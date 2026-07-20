#!/usr/bin/env python3
"""Exact compatibility certificate for the C368 H3/A5 phase theorem."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path


Point = tuple[int, int, int]
Matrix = tuple[Point, Point, Point]
OUTPUT = Path(__file__).with_suffix(".json")


def inverse(value: int, q: int) -> int:
    return pow(value % q, -1, q)


def normalize(vector: Point, q: int) -> Point:
    for value in vector:
        if value % q:
            scale = inverse(value, q)
            return tuple(scale * entry % q for entry in vector)  # type: ignore[return-value]
    raise ValueError("zero vector has no projective normalization")


def projective_points(q: int) -> list[Point]:
    return sorted(
        {
            normalize(vector, q)
            for vector in itertools.product(range(q), repeat=3)
            if vector != (0, 0, 0)
        }
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
    return sum(a * b for a, b in zip(left, right)) % q


def determinant3(columns: tuple[Point, Point, Point], q: int) -> int:
    left, middle, right = columns
    return (
        left[0] * (middle[1] * right[2] - middle[2] * right[1])
        - middle[0] * (left[1] * right[2] - left[2] * right[1])
        + right[0] * (left[1] * middle[2] - left[2] * middle[1])
    ) % q


def determinant(matrix: list[list[int]], q: int) -> int:
    work = [[entry % q for entry in row] for row in matrix]
    result = 1
    for column in range(len(work)):
        pivot = next((row for row in range(column, len(work)) if work[row][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            result = -result
        pivot_value = work[column][column]
        result = result * pivot_value % q
        scale = inverse(pivot_value, q)
        work[column] = [scale * entry % q for entry in work[column]]
        for row in range(column + 1, len(work)):
            factor = work[row][column]
            work[row] = [
                (entry - factor * pivot_entry) % q
                for entry, pivot_entry in zip(work[row], work[column])
            ]
    return result % q


def six_points(q: int, tau: int) -> list[Point]:
    raw = [
        (0, 1, 1 - tau),
        (0, 1, tau - 1),
        (1, 1 - tau, 0),
        (1, tau - 1, 0),
        (1, 0, -tau),
        (1, 0, tau),
    ]
    return sorted({normalize(point, q) for point in raw})


def quadratic_evaluation_determinant(points: list[Point], q: int) -> int:
    rows = [
        [x * x, y * y, z * z, x * y, x * z, y * z]
        for x, y, z in points
    ]
    return determinant(rows, q)


def secant_complement(points: list[Point], q: int) -> tuple[list[Point], list[Point]]:
    lines = sorted({cross(left, right, q) for left, right in itertools.combinations(points, 2)})
    covered = {
        point
        for point in projective_points(q)
        if any(dot(line, point, q) == 0 for line in lines)
    }
    return lines, sorted(set(projective_points(q)) - covered)


def matrix_vector(matrix: Matrix, point: Point, q: int) -> Point:
    return normalize(
        tuple(sum(row[index] * point[index] for index in range(3)) % q for row in matrix),  # type: ignore[arg-type]
        q,
    )


def conic_points(q: int, equation: str) -> list[Point]:
    if equation == "sum_of_squares":
        predicate = lambda p: (p[0] ** 2 + p[1] ** 2 + p[2] ** 2) % q == 0
    elif equation == "xz_equals_y2":
        predicate = lambda p: (p[0] * p[2] - p[1] ** 2) % q == 0
    else:
        raise ValueError(equation)
    return [point for point in projective_points(q) if predicate(point)]


def all_triples_independent(points: list[Point], q: int) -> bool:
    return all(determinant3(choice, q) != 0 for choice in itertools.combinations(points, 3))


def maximum_line_intersection(points: list[Point], q: int) -> int:
    return max(sum(dot(line, point, q) == 0 for point in points) for line in projective_points(q))


def certificate() -> dict[str, object]:
    columns5 = six_points(5, 3)
    conic5 = conic_points(5, "sum_of_squares")
    lines5, complement5 = secant_complement(columns5, 5)
    assert columns5 == conic5
    assert len(lines5) == 15 and complement5 == []
    assert all_triples_independent(columns5, 5)
    assert quadratic_evaluation_determinant(columns5, 5) == 0

    columns11 = six_points(11, 8)
    lines11, complement11 = secant_complement(columns11, 11)
    columns11_conjugate = six_points(11, 4)
    lines11_conjugate, complement11_conjugate = secant_complement(columns11_conjugate, 11)
    invariant_conic11 = conic_points(11, "sum_of_squares")
    projectivity: Matrix = ((2, 3, 8), (10, 6, 9), (2, 2, 5))
    mapped_columns11 = sorted(matrix_vector(projectivity, point, 11) for point in columns11)
    expected_manuscript_columns = sorted(
        {(1, 10, 0), (1, 9, 1), (1, 4, 7), (1, 8, 5), (0, 1, 4), (1, 1, 7)}
    )
    mapped_complement11 = sorted(matrix_vector(projectivity, point, 11) for point in complement11)
    conic11 = conic_points(11, "xz_equals_y2")
    assert mapped_columns11 == expected_manuscript_columns
    assert len(lines11) == 15 and len(complement11) == 12
    assert len(lines11_conjugate) == 15 and complement11_conjugate == complement11
    assert complement11 == invariant_conic11
    assert mapped_complement11 == conic11
    assert quadratic_evaluation_determinant(columns11, 11) != 0
    assert quadratic_evaluation_determinant(columns11_conjugate, 11) != 0
    assert all_triples_independent(complement11, 11)
    assert maximum_line_intersection(complement11, 11) == 2

    return {
        "schema": "c368-h3-a5-arithmetic-phase/v1",
        "characteristic_5_source_phase": {
            "field_order": 5,
            "tau": 3,
            "source_columns": columns5,
            "source_conic": "X^2 + Y^2 + Z^2 = 0",
            "source_conic_points": conic5,
            "secant_count": len(lines5),
            "secant_complement_size": len(complement5),
            "quadratic_evaluation_determinant_mod_5": 0,
        },
        "q11_deep_hole_phase": {
            "field_order": 11,
            "verified_tau_roots": [4, 8],
            "source_quadratic_evaluation_determinants_mod_11": {
                "tau_4": quadratic_evaluation_determinant(columns11_conjugate, 11),
                "tau_8": quadratic_evaluation_determinant(columns11, 11),
            },
            "secant_count": len(lines11),
            "deep_hole_points_h3_coordinates": complement11,
            "deep_hole_conic_h3_coordinates": "X^2 + Y^2 + Z^2 = 0",
            "tau_8_source_columns": columns11,
            "projectivity_to_manuscript_coordinates": projectivity,
            "mapped_source_columns": mapped_columns11,
            "mapped_deep_hole_points": mapped_complement11,
            "deep_hole_conic_manuscript_coordinates": "XZ = Y^2",
            "deep_hole_conic_points_manuscript_coordinates": conic11,
            "child_projective_code_parameters": [12, 3, 10],
            "child_maximum_line_intersection": maximum_line_intersection(complement11, 11),
        },
    }


def canonical_bytes() -> bytes:
    return (json.dumps(certificate(), indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    generated = canonical_bytes()
    if args.write:
        OUTPUT.write_bytes(generated)
        print(f"wrote {OUTPUT.name}: {len(generated)} bytes sha256={hashlib.sha256(generated).hexdigest()}")
    else:
        tracked = OUTPUT.read_bytes()
        assert tracked == generated
        print(f"checked {OUTPUT.name}: {len(generated)} bytes sha256={hashlib.sha256(generated).hexdigest()}")


if __name__ == "__main__":
    main()
