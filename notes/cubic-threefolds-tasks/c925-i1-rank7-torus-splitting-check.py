#!/usr/bin/env python3
"""Exact integral splitting certificate for the C925 level-seven torus."""

import argparse
import itertools
import json
from pathlib import Path

import sympy as sp


def permutation(n, cycles):
    value = list(range(n))
    for cycle in cycles:
        for index, entry in enumerate(cycle):
            value[entry] = cycle[(index + 1) % len(cycle)]
    return tuple(value)


def compose(left, right):
    return tuple(left[right[index]] for index in range(len(left)))


def multiply(left, right):
    return compose(left[0], right[0]), compose(left[1], right[1])


IDENTITY = tuple(range(5)), tuple(range(11))
GENERATOR_ONE = (
    permutation(5, ((1, 2), (3, 4))),
    permutation(11, ((0, 1), (2, 4), (3, 5), (6, 7), (8, 9))),
)
GENERATOR_TWO = (
    permutation(5, ((0, 1), (3, 4))),
    permutation(11, ((0, 3), (1, 2), (4, 5), (6, 8), (7, 9))),
)


def closure(generators):
    group = {IDENTITY}
    queue = [IDENTITY]
    while queue:
        value = queue.pop()
        for generator in generators:
            for product in (multiply(value, generator), multiply(generator, value)):
                if product not in group:
                    group.add(product)
                    queue.append(product)
    return sorted(group)


def element_order(value):
    product = IDENTITY
    for order in range(1, 13):
        product = multiply(product, value)
        if product == IDENTITY:
            return order
    raise AssertionError("order exceeds group order")


def permutation_matrix(value):
    matrix = sp.zeros(len(value))
    for column, row in enumerate(value):
        matrix[row, column] = 1
    return matrix


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
change_of_basis = sp.Matrix.hstack(
    *(sp.Matrix(column) for column in B_COLUMNS)
)
assert change_of_basis.det() == -1
change_of_basis_inverse = change_of_basis.inv()

q_three_weights = sp.Matrix([
    [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
]) * change_of_basis
q_two_weights = sp.Matrix([
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
]) * change_of_basis
print(f"Q3_WEIGHTS={q_three_weights.tolist()}")
print(f"Q2_WEIGHTS={q_two_weights.tolist()}")

group = closure((GENERATOR_ONE, GENERATOR_TWO))
assert len(group) == 12
old_actions = {
    value: change_of_basis * permutation_matrix(value[1]) * change_of_basis_inverse
    for value in group
}
assert all(
    action[:6, 6:] == sp.zeros(6, 5)
    and action[6:, :6] == sp.zeros(5, 6)
    for action in old_actions.values()
)

# Primitive basis of ker((-K).-) in Pic(Sbar).
root_basis = sp.Matrix.hstack(
    sp.Matrix([0, 1, 0, 0, 0, -1]),
    sp.Matrix([0, 0, 1, 0, 0, -1]),
    sp.Matrix([0, 0, 0, 1, 0, -1]),
    sp.Matrix([0, 0, 0, 0, 1, -1]),
    sp.Matrix([1, 0, 0, 0, 0, -3]),
)
root_left_inverse = (root_basis.T * root_basis).inv() * root_basis.T
root_actions = {
    value: root_left_inverse * old_actions[value][:6, :6] * root_basis
    for value in group
}
assert all(all(entry.q == 1 for entry in action)
           for action in root_actions.values())


def augmentation_three(action):
    return sp.Matrix.hstack(
        action[:2, 0] - action[:2, 2],
        action[:2, 1] - action[:2, 2],
    )


def quotient_three(action):
    result = sp.zeros(2)
    for column in range(2):
        result[:, column] = (
            action[:2, column] - action[2, column] * sp.ones(2, 1)
        )
    return result


standard_root_actions = {
    value: augmentation_three(old_actions[value][6:9, 6:9])
    for value in group
}
standard_weight_actions = {
    value: quotient_three(old_actions[value][6:9, 6:9])
    for value in group
}
sign_actions = {
    value: sp.Matrix([[
        int(old_actions[value][9, 9] - old_actions[value][9, 10])
    ]])
    for value in group
}

central_involution = next(
    value for value in group
    if value != IDENTITY
    and all(multiply(value, other) == multiply(other, value) for other in group)
)
three_cycle = next(value for value in group if element_order(value) == 3)
transposition = next(
    value for value in group
    if element_order(value) == 2
    and value != central_involution
    and len(closure((value, three_cycle))) == 6
)
symmetric_three = set(closure((transposition, three_cycle)))
central_sign_actions = {
    value: sp.Matrix([[1 if value in symmetric_three else -1]])
    for value in group
}
product_sign_actions = {
    value: central_sign_actions[value] * sign_actions[value]
    for value in group
}

# Source: ker((-K).-) plus the augmentation lattice of the degree-three
# auxiliary orbit.  Target: three rank-one signs and the A2 root and weight
# lattices.  Every corresponding torus factor has dimension at most two.
source_actions = {
    value: sp.diag(root_actions[value], standard_root_actions[value])
    for value in group
}

endomorphism_variables = sp.symbols("e0:49")
endomorphism_unknown = sp.Matrix(7, 7, endomorphism_variables)
endomorphism_equations = []
for value in group:
    endomorphism_equations.extend(list(
        source_actions[value] * endomorphism_unknown
        - endomorphism_unknown * source_actions[value]
    ))
endomorphism_coefficients, _ = sp.linear_eq_to_matrix(
    endomorphism_equations, endomorphism_variables
)
endomorphism_basis = endomorphism_coefficients.nullspace()
print(f"ENDOMORPHISM_RANK={len(endomorphism_basis)}")
for basis_index, basis_vector in enumerate(endomorphism_basis):
    print(f"ENDOMORPHISM_{basis_index}={sp.Matrix(7, 7, basis_vector).tolist()}")
raise SystemExit(0)
target_actions = {
    value: sp.diag(
        sign_actions[value],
        standard_root_actions[value],
        standard_weight_actions[value],
        central_sign_actions[value],
        product_sign_actions[value],
    )
    for value in group
}

variables = sp.symbols("u0:49")
unknown = sp.Matrix(7, 7, variables)
equations = []
for value in group:
    equations.extend(list(
        source_actions[value] * unknown - unknown * target_actions[value]
    ))
coefficient_matrix, _ = sp.linear_eq_to_matrix(equations, variables)
hom_basis = coefficient_matrix.nullspace()
assert len(hom_basis) == 7
hom_matrices = [sp.Matrix(7, 7, vector) for vector in hom_basis]
if __debug__:
    print(f"CENTRAL_ROOT={root_actions[central_involution].tolist()}")
    print(f"GENERATOR_ONE_ROOT={root_actions[GENERATOR_ONE].tolist()}")
    print(f"GENERATOR_TWO_ROOT={root_actions[GENERATOR_TWO].tolist()}")
    for basis_index, matrix in enumerate(hom_matrices):
        print(f"HOM_BASIS_{basis_index}={matrix.tolist()}")

# The rational nullspace normalization hides congruence conditions on the
# integral Hom lattice.  Search the determinant-one locus in a small exact
# box; the resulting matrix is recorded below and checked independently.
intertwiner = None
intertwiner_coefficients = None
for coefficients in itertools.product(range(-3, 4), repeat=7):
    if coefficients[2] not in (-1, 1):
        continue
    if coefficients[3] not in (-1, 1):
        continue
    if coefficients[4] not in (-1, 1):
        continue
    candidate = sum(
        (coefficient * matrix for coefficient, matrix
         in zip(coefficients, hom_matrices)),
        sp.zeros(7),
    )
    if not all(entry.q == 1 for entry in candidate):
        continue
    if candidate.det() in (-1, 1):
        intertwiner = candidate
        intertwiner_coefficients = coefficients
        break
assert intertwiner is not None
assert all(entry.q == 1 for entry in intertwiner)
assert intertwiner.det() in (-1, 1)
assert all(
    source_actions[value] * intertwiner
    == intertwiner * target_actions[value]
    for value in group
)

certificate = {
    "schema": "c925-i1-rank7-torus-splitting-v1",
    "group_order": len(group),
    "lemma_4_2_change_of_basis_determinant": int(change_of_basis.det()),
    "equivariant_hom_rank": len(hom_basis),
    "nullspace_coefficients": list(intertwiner_coefficients),
    "intertwiner": [
        [int(entry) for entry in intertwiner.row(index)]
        for index in range(intertwiner.rows)
    ],
    "intertwiner_determinant": int(intertwiner.det()),
    "target_ranks": [1, 2, 2, 1, 1],
    "conclusion": (
        "The rank-seven torus character lattice ker((-K).-) plus the "
        "degree-three augmentation lattice is integrally the direct sum "
        "of three rank-one sign lattices and the rank-two A2 root and "
        "weight lattices. Hence its torus is rational."
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
