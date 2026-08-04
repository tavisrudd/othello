#!/usr/bin/env python3
"""Independent ordered backtracking replay for the terminal orbit DAG.

This program never computes a projective canonical key or a stabilizer.  It
enumerates labelled arcs once, in increasing point-index order, using the
discriminant passancy test and bitset line blockers.  Its level counts must
equal the orbit-mass identities in the independently generated DAG.
"""

from __future__ import annotations

import argparse
import json
import gzip
from collections import Counter
from itertools import combinations
from pathlib import Path


Point = tuple[int, int, int]
CERTIFICATE = Path(__file__).with_name("terminal_orbit_dag.json.gz")
OUTPUT = Path(__file__).with_name("terminal_orbit_dag_replay.json")
SCHEMA = "clebsch-terminal-passant-orbit-dag-v1"


def normalize(vector: Point, q: int) -> Point:
    pivot = next(value for value in vector if value % q)
    scale = pow(pivot, q - 2, q)
    return tuple(scale * coordinate % q for coordinate in vector)  # type: ignore[return-value]


def points(q: int) -> list[Point]:
    return (
        [(1, y, z) for y in range(q) for z in range(q)]
        + [(0, 1, z) for z in range(q)]
        + [(0, 0, 1)]
    )


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
    a, b, c = cross(left, right, q)
    discriminant = (b * b - 4 * a * c) % q
    return discriminant != 0 and pow(discriminant, (q - 1) // 2, q) == q - 1


def field_replay(field: dict[str, object]) -> dict[str, object]:
    q = field["q"]
    all_points = points(q)
    conic = {point for point in all_points if (point[0] * point[2] - point[1] ** 2) % q == 0}
    off = [point for point in all_points if point not in conic]
    assert len(off) == q * q
    n = len(off)
    full = (1 << n) - 1

    neighbors = [0] * n
    line_masks: dict[tuple[int, int], int] = {}
    edges = []
    for left in range(n):
        for right in range(left + 1, n):
            if not passant(off[left], off[right], q):
                continue
            edges.append((left, right))
            neighbors[left] |= 1 << right
            neighbors[right] |= 1 << left
            line = cross(off[left], off[right], q)
            line_masks[left, right] = sum(
                1 << vertex for vertex, point in enumerate(off) if dot(line, point, q) == 0
            )
    assert len(edges) == field["passant_edges"]

    counts: Counter[int] = Counter({2: len(edges)})
    terminals: Counter[int] = Counter()
    witness: tuple[int, ...] | None = None
    selected: list[int] = []

    def pair_key(left: int, right: int) -> tuple[int, int]:
        return (left, right) if left < right else (right, left)

    def visit(remaining: int, forbidden: int) -> None:
        nonlocal witness
        common = full
        selected_mask = 0
        for vertex in selected:
            common &= neighbors[vertex]
            selected_mask |= 1 << vertex
        common &= ~selected_mask
        common &= ~forbidden
        if not common:
            terminals[len(selected)] += 1
        if len(selected) == 6:
            if witness is None:
                witness = tuple(selected)
            if common:
                raise AssertionError((q, "passant seven-arc found", selected))
            return

        while remaining:
            bit = remaining & -remaining
            remaining ^= bit
            vertex = bit.bit_length() - 1
            if (forbidden >> vertex) & 1:
                continue
            added_lines = 0
            for old in selected:
                added_lines |= line_masks[pair_key(old, vertex)]
            selected.append(vertex)
            counts[len(selected)] += 1
            visit(remaining & neighbors[vertex], forbidden | added_lines)
            selected.pop()

    for left, right in edges:
        selected[:] = [left, right]
        larger = full ^ ((1 << (right + 1)) - 1)
        remaining = neighbors[left] & neighbors[right] & larger
        visit(remaining, line_masks[left, right])

    expected = {level["size"]: level["labelled_arc_mass"] for level in field["levels"]}
    assert dict(sorted(counts.items())) == expected
    assert witness is not None
    witness_points = [list(off[vertex]) for vertex in witness]
    tracked_witness = {tuple(point) for point in field["six_point_witness"]}
    assert len(tracked_witness) == 6
    assert all(
        passant(left, right, q)
        for left, right in combinations((tuple(point) for point in tracked_witness), 2)
    )
    return {
        "q": q,
        "labelled_arcs_by_size": [counts[size] for size in range(2, 7)],
        "labelled_terminal_arcs_by_size": [terminals[size] for size in range(2, 7)],
        "maximum_passant_arc_size": 6,
        "independent_witness": witness_points,
    }


def generate() -> dict[str, object]:
    certificate = json.loads(gzip.decompress(CERTIFICATE.read_bytes()))
    assert certificate["schema"] == SCHEMA
    return {
        "schema": "clebsch-ordered-backtracking-replay-v1",
        "fields": [field_replay(field) for field in certificate["fields"]],
    }


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    result = generate()
    encoded = canonical_bytes(result)
    if args.write:
        OUTPUT.write_bytes(encoded)
        print(f"wrote={OUTPUT.name} bytes={len(encoded)}")
        return
    assert encoded == OUTPUT.read_bytes()
    print(
        json.dumps(
            {
                "status": "ok",
                "fields": [
                    {
                        "q": field["q"],
                        "labelled_six_arcs": field["labelled_arcs_by_size"][-1],
                        "maximum_passant_arc_size": field["maximum_passant_arc_size"],
                    }
                    for field in result["fields"]
                ],
            },
            sort_keys=True,
            separators=(",", ":"),
        )
    )


if __name__ == "__main__":
    main()
