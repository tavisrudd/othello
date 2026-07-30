#!/usr/bin/env python3
"""Independent direct replay of the C691 triangle-product identity."""

from __future__ import annotations

import argparse
import json
from itertools import combinations
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CERTIFICATE = ROOT / "notes" / "2026-07-29-c691-cubic-golden-two-graph.json"
C690 = ROOT / "notes" / "2026-07-29-c690-rigidity-fingerprints.json"
C682 = ROOT / "notes" / "2026-07-26-c682-transvectant-bridge.json"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("certificate", nargs="?", type=Path, default=CERTIFICATE)
    args = parser.parse_args()
    data = json.loads(args.certificate.read_text())
    if data["schema"] != "c691-cubic-golden-two-graph-v1":
        raise AssertionError("unexpected schema")
    c690 = json.loads(C690.read_text())
    c682 = json.loads(C682.read_text())
    comparison = c690["twelve_point_kill_test"]["paper_I"][
        "direct_c682_axis_lattice_comparison"
    ]
    matrix = comparison["continuation_signed_operator"]
    permutation = comparison["permutation_zero_based"]
    expected = {
        tuple(record["support"]): record["coefficient"]
        for record in c682["icosahedral_marking"]["support_orientation_cubic_terms"]
    }
    actual = {}
    for triple in combinations(range(6), 3):
        transported = tuple(sorted(permutation[i] for i in triple))
        actual[transported] = (
            matrix[triple[0]][triple[1]]
            * matrix[triple[1]][triple[2]]
            * matrix[triple[2]][triple[0]]
        )
    if actual != expected:
        raise AssertionError("triangle-product identity failed")

    gauge = [[0] * 6 for _ in range(6)]
    for i in range(1, 6):
        gauge[0][i] = gauge[i][0] = 1
    for i, j in combinations(range(1, 6), 2):
        gauge[i][j] = gauge[j][i] = (
            matrix[0][i] * matrix[i][j] * matrix[j][0]
        )
    for triple in combinations(range(6), 3):
        product = (
            gauge[triple[0]][triple[1]]
            * gauge[triple[1]][triple[2]]
            * gauge[triple[2]][triple[0]]
        )
        source = tuple(sorted(permutation[i] for i in triple))
        if product != expected[source]:
            raise AssertionError("inverse gauge reconstruction failed")
    if gauge != data["inverse_reconstruction"]["gauge_matrix"]:
        raise AssertionError("stored gauge matrix mismatch")
    print(
        json.dumps(
            {
                "triangle_coefficients_checked": len(actual),
                "forward_identity": True,
                "inverse_gauge_identity": True,
                "orbital_negation_degree": 3,
            },
            sort_keys=True,
            separators=(",", ":"),
        )
    )


if __name__ == "__main__":
    main()
