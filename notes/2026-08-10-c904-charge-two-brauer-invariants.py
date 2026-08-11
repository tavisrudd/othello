#!/usr/bin/env python3
"""Exact mod-2 invariant audit for the marked charge-two Brauer class.

The geometric 2-torsion Brauer group of a complex abelian fivefold is
H^2(J,F_2)/(NS(J)/2).  This script constructs the actual exotic principal
homology lattice, the A5 action, the marked C3 monodromy, and the full
rank-15 Neron--Severi subspace.  It then computes fixed spaces on the
30-dimensional Brauer quotient, without assuming exactness of invariants.
"""

import importlib.util
from itertools import combinations
from math import gcd
from pathlib import Path

from sympy import Matrix


SOURCE = Path(__file__).with_name("2026-08-10-c904-minimal-class-divisor-replay.py")
SPEC = importlib.util.spec_from_file_location("c904_minimal_replay", SOURCE)
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)


def transpose(a):
    return [list(column) for column in zip(*a)]


def matmul(a, b):
    bt = transpose(b)
    return [[sum(x * y for x, y in zip(row, column)) % 2
             for column in bt] for row in a]


def identity(n):
    return [[int(i == j) for j in range(n)] for i in range(n)]


def add(a, b):
    return [[x ^ y for x, y in zip(ra, rb)] for ra, rb in zip(a, b)]


def rank(a):
    rows = [row[:] for row in a]
    if not rows:
        return 0
    nrows, ncols = len(rows), len(rows[0])
    pivot_row = 0
    for column in range(ncols):
        pivot = next((i for i in range(pivot_row, nrows)
                      if rows[i][column]), None)
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        for i in range(nrows):
            if i != pivot_row and rows[i][column]:
                rows[i] = [x ^ y for x, y in zip(rows[i], rows[pivot_row])]
        pivot_row += 1
    return pivot_row


def nullspace(a):
    """Canonical row-vector basis of the right kernel over F_2."""
    rows = [row[:] for row in a]
    if not rows:
        return []
    nrows, ncols = len(rows), len(rows[0])
    pivots = []
    pivot_row = 0
    for column in range(ncols):
        pivot = next((i for i in range(pivot_row, nrows)
                      if rows[i][column]), None)
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        for i in range(nrows):
            if i != pivot_row and rows[i][column]:
                rows[i] = [x ^ y for x, y in zip(rows[i], rows[pivot_row])]
        pivots.append(column)
        pivot_row += 1
    free = [column for column in range(ncols) if column not in pivots]
    result = []
    for free_column in free:
        vector = [0] * ncols
        vector[free_column] = 1
        for i, pivot_column in enumerate(pivots):
            vector[pivot_column] = rows[i][free_column]
        result.append(vector)
    assert all(not any(sum(x * y for x, y in zip(row, vector)) % 2
                           for row in a) for vector in result)
    return result


def inverse(a):
    n = len(a)
    rows = [row[:] + unit[:] for row, unit in zip(a, identity(n))]
    pivot_row = 0
    for column in range(n):
        pivot = next((i for i in range(pivot_row, n) if rows[i][column]), None)
        assert pivot is not None
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        for i in range(n):
            if i != pivot_row and rows[i][column]:
                rows[i] = [x ^ y for x, y in zip(rows[i], rows[pivot_row])]
        pivot_row += 1
    assert [row[:n] for row in rows] == identity(n)
    return [row[n:] for row in rows]


def nullity_of_stacked_fixed(actions):
    n = len(actions[0])
    equations = []
    for action in actions:
        equations.extend(add(action, identity(n)))
    return n - rank(equations)


def axis_action(permutation):
    """Integral action on v1,...,v5 with v6=-(v1+...+v5)."""
    result = [[0] * 5 for _ in range(5)]
    for source in range(5):
        target = permutation[source]
        column = [-1] * 5 if target == 5 else [
            int(i == target) for i in range(5)
        ]
        for i, value in enumerate(column):
            result[i][source] = value
    return result


def induced_principal(ambient):
    basis = Matrix(BASE.PRINCIPAL_BASIS)
    ambient_matrix = Matrix(ambient)
    induced = basis * ambient_matrix.T * basis.inv()
    assert all(value.q == 1 for value in induced)
    return [[int(induced[i, j]) % 2 for j in range(10)] for i in range(10)]


def block_diagonal(a, b):
    result = [[0] * (len(a) + len(b)) for _ in range(len(a) + len(b))]
    for i, row in enumerate(a):
        for j, value in enumerate(row):
            result[i][j] = value
    offset = len(a)
    for i, row in enumerate(b):
        for j, value in enumerate(row):
            result[offset + i][offset + j] = value
    return result


PAIRS = list(combinations(range(10), 2))


def wedge_action(linear):
    """Action E -> linear E linear^T on alternating 2-forms."""
    columns = []
    for source_i, source_j in PAIRS:
        form = [[0] * 10 for _ in range(10)]
        form[source_i][source_j] = 1
        form[source_j][source_i] = 1
        image = matmul(matmul(linear, form), transpose(linear))
        columns.append([image[i][j] for i, j in PAIRS])
    return transpose(columns)


def ns_vectors():
    vectors = []
    for sparse in BASE.divisor_forms():
        vectors.append([value % 2 for pair in PAIRS
                        for value in [sparse.get(pair, 0)]])
    assert rank(vectors) == 15
    return vectors


def quotient_actions(actions, subspace):
    """Induced matrices after placing subspace in the first coordinates."""
    basis_vectors = []
    running_rank = 0
    for vector in subspace:
        new_rank = rank(basis_vectors + [vector])
        if new_rank > running_rank:
            basis_vectors.append(vector)
            running_rank = new_rank
    assert running_rank == 15
    for i in range(45):
        vector = [int(i == j) for j in range(45)]
        new_rank = rank(basis_vectors + [vector])
        if new_rank > running_rank:
            basis_vectors.append(vector)
            running_rank = new_rank
    assert running_rank == 45
    change = transpose(basis_vectors)
    change_inverse = inverse(change)

    quotient = []
    for action in actions:
        transported = matmul(matmul(change_inverse, action), change)
        # The first 15 columns span NS and must have no quotient component.
        assert not any(transported[i][j]
                       for i in range(15, 45) for j in range(15))
        quotient.append([row[15:] for row in transported[15:]])
    return quotient, change


def fixed_basis(actions):
    n = len(actions[0])
    equations = []
    for action in actions:
        equations.extend(add(action, identity(n)))
    return nullspace(equations)


def apply_matrix(a, vector):
    return [sum(x * y for x, y in zip(row, vector)) % 2 for row in a]


def alternating_matrix(vector):
    result = [[0] * 10 for _ in range(10)]
    for value, (i, j) in zip(vector, PAIRS):
        result[i][j] = value
        result[j][i] = value
    return result


def invariant_coset_rank_profiles(invariant_basis, change, ns):
    """Minimum-rank and rank histogram in each nonzero invariant coset."""
    profiles = []
    for mask in range(1, 1 << len(invariant_basis)):
        quotient_vector = [0] * 30
        for i, basis_vector in enumerate(invariant_basis):
            if mask & (1 << i):
                quotient_vector = [x ^ y for x, y in
                                   zip(quotient_vector, basis_vector)]
        representative = apply_matrix(change, [0] * 15 + quotient_vector)
        histogram = {}
        value = representative[:]
        previous_gray = 0
        # Gray-code traversal changes one NS basis vector at a time.
        for integer in range(1 << len(ns)):
            gray = integer ^ (integer >> 1)
            if integer:
                changed = gray ^ previous_gray
                index = changed.bit_length() - 1
                value = [x ^ y for x, y in zip(value, ns[index])]
            form_rank = rank(alternating_matrix(value))
            histogram[form_rank] = histogram.get(form_rank, 0) + 1
            previous_gray = gray
        profiles.append((mask, min(histogram), sorted(histogram.items())))
    return profiles


def hilbert_determinant_degree(m):
    """Degree of det R p_* O_C(m) on a geometric quintic P^5 fibre."""
    chi_e = (m - 1) * m * (m + 1)
    k = m - 2
    twice_chi_o = k ** 3 + 3 * k ** 2 + 4 * k + 2
    degree = chi_e - twice_chi_o
    assert degree == (m - 1) * (3 * m - 2)
    return degree


def matrix_key(a):
    return tuple(value for row in a for value in row)


def generated_group(generators):
    n = len(generators[0])
    one = identity(n)
    elements = {matrix_key(one): one}
    frontier = [one]
    while frontier:
        value = frontier.pop()
        for generator in generators:
            product_value = matmul(value, generator)
            key = matrix_key(product_value)
            if key not in elements:
                elements[key] = product_value
                frontier.append(product_value)
    return list(elements.values())


def matrix_order(a):
    value = identity(len(a))
    for order_value in range(1, 121):
        value = matmul(value, a)
        if value == identity(len(a)):
            return order_value
    raise AssertionError("order exceeds audit bound")


def main():
    translation = [1, 2, 3, 4, 0, 5]
    inversion = [5, 4, 2, 3, 1, 0]
    axis_generators = [axis_action(translation), axis_action(inversion)]
    a5_h1 = [
        induced_principal(block_diagonal(generator, generator))
        for generator in axis_generators
    ]
    assert len(generated_group(a5_h1)) == 60

    # Marked elliptic monodromy [-I -I; I 0].
    i5 = Matrix.eye(5)
    z5 = Matrix.zeros(5)
    c3_ambient = Matrix.vstack(
        Matrix.hstack(-i5, -i5),
        Matrix.hstack(i5, z5),
    )
    c3_h1 = induced_principal(c3_ambient.tolist())
    assert matrix_order(c3_h1) == 3
    assert all(matmul(c3_h1, generator) == matmul(generator, c3_h1)
               for generator in a5_h1)

    a5_h2 = [wedge_action(generator) for generator in a5_h1]
    c3_h2 = wedge_action(c3_h1)
    ns = ns_vectors()
    quotient, change = quotient_actions(a5_h2 + [c3_h2], ns)
    a5_br = quotient[:2]
    c3_br = quotient[2]

    print("marked charge-two geometric Brauer invariant audit")
    print("  dim H2(J,F2)=45")
    print(f"  dim NS/2={rank(ns)}")
    print(f"  dim Br(J)[2]={len(a5_br[0])}")
    print(f"  dim Br[2]^A5={nullity_of_stacked_fixed(a5_br)}")
    print(f"  dim Br[2]^C3={nullity_of_stacked_fixed([c3_br])}")
    print(
        "  dim Br[2]^(A5 x C3)="
        f"{nullity_of_stacked_fixed(a5_br + [c3_br])}"
    )
    joint_basis = fixed_basis(a5_br + [c3_br])
    profiles = invariant_coset_rank_profiles(joint_basis, change, ns)
    print(f"  joint invariant nonzero coset rank profiles={profiles}")

    # Finite 2-primary subgroup diagnostics inside A5.
    a5_group = generated_group(a5_br)
    order_counts = {}
    for element in a5_group:
        order_value = matrix_order(element)
        order_counts[order_value] = order_counts.get(order_value, 0) + 1
    print(f"  quotient A5 image order={len(a5_group)} classes={sorted(order_counts.items())}")

    involutions = [element for element in a5_group if matrix_order(element) == 2]
    first = involutions[0]
    commuting = [element for element in involutions
                 if element != first and matmul(first, element) == matmul(element, first)]
    second = commuting[0]
    v4 = [first, second]
    print(f"  dim Br[2]^C2={nullity_of_stacked_fixed([first])}")
    print(f"  dim Br[2]^V4={nullity_of_stacked_fixed(v4)}")

    degrees = [hilbert_determinant_degree(m) for m in range(-4, 7)]
    degree_gcd = 0
    for degree in degrees:
        degree_gcd = gcd(degree_gcd, abs(degree))
    print("  Hilbert determinant degree d_m=(m-1)(3m-2)")
    print(f"  gcd(d_m, -4<=m<=6)={degree_gcd}; all sampled degrees even")
    assert degree_gcd == 2 and all(degree % 2 == 0 for degree in degrees)

    if nullity_of_stacked_fixed(a5_br + [c3_br]) == 0:
        print("  no A5- and marked-monodromy-invariant geometric 2-torsion Brauer class")
    else:
        print("  invariant classes survive; cocycle identification remains necessary")
    print("PASS")


if __name__ == "__main__":
    main()
