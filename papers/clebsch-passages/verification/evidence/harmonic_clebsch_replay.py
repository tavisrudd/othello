#!/usr/bin/env python3
"""Independent replay of the degree-six Clebsch harmonic calculation."""

from __future__ import annotations

import json
from dataclasses import dataclass
from fractions import Fraction
from math import factorial
from pathlib import Path


Q = Fraction
CERTIFICATE = Path(__file__).with_name("harmonic_clebsch.json")


@dataclass(frozen=True)
class Root5:
    rational: Q
    radical: Q = Q(0)

    def __add__(self, other: "Root5") -> "Root5":
        return Root5(self.rational + other.rational, self.radical + other.radical)

    def __neg__(self) -> "Root5":
        return Root5(-self.rational, -self.radical)

    def __sub__(self, other: "Root5") -> "Root5":
        return self + (-other)

    def __mul__(self, other: "Root5") -> "Root5":
        return Root5(
            self.rational * other.rational + 5 * self.radical * other.radical,
            self.rational * other.radical + self.radical * other.rational,
        )

    def scale(self, value: Q | int) -> "Root5":
        return Root5(self.rational * value, self.radical * value)


ZERO = Root5(Q(0))
ONE = Root5(Q(1))
PHI = Root5(Q(1, 2), Q(1, 2))
INV_PHI = Root5(Q(-1, 2), Q(1, 2))


def vertices() -> list[tuple[Root5, Root5, Root5]]:
    result: list[tuple[Root5, Root5, Root5]] = []
    for a in (-1, 1):
        for b in (-1, 1):
            for c in (-1, 1):
                result.append((ONE.scale(a), ONE.scale(b), ONE.scale(c)))
    for slot in range(3):
        for a in (-1, 1):
            for b in (-1, 1):
                short = INV_PHI.scale(a)
                long = PHI.scale(b)
                result.append(
                    (
                        (ZERO, short, long),
                        (short, long, ZERO),
                        (long, ZERO, short),
                    )[slot]
                )
    return result


def axes() -> list[tuple[Root5, Root5, Root5]]:
    result: list[tuple[Root5, Root5, Root5]] = []
    for point in vertices():
        if point not in result and tuple(-entry for entry in point) not in result:
            result.append(point)
    return result


def inner(left: tuple[Root5, ...], right: tuple[Root5, ...]) -> Root5:
    answer = ZERO
    for a, b in zip(left, right):
        answer = answer + a * b
    return answer


def legendre6(value: Root5) -> Root5:
    square = value * value
    fourth = square * square
    sixth = fourth * square
    return (
        sixth.scale(231)
        + fourth.scale(-315)
        + square.scale(105)
        + ONE.scale(-5)
    ).scale(Q(1, 16))


Exponent = tuple[int, int, int]
DensePoly = dict[Exponent, Root5]


def multinomial(total: int, parts: Exponent) -> int:
    return factorial(total) // (factorial(parts[0]) * factorial(parts[1]) * factorial(parts[2]))


def triples(total: int):
    for first in range(total + 1):
        for second in range(total - first + 1):
            yield first, second, total - first - second


def linear_power(axis: tuple[Root5, Root5, Root5], degree: int) -> DensePoly:
    result: DensePoly = {}
    for exponent in triples(degree):
        coefficient = ONE.scale(multinomial(degree, exponent))
        for coordinate, power in zip(axis, exponent):
            for _ in range(power):
                coefficient = coefficient * coordinate
        result[exponent] = coefficient
    return result


def radius_power(degree: int) -> DensePoly:
    result: DensePoly = {}
    for exponent in triples(degree):
        result[tuple(2 * item for item in exponent)] = ONE.scale(
            multinomial(degree, exponent)
        )
    return result


def multiply(left: DensePoly, right: DensePoly) -> DensePoly:
    result: DensePoly = {}
    for a, u in left.items():
        for b, v in right.items():
            exponent = tuple(a[i] + b[i] for i in range(3))
            result[exponent] = result.get(exponent, ZERO) + u * v
    return {key: value for key, value in result.items() if value != ZERO}


def add_scaled(target: DensePoly, source: DensePoly, scalar: Q | int) -> None:
    for exponent, value in source.items():
        target[exponent] = target.get(exponent, ZERO) + value.scale(scalar)
        if target[exponent] == ZERO:
            del target[exponent]


def zonal(axis: tuple[Root5, Root5, Root5]) -> DensePoly:
    answer: DensePoly = {}
    for dot_degree, radius_degree, coefficient in (
        (6, 0, Q(231, 432)),
        (4, 1, Q(-35, 16)),
        (2, 2, Q(35, 16)),
        (0, 3, Q(-5, 16)),
    ):
        term = multiply(linear_power(axis, dot_degree), radius_power(radius_degree))
        add_scaled(answer, term, coefficient)
    return answer


def power(poly: DensePoly, exponent: int) -> DensePoly:
    answer: DensePoly = {(0, 0, 0): ONE}
    for _ in range(exponent):
        answer = multiply(answer, poly)
    return answer


def odd_double_factorial(value: int) -> int:
    answer = 1
    for item in range(value, 0, -2):
        answer *= item
    return answer


def average(poly: DensePoly) -> Root5:
    answer = ZERO
    for exponent, coefficient in poly.items():
        if any(item % 2 for item in exponent):
            continue
        numerator = 1
        for item in exponent:
            numerator *= odd_double_factorial(item - 1)
        denominator = odd_double_factorial(sum(exponent) + 1)
        answer = answer + coefficient.scale(Q(numerator, denominator))
    return answer


def matmul(left: list[list[int]], right: list[list[int]]) -> list[list[int]]:
    size = len(left)
    return [
        [sum(left[i][k] * right[k][j] for k in range(size)) for j in range(size)]
        for i in range(size)
    ]


def matrix_add(left: list[list[int]], scalar: int) -> list[list[int]]:
    return [
        [value + (scalar if i == j else 0) for j, value in enumerate(row)]
        for i, row in enumerate(left)
    ]


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    face_axes = axes()
    assert len(face_axes) == 10
    gram = [
        [legendre6(inner(left, right).scale(Q(1, 3))) for right in face_axes]
        for left in face_axes
    ]
    axis_labels = [
        [1, 2], [1, 3], [1, 4], [1, 5], [3, 4],
        [2, 5], [4, 5], [2, 3], [3, 5], [2, 4],
    ]
    adjacency = [
        [int(gram[i][j] == Root5(Q(-65, 243))) for j in range(10)]
        for i in range(10)
    ]
    assert all(sum(row) == 3 for row in adjacency)
    assert all(
        adjacency[i][j]
        == int(i != j and set(axis_labels[i]).isdisjoint(axis_labels[j]))
        for i in range(10)
        for j in range(10)
    )
    minimal = matmul(
        matmul(matrix_add(adjacency, -3), matrix_add(adjacency, -1)),
        matrix_add(adjacency, 2),
    )
    assert all(value == 0 for row in minimal for value in row)
    assert sum(adjacency[i][i] for i in range(10)) == 0
    assert sum(matmul(adjacency, adjacency)[i][i] for i in range(10)) == 30

    weights = [3] * 4 + [-2] * 6
    assert [
        sum(adjacency[i][j] * weights[j] for j in range(10))
        for i in range(10)
    ] == [-2 * value for value in weights]

    field: DensePoly = {}
    for weight, axis in zip(weights, face_axes):
        add_scaled(field, zonal(axis), weight)
    norm = average(power(field, 2))
    cubic = average(power(field, 3))
    scalar = cubic.scale(Q(1, 20))
    normalized_square = cubic.rational**2 / norm.rational**3
    wigner_square = Q(
        factorial(9) ** 2 * factorial(6) ** 3,
        factorial(3) ** 6 * factorial(19),
    )
    assert norm == Root5(Q(2800, 351))
    assert cubic == Root5(Q(-15680000, 1247103))
    assert scalar == Root5(Q(-784000, 1247103))
    assert normalized_square == Q(3931200, 12623809)
    assert wigner_square == Q(400, 46189)
    assert certificate["gaunt_scalar"] == "-784000/1247103"
    assert certificate["normalized_witness"] == "-120*sqrt(273)/3553"
    assert certificate["wigner_3j_6_6_6_0_0_0"] == "-20/sqrt(46189)"
    assert certificate["integral_to_standard_W6"] == "-130/sqrt(3553*pi)"
    assert certificate["axis_labels"] == axis_labels
    assert certificate["petersen_adjacency"] == adjacency
    assert certificate["spherical_gram_spectrum"] == {
        "110/1053": 1, "28/1053": 5, "140/1053": 4
    }
    print(
        "independent harmonic replay: OK "
        "(10 axes, Petersen spectrum 3^1 1^5 (-2)^4, "
        "Gaunt scalar -784000/1247103)"
    )


if __name__ == "__main__":
    main()
