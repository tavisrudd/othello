#!/usr/bin/env python3
"""Exact C794 certificate for aligned-design reconstruction and cut moments."""

from __future__ import annotations

import argparse
import json
from collections import Counter
from fractions import Fraction
from itertools import combinations
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-08-02-c794-aligned-design-moments.json"


def matmul(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    return [
        [sum(a[i][k] * b[k][j] for k in range(len(b))) for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def transpose(a: list[list[int]]) -> list[list[int]]:
    return [list(column) for column in zip(*a)]


def identity(n: int, scale: int) -> list[list[int]]:
    return [[scale * int(i == j) for j in range(n)] for i in range(n)]


def paley_conference(q: int) -> list[list[int]]:
    def character(x: int) -> int:
        x %= q
        if x == 0:
            return 0
        return 1 if pow(x, (q - 1) // 2, q) == 1 else -1

    return [
        [
            0
            if i == j
            else 1
            if i == 0 or j == 0
            else character((i - 1) - (j - 1))
            for j in range(q + 1)
        ]
        for i in range(q + 1)
    ]


def universal_order_ten() -> list[list[int]]:
    columns = []
    for tail in combinations(range(1, 6), 2):
        half = {0, *tail}
        columns.append([1 if i in half else -1 for i in range(6)])
    gram = matmul(columns, transpose(columns))
    return [
        [(gram[i][j] - 6 * int(i == j)) // 2 for j in range(10)]
        for i in range(10)
    ]


def triangle_sign(matrix: list[list[int]], triple: tuple[int, int, int]) -> int:
    a, b, c = triple
    return matrix[a][b] * matrix[a][c] * matrix[b][c]


def four_cycle_sum(matrix: list[list[int]], four: tuple[int, int, int, int]) -> int:
    a, b, c, d = four
    return (
        matrix[a][b] * matrix[b][c] * matrix[c][d] * matrix[d][a]
        + matrix[a][b] * matrix[b][d] * matrix[d][c] * matrix[c][a]
        + matrix[a][c] * matrix[c][b] * matrix[b][d] * matrix[d][a]
    )


def aligned_blocks(matrix: list[list[int]]) -> list[int]:
    blocks = []
    for four in combinations(range(len(matrix)), 4):
        cycle_test = four_cycle_sum(matrix, four) == 3
        signs = {triangle_sign(matrix, triple) for triple in combinations(four, 3)}
        parity_test = len(signs) == 1
        assert cycle_test == parity_test
        if cycle_test:
            blocks.append(sum(1 << vertex for vertex in four))
    return blocks


def fraction_record(value: Fraction) -> dict[str, int]:
    return {"numerator": value.numerator, "denominator": value.denominator}


def gf2_rank(rows: list[int]) -> int:
    pivots: dict[int, int] = {}
    for row in rows:
        while row:
            pivot = row.bit_length() - 1
            if pivot in pivots:
                row ^= pivots[pivot]
            else:
                pivots[pivot] = row
                break
    return len(pivots)


def order_ten_reconstruction() -> dict[str, object]:
    matrix = universal_order_ten()
    assert matrix == transpose(matrix)
    assert matmul(matrix, matrix) == identity(10, 9)
    blocks = aligned_blocks(matrix)
    assert len(blocks) == 30

    owner: dict[int, int] = {}
    colors = 0
    for block_index, block in enumerate(blocks):
        vertices = tuple(i for i in range(10) if block >> i & 1)
        color = int(triangle_sign(matrix, next(combinations(vertices, 3))) == -1)
        colors |= color << block_index
        for triple in combinations(vertices, 3):
            mask = sum(1 << vertex for vertex in triple)
            assert mask not in owner
            owner[mask] = block_index
    assert len(owner) == comb(10, 3)

    block_set = set(blocks)
    equations = []
    for four in combinations(range(10), 4):
        four_mask = sum(1 << vertex for vertex in four)
        if four_mask in block_set:
            continue
        row = 0
        for triple in combinations(four, 3):
            triple_mask = sum(1 << vertex for vertex in triple)
            row ^= 1 << owner[triple_mask]
        equations.append(row)

    rank = gf2_rank(equations)
    all_ones = (1 << len(blocks)) - 1
    assert rank == 28
    assert all((row & colors).bit_count() % 2 == 0 for row in equations)
    assert all((row & all_ones).bit_count() % 2 == 0 for row in equations)
    assert colors not in (0, all_ones)

    return {
        "vertices": 10,
        "aligned_blocks": len(blocks),
        "triple_degree": 1,
        "triple_overlap_components": {"size": 4, "count": 30},
        "nonblock_parity_equations": len(equations),
        "gf2_rank": rank,
        "gf2_nullity": len(blocks) - rank,
        "admissible_nonconstant_color_weights": sorted(
            [colors.bit_count(), (colors ^ all_ones).bit_count()]
        ),
    }


def union_profile(blocks: list[int], arity: int) -> Counter[int]:
    if arity == 2:
        return Counter((a | b).bit_count() for a, b in combinations(blocks, 2))
    if arity == 3:
        return Counter(
            (a | b | c).bit_count() for a, b, c in combinations(blocks, 3)
        )
    raise ValueError(arity)


def inclusion_probability(v: int, d: int, union_size: int) -> Fraction:
    if union_size > d:
        return Fraction(0)
    return Fraction(comb(v - union_size, d - union_size), comb(v, d))


def cut_moment_record(matrix: list[list[int]]) -> dict[str, object]:
    v = len(matrix)
    d = v // 2
    assert matrix == transpose(matrix)
    assert matmul(matrix, matrix) == identity(v, v - 1)
    blocks = aligned_blocks(matrix)

    triple_degrees = Counter()
    for block in blocks:
        vertices = tuple(i for i in range(v) if block >> i & 1)
        for triple in combinations(vertices, 3):
            triple_degrees[triple] += 1
    assert len(triple_degrees) == comb(v, 3)
    assert len(set(triple_degrees.values())) == 1

    histogram: Counter[int] = Counter()
    for tail in combinations(range(1, v), d - 1):
        half = 1 | sum(1 << vertex for vertex in tail)
        histogram[sum((block & half) == block for block in blocks)] += 1

    pair_profile = union_profile(blocks, 2)
    triple_profile = union_profile(blocks, 3)
    factorial_one = Fraction(len(blocks)) * inclusion_probability(v, d, 4)
    factorial_two = sum(
        2 * count * inclusion_probability(v, d, size)
        for size, count in pair_profile.items()
    )
    factorial_three = sum(
        6 * count * inclusion_probability(v, d, size)
        for size, count in triple_profile.items()
    )
    raw_two = factorial_two + factorial_one
    raw_three = factorial_three + 3 * factorial_two + factorial_one
    variance = raw_two - factorial_one**2
    centered_three = raw_three - 3 * factorial_one * raw_two + 2 * factorial_one**3

    sample_size = sum(histogram.values())
    empirical_mean = Fraction(sum(k * count for k, count in histogram.items()), sample_size)
    empirical_variance = sum(
        Fraction(count, sample_size) * (Fraction(k) - empirical_mean) ** 2
        for k, count in histogram.items()
    )
    empirical_third = sum(
        Fraction(count, sample_size) * (Fraction(k) - empirical_mean) ** 3
        for k, count in histogram.items()
    )
    assert (factorial_one, variance, centered_three) == (
        empirical_mean,
        empirical_variance,
        empirical_third,
    )

    return {
        "vertices": v,
        "half_size": d,
        "aligned_blocks": len(blocks),
        "triple_degree": next(iter(triple_degrees.values())),
        "projective_cut_histogram": {str(k): histogram[k] for k in sorted(histogram)},
        "unordered_pair_union_profile": {
            str(k): pair_profile[k] for k in sorted(pair_profile)
        },
        "unordered_triple_union_profile": {
            str(k): triple_profile[k] for k in sorted(triple_profile)
        },
        "factorial_moments": {
            "one": fraction_record(factorial_one),
            "two": fraction_record(factorial_two),
            "three": fraction_record(factorial_three),
        },
        "variance": fraction_record(variance),
        "third_centered_moment": fraction_record(centered_three),
    }


def generate() -> dict[str, object]:
    return {
        "schema": "c794-aligned-design-moments-v1",
        "order_ten_reconstruction": order_ten_reconstruction(),
        "paley_cut_moments": [
            cut_moment_record(paley_conference(13)),
            cut_moment_record(paley_conference(17)),
        ],
    }


def canonical_bytes(value: dict[str, object]) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    generated = canonical_bytes(generate())
    if args.check:
        assert CERTIFICATE.read_bytes() == generated
        print("certificate matches exact regeneration")
    else:
        CERTIFICATE.write_bytes(generated)
        print(CERTIFICATE)


if __name__ == "__main__":
    main()
