#!/usr/bin/env python3
"""Exact pair-concurrence coherent closure for C817 subitem 2."""

from __future__ import annotations

import argparse
import itertools
import json
from collections import Counter
from pathlib import Path


Q = 13
RELATIONS = (0, 1, 3, 9, 10, 12)
REPRESENTATIVES = (
    (
        (1, 0, 2), (1, 0, 5), (1, 1, 3), (1, 1, 6),
        (1, 2, 9), (1, 3, 4), (1, 3, 7), (1, 6, 5),
        (1, 8, 7), (1, 11, 2), (1, 11, 12), (1, 12, 6),
    ),
    (
        (1, 0, 2), (1, 0, 5), (1, 1, 3), (1, 1, 6),
        (1, 2, 12), (1, 5, 5), (1, 6, 2), (1, 6, 4),
        (1, 8, 4), (1, 8, 6), (1, 9, 9), (1, 12, 9),
    ),
    (
        (1, 0, 2), (1, 3, 2), (1, 4, 5), (1, 1, 8),
        (1, 4, 8), (1, 1, 7), (1, 7, 12), (1, 3, 3),
        (1, 9, 11), (1, 10, 11), (1, 0, 5), (1, 8, 7),
    ),
    (
        (1, 0, 2), (1, 0, 7), (1, 1, 6), (1, 2, 11),
        (1, 3, 7), (1, 3, 11), (1, 5, 1), (1, 5, 10),
        (1, 6, 4), (1, 7, 2), (1, 8, 1), (1, 8, 6),
    ),
)


def canonical(vector: tuple[int, ...]) -> tuple[int, ...]:
    first = next(value for value in vector if value)
    inverse = pow(first, -1, Q)
    return tuple(value * inverse % Q for value in vector)


def projective_points() -> list[tuple[int, int, int]]:
    return (
        [(1, y, z) for y in range(Q) for z in range(Q)]
        + [(0, 1, z) for z in range(Q)]
        + [(0, 0, 1)]
    )


def delta(point: tuple[int, int, int]) -> int:
    x, y, z = point
    return (y * y - x * z) % Q


def internal_points() -> list[tuple[int, int, int]]:
    squares = {value * value % Q for value in range(1, Q)}
    return [
        point
        for point in projective_points()
        if delta(point) not in squares | {0}
    ]


def rho(first: tuple[int, int, int], second: tuple[int, int, int]) -> int:
    x, y, z = first
    u, v, w = second
    beta = (2 * y * v - x * w - z * u) % Q
    return beta * beta * pow(delta(first) * delta(second), -1, Q) % Q


def pgl_matrices() -> list[tuple[int, int, int, int]]:
    matrices = (
        [(1, b, c, d) for b in range(Q) for c in range(Q) for d in range(Q)]
        + [(0, 1, c, d) for c in range(Q) for d in range(Q)]
        + [(0, 0, 1, d) for d in range(Q)]
        + [(0, 0, 0, 1)]
    )
    return [
        matrix
        for matrix in matrices
        if (matrix[0] * matrix[3] - matrix[1] * matrix[2]) % Q
    ]


def act(
    matrix: tuple[int, int, int, int], point: tuple[int, int, int]
) -> tuple[int, int, int]:
    a, b, c, d = matrix
    x, y, z = point
    return canonical(
        (
            (a * a * x + 2 * a * b * y + b * b * z) % Q,
            (a * c * x + (a * d + b * c) * y + b * d * z) % Q,
            (c * c * x + 2 * c * d * y + d * d * z) % Q,
        )
    )


def coherent_refinement(colors: list[list[int]]) -> list[list[int]]:
    size = len(colors)
    signatures = []
    for first in range(size):
        for second in range(size):
            intersection_counts = Counter(
                (colors[first][middle], colors[middle][second])
                for middle in range(size)
            )
            signatures.append(
                (colors[first][second], tuple(sorted(intersection_counts.items())))
            )
    labels = {
        signature: label for label, signature in enumerate(sorted(set(signatures)))
    }
    return [
        [labels[signatures[first * size + second]] for second in range(size)]
        for first in range(size)
    ]


def incident(
    line: tuple[int, int, int], point: tuple[int, int, int]
) -> bool:
    return sum(a * b for a, b in zip(line, point)) % Q == 0


def compute() -> dict[str, object]:
    points = internal_points()
    point_index = {point: index for index, point in enumerate(points)}
    matrices = pgl_matrices()
    assert len(points) == 78
    assert len(matrices) == 2184

    orbits = []
    for representative in REPRESENTATIVES:
        orbit = {
            frozenset(point_index[act(matrix, point)] for point in representative)
            for matrix in matrices
        }
        assert len(orbit) == 91
        orbits.append(orbit)
    minimum_supports = set().union(*orbits)
    assert len(minimum_supports) == 364
    point_degrees = Counter(point for support in minimum_supports for point in support)
    assert set(point_degrees.values()) == {56}

    pair_concurrence: Counter[tuple[int, int]] = Counter()
    for support in minimum_supports:
        pair_concurrence.update(itertools.combinations(sorted(support), 2))
    assert len(pair_concurrence) == 78 * 77 // 2
    concurrence_distribution = Counter(pair_concurrence.values())
    assert concurrence_distribution == Counter({6: 1092, 7: 546, 8: 273, 9: 546, 12: 546})

    rho_to_concurrence = {
        value: sorted(
            {
                pair_concurrence[tuple(sorted((first, second)))]
                for first in range(78)
                for second in range(first)
                if rho(points[first], points[second]) == value
            }
        )
        for value in RELATIONS
    }
    assert rho_to_concurrence == {
        0: [8], 1: [6], 3: [6], 9: [12], 10: [7], 12: [9]
    }

    initial = [
        [
            -1
            if first == second
            else pair_concurrence[tuple(sorted((first, second)))]
            for second in range(78)
        ]
        for first in range(78)
    ]
    first_refinement = coherent_refinement(initial)
    stable_refinement = coherent_refinement(first_refinement)
    assert first_refinement == stable_refinement
    assert len({color for row in initial for color in row}) == 6
    assert len({color for row in first_refinement for color in row}) == 7

    refined_colors_by_rho = {
        value: sorted(
            {
                first_refinement[first][second]
                for first in range(78)
                for second in range(first)
                if rho(points[first], points[second]) == value
            }
        )
        for value in RELATIONS
    }
    assert all(len(colors) == 1 for colors in refined_colors_by_rho.values())
    assert len({colors[0] for colors in refined_colors_by_rho.values()}) == 6

    common_sevens_by_rho = {}
    for value in (1, 3):
        counts = {
            sum(
                initial[first][middle] == 7 and initial[middle][second] == 7
                for middle in range(78)
            )
            for first in range(78)
            for second in range(first)
            if rho(points[first], points[second]) == value
        }
        common_sevens_by_rho[value] = sorted(counts)
    assert common_sevens_by_rho == {1: [2], 3: [4]}

    color_eight_neighborhoods = {
        frozenset(
            second
            for second in range(78)
            if second != first and initial[first][second] == 8
        )
        for first in range(78)
    }
    assert len(color_eight_neighborhoods) == 78
    assert {len(row) for row in color_eight_neighborhoods} == {7}

    squares = {value * value % Q for value in range(1, Q)}
    passants = [
        line
        for line in projective_points()
        if (line[1] * line[1] - 4 * line[0] * line[2]) % Q
        not in squares | {0}
    ]
    incidence_rows = {
        frozenset(index for index, point in enumerate(points) if incident(line, point))
        for line in passants
    }
    polar_rows = {
        frozenset(
            index
            for index, second in enumerate(points)
            if incident(canonical((-point[2] % Q, 2 * point[1] % Q, -point[0] % Q)), second)
        )
        for point in points
    }
    assert len(passants) == 78
    assert color_eight_neighborhoods == polar_rows == incidence_rows

    return {
        "schema": "c817-pair-concurrence-closure-v1",
        "point_count": len(points),
        "minimum_support_count": len(minimum_supports),
        "minimum_orbit_sizes": [len(orbit) for orbit in orbits],
        "weighted_1_section_point_degree": 56,
        "pair_concurrence_distribution": {
            str(value): count for value, count in sorted(concurrence_distribution.items())
        },
        "rho_to_pair_concurrence": {
            str(value): concurrences for value, concurrences in rho_to_concurrence.items()
        },
        "coherent_closure_color_counts_including_diagonal": [6, 7, 7],
        "common_concurrence_7_neighbors_for_concurrence_6_pair": {
            "rho_1": 2,
            "rho_3": 4,
        },
        "coherent_closure_verdict": (
            "one refinement splits rho=1 and rho=3 and recovers all six elliptic relations"
        ),
        "color_8_neighborhood_count": len(color_eight_neighborhoods),
        "color_8_neighborhood_size": 7,
        "color_8_neighborhoods_equal_passant_incidence_rows": True,
        "automorphism_group_order_via_full_scheme_rigidity": 2184,
        "independent_closure_checks": [
            "full coherent signature refinement",
            "direct common-concurrence-7 count",
        ],
    }


def canonical_json(result: dict[str, object]) -> str:
    return json.dumps(result, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    rendered = canonical_json(compute())
    if args.write:
        args.write.write_text(rendered, encoding="utf-8")
    elif args.check:
        assert args.check.read_text(encoding="utf-8") == rendered
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
