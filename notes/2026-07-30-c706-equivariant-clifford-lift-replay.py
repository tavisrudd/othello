#!/usr/bin/env python3
"""Independent compact replay of the C706 obstruction and golden class."""

from itertools import combinations


# Five equations extracted independently from the S6 Coxeter lift system.
# Their left sides XOR to zero while their right sides XOR to one.
ROWS = (2, 256, 196608, 257, 196611)
RHS = (1, 1, 1, 1, 1)
assert ROWS[0] ^ ROWS[1] ^ ROWS[2] ^ ROWS[3] ^ ROWS[4] == 0
assert sum(RHS) % 2 == 1

C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)
ODD = tuple(
    (a, b)
    for a in range(4)
    for b in range(4)
    if (a & b).bit_count() % 2
)


def duad_vector(left, right):
    a, b = ODD[left]
    c, d = ODD[right]
    return (b ^ d) | ((a ^ c) << 2)


VECTOR_TO_DUAD = {
    duad_vector(left, right): (left, right)
    for left, right in combinations(range(6), 2)
}


def compose(left, right):
    return tuple(left[right[index]] for index in range(6))


def generated_group(generators):
    identity = tuple(range(6))
    seen = {identity}
    frontier = [identity]
    while frontier:
        element = frontier.pop()
        for generator in generators:
            target = compose(generator, element)
            if target not in seen:
                seen.add(target)
                frontier.append(target)
    return seen


def vector_map(permutation):
    result = {0: 0}
    for left, right in combinations(range(6), 2):
        target = tuple(sorted((permutation[left], permutation[right])))
        result[duad_vector(left, right)] = duad_vector(*target)
    return tuple(result[vector] for vector in range(16))


def conference_bit(vector):
    if not vector:
        return 0
    left, right = VECTOR_TO_DUAD[vector]
    return int(C[left][right] < 0)


def is_linear(values):
    return all(
        values[left ^ right] == values[left] ^ values[right]
        for left in range(16)
        for right in range(16)
    )


A = (0, 2, 4, 1, 5, 3)
B = (1, 0, 3, 2, 4, 5)
assert len(generated_group((A, B))) == 60
conference = tuple(conference_bit(vector) for vector in range(16))
for permutation in (A, B):
    action = vector_map(permutation)
    difference = tuple(
        conference[vector] ^ conference[action[vector]]
        for vector in range(16)
    )
    assert is_linear(difference)

# The conference cochain is not affine-linear. Since this A5 is transitive
# on the fifteen nonzero vectors, its resulting H1 class cannot be a
# coboundary.
assert all(
    any(
        conference[vector]
        != (
            constant
            ^ sum(
                ((linear >> bit) & 1) * ((vector >> bit) & 1)
                for bit in range(4)
            )
            % 2
        )
        for vector in range(1, 16)
    )
    for constant in range(2)
    for linear in range(16)
)


def gaussian_add(left, right):
    return left[0] + right[0], left[1] + right[1]


def gaussian_multiply(left, right):
    return (
        left[0] * right[0] - left[1] * right[1],
        left[0] * right[1] + left[1] * right[0],
    )


def matrix_multiply(left, right):
    return tuple(
        tuple(
            gaussian_add(
                gaussian_add(
                    gaussian_multiply(left[row][0], right[0][column]),
                    gaussian_multiply(left[row][1], right[1][column]),
                ),
                gaussian_add(
                    gaussian_multiply(left[row][2], right[2][column]),
                    gaussian_multiply(left[row][3], right[3][column]),
                ),
            )
            for column in range(4)
        )
        for row in range(4)
    )


def power(matrix, exponent):
    result = tuple(
        tuple((1, 0) if row == column else (0, 0) for column in range(4))
        for row in range(4)
    )
    for _ in range(exponent):
        result = matrix_multiply(matrix, result)
    return result


def scalar(matrix, value, denominator):
    return all(
        matrix[row][column]
        == (
            (value[0] * denominator, value[1] * denominator)
            if row == column
            else (0, 0)
        )
        for row in range(4)
        for column in range(4)
    )


UA = (
    ((0, -1), (-1, 0), (-1, 0), (0, 1)),
    ((0, -1), (-1, 0), (1, 0), (0, -1)),
    ((-1, 0), (0, -1), (0, -1), (1, 0)),
    ((1, 0), (0, 1), (0, -1), (1, 0)),
)
UB = (
    ((1, 0), (0, -1), (0, -1), (-1, 0)),
    ((0, 1), (-1, 0), (1, 0), (0, 1)),
    ((0, 1), (1, 0), (-1, 0), (0, 1)),
    ((-1, 0), (0, -1), (0, -1), (1, 0)),
)
assert scalar(power(UA, 5), (0, 1), 2**5)
assert scalar(power(UB, 2), (1, 0), 2**2)
assert scalar(power(matrix_multiply(UA, UB), 3), (0, 1), 4**3)

print("C706 independent replay: nonsplit S6, nonzero golden H1, scalar-trivial A5")
