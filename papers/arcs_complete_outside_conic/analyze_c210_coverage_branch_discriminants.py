#!/usr/bin/env python3
"""Compute the reduced C210 seed--repair ramification equations.

The seed--repair incidence resultant ``P(r)`` has degree seven.  In
characteristic two its derivative is a square,

    P'(r) = Q(r)^2,

so the ordinary discriminant is a square.  Expanding that discriminant hides
the much smaller source equation.  This script works on the translation
quotient ``eta0=1, c1=0`` over GF(8) and computes the exact Jacobian numerator
of the rational chord-incidence map for both seed colours.
"""

from __future__ import annotations

import json
from collections.abc import Iterable

from analyze_c210_residue_hypergraph import build_context


NAMES = ("e", "a", "b", "k", "y0", "y1", "h0", "h1")
Monomial = tuple[int, ...]
Polynomial = dict[Monomial, int]
RPoly = tuple[Polynomial, ...]


class Ring:
    def __init__(self) -> None:
        self.context = build_context(1)
        self.field = self.context.ambient
        self.zero: Polynomial = {}
        self.one: Polynomial = {(0,) * len(NAMES): 1}
        self.variables = {
            name: {tuple(1 if i == j else 0 for i in range(len(NAMES))): 1}
            for j, name in enumerate(NAMES)
        }

    def constant(self, value: int) -> Polynomial:
        return {} if value == 0 else {(0,) * len(NAMES): value}

    def add(self, *values: Polynomial) -> Polynomial:
        out: Polynomial = {}
        for value in values:
            for monomial, coefficient in value.items():
                new = self.field.add(out.get(monomial, 0), coefficient)
                if new:
                    out[monomial] = new
                else:
                    out.pop(monomial, None)
        return out

    def mul(self, left: Polynomial, right: Polynomial) -> Polynomial:
        out: Polynomial = {}
        for a, ca in left.items():
            for b, cb in right.items():
                monomial = tuple(x + y for x, y in zip(a, b))
                coefficient = self.field.add(
                    out.get(monomial, 0), self.field.mul(ca, cb)
                )
                if coefficient:
                    out[monomial] = coefficient
                else:
                    out.pop(monomial, None)
        return out

    def square(self, value: Polynomial) -> Polynomial:
        return {
            tuple(2 * exponent for exponent in monomial):
                self.field.mul(coefficient, coefficient)
            for monomial, coefficient in value.items()
        }

    def product(self, values: Iterable[Polynomial]) -> Polynomial:
        out = self.one
        for value in values:
            out = self.mul(out, value)
        return out

def rtrim(coefficients: Iterable[Polynomial]) -> RPoly:
    out = list(coefficients)
    while out and not out[-1]:
        out.pop()
    return tuple(out)


def radd(ring: Ring, left: RPoly, right: RPoly) -> RPoly:
    return rtrim(
        ring.add(
            left[i] if i < len(left) else ring.zero,
            right[i] if i < len(right) else ring.zero,
        )
        for i in range(max(len(left), len(right)))
    )


def rmul(ring: Ring, left: RPoly, right: RPoly) -> RPoly:
    if not left or not right:
        return ()
    out = [ring.zero] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            out[i + j] = ring.add(out[i + j], ring.mul(a, b))
    return rtrim(out)


Pair = tuple[Polynomial, Polynomial]


def padd(ring: Ring, *values: Pair) -> Pair:
    return (
        ring.add(*(value[0] for value in values)),
        ring.add(*(value[1] for value in values)),
    )


def pmul(ring: Ring, left: Pair, right: Pair) -> Pair:
    """Multiply in F(omega), where omega^2=omega+1."""
    x0, x1 = left
    y0, y1 = right
    cross = ring.mul(x1, y1)
    return (
        ring.add(ring.mul(x0, y0), cross),
        ring.add(ring.mul(x0, y1), ring.mul(x1, y0), cross),
    )


def psquare(ring: Ring, value: Pair) -> Pair:
    return pmul(ring, value, value)


def ramification_numerator(ring: Ring, seed: str) -> Polynomial:
    """Numerator of det_F(dh/dr,dh/dt) for a fixed target abscissa.

    Put ``D=x+t``, ``Y=y+t``, and ``q=g(r)+z``.  The chord height is

        h = z + Y^2 + Y*(D+q/D).

    After clearing the common ``D^2`` denominator, its two derivatives are

        dh/dr = Y*(D^2+omega*bD+q),
        dh/dt = D^3+qD+Y*(D^2+q).

    Their coordinate determinant is the ramification equation.
    """

    e, a, b, k, y0, y1 = (
        ring.variables[name] for name in NAMES[:6]
    )
    # Reuse h0,h1 as the source parameters r,t: the ramification source does
    # not contain target-height variables.
    r = ring.variables["h0"]
    t = ring.variables["h1"]
    one = ring.one
    z0 = one
    z1 = ring.zero if seed == "A" else ring.constant(ring.context.tau)

    D: Pair = (ring.add(one, r, t), e)
    Y: Pair = (ring.add(y0, t), y1)
    q: Pair = (
        ring.add(k, one, z0),
        ring.add(ring.mul(a, ring.square(r)), ring.mul(b, r), z1),
    )
    D2 = psquare(ring, D)
    omega_b_D = pmul(ring, (ring.zero, b), D)
    R = padd(ring, D2, omega_b_D, q)
    T = padd(
        ring,
        pmul(ring, D2, D),
        pmul(ring, q, D),
        pmul(ring, Y, padd(ring, D2, q)),
    )
    Y_R = pmul(ring, Y, R)
    return ring.add(
        ring.mul(Y_R[0], T[1]),
        ring.mul(Y_R[1], T[0]),
    )


def degree_vector(poly: Polynomial) -> dict[str, int]:
    return {
        name: max((monomial[i] for monomial in poly), default=-1)
        for i, name in enumerate(NAMES)
    }


def derivative(ring: Ring, poly: Polynomial, name: str) -> Polynomial:
    index = NAMES.index(name)
    out: Polynomial = {}
    for monomial, coefficient in poly.items():
        if monomial[index] % 2 == 0:
            continue
        reduced = list(monomial)
        reduced[index] -= 1
        out[tuple(reduced)] = coefficient
    return out


def specialize(ring: Ring, poly: Polynomial, values: dict[str, int]) -> Polynomial:
    out: Polynomial = {}
    indexes = {NAMES.index(name): value for name, value in values.items()}
    for monomial, coefficient in poly.items():
        residual = list(monomial)
        scalar = coefficient
        for index, value in indexes.items():
            scalar = ring.field.mul(scalar, ring.field.power(value, residual[index]))
            residual[index] = 0
        key = tuple(residual)
        new = ring.field.add(out.get(key, 0), scalar)
        if new:
            out[key] = new
        else:
            out.pop(key, None)
    return out


def evaluate(ring: Ring, poly: Polynomial, values: dict[str, int]) -> int:
    assert set(values) == set(NAMES)
    out = 0
    for monomial, coefficient in poly.items():
        term = coefficient
        for name, exponent in zip(NAMES, monomial):
            term = ring.field.mul(
                term, ring.field.power(values[name], exponent)
            )
        out = ring.field.add(out, term)
    return out


def rvalue(ring: Ring, poly: RPoly, values: dict[str, int], r: int) -> int:
    out = 0
    for coefficient in reversed(poly):
        out = ring.field.add(
            ring.field.mul(out, r), evaluate(ring, coefficient, values)
        )
    return out


def chord_height(ring: Ring, seed: str, coefficients, r: int, t: int, y: int) -> int:
    field = ring.field
    e, a, b, k = coefficients
    omega = field.div(field.add(ring.context.beta, 1), ring.context.tau)
    eta = field.add(1, field.mul(e, omega))
    x = field.add(eta, r)
    z = ring.context.alpha if seed == "A" else ring.context.beta
    g = field.add(
        field.add(k, 1),
        field.mul(
            omega,
            field.add(field.mul(a, field.mul(r, r)), field.mul(b, r)),
        ),
    )
    assert x != t
    Y = field.add(y, t)
    D = field.add(x, t)
    return field.add(
        z,
        field.add(
            field.mul(Y, Y),
            field.mul(Y, field.add(D, field.div(field.add(g, z), D))),
        ),
    )


def numeric_ramification_numerator(
    ring: Ring, seed: str, coefficients, r: int, t: int, y: int
) -> int:
    field = ring.field
    e, a, b, k = coefficients
    omega = field.div(field.add(ring.context.beta, 1), ring.context.tau)
    eta = field.add(1, field.mul(e, omega))
    D = field.add(field.add(eta, r), t)
    Y = field.add(y, t)
    z = ring.context.alpha if seed == "A" else ring.context.beta
    q = field.add(field.add(k, 1), z)
    q = field.add(q, field.mul(
        omega,
        field.add(field.mul(a, field.mul(r, r)), field.mul(b, r)),
    ))
    D2 = field.mul(D, D)
    R = field.add(
        field.add(D2, field.mul(field.mul(omega, b), D)), q
    )
    T = field.add(
        field.add(field.mul(D2, D), field.mul(q, D)),
        field.mul(Y, field.add(D2, q)),
    )
    left = field.mul(Y, R)
    left0, left1 = ring.context.coordinates(left)
    right0, right1 = ring.context.coordinates(T)
    return field.add(field.mul(left0, right1), field.mul(left1, right0))


def incidence_resultant(ring: Ring, seed: str) -> RPoly:
    e, a, b, k, y0, y1, h0, h1 = (
        ring.variables[name] for name in NAMES
    )
    one = ring.one
    c0 = ring.add(k, one)
    e0 = one
    c1 = ring.zero
    seed0 = one
    seed1 = ring.zero if seed == "A" else ring.constant(ring.context.tau)

    d = ring.add(e0, y0)
    ell = ring.add(e, y1)
    q00 = ring.add(ring.square(d), ring.square(ell), h0, c0)
    q10 = ring.add(c1, ring.square(ell), h1)
    r00 = ring.add(ring.square(e0), ring.square(e), seed0, c0)
    r10 = ring.add(c1, ring.square(e), seed1)
    u2 = ring.add(y0, ring.mul(a, y1))
    u1 = ring.add(q00, r00, ring.mul(b, y1))
    u0 = ring.add(
        ring.mul(e0, q00), ring.mul(e, q10),
        ring.mul(d, r00), ring.mul(ell, r10),
    )
    v2 = ring.add(ring.mul(a, ring.add(y0, y1)), y1)
    v1 = ring.add(q10, r10, ring.mul(b, ring.add(y0, y1)))
    v0 = ring.add(
        ring.mul(e0, q10), ring.mul(e, q00), ring.mul(e, q10),
        ring.mul(d, r10), ring.mul(ell, r00), ring.mul(ell, r10),
    )

    # Sylvester resultant in the seed parameter t, with coefficients in r.
    A = ((d, one), (q00, ring.zero, one), (u0, u1, u2))
    B = ((ell,), (q10, b, a), (v0, v1, v2))
    zero: RPoly = ()
    matrix = (
        (A[0], A[1], A[2], zero),
        (zero, A[0], A[1], A[2]),
        (B[0], B[1], B[2], zero),
        (zero, B[0], B[1], B[2]),
    )
    result: RPoly = ()
    # Four by four is small enough to enumerate directly.
    import itertools
    for permutation in itertools.permutations(range(4)):
        term: RPoly = (ring.one,)
        for row, column in enumerate(permutation):
            term = rmul(ring, term, matrix[row][column])
        result = radd(ring, result, term)
    assert len(result) == 8
    return result


def main() -> None:
    ring = Ring()
    rows = []
    for seed in ("A", "B"):
        polynomial = incidence_resultant(ring, seed)
        ramification = ramification_numerator(ring, seed)
        source_variables = ("y0", "y1", "h0", "h1")
        derivative_counts = {
            name: len(derivative(ring, ramification, name))
            for name in source_variables
        }

        context = ring.context
        base = context.base_values
        nowhere_differentiable = []
        for e in base:
            for a in base:
                if e == 0 or a == 0:
                    continue
                for b in base:
                    for k in base:
                        specialized_derivatives = [
                            specialize(
                                ring, derivative(ring, ramification, name),
                                {"e": e, "a": a, "b": b, "k": k},
                            )
                            for name in source_variables
                        ]
                        if not any(specialized_derivatives):
                            nowhere_differentiable.append((e, a, b, k))
        assert not nowhere_differentiable

        # Check the Jacobian equation against the derivative of the eliminated
        # degree-seven incidence polynomial on deterministic source fibers.
        checks = 0
        for e in base[1:4]:
            for a in base[1:3]:
                for b in base[:3]:
                    k = base[(checks + 2) % len(base)]
                    for r in base[:4]:
                        for t in base[:4]:
                            for y0 in base[:2]:
                                y1 = base[(checks + 3) % len(base)]
                                omega = ring.field.div(
                                    ring.field.add(context.beta, 1), context.tau
                                )
                                x = ring.field.add(
                                    ring.field.add(1, ring.field.mul(e, omega)), r,
                                )
                                if x == t:
                                    continue
                                y = ring.field.add(y0, ring.field.mul(y1, omega))
                                if y in (t, x):
                                    continue
                                h = chord_height(
                                    ring, seed, (e, a, b, k), r, t, y
                                )
                                h0, h1 = context.coordinates(h)
                                target_values = {
                                    "e": e, "a": a, "b": b, "k": k,
                                    "y0": y0, "y1": y1, "h0": h0, "h1": h1,
                                }
                                assert rvalue(ring, polynomial, target_values, r) == 0
                                source_values = {
                                    "e": e, "a": a, "b": b, "k": k,
                                    "y0": y0, "y1": y1, "h0": r, "h1": t,
                                }
                                jacobian_value = evaluate(
                                    ring, ramification, source_values
                                )
                                assert jacobian_value == numeric_ramification_numerator(
                                    ring, seed, (e, a, b, k), r, t, y
                                )
                                checks += 1
        rows.append({
            "seed": seed,
            "incidence_resultant_term_counts": [
                len(coefficient) for coefficient in polynomial
            ],
            "ramification_numerator_term_count": len(ramification),
            "ramification_numerator_total_degree": max(
                map(sum, ramification), default=-1
            ),
            "ramification_numerator_degree_vector": degree_vector(ramification),
            "source_derivative_term_counts": derivative_counts,
            "gf8_repair_stratum_points_with_all_source_derivatives_zero": 0,
            "incidence_and_jacobian_evaluation_checks": checks,
        })
    difference = ring.add(
        ramification_numerator(ring, "A"),
        ramification_numerator(ring, "B"),
    )
    target_y1_monomial = (0, 0, 0, 0, 0, 1, 0, 0)
    target_y1_coefficient = difference[target_y1_monomial]
    assert target_y1_coefficient == ring.field.power(ring.context.tau, 4)
    print(json.dumps({
        "field": "GF(8)",
        "coefficient_quotient": ["eta1", "a1", "b1", "c0"],
        "normalization": "eta0=1, c1=0, k=c0+1",
        "source_coordinates": ["repair r=h0", "seed t=h1", "target y0", "target y1"],
        "identity": "ramification is det_F(dh/dr,dh/dt)=0 after clearing D^2",
        "seed_covers": rows,
        "seed_cover_difference": {
            "term_count": len(difference),
            "total_degree": max(map(sum, difference)),
            "independent_of_a1": degree_vector(difference)["a"] == 0,
            "coefficient_of_target_y1": "tau^4",
            "consequence":
                "the two ramification source equations never coincide on a coefficient stratum",
        },
        "status": "exact low-degree ramification sources constructed and separated; image discriminants remain",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
