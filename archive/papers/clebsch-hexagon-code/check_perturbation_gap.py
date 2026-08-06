#!/usr/bin/env python3
"""Exact local perturbation census for the Clebsch six-arc in PG(2,11).

This standalone, standard-library-only checker concerns only the local graph
whose edges replace one vertex of the displayed six-arc by one new projective
point while retaining the arc condition.  It does *not* assert a global
nearest-class or global metric theorem.

All projective and quadratic calculations are exact over F_11.  The final
assertions are the expected-output contract; a regression exits nonzero.
"""

from __future__ import annotations

from collections import Counter
from dataclasses import dataclass
from itertools import combinations, product

from check_code_automorphisms import matrix_vec, projective_lifts


Q = 11


Point = tuple[int, int, int]
Arc = frozenset[Point]


@dataclass(frozen=True)
class OrbitSummary:
    size: int
    fixed_conic_symmetric_difference: int
    surviving_fixed_conic_points: int
    uncovered_points: int
    distinct_replacements: int
    replacements_per_deleted_vertex: int
    deletions_per_replacement: int
    replacement_point_orbit_size: int
    replacement_point_orbit_minimum: Point
    polar_incident: bool
    deleted_replacement_line_conic_points: int
    other_base_vertices_on_deleted_replacement_line: int
    representative_deleted: Point
    representative_replacement: Point


def inv(x: int) -> int:
    assert x % Q
    return pow(x, -1, Q)


def canonical(v: Point) -> Point:
    """Canonical representative with first nonzero coordinate equal to one."""
    assert any(x % Q for x in v)
    pivot = next(x % Q for x in v if x % Q)
    scale = inv(pivot)
    return tuple(scale * x % Q for x in v)  # type: ignore[return-value]


PROJECTIVE_POINTS: tuple[Point, ...] = tuple(
    [(1, y, z) for y, z in product(range(Q), repeat=2)]
    + [(0, 1, z) for z in range(Q)]
    + [(0, 0, 1)]
)
PROJECTIVE_POINT_SET = frozenset(PROJECTIVE_POINTS)

BASE_ARC: Arc = frozenset(
    {
        (1, 10, 0),
        (1, 9, 1),
        (1, 4, 7),
        (1, 8, 5),
        (0, 1, 4),
        (1, 1, 7),
    }
)

STANDARD_CONIC: frozenset[Point] = frozenset(
    point
    for point in PROJECTIVE_POINTS
    if (point[0] * point[2] - point[1] * point[1]) % Q == 0
)


def determinant(a: Point, b: Point, c: Point) -> int:
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % Q


def is_arc(points: Arc) -> bool:
    return len(points) == 6 and all(
        determinant(a, b, c) != 0 for a, b, c in combinations(points, 3)
    )


def uncovered_locus(arc: Arc) -> frozenset[Point]:
    """Points off the arc and off every secant of the arc."""
    assert is_arc(arc)
    secants = tuple(combinations(arc, 2))
    return frozenset(
        point
        for point in PROJECTIVE_POINTS
        if point not in arc
        and all(determinant(point, a, b) != 0 for a, b in secants)
    )


def quadratic_features(point: Point) -> tuple[int, int, int, int, int, int]:
    x, y, z = point
    return (x * x % Q, x * y % Q, x * z % Q, y * y % Q, y * z % Q, z * z % Q)


def rank_mod_q(rows: list[list[int]], columns: int) -> int:
    matrix = [[x % Q for x in row] for row in rows]
    rank = 0
    for column in range(columns):
        pivot = next(
            (row for row in range(rank, len(matrix)) if matrix[row][column] % Q),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        scale = inv(matrix[rank][column])
        matrix[rank] = [scale * x % Q for x in matrix[rank]]
        for row in range(len(matrix)):
            if row == rank:
                continue
            coefficient = matrix[row][column]
            if coefficient:
                matrix[row] = [
                    (x - coefficient * y) % Q
                    for x, y in zip(matrix[row], matrix[rank])
                ]
        rank += 1
    return rank


def lies_on_a_conic(points: frozenset[Point]) -> bool:
    """Whether some nonzero homogeneous quadratic, degenerate allowed, vanishes."""
    evaluation = [list(quadratic_features(point)) for point in points]
    return rank_mod_q(evaluation, 6) < 6


def local_neighbors() -> tuple[list[int], set[Arc]]:
    counts = []
    neighbors: set[Arc] = set()
    # Sort only to make the deleted-vertex traversal and diagnostics deterministic.
    for deleted in sorted(BASE_ARC):
        retained = set(BASE_ARC)
        retained.remove(deleted)
        legal = []
        for replacement in PROJECTIVE_POINTS:
            # A replacement is genuinely new; putting the deleted point back is
            # not an edge in the one-point-replacement graph.
            if replacement in BASE_ARC:
                continue
            candidate = frozenset(retained | {replacement})
            if is_arc(candidate):
                legal.append(candidate)
        counts.append(len(legal))
        neighbors.update(legal)
    return counts, neighbors


def stabilizer_projectivities() -> tuple[tuple[tuple[int, ...], ...], ...]:
    """The 60 exact projective lifts of the Clebsch-arc stabilizer."""
    lifts = projective_lifts()
    matrices = tuple(lifts[permutation][0] for permutation in sorted(lifts))
    assert len(matrices) == 60
    assert len(set(matrices)) == 60
    return matrices


def projectivity_image(
    matrix: tuple[tuple[int, ...], ...], point: Point
) -> Point:
    return canonical(matrix_vec(matrix, point))  # type: ignore[arg-type]


def projectivity_arc_image(
    matrix: tuple[tuple[int, ...], ...], arc: Arc
) -> Arc:
    return frozenset(projectivity_image(matrix, point) for point in arc)


def neighbor_incidence(neighbor: Arc) -> tuple[Point, Point]:
    deleted = BASE_ARC - neighbor
    replacement = neighbor - BASE_ARC
    assert len(deleted) == len(replacement) == 1
    return min(deleted), min(replacement)


def polar_incident(a: Point, b: Point) -> bool:
    """Incidence for the polarity of XZ-Y^2."""
    return (a[0] * b[2] + a[2] * b[0] - 2 * a[1] * b[1]) % Q == 0


def line_conic_point_count(a: Point, b: Point) -> int:
    return sum(determinant(a, b, point) == 0 for point in STANDARD_CONIC)


def other_base_vertices_on_line(deleted: Point, replacement: Point) -> int:
    return sum(
        determinant(deleted, replacement, point) == 0
        for point in BASE_ARC
        if point != deleted
    )


def local_neighbor_orbits(
    neighbors: set[Arc],
    matrices: tuple[tuple[tuple[int, ...], ...], ...],
) -> tuple[frozenset[Arc], ...]:
    """Partition the local neighbors into closed stabilizer orbits."""
    remaining = set(neighbors)
    orbits = []
    while remaining:
        representative = min(remaining, key=lambda arc: tuple(sorted(arc)))
        orbit = frozenset(
            projectivity_arc_image(matrix, representative) for matrix in matrices
        )
        assert orbit <= neighbors
        assert all(
            projectivity_arc_image(matrix, neighbor) in orbit
            for matrix in matrices
            for neighbor in orbit
        )
        orbits.append(orbit)
        remaining.difference_update(orbit)
    assert frozenset().union(*orbits) == neighbors
    assert sum(len(orbit) for orbit in orbits) == len(neighbors)
    return tuple(orbits)


def summarize_orbit(
    orbit: frozenset[Arc],
    loci: dict[Arc, frozenset[Point]],
    matrices: tuple[tuple[tuple[int, ...], ...], ...],
) -> OrbitSummary:
    incidences = {neighbor: neighbor_incidence(neighbor) for neighbor in orbit}
    deleted_counts = Counter(deleted for deleted, _ in incidences.values())
    replacement_counts = Counter(replacement for _, replacement in incidences.values())
    assert set(deleted_counts) == BASE_ARC
    assert len(set(deleted_counts.values())) == 1
    assert len(set(replacement_counts.values())) == 1

    metrics = {
        (
            len(loci[neighbor] ^ STANDARD_CONIC),
            len(loci[neighbor] & STANDARD_CONIC),
            len(loci[neighbor]),
        )
        for neighbor in orbit
    }
    assert len(metrics) == 1
    symmetric_difference, surviving_conic, uncovered_points = min(metrics)

    polar_values = {
        polar_incident(deleted, replacement)
        for deleted, replacement in incidences.values()
    }
    conic_line_counts = {
        line_conic_point_count(deleted, replacement)
        for deleted, replacement in incidences.values()
    }
    base_line_counts = {
        other_base_vertices_on_line(deleted, replacement)
        for deleted, replacement in incidences.values()
    }
    assert len(polar_values) == len(conic_line_counts) == len(base_line_counts) == 1

    representative_deleted, representative_replacement = min(incidences.values())
    replacement_point_orbit = frozenset(
        projectivity_image(matrix, representative_replacement) for matrix in matrices
    )
    assert replacement_point_orbit == frozenset(replacement_counts)

    return OrbitSummary(
        size=len(orbit),
        fixed_conic_symmetric_difference=symmetric_difference,
        surviving_fixed_conic_points=surviving_conic,
        uncovered_points=uncovered_points,
        distinct_replacements=len(replacement_counts),
        replacements_per_deleted_vertex=min(deleted_counts.values()),
        deletions_per_replacement=min(replacement_counts.values()),
        replacement_point_orbit_size=len(replacement_point_orbit),
        replacement_point_orbit_minimum=min(replacement_point_orbit),
        polar_incident=min(polar_values),
        deleted_replacement_line_conic_points=min(conic_line_counts),
        other_base_vertices_on_deleted_replacement_line=min(base_line_counts),
        representative_deleted=representative_deleted,
        representative_replacement=representative_replacement,
    )


def diagonal_projectivity(point: Point) -> Point:
    """The projectivity diag(4,2,1), canonicalized."""
    x, y, z = point
    return canonical((4 * x % Q, 2 * y % Q, z))


def main() -> None:
    assert len(PROJECTIVE_POINT_SET) == Q * Q + Q + 1 == 133
    assert len(STANDARD_CONIC) == Q + 1 == 12
    assert is_arc(BASE_ARC)
    assert uncovered_locus(BASE_ARC) == STANDARD_CONIC

    replacement_counts, neighbors = local_neighbors()
    assert replacement_counts == [42] * 6
    assert len(neighbors) == 252
    assert all(len(neighbor & BASE_ARC) == 5 for neighbor in neighbors)

    symmetric_difference_histogram: Counter[int] = Counter()
    surviving_conic_histogram: Counter[int] = Counter()
    uncovered_size_histogram: Counter[int] = Counter()
    neighbors_on_a_conic = 0
    loci = {neighbor: uncovered_locus(neighbor) for neighbor in neighbors}
    for locus in loci.values():
        symmetric_difference_histogram[len(locus ^ STANDARD_CONIC)] += 1
        surviving_conic_histogram[len(locus & STANDARD_CONIC)] += 1
        uncovered_size_histogram[len(locus)] += 1
        neighbors_on_a_conic += int(lies_on_a_conic(locus))

    assert symmetric_difference_histogram == Counter(
        {18: 30, 19: 60, 20: 90, 22: 42, 24: 30}
    )
    assert surviving_conic_histogram == Counter({4: 60, 6: 132, 7: 60})
    assert uncovered_size_histogram == Counter({18: 60, 20: 120, 21: 60, 22: 12})
    assert neighbors_on_a_conic == 0

    matrices = stabilizer_projectivities()
    assert all(projectivity_arc_image(matrix, BASE_ARC) == BASE_ARC for matrix in matrices)
    assert all(
        frozenset(projectivity_image(matrix, point) for point in STANDARD_CONIC)
        == STANDARD_CONIC
        for matrix in matrices
    )
    orbits = local_neighbor_orbits(neighbors, matrices)
    summaries = sorted(
        (summarize_orbit(orbit, loci, matrices) for orbit in orbits),
        key=lambda summary: (
            summary.fixed_conic_symmetric_difference,
            summary.size,
            summary.representative_replacement,
        ),
    )
    expected_summaries = [
        OrbitSummary(30, 18, 6, 18, 30, 5, 1, 30, (0, 1, 2), False, 0, 1,
                     (0, 1, 4), (1, 0, 6)),
        OrbitSummary(60, 19, 7, 21, 12, 10, 5, 12, (0, 0, 1), False, 2, 0,
                     (0, 1, 4), (1, 0, 0)),
        OrbitSummary(30, 20, 6, 20, 30, 5, 1, 30, (0, 1, 0), False, 0, 1,
                     (0, 1, 4), (1, 0, 2)),
        OrbitSummary(30, 20, 6, 20, 30, 5, 1, 30, (0, 1, 0), False, 0, 1,
                     (0, 1, 4), (1, 1, 8)),
        OrbitSummary(30, 20, 6, 20, 30, 5, 1, 30, (0, 1, 2), True, 0, 1,
                     (0, 1, 4), (1, 2, 0)),
        OrbitSummary(12, 22, 6, 22, 12, 2, 1, 12, (0, 0, 1), True, 1, 0,
                     (0, 1, 4), (0, 0, 1)),
        OrbitSummary(30, 22, 4, 18, 30, 5, 1, 30, (1, 0, 1), False, 0, 1,
                     (0, 1, 4), (1, 1, 10)),
        OrbitSummary(30, 24, 4, 20, 30, 5, 1, 30, (1, 0, 1), False, 0, 1,
                     (0, 1, 4), (1, 1, 2)),
    ]
    assert summaries == expected_summaries
    assert Counter(summary.size for summary in summaries) == Counter({30: 6, 60: 1, 12: 1})
    assert {
        summary.fixed_conic_symmetric_difference for summary in summaries
    } == set(symmetric_difference_histogram)
    assert Counter(
        {
            value: sum(
                summary.size
                for summary in summaries
                if summary.fixed_conic_symmetric_difference == value
            )
            for value in symmetric_difference_histogram
        }
    ) == symmetric_difference_histogram
    assert Counter(
        {
            value: sum(
                summary.size
                for summary in summaries
                if summary.surviving_fixed_conic_points == value
            )
            for value in surviving_conic_histogram
        }
    ) == surviving_conic_histogram
    assert Counter(
        {
            value: sum(
                summary.size
                for summary in summaries
                if summary.uncovered_points == value
            )
            for value in uncovered_size_histogram
        }
    ) == uncovered_size_histogram

    # This is an explicit counterexample to extending the local result into a
    # global "nearest other six-arc" statement.  The projectivity preserves
    # XZ=Y^2 because (4X)Z=(2Y)^2 whenever XZ=Y^2.
    transformed_arc = frozenset(diagonal_projectivity(point) for point in BASE_ARC)
    assert is_arc(transformed_arc)
    assert transformed_arc != BASE_ARC
    assert len(transformed_arc & BASE_ARC) < 5
    assert transformed_arc not in neighbors
    assert frozenset(diagonal_projectivity(point) for point in STANDARD_CONIC) == STANDARD_CONIC
    assert uncovered_locus(transformed_arc) == STANDARD_CONIC
    assert len(uncovered_locus(transformed_arc) ^ STANDARD_CONIC) == 0

    print("scope=local_one_point_replacement_graph")
    print(f"projective_points={len(PROJECTIVE_POINT_SET)}")
    print(f"standard_conic_points={len(STANDARD_CONIC)}")
    print(f"legal_replacements_per_deleted_vertex={replacement_counts}")
    print(f"distinct_neighboring_six_arcs={len(neighbors)}")
    print(f"stabilizer_projectivities={len(matrices)}")
    print(f"local_neighbor_orbits={len(summaries)}")
    print(f"local_neighbor_orbit_sizes={[summary.size for summary in summaries]}")
    for index, summary in enumerate(summaries, 1):
        print(
            f"local_orbit_{index}="
            f"size:{summary.size},"
            f"fixed_conic_symdiff:{summary.fixed_conic_symmetric_difference},"
            f"surviving_conic:{summary.surviving_fixed_conic_points},"
            f"uncovered:{summary.uncovered_points},"
            f"distinct_replacements:{summary.distinct_replacements},"
            f"per_deleted:{summary.replacements_per_deleted_vertex},"
            f"per_replacement:{summary.deletions_per_replacement},"
            f"replacement_point_orbit:{summary.replacement_point_orbit_size}"
            f"@{summary.replacement_point_orbit_minimum},"
            f"polar_incident:{summary.polar_incident},"
            f"line_conic_points:{summary.deleted_replacement_line_conic_points},"
            f"other_base_on_line:{summary.other_base_vertices_on_deleted_replacement_line},"
            f"representative:{summary.representative_deleted}"
            f"->{summary.representative_replacement}"
        )
    print(
        "fixed_conic_symmetric_difference_histogram="
        f"{dict(sorted(symmetric_difference_histogram.items()))}"
    )
    print(
        "surviving_fixed_conic_points_histogram="
        f"{dict(sorted(surviving_conic_histogram.items()))}"
    )
    print(f"uncovered_locus_size_histogram={dict(sorted(uncovered_size_histogram.items()))}")
    print(f"neighbors_on_any_conic={neighbors_on_a_conic}")
    print("global_counterexample_projectivity=diag(4,2,1)")
    print("global_counterexample_fixed_conic_distance=0")
    print("global_gloss_counterexample=True")
    print("all assertions passed")


if __name__ == "__main__":
    main()
