#!/usr/bin/env python3
"""Independent small-domain replay for the C729 cut-moment certificate."""

from __future__ import annotations

import itertools
import json
from collections import Counter
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CERTIFICATE = ROOT / "notes" / "2026-07-31-c729-cut-moments.json"

PALEY_C10 = (
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    (1, 0, 1, 1, 1, -1, -1, 1, -1, -1),
    (1, 1, 0, 1, -1, 1, -1, -1, 1, -1),
    (1, 1, 1, 0, -1, -1, 1, -1, -1, 1),
    (1, 1, -1, -1, 0, 1, 1, 1, -1, -1),
    (1, -1, 1, -1, 1, 0, 1, -1, 1, -1),
    (1, -1, -1, 1, 1, 1, 0, -1, -1, 1),
    (1, 1, -1, -1, 1, -1, -1, 0, 1, 1),
    (1, -1, 1, -1, -1, 1, -1, 1, 0, 1),
    (1, -1, -1, 1, -1, -1, 1, 1, 1, 0),
)


def parity(permutation: tuple[int, ...]) -> int:
    inversions = sum(
        permutation[i] > permutation[j]
        for i in range(len(permutation))
        for j in range(i + 1, len(permutation))
    )
    return -1 if inversions % 2 else 1


def determinant(matrix: tuple[tuple[int, ...], ...]) -> int:
    return sum(
        parity(permutation)
        * math_product(matrix[row][permutation[row]] for row in range(len(matrix)))
        for permutation in itertools.permutations(range(len(matrix)))
    )


def math_product(values: object) -> int:
    result = 1
    for value in values:
        result *= int(value)
    return result


def submatrix(rows: tuple[int, ...], columns: tuple[int, ...]) -> tuple[tuple[int, ...], ...]:
    return tuple(tuple(PALEY_C10[row][column] for column in columns) for row in rows)


def cut_vector(cut: tuple[int, ...]) -> tuple[int, ...]:
    support = set(cut)
    return tuple(1 if vertex in support else -1 for vertex in range(10))


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    cuts = tuple(cut for cut in itertools.combinations(range(10), 5) if 0 in cut)
    distribution: Counter[int] = Counter()
    extremal_vectors = []
    for cut in cuts:
        complement = tuple(vertex for vertex in range(10) if vertex not in cut)
        value = abs(determinant(submatrix(cut, complement)))
        distribution[value] += 1
        if value:
            extremal_vectors.append(cut_vector(cut))
    assert distribution == Counter({0: 90, 48: 36})
    assert certificate["projective_cut_determinant_distributions"]["10"] == {
        str(value): count for value, count in sorted(distribution.items())
    }

    inner_distributions = []
    for left in extremal_vectors:
        inner_distributions.append(
            Counter(
                abs(sum(a * b for a, b in zip(left, right)))
                for right in extremal_vectors
                if right != left
            )
        )
    assert all(counts == Counter({2: 30, 6: 5}) for counts in inner_distributions)
    moments = {}
    for degree in range(1, 9):
        if degree % 2:
            moments[str(degree)] = "0"
        else:
            moments[str(degree)] = str(
                Fraction(10**degree + 5 * 6**degree + 30 * 2**degree, 36 * 10**degree)
            )
    assert certificate["antipodal_spherical_moments"]["10_to_36"] == moments

    frame = [
        [sum(vector[i] * vector[j] for vector in extremal_vectors) for j in range(10)]
        for i in range(10)
    ]
    assert frame == [[36 if i == j else -4 for j in range(10)] for i in range(10)]
    print("OK independent Paley-C10 Leibniz replay: 126 cuts, 36 extremal lines, moments through degree 8")


if __name__ == "__main__":
    main()
