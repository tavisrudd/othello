#!/usr/bin/env python3
"""Derive the generic C210 repair--repair coverage character.

For a quadratic repair graph, a generic target determines one repair pair sum
and product.  Repair--repair coverage is therefore one Artin--Schreier
character.  This checker verifies the formulas against direct q=64 chord
incidence, proves finite independence from the three seed-only characters,
and isolates its branch divisor from both seed--repair coverage covers.
"""

from __future__ import annotations

import itertools
import json
from collections import Counter
from fractions import Fraction

from analyze_c210_joint_coverage_monodromy import (
    absolute_trace,
    assemble,
    mixed_seed_polynomial,
    same_layer_character,
)
from analyze_c210_persistent_singletons import (
    coverage_equations,
    factor,
    sylvester_resultant,
)
from analyze_c210_residue_hypergraph import build_context
from analyze_c210_symbolic_coverage_resultant import (
    poly_derivative,
    poly_gcd,
    tau_exponents,
)


def repair_pair_data(
    context, target: tuple[int, int, int, int]
) -> tuple[int, int, int] | None:
    """Return (pair sum, pair product, AS bit), or None on a boundary."""

    field = context.ambient
    y0, y1, h0, h1 = target
    y = assemble(context, y0, y1)
    h = assemble(context, h0, h1)
    eta = assemble(context, context.eta0, context.eta1)
    quadratic = assemble(context, 1, context.a1)  # 1+a
    linear = assemble(context, 0, context.b1)
    constant = assemble(context, context.c0, context.c1)
    shifted_y = field.add(y, eta)
    shifted_y0, shifted_y1 = context.coordinates(shifted_y)
    if shifted_y1 == 0:
        return None

    right_side = field.add(
        field.add(h, constant),
        field.add(
            field.mul(shifted_y, shifted_y),
            field.mul(shifted_y, linear),
        ),
    )
    normalized = field.div(right_side, quadratic)
    normalized0, normalized1 = context.coordinates(normalized)
    pair_sum = field.div(normalized1, shifted_y1)
    if pair_sum == 0:
        return None
    pair_product = field.add(
        normalized0, field.mul(shifted_y0, pair_sum)
    )
    bit = absolute_trace(
        context,
        field.div(pair_product, field.mul(pair_sum, pair_sum)),
    )
    return pair_sum, pair_product, bit


def direct_repair_pairs(
    context, target: tuple[int, int, int, int]
) -> set[tuple[int, int]]:
    field = context.ambient
    y = assemble(context, target[0], target[1])
    h = assemble(context, target[2], target[3])
    eta = assemble(context, context.eta0, context.eta1)
    out = set()
    for r, s in itertools.combinations(context.base_values, 2):
        x_r = field.add(eta, r)
        x_s = field.add(eta, s)
        g_r = field.add(
            field.add(
                field.mul(context.a_big, field.mul(r, r)),
                field.mul(context.b_big, r),
            ),
            context.c_big,
        )
        g_s = field.add(
            field.add(
                field.mul(context.a_big, field.mul(s, s)),
                field.mul(context.b_big, s),
            ),
            context.c_big,
        )
        chord_height = field.add(
            g_r,
            field.add(
                field.mul(
                    field.add(y, x_r),
                    field.div(field.add(g_s, g_r), field.add(s, r)),
                ),
                field.mul(field.add(y, x_r), field.add(y, x_s)),
            ),
        )
        if chord_height == h:
            out.add((r, s))
    return out


def verify_repair_equations(context) -> dict[str, int]:
    field = context.ambient
    checked = 0
    boundary = 0
    pair_sum_zero = 0
    direct_pair_tests = 0
    for target in itertools.product(context.base_values, repeat=4):
        if target[1] == 0:
            continue
        direct = direct_repair_pairs(context, target)
        direct_pair_tests += math_comb_8_2()
        data = repair_pair_data(context, target)
        if data is None:
            eta1 = context.eta1
            if field.add(target[1], eta1) == 0:
                boundary += 1
            else:
                pair_sum_zero += 1
                assert not direct
            continue
        pair_sum, pair_product, bit = data
        formula = {
            (r, s) for r, s in itertools.combinations(context.base_values, 2)
            if field.add(r, s) == pair_sum
            and field.mul(r, s) == pair_product
        }
        assert formula == direct
        assert bool(direct) == (bit == 0)
        checked += 1
    return {
        "generic_nonzero_pair_sum_targets": checked,
        "shifted_y_boundary_targets": boundary,
        "zero_pair_sum_targets": pair_sum_zero,
        "direct_unordered_pair_tests": direct_pair_tests,
    }


def math_comb_8_2() -> int:
    return 28


def joint_character_rows(context) -> dict[str, object]:
    field = context.ambient
    histogram: Counter[tuple[int, int, int, int]] = Counter()
    witnesses = {}
    for target in itertools.product(context.base_values, repeat=4):
        y0, y1, h0, h1 = target
        if y1 == 0:
            continue
        repair = repair_pair_data(context, target)
        if repair is None:
            continue
        try:
            _, _, aa_bit = same_layer_character(
                context, context.alpha, target
            )
            _, _, bb_bit = same_layer_character(
                context, context.beta, target
            )
        except AssertionError:
            continue
        mixed = mixed_seed_polynomial(context, y1, h0, h1)
        if len(poly_gcd(field, mixed, poly_derivative(mixed))) != 1:
            continue
        factors = factor(field, context.base_values, mixed)
        ab_sign_bit = (5 - len(factors)) % 2
        key = (ab_sign_bit, aa_bit, bb_bit, repair[2])
        histogram[key] += 1
        witnesses.setdefault(key, {
            "target_tau_exponents": tau_exponents(context, target),
            "mixed_seed_factor_degrees":
                [len(item) - 1 for item in factors],
            "repair_pair_sum_product_tau_exponents":
                tau_exponents(context, repair[:2]),
        })
    assert set(histogram) == set(itertools.product((0, 1), repeat=4))
    return {
        "frobenius_bit_order": [
            "AB_sign", "AA_trace", "BB_trace", "RR_trace"
        ],
        "histogram": {
            "".join(map(str, key)): histogram[key]
            for key in sorted(histogram)
        },
        "witnesses": {
            "".join(map(str, key)): witnesses[key]
            for key in sorted(witnesses)
        },
    }


def branch_isolation_witness(context) -> dict[str, object]:
    field = context.ambient
    target = (0, 1, 0, field.power(context.tau, 6))

    # Compute p and q without discarding p=0.
    y = assemble(context, target[0], target[1])
    h = assemble(context, target[2], target[3])
    eta = assemble(context, context.eta0, context.eta1)
    shifted_y = field.add(y, eta)
    shifted_y0, shifted_y1 = context.coordinates(shifted_y)
    quadratic = assemble(context, 1, context.a1)
    linear = assemble(context, 0, context.b1)
    constant = assemble(context, context.c0, context.c1)
    normalized = field.div(
        field.add(
            field.add(h, constant),
            field.add(field.mul(shifted_y, shifted_y),
                      field.mul(shifted_y, linear)),
        ),
        quadratic,
    )
    normalized0, normalized1 = context.coordinates(normalized)
    pair_sum = field.div(normalized1, shifted_y1)
    pair_product = field.add(
        normalized0, field.mul(shifted_y0, pair_sum)
    )
    assert pair_sum == 0 and pair_product != 0

    # Every previously introduced target cover is unramified here.
    same_layer_character(context, context.alpha, target)
    same_layer_character(context, context.beta, target)
    mixed = mixed_seed_polynomial(context, target[1], target[2], target[3])
    assert len(poly_gcd(field, mixed, poly_derivative(mixed))) == 1
    for seed_height in (context.alpha, context.beta):
        resultant = sylvester_resultant(
            field,
            *coverage_equations(
                field, context.coordinates,
                context.eta0, context.eta1,
                context.a1, context.b1, context.c0, context.c1,
                seed_height, *target,
            ),
        )
        assert len(resultant) == 8
        assert len(poly_gcd(
            field, resultant, poly_derivative(resultant)
        )) == 1

    return {
        "target_tau_exponents": tau_exponents(context, target),
        "repair_pair_sum_tau_exponent": None,
        "repair_pair_product_tau_exponent":
            tau_exponents(context, (pair_product,))[0],
        "previous_target_covers_unramified": True,
    }


def main() -> None:
    context = build_context(1)
    previous_density = Fraction(
        29865552106645555637458091245391757971,
        391362999229013085388800000000000000000,
    )
    uncovered_density = previous_density / 2

    print(json.dumps({
        "base_specialization": "GF(8), orbit 1",
        "repair_chord_identity":
            "h=c+Y^2+Y*((1+a)*p+b)+(1+a)*q, Y=y-eta",
        "normalized_pair_equation":
            "q+Y*p=(1+a)^(-1)*(h+c+Y^2+Y*b)",
        "repair_coverage_character": "tr(q/p^2)=0",
        "equation_verification": verify_repair_equations(context),
        "joint_character_independence": joint_character_rows(context),
        "repair_character_branch_isolation":
            branch_isolation_witness(context),
        "generic_group_with_all_chord_classes":
            "((H wr S7) x (H wr S7)) x (S5 x C2 x C2 x C2_RR)",
        "previous_no_seed_or_legal_seed_repair_density":
            str(previous_density),
        "repair_repair_uncovered_density": "1/2",
        "all_chord_classes_uncovered_density": str(uncovered_density),
        "all_chord_classes_uncovered_density_decimal":
            float(uncovered_density),
        "conclusion":
            "the coefficient-generic full quadratic repair layer is not "
            "affine-complete; thinning cannot repair coverage",
        "status":
            "generic quadratic coefficients closed; classify the exceptional "
            "monodromy-drop locus before abandoning quadratic repairs",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
