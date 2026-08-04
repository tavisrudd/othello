#!/usr/bin/env python3
"""Build and verify the compact finite-census certificates.

The default mode checks the tracked proof objects directly.  ``--audit``
regenerates them from the full frame-normalized enumerations and compares the
canonical JSON byte for byte; ``--write`` updates the tracked JSON.
"""

from __future__ import annotations

import argparse
import json
from collections import Counter, defaultdict
from itertools import combinations, permutations
from pathlib import Path
from typing import Iterable, Sequence

import sys


PAPER_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PAPER_ROOT))

import check_global_conic_gap as gap  # noqa: E402
import check_low_degree_loci as low  # noqa: E402
import check_small_k_conic_filling as small  # noqa: E402


CERTIFICATE = Path(__file__).with_name("finite_census_certificates.json")
SCHEMA = "clebsch-finite-census-certificates-v1"
EXPECTED_NORMALIZED_SEVEN = {11: 140, 13: 1680}

Point = tuple[int, int, int]
Arc = tuple[Point, ...]
Matrix = tuple[tuple[int, int, int], ...]


def determinant_mod(matrix: Sequence[Sequence[int]], q: int) -> int:
    work = [[entry % q for entry in row] for row in matrix]
    result = 1
    for column in range(len(work)):
        pivot = next(
            (row for row in range(column, len(work)) if work[row][column]), None
        )
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            result = -result
        value = work[column][column]
        result = result * value % q
        inverse = pow(value, q - 2, q)
        for row in range(column + 1, len(work)):
            factor = work[row][column] * inverse % q
            for entry in range(column, len(work)):
                work[row][entry] = (
                    work[row][entry] - factor * work[column][entry]
                ) % q
    return result % q


def rank_mod(rows: Sequence[Sequence[int]], q: int) -> int:
    return len(small.rref(rows, q)[1])


def independent_minor(
    points: Sequence[Point], rows: Sequence[Sequence[int]], width: int, q: int
) -> tuple[list[list[int]], int]:
    chosen_points: list[Point] = []
    chosen_rows: list[Sequence[int]] = []
    for point, row in zip(points, rows):
        if rank_mod(chosen_rows + [row], q) > len(chosen_rows):
            chosen_points.append(point)
            chosen_rows.append(row)
        if len(chosen_rows) == width:
            break
    assert len(chosen_rows) == width
    determinant = determinant_mod(chosen_rows, q)
    assert determinant
    return [list(point) for point in chosen_points], determinant


def matrix_from_columns(columns: tuple[Point, Point, Point]) -> Matrix:
    return tuple(
        tuple(columns[column][row] for column in range(3)) for row in range(3)
    )  # type: ignore[return-value]


def matrix_vector(matrix: Matrix, vector: Point, q: int) -> Point:
    return tuple(
        sum(matrix[row][column] * vector[column] for column in range(3)) % q
        for row in range(3)
    )  # type: ignore[return-value]


def matrix_inverse(matrix: Matrix, q: int) -> Matrix:
    augmented = [
        [matrix[row][column] % q for column in range(3)]
        + [int(row == column) for column in range(3)]
        for row in range(3)
    ]
    for column in range(3):
        pivot = next(row for row in range(column, 3) if augmented[row][column])
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        scale = pow(augmented[column][column], q - 2, q)
        augmented[column] = [entry * scale % q for entry in augmented[column]]
        for row in range(3):
            if row == column:
                continue
            factor = augmented[row][column]
            augmented[row] = [
                (left - factor * right) % q
                for left, right in zip(augmented[row], augmented[column])
            ]
    return tuple(tuple(row[3:]) for row in augmented)  # type: ignore[return-value]


def normalize_point(point: Point, q: int) -> Point:
    pivot = next(entry for entry in point if entry)
    inverse = pow(pivot, q - 2, q)
    return tuple(entry * inverse % q for entry in point)  # type: ignore[return-value]


def normalize_ordered_frame(arc: Arc, ordered_frame: tuple[Point, ...], q: int) -> Arc:
    first, second, third, fourth = ordered_frame
    inverse = matrix_inverse(matrix_from_columns((first, second, third)), q)
    fourth_coordinates = matrix_vector(inverse, fourth, q)
    assert all(fourth_coordinates)
    diagonal = tuple(
        tuple(
            pow(fourth_coordinates[row], q - 2, q) if row == column else 0
            for column in range(3)
        )
        for row in range(3)
    )
    transformation = tuple(
        tuple(
            sum(diagonal[i][k] * inverse[k][j] for k in range(3)) % q
            for j in range(3)
        )
        for i in range(3)
    )
    return tuple(
        sorted(
            normalize_point(matrix_vector(transformation, point, q), q)
            for point in arc
        )
    )


def normalized_orbit(arc: Arc, q: int) -> set[Arc]:
    return {
        normalize_ordered_frame(arc, ordered_frame, q)
        for ordered_frame in permutations(arc, 4)
    }


def projective_key(arc: Arc, q: int) -> Arc:
    return min(normalized_orbit(arc, q))


def point_on_chord(point: Point, chord: Point, q: int) -> bool:
    return small.dot(point, chord, q) == 0


def chord_data(arc: Arc, q: int) -> tuple[list[Point], Counter[int]]:
    chords = [small.cross(left, right, q) for left, right in combinations(arc, 2)]
    assert len(set(chords)) == len(chords)
    arc_set = set(arc)
    concurrence = Counter()
    for point in small.canonical_points(q):
        if point in arc_set:
            continue
        multiplicity = sum(point_on_chord(point, chord, q) for chord in chords)
        concurrence[multiplicity] += 1
    assert max(concurrence) <= 3
    return chords, concurrence


def uncovered_points(arc: Arc, q: int) -> list[Point]:
    chords, _ = chord_data(arc, q)
    return [
        point
        for point in small.canonical_points(q)
        if point not in arc and not any(point_on_chord(point, chord, q) for chord in chords)
    ]


def encode_arc(arc: Arc) -> list[list[int]]:
    return [list(point) for point in arc]


def decode_arc(value: object) -> Arc:
    assert isinstance(value, list)
    return tuple(tuple(int(entry) for entry in point) for point in value)  # type: ignore[misc,return-value]


def cubic_row(point: Point, q: int) -> list[int]:
    return list(low.point_features(point, low.homogeneous_monomials(3)))


def quadratic_row(point: Point, q: int) -> list[int]:
    return small.quadratic_row(point, q)


def low_quadratic_row(point: Point) -> list[int]:
    return list(low.point_features(point, low.homogeneous_monomials(2)))


def q11_classes() -> tuple[list[Arc], dict[Arc, list[Arc]]]:
    representatives = gap.frame_normalized_census()
    classes: dict[Arc, list[Arc]] = defaultdict(list)
    for arc in representatives:
        classes[gap.projective_class_key(arc)].append(arc)
    assert len(classes) == 15
    return sorted(classes), classes


def conic_metrics(arcs: Sequence[Arc]) -> list[dict[str, object]]:
    uncovered_masks = [gap.uncovered_mask(arc) for arc in arcs]
    histograms = [Counter() for _ in arcs]
    maxima = [-1 for _ in arcs]
    nearest_counts = [0 for _ in arcs]
    witnesses: list[tuple[int, ...] | None] = [None for _ in arcs]
    for coefficients, mask in gap.nonsingular_conics():
        for index, uncovered in enumerate(uncovered_masks):
            intersection = (uncovered & mask).bit_count()
            histograms[index][intersection] += 1
            if intersection > maxima[index]:
                maxima[index] = intersection
                nearest_counts[index] = 1
                witnesses[index] = coefficients
            elif intersection == maxima[index]:
                nearest_counts[index] += 1
                if witnesses[index] is None or coefficients < witnesses[index]:
                    witnesses[index] = coefficients
    result = []
    for uncovered, intersections, maximum, nearest_count, witness in zip(
        uncovered_masks, histograms, maxima, nearest_counts, witnesses
    ):
        assert witness is not None
        result.append(
            {
                "delta": uncovered.bit_count() + 12 - 2 * maximum,
                "intersection_histogram": {
                    str(key): value for key, value in sorted(intersections.items())
                },
                "nearest_conics": nearest_count,
                "witness": list(witness),
            }
        )
    return result


def build_q11_census() -> dict[str, object]:
    arcs, classes = q11_classes()
    metrics = conic_metrics(arcs)
    records = []
    for index, (arc, metric) in enumerate(zip(arcs, metrics), start=1):
        orbit = normalized_orbit(arc, 11)
        assert orbit == set(classes[arc])
        stabilizer = 360 // len(orbit)
        _chords, concurrence = chord_data(arc, 11)
        n3 = concurrence[3]
        formula_size = 22 - n3
        assert formula_size == gap.uncovered_mask(arc).bit_count()
        record: dict[str, object] = {
            "id": f"C{index:02d}",
            "representative": encode_arc(arc),
            "normalized_orbit_mass": len(orbit),
            "stabilizer_order": stabilizer,
            "triple_concurrences": n3,
            "uncovered_size_from_chord_defect": formula_size,
            "conic_gap": metric,
        }
        uncovered = uncovered_points(arc, 11)
        if index != 15:
            points, determinant = independent_minor(
                uncovered, [cubic_row(point, 11) for point in uncovered], 10, 11
            )
            record["cubic_rank_witness"] = {
                "points": points,
                "determinant_mod_11": determinant,
            }
        else:
            quadratic = low.EXPECTED_EXACT_FORMS[15]
            quadratic_kernel = low.nullspace(low.evaluation_matrix(gap.uncovered_mask(arc), 2))
            cubic_kernel = low.nullspace(low.evaluation_matrix(gap.uncovered_mask(arc), 3))
            assert len(quadratic_kernel) == 1
            assert low.canonical_polynomial(quadratic_kernel[0]) == quadratic
            product_matrix = low.multiplication_matrix(quadratic, 2, 3)
            cubic_generators = [list(column) for column in zip(*product_matrix)]
            assert rank_mod(cubic_generators, 11) == 3
            record["clebsch_kernel"] = {
                "quadratic_generator": list(quadratic),
                "quadratic_nullity": len(quadratic_kernel),
                "cubic_nullity": len(cubic_kernel),
                "cubic_generators_q_times_x_y_z": cubic_generators,
            }
        records.append(record)
    return {
        "normalized_domain_mass": 1548,
        "ordered_frames_per_arc": 360,
        "records": records,
    }


def seven_arc_candidates(q: int) -> tuple[list[Point], set[int]]:
    points = small.canonical_points(q)
    point_index = {point: index for index, point in enumerate(points)}
    full_mask = (1 << len(points)) - 1
    line_masks: dict[Point, int] = {}

    def line_mask(line: Point) -> int:
        if line not in line_masks:
            line_masks[line] = sum(
                1 << index
                for index, point in enumerate(points)
                if small.dot(line, point, q) == 0
            )
        return line_masks[line]

    def uncovered_mask(indices: Sequence[int]) -> int:
        covered = sum(1 << index for index in indices)
        for left, right in combinations(indices, 2):
            covered |= line_mask(small.cross(points[left], points[right], q))
        return full_mask ^ covered

    frame_indices = tuple(point_index[point] for point in small.FRAME)
    affine_candidates = [
        point
        for point in points
        if point[0]
        and point[1]
        and point[2]
        and len(set(point)) == 3
    ]
    seven_masks: set[int] = set()
    for left, right in combinations(affine_candidates, 2):
        six = frame_indices + (point_index[left], point_index[right])
        if not all(small.determinant(points[f], left, right, q) for f in frame_indices):
            continue
        base = sum(1 << index for index in six)
        for extension in small.indices(uncovered_mask(six)):
            seven_masks.add(base | (1 << extension))
    selected = {
        mask
        for mask in seven_masks
        if uncovered_mask(small.indices(mask)).bit_count() == q + 1
    }
    assert len(selected) == EXPECTED_NORMALIZED_SEVEN[q]
    return points, selected


def build_seven_arc_orbits(q: int) -> dict[str, object]:
    points, masks = seven_arc_candidates(q)
    remaining = {
        tuple(sorted(points[index] for index in small.indices(mask))) for mask in masks
    }
    classes: dict[Arc, list[Arc]] = {}
    while remaining:
        seed = min(remaining)
        orbit = normalized_orbit(seed, q)
        assert orbit <= remaining
        representative = min(orbit)
        classes[representative] = sorted(orbit)
        remaining.difference_update(orbit)
    records = []
    for index, arc in enumerate(sorted(classes), start=1):
        orbit = normalized_orbit(arc, q)
        assert orbit == set(classes[arc])
        _chords, concurrence = chord_data(arc, q)
        n3 = concurrence[3]
        assert q * q - 20 * q + 120 - n3 == q + 1
        uncovered = uncovered_points(arc, q)
        witness_points, determinant = independent_minor(
            uncovered, [quadratic_row(point, q) for point in uncovered], 6, q
        )
        records.append(
            {
                "id": f"q{q}-O{index:02d}",
                "representative": encode_arc(arc),
                "normalized_orbit_mass": len(orbit),
                "stabilizer_order": 840 // len(orbit),
                "triple_concurrences": n3,
                "uncovered_size_from_chord_defect": q + 1,
                "quadratic_rank_witness": {
                    "points": witness_points,
                    "determinant_mod_q": determinant,
                },
            }
        )
    assert sum(record["normalized_orbit_mass"] for record in records) == len(masks)
    return {
        "q": q,
        "normalized_domain_mass": len(masks),
        "ordered_frames_per_arc": 840,
        "records": records,
    }


def build_certificate() -> dict[str, object]:
    return {
        "schema": SCHEMA,
        "q11_six_arc_census": build_q11_census(),
        "seven_arc_exclusions": [
            build_seven_arc_orbits(11),
            build_seven_arc_orbits(13),
        ],
    }


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def verify_point_avoids_chords(point: Point, arc: Arc, q: int) -> None:
    assert point not in arc
    chords, _ = chord_data(arc, q)
    assert not any(point_on_chord(point, chord, q) for chord in chords)


def verify_tracked(certificate: dict[str, object]) -> None:
    assert certificate["schema"] == SCHEMA
    census = certificate["q11_six_arc_census"]
    assert isinstance(census, dict)
    records = census["records"]
    assert isinstance(records, list) and len(records) == 15
    mass = 0
    seen: set[Arc] = set()
    for index, record in enumerate(records, start=1):
        assert isinstance(record, dict) and record["id"] == f"C{index:02d}"
        arc = decode_arc(record["representative"])
        assert small.is_arc([small.canonical_points(11).index(point) for point in arc], small.canonical_points(11), 11)
        orbit = normalized_orbit(arc, 11)
        assert arc == min(orbit) and arc not in seen
        seen.add(arc)
        assert len(orbit) == record["normalized_orbit_mass"]
        assert 360 == len(orbit) * record["stabilizer_order"]
        mass += len(orbit)
        _chords, concurrence = chord_data(arc, 11)
        assert concurrence[3] == record["triple_concurrences"]
        assert 22 - concurrence[3] == record["uncovered_size_from_chord_defect"]
        gap_summary = record["conic_gap"]
        assert isinstance(gap_summary, dict)
        histogram = gap_summary["intersection_histogram"]
        assert isinstance(histogram, dict) and sum(histogram.values()) == 160930
        maximum = max(int(key) for key, value in histogram.items() if value)
        assert record["uncovered_size_from_chord_defect"] + 12 - 2 * maximum == gap_summary["delta"]
        witness = tuple(gap_summary["witness"])
        assert gap.symmetric_conic_determinant(witness) != 0
        witness_mask = gap.conic_mask(witness)
        assert witness_mask.bit_count() == 12
        direct_uncovered_mask = gap.uncovered_mask(arc)
        assert (direct_uncovered_mask & witness_mask).bit_count() == maximum
        if index != 15:
            rank_witness = record["cubic_rank_witness"]
            assert isinstance(rank_witness, dict)
            witness_points = [tuple(point) for point in rank_witness["points"]]
            for point in witness_points:
                verify_point_avoids_chords(point, arc, 11)
            determinant = determinant_mod([cubic_row(point, 11) for point in witness_points], 11)
            assert determinant == rank_witness["determinant_mod_11"] != 0
        else:
            kernel = record["clebsch_kernel"]
            assert isinstance(kernel, dict)
            quadratic = tuple(kernel["quadratic_generator"])
            uncovered = uncovered_points(arc, 11)
            assert all(
                sum(a * b for a, b in zip(quadratic, low_quadratic_row(point))) % 11 == 0
                for point in uncovered
            )
            assert rank_mod([low_quadratic_row(point) for point in uncovered], 11) == 5
            assert rank_mod([cubic_row(point, 11) for point in uncovered], 11) == 7
            assert kernel["quadratic_nullity"] == 1
            assert kernel["cubic_nullity"] == 3
            product_matrix = low.multiplication_matrix(quadratic, 2, 3)
            cubic_generators = [list(column) for column in zip(*product_matrix)]
            assert cubic_generators == kernel["cubic_generators_q_times_x_y_z"]
            assert rank_mod(cubic_generators, 11) == 3
            assert all(
                all(
                    sum(a * b for a, b in zip(generator, cubic_row(point, 11))) % 11 == 0
                    for point in uncovered
                )
                for generator in cubic_generators
            )
    assert mass == census["normalized_domain_mass"] == 1548

    seven = certificate["seven_arc_exclusions"]
    assert isinstance(seven, list) and len(seven) == 2
    for section in seven:
        assert isinstance(section, dict)
        q = section["q"]
        assert q in (11, 13)
        records = section["records"]
        assert isinstance(records, list)
        mass = 0
        seen = set()
        for record in records:
            assert isinstance(record, dict)
            arc = decode_arc(record["representative"])
            orbit = normalized_orbit(arc, q)
            assert arc == min(orbit) and arc not in seen
            seen.add(arc)
            assert len(orbit) == record["normalized_orbit_mass"]
            assert 840 == len(orbit) * record["stabilizer_order"]
            mass += len(orbit)
            _chords, concurrence = chord_data(arc, q)
            assert concurrence[3] == record["triple_concurrences"]
            assert q * q - 20 * q + 120 - concurrence[3] == q + 1
            witness = record["quadratic_rank_witness"]
            assert isinstance(witness, dict)
            witness_points = [tuple(point) for point in witness["points"]]
            for point in witness_points:
                verify_point_avoids_chords(point, arc, q)
            determinant = determinant_mod([quadratic_row(point, q) for point in witness_points], q)
            assert determinant == witness["determinant_mod_q"] != 0
        assert mass == section["normalized_domain_mass"] == EXPECTED_NORMALIZED_SEVEN[q]


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--audit", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()

    if args.audit or args.write:
        built = build_certificate()
        verify_tracked(built)
        encoded = canonical_bytes(built)
        if args.write:
            CERTIFICATE.write_bytes(encoded)
            print(f"wrote={CERTIFICATE.name} bytes={len(encoded)}")
        else:
            assert encoded == CERTIFICATE.read_bytes()
            print("finite_census_full_enumeration_audit=PASS")
        return

    tracked = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    verify_tracked(tracked)
    census = tracked["q11_six_arc_census"]
    seven = tracked["seven_arc_exclusions"]
    print(
        "finite_census_direct_certificates=PASS "
        f"six_arc_orbits={len(census['records'])} "
        f"seven_arc_orbits_q11={len(seven[0]['records'])} "
        f"seven_arc_orbits_q13={len(seven[1]['records'])}"
    )


if __name__ == "__main__":
    main()
