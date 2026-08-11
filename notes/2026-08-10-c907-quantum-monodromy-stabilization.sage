#!/usr/bin/env sage
"""Exact C907 certificate generator for cubic quantum monodromy.

This reconstructs Cai's rank-two indicial polynomial over Q(sqrt(3))(u),
where q = u^2, checks the projective-space grading contribution exactly for
P^m with 0 <= m <= the requested bound, and audits the coarse blow-up atom
multiplicity model for stabilization dimensions 1 <= m <= the bound.
"""

import argparse
import json
from functools import reduce
from math import gcd
from pathlib import Path

import sage.version


SCHEMA = "c907-quantum-monodromy-stabilization-v1"


def matrix_strings(M):
    return [[str(M[i, j]) for j in range(M.ncols())] for i in range(M.nrows())]


def cai_certificate():
    number_field = QuadraticField(3, "r")
    r = number_field.gen()
    function_field = FunctionField(number_field, "u")
    u = function_field.gen()
    q = u**2

    K = 2 * matrix(
        function_field,
        [
            [0, 6 * q, 0, 36 * q**2],
            [1, 0, 15 * q, 0],
            [0, 1, 0, 6 * q],
            [0, 0, 1, 0],
        ],
    )
    G = diagonal_matrix(
        function_field,
        [function_field(3) / 2, function_field(1) / 2,
         -function_field(1) / 2, -function_field(3) / 2],
    )

    J, P = K.jordan_form(transformation=True)
    assert K == P * J * P.inverse()
    transformed_G = P.inverse() * G * P

    block_label = [0, 1, 2, 2]
    positions = [
        (i, j)
        for i in range(4)
        for j in range(4)
        if block_label[i] != block_label[j]
    ]
    off_block_basis = []
    for i, j in positions:
        elementary = matrix(function_field, 4, 4)
        elementary[i, j] = 1
        off_block_basis.append(elementary)

    sylvester = matrix(
        function_field,
        [
            [(J * E - E * J)[i, j] for E in off_block_basis]
            for i, j in positions
        ],
    )
    target = vector(function_field, [-transformed_G[i, j] for i, j in positions])
    coefficients = sylvester.solve_right(target)
    A1 = sum(
        (coefficients[k] * off_block_basis[k] for k in range(len(off_block_basis))),
        matrix(function_field, 4, 4),
    )

    M1 = J * A1 - A1 * J + transformed_G
    assert all(
        M1[i, j] == 0
        for i, j in positions
    )
    R2 = A1 * (A1 * J - J * A1) + (transformed_G * A1 - A1 * transformed_G) - A1

    polynomial_ring = PolynomialRing(function_field, "rho")
    rho = polynomial_ring.gen()
    d11 = M1[2, 2]
    d22 = M1[3, 3]
    jordan_link = J[2, 3]
    return_link = R2[3, 2]
    indicial = (rho - d11) * (rho + 1 - d22) - jordan_link * return_link
    expected = rho**2 + rho + polynomial_ring(5) / 36
    assert indicial == expected
    assert sorted(root for root, multiplicity in indicial.roots() for _ in range(multiplicity)) == [
        function_field(-5) / 6,
        function_field(-1) / 6,
    ]

    return {
        "coefficient_field": "Q(sqrt(3))(u), q=u^2",
        "source_K": matrix_strings(K),
        "source_G": matrix_strings(G),
        "jordan_K": matrix_strings(J),
        "basis_change_verified": True,
        "rank_two_M1": matrix_strings(M1[2:4, 2:4]),
        "rank_two_R2": matrix_strings(R2[2:4, 2:4]),
        "rank_two_data": {
            "d11": str(d11),
            "d22": str(d22),
            "jordan_link": str(jordan_link),
            "return_link": str(return_link),
        },
        "indicial_polynomial": str(indicial),
        "roots": ["-5/6", "-1/6"],
        "fractional_residues_mod_Z": ["-1/6", "1/6"],
    }


def projective_space_check(m):
    n = m + 1
    if n == 1:
        field = QQ
        roots = [QQ(1)]
    else:
        field = CyclotomicField(n)
        zeta = field.gen()
        roots = [zeta**j for j in range(n)]

    H = matrix(field, n, n)
    for k in range(n - 1):
        H[k + 1, k] = 1
    H[0, n - 1] = 1
    K = n * H
    G = diagonal_matrix(field, [field(m) / 2 - k for k in range(n)])
    eigenbasis = matrix(
        field,
        n,
        n,
        lambda row, col: roots[col] ** (-row),
    )
    assert eigenbasis.is_invertible()
    diagonal_K = eigenbasis.inverse() * K * eigenbasis
    transformed_G = eigenbasis.inverse() * G * eigenbasis
    assert diagonal_K.is_diagonal()
    assert all(transformed_G[j, j] == 0 for j in range(n))
    assert K**n == (n**n) * identity_matrix(field, n)

    return {
        "m": m,
        "rank": n,
        "cyclic_power_identity": True,
        "semisimple_eigenbasis_verified": True,
        "formal_power_exponents": ["0"] * n,
        "cubic_rank_two_copies_after_product": n,
        "cubic_fractional_residues_after_product": ["-1/6", "1/6"],
    }


def coarse_cancellation_check(m):
    target = m + 1
    weights = [t * (m - t) for t in range(1, m)]
    common_divisor = reduce(gcd, weights) if weights else 0

    if m == 1:
        relation = None
        target_in_integer_span = False
    elif m == 2:
        relation = {"1": 3}
        target_in_integer_span = 3 * weights[0] == target
    elif m % 2 == 0:
        relation = {"1": 3, "2": -1}
        target_in_integer_span = 3 * weights[0] - weights[1] == target
    else:
        factor = (m + 1) // 2
        relation = {"1": 2 * factor, "2": -factor}
        target_in_integer_span = 2 * factor * weights[0] - factor * weights[1] == target

    predicted_gcd = 0 if m == 1 else (1 if m % 2 == 0 else 2)
    assert common_divisor == predicted_gcd
    if m >= 2:
        assert target_in_integer_span
        assert target % common_divisor == 0

    return {
        "stabilizing_projective_dimension_m": m,
        "endpoint_cubic_atom_multiplicity": target,
        "center_weights_t_times_m_minus_t": weights,
        "weight_gcd": common_divisor,
        "predicted_gcd": predicted_gcd,
        "endpoint_multiplicity_in_integer_span": target_in_integer_span,
        "explicit_signed_relation_by_t": relation,
    }


def convolution(left, right):
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return result


def tate_graded_candidate_check(m):
    endpoint = [1] * (m + 1)
    center_polynomials = []
    for t in range(1, m):
        center_projective_factor = [1] * t
        exceptional_factor = [0] + [1] * (m - t)
        coefficients = convolution(center_projective_factor, exceptional_factor)
        coefficients += [0] * ((m + 1) - len(coefficients))
        assert len(coefficients) == m + 1
        assert coefficients[0] == 0
        assert coefficients[m] == 0
        center_polynomials.append({"t": t, "coefficients_low_to_high": coefficients})
    return {
        "stabilizing_projective_dimension_m": m,
        "endpoint_coefficients_low_to_high": endpoint,
        "center_polynomials": center_polynomials,
        "endpoint_outside_center_integer_span_by_extreme_degrees": True,
    }


def build_certificate(bound):
    assert bound >= 3
    return {
        "schema": SCHEMA,
        "sage_version": sage.version.version,
        "source": {
            "paper": "Jiaji Cai, The cubic threefold is symplectically irrational",
            "arxiv": "2608.01577v1",
            "cached_pdf_sha256": "06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e",
            "equation_convention": "z^2 dS/dz = (K + zG)S",
        },
        "cai_rank_two_certificate": cai_certificate(),
        "projective_stabilization": {
            "general_statement": (
                "The P^m factor has m+1 semisimple formal solutions with power exponent 0; "
                "tensoring therefore gives m+1 copies of the cubic rank-two block with unchanged residues."
            ),
            "checked_m_range": [0, bound],
            "checks": [projective_space_check(m) for m in range(bound + 1)],
        },
        "coarse_blowup_cancellation_model": {
            "model": (
                "In endpoint dimension 3+m, a center X x P^(s-3), with t=s-2, "
                "contributes t(m-t) copies of the cubic atom under the ungraded blow-up formula."
            ),
            "checked_m_range": [1, bound],
            "checks": [coarse_cancellation_check(m) for m in range(1, bound + 1)],
            "interpretation": (
                "For every m>=2 the endpoint multiplicity m+1 lies in the signed integer span of "
                "the admissible coarse center weights. This refutes a multiplicity-only stable obstruction; "
                "it does not construct geometrically realizable weak-factorization centers."
            ),
        },
        "candidate_tate_graded_refinement": {
            "status": (
                "Exact polynomial separation, but not an invariant in the present formal category: "
                "integer powers of z are removable by allowed gauge transformations."
            ),
            "model": (
                "The endpoint coefficient is 1+L+...+L^m. A self-carrier center indexed by t "
                "contributes (1+...+L^(t-1))(L+...+L^(m-t)), whose constant and L^m terms vanish."
            ),
            "checked_m_range": [1, bound],
            "checks": [tate_graded_candidate_check(m) for m in range(1, bound + 1)],
            "missing_theorem": (
                "Construct a birationally functorial filtered or integral-exponent enhancement of "
                "the quantum atom that retains these Tate degrees, or prove that no such enhancement exists."
            ),
        },
    }


def canonical_bytes(certificate):
    return (json.dumps(certificate, indent=2, sort_keys=True, default=int) + "\n").encode("utf-8")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--bound", type=int, default=24)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--output", type=Path)
    group.add_argument("--check", type=Path)
    args = parser.parse_args()

    payload = canonical_bytes(build_certificate(args.bound))
    if args.output is not None:
        args.output.write_bytes(payload)
        print(f"wrote {args.output} ({len(payload)} bytes)")
    else:
        tracked = args.check.read_bytes()
        if tracked != payload:
            raise SystemExit(f"certificate mismatch: {args.check}")
        print(f"verified {args.check} ({len(payload)} bytes)")


if __name__ == "__main__":
    main()
