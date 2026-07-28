#!/usr/bin/env python3
"""Independent replay for the C605 conic-filling exclusion certificates.

The primary C++ search tests passancy by incidence with every conic point,
forms edge orbits with a disjoint-set structure, and deduplicates partial arcs
under each root stabilizer.  This replay instead tests the discriminant of the
line--conic intersection, verifies the listed edge-orbit partition directly,
and uses an ordered bitset backtracking search with no stabilizer quotient.

Run from the repository root:

    python3 verification/c605_replay.py \
      verification/c605_q13.json \
      verification/c605_q17.json \
      verification/c605_q19.json
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Iterator

Point = tuple[int, int, int]
Matrix2 = tuple[int, int, int, int]


def normalize(vector: Point, q: int) -> Point:
    for value in vector:
        if value % q:
            scale = pow(value, q - 2, q)
            return tuple(scale * coordinate % q for coordinate in vector)  # type: ignore[return-value]
    raise ValueError("zero projective vector")


def points(q: int) -> list[Point]:
    result = [(1, y, z) for y in range(q) for z in range(q)]
    result.extend((0, 1, z) for z in range(q))
    result.append((0, 0, 1))
    return result


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


def passant(left: Point, right: Point, q: int) -> bool:
    """Test that the join misses XZ=Y^2 via its binary-quadratic discriminant."""
    a, b, c = cross(left, right, q)
    discriminant = (b * b - 4 * a * c) % q
    return discriminant != 0 and pow(discriminant, (q - 1) // 2, q) == q - 1


def pgl2(q: int) -> Iterator[Matrix2]:
    seen: set[Matrix2] = set()
    for a in range(q):
        for b in range(q):
            for c in range(q):
                for d in range(q):
                    if (a * d - b * c) % q == 0:
                        continue
                    raw = (a, b, c, d)
                    first = next(value for value in raw if value)
                    scale = pow(first, q - 2, q)
                    matrix = tuple(scale * value % q for value in raw)
                    if matrix not in seen:
                        seen.add(matrix)
                        yield matrix  # type: ignore[misc]


def act(matrix: Matrix2, point: Point, q: int) -> Point:
    a, b, c, d = matrix
    x, y, z = point
    return normalize(
        (
            a * a * x + 2 * a * b * y + b * b * z,
            a * c * x + (a * d + b * c) * y + b * d * z,
            c * c * x + 2 * c * d * y + d * d * z,
        ),
        q,
    )


def edge_key(left: int, right: int) -> tuple[int, int]:
    return (left, right) if left < right else (right, left)


def independent_maximum(
    root: tuple[int, int],
    off: list[Point],
    neighbor_masks: list[int],
    q: int,
) -> tuple[int, int, tuple[int, ...]]:
    """Return maximum size, visited node count, and one maximum rooted arc."""
    selected = list(root)
    candidates = neighbor_masks[root[0]] & neighbor_masks[root[1]]
    candidates &= ~(1 << root[0])
    candidates &= ~(1 << root[1])
    best = tuple(selected)
    nodes = 0

    def lies_on_old_join(vertex: int) -> bool:
        point = off[vertex]
        return any(
            dot(cross(off[selected[i]], off[selected[j]], q), point, q) == 0
            for i in range(len(selected))
            for j in range(i + 1, len(selected))
        )

    def visit(remaining: int) -> None:
        nonlocal best, nodes
        nodes += 1
        if len(selected) > len(best):
            best = tuple(selected)
        if len(selected) + remaining.bit_count() <= len(best):
            return
        while remaining:
            bit = remaining & -remaining
            remaining ^= bit
            vertex = bit.bit_length() - 1
            if lies_on_old_join(vertex):
                continue
            selected.append(vertex)
            visit(remaining & neighbor_masks[vertex])
            selected.pop()

    visit(candidates)
    return len(best), nodes, best


def replay(path: Path) -> dict[str, object]:
    certificate = json.loads(path.read_text())
    if certificate["schema"] != "c605-eight-point-conic-filling-v1":
        raise ValueError(f"{path}: unexpected schema")
    q = certificate["q"]
    if q not in (13, 17, 19):
        raise ValueError(f"{path}: unexpected q={q}")

    all_points = points(q)
    conic = [point for point in all_points if (point[0] * point[2] - point[1] ** 2) % q == 0]
    conic_set = set(conic)
    off = [point for point in all_points if point not in conic_set]
    index = {point: i for i, point in enumerate(off)}
    if (len(all_points), len(conic), len(off)) != (q * q + q + 1, q + 1, q * q):
        raise AssertionError("projective point partition failed")

    edges: set[tuple[int, int]] = set()
    neighbor_masks = [0] * len(off)
    for left in range(len(off)):
        for right in range(left + 1, len(off)):
            if passant(off[left], off[right], q):
                edges.add((left, right))
                neighbor_masks[left] |= 1 << right
                neighbor_masks[right] |= 1 << left
    if len(edges) != certificate["passant_edges"]:
        raise AssertionError(f"{path}: passant edge count mismatch")

    forced_data = {
        13: ((21, 105, 35, 0), (-1, 3, -3, 1), 11),
        17: ((157, 81, 43, 0), (-1, 3, -3, 1), 14),
        19: ((261, 33, 59, 0), (-1, 3, -3, 1), 19),
    }
    constant, coefficient, a_max = forced_data[q]
    forced = certificate["forced_spectrum"]
    if (
        forced["a_range"] != [0, a_max]
        or tuple(forced["constant"]) != constant
        or tuple(forced["a_coefficient"]) != coefficient
        or forced["moment_identities_checked"] is not True
    ):
        raise AssertionError(f"{path}: forced-spectrum certificate mismatch")
    for a in range(a_max + 1):
        n1, n2, n3, n4 = (
            constant[i] + a * coefficient[i] for i in range(4)
        )
        if (
            n1 + n2 + n3 + n4 != q * q - 8
            or n1 + 2 * n2 + 3 * n3 + 4 * n4 != 28 * (q - 1)
            or n2 + 3 * n3 + 6 * n4 != 210
        ):
            raise AssertionError(f"{path}: forced-spectrum moment failure")

    matrices = list(pgl2(q))
    expected_group_order = q * (q - 1) * (q + 1)
    if len(matrices) != expected_group_order or certificate["pgl2_order"] != expected_group_order:
        raise AssertionError(f"{path}: PGL(2,q) order mismatch")
    roots = certificate["roots"]
    if len(roots) != certificate["edge_orbits"]:
        raise AssertionError(f"{path}: root count mismatch")

    covered_edges: set[tuple[int, int]] = set()
    maxima: list[int] = []
    nodes: list[int] = []
    maximum_witness: tuple[int, ...] = ()
    for root_record in roots:
        root_points = [tuple(point) for point in root_record["representative"]]
        root = edge_key(index[root_points[0]], index[root_points[1]])
        orbit: set[tuple[int, int]] = set()
        stabilizer = 0
        for matrix in matrices:
            image = edge_key(index[act(matrix, off[root[0]], q)], index[act(matrix, off[root[1]], q)])
            orbit.add(image)
            if image == root:
                stabilizer += 1
        if len(orbit) != root_record["orbit_size"]:
            raise AssertionError(f"{path}: edge orbit size mismatch at {root_points}")
        if stabilizer != root_record["stabilizer_order"]:
            raise AssertionError(f"{path}: edge stabilizer mismatch at {root_points}")
        if covered_edges & orbit:
            raise AssertionError(f"{path}: listed edge orbits overlap")
        covered_edges |= orbit

        maximum, visited, witness = independent_maximum(root, off, neighbor_masks, q)
        maxima.append(maximum)
        nodes.append(visited)
        if len(witness) > len(maximum_witness):
            maximum_witness = witness

    if covered_edges != edges:
        raise AssertionError(f"{path}: listed roots do not cover every passant edge")
    if max(maxima) >= 7:
        raise AssertionError(f"{path}: independently found a passant seven-arc")
    if certificate["maximum_passant_arc_size"] != max(maxima):
        raise AssertionError(f"{path}: maximum passant-arc size mismatch")
    if certificate["witness_orbits"] != 0:
        raise AssertionError(f"{path}: primary search unexpectedly lists a filling witness")

    return {
        "q": q,
        "raw_off_conic_points": len(off),
        "raw_passant_edges": len(edges),
        "normalized_edge_roots": len(roots),
        "independent_nodes": sum(nodes),
        "maximum_passant_arc_size": max(maxima),
        "maximum_witness": [off[i] for i in maximum_witness],
        "filling_eight_arc_orbits": 0,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("certificates", nargs="+", type=Path)
    args = parser.parse_args()
    result = {
        "schema": "c605-independent-replay-v1",
        "fields": [replay(path) for path in args.certificates],
    }
    print(json.dumps(result, sort_keys=True, separators=(",", ":")))


if __name__ == "__main__":
    main()
