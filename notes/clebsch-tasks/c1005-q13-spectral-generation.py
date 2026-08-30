#!/usr/bin/env python3
"""Exact spectral-generation certificate for the q=13 pair matrix.

The construction is independent of the minimum-support enumeration: it uses
the intrinsic internal-point model, the six rho relations, and the proved
rho-to-concurrence table from Paper IV.
"""

from __future__ import annotations

import argparse
import json
from collections import Counter
from fractions import Fraction
from pathlib import Path


Q = 13
MODULUS = 1_000_003
CONCURRENCE = {0: 8, 1: 6, 3: 6, 9: 12, 10: 7, 12: 9}


def projective_points() -> list[tuple[int, int, int]]:
    return (
        [(1, y, z) for y in range(Q) for z in range(Q)]
        + [(0, 1, z) for z in range(Q)]
        + [(0, 0, 1)]
    )


def delta(point: tuple[int, int, int]) -> int:
    x, y, z = point
    return (y * y - x * z) % Q


def internal_points() -> list[tuple[int, int, int]]:
    nonzero_squares = {value * value % Q for value in range(1, Q)}
    return [
        point
        for point in projective_points()
        if delta(point) not in nonzero_squares | {0}
    ]


def rho(
    first: tuple[int, int, int], second: tuple[int, int, int]
) -> int:
    x, y, z = first
    u, v, w = second
    beta = (2 * y * v - x * w - z * u) % Q
    return (
        beta
        * beta
        * pow(delta(first) * delta(second), -1, Q)
        % Q
    )


Matrix = list[list[int]]


def identity(size: int) -> Matrix:
    return [[int(first == second) for second in range(size)] for first in range(size)]


def multiply(first: Matrix, second: Matrix) -> Matrix:
    columns = list(zip(*second))
    return [
        [sum(x * y for x, y in zip(row, column)) for column in columns]
        for row in first
    ]


def canonical_pivots(
    powers: list[Matrix], modulus: int
) -> list[tuple[int, int]]:
    """Lexicographic pivot entries proving powers 0,...,6 independent mod p."""
    def rank_mod(rows: list[list[int]]) -> int:
        work = [[entry % modulus for entry in row] for row in rows]
        rank = 0
        for column in range(7):
            pivot = next(
                (
                    row
                    for row in range(rank, len(work))
                    if work[row][column]
                ),
                None,
            )
            if pivot is None:
                continue
            work[rank], work[pivot] = work[pivot], work[rank]
            inverse = pow(work[rank][column], -1, modulus)
            work[rank] = [entry * inverse % modulus for entry in work[rank]]
            for row in range(len(work)):
                if row == rank or not work[row][column]:
                    continue
                factor = work[row][column]
                work[row] = [
                    (entry - factor * pivot_entry) % modulus
                    for entry, pivot_entry in zip(work[row], work[rank])
                ]
            rank += 1
        return rank

    size = len(powers[0])
    selected_rows: list[list[int]] = []
    pivots: list[tuple[int, int]] = []
    for flat_index in range(size * size):
        first, second = divmod(flat_index, size)
        row = [power[first][second] % modulus for power in powers[:7]]
        if rank_mod([*selected_rows, row]) == len(selected_rows):
            continue
        selected_rows.append(row)
        pivots.append((first, second))
        if len(selected_rows) == 7:
            return pivots
    raise AssertionError("the first seven powers were not independent")


def solve_exact(matrix: Matrix, rhs: list[int]) -> list[int]:
    size = len(matrix)
    augmented = [
        [Fraction(entry) for entry in row + [value]]
        for row, value in zip(matrix, rhs)
    ]
    for column in range(size):
        pivot = next(
            row for row in range(column, size) if augmented[row][column]
        )
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        scale = augmented[column][column]
        augmented[column] = [entry / scale for entry in augmented[column]]
        for row in range(size):
            if row == column or not augmented[row][column]:
                continue
            factor = augmented[row][column]
            augmented[row] = [
                entry - factor * pivot_entry
                for entry, pivot_entry in zip(augmented[row], augmented[column])
            ]
    result = [augmented[index][-1] for index in range(size)]
    assert all(value.denominator == 1 for value in result)
    return [value.numerator for value in result]


def determinant_bareiss(matrix: Matrix) -> int:
    work = [row[:] for row in matrix]
    sign = 1
    previous = 1
    for column in range(len(work) - 1):
        if work[column][column] == 0:
            pivot = next(
                row
                for row in range(column + 1, len(work))
                if work[row][column]
            )
            work[column], work[pivot] = work[pivot], work[column]
            sign = -sign
        diagonal = work[column][column]
        for row in range(column + 1, len(work)):
            for index in range(column + 1, len(work)):
                work[row][index] = (
                    work[row][index] * diagonal
                    - work[row][column] * work[column][index]
                ) // previous
        previous = diagonal
    return sign * work[-1][-1]


def compute() -> dict[str, object]:
    points = internal_points()
    assert len(points) == 78
    size = len(points)
    matrix = [
        [
            0
            if first == second
            else CONCURRENCE[rho(points[first], points[second])]
            for second in range(size)
        ]
        for first in range(size)
    ]
    distribution = Counter(
        matrix[first][second]
        for first in range(size)
        for second in range(first)
    )
    assert distribution == Counter({6: 1092, 7: 546, 8: 273, 9: 546, 12: 546})

    powers = [identity(size)]
    for _ in range(7):
        powers.append(multiply(powers[-1], matrix))

    pivots = canonical_pivots(powers, MODULUS)
    minor = [
        [powers[exponent][first][second] for exponent in range(7)]
        for first, second in pivots
    ]
    determinant = determinant_bareiss(minor)
    assert determinant % MODULUS == 694_500
    assert determinant != 0

    rhs = [powers[7][first][second] for first, second in pivots]
    coefficients = solve_exact(minor, rhs)
    assert all(
        powers[7][first][second]
        == sum(
            coefficients[exponent] * powers[exponent][first][second]
            for exponent in range(7)
        )
        for first in range(size)
        for second in range(size)
    )

    return {
        "schema": "c1005-q13-spectral-generation-v1",
        "field_order": Q,
        "point_order": (
            "(1,y,z), then (0,1,z), then (0,0,1), filtered to internal points"
        ),
        "point_count": size,
        "pair_concurrence_distribution": {
            str(value): count for value, count in sorted(distribution.items())
        },
        "ordinary_power_span": {
            "dimension": 7,
            "conclusion": (
                "Q[M] is the full seven-dimensional elliptic "
                "Bose--Mesner algebra"
            ),
            "independence_modulus": MODULUS,
            "canonical_pivot_entries": [list(pair) for pair in pivots],
            "pivot_minor_determinant": determinant,
            "pivot_minor_determinant_mod_p": determinant % MODULUS,
            "M7_coefficients_c0_through_c6": coefficients,
            "minimal_polynomial_coefficients_high_to_low": [
                1,
                *[-coefficients[index] for index in range(6, -1, -1)],
            ],
            "exact_matrix_identity_checked": True,
        },
        "independent_cross_check": (
            "The concurrence distribution agrees with the support-orbit "
            "enumeration in verification/pair_reconstruction.json."
        ),
    }


def render(result: dict[str, object]) -> str:
    return json.dumps(result, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", type=Path)
    parser.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    output = render(compute())
    if arguments.write:
        arguments.write.write_text(output, encoding="utf-8")
    elif arguments.check:
        assert arguments.check.read_text(encoding="utf-8") == output
        print("C1005 q=13 spectral-generation certificate: PASS")
    else:
        print(output, end="")


if __name__ == "__main__":
    main()
