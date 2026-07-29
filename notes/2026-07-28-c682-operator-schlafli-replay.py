#!/usr/bin/env python3
"""Independent two-prime replay of the C682 operator double-six."""

from __future__ import annotations

import itertools
import math


def rref(matrix, prime):
    work = [[value % prime for value in row] for row in matrix]
    row = 0
    pivots = []
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, prime)
        work[row] = [value * inverse % prime for value in work[row]]
        for index in range(len(work)):
            if index == row:
                continue
            scale = work[index][column]
            work[index] = [
                (left - scale * right) % prime
                for left, right in zip(work[index], work[row], strict=True)
            ]
        pivots.append(column)
        row += 1
    return work[:row], pivots


def rank(matrix, prime):
    return len(rref(matrix, prime)[1]) if matrix else 0


def nullspace(matrix, prime):
    reduced, pivots = rref(matrix, prime)
    width = len(matrix[0])
    result = []
    for column in range(width):
        if column in pivots:
            continue
        vector = [0] * width
        vector[column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][column] % prime
        result.append(vector)
    return result


def product(left, right, prime):
    result = [0] * (len(left) + len(right) - 1)
    for left_index, left_value in enumerate(left):
        for right_index, right_value in enumerate(right):
            result[left_index + right_index] = (
                result[left_index + right_index] + left_value * right_value
            ) % prime
    return result


def power(value, exponent, prime):
    result = [1]
    for _ in range(exponent):
        result = product(result, value, prime)
    return result


def apolar_pair(left, right, prime):
    return sum(
        (-1) ** index
        * math.factorial(index)
        * math.factorial(6 - index)
        * left[index]
        * right[6 - index]
        for index in range(7)
    ) % prime


def annihilator(space, prime):
    equations = [
        [
            apolar_pair(
                [1 if index == column else 0 for index in range(7)],
                vector,
                prime,
            )
            for column in range(7)
        ]
        for vector in space
    ]
    return nullspace(equations, prime)


def intersection(left, right, prime):
    return annihilator(annihilator(left, prime) + annihilator(right, prime), prime)


def intersection_dimension(left, right, prime):
    return len(left) + len(right) - rank(left + right, prime)


def falling(value, order):
    return 0 if value < order else math.factorial(value) // math.factorial(value - order)


def operator(sign, prime):
    terms = [(1, 11, 1), (sign * 11, 6, 6), (-1, 1, 11)]
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
            for coefficient, fx, fy in terms:
                right = (
                    coefficient
                    * falling(fx, index)
                    * falling(fy, 3 - index)
                )
                output_y = py - index + fy - (3 - index)
                if left and right:
                    matrix[output_y][column] += left * right
    content = math.gcd(*(value for row in matrix for value in row))
    return [[value // content % prime for value in row] for row in matrix]


def primitive_fifth_root(prime):
    return next(
        value
        for value in range(2, prime)
        if pow(value, 5, prime) == 1 and value != 1
    )


def replay(prime):
    zeta = primitive_fifth_root(prime)
    plus = operator(1, prime)
    minus = operator(-1, prime)
    assert rank(plus, prime) == rank(minus, prime) == 4
    plus_kernel = nullspace(plus, prime)
    minus_kernel = nullspace(minus, prime)
    fixed_space = annihilator(plus_kernel, prime)
    assert intersection_dimension(plus_kernel, minus_kernel, prime) == 1

    axes = [[0, 1, 0]]
    for exponent in range(5):
        value = pow(zeta, exponent, prime)
        axes.append([1, value, -value * value % prime])

    e_lines = []
    e_prime_lines = []
    for axis in axes:
        cube = power(axis, 3, prime)
        assert rank(plus_kernel + [cube], prime) == 3
        square = power(axis, 2, prime)
        tangent = [
            product(square, basis, prime)
            for basis in ([1, 0, 0], [0, 1, 0], [0, 0, 1])
        ]
        e_lines.append(intersection(fixed_space, tangent, prime))
        e_prime_lines.append(
            intersection(fixed_space, annihilator(tangent, prime), prime)
        )
    assert all(len(line) == 2 for line in e_lines + e_prime_lines)
    assert all(
        intersection_dimension(e_lines[left], e_lines[right], prime) == 0
        for left, right in itertools.combinations(range(6), 2)
    )
    assert all(
        intersection_dimension(
            e_prime_lines[left], e_prime_lines[right], prime
        )
        == 0
        for left, right in itertools.combinations(range(6), 2)
    )
    cross = [
        [
            intersection_dimension(e_lines[left], e_prime_lines[right], prime)
            for right in range(6)
        ]
        for left in range(6)
    ]
    assert cross == [
        [0 if left == right else 1 for right in range(6)]
        for left in range(6)
    ]
    return zeta


def main():
    rows = [(prime, replay(prime)) for prime in (31, 41)]
    print(
        "PASS independent finite-field replay "
        + " ".join(f"p={prime}:zeta={zeta}" for prime, zeta in rows)
    )


if __name__ == "__main__":
    main()
