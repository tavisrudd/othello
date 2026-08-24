#!/usr/bin/env python3
"""Exact rank-one quotient data at the C925 type-I1 level-four frontier."""

import argparse
import itertools
import json
import math
from pathlib import Path

import sympy as sp


ROOT_GENERATORS = (
    sp.Matrix([
        [-1, 0, 0, -1, -1],
        [1, 1, 1, 0, 2],
        [0, 0, -1, -1, -1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 1, 0],
    ]),
    sp.Matrix([
        [0, -1, -1, 0, -1],
        [-1, 0, -1, 0, -1],
        [0, 0, 0, 0, 1],
        [0, 0, -1, -1, -1],
        [0, 0, 1, 0, 0],
    ]),
)
CHARACTER_GENERATORS = tuple(
    generator.inv().T for generator in ROOT_GENERATORS
)


def primitive(vector):
    denominator = sp.ilcm(*(entry.q for entry in vector))
    entries = [int(denominator * entry) for entry in vector]
    divisor = math.gcd(*(abs(entry) for entry in entries))
    result = sp.Matrix([entry // divisor for entry in entries])
    first_nonzero = next(entry for entry in result if entry)
    return result if first_nonzero > 0 else -result


def common_eigenspace(generators, signs):
    equations = sp.Matrix.vstack(*(
        generator - sign * sp.eye(generator.rows)
        for generator, sign in zip(generators, signs)
    ))
    return equations.nullspace()


# There is no invariant character or cocharacter after removing -K.
assert common_eigenspace(CHARACTER_GENERATORS, (1, 1)) == []
assert common_eigenspace(
    tuple(generator.T for generator in CHARACTER_GENERATORS), (1, 1)
) == []

records = []
for signs in itertools.product((1, -1), repeat=2):
    injection_space = common_eigenspace(CHARACTER_GENERATORS, signs)
    quotient_space = common_eigenspace(
        tuple(generator.T for generator in CHARACTER_GENERATORS), signs
    )
    if not injection_space or not quotient_space:
        continue
    assert len(injection_space) == len(quotient_space) == 1
    injection = primitive(injection_space[0])
    quotient_row = primitive(quotient_space[0]).T
    index = int((quotient_row * injection)[0])

    # The primitive quotient row is surjective. Its kernel is the character
    # lattice of a four-dimensional quotient torus.
    kernel_columns = [primitive(vector) for vector in quotient_row.nullspace()]
    kernel_basis = sp.Matrix.hstack(*kernel_columns)
    assert kernel_basis.rank() == 4
    assert quotient_row * kernel_basis == sp.zeros(1, 4)
    maximal_minors = [
        int(kernel_basis[list(rows), :].det())
        for rows in itertools.combinations(range(5), 4)
    ]
    assert math.gcd(*(abs(value) for value in maximal_minors)) == 1

    left_inverse = (kernel_basis.T * kernel_basis).inv() * kernel_basis.T
    quotient_actions = []
    for generator in CHARACTER_GENERATORS:
        induced = left_inverse * generator * kernel_basis
        assert kernel_basis * induced == generator * kernel_basis
        assert all(entry.q == 1 for entry in induced)
        assert induced.det() in (-1, 1)
        quotient_actions.append(induced)

    records.append({
        "signs": list(signs),
        "primitive_sign_injection": [int(entry) for entry in injection],
        "primitive_sign_quotient": [int(entry) for entry in quotient_row],
        "injection_quotient_pairing": index,
        "kernel_basis": [
            [int(entry) for entry in kernel_basis.col(column)]
            for column in range(4)
        ],
        "quotient_generator_actions": [
            [[int(entry) for entry in matrix.row(row)] for row in range(4)]
            for matrix in quotient_actions
        ],
    })

assert [record["signs"] for record in records] == [
    [1, -1], [-1, 1], [-1, -1]
]
assert [abs(record["injection_quotient_pairing"]) for record in records] == [
    2, 2, 6
]

certificate = {
    "schema": "c925-i1-level4-frontier-v1",
    "character_group_order": 12,
    "invariant_character_rank": 0,
    "invariant_cocharacter_rank": 0,
    "rank_one_sign_quotients": records,
    "conclusion": (
        "The type-I1 rank-five character lattice has no split rank-one "
        "direction. It has exactly three sign directions; none splits "
        "integrally, with injection-quotient indices 2, 2, and 6."
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
