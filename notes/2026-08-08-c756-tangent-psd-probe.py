#!/usr/bin/env python3
"""Numerical discriminator for uniform PSD bounds on the C756 tangent graphs.

This is discovery evidence, not an exact certificate.  For each graph H, solve

  maximize s  subject to C >= 0, C_ii = 1, C_ij = -s on edges of H.

Then every clique has size at most 1 + 1/s.  The q=13 optimum can be compared with
Paper IV's exact matrix, where s=1/4 and the bound is 5.

Run in the recorded Nix environment; stdout is canonical JSON.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import sys

import clarabel
import cvxpy as cp
import numpy as np


HERE = Path(__file__).resolve().parent
GRAPH_SOURCE = HERE / "2026-08-08-c756-passant-code-equality.py"
OUTPUT = HERE / "2026-08-08-c756-tangent-psd-probe.json"


def load_graph_module():
    spec = importlib.util.spec_from_file_location("c756_passant_equality", GRAPH_SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {GRAPH_SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


GRAPH = load_graph_module()


def adjacency_matrix(neighbors):
    n = len(neighbors)
    return np.array(
        [[float((neighbors[i] >> j) & 1) for j in range(n)] for i in range(n)],
        dtype=float,
    )


def spectrum_summary(matrix, places=7):
    eigenvalues = np.linalg.eigvalsh(matrix)
    rounded = [round(float(value), places) for value in eigenvalues]
    return {
        "minimum": rounded[0],
        "minimum_multiplicity": rounded.count(rounded[0]),
        "maximum": rounded[-1],
        "maximum_multiplicity": rounded.count(rounded[-1]),
        "distinct_values": len(set(rounded)),
    }


def nonedge_value_summary(matrix, edge_mask, places=7):
    values = []
    n = matrix.shape[0]
    for i in range(n):
        for j in range(i + 1, n):
            if edge_mask[i, j]:
                continue
            values.append(round(float(matrix[i, j]), places))
    return {
        "distinct_values": len(set(values)),
        "minimum": min(values),
        "maximum": max(values),
    }


def solve_field(p, exponent):
    q, neighbors, tangent_sign = GRAPH.build_tangent_graph(p, exponent)
    adjacency = adjacency_matrix(neighbors)
    n = len(neighbors)
    edges = [(i, j) for i in range(n) for j in range(i + 1, n)
             if adjacency[i, j] == 1]

    completion = cp.Variable((n, n), symmetric=True)
    edge_value = cp.Variable()
    constraints = [completion >> 0, cp.diag(completion) == 1]
    constraints += [completion[i, j] == -edge_value for i, j in edges]
    problem = cp.Problem(cp.Maximize(edge_value), constraints)
    optimum = problem.solve(
        solver="CLARABEL",
        tol_gap_abs=1e-9,
        tol_gap_rel=1e-9,
        tol_feas=1e-9,
        max_iter=500,
    )
    if problem.status not in {cp.OPTIMAL, cp.OPTIMAL_INACCURATE}:
        raise RuntimeError(f"q={q}: solver status {problem.status}")

    matrix = np.asarray(completion.value, dtype=float)
    matrix = (matrix + matrix.T) / 2
    eigenvalues = np.linalg.eigvalsh(matrix)
    s = float(edge_value.value)
    edge_residual = max(abs(matrix[i, j] + s) for i, j in edges)
    diagonal_residual = float(np.max(np.abs(np.diag(matrix) - 1)))
    rank_threshold = 1e-7
    return {
        "q": q,
        "vertices": n,
        "edges": len(edges),
        "required_tangent_holonomy": tangent_sign,
        "solver_status": problem.status,
        "objective_return": round(float(optimum), 10),
        "edge_magnitude_s": round(s, 10),
        "quadratic_clique_bound": round(1 + 1 / s, 8),
        "forbidden_target": (q + 1) // 2,
        "target_excluded_numerically": 1 + 1 / s < (q + 1) // 2 - 1e-6,
        "completion_min_eigenvalue": round(float(eigenvalues[0]), 10),
        "completion_rank_at_1e-7": int(np.sum(eigenvalues > rank_threshold)),
        "completion_nonedge_value_clusters_1e-7": nonedge_value_summary(
            matrix, adjacency.astype(bool)
        ),
        "edge_residual": f"{edge_residual:.3e}",
        "diagonal_residual": f"{diagonal_residual:.3e}",
        "adjacency_spectrum_1e-7": spectrum_summary(adjacency),
    }


def generate():
    fields = [(5, 1), (7, 1), (3, 2), (11, 1), (13, 1), (17, 1), (19, 1)]
    return {
        "schema": "c756-tangent-psd-probe-v1",
        "environment": {
            "python": sys.version.split()[0],
            "python_package": "nixpkgs python3.withPackages (ps: [ ps.numpy ps.cvxpy ])",
            "numpy": np.__version__,
            "cvxpy": cp.__version__,
            "clarabel": clarabel.__version__,
            "solver": "CLARABEL",
            "absolute_relative_feasibility_tolerance": "1e-9",
        },
        "graph_source": {
            "path": "notes/2026-08-08-c756-passant-code-equality.py",
            "bytes": GRAPH_SOURCE.stat().st_size,
            "sha256": hashlib.sha256(GRAPH_SOURCE.read_bytes()).hexdigest(),
        },
        "fields": [solve_field(p, exponent) for p, exponent in fields],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(generate(), indent=1, sort_keys=True) + "\n"
    if args.check:
        if OUTPUT.read_text() != rendered:
            raise SystemExit(f"generated output differs from {OUTPUT}")
        print(f"ok: {OUTPUT.name}")
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
