#!/usr/bin/env python3
"""Check and summarize streamed C997/Gurobi evidence without Gurobi."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


def read_run(path: Path) -> tuple[dict, list[dict], dict]:
    header = None
    solves = []
    summary = None
    with path.open(encoding="utf-8") as stream:
        for line_number, line in enumerate(stream, 1):
            record = json.loads(line)
            kind = record.get("kind")
            if kind == "header" and header is None:
                header = record
            elif kind == "solve":
                solves.append(record)
            elif kind == "summary" and summary is None:
                summary = record
            else:
                raise ValueError(
                    f"{path}:{line_number}: invalid or repeated {kind!r} record"
                )
    if header is None or summary is None:
        raise ValueError(f"{path}: incomplete evidence stream")
    return header, solves, summary


def total(solves: list[dict], field: str) -> float:
    return sum(float(solve[field]) for solve in solves)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--per-logical", type=Path, required=True)
    parser.add_argument("--global-model", type=Path, required=True)
    parser.add_argument("--symbreak", type=Path, required=True)
    args = parser.parse_args()

    runs = {
        "per-logical": read_run(args.per_logical),
        "global": read_run(args.global_model),
        "symbreak": read_run(args.symbreak),
    }
    identity_fields = (
        "schema",
        "solver",
        "seed",
        "threads",
        "package_versions",
        "python_version",
        "c997_source_sha256",
        "runner_sha256",
        "hx_sha256",
        "lx_sha256",
        "semantic_checks",
    )
    reference = runs["per-logical"][0]
    for mode, (header, solves, summary) in runs.items():
        if header["mode"] != mode or summary["mode"] != mode:
            raise ValueError(f"{mode}: mode mismatch")
        if any(header[field] != reference[field] for field in identity_fields):
            raise ValueError(f"{mode}: run identity mismatch")
        if not summary["all_optimal"] or len(solves) != summary["solves"]:
            raise ValueError(f"{mode}: incomplete optimal solve set")
        if summary["min_objective"] != 12.0:
            raise ValueError(f"{mode}: expected exact Gross distance 12")
        for solve in solves:
            if solve["status_name"] != "OPTIMAL":
                raise ValueError(f"{mode}: nonoptimal solve")
            if (
                solve["objective"] != solve["objective_bound"]
                or solve["mip_gap"] != 0.0
            ):
                raise ValueError(f"{mode}: objective was not proved")
            if solve["witness"]["weight"] != solve["objective"]:
                raise ValueError(f"{mode}: witness/objective mismatch")

    per_solves = runs["per-logical"][1]
    global_solves = runs["global"][1]
    sym_solves = runs["symbreak"][1]
    if sorted(solve["logical"] for solve in per_solves) != list(range(12)):
        raise ValueError("per-logical: incomplete logical basis")
    if len(global_solves) != 1 or global_solves[0]["logical"] is not None:
        raise ValueError("global: expected exactly one class-independent solve")
    anchors = reference["semantic_checks"]["anchor_cover"]
    if sorted(solve["anchor"] for solve in sym_solves) != anchors:
        raise ValueError("symbreak: solved anchors differ from certified orbit cover")

    fields = ("nodes", "iterations", "work", "wall_seconds")
    totals = {
        mode: {field: total(run[1], field) for field in fields}
        for mode, run in runs.items()
    }
    ratios = {
        "per_logical_over_symbreak": {
            field: totals["per-logical"][field] / totals["symbreak"][field]
            for field in fields
        },
        "global_over_symbreak": {
            field: totals["global"][field] / totals["symbreak"][field]
            for field in fields
        },
        "per_logical_over_global": {
            field: totals["per-logical"][field] / totals["global"][field]
            for field in fields
        },
    }
    print(json.dumps({"totals": totals, "ratios": ratios}, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
