#!/usr/bin/env python3
"""Run and record every prime in the deterministic C958 identity proof."""

import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time

if sys.flags.optimize:
    raise RuntimeError("verification must run with Python assertions enabled")


GRID_CHECKER = Path(__file__).with_name(
    "2026-08-25-c958-generic-identity-grid-check.py"
)
ROOT = Path(__file__).resolve().parents[1]


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run_prime(prime, base, stop, forward, inverse):
    started = time.monotonic()
    command = [
        sys.executable, str(GRID_CHECKER),
        "--prime", str(prime), "--base", str(base), "--stop", str(stop),
        "--milestone", "0", str(forward), str(inverse),
    ]
    result = subprocess.run(command, check=False, capture_output=True, text=True)
    elapsed = time.monotonic() - started
    if result.returncode:
        raise RuntimeError(
            f"prime {prime} failed with exit {result.returncode}: {result.stderr[-1000:]}"
        )
    expected = f"prime={prime} zero_grid=[0,{stop}) kronecker_base={base}"
    if result.stdout.strip() != expected:
        raise RuntimeError(f"prime {prime} returned unexpected output: {result.stdout[-1000:]}")
    return {"prime": prime, "elapsed_seconds": round(elapsed, 3), "result": expected}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("forward", type=Path)
    parser.add_argument("inverse", type=Path)
    parser.add_argument("bound", type=Path)
    parser.add_argument("--write", type=Path, required=True)
    parser.add_argument("--workers", type=int, default=4)
    arguments = parser.parse_args()
    bound = json.loads(arguments.bound.read_text())
    assert bound["schema"] == "c958-generic-identity-bound-v1"
    assert bound["input_sha256"][str(arguments.forward)] == sha256(arguments.forward)
    assert bound["input_sha256"][str(arguments.inverse)] == sha256(arguments.inverse)
    base = int(bound["kronecker_base"])
    degrees = bound["residual_parameter_degree_bounds"]
    assert all(degree[1] < base for degree in degrees)
    stop = max(degree[0] * base + degree[1] for degree in degrees) + 1
    assert stop == 6230
    primes = [int(prime) for prime in bound["primes"]]
    started = time.monotonic()
    results = []
    with ThreadPoolExecutor(max_workers=arguments.workers) as executor:
        futures = {
            executor.submit(
                run_prime, prime, base, stop, arguments.forward, arguments.inverse,
            ): prime
            for prime in primes
        }
        for future in as_completed(futures):
            result = future.result()
            results.append(result)
            print(
                f"completed_prime={result['prime']} "
                f"elapsed_seconds={result['elapsed_seconds']}",
                flush=True,
            )
    results.sort(key=lambda item: item["prime"])
    payload = {
        "schema": "c958-generic-identity-replay-v1",
        "input_sha256": {
            str(arguments.forward): sha256(arguments.forward),
            str(arguments.inverse): sha256(arguments.inverse),
            str(arguments.bound): sha256(arguments.bound),
            str(GRID_CHECKER.resolve().relative_to(ROOT)): sha256(GRID_CHECKER),
        },
        "workers": arguments.workers,
        "kronecker_base": base,
        "evaluation_range": [0, stop],
        "prime_results": results,
        "wall_seconds": round(time.monotonic() - started, 3),
        "conclusion": (
            "All four denominator-cleared residuals vanish over Z by the "
            "degree, injective-Kronecker, and coefficient-height argument in "
            "the bound certificate."
        ),
    }
    arguments.write.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(
        f"certified_primes={len(results)} grid_size={stop} "
        f"wall_seconds={payload['wall_seconds']}",
        flush=True,
    )


if __name__ == "__main__":
    main()
