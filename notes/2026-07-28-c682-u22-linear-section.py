#!/usr/bin/env python3
"""Certify the target-side U_22 section behind the C682 22-point resolvent."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
NOTES = REPOSITORY / "notes"
RANK_SCRIPT = NOTES / "2026-07-28-c682-rank-four-resolvent.py"
RANK_CERTIFICATE = RANK_SCRIPT.with_suffix(".json")
DEFORMATION_CERTIFICATE = NOTES / "2026-07-28-c682-transvectant-deformation-map.json"
OUTPUT = Path(__file__).with_suffix(".json")
PRIME = 11
TRIPLES = list(itertools.combinations(range(7), 3))


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


RANK = load_module("c682_rank_resolvent", RANK_SCRIPT)
DEFORMATION = RANK.DEFORMATION
MM = RANK.MM


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def determinant3(matrix):
    return (
        matrix[0][0]
        * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1]
        * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2]
        * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    ) % PRIME


def plucker(plane):
    return [
        determinant3(
            [[plane[row][column] for column in columns] for row in range(3)]
        )
        for columns in TRIPLES
    ]


def independent_rows(rows):
    basis = []
    for row in rows:
        if MM.rank(basis + [row], PRIME) > len(basis):
            basis.append(row)
    return basis


def fifth_forms():
    standard = [
        [int(row == column) for row in range(7)] for column in range(7)
    ]
    return [
        [
            [
                DEFORMATION.fifth_pair(standard[left], standard[right])[coefficient]
                for right in range(7)
            ]
            for left in range(7)
        ]
        for coefficient in range(3)
    ]


def contraction_equations(forms):
    equations = []
    for form in forms:
        for output in range(7):
            equations.append(
                [
                    (
                        form[left][middle] * int(output == right)
                        - form[left][right] * int(output == middle)
                        + form[middle][right] * int(output == left)
                    )
                    % PRIME
                    for left, middle, right in TRIPLES
                ]
            )
    return equations


def chart_plane(plane):
    reduced, pivots = MM.rref([row[:] for row in plane], PRIME)
    assert len(pivots) == 3
    complement = [column for column in range(7) if column not in pivots]
    return reduced, pivots, complement


def tangent_data(plane, forms, section_basis):
    normalized, _, complement = chart_plane(plane)
    equations = []
    variables = [(row, column) for row in range(3) for column in complement]
    for left, right in itertools.combinations(range(3), 2):
        for form in forms:
            equation = []
            for moving_row, moving_column in variables:
                value = 0
                if moving_row == left:
                    value += sum(
                        form[moving_column][column] * normalized[right][column]
                        for column in range(7)
                    )
                if moving_row == right:
                    value += sum(
                        normalized[left][column] * form[column][moving_column]
                        for column in range(7)
                    )
                equation.append(value % PRIME)
            equations.append(equation)
    tangent_parameters = MM.nullspace(equations, PRIME)
    tangent_pluckers = []
    for parameter in tangent_parameters:
        variation = [[0] * 7 for _ in range(3)]
        for index, (row, column) in enumerate(variables):
            variation[row][column] = parameter[index]
        derivative = []
        for columns in TRIPLES:
            value = 0
            for moving_row in range(3):
                rows = [row[:] for row in normalized]
                rows[moving_row] = variation[moving_row]
                value += determinant3(
                    [[rows[row][column] for column in columns] for row in range(3)]
                )
            derivative.append(value % PRIME)
        tangent_pluckers.append(derivative)
    point = plucker(normalized)
    affine_tangent = [point] + tangent_pluckers
    return {
        "linearized_isotropy_rank": MM.rank(equations, PRIME),
        "projective_tangent_dimension": len(tangent_parameters),
        "affine_plucker_tangent_rank": MM.rank(affine_tangent, PRIME),
        "section_plus_affine_tangent_rank": MM.rank(
            section_basis + affine_tangent, PRIME
        ),
    }


def matrix_product(left, right):
    return tuple(
        (
            left[2 * row] * right[column]
            + left[2 * row + 1] * right[2 + column]
        )
        % PRIME
        for row in range(2)
        for column in range(2)
    )


def projective_order(matrix):
    product = (1, 0, 0, 1)
    for order in range(1, 61):
        product = matrix_product(product, matrix)
        if (
            product[0]
            and product[1] == product[2] == 0
            and product[3] * pow(product[0], -1, PRIME) % PRIME == 1
        ):
            return order
    raise AssertionError("projective order exceeds 60")


def wedge_action(binary_matrix):
    source = DEFORMATION.DIVIDED.symmetric_action_mod(
        binary_matrix, 6, 3, PRIME
    )
    return [
        [
            determinant3(
                [
                    [source[row][column] for column in input_columns]
                    for row in output_rows
                ]
            )
            for input_columns in TRIPLES
        ]
        for output_rows in TRIPLES
    ]


def action(matrix, vector):
    return [
        sum(matrix[row][column] * vector[column] for column in range(35))
        % PRIME
        for row in range(35)
    ]


def coordinates(basis, vector):
    return DEFORMATION.solve_coordinates(
        [list(row) for row in zip(*basis)], vector
    )


def restricted_trace(matrix, basis):
    coordinate_columns = [
        coordinates(basis, action(matrix, vector)) for vector in basis
    ]
    return sum(
        coordinate_columns[index][index] for index in range(len(basis))
    ) % PRIME


def restriction_columns(matrix, basis):
    return [coordinates(basis, action(matrix, vector)) for vector in basis]


def particular_solution(matrix, right_hand_side):
    reduced, pivots = MM.rref(
        [
            row + [right_hand_side[index]]
            for index, row in enumerate(matrix)
        ],
        PRIME,
    )
    solution = [0] * len(matrix[0])
    for row, column in enumerate(pivots):
        if column < len(solution):
            solution[column] = reduced[row][-1]
    assert all(
        sum(entry * value for entry, value in zip(row, solution)) % PRIME
        == right_hand_side[index]
        for index, row in enumerate(matrix)
    )
    return solution


def form_terms(form):
    return [
        {"plucker": list(columns), "coefficient": coefficient}
        for columns, coefficient in zip(TRIPLES, form)
        if coefficient
    ]


def sorted_wedge_sign(indices):
    if len(set(indices)) < len(indices):
        return 0, None
    inversions = sum(
        indices[left] > indices[right]
        for left in range(len(indices))
        for right in range(left + 1, len(indices))
    )
    return (-1 if inversions % 2 else 1), tuple(sorted(indices))


def rref_row_basis(rows):
    reduced, pivots = MM.rref(rows, PRIME)
    basis = [row for row in reduced if any(row)]
    return basis, pivots[: len(basis)]


def restricted_plucker_quadrics(section_basis):
    triple_index = {triple: index for index, triple in enumerate(TRIPLES)}
    monomials = list(itertools.combinations_with_replacement(range(11), 2))
    monomial_index = {
        monomial: index for index, monomial in enumerate(monomials)
    }
    relations = []
    for left_indices in itertools.combinations(range(7), 2):
        for right_indices in itertools.combinations(range(7), 4):
            relation = [0] * len(monomials)
            for position, moving_index in enumerate(right_indices):
                sign, left_triple = sorted_wedge_sign(
                    left_indices + (moving_index,)
                )
                if not sign:
                    continue
                right_triple = tuple(
                    index for index in right_indices if index != moving_index
                )
                coefficient = (-1) ** position * sign
                for left_variable in range(11):
                    left_value = section_basis[left_variable][
                        triple_index[left_triple]
                    ]
                    if not left_value:
                        continue
                    for right_variable in range(11):
                        right_value = section_basis[right_variable][
                            triple_index[right_triple]
                        ]
                        if not right_value:
                            continue
                        monomial = tuple(
                            sorted((left_variable, right_variable))
                        )
                        relation[monomial_index[monomial]] = (
                            relation[monomial_index[monomial]]
                            + coefficient * left_value * right_value
                        ) % PRIME
            if any(relation):
                relations.append(relation)
    basis, pivots = rref_row_basis(relations)
    return relations, monomials, basis, pivots


def multiply_ideal_basis(basis, old_monomials, degree):
    monomials = list(
        itertools.combinations_with_replacement(range(11), degree)
    )
    monomial_index = {
        monomial: index for index, monomial in enumerate(monomials)
    }
    rows = []
    for polynomial in basis:
        for variable in range(11):
            row = [0] * len(monomials)
            for index, coefficient in enumerate(polynomial):
                if coefficient:
                    monomial = tuple(
                        sorted(old_monomials[index] + (variable,))
                    )
                    row[monomial_index[monomial]] = coefficient
            rows.append(row)
    reduced, pivots = rref_row_basis(rows)
    return monomials, reduced, pivots


def quotient_multiplication_rank(
    source_monomials,
    source_pivots,
    target_monomials,
    target_basis,
    target_pivots,
    linear_form,
):
    source_nonpivots = [
        index
        for index in range(len(source_monomials))
        if index not in set(source_pivots)
    ]
    target_nonpivots = [
        index
        for index in range(len(target_monomials))
        if index not in set(target_pivots)
    ]
    target_index = {
        monomial: index for index, monomial in enumerate(target_monomials)
    }
    columns = []
    for source_index in source_nonpivots:
        vector = [0] * len(target_monomials)
        for variable, coefficient in enumerate(linear_form):
            if coefficient:
                monomial = tuple(
                    sorted(source_monomials[source_index] + (variable,))
                )
                vector[target_index[monomial]] = coefficient
        for row, pivot in zip(target_basis, target_pivots):
            if vector[pivot]:
                scale = vector[pivot]
                vector = [
                    (left - scale * right) % PRIME
                    for left, right in zip(vector, row)
                ]
        columns.append([vector[index] for index in target_nonpivots])
    return (
        len(source_nonpivots),
        len(target_nonpivots),
        MM.rank(columns, PRIME),
    )


def build_certificate():
    operator_basis = RANK.operator_basis()
    parameters = [
        (parameter, sheet)
        for sheet in (1, PRIME - 1)
        for parameter in range(PRIME)
    ]
    source_points = [
        RANK.parameter_point(parameter, sheet)
        for parameter, sheet in parameters
    ]
    planes = [
        MM.nullspace(RANK.operator_at(point, operator_basis), PRIME)
        for point in source_points
    ]
    assert all(len(plane) == 3 for plane in planes)
    target_points = [plucker(plane) for plane in planes]
    section_basis = independent_rows(target_points)
    assert len(section_basis) == 11

    forms = fifth_forms()
    contractions = contraction_equations(forms)
    contraction_basis = independent_rows(contractions)
    anticanonical_basis = MM.nullspace(contractions, PRIME)
    assert len(contraction_basis) == 21
    assert len(anticanonical_basis) == 14
    assert all(
        sum(equation[index] * point[index] for index in range(35))
        % PRIME
        == 0
        for equation in contractions
        for point in target_points
    )

    section_annihilator = MM.nullspace(section_basis, PRIME)
    extra_forms = []
    equation_basis = contraction_basis[:]
    for form in section_annihilator:
        if MM.rank(equation_basis + [form], PRIME) > len(equation_basis):
            equation_basis.append(form)
            extra_forms.append(form)
        if len(extra_forms) == 3:
            break
    expected_forms = []
    for terms in (
        [((0, 1, 2), 1)],
        [((0, 1, 3), 1), ((3, 5, 6), 1)],
        [((4, 5, 6), 1)],
    ):
        expected_forms.append(
            [
                next(
                    (
                        coefficient
                        for columns, coefficient in terms
                        if columns == triple
                    ),
                    0,
                )
                for triple in TRIPLES
            ]
        )
    assert extra_forms == expected_forms
    assert len(equation_basis) == 24
    assert all(
        sum(form[index] * point[index] for index in range(35)) % PRIME == 0
        for form in extra_forms
        for point in target_points
    )

    tangent_rows = [
        tangent_data(plane, forms, section_basis) for plane in planes
    ]
    assert {
        tuple(sorted(row.items())) for row in tangent_rows
    } == {
        tuple(
            sorted(
                {
                    "linearized_isotropy_rank": 9,
                    "projective_tangent_dimension": 3,
                    "affine_plucker_tangent_rank": 4,
                    "section_plus_affine_tangent_rank": 14,
                }.items()
            )
        )
    }

    deformation = json.loads(
        DEFORMATION_CERTIFICATE.read_text(encoding="utf-8")
    )
    stored_generators = deformation["ej_ten_pair_carrier"]["generators"]
    order_two = tuple(stored_generators[0]["binary_PGL2_matrix"])
    order_three = tuple(stored_generators[1]["binary_PGL2_matrix"])
    assert projective_order(order_two) == 2
    assert projective_order(order_three) == 3
    order_five = next(
        matrix
        for matrix in (
            matrix_product(order_two, order_three),
            matrix_product(order_three, order_two),
            matrix_product(
                order_two, matrix_product(order_three, order_three)
            ),
            matrix_product(
                matrix_product(order_three, order_three), order_two
            ),
        )
        if projective_order(matrix) == 5
    )
    character_rows = []
    induced_generators = []
    for binary_matrix in (order_two, order_three, order_five):
        induced = wedge_action(binary_matrix)
        induced_generators.append(induced)
        ambient_trace = restricted_trace(induced, anticanonical_basis)
        section_trace = restricted_trace(induced, section_basis)
        character_rows.append(
            {
                "order": projective_order(binary_matrix),
                "binary_PGL2_matrix": list(binary_matrix),
                "anticanonical_trace": ambient_trace,
                "section_trace": section_trace,
                "quotient_trace": (ambient_trace - section_trace) % PRIME,
            }
        )
    assert [
        (
            row["order"],
            row["anticanonical_trace"],
            row["section_trace"],
            row["quotient_trace"],
        )
        for row in character_rows
    ] == [(2, 2, 3, 10), (3, 2, 2, 0), (5, 5, 1, 4)]

    invariant_equations = []
    for induced in induced_generators[:2]:
        columns = restriction_columns(induced, anticanonical_basis)
        for column in range(14):
            invariant_equations.append(
                [
                    (
                        columns[column][row]
                        - int(row == column)
                    )
                    % PRIME
                    for row in range(14)
                ]
            )
    invariant_functionals = MM.nullspace(invariant_equations, PRIME)
    assert len(invariant_functionals) == 2
    invariant_forms = [
        particular_solution(anticanonical_basis, functional)
        for functional in invariant_functionals
    ]
    expected_invariant_forms = []
    for terms in (
        [((0, 3, 6), 5), ((0, 4, 5), 8)],
        [((0, 1, 3), 10), ((3, 5, 6), 1)],
    ):
        expected_invariant_forms.append(
            [
                next(
                    (
                        coefficient
                        for columns, coefficient in terms
                        if columns == triple
                    ),
                    0,
                )
                for triple in TRIPLES
            ]
        )
    assert invariant_forms == expected_invariant_forms
    sheet_evaluations = []
    for (parameter, sheet), point in zip(parameters, target_points):
        values = [
            sum(form[index] * point[index] for index in range(35)) % PRIME
            for form in invariant_forms
        ]
        assert values[1] != 0
        recovered_sheet = values[0] * pow(values[1], -1, PRIME) % PRIME
        assert recovered_sheet == sheet
        assert (values[0] ** 2 - values[1] ** 2) % PRIME == 0
        sheet_evaluations.append(
            {
                "t": parameter,
                "source_s": sheet,
                "u": values[0],
                "v": values[1],
                "u_over_v": recovered_sheet,
            }
        )

    (
        plucker_relation_rows,
        degree_two_monomials,
        degree_two_basis,
        degree_two_pivots,
    ) = restricted_plucker_quadrics(section_basis)
    degree_three_monomials, degree_three_basis, degree_three_pivots = (
        multiply_ideal_basis(
            degree_two_basis, degree_two_monomials, degree=3
        )
    )
    degree_four_monomials, degree_four_basis, degree_four_pivots = (
        multiply_ideal_basis(
            degree_three_basis, degree_three_monomials, degree=4
        )
    )
    assert (
        len(plucker_relation_rows),
        len(degree_two_basis),
        len(degree_two_monomials) - len(degree_two_basis),
    ) == (516, 45, 21)
    assert (
        len(degree_three_basis),
        len(degree_three_monomials) - len(degree_three_basis),
    ) == (264, 22)
    assert (
        len(degree_four_basis),
        len(degree_four_monomials) - len(degree_four_basis),
    ) == (979, 22)
    v_on_section = [
        sum(
            invariant_forms[1][coordinate] * section_basis[variable][coordinate]
            for coordinate in range(35)
        )
        % PRIME
        for variable in range(11)
    ]
    multiplication_dimensions = quotient_multiplication_rank(
        degree_three_monomials,
        degree_three_pivots,
        degree_four_monomials,
        degree_four_basis,
        degree_four_pivots,
        v_on_section,
    )
    assert v_on_section == [2] * 11
    assert multiplication_dimensions == (22, 22, 22)

    return {
        "schema": "c682-u22-linear-section-v1",
        "field": "F_11",
        "inputs": {
            str(RANK_SCRIPT.relative_to(REPOSITORY)): sha256(RANK_SCRIPT),
            str(RANK_CERTIFICATE.relative_to(REPOSITORY)): sha256(
                RANK_CERTIFICATE
            ),
            str(DEFORMATION_CERTIFICATE.relative_to(REPOSITORY)): sha256(
                DEFORMATION_CERTIFICATE
            ),
        },
        "target_anticanonical_model": {
            "carrier": "E=Sym^6(F_11^2)",
            "plucker_coordinate_order": [list(triple) for triple in TRIPLES],
            "isotropy_map": (
                "c_omega(u wedge v wedge w)="
                "omega(u,v)w-omega(u,w)v+omega(v,w)u"
            ),
            "contraction_equation_count": len(contractions),
            "contraction_rank": len(contraction_basis),
            "ambient_vector_dimension": len(anticanonical_basis),
            "ambient_projective_dimension": len(anticanonical_basis) - 1,
            "identification": (
                "P(ker c_omega)=P(1+Sym^12), the anticanonical P^13"
            ),
        },
        "linear_section": {
            "target_point_count": len(target_points),
            "target_plucker_rank": len(section_basis),
            "target_projective_span_dimension": len(section_basis) - 1,
            "equations_modulo_the_21_isotropy_contraction_relations": [
                form_terms(form) for form in extra_forms
            ],
            "display_equations": [
                "p_012=0",
                "p_013+p_356=0",
                "p_456=0",
            ],
            "codimension_inside_anticanonical_space": 3,
            "target_points": [
                {
                    "t": parameter,
                    "s": sheet,
                    "plucker": point,
                }
                for (parameter, sheet), point in zip(parameters, target_points)
            ],
        },
        "A5_module": {
            "anticanonical_decomposition": "2*1 + V3 + V4 + V5",
            "section_decomposition": "2*1 + V4 + V5",
            "quotient": "V3",
            "character_rows_mod_11": character_rows,
            "selected_order_five_V3_trace": 4,
        },
        "quadratic_target_resolvent": {
            "invariant_linear_form_dimension": len(invariant_forms),
            "u": form_terms(invariant_forms[0]),
            "v": form_terms(invariant_forms[1]),
            "display_coordinates": [
                "u=5*p_036+8*p_045",
                "v=10*p_013+p_356",
            ],
            "equation_on_the_22_point_section": "u^2-v^2=0",
            "sheet_plus": "u-v=0, length 11",
            "sheet_minus": "u+v=0, length 11",
            "source_sheet_recovery": "s=u/v",
            "evaluations": sheet_evaluations,
            "interpretation": (
                "The two trivial A5 summands of the anticanonical carrier "
                "supply the target invariant pencil; its two hyperplanes "
                "are the two sheets of the quadratic resolvent."
            ),
        },
        "target_macaulay": {
            "restricted_nonzero_plucker_relation_rows": len(
                plucker_relation_rows
            ),
            "degree_two": {
                "monomial_count": len(degree_two_monomials),
                "ideal_rank": len(degree_two_basis),
                "quotient_dimension": (
                    len(degree_two_monomials) - len(degree_two_basis)
                ),
            },
            "degree_three": {
                "monomial_count": len(degree_three_monomials),
                "ideal_rank": len(degree_three_basis),
                "quotient_dimension": (
                    len(degree_three_monomials) - len(degree_three_basis)
                ),
            },
            "degree_four": {
                "monomial_count": len(degree_four_monomials),
                "ideal_rank": len(degree_four_basis),
                "quotient_dimension": (
                    len(degree_four_monomials) - len(degree_four_basis)
                ),
            },
            "v_coefficients_on_section_basis": v_on_section,
            "v_multiplication_degree_3_to_4": {
                "source_dimension": multiplication_dimensions[0],
                "target_dimension": multiplication_dimensions[1],
                "rank": multiplication_dimensions[2],
            },
            "conclusion": (
                "S_4=I_4+v*S_3, so multiplication and induction bound "
                "all later Hilbert values by 22; the 22 reduced points "
                "force equality and exclude every excess component."
            ),
        },
        "transversality": {
            "point_count": len(tangent_rows),
            "common_tangent_data": tangent_rows[0],
            "all_22_rows_equal": True,
            "projective_tangent_meets_P10_in_dimension": 0,
        },
        "degree_close": {
            "anticanonical_degree": 22,
            "contained_distinct_transverse_points": 22,
            "conclusion": (
                "The complementary P10 section is proper and equals the "
                "22 reduced target kernel planes scheme-theoretically."
            ),
        },
        "trust_boundary": {
            "certifies": [
                "the 14-dimensional target anticanonical Plucker carrier",
                "the explicit A5-stable codimension-three target section",
                "the 22 target points, their P10 span, and transversality",
                "the target Plucker-ideal Hilbert bound and v-isomorphism",
                "the quotient character identifying the omitted V3",
                "the invariant target pencil and its u^2-v^2 sheet split",
            ],
            "uses_classically": [
                "the fifth-transvectant Grassmannian model of U22",
                "the anticanonical degree (-K_U22)^3=22",
                "the complementary-linear-section degree lemma",
            ],
            "does_not_claim": [
                "an integral or characteristic-zero lift of this section",
                "a new manuscript theorem or novelty verdict",
                "that the source quadratic sheet coordinate is linear on U22",
            ],
        },
    }


def main():
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--write", action="store_true")
    group.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    certificate = build_certificate()
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if arguments.write:
        OUTPUT.write_text(rendered, encoding="utf-8")
        print(f"wrote {OUTPUT.relative_to(REPOSITORY)}")
    elif arguments.check:
        assert OUTPUT.read_text(encoding="utf-8") == rendered
        print("C682 U22 linear-section certificate: PASS")
    else:
        print(
            "ambient=14 section=11 points=22 "
            "quotient=V3 transverse=22/22"
        )


if __name__ == "__main__":
    main()
