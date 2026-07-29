#!/usr/bin/env python3
"""Independent replay of the C682 D5/S3 incidence identifications."""

from __future__ import annotations

import itertools
import json
import math
from pathlib import Path


NOTES = Path(__file__).resolve().parent
RANK_CERTIFICATE = NOTES / "2026-07-28-c682-rank-four-resolvent.json"
DEFORMATION_CERTIFICATE = (
    NOTES / "2026-07-28-c682-transvectant-deformation-map.json"
)
PRIME = 11


def rref(matrix):
    result = [[value % PRIME for value in row] for row in matrix]
    pivots = []
    pivot_row = 0
    if not result:
        return result, pivots
    for column in range(len(result[0])):
        pivot = next(
            (
                row
                for row in range(pivot_row, len(result))
                if result[row][column]
            ),
            None,
        )
        if pivot is None:
            continue
        result[pivot_row], result[pivot] = result[pivot], result[pivot_row]
        inverse = pow(result[pivot_row][column], -1, PRIME)
        result[pivot_row] = [
            inverse * value % PRIME for value in result[pivot_row]
        ]
        for row in range(len(result)):
            if row == pivot_row or not result[row][column]:
                continue
            scale = result[row][column]
            result[row] = [
                (left - scale * right) % PRIME
                for left, right in zip(result[row], result[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(result):
            break
    return result, pivots


def rank(matrix):
    reduced, _ = rref(matrix)
    return sum(any(row) for row in reduced)


def nullspace(matrix):
    reduced, pivots = rref(matrix)
    columns = len(matrix[0])
    free = [column for column in range(columns) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * columns
        vector[free_column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][free_column] % PRIME
        basis.append(vector)
    return basis


def apolar_annihilator(planes):
    equations = []
    for vector in planes:
        equations.append(
            [
                (
                    vector[6 - column]
                    * (-1) ** (6 - column)
                    * math.factorial(6 - column)
                    * math.factorial(column)
                )
                % PRIME
                for column in range(7)
            ]
        )
    return nullspace(equations)


def normalize(vector):
    first = next(value for value in vector if value)
    inverse = pow(first, -1, PRIME)
    return tuple(inverse * value % PRIME for value in vector)


def q_coordinates(vector, frame):
    augmented = [
        [frame[column][row] for column in range(5)] + [vector[row]]
        for row in range(7)
    ] + [[1, 1, 1, 1, 1, 0]]
    reduced, pivots = rref(augmented)
    assert pivots[:5] == [0, 1, 2, 3, 4]
    solution = [0] * 5
    for row, pivot in enumerate(pivots):
        if pivot < 5:
            solution[pivot] = reduced[row][-1]
    return solution


def main():
    rank_data = json.loads(RANK_CERTIFICATE.read_text(encoding="utf-8"))
    deformation_data = json.loads(
        DEFORMATION_CERTIFICATE.read_text(encoding="utf-8")
    )
    points = rank_data["explicit_resolvent"]["points"]
    by_size = {
        len(orbit): orbit
        for orbit in rank_data["A5_orbits"]["point_index_orbits"]
    }
    frame = deformation_data["ej_rank_drop_clebsch_frame"][
        "clebsch_frame_with_first_vector_xyz_and_sum_zero"
    ]
    radial = points[by_size[1][0]]["kernel_rref"]

    d5_lines = []
    for index in by_size[6]:
        common = apolar_annihilator(radial + points[index]["kernel_rref"])
        assert len(common) == 2
        coordinates = [q_coordinates(vector, frame) for vector in common]
        left, right = coordinates
        coefficients = [
            sum(value**3 for value in left),
            3 * sum(left[i] ** 2 * right[i] for i in range(5)),
            3 * sum(left[i] * right[i] ** 2 for i in range(5)),
            sum(value**3 for value in right),
        ]
        assert all(value % PRIME == 0 for value in coefficients)
        d5_lines.append(common)
    assert all(
        rank(left + right) == 4
        for left, right in itertools.combinations(d5_lines, 2)
    )

    expected_sums = {
        normalize(
            [
                (frame[left][coordinate] + frame[right][coordinate])
                % PRIME
                for coordinate in range(7)
            ]
        )
        for left, right in itertools.combinations(range(5), 2)
    }
    expected_differences = {
        normalize(
            [
                (frame[left][coordinate] - frame[right][coordinate])
                % PRIME
                for coordinate in range(7)
            ]
        )
        for left, right in itertools.combinations(range(5), 2)
    }
    observed_sums = set()
    for index in by_size[10]:
        common = apolar_annihilator(radial + points[index]["kernel_rref"])
        assert len(common) == 1
        line = normalize(common[0])
        assert line not in expected_differences
        coordinates = q_coordinates(common[0], frame)
        assert sum(value**3 for value in coordinates) % PRIME
        observed_sums.add(line)
    assert observed_sums == expected_sums
    print("C682 incidence-moduli independent replay: PASS")


if __name__ == "__main__":
    main()
