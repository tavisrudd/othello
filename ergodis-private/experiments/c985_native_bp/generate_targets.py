#!/usr/bin/env python3
import argparse
import json
import pathlib
import random
import struct


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True, type=pathlib.Path)
    parser.add_argument("--out", required=True, type=pathlib.Path)
    parser.add_argument("--trials", type=int, default=128)
    parser.add_argument("--seed", type=int, default=985)
    args = parser.parse_args()

    payload = json.loads(args.input.read_text())
    bits = int(payload["coordinate_count"])
    logicals = len(payload["logical_observations"])
    if bits > 0xFFFF or logicals > 64:
        raise ValueError("EGBPORD1 supports at most 65535 bits and 64 logicals")
    rng = random.Random(args.seed)
    identity_order = b"".join(struct.pack("<H", index) for index in range(bits))
    with args.out.open("xb") as stream:
        stream.write(struct.pack("<8sHHI", b"EGBPORD1", bits, logicals, args.trials))
        for _ in range(args.trials):
            target = 0
            while target == 0:
                target = rng.getrandbits(logicals)
            stream.write(struct.pack("<Q", target))
            stream.write(identity_order)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
