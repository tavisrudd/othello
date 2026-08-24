#!/usr/bin/env python3
"""Independent stdlib replay of the type-I1 saturated level-two certificate."""

import argparse
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path


def transpose(matrix):
    return [list(row) for row in zip(*matrix)]


def multiply(left, right):
    return [
        [sum(a*b for a, b in zip(row, column)) for column in transpose(right)]
        for row in left
    ]


def determinant(matrix):
    if len(matrix) == 1:
        return matrix[0][0]
    return sum(
        (-1)**column*matrix[0][column]*determinant([
            row[:column]+row[column+1:] for row in matrix[1:]
        ])
        for column in range(len(matrix))
    )


def columns_to_rows(columns):
    return transpose(columns)


def maximal_minor_gcd(columns):
    rows = columns_to_rows(columns)
    rank = len(columns)
    return math.gcd(*(
        abs(int(determinant([rows[index] for index in indices])))
        for indices in itertools.combinations(range(len(rows)), rank)
    ))


galois_generators = [
    [[-1, 1, 0, 0, 0], [0, 1, 0, 0, 0], [0, 1, -1, 0, 0],
     [-1, 0, -1, 0, 1], [-1, 2, -1, 1, 0]],
    [[0, -1, 0, 0, 0], [-1, 0, 0, 0, 0], [-1, -1, 0, -1, 1],
     [0, 0, 0, -1, 0], [-1, -1, 1, -1, 0]],
]
raw_columns = [[0, 0, 0, 1, 1], [0, 0, 1, 0, 1], [0, 0, 1, 1, 0]]
saturated_columns = [raw_columns[0], raw_columns[1], [0, 0, 1, 1, 1]]
assert [2*x for x in saturated_columns[2]] == [
    sum(raw_columns[column][row] for column in range(3)) for row in range(5)
]
assert maximal_minor_gcd(raw_columns) == 2
assert maximal_minor_gcd(saturated_columns) == 1

subtorus_actions = [
    [[1, 0, 1], [0, -1, 0], [0, 0, -1]],
    [[-1, 0, 0], [0, 1, 1], [0, 0, -1]],
]
for generator, action in zip(galois_generators, subtorus_actions):
    assert multiply(generator, columns_to_rows(saturated_columns)) == multiply(
        columns_to_rows(saturated_columns), action
    )

# The four surviving weights form a unimodular affine tetrahedron.
window_weights = [[0, 0, 1], [0, 1, 1], [1, 0, 1], [1, 1, 2]]
weight_differences = [
    [window_weights[column][row]-window_weights[0][row] for row in range(3)]
    for column in range(1, 4)
]
assert abs(determinant(columns_to_rows(weight_differences))) == 1

completion_columns = saturated_columns+[[1, 0, 0, 0, 0], [0, 1, 0, 0, 0]]
assert determinant(columns_to_rows(completion_columns)) == 1
completed_actions = [
    [[1, 0, 1, -1, 1], [0, -1, 0, 0, 2], [0, 0, -1, 0, -1],
     [0, 0, 0, -1, 1], [0, 0, 0, 0, 1]],
    [[-1, 0, 0, 0, 0], [0, 1, 1, -1, -1], [0, 0, -1, 0, 0],
     [0, 0, 0, 0, -1], [0, 0, 0, -1, 0]],
]
for generator, action in zip(galois_generators, completed_actions):
    assert multiply(generator, columns_to_rows(completion_columns)) == multiply(
        columns_to_rows(completion_columns), action
    )
residual_cocharacter_actions = [[row[3:] for row in action[3:]] for action in completed_actions]
assert residual_cocharacter_actions == [
    [[-1, 1], [0, 1]], [[0, -1], [-1, 0]],
]

slice_matrix = [
    [Fraction(-77, 15), Fraction(17, 84), 0, Fraction(-19, 660)],
    [Fraction(-77, 3), 0, 0, Fraction(1, 2)],
    [-11, 0, Fraction(2, 15), 0],
]
maximal_minors = [
    determinant([[row[column] for column in range(4) if column != omitted] for row in slice_matrix])
    for omitted in range(4)
]
assert maximal_minors == [
    Fraction(-17, 1260), Fraction(119, 270), Fraction(-187, 168), Fraction(187, 270)
]

certificate = {
    "schema": "c925-i1-level2-saturation-independent-check-v1",
    "raw_isotypic_basis_saturation_index": 2,
    "saturated_basis_index": 1,
    "stable_window_affine_lattice_index": 1,
    "ambient_completion_determinant": 1,
    "residual_torus_rank": 2,
    "slice_maximal_minors": [str(value) for value in maximal_minors],
    "conclusion": (
        "The actual three-sign subtorus lattice is saturated, its stable "
        "four-weight window is unimodular, the tangent slice has one open-orbit "
        "point, and the residual torus has rank two."
    ),
}

parser = argparse.ArgumentParser()
mode = parser.add_mutually_exclusive_group()
mode.add_argument("--write-certificate", type=Path)
mode.add_argument("--check-certificate", type=Path)
arguments = parser.parse_args()
payload = json.dumps(certificate, indent=2, sort_keys=True)+"\n"
if arguments.write_certificate:
    arguments.write_certificate.write_text(payload, encoding="utf-8")
if arguments.check_certificate:
    assert arguments.check_certificate.read_text(encoding="utf-8") == payload
print(payload, end="")
