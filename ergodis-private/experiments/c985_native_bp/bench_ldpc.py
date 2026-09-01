#!/usr/bin/env python3
import argparse
import importlib.util
import pathlib
import struct
import time

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
    parser.add_argument("--targets", required=True, type=pathlib.Path)
    parser.add_argument("--helper", required=True, type=pathlib.Path)
    parser.add_argument("--trials", type=int, default=128)
    parser.add_argument("--iterations", type=int, default=300)
    parser.add_argument("--osd0", action="store_true")
    parser.add_argument("--skip-verify", action="store_true")
    args = parser.parse_args()

    helper = load_helper(args.helper)
    _, n, physical, logical, _ = helper.load_instance(args.input)
    stacked = np.vstack([physical, logical])
    if args.osd0:
        decoder = helper.build_decoder(stacked, 0.002, args.iterations, 0, "osd0")
    else:
        from ldpc import BpDecoder

        decoder = BpDecoder(
            stacked,
            error_rate=0.002,
            max_iter=args.iterations,
            bp_method="minimum_sum",
            ms_scaling_factor=0.625,
            schedule="parallel",
            omp_thread_count=1,
        )

    targets = []
    with args.targets.open("rb") as stream:
        header = stream.read(16)
        assert header[:8] == b"EGBPORD1"
        for _ in range(args.trials):
            targets.append(struct.unpack("<Q", stream.read(8))[0])
            stream.read(2 * n)

    started = time.perf_counter_ns()
    valid = 0
    converged = 0
    best = n + 1
    for target in targets:
        syndrome = np.concatenate(
            [
                np.zeros(physical.shape[0], dtype=np.uint8),
                np.array(
                    [(target >> index) & 1 for index in range(logical.shape[0])],
                    dtype=np.uint8,
                ),
            ]
        )
        candidate = np.asarray(decoder.decode(syndrome), dtype=np.uint8) & 1
        converged += int(decoder.converge)
        is_valid = args.skip_verify or bool(np.array_equal((stacked @ candidate) % 2, syndrome))
        valid += int(is_valid)
        if is_valid:
            best = min(best, int(candidate.sum()))
    elapsed = time.perf_counter_ns() - started
    print(
        {
            "schema": "c985-ldpc-bp-spike-bench-v1",
            "trials": len(targets),
            "converged": converged,
            "valid": valid,
            "best_weight": best,
            "elapsed_ns": elapsed,
            "osd0": args.osd0,
        }
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
