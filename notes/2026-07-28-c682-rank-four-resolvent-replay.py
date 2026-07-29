#!/usr/bin/env python3
"""Independent invariant replay for the C682 rank-four resolvent."""

from __future__ import annotations

import itertools
import json
import math
from pathlib import Path


CERTIFICATE = Path(__file__).with_name(
    "2026-07-28-c682-rank-four-resolvent.json"
)
PRIME = 11


def rank(matrix):
    if not matrix:
        return 0
    reduced = [[value % PRIME for value in row] for row in matrix]
    pivot_row = 0
    for column in range(len(reduced[0])):
        pivot = next(
            (
                row
                for row in range(pivot_row, len(reduced))
                if reduced[row][column]
            ),
            None,
        )
        if pivot is None:
            continue
        reduced[pivot_row], reduced[pivot] = (
            reduced[pivot],
            reduced[pivot_row],
        )
        scale = pow(reduced[pivot_row][column], -1, PRIME)
        reduced[pivot_row] = [
            scale * value % PRIME for value in reduced[pivot_row]
        ]
        for row in range(len(reduced)):
            if row == pivot_row or reduced[row][column] == 0:
                continue
            scale = reduced[row][column]
            reduced[row] = [
                (left - scale * right) % PRIME
                for left, right in zip(reduced[row], reduced[pivot_row])
            ]
        pivot_row += 1
    return pivot_row


def nullspace(matrix):
    reduced = [[value % PRIME for value in row] for row in matrix]
    rows = len(reduced)
    columns = len(reduced[0])
    pivot_row = 0
    pivots = []
    for column in range(columns):
        pivot = next(
            (
                row
                for row in range(pivot_row, rows)
                if reduced[row][column]
            ),
            None,
        )
        if pivot is None:
            continue
        reduced[pivot_row], reduced[pivot] = (
            reduced[pivot],
            reduced[pivot_row],
        )
        scale = pow(reduced[pivot_row][column], -1, PRIME)
        reduced[pivot_row] = [
            scale * value % PRIME for value in reduced[pivot_row]
        ]
        for row in range(rows):
            if row == pivot_row or reduced[row][column] == 0:
                continue
            scale = reduced[row][column]
            reduced[row] = [
                (left - scale * right) % PRIME
                for left, right in zip(reduced[row], reduced[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
    free = [column for column in range(columns) if column not in pivots]
    answer = []
    for free_column in free:
        vector = [0] * columns
        vector[free_column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][free_column] % PRIME
        answer.append(vector)
    return answer


def matrix_multiply(left, right):
    return [
        [
            sum(
                left[row][middle] * right[middle][column]
                for middle in range(len(right))
            )
            % PRIME
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def matrix_inverse(matrix):
    size = len(matrix)
    augmented = [
        row[:]
        + [int(row_index == column) for column in range(size)]
        for row_index, row in enumerate(matrix)
    ]
    assert rank(augmented) == size
    for column in range(size):
        pivot = next(
            row
            for row in range(column, size)
            if augmented[row][column] % PRIME
        )
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        scale = pow(augmented[column][column], -1, PRIME)
        augmented[column] = [
            scale * value % PRIME for value in augmented[column]
        ]
        for row in range(size):
            if row == column or augmented[row][column] == 0:
                continue
            scale = augmented[row][column]
            augmented[row] = [
                (left - scale * right) % PRIME
                for left, right in zip(augmented[row], augmented[column])
            ]
    return [row[size:] for row in augmented]


def matrix_vector(matrix, vector):
    return [
        sum(row[column] * vector[column] for column in range(len(vector)))
        % PRIME
        for row in matrix
    ]


def normalize_projective(vector):
    pivot = next(value for value in vector if value)
    scale = pow(pivot, -1, PRIME)
    return tuple(scale * value % PRIME for value in vector)


def exponent_vectors(total: int, variables: int = 10, prefix=()):
    if variables == 1:
        return [prefix + (total,)]
    return [
        exponent
        for value in range(total, -1, -1)
        for exponent in exponent_vectors(
            total - value, variables - 1, prefix + (value,)
        )
    ]


def evaluate(point, exponent):
    return math.prod(
        pow(point[index], exponent[index], PRIME)
        for index in range(len(exponent))
    ) % PRIME


def falling(value, order):
    answer = 1
    for offset in range(order):
        answer *= value - offset
    return answer


def fifth_pair(left, right):
    output = [0, 0, 0]
    for left_y, left_coefficient in enumerate(left):
        for right_y, right_coefficient in enumerate(right):
            for index in range(6):
                output_y = left_y - index + right_y - (5 - index)
                if not 0 <= output_y <= 2:
                    continue
                output[output_y] += (
                    (-1) ** index
                    * math.comb(5, index)
                    * left_coefficient
                    * falling(6 - left_y, 5 - index)
                    * falling(left_y, index)
                    * right_coefficient
                    * falling(6 - right_y, index)
                    * falling(right_y, 5 - index)
                )
    return [value % PRIME for value in output]


def parameter_point(t, s):
    return (
        1,
        t,
        5 * t**2 % PRIME,
        4 * t**3 % PRIME,
        8 * t**4 % PRIME,
        (10 + 9 * t**5 + s) % PRIME,
        (9 * t**6 + 6 * s * t) % PRIME,
        (8 * t**7 + 4 * s * t**2) % PRIME,
        (4 * t**8 + 9 * s * t**3) % PRIME,
        (5 * t**9 + 4 * s * t**4) % PRIME,
    )


def operator_at(point, basis):
    return [
        [
            sum(
                point[index] * basis[index][row][column]
                for index in range(10)
            )
            % PRIME
            for column in range(7)
        ]
        for row in range(13)
    ]


def tangent_rank(matrix, basis):
    right_kernel = nullspace(matrix)
    left_kernel = nullspace(
        [list(column) for column in zip(*matrix)]
    )
    equations = []
    for left in left_kernel:
        for right in right_kernel:
            equations.append(
                [
                    sum(
                        left[row]
                        * sum(
                            direction[row][column] * right[column]
                            for column in range(7)
                        )
                        for row in range(13)
                    )
                    % PRIME
                    for direction in basis
                ]
            )
    return rank(equations)


def main():
    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    basis = certificate["operator_pencil"]["operator_basis"]
    rows = certificate["explicit_resolvent"]["points"]
    points = sorted(
        parameter_point(t, s)
        for t in range(PRIME)
        for s in (1, -1)
    )
    assert points == sorted(
        tuple(row["extended_normal_line"]) for row in rows
    )
    assert len(set(points)) == 22

    for point in points:
        operator = operator_at(point, basis)
        kernel = nullspace(operator)
        assert rank(operator) == 4
        assert len(kernel) == 3
        assert all(
            fifth_pair(kernel[left], kernel[right]) == [0, 0, 0]
            for left in range(3)
            for right in range(left + 1, 3)
        )
        assert tangent_rank(operator, basis) == 9

    macaulay = certificate["macaulay_certificate"]
    degree_five = exponent_vectors(5)
    degree_six = exponent_vectors(6)
    standard_five = [
        degree_five[index]
        for index in macaulay["quintic_standard_monomial_indices"]
    ]
    standard_six = [
        degree_six[index]
        for index in macaulay["sextic_standard_monomial_indices"]
    ]
    evaluation_five = [
        [evaluate(point, exponent) for exponent in standard_five]
        for point in points
    ]
    evaluation_six = [
        [evaluate(point, exponent) for exponent in standard_six]
        for point in points
    ]
    assert rank(evaluation_five) == rank(evaluation_six) == 22
    multiplication = macaulay["multiplication_matrices_degree_5_to_6"]
    for variable in range(10):
        for point_index, point in enumerate(points):
            for source in range(22):
                assert (
                    sum(
                        multiplication[variable][source][target]
                        * evaluation_six[point_index][target]
                        for target in range(22)
                    )
                    - point[variable] * evaluation_five[point_index][source]
                ) % PRIME == 0
    assert rank(multiplication[0]) == 22

    corrected = certificate["corrected_1_plus_5_theorem"]
    intertwiner = corrected["intertwiner_pair_to_extended_normal"]
    inverse_intertwiner = matrix_inverse(intertwiner)
    star = [
        [int(vertex in pair) for vertex in range(5)]
        for pair in itertools.combinations(range(5), 2)
    ]
    pair_edges = list(itertools.combinations(range(5), 2))
    star_indices = []
    point_sheets = {}
    for index, point in enumerate(points):
        pair_point = matrix_vector(inverse_intertwiner, point)
        if rank([star[row] + [pair_point[row]] for row in range(10)]) == 5:
            star_indices.append(index)
        total_square = sum(pair_point) ** 2 % PRIME
        diagonal = sum(value**2 for value in pair_point) % PRIME
        adjacent = sum(
            pair_point[left] * pair_point[right]
            for left in range(10)
            for right in range(left + 1, 10)
            if set(pair_edges[left]) & set(pair_edges[right])
        ) % PRIME
        sheet = (point[5] - 10 - 9 * point[1] ** 5) % PRIME
        assert (
            7 * total_square + 9 * diagonal + 10 * adjacent
        ) % PRIME == sheet
        point_sheets[point] = sheet
    assert star_indices == corrected["point_indices"]
    assert len(star_indices) == 6

    generators = certificate["A5_orbits"]["generator_actions"]
    unseen = set(points)
    orbit_sizes = []
    orbit_sheets = []
    while unseen:
        orbit = {min(unseen)}
        frontier = list(orbit)
        while frontier:
            point = frontier.pop()
            for generator in generators:
                image = normalize_projective(
                    matrix_vector(generator, point)
                )
                if image not in orbit:
                    orbit.add(image)
                    frontier.append(image)
        unseen -= orbit
        orbit_sizes.append(len(orbit))
        orbit_sheets.append({point_sheets[point] for point in orbit})
    assert sorted(orbit_sizes) == [1, 5, 6, 10]
    assert sorted(
        (next(iter(sheet)), size)
        for sheet, size in zip(orbit_sheets, orbit_sizes)
    ) == [(1, 1), (1, 10), (10, 5), (10, 6)]
    print(
        "PASS independent C682 replay: 22 explicit reduced rank-four "
        "isotropic points, quadratic sheets (1+10)/(5+6), "
        "and star-sum section 1+5"
    )


if __name__ == "__main__":
    main()
