#!/usr/bin/env python3
"""Certify simple points on every rational C210 coverage branch image.

The preceding branch-source checker constructs the exact Jacobian equations
for the two degree-seven seed--repair covers on the translation quotient

    (e, a, b, k) = (eta1, a1, b1, c0+1),  e*a != 0.

This checker maps those sources back to target space.  For every one of the
3136 rational GF(8) quotient points and for each seed colour, it finds a
target whose degree-seven repair resultant has exactly one doubled root, a
squarefree residual factor, and a unique seed parameter above the doubled
root.  It also verifies the chord and Jacobian equations at that source
point.  Thus none of the rational quotient points -- including every rational
intersection of the known mixed-cover drop divisors -- lies on a coverage
divisor that destroys all simple branch inertia.

This is a rational-point exclusion, not a classification of geometric
coverage drop divisors over extensions of GF(8).
"""

from __future__ import annotations

import hashlib
import itertools
import json
from collections import Counter

from analyze_c210_coverage_branch_discriminants import (
    NAMES,
    Ring,
    chord_height,
    derivative,
    numeric_ramification_numerator,
    ramification_numerator,
)
from analyze_c210_persistent_singletons import (
    coverage_equations,
    poly_divmod,
    poly_value,
    sylvester_resultant,
    t_gcd_modulus,
)
from analyze_c210_residue_hypergraph import build_context
from analyze_c210_symbolic_coverage_resultant import poly_derivative, poly_gcd


def normalized(field, polynomial: tuple[int, ...]) -> tuple[int, ...]:
    inverse = field.inv(polynomial[-1])
    return tuple(field.mul(coefficient, inverse) for coefficient in polynomial)


def row_digest(rows: list[tuple[int, ...]]) -> str:
    payload = json.dumps(rows, separators=(",", ":")).encode()
    return hashlib.sha256(payload).hexdigest()


def main() -> None:
    context = build_context(1)
    field = context.ambient
    base = context.base_values
    omega = field.div(field.add(context.beta, 1), context.tau)

    # This coefficient is independent of (e,a,b,k).  In particular, neither
    # ramification source can become everywhere inseparable on a coefficient
    # stratum: dJ/dy1 always contains t^4 with coefficient one.
    source_t4 = [0] * len(NAMES)
    source_t4[NAMES.index("h1")] = 4
    source_t4 = tuple(source_t4)
    for seed in ("A", "B"):
        ring = Ring()
        dy1 = derivative(ring, ramification_numerator(ring, seed), "y1")
        assert dy1[source_t4] == 1

    sqrt_power = field.q // 2
    divisor_counts = Counter()
    divisor_witness_counts = {"A": Counter(), "B": Counter()}
    summaries = []

    sqrt_tau = field.power(context.tau, 4)

    def conditions(e: int, b: int, k: int) -> tuple[str, ...]:
        square = lambda value: field.mul(value, value)
        out = []
        if b == 0:
            out.append("b1_zero")
        if field.add(square(e), k) == 0:
            out.append("critical_value_collision")
        C = field.add(square(e), field.mul(sqrt_tau, e))
        hasse = field.add(
            field.add(square(k), field.mul(C, k)), square(C)
        )
        if hasse == 0:
            out.append("non_simple_inertia")
        return tuple(out)

    coefficient_rows = [
        (e, a, b, k)
        for e in base if e != 0
        for a in base if a != 0
        for b in base
        for k in base
    ]
    for e, _a, b, k in coefficient_rows:
        for name in conditions(e, b, k):
            divisor_counts[name] += 1

    for seed, seed_height in (("A", context.alpha), ("B", context.beta)):
        ring = Ring()
        trials = Counter()
        witnesses: list[tuple[int, ...]] = []

        for e, a, b, k in coefficient_rows:
            c0 = field.add(k, 1)
            found = False
            trial = 0
            for target in itertools.product(base, repeat=4):
                # On y1!=0 the leading coefficient is
                # a*y1*(a^2+a+1), which is nonzero over GF(8) when a!=0.
                if target[1] == 0:
                    continue
                trial += 1
                equations = coverage_equations(
                    field,
                    context.coordinates,
                    1,
                    e,
                    a,
                    b,
                    c0,
                    0,
                    seed_height,
                    *target,
                )
                resultant = sylvester_resultant(field, *equations)
                assert len(resultant) == 8
                gcd = normalized(
                    field,
                    poly_gcd(field, resultant, poly_derivative(resultant)),
                )
                if len(gcd) != 3 or gcd[1] != 0:
                    continue

                root = field.power(gcd[0], sqrt_power)
                if gcd != (field.mul(root, root), 0, 1):
                    continue
                quotient, remainder = poly_divmod(field, resultant, gcd)
                if remainder or poly_value(field, quotient, root) == 0:
                    continue
                if len(poly_gcd(field, quotient, poly_derivative(quotient))) != 1:
                    continue

                t_gcd = t_gcd_modulus(
                    field, (root, 1), equations[:3], equations[3:]
                )
                if len(t_gcd) != 2 or t_gcd[1] != (1,):
                    continue
                seed_parameter = 0 if not t_gcd[0] else t_gcd[0][0]

                y = field.add(target[0], field.mul(target[1], omega))
                height = field.add(target[2], field.mul(target[3], omega))
                eta = field.add(1, field.mul(e, omega))
                assert field.add(field.add(eta, root), seed_parameter) != 0
                assert chord_height(
                    ring, seed, (e, a, b, k), root, seed_parameter, y
                ) == height
                assert numeric_ramification_numerator(
                    ring, seed, (e, a, b, k), root, seed_parameter, y
                ) == 0

                trials[trial] += 1
                witnesses.append(
                    (e, a, b, k, *target, root, seed_parameter)
                )
                for name in conditions(e, b, k):
                    divisor_witness_counts[seed][name] += 1
                found = True
                break
            assert found, (seed, e, a, b, k)

        assert len(witnesses) == len(coefficient_rows)
        summaries.append({
            "seed": seed,
            "quotient_points_with_simple_branch_image_witness": len(witnesses),
            "maximum_targets_tried": max(trials),
            "total_targets_tried": sum(count * tries for tries, count in trials.items()),
            "witness_rows_sha256": row_digest(witnesses),
            "mixed_divisor_points_with_witness": dict(
                sorted(divisor_witness_counts[seed].items())
            ),
        })

    assert all(
        divisor_witness_counts[seed][name] == count
        for seed in ("A", "B")
        for name, count in divisor_counts.items()
    )

    print(json.dumps({
        "field": "GF(8)",
        "coefficient_quotient": ["eta1", "a1", "b1", "c0"],
        "normalization": "eta0=1, c1=0, k=c0+1",
        "repair_stratum_size": len(coefficient_rows),
        "source_separability_identity":
            "coefficient of t^4 in dJ_z/dy1 is 1 for z=A and z=B",
        "simple_branch_image_witness_conditions": [
            "degree-seven repair resultant",
            "derivative gcd exactly (r+rho)^2",
            "residual quintic squarefree and avoiding rho",
            "unique seed parameter above rho",
            "nonzero chord denominator",
            "source maps to target and satisfies J_z=0",
        ],
        "seed_covers": summaries,
        "mixed_drop_divisor_rational_point_counts": dict(sorted(divisor_counts.items())),
        "consequence":
            "no GF(8)-rational quotient point, including any rational point "
            "of a known mixed-cover drop divisor, destroys all simple branch "
            "inertia in either degree-seven coverage image",
        "scope":
            "geometric coverage drop divisors without GF(8)-rational points "
            "and the arithmetic c1 twist remain",
        "status":
            "coverage branch images certified pointwise on the full rational "
            "quotient; extension-field divisor classification remains",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
