#!/usr/bin/env python3
"""Exact exterior-algebra sign check for the C904 Poincare-cubic bypass."""

from fractions import Fraction
from math import comb, factorial


def wedge(left, right):
    result = {}
    for left_indices, left_value in left.items():
        left_set = set(left_indices)
        for right_indices, right_value in right.items():
            if left_set.intersection(right_indices):
                continue
            inversions = sum(i > j for i in left_indices for j in right_indices)
            indices = tuple(sorted(left_indices + right_indices))
            coefficient = left_value * right_value
            if inversions % 2:
                coefficient = -coefficient
            result[indices] = result.get(indices, Fraction(0)) + coefficient
            if not result[indices]:
                del result[indices]
    return result


def divided_power(value, exponent):
    result = {(): Fraction(1)}
    for _ in range(exponent):
        result = wedge(result, value)
    divisor = factorial(exponent)
    return {indices: coefficient / divisor
            for indices, coefficient in result.items()}


def one_form(index):
    return {(index,): Fraction(1)}


def scalar_for_minimal_carrier(dimension, carrier_dimension):
    shift = 2 * dimension
    theta_first = {}
    theta_second = {}
    poincare = {}
    for i in range(dimension):
        a = 2 * i
        b = 2 * i + 1
        theta_first[(a, b)] = Fraction(1)
        theta_second[(shift + a, shift + b)] = Fraction(1)
        poincare[(a, shift + b)] = Fraction(1)
        poincare[(b, shift + a)] = Fraction(-1)
    carrier_product = wedge(
        divided_power(theta_first, dimension - carrier_dimension),
        divided_power(theta_second, dimension - carrier_dimension),
    )
    kernel = wedge(
        carrier_product, divided_power(poincare, 2 * carrier_dimension - 1)
    )
    value = wedge(kernel, wedge(one_form(0), one_form(shift + 1)))
    return value.get(tuple(range(4 * dimension)), Fraction(0))


def main():
    # On each factor use (a_0,b_0,...,a_4,b_4), with the second shifted by 10.
    theta_first = {}
    theta_second = {}
    poincare = {}
    omega = [[0] * 10 for _ in range(10)]
    for i in range(5):
        a = 2 * i
        b = 2 * i + 1
        theta_first[(a, b)] = Fraction(1)
        theta_second[(10 + a, 10 + b)] = Fraction(1)
        # P=m^*Theta-p_1^*Theta-p_2^*Theta.
        poincare[(a, 10 + b)] = Fraction(1)
        poincare[(b, 10 + a)] = Fraction(-1)
        omega[a][b] = 1
        omega[b][a] = -1

    fano_product = wedge(divided_power(theta_first, 3),
                         divided_power(theta_second, 3))
    kernel = wedge(fano_product, divided_power(poincare, 3))
    top = tuple(range(20))
    pairing = []
    for i in range(10):
        row = []
        for j in range(10):
            value = wedge(kernel, wedge(one_form(i), one_form(10 + j)))
            row.append(value.get(top, Fraction(0)))
        pairing.append(row)

    four_omega = [[4 * value for value in row] for row in omega]
    negative_four_omega = [[-value for value in row] for row in four_omega]
    scalar = 4 if pairing == four_omega else -4 if pairing == negative_four_omega else 0
    nonzero = [(i, j, pairing[i][j])
               for i in range(10) for j in range(10) if pairing[i][j]]
    if not scalar:
        print(nonzero)
    assert scalar
    print("C904 Poincare-cubic Fano pairing")
    print("convention: P=m^*Theta-p1^*Theta-p2^*Theta")
    print(f"nonzero entries={nonzero}")
    print(f"kernel matrix={scalar:+d}*Omega; scalar on a_i tensor b_i is {scalar:+d}")
    print("replacing P by delta^*Theta-p1^*Theta-p2^*Theta flips the sign")
    general = [(dimension, scalar_for_minimal_carrier(dimension, 2))
               for dimension in range(2, 9)]
    assert all(value == dimension - 1 for dimension, value in general)
    print(f"general minimal-surface scalars={general}")
    dimension_five = [scalar_for_minimal_carrier(5, carrier_dimension)
                      for carrier_dimension in range(1, 6)]
    assert dimension_five == [Fraction((-1) ** d * comb(4, d - 1))
                              for d in range(1, 6)]
    print(f"dimension-5 minimal-carrier scalars={dimension_five}")
    print("PASS")


if __name__ == "__main__":
    main()
