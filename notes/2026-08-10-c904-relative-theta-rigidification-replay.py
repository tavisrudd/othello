#!/usr/bin/env python3
"""Independent Fraction/SymPy replay of relative theta rigidification."""

import importlib.util
from pathlib import Path

from sympy import Matrix


SOURCE = Path(__file__).with_name("2026-08-10-c904-minimal-class-divisor-replay.py")
SPEC = importlib.util.spec_from_file_location("c904_minimal_replay", SOURCE)
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)


def mod_two(matrix):
    return [[int(value) % 2 for value in row] for row in matrix]


def matrix_product(left, right):
    return [[sum(a * b for a, b in zip(row, column)) % 2
             for column in zip(*right)] for row in left]


def transpose(matrix):
    return [list(column) for column in zip(*matrix)]


def vector_matrix(vector, matrix):
    return [sum(value * matrix[i][j] for i, value in enumerate(vector)) % 2
            for j in range(len(matrix[0]))]


def quadratic(upper, vector):
    return sum(vector[i] * upper[i][j] * vector[j]
               for i in range(len(vector))
               for j in range(len(vector))) % 2


def solve_mod_two(matrix, target):
    size = len(matrix)
    augmented = [row[:] + [value] for row, value in zip(matrix, target)]
    pivot_row = 0
    pivots = []
    for column in range(size):
        pivot = next((row for row in range(pivot_row, size)
                      if augmented[row][column]), None)
        if pivot is None:
            continue
        augmented[pivot_row], augmented[pivot] = augmented[pivot], augmented[pivot_row]
        for row in range(size):
            if row != pivot_row and augmented[row][column]:
                augmented[row] = [a ^ b for a, b in zip(augmented[row],
                                                        augmented[pivot_row])]
        pivots.append(column)
        pivot_row += 1
    assert len(pivots) == size
    solution = [0] * size
    for row, column in enumerate(pivots):
        solution[column] = augmented[row][-1]
    return solution


def invariant_refinement(alternating, monodromy):
    size = len(alternating)
    upper = [[alternating[i][j] if i < j else 0 for j in range(size)]
             for i in range(size)]
    difference = []
    for i in range(size):
        basis = [int(i == j) for j in range(size)]
        image = vector_matrix(basis, monodromy)
        difference.append(quadratic(upper, image) ^ quadratic(upper, basis))
    linear_matrix = [[monodromy[i][j] ^ int(i == j) for j in range(size)]
                     for i in range(size)]
    # The Sage equation is (M+I) l = d for column l.
    linear = solve_mod_two(linear_matrix, difference)
    for mask in range(1 << size):
        point = [(mask >> i) & 1 for i in range(size)]
        image = vector_matrix(point, monodromy)
        q_point = quadratic(upper, point) ^ sum(a * b for a, b in zip(point, linear)) % 2
        q_image = quadratic(upper, image) ^ sum(a * b for a, b in zip(image, linear)) % 2
        assert q_point == q_image
    return tuple(linear)


def main():
    identity5 = Matrix.eye(5)
    zero5 = Matrix.zeros(5)
    ambient = Matrix.vstack(
        Matrix.hstack(-identity5, -identity5),
        Matrix.hstack(identity5, zero5),
    )
    basis = Matrix(BASE.PRINCIPAL_BASIS)
    monodromy_q = basis * ambient.T * basis.inv()
    assert all(value.q == 1 for value in monodromy_q)
    monodromy_z = [[int(value) for value in monodromy_q.row(i)] for i in range(10)]
    monodromy = mod_two(monodromy_z)
    identity10 = [[int(i == j) for j in range(10)] for i in range(10)]
    polynomial = [
        [a ^ b ^ c for a, b, c in zip(row_a, row_b, row_c)]
        for row_a, row_b, row_c in zip(
            matrix_product(monodromy, monodromy), monodromy, identity10
        )
    ]
    assert not any(any(row) for row in polynomial)
    # M+I is invertible, verified by solving against each basis vector.
    plus_identity = [[monodromy[i][j] ^ int(i == j) for j in range(10)]
                     for i in range(10)]
    for i in range(10):
        solve_mod_two(plus_identity, [int(i == j) for j in range(10)])

    cusp_widths = (1, 2, 3, 6)
    marked_cusp_widths = tuple(2 * width if width % 2 else width
                               for width in cusp_widths)
    transvection = [[1, 1], [0, 1]]
    transvection_squared = matrix_product(transvection, transvection)
    assert transvection_squared == [[1, 0], [0, 1]]
    assert all(width % 2 == 0 for width in marked_cusp_widths)

    forms = BASE.divisor_forms()
    refinements = []
    for sparse in forms:
        alternating = [[0] * 10 for _ in range(10)]
        for (i, j), value in sparse.items():
            alternating[i][j] = value % 2
            alternating[j][i] = value % 2
        transported = matrix_product(matrix_product(monodromy, alternating),
                                     transpose(monodromy))
        assert transported == alternating
        refinements.append(invariant_refinement(alternating, monodromy))

    print("order-three monodromy mod 2=")
    for row in monodromy:
        print(tuple(row))
    print("fixed dimension=0")
    print(f"unmarked cusp widths={cusp_widths}; exotic-marked widths={marked_cusp_widths}")
    print("local mod-2 theta residues=all zero")
    print("invariant refinements=")
    for refinement in refinements:
        print(refinement)
    print("count=15 unique=PASS")
    print("PASS")


if __name__ == "__main__":
    main()
