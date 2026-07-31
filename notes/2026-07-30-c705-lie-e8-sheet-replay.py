#!/usr/bin/env python3
"""Independent hard-coded replay of the C705 split Joubert sheet."""

from itertools import combinations, permutations


P = 1447
ROOTS = (449, 773, 775, 878, 1238, 1321)
TRIPLES = tuple(combinations(range(6), 3))
Z = (
    (-1, -1, 1, 1, 1, -1, 1, 1, -1, -1, 1, 1, -1, -1, 1, -1, -1, -1, 1, 1),
    (1, 1, -1, -1, -1, -1, 1, 1, -1, 1, -1, 1, -1, -1, 1, 1, 1, 1, -1, -1),
    (1, -1, 1, -1, 1, -1, -1, -1, 1, 1, -1, -1, 1, 1, 1, -1, 1, -1, 1, -1),
    (-1, 1, -1, 1, 1, 1, -1, -1, -1, 1, -1, 1, 1, 1, -1, -1, -1, 1, -1, 1),
    (-1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1, -1, 1, -1, -1, 1, 1, -1, -1, 1),
    (1, -1, -1, 1, -1, 1, -1, 1, 1, -1, 1, -1, -1, 1, -1, 1, -1, 1, 1, -1),
)


def evaluate(row, values):
    return sum(
        coefficient * values[i] * values[j] * values[k]
        for coefficient, (i, j, k) in zip(row, TRIPLES)
    ) % P


images = set()
for ordering in permutations(ROOTS):
    mean = sum(ordering) * pow(6, -1, P) % P
    centered = tuple((value - mean) % P for value in ordering)
    joubert = tuple(evaluate(row, centered) for row in Z)
    square_sum = sum(value * value for value in joubert) % P
    polar = tuple((6 * value * value - square_sum) % P for value in joubert)
    assert sum(joubert) % P == 0
    assert sum(value**3 for value in joubert) % P == 0
    assert sum(polar) % P == 0
    assert (
        sum(value * value for value in polar) ** 2
        - 4 * sum(value**4 for value in polar)
    ) % P == 0
    images.add(joubert)

assert len(images) == 720
assert tuple(evaluate(row, (508, 832, 834, 937, 1297, 1380)) for row in Z) == (
    386,
    250,
    745,
    1361,
    891,
    708,
)

print("C705 independent Lie-E8 sheet replay: 720/720")
