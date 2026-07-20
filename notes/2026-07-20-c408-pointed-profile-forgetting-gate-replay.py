#!/usr/bin/env python3
"""Independent direct-incidence replay for the bounded C408 negative gate."""

from __future__ import annotations

import json
from collections import Counter
from itertools import combinations
from pathlib import Path


CERTIFICATE = Path(__file__).with_name("2026-07-20-c408-pointed-profile-forgetting-gate.json")


def objects(q: int) -> tuple[tuple[int, int, int], ...]:
    return tuple(
        [(1, a, b) for a in range(q) for b in range(q)]
        + [(0, 1, a) for a in range(q)]
        + [(0, 0, 1)]
    )


def normalize(vector: tuple[int, int, int], q: int) -> tuple[int, int, int]:
    for value in vector:
        if value % q:
            inverse = pow(value, -1, q)
            return tuple(entry * inverse % q for entry in vector)  # type: ignore[return-value]
    raise ValueError("zero vector")


def cross(left: tuple[int, int, int], right: tuple[int, int, int], q: int) -> tuple[int, int, int]:
    return normalize(
        (
            left[1] * right[2] - left[2] * right[1],
            left[2] * right[0] - left[0] * right[2],
            left[0] * right[1] - left[1] * right[0],
        ),
        q,
    )


def direct_profile(q: int, point_vectors: tuple[tuple[int, int, int], ...]) -> tuple[dict[str, int], list[list[int]], list[int], tuple[int, ...]]:
    vectors = objects(q)
    index = {vector: position for position, vector in enumerate(vectors)}
    mask = sum(1 << index[point] for point in point_vectors)
    line_masks = tuple(
        sum(
            1 << point
            for point, point_vector in enumerate(vectors)
            if sum(a * b for a, b in zip(line, point_vector)) % q == 0
        )
        for line in vectors
    )
    point_lines = tuple(
        tuple(line for line, line_mask in enumerate(line_masks) if line_mask & (1 << point))
        for point in range(len(vectors))
    )
    sizes = tuple((mask & line_mask).bit_count() for line_mask in line_masks)
    histogram = {str(size): count for size, count in sorted(Counter(sizes).items())}
    coordinate = [
        list(value)
        for value in sorted(
            (
                sum((sizes[line] - 1) * (sizes[line] - 2) // 2 for line in point_lines[point]),
                sum((sizes[line] - 1) // 2 for line in point_lines[point]),
            )
            for point in range(len(vectors))
            if mask & (1 << point)
        )
    ]
    syndrome = sorted(
        sum(sizes[line] * (sizes[line] - 1) // 2 for line in point_lines[point])
        for point in range(len(vectors))
        if not mask & (1 << point)
    )
    arrangement = tuple(line for line, line_mask in enumerate(line_masks) if not line_mask & mask)
    covered = 0
    for line in arrangement:
        covered |= line_masks[line]
    if ((1 << len(vectors)) - 1) ^ covered != mask:
        raise AssertionError("external-line closure mismatch")
    return histogram, coordinate, syndrome, arrangement


def gf49_add(left: tuple[int, int], right: tuple[int, int]) -> tuple[int, int]:
    return ((left[0] + right[0]) % 7, (left[1] + right[1]) % 7)


def gf49_scale(scalar: int, value: tuple[int, int]) -> tuple[int, int]:
    return (scalar * value[0] % 7, scalar * value[1] % 7)


def gf49_points() -> tuple[tuple[tuple[int, int], tuple[int, int], tuple[int, int]], ...]:
    elements = tuple((a, b) for a in range(7) for b in range(7))
    zero = (0, 0)
    one = (1, 0)
    return tuple(
        [(one, a, b) for a in elements for b in elements]
        + [(zero, one, a) for a in elements]
        + [(zero, zero, one)]
    )


def adjoint_depths_over_49(arrangement: tuple[int, ...]) -> Counter[int]:
    vectors = objects(7)
    lines = tuple(vectors[index] for index in arrangement)
    blocks: dict[tuple[int, int, int], set[int]] = {}
    for first, second in combinations(range(len(lines)), 2):
        point = cross(lines[first], lines[second], 7)
        blocks.setdefault(point, set()).update((first, second))
    adjoint = tuple((point, len(indices) - 1) for point, indices in sorted(blocks.items()))
    result: Counter[int] = Counter()
    for projective_point in gf49_points():
        depth = 0
        for line, weight in adjoint:
            value = (0, 0)
            for coefficient, coordinate in zip(line, projective_point):
                value = gf49_add(value, gf49_scale(coefficient, coordinate))
            if value == (0, 0):
                depth += weight
        result[depth] += 1
    return result


def replay_constructive(certificate: dict[str, object]) -> None:
    attack = certificate["constructive_closure_attack"]
    assert isinstance(attack, dict)
    arrangements = []
    for name in ("first", "second"):
        expected = attack[name]
        assert isinstance(expected, dict)
        points = tuple(tuple(point) for point in expected["complement_points"])
        histogram, coordinate, syndrome, arrangement = direct_profile(7, points)  # type: ignore[arg-type]
        if histogram != expected["line_section_histogram"]:
            raise AssertionError((name, "histogram"))
        if coordinate != expected["coordinate_repair_profile"]:
            raise AssertionError((name, "coordinate"))
        if syndrome != expected["excluded_syndrome_multiplicities"]:
            raise AssertionError((name, "syndrome"))
        arrangements.append(arrangement)
    first_depths = adjoint_depths_over_49(arrangements[0])
    second_depths = adjoint_depths_over_49(arrangements[1])
    if first_depths == second_depths:
        raise AssertionError("F49 adjoint depths failed to separate")
    if (first_depths[1], second_depths[1], first_depths[2], second_depths[2]) != (168, 210, 1008, 924):
        raise AssertionError("unexpected F49 separating coefficients")
    print(
        "q=7 constructive bronze OK; F49 adjoint separation "
        f"depth1={first_depths[1]}/{second_depths[1]} depth2={first_depths[2]}/{second_depths[2]}"
    )


def replay(q: int, first_n: int, last_n: int) -> dict[str, int | bool]:
    vectors = objects(q)
    count = len(vectors)
    full = (1 << count) - 1
    line_masks = tuple(
        sum(
            1 << point
            for point, point_vector in enumerate(vectors)
            if sum(a * b for a, b in zip(line, point_vector)) % q == 0
        )
        for line in vectors
    )
    point_lines = tuple(
        tuple(line for line, line_mask in enumerate(line_masks) if line_mask & (1 << point))
        for point in range(count)
    )
    tested = 0
    seen: set[tuple[int, int]] = set()
    first_profiles: dict[tuple[tuple[int, int], ...], tuple[tuple[tuple[int, int], ...], tuple[int, ...]]] = {}
    buckets: set[tuple[tuple[int, int], ...]] = set()
    collision = False
    for n_lines in range(first_n, last_n + 1):
        for arrangement in combinations(range(count), n_lines):
            tested += 1
            common = full
            covered = 0
            for line in arrangement:
                common &= line_masks[line]
                covered |= line_masks[line]
            if common:
                continue  # all arrangement lines share a point, hence rank below three
            complement = full ^ covered
            if not complement or (n_lines, complement) in seen:
                continue
            if any(complement & ~line_mask == 0 for line_mask in line_masks):
                continue  # complement is contained in one projective line
            seen.add((n_lines, complement))
            sizes = tuple((complement & line_mask).bit_count() for line_mask in line_masks)
            histogram = tuple(sorted(Counter(sizes).items()))
            coordinate = tuple(
                sorted(
                    (
                        sum((sizes[line] - 1) * (sizes[line] - 2) // 2 for line in point_lines[point]),
                        sum((sizes[line] - 1) // 2 for line in point_lines[point]),
                    )
                    for point in range(count)
                    if complement & (1 << point)
                )
            )
            syndrome = tuple(
                sorted(
                    sum(sizes[line] * (sizes[line] - 1) // 2 for line in point_lines[point])
                    for point in range(count)
                    if not complement & (1 << point)
                )
            )
            key = histogram
            operational = (coordinate, syndrome)
            buckets.add(key)
            if key in first_profiles and first_profiles[key] != operational:
                collision = True
            first_profiles.setdefault(key, operational)
    return {
        "tested_arrangement_subsets": tested,
        "distinct_spanning_complements": len(seen),
        "global_profile_buckets": len(buckets),
        "bronze_collision_found": collision,
    }


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    for expected in certificate["scans"]:
        actual = replay(expected["q"], *expected["arrangement_line_counts"])
        for field, value in actual.items():
            if value != expected[field]:
                raise AssertionError((expected["q"], field, value, expected[field]))
        print(
            f"q={expected['q']} tested={actual['tested_arrangement_subsets']} "
            f"spanning={actual['distinct_spanning_complements']} "
            f"buckets={actual['global_profile_buckets']} collision={actual['bronze_collision_found']}"
        )
    replay_constructive(certificate)
    print("INDEPENDENT REPLAY OK")


if __name__ == "__main__":
    main()
