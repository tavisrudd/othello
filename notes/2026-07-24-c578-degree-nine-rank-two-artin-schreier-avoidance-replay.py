#!/usr/bin/env python3
"""Independent replay for the compact C578 F_64 certificate."""

from __future__ import annotations

import json
from itertools import product
from pathlib import Path


HERE = Path(__file__).resolve().parent
DATA = json.loads(
    (HERE / "2026-07-24-c578-degree-nine-rank-two-artin-schreier-avoidance.json").read_text()
)
Q = 64
MODULUS = int(DATA["bounded_field"]["modulus_hex"], 16)


def multiply(left: int, right: int) -> int:
    value = 0
    a, b = left, right
    while b:
        if b & 1:
            value ^= a
        b >>= 1
        a <<= 1
        if a & Q:
            a ^= MODULUS
    return value


def power(value: int, exponent: int) -> int:
    result = 1
    while exponent:
        if exponent & 1:
            result = multiply(result, value)
        value = multiply(value, value)
        exponent >>= 1
    return result


def normalize(values: tuple[int, ...]) -> tuple[int, ...]:
    pivot = next(value for value in values if value)
    inverse = power(pivot, Q - 2)
    return tuple(multiply(value, inverse) for value in values)


def determinant(matrix: tuple[int, int, int, int]) -> int:
    a, b, c, d = matrix
    return multiply(a, d) ^ multiply(b, c)


def act(
    point: tuple[int, int, int, int],
    matrix: tuple[int, int, int, int],
) -> tuple[int, int, int, int]:
    a, b, c, d = matrix
    af, bf, cf, df = (power(value, 4) for value in matrix)
    x, y, z, w = point
    left = (
        multiply(af, x) ^ multiply(bf, z),
        multiply(af, y) ^ multiply(bf, w),
        multiply(cf, x) ^ multiply(df, z),
        multiply(cf, y) ^ multiply(df, w),
    )
    return normalize(
        (
            multiply(left[0], a) ^ multiply(left[1], b),
            multiply(left[0], c) ^ multiply(left[1], d),
            multiply(left[2], a) ^ multiply(left[3], b),
            multiply(left[2], c) ^ multiply(left[3], d),
        )
    )


def projective_matrices():
    for lead in range(4):
        for tail in product(range(Q), repeat=3 - lead):
            matrix = (0,) * lead + (1,) + tail
            if determinant(matrix):
                yield matrix


def polynomial_from_roots(roots: list[int]) -> list[int]:
    coefficients = [1]
    for root in roots:
        nxt = [0] * (len(coefficients) + 1)
        for index, coefficient in enumerate(coefficients):
            nxt[index] ^= multiply(coefficient, root)
            nxt[index + 1] ^= coefficient
        coefficients = nxt
    return coefficients + [0] * (9 - len(coefficients))


def check_kernel(point: tuple[int, ...], coefficients: list[int]) -> None:
    first = 0
    second = 0
    for value, index in zip(point, (2, 3, 6, 7)):
        first ^= multiply(value, coefficients[index - 1])
        second ^= multiply(value, coefficients[index])
    assert first == second == 0


def main() -> None:
    field = DATA["bounded_field"]
    twists = field["twists"]
    representatives = [
        tuple(int(value, 16) for value in item["representative_hex"])
        for item in twists
    ]
    expected_centralizers = [item["centralizer_order"] for item in twists]
    stabilizers = [0] * len(twists)
    square_targets = [normalize(tuple(multiply(x, x) for x in rep)) for rep in representatives]
    transport = [[False] * len(twists) for _ in twists]
    matrix_count = 0
    for matrix in projective_matrices():
        matrix_count += 1
        for source, representative in enumerate(representatives):
            image = act(representative, matrix)
            if image == representative:
                stabilizers[source] += 1
            for target, square_target in enumerate(square_targets):
                if image == square_target:
                    transport[source][target] = True
    assert matrix_count == Q * (Q * Q - 1)
    assert stabilizers == expected_centralizers
    assert sum(matrix_count // order for order in stabilizers) == matrix_count

    # Coefficient Frobenius fixes 1A/2A/3A and exchanges the two order-five classes.
    assert all(transport[index][index] for index in range(3))
    assert transport[3][4] and transport[4][3]

    for item, representative in zip(twists, representatives):
        encoded_roots = item["roots_hex"]
        assert len(encoded_roots) == len(set(encoded_roots)) == 8
        roots = [int(value, 16) for value in encoded_roots if value != "inf"]
        coefficients = polynomial_from_roots(roots)
        recorded = [int(value, 16) for value in item["coefficients_low_to_high_hex"]]
        assert coefficients == recorded
        check_kernel(representative, coefficients)

    bounds = DATA["structural_bound"]
    assert bounds == {
        "deleted_curve_points_upper_bound": 48,
        "deleted_x_values_upper_bound": 23,
        "fiber_genus_upper_bound": 1,
        "first_theorem_power_of_two": 128,
        "five_root_bad_degree": 102,
        "hasse_lower_at_q64": 49,
    }
    print("C578 replay passed: 5 twists, complete F_64 mass, witnesses, and bounds")


if __name__ == "__main__":
    main()
