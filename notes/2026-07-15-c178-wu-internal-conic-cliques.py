#!/usr/bin/env python3
"""Exact F_11 first-cell audit for Wu's internal-point orbit conics.

The fixed conic is C: XZ = Y^2 in PG(2,11).  We construct the symmetric-square
image H = PSL(2,11), the stabilizer H_P of every internal point P, and all
length-12 H_P-orbits on internal points.  The script then verifies Wu's conic
and passant-line claims, computes the passant-join clique graph on every orbit
conic, and classifies any six-cliques under H.

There are no third-party dependencies.  Every reported conclusion is guarded
by an assertion; output order is deterministic.
"""

from __future__ import annotations

from collections import Counter
from itertools import combinations
from math import lcm


Q = 11
Point = tuple[int, int, int]
SetOfPoints = frozenset[int]


def normalize(vector: tuple[int, ...]) -> tuple[int, ...]:
    values = tuple(value % Q for value in vector)
    first = next(value for value in values if value)
    inverse = pow(first, Q - 2, Q)
    return tuple(value * inverse % Q for value in values)


def projective_points() -> tuple[Point, ...]:
    points: list[Point] = []
    for y in range(Q):
        for z in range(Q):
            points.append((1, y, z))
    for z in range(Q):
        points.append((0, 1, z))
    points.append((0, 0, 1))
    assert len(points) == Q * Q + Q + 1 == 133
    assert len(set(points)) == len(points)
    return tuple(points)


POINTS = projective_points()
POINT_INDEX = {point: index for index, point in enumerate(POINTS)}


def cross(left: Point, right: Point) -> Point:
    return normalize(
        (
            left[1] * right[2] - left[2] * right[1],
            left[2] * right[0] - left[0] * right[2],
            left[0] * right[1] - left[1] * right[0],
        )
    )  # type: ignore[return-value]


def dot(line: Point, point: Point) -> int:
    return sum(a * b for a, b in zip(line, point)) % Q


LINES = POINTS
LINE_INDEX = POINT_INDEX
LINE_POINTS = tuple(
    frozenset(index for index, point in enumerate(POINTS) if dot(line, point) == 0)
    for line in LINES
)
assert all(len(points) == Q + 1 for points in LINE_POINTS)


def quadratic_value(point: Point) -> int:
    x, y, z = point
    return (y * y - x * z) % Q


SQUARES = frozenset((value * value) % Q for value in range(1, Q))
NONSQUARES = frozenset(range(1, Q)) - SQUARES
FIXED_CONIC = frozenset(index for index, point in enumerate(POINTS) if quadratic_value(point) == 0)
INTERNAL = frozenset(
    index for index, point in enumerate(POINTS) if quadratic_value(point) in NONSQUARES
)
EXTERNAL = frozenset(range(len(POINTS))) - FIXED_CONIC - INTERNAL
assert len(FIXED_CONIC) == Q + 1 == 12
assert len(INTERNAL) == Q * (Q - 1) // 2 == 55
assert len(EXTERNAL) == Q * (Q + 1) // 2 == 66

LINE_CONIC_INTERSECTIONS = tuple(len(points & FIXED_CONIC) for points in LINE_POINTS)
assert Counter(LINE_CONIC_INTERSECTIONS) == Counter({0: 55, 1: 12, 2: 66})


def psl2_matrices() -> tuple[tuple[int, int, int, int], ...]:
    """Projectively normalized matrices in PSL(2,11), exactly once each."""

    matrices = set()
    for a in range(Q):
        for b in range(Q):
            for c in range(Q):
                for d in range(Q):
                    determinant = (a * d - b * c) % Q
                    if determinant in SQUARES:
                        matrices.add(normalize((a, b, c, d)))
    assert len(matrices) == Q * (Q * Q - 1) // 2 == 660
    return tuple(sorted(matrices))


def symmetric_square_permutation(matrix: tuple[int, int, int, int]) -> tuple[int, ...]:
    a, b, c, d = matrix
    image = []
    for x, y, z in POINTS:
        image.append(
            POINT_INDEX[
                normalize(
                    (
                        a * a * x + 2 * a * b * y + b * b * z,
                        a * c * x + (a * d + b * c) * y + b * d * z,
                        c * c * x + 2 * c * d * y + d * d * z,
                    )
                )
            ]
        )
    permutation = tuple(image)
    assert len(set(permutation)) == len(POINTS)
    return permutation


PSL2 = psl2_matrices()
GROUP = tuple(symmetric_square_permutation(matrix) for matrix in PSL2)
assert len(set(GROUP)) == len(GROUP) == 660
assert all(frozenset(permutation[p] for p in FIXED_CONIC) == FIXED_CONIC for permutation in GROUP)
assert all(frozenset(permutation[p] for p in INTERNAL) == INTERNAL for permutation in GROUP)


def rank_mod(rows: list[list[int]]) -> int:
    matrix = [[value % Q for value in row] for row in rows]
    rank = 0
    columns = len(matrix[0]) if matrix else 0
    for column in range(columns):
        pivot = next((row for row in range(rank, len(matrix)) if matrix[row][column]), None)
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inverse = pow(matrix[rank][column], Q - 2, Q)
        matrix[rank] = [value * inverse % Q for value in matrix[rank]]
        for row in range(len(matrix)):
            if row != rank and matrix[row][column]:
                factor = matrix[row][column]
                matrix[row] = [
                    (left - factor * right) % Q
                    for left, right in zip(matrix[row], matrix[rank])
                ]
        rank += 1
        if rank == len(matrix):
            break
    return rank


def quadratic_row(point: Point) -> list[int]:
    x, y, z = point
    return [x * x % Q, x * y % Q, x * z % Q, y * y % Q, y * z % Q, z * z % Q]


def unique_kernel_vector(rows: list[list[int]]) -> tuple[int, ...]:
    """Return the normalized generator of a rank-five kernel in F_11^6."""

    matrix = [[value % Q for value in row] for row in rows]
    pivot_columns: list[int] = []
    rank = 0
    for column in range(6):
        pivot = next((row for row in range(rank, len(matrix)) if matrix[row][column]), None)
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inverse = pow(matrix[rank][column], Q - 2, Q)
        matrix[rank] = [value * inverse % Q for value in matrix[rank]]
        for row in range(len(matrix)):
            if row != rank and matrix[row][column]:
                factor = matrix[row][column]
                matrix[row] = [
                    (left - factor * right) % Q
                    for left, right in zip(matrix[row], matrix[rank])
                ]
        pivot_columns.append(column)
        rank += 1
    assert rank == 5
    free_columns = [column for column in range(6) if column not in pivot_columns]
    assert len(free_columns) == 1
    free = free_columns[0]
    vector = [0] * 6
    vector[free] = 1
    for row, pivot in enumerate(pivot_columns):
        vector[pivot] = -sum(
            matrix[row][column] * vector[column]
            for column in range(6)
            if column != pivot
        ) % Q
    assert all(sum(a * b for a, b in zip(row, vector)) % Q == 0 for row in rows)
    return normalize(tuple(vector))


def conic_determinant(coefficients: tuple[int, ...]) -> int:
    """Determinant of twice the symmetric matrix of a ternary quadratic."""

    a, b, c, d, e, f = coefficients
    matrix = ((2 * a, b, c), (b, 2 * d, e), (c, e, 2 * f))
    return (
        matrix[0][0] * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1] * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2] * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    ) % Q


def conic_fit(point_set: SetOfPoints) -> tuple[int, tuple[int, ...] | None, bool]:
    rows = [quadratic_row(POINTS[point]) for point in sorted(point_set)]
    rank = rank_mod(rows)
    if rank != 5:
        return rank, None, False
    coefficients = unique_kernel_vector(rows)
    full_zero_set = frozenset(
        index
        for index, point in enumerate(POINTS)
        if sum(a * b for a, b in zip(coefficients, quadratic_row(point))) % Q == 0
    )
    return rank, coefficients, full_zero_set == point_set


def canonical(point_set: SetOfPoints, group: tuple[tuple[int, ...], ...] = GROUP) -> tuple[int, ...]:
    return min(tuple(sorted(permutation[point] for point in point_set)) for permutation in group)


def stabilizer(point_set: SetOfPoints, group: tuple[tuple[int, ...], ...] = GROUP) -> tuple[tuple[int, ...], ...]:
    return tuple(
        permutation
        for permutation in group
        if frozenset(permutation[point] for point in point_set) == point_set
    )


def permutation_order(permutation: tuple[int, ...]) -> int:
    seen: set[int] = set()
    cycle_lengths = []
    for start in range(len(permutation)):
        if start in seen:
            continue
        point = start
        length = 0
        while point not in seen:
            seen.add(point)
            length += 1
            point = permutation[point]
        cycle_lengths.append(length)
    return lcm(*cycle_lengths)


def set_orbits(sets: set[SetOfPoints], group: tuple[tuple[int, ...], ...]) -> list[tuple[SetOfPoints, set[SetOfPoints]]]:
    unseen = set(sets)
    answer = []
    while unseen:
        representative = min(unseen, key=lambda item: tuple(sorted(item)))
        orbit = {
            frozenset(permutation[point] for point in representative)
            for permutation in group
        }
        assert orbit <= sets
        answer.append((representative, orbit))
        unseen -= orbit
    answer.sort(key=lambda record: canonical(record[0], group))
    return answer


def wu_orbit_conics() -> tuple[set[SetOfPoints], Counter[int]]:
    conics: set[SetOfPoints] = set()
    point_orbit_length_histogram: Counter[int] = Counter()
    for fixed_point in sorted(INTERNAL):
        point_stabilizer = tuple(permutation for permutation in GROUP if permutation[fixed_point] == fixed_point)
        assert len(point_stabilizer) == Q + 1 == 12
        point_orbits = {
            frozenset(permutation[point] for permutation in point_stabilizer)
            for point in INTERNAL
        }
        assert set().union(*point_orbits) == set(INTERNAL)
        assert sum(len(orbit) for orbit in point_orbits) == len(INTERNAL)
        assert Counter(map(len, point_orbits)) == Counter({1: 1, 3: 2, 6: 4, 12: 2})
        point_orbit_length_histogram.update(len(orbit) for orbit in point_orbits)
        length_twelve = {orbit for orbit in point_orbits if len(orbit) == Q + 1}
        assert len(length_twelve) == (Q - 3) // 4 == 2
        conics.update(length_twelve)
    return conics, point_orbit_length_histogram


def verify_wu_conic(conic: SetOfPoints) -> tuple[int, ...]:
    assert len(conic) == Q + 1 == 12
    assert conic <= INTERNAL
    pair_lines = [LINE_INDEX[cross(POINTS[left], POINTS[right])] for left, right in combinations(sorted(conic), 2)]
    assert len(pair_lines) == len(set(pair_lines)) == 66  # no three collinear
    assert all(len(conic & LINE_POINTS[line]) in (0, 2) for line in range(len(LINES)) if LINE_CONIC_INTERSECTIONS[line] == 0)
    rank, coefficients, exact = conic_fit(conic)
    assert rank == 5 and coefficients is not None and exact
    assert conic_determinant(coefficients) != 0
    return coefficients


def clique_data(conic: SetOfPoints) -> tuple[list[list[tuple[int, ...]]], list[int]]:
    vertices = tuple(sorted(conic))
    adjacency = [0] * len(vertices)
    for left, right in combinations(range(len(vertices)), 2):
        line = LINE_INDEX[cross(POINTS[vertices[left]], POINTS[vertices[right]])]
        if LINE_CONIC_INTERSECTIONS[line] == 0:
            adjacency[left] |= 1 << right
            adjacency[right] |= 1 << left

    cliques: list[list[tuple[int, ...]]] = [[] for _ in range(len(vertices) + 1)]
    greater = [~((1 << (vertex + 1)) - 1) for vertex in range(len(vertices))]

    def visit(chosen: tuple[int, ...], candidates: int) -> None:
        if chosen:
            cliques[len(chosen)].append(tuple(vertices[vertex] for vertex in chosen))
        remaining = candidates
        while remaining:
            bit = remaining & -remaining
            vertex = bit.bit_length() - 1
            remaining ^= bit
            visit(chosen + (vertex,), candidates & adjacency[vertex] & greater[vertex])

    visit((), (1 << len(vertices)) - 1)
    assert len(cliques[1]) == 12
    degrees = [mask.bit_count() for mask in adjacency]
    return cliques, degrees


def uncovered_locus(arc: SetOfPoints) -> SetOfPoints:
    covered: set[int] = set()
    for left, right in combinations(sorted(arc), 2):
        line = LINE_INDEX[cross(POINTS[left], POINTS[right])]
        assert LINE_CONIC_INTERSECTIONS[line] == 0
        covered.update(LINE_POINTS[line])
    uncovered = frozenset(range(len(POINTS))) - covered
    assert FIXED_CONIC <= uncovered
    return uncovered


def coordinate_list(point_set: SetOfPoints) -> list[Point]:
    return [POINTS[point] for point in sorted(point_set)]


def main() -> None:
    conics, raw_orbit_lengths = wu_orbit_conics()
    assert raw_orbit_lengths == Counter({1: 55, 3: 110, 6: 220, 12: 110})
    assert len(conics) == 110
    assert all(verify_wu_conic(conic) for conic in conics)
    conic_orbits = set_orbits(conics, GROUP)
    assert len(conic_orbits) == 2
    assert sorted(len(orbit) for _, orbit in conic_orbits) == [55, 55]

    print("C178 Wu internal-conic first cell over F_11")
    print(f"PG_points={len(POINTS)} fixed_conic={len(FIXED_CONIC)} internal={len(INTERNAL)} external={len(EXTERNAL)}")
    print(f"H=PSL2(11)_Sym2 order={len(GROUP)} internal_transitive=True internal_point_stabilizer_order=12")
    print(f"per_internal_point_Hp_orbit_length_histogram={{1: 1, 3: 2, 6: 4, 12: 2}}")
    print(f"length12_orbit_occurrences_with_multiplicity={55 * 2}")
    print(f"distinct_Wu_orbit_conics={len(conics)} H_orbits={len(conic_orbits)}")

    all_six_cliques: set[SetOfPoints] = set()
    reference_graph_signatures = {}
    for orbit_number, (representative, orbit) in enumerate(conic_orbits, 1):
        conic_stabilizer = stabilizer(representative)
        assert len(orbit) * len(conic_stabilizer) == len(GROUP)
        stabilizer_order_histogram = Counter(map(permutation_order, conic_stabilizer))
        assert stabilizer_order_histogram == Counter({1: 1, 2: 7, 3: 2, 6: 2})
        assert all(
            sum(1 for permutation in conic_stabilizer if permutation[point] == point) == 1
            for point in representative
        )
        cliques, degrees = clique_data(representative)
        omega = max(size for size, values in enumerate(cliques) if values)
        maximum = {frozenset(clique) for clique in cliques[omega]}
        maximum_orbits = set_orbits(maximum, conic_stabilizer)
        signature = (
            tuple(sorted(Counter(degrees).items())),
            tuple(len(values) for values in cliques),
            omega,
            len(maximum),
            len(maximum_orbits),
        )
        reference_graph_signatures[orbit_number] = signature

        # Every member of an H-orbit has the same graph data.  Audit it directly.
        for member in orbit:
            member_cliques, member_degrees = clique_data(member)
            member_omega = max(size for size, values in enumerate(member_cliques) if values)
            assert Counter(member_degrees) == Counter(degrees)
            assert tuple(len(values) for values in member_cliques) == tuple(len(values) for values in cliques)
            assert member_omega == omega
            if len(member_cliques) > 6:
                all_six_cliques.update(frozenset(clique) for clique in member_cliques[6])

        coefficients = verify_wu_conic(representative)
        passant_intersections = Counter(
            len(representative & LINE_POINTS[line])
            for line in range(len(LINES))
            if LINE_CONIC_INTERSECTIONS[line] == 0
        )
        assert passant_intersections == Counter({2: 36, 0: 19})
        print(
            f"conic_H_orbit={orbit_number} orbit_size={len(orbit)} set_stabilizer={len(conic_stabilizer)} "
            f"representative_form={coefficients}"
        )
        print(
            f"  set_stabilizer_element_orders={dict(sorted(stabilizer_order_histogram.items()))} "
            "regular_on_conic=True group_type=dihedral_order_12"
        )
        print(f"  representative_points={coordinate_list(representative)}")
        print("  all_internal=True no_three_collinear=True pair_lines=66 nonsingular_conic=True")
        print(f"  passant_line_intersection_histogram={dict(sorted(passant_intersections.items()))}")
        print(f"  graph_degree_histogram={dict(sorted(Counter(degrees).items()))} edge_count={sum(degrees) // 2}")
        print(f"  clique_count_by_size={{{', '.join(f'{size}: {len(values)}' for size, values in enumerate(cliques) if values)}}}")
        print(f"  clique_number={omega} maximum_cliques={len(maximum)} maximum_clique_orbits={len(maximum_orbits)}")
        for max_orbit_number, (max_representative, max_orbit) in enumerate(maximum_orbits, 1):
            max_stabilizer = stabilizer(max_representative, conic_stabilizer)
            assert len(max_orbit) * len(max_stabilizer) == len(conic_stabilizer)
            print(
                f"    maximum_orbit={max_orbit_number} orbit_size={len(max_orbit)} "
                f"stabilizer_in_conic_stabilizer={len(max_stabilizer)} "
                f"representative={coordinate_list(max_representative)}"
            )

    expected_signatures = {
        (
            ((6, 12),),
            (0, 12, 36, 36, 12, 0, 0, 0, 0, 0, 0, 0, 0),
            4,
            12,
            2,
        ),
        (
            ((6, 12),),
            (0, 12, 36, 28, 0, 0, 0, 0, 0, 0, 0, 0, 0),
            3,
            28,
            3,
        ),
    }
    assert set(reference_graph_signatures.values()) == expected_signatures
    assert not all_six_cliques

    six_orbits = set_orbits(all_six_cliques, GROUP) if all_six_cliques else []
    print(f"distinct_six_cliques_across_Wu_conics={len(all_six_cliques)} H_orbits={len(six_orbits)}")
    uncovered_histogram: Counter[int] = Counter()
    conic_fit_histogram: Counter[tuple[int, bool]] = Counter()
    containing_wu_conic_histogram: Counter[int] = Counter()
    for orbit_number, (representative, orbit) in enumerate(six_orbits, 1):
        arc_stabilizer = stabilizer(representative)
        assert len(orbit) * len(arc_stabilizer) == len(GROUP)
        containing_conics = sum(1 for conic in conics if representative <= conic)
        containing_wu_conic_histogram[containing_conics] += len(orbit)
        uncovered = uncovered_locus(representative)
        rank, coefficients, exact = conic_fit(uncovered)
        uncovered_histogram[len(uncovered)] += len(orbit)
        conic_fit_histogram[(rank, exact)] += len(orbit)
        print(
            f"six_clique_H_orbit={orbit_number} orbit_size={len(orbit)} H_stabilizer={len(arc_stabilizer)} "
            f"containing_Wu_conics={containing_conics} U_size={len(uncovered)} "
            f"U_quadratic_rank={rank} U_exact_conic={exact} U_equals_fixed_conic={uncovered == FIXED_CONIC}"
        )
        print(f"  representative={coordinate_list(representative)}")
        if coefficients is not None:
            print(f"  U_conic_form={coefficients}")

    print(f"six_clique_U_size_histogram={dict(sorted(uncovered_histogram.items()))}")
    print(
        "six_clique_U_fit_histogram="
        + str({str(key): value for key, value in sorted(conic_fit_histogram.items())})
    )
    print(f"six_clique_containing_Wu_conics_histogram={dict(sorted(containing_wu_conic_histogram.items()))}")


if __name__ == "__main__":
    main()
