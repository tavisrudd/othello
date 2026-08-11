#!/usr/bin/env python3
"""Exact p=3, g=4 divided-power obstruction certificate.

This is a single explicit certificate, not a census.  It verifies directly
that the displayed graph Lagrangian has a complete integral NS lattice whose
triple divisor products are annihilated modulo 3 by a functional which is
nonzero on the primitive minimal class.
"""

from itertools import combinations, combinations_with_replacement

from sympy import Matrix


P = 3
G = 4
A = Matrix([
    [1, 1, 0, 0],
    [1, 1, 2, 2],
    [0, 2, 1, 0],
    [0, 2, 0, 1],
])
POSITIONS = [(i, j) for i in range(G) for j in range(i, G)]

# Coordinates use POSITIONS.  These rows are a basis of
# {T in Sym_4(Z) : TA-AT = 0 mod 3}.
T_BASIS_COORDINATES = [
    [1, 0, 0, 0, 1, 0, 0, 0, 1, 0],
    [0, 1, 0, 0, 0, 2, 2, 0, 0, 0],
    [0, 0, 1, 0, 2, 0, 0, 0, 0, 2],
    [0, 0, 0, 1, 2, 0, 0, 0, 2, 1],
    [0, 0, 0, 0, 3, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 3, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 3, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 1, 2, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 3, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 3],
]

# Coefficient functional on wedge^6 Z^8.  Indices 0,...,3 are e_i and
# 4,...,7 are f_i.
FUNCTIONAL_SUPPORT = {
    (0, 1, 2, 4, 5, 6),
    (1, 2, 3, 4, 5, 6),
    (1, 2, 3, 5, 6, 7),
}


def rank_mod_p(rows, prime):
    work = [[value % prime for value in row] for row in rows]
    rank = 0
    columns = len(work[0]) if work else 0
    for column in range(columns):
        pivot = next((row for row in range(rank, len(work))
                      if work[row][column]), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = pow(work[rank][column], -1, prime)
        work[rank] = [(inverse * value) % prime for value in work[rank]]
        for row in range(len(work)):
            if row == rank or not work[row][column]:
                continue
            scalar = work[row][column]
            work[row] = [
                (left - scalar * right) % prime
                for left, right in zip(work[row], work[rank])
            ]
        rank += 1
    return rank


def symmetric_matrix(coordinates):
    answer = Matrix.zeros(G, G)
    for value, (i, j) in zip(coordinates, POSITIONS):
        answer[i, j] = value
        answer[j, i] = value
    return answer


def two_form(matrix_value):
    return {
        (i, j): int(matrix_value[i, j])
        for i in range(matrix_value.rows)
        for j in range(i + 1, matrix_value.cols)
        if matrix_value[i, j]
    }


def wedge(left, right):
    answer = {}
    for left_indices, left_value in left.items():
        left_set = set(left_indices)
        for right_indices, right_value in right.items():
            if left_set.intersection(right_indices):
                continue
            inversions = sum(i > j for i in left_indices for j in right_indices)
            indices = tuple(sorted(left_indices + right_indices))
            answer[indices] = answer.get(indices, 0) + (
                (-1) ** inversions * left_value * right_value
            )
    return {indices: value for indices, value in answer.items() if value}


def divisor_form(coordinates):
    t_value = symmetric_matrix(coordinates)
    commutator = t_value * A - A * t_value
    assert all(value % P == 0 for value in commutator)
    upper_left = commutator.applyfunc(lambda value: value // P)
    answer = Matrix.zeros(2 * G, 2 * G)
    answer[:G, :G] = upper_left
    answer[:G, G:] = t_value
    answer[G:, :G] = -t_value
    assert answer + answer.T == Matrix.zeros(2 * G, 2 * G)
    return two_form(answer)


def functional(value):
    return sum(value.get(indices, 0) for indices in FUNCTIONAL_SUPPORT) % P


def main():
    # Completeness of the NS congruence lattice: the commutator map has rank
    # five over F_3, while the displayed rank-ten lift has determinant 3^5.
    commutator_columns = []
    for index in range(len(POSITIONS)):
        coordinates = [0] * len(POSITIONS)
        coordinates[index] = 1
        commutator = symmetric_matrix(coordinates) * A - A * symmetric_matrix(coordinates)
        commutator_columns.append([
            int(commutator[i, j]) for i in range(G) for j in range(i + 1, G)
        ])
    commutator_matrix = list(map(list, zip(*commutator_columns)))
    assert rank_mod_p(commutator_matrix, P) == 5
    assert abs(int(Matrix(T_BASIS_COORDINATES).det())) == P ** 5

    divisors = [divisor_form(row) for row in T_BASIS_COORDINATES]
    checked = 0
    for indices in combinations_with_replacement(range(len(divisors)), G - 1):
        value = {tuple(): 1}
        for index in indices:
            value = wedge(value, divisors[index])
        assert functional(value) == 0
        checked += 1
    assert checked == 220

    theta_matrix = Matrix.zeros(2 * G, 2 * G)
    theta_matrix[:G, G:] = Matrix.eye(G)
    theta_matrix[G:, :G] = -Matrix.eye(G)
    theta = two_form(theta_matrix)
    theta_cube = wedge(wedge(theta, theta), theta)
    assert all(value % 6 == 0 for value in theta_cube.values())
    minimal = {indices: value // 6 for indices, value in theta_cube.items()}
    assert functional(minimal) == 1

    print("C904 p=3 g=4 divided-power counterexample")
    print("commutator_rank_mod_3=5")
    print("ns_congruence_index=3^5")
    print("triple_products_checked=220")
    print("functional_on_products=0")
    print("functional_on_minimal_class=1")
    print("minimal_class_not_in_integral_divisor_product_lattice=PASS")


if __name__ == "__main__":
    main()
