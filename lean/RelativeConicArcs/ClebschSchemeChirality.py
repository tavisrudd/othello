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


def mat_vec(matrix: tuple[tuple[int, ...], ...], vector: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(sum(row[j] * vector[j] for j in range(3)) % Q for row in matrix)


def mat_mul(
    left: tuple[tuple[int, ...], ...], right: tuple[tuple[int, ...], ...]
) -> tuple[tuple[int, ...], ...]:
    return tuple(
        tuple(sum(left[i][k] * right[k][j] for k in range(3)) % Q for j in range(3))
        for i in range(3)
    )


def mat_inverse(matrix: tuple[tuple[int, ...], ...]) -> tuple[tuple[int, ...], ...]:
    augmented = [list(row) + [int(i == j) for j in range(3)] for i, row in enumerate(matrix)]
    for column in range(3):
        pivot = next(row for row in range(column, 3) if augmented[row][column] % Q)
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        scale = pow(augmented[column][column], -1, Q)
        augmented[column] = [scale * value % Q for value in augmented[column]]
        for row in range(3):
            if row != column:
                scale = augmented[row][column]
                augmented[row] = [
                    (a - scale * b) % Q for a, b in zip(augmented[row], augmented[column])
                ]
    return tuple(tuple(row[3:]) for row in augmented)


def normalize(vector: tuple[int, ...]) -> tuple[int, ...]:
    pivot = next(value for value in vector if value % Q)
    scale = pow(pivot, -1, Q)
    return tuple(scale * value % Q for value in vector)


def frame_transport(targets: tuple[tuple[int, ...], ...]) -> tuple[tuple[int, ...], ...]:
    sources = DIRECTIONS[:4]
    source_basis = tuple(tuple(sources[j][i] for j in range(3)) for i in range(3))
    target_basis = tuple(tuple(targets[j][i] for j in range(3)) for i in range(3))
    source_inverse = mat_inverse(source_basis)
    source_coordinates = mat_vec(source_inverse, sources[3])
    target_coordinates = mat_vec(mat_inverse(target_basis), targets[3])
    diagonal = tuple(
        tuple((target_coordinates[i] * pow(source_coordinates[i], -1, Q)) % Q if i == j else 0
              for j in range(3))
        for i in range(3)
    )
    return mat_mul(mat_mul(target_basis, diagonal), source_inverse)


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

    frame_candidates = []
    for target_indices in itertools.permutations(range(6), 4):
        matrix = frame_transport(tuple(DIRECTIONS[i] for i in target_indices))
        assert tuple(normalize(mat_vec(matrix, DIRECTIONS[i])) for i in range(4)) == tuple(
            DIRECTIONS[i] for i in target_indices
        )
        frame_candidates.append(matrix)
    assert len(frame_candidates) == 360 and len(set(frame_candidates)) == 360
    projective_stabilizer = {
        matrix
        for matrix in frame_candidates
        if {normalize(mat_vec(matrix, point)) for point in DIRECTIONS} == set(DIRECTIONS)
    }
    assert len(projective_stabilizer) == 60

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
        "projective_stabilizer_order": len(projective_stabilizer),
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
