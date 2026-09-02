#!/usr/bin/env python3

import asyncio
import io
import json
from pathlib import Path
import socket
import struct
import tempfile
import threading
import unittest
from unittest.mock import patch

from ergodis_client import (
    ExternalProposalSession,
    MAX_FRAME_BYTES,
    SCHEMA,
    ProtocolError,
    ProposalRole,
    ProposalSessionOffer,
    ProposalTicket,
    ProposalTicketView,
    RemoteError,
    Response,
    Session,
)


def recv_exact(connection: socket.socket, length: int) -> bytes:
    result = bytearray(length)
    view = memoryview(result)
    offset = 0
    while offset != length:
        count = connection.recv_into(view[offset:])
        if count == 0:
            raise RuntimeError("truncated test request")
        offset += count
    return bytes(result)


class ErgodisClientTest(unittest.TestCase):
    def test_pythonic_proposer_objects_validate_and_route(self) -> None:
        session = Session(Path.cwd(), Path("unused.sock"), "run", "nonce")
        opened = {
            "session_id": "session-1",
            "source_fingerprint": "a" * 64,
            "limits": {"maximum_queries": 16},
            "usage": {"queries": 0},
        }
        submitted = {
            "ticket_key": "b" * 64,
            "ticket": {"status": {"state": "queued"}},
            "usage": {"queries": 1, "outstanding": 1},
        }
        claimed = {
            **submitted,
            "ticket": {
                "spec": {"max_return_bytes": 50},
                "status": {"state": "running"},
            },
            "claim": {"kind": "started", "attempt": 0},
            "upload_relative_path": "proposal-artifacts/incoming/session-1/upload",
        }
        with patch.object(
            session,
            "request",
            side_effect=[
                Response(1, 0, opened),
                Response(2, 0, submitted),
                Response(3, 0, claimed),
            ],
        ) as request:
            proposer = session.open_proposal_session(
                ProposalSessionOffer(
                    roles=frozenset(
                        {ProposalRole.HEURISTIC, ProposalRole.NECESSARY_REDUCTION}
                    )
                )
            )
            ticket = proposer.submit(
                request_id=1,
                payload_blake3="c" * 64,
                proposer_id=3,
                role=ProposalRole.HEURISTIC,
                cost_units=5,
                maximum_return_bytes=50,
            )
            self.assertIsInstance(ticket, ProposalTicket)
            self.assertEqual(ticket.claim().claim["kind"], "started")
            self.assertEqual(request.call_args_list[0].args[0], "proposal-session-open")
            self.assertEqual(request.call_args_list[1].args[0], "proposal-submit")
            self.assertEqual(
                request.call_args_list[1].args[1]["role"], ProposalRole.HEURISTIC.value
            )
        with self.assertRaises(ValueError):
            proposer.submit(
                request_id=2,
                payload_blake3="not-a-digest",
                proposer_id=3,
                role=ProposalRole.HEURISTIC,
                cost_units=5,
                maximum_return_bytes=50,
            )
        with self.assertRaises(TypeError):
            ticket.report_failure(0, "malformed")  # type: ignore[arg-type]

    def test_proposal_result_streams_to_claimed_file_before_completion(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            incoming = root / "proposal-artifacts" / "incoming" / "session-1"
            incoming.mkdir(parents=True)
            session = Session(root, root / "unused.sock", "run", "nonce")
            submitted = {
                "ticket_key": "b" * 64,
                "ticket": {
                    "spec": {"max_return_bytes": 12},
                    "status": {"state": "queued"},
                },
                "usage": {},
            }
            claimed = {
                **submitted,
                "ticket": {
                    "spec": {"max_return_bytes": 12},
                    "status": {"state": "running"},
                },
                "claim": {"kind": "busy", "attempt": 0},
                "upload_relative_path": (
                    "proposal-artifacts/incoming/session-1/result.upload"
                ),
            }
            completed = {
                **submitted,
                "ticket": {
                    "spec": {"max_return_bytes": 12},
                    "status": {"state": "ready"},
                },
                "artifact": {
                    "relative_path": "proposal-artifacts/results/session-1/result",
                    "blake3": "c" * 64,
                    "bytes": 12,
                },
            }
            ticket = ProposalTicket(
                ExternalProposalSession(
                    session,
                    "session-1",
                    "a" * 64,
                    {},
                    {},
                ),
                ProposalTicketView.from_result(submitted),
            )
            with patch.object(
                session,
                "request",
                side_effect=[Response(1, 0, claimed), Response(2, 0, completed)],
            ) as request:
                view = ticket.complete(0, io.BytesIO(b"bounded data"))
            self.assertEqual((incoming / "result.upload").read_bytes(), b"bounded data")
            self.assertEqual(view.artifact["bytes"], 12)
            self.assertEqual(request.call_args_list[1].args[1]["attempt"], 0)
            self.assertNotIn("result_blake3", request.call_args_list[1].args[1])

    def test_proposal_result_bound_and_path_escape_fail_closed(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            incoming = root / "proposal-artifacts" / "incoming" / "session-1"
            incoming.mkdir(parents=True)
            session = Session(root, root / "unused.sock", "run", "nonce")
            ticket = ProposalTicket(
                ExternalProposalSession(session, "session-1", "a" * 64, {}, {}),
                ProposalTicketView.from_result(
                    {
                        "ticket_key": "b" * 64,
                        "ticket": {
                            "spec": {"max_return_bytes": 4},
                            "status": {"state": "queued"},
                        },
                        "usage": {},
                    }
                ),
            )
            base = {
                "ticket_key": ticket.key,
                "ticket": {
                    "spec": {"max_return_bytes": 4},
                    "status": {"state": "running"},
                },
                "usage": {},
                "claim": {"kind": "started", "attempt": 0},
            }
            for path, source in (
                ("proposal-artifacts/incoming/session-1/large", b"12345"),
                ("../escape", b"ok"),
            ):
                with (
                    self.subTest(path=path),
                    patch.object(
                        session,
                        "request",
                        return_value=Response(
                            1, 0, base | {"upload_relative_path": path}
                        ),
                    ),
                    self.assertRaises(ProtocolError),
                ):
                    ticket.complete(0, io.BytesIO(source))

    def test_language_neutral_wire_fixture_is_exact(self) -> None:
        fixture_path = (
            Path(__file__).parents[1] / "tests/fixtures/control_protocol_v0.json"
        )
        fixture = json.loads(fixture_path.read_text())
        for name in ("request_json", "response_json"):
            wire = fixture[name]
            self.assertEqual(json.dumps(json.loads(wire), separators=(",", ":")), wire)

    def test_capability_negotiation_preserves_transport_and_trust_bounds(self) -> None:
        baseline = {
            "schema": SCHEMA,
            "framing": "u32-le-length-prefixed-json",
            "max_frame_bytes": MAX_FRAME_BYTES,
            "socket_io_timeout_ms": 10_000,
            "large_results": "run-relative-create-only-files",
            "proof_authority": False,
            "operations": ["capabilities", "status"],
        }
        session = Session(Path.cwd(), Path("unused.sock"), "run", "nonce")
        for changed in (
            {"schema": "future"},
            {"framing": "native-objects"},
            {"max_frame_bytes": MAX_FRAME_BYTES + 1},
            {"max_frame_bytes": True},
            {"proof_authority": True},
            {"socket_io_timeout_ms": True},
            {"socket_io_timeout_ms": 60_001},
            {"large_results": "inline-unbounded"},
            {"operations": ["status"]},
        ):
            capabilities = baseline | changed
            with (
                self.subTest(changed=changed),
                patch.object(
                    session, "request", return_value=Response(1, 0, capabilities)
                ),
                self.assertRaises(ProtocolError),
            ):
                session.capabilities()

    def test_manifest_ingestion_is_bounded_and_typed(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "manifest.json").write_bytes(b" " * (MAX_FRAME_BYTES + 1))
            with self.assertRaises(ProtocolError):
                Session.from_run_dir(root)
            (root / "manifest.json").write_text("[]")
            with self.assertRaises(ProtocolError):
                Session.from_run_dir(root)
            (root / "manifest.json").write_bytes(b"{not-json")
            with self.assertRaises(ProtocolError):
                Session.from_run_dir(root)

    def test_response_envelope_is_strictly_typed(self) -> None:
        baseline = {
            "schema": SCHEMA,
            "request_id": 1,
            "run_id": "run",
            "epoch": 0,
            "ok": True,
            "result": {},
        }
        malformed = (
            [],
            baseline | {"request_id": True},
            baseline | {"epoch": True},
            baseline | {"epoch": -1},
            baseline | {"epoch": 1 << 64},
            baseline | {"ok": 1},
            baseline | {"result": []},
        )
        for response in malformed:
            session = Session(Path.cwd(), Path("unused.sock"), "run", "nonce")
            with (
                self.subTest(response=response),
                patch("ergodis_client.socket.socket") as socket_factory,
                patch("ergodis_client._write_frame"),
                patch(
                    "ergodis_client._read_frame",
                    return_value=json.dumps(response).encode(),
                ),
            ):
                connection = socket_factory.return_value.__enter__.return_value
                connection.makefile.return_value.__enter__.return_value = object()
                with self.assertRaises(ProtocolError):
                    session.request("noop")

    def test_live_framing_handshake_and_monotone_ids(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            endpoint = root / "campaign.sock"
            manifest = {
                "schema": SCHEMA,
                "run_id": "run-7",
                "nonce": "secret",
                "socket": str(endpoint),
            }
            (root / "manifest.json").write_text(json.dumps(manifest))

            ready = threading.Event()

            def serve() -> None:
                with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as listener:
                    listener.bind(str(endpoint))
                    listener.listen()
                    ready.set()
                    for expected_id in (1, 2):
                        connection, _ = listener.accept()
                        with connection:
                            length = struct.unpack("<I", recv_exact(connection, 4))[0]
                            request = json.loads(recv_exact(connection, length))
                            self.assertEqual(request["request_id"], expected_id)
                            response = json.dumps(
                                {
                                    "schema": SCHEMA,
                                    "request_id": expected_id,
                                    "run_id": "run-7",
                                    "epoch": 3,
                                    "ok": True,
                                    "result": {
                                        "schema": SCHEMA,
                                        "framing": "u32-le-length-prefixed-json",
                                        "max_frame_bytes": MAX_FRAME_BYTES,
                                        "socket_io_timeout_ms": 10_000,
                                        "large_results": "run-relative-create-only-files",
                                        "proof_authority": False,
                                        "operations": ["capabilities", "status"],
                                    },
                                },
                                separators=(",", ":"),
                            ).encode()
                            connection.sendall(
                                struct.pack("<I", len(response)) + response
                            )

            server = threading.Thread(target=serve)
            server.start()
            ready.wait()
            session = Session.from_run_dir(root)
            self.assertEqual(session.capabilities()["max_frame_bytes"], MAX_FRAME_BYTES)
            self.assertEqual(session.request("noop").request_id, 2)
            server.join()

    def test_evidence_is_streamed_and_confined(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "evidence").mkdir()
            (root / "evidence" / "rows.jsonl").write_bytes(b'{"x":1}\n{"x":2}\n')
            session = Session(root, root / "unused.sock", "run", "nonce")
            self.assertEqual(
                list(session.iter_evidence_json("evidence/rows.jsonl")),
                [{"x": 1}, {"x": 2}],
            )
            with self.assertRaises(ProtocolError):
                list(session.iter_evidence_lines("../outside"))
            (root / "evidence" / "long.jsonl").write_bytes(b"123456789\n")
            with self.assertRaises(ProtocolError):
                list(
                    session.iter_evidence_lines("evidence/long.jsonl", max_line_bytes=8)
                )
            (root / "evidence" / "invalid.jsonl").write_bytes(b'{"x":1}\n{bad\n')
            stream = session.iter_evidence_json("evidence/invalid.jsonl")
            self.assertEqual(next(stream), {"x": 1})
            with self.assertRaisesRegex(ProtocolError, "line 2"):
                next(stream)

    def test_oversized_declared_response_is_rejected_before_payload_read(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            endpoint = root / "campaign.sock"
            ready = threading.Event()

            def serve() -> None:
                with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as listener:
                    listener.bind(str(endpoint))
                    listener.listen()
                    ready.set()
                    connection, _ = listener.accept()
                    with connection:
                        length = struct.unpack("<I", recv_exact(connection, 4))[0]
                        recv_exact(connection, length)
                        connection.sendall(struct.pack("<I", MAX_FRAME_BYTES + 1))

            server = threading.Thread(target=serve)
            server.start()
            ready.wait()
            session = Session(root, endpoint, "run", "nonce")
            with self.assertRaises(ProtocolError):
                session.request("noop")
            server.join()

    def test_nonfinite_json_is_rejected_in_both_directions(self) -> None:
        session = Session(Path.cwd(), Path("unused.sock"), "run", "nonce")
        with self.assertRaises(ProtocolError):
            session.request("noop", {"score": float("nan")})
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "invalid.jsonl").write_bytes(b'{"score":NaN}\n')
            session = Session(root, root / "unused.sock", "run", "nonce")
            with self.assertRaises(ProtocolError):
                next(session.iter_evidence_json("invalid.jsonl"))

    def test_boolean_size_limits_are_not_accepted_as_integers(self) -> None:
        session = Session(Path.cwd(), Path("unused.sock"), "run", "nonce")
        with self.assertRaises(ValueError):
            session.request("noop", max_bytes=True)
        with self.assertRaises(ValueError):
            next(session.iter_evidence_lines("unused", max_line_bytes=True))

    def test_remote_errors_and_cross_run_responses_fail_closed(self) -> None:
        for crossed, exception in ((False, RemoteError), (True, ProtocolError)):
            with (
                self.subTest(crossed=crossed),
                tempfile.TemporaryDirectory() as directory,
            ):
                root = Path(directory)
                endpoint = root / "campaign.sock"
                ready = threading.Event()

                def serve() -> None:
                    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as listener:
                        listener.bind(str(endpoint))
                        listener.listen()
                        ready.set()
                        connection, _ = listener.accept()
                        with connection:
                            length = struct.unpack("<I", recv_exact(connection, 4))[0]
                            request = json.loads(recv_exact(connection, length))
                            response = json.dumps(
                                {
                                    "schema": SCHEMA,
                                    "request_id": request["request_id"],
                                    "run_id": "other-run" if crossed else "run",
                                    "epoch": 0,
                                    "ok": False,
                                    "result": {"error": "bounded rejection"},
                                },
                                separators=(",", ":"),
                            ).encode()
                            connection.sendall(
                                struct.pack("<I", len(response)) + response
                            )

                server = threading.Thread(target=serve)
                server.start()
                ready.wait()
                session = Session(root, endpoint, "run", "nonce")
                with self.assertRaises(exception):
                    session.request("noop")
                server.join()


class ErgodisAsyncClientTest(unittest.IsolatedAsyncioTestCase):
    async def test_native_async_transport_preserves_handshake(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            endpoint = Path(directory) / "campaign.sock"

            async def handle(
                reader: asyncio.StreamReader, writer: asyncio.StreamWriter
            ) -> None:
                length = struct.unpack("<I", await reader.readexactly(4))[0]
                request = json.loads(await reader.readexactly(length))
                response = json.dumps(
                    {
                        "schema": SCHEMA,
                        "request_id": request["request_id"],
                        "run_id": "run",
                        "epoch": 7,
                        "ok": True,
                        "result": {"async": True},
                    },
                    separators=(",", ":"),
                ).encode()
                writer.write(struct.pack("<I", len(response)) + response)
                await writer.drain()
                writer.close()

            server = await asyncio.start_unix_server(handle, str(endpoint))
            try:
                session = Session(Path(directory), endpoint, "run", "nonce")
                response = await session.request_async("noop")
                self.assertEqual(response.epoch, 7)
                self.assertIs(response.result["async"], True)
            finally:
                server.close()
                await server.wait_closed()


if __name__ == "__main__":
    unittest.main()
