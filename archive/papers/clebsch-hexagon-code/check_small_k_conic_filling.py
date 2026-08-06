#!/usr/bin/env python3
"""Fail-closed finite checks for the small-k conic-filling classification.

This standard-library checker hardens the finite computations originally supplied as
``q2_step1.py`` and ``q2_step2.py``.  It checks the displayed q=5 quadrilateral and exhausts the
frame-normalized seven-arc searches at q=11 and q=13.

It does *not* prove the universal chord-moment algebra for k=4,5,7.  That argument is a separate
mathematical proof in the manuscript; the computations here verify the surviving finite leaves.
"""

from __future__ import annotations

from collections import Counter
from itertools import combinations, product
from typing import Iterable, Sequence


Point = tuple[int, int, int]
FRAME: tuple[Point, ...] = ((1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 1))
MONOMIALS: tuple[tuple[int, int, int], ...] = (
    (2, 0, 0),
    (1, 1, 0),
    (1, 0, 1),
    (0, 2, 0),
    (0, 1, 1),
    (0, 0, 2),
)

EXPECTED = {
    11: {
        "six_reps": 1548,
        "histogram": {12: 6, 16: 30, 18: 150, 19: 300, 20: 630, 21: 360, 22: 72},
        "raw_pairs": 30696,
        "seven_sets": 10232,
    },
    13: {
        "six_reps": 4015,
        "histogram": {36: 85, 38: 210, 39: 480, 40: 1080, 41: 1800, 42: 360},
        "raw_pairs": 161880,
        "seven_sets": 53960,
    },
}


def canonical_points(q: int) -> list[Point]:
    points = (
        [(1, y, z) for y in range(q) for z in range(q)]
        + [(0, 1, z) for z in range(q)]
        + [(0, 0, 1)]
    )
    assert len(points) == q * q + q + 1
    assert len(set(points)) == len(points)
    return points


def normalize(v: Point, q: int) -> Point:
    pivot = next((x % q for x in v if x % q), None)
    assert pivot is not None, "attempted to normalize the zero vector"
    inverse = pow(pivot, q - 2, q)
    return tuple((x * inverse) % q for x in v)  # type: ignore[return-value]


def cross(left: Point, right: Point, q: int) -> Point:
    return normalize(
        (
            left[1] * right[2] - left[2] * right[1],
            left[2] * right[0] - left[0] * right[2],
            left[0] * right[1] - left[1] * right[0],
        ),
        q,
    )


def dot(left: Point, right: Point, q: int) -> int:
    return sum(x * y for x, y in zip(left, right)) % q


def determinant(left: Point, middle: Point, right: Point, q: int) -> int:
    return (
        left[0] * (middle[1] * right[2] - middle[2] * right[1])
        - left[1] * (middle[0] * right[2] - middle[2] * right[0])
        + left[2] * (middle[0] * right[1] - middle[1] * right[0])
    ) % q


def matrix_determinant_3(matrix: Sequence[Sequence[int]], q: int) -> int:
    return (
        matrix[0][0] * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1] * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2] * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    ) % q


def indices(mask: int) -> list[int]:
    result: list[int] = []
    while mask:
        bit = mask & -mask
        mask ^= bit
        result.append(bit.bit_length() - 1)
    return result


def is_arc(point_indices: Sequence[int], points: Sequence[Point], q: int) -> bool:
    return all(
        determinant(points[a], points[b], points[c], q) != 0
        for a, b, c in combinations(point_indices, 3)
    )


def rref(rows: Sequence[Sequence[int]], q: int) -> tuple[list[list[int]], list[int]]:
    matrix = [[entry % q for entry in row] for row in rows]
    pivots: list[int] = []
    pivot_row = 0
    for column in range(len(matrix[0]) if matrix else 0):
        source = next(
            (row for row in range(pivot_row, len(matrix)) if matrix[row][column] % q),
            None,
        )
        if source is None:
            continue
        matrix[pivot_row], matrix[source] = matrix[source], matrix[pivot_row]
        inverse = pow(matrix[pivot_row][column], q - 2, q)
        matrix[pivot_row] = [(entry * inverse) % q for entry in matrix[pivot_row]]
        for row in range(len(matrix)):
            if row == pivot_row or matrix[row][column] == 0:
                continue
            factor = matrix[row][column]
            matrix[row] = [
                (matrix[row][j] - factor * matrix[pivot_row][j]) % q
                for j in range(len(matrix[row]))
            ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    return matrix, pivots


def nullspace_basis(rows: Sequence[Sequence[int]], q: int, width: int) -> list[list[int]]:
    reduced, pivots = rref(rows, q)
    free_columns = [column for column in range(width) if column not in pivots]
    basis: list[list[int]] = []
    for free in free_columns:
        vector = [0] * width
        vector[free] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = (-reduced[row][free]) % q
        assert all(
            sum(entry * coefficient for entry, coefficient in zip(source, vector)) % q == 0
            for source in rows
        )
        basis.append(vector)
    return basis


def quadratic_row(point: Point, q: int) -> list[int]:
    x, y, z = point
    return [
        pow(x, i, q) * pow(y, j, q) * pow(z, k, q) % q
        for i, j, k in MONOMIALS
    ]


def quadratic_value(coefficients: Sequence[int], point: Point, q: int) -> int:
    return sum(
        coefficient * value
        for coefficient, value in zip(coefficients, quadratic_row(point, q))
    ) % q


def quadratic_is_nonsingular(coefficients: Sequence[int], q: int) -> bool:
    xx, xy, xz, yy, yz, zz = coefficients
    half = pow(2, q - 2, q)
    symmetric_matrix = (
        (xx, xy * half % q, xz * half % q),
        (xy * half % q, yy, yz * half % q),
        (xz * half % q, yz * half % q, zz),
    )
    return matrix_determinant_3(symmetric_matrix, q) != 0


def nonzero_nullspace_vectors(basis: Sequence[Sequence[int]], q: int) -> Iterable[list[int]]:
    for scalars in product(range(q), repeat=len(basis)):
        if not any(scalars):
            continue
        yield [
            sum(scalar * basis_vector[column] for scalar, basis_vector in zip(scalars, basis)) % q
            for column in range(6)
        ]


def check_q5_frame() -> dict[str, int]:
    q = 5
    points = canonical_points(q)
    point_index = {point: i for i, point in enumerate(points)}
    all_points_mask = (1 << len(points)) - 1
    line_masks: dict[Point, int] = {}

    def line_mask(line: Point) -> int:
        if line not in line_masks:
            line_masks[line] = sum(
                1 << i for i, point in enumerate(points) if dot(line, point, q) == 0
            )
        return line_masks[line]

    covered = sum(1 << point_index[point] for point in FRAME)
    for left, right in combinations(FRAME, 2):
        covered |= line_mask(cross(left, right, q))
    uncovered = all_points_mask ^ covered

    coefficients = (1, 1, 1, 1, 1, 1)
    conic = sum(
        1 << i for i, point in enumerate(points) if quadratic_value(coefficients, point, q) == 0
    )
    assert uncovered.bit_count() == q + 1 == 6
    assert uncovered == conic, "q=5 frame uncovered set is not the displayed quadratic zero set"
    assert quadratic_is_nonsingular(coefficients, q), "displayed q=5 quadratic is singular"
    assert not (uncovered & sum(1 << point_index[point] for point in FRAME))
    return {"uncovered": uncovered.bit_count(), "conic": conic.bit_count()}


def check_seven_arcs(q: int) -> dict[str, object]:
    expected = EXPECTED[q]
    points = canonical_points(q)
    point_index = {point: i for i, point in enumerate(points)}
    all_points_mask = (1 << len(points)) - 1
    line_masks: dict[Point, int] = {}

    def line_mask(line: Point) -> int:
        if line not in line_masks:
            line_masks[line] = sum(
                1 << i for i, point in enumerate(points) if dot(line, point, q) == 0
            )
        return line_masks[line]

    def uncovered_mask(arc_indices: Sequence[int]) -> int:
        covered = sum(1 << i for i in arc_indices)
        for left, right in combinations(arc_indices, 2):
            covered |= line_mask(cross(points[left], points[right], q))
        return all_points_mask ^ covered

    frame_indices = tuple(point_index[point] for point in FRAME)
    candidates = [
        point
        for point in points
        if point[0]
        and point[1]
        and point[2]
        and point[0] != point[1]
        and point[0] != point[2]
        and point[1] != point[2]
    ]
    assert len(candidates) == (q - 2) * (q - 3)

    six_arcs: list[tuple[int, ...]] = []
    for left, right in combinations(candidates, 2):
        arc = frame_indices + (point_index[left], point_index[right])
        if all(determinant(points[f], left, right, q) for f in frame_indices):
            assert is_arc(arc, points, q)
            six_arcs.append(arc)
    assert len(six_arcs) == expected["six_reps"]

    histogram: Counter[int] = Counter()
    seven_multiplicity: Counter[int] = Counter()
    checked_arc_masks: set[int] = set()
    raw_pairs = 0
    for six_arc in six_arcs:
        uncovered = uncovered_mask(six_arc)
        histogram[uncovered.bit_count()] += 1
        base_mask = sum(1 << i for i in six_arc)
        for extension in indices(uncovered):
            raw_pairs += 1
            seven_mask = base_mask | (1 << extension)
            seven_multiplicity[seven_mask] += 1
            if seven_mask not in checked_arc_masks:
                seven_indices = indices(seven_mask)
                assert len(seven_indices) == 7
                assert is_arc(seven_indices, points, q), "generated extension is not a seven-arc"
                checked_arc_masks.add(seven_mask)
            # Duplicate raw pairs reuse the already checked identical seven-set; this assertion is
            # inside the raw-generation loop so every generated pair is covered by the arc gate.
            assert seven_mask in checked_arc_masks

    assert dict(sorted(histogram.items())) == expected["histogram"]
    assert raw_pairs == expected["raw_pairs"]
    assert sum(size * count for size, count in histogram.items()) == raw_pairs
    assert len(seven_multiplicity) == expected["seven_sets"]
    assert checked_arc_masks == set(seven_multiplicity)
    multiplicity_histogram = Counter(seven_multiplicity.values())
    assert multiplicity_histogram == {3: expected["seven_sets"]}, (
        "each frame-normalized seven-set must arise from exactly three six-subsets",
        multiplicity_histogram,
    )

    size_q_plus_one = 0
    quadratic_containment_hits = 0
    nonsingular_conic_hits = 0
    nullity_histogram: Counter[int] = Counter()
    for seven_mask in seven_multiplicity:
        seven_arc = indices(seven_mask)
        uncovered = uncovered_mask(seven_arc)
        if uncovered.bit_count() != q + 1:
            continue
        size_q_plus_one += 1
        uncovered_indices = indices(uncovered)
        rows = [quadratic_row(points[i], q) for i in uncovered_indices]
        basis = nullspace_basis(rows, q, 6)
        nullity_histogram[len(basis)] += 1
        if not basis:
            continue
        quadratic_containment_hits += 1

        # A quadratic containment is called a conic only after a nonsingularity test.  If the
        # quadratic kernel is multidimensional, inspect every projective direction (duplicates are
        # harmless here); this branch is normally empty but is deliberately fail-closed.
        found_nonsingular = False
        for coefficients in nonzero_nullspace_vectors(basis, q):
            if not quadratic_is_nonsingular(coefficients, q):
                continue
            zero_mask = sum(
                1 << i
                for i, point in enumerate(points)
                if quadratic_value(coefficients, point, q) == 0
            )
            assert zero_mask == uncovered, (
                "nonsingular quadratic containing q+1 uncovered points has unexpected zero set",
                q,
                coefficients,
            )
            found_nonsingular = True
            break
        if found_nonsingular:
            nonsingular_conic_hits += 1

    assert quadratic_containment_hits == 0
    assert nonsingular_conic_hits == 0
    return {
        "six_reps": len(six_arcs),
        "histogram": dict(sorted(histogram.items())),
        "raw_pairs": raw_pairs,
        "seven_sets": len(seven_multiplicity),
        "multiplicity_histogram": dict(sorted(multiplicity_histogram.items())),
        "size_q_plus_one": size_q_plus_one,
        "nullity_histogram": dict(sorted(nullity_histogram.items())),
        "quadratic_containment_hits": quadratic_containment_hits,
        "nonsingular_conic_hits": nonsingular_conic_hits,
    }


def main() -> None:
    q5 = check_q5_frame()
    print(
        "q=5 frame: uncovered=6 displayed_quadratic_points=6 "
        "quadratic_nonsingular=PASS exact_set_equality=PASS"
    )

    results: dict[int, dict[str, object]] = {}
    for q in (11, 13):
        result = check_seven_arcs(q)
        results[q] = result
        print(
            f"q={q}: six_reps={result['six_reps']} histogram={result['histogram']} "
            f"raw_six_extension_pairs={result['raw_pairs']} "
            f"distinct_seven_arcs={result['seven_sets']} "
            f"multiplicities={result['multiplicity_histogram']}"
        )
        print(
            f"q={q}: size_q_plus_one={result['size_q_plus_one']} "
            f"quadratic_nullities={result['nullity_histogram']} "
            f"quadratic_containment_hits={result['quadratic_containment_hits']} "
            f"nonsingular_conic_hits={result['nonsingular_conic_hits']}"
        )

    assert q5 == {"uncovered": 6, "conic": 6}
    assert all(results[q]["quadratic_containment_hits"] == 0 for q in (11, 13))
    print("SMALL_K_CONIC_FILLING_PASS")


if __name__ == "__main__":
    main()
