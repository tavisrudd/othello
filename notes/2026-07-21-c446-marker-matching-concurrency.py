#!/usr/bin/env python3
"""Exact C446 concurrency test for the frozen C406 marker matchings."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter
from pathlib import Path


SCHEMA = "c446-marker-matching-concurrency-v1"
HERE = Path(__file__).resolve().parent
FROZEN = HERE / "2026-07-20-c406-matching-orbit-scout.json"
OUTPUT = Path(__file__).with_suffix(".json")


def normalize(values: tuple[int, ...], prime: int) -> tuple[int, ...]:
    values = tuple(value % prime for value in values)
    pivot = next(value for value in values if value)
    inverse = pow(pivot, -1, prime)
    return tuple(value * inverse % prime for value in values)


def pgl_actions(prime: int, endpoints: tuple[tuple[int, int], ...]):
    endpoint_index = {point: index for index, point in enumerate(endpoints)}
    actions: dict[tuple[int, ...], int] = {}
    normalized_matrices = set()
    for matrix in itertools.product(range(prime), repeat=4):
        a, b, c, d = matrix
        determinant = (a * d - b * c) % prime
        if determinant == 0:
            continue
        normalized_matrices.add(normalize(matrix, prime))
    for a, b, c, d in normalized_matrices:
        determinant = (a * d - b * c) % prime
        permutation = tuple(
            endpoint_index[normalize((a * s + b * t, c * s + d * t), prime)]
            for s, t in endpoints
        )
        actions[permutation] = determinant
    assert len(actions) == prime * (prime * prime - 1)
    return actions


def matching_image(permutation: tuple[int, ...], matching):
    return tuple(
        sorted(tuple(sorted((permutation[left], permutation[right]))) for left, right in matching)
    )


def line_through(left: tuple[int, int, int], right: tuple[int, int, int], prime: int):
    x1, y1, z1 = left
    x2, y2, z2 = right
    return normalize(
        (y1 * z2 - z1 * y2, z1 * x2 - x1 * z2, x1 * y2 - y1 * x2), prime
    )


def determinant(rows, prime: int) -> int:
    (a, b, c), (d, e, f), (g, h, i) = rows
    return (a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)) % prime


def rank(rows, prime: int) -> int:
    matrix = [list(row) for row in rows]
    result = 0
    for column in range(3):
        pivot = next((row for row in range(result, len(matrix)) if matrix[row][column] % prime), None)
        if pivot is None:
            continue
        matrix[result], matrix[pivot] = matrix[pivot], matrix[result]
        inverse = pow(matrix[result][column] % prime, -1, prime)
        matrix[result] = [value * inverse % prime for value in matrix[result]]
        for row in range(len(matrix)):
            if row == result:
                continue
            factor = matrix[row][column] % prime
            if factor:
                matrix[row] = [
                    (value - factor * pivot_value) % prime
                    for value, pivot_value in zip(matrix[row], matrix[result])
                ]
        result += 1
    return result


def encode_matching(matching):
    return [list(edge) for edge in matching]


def type_certificate(frozen_type):
    name = frozen_type["type"]
    prime = frozen_type["field_order"]
    endpoints = tuple(tuple(point) for point in frozen_type["p1_endpoints"])
    conic = tuple(tuple(point) for point in frozen_type["conic_points"])
    base = tuple(tuple(edge) for edge in frozen_type["coxeter_invariant_matching"])
    actions = pgl_actions(prime, endpoints)
    squares = {value * value % prime for value in range(1, prime)}
    psl = {permutation for permutation, det in actions.items() if det in squares}
    target = sorted({matching_image(permutation, base) for permutation in actions})
    assert len(target) == frozen_type["target_orbit_size"]

    remaining = set(target)
    sheet_by_matching = {}
    sheets = []
    while remaining:
        representative = min(remaining)
        sheet = {matching_image(permutation, representative) for permutation in psl}
        sheet &= set(target)
        remaining -= sheet
        sheets.append(sorted(sheet))
    sheets.sort(key=lambda sheet: sheet[0])
    for sheet_index, sheet in enumerate(sheets):
        for matching in sheet:
            sheet_by_matching[matching] = sheet_index
    assert sorted(map(len, sheets)) == frozen_type["psl_target_orbit_sizes"]

    records = []
    rank_histogram = Counter()
    for matching in target:
        lines = tuple(line_through(conic[left], conic[right], prime) for left, right in matching)
        line_rank = rank(lines, prime)
        rank_histogram[line_rank] += 1
        witness = next(
            (
                {"line_indices": list(indices), "determinant": determinant([lines[i] for i in indices], prime)}
                for indices in itertools.combinations(range(len(lines)), 3)
                if determinant([lines[i] for i in indices], prime)
            ),
            None,
        )
        assert line_rank == 3 and witness is not None
        records.append(
            {
                "matching": encode_matching(matching),
                "psl_sheet": sheet_by_matching[matching],
                "secant_lines": [list(line) for line in lines],
                "line_rank": line_rank,
                "concurrent": False,
                "nonconcurrency_witness": witness,
            }
        )

    parent_order = frozen_type["coxeter_parent_order"]
    secant_pencil_point_stabilizer_order = 2 * (prime + 1)
    return {
        "type": name,
        "field_order": prime,
        "matching_count": len(target),
        "secants_per_matching": (prime + 1) // 2,
        "psl_sheet_sizes": [len(sheet) for sheet in sheets],
        "concurrent_count": 0,
        "line_rank_histogram": {str(key): value for key, value in sorted(rank_histogram.items())},
        "matching_records": records,
        "orbit_stabilizer_cross_check": {
            "target_matching_stabilizer_order": parent_order,
            "secant_pencil_point_stabilizer_order": secant_pencil_point_stabilizer_order,
            "target_stabilizer_cannot_fix_secant_pencil_point": (
                parent_order > secant_pencil_point_stabilizer_order
            ),
        },
        "exterior_point_identification": None,
    }


def build_certificate():
    frozen_bytes = FROZEN.read_bytes()
    frozen = json.loads(frozen_bytes)
    assert frozen["schema"] == "c406-matching-orbit-scout-v1"
    types = [type_certificate(item) for item in frozen["types"]]
    assert [(item["type"], item["matching_count"], item["concurrent_count"]) for item in types] == [
        ("A3", 5, 0),
        ("B3", 14, 0),
        ("H3", 22, 0),
    ]
    return {
        "schema": SCHEMA,
        "verdict": "ROW_36_CLOSES_NEGATIVE_NO_FROZEN_MARKER_MATCHING_IS_CONCURRENT",
        "input": {
            "path": FROZEN.name,
            "bytes": len(frozen_bytes),
            "sha256": hashlib.sha256(frozen_bytes).hexdigest(),
        },
        "types": types,
        "summary": {
            "matching_records_checked": sum(item["matching_count"] for item in types),
            "concurrent_records": 0,
            "h3_geometric_leg_for_x3": False,
            "conditional_orbit_identification_triggered": False,
        },
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT.name}")
    elif not OUTPUT.exists() or OUTPUT.read_text() != rendered:
        raise SystemExit(f"stale certificate: run {Path(__file__).name} --write")
    else:
        print("C446 concurrency certificate OK")


if __name__ == "__main__":
    main()
