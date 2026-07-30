#!/usr/bin/env python3
"""Exact tangent-triple certificate for the C611 q=13 distance-ten gate."""

from __future__ import annotations

import argparse
import itertools
import json
import tempfile
from collections import Counter
from functools import cache
from pathlib import Path


Q = 13
HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-07-29-c611-q13-tangent-triples.json"


def canonical(vector: tuple[int, ...]) -> tuple[int, ...]:
    first = next(value for value in vector if value % Q)
    inverse = pow(first, -1, Q)
    return tuple(value * inverse % Q for value in vector)


def projective_vectors(dimension: int) -> list[tuple[int, ...]]:
    return [
        vector
        for vector in itertools.product(range(Q), repeat=dimension)
        if vector != (0,) * dimension and canonical(vector) == vector
    ]


SQUARES = {value * value % Q for value in range(1, Q)}


def character(value: int) -> int:
    value %= Q
    if value == 0:
        return 0
    return 1 if value in SQUARES else -1


def dot(line: tuple[int, int, int], point: tuple[int, int, int]) -> int:
    return sum(a * b for a, b in zip(line, point)) % Q


PROJECTIVE = projective_vectors(3)
INTERNAL = [
    point
    for point in PROJECTIVE
    if character(point[1] * point[1] - point[0] * point[2]) == -1
]
PASSANTS = [
    line
    for line in PROJECTIVE
    if character(line[1] * line[1] - 4 * line[0] * line[2]) == -1
]
SECANTS = [
    line
    for line in PROJECTIVE
    if character(line[1] * line[1] - 4 * line[0] * line[2]) == 1
]


@cache
def is_passant_join(
    first: tuple[int, int, int], second: tuple[int, int, int]
) -> bool:
    return any(
        dot(line, first) == 0 and dot(line, second) == 0 for line in PASSANTS
    )


@cache
def tangent_value(
    point: tuple[int, int, int], argument: tuple[int, int, int]
) -> int:
    """Evaluate the product of the seven conic-secants through point."""
    value = 1
    factors = 0
    for line in SECANTS:
        if dot(line, point) == 0:
            value = value * dot(line, argument) % Q
            factors += 1
    assert factors == 7
    return value


@cache
def edge_ratio(
    first: tuple[int, int, int], second: tuple[int, int, int]
) -> int:
    numerator = tangent_value(first, second)
    denominator = tangent_value(second, first)
    assert numerator and denominator
    return numerator * pow(denominator, -1, Q) % Q


def holonomy(
    first: tuple[int, int, int],
    second: tuple[int, int, int],
    third: tuple[int, int, int],
) -> int:
    return (
        edge_ratio(first, second)
        * edge_ratio(second, third)
        * edge_ratio(third, first)
        % Q
    )


def symmetric_square_action(
    matrix: tuple[int, int, int, int], point: tuple[int, int, int]
) -> tuple[int, int, int]:
    a, b, c, d = matrix
    x, y, z = point
    return canonical(
        (
            (a * a * x + 2 * a * b * y + b * b * z) % Q,
            (a * c * x + (a * d + b * c) * y + b * d * z) % Q,
            (c * c * x + 2 * c * d * y + d * d * z) % Q,
        )
    )


def permutation_order(
    matrix: tuple[int, int, int, int], points: list[tuple[int, int, int]]
) -> int:
    permutation = [
        points.index(symmetric_square_action(matrix, point)) for point in points
    ]
    current = list(range(len(points)))
    order = 0
    while True:
        current = [permutation[index] for index in current]
        order += 1
        if current == list(range(len(points))):
            return order


def translate(
    clique: frozenset[tuple[int, int]], shift: int
) -> frozenset[tuple[int, int]]:
    return frozenset((orbit, (index + shift) % 14) for orbit, index in clique)


def build_certificate() -> dict[str, object]:
    base = (1, 0, 2)
    generator = (1, 3, 7, 1)
    assert permutation_order(generator, INTERNAL) == 14
    assert symmetric_square_action(generator, base) == base

    neighbors = [
        point for point in INTERNAL if point != base and is_passant_join(base, point)
    ]
    assert len(neighbors) == 42

    unseen = set(neighbors)
    orbits: list[list[tuple[int, int, int]]] = []
    while unseen:
        point = min(unseen)
        orbit = []
        while point not in orbit:
            orbit.append(point)
            point = symmetric_square_action(generator, point)
        orbits.append(orbit)
        unseen -= set(orbit)

    def compatible(first: tuple[int, int, int], second: tuple[int, int, int]) -> bool:
        return (
            first != second
            and is_passant_join(first, second)
            and holonomy(base, first, second) == 1
        )

    def degree(point: tuple[int, int, int]) -> int:
        return sum(compatible(point, other) for other in neighbors)

    orbits.sort(key=lambda orbit: (degree(orbit[0]), orbit[0]))
    assert [orbit[0] for orbit in orbits] == [
        (1, 1, 7),
        (1, 1, 6),
        (1, 2, 10),
    ]
    assert [len(orbit) for orbit in orbits] == [14, 14, 14]
    assert [degree(orbit[0]) for orbit in orbits] == [10, 12, 12]

    vertices = [(orbit, index) for orbit in range(3) for index in range(14)]

    def adjacent(first: tuple[int, int], second: tuple[int, int]) -> bool:
        return compatible(orbits[first[0]][first[1]], orbits[second[0]][second[1]])

    adjacency = {
        vertex: {other for other in vertices if adjacent(vertex, other)}
        for vertex in vertices
    }
    assert all(
        (second in adjacency[first]) == (first in adjacency[second])
        for first in vertices
        for second in vertices
    )

    difference_sets: dict[str, list[int]] = {}
    for first_orbit in range(3):
        for second_orbit in range(first_orbit, 3):
            difference_sets[f"{first_orbit}{second_orbit}"] = [
                index
                for index in range(14)
                if (first_orbit != second_orbit or index)
                and adjacent((first_orbit, 0), (second_orbit, index))
            ]
    expected_differences = {
        "00": [4, 6, 8, 10],
        "01": [6, 7, 11, 12],
        "02": [1, 3],
        "11": [6, 8],
        "12": [3, 5, 6, 8, 9, 11],
        "22": [2, 4, 10, 12],
    }
    assert difference_sets == expected_differences

    four_cliques = [
        frozenset(clique)
        for clique in itertools.combinations(vertices, 4)
        if all(adjacent(first, second) for first, second in itertools.combinations(clique, 2))
    ]
    assert len(four_cliques) == 70
    assert Counter(
        tuple(sum(orbit == kind for orbit, _ in clique) for kind in range(3))
        for clique in four_cliques
    ) == Counter({(0, 2, 2): 14, (1, 1, 2): 28, (1, 2, 1): 28})

    translation_orbits = []
    remaining = set(four_cliques)
    while remaining:
        clique = min(remaining, key=lambda value: sorted(value))
        orbit = {translate(clique, shift) for shift in range(14)}
        representative = min(orbit, key=lambda value: sorted(value))
        extensions = sorted(
            vertex
            for vertex in vertices
            if vertex not in representative
            and all(vertex in adjacency[member] for member in representative)
        )
        assert len(extensions) == 1
        translation_orbits.append(
            {
                "representative": [list(vertex) for vertex in sorted(representative)],
                "unique_common_neighbor": list(extensions[0]),
            }
        )
        remaining -= orbit
    translation_orbits.sort(key=lambda entry: entry["representative"])
    assert len(translation_orbits) == 5

    five_cliques = {
        frozenset(set(clique) | {extensions[0]})
        for clique in four_cliques
        for extensions in [
            [
                vertex
                for vertex in vertices
                if vertex not in clique
                and all(vertex in adjacency[member] for member in clique)
            ]
        ]
    }
    assert len(five_cliques) == 14
    assert all(
        not any(
            vertex not in clique and all(vertex in adjacency[member] for member in clique)
            for vertex in vertices
        )
        for clique in five_cliques
    )

    pairwise_passant_triples = Counter()
    for first, second, third in itertools.combinations(INTERNAL, 3):
        if (
            is_passant_join(first, second)
            and is_passant_join(first, third)
            and is_passant_join(second, third)
        ):
            pairwise_passant_triples[str(holonomy(first, second, third))] += 1
    assert pairwise_passant_triples == Counter({"1": 6188, "12": 5642})

    return {
        "schema": "c611-q13-tangent-triples-v1",
        "field": Q,
        "conic": "XZ-Y^2=0",
        "counts": {
            "projective_points": len(PROJECTIVE),
            "internal_points": len(INTERNAL),
            "passant_lines": len(PASSANTS),
            "secant_lines": len(SECANTS),
            "pairwise_passant_triple_holonomy": dict(
                sorted(pairwise_passant_triples.items())
            ),
        },
        "local_tangent_graph": {
            "base_point": list(base),
            "symmetric_square_generator": list(generator),
            "generator_order": 14,
            "orbit_seeds": [list(orbit[0]) for orbit in orbits],
            "orbit_sizes": [14, 14, 14],
            "orbit_degrees": [10, 12, 12],
            "vertices": 42,
            "edges": sum(len(adjacency[vertex]) for vertex in vertices) // 2,
            "difference_sets_mod_14": difference_sets,
            "four_cliques": 70,
            "four_clique_translation_orbits": translation_orbits,
            "five_cliques": 14,
            "clique_number": 5,
        },
        "consequence": {
            "segre_sign": 1,
            "required_local_clique_for_weight_8_word": 7,
            "weight_8_word_exists": False,
            "binary_nullspace_minimum_distance_lower_bound": 10,
        },
    }


def serialized(certificate: dict[str, object]) -> str:
    return json.dumps(certificate, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")

    content = serialized(build_certificate())
    if args.write:
        OUTPUT.write_text(content)
        return

    with tempfile.TemporaryDirectory() as directory:
        replay = Path(directory) / OUTPUT.name
        replay.write_text(content)
        assert OUTPUT.read_bytes() == replay.read_bytes(), "tracked certificate is stale"
    print("C611 q=13 tangent-triple certificate: PASS")


if __name__ == "__main__":
    main()
