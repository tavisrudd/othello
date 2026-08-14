#!/usr/bin/env python3
"""Exact replay for the first C907 mixed-neutral toric shadow."""

from fractions import Fraction
from math import factorial


q1 = (1, 1, -1, -1, -1, -1, 0)
q2 = (1, 0, 1, 0, 0, 0, -1)
delta = tuple(a + 2 * b for a, b in zip(q1, q2))

assert sum(q1) == -2
assert sum(q2) == 1
assert delta == (3, 1, 1, -1, -1, -1, -2)
assert sum(delta) == 0


def coeff(n: int) -> Fraction:
    return Fraction(factorial(n) * factorial(2 * n), factorial(3 * n))


for n in range(0, 24):
    actual = coeff(n + 1) / coeff(n)
    expected = Fraction(2 * (n + 1) * (2 * n + 1),
                        3 * (3 * n + 1) * (3 * n + 2))
    assert actual == expected

# Coefficient recurrence of
# 3 theta(3 theta-1)(3 theta-2) F
#   - 2 q(theta+1)^2(2 theta+1) F = 0.
for n in range(1, 24):
    lhs = 3 * n * (3 * n - 1) * (3 * n - 2) * coeff(n)
    rhs = 2 * n * n * (2 * n - 1) * coeff(n - 1)
    assert lhs == rhs

print("charge:", delta)
print("c1 degrees: flip=-2, exceptional=1, strict=-3, neutral=0")
print("first coefficients:", [str(coeff(n)) for n in range(8)])
print("verified through degree 24")
