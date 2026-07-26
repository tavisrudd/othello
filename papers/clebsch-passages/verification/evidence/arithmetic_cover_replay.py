#!/usr/bin/env python3
"""Independent modular replay of the golden exchanger and spinor class."""

from __future__ import annotations

import json
from itertools import combinations
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "arithmetic_cover.json"
Q = 11


def normalize(point: tuple[int, ...]) -> tuple[int, ...]:
    first = next(value % Q for value in point if value % Q)
    inverse = pow(first, -1, Q)
    return tuple(inverse * value % Q for value in point)


def six_set(t: int) -> set[tuple[int, ...]]:
    return {
        normalize(point)
        for point in (
            (0, t, 1), (0, t, -1), (1, 0, t),
            (-1, 0, t), (t, -1, 0), (-t, -1, 0),
        )
    }


def determinant(points: tuple[tuple[int, ...], ...]) -> int:
    a, b, c = points
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - b[0] * (a[1] * c[2] - a[2] * c[1])
        + c[0] * (a[1] * b[2] - a[2] * b[1])
    ) % Q


def transform(point: tuple[int, ...]) -> tuple[int, ...]:
    x, y, z = point
    return normalize((x, -z, y))


def multiply(left: tuple[tuple[int, ...], ...],
             right: tuple[tuple[int, ...], ...]) -> tuple[tuple[int, ...], ...]:
    return tuple(
        tuple(sum(left[i][k] * right[k][j] for k in range(3)) % Q
              for j in range(3))
        for i in range(3)
    )


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    roots = [value for value in range(Q)
             if (value * value - value - 1) % Q == 0]
    assert roots == certificate["mod_11"]["roots"] == [4, 8]

    left, right = six_set(4), six_set(8)
    assert {transform(point) for point in left} == right
    assert {transform(point) for point in right} == left
    assert all(determinant(triple) for triple in combinations(left, 3))
    assert all(determinant(triple) for triple in combinations(right, 3))

    first_reflection = ((1, 0, 0), (0, -1, 0), (0, 0, 1))
    second_reflection = ((1, 0, 0), (0, 0, 1), (0, 1, 0))
    exchanger = ((1, 0, 0), (0, 0, -1), (0, 1, 0))
    assert multiply(first_reflection, second_reflection) == tuple(
        tuple(value % Q for value in row) for row in exchanger
    )
    squares = {value * value % Q for value in range(1, Q)}
    assert certificate["mod_11"]["reflection_norm_product"] not in squares
    assert certificate["field"]["nonzero_three_point_determinants"] == 20
    assert certificate["scope"]["not_checked"] == [
        "the global incidence degree and branch divisor",
        "the local normalization comparison",
        "the Clebsch-chart invariant identity",
    ]
    print("golden-fibre independent replay: PASS")


if __name__ == "__main__":
    main()
