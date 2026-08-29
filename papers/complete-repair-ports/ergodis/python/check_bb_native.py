#!/usr/bin/env python3
"""Independently replay retained native bivariate-bicycle distance evidence."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


def parity(row: list[int], support: set[int]) -> int:
    return sum(coordinate in support for coordinate in row) & 1


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--evidence", type=Path, required=True)
    parser.add_argument("--minimum-rounds", type=int, default=3)
    args = parser.parse_args()
    problem = json.loads(args.input.read_text(encoding="utf-8"))
    records = [json.loads(line) for line in args.evidence.read_text(encoding="utf-8").splitlines()]
    if len(records) != 1:
        raise RuntimeError("expected exactly one retained evidence record")
    record = records[0]
    result = record["result"]
    distance = result["distance"]
    witness = result["witness"]
    support = set(witness)
    logical: list[int] = []
    if distance is None:
        if witness:
            raise RuntimeError("bounded miss unexpectedly retains a witness")
    else:
        if len(support) != len(witness) or len(witness) != distance:
            raise RuntimeError("witness is repeated or has the wrong weight")
        if not all(0 <= coordinate < problem["coordinate_count"] for coordinate in support):
            raise RuntimeError("witness coordinate is outside the code")
        if any(parity(row, support) for row in problem["physical_checks"]):
            raise RuntimeError("witness has nonzero physical syndrome")
        logical = [parity(row, support) for row in problem["logical_observations"]]
        if not any(logical):
            raise RuntimeError("witness has zero logical observation")
    if record["coordinate_count"] != problem["coordinate_count"]:
        raise RuntimeError("evidence/input coordinate mismatch")
    if result["searched_maximum_weight"] > problem["maximum_weight"]:
        raise RuntimeError("evidence exceeds the input's authorized search radius")
    if distance is not None and distance > result["searched_maximum_weight"]:
        raise RuntimeError("witness lies outside the searched radius")
    candidates = [stats["candidates"] for stats in record["round_stats"]]
    if args.minimum_rounds <= 0:
        raise RuntimeError("minimum round count must be positive")
    if (
        len(candidates) != len(record["search_seconds"])
        or len(candidates) < args.minimum_rounds
    ):
        raise RuntimeError("multi-round evidence is incomplete")
    if any(seconds <= 0 for seconds in record["search_seconds"]):
        raise RuntimeError("round timing is invalid")
    if record["threads"] == 1 and len(set(candidates)) != 1:
        raise RuntimeError("single-threaded round work is nondeterministic")
    worker_cpus = record.get("worker_cpus", [])
    if worker_cpus and (
        len(worker_cpus) != record["threads"]
        or len(set(worker_cpus)) != len(worker_cpus)
        or any(cpu < 0 for cpu in worker_cpus)
    ):
        raise RuntimeError("worker affinity is incomplete, repeated, or invalid")
    search_kernel = record.get("search_kernel")
    if search_kernel is not None and search_kernel not in {
        "portable-compact",
        "portable-wide",
        "x86-64-avx2-bmi-popcnt",
    }:
        raise RuntimeError("evidence names an unknown native search kernel")
    output = {
        "schema": "ergodis-bb-native-check-v1",
        "label": problem["label"],
        "distance": distance,
        "searched_maximum_weight": result["searched_maximum_weight"],
        "physical_syndrome_zero": True,
        "logical_observation": logical,
        "rounds": len(candidates),
        "candidate_span": [min(candidates), max(candidates)],
    }
    print(json.dumps(output, separators=(",", ":"), sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
