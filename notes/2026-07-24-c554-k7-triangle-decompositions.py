#!/usr/bin/env python3
"""Enumerate triangle decompositions of KG(7,2).

Vertices of KG(7,2) are edges of K_7.  Its triangles are three-edge
near-perfect matchings of K_7.  A decomposition is the abstract matching
incidence structure forced by zero defect for a seven-arc.
"""

from __future__ import annotations

import argparse
import itertools
import json
from pathlib import Path
from collections.abc import Iterator


Vertex = int
Edge = tuple[Vertex, Vertex]
Matching = tuple[Edge, Edge, Edge]


def canon_edge(a: int, b: int) -> Edge:
    return (a, b) if a < b else (b, a)


EDGES: tuple[Edge, ...] = tuple(itertools.combinations(range(7), 2))
EDGE_ID = {edge: i for i, edge in enumerate(EDGES)}

DISJOINT_PAIRS: tuple[tuple[int, int], ...] = tuple(
    (i, j)
    for i, e in enumerate(EDGES)
    for j, f in enumerate(EDGES[i + 1 :], i + 1)
    if set(e).isdisjoint(f)
)
PAIR_ID = {pair: i for i, pair in enumerate(DISJOINT_PAIRS)}


def perfect_matchings(vertices: tuple[int, ...]) -> Iterator[tuple[Edge, ...]]:
    if not vertices:
        yield ()
        return
    a = vertices[0]
    for i in range(1, len(vertices)):
        b = vertices[i]
        rest = vertices[1:i] + vertices[i + 1 :]
        for tail in perfect_matchings(rest):
            yield (canon_edge(a, b),) + tail


MATCHINGS: tuple[Matching, ...] = tuple(
    sorted(
        tuple(sorted(matching))
        for omitted in range(7)
        for matching in perfect_matchings(
            tuple(v for v in range(7) if v != omitted)
        )
    )
)


def matching_pair_ids(matching: Matching) -> tuple[int, int, int]:
    edge_ids = sorted(EDGE_ID[edge] for edge in matching)
    return tuple(
        PAIR_ID[(i, j)]
        for i, j in itertools.combinations(edge_ids, 2)
    )


MATCHING_PAIRS = tuple(matching_pair_ids(matching) for matching in MATCHINGS)
MATCHING_MASKS = tuple(
    sum(1 << pair_id for pair_id in pair_ids)
    for pair_ids in MATCHING_PAIRS
)
BY_PAIR: tuple[tuple[int, ...], ...] = tuple(
    tuple(
        matching_id
        for matching_id, pair_ids in enumerate(MATCHING_PAIRS)
        if pair_id in pair_ids
    )
    for pair_id in range(len(DISJOINT_PAIRS))
)
FULL_MASK = (1 << len(DISJOINT_PAIRS)) - 1


def omitted_vertex(matching: Matching) -> int:
    used = {v for edge in matching for v in edge}
    return next(v for v in range(7) if v not in used)


def validate_static_data() -> None:
    assert len(EDGES) == 21
    assert len(DISJOINT_PAIRS) == 105
    assert len(MATCHINGS) == 105
    assert all(len(options) == 3 for options in BY_PAIR)
    assert len(set(MATCHINGS)) == len(MATCHINGS)


def choose_pair(covered: int) -> tuple[int, tuple[int, ...]] | None:
    best: tuple[int, tuple[int, ...]] | None = None
    remaining = FULL_MASK ^ covered
    while remaining:
        low = remaining & -remaining
        pair_id = low.bit_length() - 1
        options = tuple(
            matching_id
            for matching_id in BY_PAIR[pair_id]
            if MATCHING_MASKS[matching_id] & covered == 0
        )
        if not options:
            return pair_id, ()
        if best is None or len(options) < len(best[1]):
            best = pair_id, options
            if len(options) == 1:
                return best
        remaining ^= low
    return best


def decompositions(
    initial: tuple[int, ...] = (),
    limit: int | None = None,
    stats: dict[str, int] | None = None,
) -> Iterator[tuple[int, ...]]:
    covered = 0
    for matching_id in initial:
        mask = MATCHING_MASKS[matching_id]
        if mask & covered:
            raise ValueError("initial matchings overlap")
        covered |= mask
    chosen = list(initial)
    yielded = 0
    if stats is not None:
        stats["nodes"] = 0
        stats["max_depth"] = len(initial)

    def visit(current: int) -> Iterator[tuple[int, ...]]:
        nonlocal yielded
        if stats is not None:
            stats["nodes"] += 1
            stats["max_depth"] = max(stats["max_depth"], len(chosen))
        if limit is not None and yielded >= limit:
            return
        if current == FULL_MASK:
            yielded += 1
            yield tuple(sorted(chosen))
            return
        selected = choose_pair(current)
        assert selected is not None
        _, options = selected
        for matching_id in options:
            chosen.append(matching_id)
            yield from visit(current | MATCHING_MASKS[matching_id])
            chosen.pop()

    yield from visit(covered)


def matching_id(target: Matching) -> int:
    normalized = tuple(sorted(target))
    return MATCHINGS.index(normalized)


def summarize(solution: tuple[int, ...]) -> dict[str, object]:
    omitted_counts = [0] * 7
    edge_counts = [0] * len(EDGES)
    for mid in solution:
        matching = MATCHINGS[mid]
        omitted_counts[omitted_vertex(matching)] += 1
        for edge in matching:
            edge_counts[EDGE_ID[edge]] += 1
    return {
        "matching_ids": list(solution),
        "omitted_counts": omitted_counts,
        "edge_replications": edge_counts,
    }


def parity_obstruction() -> dict[str, object] | None:
    """Return a left-nullspace certificate with odd support, if one exists."""
    coefficient_rows = []
    for pair_id in range(len(DISJOINT_PAIRS)):
        coefficients = sum(
            1 << matching_id for matching_id in BY_PAIR[pair_id]
        )
        coefficient_rows.append(
            [coefficients, 1, 1 << pair_id]
        )

    pivot_row = 0
    for column in range(len(MATCHINGS)):
        pivot = next(
            (
                row
                for row in range(pivot_row, len(coefficient_rows))
                if coefficient_rows[row][0] >> column & 1
            ),
            None,
        )
        if pivot is None:
            continue
        coefficient_rows[pivot_row], coefficient_rows[pivot] = (
            coefficient_rows[pivot],
            coefficient_rows[pivot_row],
        )
        for row in range(len(coefficient_rows)):
            if row != pivot_row and coefficient_rows[row][0] >> column & 1:
                for field in range(3):
                    coefficient_rows[row][field] ^= coefficient_rows[pivot_row][
                        field
                    ]
        pivot_row += 1

    contradiction = next(
        (
            row
            for row in coefficient_rows
            if row[0] == 0 and row[1] == 1
        ),
        None,
    )
    if contradiction is None:
        return None
    support_mask = contradiction[2]
    support_ids = [
        pair_id
        for pair_id in range(len(DISJOINT_PAIRS))
        if support_mask >> pair_id & 1
    ]
    support = [
        [list(EDGES[i]), list(EDGES[j])]
        for pair_id in support_ids
        for i, j in [DISJOINT_PAIRS[pair_id]]
    ]
    return {
        "support_size": len(support),
        "disjoint_edge_pairs": support,
    }


def reference_count(fix_first: bool) -> dict[str, int]:
    """Independent set-based exact-cover recursion."""
    universe = frozenset(DISJOINT_PAIRS)
    first = tuple(
        sorted(
            EDGE_ID[edge]
            for edge in ((0, 1), (2, 3), (4, 5))
        )
    )
    first_pairs = frozenset(itertools.combinations(first, 2))
    nodes = 0
    max_depth = 0

    def completions(pair: tuple[int, int]) -> Iterator[frozenset[tuple[int, int]]]:
        used = set(EDGES[pair[0]]) | set(EDGES[pair[1]])
        remaining = sorted(set(range(7)) - used)
        for omitted in remaining:
            third_vertices = [v for v in remaining if v != omitted]
            third_id = EDGE_ID[canon_edge(*third_vertices)]
            triple = sorted((pair[0], pair[1], third_id))
            yield frozenset(itertools.combinations(triple, 2))

    count = 0

    def visit(uncovered: frozenset[tuple[int, int]], depth: int) -> None:
        nonlocal count, max_depth, nodes
        nodes += 1
        max_depth = max(max_depth, depth)
        if not uncovered:
            count += 1
            return
        pair = min(uncovered)
        for covered_by_triangle in completions(pair):
            if covered_by_triangle <= uncovered:
                visit(uncovered - covered_by_triangle, depth + 1)

    if fix_first:
        visit(universe - first_pairs, 1)
    else:
        visit(universe, 0)
    return {
        "count": count,
        "nodes": nodes,
        "max_depth": max_depth,
    }


def modular_ranks(prime: int) -> tuple[int, int]:
    rows = [
        [
            int(matching_id in BY_PAIR[pair_id])
            for matching_id in range(len(MATCHINGS))
        ]
        for pair_id in range(len(DISJOINT_PAIRS))
    ]

    def rank(matrix: list[list[int]]) -> int:
        work = [row[:] for row in matrix]
        pivot_row = 0
        for column in range(len(work[0])):
            pivot = next(
                (
                    row
                    for row in range(pivot_row, len(work))
                    if work[row][column] % prime
                ),
                None,
            )
            if pivot is None:
                continue
            work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
            inverse = pow(work[pivot_row][column], -1, prime)
            work[pivot_row] = [
                value * inverse % prime for value in work[pivot_row]
            ]
            for row in range(len(work)):
                factor = work[row][column] % prime
                if row != pivot_row and factor:
                    work[row] = [
                        (a - factor * b) % prime
                        for a, b in zip(work[row], work[pivot_row], strict=True)
                    ]
            pivot_row += 1
        return pivot_row

    return rank(rows), rank([row + [1] for row in rows])


def primary_count(fix_first: bool) -> dict[str, int]:
    initial: tuple[int, ...] = ()
    if fix_first:
        initial = (
            matching_id(((0, 1), (2, 3), (4, 5))),
        )
    stats: dict[str, int] = {}
    count = sum(
        1
        for _ in decompositions(
            initial=initial,
            stats=stats,
        )
    )
    return {"count": count, **stats}


def evidence_payload() -> dict[str, object]:
    return {
        "schema": "c554-k7-zero-defect-obstruction-v1",
        "ground_set": {
            "k7_edges": len(EDGES),
            "disjoint_edge_pairs": len(DISJOINT_PAIRS),
            "near_perfect_matchings": len(MATCHINGS),
            "completions_per_disjoint_pair": sorted(
                set(len(options) for options in BY_PAIR)
            ),
        },
        "symmetry_normalization": {
            "fixed_matching": [[0, 1], [2, 3], [4, 5]],
            "omitted_vertex": 6,
            "justification": (
                "S_7 is transitive on three-edge near-perfect matchings"
            ),
        },
        "primary_exact_cover": primary_count(fix_first=True),
        "independent_set_recursion": reference_count(fix_first=True),
        "modular_ranks": {
            str(prime): modular_ranks(prime)
            for prime in (2, 3, 5, 7)
        },
        "conclusion": (
            "KG(7,2) has no triangle decomposition into near-perfect "
            "matchings, so a zero-defect seven-arc is combinatorially "
            "impossible"
        ),
    }


def canonical_json(payload: object) -> str:
    return json.dumps(payload, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--limit", type=int)
    parser.add_argument(
        "--fix-first",
        action="store_true",
        help="fix 01|23|45, omitting 6, by S_7 transitivity",
    )
    parser.add_argument("--samples", type=int, default=1)
    parser.add_argument("--parity-certificate", action="store_true")
    parser.add_argument("--reference", action="store_true")
    parser.add_argument("--modular-ranks", action="store_true")
    parser.add_argument("--write-evidence", type=Path)
    parser.add_argument("--check-evidence", type=Path)
    args = parser.parse_args()

    validate_static_data()
    if args.write_evidence is not None or args.check_evidence is not None:
        if args.write_evidence is not None and args.check_evidence is not None:
            parser.error("choose only one evidence action")
        payload_text = canonical_json(evidence_payload())
        if args.write_evidence is not None:
            args.write_evidence.write_text(payload_text, encoding="utf-8")
        else:
            assert args.check_evidence is not None
            actual = args.check_evidence.read_text(encoding="utf-8")
            if actual != payload_text:
                raise SystemExit("evidence mismatch")
            print("evidence OK")
        return
    if args.modular_ranks:
        print(
            json.dumps(
                {
                    "schema": "c554-k7-modular-ranks-v1",
                    "ranks": {
                        str(prime): modular_ranks(prime)
                        for prime in (2, 3, 5, 7)
                    },
                },
                sort_keys=True,
                separators=(",", ":"),
            )
        )
        return
    if args.reference:
        print(
            json.dumps(
                {
                    "schema": "c554-k7-reference-v1",
                    "fixed_first": args.fix_first,
                    "search": reference_count(args.fix_first),
                },
                sort_keys=True,
                separators=(",", ":"),
            )
        )
        return
    if args.parity_certificate:
        print(
            json.dumps(
                {
                    "schema": "c554-k7-parity-certificate-v1",
                    "certificate": parity_obstruction(),
                },
                sort_keys=True,
                separators=(",", ":"),
            )
        )
        return
    initial: tuple[int, ...] = ()
    if args.fix_first:
        initial = (
            matching_id(((0, 1), (2, 3), (4, 5))),
        )

    count = 0
    samples: list[dict[str, object]] = []
    stats: dict[str, int] = {}
    for solution in decompositions(
        initial=initial,
        limit=args.limit,
        stats=stats,
    ):
        count += 1
        if len(samples) < args.samples:
            samples.append(summarize(solution))

    print(
        json.dumps(
            {
                "schema": "c554-k7-triangle-decompositions-v1",
                "fixed_first": args.fix_first,
                "limit": args.limit,
                "count": count,
                "complete": args.limit is None or count < args.limit,
                "search": stats,
                "samples": samples,
            },
            sort_keys=True,
            separators=(",", ":"),
        )
    )


if __name__ == "__main__":
    main()
