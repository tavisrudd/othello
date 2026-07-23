#!/usr/bin/env python3
"""Independent arithmetic replay for C439's compact interface claims."""

from __future__ import annotations

import json
from pathlib import Path

P = 11
CERT = Path(__file__).with_name("2026-07-20-c439-radical-hadamard-application-sweep.json")


def mul(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    return [[sum(x * y for x, y in zip(row, col)) % P for col in zip(*b)] for row in a]


def transpose(a: list[list[int]]) -> list[list[int]]:
    return [list(x) for x in zip(*a)]


def matrix_rank(a: list[list[int]]) -> int:
    a = [[x % P for x in row] for row in a]
    row = 0
    for col in range(len(a[0])):
        pivot = next((r for r in range(row, len(a)) if a[r][col]), None)
        if pivot is None:
            continue
        a[row], a[pivot] = a[pivot], a[row]
        inv = pow(a[row][col], P - 2, P)
        a[row] = [x * inv % P for x in a[row]]
        for r in range(len(a)):
            if r != row:
                a[r] = [(x - a[r][col] * y) % P for x, y in zip(a[r], a[row])]
        row += 1
    return row


def main() -> None:
    data = json.loads(CERT.read_text())
    f = [[10, 0, 4, 9], [0, 10, 2, 4], [2, 1, 1, 0], [10, 2, 0, 1]]
    h = [[3, 5, 5, 9], [8, 10, 2, 9], [0, 3, 8, 8], [8, 7, 5, 1]]
    g = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 2, 0], [0, 0, 0, 2]]
    ident = [[int(i == j) for j in range(4)] for i in range(4)]
    zero = [[0] * 4 for _ in range(4)]
    assert mul(f, f) == mul(h, h) == zero
    assert [[(x + y) % P for x, y in zip(a, b)] for a, b in zip(mul(f, h), mul(h, f))] == ident
    assert mul(transpose(f), g) == mul(g, f)
    assert matrix_rank(f) == matrix_rank(h) == 2

    metric = [[3, 7], [7, 10]]
    d, r = [1, 10], [1, 9]
    cross = sum(d[i] * metric[i][j] * r[j] for i in range(2) for j in range(2)) % P
    det = (metric[0][0] * metric[1][1] - metric[0][1] * metric[1][0]) % P
    inv = [[metric[1][1], -metric[0][1]], [-metric[1][0], metric[0][0]]]
    inv = [[x * pow(det, P - 2, P) % P for x in row] for row in inv]
    dual_cross = sum(d[i] * inv[i][j] * r[j] for i in range(2) for j in range(2)) % P
    assert [cross, dual_cross] == [2, 5]
    assert data["modular_target"]["target_flag_cross_pairings"] == {"vector": 2, "dual": 5}
    assert data["arithmetic_seam"]["smith_invariants"] == [1, 5]
    assert data["b3_fourier_gate"]["integral_defining_characteristic_block"] is False
    print("C439 independent replay OK")


if __name__ == "__main__":
    main()
