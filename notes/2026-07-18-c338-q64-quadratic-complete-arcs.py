#!/usr/bin/env python3
"""Exact C338 certificate for the PG(2,64) quadratic/completion package."""

from __future__ import annotations

import argparse
import itertools
import json
import sys
from collections import Counter, defaultdict
from math import comb
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "papers" / "arcs_complete_outside_conic"
sys.path.insert(0, str(SOURCE))

from analyze_c210_q64_quadratic_orbits import repair_points  # noqa: E402
from probe_c210_two_layer_parabolas import (  # noqa: E402
    QuadraticField,
    covered_points,
    layer,
    line_points,
    projective_points,
)


Point = tuple[int, int, int]
Conic = tuple[int, int, int, int, int, int]
Vector = tuple[int, int, int]


def addv(field: QuadraticField, left: Vector, right: Vector) -> Vector:
    return tuple(field.add(x, y) for x, y in zip(left, right))  # type: ignore[return-value]


def scalev(field: QuadraticField, scalar: int, vector: Vector) -> Vector:
    return tuple(field.mul(scalar, x) for x in vector)  # type: ignore[return-value]


def determinant(field: QuadraticField, columns: tuple[Vector, Vector, Vector]) -> int:
    a, b, c = columns
    return field.add(
        field.add(
            field.mul(a[0], field.add(field.mul(b[1], c[2]), field.mul(b[2], c[1]))),
            field.mul(a[1], field.add(field.mul(b[0], c[2]), field.mul(b[2], c[0]))),
        ),
        field.mul(a[2], field.add(field.mul(b[0], c[1]), field.mul(b[1], c[0]))),
    )


def frame_coordinates(field: QuadraticField, frame: tuple[Vector, Vector, Vector],
                      point: Vector) -> Vector:
    denominator = determinant(field, frame)
    assert denominator
    return (
        field.div(determinant(field, (point, frame[1], frame[2])), denominator),
        field.div(determinant(field, (frame[0], point, frame[2])), denominator),
        field.div(determinant(field, (frame[0], frame[1], point)), denominator),
    )


def map_from_frames(field: QuadraticField, source_frame4: tuple[Point, Point, Point, Point],
                    target_frame4: tuple[Point, Point, Point, Point], point: Point) -> Point:
    source_frame = source_frame4[:3]
    target_frame = target_frame4[:3]
    coordinates = frame_coordinates(field, source_frame, point)
    source_fourth = frame_coordinates(field, source_frame, source_frame4[3])
    target_fourth = frame_coordinates(field, target_frame, target_frame4[3])
    assert all(source_fourth) and all(target_fourth)
    diagonal = tuple(field.div(target_fourth[i], source_fourth[i]) for i in range(3))
    image = (0, 0, 0)
    for i in range(3):
        image = addv(
            field,
            image,
            scalev(field, field.mul(diagonal[i], coordinates[i]), target_frame[i]),
        )
    return field.normalize(image)


def conic_row(field: QuadraticField, point: Point) -> Conic:
    x, y, z = point
    return (
        field.mul(x, x), field.mul(y, y), field.mul(z, z),
        field.mul(x, y), field.mul(x, z), field.mul(y, z),
    )


def rref_nullspace(field: QuadraticField, rows: list[list[int]]) -> list[Conic]:
    matrix = [row[:] for row in rows]
    pivots: list[int] = []
    pivot_row = 0
    for column in range(6):
        found = next((r for r in range(pivot_row, len(matrix)) if matrix[r][column]), None)
        if found is None:
            continue
        matrix[pivot_row], matrix[found] = matrix[found], matrix[pivot_row]
        inverse = field.inv(matrix[pivot_row][column])
        matrix[pivot_row] = [field.mul(inverse, value) for value in matrix[pivot_row]]
        for r in range(len(matrix)):
            if r != pivot_row and matrix[r][column]:
                multiple = matrix[r][column]
                matrix[r] = [
                    field.add(value, field.mul(multiple, pivot_value))
                    for value, pivot_value in zip(matrix[r], matrix[pivot_row])
                ]
        pivots.append(column)
        pivot_row += 1
    free = [column for column in range(6) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * 6
        vector[free_column] = 1
        for r, column in reversed(list(enumerate(pivots))):
            value = 0
            for other in free:
                value = field.add(value, field.mul(matrix[r][other], vector[other]))
            vector[column] = value
        basis.append(tuple(vector))
    return basis


def conic_value(field: QuadraticField, conic: Conic, point: Point) -> int:
    value = 0
    for coefficient, monomial in zip(conic, conic_row(field, point)):
        value = field.add(value, field.mul(coefficient, monomial))
    return value


def conic_through_five(field: QuadraticField,
                       points: tuple[Point, Point, Point, Point, Point]) -> Conic:
    """Return the unique conic through five points of an arc, without elimination."""
    frame = points[:3]
    fourth = frame_coordinates(field, frame, points[3])
    fifth = frame_coordinates(field, frame, points[4])

    def mixed_row(coordinates: Vector) -> Point:
        x, y, z = coordinates
        return field.mul(x, y), field.mul(x, z), field.mul(y, z)

    d, e, f = field.cross(mixed_row(fourth), mixed_row(fifth))

    def value_in_frame(original_vector: Vector) -> int:
        x, y, z = frame_coordinates(field, frame, original_vector)
        return field.add(
            field.add(field.mul(d, field.mul(x, y)), field.mul(e, field.mul(x, z))),
            field.mul(f, field.mul(y, z)),
        )

    standard = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
    a, b, c = (value_in_frame(vector) for vector in standard)
    xy = value_in_frame((1, 1, 0))
    xz = value_in_frame((1, 0, 1))
    yz = value_in_frame((0, 1, 1))
    conic = (
        a, b, c,
        field.add(field.add(xy, a), b),
        field.add(field.add(xz, a), c),
        field.add(field.add(yz, b), c),
    )
    return field.normalize(conic)  # type: ignore[arg-type,return-value]


def nonsingular_conic(field: QuadraticField, conic: Conic) -> bool:
    a, b, c, d, e, f = conic
    radical = (f, e, d)
    return conic_value(field, (a, b, c, d, e, f), radical) != 0


def linear_combination(field: QuadraticField, scalars: tuple[int, ...],
                       basis: list[Conic]) -> Conic:
    vector = [0] * 6
    for scalar, conic in zip(scalars, basis):
        for index, value in enumerate(conic):
            vector[index] = field.add(vector[index], field.mul(scalar, value))
    return field.normalize(tuple(vector))  # type: ignore[arg-type,return-value]


def fast_conic_value(conic: Conic, row: Conic, multiplication: list[list[int]]) -> int:
    value = 0
    for coefficient, monomial in zip(conic, row):
        value ^= multiplication[coefficient][monomial]
    return value


def fast_linear_combination(field: QuadraticField, scalars: tuple[int, ...],
                            basis: list[Conic], multiplication: list[list[int]]) -> Conic:
    vector = [0] * 6
    for scalar, conic in zip(scalars, basis):
        for index, value in enumerate(conic):
            vector[index] ^= multiplication[scalar][value]
    return field.normalize(tuple(vector))  # type: ignore[arg-type,return-value]


def rich_conics(field: QuadraticField, arc: frozenset[Point]) -> dict[Conic, int]:
    points = tuple(sorted(arc))
    conics: dict[Conic, int] = {}
    for subset in itertools.combinations(points, 5):
        conic = conic_through_five(field, subset)
        if conic in conics:
            continue
        count = sum(conic_value(field, conic, point) == 0 for point in points)
        if count >= 5:
            conics[conic] = count
    return conics


def four_subset_conic_counts(field: QuadraticField, arc: frozenset[Point]) -> Counter[int]:
    """Independently count nonsingular conics with >=4 arc points."""
    incidence = Counter()
    points = tuple(sorted(arc))
    for subset in itertools.combinations(points, 4):
        frame = subset[:3]
        fourth = frame_coordinates(field, frame, subset[3])
        coordinates = [frame_coordinates(field, frame, point) for point in points]
        coefficient_d = field.mul(fourth[0], fourth[1])
        coefficient_e = field.mul(fourth[0], fourth[2])
        coefficient_f = field.mul(fourth[1], fourth[2])
        for e in range(1, field.q):
            d = 1
            f = field.div(
                field.add(coefficient_d, field.mul(e, coefficient_e)), coefficient_f
            )
            if not f:
                continue
            intersection = 0
            for x, y, z in coordinates:
                value = field.add(
                    field.add(field.mul(d, field.mul(x, y)), field.mul(e, field.mul(x, z))),
                    field.mul(f, field.mul(y, z)),
                )
                intersection += value == 0
            incidence[intersection] += 1
    counts = Counter()
    for intersection, occurrences in incidence.items():
        assert occurrences % comb(intersection, 4) == 0
        counts[intersection] = occurrences // comb(intersection, 4)
    return counts


def quadratic_distribution(field: QuadraticField, arc: frozenset[Point],
                           base_rich: dict[Conic, int]) -> dict[str, object]:
    q = field.q
    rich = Counter(base_rich.values())
    expected_rich = Counter({5: 29240, 6: 1632, 7: 16, 8: 47, 10: 2})
    assert rich == expected_rich

    lambdas = {
        0: q * q * (q ** 3 - 1),
        1: q * q * (q * q - 1),
        2: q * q * (q - 1),
        3: (q - 1) ** 2,
        4: q - 2,
    }
    nonsingular = Counter({i: rich[i] for i in range(5, 11)})
    for j in range(4, -1, -1):
        right = comb(len(arc), j) * lambdas[j]
        known = sum(comb(i, j) * count for i, count in nonsingular.items() if i > j)
        nonsingular[j] = right - known
        assert nonsingular[j] >= 0
    for j in range(5):
        assert sum(comb(i, j) * nonsingular[i] for i in range(11)) == (
            comb(len(arc), j) * lambdas[j]
        )

    lines = tuple(sorted(field.normalize(line) for line in projective_points(field)))
    line_masks = []
    points = tuple(sorted(arc))
    line_distribution = Counter()
    for line in lines:
        mask = sum(
            (1 << index) for index, point in enumerate(points)
            if point in line_points(field, line)
        )
        line_masks.append(mask)
        line_distribution[mask.bit_count()] += 1
    assert line_distribution == Counter({0: 2877, 1: 1008, 2: 276})

    repeated = Counter(line_distribution)
    external, tangent, secant = (line_distribution[i] for i in range(3))
    tangent_pairs_at_arc_points = len(arc) * comb(q + 2 - len(arc), 2)
    tangent_secant_pairs_at_arc_points = (
        len(arc) * (q + 2 - len(arc)) * (len(arc) - 1)
    )
    secant_pairs_at_arc_points = len(arc) * comb(len(arc) - 1, 2)
    split_distinct = Counter({
        0: comb(external, 2),
        1: external * tangent + tangent_pairs_at_arc_points,
        2: (
            external * secant
            + comb(tangent, 2) - tangent_pairs_at_arc_points
            + tangent_secant_pairs_at_arc_points
        ),
        3: (
            tangent * secant - tangent_secant_pairs_at_arc_points
            + secant_pairs_at_arc_points
        ),
        4: comb(secant, 2) - secant_pairs_at_arc_points,
    })
    assert sum(split_distinct.values()) == comb(len(lines), 2)
    nonsplit_per_point = q * (q - 1) // 2
    nonsplit = Counter({0: (len(lines) - len(arc)) * nonsplit_per_point,
                        1: len(arc) * nonsplit_per_point})
    degenerate = repeated + split_distinct + nonsplit
    assert sum(degenerate.values()) == (q * q + q + 1) * (q * q + 1)

    all_projective = nonsingular + degenerate
    assert sum(all_projective.values()) == sum(q ** i for i in range(6))
    weight_enumerator = {0: 1}
    for intersection, count in sorted(all_projective.items()):
        weight_enumerator[len(arc) - intersection] = (q - 1) * count
    assert sum(weight_enumerator.values()) == q ** 6
    assert min(weight for weight in weight_enumerator if weight) == 14
    assert weight_enumerator[14] == 2 * (q - 1)

    maximal = [
        sorted(point for point in arc if conic_value(field, conic, point) == 0)
        for conic, intersection in base_rich.items() if intersection == 10
    ]
    assert len(maximal) == 2 and not (set(maximal[0]) & set(maximal[1]))
    return {
        "dimension": 6,
        "length": len(arc),
        "minimum_distance": 14,
        "moment_lambdas": lambdas,
        "nonsingular_conic_intersections": dict(sorted(nonsingular.items())),
        "independent_closed_form_rich_counts": dict(sorted(rich.items())),
        "line_distribution": dict(sorted(line_distribution.items())),
        "degenerate_intersections": dict(sorted(degenerate.items())),
        "all_projective_quadrics_by_zero_count": dict(sorted(all_projective.items())),
        "weight_enumerator": dict(sorted(weight_enumerator.items())),
        "minimum_projective_quadrics": 2,
        "minimum_nonzero_codewords": 2 * (q - 1),
        "minimum_zero_sets": maximal,
        "minimum_support_intersection_size": len(arc) - 20,
    }


def intrinsic_base_parts(field: QuadraticField, arc: frozenset[Point],
                         conics: dict[Conic, int]) -> tuple[frozenset[Point], ...]:
    maximal = [conic for conic, count in conics.items() if count == 10]
    parts = tuple(
        frozenset(point for point in arc if conic_value(field, conic, point) == 0)
        for conic in sorted(maximal)
    )
    assert len(parts) == 2 and not (parts[0] & parts[1])
    return parts + (frozenset(arc - parts[0] - parts[1]),)


def base_semilinear_maps(field: QuadraticField, arc: frozenset[Point],
                         parts: tuple[frozenset[Point], ...]) -> list[dict[str, object]]:
    source_frame4 = (
        sorted(parts[0])[0], sorted(parts[0])[1], sorted(parts[1])[0], sorted(parts[2])[0]
    )
    maps = []
    for exponent in (1, 2, 4, 8, 16, 32):
        frobenius_arc = frozenset(
            tuple(field.power(x, exponent) for x in point) for point in arc
        )
        frobenius_parts = tuple(
            frozenset(tuple(field.power(x, exponent) for x in point) for point in part)
            for part in parts
        )
        frobenius_frame4 = tuple(
            tuple(field.power(x, exponent) for x in point) for point in source_frame4
        )
        for permutation in ((0, 1, 2), (1, 0, 2)):
            first, second, third = (parts[index] for index in permutation)
            for target_frame4 in (
                (left, right, middle, last)
                for left, right in itertools.permutations(sorted(first), 2)
                for middle in sorted(second)
                for last in sorted(third)
            ):
                images = {
                    map_from_frames(field, frobenius_frame4, target_frame4, point)
                    for point in frobenius_arc
                }
                if images == arc:
                    maps.append({
                        "exponent": exponent,
                        "source_frame4": frobenius_frame4,
                        "target_frame4": target_frame4,
                    })
    return maps


def apply_semilinear_map(field: QuadraticField, record: dict[str, object], point: Point) -> Point:
    exponent = int(record["exponent"])
    source = tuple(field.power(x, exponent) for x in point)
    return map_from_frames(
        field,
        record["source_frame4"],  # type: ignore[arg-type]
        record["target_frame4"],  # type: ignore[arg-type]
        source,
    )


def pair_orbits(field: QuadraticField, missing: tuple[Point, ...],
                maps: list[dict[str, object]]) -> list[list[tuple[int, int]]]:
    index = {point: i for i, point in enumerate(missing)}
    actions = []
    for record in maps:
        permutation = tuple(index[apply_semilinear_map(field, record, point)] for point in missing)
        actions.append(permutation)
    unseen = set(itertools.combinations(range(len(missing)), 2))
    orbits = []
    while unseen:
        root = min(unseen)
        orbit = sorted({tuple(sorted((action[root[0]], action[root[1]]))) for action in actions})
        assert set(orbit) <= unseen
        unseen -= set(orbit)
        orbits.append(orbit)
    return orbits


def point_conic_signatures(arc: frozenset[Point], conics: dict[Conic, int],
                           field: QuadraticField) -> dict[Point, tuple[tuple[int, int], ...]]:
    signatures = {}
    for point in arc:
        profile = Counter(
            intersection for conic, intersection in conics.items()
            if conic_value(field, conic, point) == 0
        )
        signatures[point] = tuple(sorted(profile.items()))
    return signatures


def projective_isomorphism_count(field: QuadraticField, source: frozenset[Point],
                                 target: frozenset[Point], exponent: int = 1,
                                 source_conics: dict[Conic, int] | None = None,
                                 target_conics: dict[Conic, int] | None = None) -> int:
    source_conics = source_conics or rich_conics(field, source)
    target_conics = target_conics or rich_conics(field, target)
    if Counter(source_conics.values()) != Counter(target_conics.values()):
        return 0
    source_signatures = point_conic_signatures(source, source_conics, field)
    target_signatures = point_conic_signatures(target, target_conics, field)
    transformed = frozenset(
        tuple(field.power(x, exponent) for x in point) for point in source
    )
    transformed_signatures = {
        tuple(field.power(x, exponent) for x in point): signature
        for point, signature in source_signatures.items()
    }
    source_multiset = Counter(transformed_signatures.values())
    target_multiset = Counter(target_signatures.values())
    if source_multiset != target_multiset:
        return 0
    target_by_signature: dict[tuple[tuple[int, int], ...], list[Point]] = defaultdict(list)
    for point, signature in target_signatures.items():
        target_by_signature[signature].append(point)
    ordered_source = sorted(
        transformed,
        key=lambda point: (len(target_by_signature[transformed_signatures[point]]), point),
    )
    source_frame4 = tuple(ordered_source[:4])
    candidate_lists = [target_by_signature[transformed_signatures[point]] for point in source_frame4]
    count = 0
    for target_frame4 in itertools.product(*candidate_lists):
        if len(set(target_frame4)) != 4:
            continue
        images = {
            map_from_frames(field, source_frame4, target_frame4, point) for point in transformed
        }
        if images == target:
            count += 1
    return count


def completion_rich_conics(field: QuadraticField, base: frozenset[Point],
                           added: tuple[Point, Point], base_rich: dict[Conic, int],
                           one_added: dict[Point, set[Conic]],
                           three_spaces: list[list[Conic]],
                           base_count_cache: dict[Conic, int], rows: dict[Point, Conic],
                           multiplication: list[list[int]]) -> dict[Conic, int]:
    """Reuse the base and one-added pencils across the 171 completions."""
    pair_candidates = set()
    for basis in three_spaces:
        left_values = tuple(fast_conic_value(conic, rows[added[0]], multiplication)
                            for conic in basis)
        right_values = tuple(fast_conic_value(conic, rows[added[1]], multiplication)
                             for conic in basis)
        scalars = field.cross(left_values, right_values)
        pair_candidates.add(fast_linear_combination(field, scalars, basis, multiplication))
    result = {}

    def base_count(conic: Conic) -> int:
        if conic not in base_count_cache:
            base_count_cache[conic] = sum(
                fast_conic_value(conic, rows[point], multiplication) == 0 for point in base
            )
        return base_count_cache[conic]

    def record(conic: Conic, intersection: int) -> None:
        if intersection >= 5:
            if conic in result:
                assert result[conic] == intersection
            result[conic] = intersection

    for conic in base_rich:
        record(conic, base_count(conic) + sum(
            fast_conic_value(conic, rows[point], multiplication) == 0 for point in added
        ))
    for conic in one_added[added[0]]:
        record(conic, base_count(conic) + 1
               + (fast_conic_value(conic, rows[added[1]], multiplication) == 0))
    for conic in one_added[added[1]]:
        record(conic, base_count(conic) + 1
               + (fast_conic_value(conic, rows[added[0]], multiplication) == 0))
    for conic in pair_candidates:
        record(conic, base_count(conic) + 2)
    return result


def distinguished_deletions(field: QuadraticField, completion: frozenset[Point],
                            plane: tuple[Point, ...], plane_index: dict[Point, int],
                            line_mask_cache: dict[Point, int]) -> list[tuple[Point, Point]]:
    """Find deletions leaving exactly 19 uncovered collinear projective points."""
    all_mask = (1 << len(plane)) - 1

    def mask_for_line(line: Point) -> int:
        if line not in line_mask_cache:
            line_mask_cache[line] = sum(
                1 << plane_index[point] for point in line_points(field, line)
            )
        return line_mask_cache[line]

    points = tuple(sorted(completion))
    edges = [
        (i, j, mask_for_line(field.cross(left, right)))
        for (i, left), (j, right) in itertools.combinations(enumerate(points), 2)
    ]
    distinguished = []
    for deleted_i, deleted_j in itertools.combinations(range(len(points)), 2):
        covered = 0
        for i, j, line_mask in edges:
            if i not in (deleted_i, deleted_j) and j not in (deleted_i, deleted_j):
                covered |= line_mask
        uncovered_mask = all_mask & ~covered
        if uncovered_mask.bit_count() != 19:
            continue
        uncovered = [plane[i] for i in range(len(plane)) if uncovered_mask & (1 << i)]
        carrier = field.cross(uncovered[0], uncovered[1])
        if all(point in line_points(field, carrier) for point in uncovered):
            distinguished.append((points[deleted_i], points[deleted_j]))
    return distinguished


def completion_package(field: QuadraticField, arc: frozenset[Point],
                       base_rich: dict[Conic, int]) -> dict[str, object]:
    all_points = projective_points(field)
    plane = tuple(sorted(all_points))
    plane_index = {point: index for index, point in enumerate(plane)}
    line_mask_cache: dict[Point, int] = {}
    missing = tuple(sorted(all_points - covered_points(field, tuple(sorted(arc)))))
    assert len(missing) == 19 and all(point[0] == 0 for point in missing)
    translation_stabilizer = []
    for delta_y in range(field.q):
        for delta_z in range(field.q):
            image = frozenset(
                (1, field.add(y, delta_y), field.add(z, delta_z)) for _, y, z in arc
            )
            if image == arc:
                translation_stabilizer.append((delta_y, delta_z))
    assert len(translation_stabilizer) == 4
    # C300 certifies that these four translations are the full PGL and PΓL stabilizers.
    # Every translation fixes the line X=0 pointwise.
    pairs = list(itertools.combinations(range(len(missing)), 2))
    projective_orbits = [[pair] for pair in pairs]
    semilinear_orbits = [[pair] for pair in pairs]

    for left, right in itertools.combinations(missing, 2):
        completed = tuple(sorted(arc | {left, right}))
        secants = {field.cross(x, y) for x, y in itertools.combinations(completed, 2)}
        assert len(secants) == comb(26, 2)
        assert not (all_points - covered_points(field, completed))

    base_points = tuple(sorted(arc))
    multiplication = [[field.mul(left, right) for right in range(field.q)]
                      for left in range(field.q)]
    rows = {point: conic_row(field, point) for point in all_points}
    four_pencils = [
        rref_nullspace(field, [list(conic_row(field, point)) for point in subset])
        for subset in itertools.combinations(base_points, 4)
    ]
    assert all(len(basis) == 2 for basis in four_pencils)
    three_spaces = [
        rref_nullspace(field, [list(conic_row(field, point)) for point in subset])
        for subset in itertools.combinations(base_points, 3)
    ]
    assert all(len(basis) == 3 for basis in three_spaces)
    one_added: dict[Point, set[Conic]] = {}
    for added in missing:
        conics = set()
        for basis in four_pencils:
            left, right = (fast_conic_value(conic, rows[added], multiplication)
                           for conic in basis)
            conics.add(fast_linear_combination(
                field, (right, left), basis, multiplication
            ))
        one_added[added] = conics
    base_count_cache = dict(base_rich)

    representatives = []
    for orbit in projective_orbits:
        pair = orbit[0]
        completion = frozenset(arc | {missing[pair[0]], missing[pair[1]]})
        added = (missing[pair[0]], missing[pair[1]])
        conics = completion_rich_conics(
            field, arc, added, base_rich, one_added, three_spaces, base_count_cache,
            rows, multiplication,
        )
        if not representatives:
            assert conics == rich_conics(field, completion)
        base_pair_stabilizer = len(translation_stabilizer) // len(orbit)
        intrinsic_deletions = distinguished_deletions(
            field, completion, plane, plane_index, line_mask_cache
        )
        assert intrinsic_deletions == [tuple(sorted(added))]
        projective_aut = base_pair_stabilizer
        semilinear_aut = base_pair_stabilizer
        representatives.append({
            "pair_indices": pair,
            "pair_points": [missing[pair[0]], missing[pair[1]]],
            "base_stabilizer_orbit_size": len(orbit),
            "base_pair_stabilizer_order": base_pair_stabilizer,
            "conic_signature_ge_5": dict(sorted(Counter(conics.values()).items())),
            "intrinsic_base_deletion_pairs": intrinsic_deletions,
            "projective_automorphism_order": projective_aut,
            "semilinear_automorphism_order": semilinear_aut,
        })

    return {
        "missing_directions": missing,
        "completion_pairs_checked": comb(len(missing), 2),
        "all_pairs_are_26_arcs": True,
        "all_pairs_are_complete": True,
        "base_projective_stabilizer_order": len(translation_stabilizer),
        "base_semilinear_stabilizer_order": len(translation_stabilizer),
        "translation_stabilizer": translation_stabilizer,
        "projective_pair_orbit_count": len(projective_orbits),
        "semilinear_pair_orbit_count": len(semilinear_orbits),
        "projective_pair_orbit_sizes": dict(sorted(Counter(map(len, projective_orbits)).items())),
        "semilinear_pair_orbit_sizes": dict(sorted(Counter(map(len, semilinear_orbits)).items())),
        "representatives": representatives,
        "code_consequences": {
            "primal": "[26,3,24]_64 non-GRS nonextendable MDS",
            "dual": "[26,23,4]_64 covering-radius-2 quasi-perfect MDS",
        },
    }


def load_arc() -> tuple[QuadraticField, frozenset[Point], list[int]]:
    field = QuadraticField.for_subfield_order(8)
    subfield = tuple(x for x in range(field.q) if field.in_subfield(x))
    record = json.loads(
        (SOURCE / "probe_c210_quadratic_coset_repairs_output.txt").read_text().splitlines()[-1]
    )
    alpha, beta = record["seed_offsets"]
    representative = record["nonlinear_legal_parameters"][0][:4]
    arc = frozenset(
        layer(field, alpha, subfield)
        + layer(field, beta, subfield)
        + tuple(repair_points(field, subfield, *representative))
    )
    assert len(arc) == 24
    return field, arc, representative


def generate() -> dict[str, object]:
    field, arc, representative = load_arc()
    base_rich = rich_conics(field, arc)
    return {
        "schema": "c338-q64-quadratic-complete-arcs-v1",
        "field": "GF(64)=GF(2)[x]/(x^6+x+1)",
        "representative": representative,
        "quadratic_code": quadratic_distribution(field, arc, base_rich),
        "completion_package": completion_package(field, arc, base_rich),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    serialized = json.dumps(generate(), sort_keys=True, separators=(",", ":")) + "\n"
    output = Path(__file__).with_name("2026-07-18-c338-q64-quadratic-complete-arcs.json")
    if args.check:
        assert output.read_text() == serialized
    else:
        print(serialized, end="")


if __name__ == "__main__":
    main()
