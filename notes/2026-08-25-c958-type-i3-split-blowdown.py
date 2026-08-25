#!/usr/bin/env sage-python
"""Compute the type-I3 six-line blowdown over its degree-24 splitting field."""

import argparse
import hashlib
import json
from pathlib import Path
import sys

from sage.all import QQ, FunctionField, Matrix, PolynomialRing
from sage.misc.sage_eval import sage_eval

if sys.flags.optimize:
    raise RuntimeError("verification must run with Python assertions enabled")


ROOT = Path(__file__).resolve().parents[1]
INPUT = ROOT / "notes/2026-08-25-c958-type-i3-exceptional-sections.json"


def build_field():
    first = FunctionField(QQ, "a")
    base = FunctionField(first, "beta")
    a, beta = base(first.gen()), base.gen()
    polynomial = PolynomialRing(base, "x")
    x = polynomial.gen()
    with_g = base.extension(x**2 - 3, "c958g")
    a, beta, g = with_g(a), with_g(beta), with_g.gen()
    polynomial = PolynomialRing(with_g, "x")
    x = polynomial.gen()
    with_r = with_g.extension(x**3 - a**2 * x + a**3 + beta, "c958r")
    a, beta, g, r = with_r(a), with_r(beta), with_r(g), with_r.gen()
    polynomial = PolynomialRing(with_r, "x")
    x = polynomial.gen()
    with_d = with_r.extension(x**2 + 3 * r**2 - 4 * a**2, "c958d")
    a, beta, g, r, d = (
        with_d(a), with_d(beta), with_d(g), with_d(r), with_d.gen(),
    )
    delta_squared = (-32 * g - 52) * a**4 - (24 * g + 36) * a * beta
    polynomial = PolynomialRing(with_d, "x")
    x = polynomial.gen()
    field = with_d.extension(x**2 - delta_squared, "c958e")
    return field, field(a), field(beta), field(r), field(d), field(g), field.gen()


def build():
    input_bytes = INPUT.read_bytes()
    source = json.loads(input_bytes)
    sections = source["sections"]
    field, a, beta, r, d, g, delta = build_field()
    ambient = PolynomialRing(field, names=("Y1", "Y2", "Y3", "Y4"))
    y1, y2, y3, y4 = ambient.gens()
    line_ring = PolynomialRing(field, names=("s", "t"))
    s, t = line_ring.gens()
    monomials = [
        y1**2, y1 * y2, y1 * y3, y1 * y4, y2**2,
        y2 * y3, y2 * y4, y3**2, y3 * y4, y4**2,
    ]

    def parse(value):
        return field(sage_eval(
            value,
            locals={"a": a, "beta": beta, "r": r, "d": d, "g": g,
                    "delta": delta},
        ))

    def graph(name):
        coefficients = sections[name]["coefficients"]
        return (
            parse(coefficients["A"]) * s + parse(coefficients["B"]) * t,
            parse(coefficients["C"]) * s + parse(coefficients["D"]) * t,
            s, t,
        )

    def fibre(sign):
        return ((r + 2 * a + sign * d) * t, -2 * (r + a) * t, s, r * s)

    def restriction_rows(substitution):
        rows = [[], [], []]
        hom = ambient.hom(substitution, line_ring)
        for monomial in monomials:
            value = hom(monomial)
            rows[0].append(value.monomial_coefficient(s**2))
            rows[1].append(value.monomial_coefficient(s * t))
            rows[2].append(value.monomial_coefficient(t**2))
        return rows

    graph_rows = {name: restriction_rows(graph(name)) for name in sections}
    fibre_rows = {sign: restriction_rows(fibre(sign)) for sign in (1, -1)}
    common_rows = graph_rows["Q"] + fibre_rows[1] + fibre_rows[-1]
    coordinate_divisors = {
        "Z1": ["E2", "E3", "L23"],
        "Z2": ["E1", "E3", "L13"],
        "Z3": ["E1", "E2", "L12"],
    }
    vectors = {}
    ranks = {}
    for coordinate, names in coordinate_divisors.items():
        rows = common_rows + sum((graph_rows[name] for name in names), [])
        matrix = Matrix(field, rows)
        kernel = matrix.right_kernel_matrix()
        assert matrix.rank() == 9 and kernel.nrows() == 1
        vector = list(kernel.row(0))
        pivot = next(value for value in vector if value)
        vectors[coordinate] = [value / pivot for value in vector]
        ranks[coordinate] = matrix.rank()

    quadrics = {
        coordinate: sum((value * monomial for value, monomial in zip(vector, monomials)),
                        ambient.zero())
        for coordinate, vector in vectors.items()
    }

    line_substitutions = {"E0": (s, t, line_ring.zero(), line_ring.zero())}
    line_substitutions.update({f"E{index}": graph(f"E{index}") for index in range(1, 6)})

    def contracted_points(current_quadrics):
        points = {}
        for name, substitution in line_substitutions.items():
            hom = ambient.hom(substitution, line_ring)
            coefficient_rows = []
            for quadric in current_quadrics:
                value = hom(quadric)
                coefficient_rows.append([
                    value.monomial_coefficient(s**2),
                    value.monomial_coefficient(s * t),
                    value.monomial_coefficient(t**2),
                ])
            matrix = Matrix(field, coefficient_rows)
            assert matrix.rank() == 1
            column = next(matrix.column(index) for index in range(3) if matrix.column(index))
            pivot = next(value for value in column if value)
            points[name] = [value / pivot for value in column]
        return points

    ordered = [quadrics[name] for name in ("Z1", "Z2", "Z3")]
    raw_points = contracted_points(ordered)
    assert raw_points["E4"][0] == 1
    scales = [field.one(), 1 / raw_points["E4"][1], 1 / raw_points["E4"][2]]
    vectors = {
        coordinate: [scale * value for value in vectors[coordinate]]
        for coordinate, scale in zip(("Z1", "Z2", "Z3"), scales)
    }
    quadrics = {
        coordinate: sum((value * monomial for value, monomial in zip(vector, monomials)),
                        ambient.zero())
        for coordinate, vector in vectors.items()
    }
    ordered = [quadrics[name] for name in ("Z1", "Z2", "Z3")]
    points = contracted_points(ordered)
    expected_standard = {
        "E1": [1, 0, 0], "E2": [0, 1, 0], "E3": [0, 0, 1],
        "E4": [1, 1, 1],
    }
    for name, expected in expected_standard.items():
        assert points[name] == list(map(field, expected))
    assert points["E0"][0] == 1 and points["E5"][0] == 1
    assert points["E5"][1] == points["E0"][1] ** 2
    assert points["E5"][2] == points["E0"][2] ** 2
    for left_index, left in enumerate(points):
        for right in list(points)[left_index + 1:]:
            assert any(
                points[left][i] * points[right][j] != points[left][j] * points[right][i]
                for i in range(3) for j in range(i + 1, 3)
            )
    assert Matrix(field, [vectors[name] for name in ("Z1", "Z2", "Z3")]).rank() == 3
    assert ordered[0].gcd(ordered[1]).gcd(ordered[2]).is_one()

    def text(value):
        return (str(value).replace("^", "**").replace("c958g", "g")
                .replace("c958r", "r").replace("c958d", "d")
                .replace("c958e", "delta"))

    lengths = [len(text(value)) for vector in vectors.values() for value in vector]
    return {
        "schema": "c958-type-i3-split-blowdown-v1",
        "input_sha256": hashlib.sha256(input_bytes).hexdigest(),
        "field_tower": [
            "g^2=3", "r^3-a^2*r+a^3+beta=0", "d^2+3*r^2-4*a^2=0",
            "delta^2=(-32*g-52)*a^4-(24*g+36)*a*beta",
        ],
        "quadric_monomial_order": [str(monomial) for monomial in monomials],
        "coordinate_divisors": coordinate_divisors,
        "interpolation_ranks": ranks,
        "quadric_coefficients": {
            coordinate: [text(value) for value in vectors[coordinate]]
            for coordinate in ("Z1", "Z2", "Z3")
        },
        "contracted_points": {
            name: [text(value) for value in points[name]]
            for name in ("E0", "E1", "E2", "E3", "E4", "E5")
        },
        "split_quartic_moduli": {
            "a_split": text(points["E5"][1]),
            "b_split": text(points["E5"][2]),
        },
        "distinguished_sixth_point": [text(value) for value in points["E0"]],
        "coefficient_formula_characters": {
            "minimum": min(lengths), "maximum": max(lengths), "total": sum(lengths),
        },
        "certified": [
            "each coordinate quadric is the unique quadric through its six lines",
            "the quadrics contract six disjoint lines to the standard marked points",
            "the fifth quartic point is the coordinatewise square of the cubic sixth point",
            "the three quadrics are independent and have no common ambient factor",
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
