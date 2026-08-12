#!/usr/bin/env sage -python
"""Generate/check the exact C907 toric codimension-two pilot certificate."""

import argparse
import json
from pathlib import Path

from sage.all import Matrix, PolynomialRing, QQ, vector


SCHEMA = "c907-toric-r2-pilot-v1"


def build_certificate():
    rays = [
        [-1, -1, -1, -1, -1],
        [1, 0, 0, 0, 0],
        [0, 1, 0, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 0, 1, 0],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 1, 1],
    ]
    line = [1, 1, 1, 1, 1, 1, 0]
    fibre = [0, 0, 0, 0, 1, 1, -1]
    line_minus_fibre = [a - b for a, b in zip(line, fibre)]
    ray_matrix = Matrix(QQ, rays).transpose()
    assert ray_matrix * vector(QQ, line) == 0
    assert ray_matrix * vector(QQ, fibre) == 0
    assert ray_matrix * vector(QQ, line_minus_fibre) == 0
    assert sum(line_minus_fibre) == 5
    assert sum(fibre) == 1

    ring = PolynomialRing(QQ, names=("u", "q", "t"))
    u, q, t = ring.gens()
    critical_polynomial = u**4 * (u - 1) ** 6 - q * t**6
    derivative = critical_polynomial.derivative(u)
    assert derivative == 2 * u**3 * (u - 1) ** 5 * (5 * u - 2)

    frac = ring.fraction_field()
    uf, qf, tf = frac.gens()
    b = (uf - 1) / tf
    a = b * uf
    critical_value = 4 * a + 2 * b + tf * b**2
    assert critical_value == (5 * uf**2 - 4 * uf - 1) / tf
    assert a**4 * b**2 == uf**4 * (uf - 1) ** 6 / tf**6

    asym_ring = PolynomialRing(QQ, names=("c", "s"))
    c, s = asym_ring.gens()

    ambient_u = 1 + c * s - QQ(2) / 3 * c**2 * s**2
    ambient_equation = ambient_u**4 * (ambient_u - 1) ** 6 - c**6 * s**6
    assert ambient_equation.coefficient({s: 6}) == 0
    assert ambient_equation.coefficient({s: 7}) == 0
    ambient_numerator = 5 * ambient_u**2 - 4 * ambient_u - 1
    assert ambient_numerator.coefficient({s: 1}) == 6 * c
    assert ambient_numerator.coefficient({s: 2}) == c**2

    residual_u = c * s**3 + QQ(3) / 2 * c**2 * s**6
    residual_equation = residual_u**4 * (residual_u - 1) ** 6 - c**4 * s**12
    assert residual_equation.coefficient({s: 12}) == 0
    assert residual_equation.coefficient({s: 15}) == 0
    residual_numerator = 5 * residual_u**2 - 4 * residual_u - 1
    assert residual_numerator.coefficient({s: 3}) == -4 * c
    assert residual_numerator.coefficient({s: 6}) == -c**2

    return {
        "schema": SCHEMA,
        "fan": {
            "rays": rays,
            "relation_basis": [line, fibre],
            "mori_generators": [line_minus_fibre, fibre],
            "anticanonical_degrees": [5, 1],
            "smooth_fano": True,
        },
        "mirror": {
            "potential": "x1+x2+x3+x4+x5+Q/(x1*x2*x3*x4*x5)+t*x4*x5",
            "critical_reduction": [
                "x1=x2=x3=a",
                "x4=x5=b",
                "a=b+t*b^2",
                "Q=a^4*b^2",
            ],
            "u_equation": "u^4*(u-1)^6=Q*t^6",
            "critical_value": "(5*u^2-4*u-1)/t",
            "generic_critical_point_count": 10,
            "cohomology_rank": 10,
        },
        "asymptotics": {
            "ambient": {
                "count": 6,
                "root_relation": "c^6=Q",
                "u": "1+c*t-(2/3)*c^2*t^2+O(t^3)",
                "critical_value": "6*c+c^2*t+O(t^2)",
            },
            "residual": {
                "count": 4,
                "root_relation": "c^4=Q",
                "u": "c*t^(3/2)+(3/2)*c^2*t^3+O(t^(9/2))",
                "critical_value": "-t^(-1)-4*c*t^(1/2)-c^2*t^2+O(t^(7/2))",
                "affine_rescaled_spectrum": "{-4*Q^(1/4)*zeta_4}",
            },
        },
        "boundary": {
            "certifies": [
                "fan relation lattice and Fano anticanonical degrees",
                "critical-point reduction and exact degree-ten equation",
                "generic 6+4 critical-value splitting",
                "residual affine-rescaled leading spectrum equals the P3 spectrum up to sign",
            ],
            "does_not_certify": [
                "residual-center Stokes-filtered identification",
                "Gamma/Rees strict blow-up functoriality",
                "vanishing of the limiting four-thimble Stokes cocycle",
            ],
        },
    }


def canonical_bytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode("utf-8")


def main():
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--output", type=Path)
    group.add_argument("--check", type=Path)
    args = parser.parse_args()
    data = canonical_bytes(build_certificate())
    if args.output is not None:
        args.output.write_bytes(data)
        return
    expected = args.check.read_bytes()
    if data != expected:
        raise SystemExit(f"certificate mismatch: {args.check}")
    print(f"PASS {args.check} ({len(data)} bytes)")


if __name__ == "__main__":
    main()
