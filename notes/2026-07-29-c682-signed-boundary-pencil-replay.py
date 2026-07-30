#!/usr/bin/env python3
"""Independent exact replay of the C682 Hermite-pencil chamber counts."""

import hashlib
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
INPUT = HERE / "2026-07-29-c682-plateau-controllability.json"
CERTIFICATE = HERE / "2026-07-29-c682-signed-boundary-pencil.json"


def bezout_by_recurrence(left, right):
    degree = len(left) - 1
    coefficient = [
        [Fraction(0) for _ in range(degree + 1)]
        for _ in range(degree + 1)
    ]
    for row, left_value in enumerate(left):
        for column, right_value in enumerate(right):
            coefficient[row][column] += left_value * right_value
            coefficient[column][row] -= left_value * right_value
    matrix = [
        [Fraction(0) for _ in range(degree)]
        for _ in range(degree)
    ]
    # From A_{i+1,j}=B_{i,j}-B_{i+1,j-1}.
    for row in reversed(range(degree)):
        for column in range(degree):
            matrix[row][column] = coefficient[row + 1][column]
            if row + 1 < degree and column:
                matrix[row][column] += matrix[row + 1][column - 1]
    assert all(
        matrix[row][column] == matrix[column][row]
        for row in range(degree)
        for column in range(degree)
    )
    return matrix


def companion(polynomial):
    degree = len(polynomial) - 1
    matrix = [
        [Fraction(0) for _ in range(degree)]
        for _ in range(degree)
    ]
    for column in range(degree - 1):
        matrix[column + 1][column] = 1
    for row in range(degree):
        matrix[row][-1] = -polynomial[row] / polynomial[-1]
    return matrix


def multiply(left, right):
    return [
        [
            sum(left[row][index] * right[index][column]
                for index in range(len(right)))
            for column in range(len(right))
        ]
        for row in range(len(left))
    ]


def unpivoted_inertia(matrix):
    """Independent LDL replay; every certified leading pivot is nonzero."""
    work = [row[:] for row in matrix]
    positive = negative = 0
    for pivot_index in range(len(work)):
        pivot = work[pivot_index][pivot_index]
        assert pivot
        positive += pivot > 0
        negative += pivot < 0
        for row in range(pivot_index + 1, len(work)):
            for column in range(row, len(work)):
                work[row][column] -= (
                    work[row][pivot_index]
                    * work[pivot_index][column]
                    / pivot
                )
                work[column][row] = work[row][column]
    return [int(positive), int(negative), 0]


def pencil_inertias(polynomial, endpoints):
    derivative = [
        Fraction(index) * polynomial[index]
        for index in range(1, len(polynomial))
    ]
    metric = bezout_by_recurrence(polynomial, derivative)
    constant = multiply(companion(polynomial), metric)
    assert all(
        constant[row][column] == constant[column][row]
        for row in range(len(constant))
        for column in range(len(constant))
    )
    table = {}
    for endpoint in endpoints:
        pencil = [
            [
                Fraction(endpoint) * metric[row][column]
                - constant[row][column]
                for column in range(len(metric))
            ]
            for row in range(len(metric))
        ]
        table[str(endpoint)] = unpivoted_inertia(pencil)
    return unpivoted_inertia(metric), table


def main():
    source = json.loads(INPUT.read_text(encoding="utf-8"))
    expected = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    assert expected["input"]["sha256"] == hashlib.sha256(
        INPUT.read_bytes()
    ).hexdigest()
    reduction = source["symbolic_reduction"]
    numerator = [
        Fraction(value)
        for value in reduction["mixing_numerator_coefficients_ascending"]
    ]
    denominator = [
        Fraction(value)
        for value in reduction["mixing_denominator_coefficients_ascending"]
    ]
    boundary_metric = bezout_by_recurrence(numerator, denominator)
    boundary_constant = multiply(companion(numerator), boundary_metric)
    assert all(
        boundary_constant[row][column]
        == boundary_constant[column][row]
        for row in range(len(boundary_constant))
        for column in range(len(boundary_constant))
    )
    assert unpivoted_inertia(boundary_metric) == (
        expected["signed_boundary_pencil"]["metric_inertia"]
    )
    endpoints = [-3, -2, -1, 0, 1]
    numerator_metric, numerator_table = pencil_inertias(
        numerator, endpoints
    )
    denominator_metric, denominator_table = pencil_inertias(
        denominator, endpoints
    )
    recorded = expected["intrinsic_sturm_pencils"]
    assert numerator_metric == recorded["numerator"]["metric_inertia"]
    assert numerator_table == recorded["numerator"]["endpoint_inertias"]
    assert denominator_metric == recorded["denominator"]["metric_inertia"]
    assert denominator_table == recorded["denominator"]["endpoint_inertias"]
    print("PASS: independent C682 Hermite-pencil inertia replay")


if __name__ == "__main__":
    main()
