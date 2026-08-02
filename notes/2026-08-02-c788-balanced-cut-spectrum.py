#!/usr/bin/env python3
"""Exact falsifier for the C788 balanced-cut exchange-spectrum theorem.

The script uses only Python's standard library.  It constructs the symmetric
Paley conference matrices of orders 6 and 14 and the universal order-10
conference matrix, enumerates balanced cuts modulo complement, and records the
exact characteristic polynomial of each cross-block Gram matrix.
"""

from __future__ import annotations

import argparse
import json
from collections import Counter
from fractions import Fraction
from itertools import combinations
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-08-02-c788-balanced-cut-spectrum.json"


def transpose(a: list[list[int]]) -> list[list[int]]:
    return [list(column) for column in zip(*a)]


def matmul(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    return [
        [sum(a[i][k] * b[k][j] for k in range(len(b))) for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def add(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    return [[x + y for x, y in zip(row_a, row_b)] for row_a, row_b in zip(a, b)]


def identity(n: int, scale: int = 1) -> list[list[int]]:
    return [[scale * int(i == j) for j in range(n)] for i in range(n)]


def paley_conference(q: int) -> list[list[int]]:
    def character(x: int) -> int:
        x %= q
        if x == 0:
            return 0
        return 1 if pow(x, (q - 1) // 2, q) == 1 else -1

    return [
        [
            0
            if i == j
            else 1
            if i == 0 or j == 0
            else character((i - 1) - (j - 1))
            for j in range(q + 1)
        ]
        for i in range(q + 1)
    ]


def universal_order_ten() -> list[list[int]]:
    columns = []
    for tail in combinations(range(1, 6), 2):
        half = {0, *tail}
        columns.append([1 if i in half else -1 for i in range(6)])
    gram = matmul(columns, transpose(columns))
    return [
        [(gram[i][j] - 6 * int(i == j)) // 2 for j in range(10)]
        for i in range(10)
    ]


def balanced_halves(n: int) -> list[tuple[int, ...]]:
    d = n // 2
    return [(0, *tail) for tail in combinations(range(1, n), d - 1)]


def principal(matrix: list[list[int]], indices: tuple[int, ...]) -> list[list[int]]:
    return [[matrix[i][j] for j in indices] for i in indices]


def cross_block(matrix: list[list[int]], left: tuple[int, ...]) -> list[list[int]]:
    right = tuple(i for i in range(len(matrix)) if i not in set(left))
    return [[matrix[i][j] for j in right] for i in left]


def characteristic_polynomial(matrix: list[list[int]]) -> tuple[int, ...]:
    """Return det(t I - matrix), from exact Newton identities."""
    n = len(matrix)
    powers = identity(n)
    power_sums = []
    for _ in range(n):
        powers = matmul(powers, matrix)
        power_sums.append(sum(powers[i][i] for i in range(n)))
    elementary = [1]
    for k in range(1, n + 1):
        numerator = sum(
            (-1) ** (i - 1) * elementary[k - i] * power_sums[i - 1]
            for i in range(1, k + 1)
        )
        assert numerator % k == 0
        elementary.append(numerator // k)
    return tuple([1] + [(-1) ** k * elementary[k] for k in range(1, n + 1)])


def four_cycle_sum(matrix: list[list[int]], vertices: tuple[int, ...]) -> int:
    a, b, c, d = vertices
    return (
        matrix[a][b] * matrix[b][c] * matrix[c][d] * matrix[d][a]
        + matrix[a][b] * matrix[b][d] * matrix[d][c] * matrix[c][a]
        + matrix[a][c] * matrix[c][b] * matrix[b][d] * matrix[d][a]
    )


def fraction_record(value: Fraction) -> dict[str, int]:
    return {"numerator": value.numerator, "denominator": value.denominator}


def audit(matrix: list[list[int]]) -> dict[str, object]:
    n = len(matrix)
    d = n // 2
    q = n - 1
    assert matrix == transpose(matrix)
    assert matmul(matrix, matrix) == identity(n, q)

    gram_profiles: Counter[tuple[int, ...]] = Counter()
    trace4_profiles: Counter[int] = Counter()
    aligned_four_set_profiles: Counter[int] = Counter()
    aligned_counts = []
    aligned_blocks = {
        vertices
        for vertices in combinations(range(n), 4)
        if four_cycle_sum(matrix, vertices) == 3
    }
    if n >= 6:
        triple_degrees = Counter(
            triple
            for block in aligned_blocks
            for triple in combinations(block, 3)
        )
        design_lambda = (n - 6) // 4
        assert all(
            triple_degrees[triple] == design_lambda
            for triple in combinations(range(n), 3)
        )
        assert len(aligned_blocks) == n * (n - 1) * (n - 2) * (n - 6) // 96
    else:
        design_lambda = 0
    for left in balanced_halves(n):
        a = principal(matrix, left)
        r = cross_block(matrix, left)
        rr = matmul(r, transpose(r))
        aa = matmul(a, a)
        assert rr == add(identity(d, q), [[-x for x in row] for row in aa])

        gram_profiles[characteristic_polynomial(rr)] += 1
        a4 = matmul(aa, aa)
        trace4 = sum(a4[i][i] for i in range(d))
        cycle_sums = [four_cycle_sum(a, vertices) for vertices in combinations(range(d), 4)]
        assert all(value in (-1, 3) for value in cycle_sums)
        aligned_four_sets = sum(value == 3 for value in cycle_sums)
        right = tuple(i for i in range(n) if i not in set(left))
        assert aligned_four_sets == sum(
            four_cycle_sum(matrix, vertices) == 3
            for vertices in combinations(right, 4)
        )
        aligned_counts.append(aligned_four_sets)
        aligned_four_set_profiles[aligned_four_sets] += 1
        cycle_formula = d * (d - 1) + 12 * len(list(combinations(range(d), 3)))
        cycle_formula += 8 * sum(cycle_sums)
        assert trace4 == cycle_formula
        assert trace4 == (
            d * (d - 1)
            + 12 * len(list(combinations(range(d), 3)))
            - 8 * len(list(combinations(range(d), 4)))
            + 32 * aligned_four_sets
        )
        trace4_profiles[trace4] += 1

    cut_count = len(aligned_counts)
    aligned_mean = Fraction(sum(aligned_counts), cut_count)
    aligned_variance = sum(
        (Fraction(value) - aligned_mean) ** 2 for value in aligned_counts
    ) / cut_count
    if d >= 4:
        density = Fraction(d - 3, 2 * (2 * d - 3))
        theoretical_mean = density * comb(d, 4)
        theoretical_variance = (
            Fraction(comb(2 * d, 4) * comb(2 * d - 8, d - 4), comb(2 * d, d))
            * density
            * (1 - density)
        )
    else:
        density = Fraction(0)
        theoretical_mean = Fraction(0)
        theoretical_variance = Fraction(0)
    assert aligned_mean == theoretical_mean
    assert aligned_variance == theoretical_variance

    return {
        "order": n,
        "balanced_projective_cuts": len(balanced_halves(n)),
        "aligned_four_set_design": {
            "blocks": len(aligned_blocks),
            "lambda_3": design_lambda,
            "parameters": f"3-({n},4,{design_lambda})",
        },
        "aligned_four_set_cut_moments": {
            "density": fraction_record(density),
            "mean": fraction_record(aligned_mean),
            "variance": fraction_record(aligned_variance),
        },
        "cross_gram_characteristic_polynomials": [
            {"coefficients": list(coefficients), "multiplicity": multiplicity}
            for coefficients, multiplicity in sorted(gram_profiles.items())
        ],
        "principal_fourth_trace_distribution": [
            {"trace": trace, "multiplicity": multiplicity}
            for trace, multiplicity in sorted(trace4_profiles.items())
        ],
        "aligned_four_set_count_distribution": [
            {"count": count, "multiplicity": multiplicity}
            for count, multiplicity in sorted(aligned_four_set_profiles.items())
        ],
    }


def generate() -> dict[str, object]:
    return {
        "schema": "c788-balanced-cut-spectrum-v2",
        "normalization": "polynomial is det(t I - R R^T); cuts contain vertex 0",
        "orders": [
            audit(paley_conference(5)),
            audit(universal_order_ten()),
            audit(paley_conference(13)),
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = generate()
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.write:
        CERTIFICATE.write_text(encoded)
    elif args.check:
        assert CERTIFICATE.read_text() == encoded
        print("C788 certificate check: OK")
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
