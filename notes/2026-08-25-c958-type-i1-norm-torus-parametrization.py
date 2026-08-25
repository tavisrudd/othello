#!/usr/bin/env python3
"""Certify an explicit parametrization of the type-I1 cubic norm-one torus."""

import argparse
import json
from pathlib import Path

import sympy as sp


def build():
    a, beta = sp.symbols("a beta")
    x0, x1, x2 = sp.symbols("x0 x1 x2")
    z0, z1, z2, h = sp.symbols("z0 z1 z2 h")
    u, v, w = sp.symbols("u v w")
    unit = sp.Matrix([1, 0, 0])

    def multiplication_matrix(coefficients):
        c0, c1, c2 = coefficients
        return sp.Matrix(
            [
                [c0, beta * c2, beta * c1],
                [c1, c0 + 3 * a**2 * c2, 3 * a**2 * c1 + beta * c2],
                [c2, c1, c0 + 3 * a**2 * c2],
            ]
        )

    def norm(coefficients):
        return sp.factor(multiplication_matrix(coefficients).det())

    def trace(coefficients):
        return sp.trace(multiplication_matrix(coefficients))

    def second_symmetric_function(coefficients):
        return sp.factor(
            (
                trace(coefficients) ** 2
                - trace(multiplication_matrix(coefficients) * coefficients)
            )
            / 2
        )

    x = sp.Matrix([x0, x1, x2])
    norm_x = norm(x)
    expected_norm = (
        x0**3
        + beta * x1**3
        + beta**2 * x2**3
        - 3 * beta * x0 * x1 * x2
        + 6 * a**2 * x0**2 * x2
        - 3 * a**2 * x0 * x1**2
        + 9 * a**4 * x0 * x2**2
        - 3 * a**2 * beta * x1 * x2**2
    )
    assert sp.expand(norm_x - expected_norm) == 0

    z = sp.Matrix([z0, z1, z2])
    norm_z = norm(z)
    quadric = sp.factor(
        second_symmetric_function(z) + h * trace(z) + h**2
    )
    expected_quadric = (
        9 * a**4 * z2**2
        + 6 * a**2 * h * z2
        + 12 * a**2 * z0 * z2
        - 3 * a**2 * z1**2
        - 3 * beta * z1 * z2
        + h**2
        + 3 * h * z0
        + 3 * z0**2
    )
    assert sp.expand(quadric - expected_quadric) == 0

    rational_point = sp.Matrix([-3 * a**2, 0, 1, 3 * a**2])
    quadric_variables = (z0, z1, z2, h)

    def evaluate_quadric(point):
        return sp.factor(quadric.subs(dict(zip(quadric_variables, point))))

    assert evaluate_quadric(rational_point) == 0

    hyperplane_point = sp.Matrix([u, v, 0, w])
    quadric_on_hyperplane = evaluate_quadric(hyperplane_point)
    polar = sp.factor(
        evaluate_quadric(rational_point + hyperplane_point)
        - evaluate_quadric(rational_point)
        - quadric_on_hyperplane
    )
    expected_hyperplane_quadric = -3 * a**2 * v**2 + 3 * u**2 + 3 * u * w + w**2
    expected_polar = 3 * (a**2 * u + a**2 * w - beta * v)
    assert sp.expand(quadric_on_hyperplane - expected_hyperplane_quadric) == 0
    assert sp.expand(polar - expected_polar) == 0

    quadric_parametrization = sp.simplify(
        quadric_on_hyperplane * rational_point - polar * hyperplane_point
    )
    assert evaluate_quadric(quadric_parametrization) == 0
    projected_back = sp.Matrix(
        [
            quadric_parametrization[0] + 3 * a**2 * quadric_parametrization[2],
            quadric_parametrization[1],
            quadric_parametrization[3] - 3 * a**2 * quadric_parametrization[2],
        ]
    )
    assert sp.simplify(projected_back + polar * sp.Matrix([u, v, w])) == sp.zeros(3, 1)

    adjugate_z = multiplication_matrix(z).adjugate()[:, 0]
    torus_numerator = sp.simplify(norm_z * unit + h * adjugate_z)
    assert sp.factor(
        norm(torus_numerator) - norm_z**3 - h * quadric * norm_z**2
    ) == 0

    reconstructed_z_numerator = sp.simplify(
        norm_z * torus_numerator
        + multiplication_matrix(torus_numerator).adjugate()[:, 0]
        + (norm_z**2 - norm_z * trace(torus_numerator)) * unit
    )
    assert sp.simplify(reconstructed_z_numerator - h**2 * norm_z * z) == sp.zeros(3, 1)
    assert sp.factor(
        norm(torus_numerator - norm_z * unit) - h**3 * norm_z**2
    ) == 0

    adjugate_x = multiplication_matrix(x).adjugate()[:, 0]
    z_from_torus = sp.simplify(x + adjugate_x + (1 - trace(x)) * unit)
    h_from_torus = norm(x - unit)
    quadric_from_torus = sp.factor(
        second_symmetric_function(z_from_torus)
        + h_from_torus * trace(z_from_torus)
        + h_from_torus**2
    )
    assert sp.factor(quadric_from_torus - (norm_x - 1) * h_from_torus) == 0
    norm_z_from_torus = norm(z_from_torus)
    torus_composite_numerator = sp.simplify(
        norm_z_from_torus * unit
        + h_from_torus * multiplication_matrix(z_from_torus).adjugate()[:, 0]
    )
    assert sp.simplify(torus_composite_numerator - norm_z_from_torus * x) == sp.zeros(3, 1)

    distinguished_torus_point = sp.Matrix([1, 3 * a**2 / beta, 0])
    assert sp.factor(norm(distinguished_torus_point) - 1) == 0
    point_z = sp.simplify(
        distinguished_torus_point
        + multiplication_matrix(distinguished_torus_point).adjugate()[:, 0]
        + (1 - trace(distinguished_torus_point)) * unit
    )
    point_h = norm(distinguished_torus_point - unit)
    point_scale = sp.factor(9 * a**4 / beta**2)
    assert sp.simplify(point_z - point_scale * rational_point[:3, :]) == sp.zeros(3, 1)
    assert sp.factor(point_h - point_scale * rational_point[3]) == 0

    plane_inverse = sp.Matrix(
        [
            z_from_torus[0] + 3 * a**2 * z_from_torus[2],
            z_from_torus[1],
            h_from_torus - 3 * a**2 * z_from_torus[2],
        ]
    )

    def strings(expressions):
        return [str(sp.factor(expression)) for expression in expressions]

    plane_to_quadric_strings = strings(quadric_parametrization)
    quadric_to_torus_strings = strings(torus_numerator)
    torus_to_plane_strings = strings(plane_inverse)
    return {
        "schema": "c958-type-i1-norm-torus-parametrization-v1",
        "cubic_etale_algebra": "E=K[rho]/(rho^3-3*a^2*rho-beta)",
        "norm_polynomial": str(norm_x),
        "cremona_quadric": str(quadric),
        "quadric_rational_point": strings(rational_point),
        "plane_to_quadric": {
            "coordinates": plane_to_quadric_strings,
            "polar_exceptional_factor": str(polar),
            "inverse_projection": ["z0+3*a^2*z2", "z1", "h-3*a^2*z2"],
        },
        "quadric_to_torus": {
            "common_denominator": str(norm_z),
            "coordinate_numerators": quadric_to_torus_strings,
        },
        "torus_to_quadric": {
            "z_coordinates": strings(z_from_torus),
            "h_coordinate": str(sp.factor(h_from_torus)),
        },
        "torus_to_plane": torus_to_plane_strings,
        "birational_open": "polar*h*N(Z) != 0",
        "formula_sizes": {
            "plane_to_quadric_total": sum(map(len, plane_to_quadric_strings)),
            "quadric_to_torus_total": sum(map(len, quadric_to_torus_strings)) + len(str(norm_z)),
            "torus_to_plane_total": sum(map(len, torus_to_plane_strings)),
        },
        "certified": [
            "the norm-one cubic is Cremona-birational over K to the displayed quadric",
            "the quadric has the displayed K-rational point",
            "projection from that point gives the displayed birational map from P2",
            "x maps to (Z,h)=(x+x^-1+1-Tr(x),N(x-1)) on N(x)=1",
            "the inverse map is x=1+h/Z",
            "both composites are identities on the stated dense open",
            "the complete parametrization and inverse use only a,beta and two projective parameters",
        ],
        "not_certified": [
            "the equivariant universal-torsor translation coupling this chart to the quartic del Pezzo surface",
            "the final stabilized maps for the cubic family",
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
