#!/usr/bin/env python3
"""Independent replay of common-duality q=11 group, fusion, and signed Fourier claims."""

from __future__ import annotations

import itertools
import json
from collections import deque
from pathlib import Path

Q = 11
I = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
J = ((1, 0, 0), (0, 0, 10), (0, 10, 0))
CERT = Path(__file__).with_name("common_duality.json")


def inv(x):
    return pow(x % Q, Q - 2, Q)


def dot(x, y):
    return sum(a * b for a, b in zip(x, y)) % Q


def mv(a, x):
    return tuple(dot(row, x) for row in a)


def mm(a, b):
    return tuple(tuple(sum(a[i][k] * b[k][j] for k in range(3)) % Q for j in range(3)) for i in range(3))


def normv(x):
    pivot = next(a for a in x if a % Q)
    scale = inv(pivot)
    return tuple(a * scale % Q for a in x)


def normm(a):
    pivot = next(x for row in a for x in row if x % Q)
    scale = inv(pivot)
    return tuple(tuple(x * scale % Q for x in row) for row in a)


def roots(tau):
    answer = {(1, 0, 0), (0, 1, 0), (0, 0, 1)}
    for s, t in itertools.product((1, -1), repeat=2):
        x = (1, s * tau % Q, t * (tau - 1) % Q)
        answer |= {normv(x[k:] + x[:k]) for k in range(3)}
    assert len(answer) == 15
    return answer


def reflection(x):
    factor = 2 * inv(dot(x, x)) % Q
    return tuple(tuple((int(i == j) - factor * x[i] * x[j]) % Q for j in range(3)) for i in range(3))


def closure(generators):
    answer = {I}
    queue = deque([I])
    while queue:
        left = queue.popleft()
        for right in generators:
            child = normm(mm(left, right))
            if child not in answer:
                answer.add(child)
                queue.append(child)
    return answer


def a5(tau):
    return closure([normm(reflection(x)) for x in sorted(roots(tau))])


def linear(group):
    return {tuple(tuple(s * x % Q for x in row) for row in a) for a in group for s in range(1, Q)}


def orbits(group):
    unseen = set(itertools.product(range(Q), repeat=3))
    answer = []
    while unseen:
        x = min(unseen)
        orbit = {mv(a, x) for a in group}
        unseen -= orbit
        answer.append(orbit)
    return answer


def fourier(classes):
    matrix = []
    for left in classes:
        y = min(left)
        row = []
        for right in classes:
            if right == {(0, 0, 0)}:
                row.append(1)
            else:
                lines = {normv(x) for x in right}
                row.append(Q * sum(dot(y, x) == 0 for x in lines) - len(lines))
        matrix.append(row)
    return matrix


def main():
    plus = a5(8)
    minus = a5(4)
    assert len(plus) == len(minus) == 60
    assert {normm(mm(mm(J, g), J)) for g in plus} == minus
    golden = closure(list(plus) + [J])
    assert len(golden) == 1320

    conic = {normv(x) for x in itertools.product(range(Q), repeat=3) if x != (0, 0, 0) and dot(x, x) == 0}
    assert len(conic) == 12
    assert all({normv(mv(g, x)) for x in conic} == conic for g in golden)
    assert sorted(map(len, orbits(linear(golden)))) == [1, 120, 550, 660]

    common_group = plus & minus
    assert len(common_group) == 12
    common = orbits(linear(common_group))
    common.sort(key=lambda cell: (len(cell), min(cell)))
    # Reorder by the representatives pinned in the primary certificate.
    cert = json.loads(CERT.read_text())
    representatives = [tuple(item["representative"]) for item in cert["common_relation_metadata"]]
    common = [next(cell for cell in common if representative in cell) for representative in representatives]
    assert [len(cell) for cell in common] == cert["common_refinement_valencies"]

    permutation = []
    for cell in common:
        image = {mv(J, x) for x in cell}
        permutation.append(next(i for i, target in enumerate(common) if image == target))
    assert permutation == cert["J_relation_permutation"]
    pairs = [(i, j) for i, j in enumerate(permutation) if i < j]
    assert pairs == [(1, 10), (3, 13), (6, 14), (9, 11)]

    p = fourier(common)
    assert p == cert["common_refinement_first_eigenmatrix"]
    assert all(sum(p[i][k] * p[k][j] for k in range(16)) == Q ** 3 * (i == j) for i in range(16) for j in range(16))
    odd = [[p[row][a] - p[row][b] for a, b in pairs] for row, _ in pairs]
    assert odd == [[-11, 0, 44, -22], [0, -11, 22, 44], [22, 11, 11, 0], [-11, 22, 0, 11]]
    assert all(sum(odd[i][k] * odd[k][j] for k in range(4)) == Q ** 3 * (i == j) for i in range(4) for j in range(4))
    print("independent replay: order 1320; fusion 1+120+550+660; rank 16; odd Fourier square 1331 I4")


if __name__ == "__main__":
    main()
