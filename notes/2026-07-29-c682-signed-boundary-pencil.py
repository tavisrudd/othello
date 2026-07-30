#!/usr/bin/env python3
"""Exact signed Bezout pencil for the C682 trivial boundary witness."""

import argparse
import hashlib
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
INPUT = HERE / "2026-07-29-c682-plateau-controllability.json"
OUTPUT = HERE / "2026-07-29-c682-signed-boundary-pencil.json"


def trim(polynomial):
    out = [Fraction(value) for value in polynomial]
    while len(out) > 1 and not out[-1]:
        out.pop()
    return out


def derivative(polynomial):
    return trim(
        [index * value for index, value in enumerate(polynomial) if index]
        or [0]
    )


def remainder(dividend, divisor):
    work = trim(dividend)
    divisor = trim(divisor)
    while len(work) >= len(divisor) and any(work):
        shift = len(work) - len(divisor)
        scalar = work[-1] / divisor[-1]
        for index, value in enumerate(divisor):
            work[index + shift] -= scalar * value
        work = trim(work)
    return work


def gcd_polynomial(left, right):
    left = trim(left)
    right = trim(right)
    while any(right):
        left, right = right, remainder(left, right)
    return [value / left[-1] for value in left]


def bezout_matrix(left, right):
    """Coefficient matrix of (left(x)right(y)-left(y)right(x))/(x-y)."""
    degree = len(left) - 1
    antisymmetric = [
        [Fraction(0) for _ in range(degree + 1)]
        for _ in range(degree + 1)
    ]
    for left_index, left_value in enumerate(left):
        for right_index, right_value in enumerate(right):
            antisymmetric[left_index][right_index] += (
                left_value * right_value
            )
            antisymmetric[right_index][left_index] -= (
                left_value * right_value
            )
    matrix = [
        [Fraction(0) for _ in range(degree)]
        for _ in range(degree)
    ]
    for high in range(degree + 1):
        for low in range(high):
            coefficient = antisymmetric[high][low]
            for offset in range(high - low):
                matrix[high - 1 - offset][low + offset] += coefficient
    assert is_symmetric(matrix)
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
    rows = len(left)
    inner = len(right)
    columns = len(right[0])
    return [
        [
            sum(left[row][index] * right[index][column]
                for index in range(inner))
            for column in range(columns)
        ]
        for row in range(rows)
    ]


def is_symmetric(matrix):
    return all(
        matrix[row][column] == matrix[column][row]
        for row in range(len(matrix))
        for column in range(len(matrix))
    )


def symmetric_swap(matrix, left, right):
    matrix[left], matrix[right] = matrix[right], matrix[left]
    for row in matrix:
        row[left], row[right] = row[right], row[left]


def inertia(matrix):
    """Exact congruence elimination with one- and two-dimensional pivots."""
    work = [row[:] for row in matrix]
    positive = negative = zero = 0
    while work:
        pivot = next(
            (index for index in range(len(work)) if work[index][index]),
            None,
        )
        if pivot is not None:
            symmetric_swap(work, 0, pivot)
            value = work[0][0]
            positive += value > 0
            negative += value < 0
            work = [
                [
                    work[row][column]
                    - work[row][0] * work[0][column] / value
                    for column in range(1, len(work))
                ]
                for row in range(1, len(work))
            ]
            continue
        if not any(value for row in work for value in row):
            zero += len(work)
            break
        partner = next(
            index for index in range(1, len(work)) if work[0][index]
        )
        symmetric_swap(work, 1, partner)
        value = work[0][1]
        positive += 1
        negative += 1
        work = [
            [
                work[row][column]
                - (
                    work[row][0] * work[1][column]
                    + work[row][1] * work[0][column]
                )
                / value
                for column in range(2, len(work))
            ]
            for row in range(2, len(work))
        ]
    return [int(positive), int(negative), zero]


def pencil_at(metric, constant, value):
    return [
        [
            Fraction(value) * metric[row][column] - constant[row][column]
            for column in range(len(metric))
        ]
        for row in range(len(metric))
    ]


def encode_fraction(value):
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def matrix_hash(matrix):
    payload = "\n".join(
        ",".join(encode_fraction(value) for value in row)
        for row in matrix
    ) + "\n"
    return hashlib.sha256(payload.encode("ascii")).hexdigest()


def input_hash():
    return hashlib.sha256(INPUT.read_bytes()).hexdigest()


def hermite_data(polynomial, endpoints):
    metric = bezout_matrix(polynomial, derivative(polynomial))
    operator = companion(polynomial)
    constant = multiply(operator, metric)
    assert is_symmetric(constant)
    metric_inertia = inertia(metric)
    assert metric_inertia == [len(metric), 0, 0]
    table = {
        str(endpoint): inertia(pencil_at(metric, constant, endpoint))
        for endpoint in endpoints
    }
    counts = {}
    for left, right in zip(endpoints, endpoints[1:]):
        counts[f"({left},{right})"] = (
            table[str(right)][0] - table[str(left)][0]
        )
    return metric, constant, table, counts


def certificate():
    source = json.loads(INPUT.read_text(encoding="utf-8"))
    reduction = source["symbolic_reduction"]
    numerator = [
        Fraction(value)
        for value in reduction["mixing_numerator_coefficients_ascending"]
    ]
    denominator = [
        Fraction(value)
        for value in reduction["mixing_denominator_coefficients_ascending"]
    ]
    assert len(numerator) == 16
    assert len(denominator) == 4
    assert len(gcd_polynomial(numerator, denominator)) == 1

    boundary_metric = bezout_matrix(numerator, denominator)
    numerator_companion = companion(numerator)
    boundary_constant = multiply(numerator_companion, boundary_metric)
    assert is_symmetric(boundary_constant)
    boundary_inertia = inertia(boundary_metric)
    assert boundary_inertia == [8, 7, 0]

    endpoints = [-3, -2, -1, 0, 1]
    (
        numerator_metric,
        numerator_constant,
        numerator_table,
        numerator_counts,
    ) = hermite_data(numerator, endpoints)
    (
        denominator_metric,
        denominator_constant,
        denominator_table,
        denominator_counts,
    ) = hermite_data(denominator, endpoints)
    assert numerator_counts == {
        "(-3,-2)": 1,
        "(-2,-1)": 13,
        "(-1,0)": 0,
        "(0,1)": 1,
    }
    assert denominator_counts == {
        "(-3,-2)": 2,
        "(-2,-1)": 1,
        "(-1,0)": 0,
        "(0,1)": 0,
    }

    return {
        "schema": "c682-signed-boundary-pencil-v1",
        "input": {
            "path": INPUT.name,
            "sha256": input_hash(),
        },
        "signed_boundary_pencil": {
            "definition": (
                "L_D(s)=s Bez(N,D)-C_N Bez(N,D), with C_N the "
                "monomial companion of N"
            ),
            "dimension": len(boundary_metric),
            "coprime_pair": True,
            "metric_inertia": boundary_inertia,
            "metric_sha256": matrix_hash(boundary_metric),
            "constant_matrix_sha256": matrix_hash(boundary_constant),
            "constant_matrix_symmetric": True,
            "determinant_identity": (
                "det(L_D(s))/det(Bez(N,D))=N(s)/lc(N)"
            ),
            "interpretation": (
                "The reduced boundary denominator D canonically "
                "symmetrizes the numerator companion; the 8+7 signature "
                "is the intrinsic signed structure."
            ),
        },
        "intrinsic_sturm_pencils": {
            "numerator": {
                "definition": "L_N(s)=s Bez(N,N')-C_N Bez(N,N')",
                "metric_inertia": inertia(numerator_metric),
                "metric_sha256": matrix_hash(numerator_metric),
                "constant_matrix_sha256": matrix_hash(numerator_constant),
                "endpoint_inertias": numerator_table,
                "chamber_counts": numerator_counts,
            },
            "denominator": {
                "definition": "L_D0(s)=s Bez(D,D')-C_D Bez(D,D')",
                "metric_inertia": inertia(denominator_metric),
                "metric_sha256": matrix_hash(denominator_metric),
                "constant_matrix_sha256": matrix_hash(denominator_constant),
                "endpoint_inertias": denominator_table,
                "chamber_counts": denominator_counts,
            },
            "counting_rule": (
                "For the positive Hermite metric Bez(P,P'), "
                "n_+(L_P(b))-n_+(L_P(a)) counts roots of P in (a,b)."
            ),
        },
        "conclusion": (
            "The signed boundary symmetrizer has inertia (8,7), while "
            "positive Hermite pencils derive the exact numerator counts "
            "1|13|0|1 and denominator counts 2|1|0|0 on the chambers "
            "cut by -3,-2,-1,0,1."
        ),
        "claim_boundary": (
            "This constructs the scalar trivial-module boundary pencil. "
            "It does not yet construct the block pencils for 2,3,3'."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    rendered = json.dumps(certificate(), indent=2, sort_keys=True) + "\n"
    if arguments.write:
        OUTPUT.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {OUTPUT}")
    else:
        assert OUTPUT.read_text(encoding="utf-8") == rendered
        print("PASS: C682 signed boundary pencil")


if __name__ == "__main__":
    main()
