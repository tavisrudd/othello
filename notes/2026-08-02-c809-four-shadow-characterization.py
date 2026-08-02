#!/usr/bin/env python3
"""Exact finite and tangent checks for C809's four-shadow theorem."""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from itertools import combinations, permutations
from pathlib import Path

EDGES = list(combinations(range(6), 2))
GAUGE_EDGES = list(combinations(range(1, 6), 2))
TRIPLES = list(combinations(range(6), 3))

GOLDEN = [
    [0, 1, 1, 1, 1, 1],
    [1, 0, 1, 1, -1, -1],
    [1, 1, 0, -1, 1, -1],
    [1, 1, -1, 0, -1, 1],
    [1, -1, 1, -1, 0, 1],
    [1, -1, -1, 1, 1, 0],
]

OPPOSITE_ORIENTATION = [
    [0, 1, 1, 1, 1, 1],
    [1, 0, -1, -1, 1, 1],
    [1, -1, 0, 1, -1, 1],
    [1, -1, 1, 0, 1, -1],
    [1, 1, -1, 1, 0, -1],
    [1, 1, 1, -1, -1, 0],
]

GENERIC = [
    [0, 2, -1, 3, 1, -2],
    [2, 0, 1, -2, 4, 1],
    [-1, 1, 0, 2, -3, 1],
    [3, -2, 2, 0, 1, 2],
    [1, 4, -3, 1, 0, -1],
    [-2, 1, 1, 2, -1, 0],
]


def determinant(matrix: list[list[int]]) -> int:
    if not matrix:
        return 1
    return sum(
        (-1) ** column
        * matrix[0][column]
        * determinant(
            [row[:column] + row[column + 1 :] for row in matrix[1:]]
        )
        for column in range(len(matrix))
    )


def permutation_sign(sequence: tuple[int, ...]) -> int:
    inversions = sum(
        sequence[i] > sequence[j]
        for i in range(len(sequence))
        for j in range(i + 1, len(sequence))
    )
    return (-1) ** inversions


def triangle_coefficient(matrix: list[list[int]], triple: tuple[int, ...]) -> int:
    i, j, k = triple
    return matrix[i][j] * matrix[j][k] * matrix[k][i]


def compound_coefficient(matrix: list[list[int]], triple: tuple[int, ...]) -> int:
    """C704 orientation for diag(* wedge^3 matrix)."""
    complement = tuple(i for i in range(6) if i not in triple)
    cross = [[matrix[i][j] for j in triple] for i in complement]
    return -permutation_sign(complement + triple) * determinant(cross)


Polynomial = dict[tuple[int, ...], int]


def polynomial_add(left: Polynomial, right: Polynomial) -> Polynomial:
    result = left.copy()
    for monomial, coefficient in right.items():
        result[monomial] = result.get(monomial, 0) + coefficient
    return {monomial: coefficient for monomial, coefficient in result.items() if coefficient}


def polynomial_multiply(left: Polynomial, right: Polynomial) -> Polynomial:
    result: Polynomial = {}
    for monomial_left, coefficient_left in left.items():
        for monomial_right, coefficient_right in right.items():
            monomial = tuple(sorted(monomial_left + monomial_right))
            if len(set(monomial)) != len(monomial):
                continue
            result[monomial] = (
                result.get(monomial, 0) + coefficient_left * coefficient_right
            )
    return result


def standard_pfaffian_polynomial(
    matrix: list[list[int]], indices: tuple[int, ...]
) -> Polynomial:
    if not indices:
        return {(): 1}
    first = indices[0]
    result: Polynomial = {}
    for position in range(1, len(indices)):
        second = indices[position]
        rest = indices[1:position] + indices[position + 1 :]
        linear = {
            (first,): matrix[first][second],
            (second,): -matrix[first][second],
        }
        term = polynomial_multiply(
            linear, standard_pfaffian_polynomial(matrix, rest)
        )
        if position % 2 == 0:
            term = {monomial: -coefficient for monomial, coefficient in term.items()}
        result = polynomial_add(result, term)
    return result


def oriented_pfaffian_coefficients(matrix: list[list[int]]) -> list[int]:
    # The global minus sign matches the Hodge orientation fixed in C704.
    standard = standard_pfaffian_polynomial(matrix, tuple(range(6)))
    return [-standard.get(triple, 0) for triple in TRIPLES]


def gauge_matrix(bits: int) -> list[list[int]]:
    matrix = [[0] * 6 for _ in range(6)]
    for i in range(1, 6):
        matrix[0][i] = matrix[i][0] = 1
    for bit, (i, j) in enumerate(GAUGE_EDGES):
        matrix[i][j] = matrix[j][i] = 1 if (bits >> bit) & 1 else -1
    return matrix


def matrix_square(matrix: list[list[int]]) -> list[list[int]]:
    return [
        [sum(matrix[i][k] * matrix[k][j] for k in range(6)) for j in range(6)]
        for i in range(6)
    ]


def is_conference(matrix: list[list[int]]) -> bool:
    return matrix_square(matrix) == [
        [5 * int(i == j) for j in range(6)] for i in range(6)
    ]


def rational_rank(matrix: list[list[int | Fraction]]) -> int:
    rows = [[Fraction(value) for value in row] for row in matrix]
    rank = 0
    for column in range(len(rows[0])):
        pivot = next(
            (row for row in range(rank, len(rows)) if rows[row][column]), None
        )
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        pivot_value = rows[rank][column]
        rows[rank] = [value / pivot_value for value in rows[rank]]
        for row in range(len(rows)):
            if row != rank and rows[row][column]:
                multiplier = rows[row][column]
                rows[row] = [
                    value - multiplier * reduced
                    for value, reduced in zip(rows[row], rows[rank])
                ]
        rank += 1
    return rank


def equality_value(
    matrix: list[list[int]], triple: tuple[int, ...], orientation: int
) -> int:
    return compound_coefficient(matrix, triple) - orientation * 4 * triangle_coefficient(
        matrix, triple
    )


def equality_jacobian(matrix: list[list[int]], orientation: int) -> list[list[int]]:
    jacobian = []
    for triple in TRIPLES:
        row = []
        for i, j in EDGES:
            changed = [entries[:] for entries in matrix]
            changed[i][j] = changed[j][i] = 1
            at_one = equality_value(changed, triple, orientation)
            changed[i][j] = changed[j][i] = 0
            at_zero = equality_value(changed, triple, orientation)
            row.append(at_one - at_zero)
        jacobian.append(row)
    return jacobian


def conference_tangent_rank(matrix: list[list[int]]) -> int:
    # Linearize A^2 = lambda I in 15 edge variables and lambda.
    equations = []
    edge_index = {edge: position for position, edge in enumerate(EDGES)}
    for i in range(6):
        for j in range(i, 6):
            row = [0] * 16
            for k in range(6):
                if k != j and i != k:
                    row[edge_index[tuple(sorted((k, j)))]] += matrix[i][k]
                if i != k and k != j:
                    row[edge_index[tuple(sorted((i, k)))]] += matrix[k][j]
            if i == j:
                row[-1] -= 1
            equations.append(row)
    return rational_rank(equations)


def graph_canonical_form(bits: int) -> int:
    positions = {edge: position for position, edge in enumerate(GAUGE_EDGES)}
    best = 1 << len(GAUGE_EDGES)
    for image in permutations(range(1, 6)):
        relabel = {i + 1: image[i] for i in range(5)}
        candidate = 0
        for bit, (i, j) in enumerate(GAUGE_EDGES):
            if (bits >> bit) & 1:
                edge = tuple(sorted((relabel[i], relabel[j])))
                candidate |= 1 << positions[edge]
        best = min(best, candidate)
    return best


def compute() -> dict[str, object]:
    generic_compound = [compound_coefficient(GENERIC, triple) for triple in TRIPLES]
    generic_pfaffian = oriented_pfaffian_coefficients(GENERIC)
    if generic_compound != generic_pfaffian:
        raise AssertionError("Pfaffian/compound identity failed")

    translation_coefficients = {}
    generic_square = matrix_square(GENERIC)
    for i, j in EDGES:
        triangle_sum = sum(
            triangle_coefficient(GENERIC, tuple(sorted((i, j, k))))
            for k in range(6)
            if k not in (i, j)
        )
        expected = GENERIC[i][j] * generic_square[i][j]
        if triangle_sum != expected:
            raise AssertionError("translation derivative identity failed")
        translation_coefficients[f"{i}{j}"] = triangle_sum

    counts = {
        "all_1024_gauge_signings": 0,
        "conference": 0,
        "oriented_compound_equals_4_triangle": 0,
        "opposite_compound_equals_minus_4_triangle": 0,
        "nonzero_proportional": 0,
        "zero_compound_shadow": 0,
    }
    zero_compound_bits = []
    oriented_matrices = []
    for bits in range(1 << len(GAUGE_EDGES)):
        matrix = gauge_matrix(bits)
        triangle = [triangle_coefficient(matrix, triple) for triple in TRIPLES]
        compound = [compound_coefficient(matrix, triple) for triple in TRIPLES]
        ratios = {Fraction(left, right) for left, right in zip(compound, triangle)}
        conference = is_conference(matrix)
        plus = ratios == {4}
        minus = ratios == {-4}
        zero = ratios == {0}
        counts["all_1024_gauge_signings"] += 1
        counts["conference"] += int(conference)
        counts["oriented_compound_equals_4_triangle"] += int(plus)
        counts["opposite_compound_equals_minus_4_triangle"] += int(minus)
        counts["nonzero_proportional"] += int(len(ratios) == 1 and ratios != {0})
        counts["zero_compound_shadow"] += int(zero)
        if zero:
            zero_compound_bits.append(bits)
        if plus:
            oriented_matrices.append(matrix)
        if conference != (plus or minus):
            raise AssertionError("nonzero proportionality did not match conference")

    zero_rank_histogram: dict[str, int] = {}
    for bits in zero_compound_bits:
        rank = str(rational_rank(gauge_matrix(bits)))
        zero_rank_histogram[rank] = zero_rank_histogram.get(rank, 0) + 1
    zero_orbits = sorted({graph_canonical_form(bits) for bits in zero_compound_bits})

    six_test_survivors = {}
    for triple in TRIPLES:
        survivors = 0
        for bits in range(1 << len(GAUGE_EDGES)):
            matrix = gauge_matrix(bits)
            square = matrix_square(matrix)
            first_row_balanced = all(square[0][i] == 0 for i in range(1, 6))
            orientation_fixed = equality_value(matrix, triple, 1) == 0
            survivors += int(first_row_balanced and orientation_fixed)
        six_test_survivors["".join(map(str, triple))] = survivors
    if set(six_test_survivors.values()) != {6}:
        raise AssertionError("six-test recognition packet failed")

    plus_rank = rational_rank(equality_jacobian(GOLDEN, 1))
    minus_rank = rational_rank(equality_jacobian(OPPOSITE_ORIENTATION, -1))
    conference_rank = conference_tangent_rank(GOLDEN)
    if plus_rank != 14 or minus_rank != 14 or conference_rank != 11:
        raise AssertionError("unexpected tangent rank")

    if counts != {
        "all_1024_gauge_signings": 1024,
        "conference": 12,
        "oriented_compound_equals_4_triangle": 6,
        "opposite_compound_equals_minus_4_triangle": 6,
        "nonzero_proportional": 12,
        "zero_compound_shadow": 172,
    }:
        raise AssertionError("unexpected signing census")

    return {
        "schema": "c809-four-shadow-characterization-v1",
        "definitions": {
            "matrix_domain": "symmetric 6x6, zero diagonal",
            "signing_gauge": "a_0i=1 for i=1,...,5; ten remaining edges in {+1,-1}",
            "hodge_orientation": "compound coefficient = -sgn(S^c,S) det A[S^c,S]",
        },
        "universal_identity_check": {
            "generic_integer_matrix": GENERIC,
            "coefficients_checked": len(TRIPLES),
            "oriented_pfaffian_equals_compound_diagonal": True,
            "translation_derivative_coefficients": translation_coefficients,
            "translation_formula": "sum_{k not i,j} tau_ijk = a_ij (A^2)_ij",
        },
        "signing_census": counts,
        "degenerate_zero_shadow": {
            "gauge_signings": len(zero_compound_bits),
            "S5_graph_isomorphism_orbits": len(zero_orbits),
            "matrix_rank_histogram": zero_rank_histogram,
        },
        "six_test_recognition_packet": {
            "tests": "five first-row balance equations plus any one oriented shadow coefficient",
            "survivors_for_each_of_20_coefficient_choices": six_test_survivors,
        },
        "tangent_ranks": {
            "variables_for_shadow_equality": 15,
            "rank_at_oriented_golden_point": plus_rank,
            "projective_tangent_dimension": 15 - plus_rank - 1,
            "rank_at_opposite_orientation": minus_rank,
            "generalized_conference_variables_including_lambda": 16,
            "generalized_conference_rank": conference_rank,
            "generalized_conference_tangent_dimension": 16 - conference_rank,
        },
        "representative": GOLDEN,
        "oriented_representatives_in_gauge": len(oriented_matrices),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    if args.write and args.check:
        parser.error("choose at most one of --write and --check")
    encoded = json.dumps(compute(), indent=2, sort_keys=True) + "\n"
    if args.write:
        args.write.write_text(encoded)
        print(f"wrote {args.write}")
    elif args.check:
        if args.check.read_text() != encoded:
            raise AssertionError(f"stale certificate: {args.check}")
        print(f"C809 certificate OK: {args.check}")
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
