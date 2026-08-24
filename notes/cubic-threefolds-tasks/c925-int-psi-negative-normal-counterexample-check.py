#!/usr/bin/env python3
"""Exact leading-term counterexample to universal (INT-Psi).

For r=4, l=2, Z=P1 and
N_{Z/X}=O(-2)^2+O(-1)^2, Iritani (5.40) gives q^2 on the
degree-one centre term.  Formula (5.44) gives q^-1 z^2 in the raw l=2
exceptional-to-base entry; Lemma 5.12 normalizes the source by q^-1, so the
entry is q^-2 z^2.  The centre J coefficient is q^2 z^-2.  The linearized
Birkhoff factor therefore has a unit normalized base-row coefficient, which
becomes q^1 on the raw source column and violates q^-1-adic integrality.

The 2x2 matrices below are the extremal associated-graded quotient.  eps is
q^(-1/3), so q^-2=eps^6 and q^2=eps^-6.
"""

import argparse
import json
from pathlib import Path

import sympy as sp

r = 4
l = 2
normal_degrees = (-2, -2, -1, -1)
rho_degree = sum(normal_degrees)
assert rho_degree == -6

# (5.40): Q_Z -> Q^(i_*d) q^(-rho.d/(r-1)).
centre_q_exponent = sp.Rational(-rho_degree, r - 1)
assert centre_q_exponent == 2

# (5.44), k=1: lambda^(l+1)/z = z^l.  Lemma 5.12 uses
# q^(-(l+1)/(r-1)) c_l as the normalized source vector.
raw_base_q_exponent = -1
base_z_exponent = l
source_normalization_q_exponent = sp.Rational(-(l + 1), r - 1)
normalized_base_q_exponent = raw_base_q_exponent + source_normalization_q_exponent
assert (base_z_exponent, source_normalization_q_exponent,
        normalized_base_q_exponent) == (2, -1, -2)

# The degree-one P1 J coefficient on the unit column, modulo H^2=0.
H, z = sp.symbols("H z")
j_coefficient = sp.series(1 / (H + z) ** 2, H, 0, 2).removeO().expand()
assert j_coefficient == z ** -2 - 2 * H * z ** -3

# The competing base-block term vanishes.  The mixing vector is i_*1 of
# complex codimension four, while vdim Mbar_0,2(X,[Z]) is zero.
c1_x_degree = 2 + rho_degree
base_two_point_virtual_dimension = 5 - 3 + 2 + c1_x_degree
mixing_input_codimension = r
assert c1_x_degree == -4 and base_two_point_virtual_dimension == 0
assert mixing_input_codimension > base_two_point_virtual_dimension

# Fourier and bulk phases are constant across j=0,1,2:
# zeta^(-j(l+1))=1 and exp(2pi*i(j+1/2)rho/(r-1))=1.
assert all((j * (l + 1)) % (r - 1) == 0 for j in range(r - 1))
assert rho_degree % (r - 1) == 0
assert (rho_degree // (r - 1)) % 2 == 0

# Linearized Birkhoff factorization in the extremal quotient.
eps, restriction = sp.symbols("eps restriction")
E12 = sp.Matrix([[0, 1], [0, 0]])
E22 = sp.Matrix([[0, 0], [0, 1]])
base_mixing = eps ** 6 * z ** 2
# The arbitrary restriction entry models the lower-triangular reduction
# (I,0; i^*,D) of (5.28); the conclusion is independent of it.
psi_initial = sp.Matrix([
    [1, base_mixing],
    [restriction, 1 + restriction * base_mixing],
])
positive_initial = psi_initial.inv()
centre_variation = eps ** -6 * z ** -2 * E22
conjugated_variation = sp.simplify(
    positive_initial * centre_variation * psi_initial
)
assert conjugated_variation == sp.Matrix(
    [[-restriction, -1 - restriction * base_mixing],
     [restriction * eps ** -6 * z ** -2,
      restriction + eps ** -6 * z ** -2]]
)

# Take the nonnegative-z part.  If P=Psi^-1, then
# delta(P)=C_+ P_0 and delta(Psi)=-Psi_0 delta(P) Psi_0=-Psi_0 C_+;
# its base-to-centre entry is one.
positive_projection = sp.Matrix([
    [-restriction, -1 - restriction * base_mixing],
    [0, restriction],
])
delta_psi_normalized = sp.simplify(
    -psi_initial * positive_projection
)
assert delta_psi_normalized == sp.Matrix(
    [[restriction, 1], [restriction ** 2, 0]]
)

# Raw c_2 = q * (q^-1 c_2) = eps^-3 times the normalized source.
raw_base_row_coefficient = eps ** -3 * delta_psi_normalized
assert raw_base_row_coefficient[0, 1] == eps ** -3

certificate = {
    "schema": "c925-int-psi-negative-normal-v1",
    "geometry": {
        "ambient_dimension": 5,
        "centre": "P1",
        "codimension": r,
        "normal_bundle_degrees": normal_degrees,
        "normal_degree": rho_degree,
        "ambient_c1_degree": c1_x_degree,
        "base_two_point_virtual_dimension": base_two_point_virtual_dimension,
        "mixing_input_codimension": mixing_input_codimension,
    },
    "iritani_terms": {
        "exceptional_index_l": l,
        "raw_base_term": "q^-1*z^2",
        "source_normalization": "q^-1*c_2",
        "normalized_base_term": "q^-2*z^2",
        "centre_term": "q^2*z^-2",
        "fourier_mode": "constant",
    },
    "birkhoff": {
        "normalized_delta_psi_base_row": "1",
        "raw_delta_psi_base_row": "q = eps^-3",
        "q_integral": False,
    },
    "conclusion": (
        "The Q-linear raw base row of Iritani's reconstructed Psi has a "
        "nonzero q^1 coefficient for this blowup edge; universal INT-Psi is "
        "false."
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

print("normal_degree", rho_degree)
print("centre_q_exponent", centre_q_exponent)
print("normalized_birkhoff_base_row", delta_psi_normalized[0, 1])
print("raw_birkhoff_base_row", raw_base_row_coefficient[0, 1])
print("universal_INT_Psi", False)
