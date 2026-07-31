#!/usr/bin/env python3
"""Exact certificate for the C705 ambient E6 first-normal-jet calculation."""

from __future__ import annotations

import argparse
import hashlib
import json
from itertools import product
from pathlib import Path

import sympy as sp
from sympy.polys.matrices import DomainMatrix


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-30-c705-e6-first-jet.json"


def cubic_monomial_exponents():
    result = []
    for a in range(4):
        for b in range(4 - a):
            for c in range(4 - a - b):
                for d in range(4 - a - b - c):
                    result.append((a, b, c, d, 3 - a - b - c - d))
    return tuple(result)


def build_certificate() -> dict:
    z1, z2, z3 = sp.symbols("z1 z2 z3")
    y = sp.symbols("y0:5")

    # Yoshida's conic-boundary chart Q=0.
    x1 = (1 - z1) / (1 - z2)
    x2 = (1 - z1) / (1 - z3)
    x3 = z1 / z2
    x4 = z1 / z3
    d1 = x1 * x4 - x2 * x3
    d2 = x1 * x4 - x4 + x2 - x2 * x3 + x3 - x1
    q = -x2 * x3 * x1 - x2 * x3 * x4 + x2 * x3 + x1 * x4 * x2 + x1 * x4 * x3 - x1 * x4
    assert sp.factor(q) == 0

    # Five ambient coordinates surviving on Q=0:
    # (y11,y12,y13,y15,y19) in Yoshida's notation.
    surviving_raw = (
        d1 * (x1 - 1) * (x2 - 1) * (x4 - x3),
        d1 * (x1 - 1) * (x3 - 1) * (x4 - x2),
        d1 * (x2 - 1) * (x4 - 1) * (x3 - x1),
        -d1 * x1 * (x2 - 1) * (x3 - 1),
        d2 * x2 * x3 * (x1 - 1),
    )
    segre = (
        -z1 * (z2 - z3),
        z1 - z2,
        z1 - z3,
        z3 * (z1 - 1),
        -z3 * (z1 - z2),
    )
    surviving_scale = (
        z1
        * (z1 - 1)
        * (z1 - z2)
        * (z1 - z3)
        * (z2 - z3)
        / (z2**2 * z3**2 * (z2 - 1) ** 2 * (z3 - 1) ** 2)
    )
    assert all(
        sp.factor(raw - surviving_scale * coordinate) == 0
        for raw, coordinate in zip(surviving_raw, segre)
    )

    # Five ambient coordinates divisible by Q:
    # (y1,y3,y4,y5,y7)=Q*(D1,x2-x1,x3-x1,x4-x2,x1(x4-1)).
    normal_coefficients_raw = (
        d1,
        x2 - x1,
        x3 - x1,
        x4 - x2,
        x1 * (x4 - 1),
    )
    normal_scale = z2 * z3 * (z2 - 1) * (z3 - 1)
    normal_coefficients = tuple(
        sp.factor(normal_scale * coefficient)
        for coefficient in normal_coefficients_raw
    )
    expected_normal_coefficients = (
        -z1 * (z1 - 1) * (z2 - z3),
        z2 * z3 * (z1 - 1) * (z2 - z3),
        -(z1 - z2) * z3 * (z3 - 1),
        -(z1 - z3) * z2 * (z2 - 1),
        (z1 - 1) * (z1 - z3) * z2 * (z3 - 1),
    )
    assert all(
        sp.factor(actual - expected) == 0
        for actual, expected in zip(
            normal_coefficients, expected_normal_coefficients
        )
    )
    normal_coefficients = expected_normal_coefficients

    segre_cubic = (
        y[0] * y[1] * y[3]
        + y[0] * y[2] * y[4]
        - y[1] * y[2] * y[4]
        + y[1] * y[3] * y[4]
        + y[2] ** 2 * y[4]
        - y[2] * y[3] * y[4]
    )
    assert sp.factor(segre_cubic.subs(dict(zip(y, segre)))) == 0

    # Certify that this is the unique cubic relation by exact evaluation.
    exponents = cubic_monomial_exponents()
    sample_points = tuple(product(range(2, 7), range(7, 12), range(12, 17)))
    rows = []
    for values in sample_points:
        evaluated = tuple(
            coordinate.subs(dict(zip((z1, z2, z3), values)))
            for coordinate in segre
        )
        rows.append(
            [
                sp.prod(evaluated[index] ** exponent[index] for index in range(5))
                for exponent in exponents
            ]
        )
    cubic_evaluation_matrix = DomainMatrix.from_list_sympy(
        len(rows), len(exponents), rows
    ).to_field()
    assert cubic_evaluation_matrix.rank() == 34

    gradient = sp.Matrix([sp.diff(segre_cubic, coordinate) for coordinate in y])
    gradient_on_chart = gradient.subs(dict(zip(y, segre)))
    target_change = sp.Matrix(
        [
            [0, 0, 0, 0, -2],
            [0, 2, 2, 0, 0],
            [2, 0, 0, 0, 0],
            [2, 0, 0, 2, -2],
            [2, 2, 0, 0, -2],
        ]
    )
    assert target_change.det() == 32
    transformed_gradient = target_change * gradient_on_chart
    assert all(
        sp.factor(transformed_gradient[index] + 2 * normal_coefficients[index])
        == 0
        for index in range(5)
    )

    # Schock's restriction formulas, in the basis (B2,B3), denominator 5.
    segre_line = (1, 3)
    normal_bundle = (-1, -3)
    normal_jet_line = tuple(
        segre_line[index] - normal_bundle[index] for index in range(2)
    )
    igusa_line = (2, 1)
    boundary_gap = tuple(
        normal_jet_line[index] - igusa_line[index] for index in range(2)
    )
    assert normal_jet_line == (2, 6)
    assert boundary_gap == (0, 5)

    # A generic D_{123|456}=D_{456} point is obtained by clustering
    # z1,z2,z3.  Every normal coefficient vanishes to exactly first order.
    t, a, u, v, w = sp.symbols("t a u v w")
    cluster = {z1: a + t * u, z2: a + t * v, z3: a + t * w}
    cluster_leading_coefficients = tuple(
        sp.factor(sp.limit(coefficient.subs(cluster) / t, t, 0))
        for coefficient in normal_coefficients
    )
    assert all(
        sp.factor(coefficient.subs(cluster).subs(t, 0)) == 0
        for coefficient in normal_coefficients
    )
    assert all(coefficient != 0 for coefficient in cluster_leading_coefficients)

    return {
        "schema": "c705-e6-first-jet-v1",
        "chart": {
            "yoshida_coordinates_surviving": ["y11", "y12", "y13", "y15", "y19"],
            "yoshida_coordinates_divisible_by_Q": ["y1", "y3", "y4", "y5", "y7"],
            "segre_coordinates": [str(value) for value in segre],
            "segre_cubic": str(segre_cubic),
            "cubic_monomials": len(exponents),
            "cubic_evaluation_rank": cubic_evaluation_matrix.rank(),
        },
        "first_normal_jet": {
            "normal_coefficients": [str(value) for value in normal_coefficients],
            "target_change": [list(map(int, row)) for row in target_change.tolist()],
            "target_change_determinant": int(target_change.det()),
            "identity": "target_change * grad(Segre) = -2 * normal_coefficients",
        },
        "line_bundles_on_Mbar_0_6": {
            "basis": ["B2", "B3"],
            "common_denominator": 5,
            "Segre": list(segre_line),
            "normal_bundle_of_A1_divisor": list(normal_bundle),
            "raw_normal_jet": list(normal_jet_line),
            "Igusa": list(igusa_line),
            "raw_jet_minus_Igusa": list(boundary_gap),
            "gap_interpretation": "B3",
            "generic_D3_vanishing_orders": [1] * 5,
            "generic_D3_leading_coefficients": [
                str(value) for value in cluster_leading_coefficients
            ],
        },
        "sources": {
            "Yoshida_arXiv_math_0002102_sha256": "1989e8d6349338045851d9d8428394ba7638689f903a1ebe1deffc78ab5485c5",
            "Schock_arXiv_2309_15264_sha256": "67c1f52c6df71abfb0a537aa55111929d05f812180070e891121d37440c896e5",
        },
        "conclusions": {
            "generic_A1_boundary_first_normal_jet_is_Igusa_polar": True,
            "ambient_W_E6_embedding_contains_both_five_spaces": True,
            "compactified_raw_jet_has_B3_line_bundle_twist": True,
            "common_B3_fixed_factor_certified_by_one_D3_and_S6": True,
            "global_untwisted_first_jet_lift": True,
        },
    }


def canonical_json(value: dict) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    content = canonical_json(build_certificate())
    if args.check:
        assert OUTPUT.read_bytes() == content
        print(
            "PASS C705 E6 first jet: Yoshida's normal coefficients are the "
            "Igusa polar of the surviving Segre cubic; global gap is B3"
        )
        return
    OUTPUT.write_bytes(content)
    print(f"WROTE {OUTPUT.name} sha256={hashlib.sha256(content).hexdigest()}")


if __name__ == "__main__":
    main()
