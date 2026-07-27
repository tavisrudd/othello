#!/usr/bin/env python3
"""Independent mod-101 replay of the C682 transvectant inverse certificate."""

from __future__ import annotations

import itertools
import math


PRIME = 101


def falling(n: int, r: int) -> int:
    value = 1
    for offset in range(r):
        value *= n - offset
    return value if n >= r else 0


def rank_mod(matrix: list[list[int]]) -> int:
    work = [[entry % PRIME for entry in row] for row in matrix]
    row = 0
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
        row += 1
    return row


def third_matrix(form: list[int]) -> list[list[int]]:
    matrix = [[0] * 7 for _ in range(13)]
    for out_y in range(13):
        for in_y in range(7):
            form_y = out_y - in_y + 3
            if not 0 <= form_y <= 12:
                continue
            for index in range(4):
                matrix[out_y][in_y] += (
                    (-1) ** index
                    * math.comb(3, index)
                    * falling(6 - in_y, 3 - index)
                    * falling(in_y, index)
                    * form[form_y]
                    * falling(12 - form_y, index)
                    * falling(form_y, 3 - index)
                )
    return matrix


def fifth(left: list[int], right: list[int]) -> list[int]:
    output = [0, 0, 0]
    for left_y in range(7):
        for right_y in range(7):
            for index in range(6):
                out_y = left_y - index + right_y - (5 - index)
                if 0 <= out_y <= 2:
                    output[out_y] += (
                        (-1) ** index
                        * math.comb(5, index)
                        * left[left_y]
                        * falling(6 - left_y, 5 - index)
                        * falling(left_y, index)
                        * right[right_y]
                        * falling(6 - right_y, index)
                        * falling(right_y, 5 - index)
                    )
    return [entry % PRIME for entry in output]


def determinant3(matrix: list[list[int]]) -> int:
    return (
        matrix[0][0]
        * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1]
        * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2]
        * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    ) % PRIME


def inverse3(matrix: list[list[int]]) -> list[list[int]]:
    work = [
        [entry % PRIME for entry in row]
        + [int(row_index == column) for column in range(3)]
        for row_index, row in enumerate(matrix)
    ]
    for column in range(3):
        pivot = next(index for index in range(column, 3) if work[index][column])
        work[column], work[pivot] = work[pivot], work[column]
        inverse = pow(work[column][column], -1, PRIME)
        work[column] = [(entry * inverse) % PRIME for entry in work[column]]
        for index in range(3):
            if index == column:
                continue
            scale = work[index][column]
            work[index] = [
                (work[index][j] - scale * work[column][j]) % PRIME
                for j in range(6)
            ]
    return [row[3:] for row in work]


def normalized_chart(plane: list[list[int]]) -> tuple[list[list[int]], list[int]]:
    columns = next(
        subset
        for subset in itertools.combinations(range(7), 3)
        if determinant3(
            [[plane[row][subset[column]] for column in range(3)] for row in range(3)]
        )
    )
    inverse = inverse3(
        [[plane[row][columns[column]] for column in range(3)] for row in range(3)]
    )
    normalized = [
        [
            sum(inverse[row][middle] * plane[middle][column] for middle in range(3))
            % PRIME
            for column in range(7)
        ]
        for row in range(3)
    ]
    return normalized, [column for column in range(7) if column not in columns]


def check_representative(form: list[int], plane: list[list[int]]) -> tuple[int, int, int]:
    directions = [
        third_matrix([int(index == basis) for index in range(13)])
        for basis in range(13)
    ]
    matrix = third_matrix(form)
    assert rank_mod(matrix) == 4
    assert all(
        sum(matrix[row][column] * vector[column] for column in range(7)) % PRIME == 0
        for vector in plane
        for row in range(13)
    )
    assert all(
        fifth(plane[left], plane[right]) == [0, 0, 0]
        for left in range(3)
        for right in range(left + 1, 3)
    )

    annihilator = [
        [
            sum(directions[basis][row][column] * vector[column] for column in range(7))
            for basis in range(13)
        ]
        for vector in plane
        for row in range(13)
    ]
    assert rank_mod(annihilator) == 12

    normalized, complement = normalized_chart(plane)
    tangent_equations = []
    for plane_index, vector in enumerate(normalized):
        for output in range(13):
            row = [
                sum(directions[basis][output][column] * vector[column] for column in range(7))
                % PRIME
                for basis in range(13)
            ] + [0] * 12
            for local_column, column in enumerate(complement):
                row[13 + 4 * plane_index + local_column] = matrix[output][column]
            tangent_equations.append(row)
    for left in range(3):
        for right in range(left + 1, 3):
            for output in range(3):
                row = [0] * 25
                for local_column, column in enumerate(complement):
                    direction = [0] * 7
                    direction[column] = 1
                    row[13 + 4 * left + local_column] += fifth(
                        direction, normalized[right]
                    )[output]
                    row[13 + 4 * right + local_column] += fifth(
                        normalized[left], direction
                    )[output]
                tangent_equations.append(row)
    tangent_rank = rank_mod(tangent_equations)
    assert tangent_rank == 21
    return 4, 12, 25 - tangent_rank


def main() -> None:
    global PRIME
    representatives = [
        (
            [0, 1, 0, 0, 0, 0, 11, 0, 0, 0, 0, -1, 0],
            [
                [1, 0, 0, 0, 0, 3, 0],
                [0, 3, 0, 0, 0, 0, -1],
                [0, 0, 0, 1, 0, 0, 0],
            ],
        ),
        (
            [0, 1] + [0] * 11,
            [
                [1, 0, 0, 0, 0, 0, 0],
                [0, 1, 0, 0, 0, 0, 0],
                [0, 0, 0, 1, 0, 0, 0],
            ],
        ),
        (
            [1] + [0] * 12,
            [
                [1, 0, 0, 0, 0, 0, 0],
                [0, 1, 0, 0, 0, 0, 0],
                [0, 0, 1, 0, 0, 0, 0],
            ],
        ),
    ]
    results = [check_representative(*representative) for representative in representatives]
    assert results == [(4, 12, 4), (4, 12, 4), (4, 12, 4)]
    raw_directions = [
        third_matrix([int(index == basis) for index in range(13)])
        for basis in range(13)
    ]
    primitive_directions = [
        [[entry // 240 for entry in row] for row in matrix]
        for matrix in raw_directions
    ]
    expected = {
        2: [(4, 12), (2, 10), (1, 9)],
        3: [(4, 0), (2, 4), (0, 8)],
        5: [(2, 10), (2, 10), (2, 10)],
        7: [(4, 12), (4, 11), (4, 11)],
        11: [(0, 9), (0, 9), (0, 9)],
        13: [(4, 12), (4, 12), (4, 12)],
        17: [(4, 12), (4, 12), (4, 12)],
        19: [(4, 12), (4, 12), (4, 12)],
        23: [(4, 12), (4, 12), (4, 12)],
        29: [(4, 12), (4, 12), (4, 12)],
        31: [(4, 12), (4, 12), (4, 12)],
    }
    for prime, expected_rows in expected.items():
        PRIME = prime
        actual_rows = []
        for form, plane in representatives:
            matrix = [
                [
                    sum(
                        form[index] * primitive_directions[index][output][column]
                        for index in range(13)
                    )
                    for column in range(7)
                ]
                for output in range(13)
            ]
            annihilator = [
                [
                    sum(
                        primitive_directions[index][output][column] * vector[column]
                        for column in range(7)
                    )
                    for index in range(13)
                ]
                for vector in plane
                for output in range(13)
            ]
            actual_rows.append((rank_mod(matrix), rank_mod(annihilator)))
        assert actual_rows == expected_rows
    print(
        "PASS: mod-101 replay; three orbit rows have "
        "(transvectant rank, annihilator rank, affine incidence tangent dimension) "
        "= (4, 12, 4); primitive-tensor prime audit agrees"
    )


if __name__ == "__main__":
    main()
