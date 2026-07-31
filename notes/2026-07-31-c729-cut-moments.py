#!/usr/bin/env python3
"""Exact C729 cut moments and Naimark-reflection certificates."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
import tempfile
from collections import Counter
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "notes" / "2026-07-31-c729-cut-moments.json"

BASE_C6 = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)


def determinant(matrix: list[list[int]] | tuple[tuple[int, ...], ...]) -> int:
    """Fraction-free Bareiss determinant."""
    work = [list(row) for row in matrix]
    n = len(work)
    if n == 0:
        return 1
    sign = 1
    previous = 1
    for pivot_index in range(n - 1):
        pivot_row = next(
            (row for row in range(pivot_index, n) if work[row][pivot_index]),
            None,
        )
        if pivot_row is None:
            return 0
        if pivot_row != pivot_index:
            work[pivot_index], work[pivot_row] = work[pivot_row], work[pivot_index]
            sign = -sign
        pivot = work[pivot_index][pivot_index]
        for row in range(pivot_index + 1, n):
            for column in range(pivot_index + 1, n):
                work[row][column] = (
                    work[row][column] * pivot
                    - work[row][pivot_index] * work[pivot_index][column]
                ) // previous
        previous = pivot
    return sign * work[-1][-1]


def submatrix(
    matrix: tuple[tuple[int, ...], ...], rows: tuple[int, ...], columns: tuple[int, ...]
) -> tuple[tuple[int, ...], ...]:
    return tuple(tuple(matrix[row][column] for column in columns) for row in rows)


def matmul(left: list[list[int]], right: list[list[int]]) -> list[list[int]]:
    return [
        [sum(left[i][k] * right[k][j] for k in range(len(right))) for j in range(len(right[0]))]
        for i in range(len(left))
    ]


def transpose(matrix: list[list[int]]) -> list[list[int]]:
    return [list(column) for column in zip(*matrix)]


def projective_balanced_cuts(n: int) -> list[tuple[int, ...]]:
    return [cut for cut in itertools.combinations(range(n), n // 2) if 0 in cut]


def cut_vector(n: int, cut: tuple[int, ...]) -> list[int]:
    support = set(cut)
    return [1 if vertex in support else -1 for vertex in range(n)]


def universal_cut_matrix() -> list[list[int]]:
    columns = [cut_vector(6, cut) for cut in projective_balanced_cuts(6)]
    return transpose(columns)


def derived_conference() -> tuple[tuple[int, ...], ...]:
    rows = universal_cut_matrix()
    gram = matmul(transpose(rows), rows)
    return tuple(
        tuple((gram[i][j] - 6 * int(i == j)) // 2 for j in range(10))
        for i in range(10)
    )


def check_conference(matrix: tuple[tuple[int, ...], ...]) -> None:
    n = len(matrix)
    square = matmul([list(row) for row in matrix], [list(row) for row in matrix])
    assert square == [[(n - 1) * int(i == j) for j in range(n)] for i in range(n)]


def cross_data(matrix: tuple[tuple[int, ...], ...]) -> tuple[list[tuple[int, ...]], Counter[int]]:
    n = len(matrix)
    extremal: list[tuple[int, ...]] = []
    distribution: Counter[int] = Counter()
    for cut in projective_balanced_cuts(n):
        complement = tuple(vertex for vertex in range(n) if vertex not in cut)
        value = abs(determinant(submatrix(matrix, cut, complement)))
        distribution[value] += 1
        if value:
            extremal.append(cut)
    return extremal, distribution


def frame_certificate(columns: list[list[int]], dimension: int) -> dict[str, object]:
    ambient = len(columns[0])
    count = len(columns)
    norm_squared = sum(entry * entry for entry in columns[0])
    synthesis = transpose(columns)
    gram = matmul(columns, transpose(columns))
    frame = matmul(synthesis, columns)
    tight_numerator = count * norm_squared
    assert tight_numerator % dimension == 0
    frame_bound = tight_numerator // dimension
    expected = [
        [frame_bound * int(i == j) - frame_bound // ambient for j in range(ambient)]
        for i in range(ambient)
    ]
    assert frame == expected
    absolute_inner_counts = []
    for i in range(count):
        absolute_inner_counts.append(
            Counter(abs(gram[i][j]) for j in range(count) if i != j)
        )
    assert all(counts == absolute_inner_counts[0] for counts in absolute_inner_counts)

    # The integral reflection numerator is (2d G - Nr I)/gcd of its entries.
    raw = [
        [2 * dimension * gram[i][j] - count * norm_squared * int(i == j) for j in range(count)]
        for i in range(count)
    ]
    divisor = math.gcd(*(abs(entry) for row in raw for entry in row if entry))
    reflection = [[entry // divisor for entry in row] for row in raw]
    reflection_scale = count * norm_squared // divisor
    square = matmul(reflection, reflection)
    assert square == [
        [reflection_scale**2 * int(i == j) for j in range(count)]
        for i in range(count)
    ]

    return {
        "vectors": count,
        "dimension": dimension,
        "ambient_coordinates": ambient,
        "norm_squared": norm_squared,
        "frame_bound": frame_bound,
        "absolute_inner_product_multiplicities": {
            str(value): multiplicity
            for value, multiplicity in sorted(absolute_inner_counts[0].items())
        },
        "primitive_reflection_scale": reflection_scale,
        "primitive_reflection_diagonal": sorted({reflection[i][i] for i in range(count)}),
        "primitive_reflection_off_diagonal_magnitudes": sorted(
            {abs(reflection[i][j]) for i in range(count) for j in range(count) if i != j}
        ),
    }


def antipodal_moments(
    line_count: int, norm_squared: int, inner_counts: dict[int, int], maximum_half_degree: int
) -> dict[str, str]:
    result: dict[str, str] = {}
    for degree in range(1, 2 * maximum_half_degree + 1):
        if degree % 2:
            result[str(degree)] = "0"
            continue
        numerator = norm_squared**degree + sum(
            multiplicity * inner**degree for inner, multiplicity in inner_counts.items()
        )
        result[str(degree)] = str(Fraction(numerator, line_count * norm_squared**degree))
    return result


def minor_overlap_energies(matrix: tuple[tuple[int, ...], ...]) -> dict[str, dict[str, int]]:
    n = len(matrix)
    result: dict[str, dict[str, int]] = {}
    for size in range(n // 2 + 1):
        energies: Counter[int] = Counter()
        subsets = tuple(itertools.combinations(range(n), size))
        for rows in subsets:
            row_set = set(rows)
            for columns in subsets:
                overlap = len(row_set.intersection(columns))
                value = determinant(submatrix(matrix, rows, columns))
                energies[overlap] += value * value
        assert sum(energies.values()) == math.comb(n, size) * (n - 1) ** size
        result[str(size)] = {str(overlap): value for overlap, value in sorted(energies.items())}
    return result


def binomial(n: int, k: int) -> int:
    return math.comb(n, k) if 0 <= k <= n else 0


def verify_cauchy_binet_cut_identity(
    matrix: tuple[tuple[int, ...], ...], overlap: dict[str, dict[str, int]]
) -> dict[str, object]:
    n = len(matrix)
    m = n // 2
    q = n - 1
    ordered_cut_second_moment = 0
    local_energy_profiles: Counter[tuple[int, ...]] = Counter()
    for cut in itertools.combinations(range(n), m):
        complement = tuple(vertex for vertex in range(n) if vertex not in cut)
        delta = determinant(submatrix(matrix, cut, complement))
        ordered_cut_second_moment += delta * delta
        principal = submatrix(matrix, cut, cut)
        energies = []
        for size in range(m + 1):
            energy = 0
            subsets = tuple(itertools.combinations(range(m), size))
            for rows in subsets:
                for columns in subsets:
                    minor = determinant(submatrix(principal, rows, columns))
                    energy += minor * minor
            energies.append(energy)
        reconstructed = sum(
            (-1) ** size * q ** (m - size) * energies[size]
            for size in range(m + 1)
        )
        assert reconstructed == delta * delta
        local_energy_profiles[tuple(energies)] += 1

    overlap_formula = 0
    for size_text, by_overlap in overlap.items():
        size = int(size_text)
        for overlap_text, energy in by_overlap.items():
            intersection = int(overlap_text)
            union_size = 2 * size - intersection
            overlap_formula += (
                (-1) ** size
                * q ** (m - size)
                * binomial(n - union_size, m - union_size)
                * energy
            )
    assert overlap_formula == ordered_cut_second_moment
    return {
        "ordered_balanced_halves": math.comb(n, m),
        "ordered_cut_second_moment": ordered_cut_second_moment,
        "overlap_formula_value": overlap_formula,
        "local_minor_energy_profiles": {
            ",".join(map(str, profile)): multiplicity
            for profile, multiplicity in sorted(local_energy_profiles.items())
        },
    }


def determinant_moments(distribution: Counter[int], maximum_half_degree: int) -> dict[str, int]:
    return {
        str(2 * exponent): sum(
            multiplicity * value ** (2 * exponent)
            for value, multiplicity in distribution.items()
        )
        for exponent in range(1, maximum_half_degree + 1)
    }


def generate() -> dict[str, object]:
    conference10 = derived_conference()
    check_conference(BASE_C6)
    check_conference(conference10)
    extremal10, distribution10 = cross_data(conference10)
    _, distribution6 = cross_data(BASE_C6)
    assert distribution6 == Counter({4: 10})
    assert distribution10 == Counter({0: 90, 48: 36})

    stage1_columns = transpose(universal_cut_matrix())
    stage2_columns = [cut_vector(10, cut) for cut in extremal10]
    stage1 = frame_certificate(stage1_columns, 5)
    stage2 = frame_certificate(stage2_columns, 9)
    assert stage1["absolute_inner_product_multiplicities"] == {"2": 9}
    assert stage2["absolute_inner_product_multiplicities"] == {"2": 30, "6": 5}

    overlap6 = minor_overlap_energies(BASE_C6)
    overlap10 = minor_overlap_energies(conference10)
    return {
        "schema": "c729-cut-moments-v1",
        "conference_orders": [6, 10],
        "projective_cut_determinant_distributions": {
            "6": {str(value): count for value, count in sorted(distribution6.items())},
            "10": {str(value): count for value, count in sorted(distribution10.items())},
        },
        "projective_cut_even_moment_sums": {
            "6": determinant_moments(distribution6, 4),
            "10": determinant_moments(distribution10, 4),
        },
        "minor_overlap_energies": {"6": overlap6, "10": overlap10},
        "cauchy_binet_cut_checks": {
            "6": verify_cauchy_binet_cut_identity(BASE_C6, overlap6),
            "10": verify_cauchy_binet_cut_identity(conference10, overlap10),
        },
        "reflection_stages": {"6_to_10": stage1, "10_to_36": stage2},
        "antipodal_spherical_moments": {
            "6_to_10": antipodal_moments(10, 6, {2: 9}, 4),
            "10_to_36": antipodal_moments(36, 10, {6: 5, 2: 30}, 4),
        },
        "spherical_fourth_moment_targets": {"dimension_5": "3/35", "dimension_9": "1/33"},
    }


def canonical_bytes(payload: dict[str, object]) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    if args.check == args.write:
        parser.error("choose exactly one of --check or --write")
    generated = canonical_bytes(generate())
    if args.write:
        OUTPUT.write_bytes(generated)
        return
    with tempfile.TemporaryDirectory() as directory:
        candidate = Path(directory) / OUTPUT.name
        candidate.write_bytes(generated)
        tracked = OUTPUT.read_bytes()
        assert tracked == candidate.read_bytes(), "tracked certificate is stale"
        print(f"OK {OUTPUT.relative_to(ROOT)} sha256={hashlib.sha256(tracked).hexdigest()} bytes={len(tracked)}")


if __name__ == "__main__":
    main()
