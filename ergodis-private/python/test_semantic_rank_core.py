#!/usr/bin/env python3

from __future__ import annotations

import unittest

from semantic_rank_core import (
    block_marginals,
    greedy_independent_rows,
    minimum_full_rank_subsets,
)


def binary_rank(rows: list[int]) -> int:
    pivots: dict[int, int] = {}
    for original in rows:
        row = original
        while row:
            pivot = row.bit_length() - 1
            if pivot not in pivots:
                pivots[pivot] = row
                break
            row ^= pivots[pivot]
    return len(pivots)


class SemanticRankCoreTests(unittest.TestCase):
    def test_minimum_blocks_and_marginals(self) -> None:
        blocks = [[0b001, 0b010], [0b011], [0b100]]
        rank, cores = minimum_full_rank_subsets(blocks, binary_rank)
        self.assertEqual(rank, 3)
        self.assertEqual(cores, [[0, 2]])
        self.assertEqual(
            [record["rank_loss_if_removed"] for record in block_marginals(blocks, binary_rank)],
            [1, 0, 1],
        )

    def test_greedy_row_basis(self) -> None:
        self.assertEqual(
            greedy_independent_rows([0b001, 0b011, 0b010, 0b100], binary_rank),
            [0, 1, 3],
        )

    def test_exact_subset_guard(self) -> None:
        with self.assertRaises(ValueError):
            minimum_full_rank_subsets([[1], [2], [4]], binary_rank, max_exact_blocks=2)


if __name__ == "__main__":
    unittest.main()
