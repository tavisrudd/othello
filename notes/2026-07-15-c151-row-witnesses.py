#!/usr/bin/env python3
"""Independent C151 generator for legal Lean orbit numbers in one normalized Q25 row.

This is a proposal generator only.  Lean checks every emitted orbit against `LegalPair`.
The field model is F5[w]/(w^2-2), encoded as a+5b, exactly as in `GF25`.
"""

from __future__ import annotations

import argparse
from itertools import combinations, product

Vec = tuple[int, int, int]


def add(x: int, y: int) -> int:
    return ((x % 5 + y % 5) % 5) + 5 * ((x // 5 + y // 5) % 5)


def neg(x: int) -> int:
    return ((-x) % 5) + 5 * ((-(x // 5)) % 5)


def sub(x: int, y: int) -> int:
    return add(x, neg(y))


def mul(x: int, y: int) -> int:
    a, b, c, d = x % 5, x // 5, y % 5, y // 5
    return ((a * c + 2 * b * d) % 5) + 5 * ((a * d + b * c) % 5)


def power(x: int, n: int) -> int:
    out = 1
    while n:
        if n & 1:
            out = mul(out, x)
        x = mul(x, x)
        n >>= 1
    return out


def norm(v: Vec) -> Vec:
    pivot = next(x for x in v if x)
    inv = power(pivot, 23)
    return tuple(mul(x, inv) for x in v)  # type: ignore[return-value]


def key(v: Vec) -> int:
    return v[0] + 25 * v[1] + 625 * v[2]


def rank(v: Vec) -> int:
    if v[0] == 1:
        return v[1] * 25 + v[2]
    if v[1] == 1:
        return 625 + v[2]
    return 650


def frob(v: Vec) -> Vec:
    return norm(tuple(power(x, 5) for x in v))  # type: ignore[arg-type]


def cross(a: Vec, b: Vec) -> Vec:
    return norm(
        (
            sub(mul(a[1], b[2]), mul(a[2], b[1])),
            sub(mul(a[2], b[0]), mul(a[0], b[2])),
            sub(mul(a[0], b[1]), mul(a[1], b[0])),
        )
    )


def dot(a: Vec, b: Vec) -> int:
    return add(add(mul(a[0], b[0]), mul(a[1], b[1])), mul(a[2], b[2]))


def lean_orbit_number(p: Vec, q: Vec) -> int:
    v = p if rank(p) < rank(q) else q
    if v[0] == 1:
        yr, yi = v[1] % 5, v[1] // 5
        if yi:
            assert yi in (1, 2)
            return (yr * 2 + yi - 1) * 25 + v[2]
        zr, zi = v[2] % 5, v[2] // 5
        assert zi in (1, 2)
        return 250 + (yr * 5 + zr) * 2 + zi - 1
    zr, zi = v[2] % 5, v[2] // 5
    assert v[1] == 1 and zi in (1, 2)
    return 300 + zr * 2 + zi - 1


def is_arc(points: list[int], pts: list[Vec], joins: list[list[int]]) -> bool:
    return all(dot(pts[c], pts[joins[a][b]]) != 0 for a, b, c in combinations(points, 3))


def geometry() -> tuple[list[Vec], list[tuple[int, int]], list[int], list[list[int]]]:
    pts: list[Vec] = []
    ids: dict[int, int] = {}
    for raw in product(range(25), repeat=3):
        if raw == (0, 0, 0):
            continue
        v = norm(raw)
        if key(v) not in ids:
            ids[key(v)] = len(pts)
            pts.append(v)
    assert len(pts) == 651
    sigma = [ids[key(frob(v))] for v in pts]
    fixed = [i for i, j in enumerate(sigma) if i == j]
    orbits = [(i, sigma[i]) for i in range(651) if i < sigma[i]]
    assert len(fixed) == 31 and len(orbits) == 310
    joins = [[-1] * 651 for _ in range(651)]
    for a in range(651):
        for b in range(a + 1, 651):
            joins[a][b] = joins[b][a] = ids[key(cross(pts[a], pts[b]))]
    return pts, orbits, fixed, joins


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("b", type=int, nargs="?")
    parser.add_argument("c", type=int, nargs="?")
    parser.add_argument(
        "--internal",
        action="store_true",
        help="interpret b,c as C150 internal orbit indices and print their Lean numbers",
    )
    parser.add_argument(
        "--all-representatives",
        action="store_true",
        help="check and emit all five C150 equality representatives",
    )
    args = parser.parse_args()

    pts, orbits, fixed, joins = geometry()
    by_number = {lean_orbit_number(pts[p], pts[q]): i for i, (p, q) in enumerate(orbits)}
    assert len(by_number) == 310

    def check_row(b: int, c: int) -> list[int]:
        assert 5 < b < c < 310
        chosen = [by_number[n] for n in (5, b, c)]
        config = [fixed[0], fixed[1]]
        for i in chosen:
            config.extend(orbits[i])
        assert is_arc(config, pts, joins)
        return [
            n
            for n in range(310)
            if is_arc(config + list(orbits[by_number[n]]), pts, joins)
        ]

    numbers = [lean_orbit_number(pts[p], pts[q]) for p, q in orbits]
    if args.all_representatives:
        assert args.b is None and args.c is None and not args.internal
        for ib, ic in ((93, 154), (96, 216), (98, 251), (119, 232), (123, 279)):
            b, c = sorted((numbers[ib], numbers[ic]))
            legal = check_row(b, c)
            assert len(legal) == 32
            print(f"internal=65,{ib},{ic} lean=5,{b},{c} legal={len(legal)}")
            print(" ".join(map(str, legal)))
        return

    assert args.b is not None and args.c is not None
    if args.internal:
        assert args.b != 65 and args.c != 65
        row = sorted((numbers[args.b], numbers[args.c]))
        print(f"internal=65,{args.b},{args.c} lean=5,{row[0]},{row[1]}")
        b, c = row
    else:
        b, c = args.b, args.c
    legal = check_row(b, c)
    print(f"row=5,{b},{c} legal={len(legal)}")
    print(" ".join(map(str, legal)))


if __name__ == "__main__":
    main()
