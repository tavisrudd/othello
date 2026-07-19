#!/usr/bin/env python3
"""Independent finite-prime replay of C339's H3 complement line spectrum."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from itertools import product
from pathlib import Path


Point = tuple[int, int, int]
PRIMES = (19, 29, 31, 41, 59, 61)


def normalize(vector: Point, q: int) -> Point:
    pivot = next(value % q for value in vector if value % q)
    inverse = pow(pivot, -1, q)
    return tuple(value * inverse % q for value in vector)  # type: ignore[return-value]


def projective_points(q: int) -> list[Point]:
    return (
        [(1, y, z) for y in range(q) for z in range(q)]
        + [(0, 1, z) for z in range(q)]
        + [(0, 0, 1)]
    )


def dot(left: Point, right: Point, q: int) -> int:
    return sum(a * b for a, b in zip(left, right)) % q


def h3_mirrors(q: int) -> set[Point]:
    tau = next(value for value in range(q) if (value * value - value - 1) % q == 0)
    mirrors: set[Point] = {(1, 0, 0), (0, 1, 0), (0, 0, 1)}
    for left_sign, right_sign in product((1, -1), repeat=2):
        root = (1, left_sign * tau, right_sign * (tau - 1))
        mirrors.update(
            {
                normalize(root, q),
                normalize((root[1], root[2], root[0]), q),
                normalize((root[2], root[0], root[1]), q),
            }
        )
    assert len(mirrors) == 15
    return mirrors


def expected(q: int) -> Counter[int]:
    return Counter(
        {
            0: 15,
            q - 14: (q - 11) * (q - 19),
            q - 13: 15 * (q - 11),
            q - 12: 10 * (q - 11),
            q - 11: 40,
            q - 10: 6 * (q - 9),
            q - 9: 66,
        }
    )


def replay(q: int) -> dict[str, object]:
    points = projective_points(q)
    mirrors = h3_mirrors(q)
    complement = [point for point in points if all(dot(line, point, q) for line in mirrors)]
    spectrum = Counter(
        sum(dot(line, point, q) == 0 for point in complement) for line in points
    )
    assert len(complement) == (q - 5) * (q - 9)
    assert spectrum == expected(q)
    return {
        "q": q,
        "complement_size": len(complement),
        "line_intersection_spectrum": {
            str(size): count for size, count in sorted(spectrum.items())
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    records = [replay(q) for q in PRIMES]
    output = Path(__file__).with_suffix(".json")
    rendered = (
        json.dumps(
            {"schema": "c339-finite-replay-v1", "records": records},
            indent=2,
            sort_keys=True,
        )
        + "\n"
    )
    if args.check:
        assert output.read_text() == rendered
    else:
        output.write_text(rendered)
    print(f"sha256={hashlib.sha256(rendered.encode()).hexdigest()} bytes={len(rendered)}")
    print("checked_q=" + ",".join(str(q) for q in PRIMES))
    print("C339_FINITE_REPLAY_PASS")


if __name__ == "__main__":
    main()
