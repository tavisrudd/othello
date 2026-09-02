#!/usr/bin/env python3

import asyncio
import sys
import tempfile
import unittest
from pathlib import Path

from ergodis_client import (
    ProposalFailure,
    ProposalRequestEncoding,
    ProposalRequestSchema,
)
from ergodis_command_provider import CommandProvider
from ergodis_provider import ProviderFailure, ProviderInvocation

REQUEST_SCHEMA = ProposalRequestSchema(
    "d" * 64,
    "test.request",
    1,
    ProposalRequestEncoding.BYTE_STREAM,
    1024,
    0x0F,
    (),
)


def invocation(
    request_path: Path, maximum_return_bytes: int = 64
) -> ProviderInvocation:
    return ProviderInvocation(
        "b" * 64,
        0,
        2_000,
        1_000,
        maximum_return_bytes,
        request_path,
        REQUEST_SCHEMA,
    )


class CommandProviderTest(unittest.IsolatedAsyncioTestCase):
    def make_provider(
        self, root: Path, program: str, *, request: bytes = b"request"
    ) -> tuple[CommandProvider, Path]:
        request_path = root / "request"
        request_path.write_bytes(request)
        request_path.chmod(0o600)
        provider = CommandProvider(
            (sys.executable, "-c", program),
            work_dir=root / "work",
        )
        return provider, request_path

    async def test_streams_stdin_and_stdout_through_files(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            provider, request_path = self.make_provider(
                Path(directory),
                "import sys; sys.stdout.buffer.write(sys.stdin.buffer.read().upper())",
            )
            result = await provider(invocation(request_path))
            with result:
                self.assertEqual(result.read(), b"REQUEST")

    async def test_stdout_limit_and_transient_exit_are_typed(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            provider, request_path = self.make_provider(
                root, "import sys; sys.stdout.buffer.write(b'x' * 65)"
            )
            with self.assertRaises(ProviderFailure) as oversized:
                await provider(invocation(request_path))
            self.assertEqual(oversized.exception.failure, ProposalFailure.BUDGET_LIMIT)

            provider, request_path = self.make_provider(
                root,
                "import sys; sys.stderr.write('later'); raise SystemExit(75)",
            )
            with self.assertRaises(ProviderFailure) as transient:
                await provider(invocation(request_path))
            self.assertEqual(
                transient.exception.failure, ProposalFailure.TRANSIENT_TRANSPORT
            )
            self.assertEqual(str(transient.exception), "later")

    async def test_cancellation_kills_and_reaps_process_group(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            provider, request_path = self.make_provider(
                Path(directory), "import time; time.sleep(30)"
            )
            with self.assertRaises(TimeoutError):
                async with asyncio.timeout(0.05):
                    await provider(invocation(request_path))


if __name__ == "__main__":
    unittest.main()
