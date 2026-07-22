#!/usr/bin/env python3
"""Recompute the finite six-block and three-subset chirality certificate."""

from __future__ import annotations

import argparse
import itertools
import json
from pathlib import Path

Q = 11
DIRECTIONS = ((0, 1, 4), (0, 1, 7), (1, 0, 3), (1, 0, 8), (1, 4, 0), (1, 7, 0))
GENERATORS = ((0, 1, 3, 2, 5, 4), (1, 2, 0, 5, 3, 4))
SHEET_EXCHANGE = (0, 1, 4, 5, 3, 2)


def compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[i]] for i in range(6))


def inverse(permutation: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(permutation.index(i) for i in range(6))


def closure(generators: tuple[tuple[int, ...], ...]) -> set[tuple[int, ...]]:
    result = {tuple(range(6))}
    frontier = list(generators)
    while frontier:
        element = frontier.pop()
        if element in result:
            continue
        result.add(element)
        frontier.extend(compose(element, generator) for generator in generators)
    return result


def act(permutation: tuple[int, ...], subset: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(sorted(permutation[i] for i in subset))


def certificate() -> dict[str, object]:
    neighbors = tuple(
        tuple(scale * coordinate % Q for coordinate in direction)
        for direction in DIRECTIONS
        for scale in range(1, Q)
    )
    assert len(set(neighbors)) == 60
    neighbor_set = set(neighbors)
    adjacency = {
        (i, j)
        for i, left in enumerate(neighbors)
        for j, right in enumerate(neighbors)
        if i != j and tuple((a - b) % Q for a, b in zip(left, right)) in neighbor_set
    }
    components = []
    unseen = set(range(60))
    while unseen:
        seed = min(unseen)
        component = {seed} | {j for i, j in adjacency if i == seed}
        assert all(i == j or (i, j) in adjacency for i in component for j in component)
        unseen -= component
        components.append(sorted(component))
    assert sorted(map(len, components)) == [10] * 6

    group = closure(GENERATORS)
    assert len(group) == 60
    triples = tuple(itertools.combinations(range(6), 3))
    unseen_triples = set(triples)
    orbits = []
    while unseen_triples:
        seed = min(unseen_triples)
        orbit = {act(element, seed) for element in group}
        unseen_triples -= orbit
        orbits.append(sorted(orbit))
    assert sorted(map(len, orbits)) == [10, 10]

    conjugate = {
        compose(compose(SHEET_EXCHANGE, element), inverse(SHEET_EXCHANGE)) for element in group
    }
    assert conjugate == group and SHEET_EXCHANGE not in group
    assert {act(SHEET_EXCHANGE, triple) for triple in orbits[0]} == set(orbits[1])

    return {
        "schema": "clebsch-scheme-chirality-1",
        "field_order": Q,
        "neighbor_domain_size": 60,
        "neighbor_component_sizes": sorted(map(len, components)),
        "block_action_order": len(group),
        "three_subset_domain_size": len(triples),
        "three_subset_orbit_sizes": sorted(map(len, orbits)),
        "normalizing_element_exchanges_orbits": True,
        "normalizing_element_outside_block_action": True,
        "projective_frame_candidate_bound": 360,
        "lean_boundary": (
            "The Lean module checks the displayed finite directions, adjacency components, "
            "triple enumeration, generator orbits, and one sheet exchange. Identification with "
            "the 1331-vertex scheme and automorphism-group completeness remain external."
        ),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    path = Path(__file__).with_suffix(".json")
    computed = certificate()
    if args.check:
        recorded = json.loads(path.read_text())
        if recorded != computed:
            raise SystemExit("certificate mismatch")
        print("Clebsch scheme chirality certificate: OK")
    else:
        print(json.dumps(computed, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
