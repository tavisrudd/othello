#!/usr/bin/env python3
"""Exact lattice and Cox-weight certificate for the type-I1 level-four slice."""

import argparse
import itertools
import json
import math
from pathlib import Path

import sympy as sp


# Column actions on the D5 root sublattice X^*(T_0), in the basis
# E1-E5, E2-E5, E3-E5, E4-E5, H-3E5.
CHARACTER_GENERATORS = (
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
COCHARACTER_GENERATORS = tuple(
    generator.inv().T for generator in CHARACTER_GENERATORS
)

ROOT_BASIS = sp.Matrix.hstack(
    sp.Matrix([0, 1, 0, 0, 0, -1]),
    sp.Matrix([0, 0, 1, 0, 0, -1]),
    sp.Matrix([0, 0, 0, 1, 0, -1]),
    sp.Matrix([0, 0, 0, 0, 1, -1]),
    sp.Matrix([1, 0, 0, 0, 0, -3]),
)


def primitive(vector):
    denominator = sp.ilcm(*(entry.q for entry in vector))
    entries = [int(denominator * entry) for entry in vector]
    divisor = math.gcd(*(abs(entry) for entry in entries))
    result = sp.Matrix([entry // divisor for entry in entries])
    first = next(entry for entry in result if entry)
    return result if first > 0 else -result


def eigenspace(generators, signs):
    equations = sp.Matrix.vstack(*(
        generator - sign * sp.eye(generator.rows)
        for generator, sign in zip(generators, signs)
    ))
    return equations.nullspace()


def unimodular_completion(vector):
    columns = [vector]
    for standard in sp.eye(vector.rows).columnspace():
        candidate = sp.Matrix.hstack(*columns, standard)
        if candidate.rank() > len(columns):
            columns.append(standard)
        if len(columns) == vector.rows:
            matrix = sp.Matrix.hstack(*columns)
            if abs(int(matrix.det())) == 1:
                return matrix
    raise AssertionError("primitive vector did not receive a standard completion")


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
assert len(cox_classes) == 16

records = []
for signs in itertools.product((1, -1), repeat=2):
    space = eigenspace(COCHARACTER_GENERATORS, signs)
    if not space:
        continue
    assert len(space) == 1
    cocharacter = primitive(space[0])

    # Lift the cocharacter from T_0 to T. Fixing the E5 coefficient to zero
    # chooses one representative modulo the anticanonical scalar; changing
    # the lift adds a common weight and does not alter the projective action.
    variables = sp.symbols("u0:6")
    equations = [
        sum(variables[row] * ROOT_BASIS[row, column] for row in range(6))
        - cocharacter[column]
        for column in range(5)
    ] + [variables[5]]
    solution_set = sp.linsolve(equations, variables)
    solution = next(iter(solution_set))
    assert all(entry.q == 1 for entry in solution)
    lift = sp.Matrix(1, 6, solution)
    raw_weights = [int((lift * divisor)[0]) for divisor in cox_classes]
    minimum = min(raw_weights)
    weights = [weight - minimum for weight in raw_weights]

    completion = unimodular_completion(cocharacter)
    quotient_cocharacter_actions = []
    quotient_character_actions = []
    for generator in COCHARACTER_GENERATORS:
        changed = completion.inv() * generator * completion
        assert all(changed[row, 0] == 0 for row in range(1, 5))
        quotient = changed[1:, 1:]
        assert quotient.det() in (-1, 1)
        quotient_cocharacter_actions.append(quotient)
        quotient_character_actions.append(quotient.inv().T)

    records.append({
        "signs": list(signs),
        "primitive_sign_subtorus_cocharacter": [
            int(entry) for entry in cocharacter
        ],
        "picard_cocharacter_lift": [int(entry) for entry in lift],
        "projective_cox_weights": dict(zip(cox_names, weights)),
        "projective_weight_multiplicities": {
            str(weight): weights.count(weight) for weight in sorted(set(weights))
        },
        "quotient_character_generator_actions": [
            [[int(entry) for entry in matrix.row(row)] for row in range(4)]
            for matrix in quotient_character_actions
        ],
    })

assert [record["signs"] for record in records] == [
    [1, -1], [-1, 1], [-1, -1]
]
assert [record["projective_weight_multiplicities"] for record in records] == [
    {"0": 8, "1": 8},
    {"0": 8, "1": 8},
    {"0": 2, "1": 6, "2": 6, "3": 2},
]

certificate = {
    "schema": "c925-i1-level4-linear-slice-v1",
    "root_basis_columns": [
        [int(entry) for entry in ROOT_BASIS.col(column)]
        for column in range(ROOT_BASIS.cols)
    ],
    "cox_coordinate_order": cox_names,
    "sign_subtori": records,
    "conclusion": (
        "The first two primitive type-I1 sign subtori act on the sixteen "
        "projective Cox coordinates with exactly two consecutive weights, "
        "eight coordinates of each weight. Their generic orbit closures are "
        "lines. The corresponding rank-four quotient character actions are "
        "computed integrally for independent CARAT rationality checks."
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
