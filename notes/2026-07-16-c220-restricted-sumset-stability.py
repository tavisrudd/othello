#!/usr/bin/env python3
"""C220: finite replay for cubic restricted-sumset equality and stability."""

from __future__ import annotations

import argparse
from collections import Counter
from itertools import combinations, product
import json
import math
from pathlib import Path


def points(dimension: int) -> tuple[tuple[int, ...], ...]:
    return tuple(product(range(3), repeat=dimension))


def add(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple((a + b) % 3 for a, b in zip(left, right))


def neg(value: tuple[int, ...]) -> tuple[int, ...]:
    return tuple((-a) % 3 for a in value)


def restricted_sumset(chosen: frozenset[tuple[int, ...]]) -> frozenset[tuple[int, ...]]:
    return frozenset(add(left, right) for left, right in combinations(chosen, 2))


def defect(chosen: frozenset[tuple[int, ...]]) -> int:
    return len(restricted_sumset(chosen)) - (len(chosen) - 1)


def is_affine_coset(chosen: frozenset[tuple[int, ...]]) -> bool:
    if not chosen:
        return False
    anchor = next(iter(chosen))
    translated = frozenset(add(value, neg(anchor)) for value in chosen)
    zero = (0,) * len(anchor)
    return zero in translated and all(add(left, right) in translated
                                      for left in translated for right in translated)


def predicted_zero_defect(chosen: frozenset[tuple[int, ...]]) -> bool:
    return len(chosen) in (1, 2)


def predicted_unit_defect(chosen: frozenset[tuple[int, ...]]) -> bool:
    return (not chosen or len(chosen) == 3
            or (len(chosen) >= 4 and is_affine_coset(chosen)))


def blocker_count_at_size(group, blocker_size: int) -> int:
    """Count cubic radius-three blockers through their omitted cubic set S."""

    q = len(group)
    answer = 0
    for bits in range(1 << q):
        chosen = frozenset(group[index] for index in range(q) if bits & (1 << index))
        sums = restricted_sumset(chosen)
        required_axis_size = blocker_size - (q - len(chosen))
        if len(sums) <= required_axis_size <= q:
            answer += math.comb(q - len(sums), required_axis_size - len(sums))
    return answer


def exhaustive(dimension: int) -> dict:
    group = points(dimension)
    q = len(group)
    histogram: dict[str, dict[str, int]] = {}
    for size in range(q + 1):
        counts = Counter()
        for raw in combinations(group, size):
            chosen = frozenset(raw)
            delta = defect(chosen)
            assert (delta == 0) == predicted_zero_defect(chosen)
            assert (delta == 1) == predicted_unit_defect(chosen)
            counts[delta] += 1
        histogram[str(size)] = {str(delta): count for delta, count in sorted(counts.items())}

    minimum = blocker_count_at_size(group, q - 1)
    unit_above = blocker_count_at_size(group, q)
    assert minimum == q * (q + 1) // 2

    affine_cosets_dimension_at_least_two = 0
    if dimension >= 2:
        # Sum Gaussian-binomial counts times the number of cosets.
        for subspace_dimension in range(2, dimension + 1):
            numerator = 1
            denominator = 1
            for index in range(subspace_dimension):
                numerator *= 3 ** (dimension - index) - 1
                denominator *= 3 ** (subspace_dimension - index) - 1
            gaussian = numerator // denominator
            assert numerator % denominator == 0
            affine_cosets_dimension_at_least_two += gaussian * 3 ** (dimension - subspace_dimension)
    predicted_unit_above = (
        q * q
        + math.comb(q, 2) * (q - 1)
        + 1
        + math.comb(q, 3)
        + affine_cosets_dimension_at_least_two
    )
    assert unit_above == predicted_unit_above
    return {
        "dimension": dimension,
        "q": q,
        "defect_histogram_by_subset_size": histogram,
        "minimum_blocker_count": minimum,
        "unit_above_minimum_blocker_count": unit_above,
        "affine_cosets_of_dimension_at_least_two": affine_cosets_dimension_at_least_two,
    }


def q27_controls() -> dict:
    group = points(3)
    checked = 0
    for size in range(6):
        for raw in combinations(group, size):
            chosen = frozenset(raw)
            delta = defect(chosen)
            assert (delta == 0) == predicted_zero_defect(chosen)
            assert (delta == 1) == predicted_unit_defect(chosen)
            checked += 1

    zero = (0, 0, 0)
    subspaces = set()
    for left, right in combinations(group[1:], 2):
        span = frozenset(
            add(tuple((a * coordinate) % 3 for coordinate in left),
                tuple((b * coordinate) % 3 for coordinate in right))
            for a in range(3) for b in range(3)
        )
        if len(span) == 9:
            subspaces.add(span)
    assert len(subspaces) == 13
    cosets = {
        frozenset(add(anchor, value) for value in subspace)
        for subspace in subspaces for anchor in group
    }
    assert len(cosets) == 39
    for chosen in (*cosets, frozenset(group)):
        assert zero in group
        assert defect(chosen) == 1
        assert is_affine_coset(chosen)
    return {
        "dimension": 3,
        "q": 27,
        "exhaustive_subsets_of_size_at_most_five": checked,
        "affine_planes_checked": len(cosets),
        "whole_space_checked": True,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    certificate = {
        "task": "C220",
        "defect": "|S restricted-plus S|-(|S|-1)",
        "zero_defect_iff": "|S| is 1 or 2",
        "unit_defect_iff": "S is empty, |S| is 3, or |S|>=4 and S is an affine subspace coset",
        "exhaustive": [exhaustive(1), exhaustive(2)],
        "q27_controls": q27_controls(),
    }
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
