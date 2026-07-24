#!/usr/bin/env python3
"""Exact global conic-distance census for six-arcs of PG(2,11).

The 1,548 objects first enumerated here are frame-normalized representatives,
not projective classes.  To obtain classes, every ordered four-frame in each
arc is normalized to ``e1,e2,e3,(1,1,1)`` and the lexicographically least
result is used as a projective-class key.  This produces exactly 15 classes.

Independently, every projective ternary quadratic form over F_11 is enumerated
and every nonsingular conic retained.  For a six-arc A this checker computes

    delta(A) = min_Q |U(A) symmetric_difference Q(F_11)|,

where Q ranges over all nonsingular conics.  All arithmetic and enumeration
are exact and use only the Python standard library.
"""

from __future__ import annotations

from collections import Counter, defaultdict
from itertools import combinations, permutations, product


P = 11
INV_TWO = pow(2, P - 2, P)
EXPECTED_U_HISTOGRAM = {
    12: 6, 16: 30, 18: 150, 19: 300, 20: 630, 21: 360, 22: 72,
}
EXPECTED_CLASS_MULTIPLICITIES = [
    6, 30, 30, 60, 60, 60, 72, 90, 90, 90, 120, 120, 180, 180, 360,
]
EXPECTED_CLASS_STABILIZER_ORDERS = [
    1, 2, 2, 3, 3, 4, 4, 4, 5, 6, 6, 6, 12, 12, 60,
]
EXPECTED_CLASS_DELTA_HISTOGRAM = {
    0: 1, 12: 2, 13: 1, 14: 3, 15: 1, 16: 4, 17: 2, 18: 1,
}
# In canonical-arc order: |U|, delta, nearest-conic count, intersection,
# lexicographically least nearest conic coefficient vector.
EXPECTED_CLASS_METRICS = [
    (20, 12, 1, 10, (1, 1, 1, 7, 0, 7)),
    (18, 14, 6, 8, (1, 0, 6, 1, 3, 9)),
    (19, 13, 3, 9, (1, 2, 1, 1, 2, 6)),
    (19, 17, 60, 7, (1, 0, 3, 4, 8, 5)),
    (20, 16, 23, 8, (1, 0, 2, 1, 7, 2)),
    (20, 16, 8, 8, (1, 2, 3, 3, 7, 3)),
    (21, 17, 11, 8, (1, 0, 3, 6, 9, 4)),
    (20, 16, 16, 8, (1, 1, 0, 1, 5, 9)),
    (20, 16, 8, 8, (1, 0, 8, 1, 1, 3)),
    (19, 15, 3, 8, (1, 1, 8, 7, 10, 9)),
    (16, 12, 9, 8, (1, 0, 2, 1, 7, 2)),
    (22, 18, 25, 8, (1, 0, 3, 4, 1, 6)),
    (18, 14, 9, 8, (1, 0, 2, 1, 7, 2)),
    (18, 14, 9, 8, (1, 1, 0, 1, 8, 1)),
    (12, 0, 1, 12, (1, 6, 7, 1, 7, 9)),
]

Point = tuple[int, int, int]
Arc = tuple[Point, ...]
Matrix = tuple[tuple[int, int, int], ...]


def projective_points() -> tuple[Point, ...]:
    points = tuple(
        [(1, y, z) for y, z in product(range(P), repeat=2)]
        + [(0, 1, z) for z in range(P)]
        + [(0, 0, 1)]
    )
    assert len(points) == P * P + P + 1 == 133
    assert len(set(points)) == len(points)
    return points


POINTS = projective_points()
POINT_INDEX = {point: index for index, point in enumerate(POINTS)}
FRAME = ((1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 1))
BASE_ARC = tuple(sorted((
    (1, 10, 0), (1, 9, 1), (1, 4, 7),
    (1, 8, 5), (0, 1, 4), (1, 1, 7),
)))


def determinant(a: Point, b: Point, c: Point) -> int:
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % P


def matrix_from_columns(columns: tuple[Point, Point, Point]) -> Matrix:
    return tuple(
        tuple(columns[column][row] for column in range(3))
        for row in range(3)
    )


def matrix_inverse(matrix: Matrix) -> Matrix:
    augmented = [
        [matrix[row][column] % P for column in range(3)]
        + [int(row == column) for column in range(3)]
        for row in range(3)
    ]
    for column in range(3):
        pivot = next(row for row in range(column, 3) if augmented[row][column])
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        scale = pow(augmented[column][column], P - 2, P)
        augmented[column] = [scale * entry % P for entry in augmented[column]]
        for row in range(3):
            if row == column:
                continue
            coefficient = augmented[row][column]
            augmented[row] = [
                (entry - coefficient * pivot_entry) % P
                for entry, pivot_entry in zip(augmented[row], augmented[column])
            ]
    inverse = tuple(tuple(row[3:]) for row in augmented)
    assert matrix_multiply(matrix, inverse) == ((1, 0, 0), (0, 1, 0), (0, 0, 1))
    return inverse  # type: ignore[return-value]


def matrix_multiply(left: Matrix, right: Matrix) -> Matrix:
    return tuple(
        tuple(sum(left[i][k] * right[k][j] for k in range(3)) % P for j in range(3))
        for i in range(3)
    )  # type: ignore[return-value]


def matrix_vector(matrix: Matrix, vector: Point) -> Point:
    return tuple(
        sum(matrix[row][column] * vector[column] for column in range(3)) % P
        for row in range(3)
    )  # type: ignore[return-value]


def canonical_point(vector: Point) -> Point:
    pivot = next(entry for entry in vector if entry)
    scale = pow(pivot, P - 2, P)
    return tuple(scale * entry % P for entry in vector)  # type: ignore[return-value]


def normalize_ordered_frame(arc: Arc, ordered_frame: tuple[Point, ...]) -> Arc:
    first, second, third, fourth = ordered_frame
    inverse_basis = matrix_inverse(matrix_from_columns((first, second, third)))
    fourth_coordinates = matrix_vector(inverse_basis, fourth)
    assert all(fourth_coordinates)
    diagonal = tuple(
        tuple(
            pow(fourth_coordinates[row], P - 2, P) if row == column else 0
            for column in range(3)
        )
        for row in range(3)
    )
    transformation = matrix_multiply(diagonal, inverse_basis)  # type: ignore[arg-type]
    normalized = tuple(sorted(canonical_point(matrix_vector(transformation, point)) for point in arc))
    assert set(FRAME) <= set(normalized)
    return normalized


def projective_class_key(arc: Arc) -> Arc:
    normalizations = (
        normalize_ordered_frame(arc, ordered_frame)
        for ordered_frame in permutations(arc, 4)
    )
    return min(normalizations)


def is_arc(points: Arc) -> bool:
    return all(determinant(a, b, c) != 0 for a, b, c in combinations(points, 3))


def line_masks() -> dict[tuple[int, int], int]:
    masks = {}
    for left, right in combinations(range(len(POINTS)), 2):
        mask = 0
        for index, point in enumerate(POINTS):
            if determinant(POINTS[left], POINTS[right], point) == 0:
                mask |= 1 << index
        assert mask.bit_count() == P + 1
        masks[(left, right)] = mask
    return masks


LINE_MASKS = line_masks()
FULL_POINT_MASK = (1 << len(POINTS)) - 1


def pair_key(left: int, right: int) -> tuple[int, int]:
    return (left, right) if left < right else (right, left)


def uncovered_mask(arc: Arc) -> int:
    indices = tuple(POINT_INDEX[point] for point in arc)
    covered = 0
    for left, right in combinations(indices, 2):
        covered |= LINE_MASKS[pair_key(left, right)]
    result = FULL_POINT_MASK ^ covered
    assert all((result >> index) & 1 == 0 for index in indices)
    return result


def frame_normalized_census() -> list[Arc]:
    frame_set = set(FRAME)
    candidates = [point for point in POINTS if point not in frame_set]
    arcs = []
    for fifth, sixth in combinations(candidates, 2):
        arc = tuple(sorted(FRAME + (fifth, sixth)))
        if is_arc(arc):
            arcs.append(arc)
    assert len(arcs) == len(set(arcs)) == 1548
    histogram = Counter(uncovered_mask(arc).bit_count() for arc in arcs)
    assert histogram == Counter(EXPECTED_U_HISTOGRAM)
    return arcs


def projective_quadratic_forms():
    """All normalized nonzero coefficient vectors in PG(5,11)."""
    count = 0
    for pivot in range(6):
        prefix = (0,) * pivot + (1,)
        for tail in product(range(P), repeat=5 - pivot):
            count += 1
            yield prefix + tail
    assert count == (P**6 - 1) // (P - 1) == 177156


def symmetric_conic_determinant(coefficients: tuple[int, ...]) -> int:
    a, b, c, d, e, f = coefficients
    matrix = (
        (a, b * INV_TWO % P, c * INV_TWO % P),
        (b * INV_TWO % P, d, e * INV_TWO % P),
        (c * INV_TWO % P, e * INV_TWO % P, f),
    )
    return determinant(matrix[0], matrix[1], matrix[2])


MONOMIALS = tuple(
    (x * x % P, x * y % P, x * z % P,
     y * y % P, y * z % P, z * z % P)
    for x, y, z in POINTS
)


def conic_mask(coefficients: tuple[int, ...]) -> int:
    mask = 0
    for index, features in enumerate(MONOMIALS):
        if sum(a * b for a, b in zip(coefficients, features)) % P == 0:
            mask |= 1 << index
    return mask


def nonsingular_conics() -> list[tuple[tuple[int, ...], int]]:
    conics = []
    incidence = [0] * len(POINTS)
    projective_form_count = 0
    singular_form_count = 0
    for coefficients in projective_quadratic_forms():
        projective_form_count += 1
        if symmetric_conic_determinant(coefficients) == 0:
            singular_form_count += 1
            continue
        mask = conic_mask(coefficients)
        assert mask.bit_count() == P + 1 == 12
        conics.append((coefficients, mask))
        for index in range(len(POINTS)):
            incidence[index] += (mask >> index) & 1
    assert projective_form_count == 177156
    assert len(conics) == P * P * (P**3 - 1) == 160930
    assert singular_form_count == 16226
    assert len({mask for _, mask in conics}) == len(conics)
    assert set(incidence) == {14520}
    return conics


def format_arc(arc: Arc) -> str:
    return "[" + ",".join(f"({x},{y},{z})" for x, y, z in arc) + "]"


def format_coefficients(coefficients: tuple[int, ...]) -> str:
    return "(" + ",".join(str(entry) for entry in coefficients) + ")"


def main() -> None:
    arcs = frame_normalized_census()
    classes: dict[Arc, list[Arc]] = defaultdict(list)
    for arc in arcs:
        classes[projective_class_key(arc)].append(arc)
    assert len(classes) == 15
    assert sum(len(members) for members in classes.values()) == 1548
    assert all(key in set(arcs) for key in classes)

    # A class with stabilizer S contributes 360/|S| distinct normalized
    # representatives, since a six-arc has 6P4=360 ordered four-frames and a
    # projectivity fixing an ordered frame is the identity.
    multiplicities = sorted(len(members) for members in classes.values())
    assert all(360 % multiplicity == 0 for multiplicity in multiplicities)
    stabilizer_orders = sorted(360 // multiplicity for multiplicity in multiplicities)
    assert multiplicities == EXPECTED_CLASS_MULTIPLICITIES
    assert stabilizer_orders == EXPECTED_CLASS_STABILIZER_ORDERS
    weighted_histogram = Counter()
    for canonical_arc, members in classes.items():
        weighted_histogram[uncovered_mask(canonical_arc).bit_count()] += len(members)
    assert weighted_histogram == Counter(EXPECTED_U_HISTOGRAM)

    conics = nonsingular_conics()
    rows = []
    for class_index, canonical_arc in enumerate(sorted(classes), start=1):
        u_mask = uncovered_mask(canonical_arc)
        u_size = u_mask.bit_count()
        maximum_intersection = -1
        nearest_count = 0
        witness = None
        direct_minimum = len(POINTS) + 1
        direct_nearest_count = 0
        for coefficients, mask in conics:
            intersection = (u_mask & mask).bit_count()
            direct_distance = (u_mask ^ mask).bit_count()
            formula_distance = u_size + (P + 1) - 2 * intersection
            assert direct_distance == formula_distance
            if direct_distance < direct_minimum:
                direct_minimum = direct_distance
                direct_nearest_count = 1
            elif direct_distance == direct_minimum:
                direct_nearest_count += 1
            if intersection > maximum_intersection:
                maximum_intersection = intersection
                nearest_count = 1
                witness = coefficients
            elif intersection == maximum_intersection:
                nearest_count += 1
                if witness is None or coefficients < witness:
                    witness = coefficients
        assert witness is not None
        delta = u_size + (P + 1) - 2 * maximum_intersection
        assert delta == direct_minimum
        assert nearest_count == direct_nearest_count
        multiplicity = len(classes[canonical_arc])
        stabilizer_order = 360 // multiplicity
        rows.append((
            class_index, canonical_arc, multiplicity, stabilizer_order, u_size,
            delta, nearest_count, witness, maximum_intersection,
        ))

    assert [
        (row[4], row[5], row[6], row[8], row[7]) for row in rows
    ] == EXPECTED_CLASS_METRICS

    zero_rows = [row for row in rows if row[5] == 0]
    assert len(zero_rows) == 1
    assert zero_rows[0][4] == 12
    assert is_arc(BASE_ARC)
    assert projective_class_key(BASE_ARC) == zero_rows[0][1]
    delta_histogram = Counter(row[5] for row in rows)
    assert delta_histogram == Counter(EXPECTED_CLASS_DELTA_HISTOGRAM)
    nonclebsch_gap = min(row[5] for row in rows if row[5] != 0)
    assert nonclebsch_gap == 12

    print("enumeration_unit=projective_classes_from_all_ordered_frame_normalizations")
    print(f"frame_normalized_representatives={len(arcs)}")
    print(f"projective_classes={len(classes)}")
    print(f"class_multiplicities={multiplicities}")
    print(f"class_stabilizer_orders={stabilizer_orders}")
    print("projective_quadratic_forms=177156")
    print(f"nonsingular_conics={len(conics)}")
    print("conic_points_each=12")
    print("conics_through_each_point=14520")
    print("class|normalized_reps|stabilizer|canonical_arc|U_size|delta|nearest_conics|intersection|witness")
    for row in rows:
        (class_index, canonical_arc, multiplicity, stabilizer_order, u_size,
         delta, nearest_count, witness, intersection) = row
        print(
            f"C{class_index:02d}|{multiplicity}|{stabilizer_order}|"
            f"{format_arc(canonical_arc)}|{u_size}|{delta}|{nearest_count}|"
            f"{intersection}|{format_coefficients(witness)}"
        )
    print(f"clebsch_zero_delta_classes={len(zero_rows)}")
    print(f"base_arc_zero_delta_class=C{zero_rows[0][0]:02d}")
    print(f"class_delta_histogram={dict(sorted(delta_histogram.items()))}")
    print("direct_xor_distance_crosscheck=True")
    print(f"nonclebsch_global_delta_gap={nonclebsch_gap}")
    print("all assertions passed")


if __name__ == "__main__":
    main()
