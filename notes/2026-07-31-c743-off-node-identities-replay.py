#!/usr/bin/env python3
"""Dependency-free exact replay of the three C743 off-node identities."""

from itertools import combinations, permutations, product


def sign(permutation: tuple[int, ...]) -> int:
    inversions = sum(
        permutation[i] > permutation[j]
        for i in range(len(permutation))
        for j in range(i + 1, len(permutation))
    )
    return -1 if inversions % 2 else 1


def determinant(matrix: list[list[int]]) -> int:
    size = len(matrix)
    return sum(
        sign(permutation)
        * product_entries(matrix[i][permutation[i]] for i in range(size))
        for permutation in permutations(range(size))
    )


def product_entries(entries) -> int:
    answer = 1
    for entry in entries:
        answer *= entry
    return answer


def mul(left: tuple[int, tuple[int, ...]], right: tuple[int, tuple[int, ...]]):
    lv, lg = left
    rv, rg = right
    return lv * rv, tuple(lg[i] * rv + lv * rg[i] for i in range(5))


def sub(left: tuple[int, tuple[int, ...]], right: tuple[int, tuple[int, ...]]):
    return left[0] - right[0], tuple(
        left[1][i] - right[1][i] for i in range(5)
    )


def variable(values: tuple[int, ...], index: int):
    return values[index], tuple(int(index == i) for i in range(5))


def constant(value: int):
    return value, (0, 0, 0, 0, 0)


def matching_jacobian(values: tuple[int, ...]) -> list[list[int]]:
    x = [variable(values, i) for i in range(5)] + [constant(0)]
    brackets = lambda i, j: sub(x[i], x[j])
    matchings = (
        ((0, 1), (2, 3), (4, 5)),
        ((0, 1), (2, 5), (3, 4)),
        ((0, 3), (1, 2), (4, 5)),
        ((0, 5), (1, 2), (3, 4)),
        ((0, 5), (1, 4), (2, 3)),
    )
    gradients = []
    for matching in matchings:
        value = constant(1)
        for edge in matching:
            value = mul(value, brackets(*edge))
        gradients.append(value[1])
    return [[gradients[column][row] for column in range(5)] for row in range(5)]


ROW_SETS = tuple(combinations(range(5), 4))
COL_SETS = tuple(combinations(range(5), 4))


NEEDED = {5, 16, 17, 20, 21, 25}


def named_minors(values: tuple[int, ...]) -> dict[int, int]:
    jacobian = matching_jacobian(values)
    answer = {}
    index = 0
    # Singular lists column subsets first and row subsets second.
    for columns in COL_SETS:
        for rows in ROW_SETS:
            index += 1
            if index in NEEDED:
                answer[index] = determinant(
                    [[jacobian[i][j] for j in columns] for i in rows]
                )
    return answer


def check_point(a: int, b: int, c: int, d: int) -> None:
    m = named_minors((1, 1 + a, 1 + b, 1 + c, -1 + d))
    lhs = (
        3 * m[5]
        + m[16]
        + m[17]
        + m[21]
        + (4 * c - 4 * d + 8) * m[20]
        + (-4 * d + 4) * m[25]
    )
    rhs = -6 * (1 + c) * (d - 2) * (d - 1) * (d - c - 2) * (c + d - 1) * c * (a - b)
    if lhs != rhs:
        raise SystemExit(f"4+1+1 identity failed at {(a, b, c, d)}")

    m = named_minors((1, 1 + a, 1 + b, 1 + c, d))
    lhs = m[20] + m[25]
    rhs = (1 + c) * (d - a - 1) * (d - b - 1) * (a + b + c + d + 1) * c * (a - b)
    if lhs != rhs:
        raise SystemExit(f"4+2 identity failed at {(a, b, c, d)}")

    m = named_minors((1, 1 + a, 1 + b, 1 + c, 1 + d))
    lhs = (
        3 * m[5]
        + m[16]
        + m[17]
        + m[21]
        + (4 * c - 4 * d) * m[20]
        + (-4 * d - 4) * m[25]
    )
    rhs = 6 * (1 + c) * (1 + d) * (1 + c + d) * c * d * (a - b) * (c - d)
    if lhs != rhs:
        raise SystemExit(f"5+1 identity failed at {(a, b, c, d)}")


GRID = tuple(range(-2, 8))
for point in product(GRID, repeat=4):
    check_point(*point)

print(
    "independent off-node identity replay: OK "
    "grid=10^4 degree_bound_per_variable=9 charts=3"
)
