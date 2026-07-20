#!/usr/bin/env python3
"""Independent fixed-fixture replay of C392's load-bearing distinction."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


Q = 11
HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-19-c392-clebsch-two-sheet-service.json"
CONIC = (
    (0, 0, 1), (1, 0, 0), (1, 1, 1), (1, 2, 4), (1, 3, 9), (1, 4, 5),
    (1, 5, 3), (1, 6, 3), (1, 7, 5), (1, 8, 9), (1, 9, 4), (1, 10, 1),
)
MATE = (
    ((0, 2), (1, 3), (6, 11), (7, 8), (9, 10)),
    ((0, 5), (2, 11), (3, 7), (4, 6), (8, 9)),
    ((0, 9), (1, 6), (3, 4), (5, 11), (7, 10)),
    ((0, 10), (1, 8), (2, 4), (3, 6), (5, 9)),
    ((0, 11), (1, 5), (2, 10), (3, 8), (4, 7)),
    ((1, 11), (2, 6), (4, 10), (5, 8), (7, 9)),
)
GEOMETRIC = (
    ((0, 2), (1, 8), (3, 7), (4, 10), (5, 11)),
    ((0, 5), (1, 11), (3, 6), (4, 7), (9, 10)),
    ((0, 9), (1, 3), (2, 10), (4, 6), (5, 8)),
    ((0, 10), (1, 6), (2, 11), (3, 8), (7, 9)),
    ((0, 11), (2, 6), (3, 4), (5, 9), (7, 8)),
    ((1, 5), (2, 4), (6, 11), (7, 10), (8, 9)),
)


def cross(a, b):
    return (
        (a[1] * b[2] - a[2] * b[1]) % Q,
        (a[2] * b[0] - a[0] * b[2]) % Q,
        (a[0] * b[1] - a[1] * b[0]) % Q,
    )


def dot(a, b):
    return sum(x * y for x, y in zip(a, b)) % Q


def concurrency_point(block):
    lines = [cross(CONIC[u], CONIC[v]) for u, v in block]
    point = cross(lines[0], lines[1])
    if point != (0, 0, 0) and all(dot(line, point) == 0 for line in lines):
        return point
    return None


def decomposition_bytes(decomposition):
    return [[[u, v] for u, v in block] for block in decomposition]


def main() -> None:
    payload = json.loads(CERTIFICATE.read_text())
    for decomposition in (MATE, GEOMETRIC):
        edges = [edge for block in decomposition for edge in block]
        assert len(edges) == len(set(edges)) == 30
        assert all(len({vertex for edge in block for vertex in edge}) == 10 for block in decomposition)
    assert set(edge for block in MATE for edge in block) == set(
        edge for block in GEOMETRIC for edge in block
    )
    geometric_points = [concurrency_point(block) for block in GEOMETRIC]
    assert sum(point is not None for point in geometric_points) == 6
    assert sum(concurrency_point(block) is not None for block in MATE) == 0
    for block, point in zip(GEOMETRIC, geometric_points):
        assert point is not None
        used = {vertex for edge in block for vertex in edge}
        ports = set(range(12)) - used
        assert len(ports) == 2
        for port in ports:
            tangent = cross(point, CONIC[port])
            assert sum(dot(tangent, conic_point) == 0 for conic_point in CONIC) == 1
    root = hashlib.sha256(
        json.dumps(
            sorted([decomposition_bytes(GEOMETRIC), decomposition_bytes(MATE)]),
            separators=(",", ":"),
        ).encode()
    ).hexdigest()
    assert root == payload["orbit_decompositions_sha256"]
    assert payload["geometric_sheet"]["concurrent_block_count"] == 6
    assert payload["intrinsic_mate_sheet"]["concurrent_block_count"] == 0
    print("replayed common 30-edge set, concurrency counts 6 and 0, and 12 tangent ports")


if __name__ == "__main__":
    main()
