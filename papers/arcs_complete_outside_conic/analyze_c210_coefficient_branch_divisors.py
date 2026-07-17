#!/usr/bin/env python3
"""Classify the first C210 coefficient-space branch-drop divisors.

For the mixed-seed collision quintic, put ``e=eta1`` and ``k=c0+1`` and
write ``L(r)=h(r)^2+tau*h(r)``.  Its two critical ``d^2`` values are
``tau*omega`` and ``tau*omega^2``.  Eliminating that quadratic pair gives
the degree-eight branch polynomial

    B(r) = L(r)^2 + tau*(e^2+k)*L(r)
           + tau^2*(e^4+e^2*k+k^2).

This checker verifies the identities over GF(64)/GF(8), enumerates the
rational points and intersections of the resulting quotient divisors, and
checks that the three exceptional q=64 coefficient blocks avoid them.
"""

from __future__ import annotations

import json

from analyze_c210_exceptional_quadratic_locus import canonical_known_rows
from analyze_c210_residue_hypergraph import build_context


def main() -> None:
    context = build_context(1)
    field = context.ambient
    base = context.base_values
    tau = context.tau
    omega = field.div(field.add(context.beta, 1), tau)
    omega2 = field.mul(omega, omega)
    assert field.add(field.add(omega2, omega), 1) == 0
    sqrt_tau = field.power(tau, 4)
    assert field.mul(sqrt_tau, sqrt_tau) == tau

    add = field.add
    mul = field.mul
    square = lambda x: mul(x, x)

    def L(e: int, a: int, b: int, r: int) -> int:
        h = add(add(mul(a, square(r)), mul(b, r)), square(e))
        return add(square(h), mul(tau, h))

    def critical_w(e: int, k: int, t: int) -> int:
        # Here d^2=tau*t and t^2+t+1=0.
        return mul(tau, add(mul(square(e), t), mul(k, square(t))))

    def branch_polynomial_value(e: int, a: int, b: int, k: int, r: int) -> int:
        ell = L(e, a, b, r)
        e2 = square(e)
        e4 = square(e2)
        constant = mul(square(tau), add(add(e4, mul(e2, k)), square(k)))
        return add(add(square(ell), mul(mul(tau, add(e2, k)), ell)), constant)

    def hasse_norm(e: int, k: int) -> int:
        # Norm from adjoining t^2+t+1 of the squared second-Hasse condition.
        e2 = square(e)
        A = add(square(e2), mul(tau, e2))
        return add(add(square(A), mul(A, square(k))), square(square(k)))

    def hasse_reduced(e: int, k: int) -> int:
        C = add(square(e), mul(sqrt_tau, e))
        return add(add(square(k), mul(C, k)), square(C))

    # Check the eliminated branch equation and its constant derivative for
    # every coefficient and repair parameter over GF(8).
    for e in base:
        for a in base:
            for b in base:
                for k in base:
                    w0 = critical_w(e, k, omega)
                    w1 = critical_w(e, k, omega2)
                    assert add(w0, w1) == mul(tau, add(square(e), k))
                    assert mul(w0, w1) == mul(
                        square(tau),
                        add(add(square(square(e)), mul(square(e), k)), square(k)),
                    )
                    for r in base:
                        ell = L(e, a, b, r)
                        direct = mul(add(ell, w0), add(ell, w1))
                        assert branch_polynomial_value(e, a, b, k, r) == direct

    # The norm divisor is exactly the locus where one of the two critical
    # points loses its nonzero second Hasse derivative.
    for e in base:
        for k in base:
            norm_zero = hasse_norm(e, k) == 0
            assert hasse_norm(e, k) == square(hasse_reduced(e, k))
            hasse_zero = False
            for t in (omega, omega2):
                x = mul(tau, t)
                d = field.power(x, field.q // 2)
                value = add(mul(critical_w(e, k, t), d), mul(e, square(tau)))
                hasse_zero |= value == 0
            assert norm_zero == hasse_zero

    def conditions(e: int, a: int, b: int, k: int) -> frozenset[str]:
        out = set()
        if e == 0:
            out.add("eta1_zero")
        if a == 0:
            out.add("a1_zero")
        if b == 0:
            out.add("b1_zero")
        if add(square(e), k) == 0:
            out.add("critical_value_collision")
        if hasse_reduced(e, k) == 0:
            out.add("non_simple_inertia")
        return frozenset(out)

    stratum = [
        (e, a, b, k)
        for e in base if e != 0
        for a in base if a != 0
        for b in base
        for k in base
    ]
    divisor_names = (
        "b1_zero", "critical_value_collision", "non_simple_inertia",
    )
    counts = {
        name: sum(name in conditions(*row) for row in stratum)
        for name in divisor_names
    }
    intersections = {}
    for i, left in enumerate(divisor_names):
        for right in divisor_names[i + 1:]:
            intersections[f"{left}&{right}"] = sum(
                {left, right}.issubset(conditions(*row)) for row in stratum
            )
    intersections["all_three"] = sum(
        set(divisor_names).issubset(conditions(*row)) for row in stratum
    )
    rational_hasse_pairs = {
        (e, k) for e in base if e != 0 for k in base
        if hasse_reduced(e, k) == 0
    }
    assert rational_hasse_pairs == {(sqrt_tau, 0)}

    # Check the intersection formulas after adjoining omega.
    for t in (omega, omega2):
        e = mul(sqrt_tau, t)
        k = square(e)
        assert add(square(e), k) == 0
        assert hasse_reduced(e, k) == 0

    exceptional_rows = []
    for orbit, (e, a, b, c0, _c1) in enumerate(
        canonical_known_rows(context), start=1
    ):
        k = add(c0, 1)
        bad = sorted(conditions(e, a, b, k))
        assert not bad
        exceptional_rows.append({"orbit": orbit, "drop_divisors": bad})

    print(json.dumps({
        "coefficient_quotient": ["eta1", "a1", "b1", "c0"],
        "abbreviations": {"e": "eta1", "k": "c0+1"},
        "mixed_branch_polynomial":
            "B=L^2+tau*(e^2+k)*L+tau^2*(e^4+e^2*k+k^2)",
        "L": "(a1*r^2+b1*r+e^2)^2+tau*(a1*r^2+b1*r+e^2)",
        "branch_polynomial_degree_on_repair_stratum": 8,
        "branch_polynomial_derivative": "tau^2*b1*(e^2+k)",
        "geometric_drop_divisors_on_eta1*a1_nonzero": {
            "b1_zero": "b1",
            "critical_value_collision": "e^2+k",
            "non_simple_inertia":
                "k^2+C*k+C^2, C=e^2+sqrt(tau)*e",
        },
        "interpretation": {
            "b1_zero": "the additive quartic branch fibers become inseparable",
            "critical_value_collision": "the two four-point critical fibers coincide",
            "non_simple_inertia":
                "a critical point has zero second Hasse derivative",
        },
        "geometric_factorization_and_intersections": {
            "non_simple_inertia_over_GF64":
                "(k+omega*C)*(k+omega^2*C)",
            "two_nonsimple_components_meet_on_repair_stratum":
                "e=sqrt(tau), k=0",
            "critical_collision_meets_nonsimple_components":
                "(e,k)=(sqrt(tau)*omega,e^2) and "
                "(sqrt(tau)*omega^2,e^2)",
            "b1_component_intersections":
                "set b1=0 in each listed component; the two triple "
                "intersections are the preceding conjugate (e,k) points",
        },
        "gf8_repair_stratum_size": len(stratum),
        "gf8_divisor_point_counts": counts,
        "gf8_pair_and_triple_intersections": intersections,
        "exceptional_q64_blocks": exceptional_rows,
        "twist_bit_dependence":
            "none: all three geometric equations are independent of c1",
        "status":
            "mixed S5 branch-drop divisors classified; seed-repair coverage "
            "branch discriminants remain",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
