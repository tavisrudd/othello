#!/usr/bin/env python3
"""Exact cross-check for the matched radius-three seed ports over F_29."""

from __future__ import annotations

import argparse
import itertools
import json
from collections import Counter
from pathlib import Path


P = 29
TARGET = 0
MATRICES = {
    "A": [
        [1, 7, 13, 19, 6, 8, 13, 3, 21, 21],
        [0, 0, 1, 0, 1, 1, 1, 0, 1, 1],
        [0, 0, 1, 1, 1, 0, 0, 1, 3, 28],
        [0, 1, 0, 2, 5, 28, 0, 3, 25, 0],
    ],
    "B": [
        [1, 19, 24, 10, 0, 23, 12, 28, 14, 23],
        [0, 1, 0, 1, 1, 1, 1, 0, 1, 0],
        [0, 0, 0, 1, 2, 1, 0, 1, 28, 1],
        [0, 28, 1, 0, 0, 3, 3, 2, 0, 28],
    ],
}
EXPECTED_EDGES = {
    "A": [(0, 1, 3), (0, 2, 6), (0, 4, 5), (1, 5, 8), (4, 7, 8)],
    "B": [(0, 1, 5), (0, 7, 8), (1, 2, 4), (1, 6, 8), (2, 3, 7)],
}


def columns(matrix: list[list[int]]) -> list[tuple[int, ...]]:
    return [tuple(row[j] % P for row in matrix) for j in range(len(matrix[0]))]


def rank(vectors: list[tuple[int, ...]]) -> int:
    if not vectors:
        return 0
    work = [list(row) for row in zip(*vectors)]
    row_count = len(work)
    column_count = len(work[0])
    pivot_row = 0
    for column in range(column_count):
        pivot = next(
            (row for row in range(pivot_row, row_count) if work[row][column] % P),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column] % P, -1, P)
        work[pivot_row] = [(entry * inverse) % P for entry in work[pivot_row]]
        for row in range(row_count):
            if row == pivot_row or not work[row][column] % P:
                continue
            scale = work[row][column] % P
            work[row] = [
                (entry - scale * pivot_entry) % P
                for entry, pivot_entry in zip(work[row], work[pivot_row])
            ]
        pivot_row += 1
        if pivot_row == row_count:
            break
    return pivot_row


def determinant_four(vectors: list[tuple[int, ...]]) -> int:
    total = 0
    for permutation in itertools.permutations(range(4)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(4)
            for j in range(i + 1, 4)
        )
        term = 1
        for row, column in enumerate(permutation):
            term = term * vectors[column][row] % P
        total += (-1 if inversions % 2 else 1) * term
    return total % P


def projective_functionals() -> itertools.chain[tuple[int, ...]]:
    pieces = []
    for pivot in range(4):
        pieces.append(
            (
                (0,) * pivot + (1,) + tail
                for tail in itertools.product(range(P), repeat=3 - pivot)
            )
        )
    return itertools.chain.from_iterable(pieces)


def code_distance(matrix: list[list[int]]) -> int:
    best = len(matrix[0])
    for functional in projective_functionals():
        word = [
            sum(functional[row] * matrix[row][column] for row in range(4)) % P
            for column in range(len(matrix[0]))
        ]
        best = min(best, sum(entry != 0 for entry in word))
    return best


def dual_distance(cols: list[tuple[int, ...]]) -> int:
    for size in range(1, 5):
        if any(rank([cols[index] for index in subset]) < size for subset in itertools.combinations(range(10), size)):
            return size
    raise AssertionError("no dependent column set through size four")


def pointed_histogram(cols: list[tuple[int, ...]]) -> dict[str, int]:
    histogram: Counter[str] = Counter()
    helpers = list(range(1, 10))
    for mask in range(1 << len(helpers)):
        subset = [helpers[index] for index in range(9) if mask & (1 << index)]
        subset_rank = rank([cols[index] for index in subset])
        pointed_rank = rank([cols[index] for index in [TARGET, *subset]])
        histogram[f"{subset_rank},{pointed_rank},{len(subset)}"] += 1
    return dict(sorted(histogram.items()))


def matching_number(edges: list[tuple[int, ...]]) -> int:
    edge_sets = [set(edge) for edge in edges]
    for size in range(len(edges), 0, -1):
        for family in itertools.combinations(edge_sets, size):
            if all(left.isdisjoint(right) for left, right in itertools.combinations(family, 2)):
                return size
    raise AssertionError("empty repair clutter")


def minimum_transversals(edges: list[tuple[int, ...]]) -> list[tuple[int, ...]]:
    edge_sets = [set(edge) for edge in edges]
    for size in range(1, 10):
        found = [
            subset
            for subset in itertools.combinations(range(9), size)
            if all(set(subset) & edge for edge in edge_sets)
        ]
        if found:
            return found
    raise AssertionError("repair clutter has no transversal")


def union_profile(edges: list[tuple[int, ...]]) -> dict[str, dict[str, int]]:
    edge_sets = [set(edge) for edge in edges]
    profile: dict[str, dict[str, int]] = {}
    for size in range(1, len(edges) + 1):
        counts = Counter(
            len(set().union(*family))
            for family in itertools.combinations(edge_sets, size)
        )
        profile[str(size)] = {str(union_size): counts[union_size] for union_size in sorted(counts)}
    return profile


def reliability_coefficients(edges: list[tuple[int, ...]]) -> dict[str, int]:
    edge_sets = [set(edge) for edge in edges]
    coefficients: Counter[int] = Counter()
    for size in range(1, len(edges) + 1):
        sign = 1 if size % 2 else -1
        for family in itertools.combinations(edge_sets, size):
            coefficients[len(set().union(*family))] += sign
    return {
        str(exponent): coefficient
        for exponent, coefficient in sorted(coefficients.items())
        if coefficient
    }


def analyze(name: str, matrix: list[list[int]]) -> dict[str, object]:
    cols = columns(matrix)
    assert rank(cols) == 4
    assert all(rank([cols[index] for index in subset]) == 3 for subset in itertools.combinations(range(10), 3))
    dependent_four = [
        subset
        for subset in itertools.combinations(range(10), 4)
        if rank([cols[index] for index in subset]) < 4
    ]
    determinant_dependent = [
        subset
        for subset in itertools.combinations(range(10), 4)
        if determinant_four([cols[index] for index in subset]) == 0
    ]
    assert dependent_four == determinant_dependent
    assert all(TARGET in subset for subset in dependent_four)
    edges = sorted(tuple(index - 1 for index in subset if index != TARGET) for subset in dependent_four)
    assert edges == EXPECTED_EDGES[name]
    transversals = minimum_transversals(edges)
    degrees = sorted(sum(vertex in edge for edge in edges) for vertex in range(9))
    return {
        "matrix_rows": matrix,
        "rank": 4,
        "parameters": [10, 4, code_distance(matrix)],
        "dual_distance": dual_distance(cols),
        "circuit_hyperplanes_through_target": [["x", *edge] for edge in edges],
        "circuit_hyperplanes_away_from_target": [],
        "repair_edges": [list(edge) for edge in edges],
        "helper_degree_multiset": degrees,
        "matching_number": matching_number(edges),
        "transversal_number": len(transversals[0]),
        "minimum_transversals": [list(subset) for subset in transversals],
        "union_profile": union_profile(edges),
        "reliability_coefficients": reliability_coefficients(edges),
        "pointed_rank_triple_histogram": pointed_histogram(cols),
    }


def payload() -> dict[str, object]:
    codes = {name: analyze(name, matrix) for name, matrix in MATRICES.items()}
    assert codes["A"]["parameters"] == codes["B"]["parameters"] == [10, 4, 6]
    assert codes["A"]["dual_distance"] == codes["B"]["dual_distance"] == 4
    assert codes["A"]["helper_degree_multiset"] == codes["B"]["helper_degree_multiset"]
    assert codes["A"]["matching_number"] == codes["B"]["matching_number"] == 2
    assert codes["A"]["transversal_number"] == codes["B"]["transversal_number"] == 2
    assert len(codes["A"]["minimum_transversals"]) == len(codes["B"]["minimum_transversals"]) == 1
    assert codes["A"]["pointed_rank_triple_histogram"] == codes["B"]["pointed_rank_triple_histogram"]
    assert codes["A"]["reliability_coefficients"] != codes["B"]["reliability_coefficients"]
    return {
        "schema_version": 1,
        "field_order": P,
        "target_label": "x",
        "helper_labels": list(range(9)),
        "codes": codes,
        "cross_checks": {
            "four_subset_rank_agrees_with_determinant": True,
            "pointed_rank_triple_histograms_equal": True,
            "reliability_coefficients_distinct": True,
        },
    }


def encoded_payload() -> bytes:
    return (json.dumps(payload(), indent=2, sort_keys=True) + "\n").encode()


def main() -> int:
    parser = argparse.ArgumentParser()
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--write", metavar="PATH", type=Path)
    action.add_argument("--check", metavar="PATH", type=Path)
    arguments = parser.parse_args()
    expected = encoded_payload()
    if arguments.write is not None:
        arguments.write.write_bytes(expected)
        return 0
    actual = arguments.check.read_bytes()
    if actual != expected:
        raise SystemExit(f"certificate drift: {arguments.check}")
    print("matched F_29 seed certificate: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
