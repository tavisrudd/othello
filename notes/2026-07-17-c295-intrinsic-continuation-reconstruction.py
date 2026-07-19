#!/usr/bin/env python3
"""Exact q=11 matching/port decomposition census for C295.

The input graph is constructed from the Clebsch six-arc and the twelve points
of the standard conic over F_11.  The census then forgets all coordinates and
enumerates every partition of the graph's edges into six five-edge matchings
whose two-vertex port sets partition the twelve vertices.

No third-party package is used.  Output is canonical JSON.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from itertools import combinations, product
from pathlib import Path

Q = 11
ARC = (
    (1, 10, 0),
    (1, 9, 1),
    (1, 4, 7),
    (1, 8, 5),
    (0, 1, 4),
    (1, 1, 7),
)
Point = tuple[int, int, int]
Edge = tuple[int, int]
Block = tuple[Edge, ...]
Decomposition = tuple[Block, ...]


def normalize(vector: Point) -> Point:
    pivot = next(x % Q for x in vector if x % Q)
    inverse = pow(pivot, -1, Q)
    return tuple(x * inverse % Q for x in vector)  # type: ignore[return-value]


def determinant(a: Point, b: Point, c: Point) -> int:
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % Q


def cross(a: Point, b: Point) -> Point:
    return normalize(
        (
            a[1] * b[2] - a[2] * b[1],
            a[2] * b[0] - a[0] * b[2],
            a[0] * b[1] - a[1] * b[0],
        )
    )


def dot(a: Point, b: Point) -> int:
    return sum(x * y for x, y in zip(a, b)) % Q


def projective_points() -> tuple[Point, ...]:
    return tuple(
        sorted(
            {
                normalize(v)
                for v in product(range(Q), repeat=3)
                if v != (0, 0, 0)
            }
        )
    )


def geometry() -> tuple[tuple[Point, ...], tuple[Block, ...], tuple[Edge, ...]]:
    conic = tuple(
        p for p in projective_points()
        if (p[0] * p[2] - p[1] * p[1]) % Q == 0
    )
    assert len(conic) == 12
    blocks: list[Block] = []
    for centre in ARC:
        block = tuple(
            (i, j)
            for i, j in combinations(range(12), 2)
            if determinant(centre, conic[i], conic[j]) == 0
        )
        assert len(block) == 5
        assert len({v for edge in block for v in edge}) == 10
        blocks.append(block)
    edges = tuple(sorted({edge for block in blocks for edge in block}))
    assert sum(len(block) for block in blocks) == len(edges) == 30
    degrees = Counter(v for edge in edges for v in edge)
    assert set(degrees.values()) == {5}
    return conic, tuple(sorted(blocks)), edges


def matching_blocks(edges: tuple[Edge, ...]) -> tuple[tuple[Block, tuple[int, int]], ...]:
    adjacency: dict[int, list[int]] = {v: [] for v in range(12)}
    for index, (u, v) in enumerate(edges):
        adjacency[u].append(index)
        adjacency[v].append(index)
    found: set[Block] = set()

    def extend(chosen: list[Edge], used: set[int], start: int) -> None:
        if len(chosen) == 5:
            found.add(tuple(sorted(chosen)))
            return
        needed = 2 * (5 - len(chosen))
        available = [v for v in range(start, 12) if v not in used]
        if len(available) < needed:
            return
        u = available[0]
        # A maximum matching may leave u as a port.
        extend(chosen, used, u + 1)
        for edge_index in adjacency[u]:
            edge = edges[edge_index]
            v = edge[1] if edge[0] == u else edge[0]
            if v not in used:
                extend(chosen + [edge], used | {u, v}, u + 1)

    extend([], set(), 0)
    result = []
    for block in sorted(found):
        covered = {v for edge in block for v in edge}
        ports = tuple(v for v in range(12) if v not in covered)
        assert len(ports) == 2
        result.append((block, ports))
    return tuple(result)


def decompositions(
    edges: tuple[Edge, ...], candidates: tuple[tuple[Block, tuple[int, int]], ...]
) -> tuple[Decomposition, ...]:
    edge_index = {edge: i for i, edge in enumerate(edges)}
    full_mask = (1 << len(edges)) - 1
    block_masks = [sum(1 << edge_index[e] for e in block) for block, _ in candidates]
    port_masks = [sum(1 << v for v in ports) for _, ports in candidates]
    by_edge: list[list[int]] = [[] for _ in edges]
    for i, mask in enumerate(block_masks):
        for edge_i in range(len(edges)):
            if mask >> edge_i & 1:
                by_edge[edge_i].append(i)
    answers: set[Decomposition] = set()

    def visit(edge_mask: int, port_mask: int, chosen: list[int]) -> None:
        if edge_mask == full_mask:
            assert len(chosen) == 6 and port_mask == (1 << 12) - 1
            answers.add(tuple(sorted(candidates[i][0] for i in chosen)))
            return
        if len(chosen) == 6:
            return
        uncovered = [i for i in range(len(edges)) if not (edge_mask >> i & 1)]
        edge_i = min(
            uncovered,
            key=lambda j: sum(
                not (block_masks[i] & edge_mask) and not (port_masks[i] & port_mask)
                for i in by_edge[j]
            ),
        )
        for candidate_i in by_edge[edge_i]:
            if block_masks[candidate_i] & edge_mask:
                continue
            if port_masks[candidate_i] & port_mask:
                continue
            visit(
                edge_mask | block_masks[candidate_i],
                port_mask | port_masks[candidate_i],
                chosen + [candidate_i],
            )

    visit(0, 0, [])
    return tuple(sorted(answers))


def graph_distances(edges: tuple[Edge, ...]) -> dict[tuple[int, int], int]:
    neighbours = {v: set() for v in range(12)}
    for u, v in edges:
        neighbours[u].add(v)
        neighbours[v].add(u)
    result: dict[tuple[int, int], int] = {}
    for source in range(12):
        queue = [source]
        result[source, source] = 0
        for vertex in queue:
            for target in neighbours[vertex]:
                if (source, target) not in result:
                    result[source, target] = result[source, vertex] + 1
                    queue.append(target)
    return result


def graph_automorphisms(edges: tuple[Edge, ...]) -> tuple[tuple[int, ...], ...]:
    edge_set = set(edges)
    neighbours = {
        v: {w for edge in edges if v in edge for w in edge if w != v}
        for v in range(12)
    }
    order = sorted(range(12), key=lambda v: (-len(neighbours[v]), v))
    answers: list[tuple[int, ...]] = []

    def visit(mapping: dict[int, int], used: set[int]) -> None:
        if len(mapping) == 12:
            permutation = tuple(mapping[v] for v in range(12))
            assert {
                tuple(sorted((permutation[u], permutation[v]))) for u, v in edges
            } == edge_set
            answers.append(permutation)
            return
        source = max(
            (v for v in order if v not in mapping),
            key=lambda v: (sum(w in mapping for w in neighbours[v]), -v),
        )
        for target in range(12):
            if target in used:
                continue
            if all(
                ((min(target, mapping[w]), max(target, mapping[w])) in edge_set)
                == (w in neighbours[source])
                for w in mapping
            ):
                visit(mapping | {source: target}, used | {target})

    visit({}, set())
    return tuple(sorted(answers))


def permute_decomposition(decomposition: Decomposition, permutation: tuple[int, ...]) -> Decomposition:
    return tuple(
        sorted(
            tuple(
                sorted(
                    tuple(sorted((permutation[u], permutation[v])))
                    for u, v in block
                )
            )
            for block in decomposition
        )
    )


def decomposition_orbits(
    decomps: tuple[Decomposition, ...], automorphisms: tuple[tuple[int, ...], ...]
) -> tuple[tuple[Decomposition, ...], ...]:
    remaining = set(decomps)
    orbits = []
    while remaining:
        seed = min(remaining)
        orbit = {permute_decomposition(seed, p) for p in automorphisms}
        assert orbit <= set(decomps)
        orbits.append(tuple(sorted(orbit)))
        remaining -= orbit
    return tuple(orbits)


def concurrency_point(block: Block, conic: tuple[Point, ...]) -> Point | None:
    first = cross(conic[block[0][0]], conic[block[0][1]])
    second = cross(conic[block[1][0]], conic[block[1][1]])
    point = cross(first, second)
    if all(dot(cross(conic[u], conic[v]), point) == 0 for u, v in block):
        return point
    return None


def result() -> dict[str, object]:
    conic, geometric_blocks, edges = geometry()
    all_candidates = matching_blocks(edges)
    distances = graph_distances(edges)
    antipodal_pairs = tuple(
        (u, v) for u, v in combinations(range(12), 2) if distances[u, v] == 3
    )
    assert len(antipodal_pairs) == 6
    assert len({v for pair in antipodal_pairs for v in pair}) == 12
    candidates = tuple(
        candidate for candidate in all_candidates
        if distances[candidate[1][0], candidate[1][1]] == 3
    )
    decomps = decompositions(edges, candidates)
    automorphisms = graph_automorphisms(edges)
    orbits = decomposition_orbits(decomps, automorphisms)
    geometric_decomposition = tuple(sorted(geometric_blocks))
    assert geometric_decomposition in decomps
    edge_set = set(edges)
    independent_counts = Counter()
    for mask in range(1 << 12):
        vertices = [v for v in range(12) if mask >> v & 1]
        if all(tuple(sorted(pair)) not in edge_set for pair in combinations(vertices, 2)):
            independent_counts[len(vertices)] += 1

    concurrent_histogram = Counter()
    fully_geometric = []
    for decomposition in decomps:
        points = [concurrency_point(block, conic) for block in decomposition]
        count = sum(point is not None for point in points)
        concurrent_histogram[count] += 1
        if count == 6:
            centres = tuple(sorted(point for point in points if point is not None))
            fully_geometric.append((decomposition, centres))

    orbit_sizes = sorted(len(orbit) for orbit in orbits)
    geometric_orbit = next(i for i, orbit in enumerate(orbits) if geometric_decomposition in orbit)
    decomposition_bytes = json.dumps(decomps, separators=(",", ":")).encode()
    return {
        "schema": "c295-q11-matching-port-v1",
        "field_order": Q,
        "vertex_count": len(conic),
        "edge_count": len(edges),
        "degree_multiset": sorted(Counter(v for e in edges for v in e).values()),
        "simultaneous_extension_face_counts_by_size": {
            str(k): independent_counts[k] for k in sorted(independent_counts)
        },
        "maximum_simultaneous_extension_size": max(independent_counts),
        "candidate_five_matchings_all_port_pairs": len(all_candidates),
        "candidate_five_matchings_antipodal_ports": len(candidates),
        "antipodal_port_pairs": [list(pair) for pair in antipodal_pairs],
        "antipodal_matching_port_decompositions": len(decomps),
        "graph_automorphism_order": len(automorphisms),
        "decomposition_orbit_count": len(orbits),
        "decomposition_orbit_sizes": orbit_sizes,
        "geometric_decomposition_orbit_index": geometric_orbit,
        "geometric_decomposition_orbit_size": len(orbits[geometric_orbit]),
        "geometric_decomposition_stabilizer_order": (
            len(automorphisms) // len(orbits[geometric_orbit])
        ),
        "canonical_decomposition_set_sha256": hashlib.sha256(decomposition_bytes).hexdigest(),
        "concurrent_block_count_histogram": {
            str(k): concurrent_histogram[k] for k in sorted(concurrent_histogram)
        },
        "fully_geometric_decomposition_count": len(fully_geometric),
        "geometric_centre_set_count": len({centres for _, centres in fully_geometric}),
        "geometric_decomposition": [
            [[u, v] for u, v in block] for block in geometric_decomposition
        ],
        "geometric_ports": [
            [v for v in range(12) if v not in {x for edge in block for x in edge}]
            for block in geometric_decomposition
        ],
        "conic_points": [list(point) for point in conic],
        "arc_centres": [list(normalize(point)) for point in ARC],
    }


def encode(payload: dict[str, object]) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    tracked = Path(__file__).with_suffix(".json")
    payload = encode(result())
    if args.check:
        if not tracked.exists() or tracked.read_bytes() != payload:
            raise SystemExit("tracked JSON is stale")
        print(f"checked {tracked} sha256={hashlib.sha256(payload).hexdigest()}")
    elif args.output:
        args.output.write_bytes(payload)
    else:
        print(payload.decode(), end="")


if __name__ == "__main__":
    main()
