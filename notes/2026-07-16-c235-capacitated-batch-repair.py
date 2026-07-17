#!/usr/bin/env python3
"""Exact q=9 certificates for C235's capacitated harmonic repair port."""

from __future__ import annotations

import argparse
from collections import Counter
from fractions import Fraction
from itertools import combinations
import importlib.util
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
C218 = HERE / "2026-07-16-c218-quartic-nucleus-verifier.py"

if not __debug__:
    raise RuntimeError("this verifier requires assertions; do not run Python with -O")


def load_c218():
    spec = importlib.util.spec_from_file_location("c218_quartic_nucleus", C218)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def achievable_integral_vectors(jobs, capacities):
    """Enumerate unit-capacity schedules; each labeled job is used at most once."""
    vectors = set()
    for size in range(len(jobs) + 1):
        for chosen in combinations(jobs, size):
            loads = Counter(helper for _, helpers in chosen for helper in helpers)
            if all(loads[helper] <= capacity for helper, capacity in capacities.items()):
                target_loads = Counter(target for target, _ in chosen)
                vectors.add(tuple(target_loads[target] for target in TARGETS))
    return vectors


def uniform_loads(jobs, flow):
    loads = Counter()
    rates = Counter()
    for target, helpers in jobs:
        rates[target] += flow
        for helper in helpers:
            loads[helper] += flow
    return rates, loads


TARGETS = (0, 9)  # finite zero and infinity on P^1(F_9)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    c218 = load_c218()
    base = c218.load_base()
    field = next(field for field in base.FIELDS if field.q == 9)
    blocks = c218.harmonic_blocks(field)
    curve = set(range(field.q + 1))
    live_curve = curve - set(TARGETS)
    nucleus = field.q + 1

    jobs_by_target = {}
    for target in TARGETS:
        other_target = next(value for value in TARGETS if value != target)
        jobs_by_target[target] = sorted(
            tuple(sorted(block - {target}))
            for block in blocks
            if target in block and other_target not in block
        )
        assert len(jobs_by_target[target]) == 8
        assert all(set(repair) <= live_curve for repair in jobs_by_target[target])

    per_target_degrees = {
        target: Counter(helper for repair in repairs for helper in repair)
        for target, repairs in jobs_by_target.items()
    }
    assert all(
        set(degrees) == live_curve and set(degrees.values()) == {3}
        for degrees in per_target_degrees.values()
    )
    combined_degrees = per_target_degrees[TARGETS[0]] + per_target_degrees[TARGETS[1]]
    assert set(combined_degrees.values()) == {6}

    ordinary_jobs = [
        (target, frozenset(repair))
        for target, repairs in jobs_by_target.items()
        for repair in repairs
    ]
    nucleus_jobs = [
        (target, helpers | {nucleus}) for target, helpers in ordinary_jobs
    ]
    unit_curve_capacities = {helper: 1 for helper in live_curve}
    with_nucleus_capacities = unit_curve_capacities | {nucleus: 1}
    integral_with_nucleus = achievable_integral_vectors(
        nucleus_jobs, with_nucleus_capacities
    )
    integral_without_nucleus = achievable_integral_vectors(
        ordinary_jobs, unit_curve_capacities
    )
    assert integral_with_nucleus == {(0, 0), (1, 0), (0, 1)}
    assert integral_without_nucleus == {
        (0, 0), (1, 0), (0, 1), (2, 0), (1, 1), (0, 2)
    }

    # Fractional primal/dual certificates.  With the nucleus, put 1/16 on
    # every labeled repair and price only the nucleus.  Without it, put 1/6
    # on every repair and price each ordinary helper at 1/3.
    rates, loads = uniform_loads(nucleus_jobs, Fraction(1, 16))
    assert all(rates[target] == Fraction(1, 2) for target in TARGETS)
    assert loads[nucleus] == 1
    assert all(loads[helper] == Fraction(3, 8) for helper in live_curve)
    nucleus_dual = {helper: Fraction(0) for helper in live_curve} | {
        nucleus: Fraction(1)
    }
    assert all(
        sum(nucleus_dual[helper] for helper in repair) >= 1
        for _, repair in nucleus_jobs
    )
    assert (
        sum(with_nucleus_capacities[u] * nucleus_dual[u] for u in nucleus_dual)
        == 1
    )

    rates, loads = uniform_loads(ordinary_jobs, Fraction(1, 6))
    assert all(rates[target] == Fraction(4, 3) for target in TARGETS)
    assert all(loads[helper] == 1 for helper in live_curve)
    ordinary_dual = {helper: Fraction(1, 3) for helper in live_curve}
    assert all(
        sum(ordinary_dual[helper] for helper in repair) == 1
        for _, repair in ordinary_jobs
    )
    assert (
        sum(unit_curve_capacities[u] * ordinary_dual[u] for u in ordinary_dual)
        == Fraction(8, 3)
    )

    with_nucleus_primal = {
        "flow_per_labeled_repair": "1/16",
        "target_rates": ["1/2", "1/2"],
        "nucleus_load": "1",
        "each_curve_helper_load": "3/8",
        "objective": "1",
    }
    with_nucleus_dual = {
        "nucleus_weight": "1",
        "each_curve_helper_weight": "0",
        "cover_value": "1",
    }
    without_nucleus_primal = {
        "flow_per_labeled_repair": "1/6",
        "target_rates": ["4/3", "4/3"],
        "each_curve_helper_load": "1",
        "objective": "8/3",
    }
    without_nucleus_dual = {
        "each_curve_helper_weight": "1/3",
        "weight_of_each_three_helper_repair": "1",
        "cover_value": "8/3",
    }

    certificate = {
        "task": "C235",
        "q": field.q,
        "targets": ["0", "infinity"],
        "failed_targets_excluded_from_helpers": True,
        "harmonic_block_count": len(blocks),
        "feasible_repairs_per_target": {
            str(target): len(repairs) for target, repairs in jobs_by_target.items()
        },
        "ordinary_live_helper_count": len(live_curve),
        "ordinary_helper_degree_per_target": 3,
        "ordinary_helper_combined_degree": 6,
        "symmetry_reduced_fractional_lp": {
            "variables": "a,b = common flow on each of the eight repairs for the two targets",
            "objective": "maximize 8(a+b)",
            "ordinary_helper_constraint": "3(a+b) <= c_curve",
            "nucleus_constraint": "8(a+b) <= c_nucleus",
            "capacity": "min(c_nucleus, 8*c_curve/3)",
            "region": (
                "lambda_0,lambda_infinity >= 0; "
                "lambda_0+lambda_infinity <= min(c_nucleus,8*c_curve/3)"
            ),
        },
        "unit_capacity_with_nucleus": {
            "primal": with_nucleus_primal,
            "dual": with_nucleus_dual,
            "integral_region": sorted(integral_with_nucleus),
        },
        "unit_capacity_without_nucleus": {
            "primal": without_nucleus_primal,
            "dual": without_nucleus_dual,
            "integral_region": sorted(integral_without_nucleus),
        },
    }
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
