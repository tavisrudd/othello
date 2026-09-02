"""Provider-neutral streaming boundary for optional hosted SDK adapters.

Vendor translations implement one attempt and one closeable async byte stream.
The daemon remains authoritative for deadlines, retries, rate limits, and
circuits through ``ProviderRunner``.
"""

from __future__ import annotations

import asyncio
import os
import stat
import tempfile
from collections.abc import AsyncIterator, Awaitable, Callable
from pathlib import Path
from typing import BinaryIO, Protocol

from ergodis_client import ProposalFailure
from ergodis_provider import ProviderFailure, ProviderInvocation

MAX_SDK_CHUNK_BYTES = 64 * 1024


class HostedResponseStream(Protocol):
    """A response stream whose network resources can be closed deterministically."""

    def __aiter__(self) -> AsyncIterator[object]: ...

    async def aclose(self) -> None: ...


type HostedSdkCall = Callable[
    [ProviderInvocation, BinaryIO], Awaitable[HostedResponseStream]
]


class StreamingSdkProvider:
    """Turn one SDK byte stream into a bounded disk-backed provider result.

    ``call`` must perform exactly one provider attempt. It must translate
    provider throttles and transient failures into ``ProviderFailure`` and must
    not retry internally. The invocation supplies the validated request path,
    schema, and absolute execution deadline.
    """

    def __init__(
        self,
        call: HostedSdkCall,
        *,
        work_dir: Path | str,
        accepted_schema_ids: frozenset[str],
        maximum_chunk_bytes: int = MAX_SDK_CHUNK_BYTES,
        close_timeout_ms: int = 1_000,
    ) -> None:
        if not accepted_schema_ids or any(
            not _is_digest(schema_id) for schema_id in accepted_schema_ids
        ):
            raise ValueError("accepted_schema_ids must contain valid schema identities")
        if (
            type(maximum_chunk_bytes) is not int
            or not 1 <= maximum_chunk_bytes <= MAX_SDK_CHUNK_BYTES
        ):
            raise ValueError("maximum_chunk_bytes is outside 1..=65536")
        if type(close_timeout_ms) is not int or not 1 <= close_timeout_ms <= 5_000:
            raise ValueError("close_timeout_ms is outside 1..=5000")
        self.call = call
        self.accepted_schema_ids = accepted_schema_ids
        self.maximum_chunk_bytes = maximum_chunk_bytes
        self.close_timeout_ms = close_timeout_ms
        self.work_dir = Path(work_dir).resolve()
        self.work_dir.mkdir(mode=0o700, parents=True, exist_ok=True)
        if self.work_dir.stat().st_mode & 0o077:
            raise ValueError("work_dir must be private")

    async def __call__(self, invocation: ProviderInvocation) -> BinaryIO:
        if invocation.request_schema.id not in self.accepted_schema_ids:
            raise ProviderFailure(
                ProposalFailure.PROTOCOL_FAULT,
                "hosted SDK adapter does not accept the request schema",
            )
        request_path = invocation.request_path.resolve(strict=True)
        output = tempfile.TemporaryFile(mode="w+b", dir=self.work_dir)
        stream: HostedResponseStream | None = None
        total = 0
        try:
            request_descriptor = os.open(request_path, os.O_RDONLY | os.O_NOFOLLOW)
            with os.fdopen(request_descriptor, "rb", buffering=0) as request:
                request_metadata = os.fstat(request.fileno())
                if (
                    not stat.S_ISREG(request_metadata.st_mode)
                    or request_metadata.st_uid != os.geteuid()
                    or not 0
                    < request_metadata.st_size
                    <= invocation.request_schema.maximum_bytes
                    or request_metadata.st_mode & 0o077
                ):
                    raise ProviderFailure(
                        ProposalFailure.PROTOCOL_FAULT,
                        "hosted SDK request is not a bounded private regular file",
                    )
                stream = await self.call(invocation, request)
                async for chunk in stream:
                    if (
                        not isinstance(chunk, bytes)
                        or len(chunk) > self.maximum_chunk_bytes
                    ):
                        raise ProviderFailure(
                            ProposalFailure.PROTOCOL_FAULT,
                            "hosted SDK emitted an invalid or oversized chunk",
                        )
                    total += len(chunk)
                    if total > invocation.maximum_return_bytes:
                        raise ProviderFailure(
                            ProposalFailure.BUDGET_LIMIT,
                            "hosted SDK response exceeds ticket return-byte bound",
                        )
                    if chunk:
                        await asyncio.to_thread(output.write, chunk)
            await asyncio.to_thread(output.flush)
            await asyncio.to_thread(os.fsync, output.fileno())
            closing = stream
            stream = None
            await self._close(closing)
            output.seek(0)
            return output
        except BaseException:
            output.close()
            if stream is not None:
                try:
                    await self._close(stream)
                except BaseException:
                    pass
            raise

    async def _close(self, stream: HostedResponseStream) -> None:
        try:
            async with asyncio.timeout(self.close_timeout_ms / 1_000):
                await stream.aclose()
        except TimeoutError as error:
            raise ProviderFailure(
                ProposalFailure.PROTOCOL_FAULT,
                "hosted SDK response did not close within its bound",
            ) from error


def _is_digest(value: str) -> bool:
    return len(value) == 64 and all(
        character in "0123456789abcdef" for character in value
    )
