#!/usr/bin/env python3
"""Certify one uniform chart for norm-one tori of depressed cubic algebras."""

import argparse
import json
from pathlib import Path

import sympy as sp


def build():
    p, q = sp.symbols("p q")
    x0, x1, x2 = sp.symbols("x0 x1 x2")
    z0, z1, z2, h = sp.symbols("z0 z1 z2 h")
    u, v, w = sp.symbols("u v w")
    unit = sp.Matrix([1, 0, 0])

    def multiplication_matrix(coefficients):
        c0, c1, c2 = coefficients
        return sp.Matrix([
            [c0, -q * c2, -q * c1],
            [c1, c0 - p * c2, -p * c1 - q * c2],
            [c2, c1, c0 - p * c2],
        ])

    def norm(coefficients):
        return sp.factor(multiplication_matrix(coefficients).det())

    def trace(coefficients):
        return sp.trace(multiplication_matrix(coefficients))

    def second_symmetric_function(coefficients):
        matrix = multiplication_matrix(coefficients)
        return sp.factor((sp.trace(matrix) ** 2 - sp.trace(matrix * matrix)) / 2)

    x = sp.Matrix([x0, x1, x2])
    z = sp.Matrix([z0, z1, z2])
    norm_x = norm(x)
    norm_z = norm(z)
    quadric = sp.factor(second_symmetric_function(z) + h * trace(z) + h**2)
    variables = (z0, z1, z2, h)

    def evaluate_quadric(point):
        return sp.factor(quadric.subs(dict(zip(variables, point))))

    rational_point = sp.Matrix([p, 0, 1, -p])
    assert evaluate_quadric(rational_point) == 0
    plane_point = sp.Matrix([u, v, 0, w])
    plane_quadric = evaluate_quadric(plane_point)
    polar = sp.factor(
        evaluate_quadric(rational_point + plane_point)
        - evaluate_quadric(rational_point) - plane_quadric
    )
    plane_to_quadric = sp.simplify(
        plane_quadric * rational_point - polar * plane_point
    )
    assert evaluate_quadric(plane_to_quadric) == 0
    projected_back = sp.Matrix([
        plane_to_quadric[0] - p * plane_to_quadric[2],
        plane_to_quadric[1],
        plane_to_quadric[3] + p * plane_to_quadric[2],
    ])
    assert sp.simplify(
        projected_back + polar * sp.Matrix([u, v, w])
    ) == sp.zeros(3, 1)

    adjugate_z = multiplication_matrix(z).adjugate()[:, 0]
    torus_numerator = sp.simplify(norm_z * unit + h * adjugate_z)
    assert sp.factor(
        norm(torus_numerator) - norm_z**3 - h * quadric * norm_z**2
    ) == 0
    reconstructed_z = sp.simplify(
        norm_z * torus_numerator
        + multiplication_matrix(torus_numerator).adjugate()[:, 0]
        + (norm_z**2 - norm_z * trace(torus_numerator)) * unit
    )
    assert sp.simplify(reconstructed_z - h**2 * norm_z * z) == sp.zeros(3, 1)
    assert sp.factor(
        norm(torus_numerator - norm_z * unit) - h**3 * norm_z**2
    ) == 0

    adjugate_x = multiplication_matrix(x).adjugate()[:, 0]
    z_from_torus = sp.simplify(x + adjugate_x + (1 - trace(x)) * unit)
    h_from_torus = norm(x - unit)
    assert sp.factor(
        second_symmetric_function(z_from_torus)
        + h_from_torus * trace(z_from_torus) + h_from_torus**2
        - (norm_x - 1) * h_from_torus
    ) == 0
    composite = sp.simplify(
        norm(z_from_torus) * unit
        + h_from_torus * multiplication_matrix(z_from_torus).adjugate()[:, 0]
        - norm(z_from_torus) * x
    )
    assert composite == sp.zeros(3, 1)

    distinguished = sp.Matrix([1, p / q, 0])
    assert sp.factor(norm(distinguished) - 1) == 0
    point_z = sp.simplify(
        distinguished + multiplication_matrix(distinguished).adjugate()[:, 0]
        + (1 - trace(distinguished)) * unit
    )
    point_h = norm(distinguished - unit)
    point_scale = p**2 / q**2
    assert sp.simplify(point_z - point_scale * rational_point[:3, :]) == sp.zeros(3, 1)
    assert sp.factor(point_h - point_scale * rational_point[3]) == 0

    torus_to_plane = sp.Matrix([
        z_from_torus[0] - p * z_from_torus[2],
        z_from_torus[1],
        h_from_torus + p * z_from_torus[2],
    ])

    def strings(expressions):
        return [str(sp.factor(expression)) for expression in expressions]

    return {
        "schema": "c958-cubic-norm-torus-parametrization-v1",
        "cubic_etale_algebra": "E=K[rho]/(rho^3+p*rho+q)",
        "separability_open": "q*(4*p^3+27*q^2) != 0",
        "norm_polynomial": str(norm_x),
        "cremona_quadric": str(quadric),
        "quadric_rational_point": strings(rational_point),
        "plane_to_quadric": {
            "coordinates": strings(plane_to_quadric),
            "polar_exceptional_factor": str(polar),
            "inverse_projection": ["z0-p*z2", "z1", "h+p*z2"],
        },
        "quadric_to_torus": {
            "common_denominator": str(norm_z),
            "coordinate_numerators": strings(torus_numerator),
        },
        "torus_to_quadric": {
            "z_coordinates": strings(z_from_torus),
            "h_coordinate": str(sp.factor(h_from_torus)),
        },
        "torus_to_plane": strings(torus_to_plane),
        "type_i1_specialization": {"p": "-3*a^2", "q": "-beta"},
        "type_i3_specialization": {"p": "-a^2", "q": "a^3+beta"},
        "birational_open": "q*(4*p^3+27*q^2)*polar*h*N(Z) != 0",
        "certified": [
            "the norm-one cubic is Cremona-birational over K to the displayed quadric",
            "projection from [p:0:1:-p] parametrizes that quadric by P2",
            "x maps to (Z,h)=(x+x^-1+1-Tr(x),N(x-1)) and back by x=1+h/Z",
            "both composites are identities on the displayed dense open",
            "the type-I1 and type-I3 residual cubic algebras are both specializations",
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
