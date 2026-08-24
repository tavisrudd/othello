#!/usr/bin/env python3
"""Extend the C925 level-five lattice certificate from I1 to full I3."""

import argparse
import hashlib
import json
from pathlib import Path

import sympy as sp


BASE_NAME = "c925-i1-level5-rationality-check.json"
BASE_SHA256 = "ea3c54677625d028723174812f091c0e525bcc27dfca1ced69e36ab4cb2d973a"


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


base_path = Path(__file__).with_name(BASE_NAME)
base_bytes = base_path.read_bytes()
assert hashlib.sha256(base_bytes).hexdigest() == BASE_SHA256
base = json.loads(base_bytes)
assert base["schema"] == "c925-i1-level5-rationality-v1"

h_weights = sp.Matrix(base["h_cocharacter_weights"])
large_block = tuple(base["large_block_indices"])
small_block = tuple(base["small_block_indices"])
h_zero = sp.Matrix([base["primitive_kernel_cocharacter"]])
h_bar_character_basis = sp.Matrix.hstack(*(
    sp.Matrix(column) for column in base["h_bar_permutation_character_basis"]
))
kernel_basis = sp.Matrix.hstack(*(
    sp.Matrix(column) for column in base["rank_two_quotient_character_basis"]
))

assert h_zero * h_weights[:, large_block] == sp.zeros(1, 7)
assert h_zero * h_weights[:, small_block] == -sp.ones(1, 4)
assert h_zero * h_bar_character_basis == sp.zeros(1, 5)
assert h_weights[:, large_block] * kernel_basis == sp.zeros(6, 2)

# Tschinkel--Zhang Lemma 4.2, full type-I3 target permutations.
generator_one = permutation(
    11, ((0, 1), (2, 4), (3, 5), (6, 7), (8, 9))
)
generator_two = permutation(
    11, ((0, 5, 2), (1, 4, 3), (7, 8))
)
group = closure((generator_one, generator_two))
assert len(group) == 24

# The auxiliary permutation actions are w1<->w2, q0<->q1 for g1 and
# (w0,w2,w1), identity on q0,q1 for g2. They make H/H0 quasi-trivial.
auxiliary_generators = (
    (permutation(3, ((1, 2),)), permutation(2, ((0, 1),))),
    (permutation(3, ((0, 2, 1),)), permutation(2, ())),
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


def restrict_permutation(value):
    positions = {entry: index for index, entry in enumerate(large_block)}
    return tuple(positions[value[entry]] for entry in large_block)


left_inverse = (kernel_basis.T * kernel_basis).inv() * kernel_basis.T
induced_actions = {}
for value in group:
    ambient_action = permutation_matrix(restrict_permutation(value))
    induced = left_inverse * ambient_action * kernel_basis
    assert kernel_basis * induced == ambient_action * kernel_basis
    assert all(entry.q == 1 for entry in induced)
    assert induced.det() in (-1, 1)
    induced_actions[value] = induced

generator_actions = [induced_actions[generator_one], induced_actions[generator_two]]
assert generator_actions == [
    sp.Matrix([[0, 1], [1, 0]]),
    sp.Matrix([[0, -1], [1, -1]]),
]

certificate = {
    "schema": "c925-dp4-level5-generalization-v1",
    "base_certificate": BASE_NAME,
    "base_certificate_sha256": BASE_SHA256,
    "type_i3_group_order": len(group),
    "primitive_split_kernel": [int(entry) for entry in h_zero],
    "kernel_weight_on_four_block": [
        int(entry) for entry in (h_zero * h_weights[:, small_block])
    ],
    "residual_actor_character_orbits": [3, 2],
    "rank_two_quotient_character_basis": [
        [int(entry) for entry in kernel_basis.col(index)]
        for index in range(kernel_basis.cols)
    ],
    "type_i3_generator_actions_on_rank_two_quotient": [
        [[int(entry) for entry in matrix.row(index)] for index in range(2)]
        for matrix in generator_actions
    ],
    "conclusion": (
        "The level-five quotient proof is valid for the full type-I3 group, "
        "hence for its type-I0, I1, and I2 subgroups."
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
