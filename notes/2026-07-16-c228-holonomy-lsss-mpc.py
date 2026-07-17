#!/usr/bin/env python3
"""C228: bounded multiplicative-LSSS test for C217's GF(9) pair."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
C217 = HERE / "2026-07-16-c217-gauge-invariant-verifier.py"

if not __debug__:
    raise RuntimeError("this verifier requires assertions; do not run Python with -O")


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def div(field, numerator: int, denominator: int) -> int:
    return field.mul(numerator, field.inv(denominator))


def add_vectors(field, left, right):
    return tuple(field.add(a, b) for a, b in zip(left, right))


def scale_vector(field, scalar: int, vector):
    return tuple(field.mul(scalar, value) for value in vector)


def tensor_square(field, vector):
    return tuple(field.mul(a, b) for a in vector for b in vector)


def rank(field, vectors) -> int:
    if not vectors:
        return 0
    matrix = [list(vector) for vector in vectors]
    row_count = len(matrix)
    column_count = len(matrix[0])
    pivot_row = 0
    for column in range(column_count):
        pivot = next(
            (row for row in range(pivot_row, row_count) if matrix[row][column]), None
        )
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        inverse = field.inv(matrix[pivot_row][column])
        matrix[pivot_row] = [
            field.mul(inverse, value) for value in matrix[pivot_row]
        ]
        for row in range(row_count):
            if row == pivot_row or matrix[row][column] == 0:
                continue
            multiplier = matrix[row][column]
            matrix[row] = [
                field.sub(value, field.mul(multiplier, pivot_value))
                for value, pivot_value in zip(matrix[row], matrix[pivot_row])
            ]
        pivot_row += 1
        if pivot_row == row_count:
            break
    return pivot_row


def affine_point(parameter: int):
    return (1, parameter)


def transform_row(field, vector, matrix):
    return tuple(
        sum_field(field, (field.mul(vector[i], matrix[i][j]) for i in range(2)))
        for j in range(2)
    )


def sum_field(field, values) -> int:
    result = 0
    for value in values:
        result = field.add(result, value)
    return result


def lagrange_weights(field, dealer: int, participants) -> dict[int, int]:
    answer = {}
    for parameter in participants:
        numerator = 1
        denominator = 1
        for other in participants:
            if other == parameter:
                continue
            numerator = field.mul(numerator, field.sub(dealer, other))
            denominator = field.mul(denominator, field.sub(parameter, other))
        answer[parameter] = div(field, numerator, denominator)
    return answer


def verify_recombination(field, target, participant_rows, weights) -> None:
    recombined = (0,) * 4
    for parameter, row in participant_rows.items():
        recombined = add_vectors(
            field,
            recombined,
            scale_vector(field, weights[parameter], tensor_square(field, row)),
        )
    assert recombined == tensor_square(field, target)


def dealer_test(field, parameters, dealer: int, primitive: int) -> dict:
    participants = tuple(parameter for parameter in parameters if parameter != dealer)
    target = affine_point(dealer)
    participant_rows = {parameter: affine_point(parameter) for parameter in participants}
    weights = lagrange_weights(field, dealer, participants)
    verify_recombination(field, target, participant_rows, weights)

    participant_squares = [tensor_square(field, participant_rows[p]) for p in participants]
    target_square = tensor_square(field, target)
    assert rank(field, participant_squares) == 3
    assert rank(field, [*participant_squares, target_square]) == 3

    singleton_deletions = {}
    for deleted in participants:
        remaining = tuple(parameter for parameter in participants if parameter != deleted)
        remaining_squares = [tensor_square(field, participant_rows[p]) for p in remaining]
        assert rank(field, remaining_squares) == 2
        assert rank(field, [*remaining_squares, target_square]) == 3
        # The product polynomial (T-u)(T-v) vanishes at the two remaining
        # participants but not at the distinct dealer point.
        u, v = remaining
        witness_at_dealer = field.mul(field.sub(dealer, u), field.sub(dealer, v))
        assert witness_at_dealer != 0
        singleton_deletions[str(deleted)] = {
            "remaining_participants": list(remaining),
            "remaining_square_rank": 2,
            "rank_after_adding_dealer_square": 3,
            "vanishing_product_witness_at_dealer": witness_at_dealer,
        }

    # Coordinate gauges rescale tensor squares but cannot change span membership.
    scale_by_parameter = {
        parameter: field.pow(primitive, (2 * index + 1) % (field.q - 1))
        for index, parameter in enumerate(parameters)
    }
    scaled_target = scale_vector(field, scale_by_parameter[dealer], target)
    scaled_rows = {
        parameter: scale_vector(field, scale_by_parameter[parameter], row)
        for parameter, row in participant_rows.items()
    }
    scaled_weights = {
        parameter: field.mul(
            weights[parameter],
            div(
                field,
                field.pow(scale_by_parameter[dealer], 2),
                field.pow(scale_by_parameter[parameter], 2),
            ),
        )
        for parameter in participants
    }
    verify_recombination(field, scaled_target, scaled_rows, scaled_weights)

    # A global change of information coordinates acts covariantly on every square.
    global_change = ((1, 1), (1, 2))
    transformed_target = transform_row(field, target, global_change)
    transformed_rows = {
        parameter: transform_row(field, row, global_change)
        for parameter, row in participant_rows.items()
    }
    verify_recombination(field, transformed_target, transformed_rows, weights)

    return {
        "dealer": dealer,
        "participants": list(participants),
        "minimal_qualified_coalitions": [
            list(pair)
            for index, first in enumerate(participants)
            for pair in ((first, participants[(index + 1) % 3]),)
        ],
        "lagrange_recombination_weights": {
            str(parameter): weights[parameter] for parameter in participants
        },
        "ordinary_multiplicative": True,
        "multiplicative_square_port": "3-of-3",
        "strongly_multiplicative": False,
        "singleton_adversary_deletions": singleton_deletions,
        "coordinate_gauge_replay": "passed",
        "global_information_basis_replay": "passed",
    }


def holonomy(field, parameters) -> int:
    a, b, c, d = parameters
    return div(
        field,
        field.mul(field.sub(b, c), field.sub(d, a)),
        field.mul(field.sub(c, a), field.sub(b, d)),
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    c217 = load_module("c217_for_c228", C217)
    c203 = c217.load_c203()
    base = c203.load_base()
    field = base.FIELDS[1]
    assert field.q == 9
    primitive = c217.primitive_element(field)

    parameter_sets = ((0, 1, 3, 4), (0, 1, 2, 8))
    representations = []
    for parameters in parameter_sets:
        value = holonomy(field, parameters)
        representations.append(
            {
                "parameters": list(parameters),
                "holonomy": value,
                "anharmonic_orbit": sorted(c217.anharmonic_orbit(field, value)),
                "dealer_tests": [
                    dealer_test(field, parameters, dealer, primitive)
                    for dealer in parameters
                ],
            }
        )

    assert [item["holonomy"] for item in representations] == [2, 3]
    assert set(representations[0]["anharmonic_orbit"]).isdisjoint(
        representations[1]["anharmonic_orbit"]
    )
    assert all(
        test["ordinary_multiplicative"] and not test["strongly_multiplicative"]
        for representation in representations
        for test in representation["dealer_tests"]
    )

    certificate = {
        "task": "C228",
        "c217_verifier_sha256": hashlib.sha256(C217.read_bytes()).hexdigest(),
        "field_encoding": "GF(3)[x]/(x^2+1), base-3 coefficient encoding",
        "dealer_convention": (
            "pi_dealer is the secret linear form; each other projective point pi_i "
            "is one ideal participant share"
        ),
        "primal_dual_convention_check": (
            "U(2,4) is identically self-dual, so the dual convention has the same 2-of-3 port"
        ),
        "ordinary_criterion": (
            "pi_dealer tensor pi_dealer lies in the span of participant tensor squares"
        ),
        "strong_criterion": (
            "the ordinary criterion remains true after deleting every unqualified adversary set"
        ),
        "access_structure": "2-of-3 for every dealer choice in U(2,4)",
        "q2": True,
        "q3": False,
        "structural_result": (
            "quadratic Veronese sends each four-point realization to U(3,4); "
            "the induced multiplicative port is 3-of-3, independent of holonomy"
        ),
        "representations": representations,
    }
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
