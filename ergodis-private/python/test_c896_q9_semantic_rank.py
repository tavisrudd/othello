#!/usr/bin/env python3

from __future__ import annotations

import unittest

from c896_q9_semantic_rank import compute


class C896Q9SemanticRankTests(unittest.TestCase):
    def test_extra_catalecticant_channel_has_three_generator_cores(self) -> None:
        document = compute()
        records = {tuple(record["digits"]): record for record in document["sources"]}
        extra = records[(2, 0)]
        self.assertEqual((extra["variables"], extra["rank"], extra["hom_dimension"]), (30, 29, 1))
        self.assertEqual(extra["independent_equation_count"], 29)
        self.assertEqual(extra["minimum_generator_core_size"], 3)
        self.assertEqual(
            extra["minimum_generator_cores"],
            [
                ["u(1)", "u(a)", "weyl"],
                ["u(1)", "weyl", "torus"],
                ["u(a)", "weyl", "torus"],
            ],
        )
        losses = {
            record["generator"]: record["rank_loss_if_removed"]
            for record in extra["generator_marginals"]
        }
        self.assertEqual(losses, {"u(1)": 0, "u(a)": 0, "weyl": 1, "torus": 0})


if __name__ == "__main__":
    unittest.main()
