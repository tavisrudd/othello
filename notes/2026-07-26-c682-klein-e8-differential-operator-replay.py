#!/usr/bin/env python3
"""Independent homogeneous-coefficient replay of the C682 E8 calculation."""

from fractions import Fraction
from itertools import product
from math import comb


def falling(value: int, length: int) -> int:
    out = 1
    for offset in range(length):
        out *= value - offset
    return out


def derivative(coefficients: list[int], degree: int, dx: int, dy: int) -> list[int]:
    out = [0] * (degree - dx - dy + 1)
    for y_degree, coefficient in enumerate(coefficients):
        x_degree = degree - y_degree
        if x_degree >= dx and y_degree >= dy:
            out[y_degree - dy] += (
                coefficient * falling(x_degree, dx) * falling(y_degree, dy)
            )
    return out


def multiply(left: list[int], right: list[int]) -> list[int]:
    out = [0] * (len(left) + len(right) - 1)
    for left_index, left_coefficient in enumerate(left):
        for right_index, right_coefficient in enumerate(right):
            out[left_index + right_index] += left_coefficient * right_coefficient
    return out


def power(polynomial: list[int], exponent: int) -> list[int]:
    out = [1]
    for _ in range(exponent):
        out = multiply(out, polynomial)
    return out


def transvectant(
    left: list[int],
    left_degree: int,
    right: list[int],
    right_degree: int,
    order: int,
) -> list[int]:
    out = [0] * (left_degree + right_degree - 2 * order + 1)
    for index in range(order + 1):
        left_derivative = derivative(left, left_degree, order - index, index)
        right_derivative = derivative(right, right_degree, index, order - index)
        term = multiply(left_derivative, right_derivative)
        scale = (-1) ** index * comb(order, index)
        out = [value + scale * addend for value, addend in zip(out, term)]
    return out


def proportionality(left: list[int], right: list[int]) -> Fraction:
    ratios = {
        Fraction(left_value, right_value)
        for left_value, right_value in zip(left, right)
        if right_value
    }
    assert all((left_value == 0) == (right_value == 0) for left_value, right_value in zip(left, right))
    assert len(ratios) == 1
    return ratios.pop()


def add_scaled(
    left: list[Fraction],
    right: list[Fraction],
    scale: Fraction,
) -> list[Fraction]:
    length = max(len(left), len(right))
    return [
        (left[index] if index < len(left) else 0)
        + scale * (right[index] if index < len(right) else 0)
        for index in range(length)
    ]


def coordinate_monomial(
    coordinates: tuple[list[Fraction], list[Fraction], list[Fraction]],
    exponents: tuple[int, int, int],
) -> list[Fraction]:
    out = [Fraction(1)]
    for coordinate, exponent in zip(coordinates, exponents):
        out = multiply(out, power(coordinate, exponent))
    return out


def main() -> None:
    klein_f = [0] * 13
    klein_f[1] = 1
    klein_f[6] = 11
    klein_f[11] = -1
    klein_h = transvectant(klein_f, 12, klein_f, 12, 2)
    klein_t = transvectant(klein_f, 12, klein_h, 20, 1)
    delta = lambda polynomial, degree: transvectant(
        polynomial,
        degree,
        klein_f,
        12,
        3,
    )

    assert not any(delta(klein_f, 12))
    assert not any(delta(klein_h, 20))
    assert proportionality(delta(klein_t, 30), power(klein_f, 3)) == 422427456000
    assert proportionality(delta(power(klein_f, 2), 24), klein_t) == 3
    assert (
        proportionality(delta(power(klein_f, 3), 36), multiply(klein_f, klein_t))
        == Fraction(135, 11)
    )
    third_commutator = [
        left - 3 * right
        for left, right in zip(
            delta(power(klein_f, 3), 36),
            multiply(klein_f, delta(power(klein_f, 2), 24)),
        )
    ]
    assert (
        proportionality(third_commutator, multiply(klein_f, klein_t))
        == Fraction(36, 11)
    )

    witness_left = delta(multiply(klein_f, [1] + [0] * 6), 18)
    witness_right = multiply(klein_f, delta([1] + [0] * 6, 6))
    assert witness_left != witness_right

    standard_h = [Fraction(coefficient, -242) for coefficient in klein_h]
    standard_t = [Fraction(coefficient, 4840) for coefficient in klein_t]
    coordinates = (
        [Fraction(coefficient) for coefficient in klein_f],
        standard_h,
        standard_t,
    )
    normal_terms = {
        (0, 0, 1): [((3, 0, 0), Fraction(1))],
        (0, 0, 2): [((3, 0, 1), Fraction(45, 19))],
        (0, 1, 1): [((3, 1, 0), Fraction(30, 19))],
        (1, 0, 1): [((4, 0, 0), Fraction(720, 551))],
        (2, 0, 0): [((0, 0, 1), Fraction(11, 132240))],
        (0, 0, 3): [
            ((8, 0, 0), Fraction(777600, 551)),
            ((3, 3, 0), Fraction(225, 551)),
        ],
        (0, 1, 2): [((3, 1, 1), Fraction(450, 551))],
        (0, 2, 1): [((3, 2, 0), Fraction(300, 551))],
        (0, 3, 0): [((3, 0, 1), Fraction(200, 1653))],
        (1, 0, 2): [((4, 0, 1), Fraction(540, 551))],
        (1, 1, 1): [((4, 1, 0), Fraction(360, 551))],
        (2, 0, 1): [
            ((5, 0, 0), Fraction(216, 551)),
            ((0, 3, 0), Fraction(1, 8816)),
        ],
        (2, 1, 0): [((0, 1, 1), Fraction(1, 13224))],
        (3, 0, 0): [((1, 0, 1), Fraction(1, 33060))],
    }
    for exponents in product(range(5), repeat=3):
        if sum(exponents) > 4:
            continue
        polynomial = coordinate_monomial(coordinates, exponents)
        degree = 12 * exponents[0] + 20 * exponents[1] + 30 * exponents[2]
        actual = [
            Fraction(coefficient, 87278400)
            for coefficient in delta(polynomial, degree)
        ]
        expected: list[Fraction] = []
        for derivatives, coefficient_terms in normal_terms.items():
            if any(
                derivative > exponent
                for derivative, exponent in zip(derivatives, exponents)
            ):
                continue
            derivative_multiplier = 1
            remainder = []
            for exponent, derivative in zip(exponents, derivatives):
                derivative_multiplier *= falling(exponent, derivative)
                remainder.append(exponent - derivative)
            for coefficient_exponents, coefficient in coefficient_terms:
                output_exponents = tuple(
                    remainder_exponent + coefficient_exponent
                    for remainder_exponent, coefficient_exponent in zip(
                        remainder,
                        coefficient_exponents,
                    )
                )
                term = coordinate_monomial(coordinates, output_exponents)
                expected = add_scaled(
                    expected,
                    term,
                    coefficient * derivative_multiplier,
                )
        length = max(len(actual), len(expected))
        actual += [Fraction(0)] * (length - len(actual))
        expected += [Fraction(0)] * (length - len(expected))
        assert actual == expected, exponents
    print("independent coefficient-list replay ok")


if __name__ == "__main__":
    main()
