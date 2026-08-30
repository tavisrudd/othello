#!/usr/bin/env python3
"""Unit checks for generic semantic-core lifting."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from c880_alignment_profile import profile
from c880_alignment_sat import TRIPLES
from semantic_core import dimacs_clauses, integer_ranges, locate_core
from semantic_slice import matches, parse_selector


class SemanticCoreTests(unittest.TestCase):
    def test_dimacs_and_duplicate_locations(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "tiny.cnf"
            path.write_text("p cnf 3 3\n1 -2 0\n3 0\n-2 1 0\n", encoding="ascii")
            clauses = dimacs_clauses(path)
        self.assertEqual(clauses, [(-2, 1), (3,), (-2, 1)])
        self.assertEqual(locate_core(clauses, [(-2, 1), (-2, 1)]), [0, 2])

    def test_ranges(self) -> None:
        self.assertEqual(integer_ranges([]), [])
        self.assertEqual(integer_ranges([1, 2, 3, 7, 9, 10]), [[1, 3], [7, 7], [9, 10]])

    def test_selectors(self) -> None:
        selector = parse_selector("kind=cut,side_size=3")
        self.assertEqual(selector, {"kind": "cut", "side_size": 3})
        self.assertTrue(matches({"kind": "cut", "side_size": 3, "cut": 7}, selector))
        self.assertFalse(matches({"kind": "cut", "side_size": 2}, selector))

    def test_pair_star_near_miss_has_only_two_six_failures(self) -> None:
        family = [len(set(triple) & {0, 1, 2}) >= 2 for triple in TRIPLES]
        summary = profile(family)
        self.assertEqual(summary["selected_count"], 16)
        self.assertEqual(summary["point_degree_histogram"], {"3": 5, "11": 3})
        self.assertEqual(summary["failed_cut_type_histogram"], {"2": 3})


if __name__ == "__main__":
    unittest.main()
