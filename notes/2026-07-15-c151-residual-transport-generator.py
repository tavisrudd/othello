#!/usr/bin/env python3
"""Derive C151 eight-point residual-transport permutations from the checked CSV."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import sys
from collections import Counter
from pathlib import Path
from typing import NamedTuple


HERE = Path(__file__).resolve().parent
COVER_GENERATOR = HERE / "2026-07-15-c151-residual-cover-generator.py"
EXPECTED_VALID_ROWS = 7044


def load_cover_generator():
    spec = importlib.util.spec_from_file_location("c151_residual_cover_generator", COVER_GENERATOR)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


cover = load_cover_generator()


class Point(NamedTuple):
    chart: int
    y: int
    z: int


class TransportRecord(NamedTuple):
    row: object
    forward: tuple[int, ...]
    inverse: tuple[int, ...]


def gf_add(a: int, b: int) -> int:
    return (a % 5 + b % 5) % 5 + 5 * ((a // 5 + b // 5) % 5)


def gf_mul(a: int, b: int) -> int:
    real = (a % 5 * (b % 5) + 2 * (a // 5 * (b // 5))) % 5
    imag = (a % 5 * (b // 5) + a // 5 * (b % 5)) % 5
    return real + 5 * imag


def gf_conj(a: int) -> int:
    return a % 5 + 5 * ((-(a // 5)) % 5)


def small_nonfixed(a: int, b: int) -> int:
    return a + 5 * (b + 1)


def orbit_representative(number: int) -> Point:
    if number < 250:
        return Point(1, small_nonfixed(number // 50, (number // 25) % 2), number % 25)
    if number < 300:
        offset = number - 250
        return Point(1, (offset // 10) % 5, small_nonfixed((offset // 2) % 5, offset % 2))
    offset = number - 300
    return Point(0, 1, small_nonfixed((offset // 2) % 5, offset % 2))


def conjugate(point: Point) -> Point:
    if point.chart == 1:
        return Point(1, gf_conj(point.y), gf_conj(point.z))
    if point.chart == 0:
        return Point(0, 1, gf_conj(point.z))
    assert point == Point(-1, 0, 1)
    return point


def config_points(b: int, c: int) -> tuple[Point, ...]:
    points = [Point(-1, 0, 1), Point(0, 1, 0)]
    for number in (5, b, c):
        representative = orbit_representative(number)
        points.extend((representative, conjugate(representative)))
    assert len(points) == 8 and len(set(points)) == 8
    return tuple(points)


def coordinate_scale(parameter: int) -> int:
    imaginary = parameter // 5
    assert imaginary != 0
    return pow(imaginary, -1, 5)


def coordinate_shift(parameter: int) -> int:
    return (-coordinate_scale(parameter) * (parameter % 5)) % 5


def residual_apply(y: int, z: int, point: Point) -> Point:
    if point.chart == 1:
        return Point(
            1,
            gf_add(coordinate_shift(y), gf_mul(coordinate_scale(y), point.y)),
            gf_add(coordinate_shift(z), gf_mul(coordinate_scale(z), point.z)),
        )
    if point.chart == 0:
        coefficient = (y // 5) * coordinate_scale(z) % 5
        return Point(0, 1, gf_mul(coefficient, point.z))
    assert point == Point(-1, 0, 1)
    return point


def transport_permutation(row) -> TransportRecord:
    assert row.valid
    source = config_points(row.b, row.c)
    target = config_points(row.canonical_b, row.canonical_c)
    target_index = {point: index for index, point in enumerate(target)}
    forward = tuple(target_index[residual_apply(row.y, row.z, point)] for point in source)
    assert sorted(forward) == list(range(8))
    inverse = tuple(forward.index(index) for index in range(8))
    assert all(forward[inverse[index]] == index for index in range(8))
    return TransportRecord(row, forward, inverse)


def transport_fnv1a64(records: tuple[TransportRecord, ...]) -> int:
    state = 14_695_981_039_346_656_037
    for record in records:
        for value in (record.row.b, record.row.c, *record.forward, *record.inverse):
            state = cover.fnv_feed(value, state)
    return state


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--csv", required=True, type=Path)
    args = parser.parse_args()
    rows, _ = cover.read_records(args.csv)
    transports = tuple(transport_permutation(row) for row in rows if row.valid)
    assert len(transports) == EXPECTED_VALID_ROWS
    prototype = next(record for record in transports if (record.row.b, record.row.c) == (40, 196))
    assert prototype.forward == (0, 1, 7, 6, 4, 5, 2, 3)
    assert prototype.inverse == (0, 1, 6, 7, 4, 5, 3, 2)
    histogram = Counter(record.forward for record in transports)
    assert sum(histogram.values()) == EXPECTED_VALID_ROWS
    print(f"valid_rows={len(transports)} distinct_point_permutations={len(histogram)}")
    print(f"transport_fnv1a64={transport_fnv1a64(transports):016x}")
    print(f"csv_sha256={hashlib.sha256(args.csv.read_bytes()).hexdigest()}")
    print(f"cover_generator_sha256={cover.source_sha256()}")
    print(f"generator_sha256={hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}")


if __name__ == "__main__":
    main()
