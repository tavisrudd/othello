#!/usr/bin/env python3
"""Exact graded gauge from the C682 symbol to the standard E8 3-node."""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from pathlib import Path


Poly = dict[tuple[int, int], Fraction]  # (F exponent, h exponent) -> coefficient
Matrix = list[list[Poly]]


def scalar(value: int | Fraction) -> Poly:
    value = Fraction(value)
    return {} if value == 0 else {(0, 0): value}


def monomial(coefficient: int | Fraction, f_power: int, h_power: int) -> Poly:
    coefficient = Fraction(coefficient)
    return {} if coefficient == 0 else {(f_power, h_power): coefficient}


def add(left: Poly, right: Poly) -> Poly:
    result = dict(left)
    for key, value in right.items():
        result[key] = result.get(key, Fraction(0)) + value
        if result[key] == 0:
            del result[key]
    return result


def scale(polynomial: Poly, coefficient: int | Fraction) -> Poly:
    coefficient = Fraction(coefficient)
    return {
        key: coefficient * value
        for key, value in polynomial.items()
        if coefficient * value
    }


def multiply(left: Poly, right: Poly) -> Poly:
    result: Poly = {}
    for (lf, lh), lc in left.items():
        for (rf, rh), rc in right.items():
            result = add(result, {(lf + rf, lh + rh): lc * rc})
    return result


def power(polynomial: Poly, exponent: int) -> Poly:
    result = scalar(1)
    for _ in range(exponent):
        result = multiply(result, polynomial)
    return result


def matrix_multiply(left: Matrix, right: Matrix) -> Matrix:
    if len(left[0]) != len(right):
        raise ValueError("incompatible matrix dimensions")
    return [
        [
            sum_polynomials(
                multiply(left[row][index], right[index][column])
                for index in range(len(right))
            )
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def sum_polynomials(polynomials) -> Poly:
    result: Poly = {}
    for polynomial in polynomials:
        result = add(result, polynomial)
    return result


def matrix_scale(matrix: Matrix, coefficient: int | Fraction) -> Matrix:
    return [[scale(entry, coefficient) for entry in row] for row in matrix]


def diagonal(entries: list[int | Fraction]) -> Matrix:
    return [
        [scalar(entries[row]) if row == column else {} for column in range(len(entries))]
        for row in range(len(entries))
    ]


def identity(size: int) -> Matrix:
    return diagonal([1] * size)


def anti_identity(size: int) -> Matrix:
    return [
        [scalar(1) if row + column == size - 1 else {} for column in range(size)]
        for row in range(size)
    ]


def serialize_polynomial(polynomial: Poly) -> list[dict[str, int | str]]:
    return [
        {
            "coefficient": str(coefficient),
            "F_power": f_power,
            "h_power": h_power,
        }
        for (f_power, h_power), coefficient in sorted(polynomial.items())
    ]


def serialize_matrix(matrix: Matrix) -> list[list[list[dict[str, int | str]]]]:
    return [[serialize_polynomial(entry) for entry in row] for row in matrix]


def assert_homogeneous_map(
    matrix: Matrix,
    source_degrees: list[int],
    target_degrees: list[int],
    map_degree: int,
) -> None:
    for row, source_degree in enumerate(source_degrees):
        for column, target_degree in enumerate(target_degrees):
            for (f_power, h_power), coefficient in matrix[row][column].items():
                if not coefficient:
                    continue
                entry_degree = 12 * f_power + 20 * h_power
                if entry_degree + target_degree != source_degree + map_degree:
                    raise AssertionError(
                        "inhomogeneous entry "
                        f"({row},{column}): {entry_degree}+{target_degree} "
                        f"!= {source_degree}+{map_degree}"
                    )


def build_certificate() -> dict:
    F = monomial(1, 1, 0)
    h = monomial(1, 0, 1)
    zero: Poly = {}

    A: Matrix = [
        [scale(h, -10), scale(F, 120), zero],
        [zero, scale(h, 2), scale(F, 12)],
        [scale(power(F, 3), 240), zero, scale(h, 10)],
    ]
    B: Matrix = [
        [scale(power(h, 2), 10), scale(multiply(F, h), -600), scale(power(F, 2), 720)],
        [scale(power(F, 4), 1440), scale(power(h, 2), -50), scale(multiply(F, h), 60)],
        [scale(multiply(power(F, 3), h), -240), scale(power(F, 4), 14400), scale(power(h, 2), -10)],
    ]

    Y = scale(h, Fraction(-1, 12))
    Z = F
    g = add(power(Y, 3), power(Z, 5))
    t_squared = add(scale(power(F, 5), 1728), scale(power(h, 3), -1))
    if scale(g, 1728) != t_squared:
        raise AssertionError("wrong rational base change")

    phi: Matrix = [
        [scale(power(Y, 2), -1), scale(power(Z, 4), -1), scale(multiply(Y, power(Z, 3)), -1)],
        [scale(multiply(Y, Z), -1), power(Y, 2), scale(power(Z, 4), -1)],
        [scale(power(Z, 2), -1), multiply(Y, Z), power(Y, 2)],
    ]
    psi: Matrix = [
        [Y, zero, power(Z, 3)],
        [Z, scale(Y, -1), zero],
        [zero, Z, scale(Y, -1)],
    ]

    J = anti_identity(3)
    L = diagonal([1, -10, -2])
    L_inverse = diagonal([1, Fraction(-1, 10), Fraction(-1, 2)])
    R = diagonal([Fraction(-1, 120), Fraction(-1, 240), Fraction(1, 240)])
    R_inverse = diagonal([-120, -240, 240])

    gauged_A = matrix_multiply(
        matrix_multiply(matrix_multiply(matrix_multiply(L, J), A), J),
        R,
    )
    gauged_B = matrix_multiply(
        matrix_multiply(
            matrix_multiply(matrix_multiply(R_inverse, J), B),
            J,
        ),
        L_inverse,
    )
    if gauged_A != psi:
        raise AssertionError("A gauge identity failed")
    if gauged_B != matrix_scale(phi, -172800):
        raise AssertionError("B gauge identity failed")

    potential = scale(t_squared, 100)
    potential_matrix = [
        [potential if row == column else {} for column in range(3)]
        for row in range(3)
    ]
    if matrix_multiply(A, B) != potential_matrix:
        raise AssertionError("AB has the wrong potential")
    if matrix_multiply(B, A) != potential_matrix:
        raise AssertionError("BA has the wrong potential")
    negative_g_matrix = matrix_scale(
        [[g if row == column else {} for column in range(3)] for row in range(3)],
        -1,
    )
    if matrix_multiply(phi, psi) != negative_g_matrix:
        raise AssertionError("standard phi*psi identity failed")
    if matrix_multiply(psi, phi) != negative_g_matrix:
        raise AssertionError("standard psi*phi identity failed")

    even_degrees = [2, 10, 18]
    odd_degrees = [12, 20, 28]
    standard_even_degrees = list(reversed(even_degrees))
    standard_odd_degrees = list(reversed(odd_degrees))
    assert_homogeneous_map(A, even_degrees, odd_degrees, 30)
    assert_homogeneous_map(B, odd_degrees, even_degrees, 30)
    assert_homogeneous_map(psi, standard_even_degrees, standard_odd_degrees, 30)
    assert_homogeneous_map(phi, standard_odd_degrees, standard_even_degrees, 30)

    return {
        "schema": "c682-klein-e8-graded-gauge-v1",
        "field": "Q",
        "coefficient_ring": {
            "ring": "Q[F,h]",
            "degrees": {"F": 12, "h": 20},
            "klein_relation": "t^2=1728*F^5-h^3",
        },
        "standard_factorization": {
            "source": "Curto-Morrison, arXiv:math/0611014, Appendix p. 26",
            "source_pdf_sha256": "83ff3bb97c3523f649a390f7391ec6e8df977846067453ddbf018196a5c05425",
            "node": "unprimed 3-node",
            "potential": "g=Y^3+Z^5",
            "sign_convention": "phi_3*psi_3=psi_3*phi_3=-g*I_3",
            "base_change": {"Y": "-h/12", "Z": "F", "g": "t^2/1728"},
            "phi_3_after_base_change": serialize_matrix(phi),
            "psi_3_after_base_change": serialize_matrix(psi),
        },
        "c682_factorization": {
            "potential": "100*t^2=172800*g",
            "A": serialize_matrix(A),
            "B": serialize_matrix(B),
            "identities": ["A*B=100*t^2*I_3", "B*A=100*t^2*I_3"],
        },
        "graded_modules": {
            "original_even_basis": [
                {"name": "g2", "degree": 2},
                {"name": "g10", "degree": 10},
                {"name": "g18", "degree": 18},
            ],
            "original_odd_basis": [
                {"name": "g12", "degree": 12},
                {"name": "g20", "degree": 20},
                {"name": "g28", "degree": 28},
            ],
            "standard_even_basis_degrees": standard_even_degrees,
            "standard_odd_basis_degrees": standard_odd_degrees,
            "map_degree": 30,
            "potential_degree": 60,
        },
        "gauge": {
            "J": serialize_matrix(J),
            "L": serialize_matrix(L),
            "R": serialize_matrix(R),
            "P": "L*J",
            "Q": "R^(-1)*J",
            "identity_A": "P*A*Q^(-1)=psi_3",
            "identity_B": "Q*(B/172800)*P^(-1)=-phi_3",
            "L_entries": ["1", "-10", "-2"],
            "R_entries": ["-1/120", "-1/240", "1/240"],
        },
        "checks": {
            "symbolic_matrix_product_identities": 6,
            "rational_base_change_identities": 1,
            "graded_nonzero_entries": 30,
            "conclusion": (
                "(A,B/172800) is graded-gauge equivalent over Q[F,h] "
                "to the sign-corrected standard unprimed E8 3-node "
                "factorization (psi_3,-phi_3) after Y=-h/12, Z=F."
            ),
        },
    }


def canonical_json(certificate: dict) -> str:
    return json.dumps(certificate, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")

    output = Path(__file__).with_suffix(".json")
    rendered = canonical_json(build_certificate())
    if args.write:
        output.write_text(rendered, encoding="utf-8")
        print(f"wrote {output.name}")
        return
    if not output.exists() or output.read_text(encoding="utf-8") != rendered:
        raise SystemExit(f"{output.name} is stale; run with --write")
    print("graded gauge certificate: PASS")


if __name__ == "__main__":
    main()
