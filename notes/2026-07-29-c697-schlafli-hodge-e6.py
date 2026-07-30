#!/usr/bin/env python3
"""Exact bookkeeping for the C697 graded Cartan and conjugation tests."""

from __future__ import annotations

import argparse
from fractions import Fraction
import itertools
import json
from pathlib import Path


OUTPUT = Path(__file__).with_suffix(".json")
INDICES = tuple(range(6))  # infinity, 1, zeta, zeta^2, zeta^3, zeta^4
VERTICES = (
    [f"x{i}" for i in INDICES]
    + [f"y{i}" for i in INDICES]
    + [f"w{i}{j}" for i, j in itertools.combinations(INDICES, 2)]
)


def perfect_matchings(values):
    values = tuple(values)
    if not values:
        return [()]
    first = values[0]
    result = []
    for position in range(1, len(values)):
        second = values[position]
        remainder = values[1:position] + values[position + 1 :]
        for tail in perfect_matchings(remainder):
            result.append(((min(first, second), max(first, second)),) + tail)
    return result


def permutation_sign(permutation):
    inversions = sum(
        permutation[left] > permutation[right]
        for left in range(len(permutation))
        for right in range(left + 1, len(permutation))
    )
    return -1 if inversions % 2 else 1


def galois_permutation(exponent):
    assert exponent in (1, 2, 3, 4)
    return (0,) + tuple(1 + exponent * power % 5 for power in range(5))


def rational_rank(matrix):
    work = [[Fraction(value) for value in row] for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        scale = work[row][column]
        work[row] = [value / scale for value in work[row]]
        for index in range(len(work)):
            if index == row or not work[index][column]:
                continue
            scale = work[index][column]
            work[index] = [
                left - scale * right
                for left, right in zip(work[index], work[row], strict=True)
            ]
        row += 1
    return row


def certificate():
    cross = [
        (f"x{i}", f"y{j}", f"w{min(i, j)}{max(i, j)}")
        for i in INDICES
        for j in INDICES
        if i != j
    ]
    pfaffian = [
        tuple(f"w{i}{j}" for i, j in matching)
        for matching in perfect_matchings(INDICES)
    ]
    assert len(cross) == 30 and len(pfaffian) == 15
    edges = cross + pfaffian
    exponent_matrix = [
        [int(vertex in edge) for vertex in VERTICES] for edge in edges
    ]
    rank = rational_rank(exponent_matrix)
    assert rank == 21

    actions = {}
    for exponent in (1, 2, 3, 4):
        permutation = galois_permutation(exponent)
        sign = permutation_sign(permutation)
        actions[str(exponent)] = {
            "zeta_image": f"zeta^{exponent}",
            "axis_permutation_one_based": [value + 1 for value in permutation],
            "axis_orientation_sign": sign,
            "raw_mixed_multiplier": 1,
            "raw_pfaffian_multiplier": sign,
            "raw_cartan_line_preserved": sign == 1,
            "determinant_compensated_row_multiplier": sign,
            "compensated_cartan_multiplier": sign,
        }
        assert actions[str(exponent)]["raw_cartan_line_preserved"] == (
            exponent in (1, 4)
        )

    return {
        "schema": "c697-schlafli-hodge-e6-v1",
        "graded_carrier": {
            "formula": "(A tensor U^dual) direct_sum exterior^2 U",
            "dimensions": [6, 15, 6],
            "centered_grading_weights": [1, 0, -1],
            "hodge_labels": ["(2,0)", "(1,1)", "(0,2)"],
        },
        "cartan_support": {
            "mixed_terms": len(cross),
            "pfaffian_terms": len(pfaffian),
            "total_tritangent_terms": len(edges),
        },
        "row_actions": {
            "unsigned_exchange": {
                "mixed_multiplier": -1,
                "pfaffian_multiplier": 1,
                "cartan_line_preserved": False,
            },
            "signed_A1_weyl_lift": {
                "action": "x_i -> y_i; y_i -> -x_i; w_ij -> w_ij",
                "mixed_multiplier": 1,
                "pfaffian_multiplier": 1,
                "cartan_preserved": True,
                "linear_order": 4,
                "weight_permutation_order": 2,
            },
        },
        "tritangent_rescaling_gauge": {
            "matrix_shape": [len(edges), len(VERTICES)],
            "rank_over_Q": rank,
            "kernel_dimension": len(VERTICES) - rank,
            "coefficient_invariant_dimension": len(edges) - rank,
        },
        "cyclotomic_galois_actions": actions,
        "orientation_field": {
            "even_subgroup_exponents": [1, 4],
            "fixed_field": "Q(sqrt(5))",
            "splitting_field": "Q(zeta_5)",
            "full_Q_descent_requires": (
                "twist one row by the determinant character of the six-axis permutation"
            ),
        },
        "conjugation_classification": {
            "A1_Weyl": "internal complex-linear signed action on one 27",
            "cyclotomic_Galois": "preserves rows and permutes axes",
            "Hodge_complex_conjugation": "maps V_L to V_(L^dual)",
            "E6_outer_automorphism": "exchanges 27 with 27^dual",
        },
    }


def serialized():
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = serialized()
    if args.check:
        assert OUTPUT.read_text() == payload
        print("C697 certificate matches")
    else:
        OUTPUT.write_text(payload)
        print(OUTPUT)


if __name__ == "__main__":
    main()
