#!/usr/bin/env python3
"""Euler-weight ideal for the rank-three theta-resolution moduli problem.

For a cubic threefold, H^3=3 and
td(X)=1+H+2H^2/3+H^3/3.  The moduli vector is
v=(3,-H,-H^2/2,H^3/6).  Line bundles alone have weight gcd three, but a
point and a line have weights three and two.  Their difference has weight
one, so the moduli problem is fine.
"""

from fractions import Fraction
from math import factorial, gcd


def multiply(left, right):
    result = [Fraction(0)] * 4
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            if i + j <= 3:
                result[i + j] += x * y
    return result


def euler_weight(k):
    v = [Fraction(3), -Fraction(1), -Fraction(1, 2), Fraction(1, 6)]
    td = [Fraction(1), Fraction(1), Fraction(2, 3), Fraction(1, 3)]
    twist = [Fraction(k**j, factorial(j)) for j in range(4)]
    answer = 3 * multiply(multiply(v, twist), td)[3]
    assert answer.denominator == 1
    return answer.numerator


def euler_against(ch_value):
    v = [Fraction(3), -Fraction(1), -Fraction(1, 2), Fraction(1, 6)]
    td = [Fraction(1), Fraction(1), Fraction(2, 3), Fraction(1, 3)]
    answer = 3 * multiply(multiply(v, ch_value), td)[3]
    assert answer.denominator == 1
    return answer.numerator


def main():
    weights = {k: euler_weight(k) for k in range(-2, 3)}
    assert weights == {-2: -3, -1: 0, 0: 0, 1: 6, 2: 27}
    weight_gcd = 0
    for value in weights.values():
        weight_gcd = gcd(weight_gcd, abs(value))
    assert weight_gcd == 3
    # [point]=H^3/3.  For a line, ch(O_l)=H^2/3: its degree-three
    # coefficient is zero because chi(O_l)=1.
    point_weight = euler_against([0, 0, 0, Fraction(1, 3)])
    line_weight = euler_against([0, 0, Fraction(1, 3), 0])
    full_weight_gcd = gcd(weight_gcd, point_weight, line_weight)
    assert full_weight_gcd == 1

    print("C904 theta-resolution determinant weights")
    print("weights k=-2,-1,0,1,2: -3,0,0,6,27")
    print(f"line-bundle Euler-weight gcd: {weight_gcd}")
    print(f"point/line weights: {point_weight},{line_weight}")
    print(f"full displayed Euler-weight gcd: {full_weight_gcd}")
    print("moduli problem is fine: universal-sheaf weight one")


if __name__ == "__main__":
    main()
