#!/usr/bin/env python3
"""Exact leading-term counterexample to universal (INT-Psi).

For r=4, l=2, Z=P1 and
N_{Z/X}=O(-3)+O(-2)^3, Iritani (5.40) gives q^3 on the
degree-one centre term.  Formula (5.44) gives q^-1 z^2 in the raw l=2
exceptional-to-base entry; Lemma 5.12 normalizes the source by q^-1, so the
entry is q^-2 z^2.  The centre J coefficient is q^3 z^-2.  The linearized
Birkhoff factor therefore has q^1 in the normalized base-to-base block and
q^2 on the raw exceptional column.  In particular it violates even the
weakened square-block integrality actually used by the transport proof.

The 2x2 matrices below are the extremal associated-graded quotient.  eps is
q^(-1/3), so q^-2=eps^6 and q^3=eps^-9.
"""

import argparse
import json
from pathlib import Path

import sympy as sp

r = 4
l = 2
normal_degrees = (-3, -2, -2, -2)
rho_degree = sum(normal_degrees)
assert rho_degree == -9

# (5.40): Q_Z -> Q^(i_*d) q^(-rho.d/(r-1)).
centre_q_exponent = sp.Rational(-rho_degree, r - 1)
assert centre_q_exponent == 3

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

# The competing base-block term on the unit column vanishes.  By the String
# Equation it is a one-point J coefficient, and vdim Mbar_0,1(X,[Z]) is -4.
c1_x_degree = 2 + rho_degree
base_one_point_virtual_dimension = 5 - 2 + c1_x_degree
assert c1_x_degree == -7 and base_one_point_virtual_dimension == -4

# Fourier and bulk phases are constant across j=0,1,2:
# zeta^(-j(l+1))=1 and exp(2pi*i(j+1/2)rho/(r-1))=1.
assert all((j * (l + 1)) % (r - 1) == 0 for j in range(r - 1))
assert rho_degree % (r - 1) == 0
# The common phase is -1 rather than +1; only nonvanishing and equality
# across the three Fourier summands matter.
assert (rho_degree // (r - 1)) % 2 == 1

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
centre_variation = eps ** -9 * z ** -2 * E22
conjugated_variation = sp.simplify(
    positive_initial * centre_variation * psi_initial
)
assert sp.simplify(conjugated_variation - sp.Matrix(
    [[-restriction * eps ** -3,
      -eps ** -3 * (1 + restriction * base_mixing)],
     [restriction * eps ** -9 * z ** -2,
      restriction * eps ** -3 + eps ** -9 * z ** -2]]
)) == sp.zeros(2)

# Take the nonnegative-z part.  If P=Psi^-1, then
# delta(P)=C_+ P_0 and delta(Psi)=-Psi_0 delta(P) Psi_0=-Psi_0 C_+;
# its base-to-centre entry is one.
positive_projection = sp.Matrix([
    [-restriction * eps ** -3,
     -eps ** -3 * (1 + restriction * base_mixing)],
    [0, restriction * eps ** -3],
])
delta_psi_normalized = sp.simplify(
    -psi_initial * positive_projection
)
assert sp.simplify(delta_psi_normalized - sp.Matrix(
    [[restriction * eps ** -3, eps ** -3],
     [restriction ** 2 * eps ** -3, 0]]
)) == sp.zeros(2)

# Raw c_2 = q * (q^-1 c_2) = eps^-3 times the normalized source.
raw_base_row_coefficient = eps ** -3 * delta_psi_normalized
assert delta_psi_normalized[0, 0] == restriction * eps ** -3
assert raw_base_row_coefficient[0, 1] == eps ** -6

certificate = {
    "schema": "c925-int-psi-negative-normal-v1",
    "geometry": {
        "ambient_dimension": 5,
        "centre": "P1",
        "codimension": r,
        "normal_bundle_degrees": normal_degrees,
        "normal_degree": rho_degree,
        "ambient_c1_degree": c1_x_degree,
        "base_one_point_virtual_dimension": base_one_point_virtual_dimension,
    },
    "iritani_terms": {
        "exceptional_index_l": l,
        "raw_base_term": "q^-1*z^2",
        "source_normalization": "q^-1*c_2",
        "normalized_base_term": "q^-2*z^2",
        "centre_term": "q^3*z^-2",
        "fourier_mode": "constant",
    },
    "birkhoff": {
        "normalized_delta_psi_base_to_base": "q = eps^-3",
        "raw_delta_psi_exceptional_to_base": "q^2 = eps^-6",
        "q_integral": False,
    },
    "conclusion": (
        "The Q-linear base-to-base block of Iritani's reconstructed Psi has "
        "a nonzero q^1 coefficient for this blowup edge; even the weakened "
        "square-block INT-Psi needed by transport is false."
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
print("normalized_birkhoff_base_to_base", delta_psi_normalized[0, 0])
print("raw_birkhoff_base_row", raw_base_row_coefficient[0, 1])
print("universal_INT_Psi", False)
