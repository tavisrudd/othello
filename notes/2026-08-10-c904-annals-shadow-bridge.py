#!/usr/bin/env python3
"""Exact finite certificate for the C904 cubic--Winger shadow bridge.

This script checks only algebraic, character-theoretic, and congruence-group
claims.  The Hodge/motivic realization and the cited elliptic-surface lattice
classification belong to the accompanying human proof ledger.
"""

from contextlib import redirect_stdout
from io import StringIO
from math import gcd, lcm
from pathlib import Path
import sys

import sympy as sp
from sympy.matrices.normalforms import smith_normal_form


def inner_product(left, right, class_sizes):
    numerator = sum(n * a * b for n, a, b in zip(class_sizes, left, right))
    value = sp.simplify(sp.Rational(1, sum(class_sizes)) * numerator)
    assert value.is_Integer
    return int(value)


def sl2_mod(n):
    return {
        (a, b, c, d)
        for a in range(n)
        for b in range(n)
        for c in range(n)
        for d in range(n)
        if (a * d - b * c) % n == 1 % n
    }


def gamma_images(n):
    sl2 = sl2_mod(n)
    gamma1 = {
        matrix
        for matrix in sl2
        if matrix[2] % n == 0 and matrix[0] % n == 1 % n and matrix[3] % n == 1 % n
    }
    minus_gamma1 = {
        tuple((-entry) % n for entry in matrix) for matrix in gamma1
    }
    plus_minus_gamma1 = gamma1 | minus_gamma1
    gamma0 = {matrix for matrix in sl2 if matrix[2] % n == 0}
    return gamma1, plus_minus_gamma1, gamma0


def main():
    T, z = sp.symbols("T z")
    chordal = sp.Rational(729, 5)
    D = (T + 27) * (T - chordal)

    # The quadratic cover splitting the Prym twist is rational.  The chosen
    # coordinate is z=eta/(T-729/5).
    T_of_z = sp.factor(27 * (27 * z**2 + 5) / (5 * (z**2 - 1)))
    eta_of_z = sp.factor(864 * z / (5 * (z**2 - 1)))
    assert sp.factor(D.subs(T, T_of_z) - eta_of_z**2) == 0
    assert sp.factor(T_of_z + 27 - 864 * z**2 / (5 * (z**2 - 1))) == 0
    assert sp.factor(T_of_z - chordal - 864 / (5 * (z**2 - 1))) == 0

    # Boundary pullback: z=0 lies over the order-three point, z=infinity over
    # the chordal point, z=+-1 over the width-three cusp, and the width-one
    # cusp has two conjugate preimages 27 z^2+5=0.
    assert T_of_z.subs(z, 0) == -27
    assert sp.limit(T_of_z, z, sp.oo) == chordal
    assert sp.together(T_of_z).as_numer_denom()[1].subs(z, 1) == 0
    assert sp.expand(
        sp.together(T_of_z).as_numer_denom()[0] - 27 * (27 * z**2 + 5)
    ) == 0

    # The sign of the mod-2 permutation representation is a different
    # quadratic character.  The 2-division cubic of the Tate model has
    # discriminant 16*T*(T+27)^8, hence square class T.  Adjoining both
    # square roots gives the genus-one quartic below.
    x, u, v = sp.symbols("x u v")
    b = T + 27
    two_division = 4 * x**3 + b**2 * x**2 + 2 * b**3 * x + b**4
    assert sp.factor(sp.discriminant(two_division, x)) == 16 * T * (T + 27)**8
    combined_quartic = sp.expand((u**2 + 27) * (u**2 - chordal))
    assert sp.discriminant(combined_quartic, u) != 0
    # Binary-quartic invariants for x^4+c*x^2+e.
    c = sp.expand(combined_quartic).coeff(u, 2)
    e = sp.expand(combined_quartic).coeff(u, 0)
    invariant_i = 12 * e + c**2
    invariant_j = 72 * c * e - 2 * c**3
    base_j = sp.factor(
        6912 * invariant_i**3 / (4 * invariant_i**3 - invariant_j**2)
    )
    assert base_j == sp.Rational(357911, 2160)
    # With c,e as above, the standard point-at-infinity transformation sends
    # the quartic to Y^2=X(X^2-2cX+c^2-4e).
    X_map = 2 * (v + u**2) + c
    Y_map = 2 * u * X_map
    weierstrass_relation = sp.expand(
        Y_map**2 - X_map * (X_map**2 - 2 * c * X_map + c**2 - 4 * e)
    )
    quartic_relation = v**2 - combined_quartic
    assert sp.rem(
        sp.Poly(weierstrass_relation, v), sp.Poly(quartic_relation, v)
    ).as_expr() == 0

    # Fricke does not lift to a rational automorphism of this cover: on q=z^2
    # it induces q -> -5q/(22q+5), whose square class is nontrivial.
    q = sp.symbols("q")
    T_of_q = 27 * (27 * q + 5) / (5 * (q - 1))
    fricke_T = sp.factor(729 / T_of_q)
    fricke_q = sp.factor((fricke_T + 27) / (fricke_T - chordal))
    assert fricke_q == -5 * q / (22 * q + 5)

    # A5 character certificate.  Class order is 1A,2A,3A,5A,5B.
    sqrt5 = sp.sqrt(5)
    phi = (1 + sqrt5) / 2
    phibar = (1 - sqrt5) / 2
    class_sizes = (1, 15, 20, 12, 12)
    irreducibles = {
        "1": (1, 1, 1, 1, 1),
        "V3": (3, -1, 0, phi, phibar),
        "V3'": (3, -1, 0, phibar, phi),
        "V4": (4, 0, 1, -1, -1),
        "W5": (5, 1, -1, 0, 0),
    }
    for name, character in irreducibles.items():
        assert inner_product(character, character, class_sizes) == 1, name
    assert inner_product(irreducibles["V4"], irreducibles["W5"], class_sizes) == 0
    tensor_character = tuple(
        a * b for a, b in zip(irreducibles["V4"], irreducibles["W5"])
    )
    tensor_decomposition = {
        name: inner_product(tensor_character, character, class_sizes)
        for name, character in irreducibles.items()
    }
    assert tensor_decomposition == {"1": 0, "V3": 1, "V3'": 1, "V4": 1, "W5": 2}
    assert sum(
        tensor_decomposition[name] * irreducibles[name][0]
        for name in irreducibles
    ) == 20

    # Four copies of the five-dimensional cubic factor and five copies of the
    # four-dimensional Winger factor are the smallest pure powers with equal
    # coefficient dimension.
    common_dimension = lcm(4, 5)
    assert common_dimension == 20
    assert (common_dimension // 5, common_dimension // 4) == (4, 5)

    # Six-axis simplex and the exact polarization forced by Roulleau's fibre
    # intersections.  The six C5-fixed lines in W5 form a regular simplex.
    identity6 = sp.eye(6)
    ones6 = sp.ones(6, 6)
    projection_W5 = identity6 - sp.Rational(1, 6) * ones6
    simplex_vectors = [projection_W5[:, index] for index in range(6)]
    projectors = [sp.Rational(6, 5) * vector * vector.T for vector in simplex_vectors]
    for projector in projectors:
        assert projector * projector == projector
        assert sp.trace(projector) == 1
    for i in range(6):
        for j in range(6):
            if i != j:
                assert sp.trace(projectors[i] * projectors[j]) == sp.Rational(1, 25)
    assert sum(projectors, sp.zeros(6)) == sp.Rational(6, 5) * projection_W5

    # If N_i=dP_i is the norm endomorphism of the i-th elliptic quotient,
    # the minimal-class formula gives F_i.F_j=d^2(1-1/25).  Roulleau's
    # intersection number 24 therefore forces d=5.
    polarization_degree = 5
    norms = [polarization_degree * projector for projector in projectors]
    assert all(sp.trace(norm) == 5 for norm in norms)
    assert all(
        sp.trace(norms[i] * norms[j]) == 1
        for i in range(6)
        for j in range(6)
        if i != j
    )
    assert 5**2 - 1 == 24
    assert sum(norms, sp.zeros(6)) == 6 * projection_W5

    root_gram = sp.eye(5) + sp.ones(5, 5)
    weight_polarization = 6 * sp.eye(5) - sp.ones(5, 5)
    assert root_gram * weight_polarization == 6 * sp.eye(5)
    root_snf = smith_normal_form(root_gram, domain=sp.ZZ)
    weight_snf = smith_normal_form(weight_polarization, domain=sp.ZZ)
    assert [abs(root_snf[i, i]) for i in range(5)] == [1, 1, 1, 1, 6]
    assert [abs(weight_snf[i, i]) for i in range(5)] == [1, 6, 6, 6, 6]
    assert weight_polarization.det() == 6**4

    # Forgetting the sign of a point of order N replaces Gamma_1(N) by
    # <Gamma_1(N),-I>.  It equals Gamma_0(N) exactly when every unit modulo N
    # is +-1.  The bounded enumeration detects the classical list.
    equality_levels = []
    for n in range(1, 101):
        units = {a for a in range(n) if gcd(a, n) == 1}
        signed_units = {1 % n, (-1) % n}
        equality = units == signed_units
        if n <= 12:
            gamma1, plus_minus_gamma1, gamma0 = gamma_images(n)
            assert (plus_minus_gamma1 == gamma0) == equality
        if equality:
            equality_levels.append(n)
        if n == 3:
            assert len(gamma1) == 3
            assert len(plus_minus_gamma1) == 6
            assert len(gamma0) == 6
    assert equality_levels == [1, 2, 3, 4, 6]

    print("Quadratic twist-splitting cover")
    print(f"  D(T)={D}")
    print(f"  T(z)={T_of_z}")
    print(f"  eta(z)={eta_of_z}")
    print("  deck z->-z is the quadratic-twist cocycle [-1]")
    print("  boundary preimages: -27<-0, 729/5<-infinity, infinity<-{+1,-1}, 0<-{27z^2+5=0}")
    print("  pulled-back universal Tate surface: 2 I1 + 2 I3 + IV")
    print("  root lattice A2^3; Shioda--Tate rank 2; Oguiso--Shioda lattice A2* + Z/3")
    print("Two independent quadratic characters")
    print("  twist cover square class D(T); mod-2 sign cover square class T")
    print("  composite cover v^2=(u^2+27)(u^2-729/5) has genus 1")
    print("  Jacobian j of the composite base=357911/2160")
    print("  birational model: Y^2=X(X^2+1188/5 X+746496/25)")
    print("Fricke lift obstruction")
    print(f"  on q=z^2: q'={fricke_q}")
    print("  the cubic chordal branch maps to the smooth value T=5, so the cover is not Fricke-stable")
    print("A5 representation obstruction and minimal repair")
    print("  Hom_A5(W5,V4)=0")
    print(f"  V4 tensor W5 decomposition={tensor_decomposition}")
    print("  minimal pure-power bridge: 4*dim(W5)=5*dim(V4)=20")
    print("  candidate: J(X) tensor V4  ~  A_V(C) tensor W5")
    print("Six-axis polarization certificate")
    print("  regular-simplex projector overlap tr(P_i P_j)=1/25")
    print("  Roulleau F_i.F_j=24 forces elliptic polarization degree d=5")
    print("  norm sum: sum_i N_i=6 on the W5 isotypic space")
    print("  quotient Gram=6I-J, Smith invariants=(1,6,6,6,6)")
    print("  natural six-axis isogeny degree=6^4=1296")
    print("Orientation-forgetting congruence theorem")
    print("  <Gamma_1(N),-I>=Gamma_0(N) exactly for N=1,2,3,4,6")
    print("  N=3 is the unique nontrivial odd prime level with this property")
    print("PASS")


if __name__ == "__main__":
    stream = StringIO()
    with redirect_stdout(stream):
        main()
    rendered = stream.getvalue()
    target = Path(__file__).with_suffix(".out")
    if sys.argv[1:] == ["--write"]:
        target.write_text(rendered)
    elif sys.argv[1:] == ["--check"]:
        assert target.read_text() == rendered
        print("CHECK PASS")
    elif not sys.argv[1:]:
        print(rendered, end="")
    else:
        raise SystemExit("usage: annals-shadow-bridge.py [--write|--check]")
