"""Pure-Python client for the Ergodis campaign control socket.

The Rust side is `ergodis::control` in the public core.  The wire format is a
Unix stream socket carrying length-prefixed JSON: a four-byte little-endian
length followed by that many bytes of JSON, one request and one response per
connection.  Reimplementing it here rather than shelling out to `campaign_rpc`
keeps a notebook session free of any cargo build step and makes every op
available as a Python call.

Nothing here writes to a run directory; the campaign owns those files.
"""

from __future__ import annotations

import json
import os
import socket
import struct
from dataclasses import dataclass
from pathlib import Path
from typing import Any

SCHEMA = "ergodis-control-experimental-v0"
DATA_SCHEMA = "ergodis-campaign-data-v0"
PLAN_SCHEMA = "ergodis-attack-plan-v0"

MAX_FRAME_BYTES = 64 * 1024
SOCKET_IO_TIMEOUT = 10.0
DEFAULT_RESPONSE_LIMIT = 16 * 1024

_LENGTH = struct.Struct("<I")


class ControlError(RuntimeError):
    """A protocol, transport, or campaign-side rejection."""


@dataclass(frozen=True)
class Manifest:
    """The provenance header a campaign writes before serving.

    Every field is needed to talk to the run: `socket` and `run_id`/`nonce`
    authenticate the connection, and the rest identify what is being searched.
    """

    schema: str
    run_id: str
    nonce: str
    socket: Path
    run_dir: Path
    pid: int
    code_commit: str
    presentation_hash: str
    problem: str
    feature_generator: dict[str, Any] | None = None

    @classmethod
    def from_json(cls, document: dict[str, Any]) -> "Manifest":
        return cls(
            schema=document["schema"],
            run_id=document["run_id"],
            nonce=document["nonce"],
            socket=Path(document["socket"]),
            run_dir=Path(document["run_dir"]),
            pid=int(document["pid"]),
            code_commit=document.get("code_commit", "unknown"),
            presentation_hash=document["presentation_hash"],
            problem=document["problem"],
            feature_generator=document.get("feature_generator"),
        )

    @classmethod
    def read(cls, run_dir: os.PathLike[str] | str) -> "Manifest":
        path = Path(run_dir) / "manifest.json"
        with path.open("rb") as handle:
            return cls.from_json(json.loads(handle.read(MAX_FRAME_BYTES + 1)))

    def alive(self) -> bool:
        """Whether the campaign process is still running.

        A stale run directory outlives its process, so a monitor must be able to
        tell "the run finished" from "the socket is briefly busy".
        """
        try:
            os.kill(self.pid, 0)
        except ProcessLookupError:
            return False
        except PermissionError:
            return True
        return True


_next_sequence = 0


def _request_id() -> int:
    """Mirror the Rust id scheme: process id in the high word, sequence low."""
    global _next_sequence
    _next_sequence = (_next_sequence + 1) & 0xFFFFFFFF
    if _next_sequence == 0:
        _next_sequence = 1
    return (os.getpid() << 32) | _next_sequence


def _write_frame(stream: socket.socket, payload: bytes) -> None:
    if len(payload) > MAX_FRAME_BYTES:
        raise ControlError("frame exceeds limit")
    stream.sendall(_LENGTH.pack(len(payload)) + payload)


def _read_exactly(stream: socket.socket, count: int) -> bytes:
    chunks: list[bytes] = []
    remaining = count
    while remaining:
        chunk = stream.recv(remaining)
        if not chunk:
            raise ControlError("campaign closed the connection early")
        chunks.append(chunk)
        remaining -= len(chunk)
    return b"".join(chunks)


def _read_frame(stream: socket.socket) -> bytes:
    (length,) = _LENGTH.unpack(_read_exactly(stream, _LENGTH.size))
    if length > MAX_FRAME_BYTES:
        raise ControlError("frame exceeds limit")
    return _read_exactly(stream, length)


def send_full(
    manifest: Manifest,
    op: str,
    args: dict[str, Any] | None = None,
    max_bytes: int = DEFAULT_RESPONSE_LIMIT,
    timeout: float = SOCKET_IO_TIMEOUT,
) -> dict[str, Any]:
    """Send one control request and return the whole response envelope.

    The envelope carries `epoch` alongside `result`, and the epoch is what the
    ops that change active plans want as their compare-and-swap guard.
    """
    request = {
        "schema": SCHEMA,
        "request_id": _request_id(),
        "run_id": manifest.run_id,
        "nonce": manifest.nonce,
        "max_bytes": min(max_bytes, MAX_FRAME_BYTES),
        "op": op,
        "args": {} if args is None else args,
    }
    encoded = json.dumps(request).encode()

    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as stream:
        stream.settimeout(timeout)
        try:
            stream.connect(str(manifest.socket))
        except OSError as error:
            raise ControlError(f"cannot connect to {manifest.socket}: {error}") from error
        _write_frame(stream, encoded)
        response = json.loads(_read_frame(stream))

    if (
        response.get("schema") != SCHEMA
        or response.get("request_id") != request["request_id"]
        or response.get("run_id") != manifest.run_id
    ):
        raise ControlError("response handshake rejected")
    if not response.get("ok", False):
        result = response.get("result") or {}
        raise ControlError(result.get("error", "campaign rejected request"))
    return response


def send_request(
    manifest: Manifest,
    op: str,
    args: dict[str, Any] | None = None,
    max_bytes: int = DEFAULT_RESPONSE_LIMIT,
    timeout: float = SOCKET_IO_TIMEOUT,
) -> dict[str, Any]:
    """Send one control request and return its `result`.

    Raises `ControlError` when the transport fails, when the handshake does not
    match, or when the campaign answers `ok: false`.
    """
    return send_full(manifest, op, args, max_bytes, timeout)["result"]
