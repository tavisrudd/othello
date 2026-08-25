#!/usr/bin/env python3
"""Compute and verify the inverse of the type-I1 split plane blowdown."""

import argparse
import hashlib
import json
from pathlib import Path

import sympy as sp
from sympy.polys.matrices import DomainMatrix


ROOT = Path(__file__).resolve().parents[1]
BLOWDOWN_INPUT = ROOT / "notes/2026-08-24-c958-type-i1-split-blowdown.json"
BLOWDOWN_SHA256 = "4e1d3dd013ea7fdf998d775386e905afb4be298b601b369fbe84347d44021fba"
SECTIONS_INPUT = ROOT / "notes/2026-08-24-c958-type-i1-rational-splitting-cover.json"
SECTIONS_SHA256 = "1b2d5a2a53baee1acae52e7ad566f3daacd3e72f79ad7b2bc24e0766129adefa"

a, z = sp.symbols("a z")
Y1, Y2, Y3, Y4 = sp.symbols("Y1 Y2 Y3 Y4")
Z1, Z2, Z3 = sp.symbols("Z1 Z2 Z3")
FIELD = sp.QQ.frac_field(a, z)
PLANE_RING = FIELD.poly_ring(Z1, Z2, Z3)

QUADRIC_MONOMIALS = [
    Y1**2,
    Y1 * Y2,
    Y1 * Y3,
    Y1 * Y4,
    Y2**2,
    Y2 * Y3,
    Y2 * Y4,
    Y3**2,
    Y3 * Y4,
    Y4**2,
]
PLANE_CUBIC_MONOMIALS = [
    Z1**3,
    Z1**2 * Z2,
    Z1**2 * Z3,
    Z1 * Z2**2,
    Z1 * Z2 * Z3,
    Z1 * Z3**2,
    Z2**3,
    Z2**2 * Z3,
    Z2 * Z3**2,
    Z3**3,
]
QUADRIC_EXPONENTS = [sp.Poly(monomial, Y1, Y2, Y3, Y4).monoms()[0] for monomial in QUADRIC_MONOMIALS]


def canonical(expression):
    return sp.factor(sp.cancel(expression))


def read_pinned(path, digest):
    data = path.read_bytes()
    assert hashlib.sha256(data).hexdigest() == digest
    return json.loads(data)


def normalize_vector(vector):
    pivot = next(value for value in vector if value != 0)
    return [canonical(value / pivot) for value in vector]


def ring_evaluate(coefficients, values, exponents, ring):
    ring_values = [ring.from_sympy(value) for value in values]
    total = ring.zero
    for coefficient, powers in zip(coefficients, exponents):
        term = ring.from_sympy(coefficient)
        for value, power in zip(ring_values, powers):
            if power:
                term *= value**power
        total += term
    return total


def build():
    blowdown = read_pinned(BLOWDOWN_INPUT, BLOWDOWN_SHA256)
    sections = read_pinned(SECTIONS_INPUT, SECTIONS_SHA256)
    quadric_vectors = []
    quadrics = []
    for coordinate in ("Z1", "Z2", "Z3"):
        coefficients = [sp.sympify(value) for value in blowdown["quadric_coefficients"][coordinate]]
        quadric_vectors.append(coefficients)
        quadrics.append(canonical(sum(value * monomial for value, monomial in zip(coefficients, QUADRIC_MONOMIALS))))

    points = {
        name: [sp.sympify(value) for value in coordinates]
        for name, coordinates in blowdown["contracted_points"].items()
    }
    evaluation = sp.Matrix(
        [
            [monomial.subs({Z1: point[0], Z2: point[1], Z3: point[2]}) for monomial in PLANE_CUBIC_MONOMIALS]
            for point in points.values()
        ]
    )
    evaluation_domain = DomainMatrix.from_Matrix(evaluation).convert_to(FIELD)
    cubic_nullspace = evaluation_domain.nullspace()
    assert evaluation_domain.rank() == 6 and cubic_nullspace.shape == (4, 10)
    cubic_vectors = [normalize_vector(row) for row in cubic_nullspace.to_Matrix().tolist()]
    plane_cubics = [
        canonical(sum(value * monomial for value, monomial in zip(vector, PLANE_CUBIC_MONOMIALS)))
        for vector in cubic_vectors
    ]
    for cubic in plane_cubics:
        assert all(canonical(cubic.subs({Z1: point[0], Z2: point[1], Z3: point[2]})) == 0 for point in points.values())

    beta = sp.sympify(sections["field_formulas"]["beta"])

    target_line_forms = {"E0": [[0, 0, 1, 0], [0, 0, 0, 1]]}
    for index in range(1, 6):
        coefficients = {
            name: sp.sympify(value)
            for name, value in sections["sections"][f"E{index}"]["coefficients"].items()
        }
        target_line_forms[f"E{index}"] = [
            [1, 0, -coefficients["A"], -coefficients["B"]],
            [0, 1, -coefficients["C"], -coefficients["D"]],
        ]

    transformation_symbols = sp.symbols("n0:16")
    transformation_rows = []
    for name, point in points.items():
        point_substitution = {Z1: point[0], Z2: point[1], Z3: point[2]}
        tangent_vectors = [
            [canonical(sp.diff(cubic, coordinate).subs(point_substitution)) for cubic in plane_cubics]
            for coordinate in (Z1, Z2, Z3)
        ]
        assert DomainMatrix.from_Matrix(sp.Matrix(tangent_vectors)).convert_to(FIELD).rank() == 2
        for line_form in target_line_forms[name]:
            for tangent_vector in tangent_vectors:
                expression = sum(
                    line_form[row]
                    * sum(
                        transformation_symbols[4 * row + column] * tangent_vector[column]
                        for column in range(4)
                    )
                    for row in range(4)
                )
                transformation_rows.append(
                    [sp.diff(expression, symbol) for symbol in transformation_symbols]
                )
    transformation_matrix = DomainMatrix.from_Matrix(sp.Matrix(transformation_rows), fmt="sparse").convert_to(FIELD)
    transformation_nullspace = transformation_matrix.nullspace()
    assert transformation_matrix.rank() == 15 and transformation_nullspace.shape == (1, 16)
    transformation_vector = normalize_vector(list(transformation_nullspace.to_Matrix()))
    transformation = sp.Matrix(4, 4, transformation_vector)
    assert DomainMatrix.from_Matrix(transformation).convert_to(FIELD).rank() == 4
    inverse_cubic_vectors = [
        [
            canonical(sum(transformation[row, column] * cubic_vectors[column][monomial] for column in range(4)))
            for monomial in range(10)
        ]
        for row in range(4)
    ]
    assert DomainMatrix.from_Matrix(sp.Matrix(inverse_cubic_vectors)).convert_to(FIELD).rank() == 4
    inverse_forms = [
        canonical(sum(value * monomial for value, monomial in zip(vector, PLANE_CUBIC_MONOMIALS)))
        for vector in inverse_cubic_vectors
    ]

    original_cubic = Y3 * (beta * Y3**2 + 2 * a * (3 * Y2**2 - Y1**2))
    original_cubic += Y4 * (Y1**2 + 3 * Y2**2 + 3 * a**2 * Y3**2 - Y4**2)
    inverse_substitution = dict(zip((Y1, Y2, Y3, Y4), inverse_forms))
    assert canonical(original_cubic.subs(inverse_substitution, simultaneous=True)) == 0

    forward_after_inverse = [
        ring_evaluate(vector, inverse_forms, QUADRIC_EXPONENTS, PLANE_RING)
        for vector in quadric_vectors
    ]
    assert forward_after_inverse[0] * PLANE_RING.from_sympy(Z2) == forward_after_inverse[1] * PLANE_RING.from_sympy(Z1)
    assert forward_after_inverse[0] * PLANE_RING.from_sympy(Z3) == forward_after_inverse[2] * PLANE_RING.from_sympy(Z1)

    cubic_lengths = [len(str(value)) for value in cubic_vectors for value in value]
    aligned_lengths = [len(str(value)) for vector in inverse_cubic_vectors for value in vector]
    inverse_lengths = [len(str(form)) for form in inverse_forms]
    return {
        "schema": "c958-type-i1-split-inverse-v1",
        "input_sha256": {"blowdown": BLOWDOWN_SHA256, "sections": SECTIONS_SHA256},
        "plane_cubic_monomial_order": [str(monomial) for monomial in PLANE_CUBIC_MONOMIALS],
        "plane_cubic_coefficients": [[str(value) for value in vector] for vector in cubic_vectors],
        "exceptional_line_alignment_rank": transformation_matrix.rank(),
        "inverse_cubic_forms": [str(form) for form in inverse_forms],
        "formula_characters": {
            "plane_cubic_coefficients_total": sum(cubic_lengths),
            "aligned_inverse_coefficients_total": sum(aligned_lengths),
            "inverse_forms": inverse_lengths,
        },
        "certified": [
            "the plane cubics through the six blowup points form a four-dimensional space",
            "exceptional-line incidence uniquely aligns that anticanonical model with the given cubic",
            "the inverse cubic forms satisfy the original cubic equation",
            "the blowdown after the inverse is projectively the identity on the plane",
            "because the blowdown is birational, its displayed right inverse is also its left inverse on the function field",
        ],
        "not_certified": [
            "Galois descent of the split maps",
            "the stabilized ground-field parametrization",
            "maps for the type-I3 series",
        ],
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", type=Path)
    mode.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    payload = json.dumps(build(), indent=2, sort_keys=True) + "\n"
    if arguments.write:
        arguments.write.write_text(payload)
    else:
        assert arguments.check.read_text() == payload


if __name__ == "__main__":
    main()
