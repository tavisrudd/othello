#!/usr/bin/env python3
"""Exact replay for C739's order-eight Paley/Hafnian parity twin."""

from collections import Counter, defaultdict
from functools import lru_cache
from itertools import combinations, permutations


N = 8
PRIME = 1_000_003
QUADRATIC_RESIDUES_MOD_7 = {1, 2, 4}


def legendre_mod_7(value):
    value %= 7
    if value == 0:
        return 0
    return 1 if value in QUADRATIC_RESIDUES_MOD_7 else -1


def paley_skew_conference():
    """Index 0 is infinity; indices 1,...,7 are F_7."""
    matrix = [[0] * N for _ in range(N)]
    for j in range(1, N):
        matrix[0][j] = 1
        matrix[j][0] = -1
    for i in range(1, N):
        for j in range(1, N):
            if i != j:
                matrix[i][j] = legendre_mod_7((j - 1) - (i - 1))
    return matrix


@lru_cache(maxsize=None)
def perfect_matchings(vertices):
    if not vertices:
        return ((),)
    first = vertices[0]
    answer = []
    for mate in vertices[1:]:
        remainder = tuple(v for v in vertices[1:] if v != mate)
        for tail in perfect_matchings(remainder):
            answer.append(((first, mate),) + tail)
    return tuple(answer)


def hafnian_difference_coefficients(matrix):
    """Expand Hf(K_ij (x_i-x_j)) in squarefree degree-four monomials."""
    coefficients = defaultdict(int)
    for matching in perfect_matchings(tuple(range(N))):
        weight = 1
        for i, j in matching:
            weight *= matrix[i][j]
        for choices in range(1 << (N // 2)):
            monomial = 0
            coefficient = weight
            for bit, (i, j) in enumerate(matching):
                if choices >> bit & 1:
                    monomial |= 1 << j
                    coefficient = -coefficient
                else:
                    monomial |= 1 << i
            coefficients[monomial] += coefficient
    return coefficients


def permute_vector(vector, subsets, subset_index, permutation):
    answer = [0] * len(subsets)
    for position, subset in enumerate(subsets):
        image = 0
        for vertex in range(N):
            if subset >> vertex & 1:
                image |= 1 << permutation[vertex]
        answer[subset_index[image]] = vector[position]
    return tuple(answer)


def modular_rank(rows):
    basis = {}
    for row in rows:
        reduced = [entry % PRIME for entry in row]
        while True:
            lead = next((i for i, entry in enumerate(reduced) if entry), None)
            if lead is None:
                break
            if lead in basis:
                factor = reduced[lead]
                reduced = [
                    (entry - factor * pivot) % PRIME
                    for entry, pivot in zip(reduced, basis[lead])
                ]
                continue
            inverse = pow(reduced[lead], PRIME - 2, PRIME)
            basis[lead] = [(entry * inverse) % PRIME for entry in reduced]
            break
    return len(basis)


def main():
    matrix = paley_skew_conference()
    assert all(
        matrix[i][j] == -matrix[j][i]
        for i in range(N)
        for j in range(N)
    )
    gram = [
        [sum(matrix[i][k] * matrix[j][k] for k in range(N)) for j in range(N)]
        for i in range(N)
    ]
    assert gram == [[7 if i == j else 0 for j in range(N)] for i in range(N)]

    coefficients = hafnian_difference_coefficients(matrix)
    subsets = tuple(
        sum(1 << vertex for vertex in subset)
        for subset in combinations(range(N), N // 2)
    )
    subset_index = {subset: position for position, subset in enumerate(subsets)}
    vector = tuple(coefficients[subset] for subset in subsets)
    assert Counter(vector) == Counter({-8: 14, 0: 42, 8: 14})

    # Translation invariance: (sum_i partial_i) H = 0 coefficientwise.
    for triple in combinations(range(N), 3):
        triple_mask = sum(1 << vertex for vertex in triple)
        derivative_coefficient = sum(
            coefficients[triple_mask | (1 << vertex)]
            for vertex in range(N)
            if not (triple_mask >> vertex & 1)
        )
        assert derivative_coefficient == 0

    positive_stabilizer = 0
    negative_stabilizer = 0
    signed_orbit = set()
    negative_vector = tuple(-entry for entry in vector)
    for permutation in permutations(range(N)):
        image = permute_vector(vector, subsets, subset_index, permutation)
        signed_orbit.add(image)
        positive_stabilizer += image == vector
        negative_stabilizer += image == negative_vector

    assert positive_stabilizer == 168
    assert negative_stabilizer == 168
    assert len(signed_orbit) == 240
    assert len(signed_orbit) // 2 == 120
    assert modular_rank(signed_orbit) == 14

    print("order-eight Paley/Hafnian audit: OK")
    print("terms: 28 nonzero (14 positive, 14 negative)")
    print("stabilizer: 168 positive + 168 negative = 336 projective")
    print("orbit: 240 signed vectors = 120 projective lines; rank 14")


if __name__ == "__main__":
    main()
