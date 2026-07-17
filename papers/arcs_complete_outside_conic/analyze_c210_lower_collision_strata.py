#!/usr/bin/env python3
"""Close the C210 lower mixed-collision strata at the coverage projection.

The divisors ``b=0``, ``e^2+k=0``, and ``D_H=0`` can lower the
one-repair collision group, but the two degree-seven seed--repair incidence
covers retain top group ``S7 x S7``.  For an obstruction it is enough to
forget repair legality altogether: a target with no rational point in either
degree-seven incidence fiber has no seed--repair chord even from the full
repair graph.

This checker records the resulting exact derangement density.  It also checks
every GF(8)-rational point on the three lower divisors and their intersections:
for each seed colour it finds a simple coverage branch at which the opposite
coverage cover, the three seed-only covers, and the repair--repair
Artin--Schreier cover are all unramified.  These witnesses rule out every
rational sign coupling in the projected group and provide bounded checks of
the uniform branch-support argument used in the accompanying audit.
"""

from __future__ import annotations

import hashlib
import itertools
import json
from collections import Counter
from fractions import Fraction

from analyze_c210_coverage_branch_images import normalized
from analyze_c210_extension_branch_strata import simple_branch_witness
from analyze_c210_joint_coverage_monodromy import (
    assemble,
    mixed_seed_polynomial,
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


def row_digest(rows: list[tuple[int, ...]]) -> str:
    payload = json.dumps(rows, separators=(",", ":")).encode()
    return hashlib.sha256(payload).hexdigest()


def squarefree(field, polynomial: tuple[int, ...]) -> bool:
    return len(poly_gcd(field, polynomial, poly_derivative(polynomial))) == 1


def worst_sign_coupling_density() -> tuple[Fraction, dict[str, object]]:
    """Minimize the missed density over every possible common sign quotient.

    A subdirect product of ``S7^2`` and ``S5 x C2^3`` can couple only their
    elementary-abelian sign quotients.  The common quotient has rank at most
    two.  Enumerating those relation spaces avoids assuming direct-product
    independence on a special coefficient stratum.
    """

    def parity(permutation: tuple[int, ...]) -> int:
        return sum(
            permutation[i] > permutation[j]
            for i in range(len(permutation))
            for j in range(i + 1, len(permutation))
        ) % 2

    def derangements_by_parity(degree: int) -> tuple[int, int]:
        counts = [0, 0]
        for permutation in itertools.permutations(range(degree)):
            if all(permutation[i] != i for i in range(degree)):
                counts[parity(permutation)] += 1
        return counts[0], counts[1]

    d7 = derangements_by_parity(7)
    d5 = derangements_by_parity(5)
    assert d7 == (930, 924)
    assert d5 == (24, 20)

    relation_spaces = {frozenset((0,))}
    for value in range(1, 64):
        relation_spaces.add(frozenset((0, value)))
    for left in range(1, 64):
        for right in range(left + 1, 64):
            relation_spaces.add(frozenset((0, left, right, left ^ right)))

    best = None
    for relations in relation_spaces:
        # Coordinates 0,1 are the two S7 signs; 2--5 are the S5 sign
        # and the three independent quadratic characters.  Subdirectness
        # excludes a relation supported wholly on either side.
        if any(value and value & ~0b11 == 0 for value in relations):
            continue
        if any(value and value & 0b11 == 0 for value in relations):
            continue
        allowed = [
            value for value in range(64)
            if all((value & relation).bit_count() % 2 == 0
                   for relation in relations)
        ]
        favorable = 0
        for value in allowed:
            bits = tuple((value >> index) & 1 for index in range(6))
            if bits[3:] != (1, 1, 1):
                continue
            favorable += d7[bits[0]] * d7[bits[1]] * d5[bits[2]]
        total = len(allowed) * 2520 * 2520 * 60
        density = Fraction(favorable, total)
        if best is None or density < best[0]:
            best = density, relations

    assert best is not None
    assert best[0] == Fraction(1331, 216000)
    return best[0], {
        "S7_derangements_by_parity": list(d7),
        "S5_derangements_by_parity": list(d5),
        "maximum_common_sign_rank": 2,
        "relation_masks_at_minimum": sorted(best[1]),
    }


def main() -> None:
    context = build_context(1)
    field = context.ambient
    base = context.base_values
    square = lambda value: field.mul(value, value)
    sqrt_tau = field.power(context.tau, 4)
    sqrt_power = field.q // 2

    def conditions(e: int, b: int, k: int) -> tuple[str, ...]:
        out = []
        if b == 0:
            out.append("b_zero")
        if field.add(square(e), k) == 0:
            out.append("e_squared_plus_k_zero")
        c_value = field.add(square(e), field.mul(sqrt_tau, e))
        d_h = field.add(
            field.add(square(k), field.mul(c_value, k)), square(c_value)
        )
        if d_h == 0:
            out.append("D_H_zero")
        return tuple(out)

    rows = [
        (e, a, b, k)
        for e in base if e != 0
        for a in base if a != 0
        for b in base
        for k in base
        if conditions(e, b, k)
    ]
    stratum_counts = Counter(
        name for e, _a, b, k in rows for name in conditions(e, b, k)
    )
    intersection_counts = Counter(
        "&".join(names)
        for e, _a, b, k in rows
        for names in (conditions(e, b, k),)
        if len(names) >= 2
    )

    heights = {"A": context.alpha, "B": context.beta}

    def lower_covers_unramified(
        coefficients: tuple[int, int, int, int],
        target: tuple[int, int, int, int],
    ) -> bool:
        """Test only branch support, not Frobenius character values."""

        e, a, b, k = coefficients
        y0, y1, h0, h1 = target
        for seed_height in (context.alpha, context.beta):
            _seed0, seed1 = context.coordinates(seed_height)
            pair_sum_numerator = field.add(
                field.add(h1, seed1), square(y1)
            )
            if pair_sum_numerator == 0:
                return False

        mixed = mixed_seed_polynomial(context, y1, h0, h1)
        if not squarefree(field, mixed):
            return False

        omega = field.div(field.add(context.beta, 1), context.tau)
        y = assemble(context, y0, y1)
        height = assemble(context, h0, h1)
        eta = assemble(context, 1, e)
        shifted_y = field.add(y, eta)
        shifted_y0, shifted_y1 = context.coordinates(shifted_y)
        if shifted_y1 == 0:
            return False
        quadratic = assemble(context, 1, a)
        linear = field.mul(b, omega)
        constant = assemble(context, field.add(k, 1), 0)
        right_side = field.add(
            field.add(height, constant),
            field.add(
                square(shifted_y), field.mul(shifted_y, linear)
            ),
        )
        normalized_value = field.div(right_side, quadratic)
        normalized0, normalized1 = context.coordinates(normalized_value)
        pair_sum = field.div(normalized1, shifted_y1)
        _pair_product = field.add(
            normalized0, field.mul(shifted_y0, pair_sum)
        )
        return pair_sum != 0

    witness_summaries = []
    for color, seed_height in heights.items():
        other_height = heights["B" if color == "A" else "A"]
        witnesses: list[tuple[int, ...]] = []
        trial_histogram: Counter[int] = Counter()

        for e, a, b, k in rows:
            c0 = field.add(k, 1)
            found = False
            trials = 0
            for target in itertools.product(base, repeat=4):
                if target[1] == 0:
                    continue
                trials += 1
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
                if len(resultant) != 8:
                    continue
                gcd = normalized(
                    field,
                    poly_gcd(field, resultant, poly_derivative(resultant)),
                )
                if len(gcd) != 3 or gcd[1] != 0:
                    continue
                root = field.power(gcd[0], sqrt_power)
                if gcd != (square(root), 0, 1):
                    continue
                quotient, remainder = poly_divmod(field, resultant, gcd)
                if remainder or poly_value(field, quotient, root) == 0:
                    continue
                if not squarefree(field, quotient):
                    continue
                t_gcd = t_gcd_modulus(
                    field, (root, 1), equations[:3], equations[3:]
                )
                if len(t_gcd) != 2 or t_gcd[1] != (1,):
                    continue

                other = sylvester_resultant(
                    field,
                    *coverage_equations(
                        field,
                        context.coordinates,
                        1,
                        e,
                        a,
                        b,
                        c0,
                        0,
                        other_height,
                        *target,
                    ),
                )
                if len(other) != 8 or not squarefree(field, other):
                    continue
                if not lower_covers_unramified((e, a, b, k), target):
                    continue

                seed_parameter = 0 if not t_gcd[0] else t_gcd[0][0]
                witnesses.append(
                    (e, a, b, k, *target, root, seed_parameter)
                )
                trial_histogram[trials] += 1
                found = True
                break
            assert found, (color, e, a, b, k)

        witness_summaries.append({
            "seed": color,
            "coefficient_points": len(witnesses),
            "maximum_targets_tried": max(trial_histogram),
            "witness_rows_sha256": row_digest(witnesses),
        })

    # The reduced D_H divisor has two conjugate components not visible over
    # GF(8).  Repeat the stronger isolation test at generic closed points of
    # both components, their b=0 intersections, their intersections with
    # e^2+k=0, and the resulting triple intersections.
    omega = field.div(field.add(context.beta, 1), context.tau)
    omega2 = square(omega)
    def extension_targets():
        for y0 in base:
            for y1 in base:
                if y1 == 0:
                    continue
                for h0 in range(field.q):
                    for h1 in range(field.q):
                        yield (y0, y1, h0, h1)
    geometric_witness_rows: list[tuple[int, ...]] = []
    for component in (omega, omega2):
        other_component = omega2 if component == omega else omega
        generic_e = 1
        generic_c = field.add(square(generic_e), field.mul(sqrt_tau, generic_e))
        generic_k = field.mul(component, generic_c)
        critical_e = field.mul(sqrt_tau, other_component)
        critical_k = square(critical_e)
        for e, k in ((generic_e, generic_k), (critical_e, critical_k)):
            for b in (0, 1):
                coefficients4 = (e, 1, b, k)
                coefficients5 = (*coefficients4, 0)
                for color, seed_height in heights.items():
                    other_height = heights["B" if color == "A" else "A"]
                    found = None
                    for target in extension_targets():
                        if not lower_covers_unramified(coefficients4, target):
                            continue
                        witness = simple_branch_witness(
                            context, coefficients5, seed_height, (target,)
                        )
                        if witness is None:
                            continue
                        other_cover = sylvester_resultant(
                            field,
                            *coverage_equations(
                                field,
                                context.coordinates,
                                1,
                                e,
                                1,
                                b,
                                field.add(k, 1),
                                0,
                                other_height,
                                *target,
                            ),
                        )
                        if len(other_cover) != 8 or not squarefree(
                            field, other_cover
                        ):
                            continue
                        found = witness
                        break
                    assert found is not None, (component, e, k, b, color)
                    geometric_witness_rows.append(
                        (component, e, k, b, 0 if color == "A" else 1, *found)
                    )

    s7_derangements = 1854
    s7_order = 5040
    no_seed_repair = Fraction(s7_derangements, s7_order) ** 2
    no_seed_seed = Fraction(44, 120) * Fraction(1, 2) ** 2
    no_repair_repair = Fraction(1, 2)
    uncovered = no_seed_repair * no_seed_seed * no_repair_repair
    assert Fraction(s7_derangements, s7_order) == Fraction(103, 280)
    assert uncovered == Fraction(116699, 18816000)
    coupled_floor, coupling_certificate = worst_sign_coupling_density()

    print(json.dumps({
        "coefficient_quotient": ["e", "a", "b", "k"],
        "repair_stratum": "e*a!=0",
        "lower_divisors": ["b=0", "e^2+k=0", "D_H=0"],
        "gf8_union_point_count": len(rows),
        "gf8_stratum_point_counts": dict(sorted(stratum_counts.items())),
        "gf8_nonempty_intersection_counts": dict(
            sorted(intersection_counts.items())
        ),
        "isolated_coverage_branch_witnesses": witness_summaries,
        "geometric_D_H_component_witnesses": {
            "rows": len(geometric_witness_rows),
            "witness_rows_sha256": row_digest(geometric_witness_rows),
            "loci": [
                "both conjugate generic components",
                "their b=0 intersections",
                "their e^2+k=0 intersections",
                "both conjugate triple intersections",
            ],
        },
        "projected_group_marginals": [
            "S7 x S7", "S5 x C2 x C2 x C2_RR"
        ],
        "density_factors": {
            "one_seed_repair_cover_rootless": "1854/5040=103/280",
            "both_seed_repair_covers_rootless": str(no_seed_repair),
            "mixed_seed_AB_rootless": "44/120=11/30",
            "same_seed_AA_and_BB_absent": "1/4",
            "repair_repair_absent": "1/2",
        },
        "direct_product_uncovered_density": str(uncovered),
        "direct_product_uncovered_density_decimal": float(uncovered),
        "worst_sign_coupled_uncovered_density": str(coupled_floor),
        "worst_sign_coupled_uncovered_density_decimal": float(coupled_floor),
        "sign_coupling_certificate": coupling_certificate,
        "consequence":
            "even after every possible sign coupling, each lower "
            "mixed-collision stratum has a positive-density "
            "target class with no chord even from the full quadratic repair "
            "graph; deleting to an arc-legal domain cannot add coverage",
        "status":
            "b=0, e^2+k=0, D_H=0, and all classified intersections closed",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
