#!/usr/bin/env python3
"""Independent cut-Gram replay for the C814 continuous-frontier certificate."""

from __future__ import annotations


import itertools
import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CERTIFICATE = ROOT / "notes" / "2026-08-02-c814-continuous-frontier.json"
BASE_C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)


def determinant(matrix: list[list[int]]) -> int:
    if not matrix:
        return 1
    if len(matrix) == 1:
        return matrix[0][0]
    total = 0
    for column, value in enumerate(matrix[0]):
        minor = [row[:column] + row[column + 1 :] for row in matrix[1:]]
        total += (-1 if column % 2 else 1) * value * determinant(minor)
    return total


def cut_invariants(support: tuple[int, ...]) -> dict[str, Fraction]:
    chosen = set(support)
    other = tuple(i for i in range(6) if i not in chosen)
    cross = [[BASE_C[i][j] for j in other] for i in support]
    gram = [
        [sum(cross[i][k] * cross[j][k] for k in range(len(other))) for j in range(len(support))]
        for i in range(len(support))
    ]
    gram2 = [
        [sum(gram[i][k] * gram[k][j] for k in range(len(support))) for j in range(len(support))]
        for i in range(len(support))
    ]
    e1 = Fraction(sum(gram[i][i] for i in range(len(support))), 5)
    p2 = Fraction(sum(gram2[i][i] for i in range(len(support))), 25)
    e2 = (e1 * e1 - p2) / 2
    e3 = Fraction(determinant(gram), 125) if len(support) == 3 else Fraction(0)
    return {
        "p1": e1,
        "p2": p2,
        "exterior2": e2,
        "exterior3": e3,
        "symmetric3": e3 + e1 * p2,
        "mixed21": e1 * e2 - e3,
    }


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    profiles = {
        row["negative_support_size"]: {
            key: Fraction(value)
            for key, value in row.items()
            if key != "negative_support_size"
        }
        for row in certificate["boolean_profiles_up_to_complement"]
    }
    checked = 0
    for signs in itertools.product((-1, 1), repeat=6):
        support = tuple(i for i, value in enumerate(signs) if value < 0)
        if len(support) > 3:
            support = tuple(i for i in range(6) if i not in support)
        assert cut_invariants(support) == profiles[len(support)]
        checked += 1
    assert checked == certificate["boolean_vertex_count"] == 64
    print("C814 independent cut-Gram replay: PASS (64 Boolean controls)")


if __name__ == "__main__":
    main()
