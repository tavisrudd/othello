#!/usr/bin/env python3
"""Exact projective/arithmetic classification of the C210 PG(2,64) arcs."""

from __future__ import annotations

import argparse
import itertools
import json
from collections import Counter
from pathlib import Path

from analyze_c210_q64_affine_coverage import Point
from analyze_c210_q64_quadratic_orbits import repair_points
from probe_c210_two_layer_parabolas import (
    QuadraticField,
    additive_cosets,
    layer,
    line_points,
)

Vector = tuple[int, int, int]
Conic = tuple[int, int, int, int, int, int]


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
    assert denominator != 0
    return (
        field.div(determinant(field, (point, frame[1], frame[2])), denominator),
        field.div(determinant(field, (frame[0], point, frame[2])), denominator),
        field.div(determinant(field, (frame[0], frame[1], point)), denominator),
    )


def projective_maps(field: QuadraticField, source: frozenset[Point],
                    target: frozenset[Point], source_parts: tuple[frozenset[Point], ...],
                    target_parts: tuple[frozenset[Point], ...]) -> list[tuple[Point, Point, Point, Point]]:
    """Exhaust projectivities source -> target by images of one ordered frame."""
    source_points = tuple(sorted(source))
    source_frame4 = (
        sorted(source_parts[0])[0], sorted(source_parts[0])[1],
        sorted(source_parts[1])[0], sorted(source_parts[2])[0],
    )
    source_frame = source_frame4[:3]
    source_fourth = source_frame4[3]
    source_coordinates = {
        point: frame_coordinates(field, source_frame, point) for point in source_points
    }
    fourth_coordinates = source_coordinates[source_fourth]
    assert all(fourth_coordinates)
    maps = []
    target_frames = []
    for part_permutation in ((0, 1, 2), (1, 0, 2)):
        first, second, third = (target_parts[index] for index in part_permutation)
        target_frames.extend(
            (left, right, middle, last)
            for left, right in itertools.permutations(sorted(first), 2)
            for middle in sorted(second)
            for last in sorted(third)
        )
    for target_frame4 in target_frames:
        target_frame = target_frame4[:3]
        if determinant(field, target_frame) == 0:
            continue
        target_fourth_coordinates = frame_coordinates(field, target_frame, target_frame4[3])
        if not all(target_fourth_coordinates):
            continue
        diagonal = tuple(
            field.div(target_fourth_coordinates[i], fourth_coordinates[i]) for i in range(3)
        )
        images = set()
        for point in source_points:
            coordinates = source_coordinates[point]
            image = (0, 0, 0)
            for i in range(3):
                image = addv(
                    field,
                    image,
                    scalev(field, field.mul(diagonal[i], coordinates[i]), target_frame[i]),
                )
            normalized = field.normalize(image)
            if normalized not in target:
                break
            images.add(normalized)
        if images == target:
            maps.append(target_frame4)
    return maps


def frobenius_arc(field: QuadraticField, arc: frozenset[Point], exponent: int) -> frozenset[Point]:
    return frozenset(
        tuple(field.power(coordinate, exponent) for coordinate in point)  # type: ignore[misc]
        for point in arc
    )


def conic_row(field: QuadraticField, point: Point) -> Conic:
    x, y, z = point
    return (
        field.mul(x, x), field.mul(y, y), field.mul(z, z),
        field.mul(x, y), field.mul(x, z), field.mul(y, z),
    )


def nullspace_one(field: QuadraticField, rows: list[list[int]]) -> Conic | None:
    matrix = [row[:] for row in rows]
    pivots = []
    pivot_row = 0
    for column in range(6):
        found = next((r for r in range(pivot_row, len(matrix)) if matrix[r][column]), None)
        if found is None:
            continue
        matrix[pivot_row], matrix[found] = matrix[found], matrix[pivot_row]
        inverse = field.div(1, matrix[pivot_row][column])
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
    if len(free) != 1:
        return None
    vector = [0] * 6
    vector[free[0]] = 1
    for r, column in reversed(list(enumerate(pivots))):
        vector[column] = field.add(
            vector[column],
            field.mul(matrix[r][free[0]], vector[free[0]]),
        )
    return field.normalize(tuple(vector))  # type: ignore[arg-type,return-value]


def conic_value(field: QuadraticField, conic: Conic, point: Point) -> int:
    value = 0
    for coefficient, monomial in zip(conic, conic_row(field, point)):
        value = field.add(value, field.mul(coefficient, monomial))
    return value


def rich_conics(field: QuadraticField, arc: frozenset[Point]) -> dict[Conic, int]:
    points = tuple(sorted(arc))
    conics = {}
    for subset in itertools.combinations(points, 5):
        conic = nullspace_one(field, [list(conic_row(field, point)) for point in subset])
        if conic is None or conic in conics:
            continue
        count = sum(conic_value(field, conic, point) == 0 for point in points)
        if count >= 5:
            conics[conic] = count
    return conics


def intrinsic_parts(field: QuadraticField, arc: frozenset[Point],
                    conics: dict[Conic, int]) -> tuple[frozenset[Point], ...]:
    maximum = max(conics.values())
    maximal = [conic for conic, count in conics.items() if count == maximum]
    conic_parts = tuple(
        frozenset(point for point in arc if conic_value(field, conic, point) == 0)
        for conic in sorted(maximal)
    )
    assert len(conic_parts) == 2
    assert all(len(part) == 10 for part in conic_parts)
    assert not (conic_parts[0] & conic_parts[1])
    remainder = frozenset(arc - conic_parts[0] - conic_parts[1])
    assert len(remainder) == 4
    return conic_parts + (remainder,)


def binary_rank(values: set[int]) -> int:
    basis: dict[int, int] = {}
    for value in values:
        reduced = value
        while reduced:
            pivot = reduced.bit_length() - 1
            if pivot not in basis:
                basis[pivot] = reduced
                break
            reduced ^= basis[pivot]
    return len(basis)


def affine_binary_profile(points: set[Point]) -> dict[str, object]:
    encoded = {point[1] | (point[2] << 6) for point in points}
    origin = min(encoded)
    differences = {value ^ origin for value in encoded}
    translations = sorted(
        shift for shift in differences if {value ^ shift for value in encoded} == encoded
    )
    return {
        "size": len(points),
        "affine_span_dimension_over_gf2": binary_rank(differences),
        "translation_stabilizer_size": len(translations),
        "translation_stabilizer": translations,
    }


def translation_isomorphisms(left: set[Point], right: set[Point]) -> list[int]:
    encoded_left = {point[1] | (point[2] << 6) for point in left}
    encoded_right = {point[1] | (point[2] << 6) for point in right}
    origin = min(encoded_left)
    return sorted(
        shift for target in encoded_right
        if {value ^ (origin ^ target) for value in encoded_left} == encoded_right
        for shift in (origin ^ target,)
    )


def coverage_residues(field: QuadraticField, labelled: list[tuple[str, Point]]) -> dict[str, object]:
    category_names = ("AA", "AB", "AR", "BB", "BR", "RR")
    covered: dict[str, set[Point]] = {name: set() for name in category_names}
    for (left_label, left), (right_label, right) in itertools.combinations(labelled, 2):
        name = "".join(sorted((left_label, right_label)))
        covered[name].update(
            point for point in line_points(field, field.cross(left, right)) if point[0] == 1
        )
    affine_plane = {(1, y, z) for y in range(field.q) for z in range(field.q)}
    cross_residue = affine_plane - set().union(*(covered[name] for name in ("AB", "AR", "BR")))
    after_a = cross_residue - covered["AA"]
    after_b = cross_residue - covered["BB"]
    assert len(cross_residue) == 56 and len(after_a) == len(after_b) == 14
    assert not (after_a & after_b)
    both_same_seed = cross_residue & covered["AA"] & covered["BB"]
    only_a = cross_residue & covered["AA"] - covered["BB"]
    only_b = cross_residue & covered["BB"] - covered["AA"]
    assert (len(both_same_seed), len(only_a), len(only_b)) == (28, 14, 14)
    return {
        "cross_layer_residue": affine_binary_profile(cross_residue),
        "after_AA_residue": affine_binary_profile(after_a),
        "after_BB_residue": affine_binary_profile(after_b),
        "translations_after_AA_to_after_BB": translation_isomorphisms(after_a, after_b),
        "after_AA_intersection_after_BB": len(after_a & after_b),
        "partition_by_same_seed_coverage": {
            "covered_by_both": len(both_same_seed),
            "covered_only_by_AA": len(only_a),
            "covered_only_by_BB": len(only_b),
        },
    }


def generate() -> dict[str, object]:
    field = QuadraticField.for_subfield_order(8)
    subfield = tuple(x for x in range(field.q) if field.in_subfield(x))
    source_path = Path(__file__).with_name("probe_c210_quadratic_coset_repairs_output.txt")
    record = json.loads(source_path.read_text().splitlines()[-1])
    alpha, beta = record["seed_offsets"]
    survivors = [row[:4] for row in record["nonlinear_legal_parameters"]]
    representatives = (survivors[0], survivors[4], survivors[8])
    seed_a = tuple(layer(field, alpha, subfield))
    seed_b = tuple(layer(field, beta, subfield))
    arcs = []
    for row in representatives:
        repair = repair_points(field, subfield, *row)
        arcs.append(frozenset(seed_a + seed_b) | repair)

    conics_by_arc = [rich_conics(field, arc) for arc in arcs]
    parts_by_arc = [intrinsic_parts(field, arc, conics) for arc, conics in zip(arcs, conics_by_arc)]
    projective_counts = []
    semilinear_counts = []
    for i in range(3):
        projective_row = []
        semilinear_row = []
        for j in range(3):
            counts = []
            for exponent in (1, 2, 4, 8, 16, 32):
                frobenius_source = frobenius_arc(field, arcs[i], exponent)
                frobenius_parts = tuple(
                    frozenset(
                        tuple(field.power(coordinate, exponent) for coordinate in point)
                        for point in part
                    )
                    for part in parts_by_arc[i]
                )
                counts.append(len(projective_maps(
                    field, frobenius_source, arcs[j], frobenius_parts, parts_by_arc[j]
                )))
            projective_row.append(counts[0])
            semilinear_row.append(sum(counts))
        projective_counts.append(projective_row)
        semilinear_counts.append(semilinear_row)

    conic_records = []
    for conics in conics_by_arc:
        conic_records.append({
            "intersection_profile": dict(sorted(Counter(conics.values()).items())),
            "max_intersection": max(conics.values()),
            "maximal_conics": [list(conic) for conic, count in sorted(conics.items())
                               if count == max(conics.values())],
        })

    labelled = [("A", point) for point in seed_a] + [("B", point) for point in seed_b]
    labelled += [("R", point) for point in sorted(repair_points(field, subfield, *representatives[0]))]
    direction_count = 65 - 19
    return {
        "schema": "c300-q64-arithmetic-classification-v1",
        "field": "GF(64) with distinguished GF(8)",
        "arc_size": 24,
        "representatives": representatives,
        "full_pgl3_equivalence_counts": projective_counts,
        "full_pgamma_l3_equivalence_counts": semilinear_counts,
        "pgl3_stabilizer_orders": [projective_counts[i][i] for i in range(3)],
        "pgamma_l3_stabilizer_orders": [semilinear_counts[i][i] for i in range(3)],
        "projective_orbit_count": 3,
        "semilinear_orbit_count": 1,
        "rich_conics": conic_records,
        "secant_directions": direction_count,
        "missing_directions": 19,
        "hyperfocused_required_directions": 23,
        "is_hyperfocused": direction_count == 23,
        "coverage_residues": coverage_residues(field, labelled),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    serialized = json.dumps(generate(), sort_keys=True, separators=(",", ":")) + "\n"
    output_path = Path(__file__).with_name("analyze_c300_q64_arithmetic_classification_output.json")
    if args.check:
        assert output_path.read_text() == serialized
    else:
        print(serialized, end="")


if __name__ == "__main__":
    main()
