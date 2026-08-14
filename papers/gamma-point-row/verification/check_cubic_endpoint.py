#!/usr/bin/env python3
"""Exact regression for the cubic endpoint lemma.

The human proof is in Section 9 of the manuscript.  This script protects its
rational block calculation, hypergeometric recurrence, and projective-space
grading identity against transcription drift.  It does not verify the
asymptotic theorem or any localization statement.
"""

from __future__ import annotations

import argparse
import json
import math
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent
CERTIFICATE = ROOT / "cubic_endpoint_certificate.json"
SCHEMA = "gamma-point-row-cubic-endpoint-v1"


def evaluate_quadratic(coefficients: list[Fraction], value: Fraction) -> Fraction:
    constant, linear, quadratic = coefficients
    return constant + linear * value + quadratic * value * value


Matrix = list[list[Fraction]]


def matrix_add(left: Matrix, right: Matrix) -> Matrix:
    return [
        [a + b for a, b in zip(left_row, right_row, strict=True)]
        for left_row, right_row in zip(left, right, strict=True)
    ]


def matrix_sub(left: Matrix, right: Matrix) -> Matrix:
    return [
        [a - b for a, b in zip(left_row, right_row, strict=True)]
        for left_row, right_row in zip(left, right, strict=True)
    ]


def matrix_mul(left: Matrix, right: Matrix) -> Matrix:
    return [
        [
            sum(
                (left[i][k] * right[k][j] for k in range(len(right))),
                Fraction(0),
            )
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def commutator(left: Matrix, right: Matrix) -> Matrix:
    return matrix_sub(matrix_mul(left, right), matrix_mul(right, left))


def matrix_inverse(matrix: Matrix) -> Matrix:
    size = len(matrix)
    augmented = [
        row[:] + [Fraction(int(i == j)) for j in range(size)]
        for i, row in enumerate(matrix)
    ]
    for column in range(size):
        pivot = next(row for row in range(column, size) if augmented[row][column])
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        scale = augmented[column][column]
        augmented[column] = [entry / scale for entry in augmented[column]]
        for row in range(size):
            if row == column:
                continue
            scale = augmented[row][column]
            augmented[row] = [
                entry - scale * pivot_entry
                for entry, pivot_entry in zip(
                    augmented[row], augmented[column], strict=True
                )
            ]
    return [row[size:] for row in augmented]


def solve_linear(matrix: Matrix, vector: list[Fraction]) -> list[Fraction]:
    inverse = matrix_inverse(matrix)
    return [
        sum((entry * value for entry, value in zip(row, vector, strict=True)), Fraction())
        for row in inverse
    ]


def solve_sylvester(left: Matrix, right: Matrix, target: Matrix) -> Matrix:
    """Solve left*x - x*right = target for a 2 by 2 matrix x."""
    system: Matrix = []
    values: list[Fraction] = []
    for i in range(2):
        for j in range(2):
            equation: list[Fraction] = []
            for k in range(2):
                for ell in range(2):
                    coefficient = left[i][k] if ell == j else Fraction()
                    if i == k:
                        coefficient -= right[ell][j]
                    equation.append(coefficient)
            system.append(equation)
            values.append(target[i][j])
    solution = solve_linear(system, values)
    return [solution[:2], solution[2:]]


def block(matrix: Matrix, row: int, column: int) -> Matrix:
    return [
        matrix[2 * row + i][2 * column : 2 * column + 2]
        for i in range(2)
    ]


def reconstruct_cai_block(q: Fraction) -> dict[str, object]:
    zero = Fraction()
    K = [
        [zero, 12 * q, zero, 72 * q * q],
        [Fraction(2), zero, 30 * q, zero],
        [zero, Fraction(2), zero, 12 * q],
        [zero, zero, Fraction(2), zero],
    ]
    G = [
        [Fraction(3, 2), zero, zero, zero],
        [zero, Fraction(1, 2), zero, zero],
        [zero, zero, Fraction(-1, 2), zero],
        [zero, zero, zero, Fraction(-3, 2)],
    ]
    columns = [
        [6 * q, zero, Fraction(1), zero],
        [zero, 21 * q, zero, Fraction(1)],
        [zero, -6 * q, zero, Fraction(1)],
        [Fraction(-21, 2) * q, zero, Fraction(1, 2), zero],
    ]
    P = [[columns[j][i] for j in range(4)] for i in range(4)]
    inverse_P = matrix_inverse(P)
    K0 = matrix_mul(matrix_mul(inverse_P, K), P)
    G0 = matrix_mul(matrix_mul(inverse_P, G), P)

    expected_K0 = [
        [zero, 54 * q, zero, zero],
        [Fraction(2), zero, zero, zero],
        [zero, zero, zero, Fraction(1)],
        [zero, zero, zero, zero],
    ]
    expected_G0 = [
        [Fraction(-1, 18), zero, zero, Fraction(-7, 9)],
        [zero, Fraction(1, 18), Fraction(-4, 9), zero],
        [zero, Fraction(-14, 9), Fraction(-19, 18), zero],
        [Fraction(-8, 9), zero, zero, Fraction(19, 18)],
    ]
    assert K0 == expected_K0
    assert G0 == expected_G0

    KU, KW = block(K0, 0, 0), block(K0, 1, 1)
    GUW, GWU = block(G0, 0, 1), block(G0, 1, 0)
    X = solve_sylvester(KU, KW, [[-value for value in row] for row in GUW])
    Y = solve_sylvester(KW, KU, [[-value for value in row] for row in GWU])
    assert X == [[Fraction(2, 9), zero], [zero, Fraction(1, 54) / q]]
    assert Y == [[Fraction(-1, 27) / q, zero], [zero, Fraction(-4, 9)]]

    A1 = [
        [zero, zero, X[0][0], X[0][1]],
        [zero, zero, X[1][0], X[1][1]],
        [Y[0][0], Y[0][1], zero, zero],
        [Y[1][0], Y[1][1], zero, zero],
    ]
    M1 = matrix_add(commutator(K0, A1), G0)
    M1W = block(M1, 1, 1)
    assert M1W == [
        [Fraction(-19, 18), zero],
        [zero, Fraction(19, 18)],
    ]
    B2 = matrix_sub(
        matrix_add(
            matrix_mul(A1, commutator(A1, K0)),
            commutator(G0, A1),
        ),
        A1,
    )
    B2W = block(B2, 1, 1)
    assert B2W == [
        [zero, Fraction(-7, 243) / q],
        [Fraction(-16, 81), zero],
    ]
    return {
        "q": str(q),
        "normalized_zero_block_M1": [[str(value) for value in row] for row in M1W],
        "normalized_zero_block_B2": [[str(value) for value in row] for row in B2W],
    }


def build_certificate() -> dict[str, object]:
    block_reconstructions = [
        reconstruct_cai_block(Fraction(q)) for q in (1, 2, 3)
    ]
    d11 = Fraction(-19, 18)
    d22 = Fraction(19, 18)
    jordan_link = Fraction(1)
    return_link = Fraction(-16, 81)

    # (rho-d11)(rho+1-d22)-jordan_link*return_link
    indicial = [
        (-d11) * (1 - d22) - jordan_link * return_link,
        (1 - d22) - d11,
        Fraction(1),
    ]
    expected = [Fraction(5, 36), Fraction(1), Fraction(1)]
    assert indicial == expected
    roots = [Fraction(-1, 6), Fraction(-5, 6)]
    assert all(evaluate_quadratic(indicial, root) == 0 for root in roots)

    period_checks: list[dict[str, object]] = []
    previous = Fraction(1)
    for degree in range(1, 13):
        coefficient = Fraction(
            math.factorial(3 * degree),
            math.factorial(degree) ** 5 * 27**degree,
        )
        right = (
            (Fraction(degree) - Fraction(1, 3))
            * (Fraction(degree) - Fraction(2, 3))
            * previous
        )
        assert degree**4 * coefficient == right
        period_checks.append(
            {
                "degree": degree,
                "coefficient_in_x": str(coefficient),
                "recurrence": True,
            }
        )
        previous = coefficient

    projective_checks: list[dict[str, object]] = []
    for dimension in range(0, 65):
        diagonal_sum = sum(
            (Fraction(dimension, 2) - k for k in range(dimension + 1)),
            Fraction(0),
        )
        assert diagonal_sum == 0
        projective_checks.append(
            {
                "dimension": dimension,
                "rank": dimension + 1,
                "grading_diagonal_average": "0",
            }
        )

    gamma_arguments = [Fraction(1, 3), Fraction(2, 3), Fraction(-1, 3)]
    assert all(argument.denominator != 1 or argument > 0 for argument in gamma_arguments)

    return {
        "schema": SCHEMA,
        "cai_rank_two_block": {
            "direct_matrix_reconstructions": block_reconstructions,
            "d11": str(d11),
            "d22": str(d22),
            "jordan_link": str(jordan_link),
            "return_link": str(return_link),
            "indicial_coefficients_constant_first": [str(value) for value in indicial],
            "roots": [str(root) for root in roots],
            "fractional_residues_mod_Z": ["-1/6", "1/6"],
        },
        "hypergeometric": {
            "operator": "D^4-x(D+1/3)(D+2/3)",
            "checked_degree_range": [0, 12],
            "checks": period_checks,
        },
        "barnes_nonpole_arguments": [str(argument) for argument in gamma_arguments],
        "projective_space": {
            "identity": "sum_{k=0}^m (m/2-k)=0",
            "checked_dimension_range": [0, 64],
            "checks": projective_checks,
        },
        "trust_boundary": (
            "Exact arithmetic regression only; the Barnes asymptotic theorem, "
            "quantum Kunneth theorem, and birational localization proof are not "
            "machine-verified."
        ),
    }


def canonical_json(value: object) -> str:
    return json.dumps(value, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = canonical_json(build_certificate())
    if args.check:
        if not CERTIFICATE.is_file() or CERTIFICATE.read_text(encoding="utf-8") != rendered:
            raise SystemExit("cubic endpoint certificate is stale; regenerate without --check")
        print("cubic endpoint exact regression: CHECK OK")
        return
    CERTIFICATE.write_text(rendered, encoding="utf-8")
    print(f"wrote {CERTIFICATE.name}")


if __name__ == "__main__":
    main()
