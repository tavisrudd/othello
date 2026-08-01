#!/usr/bin/env python3
"""Exact C739 replay for the Paley orbit and HMSV's normalized skew cubic."""

from collections import Counter, defaultdict
from fractions import Fraction
from importlib.util import module_from_spec, spec_from_file_location
from itertools import combinations, permutations
from pathlib import Path


N = 8
DIMENSION = 14


def load_hafnian_audit():
    path = Path(__file__).with_name("2026-07-31-c739-order8-hafnian-audit.py")
    spec = spec_from_file_location("c739_order8_hafnian_audit", path)
    module = module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


BASE = load_hafnian_audit()
SUBSETS = tuple(
    sum(1 << vertex for vertex in subset)
    for subset in combinations(range(N), N // 2)
)
SUBSET_INDEX = {subset: position for position, subset in enumerate(SUBSETS)}


def matching_vector(matching):
    """Coefficient vector of prod_(ij in M) (x_i-x_j)."""
    vector = [0] * len(SUBSETS)
    for choices in range(1 << (N // 2)):
        monomial = 0
        coefficient = 1
        for bit, (i, j) in enumerate(matching):
            if choices >> bit & 1:
                monomial |= 1 << j
                coefficient = -coefficient
            else:
                monomial |= 1 << i
        vector[SUBSET_INDEX[monomial]] += coefficient
    return tuple(vector)


def matching_sign(matching):
    word = tuple(vertex for edge in matching for vertex in edge)
    inversions = sum(
        word[i] > word[j]
        for i in range(N)
        for j in range(i + 1, N)
    )
    return -1 if inversions % 2 else 1


def is_noncrossing(matching):
    return not any(a < c < b < d for a, b in matching for c, d in matching)


def dot(left, right):
    return sum(a * b for a, b in zip(left, right))


def matrix_multiply(left, right):
    size = len(left)
    return [
        [sum(left[i][k] * right[k][j] for k in range(size)) for j in range(size)]
        for i in range(size)
    ]


def matrix_add(left, right):
    return [
        [left[i][j] + right[i][j] for j in range(len(left))]
        for i in range(len(left))
    ]


def scalar_identity(scalar, size=DIMENSION):
    return [[Fraction(scalar if i == j else 0) for j in range(size)] for i in range(size)]


def rational_rank(matrix):
    reduced = [[Fraction(entry) for entry in row] for row in matrix]
    row = 0
    for column in range(len(reduced[0])):
        pivot = next(
            (candidate for candidate in range(row, len(reduced)) if reduced[candidate][column]),
            None,
        )
        if pivot is None:
            continue
        reduced[row], reduced[pivot] = reduced[pivot], reduced[row]
        scale = reduced[row][column]
        reduced[row] = [entry / scale for entry in reduced[row]]
        for other in range(len(reduced)):
            if other == row or not reduced[other][column]:
                continue
            scale = reduced[other][column]
            reduced[other] = [
                entry - scale * pivot_entry
                for entry, pivot_entry in zip(reduced[other], reduced[row])
            ]
        row += 1
        if row == len(reduced):
            break
    return row


def solve_left(gram, bilinear):
    """Return gram^{-1} bilinear by exact row reduction."""
    size = len(gram)
    augmented = [
        [Fraction(entry) for entry in gram[i]]
        + [Fraction(entry) for entry in bilinear[i]]
        for i in range(size)
    ]
    for column in range(size):
        pivot = next(row for row in range(column, size) if augmented[row][column])
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        scale = augmented[column][column]
        augmented[column] = [entry / scale for entry in augmented[column]]
        for row in range(size):
            if row == column or not augmented[row][column]:
                continue
            scale = augmented[row][column]
            augmented[row] = [
                entry - scale * pivot_entry
                for entry, pivot_entry in zip(augmented[row], augmented[column])
            ]
    return [row[size:] for row in augmented]


def permute_blocks(blocks, permutation):
    answer = []
    for block in blocks:
        image = 0
        for vertex in range(N):
            if block >> vertex & 1:
                image |= 1 << permutation[vertex]
        answer.append(image)
    return tuple(sorted(answer))


def verify_steiner_pair(hafnian):
    positive = tuple(sorted(subset for subset in SUBSETS if hafnian[subset] == 8))
    negative = tuple(sorted(subset for subset in SUBSETS if hafnian[subset] == -8))
    assert len(positive) == len(negative) == 14
    assert not set(positive) & set(negative)

    for system in (positive, negative):
        triple_counts = Counter()
        for block in system:
            vertices = tuple(vertex for vertex in range(N) if block >> vertex & 1)
            triple_counts.update(combinations(vertices, 3))
        assert len(triple_counts) == 56
        assert set(triple_counts.values()) == {1}

    systems = {
        permute_blocks(positive, permutation)
        for permutation in permutations(range(N))
    }
    assert len(systems) == 30
    system_index = {system: index for index, system in enumerate(sorted(systems))}
    disjoint_edges = {
        tuple(sorted((system_index[left], system_index[right])))
        for left, right in combinations(systems, 2)
        if not set(left) & set(right)
    }
    assert len(disjoint_edges) == 120
    degrees = Counter(vertex for edge in disjoint_edges for vertex in edge)
    assert Counter(degrees.values()) == Counter({8: 30})

    paley_edges = {
        tuple(
            sorted(
                (
                    system_index[permute_blocks(positive, permutation)],
                    system_index[permute_blocks(negative, permutation)],
                )
            )
        )
        for permutation in permutations(range(N))
    }
    assert paley_edges == disjoint_edges
    return positive, negative


def verify_skew_cubic(hafnian):
    """Use F=sum_M epsilon(M) Gamma_M^3, HMSV's cubic up to scale."""
    matchings = BASE.perfect_matchings(tuple(range(N)))
    matching_vectors = tuple(matching_vector(matching) for matching in matchings)
    signs = tuple(matching_sign(matching) for matching in matchings)
    h_vector = tuple(hafnian[subset] for subset in SUBSETS)
    evaluations = tuple(dot(h_vector, vector) for vector in matching_vectors)

    cubic_value = sum(
        sign * evaluation**3
        for sign, evaluation in zip(signs, evaluations)
    )
    gradient = tuple(
        3
        * sum(
            sign * evaluation**2 * vector[position]
            for sign, evaluation, vector in zip(signs, evaluations, matching_vectors)
        )
        for position in range(len(SUBSETS))
    )
    assert cubic_value == 2_408_448
    assert gradient == tuple(4032 * coefficient for coefficient in h_vector)
    assert dot(h_vector, gradient) == 3 * cubic_value

    support = {subset for subset in SUBSETS if hafnian[subset]}
    companion = tuple(2 if subset not in support else -3 for subset in SUBSETS)
    assert dot(h_vector, companion) == 0

    def hessian_apply(vector):
        return tuple(
            6
            * sum(
                sign
                * evaluation
                * dot(vector, matching_vector_value)
                * matching_vector_value[position]
                for sign, evaluation, matching_vector_value in zip(
                    signs, evaluations, matching_vectors
                )
            )
            for position in range(len(SUBSETS))
        )

    assert hessian_apply(h_vector) == tuple(8064 * value for value in h_vector)
    assert hessian_apply(companion) == tuple(5760 * value for value in companion)

    basis = tuple(
        matching_vector(matching)
        for matching in matchings
        if is_noncrossing(matching)
    )
    assert len(basis) == DIMENSION
    gram = [[dot(left, right) for right in basis] for left in basis]
    pairings = [
        [dot(basis_vector, matching_vector_value) for matching_vector_value in matching_vectors]
        for basis_vector in basis
    ]
    hessian_bilinear = [
        [
            6
            * sum(
                signs[k] * evaluations[k] * pairings[i][k] * pairings[j][k]
                for k in range(len(matchings))
            )
            for j in range(DIMENSION)
        ]
        for i in range(DIMENSION)
    ]
    operator = solve_left(gram, hessian_bilinear)
    assert all(entry.denominator == 1 for row in operator for entry in row)

    identity = scalar_identity(1)
    linear_8064 = matrix_add(operator, scalar_identity(-8064))
    linear_5760 = matrix_add(operator, scalar_identity(-5760))
    square = matrix_multiply(operator, operator)
    quadratic = matrix_add(
        matrix_add(square, [[2304 * entry for entry in row] for row in operator]),
        scalar_identity(-4_644_864),
    )
    annihilator = matrix_multiply(
        matrix_multiply(linear_8064, linear_5760), quadratic
    )
    assert annihilator == [[Fraction(0) for _ in range(DIMENSION)] for _ in range(DIMENSION)]
    assert rational_rank(linear_8064) == 13
    assert rational_rank(linear_5760) == 13
    assert rational_rank(quadratic) == 2

    # The Hessian spectrum is 8064, 5760, and -1152 +/- 1728 sqrt(2),
    # the last two each with multiplicity six.  Subtracting the Lagrange
    # multiplier 4032 leaves tangent signature (1 positive, 12 negative).
    assert 1728 > 0
    assert -5184 + 1728 * Fraction(3, 2) < 0  # sqrt(2) < 3/2

    return Counter(evaluations)


def main():
    matrix = BASE.paley_skew_conference()
    hafnian = BASE.hafnian_difference_coefficients(matrix)
    verify_steiner_pair(hafnian)
    evaluation_distribution = verify_skew_cubic(hafnian)
    assert evaluation_distribution == Counter(
        {-16: 22, 16: 20, 32: 14, -32: 14, -64: 11, 64: 10, -80: 8, 80: 6}
    )
    print("order-eight Paley/skew-cubic audit: OK")
    print("designs: 30 SQS(8), disjointness degree 8, 120 edges")
    print("polar fixed point: F(h)=2408448, gradient F(h)=4032 h")
    print("Hessian: 8064, 5760, (-1152 +/- 1728 sqrt(2)) each x6")
    print("projective tangent signature: (1 positive, 12 negative)")


if __name__ == "__main__":
    main()
