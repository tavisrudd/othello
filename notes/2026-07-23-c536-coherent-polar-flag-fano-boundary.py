#!/usr/bin/env python3
"""Bounded exact checks for C536's polar-minor and Lucas tables."""

from __future__ import annotations

import argparse
import hashlib
import json
from itertools import combinations
from math import comb
from pathlib import Path


STEM = Path(__file__).with_suffix("")
JSON_PATH = STEM.with_suffix(".json")
MANIFEST_PATH = STEM.with_suffix(".sha256")
PRIMES = (2, 3, 5, 7, 11, 101)


def rank_mod_p(rows: list[list[int]], prime: int, width: int) -> int:
    matrix = [[entry % prime for entry in row] for row in rows]
    rank = 0
    for column in range(width):
        pivot = next(
            (row for row in range(rank, len(matrix)) if matrix[row][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inverse = pow(matrix[rank][column], -1, prime)
        matrix[rank] = [(inverse * entry) % prime for entry in matrix[rank]]
        for row in range(len(matrix)):
            if row != rank and matrix[row][column]:
                scale = matrix[row][column]
                matrix[row] = [
                    (left - scale * right) % prime
                    for left, right in zip(matrix[row], matrix[rank])
                ]
        rank += 1
    return rank


def polar_minor_rows(upper_degree: int) -> tuple[list[list[int]], int]:
    """Coefficient vectors of lower polar minors in upper Hankel minors."""
    minors = list(combinations(range(upper_degree - 1), 3))
    positions = {minor: index for index, minor in enumerate(minors)}
    rows: list[list[int]] = []
    for lower_columns in combinations(range(upper_degree - 2), 3):
        for y_degree in range(4):
            row = [0] * len(minors)
            for shifted_positions in combinations(range(3), y_degree):
                shifted = tuple(
                    lower_columns[index] + (index in shifted_positions)
                    for index in range(3)
                )
                if len(set(shifted)) == 3:
                    row[positions[shifted]] += 1
            rows.append(row)
    return rows, len(minors)


def polar_certificate() -> list[dict[str, object]]:
    records = []
    for upper_degree in range(4, 13):
        rows, target_rank = polar_minor_rows(upper_degree)
        records.append(
            {
                "upper_degree": upper_degree,
                "target_hankel_minors": target_rank,
                "coefficient_rows": len(rows),
                "ranks_mod_primes": {
                    str(prime): rank_mod_p(rows, prime, target_rank)
                    for prime in PRIMES
                },
            }
        )
    return records


def prime_divisors(number: int) -> list[int]:
    return [
        prime
        for prime in range(2, number + 1)
        if all(prime % divisor for divisor in range(2, int(prime**0.5) + 1))
    ]


def lucas_certificate() -> list[dict[str, object]]:
    records = []
    for lower_degree in range(2, 9):
        for characteristic in prime_divisors(lower_degree):
            seen: set[tuple[int, ...]] = set()
            for nucleus_order in range(lower_degree):
                support = tuple(
                    index
                    for index in range(lower_degree + 1)
                    if all(
                        comb(row, index) % characteristic == 0
                        for row in range(nucleus_order + 1, lower_degree + 1)
                    )
                )
                if support in seen:
                    continue
                seen.add(support)
                lift = tuple(
                    index
                    for index in range(lower_degree + 2)
                    if (index == lower_degree + 1 or index in support)
                    and (index == 0 or index - 1 in support)
                )
                if lift:
                    records.append(
                        {
                            "lower_degree": lower_degree,
                            "characteristic": characteristic,
                            "first_nucleus_order_with_support": nucleus_order,
                            "nucleus_support": list(support),
                            "upper_consecutive_lift": list(lift),
                            "upper_vector_rank": len(lift),
                        }
                    )
    return records


def payload() -> dict[str, object]:
    return {
        "schema": "c536-coherent-polar-flag-fano-boundary-v1",
        "scope": {
            "polar_upper_degrees": [4, 12],
            "lucas_lower_degrees": [2, 8],
            "rank_check_primes": list(PRIMES),
        },
        "polar_minor_span": polar_certificate(),
        "nonzero_lucas_lifts": lucas_certificate(),
    }


def canonical_bytes() -> bytes:
    return (json.dumps(payload(), indent=2, sort_keys=True) + "\n").encode()


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def manifest_bytes() -> bytes:
    paths = (Path(__file__), JSON_PATH)
    return "".join(f"{digest(path)}  {path.name}\n" for path in paths).encode()


def write_bundle() -> None:
    JSON_PATH.write_bytes(canonical_bytes())
    MANIFEST_PATH.write_bytes(manifest_bytes())


def check_bundle() -> None:
    if JSON_PATH.read_bytes() != canonical_bytes():
        raise SystemExit(f"stale certificate: {JSON_PATH}")
    expected = manifest_bytes()
    if MANIFEST_PATH.read_bytes() != expected:
        raise SystemExit(f"stale manifest: {MANIFEST_PATH}")
    print(
        "C536 certificate OK: upper degrees 4..12; "
        "Lucas lower degrees 2..8"
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--write", action="store_true")
    action.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write:
        write_bundle()
    else:
        check_bundle()


if __name__ == "__main__":
    main()
