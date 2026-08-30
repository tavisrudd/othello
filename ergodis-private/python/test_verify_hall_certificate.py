#!/usr/bin/env python3

from __future__ import annotations

import unittest

from verify_hall_certificate import verify


class VerifyHallCertificateTests(unittest.TestCase):
    def test_matching_and_deficiency(self) -> None:
        graph = {
            "schema": "ergodis-hall-graph/v1",
            "left_count": 3,
            "right_count": 2,
            "offsets": [0, 1, 2, 3],
            "neighbors": [0, 0, 1],
        }
        verify(
            graph,
            {
                "schema": "ergodis-hall-certificate/v1",
                "certificate": {"outcome": "deficient", "left": [0, 1], "neighborhood": [0]},
            },
        )
        saturated = {**graph, "right_count": 3, "neighbors": [0, 1, 2]}
        verify(
            saturated,
            {
                "schema": "ergodis-hall-certificate/v1",
                "certificate": {"outcome": "saturated", "matching": [0, 1, 2]},
            },
        )

    def test_rejects_missing_matching_edge(self) -> None:
        with self.assertRaises(ValueError):
            verify(
                {
                    "schema": "ergodis-hall-graph/v1",
                    "left_count": 1,
                    "right_count": 2,
                    "offsets": [0, 1],
                    "neighbors": [0],
                },
                {
                    "schema": "ergodis-hall-certificate/v1",
                    "certificate": {"outcome": "saturated", "matching": [1]},
                },
            )


if __name__ == "__main__":
    unittest.main()
