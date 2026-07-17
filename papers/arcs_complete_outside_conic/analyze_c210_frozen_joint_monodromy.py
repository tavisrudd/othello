#!/usr/bin/env python3
"""Certify the full joint C210 group at the three frozen q=64 layers.

The generic joint calculation used orbit 1 as a control specialization.  This
checker repeats the finite certificates needed after freezing the quadratic
repair coefficients at each of the three exceptional translation orbits.  It
checks

* an isolated simple branch for each of the two degree-seven seed--repair
  covers, away from every one-repair collision pole;
* all sixteen Frobenius classes of the mixed-seed sign, the two same-layer
  Artin--Schreier characters, and the repair--repair character; and
* an isolated repair--repair Artin--Schreier branch away from every preceding
  target cover.

The accompanying audit supplies the geometric assembly: the two incidence
sources are rational, the one-repair collision group is already certified as
``H=S5 x C2 x C2`` for all three orbits, and distinct fixed-repair incidence
hypersurfaces give the two independent wreath products.
"""

from __future__ import annotations

import json
from pathlib import Path

from analyze_c210_generic_coverage_monodromy import exact_double_root_witness
from analyze_c210_joint_coverage_monodromy import (
    assemble,
    mixed_seed_polynomial,
    same_layer_character,
)
from analyze_c210_persistent_singletons import (
    coverage_equations,
    sylvester_resultant,
)
from analyze_c210_repair_repair_coverage import joint_character_rows
from analyze_c210_residue_hypergraph import build_context
from analyze_c210_symbolic_coverage_resultant import (
    poly_derivative,
    poly_gcd,
    tau_exponents,
)


# Entries are (target coordinate exponents, doubled-root exponent).  ``None``
# denotes zero; all other entries are powers of tau in GF(8).
SEED_BRANCH_SPECIFICATIONS = {
    1: {
        "A": ((None, 0, None, 4), 5),
        "B": ((None, 0, 0, 4), 5),
    },
    2: {
        "A": ((None, 0, 1, 4), 6),
        "B": ((None, 0, None, 4), 5),
    },
    3: {
        "A": ((None, 0, 5, 6), 3),
        "B": ((None, 3, 3, 1), 5),
    },
}

REPAIR_BRANCH_SPECIFICATIONS = {
    1: ((None, 0, None, 6), 4),
    2: ((None, 0, 6, 1), 6),
    3: ((None, 0, 1, None), 2),
}


def decode(context, exponents: tuple[int | None, ...]) -> tuple[int, ...]:
    field = context.ambient
    return tuple(
        0 if exponent is None else field.power(context.tau, exponent)
        for exponent in exponents
    )


def resultant(context, seed_height: int, target: tuple[int, ...]) -> tuple[int, ...]:
    field = context.ambient
    equations = coverage_equations(
        field,
        context.coordinates,
        context.eta0,
        context.eta1,
        context.a1,
        context.b1,
        context.c0,
        context.c1,
        seed_height,
        *target,
    )
    return sylvester_resultant(field, *equations)


def squarefree(context, polynomial: tuple[int, ...]) -> bool:
    return len(poly_gcd(
        context.ambient, polynomial, poly_derivative(polynomial)
    )) == 1


def one_repair_poles(context, orbit: int) -> set[int]:
    data = json.loads(Path(__file__).with_name(
        "analyze_c210_remaining_trace_orbits_output.txt"
    ).read_text())
    row = next(item for item in data["orbits"] if item["orbit"] == orbit)
    return {
        0 if exponent is None else context.ambient.power(context.tau, exponent)
        for collision in row["collisions"]
        for exponent in collision["p_roots"]
    }


def seed_branch_rows(context, orbit: int) -> dict[str, object]:
    field = context.ambient
    heights = {"A": context.alpha, "B": context.beta}
    poles = one_repair_poles(context, orbit)
    assert len(poles) == 4
    rows = {}

    for color, (target_exponents, root_exponent) in (
        SEED_BRANCH_SPECIFICATIONS[orbit].items()
    ):
        target = decode(context, target_exponents)
        root = field.power(context.tau, root_exponent)
        witness = exact_double_root_witness(
            context, heights[color], target, root
        )
        assert witness["resultant_degree"] == 7
        assert root not in poles

        other_color = "B" if color == "A" else "A"
        other = resultant(context, heights[other_color], target)
        assert len(other) == 8 and squarefree(context, other)

        # The seed-only factors and RR character are all unramified here.
        same_layer_character(context, context.alpha, target)
        same_layer_character(context, context.beta, target)
        assert squarefree(
            context,
            mixed_seed_polynomial(context, target[1], target[2], target[3]),
        )
        pair_sum, pair_product = repair_pair_sum_product(context, target)
        assert pair_sum != 0

        rows[color] = {
            "witness": witness,
            "other_seed_repair_cover_unramified": True,
            "seed_only_covers_unramified": True,
            "repair_repair_cover_unramified": True,
            "one_repair_collision_cover_unramified": True,
            "repair_pair_sum_product_tau_exponents": tau_exponents(
                context, (pair_sum, pair_product)
            ),
        }
    return rows


def repair_pair_sum_product(
    context, target: tuple[int, ...]
) -> tuple[int, int]:
    field = context.ambient
    y = assemble(context, target[0], target[1])
    h = assemble(context, target[2], target[3])
    eta = assemble(context, context.eta0, context.eta1)
    shifted_y = field.add(y, eta)
    shifted_y0, shifted_y1 = context.coordinates(shifted_y)
    assert shifted_y1 != 0

    quadratic = assemble(context, 1, context.a1)
    linear = assemble(context, 0, context.b1)
    constant = assemble(context, context.c0, context.c1)
    normalized = field.div(
        field.add(
            field.add(h, constant),
            field.add(
                field.mul(shifted_y, shifted_y),
                field.mul(shifted_y, linear),
            ),
        ),
        quadratic,
    )
    normalized0, normalized1 = context.coordinates(normalized)
    pair_sum = field.div(normalized1, shifted_y1)
    pair_product = field.add(
        normalized0, field.mul(shifted_y0, pair_sum)
    )
    return pair_sum, pair_product


def repair_branch_row(context, orbit: int) -> dict[str, object]:
    target_exponents, product_exponent = REPAIR_BRANCH_SPECIFICATIONS[orbit]
    target = decode(context, target_exponents)
    pair_sum, pair_product = repair_pair_sum_product(context, target)
    assert pair_sum == 0
    assert pair_product == context.ambient.power(context.tau, product_exponent)

    same_layer_character(context, context.alpha, target)
    same_layer_character(context, context.beta, target)
    mixed = mixed_seed_polynomial(context, target[1], target[2], target[3])
    assert squarefree(context, mixed)
    for seed_height in (context.alpha, context.beta):
        cover = resultant(context, seed_height, target)
        assert len(cover) == 8 and squarefree(context, cover)

    return {
        "target_tau_exponents": tau_exponents(context, target),
        "repair_pair_sum_tau_exponent": None,
        "repair_pair_product_tau_exponent": product_exponent,
        "both_seed_repair_covers_unramified": True,
        "seed_only_covers_unramified": True,
    }


def main() -> None:
    orbit_rows = []
    for orbit in (1, 2, 3):
        context = build_context(orbit)
        characters = joint_character_rows(context)
        assert len(characters["histogram"]) == 16
        orbit_rows.append({
            "orbit": orbit,
            "seed_repair_isolated_transpositions":
                seed_branch_rows(context, orbit),
            "lower_character_independence": characters,
            "repair_repair_isolated_branch":
                repair_branch_row(context, orbit),
            "one_repair_collision_group": "H=S5 x C2 x C2",
            "frozen_full_joint_geometric_group":
                "((H wr S7) x (H wr S7)) x "
                "(S5 x C2 x C2 x C2_RR)",
            "frozen_full_joint_arithmetic_group":
                "((H wr S7) x (H wr S7)) x "
                "(S5 x C2 x C2 x C2_RR)",
        })

    print(json.dumps({
        "base_field": "GF(8)",
        "representatives": orbit_rows,
        "translation_invariance":
            "the four q=64 layers in each block are seed-stabilizer "
            "translates of its frozen representative",
        "group":
            "((H wr S7) x (H wr S7)) x "
            "(S5 x C2 x C2 x C2_RR)",
        "H": "S5 x C2 x C2",
        "conclusion":
            "all three exceptional q=64 blocks retain the full generic "
            "joint geometric and arithmetic group",
        "status":
            "q=64 completeness is wholly a small-field arithmetic exception; "
            "the three blocks lie on no joint-monodromy-drop locus",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
