#!/usr/bin/env python3
"""Independent conjugacy-class replay of the C742 target multiplicities."""

from __future__ import annotations

import math
from fractions import Fraction


PARTITIONS = (
    (1, 1, 1, 1, 1, 1), (2, 1, 1, 1, 1), (2, 2, 1, 1),
    (2, 2, 2), (3, 1, 1, 1), (3, 2, 1), (3, 3),
    (4, 1, 1), (4, 2), (5, 1), (6,),
)
OUTER = {
    (1, 1, 1, 1, 1, 1): (1, 1, 1, 1, 1, 1),
    (2, 1, 1, 1, 1): (2, 2, 2), (2, 2, 1, 1): (2, 2, 1, 1),
    (2, 2, 2): (2, 1, 1, 1, 1), (3, 1, 1, 1): (3, 3),
    (3, 2, 1): (6,), (3, 3): (3, 1, 1, 1),
    (4, 1, 1): (4, 1, 1), (4, 2): (4, 2),
    (5, 1): (5, 1), (6,): (3, 2, 1),
}


def class_size(partition):
    denominator = 1
    for length in set(partition):
        denominator *= length ** partition.count(length)
        denominator *= math.factorial(partition.count(length))
    return math.factorial(6) // denominator


def square_type(partition):
    parts = []
    for length in partition:
        divisor = math.gcd(length, 2)
        parts.extend([length // divisor] * divisor)
    return tuple(sorted(parts, reverse=True))


def sign(partition):
    return -1 if (6 - len(partition)) % 2 else 1


def inner(signed):
    total = 0
    for partition in PARTITIONS:
        axes = partition.count(1)
        wedge = (axes * axes - square_type(partition).count(1)) // 2
        outer_cells = OUTER[partition].count(1)
        target = outer_cells * wedge * (sign(partition) if signed else 1)
        total += class_size(partition) * (axes - 1) * target
    value = Fraction(total, math.factorial(6))
    assert value.denominator == 1
    return value.numerator


def main():
    actual = {"product": inner(False), "signed_product": inner(True)}
    assert actual == {"product": 1, "signed_product": 0}, actual
    print("independent unmarked target replay: OK")


if __name__ == "__main__":
    main()
