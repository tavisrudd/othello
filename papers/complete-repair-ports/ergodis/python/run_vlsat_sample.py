#!/usr/bin/env python3
"""Run the structured Ergodis certificate and CPU SAT baselines on one VLSAT-2 case."""

from __future__ import annotations

import argparse
import hashlib
import json
import platform
import statistics
import subprocess
import time
from pathlib import Path


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        while block := source.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def bounded(command: list[str], timeout: float) -> dict[str, object]:
    start = time.perf_counter()
    try:
        completed = subprocess.run(
            command,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=timeout,
        )
        elapsed = time.perf_counter() - start
        return {
            "status": "completed",
            "exit_code": completed.returncode,
            "elapsed_s": elapsed,
            "stdout_tail": completed.stdout[-256:],
        }
    except subprocess.TimeoutExpired:
        return {"status": "timeout", "elapsed_s": time.perf_counter() - start}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--cnf", type=Path, required=True)
    parser.add_argument("--ergodis", type=Path, required=True)
    parser.add_argument("--kissat", type=Path, required=True)
    parser.add_argument("--z3", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--rounds", type=int, default=15)
    parser.add_argument("--timeout", type=float, default=120.0)
    parser.add_argument("--kissat-revision", required=True)
    parser.add_argument("--z3-version", required=True)
    args = parser.parse_args()
    if args.rounds < 3 or args.timeout <= 0:
        raise SystemExit("invalid measurement parameters")

    ergodis_rounds = []
    expected = None
    for _ in range(args.rounds):
        completed = subprocess.run(
            [str(args.ergodis), str(args.cnf)],
            check=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=10,
        )
        record = json.loads(completed.stdout)
        semantic = {key: value for key, value in record.items() if key != "elapsed_ns"}
        if expected is None:
            expected = semantic
        elif semantic != expected:
            raise ValueError("Ergodis certificate changed between rounds")
        ergodis_rounds.append(record)

    kissat = bounded([str(args.kissat), "--quiet", str(args.cnf)], args.timeout)
    z3 = bounded([str(args.z3), "-dimacs", str(args.cnf)], args.timeout)
    median_ns = statistics.median(record["elapsed_ns"] for record in ergodis_rounds)
    timeout_ns = args.timeout * 1_000_000_000
    document = {
        "schema": "ergodis-vlsat2-structured-sample-v1",
        "instance": "vlsat2_544_8738.cnf",
        "official_url": "https://cadp.inria.fr/ftp/benchmarks/vlsat/vlsat2_544_8738.cnf.bz2",
        "expected_result": "unsat",
        "method": {
            "rounds": args.rounds,
            "timeout_s": args.timeout,
            "ergodis_timed_region": "two streaming DIMACS passes plus theorem recognition and certificate construction",
            "baseline_timed_region": "end-to-end solver subprocess including process launch",
        },
        "host": {"platform": platform.platform(), "processor": platform.processor()},
        "artifacts": {
            "cnf_sha256": sha256(args.cnf),
            "ergodis_sha256": sha256(args.ergodis),
            "kissat_sha256": sha256(args.kissat),
            "z3_sha256": sha256(args.z3),
            "kissat_revision": args.kissat_revision,
            "z3_version": args.z3_version,
        },
        "ergodis_rounds": ergodis_rounds,
        "ergodis_median_ns": median_ns,
        "kissat": kissat,
        "z3": z3,
        "kissat_speedup_lower_bound": timeout_ns / median_ns if kissat["status"] == "timeout" else None,
        "z3_speedup_lower_bound": timeout_ns / median_ns if z3["status"] == "timeout" else None,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(document, indent=2) + "\n")


if __name__ == "__main__":
    main()
