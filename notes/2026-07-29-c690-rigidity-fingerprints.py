#!/usr/bin/env python3
"""Exact C690 fingerprints for the q=13 obstruction and the twelve-point kill test."""

from __future__ import annotations

import argparse
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-07-29-c690-rigidity-fingerprints.json"


def compose(p: tuple[int, ...], q: tuple[int, ...]) -> tuple[int, ...]:
    """Return p after q."""
    return tuple(p[q[i]] for i in range(len(p)))


def inverse(p: tuple[int, ...]) -> tuple[int, ...]:
    ans = [0] * len(p)
    for i, value in enumerate(p):
        ans[value] = i
    return tuple(ans)


def parity(p: tuple[int, ...]) -> int:
    return sum(p[i] > p[j] for i in range(len(p)) for j in range(i + 1, len(p))) % 2


def powers(g: tuple[int, ...]) -> frozenset[tuple[int, ...]]:
    identity = tuple(range(len(g)))
    ans = {identity}
    value = identity
    while True:
        value = compose(value, g)
        if value in ans:
            return frozenset(ans)
        ans.add(value)


def generated(*generators: tuple[int, ...]) -> frozenset[tuple[int, ...]]:
    identity = tuple(range(len(generators[0])))
    ans = {identity}
    frontier = [identity]
    while frontier:
        value = frontier.pop()
        for generator in generators:
            product = compose(value, generator)
            if product not in ans:
                ans.add(product)
                frontier.append(product)
    return frozenset(ans)


def left_cosets(
    group: tuple[tuple[int, ...], ...], subgroup: frozenset[tuple[int, ...]]
) -> tuple[frozenset[tuple[int, ...]], ...]:
    unseen = set(group)
    ans = []
    while unseen:
        representative = min(unseen)
        coset = frozenset(compose(representative, h) for h in subgroup)
        ans.append(coset)
        unseen -= coset
    return tuple(sorted(ans, key=lambda coset: min(coset)))


def coset_action(
    group: tuple[tuple[int, ...], ...],
    cosets: tuple[frozenset[tuple[int, ...]], ...],
) -> dict[tuple[int, ...], tuple[int, ...]]:
    lookup = {element: i for i, coset in enumerate(cosets) for element in coset}
    representatives = [min(coset) for coset in cosets]
    return {
        g: tuple(lookup[compose(g, representative)] for representative in representatives)
        for g in group
    }


def conjugacy_class(
    group: tuple[tuple[int, ...], ...], representative: tuple[int, ...]
) -> frozenset[tuple[int, ...]]:
    return frozenset(
        compose(compose(g, representative), inverse(g))
        for g in group
    )


def orbit_sizes(permutations: list[tuple[int, ...]], degree: int) -> list[int]:
    unseen = set(range(degree))
    ans = []
    while unseen:
        start = min(unseen)
        orbit = {permutation[start] for permutation in permutations}
        ans.append(len(orbit))
        unseen -= orbit
    return sorted(ans)


def stabilizer_subdegrees(
    action: dict[tuple[int, ...], tuple[int, ...]], point: int
) -> list[int]:
    stabilizer = [permutation for permutation in action.values() if permutation[point] == point]
    return orbit_sizes(stabilizer, len(next(iter(action.values()))))


def orbital_graph(
    action: dict[tuple[int, ...], tuple[int, ...]], point: int
) -> list[set[int]]:
    stabilizer = [permutation for permutation in action.values() if permutation[point] == point]
    orbits = []
    unseen = set(range(len(next(iter(action.values())))))
    while unseen:
        start = min(unseen)
        orbit = {permutation[start] for permutation in stabilizer}
        orbits.append(sorted(orbit))
        unseen -= orbit
    seed_orbit = min(orbit for orbit in orbits if len(orbit) == 5)
    seed = seed_orbit[0]
    adjacency = [set() for _ in range(len(next(iter(action.values()))))]
    for permutation in action.values():
        a, b = permutation[point], permutation[seed]
        adjacency[a].add(b)
        adjacency[b].add(a)
    return adjacency


def graph_fingerprint(adjacency: list[set[int]]) -> dict[str, object]:
    edges = sum(map(len, adjacency)) // 2
    triangles = sum(
        1
        for a in range(len(adjacency))
        for b in adjacency[a]
        if a < b
        for c in adjacency[a] & adjacency[b]
        if b < c
    )
    return {
        "vertices": len(adjacency),
        "edges": edges,
        "degrees": sorted({len(neighbors) for neighbors in adjacency}),
        "triangles": triangles,
        "bipartite": is_bipartite(adjacency),
    }


def is_bipartite(adjacency: list[set[int]]) -> bool:
    colors: dict[int, int] = {}
    for start in range(len(adjacency)):
        if start in colors:
            continue
        colors[start] = 0
        frontier = [start]
        while frontier:
            vertex = frontier.pop()
            for neighbor in adjacency[vertex]:
                if neighbor not in colors:
                    colors[neighbor] = 1 - colors[vertex]
                    frontier.append(neighbor)
                elif colors[neighbor] == colors[vertex]:
                    return False
    return True


def canonical_projective_triples(q: int) -> list[tuple[int, int, int]]:
    ans = []
    for triple in itertools.product(range(q), repeat=3):
        if triple == (0, 0, 0):
            continue
        first = next(value for value in triple if value)
        inv = pow(first, -1, q)
        normalized = tuple(value * inv % q for value in triple)
        if normalized == triple:
            ans.append(triple)
    return ans


def is_nonsquare(value: int, q: int) -> bool:
    return value % q != 0 and pow(value % q, (q - 1) // 2, q) == q - 1


def gf2_rank(rows: list[int]) -> int:
    basis: dict[int, int] = {}
    for row in rows:
        value = row
        while value:
            pivot = value.bit_length() - 1
            if pivot in basis:
                value ^= basis[pivot]
            else:
                basis[pivot] = value
                break
    return len(basis)


def q13_incidence_fingerprint() -> dict[str, object]:
    q = 13
    projective = canonical_projective_triples(q)
    internal = [
        point
        for point in projective
        if is_nonsquare(point[1] * point[1] - point[0] * point[2], q)
    ]
    passants = [
        line
        for line in projective
        if is_nonsquare(line[1] * line[1] - 4 * line[0] * line[2], q)
    ]
    rows = []
    row_weights = []
    for line in passants:
        bits = 0
        for j, point in enumerate(internal):
            if sum(line[i] * point[i] for i in range(3)) % q == 0:
                bits |= 1 << j
        rows.append(bits)
        row_weights.append(bits.bit_count())
    column_weights = [
        sum((row >> j) & 1 for row in rows)
        for j in range(len(internal))
    ]

    line_index = {line: i for i, line in enumerate(passants)}
    polar_order = []
    for x, y, z in internal:
        raw = (z % q, (-2 * y) % q, x % q)
        first = next(value for value in raw if value)
        inv = pow(first, -1, q)
        polar_order.append(line_index[tuple(value * inv % q for value in raw)])
    polarity_symmetric = all(
        ((rows[polar_order[i]] >> j) & 1) == ((rows[polar_order[j]] >> i) & 1)
        for i in range(len(internal))
        for j in range(len(internal))
    )
    rank = gf2_rank(rows)
    return {
        "field": q,
        "conic": "XZ-Y^2=0",
        "internal_points": len(internal),
        "passant_lines": len(passants),
        "row_weights": sorted(set(row_weights)),
        "column_weights": sorted(set(column_weights)),
        "binary_rank": rank,
        "binary_nullity": len(internal) - rank,
        "polarity_reindexing_is_symmetric": polarity_symmetric,
        "terminal_support_weight": 8,
    }


def a5_fingerprints() -> dict[str, object]:
    group = tuple(
        permutation
        for permutation in itertools.permutations(range(5))
        if parity(permutation) == 0
    )
    identity = tuple(range(5))
    five_cycle = (1, 2, 3, 4, 0)
    reflection = (0, 4, 3, 2, 1)
    c5 = powers(five_cycle)
    d5 = generated(five_cycle, reflection)
    assert len(group) == 60 and len(c5) == 5 and len(d5) == 10

    c5_cosets = left_cosets(group, c5)
    d5_cosets = left_cosets(group, d5)
    paper_action = coset_action(group, c5_cosets)
    six_action = coset_action(group, d5_cosets)

    involution = next(g for g in group if len(powers(g)) == 2)
    three_cycle = next(g for g in group if len(powers(g)) == 3)
    five_a = conjugacy_class(group, five_cycle)
    five_b_representative = next(g for g in group if len(powers(g)) == 5 and g not in five_a)
    representatives = [
        ("1A", identity),
        ("2A", involution),
        ("3A", three_cycle),
        ("5A", five_cycle),
        ("5B", five_b_representative),
    ]
    class_sizes = {
        label: len(conjugacy_class(group, representative))
        for label, representative in representatives
    }
    paper_character = {
        label: sum(i == image for i, image in enumerate(paper_action[representative]))
        for label, representative in representatives
    }
    six_character = {
        label: sum(i == image for i, image in enumerate(six_action[representative]))
        for label, representative in representatives
    }
    double_character = {label: 2 * value for label, value in six_character.items()}

    paper_graph = orbital_graph(paper_action, 0)
    double_graph = [set() for _ in range(12)]
    for i in range(6):
        for j in range(6):
            if i != j:
                double_graph[i].add(6 + j)
                double_graph[6 + j].add(i)

    return {
        "class_sizes": class_sizes,
        "paper_I": {
            "a5_set": "A5/C5",
            "orbit_sizes": orbit_sizes(list(paper_action.values()), 12),
            "character": paper_character,
            "stabilizer_subdegrees": stabilizer_subdegrees(paper_action, 0),
            "icosahedral_five_orbital": graph_fingerprint(paper_graph),
        },
        "schlafli_double_six": {
            "a5_set": "(A5/D5) disjoint_union (A5/D5)",
            "orbit_sizes": [6, 6],
            "character": double_character,
            "one_row_character": six_character,
            "stabilizer_subdegrees_on_twelve_lines": [1, 1, 5, 5],
            "intersection_graph": graph_fingerprint(double_graph),
        },
        "equivariant_identification": False,
        "first_character_mismatch": "2A",
    }


def build_result() -> dict[str, object]:
    return {
        "schema": "c690-rigidity-fingerprints-v1",
        "q13_passant_internal_incidence": q13_incidence_fingerprint(),
        "twelve_point_kill_test": a5_fingerprints(),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(build_result(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        return
    if not OUTPUT.exists() or OUTPUT.read_text() != rendered:
        raise SystemExit(f"{OUTPUT.name} is stale; run with --write")
    print("C690 rigidity fingerprints: OK")


if __name__ == "__main__":
    main()
