#!/usr/bin/env python3
"""Derive the C210 seed--cross-repair collision curve.

On the shared-``(a,b)`` locus left by the two-coset Artin--Schreier
classification, put ``s=r+u``.  Collinearity of a seed point at parameter
``t`` with one point from each repair layer is then two quadratics in ``r``.
This checker derives their six coefficients universally in characteristic
two, forms their Sylvester resultant, and compares the equations with direct
projective incidence over GF(64)/GF(8).
"""

from __future__ import annotations

import itertools
import json
from collections.abc import Iterable

from analyze_c210_exceptional_quadratic_locus import line_key, repair_points
from analyze_c210_residue_hypergraph import build_context


NAMES = (
    "r", "s", "u", "t", "e", "delta", "a", "b",
    "k0", "k1", "c0", "c1", "g0", "g1",
)
Monomial = tuple[int, ...]
Polynomial = set[Monomial]
Pair = tuple[Polynomial, Polynomial]


class BinaryRing:
    """Sparse polynomial ring over GF(2), sufficient for the identity gate."""

    def __init__(self) -> None:
        self.zero: Polynomial = set()
        self.one: Polynomial = {(0,) * len(NAMES)}
        self.variables = {
            name: {tuple(int(i == j) for i in range(len(NAMES)))}
            for j, name in enumerate(NAMES)
        }

    @staticmethod
    def add(*values: Polynomial) -> Polynomial:
        out: Polynomial = set()
        for value in values:
            out.symmetric_difference_update(value)
        return out

    @staticmethod
    def mul(left: Polynomial, right: Polynomial) -> Polynomial:
        out: Polynomial = set()
        for first in left:
            for second in right:
                monomial = tuple(x + y for x, y in zip(first, second))
                if monomial in out:
                    out.remove(monomial)
                else:
                    out.add(monomial)
        return out

    def product(self, values: Iterable[Polynomial]) -> Polynomial:
        out = self.one
        for value in values:
            out = self.mul(out, value)
        return out

    def square(self, value: Polynomial) -> Polynomial:
        return self.mul(value, value)

    def power(self, value: Polynomial, exponent: int) -> Polynomial:
        out = self.one
        while exponent:
            if exponent & 1:
                out = self.mul(out, value)
            value = self.square(value)
            exponent //= 2
        return out

    def substitute(
        self, value: Polynomial, name: str, replacement: Polynomial
    ) -> Polynomial:
        index = NAMES.index(name)
        out = self.zero
        for monomial in value:
            term = self.one
            for position, exponent in enumerate(monomial):
                if exponent:
                    factor = replacement if position == index else self.variables[
                        NAMES[position]
                    ]
                    term = self.mul(term, self.power(factor, exponent))
            out = self.add(out, term)
        return out


def padd(ring: BinaryRing, *values: Pair) -> Pair:
    return (
        ring.add(*(value[0] for value in values)),
        ring.add(*(value[1] for value in values)),
    )


def pmul(ring: BinaryRing, left: Pair, right: Pair) -> Pair:
    """Multiply in F(omega), with omega^2=omega+1."""
    x0, x1 = left
    y0, y1 = right
    cross = ring.mul(x1, y1)
    return (
        ring.add(ring.mul(x0, y0), cross),
        ring.add(ring.mul(x0, y1), ring.mul(x1, y0), cross),
    )


def coefficient(poly: Polynomial, name: str, exponent: int) -> Polynomial:
    index = NAMES.index(name)
    out: Polynomial = set()
    for monomial in poly:
        if monomial[index] == exponent:
            reduced = list(monomial)
            reduced[index] = 0
            out.add(tuple(reduced))
    return out


def derive_quadratics(ring: BinaryRing) -> tuple[Polynomial, ...]:
    v = ring.variables
    r, s, u, t = (v[name] for name in ("r", "s", "u", "t"))
    e, delta, a, b = (v[name] for name in ("e", "delta", "a", "b"))
    k0, k1, c0, c1, g0, g1 = (
        v[name] for name in ("k0", "k1", "c0", "c1", "g0", "g1")
    )
    f = ring.add(e, delta)
    d0 = ring.add(c0, k0)
    d1 = ring.add(c1, k1)

    x: Pair = (r, e)
    x_prime: Pair = (s, f)
    y: Pair = (t, ring.zero)
    left_height: Pair = (
        c0,
        ring.add(ring.product((a, ring.square(r))), ring.mul(b, r), c1),
    )
    right_height: Pair = (
        d0,
        ring.add(ring.product((a, ring.square(s))), ring.mul(b, s), d1),
    )
    seed_height: Pair = (g0, g1)
    difference = padd(ring, x, x_prime)
    y_left = padd(ring, y, x)
    y_right = padd(ring, y, x_prime)

    # The height-interpolation identity, cleared of the chord denominator.
    equations = padd(
        ring,
        pmul(ring, seed_height, difference),
        pmul(ring, left_height, difference),
        pmul(ring, y_left, padd(ring, right_height, left_height)),
        pmul(ring, pmul(ring, difference, y_left), y_right),
    )
    equations = tuple(
        ring.substitute(value, "s", ring.add(r, u)) for value in equations
    )
    return tuple(
        coefficient(equations[coordinate], "r", degree)
        for coordinate in range(2)
        for degree in (2, 1, 0)
    )


def expected_quadratics(ring: BinaryRing) -> tuple[Polynomial, ...]:
    v = ring.variables
    u, t, e, d, a, b = (
        v[name] for name in ("u", "t", "e", "delta", "a", "b")
    )
    k0, k1, c0, c1, g0, g1 = (
        v[name] for name in ("k0", "k1", "c0", "c1", "g0", "g1")
    )
    add, mul, square, product = ring.add, ring.mul, ring.square, ring.product

    A = add(u, mul(a, d))
    B = add(k0, mul(d, b), square(d), square(u))
    C = add(
        mul(e, k1), mul(d, add(c1, g1)), mul(t, add(k0, square(d))),
        mul(u, add(c0, g0)), mul(square(e), d), mul(e, square(d)),
        product((u, e, b)), mul(u, square(e)), product((u, square(t))),
        mul(square(u), t), product((square(u), e, a)),
    )
    D = add(d, mul(a, d), mul(a, u))
    E = add(k1, mul(d, b), square(d), mul(a, square(u)))
    F = add(
        mul(e, add(k0, k1)), mul(d, add(c0, c1, g0, g1)), mul(t, k1),
        mul(u, add(c1, g1)), mul(t, square(d)), mul(square(t), d),
        product((u, e, b)), mul(u, square(e)), product((u, t, b)),
        mul(square(u), e), product((square(u), e, a)),
        product((square(u), t, a)),
    )
    return A, B, C, D, E, F


def resultant(
    ring: BinaryRing, coefficients: tuple[Polynomial, ...]
) -> Polynomial:
    A, B, C, D, E, F = coefficients
    return ring.add(
        ring.mul(ring.square(C), ring.square(D)),
        ring.product((B, C, D, E)),
        ring.product((ring.square(B), D, F)),
        ring.product((A, C, ring.square(E))),
        ring.product((A, B, E, F)),
        ring.mul(ring.square(A), ring.square(F)),
    )


def degrees(poly: Polynomial) -> dict[str, int]:
    positions = {name: NAMES.index(name) for name in ("u", "t")}
    return {
        "u": max(monomial[positions["u"]] for monomial in poly),
        "t": max(monomial[positions["t"]] for monomial in poly),
        "total_u_t": max(
            monomial[positions["u"]] + monomial[positions["t"]]
            for monomial in poly
        ),
    }


def numeric_checks() -> int:
    context = build_context(1)
    field = context.ambient
    base = context.base_values
    add, mul = field.add, field.mul
    def total(*values: int) -> int:
        out = 0
        for value in values:
            out = add(out, value)
        return out
    square = lambda value: mul(value, value)

    checked = 0
    # A fixed, broad coefficient sample; the symbolic identity above is the
    # universal proof, while this catches coordinate-convention mistakes.
    for index in range(24):
        e = base[index % 8]
        delta = base[1 + (3 * index) % 7]
        f = add(e, delta)
        a, b = base[(5 * index + 1) % 8], base[(7 * index + 2) % 8]
        c0, c1 = base[(index + 3) % 8], base[(2 * index + 4) % 8]
        d0, d1 = base[(4 * index + 5) % 8], base[(6 * index + 6) % 8]
        left = dict(zip(base, repair_points(context, e, a, b, c0, c1)))
        right = dict(zip(base, repair_points(context, f, a, b, d0, d1)))
        k0, k1 = add(c0, d0), add(c1, d1)

        for seed_height in (context.alpha, context.beta):
            g0, g1 = context.coordinates(seed_height)
            for r, s, t in itertools.product(base, repeat=3):
                u = add(r, s)
                A = add(u, mul(a, delta))
                B = total(k0, mul(delta, b), square(delta), square(u))
                C = total(
                    mul(e, k1), mul(delta, add(c1, g1)),
                    mul(t, add(k0, square(delta))), mul(u, add(c0, g0)),
                    mul(square(e), delta), mul(e, square(delta)),
                    mul(mul(u, e), b), mul(u, square(e)), mul(u, square(t)),
                    mul(square(u), t), mul(mul(square(u), e), a),
                )
                D = total(delta, mul(a, delta), mul(a, u))
                E = total(k1, mul(delta, b), square(delta), mul(a, square(u)))
                F = total(
                    mul(e, add(k0, k1)),
                    mul(delta, total(c0, c1, g0, g1)), mul(t, k1),
                    mul(u, add(c1, g1)), mul(t, square(delta)),
                    mul(square(t), delta), mul(mul(u, e), b),
                    mul(u, square(e)), mul(mul(u, t), b),
                    mul(square(u), e), mul(mul(square(u), e), a),
                    mul(mul(square(u), t), a),
                )
                equation0 = total(mul(A, square(r)), mul(B, r), C)
                equation1 = total(mul(D, square(r)), mul(E, r), F)
                direct = line_key(context, left[r], right[s]) == line_key(
                    context, left[r], (t, seed_height)
                )
                assert direct == (equation0 == equation1 == 0)
                checked += 1
    return checked


def main() -> None:
    ring = BinaryRing()
    derived = derive_quadratics(ring)
    expected = expected_quadratics(ring)
    assert derived == expected
    A, B, C, D, E, F = expected
    R = resultant(ring, expected)
    H = ring.add(ring.mul(D, B), ring.mul(A, E))
    J = ring.add(ring.mul(D, C), ring.mul(A, F))

    # Substitution of the reconstructed root r=J/H into either quadratic.
    assert ring.add(
        ring.mul(A, ring.square(J)), ring.product((B, H, J)),
        ring.mul(C, ring.square(H)), ring.mul(A, R),
    ) == ring.zero
    assert ring.add(
        ring.mul(D, ring.square(J)), ring.product((E, H, J)),
        ring.mul(F, ring.square(H)), ring.mul(D, R),
    ) == ring.zero

    u_index, t_index, a_index = map(NAMES.index, ("u", "t", "a"))
    leading = {
        monomial for monomial in R
        if monomial[u_index] + monomial[t_index] == 8
    }
    expected_leading = [0] * len(NAMES)
    expected_leading[u_index] = 4
    expected_leading[t_index] = 4
    expected_leading[a_index] = 2
    assert leading == {tuple(expected_leading)}

    print(json.dumps({
        "field": "universal characteristic two; direct check over GF(64)/GF(8)",
        "shared_coefficient_locus": "a'=a, b'=b, delta=e'+e!=0",
        "difference_variables": "s=r+u",
        "collision_equations": {
            "form": ["A*r^2+B*r+C=0", "D*r^2+E*r+F=0"],
            "A": "u+a*delta",
            "B": "k0+delta*b+delta^2+u^2",
            "D": "delta*(1+a)+a*u",
            "E": "k1+delta*b+delta^2+a*u^2",
            "constants": "C,F are the exact formulas recorded in the task report",
        },
        "no_common_infinite_root":
            "A=D=0 would imply delta*(a^2+a+1)=0",
        "resultant": {
            "formula": "A^2*F^2+A*B*E*F+A*C*E^2+B^2*D*F+B*C*D*E+C^2*D^2",
            "term_count": len(R),
            "degrees": degrees(R),
            "top_u_t_form": "a^2*u^4*t^4",
        },
        "rational_reconstruction": {
            "H": "D*B+A*E",
            "J": "D*C+A*F",
            "generic": "on H!=0, resultant=0 iff r=J/H is the unique common root",
            "degenerate": "on H=0, resultant=0 forces J=0; the two quadratics share their full gcd and require a separate split test",
            "identities": [
                "A*J^2+B*H*J+C*H^2=A*resultant",
                "D*J^2+E*H*J+F*H^2=D*resultant",
            ],
        },
        "direct_projective_incidence_checks": numeric_checks(),
        "status":
            "seed--cross-repair legality is reduced to rational points of one explicit bidegree-(6,4) resultant curve plus its H=J=0 split locus",
        "next_gate":
            "classify the resultant curve's components and Frobenius classes on the cross-repair trace-one locus before any affine-coverage test",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
