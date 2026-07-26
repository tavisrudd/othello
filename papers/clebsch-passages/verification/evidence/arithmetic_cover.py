#!/usr/bin/env python3
"""Exact certificate for the displayed golden fibre and its exchanger."""

from __future__ import annotations

import argparse
import json
from dataclasses import dataclass
from fractions import Fraction
from itertools import combinations
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "arithmetic_cover.json"
Q = 11


@dataclass(frozen=True)
class Golden:
    """Element a+b*t of Q[t]/(t^2-t-1)."""

    a: Fraction = Fraction(0)
    b: Fraction = Fraction(0)

    def __add__(self, other: object) -> Golden:
        value = coerce(other)
        return Golden(self.a + value.a, self.b + value.b)

    __radd__ = __add__

    def __neg__(self) -> Golden:
        return Golden(-self.a, -self.b)

    def __sub__(self, other: object) -> Golden:
        return self + (-coerce(other))

    def __rsub__(self, other: object) -> Golden:
        return coerce(other) - self

    def __mul__(self, other: object) -> Golden:
        value = coerce(other)
        return Golden(
            self.a * value.a + self.b * value.b,
            self.a * value.b + self.b * value.a + self.b * value.b,
        )

    __rmul__ = __mul__

    def conjugate(self) -> Golden:
        return Golden(self.a + self.b, -self.b)


def coerce(value: object) -> Golden:
    if isinstance(value, Golden):
        return value
    return Golden(Fraction(value))


ZERO = Golden()
ONE = Golden(Fraction(1))
T = Golden(Fraction(0), Fraction(1))


def dot(left: tuple[Golden, ...], right: tuple[Golden, ...]) -> Golden:
    return sum((a * b for a, b in zip(left, right)), ZERO)


def det(columns: tuple[tuple[Golden, ...], ...]) -> Golden:
    a, b, c = columns
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - b[0] * (a[1] * c[2] - a[2] * c[1])
        + c[0] * (a[1] * b[2] - a[2] * b[1])
    )


def golden_axes() -> tuple[tuple[Golden, Golden, Golden], ...]:
    return (
        (ZERO, T, ONE),
        (ZERO, T, -ONE),
        (ONE, ZERO, T),
        (-ONE, ZERO, T),
        (T, -ONE, ZERO),
        (-T, -ONE, ZERO),
    )


def mat_vec(matrix: tuple[tuple[int, ...], ...],
            vector: tuple[Golden, ...]) -> tuple[Golden, ...]:
    return tuple(
        sum((coerce(entry) * coordinate
             for entry, coordinate in zip(row, vector)), ZERO)
        for row in matrix
    )


def mat_mul(left: tuple[tuple[int, ...], ...],
            right: tuple[tuple[int, ...], ...]) -> tuple[tuple[int, ...], ...]:
    return tuple(
        tuple(sum(left[i][k] * right[k][j] for k in range(3))
              for j in range(3))
        for i in range(3)
    )


def proportional(left: tuple[Golden, ...], right: tuple[Golden, ...]) -> bool:
    return all(left[i] * right[j] == left[j] * right[i]
               for i in range(3) for j in range(i + 1, 3))


def projective_mod(vector: tuple[int, ...], modulus: int = Q) -> tuple[int, ...]:
    pivot = next(entry % modulus for entry in vector if entry % modulus)
    scale = pow(pivot, -1, modulus)
    return tuple(scale * entry % modulus for entry in vector)


def axes_mod(t: int) -> set[tuple[int, ...]]:
    return {
        projective_mod(vector)
        for vector in (
            (0, t, 1), (0, t, -1), (1, 0, t),
            (-1, 0, t), (t, -1, 0), (-t, -1, 0),
        )
    }


def image_mod(matrix: tuple[tuple[int, ...], ...],
              points: set[tuple[int, ...]]) -> set[tuple[int, ...]]:
    return {
        projective_mod(tuple(
            sum(matrix[i][j] * point[j] for j in range(3)) % Q
            for i in range(3)
        ))
        for point in points
    }


def build_certificate() -> dict[str, object]:
    points = golden_axes()
    norms = {dot(point, point) for point in points}
    assert norms == {T + 2}
    for left, right in combinations(points, 2):
        inner = dot(left, right)
        assert 5 * inner * inner == dot(left, left) * dot(right, right)
    determinants = [det(triple) for triple in combinations(points, 3)]
    assert all(value != ZERO for value in determinants)

    exchanger = ((1, 0, 0), (0, 0, -1), (0, 1, 0))
    conjugate_points = tuple(
        tuple(coordinate.conjugate() for coordinate in point)
        for point in points
    )
    images = tuple(mat_vec(exchanger, point) for point in points)
    assert all(any(proportional(image, target) for target in conjugate_points)
               for image in images)

    roots = [value for value in range(Q)
             if (value * value - value - 1) % Q == 0]
    assert roots == [4, 8]
    reduced_exchanger = tuple(tuple(entry % Q for entry in row)
                              for row in exchanger)
    assert image_mod(reduced_exchanger, axes_mod(4)) == axes_mod(8)
    assert image_mod(reduced_exchanger, axes_mod(8)) == axes_mod(4)

    # R=s_e2 s_(e2-e3); the two reflection norms have product 2.
    s_e2 = ((1, 0, 0), (0, -1, 0), (0, 0, 1))
    s_e2_minus_e3 = ((1, 0, 0), (0, 0, 1), (0, 1, 0))
    assert mat_mul(s_e2, s_e2_minus_e3) == exchanger
    squares = {value * value % Q for value in range(1, Q)}
    assert 2 not in squares

    return {
        "schema": "golden-fibre-v2",
        "field": {
            "polynomial": "t^2-t-1",
            "six_axes": len(points),
            "common_norm": "t+2",
            "normalized_squared_inner_product": "1/5",
            "nonzero_three_point_determinants": len(determinants),
        },
        "exchanger": {
            "matrix": exchanger,
            "maps_t_chart_to_conjugate_chart": True,
            "projective_order": 4,
            "linear_order": 4,
        },
        "mod_11": {
            "roots": roots,
            "maps_I4_to_I8": True,
            "maps_I8_to_I4": True,
            "reflection_norm_product": 2,
            "spinor_representative_is_nonsquare": True,
        },
        "scope": {
            "certificate_checks": [
                "the displayed golden six-sets and their exact metric data",
                "all twenty three-point determinants",
                "the exchanger on the two conjugate charts",
                "the reduction modulo 11 and nonsquare spinor representative",
            ],
            "not_checked": [
                "the global incidence degree and branch divisor",
                "the local normalization comparison",
                "the Clebsch-chart invariant identity",
            ],
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    if args.check:
        assert OUTPUT.read_text(encoding="utf-8") == rendered
        print("golden-fibre certificate: PASS")
    else:
        OUTPUT.write_text(rendered, encoding="utf-8")
        print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
