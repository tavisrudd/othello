#!/usr/bin/env python3
"""Canonicalize the twelve q=17 C80 marked-head exceptions under PGL(2,17).

The action is the symmetric-square action on the conic XY=Z^2:

  [u:v] |-> [u^2:v^2:uv].

Each object being canonicalized consists of the conic-marked selected
projective set, the marked opponent point, and the unique certified reply.
"""
from __future__ import annotations

import argparse
import json
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "notes/2026-07-24-c80-incidence-packet-mine.json"
OUT = ROOT / "notes/2026-07-24-c80-marked-head-orbits.json"
Q = 17
Point = tuple[int, int, int]
Matrix = tuple[int, int, int, int]


def normalize(point: Point) -> Point:
    for coordinate in point:
        if coordinate % Q:
            scale = pow(coordinate, -1, Q)
            return tuple((scale * value) % Q for value in point)  # type: ignore[return-value]
    raise ValueError("zero projective point")


def pgl2() -> tuple[Matrix, ...]:
    representatives = set()
    for a in range(Q):
        for b in range(Q):
            for c in range(Q):
                for d in range(Q):
                    if (a * d - b * c) % Q == 0:
                        continue
                    entries = (a, b, c, d)
                    pivot = next(value for value in entries if value)
                    scale = pow(pivot, -1, Q)
                    representatives.add(
                        tuple((scale * value) % Q for value in entries)
                    )
    result = tuple(sorted(representatives))
    assert len(result) == Q * (Q * Q - 1)
    return result


def sym2(matrix: Matrix, point: Point) -> Point:
    a, b, c, d = matrix
    x, y, z = point
    return normalize(
        (
            (a * a * x + b * b * y + 2 * a * b * z) % Q,
            (c * c * x + d * d * y + 2 * c * d * z) % Q,
            (a * c * x + b * d * y + (a * d + b * c) * z) % Q,
        )
    )


def conic_point(parameter: int | str) -> Point:
    if parameter == "inf":
        return (1, 0, 0)
    value = int(parameter)
    return normalize((value * value % Q, 1, value))


def affine_point(cell: list[int]) -> Point:
    return normalize((int(cell[0]), int(cell[1]), 1))


def selected_points(record: dict) -> tuple[Point, ...]:
    points = {(1, 0, 0), (0, 1, 0)}
    points.update(
        conic_point(parameter)
        for parameter in record["selected_conic_parameters"]
    )
    points.update(
        affine_point(cell) for cell in record["selected_intruder_cells"]
    )
    return tuple(sorted(points))


def object_key(record: dict) -> tuple[tuple[Point, ...], Point, Point]:
    replies = record["good_replies"]
    assert len(replies) == 1
    return (
        selected_points(record),
        affine_point(record["opponent_cell"]),
        affine_point(replies[0]["cell"]),
    )


def transform_key(
    matrix: Matrix, key: tuple[tuple[Point, ...], Point, Point]
) -> tuple[tuple[Point, ...], Point, Point]:
    selected, opponent, reply = key
    return (
        tuple(sorted(sym2(matrix, point) for point in selected)),
        sym2(matrix, opponent),
        sym2(matrix, reply),
    )


def encode_point(point: Point) -> list[int]:
    return list(point)


def encode_key(
    key: tuple[tuple[Point, ...], Point, Point]
) -> dict[str, object]:
    selected, opponent, reply = key
    return {
        "selected": [encode_point(point) for point in selected],
        "opponent": encode_point(opponent),
        "reply": encode_point(reply),
    }


def run() -> dict:
    source = json.loads(SOURCE.read_text())
    q17 = next(order for order in source["orders"] if order["q"] == Q)
    records = q17["max_drop_packet"]["uncovered_fallbacks"]
    assert len(records) == 12

    group = pgl2()
    orbit_rows = []
    buckets: dict[
        tuple[tuple[Point, ...], Point, Point], list[int]
    ] = defaultdict(list)
    for index, record in enumerate(records):
        key = object_key(record)
        images = {transform_key(matrix, key) for matrix in group}
        canonical = min(images)
        selected, opponent, reply = key
        selected_stabilizer = [
            matrix
            for matrix in group
            if tuple(
                sorted(sym2(matrix, point) for point in selected)
            )
            == selected
        ]
        marked_opponent_stabilizer = [
            matrix
            for matrix in selected_stabilizer
            if sym2(matrix, opponent) == opponent
        ]
        stabilizer = sum(
            transform_key(matrix, key) == key for matrix in group
        )
        assert len(images) * stabilizer == len(group)
        assert (
            len(selected_stabilizer) % len(marked_opponent_stabilizer) == 0
        )
        buckets[canonical].append(index)
        orbit_rows.append(
            {
                "record": index,
                "selected_size_projective": len(key[0]),
                "object_orbit_size": len(images),
                "object_stabilizer_size": stabilizer,
                "selected_state_stabilizer_size": len(selected_stabilizer),
                "marked_opponent_stabilizer_size": len(
                    marked_opponent_stabilizer
                ),
                "opponent_orbit_size_in_state": (
                    len(selected_stabilizer)
                    // len(marked_opponent_stabilizer)
                ),
                "reply_fixed_by_marked_opponent_stabilizer": all(
                    sym2(matrix, reply) == reply
                    for matrix in marked_opponent_stabilizer
                ),
                "canonical": encode_key(canonical),
            }
        )

    selected_buckets: dict[tuple[Point, ...], list[int]] = defaultdict(list)
    for index, record in enumerate(records):
        selected = object_key(record)[0]
        canonical_selected = min(
            tuple(sorted(sym2(matrix, point) for point in selected))
            for matrix in group
        )
        selected_buckets[canonical_selected].append(index)

    return {
        "schema": "c80-marked-head-orbits-v1",
        "q": Q,
        "action": "PGL(2,q) symmetric-square action on the conic-marked projective plane",
        "group_order": len(group),
        "records": len(records),
        "marked_object_orbits": len(buckets),
        "marked_orbit_members": [
            {
                "orbit": orbit,
                "records": members,
                "selected_sizes_projective": sorted(
                    {orbit_rows[index]["selected_size_projective"] for index in members}
                ),
                "opponent_kinds": sorted(
                    {records[index]["opponent_kind"] for index in members}
                ),
                "reply_kinds": sorted(
                    {
                        records[index]["good_replies"][0]["kind"]
                        for index in members
                    }
                ),
            }
            for orbit, members in enumerate(buckets.values())
        ],
        "selected_state_orbits": len(selected_buckets),
        "selected_state_orbit_members": [
            {"orbit": orbit, "records": members}
            for orbit, members in enumerate(selected_buckets.values())
        ],
        "marked_object_stabilizer_histogram": {
            str(key): value
            for key, value in sorted(
                Counter(
                    row["object_stabilizer_size"] for row in orbit_rows
                ).items()
            )
        },
        "selected_state_stabilizer_histogram": {
            str(key): value
            for key, value in sorted(
                Counter(
                    row["selected_state_stabilizer_size"]
                    for row in orbit_rows
                ).items()
            )
        },
        "marked_opponent_stabilizer_histogram": {
            str(key): value
            for key, value in sorted(
                Counter(
                    row["marked_opponent_stabilizer_size"]
                    for row in orbit_rows
                ).items()
            )
        },
        "all_unique_replies_fixed_by_marked_opponent_stabilizer": all(
            row["reply_fixed_by_marked_opponent_stabilizer"]
            for row in orbit_rows
        ),
        "orbit_rows": orbit_rows,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(run(), indent=2, sort_keys=True) + "\n"
    if args.check:
        assert OUT.read_text() == rendered, "marked-head orbit mismatch"
        print("C80 marked-head orbits: PASS")
    else:
        OUT.write_text(rendered)
        print(f"wrote {OUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
