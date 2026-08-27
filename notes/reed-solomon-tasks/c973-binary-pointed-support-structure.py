#!/usr/bin/env python3
"""Analyze affine divisor types in the exact binary pointed certificates."""

from __future__ import annotations

import argparse
import importlib.util
import json
from collections import Counter
from itertools import combinations
from pathlib import Path


HERE = Path(__file__).resolve().parent
C531_PATH = HERE.parent / "2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata.py"
SPEC = importlib.util.spec_from_file_location("c531_supports", C531_PATH)
assert SPEC is not None and SPEC.loader is not None
C531 = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(C531)


FIELDS = [
    (16, 0b10011, HERE / "c973-r11-gf16-pointed-quotient.json"),
    (32, 0b100101, HERE / "c973-r11-gf32-pointed-quotient.json"),
]


def affine_image(
    support: tuple[int, ...], scale: int, translate: int, modulus: int
) -> tuple[int, ...]:
    return tuple(
        sorted(C531.gf_mul(scale, root, modulus) ^ translate for root in support)
    )


def canonical_affine_support(
    support: tuple[int, ...], q: int, modulus: int
) -> tuple[int, ...]:
    return min(
        affine_image(support, scale, translate, modulus)
        for scale in range(1, q)
        for translate in range(q)
    )


def three_spaces(q: int) -> list[tuple[int, ...]]:
    spaces = set()
    for a, b, c in combinations(range(1, q), 3):
        span = tuple(sorted({0, a, b, c, a ^ b, a ^ c, b ^ c, a ^ b ^ c}))
        if len(span) == 8:
            spaces.add(span)
    return sorted(spaces)


def affine_three_spaces(q: int) -> list[tuple[int, ...]]:
    cosets = set()
    for space in three_spaces(q):
        for translate in range(q):
            cosets.add(tuple(sorted(value ^ translate for value in space)))
    return sorted(cosets)


def root_polynomial(roots: tuple[int, ...], modulus: int) -> list[int]:
    coefficients = [1]
    for root in roots:
        extended = [0] * (len(coefficients) + 1)
        for index, coefficient in enumerate(coefficients):
            extended[index] ^= C531.gf_mul(coefficient, root, modulus)
            extended[index + 1] ^= coefficient
        coefficients = extended
    return coefficients


def locator_rows(support: tuple[int, ...], modulus: int) -> tuple[tuple[int, ...], tuple[int, ...]]:
    coefficients = root_polynomial(support, modulus)
    return tuple(coefficients[2:7]), tuple(coefficients[3:8])


def dot(left: tuple[int, ...], right: tuple[int, ...], modulus: int) -> int:
    value = 0
    for x, y in zip(left, right):
        value ^= C531.gf_mul(x, y, modulus)
    return value


def additive_plus_one_rows(q: int, modulus: int) -> list[tuple[tuple[int, ...], tuple[int, ...]]]:
    rows = set()
    for coset in affine_three_spaces(q):
        coset_set = set(coset)
        for extra in range(q):
            if extra not in coset_set:
                rows.add(locator_rows(tuple(sorted((*coset, extra))), modulus))
    return sorted(rows)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--details", action="store_true")
    args = parser.parse_args()
    summaries = []
    for q, modulus, path in FIELDS:
        data = json.loads(path.read_text())
        representatives = [tuple(record["representative"]) for record in data["records"]]
        types = Counter(
            canonical_affine_support(tuple(record["support"]), q, modulus)
            for record in data["records"]
        )
        affine_spaces = affine_three_spaces(q)
        additive_rows = additive_plus_one_rows(q, modulus)
        uncovered = [
            representative
            for representative in representatives
            if not any(
                dot(representative, row0, modulus) == 0
                and dot(representative, row1, modulus) == 0
                for row0, row1 in additive_rows
            )
        ]
        summary = {
                "field_order": q,
                "pointed_orbits": len(data["records"]),
                "affine_support_types": len(types),
                "largest_type_multiplicity": max(types.values()),
                "affine_three_spaces": len(affine_spaces),
                "additive_plus_one_row_pairs": len(additive_rows),
                "additive_plus_one_uncovered_orbits": len(uncovered),
                "first_uncovered": [list(point) for point in uncovered[:10]],
            }
        if args.details:
            summary["top_types"] = [
                    {"support": list(support), "multiplicity": multiplicity}
                    for support, multiplicity in types.most_common(10)
                ]
        summaries.append(summary)
    print(json.dumps(summaries, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
