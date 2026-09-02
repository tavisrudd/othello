"""Bounded async adapter for command-line theorem/LLM proposers."""

from __future__ import annotations

import asyncio
import os
import signal
import tempfile
from collections.abc import Mapping, Sequence
from pathlib import Path
from typing import BinaryIO

from ergodis_client import ProposalFailure, ProtocolError
from ergodis_provider import ProviderFailure, ProviderInvocation

_CHUNK_BYTES = 64 * 1024


class CommandProvider:
    """Run one argv-only child with file-backed bounded input/output.

    Exit 75 is transient by default. Other nonzero exits are deterministic
    backend failures. Cancellation always kills and reaps the child.
    """

    def __init__(
        self,
        argv: Sequence[str],
        *,
        work_dir: Path | str,
        environment: Mapping[str, str] | None = None,
        maximum_request_bytes: int = 1024 * 1024,
        maximum_stderr_bytes: int = 64 * 1024,
        transient_exit_codes: frozenset[int] = frozenset({75}),
    ) -> None:
        if not argv or any(not argument for argument in argv):
            raise ValueError("argv must contain nonempty strings")
        for name, value in (
            ("maximum_request_bytes", maximum_request_bytes),
            ("maximum_stderr_bytes", maximum_stderr_bytes),
        ):
            if type(value) is not int or not 1 <= value <= 1024 * 1024:
                raise ValueError(f"{name} is outside 1..=1048576")
        if any(not 1 <= code <= 255 for code in transient_exit_codes):
            raise ValueError("transient exit codes must be in 1..=255")
        self.argv = tuple(argv)
        self.maximum_request_bytes = maximum_request_bytes
        self.work_dir = Path(work_dir).resolve()
        self.work_dir.mkdir(mode=0o700, parents=True, exist_ok=True)
        if self.work_dir.stat().st_mode & 0o077:
            raise ValueError("work_dir must be private")
        self.environment = None if environment is None else dict(environment)
        self.maximum_stderr_bytes = maximum_stderr_bytes
        self.transient_exit_codes = transient_exit_codes

    async def __call__(self, invocation: ProviderInvocation) -> BinaryIO:
        request_path = invocation.request_path.resolve(strict=True)
        request_metadata = request_path.stat()
        if (
            not request_path.is_file()
            or request_metadata.st_size > self.maximum_request_bytes
            or request_metadata.st_mode & 0o077
        ):
            raise ProviderFailure(
                ProposalFailure.PROTOCOL_FAULT,
                "request artifact is not a bounded private regular file",
            )
        # Ownership transfers to the caller on success; the failure path below closes it.
        output = tempfile.TemporaryFile(mode="w+b", dir=self.work_dir)  # noqa: SIM115
        stderr = bytearray()
        try:
            with request_path.open("rb") as request:
                process = await asyncio.create_subprocess_exec(
                    *self.argv,
                    stdin=request,
                    stdout=asyncio.subprocess.PIPE,
                    stderr=asyncio.subprocess.PIPE,
                    env=self.environment,
                    start_new_session=True,
                )
                if process.stdout is None or process.stderr is None:
                    raise ProtocolError("command provider pipes were not created")
                stdout_task = asyncio.create_task(
                    _pump_file(
                        process.stdout,
                        output,
                        invocation.maximum_return_bytes,
                    )
                )
                stderr_task = asyncio.create_task(
                    _pump_bytes(process.stderr, stderr, self.maximum_stderr_bytes)
                )
                tasks = (stdout_task, stderr_task)
                try:
                    return_code, _, _ = await asyncio.gather(process.wait(), *tasks)
                except BaseException:
                    await _kill_and_reap(process)
                    for task in tasks:
                        task.cancel()
                    await asyncio.gather(*tasks, return_exceptions=True)
                    raise
            if return_code != 0:
                failure = (
                    ProposalFailure.TRANSIENT_TRANSPORT
                    if return_code in self.transient_exit_codes
                    else ProposalFailure.DETERMINISTIC_BACKEND
                )
                diagnostic = bytes(stderr).decode("utf-8", errors="replace").strip()
                raise ProviderFailure(
                    failure,
                    diagnostic or f"provider exited with status {return_code}",
                )
            output.seek(0)
            return output
        except BaseException:
            output.close()
            raise


async def _pump_file(
    source: asyncio.StreamReader, destination: BinaryIO, maximum_bytes: int
) -> None:
    total = 0
    while chunk := await source.read(_CHUNK_BYTES):
        total += len(chunk)
        if total > maximum_bytes:
            raise ProviderFailure(
                ProposalFailure.BUDGET_LIMIT,
                "provider stdout exceeds ticket return-byte bound",
            )
        await asyncio.to_thread(destination.write, chunk)
    await asyncio.to_thread(destination.flush)
    await asyncio.to_thread(os.fsync, destination.fileno())


async def _pump_bytes(
    source: asyncio.StreamReader, destination: bytearray, maximum_bytes: int
) -> None:
    while chunk := await source.read(_CHUNK_BYTES):
        if len(destination) + len(chunk) > maximum_bytes:
            raise ProviderFailure(
                ProposalFailure.PROTOCOL_FAULT,
                "provider stderr exceeds its diagnostic bound",
            )
        destination.extend(chunk)


async def _kill_and_reap(process: asyncio.subprocess.Process) -> None:
    if process.returncode is None:
        try:
            os.killpg(process.pid, signal.SIGKILL)
        except ProcessLookupError:
            pass
    await process.wait()
