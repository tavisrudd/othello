#!/usr/bin/env python3

import asyncio
import tempfile
import unittest
from pathlib import Path
from typing import BinaryIO

from ergodis_client import (
    ProposalFailure,
    ProposalRequestEncoding,
    ProposalRequestSchema,
)
from ergodis_provider import ProviderFailure, ProviderInvocation
from ergodis_sdk_provider import StreamingSdkProvider

SCHEMA = ProposalRequestSchema(
    "d" * 64,
    "test.hosted",
    1,
    ProposalRequestEncoding.UTF8,
    1024,
    0x0F,
    (),
)


def invocation(root: Path, maximum_return_bytes: int = 64) -> ProviderInvocation:
    request = root / "request"
    request.write_bytes(b"prompt")
    request.chmod(0o600)
    return ProviderInvocation(
        "b" * 64,
        0,
        2_000,
        1_000,
        maximum_return_bytes,
        request,
        SCHEMA,
    )


class FakeStream:
    def __init__(self, chunks: list[bytes], gate: asyncio.Event | None = None) -> None:
        self.chunks = iter(chunks)
        self.gate = gate
        self.closed = False

    def __aiter__(self):
        return self

    async def __anext__(self) -> bytes:
        if self.gate is not None:
            await self.gate.wait()
        try:
            return next(self.chunks)
        except StopIteration as error:
            raise StopAsyncIteration from error

    async def aclose(self) -> None:
        self.closed = True


class HangingCloseStream(FakeStream):
    async def aclose(self) -> None:
        await asyncio.Event().wait()


class StreamingSdkProviderTest(unittest.IsolatedAsyncioTestCase):
    async def test_streams_to_disk_and_closes_provider_response(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            stream = FakeStream([b"answer", "-δ".encode()])

            async def call(
                _invocation: ProviderInvocation, _request: BinaryIO
            ) -> FakeStream:
                return stream

            provider = StreamingSdkProvider(
                call,
                work_dir=root / "work",
                accepted_schema_ids=frozenset({SCHEMA.id}),
            )
            result = await provider(invocation(root))
            with result:
                self.assertEqual(result.read(), b"answer-\xce\xb4")
            self.assertTrue(stream.closed)

    async def test_schema_chunk_and_total_bounds_fail_closed(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            stream = FakeStream([b"12345"])

            async def call(
                _invocation: ProviderInvocation, _request: BinaryIO
            ) -> FakeStream:
                return stream

            provider = StreamingSdkProvider(
                call,
                work_dir=root / "work",
                accepted_schema_ids=frozenset({SCHEMA.id}),
                maximum_chunk_bytes=4,
            )
            with self.assertRaises(ProviderFailure) as oversized_chunk:
                await provider(invocation(root))
            self.assertEqual(
                oversized_chunk.exception.failure, ProposalFailure.PROTOCOL_FAULT
            )
            self.assertTrue(stream.closed)

            stream = FakeStream([b"1234", b"5"])
            provider = StreamingSdkProvider(
                call,
                work_dir=root / "work",
                accepted_schema_ids=frozenset({SCHEMA.id}),
            )
            with self.assertRaises(ProviderFailure) as oversized_total:
                await provider(invocation(root, maximum_return_bytes=4))
            self.assertEqual(
                oversized_total.exception.failure, ProposalFailure.BUDGET_LIMIT
            )
            self.assertTrue(stream.closed)

            wrong = StreamingSdkProvider(
                call,
                work_dir=root / "work",
                accepted_schema_ids=frozenset({"e" * 64}),
            )
            with self.assertRaises(ProviderFailure) as wrong_schema:
                await wrong(invocation(root))
            self.assertEqual(
                wrong_schema.exception.failure, ProposalFailure.PROTOCOL_FAULT
            )

            exposed = invocation(root)
            exposed.request_path.chmod(0o644)
            with self.assertRaises(ProviderFailure) as bad_request:
                await provider(exposed)
            self.assertEqual(
                bad_request.exception.failure, ProposalFailure.PROTOCOL_FAULT
            )

    async def test_cancellation_closes_live_provider_response(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            gate = asyncio.Event()
            stream = FakeStream([b"never"], gate)

            async def call(
                _invocation: ProviderInvocation, _request: BinaryIO
            ) -> FakeStream:
                return stream

            provider = StreamingSdkProvider(
                call,
                work_dir=root / "work",
                accepted_schema_ids=frozenset({SCHEMA.id}),
            )
            task = asyncio.create_task(provider(invocation(root)))
            await asyncio.sleep(0)
            task.cancel()
            with self.assertRaises(asyncio.CancelledError):
                await task
            self.assertTrue(stream.closed)

    async def test_uncooperative_close_is_bounded_and_typed(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            stream = HangingCloseStream([])

            async def call(
                _invocation: ProviderInvocation, _request: BinaryIO
            ) -> HangingCloseStream:
                return stream

            provider = StreamingSdkProvider(
                call,
                work_dir=root / "work",
                accepted_schema_ids=frozenset({SCHEMA.id}),
                close_timeout_ms=1,
            )
            with self.assertRaises(ProviderFailure) as failure:
                await provider(invocation(root))
            self.assertEqual(failure.exception.failure, ProposalFailure.PROTOCOL_FAULT)


if __name__ == "__main__":
    unittest.main()
