#!/usr/bin/env python3
"""Independent exact replay for the C904 odd-minimal-class certificate.

This script deliberately does not import Sage or the construction script.  It
uses only Python's exact ``Fraction`` arithmetic plus SymPy's independent Smith
normal-form implementation.  Run it inside the Sage Nix environment only to
make SymPy available:

    nix shell nixpkgs#sage -c sage -python \
      notes/2026-08-10-c904-minimal-class-divisor-replay.py
"""

from fractions import Fraction
from functools import reduce
from itertools import combinations, combinations_with_replacement
from math import gcd, prod

from sympy import Matrix
from sympy.matrices.normalforms import smith_normal_form
from sympy.polys.domains import ZZ


def parse_matrix(text):
    return [[Fraction(token) for token in line.split()]
            for line in text.strip().splitlines()]


PRINCIPAL_BASIS = parse_matrix(r"""
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

PRINCIPAL_SYMPLECTIC = parse_matrix(r"""
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

NS_BASIS = parse_matrix(r"""
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
-1 5 -1 -1 -1 -1 -1 -1 -1 -1 -1 5 5 -1 -1
-1 -1 5 -1 -1 -1 -1 -1 -1 -1 -1 -1 5 -1 5
0 0 0 0 0 0 0 0 6 0 0 -6 0 0 6
-1 -1 -1 5 -1 -1 -1 -1 -1 -1 -1 5 -1 5 -1
-1 -1 -1 -1 5 -1 -1 -1 -1 -1 -1 -1 -1 5 5
-2 -2 -2 -2 -2 -2 -2 4 -2 -2 -2 4 4 4 -2
0 0 -6 0 0 0 0 0 0 0 0 0 6 0 -6
1 1 1 1 1 1 1 -5 1 1 -5 -5 1 1 1
0 -6 -6 0 0 0 0 0 6 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 6 0 -6 6 0
0 0 0 0 0 0 0 0 -6 0 0 6 0 0 6
-2 -2 4 -2 -2 -2 -2 4 -2 4 4 -2 -2 -2 -2
-2 -2 4 4 -2 4 -2 -2 4 -2 -2 -2 -2 -2 4
-1 -1 5 -1 -1 -1 5 5 -1 -1 -1 -1 -1 -1 -1
""")

RATIONAL_BASIS_MONOMIALS = [
    (0, 1, 1, 1), (0, 1, 1, 2), (0, 1, 1, 3),
    (0, 1, 1, 4), (0, 1, 1, 5), (0, 1, 1, 6),
    (0, 1, 1, 7), (0, 1, 1, 10), (0, 1, 1, 11),
    (0, 1, 1, 12), (1, 1, 1, 1), (1, 1, 1, 2),
    (1, 1, 1, 3), (1, 1, 1, 4), (1, 1, 1, 5),
]
MINIMAL_RATIONAL_COORDINATES = [
    Fraction(1, 15), Fraction(-3, 10), Fraction(-1, 5),
    Fraction(-1, 5), 0, 0, Fraction(-1, 2), Fraction(-1, 10),
    Fraction(-1, 5), Fraction(-1, 5), Fraction(1, 24), 0, 0, 0, 0,
]
PROJECTIONS = [
    ([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, 17], 7),
    ([0, 1, 2, 6, 7, 8, 10, 11, 13, 16, 17, 18, 23, 31, 36], 17),
]


def transpose(matrix):
    return [list(column) for column in zip(*matrix)]


def matmul(left, right):
    right_t = transpose(right)
    return [[sum(a * b for a, b in zip(row, column))
             for column in right_t] for row in left]


def block_alternating(coefficient):
    result = [[Fraction(0) for _ in range(10)] for _ in range(10)]
    for i in range(5):
        for j in range(5):
            result[i][5 + j] = coefficient[i][j]
            result[5 + i][j] = -coefficient[i][j]
    return result


def coefficient_matrix(coordinates):
    positions = [(i, j) for i in range(5) for j in range(i, 5)]
    result = [[Fraction(0) for _ in range(5)] for _ in range(5)]
    for value, (i, j) in zip(coordinates, positions):
        result[i][j] = value
        result[j][i] = value
    return result


def two_form(matrix):
    return {(i, j): int(matrix[i][j])
            for i in range(10) for j in range(i + 1, 10)
            if matrix[i][j]}


def wedge(left, right):
    result = {}
    for left_indices, left_value in left.items():
        left_set = set(left_indices)
        for right_indices, right_value in right.items():
            if left_set.intersection(right_indices):
                continue
            inversions = sum(i > j for i in left_indices for j in right_indices)
            indices = tuple(sorted(left_indices + right_indices))
            result[indices] = result.get(indices, 0) + (-1) ** inversions * left_value * right_value
    return {key: value for key, value in result.items() if value}


def divisor_forms():
    basis_t = transpose(PRINCIPAL_BASIS)
    forms = []
    for coordinates in NS_BASIS:
        source = block_alternating(coefficient_matrix(coordinates))
        pulled = matmul(matmul(PRINCIPAL_BASIS, source), basis_t)
        assert all(value.denominator == 1 for row in pulled for value in row)
        assert all(pulled[i][j] == -pulled[j][i] for i in range(10) for j in range(10))
        forms.append(two_form(pulled))
    return forms


def all_products(forms):
    degree_two = {(i, j): wedge(forms[i], forms[j])
                  for i, j in combinations_with_replacement(range(15), 2)}
    degree_three = {(i, j, k): wedge(degree_two[(i, j)], forms[k])
                    for i, j, k in combinations_with_replacement(range(15), 3)}
    eight_indices = list(combinations(range(10), 8))
    rows = []
    monomials = []
    for monomial in combinations_with_replacement(range(15), 4):
        i, j, k, ell = monomial
        value = wedge(degree_three[(i, j, k)], forms[ell])
        rows.append([value.get(indices, 0) for indices in eight_indices])
        monomials.append(monomial)
    return eight_indices, rows, monomials


def minimal_vector(eight_indices):
    theta = two_form(PRINCIPAL_SYMPLECTIC)
    theta_squared = wedge(theta, theta)
    theta_fourth = wedge(theta_squared, theta_squared)
    assert all(value % 24 == 0 for value in theta_fourth.values())
    return [theta_fourth.get(indices, 0) // 24 for indices in eight_indices]


def projection_index(rows, columns):
    projected = Matrix([[row[column] for column in columns] for row in rows])
    smith = smith_normal_form(projected, domain=ZZ)
    diagonal = [abs(int(smith[i, i])) for i in range(15)]
    assert all(diagonal)
    return prod(diagonal), diagonal


def main():
    forms = divisor_forms()
    eight_indices, rows, monomials = all_products(forms)
    assert len(rows) == 3060 and len(eight_indices) == 45
    minimal = minimal_vector(eight_indices)

    lookup = {monomial: row for monomial, row in zip(monomials, rows)}
    reconstructed = [
        sum(coefficient * lookup[monomial][column]
            for coefficient, monomial in zip(
                MINIMAL_RATIONAL_COORDINATES, RATIONAL_BASIS_MONOMIALS
            ))
        for column in range(45)
    ]
    assert reconstructed == minimal

    indices = []
    for columns, expected in PROJECTIONS:
        index, diagonal = projection_index(rows, columns)
        assert index == expected
        indices.append(index)
        print(f"projection columns={columns} smith={diagonal} index={index}")
    assert reduce(gcd, indices) == 1

    print("rational Hodge rank=15 (explicit basis)")
    print("gcd of full-rank projection indices=1")
    print("minimal class lies in the rational divisor-product span")
    print("therefore the divisor-product lattice is saturated and contains theta^4/4!")
    print("PASS")


if __name__ == "__main__":
    main()
