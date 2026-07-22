#!/usr/bin/env python3
"""Independent replay of C477 using an explicit Klein group and direct incidence."""

from __future__ import annotations

import hashlib
import json
from itertools import combinations, product
from pathlib import Path

P = 11
OO = 11
S = {0, 1, 2, 3, 4, OO}
HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-22-c477-first-atlas-collision-fibre.json"
UPSTREAM = HERE / "2026-07-22-c476-standard-grs-atlas-pilot.json"


def reciprocal(x: int) -> int:
    for y in range(1, P):
        if x * y % P == 1:
            return y
    raise ValueError(x)


def act(matrix: tuple[int, int, int, int], t: int) -> int:
    a, b, c, d = matrix
    if t == OO:
        return OO if c == 0 else a * reciprocal(c) % P
    bottom = (c * t + d) % P
    return OO if bottom == 0 else (a * t + b) * reciprocal(bottom) % P


def normalize(matrix: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    scalar = reciprocal(next(x % P for x in matrix if x % P))
    return tuple(x * scalar % P for x in matrix)


def multiply(x: tuple[int, int, int, int], y: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    a, b, c, d = x
    e, f, g, h = y
    return normalize(((a * e + b * g) % P, (a * f + b * h) % P,
                      (c * e + d * g) % P, (c * f + d * h) % P))


def orbit(group: list[tuple[int, int, int, int]], x: int) -> list[int]:
    return sorted({act(g, x) for g in group})


def conic(t: int) -> tuple[int, int, int]:
    return (0, 0, 1) if t == OO else (1, t, t * t % P)


def determinant(a: tuple[int, int, int], b: tuple[int, int, int], c: tuple[int, int, int]) -> int:
    total = 0
    for perm, sign in [((0, 1, 2), 1), ((1, 2, 0), 1), ((2, 0, 1), 1),
                       ((2, 1, 0), -1), ((1, 0, 2), -1), ((0, 2, 1), -1)]:
        total += sign * a[perm[0]] * b[perm[1]] * c[perm[2]]
    return total % P


def projective_plane() -> list[tuple[int, int, int]]:
    points = set()
    for vector in product(range(P), repeat=3):
        if vector == (0, 0, 0):
            continue
        first = next(x for x in vector if x)
        scale = reciprocal(first)
        points.add(tuple(scale * x % P for x in vector))
    assert len(points) == P * P + P + 1
    return sorted(points)


def row_rank(rows: list[list[int]]) -> int:
    rows = [[x % P for x in row] for row in rows]
    rank = 0
    for column in range(6):
        pivot = next((i for i in range(rank, len(rows)) if rows[i][column]), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        scale = reciprocal(rows[rank][column])
        rows[rank] = [scale * x % P for x in rows[rank]]
        for i in range(rank + 1, len(rows)):
            scale = rows[i][column]
            rows[i] = [(x - scale * y) % P for x, y in zip(rows[i], rows[rank])]
        rank += 1
    return rank


def veronese2(v: tuple[int, int, int]) -> list[int]:
    x, y, z = v
    return [x * x, x * y, x * z, y * y, y * z, z * z]


def profile(radical: int) -> dict[str, object]:
    arc = [conic(t) for t in sorted(S) + [radical]]
    candidates = [
        x for x in projective_plane()
        if x not in arc and all(determinant(a, b, x) for a, b in combinations(arc, 2))
    ]
    edges = [
        (x, y) for x, y in combinations(candidates, 2)
        if all(determinant(a, x, y) for a in arc)
    ]
    degrees = {x: 0 for x in candidates}
    for x, y in edges:
        degrees[x] += 1
        degrees[y] += 1
    neighbours = {x: set() for x in candidates}
    for x, y in edges:
        neighbours[x].add(y)
        neighbours[y].add(x)
    unseen = set(candidates)
    components = []
    while unseen:
        stack = [min(unseen)]
        component = set()
        while stack:
            x = stack.pop()
            if x in component:
                continue
            component.add(x)
            stack.extend(neighbours[x] - component)
        unseen -= component
        components.append((len(component), sorted(len(neighbours[x] & component) for x in component)))
    components.sort(key=lambda x: (-x[0], x[1]))
    return {
        "evaluation_rank": row_rank([veronese2(x) for x in arc]),
        "continuation_count": len(candidates),
        "continuation_edges": len(edges),
        "conflict_edges": len(candidates) * (len(candidates) - 1) // 2 - len(edges),
        "degree_multiset": sorted(degrees.values()),
        "components": components,
        "continuation_evaluation_rank": row_rank([veronese2(x) for x in candidates]),
    }


def main() -> None:
    identity = (1, 0, 0, 1)
    # A(t)=4-t, B(t)=(1-t)/(1+5t), C(t)=(3-t)/(1+5t).
    group = [normalize(x) for x in [identity, (-1, 4, 0, 1), (-1, 1, 5, 1), (-1, 3, 5, 1)]]
    assert len(set(group)) == 4
    assert {multiply(g, h) for g in group for h in group} == set(group)
    assert all(multiply(g, g) == identity for g in group)
    assert all({act(g, s) for s in S} == S for g in group)

    complement = set(range(P + 1)) - S
    complement_orbits = []
    while complement:
        current = orbit(group, min(complement))
        complement_orbits.append(current)
        complement -= set(current)
    assert complement_orbits == [[5, 10], [6, 7, 8, 9]]
    fixed_sets = sorted(
        [sorted(t for t in range(P + 1) if act(g, t) == t) for g in group if g != identity],
        key=lambda x: (len(x), x),
    )
    assert fixed_sets == [[], [2, 11], [5, 10]]

    profiles = {r: profile(r) for r in (5, 6)}
    assert profiles == {
        5: {"evaluation_rank": 5, "continuation_count": 11, "continuation_edges": 15,
            "conflict_edges": 40, "degree_multiset": [0, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4],
            "components": [(5, [2, 2, 2, 2, 2]), (5, [4, 4, 4, 4, 4]), (1, [0])],
            "continuation_evaluation_rank": 6},
        6: {"evaluation_rank": 5, "continuation_count": 7, "continuation_edges": 10,
            "conflict_edges": 11, "degree_multiset": [0, 0, 4, 4, 4, 4, 4],
            "components": [(5, [4, 4, 4, 4, 4]), (1, [0]), (1, [0])],
            "continuation_evaluation_rank": 6},
    }

    certificate = json.loads(CERTIFICATE.read_text())
    assert certificate["stabilizer"]["complement_orbits"] == complement_orbits
    by_radical = {x["representative_radical"]: x for x in certificate["collision_fibre"]}
    for r, replay in profiles.items():
        primary = by_radical[r]
        graph = primary["extension_and_continuation_profile"]
        assert primary["quadratic_evaluation_rank_on_extended_arc"] == replay["evaluation_rank"]
        assert graph["vertex_count"] == replay["continuation_count"]
        assert graph["continuation_edge_count"] == replay["continuation_edges"]
        assert graph["conflict_edge_count"] == replay["conflict_edges"]
        assert graph["continuation_degree_multiset"] == replay["degree_multiset"]
        assert [
            (x["size"], x["degree_multiset"]) for x in graph["continuation_components"]
        ] == replay["components"]
        assert graph["quadratic_evaluation_rank_on_continuations"] == replay["continuation_evaluation_rank"]
    assert certificate["upstream_frozen_input"]["sha256"] == hashlib.sha256(UPSTREAM.read_bytes()).hexdigest()
    print("C477 independent replay: stabilizer, fibre, ranks, and graphs agree")


if __name__ == "__main__":
    main()
