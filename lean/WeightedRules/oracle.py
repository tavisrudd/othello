"""Return a min-plus certificate through the existing Ergodis module C ABI.

This adapter supplies untrusted witness data to WeightedRules.Oracle. It never
generates Lean source or asserts a theorem. ERGODIS_RULE_LIBRARY names the native
shared library. Input and output are bounded by the provider's 1 MiB limit.
"""
import ctypes as c
import os
from pathlib import Path
import struct
import sys

LIMIT = 1048576
CREATE = c.CFUNCTYPE(c.c_void_p, c.c_uint32)
INVOKE = c.CFUNCTYPE(c.c_uint32, c.c_void_p, c.c_uint32, c.c_uint64,
                    c.c_void_p, c.c_uint32, c.c_void_p, c.c_uint32, c.POINTER(c.c_uint32))
DESTROY = c.CFUNCTYPE(None, c.c_void_p)


class Api(c.Structure):
    _fields_ = [("abi", c.c_uint32), ("size", c.c_uint32),
                ("create", CREATE), ("invoke", INVOKE), ("destroy", DESTROY)]


def certificate(source: Path, library_path: str) -> bytes:
    with source.open("rb") as stream:
        payload = stream.read(LIMIT + 1)
    if len(payload) > LIMIT:
        raise ValueError("source exceeds byte limit")
    library = c.CDLL(library_path)
    library.ergodis_module_v1.restype = c.POINTER(Api)
    pointer = library.ergodis_module_v1()
    if not pointer:
        raise ValueError("missing module API")
    api = pointer.contents
    if api.abi != 1 or api.size != c.sizeof(Api):
        raise ValueError("unsupported module ABI")
    context = api.create(1)
    if not context:
        raise ValueError("module creation failed")

    def call(operation, handle=0, data=b"", capacity=LIMIT):
        incoming = c.create_string_buffer(data)
        outgoing = c.create_string_buffer(capacity)
        written = c.c_uint32(0)
        status = api.invoke(context, operation, handle, incoming, len(data),
                            outgoing, capacity, c.byref(written))
        if status != 0 or written.value > capacity:
            raise ValueError(f"module operation {operation} failed: {status}")
        return outgoing.raw[:written.value]

    try:
        plan = struct.unpack("<Q", call(1, data=payload, capacity=8))[0]
        workspace = struct.unpack("<Q", call(2, plan, capacity=8))[0]
        encoded = call(3, workspace, struct.pack("<I", 1))
        call(3, workspace, struct.pack("<I", 2) + encoded)
        call(4, workspace)
        call(4, plan)
        return encoded
    finally:
        api.destroy(context)


def main():
    if len(sys.argv) != 2:
        raise ValueError("expected one source JSON filename")
    library = os.environ.get("ERGODIS_RULE_LIBRARY")
    if not library:
        raise ValueError("set ERGODIS_RULE_LIBRARY to the compiled native provider")
    sys.stdout.buffer.write(certificate(Path(sys.argv[1]), library) + b"\n")


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, struct.error) as error:
        print(str(error), file=sys.stderr)
        sys.exit(1)
