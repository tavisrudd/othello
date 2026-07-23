#!/usr/bin/env python3
"""Independent span-union replay of the C510 GF(9) certificate."""

from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path

Q = 9
DIM = 6
CERTIFICATE = Path(__file__).with_name("2026-07-23-c510-trs-deep-hole-pilot.json")


def plus(x: int, y: int) -> int:
    return ((x % 3 + y % 3) % 3) + 3 * ((x // 3 + y // 3) % 3)


def times(x: int, y: int) -> int:
    a, b, c, d = x % 3, x // 3, y % 3, y // 3
    return ((a * c + 2 * b * d) % 3) + 3 * ((a * d + b * c) % 3)


def reciprocal(x: int) -> int:
    return next(y for y in range(1, Q) if times(x, y) == 1)


def pow9(x: int, n: int) -> int:
    answer = 1
    for _ in range(n):
        answer = times(answer, x)
    return answer


def curve_point(t: int) -> tuple[int, ...]:
    p = [pow9(t, i) for i in range(7)]
    return tuple(p[:5] + [plus(p[5], times(2, p[6]))])


def pg_points(dimension: int):
    for first in range(dimension):
        for tail in itertools.product(range(Q), repeat=dimension - first - 1):
            yield (0,) * first + (1,) + tail


def canonical(v: tuple[int, ...]) -> tuple[int, ...]:
    scale = reciprocal(next(x for x in v if x))
    return tuple(times(scale, x) for x in v)


def linear_combination(coeffs: tuple[int, ...], vectors: tuple[tuple[int, ...], ...]) -> tuple[int, ...]:
    return tuple(
        sum_in_field(times(coeff, vector[i]) for coeff, vector in zip(coeffs, vectors))
        for i in range(DIM)
    )


def sum_in_field(values) -> int:
    answer = 0
    for value in values:
        answer = plus(answer, value)
    return answer


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    columns = tuple(curve_point(t) for t in range(Q))
    covered: set[tuple[int, ...]] = set()
    for support in itertools.combinations(columns, DIM - 1):
        for coeffs in pg_points(DIM - 1):
            covered.add(canonical(linear_combination(coeffs, support)))
    deep = sorted(set(pg_points(DIM)) - covered)
    encoded = ("\n".join(",".join(map(str, point)) for point in deep) + "\n").encode()
    assert len(deep) == certificate["deep_point_count"]
    assert hashlib.sha256(encoded).hexdigest() == certificate["deep_points_sha256"]
    assert len(covered) + len(deep) == certificate["projective_syndrome_points"]
    print(f"PASS {CERTIFICATE} deep={len(deep)} covered={len(covered)}")


if __name__ == "__main__":
    main()
