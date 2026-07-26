#!/usr/bin/env python3
"""Exact small checks for the equivariant H3 quotient-rank proof."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")
MATCHING_PATH = HERE / "matching_module.py"
SCOUT_PATH = HERE / "matching_orbit_scout.json"
SCHEMA = "equivariant-h3-equivariant-rank-v1"
PRIME = 11


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


MATCHING = load_module("equivariant_matching", MATCHING_PATH)


def identity(size: int) -> list[list[int]]:
    return [[int(i == j) for j in range(size)] for i in range(size)]


def matrix_add(left, right, prime):
    return [
        [(a + b) % prime for a, b in zip(left_row, right_row)]
        for left_row, right_row in zip(left, right)
    ]


def matrix_subtract(left, right, prime):
    return [
        [(a - b) % prime for a, b in zip(left_row, right_row)]
        for left_row, right_row in zip(left, right)
    ]


def matrix_power(matrix, exponent, prime):
    result = identity(len(matrix))
    base = matrix
    while exponent:
        if exponent & 1:
            result = MATCHING.matrix_product(result, base, prime)
        base = MATCHING.matrix_product(base, base, prime)
        exponent //= 2
    return result


def unipotent_symmetric_power(degree: int, prime: int) -> list[list[int]]:
    """Action of x -> x-y, y -> y on Sym^degree with basis x^(d-i)y^i."""
    matrix = [[0] * (degree + 1) for _ in range(degree + 1)]
    for source in range(degree + 1):
        x_degree = degree - source
        for shift in range(x_degree + 1):
            target = source + shift
            matrix[target][source] = (
                math.comb(x_degree, shift) * (-1) ** shift
            ) % prime
    return matrix


def cyclic_cohomology_record(degree: int) -> dict:
    sigma = unipotent_symmetric_power(degree, PRIME)
    difference = matrix_subtract(sigma, identity(degree + 1), PRIME)
    norm = [[0] * (degree + 1) for _ in range(degree + 1)]
    for exponent in range(PRIME):
        norm = matrix_add(norm, matrix_power(sigma, exponent, PRIME), PRIME)
    coboundary_rank = MATCHING.rank(difference, PRIME)
    norm_rank = MATCHING.rank(norm, PRIME)
    h1_dimension = (degree + 1 - norm_rank) - coboundary_rank

    # The quotient class is represented by x^degree.  For the quotient
    # linearization Sym^degree(V*) tensor det^(degree/2+5), conjugation by
    # diag(a,1) contributes a^(-1), so the normalizer character exponent is
    # (degree/2+5)-degree-1 = 4-degree/2 modulo 10.
    determinant_twist = (degree // 2 + 5) % (PRIME - 1)
    normalizer_exponent = (
        determinant_twist - degree - 1
    ) % (PRIME - 1)
    primitive = 2
    assert pow(primitive, PRIME - 1, PRIME) == 1
    assert all(
        pow(primitive, divisor, PRIME) != 1
        for divisor in (1, 2, 5)
    )
    normalizer_eigenvalue = pow(primitive, normalizer_exponent, PRIME)
    return {
        "symmetric_degree": degree,
        "dimension": degree + 1,
        "determinant_twist_exponent_mod_10": determinant_twist,
        "unipotent_minus_identity_rank": coboundary_rank,
        "cyclic_norm_rank": norm_rank,
        "cyclic_h1_dimension": h1_dimension,
        "normalizer_character_exponent_mod_10": normalizer_exponent,
        "normalizer_generator": primitive,
        "normalizer_eigenvalue": normalizer_eigenvalue,
        "normalizer_fixed_h1_dimension": int(normalizer_eigenvalue == 1),
    }


def quotient_vector(record, matching, endpoints):
    base = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    base_product = MATCHING.matching_product(base, endpoints, PRIME)
    product = MATCHING.matching_product(matching, endpoints, PRIME)
    difference = {
        exponent: (
            product.get(exponent, 0) - base_product.get(exponent, 0)
        )
        % PRIME
        for exponent in set(product) | set(base_product)
    }
    return MATCHING.quotient_by_conic(difference, 4, PRIME)


def delta_squared(vector):
    first = MATCHING.matrix_vector(MATCHING.laplacian_matrix(4, PRIME), vector, PRIME)
    second = MATCHING.matrix_vector(MATCHING.laplacian_matrix(2, PRIME), first, PRIME)
    assert len(second) == 1
    return second[0]


def build_certificate() -> dict:
    scout = json.loads(SCOUT_PATH.read_text())
    record = next(item for item in scout["types"] if item["type"] == "H3")
    _conic, endpoints = MATCHING.COXETER.conic_parameterization(PRIME)
    full_group, psl_group = MATCHING.full_pgl(PRIME, endpoints)
    base = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    plus_sheet = {
        MATCHING.matching_image(element, base) for element in psl_group
    }
    orbit = {
        MATCHING.matching_image(element, base) for element in full_group
    }
    assert len(plus_sheet) == 11
    assert len(orbit) == 22

    same_sheet = (
        (0, 2), (1, 8), (3, 9), (4, 11), (5, 6), (7, 10)
    )
    outer_sheet = (
        (0, 1), (2, 11), (3, 8), (4, 6), (5, 9), (7, 10)
    )
    assert same_sheet in plus_sheet
    assert outer_sheet in orbit - plus_sheet
    same_vector = quotient_vector(record, same_sheet, endpoints)
    outer_vector = quotient_vector(record, outer_sheet, endpoints)
    assert any(same_vector)
    assert delta_squared(same_vector) == 0
    assert delta_squared(outer_vector) == 10
    q_squared = MATCHING.radial_power_vector(4, PRIME)
    assert delta_squared(q_squared) == 10

    a5_class_sizes = [1, 15, 20, 12, 12]
    a5_characters = {
        "top_L8_restricts_as_4_plus_5": [9, 1, 0, -1, -1],
        "middle_L4_is_5": [5, 1, -1, 0, 0],
        "radial_character_restricts_trivially": [1, 1, 1, 1, 1],
    }
    a5_fixed_dimensions = {
        name: sum(size * value for size, value in zip(a5_class_sizes, values))
        // 60
        for name, values in a5_characters.items()
    }
    assert a5_fixed_dimensions == {
        "top_L8_restricts_as_4_plus_5": 0,
        "middle_L4_is_5": 0,
        "radial_character_restricts_trivially": 1,
    }

    cohomology = {
        str(degree): cyclic_cohomology_record(degree)
        for degree in (8, 4, 0)
    }
    assert cohomology["8"]["normalizer_fixed_h1_dimension"] == 1
    assert cohomology["4"]["normalizer_fixed_h1_dimension"] == 0
    assert cohomology["0"]["normalizer_fixed_h1_dimension"] == 0

    return {
        "schema": SCHEMA,
        "field": PRIME,
        "group": "PGL_2(11)",
        "inner_group": "PSL_2(11)",
        "stabilizer": "A5",
        "orbit_size": len(orbit),
        "sheet_size": len(plus_sheet),
        "quotient_linearization": (
            "Sym^4(Sym^2(V)^*) tensor det^(-1)"
        ),
        "fischer_layers": {
            "top": "Sym^8(V^*) tensor det^(-1)",
            "middle": "Q Sym^4(V^*) tensor det^(-3)",
            "radial": "det^(-5)",
        },
        "cyclic_sylow_and_normalizer": cohomology,
        "a5_class_sizes": a5_class_sizes,
        "a5_characters": a5_characters,
        "a5_fixed_dimensions": a5_fixed_dimensions,
        "monomial_basis_degree_4": MATCHING.homogeneous_basis(4),
        "witnesses": {
            "base_matching": base,
            "same_sheet_matching": same_sheet,
            "same_sheet_quotient_vector": same_vector,
            "same_sheet_delta_squared": delta_squared(same_vector),
            "outer_sheet_matching": outer_sheet,
            "outer_sheet_quotient_vector": outer_vector,
            "outer_sheet_delta_squared": delta_squared(outer_vector),
            "q_squared_delta_squared": delta_squared(q_squared),
            "outer_radial_coefficient": 1,
        },
        "inputs": {
            path.name: {
                "bytes": path.stat().st_size,
                "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            }
            for path in (MATCHING_PATH, SCOUT_PATH)
        },
        "verdict": (
            "MIDDLE_H1_AND_A5_FIXED_SPACE_ZERO_TOP_AND_RADIAL_NONZERO"
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT.name}")
    else:
        if not OUTPUT.exists() or OUTPUT.read_text() != rendered:
            raise SystemExit(
                f"stale certificate: run {Path(__file__).name} --write"
            )
        print(
            "equivariant-rank certificate OK: "
            "middle excluded, top and radial witnesses nonzero"
        )


if __name__ == "__main__":
    main()
