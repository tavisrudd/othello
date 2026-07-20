#!/usr/bin/env python3
"""Independent incidence-scan replay of the frozen C410 gate."""

from __future__ import annotations

import hashlib
import json
from collections import Counter
from itertools import combinations
from pathlib import Path


Q = 7
CERTIFICATE = Path(__file__).with_name("2026-07-20-c410-same-tower-pointed-collision.json")
Vector = tuple[int, int, int]


def objects(q: int) -> tuple[Vector, ...]:
    return tuple(
        [(1, a, b) for a in range(q) for b in range(q)]
        + [(0, 1, a) for a in range(q)]
        + [(0, 0, 1)]
    )


def incident(line: Vector, point: Vector, q: int) -> bool:
    return sum(a * b for a, b in zip(line, point)) % q == 0


def determinant(a: Vector, b: Vector, c: Vector, q: int) -> int:
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % q


def contains_frame(indices: tuple[int, ...], pts: tuple[Vector, ...]) -> bool:
    return any(
        all(determinant(pts[i], pts[j], pts[k], Q) for i, j, k in combinations(four, 3))
        for four in combinations(indices, 4)
    )


def canonical(value: object) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


def digest(value: object) -> str:
    return hashlib.sha256(canonical(value).encode()).hexdigest()


def singular_blocks(lines: tuple[Vector, ...], pts: tuple[Vector, ...]) -> tuple[tuple[Vector, tuple[int, ...]], ...]:
    result = []
    for point in pts:
        indices = tuple(i for i, line in enumerate(lines) if incident(line, point, Q))
        if len(indices) >= 2:
            result.append((point, indices))
    return tuple(result)


def characteristic(lines: tuple[Vector, ...], pts: tuple[Vector, ...]) -> tuple[int, int, int, int]:
    singular_sum = sum(len(indices) - 1 for _, indices in singular_blocks(lines, pts))
    return (len(lines) - 1 - singular_sum, singular_sum, -len(lines), 1)


def weighted_depth(lines: tuple[Vector, ...], pts: tuple[Vector, ...]) -> dict[str, object]:
    singular = singular_blocks(lines, pts)
    adjoint = tuple(point for point, _ in singular)
    weights = tuple(len(indices) - 1 for _, indices in singular)
    intersections = []
    intersection_count_on_line = [0] * len(adjoint)
    for point in pts:
        indices = tuple(i for i, line in enumerate(adjoint) if incident(line, point, Q))
        if len(indices) >= 2:
            intersections.append((point, indices))
            for i in indices:
                intersection_count_on_line[i] += 1
    coeffs: dict[int, list[int]] = {0: [1, 1, 1]}
    for i, weight in enumerate(weights):
        exclusive = [0, 1, 1 - intersection_count_on_line[i]]
        coeffs.setdefault(weight, [0, 0, 0])
        coeffs[weight] = [a + b for a, b in zip(coeffs[weight], exclusive)]
        coeffs[0] = [a - b for a, b in zip(coeffs[0], exclusive)]
    for _, indices in intersections:
        depth = sum(weights[i] for i in indices)
        coeffs.setdefault(depth, [0, 0, 0])
        coeffs[depth][2] += 1
        coeffs[0][2] -= 1
    evaluated = Counter(
        {depth: Q * Q * poly[0] + Q * poly[1] + poly[2] for depth, poly in coeffs.items()}
    )
    direct = Counter(
        sum(weight for line, weight in zip(adjoint, weights) if incident(line, point, Q))
        for point in pts
    )
    if evaluated != direct:
        raise AssertionError("independent depth evaluation mismatch")
    return {
        "adjoint_line_count": len(adjoint),
        "indexed_copy_count": sum(weights),
        "projective_depth_count_polynomials_q2_q_1": {
            str(depth): poly for depth, poly in sorted(coeffs.items()) if any(poly)
        },
    }


def point_profiles(
    selected: frozenset[int], pts: tuple[Vector, ...], lines: tuple[Vector, ...]
) -> tuple[tuple[tuple[int, int], ...], tuple[tuple[int, int], ...], tuple[int, ...]]:
    sizes = tuple(sum(i in selected and incident(line, pts[i], Q) for i in range(len(pts))) for line in lines)
    global_profile = tuple(sorted(Counter(sizes).items()))
    coordinate = []
    syndrome = []
    for i, point in enumerate(pts):
        through = tuple(j for j, line in enumerate(lines) if incident(line, point, Q))
        if i in selected:
            coordinate.append(
                (
                    sum((sizes[j] - 1) * (sizes[j] - 2) // 2 for j in through),
                    sum((sizes[j] - 1) // 2 for j in through),
                )
            )
        else:
            syndrome.append(sum(sizes[j] * (sizes[j] - 1) // 2 for j in through))
    return global_profile, tuple(sorted(coordinate)), tuple(sorted(syndrome))


def main() -> None:
    expected = json.loads(CERTIFICATE.read_text())
    pts = objects(Q)
    lines = pts
    frame = ((1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 1))
    frame_indices = tuple(pts.index(point) for point in frame)
    remaining = tuple(i for i in range(len(pts)) if i not in frame_indices)
    fibers: dict[str, dict[str, object]] = {}
    rows = []
    for extra in combinations(remaining, 2):
        indices = frame_indices + extra
        selected = frozenset(indices)
        arrangement = tuple(line for line in lines if all(not incident(line, pts[i], Q) for i in selected))
        universal = {
            "characteristic_polynomial_ascending": characteristic(arrangement, pts),
            "weighted_adjoint": weighted_depth(arrangement, pts),
        }
        global_profile, coordinate, syndrome = point_profiles(selected, pts, lines)
        pointed = {"coordinate_repair_availability": coordinate, "syndrome_multiplicity": syndrome}
        u_key = canonical(universal)
        p_key = canonical(pointed)
        rows.append((digest(universal), digest(pointed), tuple(pts[i] for i in extra)))
        fiber = fibers.setdefault(
            u_key,
            {"count": 0, "pointed": set(), "global": set(), "representative": tuple(pts[i] for i in extra)},
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
                "representative_extra_points": fiber["representative"],
            }
        )
    result = expected["result"]
    basis = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
    basis_indices = tuple(pts.index(point) for point in basis)
    triple_remaining = tuple(i for i in range(len(pts)) if i not in basis_indices)
    frame_free_rows = []
    frame_free_fibers: dict[str, set[str]] = {}
    for extra in combinations(triple_remaining, 3):
        indices = basis_indices + extra
        if contains_frame(indices, pts):
            continue
        selected = frozenset(indices)
        arrangement = tuple(line for line in lines if all(not incident(line, pts[i], Q) for i in selected))
        universal = {
            "characteristic_polynomial_ascending": characteristic(arrangement, pts),
            "weighted_adjoint": weighted_depth(arrangement, pts),
        }
        _, coordinate, syndrome = point_profiles(selected, pts, lines)
        pointed = {"coordinate_repair_availability": coordinate, "syndrome_multiplicity": syndrome}
        u_key = canonical(universal)
        p_key = canonical(pointed)
        frame_free_fibers.setdefault(u_key, set()).add(p_key)
        frame_free_rows.append((digest(universal), digest(pointed), tuple(pts[i] for i in extra)))
    followup = expected["frame_free_followup"]
    checks = {
        "normalized_extensions": len(rows) == expected["scope"]["normalized_extensions"] == 1378,
        "candidate_digest": digest(sorted(rows)) == result["candidate_digest"],
        "universal_fibers": len(fibers) == result["universal_fibers"] == 15,
        "fiber_summaries": canonical(summaries) == canonical(result["fiber_summaries"]),
        "pointed_collision_fibers": sum(len(fiber["pointed"]) > 1 for fiber in fibers.values())
        == result["pointed_collision_fibers"]
        == 0,
        "frame_free_representations": len(frame_free_rows) == followup["frame_free_representations"] == 60,
        "frame_free_candidate_digest": digest(sorted(frame_free_rows)) == followup["candidate_digest"],
        "frame_free_universal_fibers": len(frame_free_fibers) == followup["universal_fibers"] == 1,
        "frame_free_pointed_collisions": sum(len(values) > 1 for values in frame_free_fibers.values())
        == followup["pointed_collision_fibers"]
        == 0,
    }
    if not all(checks.values()):
        raise AssertionError(checks)
    print("OK independent_replay frame_extensions=1378 frame_free=60 pointed_collisions=0")


if __name__ == "__main__":
    main()
