#!/usr/bin/env python3
"""Exact invariants of saturated-external C756 matchings over prime fields.

Fix the matching edge {0,infinity}.  Enumerate every completion whose pairwise
resultants are nonsquares, then record the complete-mapping, collinearity, and
quadratic-sign invariants relevant to the all-k saturated branch.

This is a research analyser, not a classifier up to projective equivalence.
"""

from __future__ import annotations

import argparse
import json
import sys
from collections import Counter
from itertools import combinations
from pathlib import Path


def chi(x: int, q: int) -> int:
    x %= q
    if x == 0:
        return 0
    return 1 if pow(x, (q - 1) // 2, q) == 1 else -1


def determinant(u: tuple[int, int, int], v: tuple[int, int, int], w: tuple[int, int, int], q: int) -> int:
    return (
        u[0] * (v[1] * w[2] - v[2] * w[1])
        - u[1] * (v[0] * w[2] - v[2] * w[0])
        + u[2] * (v[0] * w[1] - v[1] * w[0])
    ) % q


def edge_vector(edge: tuple[int, int], q: int) -> tuple[int, int, int]:
    a, b = edge
    if a == q:
        return (0, 1, -b % q)
    if b == q:
        return (0, 1, -a % q)
    return (1, -(a + b) % q, a * b % q)


def resultant(e: tuple[int, int], f: tuple[int, int], q: int) -> int:
    value = 1
    for a in e:
        for b in f:
            if a == q or b == q:
                continue
            value = value * (a - b) % q
    return value


def matching_invariants(matching: tuple[tuple[int, int], ...], q: int) -> dict[str, object]:
    finite = matching[1:]
    squares = {x * x % q for x in range(1, q)}
    oriented = tuple((a, b) if a in squares else (b, a) for a, b in finite)

    products = [a * b % q for a, b in oriented]
    complete_mapping = len(set(products)) == len(products)

    vectors = tuple(edge_vector(e, q) for e in matching)
    collinear_triples = sum(
        determinant(vectors[i], vectors[j], vectors[k], q) == 0
        for i, j, k in combinations(range(len(vectors)), 3)
    )

    negative_graph_degrees = [0] * len(oriented)
    negative_edges = 0
    positive_distinct_product_edges = 0
    for i, j in combinations(range(len(oriented)), 2):
        s, a = oriented[i]
        t, b = oriented[j]
        if chi((s - t) * (a - b), q) == -1:
            negative_edges += 1
            negative_graph_degrees[i] += 1
            negative_graph_degrees[j] += 1
        elif products[i] != products[j]:
            positive_distinct_product_edges += 1

    return {
        "complete_mapping": complete_mapping,
        "collinear_triples": collinear_triples,
        "negative_edges": negative_edges,
        "negative_degree_sequence": sorted(negative_graph_degrees),
        "positive_distinct_product_edges": positive_distinct_product_edges,
    }


def analyse(q: int) -> dict[str, object]:
    if q < 3 or q % 2 == 0 or any(q % p == 0 for p in range(2, int(q**0.5) + 1)):
        raise ValueError(f"{q} is not an odd prime")

    points = tuple(range(q + 1))  # q denotes infinity
    edges = tuple(combinations(points, 2))
    edge_index = {e: i for i, e in enumerate(edges)}
    adjacency = [0] * len(edges)
    for i, e in enumerate(edges):
        for j in range(i + 1, len(edges)):
            f = edges[j]
            if set(e).isdisjoint(f) and chi(resultant(e, f, q), q) == -1:
                adjacency[i] |= 1 << j
                adjacency[j] |= 1 << i

    base = edge_index[(0, q)]
    target = (q + 1) // 2
    invariant_counts: Counter[str] = Counter()
    solution_count = 0

    def visit(chosen: tuple[int, ...], candidates: int) -> None:
        nonlocal solution_count
        if len(chosen) == target:
            solution_count += 1
            inv = matching_invariants(tuple(edges[i] for i in chosen), q)
            invariant_counts[json.dumps(inv, sort_keys=True, separators=(",", ":"))] += 1
            return
        remaining = candidates
        while remaining:
            bit = remaining & -remaining
            remaining ^= bit
            vertex = bit.bit_length() - 1
            next_candidates = remaining & adjacency[vertex]
            if len(chosen) + 1 + next_candidates.bit_count() < target:
                continue
            visit(chosen + (vertex,), next_candidates)

    visit((base,), adjacency[base])
    rows = [
        {"count": count, **json.loads(encoded)}
        for encoded, count in sorted(invariant_counts.items())
    ]
    return {"q": q, "fixed_edge_solutions": solution_count, "invariants": rows}


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
        if not args.q:
            parser.error("supply at least one q, or use --check FILE")
        qs = args.q
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
