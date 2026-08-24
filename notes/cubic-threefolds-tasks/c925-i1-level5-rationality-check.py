#!/usr/bin/env python3
"""Exact lattice certificate for the C925 type-I1 level-five bound."""

import argparse
import json
import math
from pathlib import Path

import sympy as sp
from sympy.matrices.normalforms import smith_normal_form
from sympy.polys.domains import ZZ


B_COLUMNS = (
    (2, 0, -1, -1, -1, -1, -1, 0, -1, -2, -1),
    (1, -1, 0, 0, 0, 0, -1, -1, 0, -1, -2),
    (2, -1, 0, -1, -1, -1, -1, -1, 0, -2, -1),
    (1, 0, -1, 0, 0, 0, 0, -1, -1, -1, -2),
    (1, 0, 0, 0, 0, -1, -1, 0, -1, -1, -2),
    (2, -1, -1, -1, -1, 0, 0, -1, -1, -2, -1),
    (-3, 1, 1, 2, 1, 1, 1, 1, 1, 3, 1),
    (-2, 1, 1, 0, 0, 1, 1, 1, 1, 1, 3),
    (-1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 3),
    (-3, 1, 1, 1, 2, 1, 1, 1, 1, 3, 1),
    (3, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2),
)


def permutation(n, cycles):
    value = list(range(n))
    for cycle in cycles:
        for index, entry in enumerate(cycle):
            value[entry] = cycle[(index + 1) % len(cycle)]
    return tuple(value)


def compose(left, right):
    return tuple(left[right[index]] for index in range(len(left)))


def closure(generators):
    identity = tuple(range(len(generators[0])))
    group = {identity}
    queue = [identity]
    while queue:
        value = queue.pop()
        for generator in generators:
            for product in (compose(value, generator), compose(generator, value)):
                if product not in group:
                    group.add(product)
                    queue.append(product)
    return sorted(group)


def permutation_matrix(value):
    result = sp.zeros(len(value))
    for column, row in enumerate(value):
        result[row, column] = 1
    return result


change_of_basis = sp.Matrix.hstack(
    *(sp.Matrix(column) for column in B_COLUMNS)
)
assert change_of_basis.det() == -1

# H is the product of the anticanonical scalar with both full auxiliary
# permutation tori Q_3 and Q_2.
old_h_cocharacters = sp.Matrix([
    [3, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
])
h_weights = old_h_cocharacters * change_of_basis
expected_h_weights = sp.Matrix([
    [2, 2, 2, 2, 2, 2, -3, -3, -3, -3, 4],
    [-1, -1, -1, 0, -1, 0, 1, 1, 1, 1, -1],
    [0, -1, -1, -1, 0, -1, 1, 1, 1, 1, -1],
    [-1, 0, 0, -1, -1, -1, 1, 1, 1, 1, -1],
    [-2, -1, -2, -1, -1, -2, 3, 1, 1, 3, -2],
    [-1, -2, -1, -2, -2, -1, 1, 3, 3, 1, -2],
])
assert h_weights == expected_h_weights

generator_one = permutation(
    11, ((0, 1), (2, 4), (3, 5), (6, 7), (8, 9))
)
generator_two = permutation(
    11, ((0, 3), (1, 2), (4, 5), (6, 8), (7, 9))
)
group = closure((generator_one, generator_two))
assert len(group) == 12

large_block = (0, 1, 2, 3, 4, 5, 10)
small_block = (6, 7, 8, 9)
restricted_weights = h_weights[:, large_block]
smith = smith_normal_form(restricted_weights, domain=ZZ)
smith_diagonal = [int(smith[index, index]) for index in range(6)]
assert restricted_weights.rank() == 5
assert [abs(value) for value in smith_diagonal] == [1, 1, 1, 1, 1, 0]

# The full kernel on the 6+1 block is split and scalar on the 4-block.
h_zero = sp.Matrix([[-1, -4, -4, -4, 2, 2]])
assert math.gcd(*[abs(int(value)) for value in h_zero]) == 1
assert h_zero * restricted_weights == sp.zeros(1, 7)
assert h_zero * h_weights[:, small_block] == -sp.ones(1, 4)
left_nullspace = restricted_weights.T.nullspace()
assert len(left_nullspace) == 1
assert h_zero.T == 2 * left_nullspace[0]

# Characters of H/H_0 form the direct sum of the degree-three and degree-two
# permutation lattices.
h_bar_character_basis = sp.Matrix([
    [-4, -4, -4, 2, 2],
    [1, 0, 0, 0, 0],
    [0, 1, 0, 0, 0],
    [0, 0, 1, 0, 0],
    [0, 0, 0, 1, 0],
    [0, 0, 0, 0, 1],
])
assert h_zero * h_bar_character_basis == sp.zeros(1, 5)
assert h_bar_character_basis.rank() == 5

auxiliary_generators = (
    (permutation(3, ((1, 2),)), permutation(2, ((0, 1),))),
    (permutation(3, ((0, 1),)), permutation(2, ((0, 1),))),
)
for q_three, q_two in auxiliary_generators:
    h_character_action = sp.diag(
        1, permutation_matrix(q_three), permutation_matrix(q_two)
    )
    h_bar_action = sp.diag(
        permutation_matrix(q_three), permutation_matrix(q_two)
    )
    assert h_character_action * h_bar_character_basis == (
        h_bar_character_basis * h_bar_action
    )

# The quotient of the 6+1 coordinate torus by H/H_0 has rank two. These two
# displayed vectors are a saturated basis of its character lattice.
kernel_basis = sp.Matrix([
    [1, 0],
    [0, 1],
    [0, -1],
    [1, -1],
    [-1, 0],
    [-1, 1],
    [0, 0],
])
assert restricted_weights * kernel_basis == sp.zeros(6, 2)
assert kernel_basis.rank() == 2


def restrict_permutation(value):
    positions = {entry: index for index, entry in enumerate(large_block)}
    return tuple(positions[value[entry]] for entry in large_block)


induced_actions = {}
left_inverse = (kernel_basis.T * kernel_basis).inv() * kernel_basis.T
for value in group:
    action = permutation_matrix(restrict_permutation(value))
    induced = left_inverse * action * kernel_basis
    assert kernel_basis * induced == action * kernel_basis
    assert all(entry.q == 1 for entry in induced)
    assert induced.det() in (-1, 1)
    induced_actions[value] = induced

expected_generator_one_action = induced_actions[generator_one]
expected_generator_two_action = induced_actions[generator_two]

# Independent saturation check: the 2x2 minor on the first two rows is one,
# while Smith form gives the complementary rank exactly five.
assert kernel_basis[:2, :].det() == 1

certificate = {
    "schema": "c925-i1-level5-rationality-v1",
    "lemma_4_2_change_of_basis_determinant": int(change_of_basis.det()),
    "type_i1_group_order": len(group),
    "h_cocharacter_weights": [
        [int(entry) for entry in h_weights.row(index)]
        for index in range(h_weights.rows)
    ],
    "large_block_indices": list(large_block),
    "small_block_indices": list(small_block),
    "large_block_restriction_rank": restricted_weights.rank(),
    "large_block_smith_diagonal": smith_diagonal,
    "primitive_kernel_cocharacter": [int(entry) for entry in h_zero],
    "kernel_weight_on_small_block": [
        int(entry) for entry in (h_zero * h_weights[:, small_block])
    ],
    "h_bar_permutation_character_basis": [
        [int(entry) for entry in h_bar_character_basis.col(index)]
        for index in range(h_bar_character_basis.cols)
    ],
    "rank_two_quotient_character_basis": [
        [int(entry) for entry in kernel_basis.col(index)]
        for index in range(kernel_basis.cols)
    ],
    "generator_rank_two_actions": [
        [[int(entry) for entry in expected_generator_one_action.row(index)]
         for index in range(2)],
        [[int(entry) for entry in expected_generator_two_action.row(index)]
         for index in range(2)],
    ],
    "quotient_dimension": 11 - 6,
    "conclusion": (
        "The rank-five type-I1 torus is rational. The primitive split kernel "
        "of the full auxiliary action on the 6+1 block acts scalarly on the "
        "4-block; the residual acting torus is quasi-trivial and its 6+1 "
        "quotient is a rank-two torus."
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
