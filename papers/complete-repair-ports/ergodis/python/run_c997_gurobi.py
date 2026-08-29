#!/usr/bin/env python3
"""Replay the C997 Gross-code formulations with Gurobi.

The committed C997 experiment is read-only input.  Solver logs and evidence are
streamed to files so an interrupted or long run does not accumulate a transcript
in memory.  Every incumbent reported as a solution is replayed over GF(2).
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import platform
import time
from importlib.metadata import version
from pathlib import Path

import gurobipy as gp
import numpy as np
from gurobipy import GRB


def load_c997(path: Path):
    spec = importlib.util.spec_from_file_location("c997_gross_source", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load C997 source: {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def derive_anchor_cover(c997, n: int) -> list[int]:
    """Compute coordinate orbits from the source action; do not trust constants."""
    unseen = np.ones(n, dtype=bool)
    anchors = []
    for coordinate in range(n):
        if not unseen[coordinate]:
            continue
        anchors.append(coordinate)
        for u in range(c997.ELL):
            for v in range(c997.M):
                unseen[int(c997.translation_perm(u, v)[coordinate])] = False
    if np.any(unseen):
        raise RuntimeError("orbit traversal left coordinates uncovered")
    return anchors


def validate_semantics(c997, hx: np.ndarray, hz: np.ndarray, lx: np.ndarray) -> dict:
    """Replay the algebra required by the global model and anchor reduction."""
    n = int(hx.shape[1])
    rank_hx = int(c997.gf2_rank(hx))
    rank_hz = int(c997.gf2_rank(hz))
    rank_hx_lx = int(c997.gf2_rank(np.vstack((hx, lx))))
    k = int(lx.shape[0])
    checks = {
        "css_commutes": not bool(np.any((hx @ hz.T) & 1)),
        "logical_detectors_annihilate_stabilizers": not bool(np.any((hz @ lx.T) & 1)),
        "rank_hx": rank_hx,
        "rank_hz": rank_hz,
        "rank_hx_lx": rank_hx_lx,
        "quotient_dimension": n - rank_hx - rank_hz,
    }
    group = c997.check_group_action(hx, hz)
    anchors = derive_anchor_cover(c997, n)
    if not checks["css_commutes"]:
        raise RuntimeError("C997 source matrices do not define a commuting CSS code")
    if not checks["logical_detectors_annihilate_stabilizers"]:
        raise RuntimeError("logical detectors do not vanish on stabilizers")
    if n - rank_hx - rank_hz != k or rank_hx_lx != rank_hx + k:
        raise RuntimeError("logical parity map does not exactly detect the quotient")
    if not group["rowspace_hx_invariant"] or not group["action_free_on_qubits"]:
        raise RuntimeError(
            "translation action failed exact C997 invariance/freeness replay"
        )
    if len(anchors) != group["orbits_on_qubits"]:
        raise RuntimeError("derived orbit cover disagrees with the group replay")
    checks["group"] = group
    checks["anchor_cover"] = anchors
    return checks


class JsonlSink:
    def __init__(self, path: Path):
        path.parent.mkdir(parents=True, exist_ok=True)
        # A second run must not silently create an ambiguous multi-header stream.
        self._stream = path.open("x", encoding="utf-8", buffering=1)

    def emit(self, record: dict) -> None:
        json.dump(record, self._stream, sort_keys=True, separators=(",", ":"))
        self._stream.write("\n")
        self._stream.flush()
        os.fsync(self._stream.fileno())

    def close(self) -> None:
        self._stream.close()


def add_mod2(model: gp.Model, terms, bits: int, rhs) -> None:
    slack = model.addVars(bits, vtype=GRB.BINARY)
    model.addConstr(
        gp.quicksum(terms) - gp.quicksum((1 << (j + 1)) * slack[j] for j in range(bits))
        == rhs
    )


def base_model(hx: np.ndarray, name: str) -> tuple[gp.Model, gp.tupledict]:
    model = gp.Model(name)
    n = hx.shape[1]
    x = model.addVars(n, vtype=GRB.BINARY, name="x")
    model.setObjective(x.sum(), GRB.MINIMIZE)
    bits = int(np.ceil(np.log2(int(np.max(hx.sum(axis=1))))))
    for row in range(hx.shape[0]):
        support = np.flatnonzero(hx[row])
        add_mod2(model, (x[int(q)] for q in support), bits, 0)
    return model, x


def model_per_logical(hx: np.ndarray, logical: np.ndarray, index: int):
    model, x = base_model(hx, f"gross_per_logical_{index}")
    support = np.flatnonzero(logical)
    bits = int(np.ceil(np.log2(int(support.size))))
    add_mod2(model, (x[int(q)] for q in support), bits, 1)
    return model, x


def model_global(hx: np.ndarray, lx: np.ndarray, anchor: int | None):
    suffix = "global" if anchor is None else f"anchor_{anchor}"
    model, x = base_model(hx, f"gross_{suffix}")
    parity = model.addVars(lx.shape[0], vtype=GRB.BINARY, name="parity")
    for i in range(lx.shape[0]):
        support = np.flatnonzero(lx[i])
        bits = int(np.ceil(np.log2(int(support.size))))
        add_mod2(model, (x[int(q)] for q in support), bits, parity[i])
    model.addConstr(parity.sum() >= 1)
    if anchor is not None:
        model.addConstr(x[anchor] == 1)
    return model, x


def replay_witness(
    hx: np.ndarray,
    lx: np.ndarray,
    x: gp.tupledict,
    objective: float,
    logical: int | None,
    anchor: int | None,
) -> dict:
    raw = np.fromiter((x[i].X for i in range(len(x))), dtype=np.float64, count=len(x))
    witness = np.rint(raw).astype(np.uint8)
    if np.max(np.abs(raw - witness)) > 1e-6:
        raise RuntimeError("backend incumbent is not integral")
    syndrome = (hx @ witness) & 1
    parities = (lx @ witness) & 1
    weight = int(witness.sum())
    if np.any(syndrome):
        raise RuntimeError("backend incumbent fails the exact GF(2) kernel check")
    if logical is None and not np.any(parities):
        raise RuntimeError("backend incumbent is a stabilizer")
    if logical is not None and int(parities[logical]) != 1:
        raise RuntimeError("backend incumbent fails its logical parity")
    if anchor is not None and int(witness[anchor]) != 1:
        raise RuntimeError("backend incumbent fails its certified anchor")
    if abs(objective - weight) > 1e-6:
        raise RuntimeError("backend objective differs from exact witness weight")
    packed = np.packbits(witness, bitorder="little").tobytes()
    return {
        "weight": weight,
        "support": np.flatnonzero(witness).astype(int).tolist(),
        "support_sha256": hashlib.sha256(packed).hexdigest(),
        "logical_parities": np.flatnonzero(parities).astype(int).tolist(),
    }


def solve(
    model: gp.Model,
    x: gp.tupledict,
    hx: np.ndarray,
    lx: np.ndarray,
    log_path: Path,
    time_limit: float,
    seed: int,
    logical: int | None = None,
    anchor: int | None = None,
) -> dict:
    log_path.parent.mkdir(parents=True, exist_ok=True)
    model.Params.Threads = 1
    model.Params.Seed = seed
    model.Params.MIPGap = 0.0
    model.Params.TimeLimit = time_limit
    model.Params.LogFile = str(log_path)
    model.Params.LogToConsole = 0
    start = time.perf_counter()
    model.optimize()
    wall = time.perf_counter() - start
    result = {
        "kind": "solve",
        "name": model.ModelName,
        "logical": logical,
        "anchor": anchor,
        "status": int(model.Status),
        "status_name": {
            GRB.OPTIMAL: "OPTIMAL",
            GRB.TIME_LIMIT: "TIME_LIMIT",
            GRB.INFEASIBLE: "INFEASIBLE",
        }.get(model.Status, f"STATUS_{model.Status}"),
        "wall_seconds": wall,
        "runtime_seconds": float(model.Runtime),
        "work": float(model.Work),
        "nodes": float(model.NodeCount),
        "iterations": float(model.IterCount),
        "solutions": int(model.SolCount),
        "num_vars": int(model.NumVars),
        "num_constraints": int(model.NumConstrs),
        "log_path": str(log_path),
    }
    if model.SolCount:
        result["objective"] = float(model.ObjVal)
        result["witness"] = replay_witness(hx, lx, x, model.ObjVal, logical, anchor)
    if model.Status in (GRB.OPTIMAL, GRB.TIME_LIMIT):
        result["objective_bound"] = float(model.ObjBound)
        result["mip_gap"] = float(model.MIPGap) if model.SolCount else None
    return result


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--c997-source", type=Path, required=True)
    parser.add_argument(
        "--mode", choices=("per-logical", "global", "symbreak"), required=True
    )
    parser.add_argument(
        "--out", type=Path, required=True, help="append-only JSONL evidence"
    )
    parser.add_argument("--log-dir", type=Path, required=True)
    parser.add_argument("--time-limit", type=float, default=900.0)
    parser.add_argument("--seed", type=int, default=1)
    parser.add_argument("--logicals", default="all")
    args = parser.parse_args()

    c997 = load_c997(args.c997_source.resolve())
    hx, hz, lx, _, _, _ = c997.build_gross_code()
    hx = np.asarray(hx, dtype=np.uint8) & 1
    hz = np.asarray(hz, dtype=np.uint8) & 1
    lx = np.asarray(lx, dtype=np.uint8) & 1
    semantic_checks = validate_semantics(c997, hx, hz, lx)
    anchors = semantic_checks["anchor_cover"]
    sink = JsonlSink(args.out)
    sink.emit(
        {
            "kind": "header",
            "schema": "ergodis-c997-gurobi-v1",
            "mode": args.mode,
            "solver": f"Gurobi {gp.gurobi.version()}",
            "package_versions": {
                package: version(package)
                for package in ("gurobipy", "mip", "bposd", "numpy")
            },
            "python_version": platform.python_version(),
            "threads": 1,
            "seed": args.seed,
            "mip_gap": 0.0,
            "time_limit": args.time_limit,
            "c997_source": str(args.c997_source.resolve()),
            "c997_source_sha256": sha256_file(args.c997_source),
            "runner_sha256": sha256_file(Path(__file__)),
            "hx_sha256": hashlib.sha256(hx.tobytes()).hexdigest(),
            "lx_sha256": hashlib.sha256(lx.tobytes()).hexdigest(),
            "n": int(hx.shape[1]),
            "k": int(lx.shape[0]),
            "semantic_checks": semantic_checks,
        }
    )
    results = []
    try:
        if args.mode == "per-logical":
            indices = (
                range(lx.shape[0])
                if args.logicals == "all"
                else (int(v) for v in args.logicals.split(","))
            )
            for index in indices:
                model, x = model_per_logical(hx, lx[index], index)
                result = solve(
                    model,
                    x,
                    hx,
                    lx,
                    args.log_dir / f"per_logical_{index}.log",
                    args.time_limit,
                    args.seed,
                    logical=index,
                )
                sink.emit(result)
                results.append(result)
                model.dispose()
        elif args.mode == "global":
            model, x = model_global(hx, lx, None)
            result = solve(
                model,
                x,
                hx,
                lx,
                args.log_dir / "global.log",
                args.time_limit,
                args.seed,
            )
            sink.emit(result)
            results.append(result)
            model.dispose()
        else:
            for anchor in anchors:
                model, x = model_global(hx, lx, anchor)
                result = solve(
                    model,
                    x,
                    hx,
                    lx,
                    args.log_dir / f"anchor_{anchor}.log",
                    args.time_limit,
                    args.seed,
                    anchor=anchor,
                )
                sink.emit(result)
                results.append(result)
                model.dispose()
        objectives = [r["objective"] for r in results if "objective" in r]
        sink.emit(
            {
                "kind": "summary",
                "mode": args.mode,
                "solves": len(results),
                "min_objective": min(objectives) if objectives else None,
                "total_nodes": sum(r["nodes"] for r in results),
                "total_wall_seconds": sum(r["wall_seconds"] for r in results),
                "all_optimal": all(r["status"] == GRB.OPTIMAL for r in results),
            }
        )
    finally:
        sink.close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
