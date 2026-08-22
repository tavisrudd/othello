#!/usr/bin/env python3
"""Check the represented pointed-Tutte filtration witness over F_7.

The two matrices have one distinguished first column and six helper columns.
The output records every dependent four-subset, the pointed subset-rank
profile, and the radius-three successful-set profile.  All arithmetic is
exact modulo seven.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from itertools import combinations
from pathlib import Path


MODULUS = 7
TARGET = 0
MATRICES = {
    "disjoint": (
        (1, 1, 1, 1, 0, 1, 1),
        (0, 3, 1, 4, 0, 6, 1),
        (0, 2, 3, 2, 1, 5, 0),
        (0, 1, 4, 1, 2, 4, 3),
    ),
    "overlapping": (
        (1, 1, 1, 1, 1, 1, 1),
        (0, 1, 2, 5, 4, 0, 6),
        (0, 4, 2, 0, 2, 1, 2),
        (0, 4, 1, 6, 4, 5, 4),
    ),
}


def column(matrix: tuple[tuple[int, ...], ...], index: int) -> tuple[int, ...]:
    return tuple(row[index] for row in matrix)


def rank(vectors: tuple[tuple[int, ...], ...]) -> int:
    rows = [list(vector) for vector in vectors]
    result = 0
    for coordinate in range(4):
        pivot = next(
            (
                row
                for row in range(result, len(rows))
                if rows[row][coordinate] % MODULUS
            ),
            None,
        )
        if pivot is None:
            continue
        rows[result], rows[pivot] = rows[pivot], rows[result]
        inverse = pow(rows[result][coordinate] % MODULUS, -1, MODULUS)
        for row in range(result + 1, len(rows)):
            multiplier = rows[row][coordinate] * inverse % MODULUS
            for entry in range(coordinate, 4):
                rows[row][entry] = (
                    rows[row][entry] - multiplier * rows[result][entry]
                ) % MODULUS
        result += 1
    return result


def subset_rank(matrix: tuple[tuple[int, ...], ...], subset: tuple[int, ...]) -> int:
    return rank(tuple(column(matrix, index) for index in subset))


def witness_record(
    matrix: tuple[tuple[int, ...], ...],
) -> dict[str, object]:
    ground = tuple(range(7))
    helpers = tuple(range(1, 7))
    total_rank = subset_rank(matrix, ground)
    dependent_triples = [
        list(subset)
        for subset in combinations(ground, 3)
        if subset_rank(matrix, subset) < 3
    ]
    dependent_quads = [
        list(subset)
        for subset in combinations(ground, 4)
        if subset_rank(matrix, subset) < 4
    ]

    pointed_profile: dict[tuple[int, int, int], int] = {}
    radius_three_profile = [0] * 7
    minimal_radius_three_repairs: list[list[int]] = []
    for size in range(7):
        for helper_subset in combinations(helpers, size):
            rank_helpers = subset_rank(matrix, helper_subset)
            with_target = tuple(sorted((TARGET,) + helper_subset))
            rank_with_target = subset_rank(matrix, with_target)
            exponent = (
                total_rank - rank_with_target,
                size - rank_helpers,
                rank_with_target - rank_helpers,
            )
            pointed_profile[exponent] = pointed_profile.get(exponent, 0) + 1
            succeeds_at_three = any(
                subset_rank(matrix, tuple(sorted((TARGET,) + repair)))
                == subset_rank(matrix, repair)
                for repair_size in range(min(3, size) + 1)
                for repair in combinations(helper_subset, repair_size)
            )
            if succeeds_at_three:
                radius_three_profile[size] += 1
            if size == 3 and succeeds_at_three:
                minimal_radius_three_repairs.append(list(helper_subset))

    return {
        "rank": total_rank,
        "dependent_triples": dependent_triples,
        "dependent_four_subsets": dependent_quads,
        "pointed_profile": [
            {"exponents": list(exponent), "count": count}
            for exponent, count in sorted(pointed_profile.items())
        ],
        "minimal_radius_three_repairs": minimal_radius_three_repairs,
        "radius_three_success_counts_by_survivor_size": radius_three_profile,
    }


def payload() -> dict[str, object]:
    records = {name: witness_record(matrix) for name, matrix in MATRICES.items()}
    assert records["disjoint"]["rank"] == 4
    assert records["overlapping"]["rank"] == 4
    assert records["disjoint"]["dependent_triples"] == []
    assert records["overlapping"]["dependent_triples"] == []
    assert (
        records["disjoint"]["pointed_profile"]
        == records["overlapping"]["pointed_profile"]
    )
    assert records["disjoint"]["radius_three_success_counts_by_survivor_size"] == [
        0,
        0,
        0,
        2,
        6,
        6,
        1,
    ]
    assert records["overlapping"][
        "radius_three_success_counts_by_survivor_size"
    ] == [0, 0, 0, 2, 6, 5, 1]
    return {
        "schema": "pointed-tutte-filtration-witness-v1",
        "field_order": MODULUS,
        "distinguished_column": TARGET,
        "matrices_are_rows": True,
        "records": records,
    }


def encoded_payload() -> bytes:
    return (json.dumps(payload(), indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    data = encoded_payload()
    if args.write is not None:
        args.write.write_bytes(data)
    if args.check is not None:
        tracked = args.check.read_bytes()
        if tracked != data:
            raise SystemExit(f"{args.check} is stale")
    if args.write is None and args.check is None:
        print(data.decode(), end="")
    print(
        json.dumps(
            {
                "bytes": len(data),
                "sha256": hashlib.sha256(data).hexdigest(),
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
