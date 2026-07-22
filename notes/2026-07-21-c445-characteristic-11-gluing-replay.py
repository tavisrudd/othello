#!/usr/bin/env python3
"""Independent finite-group replay for C445; imports no primary code."""

from __future__ import annotations

import json
from collections import deque
from pathlib import Path


P = 11
INF = 11
BASE = tuple(sorted(((0, 1), (2, 5), (3, 7), (4, 9), (6, 8), (10, INF))))
JMATE = tuple(sorted(((0, 10), (1, INF), (2, 7), (3, 5), (4, 8), (6, 9))))


def norm(a: int, b: int, c: int, d: int) -> tuple[int, int, int, int]:
    xs = [a % P, b % P, c % P, d % P]
    inv = pow(next(x for x in xs if x), -1, P)
    return tuple(x * inv % P for x in xs)  # type: ignore[return-value]


def point(g: tuple[int, int, int, int], x: int) -> int:
    a, b, c, d = g
    if x == INF:
        return INF if c == 0 else a * pow(c, -1, P) % P
    den = (c * x + d) % P
    return INF if den == 0 else (a * x + b) * pow(den, -1, P) % P


def perm(g: tuple[int, int, int, int]) -> tuple[int, ...]:
    return tuple(point(g, x) for x in range(P + 1))


def act(g: tuple[int, ...], matching: tuple[tuple[int, int], ...]) -> tuple[tuple[int, int], ...]:
    return tuple(sorted(tuple(sorted((g[a], g[b]))) for a, b in matching))


def mul(g: tuple[int, ...], h: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(g[h[x]] for x in range(P + 1))


def inv(g: tuple[int, ...]) -> tuple[int, ...]:
    out = [0] * len(g)
    for x, y in enumerate(g):
        out[y] = x
    return tuple(out)


def closure(generators: set[tuple[int, ...]]) -> set[tuple[int, ...]]:
    steps = generators | {inv(g) for g in generators}
    identity = tuple(range(P + 1))
    seen = {identity}
    todo = deque([identity])
    while todo:
        g = todo.popleft()
        for h in steps:
            gh = mul(g, h)
            if gh not in seen:
                seen.add(gh)
                todo.append(gh)
    return seen


def main() -> None:
    matrices = {
        norm(a, b, c, d)
        for a in range(P)
        for b in range(P)
        for c in range(P)
        for d in range(P)
        if (a * d - b * c) % P
    }
    pgl = {perm(g) for g in matrices}
    psl = {
        perm(g)
        for g in matrices
        if pow((g[0] * g[3] - g[1] * g[2]) % P, 5, P) == 1
    }
    hb = {g for g in pgl if act(g, BASE) == BASE}
    hj = {g for g in pgl if act(g, JMATE) == JMATE}
    pgl_orbit = {act(g, BASE) for g in pgl}
    ob = {act(g, BASE) for g in psl}
    oj = {act(g, JMATE) for g in psl}
    transporter = perm(norm(1, 10, 1, 1))

    assert (len(pgl), len(psl), len(hb), len(hj), len(hb & hj)) == (1320, 660, 60, 60, 12)
    assert hb <= psl and hj <= psl and closure(hb | hj) == psl
    assert len(pgl_orbit) == 22 and len(ob) == len(oj) == 11
    assert ob.isdisjoint(oj) and pgl_orbit == ob | oj
    assert act(transporter, BASE) == JMATE

    certificate = json.loads(
        (Path(__file__).with_name("2026-07-21-c445-characteristic-11-gluing.json")).read_text()
    )
    finite = certificate["exact_gluing_theorem"]["characteristic_11"]
    assert finite["PGL2_orbit_size"] == len(pgl_orbit)
    assert finite["PSL2_orbit_sizes"] == [len(ob), len(oj)]
    assert finite["generated_closure_order"] == len(psl)
    assert finite["stabilizer_intersection_order"] == len(hb & hj)
    print("C445 independent finite-group replay: OK")


if __name__ == "__main__":
    main()
