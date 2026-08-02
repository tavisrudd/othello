#!/usr/bin/env python3
"""Exact audits for the C756 Segre-tangent coherence reduction.

For each listed odd prime q == 3 (mod 4), this program

* enumerates every resultant-compatible perfect matching after fixing {0,inf};
* compares the arc condition with the coherent sign condition forced by
  Segre's lemma of tangents; and
* computes the point stabilizer of the tournament induced by the nonzero
  squares, together with its complete-mapping count.

The program is evidence for the reduction, not a proof of the all-field
first-subconstituent automorphism statement.
"""

from __future__ import annotations

import argparse
import json
import sys
from itertools import combinations
from pathlib import Path


def chi(x: int, q: int) -> int:
    x %= q
    if x == 0:
        return 0
    return 1 if pow(x, (q - 1) // 2, q) == 1 else -1


def resultant(e: tuple[int, int], f: tuple[int, int], q: int) -> int:
    value = 1
    for x in e:
        for y in f:
            if x == q or y == q:
                continue
            value = value * (x - y) % q
    return value


def vector(e: tuple[int, int], q: int) -> tuple[int, int, int]:
    x, y = e
    if y == q:
        return (0, 1, -x % q)
    return (1, -(x + y) % q, x * y % q)


def determinant(u: tuple[int, int, int], v: tuple[int, int, int], w: tuple[int, int, int], q: int) -> int:
    return (
        u[0] * (v[1] * w[2] - v[2] * w[1])
        - u[1] * (v[0] * w[2] - v[2] * w[0])
        + u[2] * (v[0] * w[1] - v[1] * w[0])
    ) % q


def matching_audit(q: int) -> dict[str, int]:
    points = tuple(range(q + 1))  # q denotes infinity
    edges = tuple(combinations(points, 2))
    edge_index = {edge: i for i, edge in enumerate(edges)}
    adjacency = [0] * len(edges)
    for i, edge in enumerate(edges):
        for j in range(i + 1, len(edges)):
            other = edges[j]
            if set(edge).isdisjoint(other) and chi(resultant(edge, other, q), q) == -1:
                adjacency[i] |= 1 << j
                adjacency[j] |= 1 << i

    base = edge_index[(0, q)]
    target = (q + 1) // 2
    squares = {x * x % q for x in range(1, q)}
    counts = {
        "matchings": 0,
        "arcs": 0,
        "coherent": 0,
        "arc_not_coherent": 0,
        "coherent_not_arc": 0,
    }

    def record(chosen: tuple[int, ...]) -> None:
        matching = tuple(edges[i] for i in chosen)
        finite = matching[1:]
        oriented = tuple((x, y) if x in squares else (y, x) for x, y in finite)
        vectors = tuple(vector(edge, q) for edge in matching)
        arc = all(determinant(vectors[i], vectors[j], vectors[k], q) for i, j, k in combinations(range(target), 3))
        # B_st=(s-phi(t))(phi(s)-t).  Segre symmetry is chi(B_st)=+1.
        coherent = all(
            chi((s - b) * (a - t), q) == 1
            for (s, a), (t, b) in combinations(oriented, 2)
        )
        counts["matchings"] += 1
        counts["arcs"] += int(arc)
        counts["coherent"] += int(coherent)
        counts["arc_not_coherent"] += int(arc and not coherent)
        counts["coherent_not_arc"] += int(coherent and not arc)

    def visit(chosen: tuple[int, ...], candidates: int) -> None:
        if len(chosen) == target:
            record(chosen)
            return
        remaining = candidates
        while remaining:
            bit = remaining & -remaining
            remaining ^= bit
            vertex = bit.bit_length() - 1
            next_candidates = remaining & adjacency[vertex]
            if len(chosen) + 1 + next_candidates.bit_count() >= target:
                visit(chosen + (vertex,), next_candidates)

    visit((base,), adjacency[base])
    return counts


def local_tournament_audit(q: int) -> dict[str, object]:
    squares = sorted({x * x % q for x in range(1, q)})
    square_set = set(squares)
    size = len(squares)
    out = [[(squares[j] - squares[i]) % q in square_set for j in range(size)] for i in range(size)]
    degrees = [sum(row) for row in out]

    # Multiplication by a square is vertex-transitive.  Fix the vertex 1 and
    # enumerate its stabilizer by exact compatibility backtracking.
    one = squares.index(1)
    image: dict[int, int] = {one: one}
    used = {one}
    stabilizer: list[tuple[int, ...]] = []

    def visit() -> None:
        if len(image) == size:
            stabilizer.append(tuple(image[i] for i in range(size)))
            return
        best_vertex = -1
        best_candidates: list[int] | None = None
        for vertex in range(size):
            if vertex in image:
                continue
            candidates = [
                target
                for target in range(size)
                if target not in used
                and degrees[target] == degrees[vertex]
                and all(
                    out[vertex][old] == out[target][new]
                    and out[old][vertex] == out[new][target]
                    for old, new in image.items()
                )
            ]
            if not candidates:
                return
            if best_candidates is None or len(candidates) < len(best_candidates):
                best_vertex = vertex
                best_candidates = candidates
        assert best_candidates is not None
        for target in best_candidates:
            image[best_vertex] = target
            used.add(target)
            visit()
            used.remove(target)
            del image[best_vertex]

    visit()
    complete = sum(
        len({squares[i] * squares[perm[i]] % q for i in range(size)}) == size
        for perm in stabilizer
    )
    return {
        "vertices": size,
        "degree_set": sorted(set(degrees)),
        "stabilizer_of_1": len(stabilizer),
        "full_automorphism_group": size * len(stabilizer),
        "complete_mappings_in_stabilizer": complete,
    }


def analyse(q: int) -> dict[str, object]:
    if q % 4 != 3 or any(q % p == 0 for p in range(2, int(q**0.5) + 1)):
        raise ValueError(f"{q} is not a prime congruent to 3 modulo 4")
    return {
        "q": q,
        "matching": matching_audit(q),
        "local_tournament": local_tournament_audit(q),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("q", nargs="*", type=int)
    parser.add_argument("--out", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    if args.check:
        expected = args.check.read_text()
        stored = json.loads(expected)
        qs = [row["q"] for row in stored["rows"]]
    else:
        qs = args.q or [7, 11, 19, 23, 31, 43]
    payload = {"schema": 1, "task": "C756", "rows": [analyse(q) for q in qs]}
    rendered = json.dumps(payload, indent=1, sort_keys=True) + "\n"
    if args.check:
        if rendered != expected:
            print(f"mismatch: {args.check}", file=sys.stderr)
            raise SystemExit(1)
        print(f"ok: {args.check}")
    elif args.out:
        args.out.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
