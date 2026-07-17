#!/usr/bin/env python3
"""Certify the generic joint C210 seed-coverage monodromy.

This checker adds the three seed--seed chord schemes to the two seed--repair
coverage covers.  It derives and exhaustively verifies the mixed-seed quintic,
certifies its S5 arithmetic/geometric monodromy, verifies the two same-layer
Artin--Schreier characters, and records finite witnesses for all eight joint
quadratic character values.  It also certifies branch isolation of the two
degree-seven seed--repair covers.

The accompanying audit uses the distinct incidence branch divisors to combine
these certificates with the preceding collision-cover wreath products.
"""

from __future__ import annotations

import itertools
import json
import math
from collections import Counter
from fractions import Fraction

from analyze_c210_generic_coverage_monodromy import (
    exact_double_root_witness,
    success_density,
)
from analyze_c210_persistent_singletons import (
    coverage_equations,
    factor,
    poly_value,
    sylvester_resultant,
)
from analyze_c210_residue_hypergraph import build_context
from analyze_c210_symbolic_coverage_resultant import (
    poly_derivative,
    poly_gcd,
    tau_exponents,
)


def absolute_trace(context, value: int) -> int:
    field = context.ambient
    out = 0
    for exponent in (1, 2, 4):
        out = field.add(out, field.power(value, exponent))
    assert out in (0, 1)
    return out


def mixed_seed_polynomial(
    context, y1: int, h0: int, h1: int
) -> tuple[int, ...]:
    """Return the AB candidate polynomial in d=t+u, low degree first."""

    field = context.ambient
    tau = context.tau
    b = field.div(y1, tau)
    k = field.add(field.add(field.mul(y1, y1), h1), tau)
    a = field.div(k, tau)
    return (
        field.mul(y1, tau),
        field.add(h0, 1),
        y1,
        field.add(field.mul(a, a), a),
        b,
        field.mul(b, b),
    )


def same_layer_character(
    context,
    seed_height: int,
    target: tuple[int, int, int, int],
) -> tuple[int, int, int]:
    """Return (pair sum, pair product, AS Frobenius bit)."""

    field = context.ambient
    y0, y1, h0, h1 = target
    c0, c1 = context.coordinates(seed_height)
    assert y1 != 0
    pair_sum = field.div(
        field.add(field.add(h1, c1), field.mul(y1, y1)), y1
    )
    assert pair_sum != 0
    pair_product = field.add(
        field.add(field.add(h0, c0), field.mul(y0, y0)),
        field.add(field.mul(y1, y1), field.mul(y0, pair_sum)),
    )
    bit = absolute_trace(
        context,
        field.div(pair_product, field.mul(pair_sum, pair_sum)),
    )
    return pair_sum, pair_product, bit


def assemble(context, first: int, second: int) -> int:
    field = context.ambient
    omega = field.div(field.add(context.beta, 1), context.tau)
    return field.add(first, field.mul(second, omega))


def verify_seed_coverage_equations(context) -> dict[str, int]:
    field = context.ambient
    base = context.base_values
    tested_targets = 0
    tested_mixed_differences = 0
    tested_same_layer_pairs = 0

    for y0 in base:
        for y1 in base:
            if y1 == 0:
                continue
            y = assemble(context, y0, y1)
            for h0 in base:
                for h1 in base:
                    h = assemble(context, h0, h1)
                    target = (y0, y1, h0, h1)
                    tested_targets += 1

                    candidate_poly = mixed_seed_polynomial(context, y1, h0, h1)
                    polynomial_roots = {
                        d for d in base if poly_value(field, candidate_poly, d) == 0
                    }
                    direct_roots = set()
                    for d in base:
                        if d == 0:
                            continue
                        tested_mixed_differences += 1
                        b = field.div(y1, context.tau)
                        k = field.add(
                            field.add(field.mul(y1, y1), h1), context.tau
                        )
                        a = field.div(k, context.tau)
                        x0 = field.add(
                            y1,
                            field.add(field.mul(a, d),
                                      field.mul(b, field.mul(d, d))),
                        )
                        u = field.add(x0, y0)
                        t = field.add(d, u)
                        lam = field.div(field.add(y, t), d)
                        chord_height = field.add(
                            context.alpha,
                            field.add(
                                field.mul(lam, field.add(
                                    context.beta, context.alpha
                                )),
                                field.mul(
                                    field.mul(d, d),
                                    field.mul(lam, field.add(1, lam)),
                                ),
                            ),
                        )
                        if chord_height == h:
                            direct_roots.add(d)
                    assert polynomial_roots == direct_roots

                    for seed_height in (context.alpha, context.beta):
                        pair_sum = field.div(
                            field.add(
                                field.add(h1, context.coordinates(seed_height)[1]),
                                field.mul(y1, y1),
                            ),
                            y1,
                        )
                        direct_pairs = set()
                        for t, u in itertools.combinations(base, 2):
                            tested_same_layer_pairs += 1
                            chord_height = field.add(
                                seed_height,
                                field.mul(field.add(y, t), field.add(y, u)),
                            )
                            if chord_height == h:
                                direct_pairs.add((t, u))
                        if pair_sum == 0:
                            assert not direct_pairs
                            continue
                        p, q, bit = same_layer_character(
                            context, seed_height, target
                        )
                        assert p == pair_sum
                        formula_pairs = {
                            (t, u) for t, u in itertools.combinations(base, 2)
                            if field.add(t, u) == p and field.mul(t, u) == q
                        }
                        assert formula_pairs == direct_pairs
                        assert bool(direct_pairs) == (bit == 0)

    return {
        "generic_targets": tested_targets,
        "mixed_differences": tested_mixed_differences,
        "same_layer_unordered_pairs": tested_same_layer_pairs,
    }


def mixed_seed_monodromy_witnesses(context) -> dict[str, object]:
    field = context.ambient
    cases = {
        "five_cycle": (1, 1, field.power(context.tau, 2), [5]),
        "two_times_three": (1, 0, 0, [2, 3]),
        "four_cycle": (1, 0, 1, [1, 4]),
    }
    rows = {}
    for name, (y1, h0, h1, expected_degrees) in cases.items():
        poly = mixed_seed_polynomial(context, y1, h0, h1)
        assert len(poly_gcd(field, poly, poly_derivative(poly))) == 1
        degrees = [len(item) - 1 for item in factor(field, context.base_values, poly)]
        assert degrees == expected_degrees
        rows[name] = {
            "target_y1_h0_h1_tau_exponents":
                tau_exponents(context, (y1, h0, h1)),
            "factor_degrees": degrees,
            "polynomial_coefficients_tau_exponents":
                tau_exponents(context, poly),
        }
    return rows


def seed_character_independence(context) -> dict[str, object]:
    field = context.ambient
    histogram: Counter[tuple[int, int, int]] = Counter()
    witnesses = {}
    for y1 in context.base_values:
        if y1 == 0:
            continue
        for h0 in context.base_values:
            for h1 in context.base_values:
                target = (0, y1, h0, h1)
                try:
                    _, _, aa_bit = same_layer_character(
                        context, context.alpha, target
                    )
                    _, _, bb_bit = same_layer_character(
                        context, context.beta, target
                    )
                except AssertionError:
                    continue
                poly = mixed_seed_polynomial(context, y1, h0, h1)
                if len(poly_gcd(field, poly, poly_derivative(poly))) != 1:
                    continue
                factors = factor(field, context.base_values, poly)
                ab_sign_bit = (5 - len(factors)) % 2
                key = (ab_sign_bit, aa_bit, bb_bit)
                histogram[key] += 1
                witnesses.setdefault(key, {
                    "target_y1_h0_h1_tau_exponents":
                        tau_exponents(context, (y1, h0, h1)),
                    "mixed_seed_factor_degrees":
                        [len(item) - 1 for item in factors],
                })
    assert set(histogram) == set(itertools.product((0, 1), repeat=3))
    return {
        "frobenius_bit_order": ["AB_sign", "AA_trace", "BB_trace"],
        "histogram": {
            "".join(map(str, key)): histogram[key]
            for key in sorted(histogram)
        },
        "witnesses": {
            "".join(map(str, key)): witnesses[key]
            for key in sorted(witnesses)
        },
    }


def seed_repair_branch_isolation(context) -> dict[str, object]:
    field = context.ambient

    a_target = (0, 1, 0, field.power(context.tau, 4))
    a_root = field.power(context.tau, 5)
    a_witness = exact_double_root_witness(
        context, context.alpha, a_target, a_root
    )
    b_at_a = sylvester_resultant(
        field,
        *coverage_equations(
            field, context.coordinates,
            context.eta0, context.eta1,
            context.a1, context.b1, context.c0, context.c1,
            context.beta, *a_target,
        ),
    )
    assert len(poly_gcd(field, b_at_a, poly_derivative(b_at_a))) == 1

    b_target = (0, 1, 1, field.power(context.tau, 4))
    b_root = field.power(context.tau, 5)
    b_witness = exact_double_root_witness(
        context, context.beta, b_target, b_root
    )
    a_at_b = sylvester_resultant(
        field,
        *coverage_equations(
            field, context.coordinates,
            context.eta0, context.eta1,
            context.a1, context.b1, context.c0, context.c1,
            context.alpha, *b_target,
        ),
    )
    assert len(poly_gcd(field, a_at_b, poly_derivative(a_at_b))) == 1

    return {
        "A_only_transposition": a_witness,
        "B_only_transposition": b_witness,
        "other_seed_color_unramified_at_each_witness": True,
    }


def main() -> None:
    context = build_context(1)
    no_legal_repair_one_color = 1 - success_density(7)
    seed_only_uncovered_density = Fraction(1, 2) * Fraction(1, 2) * Fraction(44, 120)
    joint_uncovered_density = (
        seed_only_uncovered_density
        * no_legal_repair_one_color
        * no_legal_repair_one_color
    )
    assert seed_only_uncovered_density == Fraction(11, 120)

    print(json.dumps({
        "base_specialization": "GF(8), orbit 1, generic y1!=0 stratum",
        "equation_verification": verify_seed_coverage_equations(context),
        "mixed_seed_candidate_polynomial":
            "B^2*d^5+B*d^4+(A^2+A)*d^3+y1*d^2+(h0+1)*d+y1*tau",
        "mixed_seed_parameters":
            "A=(y1^2+h1+tau)/tau, B=y1/tau",
        "mixed_seed_monodromy_witnesses":
            mixed_seed_monodromy_witnesses(context),
        "mixed_seed_arithmetic_monodromy": "S5",
        "mixed_seed_geometric_monodromy": "S5",
        "same_layer_group": "C2 x C2",
        "seed_only_joint_group": "S5 x C2 x C2",
        "seed_character_independence": seed_character_independence(context),
        "seed_repair_branch_isolation": seed_repair_branch_isolation(context),
        "two_seed_color_repair_group": "(H wr S7) x (H wr S7)",
        "collision_group": "H=S5 x C2 x C2",
        "full_generic_joint_group":
            "((H wr S7) x (H wr S7)) x (S5 x C2 x C2)",
        "density_factors": {
            "AA_uncovered": "1/2",
            "BB_uncovered": "1/2",
            "AB_uncovered": "44/120=11/30",
            "one_repair_seed_color_no_legal_candidate":
                str(no_legal_repair_one_color),
        },
        "seed_only_uncovered_density": str(seed_only_uncovered_density),
        "joint_uncovered_density": str(joint_uncovered_density),
        "joint_uncovered_density_decimal": float(joint_uncovered_density),
        "status":
            "positive-density generic targets avoid every seed--seed chord "
            "and every one-repair-legal seed--repair chord; repair--repair "
            "coverage is the remaining quadratic-mechanism gate",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
