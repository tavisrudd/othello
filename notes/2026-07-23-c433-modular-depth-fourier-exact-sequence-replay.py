#!/usr/bin/env python3
"""Independent small-matrix replay for C433."""

from __future__ import annotations

import json
from pathlib import Path

P = 11
HERE = Path(__file__).resolve().parent
CERT = json.loads(
    (HERE / "2026-07-23-c433-modular-depth-fourier-exact-sequence.json").read_text()
)


def span(vectors: list[list[int]]) -> set[tuple[int, ...]]:
    points = {(0,) * len(vectors[0])}
    for vector in vectors:
        points = {
            tuple((x + a * y) % P for x, y in zip(point, vector))
            for point in points
            for a in range(P)
        }
    return points


def action(matrix: list[list[int]], vector: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(sum(row[j] * vector[j] for j in range(len(vector))) % P for row in matrix)


fourier = CERT["divided_fourier_mod_11"]
depth = CERT["weighted_depth_matrix_mod_11"]
homotopy = CERT["canonical_placement"]["contracting_homotopy_mod_11"]
domain = [
    (a, b, c)
    for a in range(P)
    for b in range(P)
    for c in range(P)
]
depth_values = {
    tuple(sum(depth[i][j] * u[j] for j in range(3)) % P for i in range(4))
    for u in domain
}
kernel_depth = {
    u
    for u in domain
    if all(sum(depth[i][j] * u[j] for j in range(3)) % P == 0 for i in range(4))
}
ambient = [
    (a, b, c, d)
    for a in range(P)
    for b in range(P)
    for c in range(P)
    for d in range(P)
]
image_fourier = {action(fourier, v) for v in ambient}
kernel_fourier = {v for v in ambient if action(fourier, v) == (0, 0, 0, 0)}
image_composite = {action(fourier, v) for v in depth_values}

assert len(depth_values) == P**2
assert kernel_depth == {(a, a, a) for a in range(P)}
assert len(image_fourier) == P**2
assert image_fourier == kernel_fourier
assert depth_values.intersection(kernel_fourier) == {(0, 0, 0, 0)}
assert len(depth_values | kernel_fourier) == 2 * P**2 - 1
assert len(span(CERT["depth_image_basis"] + CERT["fourier_image_basis"])) == P**4
assert image_composite == image_fourier
for vector in ambient:
    assert action(homotopy, action(homotopy, vector)) == (0, 0, 0, 0)
    left = action(fourier, action(homotopy, vector))
    right = action(homotopy, action(fourier, vector))
    assert tuple((x + y) % P for x, y in zip(left, right)) == vector
print("C433 independent replay OK")
