#!/usr/bin/env python3
"""Identify the discriminant quartic of a redundancy-five Hankel pencil as a
classical covariant of the syndrome quartic, and locate the terminal carrier's
residual component.

Objects.  A redundancy-five syndrome is a = (a0,...,a4) in divided-power
coordinates.  Its Hankel matrix

    H_a = [[a0, a1, a2, a3],
           [a1, a2, a3, a4]]

annihilates a pencil W_a of binary cubics g(t) = c0 + c1 t + c2 t^2 + c3 t^3;
equivalently W_a is the degree-three part of the apolar ideal of the binary
quartic attached to a.  For a point x of the affine line, the member of W_a
vanishing at x is the kernel of the 3x4 matrix that adjoins the evaluation row
(1, x, x^2, x^3); dividing it by (t - x) leaves the residual quadratic h_x, and
disc(h_x) is the quartic in x whose square root defines the off-diagonal fibre
square as a double cover.

Syndrome quartic.  In the dual variable the syndrome is

    f_a(x) = a0 x^4 - 4 a1 x^3 + 6 a2 x^2 - 4 a3 x + a4,

normalized so that the normal-rational-curve point (1, t, t^2, t^3, t^4) becomes
(x - t)^4.  Its classical invariants are I and J and its Hessian covariant is H.

Claims checked, all as polynomial identities over the integers, hence valid in
every characteristic:

  1. disc(h_x) = I * H - J * f.
  2. J equals the determinant of the 3x3 catalecticant of a, which is the cubic
     cutting the first prime of the terminal bad carrier.
  3. I = z3 - 3 z2 in the Plucker coordinates of the pencil, so the vanishing of
     the syndrome quartic's first invariant is a linear complex condition.
  4. The locus where f_a is a perfect square satisfies the four printed
     generators of the terminal carrier's residual prime, and carries
     27 J^2 = I^3, so it lies in the quartic discriminant.
  5. The parametrization printed alongside those generators does not satisfy
     three of them, because it is written in plain rather than divided-power
     coefficients.
  6. On the patch Delta = a0*a2-a1^2, direct substitution into Kaipa--Pradhan
     equations (8) and (20) gives D_L = disc(h_x)/(36*Delta^2).  Thus their
     double cover and the fibre square differ by the square (3*Delta)^2, not a
     fixed scalar that could produce a quadratic twist.

Replay:  uv run --with sympy python3 notes/2026-08-07-c883-hankel-plucker-covariant.py
Writes:  notes/2026-08-07-c883-hankel-plucker-covariant.json
"""

import argparse
import json
from pathlib import Path

import sympy as sp

a0, a1, a2, a3, a4, x, t, u, v, w = sp.symbols("a0 a1 a2 a3 a4 x t u v w")
SYNDROME = [a0, a1, a2, a3, a4]


def residual_discriminant(a):
    """disc(h_x) for the pencil member vanishing at x, in the minor normalization."""
    M = sp.Matrix([
        [a[0], a[1], a[2], a[3]],
        [a[1], a[2], a[3], a[4]],
        [1, x, x**2, x**3],
    ])
    cols = list(range(4))
    minors = [(-1) ** j * M[:, [k for k in cols if k != j]].det() for j in cols]
    member = sp.expand(minors[0] + minors[1] * t + minors[2] * t**2 + minors[3] * t**3)
    quad, rem = sp.div(sp.Poly(member, t), sp.Poly(t - x, t))
    assert rem.is_zero, "the selected member must vanish at x"
    A2, A1, A0 = quad.all_coeffs()
    return sp.expand(A1**2 - 4 * A2 * A0)


def quartic_data(a, var):
    """f_a and its classical invariants and Hessian, in the dual variable."""
    A, B, C, D, E = a[0], -a[1], a[2], -a[3], a[4]
    f = sp.expand(A * var**4 + 4 * B * var**3 + 6 * C * var**2 + 4 * D * var + E)
    I = sp.expand(A * E - 4 * B * D + 3 * C**2)
    J = sp.expand(A * C * E + 2 * B * C * D - A * D**2 - B**2 * E - C**3)
    H = sp.expand(
        (A * C - B**2) * var**4
        + 2 * (A * D - B * C) * var**3
        + (A * E + 2 * B * D - 3 * C**2) * var**2
        + 2 * (B * E - C * D) * var
        + (C * E - D**2)
    )
    return f, I, J, H


def plucker(a):
    """Signed maximal minors of the Hankel matrix, in the paper's ordering."""
    return [
        a[2] * a[4] - a[3] ** 2,
        -a[1] * a[4] + a[2] * a[3],
        a[1] * a[3] - a[2] ** 2,
        a[0] * a[4] - a[1] * a[3],
        -a[0] * a[3] + a[1] * a[2],
        a[0] * a[2] - a[1] ** 2,
    ]


def kaipa_pradhan_patch_data(a):
    """Kaipa--Pradhan equations (8) and (20) on the nonzero leading-minor patch."""
    delta = sp.expand(a[0] * a[2] - a[1] ** 2)

    # A basis of the Hankel kernel in ordinary cubic coefficients, with the
    # final two coordinates respectively (1,0) and (0,1).
    first = [
        (a[1] * a[3] - a[2] ** 2) / delta,
        (a[1] * a[2] - a[0] * a[3]) / delta,
        sp.Integer(1),
        sp.Integer(0),
    ]
    second = [
        (a[1] * a[4] - a[2] * a[3]) / delta,
        (a[1] * a[3] - a[0] * a[4]) / delta,
        sp.Integer(0),
        sp.Integer(1),
    ]

    # Kaipa--Pradhan use u0 Y^3 - 3 u1 Y^2 X + 3 u2 Y X^2 - u3 X^3.
    first = [first[0], -first[1] / 3, first[2] / 3, -first[3]]
    second = [second[0], -second[1] / 3, second[2] / 3, -second[3]]
    p = {
        (i, j): sp.cancel(first[i] * second[j] - first[j] * second[i])
        for i in range(4)
        for j in range(i + 1, 4)
    }

    # Equation (8): Pluecker coordinates p_ij in terms of z_0,...,z_5.
    z0 = p[0, 1]
    z1 = p[0, 2] / 2
    z2 = p[0, 3] / 6 + p[1, 2] / 2
    z5 = p[0, 3] / 6 - p[1, 2] / 2
    z3 = p[1, 3] / 2
    z4 = p[2, 3]

    phi = sp.expand(z0 - 4 * z1 * x + 6 * z2 * x**2 - 4 * z3 * x**3 + z4 * x**4)
    residual = sp.expand(
        -z5 * phi
        + (z1**2 - z0 * z2)
        + 2 * (z0 * z3 - z1 * z2) * x
        - (z0 * z4 + 2 * z1 * z3 - 3 * z2**2) * x**2
        + 2 * (z1 * z4 - z2 * z3) * x**3
        + (z3**2 - z2 * z4) * x**4
    )
    return delta, sp.cancel(z5), sp.cancel(phi), sp.cancel(residual)


def residual_generators(c):
    """The four printed generators of the terminal carrier's residual prime."""
    return [
        2 * c[3] ** 3 - 3 * c[2] * c[3] * c[4] + c[1] * c[4] ** 2,
        6 * c[2] * c[3] ** 2 - 9 * c[2] ** 2 * c[4] + 2 * c[1] * c[3] * c[4]
        + c[0] * c[4] ** 2,
        2 * c[1] * c[3] ** 2 - 3 * c[1] * c[2] * c[4] + c[0] * c[3] * c[4],
        c[0] * c[3] ** 2 - c[1] ** 2 * c[4],
    ]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--check",
        action="store_true",
        help="compare regenerated canonical JSON with the tracked certificate without writing",
    )
    args = parser.parse_args()
    results = {}

    disc = residual_discriminant(SYNDROME)
    f, I, J, H = quartic_data(SYNDROME, x)

    identity = sp.expand(disc - (I * H - J * f))
    results["discriminant_is_I_H_minus_J_f"] = identity == 0

    integral = all(
        coefficient.is_integer
        for term in sp.Poly(sp.expand(I * H - J * f), x).coeffs()
        for coefficient in sp.Poly(term, *SYNDROME).coeffs()
    )
    results["identity_is_integral"] = bool(integral)

    for p in (2, 3):
        reduced = sp.expand(sp.Poly(identity, x, *SYNDROME).set_modulus(p).as_expr()) \
            if identity != 0 else 0
        results[f"identity_holds_mod_{p}"] = reduced == 0

    catalecticant = sp.Matrix([
        [a0, a1, a2],
        [a1, a2, a3],
        [a2, a3, a4],
    ]).det()
    results["J_is_catalecticant_determinant"] = sp.expand(J - catalecticant) == 0

    z = plucker(SYNDROME)
    results["I_is_z3_minus_3z2"] = sp.expand(I - (z[3] - 3 * z[2])) == 0
    results["plucker_lies_on_klein_quadric"] = (
        sp.expand(z[0] * z[5] - z[1] * z[4] + z[2] * z[3]) == 0
    )

    # The locus where the syndrome quartic is a perfect square of a quadratic.
    square = sp.Poly(sp.expand((u * x**2 + v * x + w) ** 2), x).all_coeffs()
    square_locus = [
        square[0],
        -sp.Rational(1, 4) * square[1],
        sp.Rational(1, 6) * square[2],
        -sp.Rational(1, 4) * square[3],
        square[4],
    ]
    square_locus = [sp.simplify(term) for term in square_locus]
    results["perfect_square_locus_satisfies_residual_generators"] = all(
        sp.simplify(generator) == 0 for generator in residual_generators(square_locus)
    )
    results["perfect_square_locus_parametrization"] = [
        sp.sstr(term) for term in square_locus
    ]

    _, I_sq, J_sq, _ = quartic_data(square_locus, x)
    results["perfect_square_locus_satisfies_27J2_eq_I3"] = (
        sp.simplify(27 * J_sq**2 - I_sq**3) == 0
    )

    printed = [u**2, 2 * u * v, v**2 + 2 * u * w, 2 * v * w, w**2]
    printed_values = [sp.simplify(generator) for generator in residual_generators(printed)]
    results["plain_parametrization_generator_vanishing"] = [
        value == 0 for value in printed_values
    ]
    results["plain_parametrization_generator_residuals"] = [
        sp.sstr(sp.factor(value)) for value in printed_values
    ]

    # The replacement, cleared of denominators and with v negated for sign-freeness.
    bottom = [6 * u**2, 3 * u * v, v**2 + 2 * u * w, 3 * v * w, 6 * w**2]
    reversed_bottom = list(reversed(bottom))
    results["bottom_parametrization_satisfies_generators"] = all(
        sp.simplify(generator) == 0 for generator in residual_generators(bottom)
    )
    results["bottom_parametrization_satisfies_reversed_generators"] = all(
        sp.simplify(generator) == 0 for generator in residual_generators(reversed_bottom)
    )
    quartic_on_bottom = sum(
        coefficient * sp.Rational(sign) * x ** (4 - power)
        for coefficient, sign, power in zip(
            bottom, (1, -4, 6, -4, 1), range(5)
        )
    )
    results["bottom_parametrization_quartic_is_six_times_a_square"] = (
        sp.simplify(quartic_on_bottom - 6 * (u * x**2 - v * x + w) ** 2) == 0
    )

    # The two surfaces coincide modulo five, so the mismatch is invisible there.
    negated = [term.subs(v, -v) for term in bottom]
    results["plain_equals_bottom_negated_mod_five"] = all(
        sp.simplify(sp.Poly(sp.expand(b - 6 * a_term), u, v, w).set_modulus(5).as_expr()) == 0
        for a_term, b in zip(printed, negated)
    )

    # Irredundancy witnesses: the residual prime is not inside the catalecticant cubic.
    def catalecticant_at(point):
        return sp.Matrix([
            [point[0], point[1], point[2]],
            [point[1], point[2], point[3]],
            [point[2], point[3], point[4]],
        ]).det()

    witness = [3, 0, 1, 0, 3]
    results["witness_on_residual_prime"] = all(
        sp.simplify(generator) == 0 for generator in residual_generators(witness)
    )
    results["witness_catalecticant"] = int(catalecticant_at(witness))
    stale = [1, 0, 2, 0, 1]
    results["stale_witness_generator_values"] = [
        int(sp.simplify(generator)) for generator in residual_generators(stale)
    ]
    results["stale_witness_catalecticant"] = int(catalecticant_at(stale))

    # Match the actual line representative and projective scale in Kaipa--Pradhan,
    # rather than comparing invariant normalizations of differently scaled quartics.
    delta, their_z5, their_phi, their_disc = kaipa_pradhan_patch_data(SYNDROME)
    results["kaipa_pradhan_phi_is_scaled_hessian_on_patch"] = (
        sp.cancel(their_phi + H / (3 * delta)) == 0
    )
    results["kaipa_pradhan_z5_scale_on_patch"] = (
        sp.cancel(their_z5 - I / (18 * delta)) == 0
    )
    results["kaipa_pradhan_discriminant_square_class_on_patch"] = (
        sp.cancel(their_disc - disc / (36 * delta**2)) == 0
    )
    results["fibre_to_kaipa_pradhan_square_factor"] = "(3*(a0*a2 - a1**2))**2"

    out = Path(__file__).with_suffix(".json")
    serialized = json.dumps(results, indent=2, sort_keys=True) + "\n"
    if args.check:
        if out.read_text(encoding="utf-8") != serialized:
            raise SystemExit(f"certificate mismatch: regenerate {out}")
    else:
        out.write_text(serialized, encoding="utf-8")
    for key, value in sorted(results.items()):
        print(f"{key}: {value}")


if __name__ == "__main__":
    main()
