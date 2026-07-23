#!/usr/bin/env python3
"""Generate the compact C519 characteristic-two obstruction certificate."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

def rank_mod2(matrix: list[list[int]]) -> int:
    rows = [sum((entry & 1) << j for j, entry in enumerate(row)) for row in matrix]
    rank = 0
    width = len(matrix[0]) if matrix else 0
    for column in range(width):
        pivot = next((i for i in range(rank, len(rows)) if (rows[i] >> column) & 1), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        for i in range(len(rows)):
            if i != rank and ((rows[i] >> column) & 1):
                rows[i] ^= rows[rank]
        rank += 1
    return rank


def contraction_matrix(coefficients: tuple[int, ...], degree: int) -> list[list[int]]:
    """Rows H_-1,H_0,H_1,H_2; columns p_0,...,p_(degree-3)."""

    def a(index: int) -> int:
        return coefficients[index] if 0 <= index <= degree else 0

    return [
        [a(k - shift) for k in range(degree - 2)]
        for shift in (-1, 0, 1, 2)
    ]


def middle_catalecticant(coefficients: tuple[int, ...], degree: int) -> list[list[int]]:
    """The 3 by (n-1) catalecticant cutting out the rank-at-most-two carrier."""
    return [
        [coefficients[row + column] for column in range(degree - 1)]
        for row in range(3)
    ]


def outside_frozen_char2_nucleus(coefficients: tuple[int, ...], degree: int) -> bool:
    if degree == 5:
        return any(coefficients[index] for index in (0, 1, 4, 5))
    if degree == 6:
        return coefficients != (0, 0, 0, 1, 0, 0, 0)
    # C513 has no characteristic-two lift at degree seven; C516 has none at degree eight.
    return True


def ns_coefficients_mod2(coefficients: tuple[int, ...], degree: int) -> list[int]:
    """Upper-triangular coefficients of H_-1 H_2 + H_0 H_1 over F_2."""
    matrix = contraction_matrix(coefficients, degree)
    hm1, h0, h1, h2 = matrix
    width = degree - 2
    answer: list[int] = []
    for i in range(width):
        for j in range(i, width):
            value = (
                hm1[i] * h2[j]
                + hm1[j] * h2[i]
                + h0[i] * h1[j]
                + h0[j] * h1[i]
            )
            if i == j:
                value = hm1[i] * h2[i] + h0[i] * h1[i]
            answer.append(value & 1)
    return answer


def first_rank_witness(degree: int, target_rank: int) -> dict[str, object]:
    for mask in range(1, 1 << (degree + 1)):
        coefficients = tuple((mask >> i) & 1 for i in range(degree + 1))
        matrix = contraction_matrix(coefficients, degree)
        rank = rank_mod2(matrix)
        catalecticant = middle_catalecticant(coefficients, degree)
        catalecticant_rank = rank_mod2(catalecticant)
        if (
            rank == target_rank
            and catalecticant_rank == 3
            and outside_frozen_char2_nucleus(coefficients, degree)
        ):
            ns = ns_coefficients_mod2(coefficients, degree)
            if any(ns):
                return {
                    "degree": degree,
                    "coefficients_low_first": list(coefficients),
                    "contraction_matrix_rows": matrix,
                    "rank": rank,
                    "middle_catalecticant_rows": catalecticant,
                    "middle_catalecticant_rank": catalecticant_rank,
                    "outside_frozen_char2_nucleus": True,
                    "ns_upper_triangular_coefficients": ns,
                }
    raise RuntimeError(f"no degree-{degree} rank-{target_rank} witness")


Monomial = tuple[int, int, int, int]
Polynomial = dict[Monomial, int]


def poly_add(*polynomials: Polynomial) -> Polynomial:
    answer: Polynomial = {}
    for polynomial in polynomials:
        for monomial, coefficient in polynomial.items():
            answer[monomial] = answer.get(monomial, 0) + coefficient
    return {monomial: coefficient for monomial, coefficient in answer.items() if coefficient}


def poly_scale(coefficient: int, polynomial: Polynomial) -> Polynomial:
    return {
        monomial: coefficient * value
        for monomial, value in polynomial.items()
        if coefficient * value
    }


def poly_multiply(left: Polynomial, right: Polynomial) -> Polynomial:
    answer: Polynomial = {}
    for lm, lc in left.items():
        for rm, rc in right.items():
            monomial = tuple(lm[i] + rm[i] for i in range(4))
            answer[monomial] = answer.get(monomial, 0) + lc * rc
    return {monomial: coefficient for monomial, coefficient in answer.items() if coefficient}


def poly_power(polynomial: Polynomial, exponent: int) -> Polynomial:
    answer: Polynomial = {(0, 0, 0, 0): 1}
    for _ in range(exponent):
        answer = poly_multiply(answer, polynomial)
    return answer


def poly_mod(polynomial: Polynomial, prime: int) -> Polynomial:
    return {
        monomial: coefficient % prime
        for monomial, coefficient in polynomial.items()
        if coefficient % prime
    }


def generate() -> dict[str, object]:
    A = {(1, 0, 0, 0): 1}
    B = {(0, 1, 0, 0): 1}
    C = {(0, 0, 1, 0): 1}
    D = {(0, 0, 0, 1): 1}
    determinant = poly_add(poly_multiply(B, D), poly_scale(-1, poly_power(C, 2)))
    trace_numerator = poly_add(poly_multiply(A, D), poly_scale(-1, poly_multiply(B, C)))
    norm_numerator = poly_add(poly_multiply(A, C), poly_scale(-1, poly_power(B, 2)))
    branch = poly_add(
        poly_power(trace_numerator, 2),
        poly_scale(-4, poly_multiply(determinant, norm_numerator)),
    )
    expected = {
        (2, 0, 0, 2): 1,
        (1, 1, 1, 1): -6,
        (0, 2, 2, 0): -3,
        (1, 0, 3, 0): 4,
        (0, 3, 0, 1): 4,
    }
    # Standard cubic formula b^2*c^2-4*a*c^3-4*b^3*d-27*a^2*d^2+18*a*b*c*d
    # with coefficients (a,b,c,d)=(A,3B,3C,D).
    cubic_b = poly_scale(3, B)
    cubic_c = poly_scale(3, C)
    ordinary_discriminant = poly_add(
        poly_multiply(poly_power(cubic_b, 2), poly_power(cubic_c, 2)),
        poly_scale(-4, poly_multiply(A, poly_power(cubic_c, 3))),
        poly_scale(-4, poly_multiply(poly_power(cubic_b, 3), D)),
        poly_scale(-27, poly_multiply(poly_power(A, 2), poly_power(D, 2))),
        poly_scale(
            18,
            poly_multiply(poly_multiply(poly_multiply(A, cubic_b), cubic_c), D),
        ),
    )
    reduced_quadric = poly_add(poly_multiply(A, D), poly_multiply(B, C))
    branch_mod2 = poly_mod(branch, 2)
    branch_mod3 = poly_mod(branch, 3)
    discriminant_in_A_mod3 = {
        (0, 0, 6, 0): 1,
        (0, 3, 0, 3): -1,
    }
    char3_cube = poly_power(
        poly_add(poly_power(C, 2), poly_scale(-1, poly_multiply(B, D))), 3
    )

    checks = {
        "residual_expansion": branch == expected,
        "ordinary_discriminant": ordinary_discriminant == poly_scale(-27, expected),
        "characteristic_two_double_quadric": (
            branch_mod2 == poly_mod(poly_power(reduced_quadric, 2), 2)
        ),
        "characteristic_three_A_discriminant": (
            poly_mod(discriminant_in_A_mod3, 3) == poly_mod(char3_cube, 3)
        ),
        "first_hankel_syzygy": poly_add(
            poly_multiply(A, determinant),
            poly_scale(-1, poly_multiply(B, trace_numerator)),
            poly_multiply(C, norm_numerator),
        ) == {},
        "second_hankel_syzygy": poly_add(
            poly_multiply(B, determinant),
            poly_scale(-1, poly_multiply(C, trace_numerator)),
            poly_multiply(D, norm_numerator),
        ) == {},
    }
    if not all(checks.values()):
        raise AssertionError(checks)

    modular_remainders = {}
    for prime in (2, 3, 5, 7):
        modular_remainders[str(prime)] = {
            "residual_identity_zero": poly_mod(
                poly_add(branch, poly_scale(-1, expected)), prime
            ) == {},
            "ordinary_discriminant_identity_zero": poly_mod(
                poly_add(ordinary_discriminant, poly_scale(27, expected)), prime
            ) == {},
        }

    witnesses = [
        first_rank_witness(5, 3),
        first_rank_witness(6, 4),
        first_rank_witness(7, 4),
        first_rank_witness(8, 4),
    ]

    return {
        "schema": "c519-universal-residual-discriminant-v1",
        "dependencies": "Python standard library only",
        "conventions": {
            "syndrome": "f=(a_0,...,a_n) in Gamma^n(E)",
            "factor": "P=sum p_i t^i of degree n-3",
            "contractions": "H_j=sum_i a_i p_(i+j), j=-1,0,1,2",
            "residual_quadratic": "D*t^2-N_s*t+N_u",
        },
        "integral": {
            "D": "B*D-C^2",
            "N_s": "A*D-B*C",
            "N_u": "A*C-B^2",
            "K": "A^2*D^2-6*A*B*C*D-3*B^2*C^2+4*A*C^3+4*B^3*D",
            "ordinary_binary_cubic_discriminant": "-27*K",
            "divided_hessian": "N_u*X^2+N_s*X*Y+D*Y^2",
            "ordinary_hessian": "36*(N_u*X^2+N_s*X*Y+D*Y^2)",
            "hankel_syzygies": [
                "A*D-B*N_s+C*N_u=0",
                "B*D-C*N_s+D_3*N_u=0",
            ],
            "checks": checks,
            "modular_remainders": modular_remainders,
        },
        "characteristic_two": {
            "K": "(A*D+B*C)^2",
            "reduced_tangent_surface": "A*D+B*C",
            "residual_separability_coefficient": "N_s=A*D+B*C",
            "artin_schreier_equation": "z^2+z=D*N_u/N_s^2, z=D*t/N_s",
            "arf_invariant": "D*N_u/N_s^2 modulo {h^2+h}",
            "artin_schreier_nontrivial_specialization": {
                "specialization": "B=0,C=1,D=1",
                "D_minor": "1",
                "N_s": "A",
                "N_u": "A",
                "class": "1/A",
                "certificate": "simple pole at A=0, hence not h^2+h",
            },
            "generic_outside_frozen_carriers": witnesses,
        },
        "characteristic_three": {
            "K": "A^2*D^2+A*C^3+B^3*D",
            "discriminant_as_quadratic_in_A": "(C^2-B*D)^3",
            "nonsquare_prime_factor": "C^2-B*D with odd valuation 3",
            "singular_equations": ["C^3-A*D^2", "B^3-A^2*D"],
            "singular_reduced_support": "twisted cubic [s^3:s^2*t:s*t^2:t^3]",
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = generate()
    encoded = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.check:
        if not args.output.exists() or args.output.read_text() != encoded:
            raise SystemExit(f"certificate mismatch: {args.output}")
    else:
        args.output.write_text(encoded)


if __name__ == "__main__":
    main()
