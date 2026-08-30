#!/usr/bin/env python3

import json
from pathlib import Path
import socket
import struct
import tempfile
import threading
import unittest
from unittest.mock import patch

from ergodis_client import (
    MAX_FRAME_BYTES,
    SCHEMA,
    ProtocolError,
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
    def test_language_neutral_wire_fixture_is_exact(self) -> None:
        fixture_path = Path(__file__).parents[1] / "tests/fixtures/control_protocol_v0.json"
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
            with self.subTest(changed=changed), patch.object(
                session, "request", return_value=Response(1, 0, capabilities)
            ), self.assertRaises(ProtocolError):
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
            with self.subTest(response=response), patch(
                "ergodis_client.socket.socket"
            ) as socket_factory, patch("ergodis_client._write_frame"), patch(
                "ergodis_client._read_frame",
                return_value=json.dumps(response).encode(),
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
                            connection.sendall(struct.pack("<I", len(response)) + response)

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
                    session.iter_evidence_lines(
                        "evidence/long.jsonl", max_line_bytes=8
                    )
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
            with self.subTest(crossed=crossed), tempfile.TemporaryDirectory() as directory:
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
                            connection.sendall(struct.pack("<I", len(response)) + response)

                server = threading.Thread(target=serve)
                server.start()
                ready.wait()
                session = Session(root, endpoint, "run", "nonce")
                with self.assertRaises(exception):
                    session.request("noop")
                server.join()


if __name__ == "__main__":
    unittest.main()
