#!/usr/bin/env python3
"""Exhibit the first arithmetic Frobenius class of the C210 collision curve.

The shared-``(a,b)`` two-repair locus has one cross-repair trace condition
in each orientation and one seed--cross-repair resultant ``R(u,t)``.  This
checker records a GF(8) specialization for which

* both oriented trace conditions coincide and equal one;
* the beta-seed resultant has no GF(8)-rational point; and
* the specialized polynomial is the one independently factored by
  ``analyze_c210_collision_curve_frobenius.sing``.

Thus a base-field census really can miss the collision curve.  The companion
Singular certificate proves that this particular curve is nevertheless
absolutely irreducible, so the exception cannot persist up the scalar tower.
"""

from __future__ import annotations

import json

from analyze_c210_residue_hypergraph import build_context
from analyze_c210_seed_cross_repair_curve import (
    BinaryRing,
    NAMES,
    expected_quadratics,
    resultant,
)


# Entries are exponents of tau, in the order used below.  This is the first
# deterministic sample found with no beta-seed collision over GF(8).
EXPONENTS = {
    "e": 2,
    "delta": 1,
    "a": 6,
    "b": 2,
    "c0": 5,
    "c1": 5,
    "k0": 6,
    "k1": 3,
}


def main() -> None:
    context = build_context(1)
    field = context.ambient
    base = context.base_values
    tau = context.tau
    add, mul = field.add, field.mul

    def total(*values: int) -> int:
        out = 0
        for value in values:
            out = add(out, value)
        return out

    def square(value: int) -> int:
        return mul(value, value)

    def trace(value: int) -> int:
        out = 0
        conjugate = value
        for _ in range(3):
            out = add(out, conjugate)
            conjugate = square(conjugate)
        assert out in (0, 1)
        return out

    values = {name: field.power(tau, exponent) for name, exponent in EXPONENTS.items()}
    e = values["e"]
    delta = values["delta"]
    e_prime = add(e, delta)
    assert e != 0 and e_prime != 0 and e != e_prime
    a, b = values["a"], values["b"]
    c0, c1, k0, k1 = (values[name] for name in ("c0", "c1", "k0", "k1"))

    norm = total(square(a), a, 1)
    t0 = total(k0, mul(delta, b), square(delta))
    t1 = total(k1, mul(delta, b), square(delta))
    pair_sum = field.div(total(t1, mul(a, t0)), mul(delta, norm))
    pair_product = total(t0, mul(mul(a, delta), pair_sum))
    oriented_trace = trace(field.div(pair_product, square(pair_sum)))
    assert pair_sum != 0 and oriented_trace == 1

    # Reversing the layers changes e to e+delta, but t0, t1, pair_sum, and
    # pair_product do not involve e at all on the shared-(a,b) locus.
    reverse_t0 = total(k0, mul(delta, b), square(delta))
    reverse_t1 = total(k1, mul(delta, b), square(delta))
    reverse_pair_sum = field.div(
        total(reverse_t1, mul(a, reverse_t0)), mul(delta, norm)
    )
    reverse_pair_product = total(
        reverse_t0, mul(mul(a, delta), reverse_pair_sum)
    )
    reverse_trace = trace(
        field.div(reverse_pair_product, square(reverse_pair_sum))
    )
    assert (reverse_pair_sum, reverse_pair_product, reverse_trace) == (
        pair_sum,
        pair_product,
        oriented_trace,
    )

    ring = BinaryRing()
    coefficients = expected_quadratics(ring)
    universal = resultant(ring, coefficients)
    A, B, _C, D, E, _F = coefficients
    universal_h = ring.add(ring.mul(D, B), ring.mul(A, E))
    u_index, t_index = NAMES.index("u"), NAMES.index("t")
    parameters = {
        **values,
        "g0": 1,
        "g1": tau,  # beta seed
    }
    def specialize(polynomial: set[tuple[int, ...]]) -> dict[tuple[int, int], int]:
        answer: dict[tuple[int, int], int] = {}
        for monomial in polynomial:
            coefficient = 1
            for index, name in enumerate(NAMES):
                if name in ("u", "t"):
                    continue
                exponent = monomial[index]
                if exponent:
                    coefficient = mul(
                        coefficient,
                        field.power(parameters.get(name, 0), exponent),
                    )
            if coefficient:
                degree = (monomial[u_index], monomial[t_index])
                answer[degree] = add(answer.get(degree, 0), coefficient)
        return {degree: value for degree, value in answer.items() if value}

    specialized = specialize(universal)
    specialized_h = specialize(universal_h)
    h_total_degree = max(sum(degree) for degree in specialized_h)
    assert specialized_h and h_total_degree < 8

    def tau_exponent(value: int) -> int:
        assert value != 0
        return next(exponent for exponent in range(7) if field.power(tau, exponent) == value)

    # Normalize by the leading u^4*t^4 coefficient.  These are exactly the
    # coefficients in the companion Singular certificate.
    scale = field.inv(specialized[(4, 4)])
    normalized = {
        degree: tau_exponent(mul(scale, coefficient))
        for degree, coefficient in specialized.items()
    }
    expected_normalized = {
        (6, 0): 0, (5, 2): 5, (5, 1): 1, (5, 0): 4,
        (4, 4): 0, (4, 2): 4, (4, 1): 6, (4, 0): 3,
        (3, 2): 1, (3, 1): 4, (3, 0): 0, (2, 4): 2,
        (2, 2): 2, (2, 1): 0, (2, 0): 1, (1, 2): 2,
        (1, 1): 5, (1, 0): 1, (0, 4): 4, (0, 2): 1,
        (0, 1): 3, (0, 0): 4,
    }
    assert normalized == expected_normalized

    rational_points: list[tuple[int, int]] = []
    for u in base:
        for t in base:
            value = 0
            for (u_degree, t_degree), coefficient in specialized.items():
                value = add(
                    value,
                    mul(
                        coefficient,
                        mul(field.power(u, u_degree), field.power(t, t_degree)),
                    ),
                )
            if value == 0:
                rational_points.append((u, t))
    assert rational_points == []

    print(json.dumps({
        "field": "GF(8)",
        "specialization_tau_exponents": EXPONENTS,
        "oriented_cross_repair_traces": [oriented_trace, reverse_trace],
        "orientation_collapse":
            "on shared (a,b), reversing the layers leaves P0 and q0 unchanged",
        "seed": "beta=1+tau*omega",
        "resultant_term_count": len(specialized),
        "normalized_resultant_coefficients": {
            f"u^{u_degree}*t^{t_degree}": exponent
            for (u_degree, t_degree), exponent in sorted(normalized.items())
        },
        "gf8_rational_points": len(rational_points),
        "H_nonzero_total_degree": h_total_degree,
        "companion_certificate":
            "analyze_c210_collision_curve_frobenius.sing",
        "conclusion":
            "both trace-one gates can hold while the collision curve has no base-field point",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
