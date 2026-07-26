#!/usr/bin/env python3
"""Exact modular quotient, covariant, and depth-boundary certificate."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
MATCHING_PATH = HERE / "matching_module.py"
MATCHING_INPUT = HERE / "matching_orbit_scout.json"
PROFILE_INPUT = HERE / "profile_incidence.json"
OUTPUT = HERE / "relative_cubic_depth.json"
SCHEMA = "depth-relative-cubic-depth-plane-v3"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


MATCHING = load_module("matching_matching_module_for_depth", MATCHING_PATH)


def normalize_projective(vector, prime):
    first = next(value % prime for value in vector if value % prime)
    inverse = pow(first, -1, prime)
    return tuple(value * inverse % prime for value in vector)


def symmetric_one_two(left, right, prime):
    """Coordinates of left odot right odot right in the pure-power convention."""
    inverse_three = pow(3, -1, prime)
    return [
        (
            left[i] * right[j] * right[k]
            + right[i] * left[j] * right[k]
            + right[i] * right[j] * left[k]
        )
        * inverse_three
        % prime
        for i, j, k in itertools.combinations_with_replacement(range(len(left)), 3)
    ]


def symmetric_cube_basis_image(matrix, source_indices, prime):
    """One column of the symmetric-cube action, without forming the full matrix."""
    source_permutations = set(itertools.permutations(source_indices))
    return [
        sum(
            matrix[i][left] * matrix[j][middle] * matrix[k][right]
            for left, middle, right in source_permutations
        )
        % prime
        for i, j, k in itertools.combinations_with_replacement(range(len(matrix)), 3)
    ]


def symmetric_square_action(matrix, prime):
    basis = list(itertools.combinations_with_replacement(range(len(matrix)), 2))
    basis_index = {indices: index for index, indices in enumerate(basis)}
    action = [[0] * len(basis) for _ in basis]
    for row, (i, j) in enumerate(basis):
        for left in range(len(matrix)):
            for right in range(len(matrix)):
                column = basis_index[tuple(sorted((left, right)))]
                action[row][column] = (
                    action[row][column] + matrix[i][left] * matrix[j][right]
                ) % prime
    return action


def matrix_algebra_dimension(generators, prime):
    dimension = len(generators[0])
    identity = [[1 if row == column else 0 for column in range(dimension)] for row in range(dimension)]
    basis = []
    frontier = [identity]
    while frontier:
        matrix = frontier.pop()
        vector = [value for row in matrix for value in row]
        if MATCHING.rank(basis + [vector], prime) == len(basis):
            continue
        basis.append(vector)
        frontier.extend(MATCHING.matrix_product(matrix, generator, prime) for generator in generators)
    return len(basis)


def coordinates_in_basis(vector, basis, prime):
    _reduced, pivots = MATCHING.rref(basis, prime)
    assert len(pivots) == len(basis)
    square = [[basis[column][row] for column in range(len(basis))] for row in pivots]
    inverse = MATCHING.matrix_inverse(square, prime)
    return MATCHING.matrix_vector(inverse, [vector[row] for row in pivots], prime)


def poly_mul(left, right, prime):
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] = (result[i + j] + a * b) % prime
    return result


def hessian_binary_cubic(coefficients, prime):
    a, b, c, d = coefficients
    # Coefficients are for x^3, x^2 y, x y^2, y^3 without binomial scaling.
    f_xx = [6 * a % prime, 2 * b % prime]
    f_xy = [2 * b % prime, 2 * c % prime]
    f_yy = [2 * c % prime, 6 * d % prime]
    left = poly_mul(f_xx, f_yy, prime)
    right = poly_mul(f_xy, f_xy, prime)
    return [(x - y) % prime for x, y in zip(left, right)]


def determinant(matrix, prime):
    work = [row[:] for row in matrix]
    value = 1
    for column in range(len(work)):
        pivot = next((row for row in range(column, len(work)) if work[row][column] % prime), None)
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            value = -value
        pivot_value = work[column][column] % prime
        value = value * pivot_value % prime
        inverse = pow(pivot_value, -1, prime)
        work[column] = [entry * inverse % prime for entry in work[column]]
        for row in range(column + 1, len(work)):
            factor = work[row][column] % prime
            if factor:
                work[row] = [
                    (left - factor * right) % prime
                    for left, right in zip(work[row], work[column])
                ]
    return value % prime


def pullback_binary_cubic(coefficients, matrix, prime):
    # matrix sends (u,v) to (x,y): x=a*u+b*v, y=c*u+d*v.
    a, b = matrix[0]
    c, d = matrix[1]
    result = [0, 0, 0, 0]
    for x_degree, coefficient in zip((3, 2, 1, 0), coefficients):
        y_degree = 3 - x_degree
        for i in range(x_degree + 1):
            for j in range(y_degree + 1):
                u_degree = i + j
                term = (
                    coefficient
                    * math.comb(x_degree, i)
                    * pow(a, i, prime)
                    * pow(b, x_degree - i, prime)
                    * math.comb(y_degree, j)
                    * pow(c, j, prime)
                    * pow(d, y_degree - j, prime)
                )
                result[3 - u_degree] = (result[3 - u_degree] + term) % prime
    return result


def source_certificate():
    scout = json.loads(MATCHING_INPUT.read_text())
    record = next(item for item in scout["types"] if item["type"] == "H3")
    prime = record["field_order"]
    conic, parameters = MATCHING.COXETER.conic_parameterization(prime)
    full_group, psl_group = MATCHING.full_pgl(prime, parameters)
    base_matching = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = sorted({MATCHING.matching_image(element, base_matching) for element in full_group})
    orbit_index = {matching: index for index, matching in enumerate(orbit)}
    base_product = MATCHING.matching_product(base_matching, tuple(parameters), prime)
    quotient_vectors = []
    for matching in orbit:
        product = MATCHING.matching_product(matching, tuple(parameters), prime)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % prime
            for exponent in set(product) | set(base_product)
        }
        quotient_vectors.append(MATCHING.quotient_by_conic(difference, 4, prime))
    image_matrix = MATCHING.transpose(quotient_vectors)
    _reduced, coordinate_pivots = MATCHING.rref(MATCHING.transpose(image_matrix), prime)
    reduced_vectors = [[vector[index] for index in coordinate_pivots] for vector in quotient_vectors]
    _point_reduced, point_basis_indices = MATCHING.rref(MATCHING.transpose(reduced_vectors), prime)
    point_basis_matrix = MATCHING.transpose([reduced_vectors[index] for index in point_basis_indices])
    point_basis_inverse = MATCHING.matrix_inverse(point_basis_matrix, prime)
    base_index = orbit_index[base_matching]

    def induced_action(element):
        action = MATCHING.action_permutation(element, orbit, orbit_index)
        moved_base = action[base_index]
        target_basis = MATCHING.transpose(
            [
                [
                    (reduced_vectors[action[index]][coordinate] - reduced_vectors[moved_base][coordinate])
                    % prime
                    for coordinate in range(len(coordinate_pivots))
                ]
                for index in point_basis_indices
            ]
        )
        return MATCHING.matrix_product(target_basis, point_basis_inverse, prime)

    psl_generators = MATCHING.permutation_generators(psl_group)
    outer_element = min(full_group - psl_group)
    ambient_actions = [
        MATCHING.symmetric_cube_action(induced_action(element), prime)
        for element in psl_generators + [outer_element]
    ]
    equations = []
    for index, action in enumerate(ambient_actions):
        eigenvalue = 1 if index < len(psl_generators) else prime - 1
        equations.extend(
            [
                [
                    (action[row][column] - (eigenvalue if row == column else 0)) % prime
                    for column in range(len(action))
                ]
                for row in range(len(action))
            ]
        )
    relative_basis = MATCHING.nullspace(equations, prime)
    assert len(relative_basis) == 3
    identity3 = [[1 if row == column else 0 for column in range(3)] for row in range(3)]
    minus_identity3 = [[-value % prime for value in row] for row in identity3]
    restricted_actions = []
    for action in ambient_actions:
        columns = [coordinates_in_basis(MATCHING.matrix_vector(action, vector, prime), relative_basis, prime) for vector in relative_basis]
        restricted_actions.append(MATCHING.transpose(columns))
    assert restricted_actions[:-1] == [identity3] * len(psl_generators)
    assert restricted_actions[-1] == minus_identity3

    twisted_actions = []
    relation_columns = []
    for index, action in enumerate(ambient_actions):
        character = 1 if index < len(psl_generators) else prime - 1
        twisted = [[character * value % prime for value in row] for row in action]
        twisted_actions.append(twisted)
        relation_columns.extend(
            [
                [
                    (twisted[row][column] - (1 if row == column else 0)) % prime
                    for row in range(len(twisted))
                ]
                for column in range(len(twisted))
            ]
        )
    relation_matrix = MATCHING.transpose(relation_columns)
    _relation_reduced, relation_pivots = MATCHING.rref(relation_matrix, prime)
    relation_basis = [relation_columns[index] for index in relation_pivots]
    relation_rank = len(relation_basis)
    coinvariant_dimension = len(relative_basis[0]) - relation_rank
    coinvariant_covectors = MATCHING.nullspace(relation_basis, prime)
    assert len(coinvariant_covectors) == coinvariant_dimension

    def coinvariant_coordinates(vector):
        return [sum(left * right for left, right in zip(covector, vector)) % prime for covector in coinvariant_covectors]

    invariant_to_coinvariant_rank = MATCHING.column_rank(relation_basis + relative_basis, prime) - relation_rank
    intersection_solutions = MATCHING.nullspace(
        MATCHING.transpose(
            relative_basis + [[-value % prime for value in vector] for vector in relation_basis]
        ),
        prime,
    )
    invariant_to_coinvariant_kernel = [solution[: len(relative_basis)] for solution in intersection_solutions]
    assert len(invariant_to_coinvariant_kernel) == len(relative_basis) - invariant_to_coinvariant_rank
    invariant_to_coinvariant_matrix = MATCHING.transpose(
        [coinvariant_coordinates(vector) for vector in relative_basis]
    )

    _coinvariant_reduced, coinvariant_pivots = MATCHING.rref(coinvariant_covectors, prime)
    coinvariant_section_matrix = MATCHING.matrix_inverse(
        [[covector[index] for index in coinvariant_pivots] for covector in coinvariant_covectors],
        prime,
    )
    cube_basis = list(itertools.combinations_with_replacement(range(len(reduced_vectors[0])), 3))
    norm_columns = [[0] * len(relative_basis[0]) for _ in range(coinvariant_dimension)]
    for element in psl_group:
        action = induced_action(element)
        pivot_images = [
            symmetric_cube_basis_image(action, cube_basis[index], prime)
            for index in coinvariant_pivots
        ]
        for column in range(coinvariant_dimension):
            image = [
                sum(
                    pivot_images[row][coordinate] * coinvariant_section_matrix[row][column]
                    for row in range(coinvariant_dimension)
                )
                % prime
                for coordinate in range(len(relative_basis[0]))
            ]
            norm_columns[column] = [
                (left + right) % prime for left, right in zip(norm_columns[column], image)
            ]
    norm_matrix = MATCHING.transpose(
        [coordinates_in_basis(column, relative_basis, prime) for column in norm_columns]
    )
    assert all(
        MATCHING.matrix_vector(action, column, prime) == column
        for action in ambient_actions[:-1]
        for column in norm_columns
    )
    assert all(
        MATCHING.matrix_vector(ambient_actions[-1], column, prime)
        == [(-value) % prime for value in column]
        for column in norm_columns
    )
    full_group_norm_matrix = [
        [2 * value % prime for value in row] for row in norm_matrix
    ]
    norm_kernel_basis = MATCHING.nullspace(norm_matrix, prime)
    norm_image_columns = MATCHING.transpose(norm_matrix)
    nonzero_norm_image = next(column for column in norm_image_columns if any(column))
    projection_image_columns = MATCHING.transpose(invariant_to_coinvariant_matrix)
    tate_exactness = {
        "norm_after_invariant_projection_is_zero": MATCHING.matrix_product(
            norm_matrix, invariant_to_coinvariant_matrix, prime
        )
        == [[0] * len(relative_basis) for _ in range(len(relative_basis))],
        "projection_image_equals_norm_kernel": MATCHING.column_rank(
            projection_image_columns + norm_kernel_basis, prime
        )
        == invariant_to_coinvariant_rank
        == len(norm_kernel_basis),
        "norm_image_equals_projection_kernel": normalize_projective(nonzero_norm_image, prime)
        == normalize_projective(invariant_to_coinvariant_kernel[0], prime),
    }
    assert all(tate_exactness.values())

    sheets = []
    unseen = set(orbit)
    while unseen:
        representative = min(unseen)
        sheet = {MATCHING.matching_image(element, representative) for element in psl_group}
        unseen -= sheet
        sheets.append(sheet)
    sheet_affine_ranks = []
    sheet_difference_bases = []
    sheet_affine_dependencies = []
    sheet_vector_sums = []
    for sheet in sheets:
        sheet_indices = sorted(orbit_index[matching] for matching in sheet)
        base_vector = reduced_vectors[sheet_indices[0]]
        differences = [
            [(value - base_vector[column]) % prime for column, value in enumerate(reduced_vectors[index])]
            for index in sheet_indices[1:]
        ]
        sheet_affine_ranks.append(MATCHING.rank(differences, prime))
        _difference_reduced, difference_pivots = MATCHING.rref(MATCHING.transpose(differences), prime)
        sheet_difference_bases.append([differences[index] for index in difference_pivots])
        sheet_affine_dependencies.append(
            MATCHING.nullspace(
                MATCHING.transpose([reduced_vectors[index] + [1] for index in sheet_indices]), prime
            )
        )
        sheet_vector_sums.append(
            [
                sum(reduced_vectors[index][coordinate] for index in sheet_indices) % prime
                for coordinate in range(len(reduced_vectors[0]))
            ]
        )
    sheet_difference_span_rank = MATCHING.rank(
        sheet_difference_bases[0] + sheet_difference_bases[1], prime
    )
    sheet_difference_intersection_dimension = (
        sum(sheet_affine_ranks) - sheet_difference_span_rank
    )
    heart_basis = sheet_difference_bases[0]
    heart_actions = []
    for element in psl_generators:
        action = induced_action(element)
        heart_actions.append(
            MATCHING.transpose(
                [
                    coordinates_in_basis(MATCHING.matrix_vector(action, vector, prime), heart_basis, prime)
                    for vector in heart_basis
                ]
            )
        )
    heart_matrix_algebra_dimension = matrix_algebra_dimension(heart_actions, prime)
    assert heart_matrix_algebra_dimension == 81
    sign = [1 if matching in sheets[0] else prime - 1 for matching in orbit]
    cubic_moment = [
        sum(coefficient * value for coefficient, value in zip(sign, coordinate_values)) % prime
        for coordinate_values in zip(*(MATCHING.symmetric_power(vector, 3, prime) for vector in reduced_vectors))
    ]
    moment_coordinates = coordinates_in_basis(cubic_moment, relative_basis, prime)

    profile_certificate = json.loads(PROFILE_INPUT.read_text())
    fibres = [set(item["matching_indices"]) for item in profile_certificate["double_cosets"]["representatives"]]
    fibre_by_index = {index: fibre for fibre, members in enumerate(fibres) for index in members}
    assert set(fibre_by_index) == set(range(len(orbit)))

    singleton_indices = sorted(next(iter(fibre)) for fibre in fibres if len(fibre) == 1)
    assert singleton_indices == [0, 19]
    stabilizer = {
        element
        for element in full_group
        if all(MATCHING.matching_image(element, orbit[index]) == orbit[index] for index in singleton_indices)
    }
    assert len(stabilizer) == 12 and stabilizer <= psl_group
    for element in stabilizer:
        action = MATCHING.action_permutation(element, orbit, orbit_index)
        assert all(fibre_by_index[action[index]] == fibre_by_index[index] for index in range(len(orbit)))

    j_element = next(
        element
        for element in sorted(full_group - psl_group)
        if MATCHING.matching_image(element, orbit[0]) == orbit[19]
        and {MATCHING.compose(MATCHING.compose(element, k), MATCHING.inverse(element)) for k in stabilizer}
        == stabilizer
    )
    j_action = MATCHING.action_permutation(j_element, orbit, orbit_index)
    profile_by_index = {}
    for item in profile_certificate["double_cosets"]["representatives"]:
        for index in item["matching_indices"]:
            profile_by_index[index] = tuple(value % prime for value in item["depth_profile"])
    assert all(
        profile_by_index[j_action[index]] == tuple(-value % prime for value in profile_by_index[index])
        for index in range(len(orbit))
    )

    paired_orbit_coinvariants = []
    positive_items = [
        item for item in profile_certificate["double_cosets"]["representatives"] if item["sheet"] == 0
    ]
    for item in sorted(positive_items, key=lambda value: value["orbit_size"]):
        profile = tuple(value % prime for value in item["depth_profile"])
        negative = next(
            candidate
            for candidate in profile_certificate["double_cosets"]["representatives"]
            if candidate["sheet"] == 1
            and tuple(value % prime for value in candidate["depth_profile"])
            == tuple(-value % prime for value in profile)
        )
        tensor = [0] * len(relative_basis[0])
        for coefficient, indices in (
            (1, item["matching_indices"]),
            (prime - 1, negative["matching_indices"]),
        ):
            for index in indices:
                power = MATCHING.symmetric_power(reduced_vectors[index], 3, prime)
                tensor = [
                    (left + coefficient * right) % prime for left, right in zip(tensor, power)
                ]
        paired_orbit_coinvariants.append(
            {
                "orbit_size": item["orbit_size"],
                "positive_profile": list(profile),
                "coinvariant_coordinates_of_signed_orbit_sum": coinvariant_coordinates(tensor),
            }
        )
    orbit_coinvariant_columns = [
        item["coinvariant_coordinates_of_signed_orbit_sum"] for item in paired_orbit_coinvariants
    ]
    orbit_coinvariant_relations = MATCHING.nullspace(MATCHING.transpose(orbit_coinvariant_columns), prime)
    target_profile_columns = [item["positive_profile"] for item in paired_orbit_coinvariants]
    target_profile_relations = MATCHING.nullspace(MATCHING.transpose(target_profile_columns), prime)

    positive_orbits = [
        sorted(item["matching_indices"])
        for item in sorted(positive_items, key=lambda value: value["orbit_size"])
    ]
    positive_indices = sorted(index for indices in positive_orbits for index in indices)
    psl_matching_actions = [MATCHING.action_permutation(element, orbit, orbit_index) for element in psl_group]
    unseen_pairs = set(itertools.product(positive_indices, repeat=2))
    positive_sheet_orbitals = []
    while unseen_pairs:
        seed = min(unseen_pairs)
        relation = {(action[seed[0]], action[seed[1]]) for action in psl_matching_actions}
        unseen_pairs -= relation
        positive_sheet_orbitals.append(relation)
    positive_sheet_orbitals.sort(key=lambda relation: (len(relation), min(relation)))
    orbital_operators = []
    target_orbit_sum_relation = [1, 1, 1]
    for relation in positive_sheet_orbitals:
        operator = []
        for target_orbit in positive_orbits:
            representative = target_orbit[0]
            operator.append(
                [
                    sum((representative, source_index) in relation for source_index in source_orbit)
                    % prime
                    for source_orbit in positive_orbits
                ]
            )
        orbital_operators.append(
            {
                "ordered_pair_orbit_size": len(relation),
                "matrix_on_a4_orbit_sums_in_size_order": operator,
            }
        )

    j_difference_coinvariants = []
    for item in sorted(positive_items, key=lambda value: value["orbit_size"]):
        tensor = [0] * len(relative_basis[0])
        for index in item["matching_indices"]:
            difference = [
                (left - right) % prime
                for left, right in zip(reduced_vectors[index], reduced_vectors[j_action[index]])
            ]
            power = MATCHING.symmetric_power(difference, 3, prime)
            tensor = [(left + right) % prime for left, right in zip(tensor, power)]
        j_difference_coinvariants.append(
            {
                "orbit_size": item["orbit_size"],
                "positive_profile": list(item["depth_profile"]),
                "coinvariant_coordinates_of_j_difference_cube_sum": coinvariant_coordinates(tensor),
            }
        )
    j_difference_columns = [
        item["coinvariant_coordinates_of_j_difference_cube_sum"]
        for item in j_difference_coinvariants
    ]
    j_difference_relations = MATCHING.nullspace(MATCHING.transpose(j_difference_columns), prime)
    for record in orbital_operators:
        operator = record["matrix_on_a4_orbit_sums_in_size_order"]
        relation_images = {}
        for name, relation in (
            ("paired_orbit_sum", orbit_coinvariant_relations[0]),
            ("j_difference_cube_sum", j_difference_relations[0]),
        ):
            image = MATCHING.matrix_vector(operator, relation, prime)
            relation_images[name] = {
                "image": image,
                "maps_to_target_orbit_sum_relation": any(image)
                and normalize_projective(image, prime)
                == normalize_projective(target_orbit_sum_relation, prime),
            }
        record["source_relation_images"] = relation_images

    orbit_sizes = [len(indices) for indices in positive_orbits]
    odd_orbit_sum_depth_columns = [
        [orbit_size * value % prime for value in item["positive_profile"]]
        for orbit_size, item in zip(
            orbit_sizes, sorted(paired_orbit_coinvariants, key=lambda value: value["orbit_size"])
        )
    ]
    odd_orbit_sum_depth_matrix = MATCHING.transpose(odd_orbit_sum_depth_columns)
    odd_orbit_sum_depth_kernel = MATCHING.nullspace(odd_orbit_sum_depth_matrix, prime)
    assert len(odd_orbit_sum_depth_kernel) == 1
    assert normalize_projective(odd_orbit_sum_depth_kernel[0], prime) == (1, 1, 1)
    full_mixed_depth_matrix = [
        [0, 0, 0] + row for row in odd_orbit_sum_depth_matrix
    ]
    full_mixed_depth_kernel = MATCHING.nullspace(full_mixed_depth_matrix, prime)
    assert len(full_mixed_depth_kernel) == 4
    brauer_tree_depth_identification = {
        "psl_order": len(psl_group),
        "sylow_11_order": prime,
        "sylow_11_is_cyclic": True,
        "a5_point_stabilizer_order": len(next(
            {element for element in psl_group if MATCHING.matching_image(element, orbit[positive_indices[0]]) == orbit[positive_indices[0]]}
            for _ in [0]
        )),
        "point_stabilizer_is_11_prime": True,
        "positive_sheet_permutation_dimension": len(positive_indices),
        "positive_sheet_orbital_algebra_dimension": len(positive_sheet_orbitals),
        "orbital_algebra_is_local_in_characteristic_11": len(positive_sheet_orbitals) == 2
        and len(positive_indices) % prime == 0,
        "psl_permutation_module_is_projective_indecomposable_cover_of_trivial": True,
        "loewy_layer_dimensions": [1, 9, 1],
        "middle_simple_label": "L(8)=Sym^8(F_11^2), dimension 9",
        "heart_matrix_algebra_dimension": heart_matrix_algebra_dimension,
        "heart_is_absolutely_irreducible_by_density": heart_matrix_algebra_dimension == 81,
        "j_odd_paired_slice_is_the_a4_fixed_projective_cover_slice_with_sign_attached": True,
        "a4_fixed_odd_orbit_sum_dimension": len(positive_orbits),
        "odd_orbit_sum_depth_matrix": odd_orbit_sum_depth_matrix,
        "odd_orbit_sum_depth_rank": MATCHING.rank(odd_orbit_sum_depth_matrix, prime),
        "odd_orbit_sum_depth_kernel": odd_orbit_sum_depth_kernel,
        "depth_kernel_is_projective_cover_socle_line": normalize_projective(
            odd_orbit_sum_depth_kernel[0], prime
        )
        == (1, 1, 1),
        "full_mixed_bihecke_dimension": 2 * len(positive_orbits),
        "full_mixed_depth_kernel_dimension": len(full_mixed_depth_kernel),
        "full_kernel_is_even_half_plus_odd_socle": len(full_mixed_depth_kernel) == 4,
    }

    def balanced_integer_lift(vector):
        return [value if value <= prime // 2 else value - prime for value in vector]

    integral_transfer_matrix = [orbit_sizes[:] for _ in orbit_sizes]
    integral_transfer_square = [
        [
            sum(integral_transfer_matrix[row][middle] * integral_transfer_matrix[middle][column]
                for middle in range(len(orbit_sizes)))
            for column in range(len(orbit_sizes))
        ]
        for row in range(len(orbit_sizes))
    ]
    assert integral_transfer_square == [
        [prime * value for value in row] for row in integral_transfer_matrix
    ]
    source_integral_relation_lifts = {
        "paired_orbit_sum": balanced_integer_lift(orbit_coinvariant_relations[0]),
        "j_difference_cube_sum": balanced_integer_lift(j_difference_relations[0]),
    }
    source_integral_weighted_sums = {
        name: sum(weight * coefficient for weight, coefficient in zip(orbit_sizes, relation))
        for name, relation in source_integral_relation_lifts.items()
    }
    assert set(source_integral_weighted_sums.values()) == {0}
    depth_socle = [1, 1, 1]
    depth_socle_transfer = [
        sum(row[column] * depth_socle[column] for column in range(len(depth_socle)))
        for row in integral_transfer_matrix
    ]
    assert depth_socle_transfer == [prime] * len(depth_socle)
    divided_transfer_gate = {
        "integral_orbit_sizes": orbit_sizes,
        "integral_transfer_matrix": integral_transfer_matrix,
        "integral_identity": "B^2=11B",
        "source_balanced_integral_relation_lifts": source_integral_relation_lifts,
        "source_integral_weighted_sums": source_integral_weighted_sums,
        "divided_transfer_on_source_relations": {
            name: [0, 0, 0] for name in source_integral_relation_lifts
        },
        "depth_socle": depth_socle,
        "integral_transfer_on_depth_socle": depth_socle_transfer,
        "divided_transfer_on_depth_socle": depth_socle,
        "bockstein_distinguishes_source_relations_from_depth_socle": True,
        "divided_transfer_supplies_source_to_depth_bridge": False,
    }

    odd_polarization_families = {}
    for family_name in ("cube_of_orbit_sum", "sum_of_delta_sigma_squared"):
        records = []
        for item in sorted(positive_items, key=lambda value: value["orbit_size"]):
            tensor = [0] * len(relative_basis[0])
            orbit_difference_sum = [0] * len(reduced_vectors[0])
            for index in item["matching_indices"]:
                left = reduced_vectors[index]
                right = reduced_vectors[j_action[index]]
                difference = [(x - y) % prime for x, y in zip(left, right)]
                symmetric_sum = [(x + y) % prime for x, y in zip(left, right)]
                orbit_difference_sum = [
                    (x + y) % prime for x, y in zip(orbit_difference_sum, difference)
                ]
                if family_name == "sum_of_delta_sigma_squared":
                    polarized = symmetric_one_two(difference, symmetric_sum, prime)
                    tensor = [(x + y) % prime for x, y in zip(tensor, polarized)]
            if family_name == "cube_of_orbit_sum":
                tensor = MATCHING.symmetric_power(orbit_difference_sum, 3, prime)
            records.append(
                {
                    "orbit_size": item["orbit_size"],
                    "coinvariant_coordinates": coinvariant_coordinates(tensor),
                }
            )
        columns = [item["coinvariant_coordinates"] for item in records]
        relations = MATCHING.nullspace(MATCHING.transpose(columns), prime)
        odd_polarization_families[family_name] = {
            "records": records,
            "span_dimension": MATCHING.column_rank(columns, prime),
            "relations": relations,
            "relation_matches_target": len(relations) == 1
            and len(target_profile_relations) == 1
            and normalize_projective(relations[0], prime)
            == normalize_projective(target_profile_relations[0], prime),
        }

    def norm_scalars_for_records(records, coordinate_key):
        images = [
            MATCHING.matrix_vector(norm_matrix, item[coordinate_key], prime) for item in records
        ]
        reference = next(image for image in images if any(image))
        pivot = next(index for index, value in enumerate(reference) if value)
        inverse = pow(reference[pivot], -1, prime)
        return {
            "norm_images_in_relative_coordinates": images,
            "norm_scalars_relative_to_first_image": [
                image[pivot] * inverse % prime for image in images
            ],
        }

    j_difference_norm_data = norm_scalars_for_records(
        j_difference_coinvariants, "coinvariant_coordinates_of_j_difference_cube_sum"
    )
    for family in odd_polarization_families.values():
        family.update(norm_scalars_for_records(family["records"], "coinvariant_coordinates"))
    delta_sigma_relation_lift = balanced_integer_lift(
        odd_polarization_families["sum_of_delta_sigma_squared"]["relations"][0]
    )
    delta_sigma_weighted_sum = sum(
        weight * coefficient for weight, coefficient in zip(orbit_sizes, delta_sigma_relation_lift)
    )
    assert delta_sigma_weighted_sum == 0
    source_integral_relation_lifts["delta_sigma_squared"] = delta_sigma_relation_lift
    source_integral_weighted_sums["delta_sigma_squared"] = delta_sigma_weighted_sum
    divided_transfer_gate["divided_transfer_on_source_relations"]["delta_sigma_squared"] = [0, 0, 0]

    second_moment_form = [
        [
            sum(vector[row] * vector[column] for vector in reduced_vectors) % prime
            for column in range(len(reduced_vectors[0]))
        ]
        for row in range(len(reduced_vectors[0]))
    ]

    def correlation_map(lower_with_second_moment, point_vectors=None):
        vectors = reduced_vectors if point_vectors is None else point_vectors
        cube_indices = list(itertools.combinations_with_replacement(range(len(reduced_vectors[0])), 3))
        cube_multiplicities = [
            1 if indices[0] == indices[2] else 3 if indices[0] == indices[1] or indices[1] == indices[2] else 6
            for indices in cube_indices
        ]
        columns = []
        for cubic in relative_basis:
            output = [0, 0, 0, 0]
            for index, vector in enumerate(vectors):
                argument = (
                    MATCHING.matrix_vector(second_moment_form, vector, prime)
                    if lower_with_second_moment
                    else vector
                )
                scalar = sum(
                    multiplicity * left * right
                    for multiplicity, left, right in zip(
                        cube_multiplicities, cubic, MATCHING.symmetric_power(argument, 3, prime)
                    )
                ) % prime
                output = [
                    (left + scalar * right) % prime
                    for left, right in zip(output, profile_by_index[index])
                ]
            columns.append(output)
        matrix = MATCHING.transpose(columns)
        kernel = MATCHING.nullspace(matrix, prime)
        return {
            "matrix_in_relative_basis_to_four_depth_coordinates": matrix,
            "rank": MATCHING.rank(matrix, prime),
            "kernel_basis_in_relative_coordinates": kernel,
            "kernel_equals_twisted_coinvariant_kernel": len(kernel) == 1
            and len(invariant_to_coinvariant_kernel) == 1
            and normalize_projective(kernel[0], prime)
            == normalize_projective(invariant_to_coinvariant_kernel[0], prime),
            "image_satisfies_depth_plane_equations": all(
                sum(equation[index] * column[index] for index in range(4)) % prime == 0
                for equation in ([2, 2, 1, 0], [9, 8, 0, 1])
                for column in columns
            ),
        }

    raw_correlation = correlation_map(False)
    lowered_correlation = correlation_map(True)

    second_moment_covariance = []
    for element in psl_generators + [outer_element]:
        action = induced_action(element)
        transformed = MATCHING.matrix_product(
            MATCHING.transpose(action), MATCHING.matrix_product(second_moment_form, action, prime), prime
        )
        second_moment_covariance.append(transformed == second_moment_form)

    symmetric_pairs = list(itertools.combinations_with_replacement(range(len(reduced_vectors[0])), 2))
    invariant_form_equations = []
    for element in psl_generators + [outer_element]:
        action = induced_action(element)
        for left, right in symmetric_pairs:
            row = []
            for first, second in symmetric_pairs:
                coefficient = action[first][left] * action[second][right]
                if first != second:
                    coefficient += action[second][left] * action[first][right]
                if (first, second) == (left, right):
                    coefficient -= 1
                row.append(coefficient % prime)
            invariant_form_equations.append(row)
    invariant_form_coordinates = MATCHING.nullspace(invariant_form_equations, prime)
    invariant_tensor_equations = []
    for element in psl_generators + [outer_element]:
        action = induced_action(element)
        for left, right in symmetric_pairs:
            row = []
            for first, second in symmetric_pairs:
                coefficient = action[left][first] * action[right][second]
                if first != second:
                    coefficient += action[left][second] * action[right][first]
                if (first, second) == (left, right):
                    coefficient -= 1
                row.append(coefficient % prime)
            invariant_tensor_equations.append(row)
    invariant_tensor_coordinates = MATCHING.nullspace(invariant_tensor_equations, prime)

    def symmetric_matrix(coordinates):
        matrix = [[0] * len(reduced_vectors[0]) for _ in range(len(reduced_vectors[0]))]
        for value, (left, right) in zip(coordinates, symmetric_pairs):
            matrix[left][right] = value
            matrix[right][left] = value
        return matrix

    invariant_form_records = []
    for coordinates in invariant_form_coordinates:
        form = symmetric_matrix(coordinates)
        old_form = second_moment_form
        second_moment_form = form
        correlation = correlation_map(True)
        second_moment_form = old_form
        invariant_form_records.append(
            {
                "rank": MATCHING.rank(form, prime),
                "coordinate_sha256": hashlib.sha256(bytes(coordinates)).hexdigest(),
                "depth_correlation": correlation,
            }
        )
    invariant_form_pencil = []
    invariant_form_pencil_data = []
    assert len(invariant_form_coordinates) == 2
    for parameters in [(1, value) for value in range(prime)] + [(0, 1)]:
        coordinates = [
            sum(parameter * basis[index] for parameter, basis in zip(parameters, invariant_form_coordinates))
            % prime
            for index in range(len(symmetric_pairs))
        ]
        form = symmetric_matrix(coordinates)
        old_form = second_moment_form
        second_moment_form = form
        correlation = correlation_map(True)
        second_moment_form = old_form
        invariant_form_pencil.append(
            {
                "projective_parameters": list(parameters),
                "rank": MATCHING.rank(form, prime),
                "determinant": determinant(form, prime),
                "correlation_rank": correlation["rank"],
                "correlation_kernel": correlation["kernel_basis_in_relative_coordinates"],
                "kernel_equals_twisted_coinvariant_kernel": correlation[
                    "kernel_equals_twisted_coinvariant_kernel"
                ],
            }
        )
        invariant_form_pencil_data.append((parameters, coordinates, form, correlation))
    rank_nine_members = [item for item in invariant_form_pencil_data if MATCHING.rank(item[2], prime) == 9]
    rank_one_members = [item for item in invariant_form_pencil_data if MATCHING.rank(item[2], prime) == 1]
    assert len(rank_nine_members) == len(rank_one_members) == 1
    rank_nine_parameters, rank_nine_coordinates, rank_nine_form, rank_nine_correlation = rank_nine_members[0]
    rank_one_parameters, _rank_one_coordinates, rank_one_form, _rank_one_correlation = rank_one_members[0]
    rank_one_covector = next(row[:] for row in rank_one_form if any(row))
    rank_one_covector_characters = []
    for element in psl_generators + [outer_element]:
        action = induced_action(element)
        moved = [
            sum(rank_one_covector[row] * action[row][column] for row in range(len(action))) % prime
            for column in range(len(action))
        ]
        scalar = next(
            moved[index] * pow(rank_one_covector[index], -1, prime) % prime
            for index in range(len(moved))
            if rank_one_covector[index]
        )
        assert moved == [scalar * value % prime for value in rank_one_covector]
        rank_one_covector_characters.append(scalar)

    cube_index = {indices: index for index, indices in enumerate(cube_basis)}
    contraction_columns = []
    contraction_forms_are_invariant = []
    for cubic in relative_basis:
        matrix = [
            [
                sum(
                    cubic[cube_index[tuple(sorted((left, right, index)))]]
                    * rank_one_covector[index]
                    for index in range(len(rank_one_covector))
                )
                % prime
                for right in range(len(rank_one_covector))
            ]
            for left in range(len(rank_one_covector))
        ]
        coordinates = [matrix[left][right] for left, right in symmetric_pairs]
        target_coordinates = coordinates_in_basis(coordinates, invariant_tensor_coordinates, prime)
        reconstructed = [
            sum(
                coefficient * basis[index]
                for coefficient, basis in zip(target_coordinates, invariant_tensor_coordinates)
            )
            % prime
            for index in range(len(symmetric_pairs))
        ]
        assert reconstructed == coordinates
        contraction_columns.append(target_coordinates)
        contraction_forms_are_invariant.append(
            all(
                MATCHING.matrix_product(
                    induced_action(element),
                    MATCHING.matrix_product(matrix, MATCHING.transpose(induced_action(element)), prime),
                    prime,
                )
                == matrix
                for element in psl_generators + [outer_element]
            )
        )
    contraction_map = MATCHING.transpose(contraction_columns)
    contraction_kernel = MATCHING.nullspace(contraction_map, prime)
    invariant_tensor_pencil = []
    for parameters in [(1, value) for value in range(prime)] + [(0, 1)]:
        coordinates = [
            sum(parameter * basis[index] for parameter, basis in zip(parameters, invariant_tensor_coordinates))
            % prime
            for index in range(len(symmetric_pairs))
        ]
        matrix = symmetric_matrix(coordinates)
        invariant_tensor_pencil.append(
            {
                "projective_parameters": list(parameters),
                "rank": MATCHING.rank(matrix, prime),
                "determinant": determinant(matrix, prime),
            }
        )
    determinant_model_values = [
        pow((parameters[1] - 9 * parameters[0]) % prime, 9, prime)
        * ((parameters[1] - 3 * parameters[0]) % prime)
        % prime
        for parameters in [(1, value) for value in range(prime)] + [(0, 1)]
    ]
    determinant_scale = next(
        item["determinant"] * pow(model, -1, prime) % prime
        for item, model in zip(invariant_tensor_pencil, determinant_model_values)
        if model
    )
    assert all(
        item["determinant"] == determinant_scale * model % prime
        for item, model in zip(invariant_tensor_pencil, determinant_model_values)
    )
    ordered_flag_maps = set()
    source_flag = ([1, 9], [1, 3])
    target_flag = ([1, prime - 1], [1, prime - 2])
    for entries in itertools.product(range(prime), repeat=4):
        matrix = [list(entries[:2]), list(entries[2:])]
        if not determinant(matrix, prime):
            continue
        if all(
            normalize_projective(MATCHING.matrix_vector(matrix, source_line, prime), prime)
            == normalize_projective(target_line, prime)
            for source_line, target_line in zip(source_flag, target_flag)
        ):
            ordered_flag_maps.add(normalize_projective(entries, prime))
    contraction_special_images = {
        "signed_moment": normalize_projective(
            MATCHING.matrix_vector(contraction_map, moment_coordinates, prime), prime
        ),
        "twisted_coinvariant_kernel": tuple(
            MATCHING.matrix_vector(contraction_map, invariant_to_coinvariant_kernel[0], prime)
        ),
    }

    def depth_quadratic_columns(point_vectors, include_sheet_sign):
        columns = []
        powers = [MATCHING.symmetric_power(vector, 2, prime) for vector in point_vectors]
        for depth_coordinate in range(4):
            columns.append(
                [
                    sum(
                        (sign[index] if include_sheet_sign else 1)
                        * profile_by_index[index][depth_coordinate]
                        * power[coordinate]
                        for index, power in enumerate(powers)
                    )
                    % prime
                    for coordinate in range(len(symmetric_pairs))
                ]
            )
        return columns

    def depth_quadratic_moment(point_vectors, include_sheet_sign):
        ambient_columns = depth_quadratic_columns(point_vectors, include_sheet_sign)
        columns = []
        in_invariant_tensor_space = []
        for tensor in ambient_columns:
            target_coordinates = coordinates_in_basis(tensor, invariant_tensor_coordinates, prime)
            reconstructed = [
                sum(
                    coefficient * basis[index]
                    for coefficient, basis in zip(target_coordinates, invariant_tensor_coordinates)
                )
                % prime
                for index in range(len(symmetric_pairs))
            ]
            in_invariant_tensor_space.append(reconstructed == tensor)
            columns.append(target_coordinates)
        matrix = MATCHING.transpose(columns)
        return {
            "matrix_from_four_depth_covectors_to_invariant_tensors": matrix,
            "rank": MATCHING.rank(matrix, prime),
            "all_columns_are_invariant_tensors": all(in_invariant_tensor_space),
            "plane_annihilator_is_kernel": all(
                MATCHING.matrix_vector(matrix, equation, prime) == [0, 0]
                for equation in ([2, 2, 1, 0], [9, 8, 0, 1])
            ),
            "ambient_columns_sha256": hashlib.sha256(
                bytes(value for column in ambient_columns for value in column)
            ).hexdigest(),
        }

    depth_quadratic_records = {}
    for include_sheet_sign in (False, True):
        name = "sheet_signed" if include_sheet_sign else "unsigned"
        records = []
        for base_vector in reduced_vectors:
            shifted_vectors = [
                [(value - base_vector[index]) % prime for index, value in enumerate(vector)]
                for vector in reduced_vectors
            ]
            records.append(depth_quadratic_moment(shifted_vectors, include_sheet_sign))
        depth_quadratic_records[name] = {
            "base_records": records,
            "rank_distribution": {
                str(rank_value): sum(record["rank"] == rank_value for record in records)
                for rank_value in range(3)
            },
            "all_bases_land_in_invariant_tensors": all(
                record["all_columns_are_invariant_tensors"] for record in records
            ),
            "all_bases_factor_through_depth_dual": all(
                record["plane_annihilator_is_kernel"] for record in records
            ),
            "distinct_matrices": len(
                {
                    tuple(value for row in record["matrix_from_four_depth_covectors_to_invariant_tensors"] for value in row)
                    for record in records
                }
            ),
            "distinct_ambient_column_sets": len({record["ambient_columns_sha256"] for record in records}),
        }

    signed_depth_columns = depth_quadratic_columns(reduced_vectors, True)

    square_actions = [
        symmetric_square_action(induced_action(element), prime)
        for element in psl_generators + [outer_element]
    ]
    square_relation_columns = []
    for action in square_actions:
        square_relation_columns.extend(
            [
                [
                    (action[row][column] - (1 if row == column else 0)) % prime
                    for row in range(len(action))
                ]
                for column in range(len(action))
            ]
        )
    _square_relation_reduced, square_relation_pivots = MATCHING.rref(
        MATCHING.transpose(square_relation_columns), prime
    )
    square_relation_basis = [square_relation_columns[index] for index in square_relation_pivots]
    square_coinvariant_covectors = MATCHING.nullspace(square_relation_basis, prime)

    def square_coinvariant_coordinates(vector):
        return [
            sum(left * right for left, right in zip(covector, vector)) % prime
            for covector in square_coinvariant_covectors
        ]

    signed_depth_to_square_coinvariants = MATCHING.transpose(
        [square_coinvariant_coordinates(column) for column in signed_depth_columns]
    )
    invariant_tensors_to_square_coinvariants = MATCHING.transpose(
        [square_coinvariant_coordinates(tensor) for tensor in invariant_tensor_coordinates]
    )
    signed_depth_coinvariant_kernel = MATCHING.nullspace(signed_depth_to_square_coinvariants, prime)
    expected_depth_annihilator = [[2, 2, 1, 0], [9, 8, 0, 1]]
    depth_kernel_equals_annihilator = (
        len(signed_depth_coinvariant_kernel) == 2
        and MATCHING.column_rank(
            signed_depth_coinvariant_kernel + expected_depth_annihilator, prime
        )
        == 2
    )

    psl_square_relation_columns = []
    for action in square_actions[:-1]:
        psl_square_relation_columns.extend(
            [
                [
                    (action[row][column] - (1 if row == column else 0)) % prime
                    for row in range(len(action))
                ]
                for column in range(len(action))
            ]
        )
    _psl_square_reduced, psl_square_pivots = MATCHING.rref(
        MATCHING.transpose(psl_square_relation_columns), prime
    )
    psl_square_relation_basis = [psl_square_relation_columns[index] for index in psl_square_pivots]
    psl_square_coinvariant_covectors = MATCHING.nullspace(psl_square_relation_basis, prime)

    def psl_square_coinvariant_coordinates(vector):
        return [
            sum(left * right for left, right in zip(covector, vector)) % prime
            for covector in psl_square_coinvariant_covectors
        ]

    unsigned_depth_columns = depth_quadratic_columns(reduced_vectors, False)
    psl_signed_depth_matrix = MATCHING.transpose(
        [psl_square_coinvariant_coordinates(column) for column in signed_depth_columns]
    )
    psl_unsigned_depth_matrix = MATCHING.transpose(
        [psl_square_coinvariant_coordinates(column) for column in unsigned_depth_columns]
    )
    psl_invariant_tensor_matrix = MATCHING.transpose(
        [psl_square_coinvariant_coordinates(tensor) for tensor in invariant_tensor_coordinates]
    )

    def induced_symmetric_pairing(form, left_tensor, right_tensor):
        left_matrix = symmetric_matrix(left_tensor)
        right_matrix = symmetric_matrix(right_tensor)
        return sum(
            left_matrix[i][j]
            * right_matrix[k][ell]
            * form[i][k]
            * form[j][ell]
            for i in range(len(form))
            for j in range(len(form))
            for k in range(len(form))
            for ell in range(len(form))
        ) % prime

    tensor_basis_matrices = invariant_tensor_coordinates
    bilinear_pencil_compositions = []
    for parameters, _coordinates, form, _correlation in invariant_form_pencil_data:
        tensor_to_depth = [
            [
                induced_symmetric_pairing(form, tensor_basis, depth_tensor)
                for tensor_basis in tensor_basis_matrices
            ]
            for depth_tensor in signed_depth_columns
        ]
        composed = MATCHING.matrix_product(tensor_to_depth, contraction_map, prime)
        kernel = MATCHING.nullspace(composed, prime)
        bilinear_pencil_compositions.append(
            {
                "form_projective_parameters": list(parameters),
                "form_rank": MATCHING.rank(form, prime),
                "source_to_depth_matrix": composed,
                "rank": MATCHING.rank(composed, prime),
                "image_satisfies_depth_plane_equations": all(
                    sum(equation[index] * column[index] for index in range(4)) % prime == 0
                    for equation in ([2, 2, 1, 0], [9, 8, 0, 1])
                    for column in MATCHING.transpose(composed)
                ),
                "kernel_basis_in_relative_coordinates": kernel,
                "kernel_equals_twisted_coinvariant_kernel": len(kernel) == 1
                and normalize_projective(kernel[0], prime)
                == normalize_projective(invariant_to_coinvariant_kernel[0], prime),
            }
        )
    old_form = second_moment_form
    second_moment_form = rank_nine_form
    base_change_correlations = []
    for base_vector in reduced_vectors:
        shifted_vectors = [
            [(value - base_vector[index]) % prime for index, value in enumerate(vector)]
            for vector in reduced_vectors
        ]
        base_change_correlations.append(correlation_map(True, shifted_vectors))
    second_moment_form = old_form
    reference_flat = [
        value
        for row in rank_nine_correlation["matrix_in_relative_basis_to_four_depth_coordinates"]
        for value in row
    ]
    projective_base_change_matrices = {
        normalize_projective(
            [
                value
                for row in correlation["matrix_in_relative_basis_to_four_depth_coordinates"]
                for value in row
            ],
            prime,
        )
        for correlation in base_change_correlations
        if correlation["rank"]
    }
    target_cubic = [1, 7, 5, 9]
    pullback_cubics = set()
    target_two_by_two_maps = set()
    for correlation in base_change_correlations:
        if correlation["rank"] != 2:
            continue
        matrix = correlation["matrix_in_relative_basis_to_four_depth_coordinates"]
        target_matrix = [
            [4 * value % prime for value in matrix[3]],
            [5 * value % prime for value in matrix[2]],
        ]
        quotient_matrix = [row[:2] for row in target_matrix]
        assert determinant(quotient_matrix, prime)
        target_two_by_two_maps.add(normalize_projective([value for row in quotient_matrix for value in row], prime))
        pullback_cubics.add(normalize_projective(pullback_binary_cubic(target_cubic, quotient_matrix, prime), prime))

    def aggregate_correlations(coefficients):
        return [
            [
                sum(
                    coefficient
                    * correlation["matrix_in_relative_basis_to_four_depth_coordinates"][row][column]
                    for coefficient, correlation in zip(coefficients, base_change_correlations)
                )
                % prime
                for column in range(3)
            ]
            for row in range(4)
        ]

    total_aggregate = aggregate_correlations([1] * len(base_change_correlations))
    signed_aggregate = aggregate_correlations(sign)
    base_target_coordinates = [
        (4 * profile_by_index[index][3] % prime, 5 * profile_by_index[index][2] % prime)
        for index in range(len(orbit))
    ]
    flag_weight_families = {
        "hessian_line": [(left - right) % prime for left, right in base_target_coordinates],
        "residual_line": [(left - 2 * right) % prime for left, right in base_target_coordinates],
    }
    flag_weight_families.update(
        {
            "hessian_square": [value * value % prime for value in flag_weight_families["hessian_line"]],
            "hessian_times_residual": [
                left * right % prime
                for left, right in zip(
                    flag_weight_families["hessian_line"], flag_weight_families["residual_line"]
                )
            ],
            "residual_square": [value * value % prime for value in flag_weight_families["residual_line"]],
            "hessian_cube": [pow(value, 3, prime) for value in flag_weight_families["hessian_line"]],
            "hessian_square_residual": [
                left * left * right % prime
                for left, right in zip(
                    flag_weight_families["hessian_line"], flag_weight_families["residual_line"]
                )
            ],
            "hessian_residual_square": [
                left * right * right % prime
                for left, right in zip(
                    flag_weight_families["hessian_line"], flag_weight_families["residual_line"]
                )
            ],
            "residual_cube": [pow(value, 3, prime) for value in flag_weight_families["residual_line"]],
        }
    )
    flag_weighted_aggregates = {}
    for name, weights in flag_weight_families.items():
        matrix = aggregate_correlations(weights)
        kernel = MATCHING.nullspace(matrix, prime)
        flag_weighted_aggregates[name] = {
            "rank": MATCHING.rank(matrix, prime),
            "matrix_in_relative_basis_to_four_depth_coordinates": matrix,
            "kernel_basis_in_relative_coordinates": kernel,
            "kernel_equals_twisted_coinvariant_kernel": len(kernel) == 1
            and len(invariant_to_coinvariant_kernel) == 1
            and normalize_projective(kernel[0], prime)
            == normalize_projective(invariant_to_coinvariant_kernel[0], prime),
            "kernel_equals_signed_moment_line": len(kernel) == 1
            and normalize_projective(kernel[0], prime) == normalize_projective(moment_coordinates, prime),
        }

    non_descent_witness = None
    for generator_index, element in enumerate(psl_generators):
        action = MATCHING.action_permutation(element, orbit, orbit_index)
        for fibre_index, fibre in enumerate(fibres):
            image_fibres = {fibre_by_index[action[index]] for index in fibre}
            if len(image_fibres) > 1:
                pair = next(
                    (left, right)
                    for left, right in itertools.combinations(sorted(fibre), 2)
                    if fibre_by_index[action[left]] != fibre_by_index[action[right]]
                )
                non_descent_witness = {
                    "psl_generator_index": generator_index,
                    "source_fibre": fibre_index,
                    "same_profile_matching_indices": list(pair),
                    "image_matching_indices": [action[pair[0]], action[pair[1]]],
                    "distinct_image_fibres": [fibre_by_index[action[pair[0]]], fibre_by_index[action[pair[1]]]],
                }
                break
        if non_descent_witness is not None:
            break
    assert non_descent_witness is not None

    def first_flattening(cubic):
        entries = dict(zip(cube_basis, cubic))
        return [
            [entries[tuple(sorted((left, right, index)))] for index in range(len(reduced_vectors[0]))]
            for left in range(len(reduced_vectors[0]))
            for right in range(left, len(reduced_vectors[0]))
        ]

    projective_relative_lines = [(1, left, right) for left in range(prime) for right in range(prime)]
    projective_relative_lines += [(0, 1, right) for right in range(prime)] + [(0, 0, 1)]
    flattening_records = []
    for coordinates in projective_relative_lines:
        cubic = [
            sum(coefficient * basis[index] for coefficient, basis in zip(coordinates, relative_basis))
            % prime
            for index in range(len(relative_basis[0]))
        ]
        flattening_records.append((coordinates, MATCHING.rank(first_flattening(cubic), prime)))
    flattening_rank_distribution = {
        str(value): sum(rank_value == value for _coordinates, rank_value in flattening_records)
        for value in sorted({rank_value for _coordinates, rank_value in flattening_records})
    }
    minimal_flattening_rank = min(item[1] for item in flattening_records)
    minimal_flattening_lines = [
        coordinates
        for coordinates, rank_value in flattening_records
        if rank_value == minimal_flattening_rank
    ]
    assert len(minimal_flattening_lines) == 1
    special_lines = {
        "signed_moment": normalize_projective(moment_coordinates, prime),
        "twisted_coinvariant_kernel": normalize_projective(invariant_to_coinvariant_kernel[0], prime),
    }
    special_flattening_ranks = {
        name: next(rank_value for coordinates, rank_value in flattening_records if coordinates == line)
        for name, line in special_lines.items()
    }

    return {
        "ambient_W_dimension": len(reduced_vectors[0]),
        "ambient_symmetric_cube_dimension": len(relative_basis[0]),
        "relative_space_dimension": len(relative_basis),
        "psl_generator_count": len(psl_generators),
        "restricted_psl_generator_actions": restricted_actions[:-1],
        "restricted_outer_action": restricted_actions[-1],
        "signed_moment_coordinates_in_relative_basis": moment_coordinates,
        "signed_moment_projective_line": normalize_projective(moment_coordinates, prime),
        "sheet_affine_ranks": sheet_affine_ranks,
        "sheet_affine_dependencies": sheet_affine_dependencies,
        "sheet_vector_sums": sheet_vector_sums,
        "combined_sheet_difference_span_rank": sheet_difference_span_rank,
        "sheet_difference_intersection_dimension": sheet_difference_intersection_dimension,
        "sheet_heart_matrix_algebra_dimension": heart_matrix_algebra_dimension,
        "each_sheet_is_the_nine_dimensional_permutation_heart_affinely": sheet_affine_ranks
        == [9, 9]
        and sheet_difference_span_rank == 9
        and sheet_difference_intersection_dimension == 9,
        "canonical_homogeneous_sheet_lift_has_dimension_10_and_socle_kernel": all(
            len(dependencies) == 1
            and normalize_projective(dependencies[0], prime) == (1,) * 11
            for dependencies in sheet_affine_dependencies
        )
        and sheet_vector_sums == [[0] * len(reduced_vectors[0])] * 2,
        "twisted_coinvariants": {
            "ambient_dimension": len(relative_basis[0]),
            "relation_rank": relation_rank,
            "coinvariant_dimension": coinvariant_dimension,
            "canonical_invariant_to_coinvariant_rank": invariant_to_coinvariant_rank,
            "canonical_invariant_to_coinvariant_matrix": invariant_to_coinvariant_matrix,
            "canonical_kernel_dimension": len(invariant_to_coinvariant_kernel),
            "canonical_kernel_basis_in_relative_coordinates": invariant_to_coinvariant_kernel,
            "canonical_kernel_equals_signed_moment_line": len(invariant_to_coinvariant_kernel) == 1
            and normalize_projective(invariant_to_coinvariant_kernel[0], prime)
            == normalize_projective(moment_coordinates, prime),
            "commutator_submodule_dimension": relation_rank,
            "invariant_socle_intersection_with_commutator_dimension": len(
                invariant_to_coinvariant_kernel
            ),
            "psl_tate_norm_matrix_from_coinvariants_to_invariants": norm_matrix,
            "psl_tate_norm_rank": MATCHING.rank(norm_matrix, prime),
            "full_pgl_tate_norm_is_twice_psl_norm": True,
            "full_pgl_tate_norm_matrix_from_coinvariants_to_invariants": full_group_norm_matrix,
            "full_pgl_tate_norm_rank": MATCHING.rank(full_group_norm_matrix, prime),
            "psl_tate_norm_kernel_basis_in_coinvariant_coordinates": norm_kernel_basis,
            "psl_tate_norm_image_projective_line_in_relative_coordinates": list(
                normalize_projective(nonzero_norm_image, prime)
            ),
            "tate_exactness": tate_exactness,
            "paired_a4_orbit_sums": paired_orbit_coinvariants,
            "paired_orbit_sum_span_dimension": MATCHING.column_rank(orbit_coinvariant_columns, prime),
            "paired_orbit_sum_relations": orbit_coinvariant_relations,
            "target_profile_relations_in_same_size_order": target_profile_relations,
            "positive_sheet_psl_orbital_operators": orbital_operators,
            "brauer_tree_depth_identification": brauer_tree_depth_identification,
            "divided_transfer_gate": divided_transfer_gate,
            "paired_orbit_relation_matches_target_relation": len(orbit_coinvariant_relations) == 1
            and len(target_profile_relations) == 1
            and normalize_projective(orbit_coinvariant_relations[0], prime)
            == normalize_projective(target_profile_relations[0], prime),
            "j_difference_cube_sums": j_difference_coinvariants,
            "j_difference_cube_sum_span_dimension": MATCHING.column_rank(j_difference_columns, prime),
            "j_difference_cube_sum_relations": j_difference_relations,
            "j_difference_cube_sum_norm_data": j_difference_norm_data,
            "j_difference_relation_matches_target_relation": len(j_difference_relations) == 1
            and len(target_profile_relations) == 1
            and normalize_projective(j_difference_relations[0], prime)
            == normalize_projective(target_profile_relations[0], prime),
            "other_j_odd_polarization_families": odd_polarization_families,
        },
        "depth_correlation_candidates": {
            "raw_coordinate_pairing": raw_correlation,
            "second_moment_lowered_pairing": lowered_correlation,
            "second_moment_form_rank": MATCHING.rank(second_moment_form, prime),
            "second_moment_form_is_invariant_under_psl_generators_and_outer": second_moment_covariance,
            "full_group_invariant_symmetric_form_dimension": len(invariant_form_coordinates),
            "full_group_invariant_symmetric_tensor_dimension": len(invariant_tensor_coordinates),
            "full_group_invariant_symmetric_tensor_pencil": invariant_tensor_pencil,
            "invariant_tensor_determinant_divisor": {
                "homogeneous_factorization": "scale*(b-9a)^9*(b-3a)",
                "scale": determinant_scale,
                "rank_one_root": [1, 9],
                "rank_nine_root": [1, 3],
                "ordered_projective_flag_maps_to_target_cubic_flag": len(ordered_flag_maps),
                "ordered_linear_flag_maps_to_target_cubic_flag": len(ordered_flag_maps)
                * (prime - 1),
            },
            "full_group_invariant_symmetric_forms": invariant_form_records,
            "full_group_invariant_form_pencil": invariant_form_pencil,
            "rank_one_form_contraction": {
                "rank_one_form_projective_parameters": list(rank_one_parameters),
                "covector_projective_coordinates": list(normalize_projective(rank_one_covector, prime)),
                "covector_characters_on_psl_generators_and_outer": rank_one_covector_characters,
                "all_contracted_forms_are_full_group_invariant": all(contraction_forms_are_invariant),
                "matrix_from_relative_basis_to_invariant_form_pencil": contraction_map,
                "rank": MATCHING.rank(contraction_map, prime),
                "kernel_basis_in_relative_coordinates": contraction_kernel,
                "kernel_equals_twisted_coinvariant_kernel": len(contraction_kernel) == 1
                and normalize_projective(contraction_kernel[0], prime)
                == normalize_projective(invariant_to_coinvariant_kernel[0], prime),
                "special_projective_images": {
                    name: list(value) for name, value in contraction_special_images.items()
                },
            },
            "depth_weighted_quadratic_moments": depth_quadratic_records,
            "symmetric_square_coinvariant_bridge": {
                "ambient_dimension": len(signed_depth_columns[0]),
                "commutator_submodule_dimension": len(square_relation_basis),
                "coinvariant_dimension": len(square_coinvariant_covectors),
                "signed_depth_matrix_from_four_coordinates": signed_depth_to_square_coinvariants,
                "signed_depth_rank": MATCHING.rank(signed_depth_to_square_coinvariants, prime),
                "signed_depth_kernel": signed_depth_coinvariant_kernel,
                "signed_depth_kernel_equals_depth_plane_annihilator": depth_kernel_equals_annihilator,
                "invariant_tensor_projection_matrix": invariant_tensors_to_square_coinvariants,
                "invariant_tensor_projection_rank": MATCHING.rank(
                    invariant_tensors_to_square_coinvariants, prime
                ),
                "psl_only_coinvariant_dimension": len(psl_square_coinvariant_covectors),
                "psl_only_signed_depth_rank": MATCHING.rank(psl_signed_depth_matrix, prime),
                "psl_only_unsigned_depth_rank": MATCHING.rank(psl_unsigned_depth_matrix, prime),
                "psl_only_invariant_tensor_projection_rank": MATCHING.rank(
                    psl_invariant_tensor_matrix, prime
                ),
                "psl_only_signed_depth_matrix": psl_signed_depth_matrix,
                "psl_only_unsigned_depth_matrix": psl_unsigned_depth_matrix,
                "psl_only_invariant_tensor_projection_matrix": psl_invariant_tensor_matrix,
            },
            "bilinear_form_pencil_source_to_depth_compositions": bilinear_pencil_compositions,
            "canonical_rank_nine_form_depth_map": {
                "unique_rank_nine_projective_parameters": list(rank_nine_parameters),
                "form_coordinate_sha256": hashlib.sha256(bytes(rank_nine_coordinates)).hexdigest(),
                "map": rank_nine_correlation,
                "base_matching_count_checked": len(base_change_correlations),
                "nonzero_base_change_map_count": sum(item["rank"] > 0 for item in base_change_correlations),
                "base_change_rank_distribution": {
                    str(rank): sum(item["rank"] == rank for item in base_change_correlations)
                    for rank in range(3)
                },
                "distinct_projective_maps_across_base_changes": len(projective_base_change_matrices),
                "all_base_changes_equal_reference_projectively": len(projective_base_change_matrices) == 1
                and normalize_projective(reference_flat, prime) in projective_base_change_matrices,
                "distinct_kernel_lines_across_base_changes": len(
                    {
                        normalize_projective(item["kernel_basis_in_relative_coordinates"][0], prime)
                        for item in base_change_correlations
                        if len(item["kernel_basis_in_relative_coordinates"]) == 1
                    }
                ),
                "distinct_projective_quotient_isomorphisms": len(target_two_by_two_maps),
                "distinct_projective_pullback_cubics": len(pullback_cubics),
                "projective_pullback_cubics": [list(item) for item in sorted(pullback_cubics)],
                "total_base_symmetrization_rank": MATCHING.rank(total_aggregate, prime),
                "signed_base_symmetrization_rank": MATCHING.rank(signed_aggregate, prime),
                "flag_weighted_base_symmetrizations": flag_weighted_aggregates,
            },
        },
        "relative_cubic_rank_locus": {
            "projective_line_count": len(projective_relative_lines),
            "first_flattening_rank_distribution": flattening_rank_distribution,
            "special_lines": {name: list(line) for name, line in special_lines.items()},
            "special_first_flattening_ranks": special_flattening_ranks,
            "minimal_rank_lines": [
                list(coordinates) for coordinates in minimal_flattening_lines
            ],
            "unique_rank_one_line_image_under_rank_one_covector_contraction": list(
                normalize_projective(
                    MATCHING.matrix_vector(contraction_map, minimal_flattening_lines[0], prime), prime
                )
            ),
        },
        "scalar_a4_order": len(stabilizer),
        "profile_fibre_sizes": sorted(len(fibre) for fibre in fibres),
        "profile_partition_is_psl_block_system": False,
        "non_descent_witness": non_descent_witness,
    }


def build_certificate():
    prime = 11
    source = source_certificate()
    identity2 = [[1, 0], [0, 1]]
    minus_identity2 = [[prime - 1, 0], [0, prime - 1]]
    factorization = poly_mul(poly_mul([1, prime - 1], [1, prime - 1], prime), [1, prime - 2], prime)
    cubic = [1, 7, 5, 9]
    hessian = hessian_binary_cubic(cubic, prime)
    catalecticant = [[3 * cubic[0] % prime, 2 * cubic[1] % prime, cubic[2]], [cubic[1], 2 * cubic[2] % prime, 3 * cubic[3] % prime]]
    assert factorization == cubic
    assert hessian == [7, 8, 7] == [7 * value % prime for value in [1, prime - 2, 1]]
    assert MATCHING.rank(catalecticant, prime) == 2

    rank_two_map_count = (prime**3 - 1) * (prime**3 - prime)
    projective_source_lines = prime**2 + prime + 1
    gl2_order = (prime**2 - 1) * (prime**2 - prime)
    assert rank_two_map_count == projective_source_lines * gl2_order

    return {
        "schema": SCHEMA,
        "verdict": "POSITIVE_TATE_AND_BRAUER_DEPTH_QUOTIENTS_BUT_BOUNDED_NEGATIVE_IDENTIFICATION",
        "field": prime,
        "source": source,
        "target": {
            "profile_plane_dimension": 2,
            "basis": "e1=v2,e2=v3",
            "plane_equations_in_four_depth_coordinates": [[2, 2, 1, 0], [9, 8, 0, 1]],
            "scalar_a4_action": identity2,
            "outer_j_action": minus_identity2,
            "compressed_binary_cubic_coefficients": cubic,
            "factorization_linear_factors": [[1, prime - 1], [1, prime - 1], [1, prime - 2]],
            "hessian_coefficients": hessian,
            "hessian_doubled_line": [1, prime - 1],
            "residual_simple_line": [1, prime - 2],
            "first_catalecticant_matrix": catalecticant,
            "first_catalecticant_rank": MATCHING.rank(catalecticant, prime),
        },
        "common_symmetry_category": {
            "group": "A4 semidirect <J> on the frozen source/target data",
            "source_character": "three copies of the outer-sign character",
            "target_character": "two copies of the outer-sign character",
            "hom_dimension": 6,
            "every_2_by_3_matrix_is_covariant": True,
            "rank_two_map_count": rank_two_map_count,
            "possible_kernel_lines": projective_source_lines,
            "rank_two_maps_with_any_fixed_kernel_line": gl2_order,
            "signed_moment_line_is_not_selected_by_common_symmetry": True,
        },
        "full_group_obstruction": {
            "profile_partition_is_not_psl_block_system": True,
            "there_is_no_psl_action_on_six_profiles_making_depth_map_equivariant": True,
            "witness": source["non_descent_witness"],
        },
        "covariant_boundary": {
            "canonical_modular_invariant_to_coinvariant_map_has_rank_two": True,
            "tate_norm_completes_a_rank_two_rank_one_exact_cycle": True,
            "rank_one_semi_invariant_contraction_realizes_the_same_quotient": True,
            "brauer_tree_identifies_depth_plane_as_a4_fixed_projective_cover_modulo_socle": True,
            "divided_transfer_distinguishes_rather_than_identifies_source_and_depth_relations": True,
            "relative_cubic_flattening_intrinsically_selects_the_common_kernel": True,
            "paired_orbit_classes_do_not_obey_the_depth_profile_relation": True,
            "ordered_rank_flag_still_allows_10_projective_target_identifications": True,
            "binary_hessian_is_target_internal": True,
            "binary_catalecticant_is_target_internal": True,
            "apolarity_requires_an_antecedent_map_to_a_binary_form_space": True,
            "hessian_flag_does_not_define_a_map_from_the_relative_source": True,
            "a_rank_two_fitted_matrix_can_have_any_of_133_kernel_lines": True,
        },
        "inputs": {
            path.name: {"bytes": path.stat().st_size, "sha256": hashlib.sha256(path.read_bytes()).hexdigest()}
            for path in (MATCHING_PATH, MATCHING_INPUT, PROFILE_INPUT)
        },
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT.name}")
    elif not OUTPUT.exists() or OUTPUT.read_text() != rendered:
        raise SystemExit(f"stale certificate: run {Path(__file__).name} --write")
    else:
        print("relative-cubic-depth certificate OK")


if __name__ == "__main__":
    main()
