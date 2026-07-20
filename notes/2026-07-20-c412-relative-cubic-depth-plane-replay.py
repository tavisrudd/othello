#!/usr/bin/env python3
"""Independent finite-linear-algebra replay for the strengthened C412 boundary."""

from __future__ import annotations

import itertools
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CERTIFICATE = ROOT / "notes/2026-07-20-c412-relative-cubic-depth-plane.json"


def rank_two(entries, prime):
    a, b, c, d, e, f = entries
    return any(value % prime for value in (a * e - b * d, a * f - c * d, b * f - c * e))


def poly_mul(left, right, prime):
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] = (result[i + j] + a * b) % prime
    return result


def normalize(vector, prime):
    first = next(value % prime for value in vector if value % prime)
    inverse = pow(first, -1, prime)
    return tuple(value * inverse % prime for value in vector)


def kernel_line(entries, prime):
    a, b, c, d, e, f = entries
    minors = (b * f - c * e, c * d - a * f, a * e - b * d)
    return normalize(minors, prime)


def rank(matrix, prime):
    work = [[value % prime for value in row] for row in matrix]
    pivot_row = 0
    for column in range(len(work[0]) if work else 0):
        pivot = next((row for row in range(pivot_row, len(work)) if work[row][column]), None)
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, prime)
        work[pivot_row] = [value * inverse % prime for value in work[pivot_row]]
        for row in range(len(work)):
            if row != pivot_row and work[row][column]:
                scalar = work[row][column]
                work[row] = [
                    (left - scalar * right) % prime
                    for left, right in zip(work[row], work[pivot_row])
                ]
        pivot_row += 1
    return pivot_row


def matrix_product(left, right, prime):
    return [
        [sum(left[i][k] * right[k][j] for k in range(len(right))) % prime for j in range(len(right[0]))]
        for i in range(len(left))
    ]


def matrix_vector(matrix, vector, prime):
    return [sum(left * right for left, right in zip(row, vector)) % prime for row in matrix]


def main():
    certificate = json.loads(CERTIFICATE.read_text())
    prime = certificate["field"]
    target = certificate["target"]
    factors = target["factorization_linear_factors"]
    cubic = poly_mul(poly_mul(factors[0], factors[1], prime), factors[2], prime)
    assert cubic == target["compressed_binary_cubic_coefficients"]
    a, b, c, d = cubic
    f_xx, f_xy, f_yy = [6 * a % prime, 2 * b % prime], [2 * b % prime, 2 * c % prime], [2 * c % prime, 6 * d % prime]
    hessian = [(x - y) % prime for x, y in zip(poly_mul(f_xx, f_yy, prime), poly_mul(f_xy, f_xy, prime))]
    assert hessian == target["hessian_coefficients"]

    rank_two_count = 0
    kernel_counts = {}
    for entries in itertools.product(range(prime), repeat=6):
        if rank_two(entries, prime):
            rank_two_count += 1
            line = kernel_line(entries, prime)
            kernel_counts[line] = kernel_counts.get(line, 0) + 1
    common = certificate["common_symmetry_category"]
    assert rank_two_count == common["rank_two_map_count"]
    assert len(kernel_counts) == common["possible_kernel_lines"]
    assert set(kernel_counts.values()) == {common["rank_two_maps_with_any_fixed_kernel_line"]}

    witness = certificate["full_group_obstruction"]["witness"]
    assert witness["same_profile_matching_indices"][0] != witness["same_profile_matching_indices"][1]
    assert witness["distinct_image_fibres"][0] != witness["distinct_image_fibres"][1]

    modular = certificate["source"]["twisted_coinvariants"]
    projection = modular["canonical_invariant_to_coinvariant_matrix"]
    norm = modular["psl_tate_norm_matrix_from_coinvariants_to_invariants"]
    assert rank(projection, prime) == 2
    assert rank(norm, prime) == 1
    assert matrix_product(norm, projection, prime) == [[0] * 3 for _ in range(3)]
    kernel_line_source = normalize(modular["canonical_kernel_basis_in_relative_coordinates"][0], prime)
    assert kernel_line_source == tuple(modular["psl_tate_norm_image_projective_line_in_relative_coordinates"])

    orbit_records = modular["j_difference_cube_sums"]
    orbit_columns = [item["coinvariant_coordinates_of_j_difference_cube_sum"] for item in orbit_records]
    orbit_relation = modular["j_difference_cube_sum_relations"][0]
    assert [
        sum(coefficient * column[row] for coefficient, column in zip(orbit_relation, orbit_columns)) % prime
        for row in range(3)
    ] == [0, 0, 0]
    assert normalize(orbit_relation, prime) == (1, 10, 6)
    target_relation = modular["target_profile_relations_in_same_size_order"][0]
    assert normalize(target_relation, prime) == (1, 4, 6)
    norm_images = [matrix_vector(norm, column, prime) for column in orbit_columns]
    pivot = next(index for index, value in enumerate(norm_images[0]) if value)
    inverse = pow(norm_images[0][pivot], -1, prime)
    norm_scalars = [image[pivot] * inverse % prime for image in norm_images]
    assert norm_scalars == [1, 4, 6]
    orbitals = modular["positive_sheet_psl_orbital_operators"]
    assert [item["ordered_pair_orbit_size"] for item in orbitals] == [11, 110]
    assert all(
        not data["maps_to_target_orbit_sum_relation"]
        for item in orbitals
        for data in item["source_relation_images"].values()
    )
    brauer = modular["brauer_tree_depth_identification"]
    assert brauer["psl_permutation_module_is_projective_indecomposable_cover_of_trivial"]
    assert brauer["loewy_layer_dimensions"] == [1, 9, 1]
    assert brauer["heart_matrix_algebra_dimension"] == 81
    assert brauer["odd_orbit_sum_depth_rank"] == 2
    assert brauer["odd_orbit_sum_depth_kernel"] == [[1, 1, 1]]
    assert brauer["full_mixed_depth_kernel_dimension"] == 4

    divided = modular["divided_transfer_gate"]
    integral_transfer = divided["integral_transfer_matrix"]
    assert matrix_product(integral_transfer, integral_transfer, 10**9 + 7) == [
        [11 * value for value in row] for row in integral_transfer
    ]
    assert set(divided["source_integral_weighted_sums"].values()) == {0}
    assert divided["integral_transfer_on_depth_socle"] == [11, 11, 11]
    assert divided["divided_transfer_on_depth_socle"] == [1, 1, 1]
    assert not divided["divided_transfer_supplies_source_to_depth_bridge"]

    covariants = certificate["source"]["depth_correlation_candidates"]
    contraction = covariants["rank_one_form_contraction"]
    assert rank(contraction["matrix_from_relative_basis_to_invariant_form_pencil"], prime) == 2
    assert normalize(contraction["kernel_basis_in_relative_coordinates"][0], prime) == kernel_line_source
    square_bridge = covariants["symmetric_square_coinvariant_bridge"]
    assert square_bridge["coinvariant_dimension"] == 2
    assert square_bridge["invariant_tensor_projection_rank"] == 2
    assert square_bridge["signed_depth_rank"] == 1
    assert square_bridge["psl_only_unsigned_depth_rank"] == 1
    assert not square_bridge["signed_depth_kernel_equals_depth_plane_annihilator"]
    divisor = covariants["invariant_tensor_determinant_divisor"]
    for item in covariants["full_group_invariant_symmetric_tensor_pencil"]:
        a_parameter, b_parameter = item["projective_parameters"]
        model = (
            divisor["scale"]
            * pow((b_parameter - 9 * a_parameter) % prime, 9, prime)
            * ((b_parameter - 3 * a_parameter) % prime)
        ) % prime
        assert item["determinant"] == model

    flag_maps = set()
    for entries in itertools.product(range(prime), repeat=4):
        a_entry, b_entry, c_entry, d_entry = entries
        if (a_entry * d_entry - b_entry * c_entry) % prime == 0:
            continue
        matrix = [[a_entry, b_entry], [c_entry, d_entry]]
        if normalize(matrix_vector(matrix, [1, 9], prime), prime) != (1, 10):
            continue
        if normalize(matrix_vector(matrix, [1, 3], prime), prime) != (1, 9):
            continue
        flag_maps.add(normalize(entries, prime))
    assert len(flag_maps) == divisor["ordered_projective_flag_maps_to_target_cubic_flag"] == 10

    print(
        "C412 independent replay OK: Tate exactness, Brauer-tree depth quotient, divided-transfer "
        "separation, map census, and 10 residual flag maps"
    )


if __name__ == "__main__":
    main()
