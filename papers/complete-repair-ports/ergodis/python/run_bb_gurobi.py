#!/usr/bin/env python3
"""Run the audited Gurobi CSS-distance model on a sparse BB input."""

from __future__ import annotations

import argparse
import hashlib
import json
import platform
import time
from importlib.metadata import version
from pathlib import Path

import gurobipy as gp
import numpy as np
from export_bb_native import SPECS, build, gf2_rank, sparse_rows
from gurobipy import GRB
from run_c997_gurobi import JsonlSink, model_global, sha256_file, solve


def translation_perm(spec, u: int, v: int) -> np.ndarray:
    block = spec.ell * spec.m
    permutation = np.empty(2 * block, dtype=np.int64)
    for row in range(spec.ell):
        for column in range(spec.m):
            source = row * spec.m + column
            target = ((row + u) % spec.ell) * spec.m + (column + v) % spec.m
            permutation[source] = target
            permutation[block + source] = block + target
    return permutation


def validate_input(problem: dict, code: str) -> tuple[np.ndarray, np.ndarray, dict]:
    spec = SPECS[code]
    hx, hz, lx = build(spec)
    if sparse_rows(hx) != problem["physical_checks"]:
        raise RuntimeError("sparse input physical checks differ from regenerated code")
    if sparse_rows(lx) != problem["logical_observations"]:
        raise RuntimeError("sparse input logical observations differ from regenerated code")
    n = int(hx.shape[1])
    rank_hx = gf2_rank(hx)
    rank_hz = gf2_rank(hz)
    if np.any((hx @ hz.T) & 1) or np.any((hz @ lx.T) & 1):
        raise RuntimeError("regenerated CSS/logical semantics failed")
    if n - rank_hx - rank_hz != lx.shape[0]:
        raise RuntimeError("regenerated quotient dimension failed")
    generator_checks = []
    for shift in ((1, 0), (0, 1)):
        permutation = translation_perm(spec, *shift)
        generator_checks.append(
            {
                "shift": shift,
                "physical_invariant": gf2_rank(np.vstack((hx, hx[:, permutation])))
                == rank_hx,
                "stabilizer_invariant": gf2_rank(np.vstack((hz, hz[:, permutation])))
                == rank_hz,
            }
        )
    if not all(
        check["physical_invariant"] and check["stabilizer_invariant"]
        for check in generator_checks
    ):
        raise RuntimeError("translation generators do not preserve the CSS quotient")
    expected_anchors = [0, spec.ell * spec.m]
    if problem["anchors"] != expected_anchors:
        raise RuntimeError("sparse input anchor cover differs from regenerated action")
    return hx, lx, {
        "rank_hx": rank_hx,
        "rank_hz": rank_hz,
        "quotient_dimension": int(lx.shape[0]),
        "generator_checks": generator_checks,
        "anchor_cover": expected_anchors,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--code", choices=sorted(SPECS), required=True)
    parser.add_argument("--mode", choices=("global", "symbreak"), required=True)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--log-dir", type=Path, required=True)
    parser.add_argument("--time-limit", type=float, default=300.0)
    parser.add_argument("--seed", type=int, default=1)
    parser.add_argument("--threads", type=int, default=1)
    parser.add_argument(
        "--physical-parity-encoding",
        choices=("binary-slack", "forbidden-set", "cascaded", "root-cuts"),
        default="cascaded",
    )
    args = parser.parse_args()
    if args.threads < 1:
        parser.error("--threads must be positive")
    problem = json.loads(args.input.read_text(encoding="utf-8"))
    hx, lx, semantic_checks = validate_input(problem, args.code)
    sink = JsonlSink(args.out)
    sink.emit(
        {
            "kind": "header",
            "schema": "ergodis-bb-gurobi-v1",
            "mode": args.mode,
            "physical_parity_encoding": args.physical_parity_encoding,
            "solver": f"Gurobi {gp.gurobi.version()}",
            "package_versions": {
                package: version(package) for package in ("gurobipy", "bposd", "numpy")
            },
            "python_version": platform.python_version(),
            "threads": args.threads,
            "seed": args.seed,
            "mip_gap": 0.0,
            "time_limit": args.time_limit,
            "input": str(args.input.resolve()),
            "input_sha256": sha256_file(args.input),
            "runner_sha256": sha256_file(Path(__file__)),
            "hx_sha256": hashlib.sha256(hx.tobytes()).hexdigest(),
            "lx_sha256": hashlib.sha256(lx.tobytes()).hexdigest(),
            "n": int(hx.shape[1]),
            "k": int(lx.shape[0]),
            "semantic_checks": semantic_checks,
        }
    )
    anchors = [None] if args.mode == "global" else problem["anchors"]
    results = []
    try:
        for anchor in anchors:
            build_start = time.perf_counter()
            model, x = model_global(hx, lx, anchor, args.physical_parity_encoding)
            build_seconds = time.perf_counter() - build_start
            label = "global" if anchor is None else f"anchor_{anchor}"
            result = solve(
                model,
                x,
                hx,
                lx,
                args.log_dir / f"{label}.log",
                args.time_limit,
                args.seed,
                args.threads,
                build_seconds,
                anchor=anchor,
            )
            sink.emit(result)
            results.append(result)
            model.dispose()
        objectives = [result["objective"] for result in results if "objective" in result]
        sink.emit(
            {
                "kind": "summary",
                "mode": args.mode,
                "solves": len(results),
                "min_objective": min(objectives) if objectives else None,
                "total_nodes": sum(result["nodes"] for result in results),
                "total_wall_seconds": sum(result["wall_seconds"] for result in results),
                "all_optimal": all(result["status"] == GRB.OPTIMAL for result in results),
            }
        )
    finally:
        sink.close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
