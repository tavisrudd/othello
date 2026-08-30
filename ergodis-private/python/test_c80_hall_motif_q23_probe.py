#!/usr/bin/env python3

from __future__ import annotations

import unittest

from c80_hall_motif_q23_probe import compile_suite


class C80HallMotifQ23ProbeTests(unittest.TestCase):
    def test_all_three_replacement_types_have_ancestral_edges(self) -> None:
        graphs, manifest = compile_suite()
        self.assertEqual([case["case"] for case in manifest["cases"]], ["type_i", "type_ii", "type_iii"])
        self.assertEqual(
            {name: (graph["left_count"], graph["right_count"], len(graph["neighbors"])) for name, graph in graphs.items()},
            {"type_i": (1, 34, 15), "type_ii": (1, 23, 10), "type_iii": (1, 26, 14)},
        )


if __name__ == "__main__":
    unittest.main()
