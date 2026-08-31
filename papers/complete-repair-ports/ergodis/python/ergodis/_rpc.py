from __future__ import annotations

import itertools
import json
import os
import subprocess
import threading
from collections.abc import Callable, Mapping, Sequence
from pathlib import Path
from typing import Literal, ReadOnly, Self, TypeIs, TypedDict, cast


type JsonScalar = None | bool | int | float | str
type JsonValue = JsonScalar | list[JsonValue] | dict[str, JsonValue]
type RequestId = int | str


class RpcErrorBody(TypedDict):
    code: ReadOnly[int]
    message: ReadOnly[str]


class RpcSuccess[T](TypedDict):
    jsonrpc: ReadOnly[Literal["2.0"]]
    id: ReadOnly[RequestId]
    result: ReadOnly[T]


class RpcFailure(TypedDict):
    jsonrpc: ReadOnly[Literal["2.0"]]
    id: ReadOnly[RequestId | None]
    error: ReadOnly[RpcErrorBody]


class ErgodisRpcError(RuntimeError):
    def __init__(self, code: int, message: str):
        super().__init__(f"Ergodis RPC {code}: {message}")
        self.code = code
        self.message = message


def _is_mapping(value: object) -> TypeIs[dict[str, object]]:
    if not isinstance(value, dict):
        return False
    untyped = cast(dict[object, object], value)
    return all(isinstance(key, str) for key in untyped)


def _encode(value: object) -> JsonValue:
    if value is None or isinstance(value, bool | float | str):
        return value
    if isinstance(value, int):
        if -(1 << 63) <= value < 1 << 64:
            return value
        return {"$integer": str(value)}
    if isinstance(value, Mapping):
        mapping = cast(Mapping[object, object], value)
        return {str(key): _encode(item) for key, item in mapping.items()}
    if isinstance(value, Sequence) and not isinstance(value, str | bytes | bytearray):
        sequence = cast(Sequence[object], value)
        return [_encode(item) for item in sequence]
    raise TypeError(f"value of type {type(value).__name__} is not JSON-RPC encodable")


class RpcClient:
    """Synchronous, free-thread-safe client for one persistent Ergodis worker."""

    def __init__(self, binary: os.PathLike[str] | str | None = None):
        if binary is None:
            binary = os.environ.get("ERGODIS_RPC_BIN")
        if binary is None:
            binary = (
                Path(__file__).resolve().parents[2]
                / "target"
                / "release"
                / "ergodis-rpc"
            )
        self._process = subprocess.Popen(
            [os.fspath(binary)],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            text=True,
            encoding="utf-8",
            bufsize=1,
        )
        self._ids = itertools.count(1)
        self._lock = threading.Lock()

    def call[T](
        self,
        method: str,
        params: Mapping[str, object],
        /,
        *,
        decode: Callable[[object], T],
    ) -> T:
        with self._lock:
            request_id = next(self._ids)
            request = {
                "jsonrpc": "2.0",
                "id": request_id,
                "method": method,
                "params": _encode(params),
            }
            if self._process.stdin is None or self._process.stdout is None:
                raise RuntimeError("Ergodis RPC worker pipes are closed")
            self._process.stdin.write(json.dumps(request, separators=(",", ":")) + "\n")
            self._process.stdin.flush()
            line = self._process.stdout.readline()
            if not line:
                status = self._process.poll()
                raise RuntimeError(f"Ergodis RPC worker exited with status {status}")
            response: object = json.loads(line)
            if not _is_mapping(response):
                raise RuntimeError("Ergodis RPC response is not an object")
            if response.get("jsonrpc") != "2.0" or response.get("id") != request_id:
                raise RuntimeError("Ergodis RPC response envelope mismatch")
            error = response.get("error")
            if _is_mapping(error):
                code = error.get("code")
                message = error.get("message")
                if not isinstance(code, int) or not isinstance(message, str):
                    raise RuntimeError("Ergodis RPC error envelope is malformed")
                raise ErgodisRpcError(code, message)
            if "result" not in response:
                raise RuntimeError("Ergodis RPC response has neither result nor error")
            return decode(response["result"])

    def discover(self) -> Mapping[str, object]:
        return self.call("rpc.discover", {}, decode=_require_mapping)

    def close(self) -> None:
        with self._lock:
            if self._process.stdin is not None and not self._process.stdin.closed:
                self._process.stdin.close()
            try:
                self._process.wait(timeout=2)
            except subprocess.TimeoutExpired:
                self._process.terminate()
                self._process.wait(timeout=2)
            if self._process.stdout is not None and not self._process.stdout.closed:
                self._process.stdout.close()

    def __enter__(self) -> Self:
        return self

    def __exit__(self, exc_type: object, exc_value: object, traceback: object) -> None:
        self.close()


def _require_mapping(value: object) -> Mapping[str, object]:
    if not _is_mapping(value):
        raise TypeError("expected an object result")
    return value
