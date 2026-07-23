#!/usr/bin/env python3
"""Centralizer-closure classification for the frozen C400 fusion controls."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter, deque
from fractions import Fraction
from pathlib import Path
from typing import Iterable


ROOT = Path(__file__).resolve().parent
SOURCE = ROOT / "2026-07-20-c400-a5-fourier-phases.json"
OUTPUT = ROOT / "2026-07-23-c432-fusion-closure-classification.json"
SOURCE_SHA256 = "96052bf03609b8136dbba3461ae8a4c5232b97935ca4b5d6920854eeae561811"

Block = tuple[int, ...]
Partition = tuple[Block, ...]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_partition(blocks: Iterable[Iterable[int]]) -> Partition:
    answer = [tuple(sorted(block)) for block in blocks]
    assert all(answer)
    return tuple(sorted(answer, key=lambda block: (0 not in block, block)))


def row_partition(matrix: list[list[int]], partition: Partition) -> Partition:
    signatures: dict[tuple[int, ...], list[int]] = {}
    for row in range(len(matrix)):
        signature = tuple(sum(matrix[row][column] for column in block) for block in partition)
        signatures.setdefault(signature, []).append(row)
    return canonical_partition(signatures.values())


def refines(finer: Partition, coarser: Partition) -> bool:
    return all(any(set(block) <= set(parent) for parent in coarser) for block in finer)


def fusion_closure(
    first: list[list[int]], second: list[list[int]], start: Partition
) -> tuple[Partition, Partition, int]:
    """Iterate pi -> R_Q(R_P(pi)); return its fixed point and dual partition."""
    current = start
    strict_rounds = 0
    while True:
        dual = row_partition(first, current)
        following = row_partition(second, dual)
        assert refines(following, current)
        if following == current:
            return current, dual, strict_rounds
        current = following
        strict_rounds += 1
        assert strict_rounds <= len(first)


def covers(partition: Partition) -> list[Partition]:
    """All one-block binary splits, i.e. covers in the refinement order."""
    answer: set[Partition] = set()
    for position, block in enumerate(partition):
        if len(block) < 2:
            continue
        first, rest = block[0], block[1:]
        for mask in range(1 << len(rest)):
            left = (first,) + tuple(rest[index] for index in range(len(rest)) if mask >> index & 1)
            right = tuple(value for value in block if value not in left)
            if not right:
                continue
            answer.add(
                canonical_partition(partition[:position] + partition[position + 1 :] + (left, right))
            )
    return sorted(answer)


def matrix_product(left: list[list[int]], right: list[list[int]]) -> list[list[int]]:
    return [
        [
            sum(left[row][index] * right[index][column] for index in range(len(right)))
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def verify_fused_adjacency_algebra(
    matrix: list[list[int]], order: int, partition: Partition
) -> None:
    """Independently verify ordinary-product closure of the fused adjacency basis."""
    rank = len(matrix)
    intersection = [[[Fraction(0) for _ in range(rank)] for _ in range(rank)] for _ in range(rank)]
    for left in range(rank):
        for right in range(rank):
            spectral_product = [matrix[row][left] * matrix[row][right] for row in range(rank)]
            coefficients = [
                Fraction(
                    sum(matrix[target][row] * spectral_product[row] for row in range(rank)),
                    order,
                )
                for target in range(rank)
            ]
            for target, coefficient in enumerate(coefficients):
                intersection[left][right][target] = coefficient

    assert all(value.denominator == 1 for plane in intersection for row in plane for value in row)
    for left_block in partition:
        for right_block in partition:
            coefficients = [
                sum(
                    intersection[left][right][target]
                    for left in left_block
                    for right in right_block
                )
                for target in range(rank)
            ]
            for target_block in partition:
                assert len({coefficients[target] for target in target_block}) == 1


def as_lists(partition: Partition) -> list[list[int]]:
    return [list(block) for block in partition]


def classify(field: dict[str, object]) -> dict[str, object]:
    q = int(field["q"])
    first = field["first_and_second_eigenmatrix"]
    assert isinstance(first, list)
    rank = len(first)
    order = q**3
    assert matrix_product(first, first) == [
        [order * int(row == column) for column in range(rank)] for row in range(rank)
    ]
    second = first

    bottom = canonical_partition(((0,), tuple(range(1, rank))))
    bottom_closed, _, _ = fusion_closure(first, second, bottom)
    assert bottom_closed == bottom

    discovered: set[Partition] = {bottom}
    pending: deque[Partition] = deque([bottom])
    probed: set[Partition] = set()
    records: list[dict[str, object]] = []
    strict_rounds: Counter[int] = Counter()
    closure_hits: Counter[Partition] = Counter()

    while pending:
        fixed = pending.popleft()
        for candidate in covers(fixed):
            if candidate in probed:
                continue
            probed.add(candidate)
            closed, dual, rounds = fusion_closure(first, second, candidate)
            strict_rounds[rounds] += 1
            records.append(
                {
                    "cover": as_lists(candidate),
                    "closure": as_lists(closed),
                    "dual": as_lists(dual),
                    "strict_rounds": rounds,
                }
            )
            closure_hits[closed] += 1
            if closed not in discovered:
                discovered.add(closed)
                pending.append(closed)

    fusions = sorted(discovered, key=lambda partition: (len(partition), partition))
    for partition in fusions:
        closed, dual, rounds = fusion_closure(first, second, partition)
        assert closed == partition and rounds == 0
        dual_closed, dual_dual, dual_rounds = fusion_closure(first, second, dual)
        assert dual_closed == dual and dual_dual == partition and dual_rounds == 0
        verify_fused_adjacency_algebra(first, order, partition)

    frozen = field["exhaustive_coherent_fusions_when_feasible"]
    if frozen is not None:
        assert isinstance(frozen, dict)
        frozen_partitions = {
            canonical_partition(item["relation_blocks"])
            for item in frozen["fusions"]
        }
        assert discovered == frozen_partitions
        bell_partitions = int(frozen["set_partitions_tested"])
        matches_frozen: bool | None = True
    else:
        bell_partitions = None
        matches_frozen = None

    canonical_records = json.dumps(
        sorted(records, key=lambda item: (len(item["cover"]), item["cover"])),
        separators=(",", ":"),
        sort_keys=True,
    ).encode()

    return {
        "q": q,
        "rank": rank,
        "group_order": order,
        "cover_probes": len(probed),
        "bell_partitions_in_c400": bell_partitions,
        "strict_closure_rounds_histogram": {
            str(key): strict_rounds[key] for key in sorted(strict_rounds)
        },
        "fusions": [
            {
                "rank": len(partition),
                "relation_blocks": as_lists(partition),
                "dual_blocks": as_lists(row_partition(first, partition)),
                "cover_hits": closure_hits[partition],
            }
            for partition in fusions
        ],
        "cover_closure_record_sha256": hashlib.sha256(canonical_records).hexdigest(),
        "ordinary_product_closure_verified": True,
        "matches_frozen_c400_exhaustion": matches_frozen,
    }


def generate() -> bytes:
    assert sha256(SOURCE) == SOURCE_SHA256
    source = json.loads(SOURCE.read_text())
    fields = [field for field in source["comparison_fields"] if field["q"] in (5, 9, 11, 19)]
    assert [field["q"] for field in fields] == [5, 9, 11, 19]
    certificate = {
        "schema": "c432-fusion-closure-v1",
        "source": {
            "path": SOURCE.name,
            "sha256": SOURCE_SHA256,
        },
        "criterion": "fixed points of pi -> R_Q(R_P(pi))",
        "classification": [classify(field) for field in fields],
    }
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--write", action="store_true")
    group.add_argument("--check", action="store_true")
    args = parser.parse_args()

    generated = generate()
    if args.write:
        OUTPUT.write_bytes(generated)
    else:
        assert OUTPUT.read_bytes() == generated
        print(
            json.dumps(
                {
                    "output": OUTPUT.name,
                    "sha256": hashlib.sha256(generated).hexdigest(),
                    "status": "ok",
                },
                sort_keys=True,
            )
        )


if __name__ == "__main__":
    main()
