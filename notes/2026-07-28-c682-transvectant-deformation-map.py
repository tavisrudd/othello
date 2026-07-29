#!/usr/bin/env python3
"""Construct the C682 divided-transvectant deformation/incidence map."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import math
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
NOTES = REPOSITORY / "notes"
DIVIDED_SCRIPT = NOTES / "2026-07-28-c682-invariant-operator-divided-power.py"
DIVIDED_CERTIFICATE = DIVIDED_SCRIPT.with_suffix(".json")
CORRECTED_CERTIFICATE = NOTES / "2026-07-28-c682-corrected-bridge-mod-1331.json"
ARITHMETIC_CERTIFICATE = (
    REPOSITORY
    / "papers"
    / "clebsch-passages"
    / "verification"
    / "evidence"
    / "arithmetic_cover.json"
)
OUTPUT = Path(__file__).with_suffix(".json")
PRIME = 11
MODULUS = PRIME**2
F_VECTOR = [0, 1, 0, 0, 0, 0, 11, 0, 0, 0, 0, -1, 0]
FROBENIUS_INDICES = (0, 1, 11, 12)


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


DIVIDED = load_module("c682_divided", DIVIDED_SCRIPT)
MM = DIVIDED.MM


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def matmul(left, right, modulus: int = PRIME):
    return [
        [
            sum(left[row][middle] * right[middle][column] for middle in range(len(right)))
            % modulus
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def matvec(matrix, vector, modulus: int):
    return [
        sum(matrix[row][column] * vector[column] for column in range(len(vector)))
        % modulus
        for row in range(len(matrix))
    ]


def normalize_projective(vector, modulus: int = PRIME):
    pivot = next(value % modulus for value in vector if value % modulus)
    inverse = pow(pivot, -1, modulus)
    return [value * inverse % modulus for value in vector]


def serialize_form(vector, degree: int):
    return [
        {"x": degree - row, "y": row, "coefficient": value}
        for row, value in enumerate(vector)
        if value
    ]


def third_matrix(right_vector):
    right = {
        (12 - row, row): value
        for row, value in enumerate(right_vector)
        if value
    }
    matrix = [[0] * 7 for _ in range(13)]
    for column in range(7):
        image = DIVIDED.raw_third_transvectant_with_right(
            {(6 - column, column): 1}, right
        )
        for row in range(13):
            matrix[row][column] = image.get((12 - row, row), 0) % PRIME
    return matrix


def fifth_pair(left, right):
    output = [0, 0, 0]
    for left_y, left_coefficient in enumerate(left):
        for right_y, right_coefficient in enumerate(right):
            for index in range(6):
                output_y = left_y - index + right_y - (5 - index)
                if not 0 <= output_y <= 2:
                    continue
                output[output_y] += (
                    (-1) ** index
                    * math.comb(5, index)
                    * left_coefficient
                    * math.prod(range(6 - left_y - (5 - index) + 1, 6 - left_y + 1))
                    * math.prod(range(left_y - index + 1, left_y + 1))
                    * right_coefficient
                    * math.prod(range(6 - right_y - index + 1, 6 - right_y + 1))
                    * math.prod(range(right_y - (5 - index) + 1, right_y + 1))
                )
    return [value % PRIME for value in output]


def apolar_annihilator(plane):
    equations = []
    for vector in plane:
        equations.append(
            [
                (
                    vector[6 - column]
                    * (-1) ** (6 - column)
                    * math.factorial(6 - column)
                    * math.factorial(column)
                )
                % PRIME
                for column in range(7)
            ]
        )
    return MM.nullspace(equations, PRIME)


def isotropy_rows(plane):
    return [
        fifth_pair(plane[left], plane[right])
        for left in range(3)
        for right in range(left + 1, 3)
    ]


def conic_quadratic_parameterization():
    points, parameters = MM.COXETER.conic_parameterization(PRIME)
    equations = []
    for point, (left, right) in zip(points, parameters):
        monomials = [left * left % PRIME, left * right % PRIME, right * right % PRIME]
        row = [0] * 9
        for index, monomial in enumerate(monomials):
            row[index] = monomial * point[1] % PRIME
            row[3 + index] = -monomial * point[0] % PRIME
        equations.append(row)
        row = [0] * 9
        for index, monomial in enumerate(monomials):
            row[index] = monomial * point[2] % PRIME
            row[6 + index] = -monomial * point[0] % PRIME
        equations.append(row)
    kernel = MM.nullspace(equations, PRIME)
    assert len(kernel) == 1
    return points, parameters, [kernel[0][offset : offset + 3] for offset in (0, 3, 6)]


def polynomial_product(left, right):
    output = [0] * (len(left) + len(right) - 1)
    for left_degree, left_value in enumerate(left):
        for right_degree, right_value in enumerate(right):
            output[left_degree + right_degree] = (
                output[left_degree + right_degree] + left_value * right_value
            ) % PRIME
    return output


def euclidean_exchanger_permutation(points):
    normalized = [tuple(normalize_projective(point)) for point in points]
    permutation = []
    for x, y, z in points:
        image = tuple(normalize_projective((x, -z, y)))
        permutation.append(normalized.index(image))
    return tuple(permutation)


def operator_from_correction(primitive, correction):
    matrix = third_matrix(correction)
    coefficient = pow(240, -1, PRIME)
    assert coefficient == 5
    return [
        [
            (primitive[row][column] + coefficient * matrix[row][column]) % PRIME
            for column in range(7)
        ]
        for row in range(13)
    ]


def transformed_correction(correction, exchanger):
    lifted = [
        (F_VECTOR[index] + PRIME * correction[index]) % MODULUS
        for index in range(13)
    ]
    action = DIVIDED.symmetric_action_mod(exchanger, 12, 1, MODULUS)
    transformed = matvec(action, lifted, MODULUS)
    normalization = pow(transformed[1], -1, MODULUS)
    transformed = [normalization * value % MODULUS for value in transformed]
    assert [value % PRIME for value in transformed] == [
        value % PRIME for value in F_VECTOR
    ]
    quotient = []
    for index in range(13):
        difference = (transformed[index] - F_VECTOR[index]) % MODULUS
        assert difference % PRIME == 0
        quotient.append(difference // PRIME)
    return quotient, normalization


def flatten(matrix):
    return [value for row in matrix for value in row]


def solve_coordinates(basis_matrix, vector):
    reduced, pivots = MM.rref(
        [row + [vector[index]] for index, row in enumerate(basis_matrix)],
        PRIME,
    )
    assert len(pivots) == len(basis_matrix[0])
    assert len(basis_matrix[0]) not in pivots
    solution = [0] * len(basis_matrix[0])
    for row, column in enumerate(pivots):
        solution[column] = reduced[row][-1]
    assert all(
        sum(row[column] * solution[column] for column in range(len(solution)))
        % PRIME
        == vector[index] % PRIME
        for index, row in enumerate(basis_matrix)
    )
    return solution


def permutation_product(left, right):
    return tuple(left[right[index]] for index in range(len(left)))


def permutation_power(element, exponent):
    answer = tuple(range(len(element)))
    for _ in range(exponent):
        answer = permutation_product(answer, element)
    return answer


def permutation_order(element):
    identity = tuple(range(len(element)))
    for exponent in range(1, 61):
        if permutation_power(element, exponent) == identity:
            return exponent
    raise AssertionError("permutation order exceeds 60")


def presentation_pair(parent_group):
    ordered = sorted(parent_group)
    involution = next(
        left
        for left in ordered
        if permutation_order(left) == 2
        and any(
            permutation_order(right) == 3
            and permutation_order(permutation_product(left, right)) == 5
            for right in ordered
        )
    )
    cubic = next(
        right
        for right in ordered
        if permutation_order(right) == 3
        and permutation_order(permutation_product(involution, right)) == 5
    )
    return involution, cubic


def certificate():
    divided = json.loads(DIVIDED_CERTIFICATE.read_text(encoding="utf-8"))
    corrected = json.loads(CORRECTED_CERTIFICATE.read_text(encoding="utf-8"))
    arithmetic = json.loads(ARITHMETIC_CERTIFICATE.read_text(encoding="utf-8"))
    primitive = divided["sym6_primitive_matrix"]
    correction = [0] * 13
    for term in corrected["first_correction_digit_from_F"]:
        correction[term["y"]] = term["coefficient"]

    points, parameters, quadratic_map = conic_quadratic_parameterization()
    permutation = euclidean_exchanger_permutation(points)
    exchanger = tuple(DIVIDED.recover_pgl_matrix(permutation, tuple(parameters)))
    assert exchanger == (1, 3, 3, 6)
    assert arithmetic["exchanger"]["matrix"] == [[1, 0, 0], [0, 0, -1], [0, 1, 0]]

    conjugate_correction, normalization = transformed_correction(correction, exchanger)
    operator = operator_from_correction(primitive, correction)
    conjugate_operator = operator_from_correction(primitive, conjugate_correction)
    assert MM.rank(operator, PRIME) == MM.rank(conjugate_operator, PRIME) == 4

    source_action = DIVIDED.symmetric_action_mod(exchanger, 6, 3, PRIME)
    target_action = DIVIDED.symmetric_action_mod(exchanger, 12, 1, PRIME)
    inverse_exchanger = DIVIDED.inverse_2x2_mod(exchanger, PRIME)
    inverse_source_action = DIVIDED.symmetric_action_mod(
        inverse_exchanger, 6, 3, PRIME
    )
    assert (
        matmul(matmul(target_action, operator), inverse_source_action)
        == conjugate_operator
    )

    kernel = MM.nullspace(operator, PRIME)
    conjugate_kernel = MM.nullspace(conjugate_operator, PRIME)
    assert len(kernel) == len(conjugate_kernel) == 3
    assert MM.rank(kernel + conjugate_kernel, PRIME) == 6
    assert MM.rank(
        conjugate_kernel + [matvec(source_action, row, PRIME) for row in kernel],
        PRIME,
    ) == 3
    assert isotropy_rows(kernel) == isotropy_rows(conjugate_kernel) == [[0, 0, 0]] * 3

    annihilator = apolar_annihilator(kernel)
    conjugate_annihilator = apolar_annihilator(conjugate_kernel)
    intersection = apolar_annihilator(kernel + conjugate_kernel)
    assert len(annihilator) == len(conjugate_annihilator) == 4
    assert len(intersection) == 1
    incidence_vector = normalize_projective(intersection[0])
    assert incidence_vector == [1, 0, 6, 0, 6, 0, 1]
    incidence_image = matvec(source_action, incidence_vector, PRIME)
    assert incidence_image == [(-value) % PRIME for value in incidence_vector]

    xyz_restriction = polynomial_product(
        polynomial_product(quadratic_map[0], quadratic_map[1]), quadratic_map[2]
    )
    assert xyz_restriction == [6 * value % PRIME for value in incidence_vector]

    directions = [third_matrix([int(index == basis) for index in range(13)]) for basis in range(13)]
    theta_matrix = [
        [flatten(directions[column])[row] for column in range(13)]
        for row in range(13 * 7)
    ]
    theta_kernel = MM.nullspace(theta_matrix, PRIME)
    frobenius_basis = [
        [int(index == basis) for index in range(13)] for basis in FROBENIUS_INDICES
    ]
    assert MM.rank(theta_matrix, PRIME) == 9
    assert MM.rank(theta_kernel + frobenius_basis, PRIME) == 4
    augmented_operator_directions = [
        flatten(primitive)
    ] + [[5 * value % PRIME for value in flatten(direction)] for direction in directions]
    augmented_rank = MM.rank(
        [list(column) for column in zip(*augmented_operator_directions)], PRIME
    )
    assert augmented_rank == 10

    raw_conjugate = matvec(
        DIVIDED.symmetric_action_mod(exchanger, 12, 1, PRIME),
        correction,
        PRIME,
    )
    exchanger_cocycle = [
        (conjugate_correction[index] - raw_conjugate[index]) % PRIME
        for index in range(13)
    ]
    cocycle_operator = third_matrix(exchanger_cocycle)
    conjugated_primitive = matmul(
        matmul(target_action, primitive), inverse_source_action
    )
    assert all(
        (
            conjugated_primitive[row][column]
            - primitive[row][column]
            - 5 * cocycle_operator[row][column]
        )
        % PRIME
        == 0
        for row in range(13)
        for column in range(7)
    )

    quotient_coordinates = [index for index in range(13) if index not in FROBENIUS_INDICES]
    quotient_pair = [
        [vector[index] for index in quotient_coordinates]
        for vector in (correction, conjugate_correction)
    ]
    assert MM.rank(quotient_pair, PRIME) == 2
    quotient_directions = [directions[index] for index in quotient_coordinates]

    def recover_extended_normal_line(plane):
        equations = []
        for vector in plane:
            for output in range(13):
                equations.append(
                    [
                        sum(
                            primitive[output][column] * vector[column]
                            for column in range(7)
                        )
                        % PRIME
                    ]
                    + [
                        5
                        * sum(
                            direction[output][column] * vector[column]
                            for column in range(7)
                        )
                        % PRIME
                        for direction in quotient_directions
                    ]
                )
        normal_line = MM.nullspace(equations, PRIME)
        assert len(normal_line) == 1
        return MM.rank(equations, PRIME), normalize_projective(normal_line[0])

    selected_inverse_rank, selected_recovered_line = recover_extended_normal_line(kernel)
    conjugate_inverse_rank, conjugate_recovered_line = recover_extended_normal_line(
        conjugate_kernel
    )
    assert selected_recovered_line == [1] + quotient_pair[0]
    assert conjugate_recovered_line == [1] + quotient_pair[1]

    operator_basis = [primitive] + [
        [[5 * value % PRIME for value in row] for row in direction]
        for direction in quotient_directions
    ]
    operator_coordinate_matrix = [
        [flatten(operator_basis[column])[row] for column in range(10)]
        for row in range(13 * 7)
    ]
    workspace = DIVIDED.C651.h3_workspace()
    parent_group = tuple(workspace["parent_group"])
    _subgroups, five_actions = DIVIDED.C651.natural_five_action(parent_group)
    conic_parameters = tuple(MM.COXETER.conic_parameterization(PRIME)[1])
    extended_actions = {}
    pair_actions = {}
    character_rows = []
    for element in parent_group:
        pgl_matrix = DIVIDED.recover_pgl_matrix(element, conic_parameters)
        left_action = DIVIDED.symmetric_action(pgl_matrix, 12, 1)
        inverse_right_action = DIVIDED.symmetric_action(
            DIVIDED.inverse_2x2_mod(pgl_matrix, PRIME), 6, 3
        )
        columns = [
            solve_coordinates(
                operator_coordinate_matrix,
                flatten(matmul(matmul(left_action, basis), inverse_right_action)),
            )
            for basis in operator_basis
        ]
        extended_action = [list(row) for row in zip(*columns)]
        pair_permutation = DIVIDED.C651.pair_action(five_actions[element])
        pair_action = DIVIDED.permutation_matrix(pair_permutation)
        extended_actions[element] = extended_action
        pair_actions[element] = pair_action
        fixed_pairs = sum(
            index == pair_permutation[index] for index in range(len(pair_permutation))
        )
        trace = sum(extended_action[index][index] for index in range(10)) % PRIME
        assert trace == fixed_pairs % PRIME
        character_rows.append((permutation_order(element), fixed_pairs, trace))

    involution, cubic = presentation_pair(parent_group)
    generator_extended_actions = [
        extended_actions[element] for element in (involution, cubic)
    ]
    generator_pair_actions = [
        pair_actions[element] for element in (involution, cubic)
    ]
    hom_basis = DIVIDED.rectangular_hom_basis(
        generator_extended_actions, generator_pair_actions
    )
    hom_matrices = [DIVIDED.reshape(vector, 10, 10) for vector in hom_basis]
    hom_ranks = [MM.rank(matrix, PRIME) for matrix in hom_matrices]
    intertwiner = next(
        matrix for matrix in hom_matrices if MM.rank(matrix, PRIME) == 10
    )
    radial_image = [sum(row) % PRIME for row in intertwiner]
    scale = pow(radial_image[0], -1, PRIME)
    intertwiner = [
        [scale * value % PRIME for value in row] for row in intertwiner
    ]
    radial_image = [sum(row) % PRIME for row in intertwiner]
    assert radial_image == selected_recovered_line
    assert all(
        matmul(extended_action, intertwiner)
        == matmul(intertwiner, pair_action)
        for extended_action, pair_action in zip(
            generator_extended_actions, generator_pair_actions
        )
    )
    character_distribution = {}
    for order, fixed_pairs, trace in character_rows:
        key = f"order_{order}"
        row = character_distribution.setdefault(
            key,
            {
                "class_size": 0,
                "fixed_pair_character": fixed_pairs,
                "extended_trace_mod_11": trace,
            },
        )
        assert row["fixed_pair_character"] == fixed_pairs
        assert row["extended_trace_mod_11"] == trace
        row["class_size"] += 1

    def operator_from_extended_line(line):
        return [
            [
                sum(
                    line[index] * operator_basis[index][row][column]
                    for index in range(10)
                )
                % PRIME
                for column in range(7)
            ]
            for row in range(13)
        ]

    def rank_locus_tangent_rank(matrix):
        right_kernel = MM.nullspace(matrix, PRIME)
        left_kernel = MM.nullspace(
            [list(column) for column in zip(*matrix)], PRIME
        )
        equations = []
        for left in left_kernel:
            for right in right_kernel:
                equations.append(
                    [
                        sum(
                            left[row]
                            * sum(
                                basis[row][column] * right[column]
                                for column in range(7)
                            )
                            for row in range(13)
                        )
                        % PRIME
                        for basis in operator_basis
                    ]
                )
        return MM.rank(equations, PRIME)

    assert all(
        normalize_projective(matvec(action, selected_recovered_line, PRIME))
        == selected_recovered_line
        for action in extended_actions.values()
    )
    conjugate_orbit = {tuple(conjugate_recovered_line)}
    frontier = list(conjugate_orbit)
    for action in generator_extended_actions:
        assert len(action) == 10
    while frontier:
        line = frontier.pop()
        for action in generator_extended_actions:
            image = tuple(normalize_projective(matvec(action, line, PRIME)))
            if image not in conjugate_orbit:
                conjugate_orbit.add(image)
                frontier.append(image)
    assert len(conjugate_orbit) == 5

    orbit_rows = []
    for line in sorted(conjugate_orbit):
        line_operator = operator_from_extended_line(line)
        assert MM.rank(line_operator, PRIME) == 4
        line_kernel = MM.nullspace(line_operator, PRIME)
        intersection_line = apolar_annihilator(kernel + line_kernel)
        assert len(intersection_line) == 1
        orbit_rows.append(
            {
                "extended_normal_line": list(line),
                "operator_rank": 4,
                "rank_locus_tangent_equation_rank": rank_locus_tangent_rank(
                    line_operator
                ),
                "intersection_with_selected_annihilator": normalize_projective(
                    intersection_line[0]
                ),
            }
        )
    base_row = next(
        row
        for row in orbit_rows
        if row["intersection_with_selected_annihilator"] == incidence_vector
    )
    orbit_rows = [base_row] + [row for row in orbit_rows if row is not base_row]
    intersection_lines = [
        row["intersection_with_selected_annihilator"] for row in orbit_rows
    ]
    assert MM.rank(intersection_lines, PRIME) == 4
    relation = MM.nullspace(
        [list(column) for column in zip(*intersection_lines)], PRIME
    )
    assert len(relation) == 1 and all(relation[0])
    global_scale = pow(relation[0][0], -1, PRIME)
    clebsch_frame = [
        [
            global_scale * relation[0][index] * value % PRIME
            for value in line
        ]
        for index, line in enumerate(intersection_lines)
    ]
    assert clebsch_frame[0] == incidence_vector
    assert [
        sum(line[column] for line in clebsch_frame) % PRIME
        for column in range(7)
    ] == [0] * 7
    selected_tangent_rank = rank_locus_tangent_rank(operator)
    assert selected_tangent_rank == 9
    assert all(
        row["rank_locus_tangent_equation_rank"] == 9 for row in orbit_rows
    )

    inputs = (
        DIVIDED_SCRIPT,
        DIVIDED_CERTIFICATE,
        CORRECTED_CERTIFICATE,
        ARITHMETIC_CERTIFICATE,
        DIVIDED.MATCHING_MODULE_PATH,
        DIVIDED.C651_SCRIPT_PATH,
        DIVIDED.C651_CERTIFICATE_PATH,
    )
    return {
        "schema": "c682-transvectant-deformation-map-v1",
        "field": "F_11",
        "bases": {
            "H_equals_Sym6": "X^(6-i)Y^i, 0<=i<=6",
            "dodecics_equals_Sym12": "X^(12-i)Y^i, 0<=i<=12",
        },
        "extended_normal_space": {
            "ordinary_normal_quotient": (
                "Sym^12/(V^(1) tensor V), with Frobenius indices 0,1,11,12 removed"
            ),
            "ordinary_normal_dimension": 9,
            "ordinary_third_transvectant_rank": MM.rank(theta_matrix, PRIME),
            "ordinary_third_transvectant_kernel": theta_kernel,
            "bockstein_direction": "P_F, the primitive divided operator of the fixed lift F",
            "P_F_is_outside_ordinary_transvectant_image": True,
            "extended_normal_dimension": augmented_rank,
            "homogenized_map": (
                "widehatTheta(a,[L])=a*P_F+5*(-,L)_3; "
                "kappa([a,L])=ker(widehatTheta(a,[L])) on the rank-four locus"
            ),
        },
        "exchanger": {
            "euclidean_matrix": arithmetic["exchanger"]["matrix"],
            "parameter_permutation": list(permutation),
            "binary_PGL2_matrix": list(exchanger),
            "determinant_mod_11": (
                exchanger[0] * exchanger[3] - exchanger[1] * exchanger[2]
            )
            % PRIME,
            "normalization_mod_121": normalization,
            "operator_cocycle": serialize_form(exchanger_cocycle, 12),
            "operator_cocycle_quotient_coordinates": [
                exchanger_cocycle[index] for index in quotient_coordinates
            ],
            "cocycle_identity": (
                "rho12(R) P_F rho6(R)^(-1)-P_F=5*(-,c_R)_3"
            ),
        },
        "normal_lines": {
            "selected_line": "(1,[K]) in P(F_11 direct_sum N)",
            "selected_K": serialize_form(correction, 12),
            "conjugate_line": "(1,[K_R])=R*(1,[K])",
            "conjugate_K": serialize_form(conjugate_correction, 12),
            "quotient_coordinate_indices": quotient_coordinates,
            "quotient_coordinate_pair": quotient_pair,
            "lines_are_distinct": True,
        },
        "kernel_map": {
            "selected_operator_rank": MM.rank(operator, PRIME),
            "conjugate_operator_rank": MM.rank(conjugate_operator, PRIME),
            "selected_kernel": kernel,
            "conjugate_kernel": conjugate_kernel,
            "kernels_are_distinct": True,
            "sum_dimension": MM.rank(kernel + conjugate_kernel, PRIME),
            "exchanger_covariance": True,
            "fifth_transvectant_isotropy_selected": isotropy_rows(kernel),
            "fifth_transvectant_isotropy_conjugate": isotropy_rows(conjugate_kernel),
            "inverse_annihilator_construction": (
                "U maps to the projective kernel of "
                "(a,[L]) -> widehatTheta(a,[L]) restricted to U"
            ),
            "selected_inverse_equation_rank": selected_inverse_rank,
            "conjugate_inverse_equation_rank": conjugate_inverse_rank,
            "selected_recovered_extended_normal_line": selected_recovered_line,
            "conjugate_recovered_extended_normal_line": conjugate_recovered_line,
            "kernel_and_extended_annihilator_are_inverse_on_golden_pair": True,
        },
        "incidence_map": {
            "definition": (
                "([a,L],[f]) maps to ([f],ker widehatTheta(a,[L])) "
                "when f lies in the apolar annihilator of the kernel"
            ),
            "selected_annihilator_four_plane": annihilator,
            "conjugate_annihilator_four_plane": conjugate_annihilator,
            "annihilator_intersection_dimension": len(intersection),
            "common_incidence_line": incidence_vector,
            "exchanger_scalar_on_common_line": PRIME - 1,
            "conic_quadratic_parameterization": quadratic_map,
            "xyz_restriction_to_parameter_conic": xyz_restriction,
            "xyz_restriction_scalar_times_common_line": 6,
            "orientation_scalars_mod_11": [4, 7],
            "conclusion": (
                "The two exchanged extended normal lines map to two distinct "
                "fifth-transvectant-isotropic parent planes whose annihilator "
                "four-planes meet in the binary sextic line representing xyz."
            ),
        },
        "ej_ten_pair_carrier": {
            "result": (
                "The extended Bockstein normal space is A5-isomorphic to "
                "the ten-pair permutation module P10=1+4+5."
            ),
            "group_order": len(parent_group),
            "character_distribution": character_distribution,
            "all_60_character_values_match_fixed_pair_counts": True,
            "hom_space_dimension": len(hom_basis),
            "hom_basis_ranks": hom_ranks,
            "intertwiner_pair_to_extended_normal": intertwiner,
            "intertwiner_rank": MM.rank(intertwiner, PRIME),
            "radial_pair_vector_image": radial_image,
            "radial_pair_vector_maps_to_selected_K_line": True,
            "generators": [
                {
                    "order": permutation_order(element),
                    "P1_permutation": list(element),
                    "pair_permutation": list(
                        DIVIDED.C651.pair_action(five_actions[element])
                    ),
                    "binary_PGL2_matrix": list(
                        DIVIDED.recover_pgl_matrix(element, conic_parameters)
                    ),
                    "extended_normal_action": extended_actions[element],
                }
                for element in (involution, cubic)
            ],
            "interpretation": (
                "The Bockstein coordinate supplies exactly the missing "
                "trivial summand.  Under the recorded marking the corrected "
                "normal line is the image of the all-ones pair vector."
            ),
        },
        "ej_rank_drop_clebsch_frame": {
            "selected_line_is_A5_fixed": True,
            "selected_rank_four_point_tangent_equation_rank": selected_tangent_rank,
            "selected_rank_four_point_is_projectively_reduced_isolated": True,
            "conjugate_line_A5_orbit_size": len(conjugate_orbit),
            "conjugate_orbit_stabilizer_order": len(parent_group)
            // len(conjugate_orbit),
            "conjugate_orbit_rows": orbit_rows,
            "all_five_rank_four_points_are_projectively_reduced_isolated": True,
            "five_intersection_lines_span_dimension": MM.rank(
                intersection_lines, PRIME
            ),
            "raw_intersection_relation": relation[0],
            "clebsch_frame_with_first_vector_xyz_and_sum_zero": clebsch_frame,
            "conclusion": (
                "The fixed rank-drop line and the five-point orbit of the "
                "exchanged line give a 1+5 reduced rank-drop configuration. "
                "Intersecting the five exchanged annihilator four-planes "
                "with the fixed one recovers the standard five-line Clebsch "
                "frame in its four-space, with first line xyz and total sum zero."
            ),
            "noncoverage": (
                "The certificate does not prove that these six points exhaust "
                "the global projective rank-four degeneracy scheme."
            ),
        },
        "trust_boundary": [
            "Exact F_11 linear algebra constructs and checks the extended normal and incidence maps.",
            "The identification of the isotropic-plane scheme with the Mukai-Umemura threefold is a human theorem imported from Hitchin.",
            "The known finite-etale degree-two incidence theorem at xyz makes the two constructed points the complete fibre; the script does not reprove global degree two.",
            "The calculation is for the marked mod-11 fibre and does not assert good reduction of the global incidence comparison.",
            "No novelty claim or Paper III manuscript change is made.",
        ],
        "inputs": {
            str(path.relative_to(REPOSITORY)): {
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
            for path in inputs
        },
    }


def serialized_certificate():
    return (json.dumps(certificate(), indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = serialized_certificate()
    if args.check:
        if OUTPUT.read_bytes() != payload:
            raise SystemExit("certificate mismatch")
        print("PASS: transvectant deformation-map certificate matches")
    else:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
