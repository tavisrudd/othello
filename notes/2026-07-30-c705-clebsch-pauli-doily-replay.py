#!/usr/bin/env python3
"""Independent direct-matrix replay of the C705 Pauli-doily sign comparison."""

from itertools import combinations, permutations
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


def rank(rows, width):
    work = list(rows)
    result = 0
    for column in range(width):
        pivot = next(
            (row for row in range(result, len(work)) if (work[row] >> column) & 1),
            None,
        )
        if pivot is None:
            continue
        work[result], work[pivot] = work[pivot], work[result]
        for row in range(len(work)):
            if row != result and ((work[row] >> column) & 1):
                work[row] ^= work[result]
        result += 1
    return result


lines = tuple(matchings())
points = tuple(combinations(range(6), 2))
point_index = {point: index for index, point in enumerate(points)}
line_index = {line: index for index, line in enumerate(lines)}
incidence_rows = [sum(1 << point_index[point] for point in line) for line in lines]
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

assert len(lines) == 15 and rank(incidence_rows, 15) == 10
assert sum(value < 0 for value in pauli_sign.values()) == 3
assert sum(value < 0 for value in clebsch_sign.values()) == 12

grid_rows = []
for triple in combinations(range(6), 3):
    if 0 not in triple:
        continue
    left = set(triple)
    grid = tuple(
        line for line in lines if all((i in left) != (j in left) for i, j in line)
    )
    assert len(grid) == 6
    grid_rows.append(sum(1 << line_index[line] for line in grid))
    assert prod(pauli_sign[line] for line in grid) == -1
    assert prod(clebsch_sign[line] for line in grid) == -1
    assert prod(pfaffian_sign[line] for line in grid) == -1

assert len(grid_rows) == 10 and rank(grid_rows, 15) == 5
assert all(
    not sum(
        ((grid_row >> line) & 1) * ((incidence_rows[line] >> point) & 1)
        for line in range(15)
    )
    % 2
    for grid_row in grid_rows
    for point in range(15)
)
parity_generators = [
    sum(((grid_rows[grid] >> line) & 1) << grid for grid in range(10))
    for line in range(15)
]
parity_code = {0}
for generator in parity_generators:
    parity_code |= {word ^ generator for word in tuple(parity_code)}
weight_enumerator = {
    weight: sum(word.bit_count() == weight for word in parity_code)
    for weight in range(11)
    if any(word.bit_count() == weight for word in parity_code)
}
assert weight_enumerator == {0: 1, 4: 15, 6: 15, 10: 1}
weight_four = {word for word in parity_code if word.bit_count() == 4}
assert weight_four == set(parity_generators)
assert all(
    sum(((word >> left) & 1) and ((word >> right) & 1) for word in weight_four) == 2
    for left, right in combinations(range(10), 2)
)
dual_code = {
    word
    for word in range(1 << 10)
    if all((word & codeword).bit_count() % 2 == 0 for codeword in parity_code)
}
assert dual_code != parity_code
assert {
    weight: sum(word.bit_count() == weight for word in dual_code)
    for weight in range(11)
    if any(word.bit_count() == weight for word in dual_code)
} == weight_enumerator
dual_weight_four = {word for word in dual_code if word.bit_count() == 4}


def permute_word(word, permutation):
    return sum(((word >> index) & 1) << permutation[index] for index in range(10))


automorphisms = 0
isodual_maps = 0
for permutation in permutations(range(10)):
    is_automorphism = True
    is_isodual = True
    for word in weight_four:
        image = permute_word(word, permutation)
        is_automorphism &= image in weight_four
        is_isodual &= image in dual_weight_four
        if not is_automorphism and not is_isodual:
            break
    automorphisms += is_automorphism
    isodual_maps += is_isodual
assert automorphisms == isodual_maps == 720

assert all(
    clebsch_sign[line] == pfaffian_sign[line] * prod(C[i][j] for i, j in line)
    for line in lines
)

print(
    "PASS independent 4x4 Pauli replay: all 10 grid parities are -1; "
    "their [10,5,4] quotient is S6-symmetric and isodual"
)
