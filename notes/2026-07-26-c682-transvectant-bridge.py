#!/usr/bin/env python3
"""Exact certificate for the C682 icosahedral transvectant bridge."""

from __future__ import annotations

import argparse
import json
import math
from fractions import Fraction
from itertools import combinations, product
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


def gprojectively_equal(left: list[Golden], right: list[Golden]) -> bool:
    return [
        gadd(gmul(left[1], right[2]), gneg(gmul(left[2], right[1]))),
        gadd(gmul(left[2], right[0]), gneg(gmul(left[0], right[2]))),
        gadd(gmul(left[0], right[1]), gneg(gmul(left[1], right[0]))),
    ] == [GZERO, GZERO, GZERO]


def face_supports(
    axes: list[list[Golden]],
    edge_inner_product: Golden,
) -> dict[tuple[int, int, int], list[list[Golden]]]:
    signed_vertices = [
        (axis_index, sign, [entry if sign == 1 else gneg(entry) for entry in axis])
        for axis_index, axis in enumerate(axes)
        for sign in [1, -1]
    ]
    faces: dict[tuple[int, int, int], list[list[Golden]]] = {}
    for triple in combinations(signed_vertices, 3):
        if not all(
            gdot(triple[left][2], triple[right][2]) == edge_inner_product
            for left, right in [(0, 1), (0, 2), (1, 2)]
        ):
            continue
        support = tuple(sorted(vertex[0] for vertex in triple))
        assert len(set(support)) == 3
        center = [
            gadd(gadd(triple[0][2][coordinate], triple[1][2][coordinate]),
                 triple[2][2][coordinate])
            for coordinate in range(3)
        ]
        faces.setdefault(support, []).append(center)
    assert sum(len(centers) for centers in faces.values()) == 20
    assert all(
        len(centers) == 2 and centers[1] == [gneg(entry) for entry in centers[0]]
        for centers in faces.values()
    )
    return faces


def icosahedral_marking_certificate() -> dict[str, object]:
    vertex_axes = [
        [GZERO, GT, GONE],
        [GZERO, GT, gneg(GONE)],
        [GONE, GZERO, GT],
        [gneg(GONE), GZERO, GT],
        [GT, gneg(GONE), GZERO],
        [gneg(GT), gneg(GONE), GZERO],
    ]
    faces = face_supports(vertex_axes, GT)
    face_chirality = {
        (0, 1, 4), (0, 1, 5), (0, 2, 3), (0, 2, 5), (0, 3, 4),
        (1, 2, 3), (1, 2, 4), (1, 3, 5), (2, 4, 5), (3, 4, 5),
    }
    complement_chirality = {
        tuple(index for index in range(6) if index not in support)
        for support in face_chirality
    }
    # These are exactly the two Paper I support orbits in its existing
    # six-coordinate marking.
    assert set(faces) == face_chirality
    assert complement_chirality == {
        (0, 1, 2), (0, 1, 3), (0, 2, 4), (0, 3, 5), (0, 4, 5),
        (1, 2, 5), (1, 3, 4), (1, 4, 5), (2, 3, 4), (2, 3, 5),
    }

    inv_t = gadd(GT, gneg(GONE))
    paper_three_face_axes = {
        "12": [gneg(GONE), gneg(GONE), gneg(GONE)],
        "13": [gneg(GONE), gneg(GONE), GONE],
        "14": [gneg(GONE), GONE, gneg(GONE)],
        "15": [gneg(GONE), GONE, GONE],
        "34": [GZERO, gneg(inv_t), gneg(GT)],
        "25": [GZERO, gneg(inv_t), GT],
        "45": [gneg(inv_t), gneg(GT), GZERO],
        "23": [gneg(inv_t), GT, GZERO],
        "35": [gneg(GT), GZERO, gneg(inv_t)],
        "24": [GT, GZERO, gneg(inv_t)],
    }
    support_to_axis_label: dict[tuple[int, int, int], str] = {}
    complementary_decompositions: dict[
        tuple[int, int, int], tuple[tuple[int, int, int], tuple[int, int, int]]
    ] = {}
    for support, centers in faces.items():
        labels = [
            label
            for label, axis in paper_three_face_axes.items()
            if gprojectively_equal(centers[0], axis)
        ]
        assert len(labels) == 1
        support_to_axis_label[support] = labels[0]
        complement_support = tuple(
            index for index in range(6) if index not in support
        )
        signed_sums = []
        for signs in product([1, -1], repeat=3):
            candidate = [
                sum(
                    (
                        vertex_axes[axis_index][coordinate][component]
                        if signs[index] == 1
                        else -vertex_axes[axis_index][coordinate][component]
                    )
                    for index, axis_index in enumerate(complement_support)
                )
                for coordinate in range(3)
                for component in range(2)
            ]
            candidate_vector = [
                (candidate[2 * coordinate], candidate[2 * coordinate + 1])
                for coordinate in range(3)
            ]
            if (
                candidate_vector != [GZERO, GZERO, GZERO]
                and gprojectively_equal(centers[0], candidate_vector)
            ):
                signed_sums.append(signs)
        assert len(signed_sums) == 2
        assert signed_sums[1] == tuple(-sign for sign in signed_sums[0])
        canonical_signs = next(signs for signs in signed_sums if signs[0] == 1)
        complementary_decompositions[support] = (
            complement_support,
            canonical_signs,
        )
    assert len(set(support_to_axis_label.values())) == 10

    # C176's triangle-pair/support dictionary, restricted to the face
    # chirality representative in each complementary pair.
    support_to_syntheme_pair = {
        (0, 1, 4): (2, 4),
        (0, 1, 5): (1, 3),
        (0, 2, 3): (3, 4),
        (0, 2, 5): (0, 2),
        (0, 3, 4): (0, 1),
        (1, 2, 3): (1, 2),
        (1, 2, 4): (0, 3),
        (1, 3, 5): (0, 4),
        (2, 4, 5): (1, 4),
        (3, 4, 5): (2, 3),
    }
    syntheme_to_face_label = {0: 1, 1: 5, 2: 2, 3: 4, 4: 3}
    for support, pair in support_to_syntheme_pair.items():
        expected_label = "".join(
            str(label)
            for label in sorted(syntheme_to_face_label[index] for index in pair)
        )
        assert support_to_axis_label[support] == expected_label

    conjugate_axes = [[gconj(entry) for entry in axis] for axis in vertex_axes]
    conjugate_faces = face_supports(conjugate_axes, gconj(GT))
    assert set(conjugate_faces) == face_chirality

    signed_supports = {
        support: (1 if support in face_chirality else -1)
        for support in face_chirality | complement_chirality
    }
    for order in range(3):
        assert all(
            sum(
                sign
                for support, sign in signed_supports.items()
                if all(index in support for index in indices)
            ) == 0
            for indices in product(range(6), repeat=order)
        )
    signed_third_moment = {
        indices: sum(
            sign
            for support, sign in signed_supports.items()
            if all(index in support for index in indices)
        )
        for indices in product(range(6), repeat=3)
    }
    assert any(signed_third_moment.values())
    assert all(
        value == (
            signed_supports[tuple(sorted(indices))]
            if len(set(indices)) == 3
            else 0
        )
        for indices, value in signed_third_moment.items()
    )

    synthematic_total = [
        [(0, 1), (2, 3), (4, 5)],
        [(0, 2), (1, 4), (3, 5)],
        [(0, 3), (1, 5), (2, 4)],
        [(0, 4), (1, 3), (2, 5)],
        [(0, 5), (1, 2), (3, 4)],
    ]

    def sextic_values(vector: tuple[int, ...]) -> tuple[int, int]:
        assert sum(vector) == 0
        support_cubic = sum(
            sign * math.prod(vector[index] for index in support)
            for support, sign in signed_supports.items()
        )
        quadratics = [
            sum(vector[left] * vector[right] for left, right in matching)
            for matching in synthematic_total
        ]
        total = sum(quadratics)
        clebsch_coordinates = [5 * value - total for value in quadratics]
        assert sum(clebsch_coordinates) == 0
        cubic_numerator = sum(value**3 for value in clebsch_coordinates)
        assert cubic_numerator % 3 == 0
        clebsch_cubic = cubic_numerator // 3
        return support_cubic, clebsch_cubic

    def square_test(vector: tuple[int, ...]) -> tuple[int, int, Fraction]:
        support_cubic, clebsch_cubic = sextic_values(vector)
        return (
            support_cubic,
            clebsch_cubic,
            Fraction(clebsch_cubic, support_cubic**2),
        )

    square_test_a = square_test((-2, -2, -2, -1, -1, 8))
    square_test_b = square_test((-2, -2, -2, -1, 0, 7))
    assert square_test_a == (10, 8720, Fraction(436, 5))
    assert square_test_b == (18, 58480, Fraction(14620, 81))
    assert square_test_a[2] != square_test_b[2]

    # Both nonsymmetric sextics have the same one-dimensional exotic
    # component after quotienting the outer-S5-even invariant space by
    # the ordinary S6-symmetric sextics.  The corrected relation is an
    # exact polynomial identity on the augmentation hyperplane p_1=0.
    interpolation_grid = range(7)
    for leading in product(interpolation_grid, repeat=5):
        vector = tuple(leading) + (-sum(leading),)
        support_cubic, clebsch_cubic = sextic_values(vector)
        power_sums = {
            degree: sum(value**degree for value in vector)
            for degree in [2, 3, 4, 6]
        }
        symmetric_correction = (
            6000 * power_sums[6]
            - 4350 * power_sums[4] * power_sums[2]
            - 2125 * power_sums[3] ** 2
            + 705 * power_sums[2] ** 3
        )
        assert 375 * support_cubic**2 - 12 * clebsch_cubic == symmetric_correction
        elementary = {
            degree: sum(
                math.prod(vector[index] for index in subset)
                for subset in combinations(range(6), degree)
            )
            for degree in [2, 3, 4, 6]
        }
        assert symmetric_correction == -15 * (
            16 * elementary[2] ** 3
            - 80 * elementary[2] * elementary[4]
            + 75 * elementary[3] ** 2
            + 2400 * elementary[6]
        )

    nonsymmetric_witness = (-2, -2, -1, -1, 0, 6)
    permuted_witness = list(nonsymmetric_witness)
    permuted_witness[0], permuted_witness[2] = (
        permuted_witness[2],
        permuted_witness[0],
    )
    assert sextic_values(nonsymmetric_witness)[0] ** 2 == 484
    assert sextic_values(tuple(permuted_witness))[0] ** 2 == 36

    # Molien coefficients in degree six.  On V_5 the A5 class traces on
    # Sym^6 are 210,10,3,0 for orders 1,2,3,5.  The three outer S5
    # classes have degree-six traces 10,2,1 and sizes 10,30,20.
    a5_sextic_dimension = (210 + 15 * 10 + 20 * 3 + 24 * 0) // 60
    outer_even_sextic_dimension = (
        210 + 15 * 10 + 20 * 3 + 24 * 0 + 10 * 10 + 30 * 2 + 20 * 1
    ) // 120
    symmetric_sextic_dimension = 4  # p6, p4*p2, p3^2, p2^3 on p1=0
    assert a5_sextic_dimension == 7
    assert outer_even_sextic_dimension == 5
    assert symmetric_sextic_dimension == 4

    return {
        "field": "Q[t]/(t^2-t-1)",
        "vertex_axis_columns": vertex_axes,
        "paper_i_face_chirality_supports": sorted(face_chirality),
        "paper_i_complement_chirality_supports": sorted(complement_chirality),
        "support_to_syntheme_pair": [
            {"support": support, "syntheme_pair": support_to_syntheme_pair[support]}
            for support in sorted(face_chirality)
        ],
        "syntheme_to_paper_iii_label": syntheme_to_face_label,
        "support_to_paper_iii_face_axis": [
            {"support": support, "axis_label": support_to_axis_label[support]}
            for support in sorted(face_chirality)
        ],
        "complementary_signed_sum_decompositions": [
            {
                "face_support": support,
                "complement_support": complementary_decompositions[support][0],
                "complement_signs": complementary_decompositions[support][1],
                "common_axis_label": support_to_axis_label[support],
            }
            for support in sorted(face_chirality)
        ],
        "galois_conjugation_preserves_face_chirality_supports": True,
        "support_complementation_swaps_chirality_supports": True,
        "support_signed_moments_vanish_through_degree": 2,
        "support_first_nonzero_signed_moment_degree": 3,
        "support_orientation_cubic_terms": [
            {"support": support, "coefficient": signed_supports[support]}
            for support in sorted(signed_supports)
        ],
        "naive_syntheme_quadratic_clebsch_square_identity": {
            "holds": False,
            "witness_ratios": [str(square_test_a[2]), str(square_test_b[2])],
        },
        "corrected_sextic_identity_on_p1_zero": {
            "left": "375*C_support^2 - 12*sigma3(q)",
            "right": "6000*p6 - 4350*p4*p2 - 2125*p3^2 + 705*p2^3",
            "right_elementary": (
                "-15*(16*e2^3 - 80*e2*e4 + 75*e3^2 + 2400*e6)"
            ),
            "exact_interpolation_grid": [0, 1, 2, 3, 4, 5, 6],
            "grid_dimension": 5,
            "degree_bound_per_variable": 6,
        },
        "degree_six_invariant_dimensions": {
            "A5": a5_sextic_dimension,
            "outer_S5_even": outer_even_sextic_dimension,
            "outer_S5_odd": (
                a5_sextic_dimension - outer_even_sextic_dimension
            ),
            "S6_symmetric": symmetric_sextic_dimension,
        },
        "exotic_even_quotient_projective_ratio": {
            "C_support_squared": 4,
            "sigma3_of_syntheme_quadratic": 125,
            "C_support_squared_is_not_S6_symmetric_witness": {
                "vector": nonsymmetric_witness,
                "swap_zero_two_values": [484, 36],
            },
        },
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
        "icosahedral_marking": icosahedral_marking_certificate(),
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
