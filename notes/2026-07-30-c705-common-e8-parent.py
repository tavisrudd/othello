#!/usr/bin/env python3
"""Exact certificate for the common affine-E8 mixed-potential parent.

The degree-ten paired-McKay return reconstructs the conference operator.
Its six outer middle-exterior diagonals are the Joubert cubics Z_T.  This
checker forms the quotient potential

    P(x, eta) = sum_{T<5} eta_T (Z_T(x) - Z_5(x))

and verifies that its mixed Hessian is the C705 matrix A, with canonical
quadratic null sections q and W and adj(A)=6 W q^T.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-30-c705-common-e8-parent.json"
C705_SCRIPT = ROOT / "2026-07-30-c705-adjugate-segre-igusa-polar.py"


def load_c705():
    spec = importlib.util.spec_from_file_location("c705_adjugate", C705_SCRIPT)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


C705 = load_c705()
C704 = C705.C704


def derivative(poly, variable):
    result = {}
    for exponent, coefficient in poly.items():
        if exponent[variable]:
            reduced = list(exponent)
            reduced[variable] -= 1
            reduced = tuple(reduced)
            result[reduced] = result.get(reduced, 0) + coefficient * exponent[variable]
    return {exponent: coefficient for exponent, coefficient in result.items() if coefficient}


def build_potential(quotient_cubics):
    potential = {}
    for outer, cubic in enumerate(quotient_cubics):
        for exponent, coefficient in cubic.items():
            full = exponent + tuple(int(index == outer) for index in range(5))
            potential[full] = potential.get(full, 0) + coefficient
    return {exponent: coefficient for exponent, coefficient in potential.items() if coefficient}


def lift_five_variable_poly(poly, side):
    assert side in ("source", "target")
    zero = (0,) * 5
    return {
        (exponent + zero if side == "source" else zero + exponent): coefficient
        for exponent, coefficient in poly.items()
    }


def compute():
    c704_certificate = C704.build_certificate()
    shadows = C705.oriented_shadows()
    z_polys = [C704.cubic_poly(cubic) for _, cubic in shadows]
    quotient_cubics = [
        C704.add(z_polys[outer], C704.scale(z_polys[5], -1))
        for outer in range(5)
    ]
    potential = build_potential(quotient_cubics)

    mixed_hessian = [
        [derivative(derivative(potential, source), 5 + outer) for outer in range(5)]
        for source in range(5)
    ]
    expected = [
        [C705.derivative(quotient_cubics[outer], source) for outer in range(5)]
        for source in range(5)
    ]
    assert mixed_hessian == [
        [lift_five_variable_poly(entry, "source") for entry in row] for row in expected
    ]

    source_q = C705.centered_squares(list(C704.VARS), poly_mode=True)[:5]
    outer_w = C705.centered_squares(z_polys, poly_mode=True)[:5]
    source_kernel_checks = 0
    for outer in range(5):
        assert not C704.add(
            *(C704.mul(expected[source][outer], source_q[source]) for source in range(5))
        )
        source_kernel_checks += 1
    target_kernel_checks = 0
    for source in range(5):
        assert not C704.add(
            *(C704.mul(expected[source][outer], outer_w[outer]) for outer in range(5))
        )
        target_kernel_checks += 1

    adjugate = C705.jacobian_adjugate_certificate(z_polys)
    assert adjugate["adjugate_factorization"] == "adj(A)=6*W*q^T"

    return {
        "schema": "c705-common-e8-parent-v1",
        "parent": (
            "P(x,eta)=sum_{T<5} eta_T (Z_T(x)-Z_5(x)), with Z_T the "
            "diagonal of the six outer conjugates of *Lambda^3(C)"
        ),
        "paired_e8_input": (
            "the degree-ten paired-McKay return reconstructs C and its "
            "six-axis integral support lattice"
        ),
        "source_carrier": "A_X=Z^6/Z*1, rank 5",
        "target_carrier": "outer augmentation on six synthematic totals, rank 5",
        "potential_bidegree": [3, 1],
        "potential_term_count_after_augmentation_quotients": len(potential),
        "mixed_hessian_shape": [5, 5],
        "mixed_hessian_entries_checked": 25,
        "source_quadratic_null_checks": source_kernel_checks,
        "target_quadratic_null_checks": target_kernel_checks,
        "source_null_section": "q=center_X(x^2)",
        "target_null_section": "W=center_T(Z^2)",
        "adjugate_factorization": adjugate["adjugate_factorization"],
        "generic_rank": adjugate["generic_rank"],
        "arithmetic_boundary": adjugate["characteristic_rank_witnesses"],
        "upstairs_support_recovery": {
            "middle_exterior_square": c704_certificate["middle_exterior_square"],
            "middle_exterior_diagonal": c704_certificate["middle_exterior_diagonal"],
            "middle_exterior_mod2_relation": c704_certificate[
                "middle_exterior_mod2_relation"
            ],
            "outer_action_size": c704_certificate["outer_action_size"],
            "synthematic_totals": c704_certificate["synthematic_totals"],
        },
        "strata_dictionary": {
            "ten_segre_nodes": (
                "complementary pairs of triples in the recovered J(6,3) support; "
                "the mixed Hessian has rank 1 at their ten 3+3 preimages"
            ),
            "fifteen_planes_and_lines": (
                "the fifteen matchings/synthemes of the recovered six-axis set"
            ),
            "bad_characteristic_2": "support survives mod 2 but signs coalesce",
            "bad_characteristic_3": "the scalar 6 kills the fourth-compound extraction",
            "bad_characteristic_5": "golden projectors ramify while the descended mixed potential remains rank 4",
        },
        "scope": (
            "affine-E8 paired-McKay/operator parent; no identification with "
            "the Lie-E8 root lattice or Weyl representation is asserted"
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = compute()
    text = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(text)
    elif args.check:
        if not OUTPUT.exists() or OUTPUT.read_text() != text:
            raise SystemExit(f"certificate mismatch: regenerate with {Path(__file__).name} --write")
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
