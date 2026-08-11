#!/usr/bin/env python3
"""Independent Fraction/SymPy replay of the C904 elliptic-support obstruction."""

from fractions import Fraction
from functools import reduce
from itertools import product
from math import gcd, prod

from sympy import Matrix, Rational
from sympy.matrices.normalforms import smith_normal_form
from sympy.polys.domains import ZZ


def parse_matrix(text):
    return Matrix([[Rational(token) for token in line.split()]
                   for line in text.strip().splitlines()])


BASIS = parse_matrix(r"""
1/6 0 0 0 5/6 2/3 1/2 0 1/2 1/3
0 1/6 0 0 5/6 0 1/6 1/2 1/2 5/6
0 0 1/6 0 5/6 1/2 1/2 1/6 0 5/6
0 0 0 1/6 5/6 1/2 0 1/2 2/3 1/3
0 0 0 0 1 0 0 0 0 0
0 0 0 0 0 1 0 0 0 0
0 0 0 0 0 0 1 0 0 0
0 0 0 0 0 0 0 1 0 0
0 0 0 0 0 0 0 0 1 0
0 0 0 0 0 0 0 0 0 1
""")

SYMPLECTIC = parse_matrix(r"""
0 2 3 0 0 0 -1 -1 -1 4
-2 0 0 -3 -3 -1 0 -1 -1 4
-3 0 0 -2 -3 -1 -1 0 -1 4
0 3 2 0 0 -1 -1 -1 0 4
0 3 3 0 0 -1 -1 -1 -1 5
0 1 1 1 1 0 0 0 0 0
1 0 1 1 1 0 0 0 0 0
1 1 0 1 1 0 0 0 0 0
1 1 1 0 1 0 0 0 0 0
-4 -4 -4 -4 -5 0 0 0 0 0
""")

GRAM = 6 * Matrix.eye(5) - Matrix.ones(5)
OMEGA = Matrix([
    [0, 1, 0, 1],
    [0, 1, 1, 1],
    [1, 1, 1, 0],
    [1, 0, 1, 0],
])


def rank_mod_two(matrix):
    rows = [[int(value) % 2 for value in row] for row in matrix.tolist()]
    rank = 0
    for column in range(len(rows[0])):
        pivot = next((index for index in range(rank, len(rows))
                      if rows[index][column]), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        for index in range(len(rows)):
            if index != rank and rows[index][column]:
                rows[index] = [left ^ right
                               for left, right in zip(rows[index], rows[rank])]
        rank += 1
    return rank


def primitive_lines(bound):
    for entries in product(range(-bound, bound + 1), repeat=5):
        if not any(entries):
            continue
        if reduce(gcd, (abs(value) for value in entries)) != 1:
            continue
        if next(value for value in entries if value) < 0:
            continue
        yield entries


def upper_vector(matrix):
    return [int(matrix[i, j]) for i in range(10) for j in range(i + 1, 10)]


def source_curve(vector, denominator):
    result = Matrix.zeros(10)
    for i in range(5):
        for j in range(5):
            value = Rational(vector[i] * vector[j], denominator)
            result[i, 5 + j] = value
            result[5 + j, i] = -value
    return result


def primitive_curve(vector):
    """Choose the largest possible plane-area denominator (at most 2*3)."""
    inverse = BASIS.inv()
    for denominator in (6, 3, 2, 1):
        principal = inverse.T * source_curve(vector, denominator) * inverse
        if all(value.q == 1 for value in principal):
            degree = (Matrix(1, 5, vector) * GRAM * Matrix(5, 1, vector))[0]
            assert degree % denominator == 0
            return upper_vector(principal), int(degree // denominator), denominator
    raise AssertionError("source lattice itself must give an integral curve")


def smith_index(matrix):
    smith = smith_normal_form(matrix, domain=ZZ)
    diagonal = [abs(int(smith[i, i])) for i in range(min(matrix.shape))
                if smith[i, i]]
    assert len(diagonal) == 15
    return prod(diagonal), diagonal


def main():
    identity = Matrix.eye(4)
    assert rank_mod_two(OMEGA) == 4
    assert rank_mod_two(OMEGA - identity) == 4
    assert all(int(value) % 2 == 0
               for value in (OMEGA * OMEGA + OMEGA + identity))

    lines = list(primitive_lines(1))
    records = [primitive_curve(vector) for vector in lines]
    classes = Matrix([record[0] for record in records])
    assert classes.rank() == 15
    index, diagonal = smith_index(classes)
    assert index == 64
    assert diagonal == [1] * 9 + [2] * 6

    minimal_matrix = -SYMPLECTIC.inv()
    assert all(value.q == 1 for value in minimal_matrix)
    minimal = upper_vector(minimal_matrix)
    source_minimal = BASIS.T * minimal_matrix * BASIS
    assert source_minimal[:5, 5:] == GRAM.inv()

    with_minimal = classes.col_join(Matrix([minimal]))
    with_twice_minimal = classes.col_join(Matrix([[2 * value for value in minimal]]))
    minimal_index, _ = smith_index(with_minimal)
    twice_index, _ = smith_index(with_twice_minimal)
    assert minimal_index == 32 and twice_index == 64

    axes = [tuple(1 if i == j else 0 for i in range(5)) for j in range(5)]
    axes += [(-1,) * 5]
    axis_records = [primitive_curve(vector) for vector in axes]
    assert [record[1] for record in axis_records] == [5] * 6
    assert [sum(record[0][index] for record in axis_records)
            for index in range(45)] == [6 * value for value in minimal]

    degrees = sorted({record[1] for record in records if record[1] <= 8})
    denominators = sorted({record[2] for record in records})
    assert degrees == [3, 4, 5, 7, 8]
    assert denominators == [1, 3]

    print("C904 independent non-axis elliptic-support replay")
    print("  omega has no F2 eigenline: PASS")
    print(f"  121 short elliptic lines: rank=15, Smith={diagonal}, index={index}")
    print(f"  minimal adjoining index={minimal_index}; twice-minimal index={twice_index}")
    print(f"  plane-area denominators={denominators}; theta degrees <=8={degrees}")
    print("  six degree-5 axes sum to six times the minimal class: PASS")
    print("PASS")


if __name__ == "__main__":
    main()
