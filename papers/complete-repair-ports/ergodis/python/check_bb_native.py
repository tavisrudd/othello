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
    args = parser.parse_args()
    problem = json.loads(args.input.read_text(encoding="utf-8"))
    records = [json.loads(line) for line in args.evidence.read_text(encoding="utf-8").splitlines()]
    if len(records) != 1:
        raise RuntimeError("expected exactly one retained evidence record")
    record = records[0]
    result = record["result"]
    witness = result["witness"]
    support = set(witness)
    if len(support) != len(witness) or len(witness) != result["distance"]:
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
    if result["distance"] != problem["maximum_weight"]:
        raise RuntimeError("retained answer does not reach the published target distance")
    candidates = [stats["candidates"] for stats in record["round_stats"]]
    if len(candidates) != len(record["search_seconds"]) or len(candidates) < 3:
        raise RuntimeError("multi-round evidence is incomplete")
    if len(set(candidates)) != 1 or any(seconds <= 0 for seconds in record["search_seconds"]):
        raise RuntimeError("round work is nondeterministic or timing is invalid")
    output = {
        "schema": "ergodis-bb-native-check-v1",
        "label": problem["label"],
        "distance": result["distance"],
        "physical_syndrome_zero": True,
        "logical_observation": logical,
        "rounds": len(candidates),
        "candidates_per_round": candidates[0],
    }
    print(json.dumps(output, separators=(",", ":"), sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
