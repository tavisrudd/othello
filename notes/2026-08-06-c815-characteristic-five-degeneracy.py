#!/usr/bin/env python3
"""Characteristic-five mechanism for the C815 weighted Jacobian.

Settles the open mystery-ledger item of
`notes/2026-08-05-c815-rank-14-weighted-jacobian.md`: why the rank of the
weighted Jacobian drops from fourteen to eleven modulo five.

The answer is an exact containment, not a rank coincidence.  Let T be the
tangent space at the golden representative to the generalized conference locus
A^2 = lambda I, and for X in T let mu(X) be the scalar with A0 X + X A0 =
mu(X) I.  Then the kernel of the Jacobian modulo five is exactly the
hyperplane mu = 0 (mod 5) inside T.

Replay from the repository root:

    python3 notes/2026-08-06-c815-characteristic-five-degeneracy.py --check \
      notes/2026-08-06-c815-characteristic-five-degeneracy.json

Standard library only; exact integer and rational arithmetic; no randomness.
The Jacobian is rebuilt from scratch rather than imported from the C815 or
C809 bundles, so this is an independent code path for the shared quantities.
"""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from itertools import combinations
from math import gcd
from pathlib import Path

EDGES = list(combinations(range(6), 2))
TRIPLES = list(combinations(range(6), 3))

GOLDEN = [
    [0, 1, 1, 1, 1, 1],
    [1, 0, 1, 1, -1, -1],
    [1, 1, 0, -1, 1, -1],
    [1, 1, -1, 0, -1, 1],
    [1, -1, 1, -1, 0, 1],
    [1, -1, -1, 1, 1, 0],
]

OPPOSITE = [
    [0, 1, 1, 1, 1, 1],
    [1, 0, -1, -1, 1, 1],
    [1, -1, 0, 1, -1, 1],
    [1, -1, 1, 0, 1, -1],
    [1, 1, -1, 1, 0, -1],
    [1, 1, 1, -1, -1, 0],
]


# ---------------------------------------------------------------- basic algebra

def determinant(matrix):
    if not matrix:
        return 1
    total = 0
    for column in range(len(matrix)):
        if matrix[0][column]:
            minor = [row[:column] + row[column + 1:] for row in matrix[1:]]
            total += (-1) ** column * matrix[0][column] * determinant(minor)
    return total


def permutation_sign(sequence):
    sign = 1
    sequence = list(sequence)
    for i in range(len(sequence)):
        for j in range(i + 1, len(sequence)):
            if sequence[i] > sequence[j]:
                sign = -sign
    return sign


def triangle_coefficient(matrix, triple):
    i, j, k = triple
    return matrix[i][j] * matrix[j][k] * matrix[k][i]


def compound_coefficient(matrix, triple):
    complement = [x for x in range(6) if x not in triple]
    block = [[matrix[r][c] for c in triple] for r in complement]
    return -permutation_sign(list(complement) + list(triple)) * determinant(block)


def equality_value(matrix, triple, orientation):
    return (compound_coefficient(matrix, triple)
            - 4 * orientation * triangle_coefficient(matrix, triple))


def equality_jacobian(matrix, orientation):
    """Exact Jacobian by multilinearity: the partial in an edge direction is the
    difference of the values at that entry set to one and to zero."""
    rows = []
    for triple in TRIPLES:
        row = []
        for (i, j) in EDGES:
            high = [r[:] for r in matrix]
            high[i][j] = high[j][i] = 1
            low = [r[:] for r in matrix]
            low[i][j] = low[j][i] = 0
            row.append(equality_value(high, triple, orientation)
                       - equality_value(low, triple, orientation))
        rows.append(row)
    return rows


# ------------------------------------------------------------- linear algebra

def rref_rational(rows, columns):
    matrix = [[Fraction(x) for x in row] for row in rows]
    pivots = []
    pivot_row = 0
    for column in range(columns):
        found = next((i for i in range(pivot_row, len(matrix)) if matrix[i][column]), None)
        if found is None:
            continue
        matrix[pivot_row], matrix[found] = matrix[found], matrix[pivot_row]
        scale = matrix[pivot_row][column]
        matrix[pivot_row] = [x / scale for x in matrix[pivot_row]]
        for i in range(len(matrix)):
            if i != pivot_row and matrix[i][column]:
                factor = matrix[i][column]
                matrix[i] = [a - factor * b for a, b in zip(matrix[i], matrix[pivot_row])]
        pivots.append(column)
        pivot_row += 1
    return matrix[:pivot_row], pivots


def rank_rational(rows, columns):
    return len(rref_rational(rows, columns)[0])


def kernel_rational(rows, columns):
    reduced, pivots = rref_rational(rows, columns)
    free = [c for c in range(columns) if c not in pivots]
    basis = []
    for column in free:
        vector = [Fraction(0)] * columns
        vector[column] = Fraction(1)
        for index, pivot in enumerate(pivots):
            vector[pivot] = -reduced[index][column]
        denominator = 1
        for entry in vector:
            denominator = denominator * entry.denominator // gcd(denominator, entry.denominator)
        basis.append([int(entry * denominator) for entry in vector])
    return basis


def rref_mod(rows, prime, columns):
    matrix = [[x % prime for x in row] for row in rows]
    pivots = []
    pivot_row = 0
    for column in range(columns):
        found = next((i for i in range(pivot_row, len(matrix)) if matrix[i][column]), None)
        if found is None:
            continue
        matrix[pivot_row], matrix[found] = matrix[found], matrix[pivot_row]
        inverse = pow(matrix[pivot_row][column], prime - 2, prime)
        matrix[pivot_row] = [(x * inverse) % prime for x in matrix[pivot_row]]
        for i in range(len(matrix)):
            if i != pivot_row and matrix[i][column]:
                factor = matrix[i][column]
                matrix[i] = [(a - factor * b) % prime
                             for a, b in zip(matrix[i], matrix[pivot_row])]
        pivots.append(column)
        pivot_row += 1
    return matrix[:pivot_row], pivots


def rank_mod(rows, prime, columns):
    return len(rref_mod(rows, prime, columns)[0])


def kernel_mod(rows, prime, columns):
    reduced, pivots = rref_mod(rows, prime, columns)
    free = [c for c in range(columns) if c not in pivots]
    basis = []
    for column in free:
        vector = [0] * columns
        vector[column] = 1
        for index, pivot in enumerate(pivots):
            vector[pivot] = (-reduced[index][column]) % prime
        basis.append(vector)
    return basis


def same_span_mod(first, second, prime, columns):
    a = rref_mod(first, prime, columns)[0]
    b = rref_mod(second, prime, columns)[0]
    return a == b


def smith_invariants(rows):
    matrix = [row[:] for row in rows]
    height, width = len(matrix), len(matrix[0])
    invariants = []
    corner = 0
    while corner < height and corner < width:
        best = None
        for i in range(corner, height):
            for j in range(corner, width):
                if matrix[i][j] and (best is None
                                     or abs(matrix[i][j]) < abs(matrix[best[0]][best[1]])):
                    best = (i, j)
        if best is None:
            break
        matrix[corner], matrix[best[0]] = matrix[best[0]], matrix[corner]
        for row in matrix:
            row[corner], row[best[1]] = row[best[1]], row[corner]
        settled = False
        while not settled:
            settled = True
            for i in range(corner + 1, height):
                if matrix[i][corner]:
                    quotient = matrix[i][corner] // matrix[corner][corner]
                    matrix[i] = [a - quotient * b for a, b in zip(matrix[i], matrix[corner])]
                    if matrix[i][corner]:
                        matrix[corner], matrix[i] = matrix[i], matrix[corner]
                        settled = False
            for j in range(corner + 1, width):
                if matrix[corner][j]:
                    quotient = matrix[corner][j] // matrix[corner][corner]
                    for row in matrix:
                        row[j] -= quotient * row[corner]
                    if matrix[corner][j]:
                        for row in matrix:
                            row[corner], row[j] = row[j], row[corner]
                        settled = False
        invariants.append(abs(matrix[corner][corner]))
        corner += 1
    return invariants


# ------------------------------------------------- conference tangent and mu

def as_symmetric(vector):
    matrix = [[0] * 6 for _ in range(6)]
    for index, (i, j) in enumerate(EDGES):
        matrix[i][j] = matrix[j][i] = vector[index]
    return matrix


def conference_tangent(matrix):
    """Basis of {X in W : A X + X A is a scalar matrix}, as integer edge vectors."""
    rows = []
    for r in range(6):
        for c in range(r, 6):
            row = [0] * 16
            for index, (i, j) in enumerate(EDGES):
                value = 0
                if c == j:
                    value += matrix[r][i]
                if c == i:
                    value += matrix[r][j]
                if r == j:
                    value += matrix[i][c]
                if r == i:
                    value += matrix[j][c]
                row[index] = value
            row[15] = -1 if r == c else 0
            rows.append(row)
    return [vector[:15] for vector in kernel_rational(rows, 16)], rank_rational(rows, 16)


def multiplier(matrix, vector):
    """The scalar mu with A X + X A = mu I; asserts the tangency it assumes."""
    X = as_symmetric(vector)
    product = [[sum(matrix[i][k] * X[k][j] + X[i][k] * matrix[k][j] for k in range(6))
                for j in range(6)] for i in range(6)]
    for i in range(6):
        for j in range(6):
            if i != j and product[i][j] != 0:
                raise AssertionError("vector is not conference-tangent")
    diagonal = {product[i][i] for i in range(6)}
    if len(diagonal) != 1:
        raise AssertionError("A X + X A is not scalar")
    return product[0][0]


def third_compound(matrix):
    """The 20-by-20 third compound: entry (R, S) is det matrix[R, S]."""
    return [[determinant([[matrix[r][c] for c in S] for r in R]) for S in TRIPLES]
            for R in TRIPLES]


def third_compound_derivative(matrix, vector):
    """d/dt of the third compound of (matrix + t X) at t = 0, entrywise."""
    X = as_symmetric(vector)
    result = []
    for R in TRIPLES:
        row = []
        for S in TRIPLES:
            total = 0
            for slot in range(3):
                block = [[X[r][c] if index == slot else matrix[r][c] for c in S]
                         for index, r in enumerate(R)]
                total += determinant(block)
            row.append(total)
        result.append(row)
    return result


def matrix_product(left, right):
    size = len(left)
    return [[sum(left[i][k] * right[k][j] for k in range(size)) for j in range(size)]
            for i in range(size)]


def apply_jacobian(jacobian, vector):
    return [sum(row[c] * vector[c] for c in range(15)) for row in jacobian]


def content(vector):
    total = 0
    for entry in vector:
        total = gcd(total, entry)
    return total


# ------------------------------------------------------------------- analysis

def analyse(matrix, orientation):
    jacobian = equality_jacobian(matrix, orientation)
    edge_vector = [matrix[i][j] for (i, j) in EDGES]

    report = {}
    report["rank_rational"] = rank_rational(jacobian, 15)
    report["rank_mod"] = {str(p): rank_mod(jacobian, p, 15) for p in (2, 3, 5, 7, 11, 13)}

    # every entry is even; the primitive Jacobian carries the modular content
    assert all(entry % 2 == 0 for row in jacobian for entry in row)
    primitive = [[entry // 2 for entry in row] for row in jacobian]
    report["primitive_rank_mod"] = {
        str(p): rank_mod(primitive, p, 15) for p in (2, 3, 5, 7, 11, 13)
    }
    report["primitive_smith"] = smith_invariants(primitive)

    tangent, conference_rank = conference_tangent(matrix)
    report["conference_rank"] = conference_rank
    report["conference_tangent_dimension"] = len(tangent)

    multipliers = [multiplier(matrix, vector) for vector in tangent]
    report["multiplier_of_representative"] = multiplier(matrix, edge_vector)

    # mu is a linear functional on the tangent space; its rational kernel is the
    # four-dimensional summand, and the representative is NOT in it.
    functional = [[m] for m in multipliers]
    report["multiplier_rank"] = rank_rational(list(map(list, zip(*functional))), len(tangent))

    rational_mu_kernel = []
    for coefficients in kernel_rational([multipliers], len(tangent)):
        combined = [sum(coefficients[t] * tangent[t][c] for t in range(len(tangent)))
                    for c in range(15)]
        rational_mu_kernel.append(combined)
    report["rational_mu_kernel_dimension"] = rank_rational(rational_mu_kernel, 15)

    # the engine identity: A X A = mu A - 5 X for every conference-tangent X
    identity_holds = True
    for vector in tangent:
        X = as_symmetric(vector)
        left = [[sum(matrix[i][a] * X[a][b] * matrix[b][j]
                     for a in range(6) for b in range(6)) for j in range(6)]
                for i in range(6)]
        mu = multiplier(matrix, vector)
        right = [[mu * matrix[i][j] - 5 * X[i][j] for j in range(6)] for i in range(6)]
        if left != right:
            identity_holds = False
    report["engine_identity_A_X_A"] = identity_holds

    # the compound engine: C = third compound of A, with C^2 = 125 I, and the
    # compound derivative in any mu = 0 direction anticommutes with C.
    compound = third_compound(matrix)
    square = matrix_product(compound, compound)
    report["compound_square_is_125"] = all(
        square[i][j] == (125 if i == j else 0) for i in range(20) for j in range(20))
    anticommutes = True
    for vector in rational_mu_kernel:
        derivative = third_compound_derivative(matrix, vector)
        left = matrix_product(compound, derivative)
        right = matrix_product(derivative, compound)
        if any(left[i][j] != -right[i][j] for i in range(20) for j in range(20)):
            anticommutes = False
    report["compound_derivative_anticommutes_on_mu_kernel"] = anticommutes
    # by contrast the representative direction commutes rather than anticommutes
    representative_derivative = third_compound_derivative(matrix, edge_vector)
    left = matrix_product(compound, representative_derivative)
    right = matrix_product(representative_derivative, compound)
    report["compound_derivative_commutes_on_representative"] = (left == right)

    # images of the rational mu-kernel are divisible by five
    contents = sorted(content(apply_jacobian(jacobian, v)) for v in rational_mu_kernel)
    report["mu_kernel_image_contents"] = contents
    report["mu_kernel_image_divisible_by_five"] = all(c % 5 == 0 for c in contents)

    # the headline: ker(J mod 5) is exactly the mu = 0 (mod 5) hyperplane of T
    jacobian_kernel = kernel_mod(jacobian, 5, 15)
    report["jacobian_kernel_dimension_mod_five"] = len(jacobian_kernel)

    reduced_multipliers = [m % 5 for m in multipliers]
    hyperplane = []
    for coefficients in kernel_mod([reduced_multipliers], 5, len(tangent)):
        combined = [sum(coefficients[t] * tangent[t][c]
                        for t in range(len(tangent))) % 5 for c in range(15)]
        hyperplane.append(combined)
    report["mu_hyperplane_dimension_mod_five"] = rank_mod(hyperplane, 5, 15)
    report["kernel_equals_mu_hyperplane_mod_five"] = same_span_mod(
        jacobian_kernel, hyperplane, 5, 15)

    # the representative lies in the mod-five kernel although mu(A0) = 10 != 0
    report["representative_in_kernel_mod_five"] = same_span_mod(
        jacobian_kernel, jacobian_kernel + [[x % 5 for x in edge_vector]], 5, 15)
    report["representative_in_rational_mu_kernel"] = (
        rank_rational(rational_mu_kernel, 15)
        == rank_rational(rational_mu_kernel + [edge_vector], 15))

    return report


def build():
    return {
        "description": "characteristic-five degeneracy of the C815 weighted Jacobian",
        "golden": analyse(GOLDEN, 1),
        "opposite": analyse(OPPOSITE, -1),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--emit", type=Path)
    parser.add_argument("--check", type=Path)
    arguments = parser.parse_args()

    certificate = build()

    if arguments.emit:
        arguments.emit.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
        print("wrote", arguments.emit)
        return

    if arguments.check:
        stored = json.loads(arguments.check.read_text())
        if stored != certificate:
            raise SystemExit("certificate mismatch")
        print("certificate matches")
        return

    print(json.dumps(certificate, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
