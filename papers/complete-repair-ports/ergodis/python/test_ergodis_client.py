#!/usr/bin/env python3

import json
from pathlib import Path
import socket
import struct
import tempfile
import threading
import unittest

from ergodis_client import MAX_FRAME_BYTES, SCHEMA, ProtocolError, Session


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
                                        "max_frame_bytes": MAX_FRAME_BYTES,
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


if __name__ == "__main__":
    unittest.main()
