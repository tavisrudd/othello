#!/usr/bin/env python3
"""Independent small-matrix replay for the C526 obstruction."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CERTIFICATE = ROOT / "notes/2026-07-23-c526-tate-pairing-rigid-target-bridge.json"
P = 11


def rank(matrix):
    rows = [row[:] for row in matrix]
    pivot_row = 0
    for column in range(len(rows[0])):
        pivot = next((i for i in range(pivot_row, len(rows)) if rows[i][column] % P), None)
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        scale = pow(rows[pivot_row][column], -1, P)
        rows[pivot_row] = [scale * value % P for value in rows[pivot_row]]
        for i in range(len(rows)):
            if i != pivot_row and rows[i][column]:
                multiple = rows[i][column]
                rows[i] = [
                    (left - multiple * right) % P
                    for left, right in zip(rows[i], rows[pivot_row])
                ]
        pivot_row += 1
    return pivot_row


def add_scaled(left, right, a, b):
    return [
        [(a * left[i][j] + b * right[i][j]) % P for j in range(2)]
        for i in range(2)
    ]


def bilinear(gram, left, right):
    return sum(left[i] * gram[i][j] * right[j] for i in range(2) for j in range(2)) % P


def matvec(matrix, vector):
    return [sum(a * b for a, b in zip(row, vector)) % P for row in matrix]


def main():
    data = json.loads(CERTIFICATE.read_text())
    mixed = data["source_pairing_inventory"]["mixed_polarization_records"]
    by_label = {record["label"]: record for record in mixed}
    first = by_label["Q1^3"]["tate_plane_gram_in_contraction_coordinates"]
    second = by_label["Q1*Q9^2"]["tate_plane_gram_in_contraction_coordinates"]
    assert rank(first) == rank(second) == 1
    assert by_label["Q1^2*Q9"]["rank"] == by_label["Q9^3"]["rank"] == 0

    source_flag = ([1, 9], [1, 3])
    perfect_projective_pairings = 0
    for alpha, beta in [(1, value) for value in range(P)] + [(0, 1)]:
        gram = add_scaled(first, second, alpha, beta)
        assert bilinear(gram, source_flag[0], source_flag[1]) == 0
        perfect_projective_pairings += rank(gram) == 2
    assert perfect_projective_pairings == 10
    reflection = [[9, 4], [2, 2]]
    assert matvec(reflection, matvec(reflection, [1, 0])) == [1, 0]
    assert matvec(reflection, matvec(reflection, [0, 1])) == [0, 1]
    assert matvec(reflection, source_flag[0]) == source_flag[0]
    assert matvec(reflection, source_flag[1]) == [(-value) % P for value in source_flag[1]]
    assert all(
        bilinear(gram, matvec(reflection, left), matvec(reflection, right))
        == bilinear(gram, left, right)
        for gram in (first, second)
        for left in ([1, 0], [0, 1])
        for right in ([1, 0], [0, 1])
    )

    target = data["target"]
    target_gram = target["depth_plane_gram"]
    target_inverse = [[7, 5], [5, 1]]
    target_flag = ([1, 10], [1, 9])
    assert bilinear(target_gram, target_flag[0], target_flag[1]) == 2
    assert bilinear(target_inverse, target_flag[0], target_flag[1]) == 5

    pure = data["source_pairing_inventory"]["pure_pencil_records"]
    assert sum(record["rank"] == 2 for record in pure) == 10
    assert all(
        record["type"] == "anisotropic"
        for record in pure
        if record["rank"] == 2
    )
    assert data["comparison"]["projective_isometry_exists"] is False
    print("C526 independent Tate-pairing obstruction replay OK")


if __name__ == "__main__":
    main()
