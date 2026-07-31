#!/usr/bin/env python3
"""Independent direct-matrix replay of the C705 Pauli-doily sign comparison."""

from itertools import combinations
from math import prod


C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)
I2 = ((1, 0), (0, 1))
X = ((0, 1), (1, 0))
Z = ((1, 0), (0, -1))
Y = ((0, -1j), (1j, 0))
ODD = tuple(
    (a, b) for a in range(4) for b in range(4) if (a & b).bit_count() % 2
)


def matmul(left, right):
    return tuple(
        tuple(sum(left[i][k] * right[k][j] for k in range(len(right))) for j in range(len(right[0])))
        for i in range(len(left))
    )


def kron(left, right):
    return tuple(
        tuple(left[i][j] * right[k][ell] for j in range(len(left[0])) for ell in range(len(right[0])))
        for i in range(len(left))
        for k in range(len(right))
    )


def pauli(i, j):
    a_i, b_i = ODD[i]
    a_j, b_j = ODD[j]
    x, z = b_i ^ b_j, a_i ^ a_j
    factors = []
    for bit in range(2):
        factors.append({(0, 0): I2, (1, 0): X, (0, 1): Z, (1, 1): Y}[((x >> bit) & 1, (z >> bit) & 1)])
    return kron(*factors)


def matchings(vertices=tuple(range(6))):
    if not vertices:
        yield ()
        return
    first = vertices[0]
    for second in vertices[1:]:
        for tail in matchings(tuple(v for v in vertices[1:] if v != second)):
            yield ((first, second),) + tail


def permutation_sign(word):
    return (-1) ** sum(word[i] > word[j] for i in range(6) for j in range(i + 1, 6))


def scalar(matrix):
    value = matrix[0][0]
    assert all(
        matrix[i][j] == (value if i == j else 0)
        for i in range(4)
        for j in range(4)
    )
    return value


lines = tuple(matchings())
pauli_sign = {}
clebsch_sign = {}
pfaffian_sign = {}
for line in lines:
    matrix = tuple(tuple(int(i == j) for j in range(4)) for i in range(4))
    for edge in line:
        matrix = matmul(matrix, pauli(*edge))
    pauli_sign[line] = int(scalar(matrix).real)
    word = tuple(vertex for edge in line for vertex in edge)
    pfaffian_sign[line] = permutation_sign(word)
    clebsch_sign[line] = pfaffian_sign[line] * prod(C[i][j] for i, j in line)

assert len(lines) == 15
assert sum(value < 0 for value in pauli_sign.values()) == 3
assert sum(value < 0 for value in clebsch_sign.values()) == 12

for triple in combinations(range(6), 3):
    if 0 not in triple:
        continue
    left = set(triple)
    grid = tuple(
        line for line in lines if all((i in left) != (j in left) for i, j in line)
    )
    assert len(grid) == 6
    assert prod(pauli_sign[line] for line in grid) == -1
    assert prod(clebsch_sign[line] for line in grid) == -1
    assert prod(pfaffian_sign[line] for line in grid) == -1

assert all(
    clebsch_sign[line] == pfaffian_sign[line] * prod(C[i][j] for i, j in line)
    for line in lines
)

print(
    "PASS independent 4x4 Pauli replay: all 10 grid parities are -1; "
    "the conference contribution is point rephasing"
)
