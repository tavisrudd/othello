#!/usr/bin/env python3
"""C226: exact finite replay of the cubic and axis failure transforms."""

from __future__ import annotations

import argparse
from collections import Counter
from fractions import Fraction
from hashlib import sha256
from itertools import combinations, product
import json
import math
from pathlib import Path


if not __debug__:
    raise RuntimeError("this verifier requires assertions; do not run Python with -O")


Point = tuple[int, ...]
Matrix = list[list[int]]


def group(dimension: int) -> tuple[Point, ...]:
    return tuple(product(range(3), repeat=dimension))


def add(left: Point, right: Point) -> Point:
    return tuple((a + b) % 3 for a, b in zip(left, right))


def add_three(first: Point, second: Point, third: Point) -> Point:
    return add(add(first, second), third)


def restricted_sum_indices(
    points: tuple[Point, ...], index: dict[Point, int], survivor_mask: int
) -> frozenset[int]:
    chosen = tuple(i for i in range(len(points)) if survivor_mask & (1 << i))
    return frozenset(index[add(points[i], points[j])] for i, j in combinations(chosen, 2))


def zero_sum_free(points: tuple[Point, ...], survivor_mask: int) -> bool:
    chosen = tuple(i for i in range(len(points)) if survivor_mask & (1 << i))
    zero = (0,) * len(points[0])
    return all(add_three(points[i], points[j], points[k]) != zero
               for i, j, k in combinations(chosen, 3))


def cubic_edges(points: tuple[Point, ...], index: dict[Point, int]) -> tuple[int, ...]:
    q = len(points)
    return tuple(
        (1 << i) | (1 << j) | (1 << (q + index[add(points[i], points[j])]))
        for i, j in combinations(range(q), 2)
    )


def axis_edges(points: tuple[Point, ...]) -> tuple[int, ...]:
    q = len(points)
    zero = (0,) * len(points[0])
    pairs = tuple((1 << (q + i)) | (1 << (q + j))
                  for i, j in combinations(range(q), 2))
    triples = tuple(
        (1 << i) | (1 << j) | (1 << k)
        for i, j, k in combinations(range(q), 3)
        if add_three(points[i], points[j], points[k]) == zero
    )
    return pairs + triples


def direct_failure_matrix(edges: tuple[int, ...], q: int) -> Matrix:
    """Bernstein coefficients indexed by failed cubics and failed axes."""

    helper_count = 2 * q
    succeeds = bytearray(1 << helper_count)
    for edge in edges:
        succeeds[edge] = 1
    for bit in range(helper_count):
        step = 1 << bit
        for survivor_mask in range(1 << helper_count):
            if survivor_mask & step and succeeds[survivor_mask ^ step]:
                succeeds[survivor_mask] = 1

    answer = [[0] * (q + 1) for _ in range(q + 1)]
    cubic_mask = (1 << q) - 1
    for survivor_mask, success in enumerate(succeeds):
        if success:
            continue
        cubic_survivors = (survivor_mask & cubic_mask).bit_count()
        axis_survivors = ((survivor_mask >> q) & cubic_mask).bit_count()
        answer[q - cubic_survivors][q - axis_survivors] += 1
    return answer


def cubic_transform_matrix(points: tuple[Point, ...], index: dict[Point, int]) -> Matrix:
    q = len(points)
    answer = [[0] * (q + 1) for _ in range(q + 1)]
    for survivor_mask in range(1 << q):
        sums = restricted_sum_indices(points, index, survivor_mask)
        failed_cubics = q - survivor_mask.bit_count()
        for failed_axes in range(len(sums), q + 1):
            answer[failed_cubics][failed_axes] += math.comb(
                q - len(sums), failed_axes - len(sums)
            )
    return answer


def axis_transform_matrix(points: tuple[Point, ...]) -> Matrix:
    q = len(points)
    answer = [[0] * (q + 1) for _ in range(q + 1)]
    for survivor_mask in range(1 << q):
        if not zero_sum_free(points, survivor_mask):
            continue
        failed_cubics = q - survivor_mask.bit_count()
        answer[failed_cubics][q] += 1
        answer[failed_cubics][q - 1] += q
    return answer


def matrix_hash(matrix: Matrix) -> str:
    encoded = json.dumps(matrix, separators=(",", ":")).encode()
    return sha256(encoded).hexdigest()


def leading_homogeneous_layer(matrix: Matrix) -> tuple[int, int]:
    degree = min(
        failed_cubics + failed_axes
        for failed_cubics, row in enumerate(matrix)
        for failed_axes, coefficient in enumerate(row)
        if coefficient
    )
    coefficient = sum(
        value
        for failed_cubics, row in enumerate(matrix)
        for failed_axes, value in enumerate(row)
        if failed_cubics + failed_axes == degree
    )
    return degree, coefficient


def evaluate(matrix: Matrix, p_cubic: Fraction, p_axis: Fraction) -> Fraction:
    q = len(matrix) - 1
    return sum(
        coefficient
        * p_cubic**failed_cubics
        * (1 - p_cubic) ** (q - failed_cubics)
        * p_axis**failed_axes
        * (1 - p_axis) ** (q - failed_axes)
        for failed_cubics, row in enumerate(matrix)
        for failed_axes, coefficient in enumerate(row)
    )


def summarize(dimension: int) -> dict:
    points = group(dimension)
    q = len(points)
    index = {point: i for i, point in enumerate(points)}

    cubic = cubic_edges(points, index)
    axis = axis_edges(points)
    cubic_direct = direct_failure_matrix(cubic, q)
    axis_direct = direct_failure_matrix(axis, q)
    cubic_transform = cubic_transform_matrix(points, index)
    axis_transform = axis_transform_matrix(points)
    assert cubic_direct == cubic_transform
    assert axis_direct == axis_transform

    # Both endpoints use the convention that the target itself is unavailable.
    assert cubic_direct[0][0] == axis_direct[0][0] == 0
    assert cubic_direct[q][q] == axis_direct[q][q] == 1

    defect_counts = Counter()
    maximum_zero_sum_free_size = -1
    maximum_zero_sum_free_count = 0
    for survivor_mask in range(1 << q):
        sums = restricted_sum_indices(points, index, survivor_mask)
        defect = len(sums) - (survivor_mask.bit_count() - 1)
        if defect in (0, 1):
            defect_counts[defect] += 1
        if zero_sum_free(points, survivor_mask):
            size = survivor_mask.bit_count()
            if size > maximum_zero_sum_free_size:
                maximum_zero_sum_free_size = size
                maximum_zero_sum_free_count = 1
            elif size == maximum_zero_sum_free_size:
                maximum_zero_sum_free_count += 1

    assert defect_counts[0] == q * (q + 1) // 2
    cubic_degree, cubic_coefficient = leading_homogeneous_layer(cubic_direct)
    assert (cubic_degree, cubic_coefficient) == (q - 1, q * (q + 1) // 2)

    axis_degree, axis_coefficient = leading_homogeneous_layer(axis_direct)
    assert axis_degree == 2 * q - 1 - maximum_zero_sum_free_size
    assert axis_coefficient == q * maximum_zero_sum_free_count

    sample_cubic = evaluate(cubic_direct, Fraction(1, 3), Fraction(2, 5))
    sample_axis = evaluate(axis_direct, Fraction(1, 3), Fraction(2, 5))
    return {
        "dimension": dimension,
        "q": q,
        "helper_types": {"finite_cubic": q, "finite_axis": q},
        "cubic_radius_three_edge_count": len(cubic),
        "axis_radius_three_edge_count": len(axis),
        "cubic_direct_equals_restricted_sumset_transform": True,
        "axis_direct_equals_zero_sum_free_factorization": True,
        "cubic_bivariate_bernstein_sha256": matrix_hash(cubic_direct),
        "axis_bivariate_bernstein_sha256": matrix_hash(axis_direct),
        "defect_zero_subset_count": defect_counts[0],
        "defect_one_subset_count": defect_counts[1],
        "maximum_zero_sum_free_size": maximum_zero_sum_free_size,
        "maximum_zero_sum_free_count": maximum_zero_sum_free_count,
        "homogeneous_leading_failure": {
            "cubic": {"degree": cubic_degree, "coefficient": cubic_coefficient},
            "axis": {"degree": axis_degree, "coefficient": axis_coefficient},
        },
        "endpoint_checks": {"all_helpers_survive": 0, "all_helpers_fail": 1},
        "sample_failure_probability": {
            "p_cubic": "1/3",
            "p_axis": "2/5",
            "cubic": f"{sample_cubic.numerator}/{sample_cubic.denominator}",
            "axis": f"{sample_axis.numerator}/{sample_axis.denominator}",
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    certificate = {
        "task": "C226",
        "probability_convention": (
            "the target is unavailable; p_cubic and p_axis are independent helper-erasure "
            "probabilities; Q is conditional repair-failure probability"
        ),
        "transform_checks": [summarize(1), summarize(2)],
    }
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
