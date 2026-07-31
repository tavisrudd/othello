#!/usr/bin/env python3
"""Independent exact replay of the C707 frame and transition-volume claims."""

from __future__ import annotations

import itertools
from fractions import Fraction


C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)
TRIPLES = tuple(itertools.combinations(range(6), 3))
Q5 = tuple[Fraction, Fraction]  # a+b*sqrt(5)
ZERO: Q5 = (Fraction(0), Fraction(0))
ONE: Q5 = (Fraction(1), Fraction(0))


def add(left: Q5, right: Q5) -> Q5:
    return left[0] + right[0], left[1] + right[1]


def multiply(left: Q5, right: Q5) -> Q5:
    return (
        left[0] * right[0] + 5 * left[1] * right[1],
        left[0] * right[1] + left[1] * right[0],
    )


def scale(scalar: int | Fraction, value: Q5) -> Q5:
    return scalar * value[0], scalar * value[1]


def total(values) -> Q5:
    result = ZERO
    for value in values:
        result = add(result, value)
    return result


def matmul(left: list[list[Q5]], right: list[list[Q5]]) -> list[list[Q5]]:
    return [
        [total(multiply(left[i][k], right[k][j]) for k in range(len(right)))
         for j in range(len(right[0]))]
        for i in range(len(left))
    ]


def determinant(matrix: list[list[Q5]]) -> Q5:
    if not matrix:
        return ONE
    return total(
        scale(
            (-1) ** column,
            multiply(
                matrix[0][column],
                determinant([
                    row[:column] + row[column + 1 :]
                    for row in matrix[1:]
                ]),
            ),
        )
        for column in range(len(matrix))
    )


def projector(sign: int) -> list[list[Q5]]:
    # (I+sign*C/sqrt(5))/2 = I/2+sign*sqrt(5)C/10.
    return [
        [(Fraction(int(i == j), 2), Fraction(sign * C[i][j], 10))
         for j in range(6)]
        for i in range(6)
    ]


def transition_volume_square(x: tuple[int, ...]) -> Fraction:
    p_minus, p_plus = projector(-1), projector(1)
    diagonal = [[(Fraction(x[i]) if i == j else Fraction(0), Fraction(0))
                 for j in range(6)] for i in range(6)]
    block = matmul(matmul(p_minus, diagonal), p_plus)
    transpose = [list(row) for row in zip(*block)]
    gram = matmul(transpose, block)
    elementary_three = total(
        determinant([[gram[i][j] for j in support] for i in support])
        for support in TRIPLES
    )
    assert elementary_three[1] == 0
    return elementary_three[0]


p_minus, p_plus = projector(-1), projector(1)
identity = [[ONE if i == j else ZERO for j in range(6)] for i in range(6)]
assert matmul(p_plus, p_plus) == p_plus
assert matmul(p_minus, p_minus) == p_minus
assert matmul(p_plus, p_minus) == [[ZERO] * 6 for _ in range(6)]
assert [[add(p_plus[i][j], p_minus[i][j]) for j in range(6)] for i in range(6)] == identity

for projector_matrix in (p_plus, p_minus):
    gram = [[scale(2, projector_matrix[i][j]) for j in range(6)] for i in range(6)]
    effect_gram = [[multiply(gram[i][j], gram[i][j]) for j in range(6)] for i in range(6)]
    assert effect_gram == [[(Fraction(1 if i == j else 1, 1 if i == j else 5), Fraction(0))
                            for j in range(6)] for i in range(6)]

for x in itertools.product((-1, 0, 1), repeat=6):
    z = sum(
        C[i][j] * C[j][k] * C[k][i] * x[i] * x[j] * x[k]
        for i, j, k in TRIPLES
    )
    assert transition_volume_square(x) == Fraction(z * z, 500)

print(
    "independent replay passed: two exact Q(sqrt(5)) projectors; "
    "729 diagonal filters; det(K^T K)=Z^2/500"
)
