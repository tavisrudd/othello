"""Bounded stdlib client for the optional Ergodis campaign protocol.

The socket transport is the reference binding.  It intentionally keeps large
evidence out of messages: callers stream run-relative files returned by the
daemon instead of materializing them in memory.
"""

from __future__ import annotations

from dataclasses import dataclass
import json
from pathlib import Path
import socket
import struct
from typing import Any, BinaryIO, Iterator, Mapping


SCHEMA = "ergodis-control-experimental-v0"
MAX_FRAME_BYTES = 64 * 1024
_LENGTH = struct.Struct("<I")


class ProtocolError(RuntimeError):
    """The peer or local manifest violated the bounded protocol."""


class RemoteError(RuntimeError):
    """Ergodis rejected an otherwise valid request."""


@dataclass(frozen=True)
class Response:
    request_id: int
    epoch: int
    result: Mapping[str, Any]


def _read_exact(stream: BinaryIO, length: int) -> bytearray:
    chunks = bytearray(length)
    view = memoryview(chunks)
    offset = 0
    while offset != length:
        count = stream.readinto(view[offset:])
        if not count:
            raise ProtocolError("truncated frame")
        offset += count
    return chunks


def _read_frame(stream: BinaryIO, limit: int = MAX_FRAME_BYTES) -> bytearray:
    length = _LENGTH.unpack(_read_exact(stream, _LENGTH.size))[0]
    if length > limit:
        raise ProtocolError(f"frame length {length} exceeds {limit}")
    return _read_exact(stream, length)


def _write_frame(stream: BinaryIO, payload: bytes) -> None:
    if len(payload) > MAX_FRAME_BYTES:
        raise ProtocolError(f"frame length {len(payload)} exceeds {MAX_FRAME_BYTES}")
    stream.write(_LENGTH.pack(len(payload)))
    stream.write(payload)
    stream.flush()


class Session:
    """One isolated campaign endpoint with monotone client request IDs."""

    def __init__(
        self,
        run_dir: Path,
        socket_path: Path,
        run_id: str,
        nonce: str,
        *,
        timeout: float = 10.0,
    ) -> None:
        self.run_dir = run_dir.resolve()
        self.socket_path = socket_path
        self.run_id = run_id
        self._nonce = nonce
        self.timeout = timeout
        self._next_request_id = 1

    @classmethod
    def from_run_dir(cls, run_dir: Path | str, *, timeout: float = 10.0) -> "Session":
        root = Path(run_dir).resolve()
        with (root / "manifest.json").open("r", encoding="utf-8") as source:
            manifest = json.load(source)
        if manifest.get("schema") != SCHEMA:
            raise ProtocolError("unsupported manifest schema")
        try:
            return cls(
                root,
                Path(manifest["socket"]),
                str(manifest["run_id"]),
                str(manifest["nonce"]),
                timeout=timeout,
            )
        except KeyError as error:
            raise ProtocolError(f"manifest omitted {error.args[0]}") from error

    def request(
        self,
        operation: str,
        arguments: Mapping[str, Any] | None = None,
        *,
        max_bytes: int = 8192,
    ) -> Response:
        if not 1 <= max_bytes <= MAX_FRAME_BYTES:
            raise ValueError(f"max_bytes must be in 1..={MAX_FRAME_BYTES}")
        request_id = self._next_request_id
        self._next_request_id += 1
        request = {
            "schema": SCHEMA,
            "request_id": request_id,
            "run_id": self.run_id,
            "nonce": self._nonce,
            "max_bytes": max_bytes,
            "op": operation,
            "args": dict(arguments or {}),
        }
        encoded = json.dumps(request, separators=(",", ":")).encode("utf-8")
        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as connection:
            connection.settimeout(self.timeout)
            connection.connect(str(self.socket_path))
            with connection.makefile("rwb", buffering=0) as stream:
                _write_frame(stream, encoded)
                response = json.loads(_read_frame(stream, max_bytes))
        if (
            response.get("schema") != SCHEMA
            or response.get("request_id") != request_id
            or response.get("run_id") != self.run_id
        ):
            raise ProtocolError("response handshake rejected")
        result = response.get("result")
        if not isinstance(result, dict):
            raise ProtocolError("response result is not an object")
        if not response.get("ok"):
            raise RemoteError(str(result.get("error", "request rejected")))
        return Response(request_id, int(response.get("epoch", 0)), result)

    def capabilities(self) -> Mapping[str, Any]:
        return self.request("capabilities").result

    def iter_evidence_lines(
        self, relative_path: Path | str, *, max_line_bytes: int = 1024 * 1024
    ) -> Iterator[bytes]:
        """Stream a daemon-returned run-relative file with bounded line memory."""
        if max_line_bytes < 1:
            raise ValueError("max_line_bytes must be positive")
        supplied = Path(relative_path)
        if supplied.is_absolute():
            raise ProtocolError("evidence path must be run-relative")
        resolved = (self.run_dir / supplied).resolve()
        if resolved != self.run_dir and self.run_dir not in resolved.parents:
            raise ProtocolError("evidence path escapes run directory")
        with resolved.open("rb") as source:
            while line := source.readline(max_line_bytes + 1):
                if len(line) > max_line_bytes:
                    raise ProtocolError("evidence line exceeds configured limit")
                yield line

    def iter_evidence_json(
        self, relative_path: Path | str, *, max_line_bytes: int = 1024 * 1024
    ) -> Iterator[Any]:
        for line in self.iter_evidence_lines(
            relative_path, max_line_bytes=max_line_bytes
        ):
            yield json.loads(line)
