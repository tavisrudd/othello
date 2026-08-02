#!/usr/bin/env python3
"""Independent combinatorial replay of the main C794 certificate fields."""

from __future__ import annotations

import json
from collections import Counter
from fractions import Fraction
from itertools import combinations
from pathlib import Path


CERTIFICATE = Path(__file__).with_name("2026-08-02-c794-aligned-design-moments.json")


def legendre(x: int, q: int) -> int:
    x %= q
    return 0 if x == 0 else (1 if pow(x, (q - 1) // 2, q) == 1 else -1)


def edge(i: int, j: int, q: int) -> int:
    if i == 0 or j == 0:
        return 1
    return legendre((i - 1) - (j - 1), q)


def triple(i: int, j: int, k: int, q: int) -> int:
    return edge(i, j, q) * edge(i, k, q) * edge(j, k, q)


def independent_record(q: int) -> tuple[dict[str, int], Fraction]:
    v = q + 1
    d = v // 2
    blocks = []
    for four in combinations(range(v), 4):
        colors = {triple(*part, q) for part in combinations(four, 3)}
        if len(colors) == 1:
            blocks.append(frozenset(four))

    histogram: Counter[int] = Counter()
    for tail in combinations(range(1, v), d - 1):
        half = {0, *tail}
        histogram[sum(block <= half for block in blocks)] += 1
    total = sum(histogram.values())
    mean = Fraction(sum(value * count for value, count in histogram.items()), total)
    centered_three = sum(
        Fraction(count, total) * (Fraction(value) - mean) ** 3
        for value, count in histogram.items()
    )
    return {str(k): histogram[k] for k in sorted(histogram)}, centered_three


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    records = {record["vertices"]: record for record in certificate["paley_cut_moments"]}
    for q in (13, 17):
        histogram, centered_three = independent_record(q)
        expected = records[q + 1]
        assert histogram == expected["projective_cut_histogram"]
        assert {
            "numerator": centered_three.numerator,
            "denominator": centered_three.denominator,
        } == expected["third_centered_moment"]
    print("independent triangle-parity replay matches orders 14 and 18")


if __name__ == "__main__":
    main()
