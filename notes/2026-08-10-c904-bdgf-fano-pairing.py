#!/usr/bin/env python3
"""Exact exterior-algebra scalar for the C904 BdGF/Fano pullback.

On a principally polarized abelian fivefold, let theta be the symplectic
form and p the first Chern class of the Poincare bundle on A x A.  This
computes the bilinear form obtained by pulling p^3/3! to two minimal-class
Fano surfaces [F]=theta^3/3!.
"""

from math import factorial


def wedge(left, right):
    result = {}
    for left_indices, left_value in left.items():
        left_set = set(left_indices)
        for right_indices, right_value in right.items():
            if left_set.intersection(right_indices):
                continue
            inversions = sum(
                i > j for i in left_indices for j in right_indices
            )
            indices = tuple(sorted(left_indices + right_indices))
            sign = -1 if inversions % 2 else 1
            result[indices] = (
                result.get(indices, 0)
                + sign * left_value * right_value
            )
    return {indices: value for indices, value in result.items() if value}


def wedge_power(value, exponent):
    result = {(): 1}
    for _ in range(exponent):
        result = wedge(result, value)
    return result


def main():
    theta_first = {}
    theta_second = {}
    poincare = {}
    for index in range(5):
        e = 2 * index
        f = e + 1
        e_dual = 10 + e
        f_dual = 10 + f
        theta_first[(e, f)] = 1
        theta_second[(e_dual, f_dual)] = 1
        poincare[(e, f_dual)] = 1
        poincare[(f, e_dual)] = -1

    numerator = wedge(
        wedge(
            wedge_power(poincare, 3),
            wedge_power(theta_first, 3),
        ),
        wedge_power(theta_second, 3),
    )
    denominator = factorial(3) ** 3
    top = tuple(range(20))
    matrix = []
    for row in range(10):
        values = []
        for column in range(10):
            product = wedge(
                wedge(numerator, {(row,): 1}),
                {(10 + column,): 1},
            )
            coefficient = product.get(top, 0)
            assert coefficient % denominator == 0
            values.append(coefficient // denominator)
        matrix.append(values)

    expected = [
        [
            4 if column == row + 1 and row % 2 == 0
            else -4 if row == column + 1 and column % 2 == 0
            else 0
            for column in range(10)
        ]
        for row in range(10)
    ]
    assert matrix == expected

    print("C904 BdGF/Fano Poincare-cube pairing")
    print("dimension=5")
    print("[F]=theta^3/3!")
    print("kernel=poincare^3/3!")
    print("pairing matrix=4 times the standard symplectic form")
    print("PASS")


if __name__ == "__main__":
    main()
