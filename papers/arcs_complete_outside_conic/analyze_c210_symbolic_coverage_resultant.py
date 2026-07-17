#!/usr/bin/env python3
"""Derive the coefficient-parametric C210 seed--repair resultant.

The calculation is over the polynomial ring in characteristic two.  It keeps
the quadratic repair coefficients and target coordinates symbolic, computes
the Sylvester resultant in the repair parameter, and certifies its leading
coefficients.  Two GF(8) specializations independently witness squarefreeness
on the degree-seven and degree-six strata.
"""

from __future__ import annotations

import itertools
import json
from typing import Iterable

from analyze_c210_persistent_singletons import (
    coverage_equations,
    poly_divmod,
    sylvester_resultant,
    trim,
)
from analyze_c210_residue_hypergraph import build_context

NAMES = (
    "e0", "e1", "a1", "b1", "c0", "c1",
    "y0", "y1", "h0", "h1", "z0", "z1",
)
Monomial = tuple[int, ...]
Symbolic = frozenset[Monomial]
RPoly = tuple[Symbolic, ...]
ZERO: Symbolic = frozenset()
ONE: Symbolic = frozenset({(0,) * len(NAMES)})


def variable(index: int) -> Symbolic:
    exponents = [0] * len(NAMES)
    exponents[index] = 1
    return frozenset({tuple(exponents)})


VARS = dict(zip(NAMES, map(variable, range(len(NAMES)))))


def symbolic_add(*values: Symbolic) -> Symbolic:
    out: set[Monomial] = set()
    for value in values:
        for monomial in value:
            if monomial in out:
                out.remove(monomial)
            else:
                out.add(monomial)
    return frozenset(out)


def symbolic_mul(left: Symbolic, right: Symbolic) -> Symbolic:
    out: set[Monomial] = set()
    for a in left:
        for b in right:
            monomial = tuple(x + y for x, y in zip(a, b))
            if monomial in out:
                out.remove(monomial)
            else:
                out.add(monomial)
    return frozenset(out)


def symbolic_square(value: Symbolic) -> Symbolic:
    return frozenset(tuple(2 * exponent for exponent in monomial)
                     for monomial in value)


def symbolic_product(values: Iterable[Symbolic]) -> Symbolic:
    out = ONE
    for value in values:
        out = symbolic_mul(out, value)
    return out


def rpoly(*coefficients: Symbolic) -> RPoly:
    out = list(coefficients)
    while out and not out[-1]:
        out.pop()
    return tuple(out)


def rpoly_add(left: RPoly, right: RPoly) -> RPoly:
    return rpoly(*(
        symbolic_add(
            left[index] if index < len(left) else ZERO,
            right[index] if index < len(right) else ZERO,
        )
        for index in range(max(len(left), len(right)))
    ))


def rpoly_mul(left: RPoly, right: RPoly) -> RPoly:
    if not left or not right:
        return ()
    out = [ZERO] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            out[i + j] = symbolic_add(out[i + j], symbolic_mul(a, b))
    return rpoly(*out)


def symbolic_resultant() -> RPoly:
    e0, e1, a1, b1, c0, c1 = (VARS[name] for name in NAMES[:6])
    y0, y1, h0, h1, z0, z1 = (VARS[name] for name in NAMES[6:])
    d = symbolic_add(e0, y0)
    k = symbolic_add(e1, y1)
    q00 = symbolic_add(symbolic_square(d), symbolic_square(k), h0, c0)
    q10 = symbolic_add(c1, symbolic_square(k), h1)
    r00 = symbolic_add(symbolic_square(e0), symbolic_square(e1), z0, c0)
    r10 = symbolic_add(c1, symbolic_square(e1), z1)
    u2 = symbolic_add(y0, symbolic_mul(a1, y1))
    u1 = symbolic_add(q00, r00, symbolic_mul(b1, y1))
    u0 = symbolic_add(
        symbolic_mul(e0, q00), symbolic_mul(e1, q10),
        symbolic_mul(d, r00), symbolic_mul(k, r10),
    )
    v2 = symbolic_add(symbolic_mul(a1, symbolic_add(y0, y1)), y1)
    v1 = symbolic_add(q10, r10, symbolic_mul(b1, symbolic_add(y0, y1)))
    v0 = symbolic_add(
        symbolic_mul(e0, q10), symbolic_mul(e1, q00),
        symbolic_mul(e1, q10), symbolic_mul(d, r10),
        symbolic_mul(k, r00), symbolic_mul(k, r10),
    )

    a2 = rpoly(d, ONE)
    a1_t = rpoly(q00, ZERO, ONE)
    a0 = rpoly(u0, u1, u2)
    b2 = rpoly(k)
    b1_t = rpoly(q10, b1, a1)
    b0 = rpoly(v0, v1, v2)
    zero: RPoly = ()
    matrix = (
        (a2, a1_t, a0, zero), (zero, a2, a1_t, a0),
        (b2, b1_t, b0, zero), (zero, b2, b1_t, b0),
    )
    result: RPoly = ()
    for permutation in itertools.permutations(range(4)):
        term = rpoly(ONE)
        for i, j in enumerate(permutation):
            term = rpoly_mul(term, matrix[i][j])
        result = rpoly_add(result, term)
    return result


def specialize_zero(poly: Symbolic, variable_name: str) -> Symbolic:
    index = NAMES.index(variable_name)
    return frozenset(monomial for monomial in poly if monomial[index] == 0)


def poly_derivative(poly: tuple[int, ...]) -> tuple[int, ...]:
    return trim(tuple(poly[index] if index % 2 else 0
                      for index in range(1, len(poly))))


def poly_gcd(field, left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    left, right = trim(left), trim(right)
    while right:
        _, remainder = poly_divmod(field, left, right)
        left, right = right, remainder
    return left


def tau_exponents(context, values: tuple[int, ...]) -> list[int | None]:
    out = []
    for value in values:
        if value == 0:
            out.append(None)
            continue
        exponent = next(
            exponent for exponent in range(7)
            if context.ambient.power(context.tau, exponent) == value
        )
        out.append(exponent)
    return out


def specialization_resultant(
    context, seed_height: int, target: tuple[int, int, int, int]
) -> tuple[int, ...]:
    return sylvester_resultant(
        context.ambient,
        *coverage_equations(
            context.ambient, context.coordinates,
            context.eta0, context.eta1,
            context.a1, context.b1, context.c0, context.c1,
            seed_height, *target,
        ),
    )


def main() -> None:
    result = symbolic_resultant()
    assert len(result) == 8
    term_counts = [len(coefficient) for coefficient in result]
    assert term_counts == [472, 268, 276, 92, 94, 31, 16, 3]

    a1, y1, h0, h1, z0, z1 = (
        VARS[name] for name in ("a1", "y1", "h0", "h1", "z0", "z1")
    )
    expected_degree7 = symbolic_product((
        a1,
        y1,
        symbolic_add(symbolic_square(a1), a1, ONE),
    ))
    assert result[7] == expected_degree7

    degree6_on_y1_zero = specialize_zero(result[6], "y1")
    expected_degree6 = symbolic_mul(
        a1,
        symbolic_add(symbolic_mul(a1, symbolic_add(h0, z0)), h1, z1),
    )
    assert degree6_on_y1_zero == expected_degree6

    context = build_context(1)
    field = context.ambient
    target7 = (
        1, field.power(context.tau, 5), field.power(context.tau, 2), 1
    )
    degree7_rows = []
    for seed_name, seed_height in (("A", context.alpha), ("B", context.beta)):
        specialized = specialization_resultant(context, seed_height, target7)
        gcd = poly_gcd(field, specialized, poly_derivative(specialized))
        assert len(specialized) == 8 and len(gcd) == 1
        degree7_rows.append({
            "seed": seed_name,
            "degree": len(specialized) - 1,
            "squarefree": True,
            "coefficients_tau_exponents": tau_exponents(context, specialized),
        })

    target6 = (0, 0, 0, 1)
    specialized6 = specialization_resultant(context, context.alpha, target6)
    gcd6 = poly_gcd(field, specialized6, poly_derivative(specialized6))
    assert len(specialized6) == 7 and len(gcd6) == 1

    print(json.dumps({
        "coefficient_ring":
            "GF(2)[e0,e1,a1,b1,c0,c1,y0,y1,h0,h1,z0,z1]",
        "resultant_variable": "repair parameter r",
        "coefficient_term_counts_degree_0_through_7": term_counts,
        "degree_7_coefficient": "a1*y1*(a1^2+a1+1)",
        "degree_6_coefficient_when_y1_zero":
            "a1*(a1*(h0+z0)+h1+z1)",
        "seed_color_degree_6_difference_when_y1_zero": "a1*tau",
        "odd_extension_consequence":
            "a1!=0 and GF(8^m), m odd, has no GF(4), so y1!=0 gives "
            "exact degree 7; when y1=0 at least one seed color has degree 6",
        "squarefree_degree_7_specializations": degree7_rows,
        "squarefree_degree_6_specialization": {
            "orbit": 1,
            "seed": "A",
            "target_tau_exponents": [None, None, None, 0],
            "degree": len(specialized6) - 1,
            "coefficients_tau_exponents": tau_exponents(context, specialized6),
            "squarefree": True,
        },
        "generic_separability": {
            "degree_7_stratum": True,
            "degree_6_stratum": True,
            "reason": "each symbolic discriminant has a squarefree GF(8) specialization",
        },
        "conclusion":
            "the frozen empty-target certificates do not come from a "
            "universal resultant degree collapse; arithmetic factorization "
            "and monodromy are the next coefficient-space gate",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
