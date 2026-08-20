#!/usr/bin/env python3
"""Exact symbolic cross-checks for the finite cubic algebra in C924."""

from __future__ import annotations

import json

import sympy as sp


def main() -> None:
    r = sp.symbols("r", nonzero=True)
    t = sp.symbols("t")
    q = r**2 / 3

    multiplication_by_p = sp.Matrix(
        [
            [0, 6 * q, 0, 36 * q**2],
            [1, 0, 15 * q, 0],
            [0, 1, 0, 6 * q],
            [0, 0, 1, 0],
        ]
    )
    k_x = 2 * multiplication_by_p
    g_x = sp.diag(sp.Rational(3, 2), sp.Rational(1, 2),
                  sp.Rational(-1, 2), sp.Rational(-3, 2))
    c = sp.Matrix(
        [
            [6 * r**3, -6 * r**3, 0, -7 * r**2],
            [7 * r**2, 7 * r**2, -2 * r**2, 0],
            [3 * r, -3 * r, 0, 1],
            [1, 1, 1, 0],
        ]
    )
    j = sp.Matrix(
        [
            [6 * r, 0, 0, 0],
            [0, -6 * r, 0, 0],
            [0, 0, 0, 2],
            [0, 0, 0, 0],
        ]
    )
    d_expected = sp.Matrix(
        [
            [0, sp.Rational(1, 18), sp.Rational(-2, 9), -sp.Rational(7, 27) / r],
            [sp.Rational(1, 18), 0, sp.Rational(-2, 9), sp.Rational(7, 27) / r],
            [sp.Rational(-14, 9), sp.Rational(-14, 9), sp.Rational(-19, 18), 0],
            [-sp.Rational(4, 3) * r, sp.Rational(4, 3) * r, 0, sp.Rational(19, 18)],
        ]
    )
    a1 = sp.Matrix(
        [
            [0, -sp.Rational(1, 216) / r, sp.Rational(1, 27) / r,
             sp.Rational(1, 18) / r**2],
            [sp.Rational(1, 216) / r, 0, -sp.Rational(1, 27) / r,
             sp.Rational(1, 18) / r**2],
            [-sp.Rational(1, 3) / r, sp.Rational(1, 3) / r, 0, 0],
            [sp.Rational(-2, 9), sp.Rational(-2, 9), 0, 0],
        ]
    )

    assert sp.simplify(c.det() + 486 * r**5) == 0
    assert (sp.simplify(c.inv() * k_x * c - j)).is_zero_matrix
    d_actual = sp.simplify(c.inv() * g_x * c)
    assert (sp.simplify(d_actual - d_expected)).is_zero_matrix

    commutator = j * a1 - a1 * j
    # SymPy's block-diagonal constructor is clearer for the 1|1|2 partition.
    diagonal_part = sp.diag(
        d_expected[0, 0], d_expected[1, 1],
        sp.Matrix(d_expected[2:4, 2:4]),
    )
    assert (sp.simplify(d_expected + commutator - diagonal_part)).is_zero_matrix

    second = d_expected * a1 - a1 * d_expected - a1 * commutator - a1
    e0 = sp.simplify(sp.Matrix(second[2:4, 2:4]))
    e0_expected = sp.Matrix(
        [[0, -sp.Rational(14, 81) / r**2], [sp.Rational(-8, 81), 0]]
    )
    assert (sp.simplify(e0 - e0_expected)).is_zero_matrix

    residue = sp.Matrix(
        [
            [sp.Rational(-19, 18), 2],
            [sp.Rational(-8, 81), sp.Rational(1, 18)],
        ]
    )
    assert residue.trace() == -1
    assert residue.det() == sp.Rational(5, 36)
    assert sp.simplify(
        residue.charpoly(t).as_expr() - (t**2 + t + sp.Rational(5, 36))
    ) == 0
    assert sp.simplify(
        residue.charpoly(t).as_expr()
        - (t + sp.Rational(1, 6)) * (t + sp.Rational(5, 6))
    ) == 0

    characteristic = sp.factor(k_x.charpoly(t).as_expr())
    assert sp.simplify(characteristic - t**2 * (t**2 - 108 * q)) == 0
    identity = sp.eye(4)
    assert (sp.simplify(k_x**2 * (k_x**2 - 108 * q * identity))).is_zero_matrix
    assert not (sp.simplify(k_x * (k_x**2 - 108 * q * identity))).is_zero_matrix

    result = {
        "schema": "c924-finite-cubic-check-v1",
        "sympy_version": sp.__version__,
        "checks": {
            "beauville_euler_characteristic_polynomial": "t^2*(t^2-108*q)",
            "beauville_euler_minimal_polynomial": "t^2*(t^2-108*q)",
            "constant_basis_determinant": "-486*r^5",
            "first_normalized_gauge": "verified",
            "zero_block_E0_12": "-14/(81*r^2)",
            "zero_block_E0_21": "-8/81",
            "modified_residue_trace": "-1",
            "modified_residue_determinant": "5/36",
            "modified_residue_discriminant": "4/9",
            "modified_residue_eigenvalues": ["-1/6", "-5/6"],
        },
    }
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
