#!/usr/bin/env python3
"""Check the Cox-weight lattice and smooth-moduli tangent cover."""

import argparse
import itertools
import json
import sys
from pathlib import Path

import sympy as sp

if sys.flags.optimize:
    raise RuntimeError("verification must run with Python assertions enabled")


def build_certificate():
    a, b, localizer = sp.symbols("a b localizer")
    source = json.loads(Path(__file__).with_name("slice-cover-certificate.json").read_text())
    parse = {"a": a, "b": b}
    determinants = [sp.sympify(value, locals=parse) for value in source[
        "symbolic_four_hyperplane_evaluation_determinants"
    ]]
    minors = [sp.sympify(value, locals=parse) for value in source[
        "symbolic_tangent_smoothness_minors"
    ]]
    determinant_numerators = [sp.together(value).as_numer_denom()[0] for value in determinants]
    minor_numerators = [sp.together(value).as_numer_denom()[0] for value in minors]
    delta = a*b*(a-1)*(b-1)*(a-b)

    survivors = []
    branch_outcomes = []
    for choices in itertools.product((0, 1), repeat=3):
        branch = [
            (minor_numerators if choice else determinant_numerators)[index]
            for index, choice in enumerate(choices)
        ]
        basis = sp.groebner(
            branch+[localizer*delta-1], localizer, a, b, order="lex"
        )
        empty = any(polynomial.as_expr() == 1 for polynomial in basis.polys)
        branch_outcomes.append({
            "chosen_zero_factors": "".join("M" if choice else "D" for choice in choices),
            "localized_zero_locus": "empty" if empty else "survives",
        })
        if not empty:
            survivors.append({
                "zero_choice_0_D_1_M": list(choices),
                "smooth_localized_elimination_basis": [
                    str(sp.factor(polynomial.as_expr())) for polynomial in basis.polys[-2:]
                ],
            })

    first = 31223016*b**2-435944529*b+1306078948
    second = (3*b-26)*(3*b-13)
    fourth_product = sp.together(determinants[3]*minors[3]).as_numer_denom()[0]
    fourth_on_line = sp.Poly(fourth_product.subs(a, (b+2)/3), b).primitive()[1]
    fourth_factor = sp.factor(fourth_on_line.as_expr())
    fourth_quadratic = 83246*b**2-872181*b+2185995
    bezout_left = 2265746679974131615-377042650728395274*b
    bezout_right = 141417109727495582904*b-1342668830289072756147
    bezout_constant = 24176690547344887359179755
    assert sp.expand(bezout_left*first+bezout_right*fourth_quadratic) == bezout_constant
    checks = {
        "first_survivor_at_17_over_4": first.subs(b, sp.Rational(17, 4)),
        "first_survivor_at_85_over_16": first.subs(b, sp.Rational(85, 16)),
        "fourth_quadratic_at_13_over_3": fourth_quadratic.subs(b, sp.Rational(13, 3)),
        "fourth_quadratic_at_26_over_3": fourth_quadratic.subs(b, sp.Rational(26, 3)),
        "quadratic_resultant": sp.resultant(first, fourth_quadratic, b),
    }
    assert sp.gcd(fourth_on_line, sp.Poly(first*second, b)).degree() == 0

    weight_differences = sp.Matrix(source["weight_difference_matrix"])
    assert abs(int(weight_differences.det())) == 1
    coefficient_matrix = sp.Matrix([
        [sp.Rational(value) for value in row]
        for row in source["slice_coefficient_matrix"]
    ])
    maximal_minors = [
        coefficient_matrix[:, [column for column in range(4) if column != omitted]].det()
        for omitted in range(4)
    ]
    assert coefficient_matrix.rank() == 3
    assert all(value != 0 for value in maximal_minors)

    return {
        "bezout_identity": {
            "left_coefficient": str(bezout_left),
            "right_coefficient": str(bezout_right),
            "constant": str(bezout_constant),
        },
        "corrected_first_three_branch_survivors": survivors,
        "first_three_branch_outcomes": branch_outcomes,
        "fourth_product_on_survivor_line_factorization": str(fourth_factor),
        "human_coprimality_checks": {key: str(value) for key, value in checks.items()},
        "schema": source["schema"],
        "symbolic_four_hyperplane_evaluation_determinants": source[
            "symbolic_four_hyperplane_evaluation_determinants"
        ],
        "symbolic_tangent_smoothness_minors": source[
            "symbolic_tangent_smoothness_minors"
        ],
        "tangent_orbit_witnesses": source["tangent_orbit_witnesses"],
        "weight_difference_matrix": source["weight_difference_matrix"],
        "slice_coefficient_matrix": source["slice_coefficient_matrix"],
    }


parser = argparse.ArgumentParser()
parser.add_argument("--check-certificate", type=Path, required=True)
arguments = parser.parse_args()
expected = json.loads(arguments.check_certificate.read_text())
actual = build_certificate()
if actual != expected:
    for key in sorted(set(actual) | set(expected)):
        if actual.get(key) != expected.get(key):
            print(f"certificate mismatch: {key}")
            print(" expected:", expected.get(key))
            print(" actual:  ", actual.get(key))
    raise AssertionError("certificate mismatch")
print("slice-cover certificate: ok")
