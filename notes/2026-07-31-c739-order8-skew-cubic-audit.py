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

    adjacency = [set() for _ in systems]
    for left, right in disjoint_edges:
        adjacency[left].add(right)
        adjacency[right].add(left)

    colors = [-1] * len(systems)
    colors[0] = 0
    queue = [0]
    for vertex in queue:
        for neighbor in adjacency[vertex]:
            if colors[neighbor] == -1:
                colors[neighbor] = 1 - colors[vertex]
                queue.append(neighbor)
            assert colors[neighbor] != colors[vertex]
    assert Counter(colors) == Counter({0: 15, 1: 15})

    distance_patterns = Counter()
    for root in range(len(systems)):
        distance = [-1] * len(systems)
        distance[root] = 0
        queue = [root]
        for vertex in queue:
            for neighbor in adjacency[vertex]:
                if distance[neighbor] == -1:
                    distance[neighbor] = distance[vertex] + 1
                    queue.append(neighbor)
        assert Counter(distance) == Counter({2: 14, 1: 8, 3: 7, 0: 1})
        for vertex in range(len(systems)):
            layer_counts = tuple(
                sum(distance[neighbor] == layer for neighbor in adjacency[vertex])
                for layer in range(4)
            )
            distance_patterns[(distance[vertex], layer_counts)] += 1
    assert distance_patterns == Counter(
        {
            (0, (0, 8, 0, 0)): 30,
            (1, (1, 0, 7, 0)): 240,
            (2, (0, 4, 0, 4)): 420,
            (3, (0, 0, 8, 0)): 210,
        }
    )

    # The two color classes, with disjointness as cross-incidence, form the
    # symmetric 2-(15,8,4) complement of point-hyperplane incidence in PG(3,2).
    left_part = tuple(i for i, color in enumerate(colors) if color == 0)
    right_part = tuple(i for i, color in enumerate(colors) if color == 1)
    rows = [tuple(int(right in adjacency[left]) for right in right_part) for left in left_part]
    assert all(sum(row) == 8 for row in rows)
    assert all(dot(rows[i], rows[j]) == 4 for i, j in combinations(range(15), 2))

    return positive, negative, tuple(sorted(systems)), system_index, disjoint_edges, tuple(colors)


def verify_antiflag_gram(hafnian, positive, negative, systems, system_index, colors):
    h_vector = tuple(hafnian[subset] for subset in SUBSETS)
    line_to_edge = {}
    for permutation in permutations(range(N)):
        image = BASE.permute_vector(h_vector, SUBSETS, SUBSET_INDEX, permutation)
        first_nonzero = next(entry for entry in image if entry)
        if first_nonzero < 0:
            image = tuple(-entry for entry in image)

        endpoints = (
            system_index[permute_blocks(positive, permutation)],
            system_index[permute_blocks(negative, permutation)],
        )
        if colors[endpoints[0]] == 1:
            endpoints = endpoints[::-1]
        line_to_edge[image] = endpoints

    assert len(line_to_edge) == 120
    assert len(set(line_to_edge.values())) == 120
    lines = tuple(line_to_edge)
    assert all(dot(line, line) == 1792 for line in lines)

    absolute_distribution = Counter()
    antiflag_distribution = Counter()
    for left_index, right_index in combinations(range(len(lines)), 2):
        left = lines[left_index]
        right = lines[right_index]
        absolute_inner_product = abs(dot(left, right))
        absolute_distribution[absolute_inner_product] += 1

        point, hyperplane = line_to_edge[left]
        other_point, other_hyperplane = line_to_edge[right]
        shared_endpoint = int(point == other_point) + int(hyperplane == other_hyperplane)
        # Disjoint SQS pairs are the nonincident point-hyperplane pairs.
        first_cross = not set(systems[point]) & set(systems[other_hyperplane])
        second_cross = not set(systems[other_point]) & set(systems[hyperplane])
        antiflag_distribution[
            (shared_endpoint, tuple(sorted((first_cross, second_cross))), absolute_inner_product)
        ] += 1

    assert absolute_distribution == Counter({128: 3360, 512: 1680, 256: 1260, 1024: 840})
    assert antiflag_distribution == Counter(
        {
            (0, (False, True), 128): 3360,
            (0, (False, False), 512): 1680,
            (0, (True, True), 256): 1260,
            (1, (True, True), 1024): 840,
        }
    )
    expected_valencies = Counter({128: 56, 512: 28, 256: 21, 1024: 14})
    for line in lines:
        assert Counter(abs(dot(line, other)) for other in lines if other != line) == expected_valencies

    # A transposition generates the abelianization of S_8.  Its accumulated
    # orientation on the 120 canonical line representatives is positive, so
    # the degree-120 product of their linear forms is S_8-invariant, not skew.
    transposition = (1, 0, 2, 3, 4, 5, 6, 7)
    product_sign = 1
    for line in lines:
        image = BASE.permute_vector(line, SUBSETS, SUBSET_INDEX, transposition)
        first_nonzero = next(entry for entry in image if entry)
        if first_nonzero < 0:
            image = tuple(-entry for entry in image)
            product_sign = -product_sign
        assert image in line_to_edge
    assert product_sign == 1


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
    positive, negative, systems, system_index, _, colors = verify_steiner_pair(hafnian)
    verify_antiflag_gram(hafnian, positive, negative, systems, system_index, colors)
    evaluation_distribution = verify_skew_cubic(hafnian)
    assert evaluation_distribution == Counter(
        {-16: 22, 16: 20, 32: 14, -32: 14, -64: 11, 64: 10, -80: 8, 80: 6}
    )
    print("order-eight Paley/skew-cubic audit: OK")
    print("designs: 30 SQS(8), disjointness degree 8, 120 edges")
    print("geometry: PG(3,2) nonincidence graph, array {8,7,4;1,4,8}")
    print("Gram cosines: 1/14, 1/7, 2/7, 4/7 with valencies 56,21,28,14")
    print("polar fixed point: F(h)=2408448, gradient F(h)=4032 h")
    print("Hessian: 8064, 5760, (-1152 +/- 1728 sqrt(2)) each x6")
    print("projective tangent signature: (1 positive, 12 negative)")


if __name__ == "__main__":
    main()
