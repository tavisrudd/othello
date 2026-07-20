#!/usr/bin/env python3
"""Exact C412 naturality obstruction and binary-cubic flag certificate."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
C406_PATH = ROOT / "notes/2026-07-20-c406-matching-module.py"
C406_INPUT = ROOT / "notes/2026-07-20-c406-matching-orbit-scout.json"
C411_INPUT = ROOT / "notes/2026-07-20-c411-double-coset-hecke.json"
OUTPUT = ROOT / "notes/2026-07-20-c412-relative-cubic-depth-plane.json"
SCHEMA = "c412-relative-cubic-depth-plane-v1"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C406 = load_module("c406_matching_module_for_c412", C406_PATH)


def normalize_projective(vector, prime):
    first = next(value % prime for value in vector if value % prime)
    inverse = pow(first, -1, prime)
    return tuple(value * inverse % prime for value in vector)


def coordinates_in_basis(vector, basis, prime):
    _reduced, pivots = C406.rref(basis, prime)
    assert len(pivots) == len(basis)
    square = [[basis[column][row] for column in range(len(basis))] for row in pivots]
    inverse = C406.matrix_inverse(square, prime)
    return C406.matrix_vector(inverse, [vector[row] for row in pivots], prime)


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


def source_certificate():
    scout = json.loads(C406_INPUT.read_text())
    record = next(item for item in scout["types"] if item["type"] == "H3")
    prime = record["field_order"]
    conic, parameters = C406.C399.conic_parameterization(prime)
    full_group, psl_group = C406.full_pgl(prime, parameters)
    base_matching = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = sorted({C406.matching_image(element, base_matching) for element in full_group})
    orbit_index = {matching: index for index, matching in enumerate(orbit)}
    base_product = C406.matching_product(base_matching, tuple(parameters), prime)
    quotient_vectors = []
    for matching in orbit:
        product = C406.matching_product(matching, tuple(parameters), prime)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % prime
            for exponent in set(product) | set(base_product)
        }
        quotient_vectors.append(C406.quotient_by_conic(difference, 4, prime))
    image_matrix = C406.transpose(quotient_vectors)
    _reduced, coordinate_pivots = C406.rref(C406.transpose(image_matrix), prime)
    reduced_vectors = [[vector[index] for index in coordinate_pivots] for vector in quotient_vectors]
    _point_reduced, point_basis_indices = C406.rref(C406.transpose(reduced_vectors), prime)
    point_basis_matrix = C406.transpose([reduced_vectors[index] for index in point_basis_indices])
    point_basis_inverse = C406.matrix_inverse(point_basis_matrix, prime)
    base_index = orbit_index[base_matching]

    def induced_action(element):
        action = C406.action_permutation(element, orbit, orbit_index)
        moved_base = action[base_index]
        target_basis = C406.transpose(
            [
                [
                    (reduced_vectors[action[index]][coordinate] - reduced_vectors[moved_base][coordinate])
                    % prime
                    for coordinate in range(len(coordinate_pivots))
                ]
                for index in point_basis_indices
            ]
        )
        return C406.matrix_product(target_basis, point_basis_inverse, prime)

    psl_generators = C406.permutation_generators(psl_group)
    outer_element = min(full_group - psl_group)
    ambient_actions = [
        C406.symmetric_cube_action(induced_action(element), prime)
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
    relative_basis = C406.nullspace(equations, prime)
    assert len(relative_basis) == 3
    identity3 = [[1 if row == column else 0 for column in range(3)] for row in range(3)]
    minus_identity3 = [[-value % prime for value in row] for row in identity3]
    restricted_actions = []
    for action in ambient_actions:
        columns = [coordinates_in_basis(C406.matrix_vector(action, vector, prime), relative_basis, prime) for vector in relative_basis]
        restricted_actions.append(C406.transpose(columns))
    assert restricted_actions[:-1] == [identity3] * len(psl_generators)
    assert restricted_actions[-1] == minus_identity3

    sheets = []
    unseen = set(orbit)
    while unseen:
        representative = min(unseen)
        sheet = {C406.matching_image(element, representative) for element in psl_group}
        unseen -= sheet
        sheets.append(sheet)
    sign = [1 if matching in sheets[0] else prime - 1 for matching in orbit]
    cubic_moment = [
        sum(coefficient * value for coefficient, value in zip(sign, coordinate_values)) % prime
        for coordinate_values in zip(*(C406.symmetric_power(vector, 3, prime) for vector in reduced_vectors))
    ]
    moment_coordinates = coordinates_in_basis(cubic_moment, relative_basis, prime)

    c411 = json.loads(C411_INPUT.read_text())
    fibres = [set(item["matching_indices"]) for item in c411["double_cosets"]["representatives"]]
    fibre_by_index = {index: fibre for fibre, members in enumerate(fibres) for index in members}
    assert set(fibre_by_index) == set(range(len(orbit)))

    singleton_indices = sorted(next(iter(fibre)) for fibre in fibres if len(fibre) == 1)
    assert singleton_indices == [0, 19]
    stabilizer = {
        element
        for element in full_group
        if all(C406.matching_image(element, orbit[index]) == orbit[index] for index in singleton_indices)
    }
    assert len(stabilizer) == 12 and stabilizer <= psl_group
    for element in stabilizer:
        action = C406.action_permutation(element, orbit, orbit_index)
        assert all(fibre_by_index[action[index]] == fibre_by_index[index] for index in range(len(orbit)))

    j_element = next(
        element
        for element in sorted(full_group - psl_group)
        if C406.matching_image(element, orbit[0]) == orbit[19]
        and {C406.compose(C406.compose(element, k), C406.inverse(element)) for k in stabilizer}
        == stabilizer
    )
    j_action = C406.action_permutation(j_element, orbit, orbit_index)
    profile_by_index = {}
    for item in c411["double_cosets"]["representatives"]:
        for index in item["matching_indices"]:
            profile_by_index[index] = tuple(value % prime for value in item["depth_profile"])
    assert all(
        profile_by_index[j_action[index]] == tuple(-value % prime for value in profile_by_index[index])
        for index in range(len(orbit))
    )

    non_descent_witness = None
    for generator_index, element in enumerate(psl_generators):
        action = C406.action_permutation(element, orbit, orbit_index)
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

    return {
        "ambient_W_dimension": len(reduced_vectors[0]),
        "ambient_symmetric_cube_dimension": len(relative_basis[0]),
        "relative_space_dimension": len(relative_basis),
        "psl_generator_count": len(psl_generators),
        "restricted_psl_generator_actions": restricted_actions[:-1],
        "restricted_outer_action": restricted_actions[-1],
        "signed_moment_coordinates_in_relative_basis": moment_coordinates,
        "signed_moment_projective_line": normalize_projective(moment_coordinates, prime),
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
    assert C406.rank(catalecticant, prime) == 2

    rank_two_map_count = (prime**3 - 1) * (prime**3 - prime)
    projective_source_lines = prime**2 + prime + 1
    gl2_order = (prime**2 - 1) * (prime**2 - prime)
    assert rank_two_map_count == projective_source_lines * gl2_order

    return {
        "schema": SCHEMA,
        "verdict": "BOUNDED_NEGATIVE_NO_NATURAL_SOURCE_TO_DEPTH_PLANE_MAP",
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
            "first_catalecticant_rank": C406.rank(catalecticant, prime),
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
            "binary_hessian_is_target_internal": True,
            "binary_catalecticant_is_target_internal": True,
            "apolarity_requires_an_antecedent_map_to_a_binary_form_space": True,
            "hessian_flag_does_not_define_a_map_from_the_relative_source": True,
            "a_rank_two_fitted_matrix_can_have_any_of_133_kernel_lines": True,
        },
        "inputs": {
            path.name: {"bytes": path.stat().st_size, "sha256": hashlib.sha256(path.read_bytes()).hexdigest()}
            for path in (C406_PATH, C406_INPUT, C411_INPUT)
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
        print("C412 naturality obstruction certificate OK")


if __name__ == "__main__":
    main()
