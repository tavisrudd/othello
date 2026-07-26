#!/usr/bin/env python3
"""Exact C666 certificate for the seven-fiber Rédei near-counterexample."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import pathlib
import tempfile

Q = 16
MODULUS = 0x13  # x^4 + x + 1


def mul(a: int, b: int) -> int:
    out = 0
    while b:
        if b & 1:
            out ^= a
        b >>= 1
        a <<= 1
        if a & Q:
            a ^= MODULUS
    return out


def inv(a: int) -> int:
    if not a:
        raise ZeroDivisionError
    return next(b for b in range(1, Q) if mul(a, b) == 1)


def dot(a: tuple[int, ...], b: tuple[int, ...]) -> int:
    out = 0
    for x, y in zip(a, b):
        out ^= mul(x, y)
    return out


def normalize(vector: tuple[int, ...]) -> tuple[int, ...]:
    lead = next(x for x in vector if x)
    scalar = inv(lead)
    return tuple(mul(scalar, x) for x in vector)


def cross(a: tuple[int, ...], b: tuple[int, ...]) -> tuple[int, ...]:
    return normalize(
        (
            mul(a[1], b[2]) ^ mul(a[2], b[1]),
            mul(a[2], b[0]) ^ mul(a[0], b[2]),
            mul(a[0], b[1]) ^ mul(a[1], b[0]),
        )
    )


POINTS = tuple(
    [(0, 0, 1)]
    + [(0, 1, z) for z in range(Q)]
    + [(1, y, z) for y in range(Q) for z in range(Q)]
)
POINT_INDEX = {point: i for i, point in enumerate(POINTS)}
LINES = {
    line: tuple(i for i, point in enumerate(POINTS) if dot(line, point) == 0)
    for line in POINTS
}

ARC = (0, 1, 17, 34, 52, 67, 89, 127)
CONIC_FORM = (1, 11, 4, 4, 10, 9)  # X^2,Y^2,Z^2,XY,XZ,YZ
UNcovered_BASE = 240


def monomial(point: tuple[int, ...]) -> tuple[int, ...]:
    x, y, z = point
    return (mul(x, x), mul(y, y), mul(z, z), mul(x, y), mul(x, z), mul(y, z))


def on_conic(index: int) -> bool:
    return dot(CONIC_FORM, monomial(POINTS[index])) == 0


def line_through(a: int, b: int) -> tuple[int, ...]:
    return LINES[cross(POINTS[a], POINTS[b])]


def covered_points() -> set[int]:
    covered: set[int] = set()
    for a, b in itertools.combinations(ARC, 2):
        covered.update(line_through(a, b))
    return covered


def polar_radical() -> tuple[int, ...]:
    _, _, _, xy, xz, yz = CONIC_FORM
    polar = ((0, xy, xz), (xy, 0, yz), (xz, yz, 0))
    radical = tuple(point for point in POINTS if all(dot(row, point) == 0 for row in polar))
    assert len(radical) == 1
    return radical[0]


def rref(rows: list[tuple[int, ...]]) -> tuple[list[list[int]], list[int]]:
    matrix = [list(row) for row in rows]
    pivots: list[int] = []
    row = 0
    for column in range(len(matrix[0]) if matrix else 0):
        pivot = next((i for i in range(row, len(matrix)) if matrix[i][column]), None)
        if pivot is None:
            continue
        matrix[row], matrix[pivot] = matrix[pivot], matrix[row]
        scalar = inv(matrix[row][column])
        matrix[row] = [mul(scalar, x) for x in matrix[row]]
        for i in range(len(matrix)):
            if i != row and matrix[i][column]:
                coefficient = matrix[i][column]
                matrix[i] = [
                    x ^ mul(coefficient, y)
                    for x, y in zip(matrix[i], matrix[row])
                ]
        pivots.append(column)
        row += 1
    return matrix, pivots


def one_dimensional_kernel(rows: list[tuple[int, ...]]) -> tuple[int, ...]:
    matrix, pivots = rref(rows)
    free = [column for column in range(len(rows[0])) if column not in pivots]
    assert len(free) == 1
    vector = [0] * len(rows[0])
    vector[free[0]] = 1
    for i, pivot in enumerate(pivots):
        vector[pivot] = matrix[i][free[0]]
    return normalize(tuple(vector))


def build_certificate() -> dict:
    for triple in itertools.combinations(ARC, 3):
        assert dot(cross(POINTS[triple[0]], POINTS[triple[1]]), POINTS[triple[2]]) != 0

    conic = tuple(i for i in range(len(POINTS)) if on_conic(i))
    assert len(conic) == Q + 1
    assert not set(ARC) & set(conic)
    radical = polar_radical()
    assert dot(CONIC_FORM, monomial(radical)) != 0

    covered = covered_points()
    holes = tuple(i for i in range(len(POINTS)) if i not in covered and i not in ARC)
    assert UNcovered_BASE in holes

    fibers = []
    good_count = 0
    exceptional_count = 0
    for arc_position, a in enumerate(ARC):
        fiber = line_through(UNcovered_BASE, a)
        second_conic = tuple(i for i in fiber if i != UNcovered_BASE and on_conic(i))
        assert len(second_conic) == 1
        second = second_conic[0]
        fiber_holes = tuple(i for i in fiber if i in holes and i != UNcovered_BASE)
        nonincident_roots = set()
        root_multiplicities: dict[int, int] = {}
        complementary_arc = tuple(b for b in ARC if b != a)
        for b, c in itertools.combinations(complementary_arc, 2):
            intersection = POINT_INDEX[cross(cross(POINTS[b], POINTS[c]), cross(POINTS[UNcovered_BASE], POINTS[a]))]
            nonincident_roots.add(intersection)
            root_multiplicities[intersection] = root_multiplicities.get(intersection, 0) + 1

        required_off_conic = {
            i for i in fiber if i != a and not on_conic(i)
        }
        good = required_off_conic <= nonincident_roots
        exceptional = good and second in nonincident_roots
        if good:
            good_count += 1
            assert set(fiber_holes) <= {second}
            assert len(nonincident_roots) == (15 if exceptional else 14)
        if exceptional:
            exceptional_count += 1

        fibers.append(
            {
                "arc_point": a,
                "arc_position": arc_position,
                "complementary_chord_count": 21,
                "exceptional_all_allowable_roots": exceptional,
                "fiber_holes_other_than_base": list(fiber_holes),
                "fiber_point_count": len(fiber),
                "quotient_divisibility": good,
                "residual_degree": 21 - len(required_off_conic) - (1 if exceptional else 0)
                if good
                else None,
                "root_count": len(nonincident_roots),
                "root_multiplicity_profile": sorted(root_multiplicities.values(), reverse=True),
                "second_conic_point": second,
            }
        )

    assert good_count == 7
    assert exceptional_count == 2
    assert [fiber["arc_position"] for fiber in fibers if not fiber["quotient_divisibility"]] == [5]
    assert fibers[5]["fiber_holes_other_than_base"] == [264]
    assert not on_conic(264)

    determining_holes = (
        UNcovered_BASE,
        *(
            fiber["second_conic_point"]
            for fiber in fibers
            if fiber["quotient_divisibility"]
            and not fiber["exceptional_all_allowable_roots"]
        ),
    )
    determining_rows = [monomial(POINTS[i]) for i in determining_holes]
    assert len(determining_holes) == 6
    assert len(rref(determining_rows)[1]) == 5
    determining_kernel = one_dimensional_kernel(determining_rows)
    assert normalize(CONIC_FORM) == determining_kernel
    assert dot(determining_kernel, monomial(POINTS[264])) != 0

    return {
        "arc_indices": list(ARC),
        "arc_points": [list(POINTS[i]) for i in ARC],
        "arc_size": len(ARC),
        "base_uncovered_index": UNcovered_BASE,
        "base_uncovered_point": list(POINTS[UNcovered_BASE]),
        "conic_form": list(CONIC_FORM),
        "conic_indices": list(conic),
        "conic_point_count": len(conic),
        "conic_polar_radical": list(radical),
        "determining_hole_indices": list(determining_holes),
        "determining_hole_quadratic_kernel": list(determining_kernel),
        "determining_hole_quadratic_rank": 5,
        "eighth_fiber_off_conic_hole": 264,
        "exceptional_fiber_count": exceptional_count,
        "fibers": fibers,
        "field": "GF(16), polynomial basis modulo x^4+x+1",
        "good_fiber_count": good_count,
        "ordinary_hole_count": len(holes),
        "ordinary_holes": list(holes),
        "schema": "c666-redei-seven-fiber-near-counterexample-v1",
    }


def canonical_bytes(certificate: dict) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    default_output = pathlib.Path(__file__).with_suffix(".json")
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=pathlib.Path, default=default_output)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    content = canonical_bytes(build_certificate())
    if args.write:
        args.output.write_bytes(content)
        print(hashlib.sha256(content).hexdigest())
        return
    with tempfile.TemporaryDirectory() as directory:
        regenerated = pathlib.Path(directory) / args.output.name
        regenerated.write_bytes(content)
        if not args.output.exists() or args.output.read_bytes() != regenerated.read_bytes():
            raise SystemExit(f"certificate mismatch: {args.output}")
    print("PASS")


if __name__ == "__main__":
    main()
