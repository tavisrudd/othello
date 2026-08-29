#!/usr/bin/env python3
"""Check retained BB Gurobi evidence and conservative native speedup bounds."""

from __future__ import annotations

import argparse
import hashlib
import json
import statistics
from pathlib import Path


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def parity(row: list[int], support: set[int]) -> int:
    return sum(coordinate in support for coordinate in row) & 1


def replay(problem: dict, record: dict) -> None:
    witness = record.get("witness")
    if witness is None:
        return
    support = set(witness["support"])
    if len(support) != witness["weight"] or witness["weight"] != record["objective"]:
        raise RuntimeError("Gurobi witness has the wrong exact weight")
    if any(parity(row, support) for row in problem["physical_checks"]):
        raise RuntimeError("Gurobi witness has nonzero physical syndrome")
    logical = [parity(row, support) for row in problem["logical_observations"]]
    if not any(logical):
        raise RuntimeError("Gurobi witness has zero logical observation")
    anchor = record["anchor"]
    if anchor is not None and anchor not in support:
        raise RuntimeError("Gurobi witness omits its symmetry anchor")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--gurobi", type=Path, required=True)
    parser.add_argument("--native", type=Path, required=True)
    args = parser.parse_args()
    problem = json.loads(args.input.read_text(encoding="utf-8"))
    records = [json.loads(line) for line in args.gurobi.read_text(encoding="utf-8").splitlines()]
    header = records[0]
    solves = [record for record in records if record["kind"] == "solve"]
    summary = records[-1]
    if header["input_sha256"] != sha256_file(args.input):
        raise RuntimeError("Gurobi evidence input digest mismatch")
    runner = Path(__file__).with_name("run_bb_gurobi.py")
    if header["runner_sha256"] != sha256_file(runner):
        raise RuntimeError("Gurobi evidence runner digest mismatch")
    if len(solves) != len(problem["anchors"]) or summary["kind"] != "summary":
        raise RuntimeError("Gurobi symmetry-orbit evidence is incomplete")
    for record in solves:
        replay(problem, record)
    if summary["all_optimal"] or any(record["status_name"] != "TIME_LIMIT" for record in solves):
        raise RuntimeError("retained comparison is not the expected bounded timeout")
    native = json.loads(args.native.read_text(encoding="utf-8"))
    if native["result"]["distance"] != problem["maximum_weight"]:
        raise RuntimeError("native evidence does not contain the exact published distance")
    native_search = statistics.median(native["search_seconds"])
    native_cold = native["preparation_seconds"] + native_search
    gurobi_seconds = summary["total_wall_seconds"]
    output = {
        "schema": "ergodis-bb-gurobi-check-v1",
        "gurobi_all_optimal": False,
        "gurobi_anchor_bounds": [record["objective_bound"] for record in solves],
        "gurobi_anchor_incumbents": [record.get("objective") for record in solves],
        "gurobi_solver_seconds": gurobi_seconds,
        "native_exact_distance": native["result"]["distance"],
        "native_cached_cold_seconds": native_cold,
        "native_warm_median_seconds": native_search,
        "cold_time_to_proof_speedup_lower_bound": gurobi_seconds / native_cold,
        "warm_time_to_proof_speedup_lower_bound": gurobi_seconds / native_search,
    }
    print(json.dumps(output, separators=(",", ":"), sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
