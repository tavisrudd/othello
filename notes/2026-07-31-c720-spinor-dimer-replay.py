#!/usr/bin/env python3
"""Independent structural replay of the C720 K_3,3 characterization."""

from __future__ import annotations

import itertools


def parity(permutation: tuple[int, ...]) -> int:
    return -1 if sum(
        permutation[i] > permutation[j]
        for i in range(3) for j in range(i + 1, 3)
    ) % 2 else 1


def canonical_cycle(edges: frozenset[tuple[int, int]]) -> tuple[tuple[int, int], ...]:
    return tuple(sorted(edges))


cycles = set()
for tail in itertools.permutations(range(2, 6)):
    order = (1,) + tail
    edges = frozenset(tuple(sorted((order[i], order[(i + 1) % 5]))) for i in range(5))
    cycles.add(canonical_cycle(edges))
assert len(cycles) == 12

fingerprints = set()
sign_words = set()
for negative_edges in cycles:
    negative = set(negative_edges)
    matrix = [[0] * 6 for _ in range(6)]
    for i in range(6):
        for j in range(i + 1, 6):
            sign = -1 if (i, j) in negative else 1
            matrix[i][j] = matrix[j][i] = sign
    assert all(
        sum(matrix[i][k] * matrix[k][j] for k in range(6)) == 5 * int(i == j)
        for i in range(6) for j in range(6)
    )
    fingerprint = []
    sign_word = []
    for i, j in itertools.combinations(range(1, 6), 2):
        left = (0, i, j)
        right = tuple(k for k in range(6) if k not in left)
        terms = tuple(
            parity(p)
            * matrix[left[0]][right[p[0]]]
            * matrix[left[1]][right[p[1]]]
            * matrix[left[2]][right[p[2]]]
            for p in itertools.permutations(range(3))
        )
        assert min(terms.count(1), terms.count(-1)) == 1
        fingerprint.extend(term * terms[0] for term in terms)
        sign_word.append(sum(terms) // 4)
    fingerprints.add(tuple(fingerprint))
    sign_words.add(tuple(sign_word))

assert len(fingerprints) == 6
assert len(sign_words) == 6
rows = sorted(sign_words)
gram = [[sum(rows[a][i] * rows[a][j] for a in range(6)) for j in range(10)] for i in range(10)]
derived = [[(gram[i][j] - 6 * int(i == j)) // 2 for j in range(10)] for i in range(10)]
assert all(
    sum(derived[i][k] * derived[k][j] for k in range(10)) == 9 * int(i == j)
    for i in range(10) for j in range(10)
)

# Independent hard-coded order-ten boundary witness: this is conference, but
# its first balanced 5-by-5 cross block is singular.
C10 = (
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    (1, 0, 1, 1, 1, -1, -1, 1, -1, -1),
    (1, 1, 0, 1, -1, 1, -1, -1, 1, -1),
    (1, 1, 1, 0, -1, -1, 1, -1, -1, 1),
    (1, 1, -1, -1, 0, 1, 1, 1, -1, -1),
    (1, -1, 1, -1, 1, 0, 1, -1, 1, -1),
    (1, -1, -1, 1, 1, 1, 0, -1, -1, 1),
    (1, 1, -1, -1, 1, -1, -1, 0, 1, 1),
    (1, -1, 1, -1, -1, 1, -1, 1, 0, 1),
    (1, -1, -1, 1, -1, -1, 1, 1, 1, 0),
)
assert all(
    sum(C10[i][k] * C10[k][j] for k in range(10)) == 9 * int(i == j)
    for i in range(10) for j in range(10)
)
permutation = (0, 1, 5, 9, 6, 7, 2, 4, 3, 8)
switching = (1,) + tuple(derived[0][i] for i in range(1, 10))
assert all(
    switching[i] * switching[j] * derived[i][j]
    == C10[permutation[i]][permutation[j]]
    for i in range(10) for j in range(10)
)
cross = [[C10[i][j] for j in range(5, 10)] for i in range(5)]
from fractions import Fraction
work = [[Fraction(value) for value in row] for row in cross]
rank = 0
for column in range(5):
    pivot = next((row for row in range(rank, 5) if work[row][column]), None)
    if pivot is None:
        continue
    work[rank], work[pivot] = work[pivot], work[rank]
    value = work[rank][column]
    for row in range(5):
        if row != rank and work[row][column]:
            factor = work[row][column] / value
            work[row] = [work[row][j] - factor * work[rank][j] for j in range(5)]
    rank += 1
assert rank < 5

print("ok: order-6 classification, syndrome-derived C10, and singular order-10 balanced cut")
