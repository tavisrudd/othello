#!/usr/bin/env python3
"""C410 bounded q=7 six-point frame-extension kernel test."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter, defaultdict
from itertools import combinations
from pathlib import Path


STEM = Path(__file__).with_suffix("")
OUTPUT = STEM.with_suffix(".json")
SCHEMA = "c410-same-tower-pointed-collision-v1"
Q = 7
Vector = tuple[int, int, int]


def objects(q: int) -> tuple[Vector, ...]:
    return tuple(
        [(1, a, b) for a in range(q) for b in range(q)]
        + [(0, 1, a) for a in range(q)]
        + [(0, 0, 1)]
    )


def dot(a: Vector, b: Vector, q: int) -> int:
    return sum(x * y for x, y in zip(a, b)) % q


def normalize(v: Vector, q: int) -> Vector:
    for x in v:
        if x % q:
            z = pow(x, -1, q)
            return tuple((z * y) % q for y in v)  # type: ignore[return-value]
    raise ValueError("zero vector")


def cross(a: Vector, b: Vector, q: int) -> Vector:
    return normalize(
        (
            a[1] * b[2] - a[2] * b[1],
            a[2] * b[0] - a[0] * b[2],
            a[0] * b[1] - a[1] * b[0],
        ),
        q,
    )


def plane(q: int) -> tuple[tuple[Vector, ...], tuple[int, ...], tuple[tuple[int, ...], ...]]:
    pts = objects(q)
    line_masks = tuple(
        sum(1 << i for i, point in enumerate(pts) if dot(line, point, q) == 0)
        for line in pts
    )
    point_lines = tuple(
        tuple(i for i, mask in enumerate(line_masks) if mask & (1 << point))
        for point in range(len(pts))
    )
    return pts, line_masks, point_lines


def intersection_blocks(lines: tuple[Vector, ...], q: int) -> dict[Vector, tuple[int, ...]]:
    blocks: dict[Vector, set[int]] = defaultdict(set)
    for i, j in combinations(range(len(lines)), 2):
        point = cross(lines[i], lines[j], q)
        blocks[point].update((i, j))
    return {point: tuple(sorted(indices)) for point, indices in sorted(blocks.items())}


def characteristic(lines: tuple[Vector, ...], q: int) -> tuple[int, int, int, int]:
    singular_sum = sum(len(block) - 1 for block in intersection_blocks(lines, q).values())
    return (len(lines) - 1 - singular_sum, singular_sum, -len(lines), 1)


def weighted_depth(lines: tuple[Vector, ...], q: int) -> dict[str, object]:
    singular = intersection_blocks(lines, q)
    adjoint = tuple(singular)
    weights = tuple(len(singular[p]) - 1 for p in adjoint)
    blocks = intersection_blocks(adjoint, q)
    incident = [set() for _ in adjoint]
    for point, indices in blocks.items():
        for index in indices:
            incident[index].add(point)
    coeffs: dict[int, list[int]] = {
        0: [1, 1 - len(adjoint), 1 - len(adjoint) + sum(len(v) - 1 for v in blocks.values())]
    }
    for i, weight in enumerate(weights):
        coeffs.setdefault(weight, [0, 0, 0])
        coeffs[weight][1] += 1
        coeffs[weight][2] += 1 - len(incident[i])
    for indices in blocks.values():
        depth = sum(weights[i] for i in indices)
        coeffs.setdefault(depth, [0, 0, 0])
        coeffs[depth][2] += 1
    direct = Counter(
        sum(weight for line, weight in zip(adjoint, weights) if dot(line, point, q) == 0)
        for point in objects(q)
    )
    evaluated = Counter(
        {depth: q * q * poly[0] + q * poly[1] + poly[2] for depth, poly in coeffs.items()}
    )
    if direct != evaluated:
        raise AssertionError("universal depth polynomial fails at the base field")
    return {
        "adjoint_line_count": len(adjoint),
        "indexed_copy_count": sum(weights),
        "projective_depth_count_polynomials_q2_q_1": {
            str(depth): poly for depth, poly in sorted(coeffs.items()) if any(poly)
        },
    }


def profiles(
    mask: int, line_masks: tuple[int, ...], point_lines: tuple[tuple[int, ...], ...]
) -> tuple[tuple[tuple[int, int], ...], tuple[tuple[int, int], ...], tuple[int, ...]]:
    sizes = tuple((mask & line).bit_count() for line in line_masks)
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


def canonical(value: object) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


def digest(value: object) -> str:
    return hashlib.sha256(canonical(value).encode()).hexdigest()


def external_arrangement(mask: int, line_masks: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(i for i, line in enumerate(line_masks) if not line & mask)


def c408_control(
    pts: tuple[Vector, ...], line_masks: tuple[int, ...], point_lines: tuple[tuple[int, ...], ...]
) -> dict[str, object]:
    point_sets = (
        ((1, 0, 0), (1, 1, 0), (1, 2, 0), (1, 3, 1), (1, 4, 1), (1, 5, 1)),
        ((1, 0, 0), (1, 1, 0), (1, 2, 0), (1, 0, 1), (1, 0, 2), (1, 1, 2)),
    )
    signatures = []
    pointed = []
    for point_set in point_sets:
        mask = sum(1 << pts.index(point) for point in point_set)
        arrangement = tuple(pts[i] for i in external_arrangement(mask, line_masks))
        signatures.append({"characteristic": characteristic(arrangement, Q), "depth": weighted_depth(arrangement, Q)})
        pointed.append(profiles(mask, line_masks, point_lines)[1:])
    first = signatures[0]["depth"]["projective_depth_count_polynomials_q2_q_1"]
    second = signatures[1]["depth"]["projective_depth_count_polynomials_q2_q_1"]
    assert isinstance(first, dict) and isinstance(second, dict)
    defect = {}
    for depth in sorted(set(first) | set(second), key=int):
        a = first.get(depth, [0, 0, 0])
        b = second.get(depth, [0, 0, 0])
        difference = [x - y for x, y in zip(a, b)]
        if any(difference):
            defect[depth] = difference
    expected = {"1": [0, -1, 7], "2": [0, 2, -14], "4": [0, -2, 14], "5": [0, 1, -7]}
    if defect != expected or signatures[0]["characteristic"] != signatures[1]["characteristic"]:
        raise AssertionError("C408 control drift")
    if pointed[0] == pointed[1]:
        raise AssertionError("C408 pointed control unexpectedly equal")
    return {
        "depth_defect_q2_q_1": defect,
        "factored_depth_defect": "(Q-7)(-x+2x^2-2x^4+x^5)=(Q-7)x(x-1)^3(x+1)",
        "universal_map_equal": False,
        "pointed_map_equal": False,
    }


def build_certificate() -> dict[str, object]:
    pts, line_masks, point_lines = plane(Q)
    frame = ((1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 1))
    frame_indices = tuple(pts.index(point) for point in frame)
    remaining = tuple(i for i in range(len(pts)) if i not in frame_indices)
    fibers: dict[str, dict[str, object]] = {}
    candidate_rows = []
    for extra in combinations(remaining, 2):
        indices = frame_indices + extra
        mask = sum(1 << i for i in indices)
        arrangement_indices = external_arrangement(mask, line_masks)
        arrangement = tuple(pts[i] for i in arrangement_indices)
        universal = {
            "characteristic_polynomial_ascending": characteristic(arrangement, Q),
            "weighted_adjoint": weighted_depth(arrangement, Q),
        }
        global_profile, coordinate, syndrome = profiles(mask, line_masks, point_lines)
        pointed = {"coordinate_repair_availability": coordinate, "syndrome_multiplicity": syndrome}
        u_key = canonical(universal)
        p_key = canonical(pointed)
        row = (digest(universal), digest(pointed), tuple(pts[i] for i in extra))
        candidate_rows.append(row)
        fiber = fibers.setdefault(
            u_key,
            {
                "universal": universal,
                "count": 0,
                "pointed": set(),
                "global": set(),
                "representative_extra_points": tuple(pts[i] for i in extra),
            },
        )
        fiber["count"] = int(fiber["count"]) + 1
        assert isinstance(fiber["pointed"], set) and isinstance(fiber["global"], set)
        fiber["pointed"].add(p_key)
        fiber["global"].add(canonical(global_profile))
    summaries = []
    for u_key, fiber in sorted(fibers.items(), key=lambda item: digest(json.loads(item[0]))):
        pointed = fiber["pointed"]
        global_profiles = fiber["global"]
        assert isinstance(pointed, set) and isinstance(global_profiles, set)
        summaries.append(
            {
                "universal_signature_sha256": digest(json.loads(u_key)),
                "normalized_extension_count": fiber["count"],
                "pointed_signature_count": len(pointed),
                "global_profile_count": len(global_profiles),
                "representative_extra_points": fiber["representative_extra_points"],
            }
        )
    collision_count = sum(1 for fiber in summaries if fiber["pointed_signature_count"] > 1)
    if len(candidate_rows) != 1378 or len(summaries) != 15 or collision_count != 0:
        raise AssertionError("frozen gate result drift")
    return {
        "schema": SCHEMA,
        "scope": {
            "field": 7,
            "complement_size": 6,
            "fixed_projective_frame": frame,
            "normalized_extensions": len(candidate_rows),
            "completeness": "every six-point configuration containing a projective frame is projectively equivalent to at least one tested extension",
            "stop_rule": "do not enlarge the field, size, or configuration family after a negative gate",
        },
        "maps": {
            "U": "original characteristic polynomial plus universal weighted-adjoint projective depth-count polynomials",
            "P": "sorted coordinate repair/availability pairs plus sorted excluded-syndrome multiplicities; the puncture deck is determined by repair counts",
        },
        "c408_control": c408_control(pts, line_masks, point_lines),
        "result": {
            "verdict": "BOUNDED NEGATIVE",
            "universal_fibers": len(summaries),
            "pointed_collision_fibers": collision_count,
            "candidate_digest": digest(sorted(candidate_rows)),
            "fiber_summaries": summaries,
        },
    }


def payload(value: dict[str, object]) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    data = payload(certificate)
    if args.write:
        OUTPUT.write_bytes(data)
    if args.check and (not OUTPUT.exists() or OUTPUT.read_bytes() != data):
        raise SystemExit("certificate mismatch; run with --write intentionally")
    result = certificate["result"]
    assert isinstance(result, dict)
    print(
        f"OK {OUTPUT.name} {len(data)} bytes sha256={hashlib.sha256(data).hexdigest()} "
        f"extensions=1378 U_fibers={result['universal_fibers']} pointed_collisions={result['pointed_collision_fibers']}"
    )


if __name__ == "__main__":
    main()
