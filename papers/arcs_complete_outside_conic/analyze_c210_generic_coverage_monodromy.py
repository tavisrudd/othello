#!/usr/bin/env python3
"""Certify the generic C210 coverage monodromy witnesses.

The coefficient-parametric seed--repair resultant has degree seven away from
``y1=0`` and degree six on that boundary for at least one seed color.  This
checker supplies the finite specializations used to force transposition
inertia in both covers and a 5-cycle in the boundary cover.  It also checks
that the ramified repair parameters avoid the branch support of the existing
one-repair collision covers and records the resulting wreath-product density.

The accompanying audit gives the geometric argument: the incidence source is
rational (hence geometrically irreducible), the generic seed parameter is
recovered linearly from the two coverage equations, and a connected prime-
degree cover containing a transposition has full symmetric monodromy.  On the
degree-six boundary, the certified 5-cycle rules out an imprimitive block
system; primitivity plus a transposition again gives the full symmetric group.
"""

from __future__ import annotations

import json
import math
from fractions import Fraction
from pathlib import Path

from analyze_c210_persistent_singletons import (
    coverage_equations,
    factor,
    poly_divmod,
    poly_value,
    sylvester_resultant,
    t_gcd_modulus,
)
from analyze_c210_residue_hypergraph import build_context
from analyze_c210_symbolic_coverage_resultant import (
    poly_derivative,
    poly_gcd,
    tau_exponents,
)


def normalized(field, poly: tuple[int, ...]) -> tuple[int, ...]:
    inverse = field.inv(poly[-1])
    return tuple(field.mul(coefficient, inverse) for coefficient in poly)


def exact_double_root_witness(
    context,
    seed_height: int,
    target: tuple[int, int, int, int],
    root: int,
) -> dict[str, object]:
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
    resultant = sylvester_resultant(field, *equations)
    gcd = normalized(field, poly_gcd(field, resultant, poly_derivative(resultant)))
    expected_gcd = (field.mul(root, root), 0, 1)
    assert gcd == expected_gcd

    quotient, remainder = poly_divmod(field, resultant, gcd)
    assert not remainder
    assert poly_value(field, quotient, root) != 0
    assert len(poly_gcd(field, quotient, poly_derivative(quotient))) == 1

    # The common seed parameter is unique at the doubled repair root.  Thus
    # the multiplicity two is one ramified incidence point, not two distinct
    # source points with the same resultant root.
    t_gcd = t_gcd_modulus(field, (root, 1), equations[:3], equations[3:])
    assert len(t_gcd) == 2
    t_value = 0 if not t_gcd[0] else t_gcd[0][0]
    assert t_gcd[1] == (1,)

    return {
        "target_tau_exponents": tau_exponents(context, target),
        "repair_root_tau_exponent": tau_exponents(context, (root,))[0],
        "seed_parameter_tau_exponent": tau_exponents(context, (t_value,))[0],
        "resultant_degree": len(resultant) - 1,
        "resultant_coefficients_tau_exponents": tau_exponents(context, resultant),
        "derivative_gcd": "(r+root)^2",
        "residual_factor_squarefree_and_avoids_root": True,
        "unique_incidence_point_above_double_root": True,
    }


def boundary_five_cycle_witness(context) -> dict[str, object]:
    field = context.ambient
    target = (0, 0, 0, 1)
    equations = coverage_equations(
        field,
        context.coordinates,
        context.eta0,
        context.eta1,
        context.a1,
        context.b1,
        context.c0,
        context.c1,
        context.alpha,
        *target,
    )
    resultant = sylvester_resultant(field, *equations)
    assert len(resultant) == 7
    assert len(poly_gcd(field, resultant, poly_derivative(resultant))) == 1
    factors = factor(field, context.base_values, resultant)
    assert [len(poly) - 1 for poly in factors] == [1, 5]

    # Both residue factors recover one linear seed parameter.  In particular,
    # the degree-five factor is a genuine 5-cycle of the incidence cover, not
    # an artifact of forgetting a quadratic seed coordinate.
    t_degrees = []
    for modulus in factors:
        t_gcd = t_gcd_modulus(field, modulus, equations[:3], equations[3:])
        t_degrees.append(len(t_gcd) - 1)
    assert t_degrees == [1, 1]

    return {
        "target_tau_exponents": tau_exponents(context, target),
        "resultant_coefficients_tau_exponents": tau_exponents(context, resultant),
        "factor_degrees": [1, 5],
        "squarefree": True,
        "seed_parameter_degree_over_each_repair_residue_field": t_degrees,
        "frobenius_cycle_type": [5, 1],
    }


def generic_linear_recovery_witness(context) -> dict[str, object]:
    """Exhibit a degree-seven fiber with one seed coordinate over every root."""

    field = context.ambient
    target = (
        1,
        field.power(context.tau, 5),
        field.power(context.tau, 2),
        1,
    )
    equations = coverage_equations(
        field,
        context.coordinates,
        context.eta0,
        context.eta1,
        context.a1,
        context.b1,
        context.c0,
        context.c1,
        context.alpha,
        *target,
    )
    resultant = sylvester_resultant(field, *equations)
    factors = factor(field, context.base_values, resultant)
    assert [len(poly) - 1 for poly in factors] == [7]
    t_gcd = t_gcd_modulus(field, factors[0], equations[:3], equations[3:])
    assert len(t_gcd) == 2
    return {
        "target_tau_exponents": tau_exponents(context, target),
        "repair_factor_degrees": [7],
        "seed_parameter_degree_over_repair_residue_field": len(t_gcd) - 1,
    }


def success_density(degree: int) -> Fraction:
    """Density of a rational, one-repair-legal sheet in H wr S_degree."""

    legal_fraction = Fraction(11, 120)
    # The fixed-point probability generating function for S_n is
    # sum_{j=0}^n (x-1)^j/j!.  Substitute x=1-legal_fraction.
    no_legal_sheet = sum(
        ((-legal_fraction) ** j / math.factorial(j) for j in range(degree + 1)),
        Fraction(),
    )
    return 1 - no_legal_sheet


def main() -> None:
    context = build_context(1)
    field = context.ambient

    trace_data = json.loads(Path(__file__).with_name(
        "analyze_c210_remaining_trace_orbits_output.txt"
    ).read_text())
    orbit = next(row for row in trace_data["orbits"] if row["orbit"] == 1)
    same_seed_poles = {
        0 if exponent is None else field.power(context.tau, exponent)
        for collision in orbit["collisions"]
        for exponent in collision["p_roots"]
    }
    assert len(same_seed_poles) == 4

    # Interior degree-seven branch: target=(0,1,0,tau^4), r=tau^5.
    interior_root = field.power(context.tau, 5)
    interior = exact_double_root_witness(
        context,
        context.alpha,
        (0, 1, 0, field.power(context.tau, 4)),
        interior_root,
    )
    assert interior["resultant_degree"] == 7

    # Boundary degree-six branch: target=(0,0,1,1), r=tau^3.
    boundary_root = field.power(context.tau, 3)
    boundary = exact_double_root_witness(
        context,
        context.alpha,
        (0, 0, 1, 1),
        boundary_root,
    )
    assert boundary["resultant_degree"] == 6

    # The mixed S5 branch values are outside GF(8), while these two roots lie
    # in GF(8).  Avoiding the four same-seed poles therefore makes both
    # coverage transpositions unramified in the full collision compositum.
    assert interior_root not in same_seed_poles
    assert boundary_root not in same_seed_poles

    density7 = success_density(7)
    density6 = success_density(6)
    collision_group_order = 120 * 2 * 2
    assert collision_group_order == 480

    print(json.dumps({
        "base_specialization": "GF(8), orbit 1, seed A",
        "generic_incidence_source":
            "rational in (repair r, seed t, target y0, target y1)",
        "generic_seed_parameter_recovery":
            "linear after eliminating t^2 from the two coordinate equations",
        "linear_recovery_specialization":
            generic_linear_recovery_witness(context),
        "degree_7_branch_witness": interior,
        "degree_7_geometric_monodromy": "S7",
        "degree_7_arithmetic_monodromy": "S7",
        "degree_6_boundary_branch_witness": boundary,
        "degree_6_boundary_five_cycle_witness":
            boundary_five_cycle_witness(context),
        "degree_6_geometric_monodromy": "S6",
        "degree_6_arithmetic_monodromy": "S6",
        "one_repair_collision_group": "H=S5 x C2 x C2",
        "collision_group_order": collision_group_order,
        "same_seed_poles_tau_exponents": sorted(
            tau_exponents(context, tuple(same_seed_poles)),
            key=lambda value: -1 if value is None else value,
        ),
        "mixed_collision_branch_values": "outside GF(8)",
        "coverage_branch_disjoint_from_collision_branch_support": True,
        "generic_composed_groups": {
            "degree_7_stratum": "H wr S7",
            "degree_6_boundary_stratum": "H wr S6",
        },
        "one_seed_color_legal_candidate_density": {
            "degree_7": str(density7),
            "degree_7_decimal": float(density7),
            "degree_6": str(density6),
            "degree_6_decimal": float(density6),
        },
        "status":
            "generic coverage and one-repair legality are wreath-independent; "
            "joint seed-color and seed-only coverage monodromy is next",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
