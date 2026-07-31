#!/usr/bin/env python3
"""Independent compact replay of the load-bearing C709 identities."""

from __future__ import annotations

import itertools

C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)
ODD = ((1, 1), (1, 3), (2, 2), (2, 3), (3, 1), (3, 2))


def dot(left: int, right: int) -> int:
    return (left & right).bit_count() % 2


def vector(i: int, j: int) -> int:
    a, b = ODD[i]
    c, d = ODD[j]
    return (b ^ d) | ((a ^ c) << 2)


def symplectic(u: int, v: int) -> int:
    return dot(u & 3, v >> 2) ^ dot(u >> 2, v & 3)


def pfaffian(a, indices):
    if not indices:
        return 1
    return sum(
        (-1) ** (position + 1)
        * a[indices[0]][j]
        * pfaffian(a, indices[1:position] + indices[position + 1 :])
        for position, j in enumerate(indices[1:], 1)
    )


duads = tuple(itertools.combinations(range(6), 2))
assert {vector(*edge) for edge in duads} == set(range(1, 16))
assert all(
    symplectic(vector(*left), vector(*right))
    == (len(set(left) & set(right)) == 1)
    for left in duads
    for right in duads
    if left != right
)

bits = [0] * 16
for i, j in duads:
    bits[vector(i, j)] = C[i][j] < 0
distances = []
for shift in range(16):
    q = [
        dot(v & 3, v >> 2) ^ symplectic(shift, v) for v in range(16)
    ]
    distances.append(sum(a != b for a, b in zip(bits, q)))
assert sorted(distances) == [5] * 6 + [9] * 10

for x in itertools.product((-2, -1, 0, 1, 2), repeat=6):
    a = [
        [(x[i] - x[j]) * C[i][j] for j in range(6)] for i in range(6)
    ]
    pf = pfaffian(a, tuple(range(6)))
    z = sum(
        C[i][j] * C[j][k] * C[k][i] * x[i] * x[j] * x[k]
        for i, j, k in itertools.combinations(range(6), 3)
    )
    assert pf == 4 * z
    for i in range(6):
        for j in range(6):
            ca = sum(C[i][k] * a[k][j] for k in range(6))
            ac = sum(a[i][k] * C[k][j] for k in range(6))
            assert ca + ac == 0

print("ok: 15,625 direct Pfaffian/anticommutator evaluations; 16 q refinements")
