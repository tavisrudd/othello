#!/usr/bin/env python3
"""Exact lattice certificate for the C925 type-I1 level-eight bound."""

import argparse
import json
from pathlib import Path

import sympy as sp


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


change_of_basis = sp.Matrix.hstack(
    *(sp.Matrix(column) for column in B_COLUMNS)
)
assert change_of_basis.det() == -1

# Old coordinates are H,E_1,...,E_5,w_0,w_1,w_2,q_0,q_1.
# The rows are the anticanonical cocharacter and the diagonal cocharacters
# of the degree-three and degree-two auxiliary permutation tori.
old_cocharacters = sp.Matrix([
    [3, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
])
all_weights = old_cocharacters * change_of_basis
expected_rows = sp.Matrix([
    [2, 2, 2, 2, 2, 2, -3, -3, -3, -3, 4],
    [-2, -2, -2, -2, -2, -2, 3, 3, 3, 3, -3],
    [-3, -3, -3, -3, -3, -3, 4, 4, 4, 4, -4],
])
assert all_weights == expected_rows

generator_one = permutation(
    11, ((0, 1), (2, 4), (3, 5), (6, 7), (8, 9))
)
generator_two = permutation(
    11, ((0, 3), (1, 2), (4, 5), (6, 8), (7, 9))
)
group = closure((generator_one, generator_two))
assert len(group) == 12
unseen = set(range(11))
orbits = []
while unseen:
    representative = min(unseen)
    orbit = sorted({value[representative] for value in group})
    orbits.append(orbit)
    unseen -= set(orbit)
assert orbits == [list(range(6)), list(range(6, 10)), [10]]

# One column from each orbit records the three weights of each split scalar.
orbit_weight_matrix = all_weights[:, [0, 6, 10]]
assert orbit_weight_matrix == sp.Matrix([
    [2, -3, 4],
    [-2, 3, -3],
    [-3, 4, -4],
])
assert orbit_weight_matrix.det() == 1
inverse_weight_matrix = orbit_weight_matrix.inv()
assert all(entry.q == 1 for entry in inverse_weight_matrix)

certificate = {
    "schema": "c925-i1-three-scalar-level8-v1",
    "lemma_4_2_change_of_basis_determinant": int(change_of_basis.det()),
    "type_i1_group_order": len(group),
    "target_orbits": orbits,
    "cocharacter_weights": [
        [int(entry) for entry in all_weights.row(index)]
        for index in range(all_weights.rows)
    ],
    "orbit_weight_matrix": [
        [int(entry) for entry in orbit_weight_matrix.row(index)]
        for index in range(orbit_weight_matrix.rows)
    ],
    "orbit_weight_determinant": int(orbit_weight_matrix.det()),
    "inverse_weight_matrix": [
        [int(entry) for entry in inverse_weight_matrix.row(index)]
        for index in range(inverse_weight_matrix.rows)
    ],
    "quotient_dimension": 11 - 3,
    "conclusion": (
        "The anticanonical scalar and the two diagonal scalars of the "
        "auxiliary degree-3 and degree-2 permutation tori act with a "
        "unimodular 3-by-3 weight matrix on the 6+4+1 target blocks. "
        "Their simultaneous quotient is rational of dimension eight."
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
