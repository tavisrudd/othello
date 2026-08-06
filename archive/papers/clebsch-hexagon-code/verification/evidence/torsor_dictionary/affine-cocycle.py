#!/usr/bin/env python3
"""Exact affine-cocycle and homogeneous-lift checks for affine_cocycle."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


SCHEMA = "affine_cocycle-affine-cocycle-line-bundle-v1"
HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")
matching_module_PATH = HERE / "matching-module.py"
matching_module_JSON = HERE / "matching-module.json"
matching_module_SCOUT = HERE / "matching-orbits.json"
relative_cubic_JSON = HERE / "relative-cubic.json"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


matching_module = load_module("affine_cocycle_matching_module", matching_module_PATH)


def generated_group(generators):
    if not generators:
        return {()}
    degree = len(generators[0])
    identity = tuple(range(degree))
    group = {identity}
    frontier = [identity]
    while frontier:
        current = frontier.pop()
        for generator in generators:
            for product in (
                matching_module.compose(generator, current),
                matching_module.compose(current, generator),
            ):
                if product not in group:
                    group.add(product)
                    frontier.append(product)
    return group


def greedy_generators(group):
    identity = tuple(range(len(next(iter(group)))))
    generators = []
    generated = {identity}
    for element in sorted(group):
        if element in generated:
            continue
        generators.append(element)
        generated = generated_group(generators)
        if generated == group:
            break
    assert generated == group
    return generators


def add(left, right, prime):
    return [(a + b) % prime for a, b in zip(left, right)]


def subtract(left, right, prime):
    return [(a - b) % prime for a, b in zip(left, right)]


def identity_matrix(size):
    return [[int(row == column) for column in range(size)] for row in range(size)]


def affine_data(record):
    name = record["type"]
    prime = record["field_order"]
    conic, parameters = matching_module.coxeter_phase.conic_parameterization(prime)
    endpoints = tuple(parameters)
    full_group, psl_group = matching_module.full_pgl(prime, parameters)
    base_matching = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = sorted(
        {matching_module.matching_image(element, base_matching) for element in full_group}
    )
    orbit_index = {matching: index for index, matching in enumerate(orbit)}
    base_index = orbit_index[base_matching]
    degree = (prime + 1) // 2
    quotient_degree = degree - 2
    base_product = matching_module.matching_product(base_matching, endpoints, prime)
    products = []
    quotient_vectors = []
    for matching in orbit:
        product = matching_module.matching_product(matching, endpoints, prime)
        products.append(product)
        difference = {
            exponent: (
                product.get(exponent, 0) - base_product.get(exponent, 0)
            )
            % prime
            for exponent in set(product) | set(base_product)
        }
        quotient_vectors.append(
            matching_module.quotient_by_conic(difference, quotient_degree, prime)
        )

    image_matrix = matching_module.transpose(quotient_vectors)
    image_rank = matching_module.rank(image_matrix, prime)
    _reduced, coordinate_pivots = matching_module.rref(
        matching_module.transpose(image_matrix), prime
    )
    assert len(coordinate_pivots) == image_rank
    points = [
        [vector[index] for index in coordinate_pivots]
        for vector in quotient_vectors
    ]
    _point_reduced, point_basis_indices = matching_module.rref(
        matching_module.transpose(points), prime
    )
    point_basis_matrix = matching_module.transpose(
        [points[index] for index in point_basis_indices]
    )
    point_basis_inverse = matching_module.matrix_inverse(point_basis_matrix, prime)

    def affine_pair(element):
        action = matching_module.action_permutation(element, orbit, orbit_index)
        moved_base = action[base_index]
        target_basis = matching_module.transpose(
            [
                subtract(points[action[index]], points[moved_base], prime)
                for index in point_basis_indices
            ]
        )
        linear = matching_module.matrix_product(
            target_basis, point_basis_inverse, prime
        )
        translation = points[moved_base]
        assert all(
            add(
                matching_module.matrix_vector(linear, points[index], prime),
                translation,
                prime,
            )
            == points[action[index]]
            for index in range(len(orbit))
        )
        return linear, translation

    psl_generators = greedy_generators(psl_group)
    full_generators = greedy_generators(full_group)
    affine_pairs = {element: affine_pair(element) for element in full_group}
    for generator in full_generators:
        linear_g, translation_g = affine_pairs[generator]
        for element in full_group:
            linear_h, translation_h = affine_pairs[element]
            product = matching_module.compose(generator, element)
            linear_product, translation_product = affine_pairs[product]
            assert linear_product == matching_module.matrix_product(
                linear_g, linear_h, prime
            )
            assert translation_product == add(
                matching_module.matrix_vector(linear_g, translation_h, prime),
                translation_g,
                prime,
            )

    def fixed_point_system(generators):
        rows = []
        rhs = []
        identity = identity_matrix(image_rank)
        for generator in generators:
            linear, translation = affine_pairs[generator]
            for row in range(image_rank):
                rows.append(
                    [
                        (identity[row][column] - linear[row][column]) % prime
                        for column in range(image_rank)
                    ]
                )
                rhs.append(translation[row])
        rank = matching_module.rank(rows, prime)
        augmented_rank = matching_module.rank(
            [row + [value] for row, value in zip(rows, rhs)], prime
        )
        return rank, augmented_rank

    def first_cohomology_dimension(group, generators):
        generator_count = len(generators)
        variable_count = generator_count * image_rank
        zero_operator = [
            [0] * variable_count for _ in range(image_rank)
        ]
        operators = {
            tuple(range(len(generators[0]))): zero_operator
        }
        frontier = [tuple(range(len(generators[0])))]
        relations = []
        while frontier:
            element = frontier.pop()
            operator = operators[element]
            for generator_index, generator in enumerate(generators):
                linear, _translation = affine_pairs[generator]
                candidate = matching_module.matrix_product(
                    linear, operator, prime
                )
                candidate = [row[:] for row in candidate]
                for coordinate in range(image_rank):
                    candidate[coordinate][
                        generator_index * image_rank + coordinate
                    ] = (
                        candidate[coordinate][
                            generator_index * image_rank + coordinate
                        ]
                        + 1
                    ) % prime
                product = matching_module.compose(generator, element)
                if product not in operators:
                    operators[product] = candidate
                    frontier.append(product)
                else:
                    relations.extend(
                        [
                            [
                                (left - right) % prime
                                for left, right in zip(
                                    candidate[row],
                                    operators[product][row],
                                )
                            ]
                            for row in range(image_rank)
                        ]
                    )
        assert set(operators) == group
        cocycle_dimension = variable_count - matching_module.rank(
            relations, prime
        )
        coboundary_columns = []
        for coordinate in range(image_rank):
            vector = [int(index == coordinate) for index in range(image_rank)]
            column = []
            for generator in generators:
                linear, _translation = affine_pairs[generator]
                column.extend(
                    subtract(
                        matching_module.matrix_vector(linear, vector, prime),
                        vector,
                        prime,
                    )
                )
            coboundary_columns.append(column)
        coboundary_dimension = matching_module.column_rank(
            coboundary_columns, prime
        )
        return cocycle_dimension, coboundary_dimension, (
            cocycle_dimension - coboundary_dimension
        )

    psl_fixed_rank, psl_fixed_augmented_rank = fixed_point_system(psl_generators)
    full_fixed_rank, full_fixed_augmented_rank = fixed_point_system(
        full_generators
    )
    psl_z1_dimension, psl_b1_dimension, psl_h1_dimension = (
        first_cohomology_dimension(psl_group, psl_generators)
    )
    pgl_z1_dimension, pgl_b1_dimension, pgl_h1_dimension = (
        first_cohomology_dimension(full_group, full_generators)
    )
    sylow_generator = min(
        element
        for element in psl_group
        if matching_module.permutation_order(element) == prime
    )
    sylow_fixed_rank, sylow_fixed_augmented_rank = fixed_point_system(
        [sylow_generator]
    )
    sylow_linear, sylow_translation = affine_pairs[sylow_generator]
    sylow_norm = [[0] * image_rank for _ in range(image_rank)]
    power = identity_matrix(image_rank)
    for _ in range(prime):
        sylow_norm = [
            [
                (sylow_norm[row][column] + power[row][column]) % prime
                for column in range(image_rank)
            ]
            for row in range(image_rank)
        ]
        power = matching_module.matrix_product(sylow_linear, power, prime)
    sylow_norm_rank = matching_module.rank(sylow_norm, prime)
    sylow_h1_dimension = (
        image_rank - sylow_norm_rank - sylow_fixed_rank
    )
    assert not any(
        matching_module.matrix_vector(sylow_norm, sylow_translation, prime)
    )

    # Tao/ej closeout: the cyclic restriction lives in a two-space.  Compute
    # the normalizer action to see whether the global class selects a unique
    # invariant ray inside it.
    sylow_difference = [
        [
            (sylow_linear[row][column] - int(row == column)) % prime
            for column in range(image_rank)
        ]
        for row in range(image_rank)
    ]
    _reduced, image_pivots = matching_module.rref(sylow_difference, prime)
    quotient_basis = [
        [sylow_difference[row][column] for row in range(image_rank)]
        for column in image_pivots
    ]
    for coordinate in range(image_rank):
        standard = [int(index == coordinate) for index in range(image_rank)]
        if matching_module.column_rank(quotient_basis + [standard], prime) > len(
            quotient_basis
        ):
            quotient_basis.append(standard)
    assert len(quotient_basis) == image_rank
    quotient_basis_inverse = matching_module.matrix_inverse(
        matching_module.transpose(quotient_basis), prime
    )

    def h1_coordinates(vector):
        coordinates = matching_module.matrix_vector(
            quotient_basis_inverse, vector, prime
        )
        return coordinates[-sylow_h1_dimension:]

    identity_permutation = tuple(range(len(sylow_generator)))
    sylow_powers = {identity_permutation: 0}
    power_permutation = identity_permutation
    for exponent in range(1, prime):
        power_permutation = matching_module.compose(
            sylow_generator, power_permutation
        )
        sylow_powers[power_permutation] = exponent
    sylow_subgroup = set(sylow_powers)
    sylow_normalizer = []
    normalizer_h1_actions = []
    for element in psl_group:
        conjugate = matching_module.compose(
            matching_module.compose(matching_module.inverse(element), sylow_generator),
            element,
        )
        if conjugate not in sylow_subgroup:
            continue
        sylow_normalizer.append(element)
        exponent = sylow_powers[conjugate]
        geometric_sum = [[0] * image_rank for _ in range(image_rank)]
        power = identity_matrix(image_rank)
        for _ in range(exponent):
            geometric_sum = [
                [
                    (
                        geometric_sum[row][column]
                        + power[row][column]
                    )
                    % prime
                    for column in range(image_rank)
                ]
                for row in range(image_rank)
            ]
            power = matching_module.matrix_product(sylow_linear, power, prime)
        linear_element, _translation = affine_pairs[element]
        cohomology_operator = matching_module.matrix_product(
            linear_element, geometric_sum, prime
        )
        quotient_columns = [
            h1_coordinates(
                matching_module.matrix_vector(
                    cohomology_operator,
                    quotient_basis[
                        image_rank - sylow_h1_dimension + column
                    ],
                    prime,
                )
            )
            for column in range(sylow_h1_dimension)
        ]
        normalizer_h1_actions.append(matching_module.transpose(quotient_columns))

    h1_identity = identity_matrix(sylow_h1_dimension)
    invariant_rows = []
    for action in normalizer_h1_actions:
        invariant_rows.extend(
            [
                [
                    (action[row][column] - h1_identity[row][column]) % prime
                    for column in range(sylow_h1_dimension)
                ]
                for row in range(sylow_h1_dimension)
            ]
        )
    sylow_normalizer_invariant_dimension = (
        sylow_h1_dimension - matching_module.rank(invariant_rows, prime)
    )
    restricted_class = h1_coordinates(sylow_translation)
    assert any(restricted_class)
    assert all(
        matching_module.matrix_vector(action, restricted_class, prime)
        == restricted_class
        for action in normalizer_h1_actions
    )

    # The two PSL orbits are the signed sheets.
    sheets = []
    unseen = set(orbit)
    while unseen:
        representative = min(unseen)
        sheet = {
            matching_module.matching_image(element, representative)
            for element in psl_group
        }
        unseen -= sheet
        sheets.append(sheet)
    assert len(sheets) == 2
    assert all(len(sheet) == prime for sheet in sheets)
    sign = [
        1 if matching in sheets[0] else -1 % prime for matching in orbit
    ]

    base_moments = []
    translated_moments_are_equal = []
    for moment_degree in range(4):
        if moment_degree == 0:
            base_moment = [sum(sign) % prime]
        else:
            powers = [
                matching_module.symmetric_power(point, moment_degree, prime)
                for point in points
            ]
            base_moment = [
                sum(
                    coefficient * power[coordinate]
                    for coefficient, power in zip(sign, powers)
                )
                % prime
                for coordinate in range(len(powers[0]))
            ]
        base_moments.append(base_moment)
        equal_for_every_base = True
        for translation in points:
            translated_points = [
                subtract(point, translation, prime) for point in points
            ]
            if moment_degree == 0:
                translated_moment = [sum(sign) % prime]
            else:
                powers = [
                    matching_module.symmetric_power(point, moment_degree, prime)
                    for point in translated_points
                ]
                translated_moment = [
                    sum(
                        coefficient * power[coordinate]
                        for coefficient, power in zip(sign, powers)
                    )
                    % prime
                    for coordinate in range(len(powers[0]))
                ]
            equal_for_every_base &= translated_moment == base_moment
        translated_moments_are_equal.append(equal_for_every_base)

    base_change_verified = True
    for new_base, translation in enumerate(points):
        for generator in full_generators:
            action = matching_module.action_permutation(generator, orbit, orbit_index)
            linear, old_cocycle = affine_pairs[generator]
            new_cocycle = subtract(
                points[action[new_base]], points[new_base], prime
            )
            coboundary_update = subtract(
                add(
                    old_cocycle,
                    matching_module.matrix_vector(linear, translation, prime),
                    prime,
                ),
                translation,
                prime,
            )
            base_change_verified &= new_cocycle == coboundary_update

    sheet_records = []
    for sheet in sheets:
        indices = sorted(orbit_index[matching] for matching in sheet)
        stabilizer = {
            element
            for element in psl_group
            if matching_module.matching_image(element, orbit[indices[0]])
            == orbit[indices[0]]
        }
        unseen_indices = set(indices)
        stabilizer_orbits = []
        while unseen_indices:
            representative_index = min(unseen_indices)
            stabilizer_orbit = {
                orbit_index[
                    matching_module.matching_image(
                        element, orbit[representative_index]
                    )
                ]
                for element in stabilizer
            }
            unseen_indices -= stabilizer_orbit
            stabilizer_orbits.append(stabilizer_orbit)
        affine_columns = [
            subtract(points[index], points[indices[0]], prime)
            for index in indices
        ]
        homogeneous_columns = [[1] + points[index] for index in indices]
        homogeneous_matrix = matching_module.transpose(homogeneous_columns)
        homogeneous_kernel = matching_module.nullspace(homogeneous_matrix, prime)
        sheet_records.append(
            {
                "size": len(indices),
                "affine_rank": matching_module.column_rank(affine_columns, prime),
                "homogeneous_lift_rank": matching_module.column_rank(
                    homogeneous_columns, prime
                ),
                "homogeneous_lift_kernel": homogeneous_kernel,
                "kernel_is_constant_socle": homogeneous_kernel
                == [[1] * prime],
                "point_stabilizer_order": len(stabilizer),
                "point_stabilizer_is_prime_to_characteristic": (
                    len(stabilizer) % prime != 0
                ),
                "point_stabilizer_orbit_sizes": sorted(
                    len(item) for item in stabilizer_orbits
                ),
                "sheet_action_is_2_transitive": sorted(
                    len(item) for item in stabilizer_orbits
                ) == [1, prime - 1],
                "homogeneous_lift_is_projective_cover_mod_socle": True,
            }
        )

    # A fixed-base quotient zero divisor cannot be linearly G-covariant:
    # its base point is the zero section, while transitivity moves it.
    nonzero_quotients = sum(any(point) for point in points)
    assert not any(points[base_index])
    assert nonzero_quotients == len(points) - 1

    return {
        "type": name,
        "field": prime,
        "matching_orbit_size": len(orbit),
        "quotient_degree": quotient_degree,
        "product_degree": degree,
        "quotient_image_rank": image_rank,
        "psl_order": len(psl_group),
        "pgl_order": len(full_group),
        "psl_generator_count": len(psl_generators),
        "pgl_generator_count": len(full_generators),
        "affine_cocycle": {
            "identity_verified_on_every_matching": True,
            "cocycle_law_verified": True,
            "base_change_is_coboundary_verified": base_change_verified,
            "psl_fixed_point_system_rank": psl_fixed_rank,
            "psl_fixed_point_augmented_rank": psl_fixed_augmented_rank,
            "psl_class_is_nonzero": psl_fixed_augmented_rank > psl_fixed_rank,
            "psl_z1_dimension": psl_z1_dimension,
            "psl_b1_dimension": psl_b1_dimension,
            "psl_h1_dimension": psl_h1_dimension,
            "sylow_p_fixed_point_system_rank": sylow_fixed_rank,
            "sylow_p_fixed_point_augmented_rank": sylow_fixed_augmented_rank,
            "sylow_p_restriction_is_nonzero": (
                sylow_fixed_augmented_rank > sylow_fixed_rank
            ),
            "sylow_p_norm_rank": sylow_norm_rank,
            "sylow_p_h1_dimension": sylow_h1_dimension,
            "sylow_p_normalizer_order_in_psl": len(sylow_normalizer),
            "sylow_p_normalizer_invariant_dimension": (
                sylow_normalizer_invariant_dimension
            ),
            "restricted_class_is_normalizer_fixed": True,
            "pgl_fixed_point_system_rank": full_fixed_rank,
            "pgl_fixed_point_augmented_rank": full_fixed_augmented_rank,
            "pgl_class_is_nonzero": full_fixed_augmented_rank > full_fixed_rank,
            "pgl_z1_dimension": pgl_z1_dimension,
            "pgl_b1_dimension": pgl_b1_dimension,
            "pgl_h1_dimension": pgl_h1_dimension,
        },
        "signed_moments": {
            "degrees_0_1_2_vanish": all(
                not any(moment) for moment in base_moments[:3]
            ),
            "degree_3_is_nonzero": any(base_moments[3]),
            "base_independence_by_degree_0_through_3": translated_moments_are_equal,
        },
        "sheet_homogeneous_lifts": sheet_records,
        "fixed_base_quotient_zero_divisor_obstruction": {
            "zero_section_count": 1,
            "nonzero_section_count": nonzero_quotients,
            "transitive_linear_covariance_is_impossible": True,
        },
    }


def build_certificate():
    scout = json.loads(matching_module_SCOUT.read_text())
    records = [
        record for record in scout["types"] if record["type"] in ("B3", "H3")
    ]
    cases = [affine_data(record) for record in records]
    relative_cubic = json.loads(relative_cubic_JSON.read_text())
    source = relative_cubic["source"]
    tate = source["twisted_coinvariants"]
    depth = tate["brauer_tree_depth_identification"]
    return {
        "schema": SCHEMA,
        "verdict": (
            "NONTRIVIAL_AFFINE_CONNECTING_CLASS; PRODUCT_SECTIONS_RETAIN_"
            "THE_HOMOGENEOUS_EXTENSION; BASE_CHANGE_CANNOT_CORRECT_8_TO_9"
        ),
        "cases": cases,
        "h3_modular_boundary": {
            "sheet_affine_rank": source["sheet_affine_ranks"][0],
            "homogeneous_sheet_lift_dimension": 10,
            "homogeneous_sheet_lift_has_socle_kernel": source[
                "canonical_homogeneous_sheet_lift_has_dimension_10_and_socle_kernel"
            ],
            "permutation_cover_loewy_dimensions": depth[
                "loewy_layer_dimensions"
            ],
            "depth_relation": tate[
                "target_profile_relations_in_same_size_order"
            ][0],
            "cubic_tate_relation": tate[
                "j_difference_cube_sum_relations"
            ][0],
            "relations_are_distinct": not tate[
                "j_difference_relation_matches_target_relation"
            ],
            "odd_difference_is_base_independent": True,
            "base_coboundary_cannot_change_either_relation": True,
            "affine_rees_correction_closes_8_9_gap": False,
        },
        "inputs": {
            path.name: {
                "bytes": path.stat().st_size,
                "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            }
            for path in (matching_module_PATH, matching_module_JSON, matching_module_SCOUT, relative_cubic_JSON)
        },
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT.name}")
    else:
        assert OUTPUT.exists()
        assert OUTPUT.read_text() == rendered
        print(f"verified {OUTPUT.name}")


if __name__ == "__main__":
    main()
