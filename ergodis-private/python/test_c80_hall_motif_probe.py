#!/usr/bin/env python3

from __future__ import annotations

import unittest

from c80_hall_motif_probe import compile_graph


class C80HallMotifProbeTests(unittest.TestCase):
    def test_ancestral_secant_graph_passes_first_witness(self) -> None:
        graph, manifest = compile_graph()
        self.assertEqual((graph["left_count"], graph["right_count"]), (2, 7))
        self.assertEqual(graph["offsets"], [0, 3, 5])
        self.assertEqual(graph["neighbors"], [2, 4, 6, 0, 2])
        self.assertEqual(len(manifest["edges"]), 5)


if __name__ == "__main__":
    unittest.main()
