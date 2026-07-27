#!/usr/bin/env python3
"""Independent mod-101 replay of the C682 transvectant ranks."""

from __future__ import annotations

from math import comb, factorial


PRIME = 101


def falling(n: int, r: int) -> int:
    return factorial(n) // factorial(n - r) if n >= r else 0


def matrix(dodecic: list[tuple[int, int, int]]) -> list[list[int]]:
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
                output[row][sextic_y] = (
                    output[row][sextic_y] + left * right
                ) % PRIME
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
    print(
        "independent C682 replay: OK "
        "(mod 101 rank 4, isotropic kernel 3, tangent rank 9)"
    )


if __name__ == "__main__":
    main()
