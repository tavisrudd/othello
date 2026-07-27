#!/usr/bin/env python3
"""Independent mod-101 replay of the C682 transvectant ranks."""

from __future__ import annotations

from itertools import combinations, product
from math import comb, factorial, prod


PRIME = 101


def falling(n: int, r: int) -> int:
    return factorial(n) // factorial(n - r) if n >= r else 0


def matrix(
    dodecic: list[tuple[int, int, int]],
    *,
    reduce: bool = True,
) -> list[list[int]]:
    output = [[0] * 7 for _ in range(13)]
    for sextic_y in range(7):
        sextic_x = 6 - sextic_y
        for index in range(4):
            left = (
                (-1) ** index
                * comb(3, index)
                * falling(sextic_x, 3 - index)
                * falling(sextic_y, index)
            )
            if not left:
                continue
            for coefficient, dodecic_x, dodecic_y in dodecic:
                right = (
                    coefficient
                    * falling(dodecic_x, index)
                    * falling(dodecic_y, 3 - index)
                )
                if not right:
                    continue
                row = sextic_y - index + dodecic_y - (3 - index)
                value = output[row][sextic_y] + left * right
                output[row][sextic_y] = value % PRIME if reduce else value
    return output


def nullspace(input_matrix: list[list[int]]) -> list[list[int]]:
    work = [[entry % PRIME for entry in row] for row in input_matrix]
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
        inverse = pow(work[row][column], -1, PRIME)
        work[row] = [(entry * inverse) % PRIME for entry in work[row]]
        for index in range(len(work)):
            if index == row:
                continue
            scale = work[index][column]
            work[index] = [
                (work[index][j] - scale * work[row][j]) % PRIME
                for j in range(len(work[index]))
            ]
        pivots.append(column)
        row += 1
    output: list[list[int]] = []
    for free in range(len(work[0])):
        if free in pivots:
            continue
        vector = [0] * len(work[0])
        vector[free] = 1
        for index, pivot in enumerate(pivots):
            vector[pivot] = -work[index][free] % PRIME
        output.append(vector)
    return output


def rank(input_matrix: list[list[int]]) -> int:
    return len(input_matrix[0]) - len(nullspace(input_matrix))


def mat_vec_mod_11(matrix: list[list[int]], vector: list[int]) -> list[int]:
    return [
        sum(entry * coordinate for entry, coordinate in zip(row, vector)) % 11
        for row in matrix
    ]


def cross_mod_11(left: list[int], right: list[int]) -> list[int]:
    return [
        (left[1] * right[2] - left[2] * right[1]) % 11,
        (left[2] * right[0] - left[0] * right[2]) % 11,
        (left[0] * right[1] - left[1] * right[0]) % 11,
    ]


def replay_golden_gale_witness() -> None:
    axes_4 = [
        [0, 4, 1], [0, 4, -1], [1, 0, 4],
        [-1, 0, 4], [4, -1, 0], [-4, -1, 0],
    ]
    axes_8 = [
        [0, 8, 1], [0, 8, -1], [1, 0, 8],
        [-1, 0, 8], [8, -1, 0], [-8, -1, 0],
    ]
    kernel_rows = [
        [7, 4, 1, 1, 0, 0],
        [4, 10, 7, 0, 1, 0],
        [10, 4, 4, 0, 0, 1],
    ]
    axis_matrix = [list(row) for row in zip(*axes_4)]
    assert all(
        sum(a * b for a, b in zip(axis_row, kernel_row)) % 11 == 0
        for axis_row in axis_matrix
        for kernel_row in kernel_rows
    )
    projectivity = [[4, 1, 10], [0, 4, 4], [1, 0, 0]]
    for source, target in zip(zip(*kernel_rows), axes_8):
        image = mat_vec_mod_11(projectivity, list(source))
        assert image == [(7 * entry) % 11 for entry in target]
        assert cross_mod_11(image, target) == [0, 0, 0]


def replay_icosahedral_marking() -> None:
    modulus = 101

    def axes(root: int) -> list[list[int]]:
        return [
            [0, root, 1], [0, root, -1], [1, 0, root],
            [-1, 0, root], [root, -1, 0], [-root, -1, 0],
        ]

    def supports_and_centers(root: int) -> dict[tuple[int, int, int], list[int]]:
        vertices = [
            (index, [(sign * entry) % modulus for entry in axis])
            for index, axis in enumerate(axes(root))
            for sign in [1, -1]
        ]
        output: dict[tuple[int, int, int], list[int]] = {}
        for triple in combinations(vertices, 3):
            if not all(
                sum(
                    triple[left][1][coordinate] * triple[right][1][coordinate]
                    for coordinate in range(3)
                ) % modulus == root
                for left, right in [(0, 1), (0, 2), (1, 2)]
            ):
                continue
            support = tuple(sorted(vertex[0] for vertex in triple))
            center = [
                sum(vertex[1][coordinate] for vertex in triple) % modulus
                for coordinate in range(3)
            ]
            output.setdefault(support, center)
        return output

    root = 23
    conjugate_root = 79
    assert (root * root - root - 1) % modulus == 0
    assert conjugate_root == (1 - root) % modulus
    centers = supports_and_centers(root)
    face_chirality = {
        (0, 1, 4), (0, 1, 5), (0, 2, 3), (0, 2, 5), (0, 3, 4),
        (1, 2, 3), (1, 2, 4), (1, 3, 5), (2, 4, 5), (3, 4, 5),
    }
    assert set(centers) == face_chirality
    assert set(supports_and_centers(conjugate_root)) == face_chirality
    complement_chirality = {
        tuple(index for index in range(6) if index not in support)
        for support in face_chirality
    }
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
    assert any(
        sum(
            sign
            for support, sign in signed_supports.items()
            if all(index in support for index in indices)
        )
        for indices in product(range(6), repeat=3)
    )
    synthematic_total = [
        [(0, 1), (2, 3), (4, 5)],
        [(0, 2), (1, 4), (3, 5)],
        [(0, 3), (1, 5), (2, 4)],
        [(0, 4), (1, 3), (2, 5)],
        [(0, 5), (1, 2), (3, 4)],
    ]

    def square_ratio(vector: tuple[int, ...]) -> tuple[int, int]:
        support_cubic = sum(
            sign
            * vector[support[0]]
            * vector[support[1]]
            * vector[support[2]]
            for support, sign in signed_supports.items()
        )
        quadratics = [
            sum(vector[left] * vector[right] for left, right in matching)
            for matching in synthematic_total
        ]
        total = sum(quadratics)
        clebsch_coordinates = [5 * value - total for value in quadratics]
        return support_cubic, sum(value**3 for value in clebsch_coordinates) // 3

    assert square_ratio((-2, -2, -2, -1, -1, 8)) == (10, 8720)
    assert square_ratio((-2, -2, -2, -1, 0, 7)) == (18, 58480)
    assert 8720 * 18**2 != 58480 * 10**2
    for leading in product(range(7), repeat=5):
        vector = tuple(leading) + (-sum(leading),)
        support_cubic, clebsch_cubic = square_ratio(vector)
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
                prod(vector[index] for index in subset)
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
    witness = (-2, -2, -1, -1, 0, 6)
    swapped = (-1, -2, -2, -1, 0, 6)
    assert square_ratio(witness)[0] ** 2 == 484
    assert square_ratio(swapped)[0] ** 2 == 36

    inv_root = root - 1
    face_axes = {
        "12": [-1, -1, -1], "13": [-1, -1, 1],
        "14": [-1, 1, -1], "15": [-1, 1, 1],
        "34": [0, -inv_root, -root], "25": [0, -inv_root, root],
        "45": [-inv_root, -root, 0], "23": [-inv_root, root, 0],
        "35": [-root, 0, -inv_root], "24": [root, 0, -inv_root],
    }
    support_to_pair = {
        (0, 1, 4): (2, 4), (0, 1, 5): (1, 3),
        (0, 2, 3): (3, 4), (0, 2, 5): (0, 2),
        (0, 3, 4): (0, 1), (1, 2, 3): (1, 2),
        (1, 2, 4): (0, 3), (1, 3, 5): (0, 4),
        (2, 4, 5): (1, 4), (3, 4, 5): (2, 3),
    }
    relabel = {0: 1, 1: 5, 2: 2, 3: 4, 4: 3}
    for support, center in centers.items():
        labels = [
            label
            for label, axis in face_axes.items()
            if [
                (center[1] * axis[2] - center[2] * axis[1]) % modulus,
                (center[2] * axis[0] - center[0] * axis[2]) % modulus,
                (center[0] * axis[1] - center[1] * axis[0]) % modulus,
            ] == [0, 0, 0]
        ]
        assert len(labels) == 1
        expected = "".join(
            str(value)
            for value in sorted(relabel[index] for index in support_to_pair[support])
        )
        assert labels[0] == expected
        complement_support = tuple(
            index for index in range(6) if index not in support
        )
        complement_sums = []
        root_axes = axes(root)
        for signs in product([1, -1], repeat=3):
            candidate = [
                sum(
                    signs[index] * root_axes[axis_index][coordinate]
                    for index, axis_index in enumerate(complement_support)
                ) % modulus
                for coordinate in range(3)
            ]
            if [
                (center[1] * candidate[2] - center[2] * candidate[1]) % modulus,
                (center[2] * candidate[0] - center[0] * candidate[2]) % modulus,
                (center[0] * candidate[1] - center[1] * candidate[0]) % modulus,
            ] == [0, 0, 0]:
                complement_sums.append(signs)
        assert len(complement_sums) == 2
        assert complement_sums[1] == tuple(-sign for sign in complement_sums[0])


def fifth(
    left: list[int],
    right: list[int],
) -> list[int]:
    output = [0] * 3
    for left_y, left_coefficient in enumerate(left):
        left_x = 6 - left_y
        for right_y, right_coefficient in enumerate(right):
            right_x = 6 - right_y
            for index in range(6):
                coefficient = (
                    (-1) ** index
                    * comb(5, index)
                    * left_coefficient
                    * falling(left_x, 5 - index)
                    * falling(left_y, index)
                    * right_coefficient
                    * falling(right_x, index)
                    * falling(right_y, 5 - index)
                )
                output_y = left_y - index + right_y - (5 - index)
                if 0 <= output_y <= 2:
                    output[output_y] = (output[output_y] + coefficient) % PRIME
    return output


def main() -> None:
    global PRIME
    phi = [(1, 11, 1), (11, 6, 6), (-1, 1, 11)]
    base = matrix(phi)
    kernel = nullspace(base)
    assert rank(base) == 4
    assert len(kernel) == 3
    assert all(
        fifth(kernel[left], kernel[right]) == [0, 0, 0]
        for left in range(3)
        for right in range(left, 3)
    )

    left_kernel = nullspace([list(row) for row in zip(*base)])
    directions = [matrix([(1, 12 - index, index)]) for index in range(13)]
    constraints = [
        [
            sum(
                left_vector[row]
                * directions[direction][row][column]
                * kernel_vector[column]
                for row in range(13)
                for column in range(7)
            )
            % PRIME
            for direction in range(13)
        ]
        for left_vector in left_kernel
        for kernel_vector in kernel
    ]
    assert len(left_kernel) == 9
    assert rank(constraints) == 9

    for boundary, expected_kernel, expected_tangent_rank in [
        (
            [(1, 11, 1)],
            [
                [1, 0, 0, 0, 0, 0, 0],
                [0, 1, 0, 0, 0, 0, 0],
                [0, 0, 0, 1, 0, 0, 0],
            ],
            9,
        ),
        (
            [(1, 12, 0)],
            [
                [1, 0, 0, 0, 0, 0, 0],
                [0, 1, 0, 0, 0, 0, 0],
                [0, 0, 1, 0, 0, 0, 0],
            ],
            8,
        ),
    ]:
        boundary_matrix = matrix(boundary)
        boundary_kernel = nullspace(boundary_matrix)
        assert rank(boundary_matrix) == 4
        assert boundary_kernel == expected_kernel
        assert all(
            fifth(boundary_kernel[left], boundary_kernel[right]) == [0, 0, 0]
            for left in range(3)
            for right in range(left, 3)
        )
        boundary_left_kernel = nullspace(
            [list(row) for row in zip(*boundary_matrix)]
        )
        boundary_constraints = [
            [
                sum(
                    left_vector[row]
                    * directions[direction][row][column]
                    * kernel_vector[column]
                    for row in range(13)
                    for column in range(7)
                )
                % PRIME
                for direction in range(13)
            ]
            for left_vector in boundary_left_kernel
            for kernel_vector in boundary_kernel
        ]
        assert rank(boundary_constraints) == expected_tangent_rank

    raw_integer = matrix(phi, reduce=False)
    primitive_integer = [[entry // 2640 for entry in row] for row in raw_integer]
    reduction_ranks = {}
    for prime in [2, 3, 5, 7, 11, 13, 17, 19]:
        PRIME = prime
        reduction_ranks[prime] = rank(primitive_integer)
    assert reduction_ranks == {
        2: 4,
        3: 4,
        5: 2,
        7: 4,
        11: 4,
        13: 4,
        17: 4,
        19: 4,
    }
    matching_cubic_scalar = 4
    hitchin_restriction_scalar = 16 % 11
    orientation_cover_scalar = 5 * 16 % 11
    assert matching_cubic_scalar**2 % 11 == hitchin_restriction_scalar
    assert (4 * matching_cubic_scalar) ** 2 % 11 == orientation_cover_scalar
    replay_golden_gale_witness()
    replay_icosahedral_marking()
    print(
        "independent C682 replay: OK "
        "(boundary ranks 4, primitive mod-11 rank 4, "
        "c_match^2 = J0, golden Gale witness, marked face-support bridge, "
        "corrected sextic identity)"
    )


if __name__ == "__main__":
    main()
