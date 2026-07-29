#!/usr/bin/env python3
"""Independent replay for the C682 minimal-base arithmetic."""

from __future__ import annotations

import math


def falling(value: int, count: int) -> int:
    result = 1
    for offset in range(count):
        result *= value - offset
    return result if value >= count else 0


def rank(matrix: list[list[int]], prime: int) -> int:
    rows = [[entry % prime for entry in row] for row in matrix]
    pivot_row = 0
    for column in range(len(rows[0])):
        pivot = next(
            (row for row in range(pivot_row, len(rows)) if rows[row][column]),
            None,
        )
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        inverse = pow(rows[pivot_row][column], -1, prime)
        rows[pivot_row] = [
            entry * inverse % prime for entry in rows[pivot_row]
        ]
        for row in range(len(rows)):
            if row == pivot_row:
                continue
            multiplier = rows[row][column]
            rows[row] = [
                (entry - multiplier * source) % prime
                for entry, source in zip(rows[row], rows[pivot_row])
            ]
        pivot_row += 1
    return pivot_row


scales = [1, 1] + [11] * 9 + [1, 1]
for source in range(13):
    for target in range(source, 13):
        assert (
            scales[source] * math.comb(12 - source, target - source)
        ) % scales[target] == 0
    for target in range(source + 1):
        assert (
            scales[source] * math.comb(source, target)
        ) % scales[target] == 0

directions = []
for direction in range(13):
    matrix = [[0] * 7 for _ in range(13)]
    for output in range(13):
        for column in range(7):
            dodecic_index = output - column + 3
            if dodecic_index != direction:
                continue
            for index in range(4):
                matrix[output][column] += (
                    (-1) ** index
                    * math.comb(3, index)
                    * falling(6 - column, 3 - index)
                    * falling(column, index)
                    * scales[direction]
                    * falling(12 - direction, index)
                    * falling(direction, 3 - index)
                )
    directions.append(matrix)

content = math.gcd(
    *(
        abs(entry)
        for matrix in directions
        for row in matrix
        for entry in row
    )
)
assert content == 2640
directions = [
    [[entry // content for entry in row] for row in matrix]
    for matrix in directions
]

representatives = [
    [0, 1] + [0] * 4 + [1] + [0] * 4 + [-1, 0],
    [0, 1] + [0] * 11,
    [1] + [0] * 12,
]
expected = {
    2: [4, 2, 1],
    3: [4, 2, 0],
    5: [2, 2, 2],
    7: [4, 4, 4],
    11: [4, 4, 4],
    13: [4, 4, 4],
    23: [4, 4, 4],
}
for prime, expected_ranks in expected.items():
    actual = []
    for form in representatives:
        matrix = [
            [
                sum(
                    form[direction] * directions[direction][output][column]
                    for direction in range(13)
                )
                for column in range(7)
            ]
            for output in range(13)
        ]
        actual.append(rank(matrix, prime))
    assert actual == expected_ranks

apolar_weights = [60, -10, 4, -3, 4, -10, 60]
assert {
    prime: sum(weight % prime != 0 for weight in apolar_weights)
    for prime in [2, 3, 5, 7, 11, 23]
} == {2: 1, 3: 4, 5: 3, 7: 7, 11: 7, 23: 7}

denominator = 820125
center = 54781
half_difference = 24288
assert denominator == 3**8 * 5**3
assert half_difference == 2**5 * 3 * 11 * 23
assert center * center - 5 * half_difference * half_difference == 71**2 * 101**2
assert 2 * 3 * 5 * 11 * 23 == 7590

print("PASS: independent C682 minimal-base replay")
