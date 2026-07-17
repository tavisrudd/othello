#!/usr/bin/env python3
"""Derive the external C210 branch-collision elimination system.

Fix a point of the universal ramification section and compare it with a second
seed--repair source above the same target.  Write

    u=r'+r,  v=d'+d.

Then ``D'=D+(v,0)`` and ``Y'=lambda*D+(u+v,0)``.  The two target-height
equations are quadratics ``C0=C1=0`` in ``v``; the second-source ramification
equation ``J'=0`` has degree five in ``v``.  All three are independent of the
repair constant ``k``, the seed colour, and the original repair root ``r``.

The common known source is ``u=v=0``.  The Sylvester resultant of ``C0,C1``
has exactly the factor ``u^2``; after saturation the external collision
polynomial has 111 terms and degree five in ``u``.  On the generic linear
subresultant chart, substituting the unique common ``v`` into ``J'`` gives the
remaining exact external-ramification equation.

This checker constructs every polynomial in the sparse GF(8)-coefficient ring
and records stable digests.  The next gate is the final elimination in ``u``
and the section parameters.
"""

from __future__ import annotations

import hashlib
import itertools
import json

from analyze_c210_coverage_branch_discriminants import NAMES, Ring


def main() -> None:
    ring = Ring()
    add = ring.add
    mul = ring.mul
    square = ring.square
    variables = ring.variables
    e, a, b, s, lam, d, u, v = (variables[name] for name in NAMES)

    def pair_add(left, right):
        return add(left[0], right[0]), add(left[1], right[1])

    def pair_mul(left, right):
        cross = mul(left[1], right[1])
        return (
            add(mul(left[0], right[0]), cross),
            add(mul(left[0], right[1]), mul(left[1], right[0]), cross),
        )

    def pair_scale(scalar, value):
        return mul(scalar, value[0]), mul(scalar, value[1])

    def determinant(left, right):
        return add(mul(left[0], right[1]), mul(left[1], right[0]))

    D = (d, e)
    E = (e, add(d, e))
    W = pair_scale(s, E)
    Y = pair_scale(lam, D)

    D_prime = (add(d, v), e)
    E_prime = (e, add(d, v, e))
    Y_prime = (add(mul(lam, d), u, v), mul(lam, e))
    W_prime = pair_add(
        W,
        (square(v), add(mul(a, square(u)), mul(b, u))),
    )

    # Height above the seed is Y^2+Y*(W/D).  On the section W/D=s*omega.
    height = pair_add(pair_mul(Y, Y), pair_mul(Y, (ring.zero, s)))
    collision = pair_add(
        pair_mul(D_prime, pair_add(pair_mul(Y_prime, Y_prime), height)),
        pair_mul(Y_prime, W_prime),
    )
    R_prime = pair_add(W_prime, pair_scale(b, E_prime))
    T_prime = pair_mul(pair_add(D_prime, Y_prime), W_prime)
    ramification = determinant(pair_mul(Y_prime, R_prime), T_prime)

    v_index = NAMES.index("h1")
    u_index = NAMES.index("h0")

    def coefficients(poly):
        degree = max((monomial[v_index] for monomial in poly), default=-1)
        out = []
        for exponent in range(degree + 1):
            coefficient = {}
            for monomial, scalar in poly.items():
                if monomial[v_index] != exponent:
                    continue
                reduced = list(monomial)
                reduced[v_index] = 0
                coefficient[tuple(reduced)] = scalar
            out.append(coefficient)
        return out

    C0 = coefficients(collision[0])
    C1 = coefficients(collision[1])
    JR = coefficients(ramification)
    assert len(C0) == len(C1) == 3
    assert len(JR) == 6

    zero = ring.zero
    matrix = (
        (C0[0], C0[1], C0[2], zero),
        (zero, C0[0], C0[1], C0[2]),
        (C1[0], C1[1], C1[2], zero),
        (zero, C1[0], C1[1], C1[2]),
    )
    resultant = ring.zero
    for permutation in itertools.permutations(range(4)):
        term = ring.one
        for row, column in enumerate(permutation):
            term = mul(term, matrix[row][column])
        resultant = add(resultant, term)

    minimum_u = min(monomial[u_index] for monomial in resultant)
    assert minimum_u == 2
    saturated_resultant = {}
    for monomial, scalar in resultant.items():
        reduced = list(monomial)
        reduced[u_index] -= minimum_u
        saturated_resultant[tuple(reduced)] = scalar
    assert len(saturated_resultant) == 111

    # The linear subresultant is L1*v+L0.  Verify the standard quadratic
    # identity A2*Res=A2*L0^2+A1*L0*L1+A0*L1^2 exactly.
    L1 = add(mul(C0[2], C1[1]), mul(C1[2], C0[1]))
    L0 = add(mul(C0[2], C1[0]), mul(C1[2], C0[0]))
    assert min(monomial[u_index] for monomial in L0) == 1
    norm_D = add(square(d), mul(d, e), square(e))
    L1_at_known_source = {
        monomial: scalar
        for monomial, scalar in L1.items()
        if monomial[u_index] == 0
    }
    expected_L1_at_known_source = mul(
        mul(s, square(add(lam, ring.one))), norm_D
    )
    assert L1_at_known_source == expected_L1_at_known_source
    quadratic_identity = add(
        mul(C0[2], resultant),
        mul(C0[2], square(L0)),
        mul(mul(C0[1], L0), L1),
        mul(C0[0], square(L1)),
    )
    assert not quadratic_identity

    def power(value, exponent):
        out = ring.one
        while exponent:
            if exponent & 1:
                out = mul(out, value)
            value = square(value)
            exponent >>= 1
        return out

    # On L1!=0 the common collision root is v=L0/L1.  Clear L1^5 from J'.
    external_ramification = ring.zero
    degree = len(JR) - 1
    for exponent, coefficient in enumerate(JR):
        external_ramification = add(
            external_ramification,
            mul(
                mul(coefficient, power(L0, exponent)),
                power(L1, degree - exponent),
            ),
        )
    assert len(external_ramification) == 8866
    assert min(monomial[u_index] for monomial in external_ramification) == 2

    def coefficient_after_u_saturation(poly, valuation):
        out = {}
        for monomial, scalar in poly.items():
            if monomial[u_index] != valuation:
                continue
            reduced = list(monomial)
            reduced[u_index] = 0
            out[tuple(reduced)] = scalar
        return out

    collision_at_known_source = coefficient_after_u_saturation(resultant, 2)
    expected_collision_at_known_source = mul(
        mul(mul(lam, square(add(lam, ring.one))), norm_D),
        add(
            mul(square(s), norm_D),
            mul(mul(mul(s, e), b), add(s, b)),
            mul(mul(lam, square(b)), norm_D),
        ),
    )
    assert collision_at_known_source == expected_collision_at_known_source
    ramification_at_known_source = coefficient_after_u_saturation(
        external_ramification, 2
    )

    def degree_vector(poly):
        return {
            name: max((monomial[index] for monomial in poly), default=-1)
            for index, name in enumerate(
                ("e", "a", "b", "s", "lambda", "d", "u", "v")
            )
        }

    def digest(poly):
        rows = sorted((list(monomial), scalar) for monomial, scalar in poly.items())
        return hashlib.sha256(
            json.dumps(rows, separators=(",", ":")).encode()
        ).hexdigest()

    print(json.dumps({
        "difference_variables": {"u": "r'+r", "v": "d'+d"},
        "second_source": {
            "D_prime": "D+(v,0)",
            "Y_prime": "lambda*D+(u+v,0)",
            "W_prime": "W+(v^2,a*u^2+b*u)",
        },
        "independence": ["k", "seed colour", "original repair root r"],
        "collision_equations": {
            "term_counts": [len(collision[0]), len(collision[1])],
            "degree_vectors": [degree_vector(collision[0]), degree_vector(collision[1])],
            "degrees_in_v": [2, 2],
        },
        "second_ramification_equation": {
            "term_count": len(ramification),
            "degree_vector": degree_vector(ramification),
            "degree_in_v": 5,
        },
        "collision_resultant": {
            "known_source_factor": "u^2",
            "saturated_term_count": len(saturated_resultant),
            "saturated_degree_vector": degree_vector(saturated_resultant),
            "saturated_sha256": digest(saturated_resultant),
        },
        "generic_linear_subresultant": {
            "L0_term_count": len(L0),
            "L1_term_count": len(L1),
            "common_root": "v=L0/L1",
            "L0_known_source_factor": "u",
            "L1_at_u_zero": "s*(lambda+1)^2*Norm(D)",
        },
        "known_source_boundary": {
            "saturated_collision_at_u_zero":
                "lambda*(lambda+1)^2*Norm(D)*(s^2*Norm(D)+s*e*b*(s+b)+lambda*b^2*Norm(D))",
            "saturated_external_ramification_term_count_at_u_zero":
                len(ramification_at_known_source),
            "saturated_external_ramification_sha256_at_u_zero":
                digest(ramification_at_known_source),
            "consequence":
                "L1=0 cannot meet the known source on the selected open set; its boundary chart is purely external",
        },
        "external_ramification_after_substitution": {
            "term_count_before_u_saturation": len(external_ramification),
            "known_source_u_valuation": 2,
            "degree_vector": degree_vector(external_ramification),
            "sha256": digest(external_ramification),
        },
        "remaining_gate":
            "saturate the external ramification equation by u^2 and eliminate u against the 111-term collision resultant, including L1=0 boundary charts",
        "status":
            "external branch collision reduced to an exact low-variable elimination system",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
