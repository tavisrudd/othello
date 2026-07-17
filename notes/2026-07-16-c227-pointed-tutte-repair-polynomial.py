#!/usr/bin/env python3
"""C227: finite checks for the pointed-Tutte repair specialization."""

from __future__ import annotations

import argparse
from collections import Counter
from itertools import product
import importlib.util
import json
import math
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
C219 = HERE / "2026-07-16-c219-repair-reliability.py"

if not __debug__:
    raise RuntimeError("this verifier requires assertions; do not run Python with -O")


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def normalized_forms(field, dimension: int):
    """Yield one representative of each projective linear functional."""

    for first in range(dimension):
        for tail in product(range(field.q), repeat=dimension - first - 1):
            yield (0,) * first + (1,) + tail


def dot(field, left, right) -> int:
    result = 0
    for a, b in zip(left, right):
        result = field.add(result, field.mul(a, b))
    return result


def full_rank_jump_profile(field, points, target: int) -> dict:
    """Count sets A with target in cl(A), independently via hyperplanes.

    The target is outside cl(A) exactly when some linear functional is zero
    on A and nonzero on the target.  Enumerating those hyperplanes and all
    their subsets avoids importing the circuit/reliability computation.
    """

    helpers = tuple(index for index in range(len(points)) if index != target)
    local = {helper: index for index, helper in enumerate(helpers)}
    hyperplane_masks = set()
    for form in normalized_forms(field, len(points[0])):
        if dot(field, form, points[target]) == 0:
            continue
        hyperplane_masks.add(
            sum(
                1 << local[helper]
                for helper in helpers
                if dot(field, form, points[helper]) == 0
            )
        )

    failure = bytearray(1 << len(helpers))
    for mask in hyperplane_masks:
        subset = mask
        while True:
            failure[subset] = 1
            if subset == 0:
                break
            subset = (subset - 1) & mask

    failure_by_size = Counter()
    for subset, value in enumerate(failure):
        if value:
            failure_by_size[subset.bit_count()] += 1
    failure_counts = [failure_by_size[k] for k in range(len(helpers) + 1)]
    success_counts = [
        math.comb(len(helpers), k) - failure_counts[k]
        for k in range(len(helpers) + 1)
    ]
    assert all(
        success_counts[k] + failure_counts[k] == math.comb(len(helpers), k)
        for k in range(len(helpers) + 1)
    )

    # Pointed duality says success in M* on F is failure in M on V-F.
    dual_success_counts = list(reversed(failure_counts))
    assert all(
        success_counts[k] + dual_success_counts[len(helpers) - k]
        == math.comb(len(helpers), k)
        for k in range(len(helpers) + 1)
    )

    return {
        "helper_count": len(helpers),
        "avoiding_hyperplane_section_count": len(hyperplane_masks),
        "largest_avoiding_hyperplane_section": max(mask.bit_count() for mask in hyperplane_masks),
        "success_by_survivor_count": success_counts,
        "failure_by_survivor_count": failure_counts,
        "dual_success_by_survivor_count": dual_success_counts,
    }


def uniform_example(helper_count: int = 6, rank: int = 3) -> dict:
    assert 1 <= rank <= helper_count
    success = [
        math.comb(helper_count, k) if k >= rank else 0
        for k in range(helper_count + 1)
    ]
    failure = [math.comb(helper_count, k) - success[k] for k in range(helper_count + 1)]
    terms = []
    for k in range(helper_count + 1):
        terms.append(
            {
                "subset_size": k,
                "coefficient": math.comb(helper_count, k),
                "x_minus_1_exponent": max(rank - 1 - k, 0),
                "y_minus_1_exponent": max(k - rank, 0),
                "z_exponent_epsilon": 1 if k < rank else 0,
            }
        )
    return {
        "matroid": f"U_{{{rank},{helper_count + 1}}}",
        "helper_count": helper_count,
        "rank": rank,
        "success_by_survivor_count": success,
        "failure_by_survivor_count": failure,
        "pointed_tutte_terms_grouped_by_subset_size": terms,
    }


def subtract_profiles(full: dict, truncated: dict) -> list[int]:
    assert full["helper_count"] == truncated["helper_count"]
    answer = [
        a - b
        for a, b in zip(
            full["success_by_survivor_count"],
            truncated["success_by_survivor_count"],
        )
    ]
    assert all(value >= 0 for value in answer)
    return answer


def q9_examples() -> dict:
    c219 = load_module("c219_reliability", C219)
    c219_profiles = {
        "c202": c219.c202_profiles(),
        "c218": c219.c218_profiles(),
    }

    c202 = load_module("c202_extremizers_for_c227", c219.C202)
    cubic_base = c202.load_verifier()
    cubic_field = cubic_base.FIELDS[1]
    cubic_points, _ = cubic_base.completed_points(cubic_field)
    cubic_target = cubic_field.q
    cubic = full_rank_jump_profile(cubic_field, cubic_points, cubic_target)
    cubic_radius_four = c219_profiles["c202"]["cubic_infinity"]["radii"]["4"]
    assert cubic["success_by_survivor_count"] == cubic_radius_four[
        "success_by_survivor_count"
    ]
    assert cubic["failure_by_survivor_count"] == cubic_radius_four[
        "failure_by_survivor_count"
    ]

    c218 = load_module("c218_quartic_for_c227", c219.C218)
    harmonic_base = c218.load_base()
    harmonic_field = harmonic_base.FIELDS[1]
    harmonic_points = c218.quartic_system(harmonic_field)
    nucleus_target = harmonic_field.q + 1
    nucleus = full_rank_jump_profile(harmonic_field, harmonic_points, nucleus_target)
    curve = full_rank_jump_profile(harmonic_field, harmonic_points, 0)
    nucleus_radius_four = c219_profiles["c218"]["nucleus_target"]
    curve_radius_four = c219_profiles["c218"]["curve_target"]

    nucleus["new_successes_beyond_radius_four_by_survivor_count"] = subtract_profiles(
        nucleus, nucleus_radius_four
    )
    curve["new_successes_beyond_radius_four_by_survivor_count"] = subtract_profiles(
        curve, curve_radius_four
    )
    assert nucleus["new_successes_beyond_radius_four_by_survivor_count"] == [
        0,
        0,
        0,
        0,
        0,
        72,
        0,
        0,
        0,
        0,
        0,
    ]

    return {
        "cubic_infinity_full_rank_jump": cubic,
        "harmonic_nucleus_full_rank_jump": nucleus,
        "harmonic_curve_full_rank_jump": curve,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    certificate = {
        "task": "C227",
        "subset_polynomial": "P_x(u,z)=sum_{A subset E-{x}} u^|A| z^epsilon_x(A)",
        "repair_specialization": "success enumerator is coefficient of z^0",
        "rank_polynomial_identity": (
            "S_x(u)=d/dy (U_{M\\x}(u,y)-U_{M/x}(u,y)) at y=1"
        ),
        "uniform_example": uniform_example(),
        "q9_examples": q9_examples(),
    }
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
