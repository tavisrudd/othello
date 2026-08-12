#!/usr/bin/env python3
"""Independent SymPy replay for the C907 toric codimension-two pilot."""

import json
import sys
from pathlib import Path

import sympy as sp


def main(path):
    cert = json.loads(Path(path).read_text())
    assert cert["schema"] == "c907-toric-r2-pilot-v1"

    rays = sp.Matrix(cert["fan"]["rays"]).T
    line, fibre = map(sp.Matrix, cert["fan"]["relation_basis"])
    line_minus_fibre = line - fibre
    assert rays * line == sp.zeros(5, 1)
    assert rays * fibre == sp.zeros(5, 1)
    assert list(line_minus_fibre) == cert["fan"]["mori_generators"][0]
    assert [sum(line_minus_fibre), sum(fibre)] == [5, 1]

    u, Q, t = sp.symbols("u Q t")
    polynomial = u**4 * (u - 1) ** 6 - Q * t**6
    assert sp.factor(sp.diff(polynomial, u)) == 2 * u**3 * (u - 1) ** 5 * (5 * u - 2)

    b = (u - 1) / t
    a = b * u
    W = 4 * a + 2 * b + t * b**2
    assert sp.cancel(W - (5 * u**2 - 4 * u - 1) / t) == 0
    assert sp.cancel(a**4 * b**2 - u**4 * (u - 1) ** 6 / t**6) == 0

    c, s = sp.symbols("c s")
    ambient_u = 1 + c * s - sp.Rational(2, 3) * c**2 * s**2
    ambient_eq = sp.expand(ambient_u**4 * (ambient_u - 1) ** 6 - c**6 * s**6)
    assert ambient_eq.coeff(s, 6) == 0
    assert ambient_eq.coeff(s, 7) == 0
    ambient_num = sp.expand(5 * ambient_u**2 - 4 * ambient_u - 1)
    assert ambient_num.coeff(s, 1) == 6 * c
    assert ambient_num.coeff(s, 2) == c**2

    residual_u = c * s**3 + sp.Rational(3, 2) * c**2 * s**6
    residual_eq = sp.expand(residual_u**4 * (residual_u - 1) ** 6 - c**4 * s**12)
    assert residual_eq.coeff(s, 12) == 0
    assert residual_eq.coeff(s, 15) == 0
    residual_num = sp.expand(5 * residual_u**2 - 4 * residual_u - 1)
    assert residual_num.coeff(s, 3) == -4 * c
    assert residual_num.coeff(s, 6) == -c**2

    assert cert["mirror"]["generic_critical_point_count"] == 10
    assert cert["asymptotics"]["ambient"]["count"] == 6
    assert cert["asymptotics"]["residual"]["count"] == 4
    print(f"PASS {path}: independent fan, critical, and asymptotic identities")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit(f"usage: {sys.argv[0]} CERTIFICATE.json")
    main(sys.argv[1])
