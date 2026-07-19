#!/usr/bin/env python3
"""Independent direct replay for the C295 q=11 certificate.

This implementation parameterizes the conic directly, generates candidate
blocks by five-edge combinations rather than recursive matching extension,
and counts covers one antipodal port pair at a time.  It also computes the
stable 2-WL pair colours and the icosahedral intersection array.
"""

from __future__ import annotations

import hashlib
import json
from collections import Counter
from itertools import combinations
from pathlib import Path

Q = 11
ARC = (
    (1, 10, 0), (1, 9, 1), (1, 4, 7),
    (1, 8, 5), (0, 1, 4), (1, 1, 7),
)


def det(a, b, c):
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % Q


def graph():
    conic = ((0, 0, 1),) + tuple((1, t, t * t % Q) for t in range(Q))
    conic = tuple(sorted(conic))
    blocks = []
    for centre in ARC:
        block = tuple(
            (i, j) for i, j in combinations(range(12), 2)
            if det(centre, conic[i], conic[j]) == 0
        )
        assert len(block) == 5
        blocks.append(block)
    edges = tuple(sorted({edge for block in blocks for edge in block}))
    return conic, tuple(sorted(blocks)), edges


def distances(edges):
    neighbours = {v: set() for v in range(12)}
    for u, v in edges:
        neighbours[u].add(v)
        neighbours[v].add(u)
    distance = {}
    for source in range(12):
        queue = [source]
        distance[source, source] = 0
        for vertex in queue:
            for target in neighbours[vertex]:
                if (source, target) not in distance:
                    distance[source, target] = distance[source, vertex] + 1
                    queue.append(target)
    return neighbours, distance


def direct_candidates(edges, distance):
    candidates = []
    for chosen in combinations(edges, 5):
        vertices = [v for edge in chosen for v in edge]
        if len(set(vertices)) != 10:
            continue
        ports = tuple(v for v in range(12) if v not in vertices)
        if distance[ports] == 3:
            candidates.append((tuple(chosen), ports))
    return tuple(candidates)


def direct_decompositions(edges, candidates):
    edge_index = {edge: i for i, edge in enumerate(edges)}
    full = (1 << 30) - 1
    by_ports = {}
    for block, ports in candidates:
        mask = sum(1 << edge_index[edge] for edge in block)
        by_ports.setdefault(ports, []).append((block, mask))
    port_pairs = tuple(sorted(by_ports))
    assert len(port_pairs) == 6
    answers = set()

    def visit(index, used, chosen):
        if index == 6:
            if used == full:
                answers.add(tuple(sorted(chosen)))
            return
        for block, mask in by_ports[port_pairs[index]]:
            if not mask & used:
                visit(index + 1, used | mask, chosen + [block])

    visit(0, 0, [])
    return tuple(sorted(answers))


def wl2(edges):
    edge_set = set(edges)
    colours = {
        (u, v): 0 if u == v else 1 if tuple(sorted((u, v))) in edge_set else 2
        for u in range(12) for v in range(12)
    }
    while True:
        signatures = {}
        for u in range(12):
            for v in range(12):
                pairs = Counter((colours[u, w], colours[w, v]) for w in range(12))
                signatures[u, v] = (colours[u, v], tuple(sorted(pairs.items())))
        palette = {signature: i for i, signature in enumerate(sorted(set(signatures.values())))}
        refined = {pair: palette[signature] for pair, signature in signatures.items()}
        if all(refined[pair] == colours[pair] for pair in colours):
            return colours
        # Canonicalize both old and new colour names before the stability test.
        if all(
            (colours[a] == colours[b]) == (refined[a] == refined[b])
            for a in colours for b in colours
        ):
            return refined
        colours = refined


def main():
    tracked = Path(__file__).with_name("2026-07-17-c295-intrinsic-continuation-reconstruction.json")
    expected = json.loads(tracked.read_text())
    _, geometric_blocks, edges = graph()
    neighbours, distance = distances(edges)
    assert len(edges) == 30
    assert {len(neighbours[v]) for v in neighbours} == {5}
    assert Counter(distance[0, v] for v in range(12)) == Counter({0: 1, 1: 5, 2: 5, 3: 1})

    candidates = direct_candidates(edges, distance)
    decomps = direct_decompositions(edges, candidates)
    encoded = json.dumps(decomps, separators=(",", ":")).encode()
    assert len(candidates) == expected["candidate_five_matchings_antipodal_ports"] == 132
    assert len(decomps) == expected["antipodal_matching_port_decompositions"] == 636
    assert hashlib.sha256(encoded).hexdigest() == expected["canonical_decomposition_set_sha256"]
    assert tuple(sorted(geometric_blocks)) in decomps

    edge_set = set(edges)
    face_counts = Counter()
    for size in range(13):
        for vertices in combinations(range(12), size):
            if all(tuple(sorted(pair)) not in edge_set for pair in combinations(vertices, 2)):
                face_counts[size] += 1
    assert {str(k): face_counts[k] for k in face_counts} == expected[
        "simultaneous_extension_face_counts_by_size"
    ]
    assert max(face_counts) == expected["maximum_simultaneous_extension_size"]

    colours = wl2(edges)
    colour_by_distance = {}
    for pair, colour in colours.items():
        colour_by_distance.setdefault(distance[pair], set()).add(colour)
    assert {d: len(values) for d, values in colour_by_distance.items()} == {0: 1, 1: 1, 2: 1, 3: 1}

    # The distance-regular intersection array is {5,2,1;1,2,5}.
    b = []
    c = []
    root = 0
    for layer in range(3):
        vertex = next(v for v in range(12) if distance[root, v] == layer)
        b.append(sum(distance[root, w] == layer + 1 for w in neighbours[vertex]))
    for layer in range(1, 4):
        vertex = next(v for v in range(12) if distance[root, v] == layer)
        c.append(sum(distance[root, w] == layer - 1 for w in neighbours[vertex]))
    assert b == [5, 2, 1] and c == [1, 2, 5]

    # One-dimensional WL cannot identify the graph: this nonisomorphic foil
    # K_6,6 minus a perfect matching is also 5-regular on twelve vertices.
    foil = {
        tuple(sorted((u, 6 + v)))
        for u in range(6) for v in range(6) if u != v
    }
    assert len(foil) == 30
    assert all(sum(vertex in edge for edge in foil) == 5 for vertex in range(12))
    assert any(
        all(tuple(sorted((a, b))) in set(edges) for a, b in combinations(triple, 2))
        for triple in combinations(range(12), 3)
    )
    assert not any(
        all(tuple(sorted((a, b))) in foil for a, b in combinations(triple, 2))
        for triple in combinations(range(12), 3)
    )

    print(
        "replayed candidates=132 decompositions=636 "
        "wl_dimension=2 intersection_array={5,2,1;1,2,5}"
    )


if __name__ == "__main__":
    main()
