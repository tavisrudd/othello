#!/usr/bin/env python3
"""Bounded C408 search for global-profile collisions with pointed distinctions."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter, defaultdict
from itertools import combinations
from pathlib import Path


STEM = Path(__file__).with_suffix("")
OUTPUT = STEM.with_suffix(".json")
SCHEMA = "c408-pointed-profile-forgetting-v1"
STRONG_CANDIDATE_CAP = 512


Vector = tuple[int, int, int]


def projective_objects(q: int) -> tuple[Vector, ...]:
    return tuple(
        [(1, a, b) for a in range(q) for b in range(q)]
        + [(0, 1, a) for a in range(q)]
        + [(0, 0, 1)]
    )


def dot(left: Vector, right: Vector, q: int) -> int:
    return sum(a * b for a, b in zip(left, right)) % q


def determinant(rows: tuple[Vector, Vector, Vector], q: int) -> int:
    a, b, c = rows
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % q


def normalize(vector: Vector, q: int) -> Vector:
    for value in vector:
        if value % q:
            inverse = pow(value, -1, q)
            return tuple((entry * inverse) % q for entry in vector)  # type: ignore[return-value]
    raise ValueError("zero vector")


def cross(left: Vector, right: Vector, q: int) -> Vector:
    return normalize(
        (
            left[1] * right[2] - left[2] * right[1],
            left[2] * right[0] - left[0] * right[2],
            left[0] * right[1] - left[1] * right[0],
        ),
        q,
    )


def is_rank_three(indices: tuple[int, ...], objects: tuple[Vector, ...], q: int) -> bool:
    return any(
        determinant(tuple(objects[index] for index in triple), q)  # type: ignore[arg-type]
        for triple in combinations(indices, 3)
    )


def plane_data(q: int) -> dict[str, object]:
    objects = projective_objects(q)
    line_masks = tuple(
        sum(1 << point for point, vector in enumerate(objects) if dot(line, vector, q) == 0)
        for line in objects
    )
    point_lines = tuple(
        tuple(line for line, mask in enumerate(line_masks) if mask & (1 << point))
        for point in range(len(objects))
    )
    return {"objects": objects, "line_masks": line_masks, "point_lines": point_lines}


def complement_mask(arrangement: tuple[int, ...], line_masks: tuple[int, ...], point_count: int) -> int:
    covered = 0
    for line in arrangement:
        covered |= line_masks[line]
    return ((1 << point_count) - 1) ^ covered


def profile(
    mask: int,
    line_masks: tuple[int, ...],
    point_lines: tuple[tuple[int, ...], ...],
) -> tuple[tuple[tuple[int, int], ...], tuple[int, ...], tuple[int, ...]]:
    sizes = tuple((mask & line_mask).bit_count() for line_mask in line_masks)
    global_profile = tuple(sorted(Counter(sizes).items()))
    coordinate = []
    syndrome = []
    for point, incident in enumerate(point_lines):
        if mask & (1 << point):
            coordinate.append(
                (
                    sum((sizes[line] - 1) * (sizes[line] - 2) // 2 for line in incident),
                    sum((sizes[line] - 1) // 2 for line in incident),
                )
            )
        else:
            syndrome.append(sum(sizes[line] * (sizes[line] - 1) // 2 for line in incident))
    return global_profile, tuple(sorted(coordinate)), tuple(sorted(syndrome))


def intersection_blocks(lines: tuple[Vector, ...], q: int) -> dict[Vector, tuple[int, ...]]:
    blocks: dict[Vector, set[int]] = defaultdict(set)
    for first, second in combinations(range(len(lines)), 2):
        point = cross(lines[first], lines[second], q)
        blocks[point].update((first, second))
    return {point: tuple(sorted(indices)) for point, indices in sorted(blocks.items())}


def characteristic_polynomial(lines: tuple[Vector, ...], q: int) -> tuple[int, ...]:
    singular_sum = sum(len(indices) - 1 for indices in intersection_blocks(lines, q).values())
    return (len(lines) - 1 - singular_sum, singular_sum, -len(lines), 1)


def vector_rank_safe(vectors: tuple[Vector, ...], q: int) -> int:
    if not vectors:
        return 0
    rank = 1
    first = vectors[0]
    second: Vector | None = None
    for vector in vectors[1:]:
        if any((first[i] * vector[j] - first[j] * vector[i]) % q for i in range(3) for j in range(i + 1, 3)):
            second = vector
            rank = 2
            break
    if second is not None and any(determinant((first, second, vector), q) for vector in vectors):
        rank = 3
    return rank


def weighted_adjoint_depth_signature(lines: tuple[Vector, ...], q: int) -> dict[str, object]:
    singular = intersection_blocks(lines, q)
    adjoint_lines = tuple(singular)
    weights = tuple(len(singular[point]) - 1 for point in adjoint_lines)
    adjoint_blocks = intersection_blocks(adjoint_lines, q)
    incident_blocks = [set() for _ in adjoint_lines]
    for point, indices in adjoint_blocks.items():
        for index in indices:
            incident_blocks[index].add(point)
    coefficients: dict[int, list[int]] = {0: [1, 1 - len(adjoint_lines), 1 - len(adjoint_lines) + sum(len(indices) - 1 for indices in adjoint_blocks.values())]}
    for index, weight in enumerate(weights):
        coefficients.setdefault(weight, [0, 0, 0])
        coefficients[weight][1] += 1
        coefficients[weight][2] += 1 - len(incident_blocks[index])
    for indices in adjoint_blocks.values():
        depth = sum(weights[index] for index in indices)
        coefficients.setdefault(depth, [0, 0, 0])
        coefficients[depth][2] += 1
    direct = Counter(
        sum(weight for line, weight in zip(adjoint_lines, weights) if dot(line, point, q) == 0)
        for point in projective_objects(q)
    )
    evaluated = Counter(
        {depth: q * q * poly[0] + q * poly[1] + poly[2] for depth, poly in coefficients.items()}
    )
    if direct != evaluated:
        raise AssertionError((direct, evaluated))
    return {
        "rank": vector_rank_safe(adjoint_lines, q),
        "indexed_copy_count": sum(weights),
        "projective_depth_count_polynomials_q2_q_1": {
            str(depth): poly for depth, poly in sorted(coefficients.items()) if any(poly)
        },
    }


def strong_signature(arrangement: tuple[int, ...], objects: tuple[Vector, ...], q: int) -> dict[str, object]:
    lines = tuple(objects[index] for index in arrangement)
    return {
        "characteristic_polynomial_ascending": list(characteristic_polynomial(lines, q)),
        "weighted_adjoint": weighted_adjoint_depth_signature(lines, q),
    }


def record(
    q: int,
    arrangement: tuple[int, ...],
    mask: int,
    objects: tuple[Vector, ...],
    global_profile: tuple[tuple[int, int], ...],
    coordinate: tuple[tuple[int, int], ...],
    syndrome: tuple[int, ...],
) -> dict[str, object]:
    return {
        "q": q,
        "arrangement_line_indices": list(arrangement),
        "arrangement_lines": [list(objects[index]) for index in arrangement],
        "complement_point_indices": [index for index in range(len(objects)) if mask & (1 << index)],
        "complement_points": [list(objects[index]) for index in range(len(objects)) if mask & (1 << index)],
        "complement_length": mask.bit_count(),
        "line_section_histogram": {str(size): count for size, count in global_profile},
        "coordinate_repair_profile": [list(item) for item in coordinate],
        "excluded_syndrome_multiplicities": list(syndrome),
    }


def scan(q: int, n_values: range) -> dict[str, object]:
    data = plane_data(q)
    objects = data["objects"]
    line_masks = data["line_masks"]
    point_lines = data["point_lines"]
    assert isinstance(objects, tuple) and isinstance(line_masks, tuple) and isinstance(point_lines, tuple)
    buckets: dict[tuple[tuple[int, int], ...], list[tuple[tuple[int, ...], int, tuple[tuple[int, int], ...], tuple[int, ...]]]] = defaultdict(list)
    seen_complements: set[tuple[int, int]] = set()
    tested_arrangements = 0
    spanning_complements = 0
    for n_lines in n_values:
        for arrangement in combinations(range(len(objects)), n_lines):
            tested_arrangements += 1
            if not is_rank_three(arrangement, objects, q):
                continue
            mask = complement_mask(arrangement, line_masks, len(objects))
            if not mask or (n_lines, mask) in seen_complements:
                continue
            points = tuple(objects[index] for index in range(len(objects)) if mask & (1 << index))
            if vector_rank_safe(points, q) != 3:
                continue
            seen_complements.add((n_lines, mask))
            spanning_complements += 1
            global_profile, coordinate, syndrome = profile(mask, line_masks, point_lines)
            buckets[global_profile].append((arrangement, mask, coordinate, syndrome))

    bronze_pair = None
    for global_profile, candidates in sorted(buckets.items()):
        first_by_operational: dict[tuple[tuple[tuple[int, int], ...], tuple[int, ...]], tuple[tuple[int, ...], int]] = {}
        for arrangement, mask, coordinate, syndrome in candidates:
            operational = (coordinate, syndrome)
            if first_by_operational and operational not in first_by_operational:
                other_arrangement, other_mask = next(iter(first_by_operational.values()))
                other_global, other_coordinate, other_syndrome = profile(other_mask, line_masks, point_lines)
                assert other_global == global_profile
                bronze_pair = (
                    record(q, other_arrangement, other_mask, objects, global_profile, other_coordinate, other_syndrome),
                    record(q, arrangement, mask, objects, global_profile, coordinate, syndrome),
                )
                break
            first_by_operational.setdefault(operational, (arrangement, mask))
        if bronze_pair is not None:
            break

    strong_pair = None
    strong_candidates_tested = 0
    strong_buckets: dict[str, tuple[dict[str, object], tuple[tuple[tuple[int, int], ...], tuple[int, ...]]]] = {}
    for global_profile, candidates in sorted(buckets.items()):
        if len(candidates) < 2:
            continue
        for arrangement, mask, coordinate, syndrome in candidates:
            if strong_candidates_tested >= STRONG_CANDIDATE_CAP:
                break
            signature = strong_signature(arrangement, objects, q)
            strong_candidates_tested += 1
            key_payload = {"n_lines": len(arrangement), "global": global_profile, "strong": signature}
            key = hashlib.sha256(json.dumps(key_payload, sort_keys=True).encode()).hexdigest()
            current = record(q, arrangement, mask, objects, global_profile, coordinate, syndrome)
            operational = (coordinate, syndrome)
            if key in strong_buckets and strong_buckets[key][1] != operational:
                strong_pair = (strong_buckets[key][0], current, signature)
                break
            strong_buckets.setdefault(key, (current, operational))
        if strong_pair is not None or strong_candidates_tested >= STRONG_CANDIDATE_CAP:
            break

    result: dict[str, object] = {
        "q": q,
        "arrangement_line_counts": [n_values.start, n_values.stop - 1],
        "tested_arrangement_subsets": tested_arrangements,
        "distinct_spanning_complements": spanning_complements,
        "global_profile_buckets": len(buckets),
        "bronze_collision_found": bronze_pair is not None,
        "strong_candidates_tested": strong_candidates_tested,
        "strong_candidate_cap": STRONG_CANDIDATE_CAP,
        "strong_collision_found": strong_pair is not None,
    }
    if bronze_pair is not None:
        first, second = bronze_pair
        result["bronze_witness"] = {"first": first, "second": second}
        result["bronze_strong_signatures"] = {
            "first": strong_signature(tuple(first["arrangement_line_indices"]), objects, q),
            "second": strong_signature(tuple(second["arrangement_line_indices"]), objects, q),
        }
    if strong_pair is not None:
        first, second, signature = strong_pair
        result["strong_witness"] = {"first": first, "second": second, "common_strong_signature": signature}
    return result


def constructive_closure_attack() -> dict[str, object]:
    q = 7
    data = plane_data(q)
    objects = data["objects"]
    line_masks = data["line_masks"]
    point_lines = data["point_lines"]
    assert isinstance(objects, tuple) and isinstance(line_masks, tuple) and isinstance(point_lines, tuple)
    index = {vector: position for position, vector in enumerate(objects)}
    point_sets = (
        ((1, 0, 0), (1, 1, 0), (1, 2, 0), (1, 3, 1), (1, 4, 1), (1, 5, 1)),
        ((1, 0, 0), (1, 1, 0), (1, 2, 0), (1, 0, 1), (1, 0, 2), (1, 1, 2)),
    )
    records = []
    signatures = []
    for points in point_sets:
        mask = sum(1 << index[point] for point in points)
        arrangement = tuple(line for line, line_mask in enumerate(line_masks) if not line_mask & mask)
        if complement_mask(arrangement, line_masks, len(objects)) != mask:
            raise AssertionError("external-line closure failed")
        global_profile, coordinate, syndrome = profile(mask, line_masks, point_lines)
        records.append(record(q, arrangement, mask, objects, global_profile, coordinate, syndrome))
        signatures.append(strong_signature(arrangement, objects, q))
    if records[0]["line_section_histogram"] != records[1]["line_section_histogram"]:
        raise AssertionError("trade does not preserve the global histogram")
    if (
        records[0]["coordinate_repair_profile"] == records[1]["coordinate_repair_profile"]
        or records[0]["excluded_syndrome_multiplicities"] == records[1]["excluded_syndrome_multiplicities"]
    ):
        raise AssertionError("trade does not separate both pointed profiles")
    return {
        "q": q,
        "construction": "six-point external-line closure: two disjoint 3-secants versus two 3-secants sharing one point",
        "common_line_section_histogram": records[0]["line_section_histogram"],
        "first": records[0],
        "second": records[1],
        "first_strong_signature": signatures[0],
        "second_strong_signature": signatures[1],
        "strong_signature_equal": signatures[0] == signatures[1],
    }


def build_certificate() -> dict[str, object]:
    q3 = scan(3, range(3, 14))
    scans = [q3]
    if not q3["bronze_collision_found"]:
        scans.append(scan(5, range(3, 7)))
    return {
        "schema": SCHEMA,
        "gate": {
            "primary": "equal line-section histogram, unequal pointed repair or syndrome-multiplicity profile",
            "strong": "also equal original characteristic and universal weighted-adjoint depth signatures",
            "q3_scope": "all line arrangements in PG(2,3), retaining essential arrangements with nonempty spanning complements",
            "fallback_scope": "if q=3 is negative, all 3- through 6-line arrangements in PG(2,5)",
        },
        "scans": scans,
        "constructive_closure_attack": constructive_closure_attack(),
    }


def canonical_bytes(value: dict[str, object]) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    payload = canonical_bytes(certificate)
    if args.write:
        OUTPUT.write_bytes(payload)
    if args.check:
        if not OUTPUT.exists() or OUTPUT.read_bytes() != payload:
            raise SystemExit("certificate mismatch; run with --write intentionally")
    summary = certificate["scans"][0]
    assert isinstance(summary, dict)
    print(
        f"OK {OUTPUT.name} {len(payload)} bytes sha256={hashlib.sha256(payload).hexdigest()} "
        f"census_bronze={summary['bronze_collision_found']} "
        f"constructive_bronze=True constructive_strong={certificate['constructive_closure_attack']['strong_signature_equal']}"
    )


if __name__ == "__main__":
    main()
