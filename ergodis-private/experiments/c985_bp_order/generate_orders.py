#!/usr/bin/env python3
import argparse
import hashlib
import importlib.util
import json
import pathlib
import struct

import numpy as np


def load_helper(path: pathlib.Path):
    spec = importlib.util.spec_from_file_location("c1018_helper", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True, type=pathlib.Path)
    parser.add_argument("--helper", required=True, type=pathlib.Path)
    parser.add_argument("--prefix", required=True, type=pathlib.Path)
    parser.add_argument("--trials", type=int, default=2048)
    parser.add_argument("--seed", type=int, default=1018003)
    args = parser.parse_args()

    helper = load_helper(args.helper)
    _, n, physical, logical, digest = helper.load_instance(args.input)
    stacked = np.vstack([physical, logical])
    decoder = helper.build_decoder(stacked, 0.002, 300, 10, "osd_e")
    rng = np.random.default_rng(args.seed)
    modes = ("abs-asc", "abs-desc", "llr-asc", "llr-desc", "random")
    paths = {mode: pathlib.Path(f"{args.prefix}-{mode}.bin") for mode in modes}
    streams = {mode: path.open("xb") for mode, path in paths.items()}
    header = struct.pack("<8sHHI", b"EGBPORD1", n, logical.shape[0], args.trials)
    for stream in streams.values():
        stream.write(header)

    bp_best = n + 1
    completed = 0
    try:
        while completed < args.trials:
            target = rng.integers(0, 2, size=logical.shape[0], dtype=np.uint8)
            if not target.any():
                continue
            syndrome = np.concatenate([np.zeros(physical.shape[0], dtype=np.uint8), target])
            candidate = np.asarray(decoder.decode(syndrome), dtype=np.uint8) & 1
            if not np.array_equal((stacked @ candidate) % 2, syndrome):
                raise RuntimeError("decoder returned an invalid candidate")
            bp_best = min(bp_best, int(candidate.sum()))
            llr = np.asarray(decoder.log_prob_ratios)
            orders = {
                "abs-asc": np.argsort(np.abs(llr), kind="stable"),
                "abs-desc": np.argsort(-np.abs(llr), kind="stable"),
                "llr-asc": np.argsort(llr, kind="stable"),
                "llr-desc": np.argsort(-llr, kind="stable"),
                "random": rng.permutation(n),
            }
            target_word = sum(int(bit) << index for index, bit in enumerate(target))
            target_bytes = struct.pack("<Q", target_word)
            for mode, order in orders.items():
                streams[mode].write(target_bytes)
                streams[mode].write(np.asarray(order, dtype="<u2").tobytes())
            completed += 1
    finally:
        for stream in streams.values():
            stream.close()

    report = {
        "schema": "c985-bp-order-generation-v1",
        "input_sha256": digest,
        "trials": completed,
        "seed": args.seed,
        "bp_best_weight": bp_best,
        "files": {
            mode: {
                "path": str(path),
                "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            }
            for mode, path in paths.items()
        },
    }
    report_path = pathlib.Path(f"{args.prefix}-generation.json")
    report_path.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({"trials": completed, "bp_best_weight": bp_best}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
