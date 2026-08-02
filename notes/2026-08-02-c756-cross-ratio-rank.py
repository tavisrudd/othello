#!/usr/bin/env python3
"""Exact rank audit for the C756 saturated-internal cross-ratio matrix."""

from __future__ import annotations

import argparse
from collections import Counter
from importlib.util import module_from_spec, spec_from_file_location
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "2026-08-02-c756-simultaneous-angle-moments.py"
OUTPUT = HERE / "2026-08-02-c756-cross-ratio-rank.json"
FIELDS = (5, 7, 11, 19, 23, 31, 43)

spec = spec_from_file_location("c756_angles", SOURCE)
angles = module_from_spec(spec)
spec.loader.exec_module(angles)


def neg(value, q):
    return (-value[0] % q, -value[1] % q)


def matrix_rank(matrix, field, q):
    """Gaussian rank over the pair model of F_(q^2)."""
    add, mul, fpow = field["add"], field["mul"], field["fpow"]
    work = [row[:] for row in matrix]
    rank = 0
    pivot_columns = []
    for column in range(len(work[0])):
        pivot = next(
            (row for row in range(rank, len(work))
             if work[row][column] != (0, 0)),
            None,
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = fpow(work[rank][column], q * q - 2)
        work[rank] = [mul(inverse, value) for value in work[rank]]
        for row in range(len(work)):
            if row == rank or work[row][column] == (0, 0):
                continue
            scale = neg(work[row][column], q)
            work[row] = [
                add(left, mul(scale, right))
                for left, right in zip(work[row], work[rank])
            ]
        pivot_columns.append(column)
        rank += 1
    return rank, pivot_columns, work


def verify_rank_certificate(matrix, field, q, rank, pivots, reduced):
    """Check a nonzero pivot minor and an explicit basis of the right kernel."""
    add, mul = field["add"], field["mul"]
    zero = (0, 0)
    assert len(pivots) == rank
    assert all(reduced[row][column] == (1, 0)
               for row, column in enumerate(pivots))
    free = [column for column in range(len(matrix)) if column not in pivots]
    kernel = []
    for free_column in free:
        vector = [zero for _ in matrix]
        vector[free_column] = (1, 0)
        for row, pivot_column in reversed(list(enumerate(pivots))):
            vector[pivot_column] = neg(reduced[row][free_column], q)
        assert all(
            sum_vector(
                [mul(entry, value) for entry, value in zip(row, vector)],
                field,
            ) == zero
            for row in matrix
        )
        kernel.append(vector)
    assert len(kernel) == len(matrix) - rank


def sum_vector(values, field):
    total = (0, 0)
    for value in values:
        total = field["add"](total, value)
    return total


def cross_ratio_matrix(candidate, field, q):
    return [
        [
            (0, 0) if i == j else angles.angle(field, q, candidate[i], candidate[j])
            for j in range(len(candidate))
        ]
        for i in range(len(candidate))
    ]


def verify_displacement_identity(candidate, matrix, field):
    """Verify (Y-L_X)(Y-L_Y)A=E and rank(E)<=3 entrywise."""
    sub, mul, conj = field["sub"], field["mul"], field["conj"]
    for i, ai in enumerate(candidate):
        bi = conj(ai)
        for j, aj in enumerate(candidate):
            bj = conj(aj)
            left = mul(mul(sub(bi, aj), sub(bi, bj)), matrix[i][j])
            right = mul(sub(ai, aj), sub(ai, bj))
            assert left == right


def field_row(q):
    candidates, field = angles.source.saturated_candidates(q)
    joint_profile = Counter()
    constant_kernel = 0
    for candidate in candidates:
        matrix = cross_ratio_matrix(candidate, field, q)
        verify_displacement_identity(candidate, matrix, field)
        rank, pivots, reduced = matrix_rank(matrix, field, q)
        verify_rank_certificate(matrix, field, q, rank, pivots, reduced)
        row_sums = [sum_vector(row, field) for row in matrix]
        zero_rows = sum(value == (0, 0) for value in row_sums)
        in_kernel = zero_rows == len(candidate)
        constant_kernel += in_kernel
        joint_profile[(rank, zero_rows)] += 1
    return {
        "q": q,
        "matrix_size": (q + 3) // 2,
        "candidate_count": len(candidates),
        "constant_vector_in_kernel": constant_kernel,
        "rank_zero_row_profile": [
            {"rank": rank, "zero_row_sums": zero_rows, "candidates": count}
            for (rank, zero_rows), count in sorted(joint_profile.items())
        ],
    }


def generate():
    return {
        "schema": "c756-cross-ratio-rank-v1",
        "scope": (
            "all normalized pairwise-resultant-character candidates in prime "
            "fields q in {5,7,11,19,23,31,43}"
        ),
        "identity": (
            "with X=diag(z_i), Y=diag(z_i^q), the double displacement "
            "(Y M-M X) followed by (Y M-M Y) sends the cross-ratio matrix "
            "to E_ij=(z_i-z_j)(z_i-z_j^q), a rank-at-most-three evaluation matrix"
        ),
        "inputs": [SOURCE.name],
        "rows": [field_row(q) for q in FIELDS],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write and --check")
    rendered = json.dumps(generate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT}")
    else:
        assert OUTPUT.read_text() == rendered
        print(f"verified {OUTPUT}")


if __name__ == "__main__":
    main()
