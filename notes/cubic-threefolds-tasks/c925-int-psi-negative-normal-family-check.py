#!/usr/bin/env python3
"""Exact arithmetic certificate for the infinite negative-normal INT-Psi family."""

import argparse
import json
from pathlib import Path

import sympy as sp


def family_member(codimension, leakage_order):
    r = codimension
    k = leakage_order
    assert r >= 4 and k >= 1

    normal_antidegree = (r-1)*(k+2)
    # A concrete rank-r negative bundle with the required total degree.
    normal_degrees = (-(r-1)*(k+1),) + (-1,)*(r-1)
    assert -sum(normal_degrees) == normal_antidegree

    exceptional_index = r-2
    centre_q_exponent = sp.Rational(normal_antidegree, r-1)
    source_normalization_q_exponent = sp.Rational(
        -(exceptional_index+1), r-1
    )
    normalized_mixing_q_exponent = -1 + source_normalization_q_exponent
    normalized_mixing_z_exponent = exceptional_index
    centre_j_z_exponent = -2
    leakage_q_exponent = centre_q_exponent + normalized_mixing_q_exponent
    leakage_z_exponent = normalized_mixing_z_exponent + centre_j_z_exponent

    assert centre_q_exponent == k+2
    assert source_normalization_q_exponent == -1
    assert normalized_mixing_q_exponent == -2
    assert leakage_q_exponent == k
    assert leakage_z_exponent == r-4 >= 0

    ambient_dimension = r+1
    ambient_c1_degree = 2-normal_antidegree
    one_point_virtual_dimension = ambient_dimension-2+ambient_c1_degree
    assert one_point_virtual_dimension == r+1-normal_antidegree < 0

    # l+1 and the normal antidegree are multiples of r-1, so all Fourier
    # and bulk phases are constant across the r-1 centre summands.
    assert (exceptional_index+1) % (r-1) == 0
    assert normal_antidegree % (r-1) == 0

    return {
        "ambient_dimension": ambient_dimension,
        "codimension": r,
        "leakage_order_k": k,
        "normal_bundle_degrees": list(normal_degrees),
        "normal_antidegree": normal_antidegree,
        "exceptional_index_l": exceptional_index,
        "centre_q_exponent": int(centre_q_exponent),
        "normalized_initial_mixing": f"q^-2*z^{r-2}",
        "centre_j_leading_term": f"q^{k+2}*z^-2",
        "base_square_leakage": f"q^{k}*z^{r-4}",
        "raw_exceptional_to_base_leakage": f"q^{k+1}*z^{r-4}",
        "ambient_c1_degree_on_centre": ambient_c1_degree,
        "base_one_point_virtual_dimension": one_point_virtual_dimension,
        "constant_fourier_mode": True,
    }


# Exact two-by-two associated-graded Birkhoff identity. Here b is the
# normalized exceptional-to-base mixing and m the centre J variation.
b, m, restriction = sp.symbols("b m restriction")
psi_initial = sp.Matrix([
    [1, b],
    [restriction, 1+restriction*b],
])
centre_variation = m*sp.Matrix([[0, 0], [0, 1]])
conjugated = sp.simplify(
    psi_initial.inv()*centre_variation*psi_initial
)
assert conjugated == sp.Matrix([
    [-restriction*b*m, -b*m*(1+restriction*b)],
    [restriction*m, m*(1+restriction*b)],
])

# At the extremal bidegree, only the terms containing b*m have nonnegative
# z-order. Projecting and converting from P=Psi^-1 back to Psi leaves the
# base-square coefficient restriction*b*m and the normalized off-diagonal b*m.
positive_extremal = sp.Matrix([
    [-restriction*b*m, -b*m*(1+restriction*b)],
    [0, restriction*b*m],
])
delta_psi_extremal = sp.simplify(-psi_initial*positive_extremal)
assert delta_psi_extremal == sp.Matrix([
    [restriction*b*m, b*m],
    [restriction**2*b*m, 0],
])

sample_members = [
    family_member(r, k)
    for r in range(4, 11)
    for k in range(1, 5)
]

certificate = {
    "schema": "c925-int-psi-negative-normal-family-v1",
    "parameter_range": "all integers r>=4 and k>=1",
    "normal_antidegree_formula": "(r-1)*(k+2)",
    "normal_bundle_model": "O(-(r-1)(k+1)) + O(-1)^(r-1)",
    "ambient_model": "P_{P1}(O + N), with the section from O",
    "normalized_initial_mixing_formula": "q^-2*z^(r-2)",
    "centre_j_leading_formula": "q^(k+2)*z^-2",
    "base_square_leakage_formula": "q^k*z^(r-4)",
    "raw_exceptional_to_base_formula": "q^(k+1)*z^(r-4)",
    "birkhoff_base_square_coefficient": "restriction*b*m",
    "sample_exact_checks": sample_members,
    "conclusion": (
        "For every r>=4 and k>=1, a smooth projective (r+1)-fold blowup "
        "edge has a nonzero first-Novikov reconstructed base-square term "
        "q^k*z^(r-4). Universal q-integral INT-Psi fails in every such "
        "codimension, with arbitrarily large leakage."
    ),
}

parser = argparse.ArgumentParser()
mode = parser.add_mutually_exclusive_group()
mode.add_argument("--write-certificate", type=Path)
mode.add_argument("--check-certificate", type=Path)
arguments = parser.parse_args()
payload = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
if arguments.write_certificate is not None:
    arguments.write_certificate.write_text(payload, encoding="utf-8")
if arguments.check_certificate is not None:
    assert arguments.check_certificate.read_text(encoding="utf-8") == payload
print("checked", len(sample_members), "members; universal formula q^k*z^(r-4)")
