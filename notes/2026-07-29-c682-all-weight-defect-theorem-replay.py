#!/usr/bin/env python3
"""Independent numerical replay of the C682 all-weight defect theorem."""

from __future__ import annotations

import json
from math import comb, factorial
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-29-c682-all-weight-defect-theorem.json"
TEST_DEGREES = (53, 54, 67, 97, 211)


def falling(value: int, order: int) -> int:
    out = 1
    for offset in range(order):
        out *= value - offset
    return out


def delta_coefficient(degree: int, index: int, y_degree: int) -> int:
    klein_coefficient = {1: 1, 6: 11, 11: -1}[y_degree]
    x_degree = 12 - y_degree
    out = 0
    for step in range(4):
        out += (
            (-1) ** step
            * comb(3, step)
            * falling(degree - index, 3 - step)
            * falling(index, step)
            * falling(x_degree, step)
            * falling(y_degree, 3 - step)
            * klein_coefficient
        )
    return out


def fischer_weight(degree: int, index: int) -> int:
    return factorial(degree - index) * factorial(index)


def rows(degree: int, center: int) -> tuple[list[int], list[int]]:
    upper = [
        delta_coefficient(degree, center - 5, 11),
        delta_coefficient(degree, center, 6),
        delta_coefficient(degree, center + 5, 1),
    ]
    lower_source = center - 3
    lower = []
    for y_degree in (1, 6, 11):
        target = lower_source + y_degree - 3
        lower.append(
            delta_coefficient(degree - 6, lower_source, y_degree)
            * fischer_weight(degree, target)
            // fischer_weight(degree - 6, lower_source)
        )
    return upper, lower


def determinant(matrix: list[list[int]]) -> int:
    work = [row[:] for row in matrix]
    previous = 1
    sign = 1
    for pivot_index in range(len(work) - 1):
        if work[pivot_index][pivot_index] == 0:
            swap = next(
                row
                for row in range(pivot_index + 1, len(work))
                if work[row][pivot_index]
            )
            work[pivot_index], work[swap] = work[swap], work[pivot_index]
            sign = -sign
        pivot = work[pivot_index][pivot_index]
        for row in range(pivot_index + 1, len(work)):
            for column in range(pivot_index + 1, len(work)):
                work[row][column] = (
                    work[row][column] * pivot
                    - work[row][pivot_index] * work[pivot_index][column]
                ) // previous
        previous = pivot
    return sign * work[-1][-1]


def evaluate_descending(coefficients: list[int], value: int) -> int:
    out = 0
    for coefficient in coefficients:
        out = out * value + coefficient
    return out


def expected(row: dict, degree: int) -> int:
    out = row["content"]
    for root in row["linear_roots"]:
        out *= degree - root
    return out * evaluate_descending(
        row["nonlinear_coefficients_descending"],
        degree,
    )


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    for row in certificate["determinant_rows"]:
        center = row["first_center"]
        prime = row["root_exclusion_prime"]
        assert all(
            evaluate_descending(
                row["nonlinear_coefficients_descending"],
                residue,
            )
            % prime
            for residue in range(prime)
        )
        for degree in TEST_DEGREES:
            upper, lower = rows(degree, center)
            upper_next, lower_next = rows(degree, center + 5)
            matrix = [
                upper + [0],
                lower + [0],
                [0] + upper_next,
                [0] + lower_next,
            ]
            assert determinant(matrix) == expected(row, degree)
    print("PASS: independent C682 all-weight defect replay")


if __name__ == "__main__":
    main()
