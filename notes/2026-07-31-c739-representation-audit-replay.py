#!/usr/bin/env python3
"""Independent combinatorial replay of the C739 P1 multiplicities.

This builds the exceptional six-set as the six synthematic totals of K_6,
enumerates all 720 vertex permutations, and never uses the hard-coded outer
conjugacy-class map from the primary checker.
"""

from __future__ import annotations

import itertools
import math
from fractions import Fraction


VERTICES = tuple(range(6))
EDGES = frozenset(itertools.combinations(VERTICES, 2))


def perfect_matchings(vertices: tuple[int, ...]):
    if not vertices:
        yield frozenset()
        return
    first = vertices[0]
    for index in range(1, len(vertices)):
        second = vertices[index]
        rest = vertices[1:index] + vertices[index + 1 :]
        for tail in perfect_matchings(rest):
            yield tail | {tuple(sorted((first, second)))}


SYNTHEMES = tuple(sorted(set(perfect_matchings(VERTICES)), key=repr))
TOTALS = tuple(
    frozenset(chosen)
    for chosen in itertools.combinations(SYNTHEMES, 5)
    if frozenset().union(*chosen) == EDGES
    and sum(len(syntheme) for syntheme in chosen) == len(EDGES)
)
assert len(SYNTHEMES) == 15
assert len(TOTALS) == 6


def compose(left, right):
    return tuple(left[right[i]] for i in VERTICES)


def power(permutation, exponent):
    result = VERTICES
    for _ in range(exponent):
        result = compose(permutation, result)
    return result


def parity(permutation):
    inversions = sum(
        permutation[i] > permutation[j] for i in VERTICES for j in range(i + 1, 6)
    )
    return -1 if inversions % 2 else 1


def act_edge(permutation, edge):
    return tuple(sorted((permutation[edge[0]], permutation[edge[1]])))


def act_total(permutation, total):
    return frozenset(
        frozenset(act_edge(permutation, edge) for edge in syntheme)
        for syntheme in total
    )


def axis_character(permutation):
    return sum(permutation[i] == i for i in VERTICES) - 1


def outer_character(permutation):
    return sum(act_total(permutation, total) == total for total in TOTALS) - 1


def signed_outer_character(permutation):
    return parity(permutation) * outer_character(permutation)


def symmetric_power_character(base_character, permutation, degree):
    values = [1]
    for current in range(1, degree + 1):
        numerator = sum(
            base_character(power(permutation, exponent)) * values[current - exponent]
            for exponent in range(1, current + 1)
        )
        assert numerator % current == 0
        values.append(numerator // current)
    return values[degree]


def inner_product(base_character, degree, target_character):
    total = sum(
        symmetric_power_character(base_character, permutation, degree)
        * target_character(permutation)
        for permutation in itertools.permutations(VERTICES)
    )
    value = Fraction(total, math.factorial(6))
    assert value.denominator == 1
    return value.numerator


def sequence(base_character, target_character):
    return [inner_product(base_character, d, target_character) for d in range(7)]


def main():
    expected = {
        "axis_to_signed_outer": [0, 0, 0, 1, 0, 2, 2],
        "signed_outer_to_trivial": [1, 0, 1, 0, 2, 0, 4],
        "signed_outer_to_sign": [0, 0, 0, 1, 0, 2, 0],
        "signed_outer_to_outer": [0, 0, 1, 0, 3, 0, 6],
        "signed_outer_to_signed_outer": [0, 1, 0, 2, 0, 5, 0],
    }
    actual = {
        "axis_to_signed_outer": sequence(axis_character, signed_outer_character),
        "signed_outer_to_trivial": sequence(signed_outer_character, lambda _p: 1),
        "signed_outer_to_sign": sequence(signed_outer_character, parity),
        "signed_outer_to_outer": sequence(signed_outer_character, outer_character),
        "signed_outer_to_signed_outer": sequence(
            signed_outer_character, signed_outer_character
        ),
    }
    assert actual == expected, (actual, expected)
    print("independent synthematic-total replay: OK")


if __name__ == "__main__":
    main()
