#!/usr/bin/env python3
"""Compute the split plane blowdown from the type-I1 exceptional lines."""

import argparse
import hashlib
import json
from pathlib import Path

import sympy as sp
from sympy.polys.matrices import DomainMatrix


ROOT = Path(__file__).resolve().parents[1]
INPUT = ROOT / "notes/2026-08-24-c958-type-i1-rational-splitting-cover.json"
EXPECTED_INPUT_SHA256 = "1b2d5a2a53baee1acae52e7ad566f3daacd3e72f79ad7b2bc24e0766129adefa"

a, z = sp.symbols("a z")
x1, x2, y3, y4 = sp.symbols("Y1 Y2 Y3 Y4")
s, t = sp.symbols("s t")
q_symbols = sp.symbols("q0:10")
MONOMIALS = [
    x1**2,
    x1 * x2,
    x1 * y3,
    x1 * y4,
    x2**2,
    x2 * y3,
    x2 * y4,
    y3**2,
    y3 * y4,
    y4**2,
]
GENERIC_QUADRIC = sum(coefficient * monomial for coefficient, monomial in zip(q_symbols, MONOMIALS))
FIELD = sp.QQ.frac_field(a, z)


def canonical(expression):
    return sp.factor(sp.cancel(expression))


def restriction_rows(substitution):
    restricted = sp.Poly(sp.together(GENERIC_QUADRIC.subs(substitution)), s, t)
    return [
        [sp.diff(restricted.coeff_monomial(monomial), coefficient) for coefficient in q_symbols]
        for monomial in (s**2, s * t, t**2)
    ]


def build():
    input_bytes = INPUT.read_bytes()
    assert hashlib.sha256(input_bytes).hexdigest() == EXPECTED_INPUT_SHA256
    source = json.loads(input_bytes)
    sections = source["sections"]
    r = sp.sympify(source["field_formulas"]["r"])
    d = sp.sympify(source["field_formulas"]["d"])

    def graph_substitution(name):
        coefficients = {
            symbol: sp.sympify(value)
            for symbol, value in sections[name]["coefficients"].items()
        }
        return {
            x1: coefficients["A"] * s + coefficients["B"] * t,
            x2: coefficients["C"] * s + coefficients["D"] * t,
            y3: s,
            y4: t,
        }

    def graph_rows(name):
        return restriction_rows(graph_substitution(name))

    def fibre_rows(sign):
        return restriction_rows(
            {
                x1: d * t,
                x2: -sign * (r - 2 * a) * t,
                y3: s,
                y4: r * s,
            }
        )

    common_rows = graph_rows("Q") + fibre_rows(1) + fibre_rows(-1)
    coordinate_divisors = {
        "Z1": ["E2", "E3", "L23"],
        "Z2": ["E1", "E3", "L13"],
        "Z3": ["E1", "E2", "L12"],
    }
    raw_vectors = {}
    interpolation_ranks = {}
    for coordinate, names in coordinate_divisors.items():
        rows = common_rows + sum((graph_rows(name) for name in names), [])
        matrix = DomainMatrix.from_Matrix(sp.Matrix(rows), fmt="sparse").convert_to(FIELD)
        nullspace = matrix.nullspace()
        assert matrix.rank() == 9 and nullspace.shape == (1, 10)
        vector = list(nullspace.to_Matrix())
        pivot = next(value for value in vector if value != 0)
        raw_vectors[coordinate] = [canonical(value / pivot) for value in vector]
        interpolation_ranks[coordinate] = matrix.rank()

    raw_quadrics = {
        coordinate: canonical(sum(value * monomial for value, monomial in zip(vector, MONOMIALS)))
        for coordinate, vector in raw_vectors.items()
    }

    def restriction_coefficients(quadric, substitution):
        polynomial = sp.Poly(sp.together(quadric.subs(substitution)), s, t)
        return [canonical(polynomial.coeff_monomial(monomial)) for monomial in (s**2, s * t, t**2)]

    line_substitutions = {"E0": {x1: s, x2: t, y3: 0, y4: 0}}
    line_substitutions.update({f"E{index}": graph_substitution(f"E{index}") for index in range(1, 6)})

    def contracted_points(quadrics):
        points = {}
        for name, substitution in line_substitutions.items():
            coefficient_matrix = [restriction_coefficients(quadric, substitution) for quadric in quadrics]
            domain_matrix = DomainMatrix.from_Matrix(sp.Matrix(coefficient_matrix)).convert_to(FIELD)
            assert domain_matrix.rank() == 1
            column = next(
                [coefficient_matrix[row][column] for row in range(3)]
                for column in range(3)
                if any(coefficient_matrix[row][column] != 0 for row in range(3))
            )
            pivot = next(value for value in column if value != 0)
            points[name] = [canonical(value / pivot) for value in column]
        return points

    raw_points = contracted_points([raw_quadrics[name] for name in ("Z1", "Z2", "Z3")])
    assert raw_points["E4"][0] == 1
    scalars = [sp.Integer(1), canonical(1 / raw_points["E4"][1]), canonical(1 / raw_points["E4"][2])]
    vectors = {
        coordinate: [canonical(scalar * value) for value in raw_vectors[coordinate]]
        for coordinate, scalar in zip(("Z1", "Z2", "Z3"), scalars)
    }
    quadrics = {
        coordinate: canonical(sum(value * monomial for value, monomial in zip(vector, MONOMIALS)))
        for coordinate, vector in vectors.items()
    }
    ordered_quadrics = [quadrics[name] for name in ("Z1", "Z2", "Z3")]
    points = contracted_points(ordered_quadrics)

    A0 = canonical((z - 1) * (z + 3) * (z**2 - 3) / (2 * z * (z**2 - 6 * z - 3)))
    B0 = canonical(-(z - 3) * (z + 1) * (z**2 - 3) / (2 * z * (z**2 + 6 * z - 3)))
    expected_points = {
        "E0": [1, A0, B0],
        "E1": [1, 0, 0],
        "E2": [0, 1, 0],
        "E3": [0, 0, 1],
        "E4": [1, 1, 1],
        "E5": [1, A0**2, B0**2],
    }
    for name in points:
        assert all(canonical(left - right) == 0 for left, right in zip(points[name], expected_points[name]))
    for left_index, left in enumerate(points):
        for right in list(points)[left_index + 1 :]:
            minors = [
                canonical(points[left][i] * points[right][j] - points[left][j] * points[right][i])
                for i in range(3)
                for j in range(i + 1, 3)
            ]
            assert any(value != 0 for value in minors)

    coefficient_matrix = DomainMatrix.from_Matrix(
        sp.Matrix([vectors[name] for name in ("Z1", "Z2", "Z3")])
    ).convert_to(FIELD)
    assert coefficient_matrix.rank() == 3
    assert sp.gcd(sp.gcd(ordered_quadrics[0], ordered_quadrics[1]), ordered_quadrics[2]) == 1

    common_lines = ["Q", "F1+", "F1-"]
    all_line_rows = {
        "Q": graph_rows("Q"),
        "F1+": fibre_rows(1),
        "F1-": fibre_rows(-1),
    }
    all_line_rows.update({name: graph_rows(name) for names in coordinate_divisors.values() for name in names})
    for coordinate, vector in vectors.items():
        for name in common_lines + coordinate_divisors[coordinate]:
            for row in all_line_rows[name]:
                assert canonical(sum(entry * value for entry, value in zip(row, vector))) == 0

    lengths = [len(str(value)) for vector in vectors.values() for value in vector]
    return {
        "schema": "c958-type-i1-split-blowdown-v1",
        "input_sha256": EXPECTED_INPUT_SHA256,
        "quadric_monomial_order": [str(monomial) for monomial in MONOMIALS],
        "common_twisted_cubic": "Q+F1++F1- = Q0+L01+Q1",
        "coordinate_divisors": coordinate_divisors,
        "interpolation_ranks": interpolation_ranks,
        "quadric_coefficients": {
            coordinate: [str(value) for value in vectors[coordinate]]
            for coordinate in ("Z1", "Z2", "Z3")
        },
        "contracted_points": {
            name: [str(value) for value in points[name]]
            for name in ("E0", "E1", "E2", "E3", "E4", "E5")
        },
        "split_quartic_moduli": {"a_split": str(A0**2), "b_split": str(B0**2)},
        "distinguished_sixth_point": ["1", str(A0), str(B0)],
        "coefficient_formula_characters": {
            "minimum": min(lengths),
            "maximum": max(lengths),
            "total": sum(lengths),
        },
        "certified": [
            "each coordinate quadric is the unique quadric through its six displayed lines",
            "the three quadrics are linearly independent and have no ambient common factor",
            "their restrictions contract the six disjoint lines to the displayed distinct points",
            "the first five quartic blowup points have the standard marked form",
            "the sixth cubic blowup point is the coordinatewise square root of the fifth quartic point",
        ],
        "not_certified": [
            "the inverse anticanonical cubic map from the marked plane",
            "Galois descent of the split blowdown",
            "a scalar-normalized universal-torsor Cox embedding",
            "maps for the stabilized cubic product",
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
