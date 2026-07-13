#!/usr/bin/env python3
from __future__ import annotations

from dataclasses import dataclass
from itertools import combinations, product
from math import comb
from typing import Iterable

Point = tuple[int, int, int]


@dataclass(frozen=True)
class Field:
    q: int
    p: int
    degree: int
    modulus: int | None = None

    @classmethod
    def for_order(cls, q: int) -> "Field":
        if q == 8:
            return cls(q=8, p=2, degree=3, modulus=0b1011)
        if q == 9:
            return cls(q=9, p=3, degree=2)
        if q == 11:
            return cls(q=11, p=11, degree=1)
        if q == 16:
            return cls(q=16, p=2, degree=4, modulus=0b10011)
        raise ValueError(f"unsupported field order: {q}")

    def add(self, a: int, b: int) -> int:
        if self.degree == 1:
            return (a + b) % self.p
        if self.p == 2:
            return a ^ b
        a0, a1 = a % 3, a // 3
        b0, b1 = b % 3, b // 3
        return (a0 + b0) % 3 + 3 * ((a1 + b1) % 3)

    def neg(self, a: int) -> int:
        if self.degree == 1:
            return (-a) % self.p
        if self.p == 2:
            return a
        a0, a1 = a % 3, a // 3
        return (-a0) % 3 + 3 * ((-a1) % 3)

    def sub(self, a: int, b: int) -> int:
        return self.add(a, self.neg(b))

    def mul(self, a: int, b: int) -> int:
        if self.degree == 1:
            return (a * b) % self.p
        if self.p == 2:
            assert self.modulus is not None
            x, y, result = a, b, 0
            while y:
                if y & 1:
                    result ^= x
                y >>= 1
                x <<= 1
                if x & (1 << self.degree):
                    x ^= self.modulus
            return result
        a0, a1 = a % 3, a // 3
        b0, b1 = b % 3, b // 3
        c0 = (a0 * b0 + 2 * a1 * b1) % 3
        c1 = (a0 * b1 + a1 * b0) % 3
        return c0 + 3 * c1

    def inv(self, a: int) -> int:
        if a == 0:
            raise ZeroDivisionError
        for b in range(1, self.q):
            if self.mul(a, b) == 1:
                return b
        raise ArithmeticError(f"no inverse for {a}")

    def scalar_mul(self, a: int, point: Point) -> Point:
        return tuple(self.mul(a, x) for x in point)  # type: ignore[return-value]

    def dot(self, point: Point, line: Point) -> int:
        total = 0
        for x, y in zip(point, line):
            total = self.add(total, self.mul(x, y))
        return total

    def normalize(self, point: Point) -> Point:
        pivot = next((x for x in point if x != 0), None)
        if pivot is None:
            raise ValueError("zero vector is not projective")
        return self.scalar_mul(self.inv(pivot), point)

    def cross(self, u: Point, v: Point) -> Point:
        x = self.sub(self.mul(u[1], v[2]), self.mul(u[2], v[1]))
        y = self.sub(self.mul(u[2], v[0]), self.mul(u[0], v[2]))
        z = self.sub(self.mul(u[0], v[1]), self.mul(u[1], v[0]))
        return self.normalize((x, y, z))


def projective_points(field: Field) -> list[Point]:
    return sorted({
        field.normalize((x, y, z))
        for x, y, z in product(range(field.q), repeat=3)
        if x or y or z
    })


def on_standard_conic(field: Field, point: Point) -> bool:
    x, y, z = point
    return field.mul(x, z) == field.mul(y, y)


def line_points(field: Field, points: Iterable[Point], a: Point, b: Point) -> set[Point]:
    line = field.cross(a, b)
    return {point for point in points if field.dot(point, line) == 0}


def verify_witness(q: int, witness: list[Point]) -> dict[str, int]:
    field = Field.for_order(q)
    points = projective_points(field)
    conic = {point for point in points if on_standard_conic(field, point)}
    normalized = [field.normalize(point) for point in witness]
    arc = set(normalized)

    assert len(points) == q * q + q + 1
    assert len(conic) == q + 1
    assert len(arc) == len(witness)
    assert arc.isdisjoint(conic)

    secant_lines: set[Point] = set()
    for a, b in combinations(normalized, 2):
        line = field.cross(a, b)
        assert sum(field.dot(point, line) == 0 for point in normalized) == 2
        secant_lines.add(line)
    assert len(secant_lines) == comb(len(witness), 2)

    multiplicity: dict[Point, int] = {
        point: sum(field.dot(point, line) == 0 for line in secant_lines)
        for point in points
        if point not in arc
    }
    required = set(points) - arc - conic
    uncovered = {point for point in required if multiplicity[point] == 0}
    assert not uncovered

    k = len(witness)
    first = sum(multiplicity.values())
    second = sum(comb(value, 2) for value in multiplicity.values())
    assert first == comb(k, 2) * (q - 1)
    assert second == 3 * comb(k, 4)

    i_c = sum(multiplicity[point] for point in conic)
    return {
        "q": q,
        "k": k,
        "points": len(points),
        "conic_points": len(conic),
        "secants": len(secant_lines),
        "required_points": len(required),
        "I_C": i_c,
        "max_external_multiplicity": max(multiplicity.values()),
    }


def lower_bound_l2(q: int) -> int:
    for k in range(3, q + 3):
        m = k // 2
        if m * (q * q - k) <= m * comb(k, 2) * (q - 1) - 6 * comb(k, 4):
            return k
    raise ArithmeticError("bound not found")


WITNESSES: dict[int, list[Point]] = {
    8: [
        (0, 1, 1), (0, 1, 2), (1, 0, 1),
        (1, 0, 2), (1, 1, 2), (1, 1, 6),
    ],
    9: [
        (1, 0, 4), (1, 0, 5), (1, 1, 0),
        (1, 1, 2), (1, 2, 3), (1, 2, 4),
    ],
    11: [
        (1, 10, 0), (1, 9, 1), (1, 4, 7),
        (1, 8, 5), (0, 1, 4), (1, 1, 7),
    ],
    16: [
        (1, 5, 14), (1, 5, 3), (1, 9, 2),
        (1, 0, 9), (1, 13, 13), (1, 6, 10),
        (1, 3, 9), (0, 1, 11), (1, 10, 2),
    ],
}


def main() -> None:
    for q, witness in WITNESSES.items():
        result = verify_witness(q, witness)
        result["L2"] = lower_bound_l2(q)
        print(" ".join(f"{key}={value}" for key, value in result.items()))


if __name__ == "__main__":
    main()
