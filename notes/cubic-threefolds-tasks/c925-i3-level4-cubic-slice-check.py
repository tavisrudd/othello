#!/usr/bin/env python3
"""Exact full-I3 certificate for the C925 cubic-orbit level-four slice."""

import argparse
import json
from pathlib import Path

import sympy as sp


CHARACTER_GENERATORS = (
    sp.Matrix([
        [-1, 0, 0, -1, -1],
        [1, 1, 1, 0, 2],
        [0, 0, -1, -1, -1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 1, 0],
    ]),
    sp.Matrix([
        [0, 1, 1, 1, 2],
        [-1, -1, 0, 0, -1],
        [0, 0, 1, 0, 0],
        [0, 0, 0, 1, 0],
        [0, 0, -1, -1, -1],
    ]),
)
COCHARACTER_GENERATORS = tuple(
    generator.inv().T for generator in CHARACTER_GENERATORS
)


def matrix_key(matrix):
    return tuple(int(entry) for entry in matrix)


group = {matrix_key(sp.eye(5)): sp.eye(5)}
queue = [sp.eye(5)]
while queue:
    value = queue.pop()
    for generator in COCHARACTER_GENERATORS:
        for product in (value * generator, generator * value):
            key = matrix_key(product)
            if key not in group:
                group[key] = product
                queue.append(product)
assert len(group) == 24

ROOT_BASIS = sp.Matrix.hstack(
    sp.Matrix([0, 1, 0, 0, 0, -1]),
    sp.Matrix([0, 0, 1, 0, 0, -1]),
    sp.Matrix([0, 0, 0, 1, 0, -1]),
    sp.Matrix([0, 0, 0, 0, 1, -1]),
    sp.Matrix([1, 0, 0, 0, 0, -3]),
)

cocharacter = sp.Matrix([0, 0, 1, 1, 0])
assert [generator * cocharacter for generator in COCHARACTER_GENERATORS] == [
    -cocharacter, cocharacter
]

# Lift modulo the anticanonical scalar, in H,E1,...,E5 coordinates.
lift = sp.Matrix([[0, 0, 0, 1, 1, 0]])
assert lift * ROOT_BASIS == cocharacter.T

cox_classes = []
cox_names = []
for index in range(5):
    value = [0] * 6
    value[index + 1] = 1
    cox_classes.append(sp.Matrix(value))
    cox_names.append(f"E{index + 1}")
for left in range(5):
    for right in range(left + 1, 5):
        value = [1] + [0] * 5
        value[left + 1] = -1
        value[right + 1] = -1
        cox_classes.append(sp.Matrix(value))
        cox_names.append(f"L{left + 1}{right + 1}")
cox_classes.append(sp.Matrix([2, -1, -1, -1, -1, -1]))
cox_names.append("Q")

raw_weights = [int((lift * divisor)[0]) for divisor in cox_classes]
weights = [weight - min(raw_weights) for weight in raw_weights]
weight_multiplicities = {
    str(weight): weights.count(weight) for weight in sorted(set(weights))
}
assert weight_multiplicities == {"0": 2, "1": 6, "2": 6, "3": 2}
boundary_coordinates = [
    name for name, weight in zip(cox_names, weights) if weight in (0, 3)
]
assert boundary_coordinates == ["E3", "E4", "L34", "Q"]

# Primitive completion of the sign cocharacter. The lower-right blocks are
# the cocharacter actions on T0/L; dualize them to get actual characters.
completion = sp.Matrix.hstack(
    cocharacter,
    sp.eye(5).col(0),
    sp.eye(5).col(1),
    sp.eye(5).col(2),
    sp.eye(5).col(4),
)
assert completion.det() == -1
quotient_character_actions = []
for generator, expected_sign in zip(COCHARACTER_GENERATORS, (-1, 1)):
    changed = completion.inv() * generator * completion
    assert changed[0, 0] == expected_sign
    assert changed[1:, 0] == sp.zeros(4, 1)
    quotient_cocharacter = changed[1:, 1:]
    quotient_character_actions.append(quotient_cocharacter.inv().T)

expected_quotient_character_actions = [
    sp.Matrix([[-1, 0, 1, -1], [1, 1, 1, 2], [0, 0, 0, -1], [0, 0, -1, 0]]),
    sp.Matrix([[0, 1, 0, 2], [-1, -1, 0, -1], [0, 0, 1, 0], [0, 0, 0, -1]]),
]
assert quotient_character_actions == expected_quotient_character_actions

certificate = {
    "schema": "c925-i3-level4-cubic-slice-v1",
    "type_i3_group_order": len(group),
    "primitive_sign_subtorus_cocharacter": [int(entry) for entry in cocharacter],
    "generator_signs": [-1, 1],
    "picard_cocharacter_lift": [int(entry) for entry in lift],
    "cox_coordinate_order": cox_names,
    "projective_cox_weights": dict(zip(cox_names, weights)),
    "projective_weight_multiplicities": weight_multiplicities,
    "galois_stable_boundary_coordinate_sum": boundary_coordinates,
    "quotient_character_generator_actions": [
        [[int(entry) for entry in matrix.row(row)] for row in range(4)]
        for matrix in quotient_character_actions
    ],
    "conclusion": (
        "The full type-I3 anticanonical quotient torus has a primitive sign "
        "subtorus with Cox weights 0^2,1^6,2^6,3^2. General orbit closures "
        "are rational normal cubics, and their two boundary points lie in "
        "the fixed Galois-stable projective 3-space spanned by E3,E4,L34,Q. "
        "The actual rank-four quotient character actions are computed."
    ),
}

parser = argparse.ArgumentParser()
mode = parser.add_mutually_exclusive_group()
mode.add_argument("--write-certificate", type=Path)
mode.add_argument("--check-certificate", type=Path)
arguments = parser.parse_args()
payload = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
if arguments.write_certificate is not None:
    arguments.write_certificate.write_text(payload, encoding="utf-8")
if arguments.check_certificate is not None:
    assert arguments.check_certificate.read_text(encoding="utf-8") == payload
print(payload, end="")
