#!/usr/bin/env python3
"""Privately check the retained C997 physical-parity formulation A/B."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from check_c997_gurobi import read_run, total


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--binary-slack", type=Path, required=True)
    parser.add_argument("--cascaded", type=Path, required=True)
    parser.add_argument("--root-cuts", type=Path, required=True)
    args = parser.parse_args()
    runs = {
        "binary-slack": read_run(args.binary_slack),
        "cascaded": read_run(args.cascaded),
        "root-cuts": read_run(args.root_cuts),
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
    reference = runs["binary-slack"][0]
    anchors = reference["semantic_checks"]["anchor_cover"]
    for encoding, (header, solves, summary) in runs.items():
        if header["physical_parity_encoding"] != encoding:
            raise ValueError(f"{encoding}: encoding mismatch")
        if any(header[field] != reference[field] for field in identity_fields):
            raise ValueError(f"{encoding}: run identity mismatch")
        if header["mode"] != "symbreak" or summary["mode"] != "symbreak":
            raise ValueError(f"{encoding}: expected symbreak evidence")
        if not summary["all_optimal"] or summary["min_objective"] != 12.0:
            raise ValueError(f"{encoding}: exact distance was not proved")
        if sorted(solve["anchor"] for solve in solves) != anchors:
            raise ValueError(f"{encoding}: anchor coverage mismatch")
        for solve in solves:
            if solve["status_name"] != "OPTIMAL" or solve["mip_gap"] != 0.0:
                raise ValueError(f"{encoding}: incomplete solve")
            if solve["objective"] != solve["objective_bound"]:
                raise ValueError(f"{encoding}: objective/bound mismatch")
            if solve["witness"]["weight"] != 12:
                raise ValueError(f"{encoding}: witness replay mismatch")

    fields = ("nodes", "iterations", "work", "wall_seconds", "model_build_seconds")
    totals = {
        encoding: {field: total(run[1], field) for field in fields}
        for encoding, run in runs.items()
    }
    baseline = totals["binary-slack"]
    comparisons = {
        encoding: {
            f"{field}_relative_to_binary_slack": values[field] / baseline[field]
            for field in fields
        }
        for encoding, values in totals.items()
        if encoding != "binary-slack"
    }
    diagnostics = {
        encoding: {
            "root_relaxations": [solve["root_relaxation"] for solve in run[1]],
            "variables": [solve["num_vars"] for solve in run[1]],
            "constraints": [solve["num_constraints"] for solve in run[1]],
        }
        for encoding, run in runs.items()
    }
    diagnostics["root-cuts"]["cut_counts"] = [
        solve["root_parity_cuts"]["cuts"] for solve in runs["root-cuts"][1]
    ]
    diagnostics["root-cuts"]["callback_best_bounds"] = [
        solve["root_parity_cuts"]["best_bound"] for solve in runs["root-cuts"][1]
    ]
    print(
        json.dumps(
            {"totals": totals, "comparisons": comparisons, "diagnostics": diagnostics},
            indent=2,
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
