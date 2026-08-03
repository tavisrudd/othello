#!/usr/bin/env python3
"""Exact classification of the root-normalized signings on six labels.

A root-normalized signing is the symmetric zero-diagonal integer matrix on the
labels ``0..5`` whose first row and column are all ``1`` and whose remaining
ten off-diagonal entries carry signs indexed by the edges

    12, 13, 14, 15, 23, 24, 25, 34, 35, 45

in that order, bit ``k`` set meaning the edge sign ``-1``.  For each of the
``2**10`` signings this program checks the five root balances

    sum_k C[0][i] * C[i][k] * C[k][0] = 0   for i = 1..5,

and for every balanced signing reports the coefficient of ``x0*x1*x2`` in the
signed perfect-matching evaluation of the commutator bracket matrix, the
triangle sign on ``0,1,2``, and the exact rational proportionality constant
between the matching evaluation and the triangle cubic.

The proportionality constant is determined from a single evaluation point and
then verified at further points; all arithmetic is exact integer arithmetic.

Replay:

    python3 notes/2026-08-02-c815-normalized-signing-classification.py
"""

from __future__ import annotations

import itertools
import json

EDGE_BIT = {
    (1, 2): 0, (1, 3): 1, (1, 4): 2, (1, 5): 3, (2, 3): 4,
    (2, 4): 5, (2, 5): 6, (3, 4): 7, (3, 5): 8, (4, 5): 9,
}

# The fifteen perfect matchings of six labels with their Pfaffian signs, in the
# order used by the signed matching evaluation.
MATCHINGS = [
    (1, (0, 1), (2, 3), (4, 5)), (-1, (0, 1), (2, 4), (3, 5)),
    (1, (0, 1), (2, 5), (3, 4)), (-1, (0, 2), (1, 3), (4, 5)),
    (1, (0, 2), (1, 4), (3, 5)), (-1, (0, 2), (1, 5), (3, 4)),
    (1, (0, 3), (1, 2), (4, 5)), (-1, (0, 3), (1, 4), (2, 5)),
    (1, (0, 3), (1, 5), (2, 4)), (-1, (0, 4), (1, 2), (3, 5)),
    (1, (0, 4), (1, 3), (2, 5)), (-1, (0, 4), (1, 5), (2, 3)),
    (1, (0, 5), (1, 2), (3, 4)), (-1, (0, 5), (1, 3), (2, 4)),
    (1, (0, 5), (1, 4), (2, 3)),
]

EVALUATION_POINTS = [
    (3, -5, 7, 2, -1, 4), (1, 2, 3, 4, 5, 6), (-2, 5, -7, 11, 1, -3),
    (9, -1, 2, -8, 4, 5),
]


def signing(code: int) -> list[list[int]]:
    """The root-normalized matrix of the given ten-bit edge code."""
    matrix = [[0] * 6 for _ in range(6)]
    for label in range(1, 6):
        matrix[0][label] = matrix[label][0] = 1
    for (i, j), bit in EDGE_BIT.items():
        sign = -1 if (code >> bit) & 1 else 1
        matrix[i][j] = matrix[j][i] = sign
    return matrix


def triangle_sign(matrix, i, j, k):
    return matrix[i][j] * matrix[j][k] * matrix[k][i]


def pair_triangle_sum(matrix, i, j):
    return sum(triangle_sign(matrix, i, j, k) for k in range(6))


def matching_evaluation(matrix, x):
    return sum(
        sign * matrix[a][b] * matrix[c][d] * matrix[e][f]
        * (x[a] - x[b]) * (x[c] - x[d]) * (x[e] - x[f])
        for sign, (a, b), (c, d), (e, f) in MATCHINGS
    )


def triangle_cubic(matrix, x):
    return sum(
        triangle_sign(matrix, i, j, k) * x[i] * x[j] * x[k]
        for i, j, k in itertools.combinations(range(6), 3)
    )


def coefficient_012(matrix):
    """The coefficient of x0*x1*x2 in the matching evaluation."""
    total = 0
    for a, b, c in itertools.product((0, 1), repeat=3):
        total += (-1) ** (3 - a - b - c) * matching_evaluation(
            matrix, (a, b, c, 0, 0, 0))
    return total


def proportionality(matrix):
    """The exact scalar mu with matching evaluation = mu * triangle cubic."""
    scalars = set()
    for x in EVALUATION_POINTS:
        cubic = triangle_cubic(matrix, x)
        if cubic == 0:
            continue
        evaluation = matching_evaluation(matrix, x)
        if evaluation % cubic:
            return None
        scalars.add(evaluation // cubic)
    return scalars.pop() if len(scalars) == 1 else None


def main() -> None:
    positive, negative, unclassified = [], [], []
    for code in range(1 << 10):
        matrix = signing(code)
        if any(pair_triangle_sum(matrix, 0, i) for i in range(1, 6)):
            continue
        oriented = triangle_sign(matrix, 0, 1, 2)
        coefficient = coefficient_012(matrix)
        scalar = proportionality(matrix)
        entry = {"code": code, "scalar": scalar,
                 "bits": [bool((code >> k) & 1) for k in range(10)]}
        if coefficient == 4 * oriented and scalar == 4:
            positive.append(entry)
        elif coefficient == -4 * oriented and scalar == -4:
            negative.append(entry)
        else:
            unclassified.append(entry)
    print(json.dumps({
        "balanced_signings": len(positive) + len(negative) + len(unclassified),
        "positive_orientation": positive,
        "negative_orientation": negative,
        "unclassified": unclassified,
    }, indent=2))


if __name__ == "__main__":
    main()
