#!/usr/bin/env python3
"""C63 amortized-potential LP fit and sparse Farkas certificate extractor.

Run with the cached scientific-Python environment documented in the C63 report:

  .uv-cache/environments-v2/s4-ml-mine-c62c2f326ce38a36/bin/python \
    scripts/c63-potential-lp.py --data s4-dumps/2026-07-10/c63 \
    --out s4-dumps/2026-07-10/c63/lp-results.json

The strict normalized model is

    (f(child) - f(parent)) dot w <= -1

and minimizes ||w||_1.  This removes the literal model's vacuous w=0 solution.  On
infeasibility, Farkas' lemma asks for y >= 0, sum(y)=1, and D^T y=0.  HiGHS returns a
basic feasible y, hence normally a certificate supported on at most d+1 transitions.
"""

from __future__ import annotations

import argparse
import csv
import glob
import json
import math
import os
from fractions import Fraction

import numpy as np
from scipy.optimize import linprog


V1 = [
    "conic_xor",
    "conic_xor_zero",
    "live_on",
    "zone_v",
    "zone_parity",
    "reservoir_slack_total",
    "reservoir_slack_min",
    "defect_components",
    "defect_paths",
    "defect_odd_components",
    "defect_max_path",
    "defect_path_sum_sq",
    "interface_intruders",
    "interface_endpoints",
    "interface_isolates",
    "z_ceiling",
    "descent_depth",
]

# The second round removes the two exact-tablebase lookaheads and the two raw residual
# cardinalities.  Those four coordinates are proof-circular or tautologically monotone.
V2 = [
    x
    for x in V1
    if x not in {"live_on", "zone_v", "z_ceiling", "descent_depth"}
]


def stable_holdout(q: int, key: str) -> bool:
    """Whole-parent 20% split, deterministic and independent of Python hash randomization."""
    return ((int(key, 16) ^ (q * 0x9E3779B97F4A7C15)) % 5) == 0


def load_rows(paths: list[str], features: list[str]):
    deltas: list[list[int]] = []
    witnesses: list[dict[str, object]] = []
    holdout: list[bool] = []
    for path in paths:
        with open(path, newline="") as f:
            for row in csv.DictReader(f, delimiter="\t"):
                q = int(row["q"])
                delta = [
                    int(row[f"child_{name}"]) - int(row[f"parent_{name}"])
                    for name in features
                ]
                deltas.append(delta)
                witnesses.append(
                    {
                        "source": os.path.basename(path),
                        "q": q,
                        "t4": row["t4"],
                        "parent_key": row["parent_key"],
                        "parent_ply": int(row["parent_ply"]),
                        "opponent": row["opponent"],
                        "reply": row["reply"],
                        "child_key": row["child_key"],
                        "child_ply": int(row["child_ply"]),
                        "child_zone": int(row["child_zone"]),
                        "child_z": int(row["child_z"]),
                        "selector_score": int(row["selector_score"]),
                        "parent_cells": row["parent_cells"],
                        "child_cells": row["child_cells"],
                        "delta": delta,
                    }
                )
                holdout.append(stable_holdout(q, row["parent_key"]))
    return (
        np.asarray(deltas, dtype=np.float64),
        witnesses,
        np.asarray(holdout, dtype=bool),
    )


def unique_constraints(deltas: np.ndarray, witnesses: list[dict[str, object]]):
    unique, first = np.unique(deltas, axis=0, return_index=True)
    return unique, [witnesses[int(i)] for i in first]


def fit_strict(deltas: np.ndarray):
    """Minimize L1 norm of a strict unit-margin potential."""
    n = deltas.shape[1]
    result = linprog(
        np.ones(2 * n),
        A_ub=np.hstack((deltas, -deltas)),
        b_ub=-np.ones(deltas.shape[0]),
        bounds=(0, None),
        method="highs",
    )
    if not result.success:
        return result, None
    return result, result.x[:n] - result.x[n:]


def sparse_farkas(deltas: np.ndarray):
    """Return y>=0 with D^T y=0 and sum(y)=1, if one exists."""
    m = deltas.shape[0]
    result = linprog(
        np.zeros(m),
        A_eq=np.vstack((deltas.T, np.ones(m))),
        b_eq=np.concatenate((np.zeros(deltas.shape[1]), np.ones(1))),
        bounds=(0, None),
        method="highs-ds",
    )
    if not result.success:
        return result, []
    support = np.flatnonzero(result.x > 1e-9)
    return result, [(int(i), float(result.x[i])) for i in support]


def rational_text(value: float, denominator: int = 1_000_000) -> str:
    return str(Fraction(float(value)).limit_denominator(denominator))


def validation(deltas: np.ndarray, weights: np.ndarray | None):
    if weights is None or deltas.shape[0] == 0:
        return None
    changes = deltas @ weights
    return {
        "rows": int(deltas.shape[0]),
        "max_change": float(changes.max()),
        "min_change": float(changes.min()),
        "unit_margin_failures": int(np.count_nonzero(changes > -1 + 1e-7)),
        "nonincrease_failures": int(np.count_nonzero(changes > 1e-7)),
    }


def weights_output(features: list[str], weights: np.ndarray):
    return {
        feature: {"float": float(value), "rational": rational_text(value)}
        for feature, value in zip(features, weights)
        if abs(value) > 1e-9
    }


def primitive_integer_weights(weights: np.ndarray):
    fractions = [Fraction(float(x)).limit_denominator(1_000_000) for x in weights]
    scale = 1
    for x in fractions:
        scale = math.lcm(scale, x.denominator)
    integers = [x.numerator * (scale // x.denominator) for x in fractions]
    divisor = 0
    for x in integers:
        divisor = math.gcd(divisor, abs(x))
    if divisor:
        integers = [x // divisor for x in integers]
    return np.asarray(integers, dtype=np.float64)


def run_model(
    name: str,
    features: list[str],
    q13_paths: list[str],
    q17_paths: list[str],
):
    q13_d, q13_w, q13_hold = load_rows(q13_paths, features)
    q17_d, q17_w, q17_hold = load_rows(q17_paths, features)

    q13_train_d, q13_train_w = unique_constraints(
        q13_d[~q13_hold], [w for w, h in zip(q13_w, q13_hold) if not h]
    )
    q13_fit, q13_weights = fit_strict(q13_train_d)
    q13_stage: dict[str, object] = {
        "strict_status": int(q13_fit.status),
        "strict_message": q13_fit.message,
        "unique_train_deltas": int(q13_train_d.shape[0]),
    }
    if q13_weights is not None:
        q17_changes = q17_d @ q13_weights
        bad = np.flatnonzero(q17_changes > 1e-7)
        q13_stage.update(
            {
                "l1_norm": float(np.abs(q13_weights).sum()),
                "weights": weights_output(features, q13_weights),
                "validation": {
                    "q13_fit": validation(q13_d[~q13_hold], q13_weights),
                    "q13_heldout": validation(q13_d[q13_hold], q13_weights),
                    "q17_frozen_all": validation(q17_d, q13_weights),
                },
                "q17_nonincrease_counterexamples": [
                    {"change": float(q17_changes[i]), "witness": q17_w[int(i)]}
                    for i in bad[:12]
                ],
            }
        )

    train_d = np.vstack((q13_d[~q13_hold], q17_d[~q17_hold]))
    train_w = [w for w, h in zip(q13_w, q13_hold) if not h] + [
        w for w, h in zip(q17_w, q17_hold) if not h
    ]
    unique_d, unique_w = unique_constraints(train_d, train_w)
    fit, weights = fit_strict(unique_d)
    output: dict[str, object] = {
        "name": name,
        "features": features,
        "literal_nonincrease_zero_vector_feasible": True,
        "q13_rows": int(q13_d.shape[0]),
        "q17_rows": int(q17_d.shape[0]),
        "train_rows": int(train_d.shape[0]),
        "unique_train_deltas": int(unique_d.shape[0]),
        "strict_status": int(fit.status),
        "strict_message": fit.message,
        "q13_first_stage": q13_stage,
    }
    if weights is not None:
        integer_weights = primitive_integer_weights(weights)
        output["l1_norm"] = float(np.abs(weights).sum())
        output["weights"] = weights_output(features, weights)
        output["primitive_integer_weights"] = {
            feature: int(value)
            for feature, value in zip(features, integer_weights)
            if value != 0
        }
        output["validation"] = {
            "q13_fit": validation(q13_d[~q13_hold], weights),
            "q13_heldout": validation(q13_d[q13_hold], weights),
            "q17_fit": validation(q17_d[~q17_hold], weights),
            "q17_heldout": validation(q17_d[q17_hold], weights),
            "q17_all": validation(q17_d, weights),
            "integer_q13_all": validation(q13_d, integer_weights),
            "integer_q17_all": validation(q17_d, integer_weights),
        }
    else:
        dual, support = sparse_farkas(unique_d)
        output["dual_status"] = int(dual.status)
        output["dual_message"] = dual.message
        certificate = []
        residual = np.zeros(len(features), dtype=np.float64)
        mass = 0.0
        for i, multiplier in support:
            residual += multiplier * unique_d[i]
            mass += multiplier
            certificate.append(
                {
                    "multiplier_float": multiplier,
                    "multiplier_rational": rational_text(multiplier),
                    "witness": unique_w[i],
                }
            )
        output["dual_certificate"] = certificate
        output["dual_check"] = {
            "support": len(certificate),
            "mass": mass,
            "max_abs_weighted_delta": float(np.abs(residual).max(initial=0)),
            "weighted_delta": [float(x) for x in residual],
        }
    return output


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--data", required=True)
    parser.add_argument("--out", required=True)
    args = parser.parse_args()
    q13 = sorted(glob.glob(os.path.join(args.data, "q13-*.transitions.tsv")))
    q17 = sorted(glob.glob(os.path.join(args.data, "q17-*.transitions.tsv")))
    if len(q13) != 5 or len(q17) != 10:
        raise SystemExit(f"expected 5 q13 and 10 q17 transition files, got {len(q13)} and {len(q17)}")
    result = {
        "solver": "SciPy 1.17.1 linprog/HiGHS",
        "split": "whole parent key; deterministic 1/5 held out within each q",
        "strict_model": "min ||w||_1 subject to delta(row) dot w <= -1",
        "models": [
            run_model("v1_declared", V1, q13, q17),
            run_model("v2_proof_admissible", V2, q13, q17),
        ],
    }
    with open(args.out, "w") as f:
        json.dump(result, f, indent=2, sort_keys=True)
        f.write("\n")
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
