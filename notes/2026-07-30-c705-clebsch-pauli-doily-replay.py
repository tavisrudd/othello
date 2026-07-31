#!/usr/bin/env python3
"""Independent direct-matrix replay of the C705 Pauli-doily sign comparison."""

from collections import Counter
from itertools import combinations, permutations
from math import lcm, prod


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
all_weight_four = weight_four | dual_weight_four
assert len(all_weight_four) == 30
assert all(
    sum(all((word >> point) & 1 for point in triple) for word in all_weight_four) == 1
    for triple in combinations(range(10), 3)
)
assert parity_code & dual_code == {0, (1 << 10) - 1}
assert {left ^ right for left in parity_code for right in dual_code} == {
    word for word in range(1 << 10) if word.bit_count() % 2 == 0
}


def permute_word(word, permutation):
    return sum(((word >> index) & 1) << permutation[index] for index in range(10))


def cycle_type(permutation):
    seen = set()
    lengths = []
    for start in range(10):
        if start in seen:
            continue
        point = start
        length = 0
        while point not in seen:
            seen.add(point)
            length += 1
            point = permutation[point]
        lengths.append(length)
    return tuple(sorted(lengths, reverse=True))


automorphisms = 0
isodual_maps = 0
witt_automorphisms = 0
isodual_cycle_types = Counter()
automorphism_permutations = []
involutory_isodualities = []
for permutation in permutations(range(10)):
    is_automorphism = True
    is_isodual = True
    for word in weight_four:
        image = permute_word(word, permutation)
        is_automorphism &= image in weight_four
        is_isodual &= image in dual_weight_four
        if not is_automorphism and not is_isodual:
            break
    is_witt_automorphism = is_automorphism or is_isodual
    if not is_witt_automorphism:
        is_witt_automorphism = all(
            permute_word(word, permutation) in all_weight_four
            for word in all_weight_four
        )
    automorphisms += is_automorphism
    isodual_maps += is_isodual
    witt_automorphisms += is_witt_automorphism
    if is_automorphism:
        automorphism_permutations.append(permutation)
    if is_isodual:
        kind = cycle_type(permutation)
        isodual_cycle_types[kind] += 1
        if kind == (2, 2, 2, 2, 2):
            involutory_isodualities.append(permutation)
assert automorphisms == isodual_maps == 720
assert witt_automorphisms == 1440
assert isodual_cycle_types == {
    (2, 2, 2, 2, 2): 36,
    (4, 4, 1, 1): 180,
    (8, 1, 1): 180,
    (8, 2): 180,
    (10,): 144,
}
assert Counter(
    lcm(*kind)
    for kind, multiplicity in isodual_cycle_types.items()
    for _ in range(multiplicity)
) == {2: 36, 4: 180, 8: 360, 10: 144}


def compose(left, right):
    return tuple(left[right[index]] for index in range(10))


def inverse(permutation):
    result = [0] * 10
    for source, target in enumerate(permutation):
        result[target] = source
    return tuple(result)


polarity = involutory_isodualities[0]
assert {
    compose(compose(automorphism, polarity), inverse(automorphism))
    for automorphism in automorphism_permutations
} == set(involutory_isodualities)

r10_checks = (
    0b0000110011,
    0b0001000111,
    0b0010001110,
    0b0100011100,
    0b1000011001,
)
r10 = {
    word
    for word in range(1 << 10)
    if all((word & check).bit_count() % 2 == 0 for check in r10_checks)
}
r10_weight_four = {word for word in r10 if word.bit_count() == 4}
r10_equivalence = next(
    permutation
    for permutation in permutations(range(10))
    if all(permute_word(word, permutation) in r10_weight_four for word in weight_four)
)
assert r10_equivalence == (0, 1, 2, 6, 4, 9, 3, 7, 8, 5)

assert all(
    clebsch_sign[line] == pfaffian_sign[line] * prod(C[i][j] for i, j in line)
    for line in lines
)

print(
    "PASS independent 4x4 Pauli replay: all 10 grid parities are -1; "
    "their R10 quotient and dual halve W10 with 36 involutory polarities"
)
