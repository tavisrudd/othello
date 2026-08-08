#!/usr/bin/env python3
"""Independently check the two-generator odd-A5 commutant calculation."""

from __future__ import annotations

import itertools
from fractions import Fraction


Permutation = tuple[int, ...]
IntegerMatrix = list[list[int]]

ORDER = (0, 1, 2, 5, 3, 4)
SIGNS = (1, 1, 1, -1, -1, 1)
CONFERENCE = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)
ROTATION_ONE = (
    (1, 0, 0, 0, 0, 0),
    (0, 0, 0, 1, 0, 0),
    (0, 1, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, -1),
    (0, 0, -1, 0, 0, 0),
    (0, 0, 0, 0, 1, 0),
)
FIRST_ORBITAL = (
    (0, 0, 0, 0, 0, -1),
    (1, 0, 0, 0, 0, 0),
    (0, 0, 0, -1, 0, 0),
    (0, 0, 0, 0, 1, 0),
    (0, 0, -1, 0, 0, 0),
    (0, -1, 0, 0, 0, 0),
)


def compose(left: Permutation, right: Permutation) -> Permutation:
    """Permutation multiplication in the convention used by Lean's `Equiv.Perm`."""
    return tuple(left[right[index]] for index in range(5))


def parity(permutation: Permutation) -> int:
    return sum(
        permutation[left] > permutation[right]
        for left in range(5)
        for right in range(left + 1, 5)
    ) % 2


def rotation(index: int) -> Permutation:
    return tuple((value - index) % 5 for value in range(5))


def reflection(index: int) -> Permutation:
    return tuple((index - value) % 5 for value in range(5))


def transposition(left: int, right: int) -> Permutation:
    result = list(range(5))
    result[left], result[right] = result[right], result[left]
    return tuple(result)


def multiply(left: IntegerMatrix, right: IntegerMatrix) -> IntegerMatrix:
    return [
        [sum(left[row][inner] * right[inner][column] for inner in range(6))
         for column in range(6)]
        for row in range(6)
    ]


def normalized_action(group_element: Permutation) -> IntegerMatrix:
    identity = tuple(range(5))
    first = compose(transposition(2, 3), transposition(3, 4))
    representatives = [identity] + [
        compose(rotation(index), first) for index in range(5)
    ]
    raw = [[0 for _ in range(6)] for _ in range(6)]
    for row in range(6):
        for column in range(6):
            image = compose(group_element, representatives[column])
            positive = any(
                image == compose(representatives[row], rotation(index))
                for index in range(5)
            )
            negative = any(
                image == compose(
                    compose(representatives[row], reflection(0)),
                    rotation(index),
                )
                for index in range(5)
            )
            assert not (positive and negative)
            raw[row][column] = 1 if positive else (-1 if negative else 0)
    assert all(sum(value * value for value in row) == 1 for row in raw)
    assert all(
        sum(raw[row][column] ** 2 for row in range(6)) == 1
        for column in range(6)
    )
    return [
        [
            SIGNS[ORDER[row]]
            * raw[ORDER[row]][ORDER[column]]
            * SIGNS[ORDER[column]]
            for column in range(6)
        ]
        for row in range(6)
    ]


def constraint_rows(matrices: list[IntegerMatrix]) -> list[list[int]]:
    """Coefficient rows for `T M = M T` on the 36 entries of `T`."""
    rows: list[list[int]] = []
    for matrix in matrices:
        for row in range(6):
            for column in range(6):
                equation = [0 for _ in range(36)]
                for inner in range(6):
                    equation[6 * row + inner] += matrix[inner][column]
                    equation[6 * inner + column] -= matrix[row][inner]
                rows.append(equation)
    return rows


def rational_rank(integer_rows: list[list[int]]) -> int:
    rows = [[Fraction(value) for value in row] for row in integer_rows]
    pivot_row = 0
    for column in range(len(rows[0])):
        pivot = next(
            (row for row in range(pivot_row, len(rows)) if rows[row][column]),
            None,
        )
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        scale = rows[pivot_row][column]
        rows[pivot_row] = [value / scale for value in rows[pivot_row]]
        for row in range(len(rows)):
            if row != pivot_row and rows[row][column]:
                scale = rows[row][column]
                rows[row] = [
                    value - scale * pivot_value
                    for value, pivot_value in zip(rows[row], rows[pivot_row])
                ]
        pivot_row += 1
    return pivot_row


def main() -> None:
    alternating_group = [
        permutation
        for permutation in itertools.permutations(range(5))
        if parity(permutation) == 0
    ]
    assert len(alternating_group) == 60
    first = compose(transposition(2, 3), transposition(3, 4))
    actions = [normalized_action(element) for element in alternating_group]
    assert normalized_action(rotation(1)) == [list(row) for row in ROTATION_ONE]
    assert normalized_action(first) == [list(row) for row in FIRST_ORBITAL]
    conference = [list(row) for row in CONFERENCE]
    assert all(
        multiply(conference, action) == multiply(action, conference)
        for action in actions
    )
    rank = rational_rank(
        constraint_rows(
            [[*map(list, ROTATION_ONE)], [*map(list, FIRST_ORBITAL)]]
        )
    )
    assert rank == 34
    print(
        "odd_commutant=ok group_order=60 generators=2 "
        f"constraint_rank={rank} commutant_dimension={36 - rank}"
    )


if __name__ == "__main__":
    main()
