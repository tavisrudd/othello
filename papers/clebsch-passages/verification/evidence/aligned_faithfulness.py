#!/usr/bin/env python3
"""Exhaustive certificate for aligned-design faithfulness and its sharpness.

A two-graph on a finite set is represented by the unique graph in its switching
class in which the vertex ``0`` is isolated, so the two-graphs on ``n`` points
are enumerated by the graphs on ``{1, ..., n-1}``.  For such a representative
``G`` the triple function is the edge parity

    tau(S) = |{edges of G inside S}| mod 2,

and the aligned family ``A(tau)`` collects the four-sets on which all four
triple values agree.  The certificate records the fibres of ``tau -> A(tau)``
at four, five, six and seven points, the manuscript's six-point witness pair,
and the seven-point switching witness that separates the aligned hypothesis
from graph four-hypomorphy.
"""

from __future__ import annotations

import argparse
import json
from collections import defaultdict
from itertools import combinations
from pathlib import Path


OUTPUT = Path(__file__).with_suffix(".json")

# The manuscript's six-point witness, as printed in the sharpness remark.
WITNESS_G = ((1, 2), (1, 5), (2, 4), (2, 5), (3, 5))
WITNESS_H = ((1, 3), (1, 4), (2, 4), (3, 4), (3, 5))


def triple_parity(edges: frozenset[tuple[int, int]], triple: tuple[int, ...]) -> int:
    return sum(1 for pair in combinations(triple, 2) if pair in edges) % 2


def two_graph(edges: frozenset[tuple[int, int]], points: int) -> tuple[int, ...]:
    return tuple(
        triple_parity(edges, triple)
        for triple in combinations(range(points), 3)
    )


def aligned_family(values: tuple[int, ...], points: int) -> frozenset[int]:
    index = {triple: i for i, triple in enumerate(combinations(range(points), 3))}
    aligned = set()
    for position, quad in enumerate(combinations(range(points), 4)):
        marks = {values[index[triple]] for triple in combinations(quad, 3)}
        if len(marks) == 1:
            aligned.add(position)
    return frozenset(aligned)


def complement(values: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(1 - value for value in values)


def all_representatives(points: int) -> list[frozenset[tuple[int, int]]]:
    """Every graph on ``{1, ..., points-1}``: one per switching class."""
    pairs = list(combinations(range(1, points), 2))
    representatives = []
    for mask in range(1 << len(pairs)):
        representatives.append(
            frozenset(pair for i, pair in enumerate(pairs) if mask >> i & 1)
        )
    return representatives


def level(points: int) -> dict[str, object]:
    fibres: dict[frozenset[int], list[tuple[int, ...]]] = defaultdict(list)
    for edges in all_representatives(points):
        values = two_graph(edges, points)
        fibres[aligned_family(values, points)].append(values)

    sizes = sorted({len(members) for members in fibres.values()})
    faithful = sizes == [2] and all(
        complement(members[0]) == members[1] for members in fibres.values()
    )
    return {
        "points": points,
        "two_graphs": 1 << len(list(combinations(range(1, points), 2))),
        "aligned_families": len(fibres),
        "class_sizes": sizes,
        "fibres_are_complement_pairs": faithful,
        "determines_up_to_complement": faithful,
    }


def six_point_witness() -> dict[str, object]:
    g_edges = frozenset(WITNESS_G)
    h_edges = frozenset(WITNESS_H)
    g_values = two_graph(g_edges, 6)
    h_values = two_graph(h_edges, 6)
    quads = list(combinations(range(6), 4))
    shared = aligned_family(g_values, 6)

    assert shared == aligned_family(h_values, 6)
    assert h_values != g_values
    assert h_values != complement(g_values)

    return {
        "graph_G": [list(edge) for edge in sorted(g_edges)],
        "graph_H": [list(edge) for edge in sorted(h_edges)],
        "shared_aligned_family": [list(quads[i]) for i in sorted(shared)],
        "distinct_two_graphs": True,
        "not_complementary": True,
    }


def induced_four_vertex_type(edges: frozenset[tuple[int, int]], quad: tuple[int, ...]) -> tuple[int, ...]:
    """Degree sequence of the induced subgraph: enough to separate the witness."""
    degrees = sorted(
        sum(1 for other in quad if other != vertex and tuple(sorted((vertex, other))) in edges)
        for vertex in quad
    )
    return tuple(degrees)


def switching_witness() -> dict[str, object]:
    """Seven points: the empty graph against its switch at one vertex.

    Both lie in one switching class, so they share a two-graph and therefore an
    aligned family; their induced four-vertex subgraphs differ on most
    four-sets, so they are not four-hypomorphic in the graph sense.
    """
    points = 7
    empty: frozenset[tuple[int, int]] = frozenset()
    star = frozenset((0, other) for other in range(1, points))

    empty_values = two_graph(empty, points)
    star_values = two_graph(star, points)
    assert empty_values == star_values

    quads = list(combinations(range(points), 4))
    differing = [
        quad
        for quad in quads
        if induced_four_vertex_type(empty, quad) != induced_four_vertex_type(star, quad)
    ]
    return {
        "points": points,
        "same_two_graph": True,
        "same_aligned_family": aligned_family(empty_values, points)
        == aligned_family(star_values, points),
        "four_sets": len(quads),
        "four_sets_with_differing_induced_type": len(differing),
    }


def generate() -> dict[str, object]:
    levels = [level(points) for points in (4, 5, 6, 7)]
    for entry in levels:
        assert entry["determines_up_to_complement"] == (entry["points"] >= 7)

    return {
        "theorem": (
            "for at least seven points the aligned family determines the "
            "two-graph up to complement; six points do not suffice, so seven "
            "is sharp"
        ),
        "representation": (
            "two-graphs are enumerated by the graphs on {1, ..., n-1}, one per "
            "switching class, with tau the edge parity on triples"
        ),
        "levels": levels,
        "six_point_witness": six_point_witness(),
        "switching_witness": switching_witness(),
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()

    payload = canonical_bytes(generate())
    if args.write:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT}")
        return
    if not OUTPUT.exists() or OUTPUT.read_bytes() != payload:
        raise SystemExit("aligned faithfulness certificate is stale")
    print("aligned faithfulness certificate: OK")


if __name__ == "__main__":
    main()
