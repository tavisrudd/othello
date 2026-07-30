#!/usr/bin/env python3
"""Independent finite-field replay for the C704 Segre--Igusa bridge."""

import math
from itertools import combinations, permutations, product


P = 101
TRIPLES = tuple(combinations(range(6), 3))
C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)
TOTAL = (
    ((0, 1), (2, 3), (4, 5)),
    ((0, 2), (1, 4), (3, 5)),
    ((0, 3), (1, 5), (2, 4)),
    ((0, 4), (1, 3), (2, 5)),
    ((0, 5), (1, 2), (3, 4)),
)


def sign(p):
    return -1 if sum(p[i] > p[j] for i in range(6) for j in range(i + 1, 6)) % 2 else 1


def canonical_total(total):
    return tuple(sorted(tuple(sorted(matching)) for matching in total))


def permuted_total(p):
    return canonical_total(
        tuple(
            tuple(sorted(tuple(sorted((p[i], p[j]))) for i, j in matching))
            for matching in TOTAL
        )
    )


BASE = tuple(C[i][j] * C[j][k] * C[k][i] for i, j, k in TRIPLES)


def permuted_cubic(p):
    coefficients = {}
    for coefficient, support in zip(BASE, TRIPLES):
        coefficients[tuple(sorted(p[i] for i in support))] = sign(p) * coefficient
    return tuple(coefficients[support] for support in TRIPLES)


ORIENTED = {}
for permutation in permutations(range(6)):
    key = permuted_total(permutation)
    value = permuted_cubic(permutation)
    assert key not in ORIENTED or ORIENTED[key] == value
    ORIENTED[key] = value
assert len(ORIENTED) == 6
TOTALS = sorted(ORIENTED)
Z = [ORIENTED[total] for total in TOTALS]


def cubic_value(coefficients, x):
    return sum(
        coefficient * x[i] * x[j] * x[k]
        for coefficient, (i, j, k) in zip(coefficients, TRIPLES)
    ) % P


def clebsch_value(total, x):
    quadratics = [
        sum(x[i] * x[j] for i, j in matching) % P for matching in total
    ]
    common = sum(quadratics) % P
    centered = [(5 * value - common) % P for value in quadratics]
    return sum(value**3 for value in centered) * pow(3, -1, P) % P


def pfaffian(matrix, indices=tuple(range(6))):
    if not indices:
        return 1
    first = indices[0]
    return sum(
        (-1) ** (position + 1)
        * matrix[first][second]
        * pfaffian(matrix, indices[1:position] + indices[position + 1 :])
        for position, second in enumerate(indices[1:], 1)
    )


def rank_mod(matrix, prime):
    work = [[value % prime for value in row] for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next((i for i in range(row, len(work)) if work[i][column]), None)
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, prime)
        work[row] = [value * inverse % prime for value in work[row]]
        for i in range(len(work)):
            if i != row and work[i][column]:
                scalar = work[i][column]
                work[i] = [
                    (work[i][j] - scalar * work[row][j]) % prime
                    for j in range(len(work[0]))
                ]
        row += 1
    return row


def derivative(poly, dx, dy):
    output = {}
    for (x_degree, y_degree), coefficient in poly.items():
        if x_degree >= dx and y_degree >= dy:
            factor = math.prod(range(x_degree - dx + 1, x_degree + 1))
            factor *= math.prod(range(y_degree - dy + 1, y_degree + 1))
            output[x_degree - dx, y_degree - dy] = coefficient * factor
    return output


def transvectant(source_degree, form, order):
    target_degree = source_degree + sum(next(iter(form))) - 2 * order
    matrix = []
    for source_y_degree in range(source_degree + 1):
        source = {(source_degree - source_y_degree, source_y_degree): 1}
        output = {}
        for step in range(order + 1):
            left = derivative(source, order - step, step)
            right = derivative(form, step, order - step)
            scalar = (-1) ** step * math.comb(order, step)
            for (lx, ly), lc in left.items():
                for (rx, ry), rc in right.items():
                    exponent = lx + rx, ly + ry
                    output[exponent] = output.get(exponent, 0) + scalar * lc * rc
        matrix.append(
            [
                output.get((target_degree - target_y_degree, target_y_degree), 0)
                for target_y_degree in range(target_degree + 1)
            ]
        )
    return matrix


# Sister feasibility in different arithmetic: sqrt(-3)=6 modulo 13.
tetrahedral_a = 12
tetrahedral_matrix = [
    [12 * tetrahedral_a, 0, 72, 0],
    [0, -12 * tetrahedral_a, 0, 24],
    [24, 0, -12 * tetrahedral_a, 0],
    [0, 72, 0, 12 * tetrahedral_a],
]
assert rank_mod(tetrahedral_matrix, 13) == 2
octavic = {(8, 0): 1, (4, 4): 14, (0, 8): 1}
assert [rank_mod(transvectant(7, octavic, order), 101) for order in (1, 2, 3)] == [
    8,
    8,
    6,
]


checked = 0
for leading in product(range(7), repeat=5):
    x = leading + ((-sum(leading)) % P,)
    z = [cubic_value(cubic, x) for cubic in Z]
    sigma = [clebsch_value(total, x) for total in TOTALS]
    skew = [[0] * 6 for _ in range(6)]
    for i, j in combinations(range(6), 2):
        skew[i][j] = C[i][j] * (x[i] - x[j]) % P
        skew[j][i] = -skew[i][j] % P
    assert (pfaffian(skew) - 4 * cubic_value(BASE, x)) % P == 0
    assert sum(z) % P == 0
    assert sum(value**3 for value in z) % P == 0
    z2_sum = sum(value**2 for value in z) % P
    sigma_sum = sum(sigma) % P
    w = [(value**2 - z2_sum * pow(6, -1, P)) % P for value in z]
    assert sum(w) % P == 0
    assert (sum(value**2 for value in w) ** 2 - 4 * sum(value**4 for value in w)) % P == 0
    assert all(
        (
            125 * (z[index] ** 2 - z2_sum * pow(6, -1, P))
            - 4 * (sigma[index] - sigma_sum * pow(6, -1, P))
        )
        % P
        == 0
        for index in range(6)
    )
    checked += 1

print(
    "independent replay passed:"
    f" prime={P}, interpolation_grid=7^5, points={checked}, shadows={len(Z)}"
)
