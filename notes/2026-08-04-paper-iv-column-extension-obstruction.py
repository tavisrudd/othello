#!/usr/bin/env python3
"""Exact replay of the [91,15,28] -> [140,15,60] extension obstruction."""

from __future__ import annotations

import argparse
import importlib.util
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "notes/2026-08-04-c682-paper-iv-orbit-correspondence.json"
PROJECT_UP = ROOT / "notes/2026-08-04-paper-iv-project-up-optimality.py"
OUTPUT = ROOT / "notes/2026-08-04-paper-iv-column-extension-obstruction.json"

EXTRA_MESSAGES = [
    247, 290, 425, 469, 519, 652, 1029, 1538, 1673, 1781,
    1824, 1884, 2048, 2258, 3077, 3287, 3500, 3586, 3675, 3829,
]

# Rows are: total equality, aggregate slack cut, 78 minimum-word cuts,
# and the 20 cuts indexed by EXTRA_MESSAGES.
MULTIPLIERS = [
    -1279, -70,
    0, 0, 26, 50, 8, 36, 0, 55, 54, 18, 32, 5, 0, 12, 15, 55,
    38, 3, 15, 37, 33, 20, 0, 31, 2, 0, 5, 15, 37, 71, 0, 40, 0,
    24, 11, 32, 0, 1, 0, 0, 0, 7, 2, 43, 4, 12, 20, 15, 0, 32,
    37, 14, 40, 0, 9, 10, 6, 0, 4, 13, 6, 11, 26, 18, 24, 7, 12,
    0, 13, 0, 0, 20, 3, 4, 4, 0, 12, 0,
    87, 50, 77, 108, 111, 62, 50, 44, 33, 45, 35, 93, 32, 25, 39,
    36, 106, 79, 56, 38,
]


def load_code() -> tuple[list[int], list[int]]:
    data = json.loads(SOURCE.read_text())
    matrix = [sum(1 << j for j in row)
              for row in data["correspondence"]["left_neighbor_indices"]]
    spec = importlib.util.spec_from_file_location("project_up", PROJECT_UP)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    basis = list(module.kernel_basis(matrix)) + [(1 << 91) - 1]
    weights = []
    for message in range(1 << 15):
        word = 0
        for i, row in enumerate(basis):
            if (message >> i) & 1:
                word ^= row
        weights.append(word.bit_count())
    return basis, weights


def certificate() -> dict:
    basis, weights = load_code()
    minimum_messages = [u for u in range(1, 1 << 15) if weights[u] == 28]
    assert len(basis) == 15
    assert min(weights[1:]) == 28
    assert len(minimum_messages) == 78
    assert all(weights[u] == 36 for u in EXTRA_MESSAGES)

    coverage = [sum((a & u).bit_count() & 1 for u in minimum_messages)
                for a in range(1, 1 << 15)]
    assert max(coverage) == 52

    rhs = [49, 52] + [32] * 78 + [24] * 20
    assert len(MULTIPLIERS) == len(rhs) == 100
    assert MULTIPLIERS[1] <= 0
    assert all(y >= 0 for y in MULTIPLIERS[2:])

    combined = []
    for a in range(1, 1 << 15):
        coefficient = MULTIPLIERS[0]
        coefficient += MULTIPLIERS[1] * (52 - coverage[a - 1])
        for y, u in zip(MULTIPLIERS[2:80], minimum_messages):
            coefficient += y * ((a & u).bit_count() & 1)
        for y, u in zip(MULTIPLIERS[80:], EXTRA_MESSAGES):
            coefficient += y * ((a & u).bit_count() & 1)
        combined.append(coefficient)

    combined_rhs = sum(y * b for y, b in zip(MULTIPLIERS, rhs))
    assert max(combined) <= 0
    assert combined_rhs > 0

    return {
        "claim": "No nonnegative real appended-column multiplicities can extend the fixed [91,15,28] code to length 140 and distance at least 60.",
        "base_parameters": [91, 15, 28],
        "requested_extension": {"appended_columns": 49, "target_distance": 60},
        "variables": "x_a >= 0 for every nonzero a in F_2^15",
        "row_order": [
            "sum_a x_a = 49",
            "sum_a (52-coverage_on_78_minimum_messages(a))*x_a <= 52",
            "78 inequalities sum_{a dot u=1} x_a >= 32, u in ascending minimum-message order",
            "20 inequalities sum_{a dot u=1} x_a >= 24, u in extra_messages order",
        ],
        "minimum_messages": minimum_messages,
        "extra_messages": EXTRA_MESSAGES,
        "multipliers": MULTIPLIERS,
        "multiplier_signs": {
            "total_equality": "free",
            "aggregate_less_equal": "nonpositive",
            "lower_bound_rows": "nonnegative",
        },
        "combined_column_coefficient": {
            "maximum": max(combined),
            "minimum": min(combined),
            "zero_count": combined.count(0),
        },
        "combined_rhs": combined_rhs,
        "contradiction": "The signed sum gives (combined coefficients).x >= 1321, while every coefficient is <= 0 and x >= 0.",
        "trusted_boundary": "None: replay uses integer arithmetic after reconstructing the committed base code.",
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(certificate(), indent=2, sort_keys=True) + "\n"
    if args.check:
        assert OUTPUT.read_text() == rendered
        print("exact certificate and tracked JSON agree")
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
