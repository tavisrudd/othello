#!/usr/bin/env python3
"""Semantic extraction helpers for exact rank certificates.

The arithmetic stays in the domain adapter.  This module only asks for a rank
oracle and treats rows as labelled semantic blocks.
"""

from __future__ import annotations

import itertools
from collections.abc import Callable, Sequence
from typing import TypeVar


Row = TypeVar("Row")
Rank = Callable[[list[Row]], int]


def flatten(blocks: Sequence[Sequence[Row]], subset: Sequence[int]) -> list[Row]:
    return [row for block in subset for row in blocks[block]]


def minimum_full_rank_subsets(
    blocks: Sequence[Sequence[Row]], rank: Rank[Row], *, max_exact_blocks: int = 20
) -> tuple[int, list[list[int]]]:
    """Return the full rank and all smallest block subsets attaining it."""
    if len(blocks) > max_exact_blocks:
        raise ValueError(
            f"exact block-subset enumeration is capped at {max_exact_blocks}; "
            "coarsen the semantic groups or use an irredundant deletion core"
        )
    full_rank = rank(flatten(blocks, range(len(blocks))))
    for size in range(len(blocks) + 1):
        winners = [
            list(subset)
            for subset in itertools.combinations(range(len(blocks)), size)
            if rank(flatten(blocks, subset)) == full_rank
        ]
        if winners:
            return full_rank, winners
    raise AssertionError("the full block set failed to attain its own rank")


def greedy_independent_rows(rows: Sequence[Row], rank: Rank[Row]) -> list[int]:
    """Select a deterministic row basis using only the supplied rank oracle."""
    selected: list[Row] = []
    indices: list[int] = []
    current = 0
    for index, row in enumerate(rows):
        candidate = [*selected, row]
        new_rank = rank(candidate)
        if new_rank == current:
            continue
        if new_rank != current + 1:
            raise ValueError("rank oracle violated the one-row rank increment law")
        selected.append(row)
        indices.append(index)
        current = new_rank
    return indices


def block_marginals(
    blocks: Sequence[Sequence[Row]], rank: Rank[Row]
) -> list[dict[str, int]]:
    """Measure each block alone and its loss from the complete system."""
    complete = flatten(blocks, range(len(blocks)))
    full_rank = rank(complete)
    records = []
    for block in range(len(blocks)):
        without = flatten(blocks, [i for i in range(len(blocks)) if i != block])
        records.append(
            {
                "block": block,
                "rank_alone": rank(list(blocks[block])),
                "rank_loss_if_removed": full_rank - rank(without),
            }
        )
    return records
