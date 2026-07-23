#!/usr/bin/env python3
"""Independent small-matrix replay for C433."""

from __future__ import annotations

import json
import itertools
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


def matrix_product(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    return [
        [sum(a[i][k] * b[k][j] for k in range(len(b))) % P for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def rank_mod(a: list[list[int]]) -> int:
    out = [[x % P for x in row] for row in a]
    rank = 0
    for col in range(len(out[0])):
        pivot = next((i for i in range(rank, len(out)) if out[i][col]), None)
        if pivot is None:
            continue
        out[rank], out[pivot] = out[pivot], out[rank]
        inv = pow(out[rank][col], -1, P)
        out[rank] = [(inv * x) % P for x in out[rank]]
        for i in range(rank + 1, len(out)):
            if out[i][col]:
                scale = out[i][col]
                out[i] = [(x - scale * y) % P for x, y in zip(out[i], out[rank])]
        rank += 1
    return rank


fourier = CERT["divided_fourier_mod_11"]
depth = CERT["weighted_depth_matrix_mod_11"]
homotopy = CERT["canonical_placement"]["contracting_homotopy_mod_11"]
depth_projector = CERT["canonical_placement"]["depth_projector_h_Fbar"]
radical_projector = CERT["canonical_placement"]["fourier_radical_projector_Fbar_h"]
grading = CERT["canonical_placement"]["internal_grading_involution"]
commutant = CERT["canonical_placement"]["joint_commutant_basis"]
metric = CERT["canonical_placement"]["canonical_valency_metric_diagonal"]
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
    assert action(depth_projector, action(depth_projector, vector)) == action(depth_projector, vector)
    assert action(radical_projector, action(radical_projector, vector)) == action(radical_projector, vector)
    assert action(depth_projector, action(radical_projector, vector)) == (0, 0, 0, 0)
    assert action(radical_projector, action(depth_projector, vector)) == (0, 0, 0, 0)
    assert action(grading, action(grading, vector)) == vector
    assert tuple(
        (x + y) % P
        for x, y in zip(
            action(grading, action(fourier, vector)),
            action(fourier, action(grading, vector)),
        )
    ) == (0, 0, 0, 0)
assert len(commutant) == 4
assert rank_mod([[x for row in matrix for x in row] for matrix in commutant]) == 4
for matrix in commutant:
    assert matrix_product(matrix, fourier) == matrix_product(fourier, matrix)
    assert matrix_product(matrix, homotopy) == matrix_product(homotopy, matrix)
assert all(
    sum(fourier[k][i] * metric[k] * int(k == j) for k in range(4)) % P
    == sum(int(i == k) * metric[k] * fourier[k][j] for k in range(4)) % P
    for i in range(4)
    for j in range(4)
)
isometry_count = 0
for coefficients in itertools.product(range(P), repeat=4):
    matrix = [
        [
            sum(coefficients[t] * commutant[t][i][j] for t in range(4)) % P
            for j in range(4)
        ]
        for i in range(4)
    ]
    if all(
        sum(matrix[k][i] * metric[k] * matrix[k][j] for k in range(4)) % P
        == (metric[i] if i == j else 0)
        for i in range(4)
        for j in range(4)
    ):
        isometry_count += 1
assert isometry_count == 4
print("C433 independent replay OK")
