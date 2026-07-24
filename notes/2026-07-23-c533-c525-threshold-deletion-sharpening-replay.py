#!/usr/bin/env python3
"""Independent replay for the C533 compact certificate."""

from __future__ import annotations

import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
DATA = HERE / "2026-07-23-c533-c525-threshold-deletion-sharpening.json"


def rank_f2(rows: list[int]) -> int:
    pivots: dict[int, int] = {}
    for row in rows:
        while row:
            pivot = row.bit_length() - 1
            if pivot not in pivots:
                pivots[pivot] = row
                break
            row ^= pivots[pivot]
    return len(pivots)


def hasse_ok(q: int, deletion: int) -> bool:
    margin = q + 1 - deletion
    return margin > 0 and margin * margin > 4 * q


def first_q(base: int, deletion: int) -> int:
    q = 2
    while q < base or not hasse_ok(q, deletion):
        q <<= 1
    return q


def main() -> None:
    data = json.loads(DATA.read_text())
    assert data["schema"] == "c533-threshold-deletion-v1"

    # Coefficients in the ordered quartic basis s^4,s^3t,s^2t^2,st^3,t^4.
    restrictions = [0b10000, 0b01000, 0b00100, 0b00100, 0b00010, 0b00001]
    assert rank_f2(restrictions) == 5
    kernel_masks = []
    for mask in range(1, 1 << 6):
        total = 0
        for i, row in enumerate(restrictions):
            if mask & (1 << i):
                total ^= row
        if total == 0:
            kernel_masks.append(mask)
    assert kernel_masks == [0b001100]
    union = data["union_covariant"]
    assert union["quadratic_kernel"] == ["q2+q3"]
    assert union["minimum_nontrivial_common_degree_in_plucker_coordinates"] == 3
    assert union["sharp_degree_witness"]["degrees"] == [4, 2, 6]

    for row in data["threshold"]["representative_table"]:
        n = row["n"]
        m = n - 4
        before_base = min(m * (m + 15) // 2 + 1, 9 * m)
        after_base = min(m * (m + 11) // 2 + 1, 7 * m)
        assert row["before_base"] == before_base
        assert row["after_base"] == after_base
        assert row["before_first_binary_q"] == first_q(before_base, 3 * n - 4)
        assert row["after_first_binary_q"] == first_q(after_base, 3 * n - 6)
        assert row["after_base"] < row["before_base"]

    print("C533 replay OK: common-covariant rank, sharp degrees, and threshold table")


if __name__ == "__main__":
    main()
