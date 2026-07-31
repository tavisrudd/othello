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
    fingerprints.add(tuple(fingerprint))

assert len(fingerprints) == 6
print("ok: 12 normalized C5 signings, ten 5:1 cuts each, six complement-paired fingerprints")
