#!/usr/bin/env python3
"""Exact characteristic-zero incidence certificate for C339's H3 complement code."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter, defaultdict
from dataclasses import dataclass
from fractions import Fraction
from itertools import combinations, product
from pathlib import Path


@dataclass(frozen=True, order=True)
class QT:
    """Element a+b*tau of Q(tau), with tau^2=tau+1."""

    a: Fraction
    b: Fraction = Fraction(0)

    def __add__(self, other: object) -> QT:
        rhs = coerce(other)
        return QT(self.a + rhs.a, self.b + rhs.b)

    __radd__ = __add__

    def __neg__(self) -> QT:
        return QT(-self.a, -self.b)

    def __sub__(self, other: object) -> QT:
        return self + (-coerce(other))

    def __rsub__(self, other: object) -> QT:
        return coerce(other) - self

    def __mul__(self, other: object) -> QT:
        rhs = coerce(other)
        return QT(
            self.a * rhs.a + self.b * rhs.b,
            self.a * rhs.b + self.b * rhs.a + self.b * rhs.b,
        )

    __rmul__ = __mul__

    def inverse(self) -> QT:
        # (a+b*tau)(a+b-b*tau)=a^2+ab-b^2.
        norm = self.a * self.a + self.a * self.b - self.b * self.b
        if norm == 0:
            raise ZeroDivisionError
        return QT((self.a + self.b) / norm, -self.b / norm)

    def __truediv__(self, other: object) -> QT:
        return self * coerce(other).inverse()

    def __bool__(self) -> bool:
        return bool(self.a or self.b)

    def as_pair(self) -> list[str]:
        return [str(self.a), str(self.b)]


def coerce(value: object) -> QT:
    if isinstance(value, QT):
        return value
    if isinstance(value, int):
        return QT(Fraction(value))
    if isinstance(value, Fraction):
        return QT(value)
    return NotImplemented  # type: ignore[return-value]


Vector = tuple[QT, QT, QT]
ZERO = QT(Fraction(0))
ONE = QT(Fraction(1))
TAU = QT(Fraction(0), Fraction(1))


def normalize(vector: Vector) -> Vector:
    pivot = next(value for value in vector if value)
    return tuple(value / pivot for value in vector)  # type: ignore[return-value]


def dot(left: Vector, right: Vector) -> QT:
    return sum((a * b for a, b in zip(left, right)), ZERO)


def cross(left: Vector, right: Vector) -> Vector:
    return normalize(
        (
            left[1] * right[2] - left[2] * right[1],
            left[2] * right[0] - left[0] * right[2],
            left[0] * right[1] - left[1] * right[0],
        )
    )


def h3_mirrors() -> set[Vector]:
    mirrors: set[Vector] = {
        (ONE, ZERO, ZERO),
        (ZERO, ONE, ZERO),
        (ZERO, ZERO, ONE),
    }
    for left_sign, right_sign in product((1, -1), repeat=2):
        root = (ONE, left_sign * TAU, right_sign * (TAU - 1))
        mirrors.update(
            {
                normalize(root),
                normalize((root[1], root[2], root[0])),
                normalize((root[2], root[0], root[1])),
            }
        )
    assert len(mirrors) == 15
    return mirrors


def polynomial(coefficients: tuple[int, int, int]) -> str:
    constant, linear, quadratic = coefficients
    pieces: list[str] = []
    if quadratic:
        pieces.append("q^2" if quadratic == 1 else f"{quadratic}q^2")
    if linear:
        sign = "+" if linear > 0 and pieces else ""
        pieces.append(f"{sign}{linear}q")
    if constant or not pieces:
        sign = "+" if constant > 0 and pieces else ""
        pieces.append(f"{sign}{constant}")
    return "".join(pieces)


def build_certificate() -> dict[str, object]:
    mirrors = h3_mirrors()
    intersections: dict[Vector, set[Vector]] = defaultdict(set)
    for left, right in combinations(sorted(mirrors), 2):
        point = cross(left, right)
        intersections[point].update({left, right})
    multiplicity = {
        point: sum(dot(line, point) == ZERO for line in mirrors)
        for point in intersections
    }
    assert Counter(multiplicity.values()) == Counter({2: 15, 3: 10, 5: 6})

    special_lines: dict[Vector, set[Vector]] = defaultdict(set)
    for left, right in combinations(sorted(intersections), 2):
        line = cross(left, right)
        if line not in mirrors:
            special_lines[line].update({left, right})
    for line in special_lines:
        special_lines[line] = {
            point for point in intersections if dot(line, point) == ZERO
        }

    line_records = []
    special_by_delta: Counter[int] = Counter()
    special_incidence_at_point: Counter[Vector] = Counter()
    for line, points in sorted(special_lines.items()):
        signature = tuple(sorted((multiplicity[point] for point in points), reverse=True))
        delta = sum(value - 1 for value in signature)
        special_by_delta[delta] += 1
        special_incidence_at_point.update(points)
        line_records.append(
            {
                "line": [entry.as_pair() for entry in line],
                "multiplicity_signature": list(signature),
                "delta": delta,
            }
        )

    special_pencils = Counter(
        (multiplicity[point], special_incidence_at_point[point])
        for point in intersections
    )

    # Counts are coefficient triples constant + linear*q + quadratic*q^2.
    counts: dict[int, tuple[int, int, int]] = dict(special_by_delta)
    counts = {delta: (count, 0, 0) for delta, count in special_by_delta.items()}
    ordinary_total = (0, 0, 0)
    for (multiplicity_value, special_count), point_count in special_pencils.items():
        delta = multiplicity_value - 1
        # At the point: q+1 total lines, m mirrors, and special_count other special lines.
        per_point = (1 - multiplicity_value - special_count, 1, 0)
        addition = tuple(point_count * value for value in per_point)
        old = counts.get(delta, (0, 0, 0))
        counts[delta] = tuple(a + b for a, b in zip(old, addition))
        ordinary_total = tuple(a + b for a, b in zip(ordinary_total, addition))

    # All remaining projective lines contain no singular arrangement point.
    used_nonzero = (15 + len(special_lines) + ordinary_total[0], ordinary_total[1], 0)
    counts[0] = (-used_nonzero[0] + 1, -used_nonzero[1] + 1, 1)

    expected = {
        0: (209, -30, 1),
        1: (-165, 15, 0),
        2: (-110, 10, 0),
        3: (40, 0, 0),
        4: (-54, 6, 0),
        5: (66, 0, 0),
    }
    assert counts == expected
    # There are 15 mirrors in addition to these nonmirror lines.
    assert tuple(
        sum(counts[delta][index] for delta in counts) + ((15, 0, 0)[index])
        for index in range(3)
    ) == (1, 1, 1)

    return {
        "schema": "c339-h3-line-spectrum-v1",
        "base_field": "Q(tau), tau^2=tau+1",
        "mirror_count": len(mirrors),
        "singular_multiplicities": {
            str(key): value for key, value in sorted(Counter(multiplicity.values()).items())
        },
        "special_nonmirror_line_count": len(special_lines),
        "special_nonmirror_delta_counts": {
            str(key): value for key, value in sorted(special_by_delta.items())
        },
        "singular_point_pencils": [
            {
                "arrangement_multiplicity": key[0],
                "special_nonmirror_lines_through_point": key[1],
                "point_count": value,
            }
            for key, value in sorted(special_pencils.items())
        ],
        "all_nonmirror_line_delta_counts": {
            str(delta): polynomial(coefficients)
            for delta, coefficients in sorted(counts.items())
        },
        "intersection_sizes": {
            str(delta): f"q-{14 - delta}" for delta in sorted(counts)
        },
        "special_lines": line_records,
    }


def canonical_json(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    output = Path(__file__).with_suffix(".json")
    rendered = canonical_json(build_certificate())
    if args.check:
        assert output.read_bytes() == rendered
    else:
        output.write_bytes(rendered)
    print(f"sha256={hashlib.sha256(rendered).hexdigest()} bytes={len(rendered)}")
    print("C339_H3_LINE_SPECTRUM_PASS")


if __name__ == "__main__":
    main()
