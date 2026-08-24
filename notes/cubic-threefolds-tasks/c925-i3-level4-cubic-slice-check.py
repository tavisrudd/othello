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

# Saturated rank-three subtorus.  The cocharacter lattice spanned by the last
# three standard basis vectors is invariant under the full type-I3 group.
# Its central four-block window is unimodular and its residual torus has rank
# two, giving the level-two quotient when combined with the universal tangent
# certificate.
rank_three_basis = sp.Matrix.hstack(
    sp.eye(5).col(2), sp.eye(5).col(3), sp.eye(5).col(4)
)
rank_three_left_inverse = (
    (rank_three_basis.T*rank_three_basis).inv()*rank_three_basis.T
)
rank_three_actions = [
    rank_three_left_inverse*generator*rank_three_basis
    for generator in COCHARACTER_GENERATORS
]
assert all(
    rank_three_basis*action == generator*rank_three_basis
    for action, generator in zip(rank_three_actions, COCHARACTER_GENERATORS)
)
rank_three_lifts = []
for column in range(3):
    variables = sp.symbols("u0:6")
    solution = next(iter(sp.linsolve([
        sum(variables[row]*ROOT_BASIS[row, root] for row in range(6))
        - rank_three_basis[root, column]
        for root in range(5)
    ] + [variables[5]], variables)))
    assert all(entry.q == 1 for entry in solution)
    rank_three_lifts.append(sp.Matrix(1, 6, solution))
rank_three_raw_weights = [
    tuple(int((lift*divisor)[0]) for lift in rank_three_lifts)
    for divisor in cox_classes
]
rank_three_minima = tuple(
    min(weight[index] for weight in rank_three_raw_weights) for index in range(3)
)
rank_three_weights = [
    tuple(weight[index]-rank_three_minima[index] for index in range(3))
    for weight in rank_three_raw_weights
]
rank_three_blocks = {
    weight: [
        name for name, value in zip(cox_names, rank_three_weights) if value == weight
    ]
    for weight in sorted(set(rank_three_weights))
}
rank_three_points = sorted(rank_three_blocks)
rank_three_affine_actions = []
for action in rank_three_actions:
    dual = action.inv().T
    for target in map(sp.Matrix, rank_three_points):
        shift = target-dual*sp.Matrix(rank_three_points[0])
        images = [
            tuple(dual*sp.Matrix(weight)+shift) for weight in rank_three_points
        ]
        if set(images) == set(rank_three_points):
            rank_three_affine_actions.append(dict(zip(rank_three_points, images)))
            break
    else:
        raise AssertionError("type-I3 action did not preserve rank-three weights")
unimodular_window_weights = (
    (0, 1, 1), (1, 0, 1), (1, 1, 0), (1, 1, 1),
)
unimodular_window_blocks = [rank_three_blocks[weight] for weight in unimodular_window_weights]
assert unimodular_window_blocks == [
    ["L13", "L23", "L35"],
    ["L14", "L24", "L45"],
    ["E1", "E2", "E5"],
    ["L12", "L15", "L25"],
]
assert all(
    {action[weight] for weight in unimodular_window_weights}
    == set(unimodular_window_weights)
    for action in rank_three_affine_actions
)
window_difference_matrix = sp.Matrix.hstack(*(
    sp.Matrix(weight)-sp.Matrix(unimodular_window_weights[0])
    for weight in unimodular_window_weights[1:]
))
assert abs(int(window_difference_matrix.det())) == 1
assert set(rank_three_blocks)-set(unimodular_window_weights) == {
    (0, 0, 1), (0, 0, 2), (1, 2, 0), (2, 1, 0),
}
assert sorted(
    name
    for weight in set(rank_three_blocks)-set(unimodular_window_weights)
    for name in rank_three_blocks[weight]
) == ["E3", "E4", "L34", "Q"]

rank_three_completion = sp.Matrix.hstack(
    rank_three_basis, sp.eye(5).col(0), sp.eye(5).col(1)
)
assert abs(int(rank_three_completion.det())) == 1
rank_two_cocharacter_actions = []
rank_two_character_actions = []
for generator in COCHARACTER_GENERATORS:
    changed = rank_three_completion.inv()*generator*rank_three_completion
    assert changed[3:5, 0:3] == sp.zeros(2, 3)
    residual = changed[3:5, 3:5]
    rank_two_cocharacter_actions.append(residual)
    rank_two_character_actions.append(residual.inv().T)

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
    "saturated_rank_three_level_two_subtorus": {
        "cocharacter_basis": [
            [int(entry) for entry in rank_three_basis.col(column)]
            for column in range(3)
        ],
        "generator_actions": [
            [[int(entry) for entry in matrix.row(row)] for row in range(3)]
            for matrix in rank_three_actions
        ],
        "affine_weight_generator_actions": [
            {
                ",".join(map(str, weight)): [int(entry) for entry in action[weight]]
                for weight in rank_three_points
            }
            for action in rank_three_affine_actions
        ],
        "unimodular_window_weights": [list(weight) for weight in unimodular_window_weights],
        "unimodular_window_blocks": unimodular_window_blocks,
        "window_affine_lattice_index": abs(int(window_difference_matrix.det())),
        "boundary_coordinates": ["E3", "E4", "L34", "Q"],
        "ambient_completion_determinant": int(rank_three_completion.det()),
        "residual_rank_two_cocharacter_actions": [
            [[int(entry) for entry in matrix.row(row)] for row in range(2)]
            for matrix in rank_two_cocharacter_actions
        ],
        "residual_rank_two_character_actions": [
            [[int(entry) for entry in matrix.row(row)] for row in range(2)]
            for matrix in rank_two_character_actions
        ],
        "conclusion": (
            "The full type-I3 group preserves a saturated rank-three subtorus "
            "with a Galois-stable unimodular four-block window and rational "
            "rank-two residual torus."
        ),
    },
    "conclusion": (
        "The full type-I3 anticanonical quotient torus has both the certified "
        "rank-one level-four cubic window and a saturated rank-three level-two "
        "unimodular window. The latter leaves E3,E4,L34,Q as its boundary and "
        "has a rational rank-two residual torus."
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
