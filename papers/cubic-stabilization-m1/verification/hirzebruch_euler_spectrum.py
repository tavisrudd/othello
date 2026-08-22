#!/usr/bin/env python3
"""Euler spectrum of a specialized Hirzebruch surface.

The Hirzebruch surface `F_a = P(O + O(a))` over the projective line, `a >= 0`, is
the general rational geometrically ruled surface; these are the minimal ones
apart from `F_1`, which is the projective plane blown up at a point.  Its even
cohomology `H^0 + H^2 + H^4` has rank four, with `H^2` spanned by the class `F` of a fibre
and the class `S` of the section of self-intersection `-a`; the curve classes
are the fibre class `f` and the negative-section class `s`, with
`f.f = 0`, `f.s = 1`, `s.s = -a`, and first Chern number `c_1.f = 2`,
`c_1.s = 2 - a`.

Genus-zero Gromov--Witten invariants are deformation invariant, and for `a >= 2`
one smooth projective family joins `F_a` to `F_{a - 2k}` with `k = a // 2`: the
extensions of `O(a)` by `O` whose class is a multiple of the class of a nowhere
vanishing pair of sections of `O(k)` and `O(a - k)`.  The parallel transport of
the curve-class lattice fixes the fibre class and, being determined by the
intersection form, sends `s` to `s_0 - k f`; so it sends `s + k f` to the
negative section `s_0` of `F_{a - 2k}`, and the divisor class `S + k F`, whose
self-intersection is `-a + 2k`, to the negative section there.  Writing

    u = the specialized Novikov value of the fibre class f,
    w = the specialized Novikov value of the class s + k f,

the small quantum cohomology of `F_a` after the specialization is therefore the
quantum Stanley--Reisner presentation of `F_0` or `F_1` in the deformed
generators `Sd = S + k F` and `F`:

    a even:  Sd * Sd = u,           F * F = w,        Euler class 2 Sd + 2 F
    a odd:   Sd * Sd + Sd * F = u,  F * F = w * Sd,   Euler class 2 Sd + 3 F

This script builds the rank-four matrix of Euler multiplication in each case,
computes its characteristic polynomial and the discriminant of that quartic, and
records the exact degeneracy locus.  It also runs the cross-checks listed under
CHECKS below and writes a canonical JSON certificate.

What the certificate establishes: the two displayed quartics and their
discriminants are the characteristic polynomial and discriminant of Euler
multiplication in the presented ring, and the Jordan structure at the
degeneracy locus is as recorded.  What it does not establish: that the
presented ring is the small quantum cohomology of the surface.  That is the
mathematical content of the deformation reduction and of the toric
presentation for `F_0` and `F_1`, argued in the manuscript and cited there; no
step of it is computational.

CHECKS

  presentation      the deformed presentation degenerates at u = w = 0 to the
                    classical cohomology ring of F_a, in the classical
                    generators F and S = Sd - k F, with F.F = 0, S.F = 1,
                    S.S = -a
  homogeneity       the presentation and the characteristic polynomial are
                    homogeneous for the Novikov grading deg X = 2, deg u = 4,
                    deg w = 4 - 2 * (a mod 2); recorded once per index for
                    uniformity, though the quartic depends on a only through its
                    parity
  elimination       the characteristic polynomial obtained from the
                    multiplication matrix agrees with the one obtained by
                    eliminating the two divisor generators from the ideal
                    together with X - (Euler class)
  discriminant      the discriminant obtained from the quartic coefficients
                    agrees with the squared product of the pairwise root
                    differences of an explicit splitting
  frobenius         a self-consistency check of the multiplication matrix
                    against an independently built multiplication operator;
                    self-adjointness for the trace form holds for any
                    commutative presentation, so that flag tests agreement of
                    the two constructions rather than a property of this ring.
                    The recorded nondegeneracy of the trace form is a structural
                    comparison of its determinant against the literal zero, so
                    it certifies that the determinant does not simplify to zero,
                    not that it is nonzero at every specialization
  gromov_witten     for F_2 the presentation agrees with the relations computed
                    directly from the genus-zero invariants <pt>_f = 1,
                    <pt>_{f+s} = 1, all other point invariants in classes of
                    first Chern number two being zero
  degeneracy        on the degeneracy locus the quartic has root multiplicities
                    1, 1, 2 and the matrix of Euler multiplication is semisimple
                    at the double root; simplicity of the spectrum off the locus
                    follows from the recorded discriminant, not from this check

Replay, from the paper directory `papers/cubic-stabilization-m1`:

    uv run --with sympy python3 verification/hirzebruch_euler_spectrum.py

    uv run --with sympy python3 verification/hirzebruch_euler_spectrum.py --check

The second form regenerates the certificate in memory and compares it with the
tracked file, leaving the working tree unchanged.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import pathlib
import sys

import sympy as sp

X, U, W, T = sp.symbols("X u w t")

# The range of Hirzebruch indices the structural checks are run over.  The
# presentation depends on a only through k = a // 2 and the parity, so the
# range is a finite check of a statement that is uniform in a; it is not a
# bounded substitute for the general argument.
INDICES = tuple(range(0, 13))


def deformed_relations(parity: int) -> list[sp.Expr]:
    """Relations of the presented ring in the deformed generators Sd, F."""
    Sd, F = sp.symbols("Sd F")
    if parity == 0:
        return [Sd**2 - U, F**2 - W]
    return [Sd**2 + Sd * F - U, F**2 - W * Sd]


def euler_class(parity: int) -> sp.Expr:
    """First Chern class in the deformed generators."""
    Sd, F = sp.symbols("Sd F")
    return 2 * Sd + (2 if parity == 0 else 3) * F


def multiplication_matrix(parity: int) -> sp.Matrix:
    """Matrix of Euler multiplication in the basis 1, F, Sd, Sd*F."""
    Sd, F = sp.symbols("Sd F")
    basis = [sp.Integer(1), F, Sd, Sd * F]
    field = sp.QQ.frac_field(U, W)
    groebner = sp.groebner(deformed_relations(parity), Sd, F, order="grevlex", domain=field)
    matrix = sp.zeros(4, 4)
    for column, element in enumerate(basis):
        reduced = sp.expand(groebner.reduce(sp.expand(euler_class(parity) * element))[1])
        polynomial = sp.Poly(reduced, Sd, F)
        for monomial, coefficient in zip(polynomial.monoms(), polynomial.coeffs()):
            target = Sd ** monomial[0] * F ** monomial[1]
            matrix[basis.index(sp.expand(target)), column] = sp.together(coefficient)
    return matrix


def characteristic_polynomial(parity: int) -> sp.Expr:
    """Characteristic polynomial of Euler multiplication, monic of degree four."""
    return sp.expand(multiplication_matrix(parity).charpoly(X).as_expr())


def quartic_coefficients(polynomial: sp.Expr) -> list[sp.Expr]:
    """Coefficients l0, l1, l2, l3 of a monic quartic X^4 + l3 X^3 + ... + l0."""
    poly = sp.Poly(polynomial, X)
    if poly.degree() != 4 or sp.simplify(poly.LC() - 1) != 0:
        raise SystemExit("characteristic polynomial is not a monic quartic")
    return [sp.expand(poly.coeff_monomial(X**index)) for index in range(4)]


def check_presentation(index: int) -> dict:
    """The presented ring degenerates at u = w = 0 to the cohomology of F_a."""
    parity = index % 2
    half = index // 2
    Sd, F, S = sp.symbols("Sd F S")
    classical = [relation.subs({U: 0, W: 0}).subs(Sd, S + half * F) for relation in
                 deformed_relations(parity)]
    # In H^*(F_a) the products are F.F = 0, S.F = 1, S.S = -a, in units of the
    # point class; a degree-two expression vanishes exactly when its evaluation
    # against those structure constants vanishes.
    def evaluate(expression: sp.Expr) -> sp.Expr:
        polynomial = sp.Poly(sp.expand(expression), S, F)
        total = sp.Integer(0)
        for (exponent_s, exponent_f), coefficient in zip(polynomial.monoms(), polynomial.coeffs()):
            if exponent_s + exponent_f != 2:
                raise SystemExit("classical relation is not purely quadratic")
            if exponent_s == 2:
                total += coefficient * (-index)
            elif exponent_s == 1:
                total += coefficient
        return sp.expand(total)

    values = [evaluate(relation) for relation in classical]
    euler = sp.expand(euler_class(parity).subs(Sd, S + half * F))
    return {
        "index": index,
        "classical_relations_vanish": all(value == 0 for value in values),
        "euler_class": sp.sstr(euler),
        "euler_class_matches_anticanonical": sp.expand(euler - (2 * S + (index + 2) * F)) == 0,
    }


def check_homogeneity(index: int) -> dict:
    """The presentation and the quartic are homogeneous for the Novikov grading."""
    parity = index % 2
    weights = {X: 2, U: 4, W: 4 - 2 * parity}
    scale = sp.Symbol("lam", positive=True)
    polynomial = characteristic_polynomial(parity)
    scaled = polynomial.subs({symbol: scale ** weight * symbol
                              for symbol, weight in weights.items()}, simultaneous=True)
    homogeneous = sp.simplify(sp.expand(scaled - scale**8 * polynomial)) == 0
    return {"index": index, "degree_w": weights[W], "characteristic_polynomial_homogeneous": homogeneous}


def check_elimination(parity: int) -> dict:
    """The quartic agrees with the one obtained by eliminating the generators."""
    Sd, F = sp.symbols("Sd F")
    ideal = deformed_relations(parity) + [X - euler_class(parity)]
    basis = sp.groebner(ideal, Sd, F, X, order="lex", domain=sp.QQ.frac_field(U, W))
    eliminated = [generator for generator in basis.exprs
                  if not generator.free_symbols & {Sd, F}]
    if len(eliminated) != 1:
        raise SystemExit("elimination did not produce a single relation in X")
    monic = sp.expand(sp.Poly(eliminated[0], X).monic().as_expr())
    return {
        "agrees": sp.simplify(sp.expand(monic - characteristic_polynomial(parity))) == 0,
        "eliminated_relation": sp.sstr(monic),
    }


def check_discriminant(parity: int) -> dict:
    """The discriminant agrees with the squared product of root differences."""
    polynomial = characteristic_polynomial(parity)
    discriminant = sp.factor(sp.discriminant(sp.Poly(polynomial, X)))
    # Independent route: split the quartic over an explicit extension and form
    # the squared product of the pairwise root differences.
    if parity == 0:
        alpha, beta = sp.symbols("alpha beta")
        split = [2 * (alpha + beta), 2 * (alpha - beta), -2 * (alpha - beta), -2 * (alpha + beta)]
        substitution = {U: alpha**2, W: beta**2}
    else:
        # For the odd presentation the four points of the spectrum are
        # parametrized by the roots of t^4 + w t^3 - u w^2, through
        # Sd = t^2 / w and the eigenvalue 2 t^2 / w + 3 t.
        parametrized = T**4 + W * T**3 - U * W**2
        substitution = None
        split = None
    if split is not None:
        product = sp.Integer(1)
        for first in range(4):
            for second in range(first + 1, 4):
                product *= (split[first] - split[second]) ** 2
        # Compare in the splitting variables: substitute u = alpha^2, w = beta^2
        # into the discriminant computed from the coefficients.
        by_coefficients = sp.expand(sp.expand(discriminant).subs(substitution))
        agrees = sp.expand(sp.expand(product) - by_coefficients) == 0
        route = "explicit splitting 2(+-alpha+-beta) with alpha^2 = u, beta^2 = w"
        # The quartic itself must equal the product of the four linear factors.
        rebuilt = sp.expand(sp.prod([X - value for value in split]))
        agrees = agrees and sp.expand(rebuilt - sp.expand(polynomial.subs(substitution))) == 0
    else:
        # Independent route for the odd case: the eigenvalues are the images of
        # the roots of the parametrizing quartic, so the characteristic
        # polynomial is the resultant of that quartic with w X - 2 t^2 - 3 w t.
        resultant = sp.resultant(parametrized, W * X - 2 * T**2 - 3 * W * T, T)
        monic = sp.expand(sp.Poly(sp.expand(resultant), X).monic().as_expr())
        agrees = sp.simplify(sp.expand(monic - polynomial)) == 0
        route = "resultant with the parametrizing quartic t^4 + w t^3 - u w^2"
        by_roots = None
    coefficients = quartic_coefficients(polynomial)
    return {
        "characteristic_polynomial": sp.sstr(polynomial),
        "coefficients": [sp.sstr(coefficient) for coefficient in coefficients],
        "discriminant": sp.sstr(sp.factor(discriminant)),
        "independent_route": route,
        "independent_route_agrees": bool(agrees),
    }


def check_frobenius(parity: int) -> dict:
    """Euler multiplication is self-adjoint for the trace form of the ring."""
    matrix = multiplication_matrix(parity)
    # The trace form of a finite commutative algebra is g(x, y) = tr(x * y); a
    # multiplication operator is always self-adjoint for it, and the form is
    # nondegenerate exactly when the algebra is separable.  Both are checked.
    Sd, F = sp.symbols("Sd F")
    basis = [sp.Integer(1), F, Sd, Sd * F]
    field = sp.QQ.frac_field(U, W)
    groebner = sp.groebner(deformed_relations(parity), Sd, F, order="grevlex", domain=field)

    def operator(element: sp.Expr) -> sp.Matrix:
        columns = sp.zeros(4, 4)
        for column, other in enumerate(basis):
            reduced = sp.expand(groebner.reduce(sp.expand(element * other))[1])
            polynomial = sp.Poly(reduced, Sd, F)
            for monomial, coefficient in zip(polynomial.monoms(), polynomial.coeffs()):
                target = sp.expand(Sd ** monomial[0] * F ** monomial[1])
                columns[basis.index(target), column] = sp.together(coefficient)
        return columns

    form = sp.zeros(4, 4)
    for row, left in enumerate(basis):
        for column, right in enumerate(basis):
            form[row, column] = sp.simplify(operator(sp.expand(left * right)).trace())
    selfadjoint = sp.simplify(sp.expand((matrix.T * form - form * matrix))) == sp.zeros(4, 4)
    return {
        "trace_form_nondegenerate_generically": sp.simplify(form.det()) != 0,
        "euler_selfadjoint": bool(selfadjoint),
    }


def check_gromov_witten() -> dict:
    """The presentation for F_2 agrees with a direct invariant computation.

    For `F_2` the first Chern number of `m f + n s` is `2 m`, so a three-point
    genus-zero invariant with two divisor insertions is nonzero only for
    `m = 1`, where the third insertion is the point class and the invariant is
    `(D . beta)(D' . beta) <pt>_beta`.  Deformation to `F_0` gives
    `<pt>_f = <pt>_{f+s} = 1` and `<pt>_{f+n s} = 0` for `n >= 2`.  The
    resulting products are compared with the presented ring.
    """
    Sd, F, S = sp.symbols("Sd F S")
    qf, qs = sp.symbols("qf qs")
    # Intersection numbers on F_2 in the classical divisor basis S, F.
    def pair(divisor: sp.Expr, curve: tuple[int, int]) -> sp.Expr:
        # curve = (m, n) for m f + n s; S.f = 1, S.s = -2, F.f = 0, F.s = 1
        polynomial = sp.Poly(sp.expand(divisor), S, F)
        total = sp.Integer(0)
        for (exponent_s, exponent_f), coefficient in zip(polynomial.monoms(), polynomial.coeffs()):
            total += coefficient * (exponent_s * (curve[0] - 2 * curve[1])
                                    + exponent_f * curve[1])
        return sp.expand(total)

    point_invariants = {(1, 0): sp.Integer(1), (1, 1): sp.Integer(1)}

    def quantum_square(divisor: sp.Expr, other: sp.Expr, classical: sp.Expr) -> sp.Expr:
        """Product of two divisors: classical part plus the identity-valued tail."""
        tail = sp.Integer(0)
        for (curve, invariant) in point_invariants.items():
            tail += qf ** curve[0] * qs ** curve[1] * pair(divisor, curve) * pair(other, curve) * invariant
        return sp.expand(classical + tail)

    # Classical products in units of the point class: S.S = -2, S.F = 1, F.F = 0.
    point = sp.Symbol("pt")
    square_S = quantum_square(S, S, -2 * point)
    square_F = quantum_square(F, F, 0 * point)
    product_SF = quantum_square(S, F, point)
    # The presented ring for a = 2 has Sd = S + F, Sd^2 = u, F^2 = w with
    # u = qf and w = qf * qs.
    presented_Sd_square = sp.expand(square_S + 2 * product_SF + square_F)
    presented_F_square = square_F
    return {
        "S_square": sp.sstr(square_S),
        "F_square": sp.sstr(square_F),
        "S_F_product": sp.sstr(product_SF),
        "deformed_section_square": sp.sstr(presented_Sd_square),
        "matches_even_presentation": bool(
            sp.expand(presented_Sd_square - qf) == 0
            and sp.expand(presented_F_square - qf * qs) == 0
        ),
    }


def check_degeneracy(parity: int) -> dict:
    """Block structure of Euler multiplication on and off the degeneracy locus."""
    polynomial = characteristic_polynomial(parity)
    matrix = multiplication_matrix(parity)
    if parity == 0:
        # Discriminant 2^24 u^2 w^2 (u - w)^2; for u, w nonzero it vanishes
        # exactly on u = w.
        locus = "u = w"
        specialization = {W: U}
    else:
        # Discriminant -u^2 w^2 (256 u + 27 w^2)^3; for u, w nonzero it
        # vanishes exactly on 256 u + 27 w^2 = 0.
        locus = "256 u + 27 w^2 = 0"
        specialization = {U: -sp.Rational(27, 256) * W**2}
    degenerate = sp.factor(sp.expand(polynomial.subs(specialization)))
    factors = sp.factor_list(sp.expand(polynomial.subs(specialization)), X)
    multiplicities = sorted(
        multiplicity
        for factor, multiplicity in factors[1]
        for _ in range(sp.Poly(factor, X).degree())
    )
    repeated = [[sp.sstr(factor), int(multiplicity)] for factor, multiplicity in factors[1]
                if multiplicity > 1]
    if parity == 0:
        double_root = sp.Integer(0)
    else:
        double_root = -sp.Rational(9, 8) * W
    specialized = matrix.subs(specialization)
    centered = sp.expand(specialized - double_root * sp.eye(4))
    nullity = 4 - centered.rank()
    # The generalized eigenspace equals the eigenspace exactly when squaring
    # the centered matrix does not enlarge the kernel.
    nilpotent_part_vanishes = sp.expand(centered * centered).rank() == centered.rank()
    return {
        "degeneracy_locus": locus,
        "factorization_at_locus": sp.sstr(degenerate),
        "root_multiplicities": [int(multiplicity) for multiplicity in multiplicities],
        "repeated_factors": repeated,
        "double_root": sp.sstr(double_root),
        "eigenspace_dimension_at_double_root": int(nullity),
        "semisimple_at_double_root": int(nullity) == 2,
        "nilpotent_part_vanishes": bool(nilpotent_part_vanishes),
    }


def valuation_table() -> list[dict]:
    """When the degeneracy locus is compatible with the strict valuation law.

    Strict Novikov admissibility gives `v(u) = l(f)` and
    `v(w) = l(s) + k l(f)` with `l` positive on nonzero effective classes.
    For `a = 2k` the degeneracy `u = w` needs `l(f) = l(s) + k l(f)`, and for
    `a = 2k + 1` the degeneracy `256 u + 27 w^2 = 0` needs
    `l(f) = 2 l(s) + 2 k l(f)`.  Each is a linear condition whose solvability
    with `l(f), l(s) > 0` is recorded.
    """
    rows = []
    for index in INDICES:
        half, parity = index // 2, index % 2
        # Condition on (l(f), l(s)) forced by equal valuations.
        if parity == 0:
            solvable = (1 - half) > 0
            condition = f"l(s) = {1 - half} l(f)"
        else:
            solvable = (1 - 2 * half) > 0
            condition = f"2 l(s) = {1 - 2 * half} l(f)"
        rows.append({
            "index": index,
            "valuation_condition": condition,
            "compatible_with_positive_length": bool(solvable),
        })
    return rows


def certificate() -> dict:
    """The canonical certificate of this bundle."""
    return {
        "schema": "hirzebruch-euler-spectrum-v1",
        "presentation": {
            "even": {
                "relations": ["Sd^2 = u", "F^2 = w"],
                "euler_class": "2 Sd + 2 F",
            },
            "odd": {
                "relations": ["Sd^2 + Sd F = u", "F^2 = w Sd"],
                "euler_class": "2 Sd + 3 F",
            },
            "novikov_values": "u = chi(Q^f), w = chi(Q^(s + k f)) with k = a // 2",
        },
        "spectrum": {
            "even": check_discriminant(0),
            "odd": check_discriminant(1),
        },
        "degeneracy": {
            "even": check_degeneracy(0),
            "odd": check_degeneracy(1),
        },
        "checks": {
            "presentation": [check_presentation(index) for index in INDICES],
            "homogeneity": [check_homogeneity(index) for index in INDICES],
            "elimination": {"even": check_elimination(0), "odd": check_elimination(1)},
            "frobenius": {"even": check_frobenius(0), "odd": check_frobenius(1)},
            "gromov_witten": check_gromov_witten(),
        },
        "valuation_exclusion": valuation_table(),
    }


def assert_all_checks_pass(record: dict) -> None:
    """Fail loudly if any recorded check is negative."""
    failures: list[str] = []
    for row in record["checks"]["presentation"]:
        if not row["classical_relations_vanish"] or not row["euler_class_matches_anticanonical"]:
            failures.append(f"presentation a={row['index']}")
    for row in record["checks"]["homogeneity"]:
        if not row["characteristic_polynomial_homogeneous"]:
            failures.append(f"homogeneity a={row['index']}")
    for parity in ("even", "odd"):
        if not record["checks"]["elimination"][parity]["agrees"]:
            failures.append(f"elimination {parity}")
        if not record["checks"]["frobenius"][parity]["euler_selfadjoint"]:
            failures.append(f"frobenius {parity}")
        if not record["checks"]["frobenius"][parity]["trace_form_nondegenerate_generically"]:
            failures.append(f"trace form {parity}")
        if not record["spectrum"][parity]["independent_route_agrees"]:
            failures.append(f"discriminant {parity}")
        block = record["degeneracy"][parity]
        if sorted(block["root_multiplicities"]) != [1, 1, 2] or not block["semisimple_at_double_root"]:
            failures.append(f"degeneracy {parity}")
    if not record["checks"]["gromov_witten"]["matches_even_presentation"]:
        failures.append("gromov_witten")
    for row in record["valuation_exclusion"]:
        if row["index"] >= 2 and row["compatible_with_positive_length"]:
            failures.append(f"valuation a={row['index']}")
    if failures:
        raise SystemExit("failed checks: " + ", ".join(failures))


def serialize(record: dict) -> str:
    """Canonical serialization: sorted keys, fixed separators, trailing newline."""
    return json.dumps(record, indent=2, sort_keys=True) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--check", action="store_true",
                        help="compare with the tracked certificate instead of writing it")
    arguments = parser.parse_args()

    here = pathlib.Path(__file__).resolve().parent
    target = here / "hirzebruch-euler-spectrum.json"
    manifest = here / "hirzebruch-euler-spectrum.sha256"

    record = certificate()
    assert_all_checks_pass(record)
    payload = serialize(record)

    if arguments.check:
        if not target.is_file():
            print(f"missing certificate: {target}", file=sys.stderr)
            return 1
        if target.read_text() != payload:
            print(f"certificate differs from {target}", file=sys.stderr)
            return 1
        expected = manifest.read_text().split()
        for path, digest in zip(expected[1::2], expected[0::2]):
            actual = hashlib.sha256((here / path).read_bytes()).hexdigest()
            if actual != digest:
                print(f"digest mismatch for {path}", file=sys.stderr)
                return 1
        print("certificate and digests agree")
        return 0

    target.write_text(payload)
    lines = []
    for path in ("hirzebruch_euler_spectrum.py", "hirzebruch-euler-spectrum.json"):
        digest = hashlib.sha256((here / path).read_bytes()).hexdigest()
        lines.append(f"{digest}  {path}")
    manifest.write_text("\n".join(lines) + "\n")
    print(payload, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
