#!/usr/bin/env python3
"""Exact certificate for the C682 icosahedral transvectant bridge."""

from __future__ import annotations

import argparse
import json
import math
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-26-c682-transvectant-bridge.json"

Golden = tuple[int, int]
GZERO: Golden = (0, 0)
GONE: Golden = (1, 0)
GT: Golden = (0, 1)


def gadd(left: Golden, right: Golden) -> Golden:
    return (left[0] + right[0], left[1] + right[1])


def gneg(value: Golden) -> Golden:
    return (-value[0], -value[1])


def gmul(left: Golden, right: Golden) -> Golden:
    # t^2 = t + 1
    return (
        left[0] * right[0] + left[1] * right[1],
        left[0] * right[1] + left[1] * right[0] + left[1] * right[1],
    )


def gconj(value: Golden) -> Golden:
    # t |-> 1-t
    return (value[0] + value[1], -value[1])


def gdot(left: list[Golden], right: list[Golden]) -> Golden:
    output = GZERO
    for a, b in zip(left, right):
        output = gadd(output, gmul(a, b))
    return output


def gdet(matrix: list[list[Golden]]) -> Golden:
    positive = gadd(
        gmul(matrix[0][0], gmul(matrix[1][1], matrix[2][2])),
        gadd(
            gmul(matrix[0][1], gmul(matrix[1][2], matrix[2][0])),
            gmul(matrix[0][2], gmul(matrix[1][0], matrix[2][1])),
        ),
    )
    negative = gadd(
        gmul(matrix[0][2], gmul(matrix[1][1], matrix[2][0])),
        gadd(
            gmul(matrix[0][1], gmul(matrix[1][0], matrix[2][2])),
            gmul(matrix[0][0], gmul(matrix[1][2], matrix[2][1])),
        ),
    )
    return gadd(positive, gneg(negative))


def golden_gale_certificate() -> dict[str, object]:
    axes = [
        [GZERO, GT, GONE],
        [GZERO, GT, gneg(GONE)],
        [GONE, GZERO, GT],
        [gneg(GONE), GZERO, GT],
        [GT, gneg(GONE), GZERO],
        [gneg(GT), gneg(GONE), GZERO],
    ]
    axis_matrix = [list(row) for row in zip(*axes)]
    gale_kernel_rows = [
        [gneg(GT), GT, GONE, GONE, GZERO, GZERO],
        [GT, gneg(GONE), gneg(GT), GZERO, GONE, GZERO],
        [gneg(GONE), GT, GT, GZERO, GZERO, GONE],
    ]
    assert all(
        gdot(axis_row, kernel_row) == GZERO
        for axis_row in axis_matrix
        for kernel_row in gale_kernel_rows
    )
    # The last three columns form I_3, so these are a full kernel basis.
    gale_points = [list(column) for column in zip(*gale_kernel_rows)]
    projectivity = [
        [GT, GONE, gneg(GONE)],
        [GZERO, GT, GT],
        [GONE, GZERO, GZERO],
    ]
    assert gdet(projectivity) != GZERO
    conjugate_axes = [[gconj(entry) for entry in point] for point in axes]
    common_scalar = gneg(GT)
    for source, target in zip(gale_points, conjugate_axes):
        image = [gdot(row, source) for row in projectivity]
        assert image == [gmul(common_scalar, entry) for entry in target]
        cross = [
            gadd(gmul(image[1], target[2]), gneg(gmul(image[2], target[1]))),
            gadd(gmul(image[2], target[0]), gneg(gmul(image[0], target[2]))),
            gadd(gmul(image[0], target[1]), gneg(gmul(image[1], target[0]))),
        ]
        assert cross == [GZERO, GZERO, GZERO]
        assert image != [GZERO, GZERO, GZERO]
    return {
        "field": "Q[t]/(t^2-t-1)",
        "ordered_axis_columns": axes,
        "gale_kernel_rows": gale_kernel_rows,
        "projectivity_to_galois_conjugate": projectivity,
        "projectivity_determinant": gdet(projectivity),
        "common_column_scalar": common_scalar,
        "permutation_zero_based": list(range(6)),
    }


def falling(n: int, r: int) -> int:
    if n < r:
        return 0
    return math.factorial(n) // math.factorial(n - r)


def primitive(vector: list[Fraction]) -> list[int]:
    denominator = math.lcm(*(entry.denominator for entry in vector))
    values = [int(entry * denominator) for entry in vector]
    divisor = math.gcd(*values)
    values = [entry // divisor for entry in values]
    first = next(entry for entry in values if entry)
    return values if first > 0 else [-entry for entry in values]


def rref(matrix: list[list[int]]) -> tuple[int, list[int], list[list[int]]]:
    work = [[Fraction(entry) for entry in row] for row in matrix]
    row = 0
    pivots: list[int] = []
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        scale = work[row][column]
        work[row] = [entry / scale for entry in work[row]]
        for index in range(len(work)):
            if index == row or not work[index][column]:
                continue
            scale = work[index][column]
            work[index] = [
                work[index][j] - scale * work[row][j]
                for j in range(len(work[index]))
            ]
        pivots.append(column)
        row += 1

    free = [column for column in range(len(work[0])) if column not in pivots]
    kernel: list[list[int]] = []
    for column in free:
        vector = [Fraction(0) for _ in range(len(work[0]))]
        vector[column] = 1
        for index, pivot in enumerate(pivots):
            vector[pivot] = -work[index][column]
        kernel.append(primitive(vector))
    return row, pivots, kernel


def transvectant(
    left: dict[tuple[int, int], int],
    right: dict[tuple[int, int], int],
    order: int,
) -> dict[tuple[int, int], int]:
    output: dict[tuple[int, int], int] = {}
    for index in range(order + 1):
        for (left_x, left_y), left_coefficient in left.items():
            left_derivative = (
                left_coefficient
                * falling(left_x, order - index)
                * falling(left_y, index)
            )
            if not left_derivative:
                continue
            for (right_x, right_y), right_coefficient in right.items():
                right_derivative = (
                    right_coefficient
                    * falling(right_x, index)
                    * falling(right_y, order - index)
                )
                if not right_derivative:
                    continue
                degree = (
                    left_x - (order - index) + right_x - index,
                    left_y - index + right_y - (order - index),
                )
                output[degree] = output.get(degree, 0) + (
                    (-1) ** index
                    * math.comb(order, index)
                    * left_derivative
                    * right_derivative
                )
    return {degree: coefficient for degree, coefficient in output.items() if coefficient}


def third_transvectant_matrix(
    dodecic: list[tuple[int, int, int]],
) -> list[list[int]]:
    matrix = [[0] * 7 for _ in range(13)]
    for column in range(7):
        px, py = 6 - column, column
        for index in range(4):
            left = (
                (-1) ** index
                * math.comb(3, index)
                * falling(px, 3 - index)
                * falling(py, index)
            )
            if not left:
                continue
            for coefficient, fx, fy in dodecic:
                right = (
                    coefficient
                    * falling(fx, index)
                    * falling(fy, 3 - index)
                )
                if not right:
                    continue
                output_y_degree = py - index + fy - (3 - index)
                matrix[output_y_degree][column] += left * right
    return matrix


def rank_modulo(matrix: list[list[int]], prime: int) -> int:
    work = [[entry % prime for entry in row] for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, prime)
        work[row] = [(entry * inverse) % prime for entry in work[row]]
        for index in range(row + 1, len(work)):
            scale = work[index][column]
            work[index] = [
                (work[index][j] - scale * work[row][j]) % prime
                for j in range(len(work[index]))
            ]
        row += 1
    return row


def tangent_data(
    matrix: list[list[int]],
    directions: list[list[list[int]]],
) -> dict[str, int]:
    rank, _, kernel = rref(matrix)
    _, _, left_kernel = rref([list(row) for row in zip(*matrix)])
    constraints = [
        [
            sum(
                left_vector[row]
                * directions[direction][row][column]
                * kernel_vector[column]
                for row in range(13)
                for column in range(7)
            )
            for direction in range(13)
        ]
        for left_vector in left_kernel
        for kernel_vector in kernel
    ]
    constraint_rank, _, tangent_kernel = rref(constraints)
    return {
        "matrix_rank": rank,
        "kernel_dimension": len(kernel),
        "left_kernel_dimension": len(left_kernel),
        "linearized_constraint_count": len(constraints),
        "linearized_constraint_rank": constraint_rank,
        "affine_tangent_dimension": len(tangent_kernel),
        "projective_tangent_dimension": len(tangent_kernel) - 1,
    }


def certificate() -> dict[str, object]:
    # Klein's invariant binary dodecic:
    # Phi_12 = X Y (X^10 + 11 X^5 Y^5 - Y^10).
    phi = [(1, 11, 1), (11, 6, 6), (-1, 1, 11)]
    # Columns use the binary-sextic basis X^(6-k)Y^k.  Rows use
    # X^(12-j)Y^j.  The standard third transvectant is
    # sum_i (-1)^i binom(3,i) d_X^(3-i)d_Y^i(p)
    #                         d_X^i d_Y^(3-i)(Phi_12).
    matrix = third_transvectant_matrix(phi)

    divisor = math.gcd(*(entry for row in matrix for entry in row))
    normalized = [[entry // divisor for entry in row] for row in matrix]
    rank, pivots, kernel = rref(normalized)
    assert divisor == 2640
    assert rank == 4
    assert pivots == [0, 1, 2, 4]
    assert kernel == [
        [0, 0, 0, 1, 0, 0, 0],
        [1, 0, 0, 0, 0, 3, 0],
        [0, 3, 0, 0, 0, 0, -1],
    ]
    kernel_forms = [
        {
            (6 - index, index): coefficient
            for index, coefficient in enumerate(vector)
            if coefficient
        }
        for vector in kernel
    ]
    isotropy = [
        {
            "pair": [left, right],
            "fifth_transvectant": [
                {
                    "coefficient": coefficient,
                    "x_degree": degree[0],
                    "y_degree": degree[1],
                }
                for degree, coefficient in sorted(
                    transvectant(kernel_forms[left], kernel_forms[right], 5).items()
                )
            ],
        }
        for left in range(3)
        for right in range(left, 3)
    ]
    assert all(not row["fifth_transvectant"] for row in isotropy)

    # Linearize rank <= 4 at Phi_12.  A tangent direction delta satisfies
    # delta(M)(ker M) subset im(M), equivalently every left-kernel vector
    # annihilates delta(M) on every kernel vector.
    direction_matrices = [
        third_transvectant_matrix([(1, 12 - index, index)])
        for index in range(13)
    ]
    open_tangent = tangent_data(normalized, direction_matrices)
    assert open_tangent["left_kernel_dimension"] == 9
    assert open_tangent["linearized_constraint_rank"] == 9
    assert open_tangent["affine_tangent_dimension"] == 4

    boundary_inputs = [
        ("two_dimensional_orbit", [(1, 11, 1)]),
        ("one_dimensional_closed_orbit", [(1, 12, 0)]),
    ]
    boundary_models = []
    for name, boundary_form in boundary_inputs:
        boundary_matrix = third_transvectant_matrix(boundary_form)
        boundary_rank, _, boundary_kernel = rref(boundary_matrix)
        boundary_kernel_forms = [
            {
                (6 - index, index): coefficient
                for index, coefficient in enumerate(vector)
                if coefficient
            }
            for vector in boundary_kernel
        ]
        boundary_isotropic = all(
            not transvectant(
                boundary_kernel_forms[left],
                boundary_kernel_forms[right],
                5,
            )
            for left in range(3)
            for right in range(left, 3)
        )
        assert boundary_rank == 4
        assert boundary_isotropic
        boundary_models.append(
            {
                "name": name,
                "dodecic_terms": boundary_form,
                "kernel_basis": boundary_kernel,
                "fifth_transvectant_isotropic": boundary_isotropic,
                "rank_locus_tangent": tangent_data(
                    boundary_matrix,
                    direction_matrices,
                ),
            }
        )
    assert boundary_models[0]["kernel_basis"] == [
        [1, 0, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0],
    ]
    assert boundary_models[1]["kernel_basis"] == [
        [1, 0, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0],
    ]

    primitive_reduction_ranks = {
        str(prime): rank_modulo(normalized, prime)
        for prime in [2, 3, 5, 7, 11, 13, 17, 19]
    }
    assert primitive_reduction_ranks == {
        "2": 4,
        "3": 4,
        "5": 2,
        "7": 4,
        "11": 4,
        "13": 4,
        "17": 4,
        "19": 4,
    }
    three_paper_mod_11 = {
        "matching_cubic_scalar_on_sigma3": 4,
        "hitchin_restriction_scalar_on_sigma3_squared": 16 % 11,
        "orientation_cover_scalar_on_sigma3_squared": (5 * 16) % 11,
        "square_root_of_five": 4,
    }
    assert (
        three_paper_mod_11["matching_cubic_scalar_on_sigma3"] ** 2 % 11
        == three_paper_mod_11[
            "hitchin_restriction_scalar_on_sigma3_squared"
        ]
    )
    assert (
        (
            three_paper_mod_11["square_root_of_five"]
            * three_paper_mod_11["matching_cubic_scalar_on_sigma3"]
        )
        ** 2
        % 11
        == three_paper_mod_11["orientation_cover_scalar_on_sigma3_squared"]
    )
    return {
        "schema": "c682-transvectant-bridge-v1",
        "ground_ring": "Z",
        "klein_dodecic_terms": [
            {"coefficient": coefficient, "x_degree": x_degree, "y_degree": y_degree}
            for coefficient, x_degree, y_degree in phi
        ],
        "transvectant_order": 3,
        "domain_basis": [f"x^{6-k} y^{k}" for k in range(7)],
        "codomain_basis": [f"x^{12-k} y^{k}" for k in range(13)],
        "common_matrix_divisor": divisor,
        "normalized_matrix_rows": normalized,
        "rank": rank,
        "pivot_columns_zero_based": pivots,
        "kernel_basis": kernel,
        "kernel_polynomials": [
            "x^3 y^3",
            "x^6 + 3 x y^5",
            "3 x^5 y - y^6",
        ],
        "kernel_fifth_transvectant_isotropy": isotropy,
        "rank_locus_tangent": {
            "ambient_affine_dimension": 13,
            **open_tangent,
        },
        "boundary_models": boundary_models,
        "primitive_reduction_ranks": primitive_reduction_ranks,
        "three_paper_normalization_mod_11": three_paper_mod_11,
        "golden_gale_self_association": golden_gale_certificate(),
    }


def serialized() -> str:
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    expected = serialized()
    if args.write:
        CERTIFICATE.write_text(expected, encoding="utf-8")
        print(f"wrote {CERTIFICATE.name}")
        return
    if not CERTIFICATE.exists() or CERTIFICATE.read_text(encoding="utf-8") != expected:
        raise SystemExit("transvectant certificate is missing or stale")
    print("C682 transvectant certificate: OK (rank 4, kernel dimension 3)")


if __name__ == "__main__":
    main()
