#!/usr/bin/env python3
"""Intersect the constant-height two-layer arc conditions with the even-factor gate.

The fortieth coordinate gate normalizes the coefficient-varying ``a=b=0`` C210
collision locus and finds ``270`` of ``5376`` exact ``GF(8)`` tuples whose
seed--cross-repair collision polynomial has no odd-degree factor for either
seed color.  Factor parity alone therefore does not close the locus.

This checker imposes the missing arc-legality condition and shows the joint
gate is empty.  It works on two fronts:

1.  Normalized ``p=1`` slice (exactly the census of the fortieth gate).  Each of
    the ``5376`` tuples reconstructs to a concrete ``GF(8)`` constant-height
    two-layer configuration -- two seed layers of colors ``alpha,beta`` plus a
    left repair coset at offset ``(h0,h1)`` and the derived right coset.  None
    of the ``5376`` normalized ``p=1`` configurations is arc-legal, so in
    particular none of the ``270`` even-factor survivors is.

2.  General ``p`` (the whole trace-one constant-height space).  The census
    scaling ``(e,delta,p,h0,h1)->(l*e,l*delta,l*p,l^2*h0,l^2*h1)`` is a symmetry
    of the collision polynomial but *not* of the plane geometry: every arc-legal
    trace-one arc has ``p in {14,22,24}``, never ``p=1``.  Enumerating the entire
    constant-height two-layer arc space directly gives ``22`` arcs, ``12`` of them
    trace-one, and *every one of those twelve has an odd-degree collision factor
    for at least one seed color*.  Hence no configuration is simultaneously
    arc-legal and even-factor-surviving.

The intersection of the arc-condition locus with the two-seed even-factor
condition is therefore empty on ``a=b=0``.  Only the lower factorization strata
in ``a=0,b!=0`` and the factorization divisors on ``a!=0`` remain.
"""

from __future__ import annotations

import itertools
import json
from collections import Counter, defaultdict

from analyze_c210_exceptional_quadratic_locus import line_key, repair_points
from analyze_c210_persistent_singletons import poly_add, poly_divmod, poly_mul
from analyze_c210_residue_hypergraph import build_context
from analyze_c210_seed_cross_repair_curve import (
    BinaryRing,
    expected_quadratics,
    resultant,
)
from analyze_c210_collision_curve_constant_height import VARIABLES, pullback


def main() -> None:
    ring0 = BinaryRing()
    ring, polynomial = pullback(resultant(ring0, expected_quadratics(ring0)))
    z_index = VARIABLES.index("z")

    context = build_context(1)
    field = context.ambient
    base = context.base_values
    add, mul = field.add, field.mul
    alpha0, alpha1 = context.coordinates(context.alpha)
    tau = context.coordinates(field.add(context.alpha, context.beta))[1]

    def specialize(values: dict[str, int]) -> tuple[int, ...]:
        coefficients: dict[int, int] = {}
        for monomial in polynomial:
            value = 1
            for index, name in enumerate(VARIABLES):
                if name == "z":
                    continue
                value = mul(value, field.power(values.get(name, 0), monomial[index]))
            degree = monomial[z_index]
            coefficients[degree] = add(coefficients.get(degree, 0), value)
        result = tuple(coefficients.get(i, 0) for i in range(7))
        while result and result[-1] == 0:
            result = result[:-1]
        return result

    def has_odd_degree_factor(poly: tuple[int, ...]) -> bool:
        # gcd(poly, x^(2^9)-x) is nontrivial exactly when poly has a factor of
        # odd degree dividing 9 (degrees 1, 3, 9 over GF(8)); the seed collision
        # polynomial has degree at most six, so this detects every odd factor.
        residue = (0, 1)
        for _ in range(9):
            _, residue = poly_divmod(field, poly_mul(field, residue, residue), poly)
        probe = poly_add(field, residue, (0, 1))
        left, right = poly, probe
        while right:
            _, remainder = poly_divmod(field, left, right)
            left, right = right, remainder
        return len(left) > 1

    def seed_collision(e, delta, p, w, h0, h1) -> tuple[bool, bool]:
        return tuple(
            has_odd_degree_factor(specialize({
                "e": e, "delta": delta, "p": p, "w": w, "h0": h0, "h1": shifted,
            }))
            for shifted in (h1, add(h1, tau))
        )

    seeds = tuple(
        (parameter, height)
        for parameter in base
        for height in (context.alpha, context.beta)
    )

    def is_arc(points) -> bool:
        seen: set = set()
        for left, right in itertools.combinations(points, 2):
            key = line_key(context, left, right)
            if key in seen:
                return False
            seen.add(key)
        return True

    def config_arc(e, delta, p, w, h0, h1) -> bool:
        theta = add(add(mul(w, w), w), 1)
        k0 = add(mul(mul(p, p), theta), mul(delta, delta))
        k1 = add(mul(delta, p), mul(delta, delta))
        c0_left, c1_left = add(h0, alpha0), add(h1, alpha1)
        return is_arc(
            seeds
            + repair_points(context, e, 0, 0, c0_left, c1_left)
            + repair_points(
                context, add(e, delta), 0, 0, add(k0, c0_left), add(k1, c1_left)
            )
        )

    # ---- Front 1: normalized p=1 census (the fortieth-gate 5376 tuples) ------
    w_representatives = tuple(x for x in base if x < add(x, 1))
    h1_representatives = tuple(x for x in base if x < add(x, tau))
    assert len(w_representatives) == len(h1_representatives) == 4

    census = Counter()
    survivors_p1 = 0
    arc_legal_p1 = 0
    survivor_arc_legal_p1 = 0
    for e, delta, w, h0, h1 in itertools.product(
        base[1:], base[1:], w_representatives, base, h1_representatives
    ):
        if add(e, delta) == 0:
            continue
        collides = seed_collision(e, delta, 1, w, h0, h1)
        status = (
            "both" if all(collides)
            else "exactly_one" if any(collides)
            else "neither"
        )
        census[status] += 1
        legal = config_arc(e, delta, 1, w, h0, h1)
        if legal:
            arc_legal_p1 += 1
        if status == "neither":
            survivors_p1 += 1
            if legal:
                survivor_arc_legal_p1 += 1
    assert sum(census.values()) == 5376
    assert census["neither"] == 270 and survivors_p1 == 270
    assert arc_legal_p1 == 0
    assert survivor_arc_legal_p1 == 0

    # ---- Front 2: full constant-height two-layer arc space, general p --------
    legal_single: dict[int, list[tuple[int, int]]] = defaultdict(list)
    for e in base[1:]:
        for c0, c1 in itertools.product(base, repeat=2):
            if c0 == c1 == 0:
                continue
            if is_arc(seeds + repair_points(context, e, 0, 0, c0, c1)):
                legal_single[e].append((c0, c1))

    def trace(value: int) -> int:
        out, conjugate = 0, value
        for _ in range(3):
            out = add(out, conjugate)
            conjugate = mul(conjugate, conjugate)
        assert out in (0, 1)
        return out

    two_layer_arcs = 0
    trace_one_arcs = 0
    trace_one_p_values = Counter()
    trace_one_collision_free = 0
    for e, delta in itertools.product(base[1:], repeat=2):
        e_prime = add(e, delta)
        if e_prime == 0:
            continue
        for left in legal_single[e]:
            for right in legal_single[e_prime]:
                if not is_arc(
                    seeds
                    + repair_points(context, e, 0, 0, *left)
                    + repair_points(context, e_prime, 0, 0, *right)
                ):
                    continue
                two_layer_arcs += 1
                k0 = add(left[0], right[0])
                k1 = add(left[1], right[1])
                p = field.div(add(k1, mul(delta, delta)), delta)
                if p == 0:
                    continue
                theta = field.div(add(k0, mul(delta, delta)), mul(p, p))
                if trace(theta) != 1:
                    continue
                trace_one_arcs += 1
                trace_one_p_values[p] += 1
                w = next(
                    x for x in base if add(add(mul(x, x), x), 1) == theta
                )
                h0, h1 = add(left[0], alpha0), add(left[1], alpha1)
                assert config_arc(e, delta, p, w, h0, h1)
                if not any(seed_collision(e, delta, p, w, h0, h1)):
                    trace_one_collision_free += 1

    assert sum(len(rows) for rows in legal_single.values()) == 35
    assert two_layer_arcs == 22
    assert trace_one_arcs == 12
    assert set(trace_one_p_values) == {14, 22, 24}
    assert trace_one_collision_free == 0

    print(json.dumps({
        "normalized_p1_slice": {
            "tuples": 5376,
            "even_factor_status": dict(census),
            "even_factor_survivors": survivors_p1,
            "arc_legal_configurations": arc_legal_p1,
            "arc_legal_survivors": survivor_arc_legal_p1,
        },
        "general_p_arc_space": {
            "arc_legal_single_layers": 35,
            "two_layer_arcs": two_layer_arcs,
            "trace_one_two_layer_arcs": trace_one_arcs,
            "trace_one_p_values": dict(sorted(trace_one_p_values.items())),
            "p_equals_one_arcs": trace_one_p_values.get(1, 0),
            "trace_one_arcs_collision_free": trace_one_collision_free,
        },
        "scaling_is_arc_symmetry": False,
        "joint_gate_empty": True,
        "conclusion": (
            "on a=b=0 the constant-height two-layer arc-condition locus is "
            "disjoint from the two-seed even-factor survivor set: every "
            "arc-legal trace-one arc collides for at least one seed color, and "
            "no even-factor survivor is arc-legal"
        ),
        "next_gate": (
            "classify the lower factorization strata in a=0,b!=0, then the "
            "factorization divisors on a!=0, before any affine-coverage test"
        ),
    }, sort_keys=True))


if __name__ == "__main__":
    main()
