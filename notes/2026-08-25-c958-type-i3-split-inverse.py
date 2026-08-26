#!/usr/bin/env sage-python
"""Compute and verify the inverse of the type-I3 split plane blowdown."""

import argparse
import hashlib
import json
from pathlib import Path
import sys

from sage.all import FunctionField, Matrix, PolynomialRing, QQ
from sage.misc.sage_eval import sage_eval

if sys.flags.optimize:
    raise RuntimeError("verification must run with Python assertions enabled")


ROOT = Path(__file__).resolve().parents[1]
BLOWDOWN_INPUT = ROOT / "notes/2026-08-25-c958-type-i3-split-blowdown.json"
SECTIONS_INPUT = ROOT / "notes/2026-08-25-c958-type-i3-exceptional-sections.json"
BLOWDOWN_SOURCE = ROOT / "notes/2026-08-25-c958-type-i3-split-blowdown.py"


def progress(message):
    print(f"c958 type-I3 inverse: {message}", file=sys.stderr, flush=True)


def build_normalized_field():
    base = FunctionField(QQ, "beta")
    beta = base.gen()
    polynomial = PolynomialRing(base, "x")
    x = polynomial.gen()
    with_g = base.extension(x**2 - 3, "c958g")
    beta, g = with_g(beta), with_g.gen()
    polynomial = PolynomialRing(with_g, "x")
    x = polynomial.gen()
    with_r = with_g.extension(x**3 - x + 1 + beta, "c958r")
    beta, g, r = with_r(beta), with_r(g), with_r.gen()
    polynomial = PolynomialRing(with_r, "x")
    x = polynomial.gen()
    with_d = with_r.extension(x**2 + 3 * r**2 - 4, "c958d")
    beta, g, r, d = with_d(beta), with_d(g), with_d(r), with_d.gen()
    delta_squared = (-32 * g - 52) - (24 * g + 36) * beta
    polynomial = PolynomialRing(with_d, "x")
    x = polynomial.gen()
    field = with_d.extension(x**2 - delta_squared, "c958e")
    return field, field(beta), field(r), field(d), field(g), field.gen()


def build(check_forward=True, check_reverse=True):
    assert check_forward or not check_reverse
    normalization_ring = PolynomialRing(
        QQ, names=("A", "S", "R", "D", "G", "E", "X1", "X2", "X3", "X4"),
    )
    A, S, R, D, G, E, X1, X2, X3, X4 = normalization_ring.gens()
    original_cubic_after_scaling = (
        X3 * (A * (A * X1)**2 + 2 * A * (A * X1) * (A * X2)
              + (A**3 + A**3 * S) * X3**2)
        + A * X4 * ((A * X1)**2 + (A * X1) * (A * X2) + (A * X2)**2
                    - A**2 * X3**2 + (A * X4)**2)
    )
    normalized_cubic = (
        X3 * (X1**2 + 2 * X1 * X2 + (1 + S) * X3**2)
        + X4 * (X1**2 + X1 * X2 + X2**2 - X3**2 + X4**2)
    )
    assert original_cubic_after_scaling == A**3 * normalized_cubic
    assert (A * R)**3 - A**2 * (A * R) + A**3 + A**3 * S == (
        A**3 * (R**3 - R + 1 + S)
    )
    assert (A * D)**2 + 3 * (A * R)**2 - 4 * A**2 == (
        A**2 * (D**2 + 3 * R**2 - 4)
    )
    assert (
        (A**2 * E)**2
        - ((-32 * G - 52) * A**4 - (24 * G + 36) * A * (A**3 * S))
        == A**4 * (E**2 - ((-32 * G - 52) - (24 * G + 36) * S))
    )
    blowdown_bytes = BLOWDOWN_INPUT.read_bytes()
    sections_bytes = SECTIONS_INPUT.read_bytes()
    blowdown = json.loads(blowdown_bytes)
    sections = json.loads(sections_bytes)
    assert blowdown["schema"] == "c958-type-i3-split-blowdown-v1"
    assert sections["schema"] == "c958-type-i3-exceptional-sections-v1"
    assert blowdown["input_sha256"] == hashlib.sha256(sections_bytes).hexdigest()
    nested_field, nested_beta, nested_r, nested_d, nested_g, nested_delta = (
        build_normalized_field()
    )
    field = nested_field
    from_simple = to_simple = lambda value: value
    beta, r, d, g, delta = [
        to_simple(value)
        for value in (nested_beta, nested_r, nested_d, nested_g, nested_delta)
    ]
    a = field.one()
    assert all(
        from_simple(to_simple(value)) == value
        for value in (nested_beta, nested_r, nested_d, nested_g, nested_delta)
    )
    progress("loaded the exact normalized one-parameter degree-24 field")

    def parse(value):
        return to_simple(nested_field(sage_eval(
            value,
            locals={"a": nested_field.one(), "beta": nested_beta, "r": nested_r,
                    "d": nested_d, "g": nested_g, "delta": nested_delta},
        )))

    ambient = PolynomialRing(field, names=("Y1", "Y2", "Y3", "Y4"))
    y1, y2, y3, y4 = ambient.gens()
    plane = PolynomialRing(field, names=("Z1", "Z2", "Z3"))
    z1, z2, z3 = plane.gens()
    quadric_monomials = [
        y1**2, y1 * y2, y1 * y3, y1 * y4, y2**2,
        y2 * y3, y2 * y4, y3**2, y3 * y4, y4**2,
    ]
    plane_cubic_monomials = [
        z1**3, z1**2 * z2, z1**2 * z3, z1 * z2**2, z1 * z2 * z3,
        z1 * z3**2, z2**3, z2**2 * z3, z2 * z3**2, z3**3,
    ]
    quadric_vectors = {
        coordinate: [parse(value) for value in blowdown["quadric_coefficients"][coordinate]]
        for coordinate in ("Z1", "Z2", "Z3")
    }
    quadrics = {
        coordinate: sum(
            (value * monomial for value, monomial in zip(vector, quadric_monomials)),
            ambient.zero(),
        )
        for coordinate, vector in quadric_vectors.items()
    }
    points = {
        name: [parse(value) for value in coordinates]
        for name, coordinates in blowdown["contracted_points"].items()
    }
    evaluation = Matrix(field, [
        [monomial(*point) for monomial in plane_cubic_monomials]
        for point in points.values()
    ])
    cubic_kernel = evaluation.right_kernel_matrix()
    assert cubic_kernel.nrows() == 4
    cubic_vectors = []
    for row in cubic_kernel.rows():
        vector = list(row)
        pivot = next(value for value in vector if value)
        pivot_inverse = ~pivot
        cubic_vectors.append([value * pivot_inverse for value in vector])
    plane_cubics = [sum(
        (value * monomial for value, monomial in zip(vector, plane_cubic_monomials)),
        plane.zero(),
    ) for vector in cubic_vectors]
    assert all(cubic(*point) == 0 for cubic in plane_cubics for point in points.values())
    progress("reconstructed the four cubics through the six marked points")

    target_line_forms = {"E0": [[0, 0, 1, 0], [0, 0, 0, 1]]}
    for index in range(1, 6):
        coefficients = {
            name: parse(value)
            for name, value in sections["sections"][f"E{index}"]["coefficients"].items()
        }
        target_line_forms[f"E{index}"] = [
            [1, 0, -coefficients["A"], -coefficients["B"]],
            [0, 1, -coefficients["C"], -coefficients["D"]],
        ]
    transformation_rows = []
    for name, point in points.items():
        tangent_vectors = [
            [cubic.derivative(variable)(*point) for cubic in plane_cubics]
            for variable in (z1, z2, z3)
        ]
        for line_form in target_line_forms[name]:
            for tangent_vector in tangent_vectors:
                transformation_rows.append([
                    line_form[row] * tangent_vector[column]
                    for row in range(4) for column in range(4)
                ])
    # The independent Rust quotient-algebra checker selects the same row basis
    # at three distinct prime specializations.  Reduce only this exact 15 by 16
    # submatrix over the function field, then certify the result against every
    # original incidence row.  This avoids an unnecessarily expensive RREF of
    # the full redundant matrix without weakening the exact assertion.
    alignment_row_indices = [7, 8, 12, 14, 10, 11, 15, 17, 1, 2, 18, 19, 3, 4, 24]
    alignment_matrix = Matrix(field, [
        transformation_rows[index] for index in alignment_row_indices
    ])
    transformation_kernel = alignment_matrix.right_kernel_matrix()
    assert transformation_kernel.nrows() == 1
    alignment_rank = 15  # rank-nullity for the 15 by 16 matrix
    transformation_vector = list(transformation_kernel.row(0))
    pivot = next(value for value in transformation_vector if value)
    pivot_inverse = ~pivot
    transformation_vector = [value * pivot_inverse for value in transformation_vector]
    transformation = Matrix(field, 4, 4, transformation_vector)
    if check_forward:
        assert transformation.det()
    assert all(
        sum(row[index] * transformation_vector[index] for index in range(16)) == 0
        for row in transformation_rows
    )
    inverse_cubic_vectors = [[
        sum(transformation[row, column] * cubic_vectors[column][monomial]
            for column in range(4))
        for monomial in range(10)
    ] for row in range(4)]
    progress("aligned the anticanonical system with the cubic surface")
    inverse_forms = [sum(
        (value * monomial for value, monomial in zip(vector, plane_cubic_monomials)),
        plane.zero(),
    ) for vector in inverse_cubic_vectors]

    if check_forward:
        cubic = (
            y3 * (a * y1**2 + 2 * a * y1 * y2 + (a**3 + beta) * y3**2)
            + y4 * (y1**2 + y1 * y2 + y2**2 - a**2 * y3**2 + y4**2)
        )
        inverse_hom = ambient.hom(inverse_forms, plane)
        assert inverse_hom(cubic).is_zero()
        progress("checked that the inverse forms land on the cubic surface")
        forward_after_inverse = [inverse_hom(quadrics[name]) for name in ("Z1", "Z2", "Z3")]
        assert forward_after_inverse[0] * z2 == forward_after_inverse[1] * z1
        assert forward_after_inverse[0] * z3 == forward_after_inverse[2] * z1
        progress("checked blowdown after inverse")
        if check_reverse:
            forward_hom = plane.hom([quadrics[name] for name in ("Z1", "Z2", "Z3")], ambient)
            inverse_after_forward = [forward_hom(form) for form in inverse_forms]
            coefficient_ring = PolynomialRing(field, names=("X1", "X2", "X3"))
            x1, x2, x3 = coefficient_ring.gens()
            univariate_ring = PolynomialRing(coefficient_ring, "X4")
            x4 = univariate_ring.gen()
            as_univariate = ambient.hom([x1, x2, x3, x4], univariate_ring)
            univariate_cubic = as_univariate(cubic)
            assert univariate_cubic.is_monic()
            for index, coordinate in enumerate((y1, y2, y3, y4)[1:], start=1):
                residual = inverse_after_forward[0] * coordinate - inverse_after_forward[index] * y1
                assert as_univariate(residual).quo_rem(univariate_cubic)[1].is_zero()
            progress("checked inverse after blowdown modulo the monic cubic equation")

    def text(value):
        return (str(from_simple(value)).replace("^", "**").replace("c958g", "g")
                .replace("c958r", "r").replace("c958d", "d")
                .replace("c958e", "delta"))

    plane_cubic_text = [[text(value) for value in vector] for vector in cubic_vectors]
    inverse_cubic_text = [[text(value) for value in vector]
                          for vector in inverse_cubic_vectors]
    lengths = [len(value) for vector in inverse_cubic_text for value in vector]
    progress("serialized the exact inverse coefficients")
    return {
        "schema": ("c958-type-i3-normalized-split-inverse-v1" if check_reverse else
                   "c958-type-i3-normalized-split-inverse-one-sided-v1" if check_forward else
                   "c958-type-i3-normalized-split-inverse-formulas-v1"),
        "input_sha256": {
            "blowdown": hashlib.sha256(blowdown_bytes).hexdigest(),
            "sections": hashlib.sha256(sections_bytes).hexdigest(),
            "blowdown_source": hashlib.sha256(BLOWDOWN_SOURCE.read_bytes()).hexdigest(),
        },
        "plane_cubic_monomial_order": [str(value) for value in plane_cubic_monomials],
        "normalization": {
            "base_parameter": "s=beta/a**3",
            "splitting_generators": ["R=r/a", "D=d/a", "g=g", "Delta=delta/a**2"],
            "surface_coordinates": ["X1=Y1/a", "X2=Y2/a", "X3=Y3", "X4=Y4/a"],
            "inverse_surface_coordinates": ["Y1=a*X1", "Y2=a*X2", "Y3=X3", "Y4=a*X4"],
            "dense_open": "a != 0",
        },
        "plane_cubic_coefficients": plane_cubic_text,
        "exceptional_line_alignment_rank": alignment_rank,
        "exceptional_line_alignment_row_indices": alignment_row_indices,
        "inverse_cubic_coefficients": inverse_cubic_text,
        "formula_characters": {
            "minimum": min(lengths), "maximum": max(lengths), "total": sum(lengths),
        },
        "certified": [
            "the displayed weight change identifies the original family over a != 0 with the normalized one-parameter family",
            "the cubics through the six marked points form a four-dimensional system",
            "exceptional-line incidence uniquely aligns it with the original cubic surface",
        ] + ([
            "the inverse cubic forms satisfy the original cubic equation",
            "the split blowdown after the inverse is projectively the plane identity",
        ] if check_forward else []) + ([
            "the inverse after the split blowdown is projectively the surface identity modulo the cubic equation",
        ] if check_reverse else []),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", type=Path)
    mode.add_argument("--write-one-sided", type=Path)
    mode.add_argument("--write-formulas", type=Path)
    mode.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    expected_schema = None
    if arguments.check:
        expected_schema = json.loads(arguments.check.read_text())["schema"]
    formulas_only = (
        arguments.write_formulas is not None
        or expected_schema == "c958-type-i3-normalized-split-inverse-formulas-v1"
    )
    one_sided = (
        arguments.write_one_sided is not None
        or expected_schema == "c958-type-i3-normalized-split-inverse-one-sided-v1"
    )
    payload = json.dumps(build(
        check_forward=not formulas_only,
        check_reverse=not one_sided and not formulas_only,
    ), indent=2, sort_keys=True) + "\n"
    if arguments.write:
        arguments.write.write_text(payload)
    elif arguments.write_one_sided:
        arguments.write_one_sided.write_text(payload)
    elif arguments.write_formulas:
        arguments.write_formulas.write_text(payload)
    else:
        assert arguments.check.read_text() == payload


if __name__ == "__main__":
    main()
