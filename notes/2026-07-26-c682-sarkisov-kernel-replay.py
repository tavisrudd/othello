#!/usr/bin/env python3
"""Independent finite-field replay of the C682 Sarkisov-kernel audit."""

from __future__ import annotations

import itertools
import json
import math
from pathlib import Path


PRIME = 101
HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-26-c682-sarkisov-kernel.json"


def falling(number: int, order: int) -> int:
    if order < 0 or order > number:
        return 0
    return math.prod(range(number - order + 1, number + 1))


def transvectant(left: list[int], right: list[int], order: int) -> list[int]:
    left_degree = len(left) - 1
    right_degree = len(right) - 1
    result = [0] * (left_degree + right_degree - 2 * order + 1)
    for left_index, left_coefficient in enumerate(left):
        for right_index, right_coefficient in enumerate(right):
            for index in range(order + 1):
                output_index = left_index + right_index - order
                if not 0 <= output_index < len(result):
                    continue
                result[output_index] += (
                    (-1) ** index
                    * math.comb(order, index)
                    * falling(left_degree - left_index, order - index)
                    * falling(left_index, index)
                    * falling(right_degree - right_index, index)
                    * falling(right_index, order - index)
                    * left_coefficient
                    * right_coefficient
                )
    return [entry % PRIME for entry in result]


def transform(form: list[int], matrix: tuple[int, int, int, int]) -> list[int]:
    degree = len(form) - 1
    a, b, c, d = matrix
    result = [0] * (degree + 1)
    for form_index, form_coefficient in enumerate(form):
        for first_y_count in range(degree - form_index + 1):
            for second_y_count in range(form_index + 1):
                output_index = first_y_count + second_y_count
                result[output_index] += (
                    form_coefficient
                    * math.comb(degree - form_index, first_y_count)
                    * pow(a, degree - form_index - first_y_count, PRIME)
                    * pow(b, first_y_count, PRIME)
                    * math.comb(form_index, second_y_count)
                    * pow(c, form_index - second_y_count, PRIME)
                    * pow(d, second_y_count, PRIME)
                )
    return [entry % PRIME for entry in result]


def operator_matrix(
    form: list[int], domain_degree: int, order: int
) -> list[list[int]]:
    columns = []
    for index in range(domain_degree + 1):
        basis = [0] * (domain_degree + 1)
        basis[index] = 1
        columns.append(transvectant(basis, form, order))
    return [list(row) for row in zip(*columns)]


def rank(matrix: list[list[int]]) -> int:
    work = [[entry % PRIME for entry in row] for row in matrix]
    pivot_row = 0
    for column in range(len(work[0])):
        pivot = next(
            (
                row
                for row in range(pivot_row, len(work))
                if work[row][column]
            ),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, PRIME)
        work[pivot_row] = [
            entry * inverse % PRIME for entry in work[pivot_row]
        ]
        for row in range(len(work)):
            if row == pivot_row:
                continue
            multiplier = work[row][column]
            work[row] = [
                (entry - multiplier * pivot_entry) % PRIME
                for entry, pivot_entry in zip(
                    work[row], work[pivot_row]
                )
            ]
        pivot_row += 1
    return pivot_row


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    assert certificate["prime_replay"]["prime"] == PRIME
    klein = certificate["source"]["klein_dodecic"]
    cancellation = certificate["map"]["unnormalized_cancellation"]
    sixth_power = [1] + [0] * 6

    # Independent bounded evaluation of the generic Laurent identity.
    chart_points = 0
    for a in range(1, 6):
        for b in range(5):
            for c in range(5):
                d = (1 + b * c) * pow(a, -1, PRIME) % PRIME
                orbit_form = transform(klein, (a, b, c, d))
                image = transvectant(orbit_form, sixth_power, 6)
                image[0] = (image[0] - cancellation) % PRIME
                assert transvectant(image, image, 4) == [0] * 5
                chart_points += 1

    # Exhaust the F_101-points of the center normalization P^1.
    center_points = 0
    parameters = [(1, value) for value in range(PRIME)] + [(0, 1)]
    for s, t in parameters:
        center = [
            math.comb(5, index)
            * pow(s, 5 - index, PRIME)
            * pow(t, index, PRIME)
            % PRIME
            for index in range(6)
        ] + [0]
        kernel_two = [
            s * s,
            2 * s * t,
            t * t,
            0,
            0,
        ]
        kernel_three = [
            0,
            2 * pow(s, 3, PRIME),
            5 * s * s * t,
            4 * s * t * t,
            pow(t, 3, PRIME),
        ]
        assert rank(operator_matrix(center, 4, 2)) == 3
        assert transvectant(kernel_two, center, 2) == [0] * 7
        assert transvectant(kernel_three, center, 2) == [0] * 7
        assert transvectant(kernel_two, kernel_three, 3) == [0] * 3
        assert rank([kernel_two, kernel_three]) == 2
        center_points += 1

    assert chart_points == certificate["prime_replay"]["chart_points"]
    assert center_points == certificate["prime_replay"]["p1_points"]
    print(
        "PASS: independent mod-101 replay;",
        chart_points,
        "SL2-chart points and",
        center_points,
        "center points",
    )


if __name__ == "__main__":
    main()
