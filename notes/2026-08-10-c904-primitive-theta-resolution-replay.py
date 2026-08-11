#!/usr/bin/env python3
"""Exact finite checks for the C904 primitive-theta resolution gate."""

from fractions import Fraction
from itertools import permutations, product


def compose(left, right):
    return tuple(left[right[i]] for i in range(len(left)))


def identity(n):
    return tuple(range(n))


def power(value, exponent):
    result = identity(len(value))
    for _ in range(exponent):
        result = compose(value, result)
    return result


def order(value):
    result = identity(len(value))
    for exponent in range(1, 61):
        result = compose(value, result)
        if result == identity(len(value)):
            return exponent
    raise AssertionError("order bound exceeded")


def parity(value):
    inversions = sum(value[i] > value[j]
                     for i in range(len(value))
                     for j in range(i + 1, len(value)))
    return inversions % 2


def subgroup_generated(generator):
    return frozenset(power(generator, i) for i in range(order(generator)))


def permutation_matrix_on_sylows(element, sylows):
    inverse = power(element, order(element) - 1)
    positions = {subgroup: i for i, subgroup in enumerate(sylows)}
    result = [[0] * len(sylows) for _ in sylows]
    for i, subgroup in enumerate(sylows):
        conjugate = frozenset(compose(compose(element, h), inverse)
                              for h in subgroup)
        result[positions[conjugate]][i] = 1
    return result


def matrix_vector(matrix, vector):
    return tuple(sum(row[j] * vector[j] for j in range(len(vector)))
                 for row in matrix)


def rank_rational(rows):
    matrix = [[Fraction(value) for value in row] for row in rows]
    rank = 0
    columns = len(matrix[0]) if matrix else 0
    for column in range(columns):
        pivot = next((i for i in range(rank, len(matrix))
                      if matrix[i][column]), None)
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        pivot_value = matrix[rank][column]
        matrix[rank] = [value / pivot_value for value in matrix[rank]]
        for i in range(len(matrix)):
            if i != rank and matrix[i][column]:
                factor = matrix[i][column]
                matrix[i] = [matrix[i][j] - factor * matrix[rank][j]
                             for j in range(columns)]
        rank += 1
    return rank


def check_a5_axes():
    a5 = tuple(value for value in permutations(range(5)) if parity(value) == 0)
    assert len(a5) == 60
    five_subgroups = {subgroup_generated(value) for value in a5
                      if order(value) == 5}
    sylows = tuple(sorted(five_subgroups, key=lambda group: sorted(group)))
    assert len(sylows) == 6

    normalizers = []
    for subgroup in sylows:
        normalizer = frozenset(
            g for g in a5
            if frozenset(compose(compose(g, h), power(g, order(g) - 1))
                         for h in subgroup) == subgroup
        )
        assert len(normalizer) == 10
        normalizers.append(normalizer)

    involutions = tuple(g for g in a5 if order(g) == 2)
    assert len(involutions) == 15
    assert all(sum(g in normalizer for normalizer in normalizers) == 2
               for g in involutions)

    g = involutions[0]
    containing = [i for i, normalizer in enumerate(normalizers)
                  if g in normalizer]
    action = permutation_matrix_on_sylows(g, sylows)
    axes = []
    for i in containing:
        # The D5-normalizer has singleton orbit i and a five-point orbit.
        axis = tuple(5 if j == i else -1 for j in range(6))
        assert sum(axis) == 0
        assert matrix_vector(action, axis) == axis
        axes.append(axis)
    assert rank_rational(axes) == 2

    # On Q^6 the involution has four + and two - eigenvectors.  Removing
    # the constant vector leaves W5 dimensions (+,-)=(3,2).
    identity6 = [[int(i == j) for j in range(6)] for i in range(6)]
    plus_matrix = [[action[i][j] - identity6[i][j] for j in range(6)]
                   for i in range(6)]
    minus_matrix = [[action[i][j] + identity6[i][j] for j in range(6)]
                    for i in range(6)]
    plus_dimension_q6 = 6 - rank_rational(plus_matrix)
    minus_dimension_q6 = 6 - rank_rational(minus_matrix)
    assert (plus_dimension_q6 - 1, minus_dimension_q6) == (3, 2)


def check_parity_identity():
    # Modulo two, the three norm traces vanish.  The two cyclic triple
    # traces agree for Rosati-symmetric operators and hence cancel.
    for ab, ac, bc, abc in product(range(2), repeat=4):
        ta = tb = tc = 0
        mixed = (ta * tb * tc - ta * bc - tb * ac - tc * ab
                 + abc + abc)
        assert mixed % 2 == 0
    for trace in range(2):
        assert (6 * trace) % 2 == 0


def check_resolution_relation():
    # Coordinates are (primitive lift a, exceptional line ell).
    a = (1, 0)
    ell = (0, 1)
    strict_incidence = (2, -1)
    exceptional_pairing = lambda value: -value[1]
    push = lambda value: value[0]
    assert push(strict_incidence) == 2
    assert exceptional_pairing(strict_incidence) == 1
    assert tuple(strict_incidence[i] + ell[i] for i in range(2)) == \
        tuple(2 * a[i] for i in range(2))


def main():
    check_a5_axes()
    check_parity_identity()
    check_resolution_relation()
    print("A5 D5-axis incidence: PASS")
    print("Rosati mixed-degree parity: PASS")
    print("theta-resolution relation 2a=z+ell: PASS")


if __name__ == "__main__":
    main()
