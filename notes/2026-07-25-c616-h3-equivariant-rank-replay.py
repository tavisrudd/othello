#!/usr/bin/env python3
"""Independent replay of the small C616 cohomology and witness checks."""

from __future__ import annotations

import importlib.util
import itertools
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = json.loads(
    (HERE / "2026-07-25-c616-h3-equivariant-rank.json").read_text()
)
SCOUT = json.loads(
    (HERE / "2026-07-20-c406-matching-orbit-scout.json").read_text()
)
REPLAY_PATH = HERE / "2026-07-20-c406-matching-module-replay.py"
PRIME = 11


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


REPLAY = load_module("c616_c406_independent", REPLAY_PATH)


def matrix_rank(rows):
    return REPLAY.matrix_rank(rows, PRIME)


def matrix_product(left, right):
    return [
        [
            sum(a * b for a, b in zip(row, column)) % PRIME
            for column in zip(*right)
        ]
        for row in left
    ]


def matrix_vector(matrix, vector):
    return [
        sum(a * b for a, b in zip(row, vector)) % PRIME
        for row in matrix
    ]


def identity(size):
    return [[int(i == j) for j in range(size)] for i in range(size)]


def unipotent_matrix(degree):
    matrix = [[0] * (degree + 1) for _ in range(degree + 1)]
    for column, y_degree in enumerate(range(degree + 1)):
        x_degree = degree - y_degree
        for extra_y in range(x_degree + 1):
            row = y_degree + extra_y
            matrix[row][column] = (
                math.comb(x_degree, extra_y) * (-1) ** extra_y
            ) % PRIME
    return matrix


def cyclic_record(degree):
    sigma = unipotent_matrix(degree)
    difference = [
        [
            (sigma[i][j] - int(i == j)) % PRIME
            for j in range(degree + 1)
        ]
        for i in range(degree + 1)
    ]
    power = identity(degree + 1)
    norm = [[0] * (degree + 1) for _ in range(degree + 1)]
    for _ in range(PRIME):
        norm = [
            [
                (norm[i][j] + power[i][j]) % PRIME
                for j in range(degree + 1)
            ]
            for i in range(degree + 1)
        ]
        power = matrix_product(power, sigma)
    twist = (degree // 2 + 5) % 10
    exponent = (twist - degree - 1) % 10
    eigenvalue = pow(2, exponent, PRIME)
    return {
        "dimension": degree + 1,
        "determinant_twist_exponent_mod_10": twist,
        "unipotent_minus_identity_rank": matrix_rank(difference),
        "cyclic_norm_rank": matrix_rank(norm),
        "cyclic_h1_dimension": (
            degree + 1 - matrix_rank(norm) - matrix_rank(difference)
        ),
        "normalizer_character_exponent_mod_10": exponent,
        "normalizer_generator": 2,
        "normalizer_eigenvalue": eigenvalue,
        "normalizer_fixed_h1_dimension": int(eigenvalue == 1),
        "symmetric_degree": degree,
    }


def laplacian_matrix(degree):
    source = REPLAY.monomials(degree)
    target = REPLAY.monomials(degree - 2)
    target_index = {exponent: index for index, exponent in enumerate(target)}
    matrix = [[0] * len(source) for _ in target]
    for column, (x_degree, y_degree, z_degree) in enumerate(source):
        if x_degree and z_degree:
            matrix[target_index[(x_degree - 1, y_degree, z_degree - 1)]][
                column
            ] += 4 * x_degree * z_degree
        if y_degree >= 2:
            matrix[target_index[(x_degree, y_degree - 2, z_degree)]][
                column
            ] -= y_degree * (y_degree - 1)
    return [[entry % PRIME for entry in row] for row in matrix]


def delta_squared(vector):
    return matrix_vector(
        laplacian_matrix(2), matrix_vector(laplacian_matrix(4), vector)
    )[0]


def quotient(base, matching, endpoints):
    base_product = REPLAY.secant_product(base, endpoints, PRIME)
    product = REPLAY.secant_product(matching, endpoints, PRIME)
    difference = {
        exponent: (
            product.get(exponent, 0) - base_product.get(exponent, 0)
        )
        % PRIME
        for exponent in set(product) | set(base_product)
    }
    return REPLAY.conic_quotient(difference, 4, PRIME)


def main():
    assert CERTIFICATE["schema"] == "c616-h3-equivariant-rank-v1"
    assert {
        str(degree): cyclic_record(degree) for degree in (8, 4, 0)
    } == CERTIFICATE["cyclic_sylow_and_normalizer"]

    record = next(item for item in SCOUT["types"] if item["type"] == "H3")
    endpoints, full_group, psl_group = REPLAY.mobius_groups(PRIME)
    base = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = {
        REPLAY.image_matching(element, base) for element in full_group
    }
    plus_sheet = {
        REPLAY.image_matching(element, base) for element in psl_group
    }
    witnesses = CERTIFICATE["witnesses"]
    same = tuple(tuple(pair) for pair in witnesses["same_sheet_matching"])
    outer = tuple(tuple(pair) for pair in witnesses["outer_sheet_matching"])
    assert same in plus_sheet
    assert outer in orbit - plus_sheet
    same_vector = quotient(base, same, endpoints)
    outer_vector = quotient(base, outer, endpoints)
    assert same_vector == witnesses["same_sheet_quotient_vector"]
    assert outer_vector == witnesses["outer_sheet_quotient_vector"]
    assert any(same_vector)
    assert delta_squared(same_vector) == 0
    assert delta_squared(outer_vector) == 10

    class_sizes = CERTIFICATE["a5_class_sizes"]
    fixed_dimensions = {
        name: sum(
            size * value for size, value in zip(class_sizes, character)
        )
        // 60
        for name, character in CERTIFICATE["a5_characters"].items()
    }
    assert fixed_dimensions == CERTIFICATE["a5_fixed_dimensions"]
    print(
        "C616 independent replay OK: cyclic H1 weights, A5 fixed spaces, "
        "and two quotient witnesses"
    )


if __name__ == "__main__":
    main()
