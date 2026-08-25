#!/usr/bin/env python3
"""Derive the type-I3 lattice and tangent-section certificate from raw data.

The inputs transcribed here are the two type-I3 character matrices and the
twenty Cox quadrics from Tschinkel--Zhang, Sections 3--4.  Everything stored
in ``slice-cover-certificate.json`` is recomputed from those inputs and the
four witness triples printed in the manuscript.
"""

import argparse
import itertools
import json
import re
import sys
from pathlib import Path

import sympy as sp

if sys.flags.optimize:
    raise RuntimeError("verification must run with Python assertions enabled")


CHARACTER_GENERATORS = (
    sp.Matrix([
        [-1, 0, 0, -1, -1],
        [1, 1, 1, 0, 2],
        [0, 0, -1, -1, -1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 1, 0],
    ]),
    sp.Matrix([
        [0, 1, 1, 1, 2],
        [-1, -1, 0, 0, -1],
        [0, 0, 1, 0, 0],
        [0, 0, 0, 1, 0],
        [0, 0, -1, -1, -1],
    ]),
)
COCHARACTER_GENERATORS = tuple(
    generator.inv().T for generator in CHARACTER_GENERATORS
)
ROOT_BASIS = sp.Matrix.hstack(
    sp.Matrix([0, 1, 0, 0, 0, -1]),
    sp.Matrix([0, 0, 1, 0, 0, -1]),
    sp.Matrix([0, 0, 0, 1, 0, -1]),
    sp.Matrix([0, 0, 0, 0, 1, -1]),
    sp.Matrix([1, 0, 0, 0, 0, -3]),
)


def matrix_key(matrix):
    return tuple(int(entry) for entry in matrix)


def affine_weight_action(points, linear_action):
    """Recover the affine action on projective weights."""
    dual = linear_action.inv().T
    origin = sp.Matrix(points[0])
    point_set = set(points)
    for target in map(sp.Matrix, points):
        shift = target - dual * origin
        images = [tuple(dual * sp.Matrix(point) + shift) for point in points]
        if set(images) == point_set:
            return dict(zip(points, images))
    raise AssertionError("projective weight set is not preserved")


def type_i3_lattice_data():
    """Derive the saturated subtorus, Cox weights, and residual rank."""
    group = {matrix_key(sp.eye(5)): sp.eye(5)}
    queue = [sp.eye(5)]
    while queue:
        value = queue.pop()
        for generator in COCHARACTER_GENERATORS:
            for product in (value * generator, generator * value):
                key = matrix_key(product)
                if key not in group:
                    group[key] = product
                    queue.append(product)
    assert len(group) == 24

    cox_classes = []
    cox_names = []
    for index in range(5):
        divisor = [0] * 6
        divisor[index + 1] = 1
        cox_classes.append(sp.Matrix(divisor))
        cox_names.append(f"E{index + 1}")
    for left in range(5):
        for right in range(left + 1, 5):
            divisor = [1] + [0] * 5
            divisor[left + 1] = divisor[right + 1] = -1
            cox_classes.append(sp.Matrix(divisor))
            cox_names.append(f"L{left + 1}{right + 1}")
    cox_classes.append(sp.Matrix([2, -1, -1, -1, -1, -1]))
    cox_names.append("Q")

    rank_three_basis = sp.Matrix.hstack(
        sp.eye(5).col(2), sp.eye(5).col(3), sp.eye(5).col(4)
    )
    left_inverse = rank_three_basis.T
    actions = [
        left_inverse * generator * rank_three_basis
        for generator in COCHARACTER_GENERATORS
    ]
    assert all(
        rank_three_basis * action == generator * rank_three_basis
        for action, generator in zip(actions, COCHARACTER_GENERATORS)
    )
    assert actions == [
        sp.Matrix([[-1, 0, 0], [-1, 0, 1], [-1, 1, 0]]),
        sp.Matrix([[1, 0, -1], [0, 1, -1], [0, 0, -1]]),
    ]

    lifts = []
    for column in range(3):
        variables = sp.symbols("u0:6")
        equations = [
            sum(
                variables[row] * ROOT_BASIS[row, root]
                for row in range(6)
            ) - rank_three_basis[root, column]
            for root in range(5)
        ] + [variables[5]]
        solution = next(iter(sp.linsolve(equations, variables)))
        assert all(entry.q == 1 for entry in solution)
        lifts.append(sp.Matrix(1, 6, solution))

    raw_weights = [
        tuple(int((lift * divisor)[0]) for lift in lifts)
        for divisor in cox_classes
    ]
    minima = tuple(min(weight[i] for weight in raw_weights) for i in range(3))
    weights = [
        tuple(weight[i] - minima[i] for i in range(3))
        for weight in raw_weights
    ]
    blocks = {
        weight: [
            name for name, value in zip(cox_names, weights) if value == weight
        ]
        for weight in sorted(set(weights))
    }
    window_weights = ((0, 1, 1), (1, 0, 1), (1, 1, 0), (1, 1, 1))
    window_blocks = [blocks[weight] for weight in window_weights]
    assert window_blocks == [
        ["L13", "L23", "L35"],
        ["L14", "L24", "L45"],
        ["E1", "E2", "E5"],
        ["L12", "L15", "L25"],
    ]
    affine_actions = [affine_weight_action(sorted(blocks), action) for action in actions]
    assert all(
        {action[weight] for weight in window_weights} == set(window_weights)
        for action in affine_actions
    )
    difference_matrix = sp.Matrix.hstack(*(
        sp.Matrix(weight) - sp.Matrix(window_weights[0])
        for weight in window_weights[1:]
    ))
    assert abs(int(difference_matrix.det())) == 1
    boundary = sorted(
        name
        for weight in set(blocks) - set(window_weights)
        for name in blocks[weight]
    )
    assert boundary == ["E3", "E4", "L34", "Q"]

    completion = sp.Matrix.hstack(
        rank_three_basis, sp.eye(5).col(0), sp.eye(5).col(1)
    )
    assert abs(int(completion.det())) == 1
    residual_actions = []
    for generator in COCHARACTER_GENERATORS:
        changed = completion.inv() * generator * completion
        assert changed[3:5, 0:3] == sp.zeros(2, 3)
        residual_actions.append(changed[3:5, 3:5].inv().T)
    assert all(matrix.det() in (-1, 1) for matrix in residual_actions)
    return {
        "cox_names": cox_names,
        "difference_matrix": difference_matrix,
        "type_i3_action_matrices": actions,
        "selected_weight_blocks": [
            {"weight": list(weight), "generators": blocks[weight]}
            for weight in window_weights
        ],
        "boundary_generators": boundary,
    }


def cox_data(cox_names):
    """Build the Cox quadrics, their parametrized point, and Jacobian."""
    a, b, z1, z2, z3 = sp.symbols("a b z1 z2 z3")
    coordinates = sp.symbols(
        "e1 e2 e3 e4 e5 l12 l13 l14 l15 l23 l24 l25 l34 l35 l45 q"
    )
    (
        e1, e2, e3, e4, e5, l12, l13, l14, l15,
        l23, l24, l25, l34, l35, l45, q,
    ) = coordinates
    relations = [
        e2*l12-e3*l13+e4*l14,
        a*e2*l12-b*e3*l13+e5*l15,
        e1*l12-e3*l23+e4*l24,
        e1*l12-b*e3*l23+e5*l25,
        e1*l13-e2*l23+e4*l34,
        e1*l13-a*e2*l23+e5*l35,
        e1*l14-e2*l24+e3*l34,
        (b-1)*e1*l14+(a-b)*e2*l24+e5*l45,
        e1*l15-a*e2*l25+b*e3*l35,
        (a-1)*e2*l25+(1-b)*e3*l35+e4*l45,
        l23*l45+l24*l35-l25*l34,
        a*l23*l45+(a-b)*l24*l35-e1*q,
        l13*l45+l14*l35-l15*l34,
        l13*l45+(1-b)*l14*l35-e2*q,
        l12*l45+l14*l25-l15*l24,
        l12*l45+(1-a)*l14*l25-e3*q,
        l12*l35-l13*l25+l15*l23,
        (b-1)*l12*l35+(1-a)*l13*l25-e4*q,
        l12*l34-l13*l24+l14*l23,
        a*(b-1)*l12*l34+b*(1-a)*l13*l24-e5*q,
    ]
    point = {
        e1: 1, e2: 1, e3: 1, e4: 1, e5: 1,
        l12: z3, l13: z2, l14: z2-z3, l15: b*z2-a*z3,
        l23: z1, l24: z1-z3, l25: b*z1-z3, l34: z1-z2,
        l35: a*z1-z2,
        l45: (b-a)*z1+(1-b)*z2+(a-1)*z3,
        q: b*(1-a)*z1*z2+a*(b-1)*z1*z3+(a-b)*z2*z3,
    }
    assert all(sp.factor(relation.subs(point)) == 0 for relation in relations)
    jacobian = sp.Matrix(relations).jacobian(coordinates).subs(point)
    rows = (0, 1, 2, 3, 4, 5, 7, 11)
    columns = tuple(
        cox_names.index(name)
        for name in ("E1", "E2", "E5", "L12", "L13", "L14", "L15", "L23")
    )
    minor = sp.factor(jacobian.extract(rows, columns).det())
    assert minor != 0
    return (a, b, z1, z2, z3), coordinates, relations, jacobian, rows, minor


def build_certificate():
    lattice = type_i3_lattice_data()
    cox_names = lattice["cox_names"]
    difference_matrix = lattice["difference_matrix"]
    symbols, coordinates, relations, jacobian, rows, tangent_minor = cox_data(cox_names)
    a, b, z1, z2, z3 = symbols
    coordinate_by_name = dict(zip(cox_names, coordinates))
    boundary_indices = [cox_names.index(name) for name in ("E3", "E4", "L34", "Q")]
    window_blocks = [
        ["E1", "E2", "E5"],
        ["L14", "L24", "L45"],
        ["L13", "L23", "L35"],
        ["L12", "L15", "L25"],
    ]

    def slice_data(tangent_z, orbit_e, orbit_z):
        tangent_rows = jacobian[list(rows), :].subs(dict(zip((z1, z2, z3), tangent_z)))
        coefficient_basis = tangent_rows[:, boundary_indices].T.nullspace()
        assert len(coefficient_basis) == 4
        hyperplanes = [coefficient.T * tangent_rows for coefficient in coefficient_basis]
        ee1, ee2, ee3, ee4, ee5 = orbit_e
        zz1, zz2, zz3 = orbit_z
        values = {
            coordinate_by_name["E1"]: ee1,
            coordinate_by_name["E2"]: ee2,
            coordinate_by_name["E3"]: ee3,
            coordinate_by_name["E4"]: ee4,
            coordinate_by_name["E5"]: ee5,
            coordinate_by_name["L12"]: sp.Rational(zz3, ee1*ee2),
            coordinate_by_name["L13"]: sp.Rational(zz2, ee1*ee3),
            coordinate_by_name["L14"]: sp.Rational(zz2-zz3, ee1*ee4),
            coordinate_by_name["L15"]: (b*zz2-a*zz3)/(ee1*ee5),
            coordinate_by_name["L23"]: sp.Rational(zz1, ee2*ee3),
            coordinate_by_name["L24"]: sp.Rational(zz1-zz3, ee2*ee4),
            coordinate_by_name["L25"]: (b*zz1-zz3)/(ee2*ee5),
            coordinate_by_name["L34"]: sp.Rational(zz1-zz2, ee3*ee4),
            coordinate_by_name["L35"]: (a*zz1-zz2)/(ee3*ee5),
            coordinate_by_name["L45"]: (
                (b-a)*zz1+(1-b)*zz2+(a-1)*zz3
            )/(ee4*ee5),
            coordinate_by_name["Q"]: (
                b*(1-a)*zz1*zz2+a*(b-1)*zz1*zz3+(a-b)*zz2*zz3
            )/(ee1*ee2*ee3*ee4*ee5),
        }
        assert all(sp.factor(relation.subs(values)) == 0 for relation in relations)
        matrix = sp.Matrix([
            [
                sum(
                    hyperplane[cox_names.index(name)] * values[coordinate_by_name[name]]
                    for name in block
                )
                for block in window_blocks
            ]
            for hyperplane in hyperplanes
        ])
        determinant = sp.factor(matrix.det())
        minor = sp.factor(tangent_minor.subs(dict(zip((z1, z2, z3), tangent_z))))
        return determinant, minor, hyperplanes, values, matrix

    witnesses = [
        ((1, 3, 7), (2, 3, 5, 7, 11), (2, 4, 9)),
        ((2, 5, 11), (3, 4, 7, 13, 17), (1, 6, 10)),
        ((3, 8, 13), (5, 7, 11, 17, 19), (2, 9, 15)),
        ((4, 9, 17), (2, 5, 11, 19, 23), (3, 10, 18)),
    ]
    derived = [slice_data(*witness) for witness in witnesses]
    determinants = [item[0] for item in derived]
    minors = [item[1] for item in derived]

    localizer = sp.symbols("localizer")
    delta = a*b*(a-1)*(b-1)*(a-b)
    determinant_numerators = [sp.together(value).as_numer_denom()[0] for value in determinants]
    minor_numerators = [sp.together(value).as_numer_denom()[0] for value in minors]
    survivors = []
    outcomes = []
    for choices in itertools.product((0, 1), repeat=3):
        branch = [
            (minor_numerators if choice else determinant_numerators)[index]
            for index, choice in enumerate(choices)
        ]
        basis = sp.groebner(branch + [localizer*delta-1], localizer, a, b, order="lex")
        empty = any(polynomial.as_expr() == 1 for polynomial in basis.polys)
        outcomes.append({
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

    first_hyperplanes = derived[0][2]
    first_values = derived[0][3]
    first_evaluation = derived[0][4]
    coefficient_matrix = sp.Matrix([
        [-1, 1, 0, 0],
        [-1, 0, 1, 0],
        [-1, 0, 0, 1],
    ])
    hyperplane_combinations = coefficient_matrix * first_evaluation.inv()
    slice_hyperplanes = [
        sum(
            (
                hyperplane_combinations[row, column] * first_hyperplanes[column]
                for column in range(4)
            ),
            sp.zeros(1, len(cox_names)),
        )
        for row in range(3)
    ]
    assert (
        hyperplane_combinations * first_evaluation - coefficient_matrix
    ).applyfunc(sp.factor) == sp.zeros(3, 4)
    assert all(
        sp.factor(sum(
            hyperplane[cox_names.index(name)] * first_values[coordinate_by_name[name]]
            for name in cox_names
        )) == 0
        for hyperplane in slice_hyperplanes
    )
    maximal_minors = [
        coefficient_matrix[:, [column for column in range(4) if column != omitted]].det()
        for omitted in range(4)
    ]
    assert coefficient_matrix.rank() == 3 and all(value != 0 for value in maximal_minors)

    return {
        "bezout_identity": {
            "left_coefficient": str(bezout_left),
            "right_coefficient": str(bezout_right),
            "constant": str(bezout_constant),
        },
        "corrected_first_three_branch_survivors": survivors,
        "first_three_branch_outcomes": outcomes,
        "fourth_product_on_survivor_line_factorization": str(fourth_factor),
        "human_coprimality_checks": {key: str(value) for key, value in checks.items()},
        "schema": "quartic-del-pezzo-two-variable-slice-cover-v4",
        "type_i3_action_matrices": [
            [[int(entry) for entry in matrix.row(row)] for row in range(3)]
            for matrix in lattice["type_i3_action_matrices"]
        ],
        "selected_weight_blocks": lattice["selected_weight_blocks"],
        "boundary_generators": lattice["boundary_generators"],
        "symbolic_four_hyperplane_evaluation_determinants": [str(value) for value in determinants],
        "symbolic_tangent_smoothness_minors": [str(value) for value in minors],
        "tangent_orbit_witnesses": [
            {"tangent_z": list(tangent), "orbit_e": list(e), "orbit_z": list(z)}
            for tangent, e, z in witnesses
        ],
        "weight_difference_matrix": [
            [int(entry) for entry in difference_matrix.row(row)]
            for row in range(3)
        ],
        "slice_coefficient_matrix": [
            [str(entry) for entry in coefficient_matrix.row(row)]
            for row in range(3)
        ],
    }


def render_tex_artifact(certificate):
    """Render every computation-derived value printed in the manuscript."""
    a, b = sp.symbols("a b")
    parse = {"a": a, "b": b}
    determinants = [
        sp.sympify(value, locals=parse)
        for value in certificate["symbolic_four_hyperplane_evaluation_determinants"]
    ]
    minors = [
        sp.sympify(value, locals=parse)
        for value in certificate["symbolic_tangent_smoothness_minors"]
    ]
    determinant_numerators = []
    for value in determinants:
        numerator = sp.together(value).as_numer_denom()[0]
        determinant_numerators.append(sp.Poly(numerator, a, b).primitive()[1].as_expr())
    minor_numerators = [
        sp.together(value).as_numer_denom()[0] for value in minors
    ]

    def polynomial_rows(name, polynomial):
        terms = sp.Add.make_args(sp.expand(polynomial))
        terms = sorted(
            terms,
            key=lambda term: sp.Poly(term, a, b).monoms()[0],
            reverse=True,
        )
        rendered = []
        for index, term in enumerate(terms):
            sign = "-" if term.could_extract_minus_sign() else "+"
            body = sp.latex(-term if sign == "-" else term)
            if index == 0 and sign == "+":
                sign = ""
            rendered.append(sign + body)
        rows = [
            "".join(rendered[index:index + 3])
            for index in range(0, len(rendered), 3)
        ]
        return (
            f"{name}={{}}&" + rows[0]
            + "".join(r"\\" + "\n&" + row for row in rows[1:])
        )

    determinant_rows = []
    for index, value in enumerate(determinant_numerators, start=1):
        factored = sp.factor(value)
        if index == 1:
            determinant_rows.append(f"D_1={{}}&{sp.latex(factored)}")
        else:
            determinant_rows.append(polynomial_rows(f"D_{index}", value))
    minor_rows = [
        f"M_{index}={{}}&{sp.latex(sp.factor(value))}"
        for index, value in enumerate(minor_numerators, start=1)
    ]

    survivors = certificate["corrected_first_three_branch_survivors"]
    first_basis = survivors[0]["smooth_localized_elimination_basis"]
    q0 = sp.sympify(first_basis[1], locals=parse)
    fourth_factor = sp.sympify(
        certificate["fourth_product_on_survivor_line_factorization"],
        locals=parse,
    )
    q4_candidates = [
        factor
        for factor, _multiplicity in sp.factor_list(fourth_factor)[1]
        if sp.Poly(factor, b).degree() == 2
    ]
    assert len(q4_candidates) == 1
    q4 = q4_candidates[0]
    checks = certificate["human_coprimality_checks"]
    bezout = certificate["bezout_identity"]
    left = sp.sympify(bezout["left_coefficient"], locals=parse)
    right = sp.sympify(bezout["right_coefficient"], locals=parse)

    action_matrices = [
        sp.latex(sp.Matrix(matrix)) for matrix in certificate["type_i3_action_matrices"]
    ]
    block_rows = []
    for block in certificate["selected_weight_blocks"]:
        weight = ",".join(str(value) for value in block["weight"])
        generators = ",".join(
            re.sub(r"([A-Z]+)([0-9]+)$", r"\1_{\2}", name)
            for name in block["generators"]
        )
        block_rows.append(rf"$({weight})$ & ${generators}$\\")
    boundary = ",".join(
        re.sub(r"([A-Z]+)([0-9]+)$", r"\1_{\2}", name)
        for name in certificate["boundary_generators"]
    )
    witness_rows = []
    for index, witness in enumerate(certificate["tangent_orbit_witnesses"], start=1):
        tangent = ",".join(str(value) for value in witness["tangent_z"])
        orbit_e = ",".join(str(value) for value in witness["orbit_e"])
        orbit_z = ",".join(str(value) for value in witness["orbit_z"])
        witness_rows.append(rf"{index}&$({tangent})$&$({orbit_e})$&$({orbit_z})$\\")

    def branch_formula(code):
        return "".join(f"{letter}_{index}" for index, letter in enumerate(code, start=1))

    branch_rows = []
    outcomes = certificate["first_three_branch_outcomes"]
    for initial in ("D", "M"):
        empty_codes = [
            outcome["chosen_zero_factors"]
            for outcome in outcomes
            if outcome["localized_zero_locus"] == "empty"
            and outcome["chosen_zero_factors"].startswith(initial)
        ]
        if empty_codes:
            equations = ", ".join(branch_formula(code) for code in empty_codes)
            branch_rows.append(rf"${equations}$&empty\\")
    survivor_by_code = {
        "".join("M" if value else "D" for value in survivor["zero_choice_0_D_1_M"]):
            survivor["smooth_localized_elimination_basis"]
        for survivor in survivors
    }
    for outcome in outcomes:
        code = outcome["chosen_zero_factors"]
        if outcome["localized_zero_locus"] != "survives":
            continue
        basis = survivor_by_code[code]
        basis_expressions = [sp.sympify(value, locals=parse) for value in basis]
        locus = "=".join(
            "Q_0(b)" if sp.expand(value - q0) == 0 else sp.latex(value)
            for value in basis_expressions
        )
        branch_rows.append(rf"${branch_formula(code)}$&${locus}=0$\\")

    return "\n".join([
        "% Generated by verification/derive_slice_cover.py; do not edit by hand.",
        rf"\newcommand{{\IThreeActionOne}}{{{action_matrices[0]}}}",
        rf"\newcommand{{\IThreeActionTwo}}{{{action_matrices[1]}}}",
        r"\newcommand{\IThreeWeightTable}{%",
        r"\begin{tabular}{@{}cl@{}}",
        r"\toprule",
        r"weight & Cox generators\\",
        r"\midrule",
        *block_rows,
        r"\bottomrule",
        r"\end{tabular}%",
        r"}",
        rf"\newcommand{{\IThreeBoundaryGenerators}}{{{boundary}}}",
        r"\newcommand{\SliceWitnessTable}{%",
        r"\begin{tabular}{@{}ccll@{}}",
        r"\toprule",
        r"$i$&$z$&$e$&$z'$\\",
        r"\midrule",
        *witness_rows,
        r"\bottomrule",
        r"\end{tabular}%",
        r"}",
        r"\newcommand{\SliceDeterminants}{%",
        r"\begin{align*}",
        (r",\\" + "\n").join(determinant_rows) + ".",
        r"\end{align*}",
        r"}",
        r"\newcommand{\SliceMinors}{%",
        r"\begin{align*}",
        (r",\\" + "\n").join(minor_rows) + ".",
        r"\end{align*}",
        r"}",
        r"\newcommand{\SliceCoverArithmetic}{%",
        r"\begin{center}",
        r"\begin{tabular}{@{}cc@{}}",
        r"\toprule",
        r"chosen equations & localized zero locus\\",
        r"\midrule",
        *branch_rows,
        r"\bottomrule",
        r"\end{tabular}",
        r"\end{center}",
        r"where",
        r"\[",
        f" Q_0(b)={sp.latex(q0)}.",
        r"\]",
        r"On the line $3a-b-2=0$, the primitive numerator of $D_4M_4$ is",
        r"\begin{align*}",
        f" &{sp.latex(fourth_factor)},\\\\",
        rf" Q_4(b)&={sp.latex(q4)}.",
        r"\end{align*}",
        r"The evaluations",
        r"\begin{align*}",
        rf" Q_0(17/4)&={sp.latex(sp.Rational(checks['first_survivor_at_17_over_4']))}, &",
        rf" Q_0(85/16)&={sp.latex(sp.Rational(checks['first_survivor_at_85_over_16']))},\\",
        rf" Q_4(26/3)&={sp.latex(sp.Rational(checks['fourth_quadratic_at_26_over_3']))}, &",
        rf" Q_4(13/3)&={sp.latex(sp.Rational(checks['fourth_quadratic_at_13_over_3']))}",
        r"\end{align*}",
        r"exclude the four linear roots.  Finally, the two quadratics are coprime by",
        r"the identity",
        r"\begingroup\small",
        r"\begin{align*}",
        rf" &\bigl({sp.latex(left)}\bigr)Q_0(b)\\",
        rf" &\quad +\bigl({sp.latex(right)}\bigr)Q_4(b)\\",
        rf" &={bezout['constant']}.",
        r"\end{align*}",
        r"\endgroup",
        r"}",
        "",
    ])


def verify_empty_branch_certificates(path, slice_certificate):
    """Verify retained identities for every localized branch marked empty."""
    retained = json.loads(path.read_text(encoding="utf-8"))
    assert retained["schema"] == "quartic-del-pezzo-groebner-empty-identities-v1"
    assert retained["variables"] == ["a", "b", "localizer"]
    a, b, localizer = sp.symbols("a b localizer")
    parse = {"a": a, "b": b, "localizer": localizer}
    determinants = [
        sp.sympify(value, locals=parse)
        for value in slice_certificate["symbolic_four_hyperplane_evaluation_determinants"]
    ]
    minors = [
        sp.sympify(value, locals=parse)
        for value in slice_certificate["symbolic_tangent_smoothness_minors"]
    ]
    determinant_numerators = [
        sp.together(value).as_numer_denom()[0] for value in determinants
    ]
    minor_numerators = [
        sp.together(value).as_numer_denom()[0] for value in minors
    ]
    delta = a * b * (a - 1) * (b - 1) * (a - b)
    empty_codes = {
        outcome["chosen_zero_factors"]
        for outcome in slice_certificate["first_three_branch_outcomes"]
        if outcome["localized_zero_locus"] == "empty"
    }
    assert set(retained["branches"]) == empty_codes
    for code, record in retained["branches"].items():
        generators = [
            (minor_numerators if choice == "M" else determinant_numerators)[position]
            for position, choice in enumerate(code)
        ] + [localizer * delta - 1]
        assert record["generators"] == [str(value) for value in generators]
        assert len(record["multipliers"]) == len(generators) == 4
        constant = sp.Integer(record["constant"])
        assert constant != 0
        multipliers = [
            sp.sympify(value, locals=parse) for value in record["multipliers"]
        ]
        assert sp.expand(
            sum(multiplier * generator for multiplier, generator in zip(
                multipliers, generators
            )) - constant
        ) == 0


parser = argparse.ArgumentParser()
mode = parser.add_mutually_exclusive_group(required=True)
mode.add_argument("--write-certificate", type=Path)
mode.add_argument("--check-certificate", type=Path)
artifact_mode = parser.add_mutually_exclusive_group()
artifact_mode.add_argument("--write-tex-artifact", type=Path)
artifact_mode.add_argument("--check-tex-artifact", type=Path)
parser.add_argument("--check-empty-certificates", type=Path, required=True)
arguments = parser.parse_args()
certificate = build_certificate()
verify_empty_branch_certificates(arguments.check_empty_certificates, certificate)
payload = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
tex_artifact = render_tex_artifact(certificate)
if arguments.write_certificate is not None:
    arguments.write_certificate.write_text(payload, encoding="utf-8")
else:
    assert arguments.check_certificate.read_text(encoding="utf-8") == payload
if arguments.write_tex_artifact is not None:
    arguments.write_tex_artifact.write_text(tex_artifact, encoding="utf-8")
if arguments.check_tex_artifact is not None:
    assert arguments.check_tex_artifact.read_text(encoding="utf-8") == tex_artifact
print("slice-cover derivation: ok")
