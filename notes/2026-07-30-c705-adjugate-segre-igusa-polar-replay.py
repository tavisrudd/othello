#!/usr/bin/env python3
"""Independent finite-field replay of the C705 adjugate factorization."""

from itertools import combinations, product


PRIME = 101
GRID = range(9)
TRIPLES = tuple(combinations(range(6), 3))
Z_COEFFICIENTS = (
    (-1, -1, 1, 1, 1, -1, 1, 1, -1, -1, 1, 1, -1, -1, 1, -1, -1, -1, 1, 1),
    (1, 1, -1, -1, -1, -1, 1, 1, -1, 1, -1, 1, -1, -1, 1, 1, 1, 1, -1, -1),
    (1, -1, 1, -1, 1, -1, -1, -1, 1, 1, -1, -1, 1, 1, 1, -1, 1, -1, 1, -1),
    (-1, 1, -1, 1, 1, 1, -1, -1, -1, 1, -1, 1, 1, 1, -1, -1, -1, 1, -1, 1),
    (-1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1, -1, 1, -1, -1, 1, 1, -1, -1, 1),
    (1, -1, -1, 1, -1, 1, -1, 1, 1, -1, 1, -1, -1, 1, -1, 1, -1, 1, 1, -1),
)


def determinant(matrix):
    if not matrix:
        return 1
    total = 0
    for column, entry in enumerate(matrix[0]):
        minor = [
            row[:column] + row[column + 1 :]
            for row in matrix[1:]
        ]
        total += (-1) ** column * entry * determinant(minor)
    return total % PRIME


def evaluate(point):
    full = tuple(point) + ((-sum(point)) % PRIME,)
    z = []
    jacobian = [[0] * 6 for _ in range(5)]
    for shadow, coefficients in enumerate(Z_COEFFICIENTS):
        value = 0
        full_gradient = [0] * 6
        for coefficient, triple in zip(coefficients, TRIPLES):
            i, j, k = triple
            value += coefficient * full[i] * full[j] * full[k]
            full_gradient[i] += coefficient * full[j] * full[k]
            full_gradient[j] += coefficient * full[i] * full[k]
            full_gradient[k] += coefficient * full[i] * full[j]
        z.append(value % PRIME)
        for variable in range(5):
            jacobian[variable][shadow] = (
                full_gradient[variable] - full_gradient[5]
            ) % PRIME
    return full, z, jacobian


def verify_point(point):
    full, z, jacobian = evaluate(point)
    source_sum = sum(value * value for value in full) % PRIME
    q = [(6 * full[i] * full[i] - source_sum) % PRIME for i in range(5)]
    outer_sum = sum(value * value for value in z) % PRIME
    w = [(6 * value * value - outer_sum) % PRIME for value in z]

    assert all(sum(jacobian[row]) % PRIME == 0 for row in range(5))
    assert all(
        sum(jacobian[row][column] * q[row] for row in range(5)) % PRIME == 0
        for column in range(6)
    )
    assert all(
        sum(jacobian[row][column] * w[column] for column in range(6)) % PRIME == 0
        for row in range(5)
    )

    difference = [
        [
            (jacobian[row][column] - jacobian[row][5]) % PRIME
            for column in range(5)
        ]
        for row in range(5)
    ]
    for row in range(5):
        for column in range(5):
            minor = [
                [difference[i][j] for j in range(5) if j != row]
                for i in range(5)
                if i != column
            ]
            adjugate = (-1) ** (row + column) * determinant(minor)
            assert (adjugate - 6 * w[row] * q[column]) % PRIME == 0


def main():
    checked = 0
    for point in product(GRID, repeat=5):
        verify_point(point)
        checked += 1
    print(
        {
            "prime": PRIME,
            "grid": "0,...,8 in each of five variables",
            "points": checked,
            "degree_bound_per_variable": 8,
            "identity": "adj(A)=6*W*q^T",
            "status": "verified",
        }
    )


if __name__ == "__main__":
    main()
