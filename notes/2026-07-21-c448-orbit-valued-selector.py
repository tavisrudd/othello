#!/usr/bin/env python3
"""Exact q=5 support certificate for C448's antipodal-copycat comparison."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
STEM = ROOT / "2026-07-21-c448-orbit-valued-selector"
REPORT = STEM.with_suffix(".md")
SCRIPT = STEM.with_suffix(".py")
CERTIFICATE = STEM.with_suffix(".json")
MANIFEST = STEM.with_suffix(".sha256")
Q = 5
FRAME = ((1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 1))


def normalize(vector: tuple[int, int, int]) -> tuple[int, int, int]:
    vector = tuple(entry % Q for entry in vector)
    pivot = next(entry for entry in vector if entry)
    inverse = pow(pivot, Q - 2, Q)
    return tuple(entry * inverse % Q for entry in vector)


def points() -> tuple[tuple[int, int, int], ...]:
    return tuple(
        sorted(
            {
                normalize(vector)
                for vector in itertools.product(range(Q), repeat=3)
                if any(vector)
            }
        )
    )


def determinant(rows: tuple[tuple[int, int, int], ...]) -> int:
    (a, b, c), (d, e, f), (g, h, i) = rows
    return (a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)) % Q


def is_arc(vertices: tuple[tuple[int, int, int], ...]) -> bool:
    return all(determinant(triple) != 0 for triple in itertools.combinations(vertices, 3))


def conic_value(point: tuple[int, int, int]) -> int:
    x, y, z = point
    return (x * x + y * y + z * z + x * y + x * z + y * z) % Q


def point_key(point: tuple[int, int, int]) -> str:
    return ":".join(map(str, point))


def pair_key(pair: tuple[tuple[int, int, int], tuple[int, int, int]]) -> list[str]:
    return [point_key(point) for point in pair]


def build_certificate() -> dict[str, object]:
    projective_points = points()
    assert len(projective_points) == Q * Q + Q + 1 == 31
    assert is_arc(FRAME)

    uncovered = tuple(point for point in projective_points if is_arc(FRAME + (point,)))
    conic = tuple(point for point in projective_points if conic_value(point) == 0)
    assert uncovered == conic
    assert len(uncovered) == Q + 1 == 6

    conflict_edges = []
    legal_pairs = []
    for pair in itertools.combinations(uncovered, 2):
        if is_arc(FRAME + pair):
            legal_pairs.append(pair)
        else:
            conflict_edges.append(pair)

    assert len(conflict_edges) == 12
    assert len(legal_pairs) == 3
    assert {point for pair in legal_pairs for point in pair} == set(uncovered)

    antipode: dict[tuple[int, int, int], tuple[int, int, int]] = {}
    for left, right in legal_pairs:
        antipode[left] = right
        antipode[right] = left
    assert all(antipode[antipode[point]] == point and antipode[point] != point for point in uncovered)

    # In K6 minus the legal perfect matching, the antipode is the unique legal reply.
    for move in uncovered:
        replies = tuple(
            reply
            for reply in uncovered
            if reply != move and is_arc(FRAME + (move, reply))
        )
        assert replies == (antipode[move],)
        assert not any(
            is_arc(FRAME + (move, antipode[move], third))
            for third in uncovered
            if third not in (move, antipode[move])
        )

    return {
        "schema": "c448-q5-antipodal-copycat-v1",
        "field_order": Q,
        "projective_point_count": len(projective_points),
        "frame": [point_key(point) for point in FRAME],
        "conic_equation": "X^2+Y^2+Z^2+XY+XZ+YZ",
        "uncovered_points": [point_key(point) for point in uncovered],
        "conflict_edges": [pair_key(pair) for pair in conflict_edges],
        "legal_non_edges": [pair_key(pair) for pair in legal_pairs],
        "antipode": {point_key(point): point_key(antipode[point]) for point in uncovered},
        "checks": {
            "frame_is_arc": True,
            "uncovered_equals_nonsingular_conic_input_from_c187": True,
            "conflict_graph": "K6-minus-perfect-matching",
            "antipode_is_fixed_point_free_involution": True,
            "antipode_is_unique_legal_reply": True,
            "reply_pair_is_terminal": True,
            "seeded_position_is_P_by_copycat": True,
        },
    }


def canonical_json(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def manifest_bytes(json_bytes: bytes) -> bytes:
    payloads = {
        REPORT.name: REPORT.read_bytes(),
        SCRIPT.name: SCRIPT.read_bytes(),
        CERTIFICATE.name: json_bytes,
    }
    return "".join(
        f"{hashlib.sha256(payload).hexdigest()}  notes/{name}\n"
        for name, payload in payloads.items()
    ).encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()

    json_bytes = canonical_json(build_certificate())
    expected_manifest = manifest_bytes(json_bytes)
    if args.write:
        CERTIFICATE.write_bytes(json_bytes)
        MANIFEST.write_bytes(expected_manifest)
        print(f"wrote {CERTIFICATE.name} and {MANIFEST.name}")
        return

    assert CERTIFICATE.read_bytes() == json_bytes, "certificate drift"
    assert MANIFEST.read_bytes() == expected_manifest, "manifest drift"
    print("C448_Q5_SUPPORT_PASS")


if __name__ == "__main__":
    main()
