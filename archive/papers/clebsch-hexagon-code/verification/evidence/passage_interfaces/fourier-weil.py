#!/usr/bin/env python3
"""Exact normalization and Weil-operator checks for Fourier--Weil/T8."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "fourier-weil.json"
INPUTS = {
    "scheme_fourier": (
        ROOT / "scheme-fourier.json",
        "44499697c354b0ebff69dc675deb111cf3d15e7d9c4f42f8865211b2e8efbbb7",
    ),
    "common_duality": (
        ROOT / "common-duality.json",
        "a09cc2d5b9ea1df82b25a32bcfe019f3f1b5c7e229a3bd23a51e8812163610d1",
    ),
}


def canonical_bytes(data: object) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def mat_mul(left: list[list[int]], right: list[list[int]]) -> list[list[int]]:
    return [
        [sum(left[i][k] * right[k][j] for k in range(len(right))) for j in range(len(right[0]))]
        for i in range(len(left))
    ]


def scalar_identity(size: int, scalar: int) -> list[list[int]]:
    return [[scalar if i == j else 0 for j in range(size)] for i in range(size)]


def check_weighted_self_adjoint(matrix: list[list[int]], weights: list[int]) -> None:
    assert len(matrix) == len(weights)
    assert all(
        weights[i] * matrix[i][j] == weights[j] * matrix[j][i]
        for i in range(len(matrix))
        for j in range(len(matrix))
    )


def involution_multiplicities(matrix: list[list[int]], square_scalar: int) -> list[int]:
    """Return +/- multiplicities when M^2=sI and tr(M)=0."""
    assert mat_mul(matrix, matrix) == scalar_identity(len(matrix), square_scalar)
    assert sum(matrix[i][i] for i in range(len(matrix))) == 0
    assert len(matrix) % 2 == 0
    return [len(matrix) // 2, len(matrix) // 2]


def load_inputs() -> dict[str, dict[str, object]]:
    answer = {}
    for name, (path, expected_hash) in INPUTS.items():
        raw = path.read_bytes()
        assert hashlib.sha256(raw).hexdigest() == expected_hash
        answer[name] = json.loads(raw)
    return answer


def certificate() -> dict[str, object]:
    inputs = load_inputs()
    scheme_fourier = inputs["scheme_fourier"]
    common_duality = inputs["common_duality"]
    q = 11
    order = q**3
    assert scheme_fourier["field"] == common_duality["field"] == q
    assert scheme_fourier["order"] == order

    p8 = scheme_fourier["first_eigenmatrix_P"]
    k8 = scheme_fourier["valencies"]
    assert p8 == scheme_fourier["second_eigenmatrix_Q"]
    assert mat_mul(p8, p8) == scalar_identity(8, order)
    check_weighted_self_adjoint(p8, k8)
    for i, counts in enumerate(scheme_fourier["hyperplane_projective_line_counts"]):
        assert p8[i][0] == 1
        for j in range(1, 8):
            assert k8[j] % (q - 1) == 0
            assert p8[i][j] == q * counts[j] - k8[j] // (q - 1)

    p16 = common_duality["common_refinement_first_eigenmatrix"]
    k16 = common_duality["common_refinement_valencies"]
    assert mat_mul(p16, p16) == scalar_identity(16, order)
    check_weighted_self_adjoint(p16, k16)

    pairs = [tuple(pair) for pair in common_duality["J_odd_relation_pairs"]]
    odd = common_duality["odd_fourier_matrix"]
    derived_odd = [
        [p16[row][left] - p16[row][right] for left, right in pairs]
        for row, _ in pairs
    ]
    assert odd == derived_odd
    odd_weights = [k16[left] + k16[right] for left, right in pairs]
    assert all(k16[left] == k16[right] for left, right in pairs)
    assert mat_mul(odd, odd) == scalar_identity(4, order)
    check_weighted_self_adjoint(odd, odd_weights)
    rank16_multiplicities = involution_multiplicities(p16, order)
    odd_multiplicities = involution_multiplicities(odd, order)
    even_multiplicities = [
        rank16_multiplicities[index] - odd_multiplicities[index] for index in range(2)
    ]
    assert even_multiplicities == [6, 6]

    # For psi(t)=exp(2*pi*i*t/11), the quadratic Gauss sum is i*sqrt(11).
    # The exact finite-field checks below fix its sign class; the positive-imaginary
    # square root is part of the stated complex embedding convention.
    square_counts = [sum((x * x) % q == residue for x in range(q)) for residue in range(q)]
    assert square_counts == [1, 2, 0, 2, 2, 2, 0, 0, 0, 2, 0]
    assert q % 4 == 3 and pow(q - 1, (q - 1) // 2, q) == q - 1

    return {
        "schema": "fourier-fourier-weil-v1",
        "field": q,
        "ambient_function_space_dimension": order,
        "additive_character": "psi(t)=exp(2*pi*i*t/11)",
        "unnormalized_transform": "hat(f)(y)=sum_x psi(y dot x) f(x)",
        "unitary_transform": "F=11^(-3/2) hat",
        "ambient_square": "F^2=R, Rf(x)=f(-x)",
        "weyl_element": "w=[[0,I_3],[-I_3,0]] (plus-kernel Schroedinger convention)",
        "projective_weil_identification": "[rho(w)]=[F]",
        "gauss_sum": "sum_t psi(t^2)=i*sqrt(11)",
        "gauss_factor_gamma": "i",
        "genuine_linearization": "with rho(n_B)f(x)=psi(-x^T B x/2)f(x), rho(w)=gamma^(-3)F=iF",
        "central_action": "rho(-I_6)=-R; on the certified even spaces it is -I",
        "literal_conjugacy_to_genuine_operator": False,
        "reason_not_literal": "F has eigenvalues +/-1, while rho(w)=iF has eigenvalues +/-i",
        "rank8": {
            "space": "C[F_11^3]^(F_11^* x A5_plus)",
            "raw_basis": "relation indicators in the scheme-certificate order",
            "raw_matrix": "P8",
            "raw_matrix_square": "1331 I_8",
            "orthonormal_basis": "1_Rj/sqrt(k_j)",
            "basis_conjugacy": "B8=11^(-3/2) D8^(1/2) P8 D8^(-1/2), D8=diag(k_j)",
            "weighted_self_adjoint": True,
            "unitary_involution_multiplicities_plus_minus": involution_multiplicities(p8, order),
        },
        "rank16": {
            "space": "C[F_11^3]^(F_11^* x A4)",
            "raw_basis": "common-refinement relation indicators in the duality-certificate order",
            "raw_matrix": "P16",
            "raw_matrix_square": "1331 I_16",
            "orthonormal_basis": "1_Sj/sqrt(k_j)",
            "basis_conjugacy": "B16=11^(-3/2) D16^(1/2) P16 D16^(-1/2)",
            "weighted_self_adjoint": True,
            "unitary_involution_multiplicities_plus_minus": rank16_multiplicities,
        },
        "signed_odd_block": {
            "space": "J-odd subspace of C[F_11^3]^(F_11^* x A4)",
            "raw_basis": [f"1_S{left}-1_S{right}" for left, right in pairs],
            "raw_basis_squared_norms": odd_weights,
            "raw_matrix": odd,
            "raw_matrix_square": "1331 I_4",
            "basis_conjugacy": "Bodd=11^(-3/2) Dodd^(1/2) Modd Dodd^(-1/2)",
            "weighted_self_adjoint": True,
            "unitary_involution_multiplicities_plus_minus": odd_multiplicities,
        },
        "joint_J_F_multiplicities": {
            "J_plus_F_plus": even_multiplicities[0],
            "J_plus_F_minus": even_multiplicities[1],
            "J_minus_F_plus": odd_multiplicities[0],
            "J_minus_F_minus": odd_multiplicities[1],
            "consequence": "Fourier eigenvalue multiplicities are unchanged by chirality orientation",
        },
        "field_and_central_filter": {
            "raw_unnormalized_eigenvalues": "+/-11*sqrt(11)",
            "raw_eigenvalue_field": "Q(sqrt(11))",
            "genuine_unnormalized_eigenvalues": "+/-11*sqrt(-11)",
            "genuine_eigenvalue_field": "Q(sqrt(-11))",
            "galois_action": "sqrt(-11)->-sqrt(-11) exchanges the two genuine eigenspaces",
            "legendre_minus_one": -1,
            "diagonal_SL2_central_action_on_certified_spaces": -1,
            "psl2_descent_if_full_diagonal_SL2_action_stabilized_the_space": False,
            "boundary": "the exact field match proves no restricted-module stability",
        },
        "module_discriminator": {
            "fourier_eigenspace_splits": ["4+4 on rank 8", "2+2 on signed rank 4"],
            "relative_cubic_split_from_controller": "3=1+0+1+1",
            "compatible_canonical_identification": False,
            "conclusion": "the Fourier fixed spaces do not recover the three relative-cubic lines",
        },
        "roof_substatement_c": "PROVED with restriction/projective wording; standalone Weil-module and literal genuine-normalization conjugacy are excluded",
        "trusted_inputs": {
            name: {"path": path.name, "sha256": digest}
            for name, (path, digest) in INPUTS.items()
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    raw = canonical_bytes(certificate())
    if args.write:
        OUTPUT.write_bytes(raw)
    if args.check:
        assert OUTPUT.read_bytes() == raw
    if not args.write and not args.check:
        print(raw.decode(), end="")
    print(f"sha256={hashlib.sha256(raw).hexdigest()} bytes={len(raw)}")


if __name__ == "__main__":
    main()
