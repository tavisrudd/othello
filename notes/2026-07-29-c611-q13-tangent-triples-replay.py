#!/usr/bin/env python3
"""Independent combinatorial replay of the C611 cyclic tangent certificate."""

from __future__ import annotations

import itertools
from collections import Counter


DIFFERENCES = {
    (0, 0): {4, 6, 8, 10},
    (0, 1): {6, 7, 11, 12},
    (0, 2): {1, 3},
    (1, 1): {6, 8},
    (1, 2): {3, 5, 6, 8, 9, 11},
    (2, 2): {2, 4, 10, 12},
}
VERTICES = [(orbit, index) for orbit in range(3) for index in range(14)]


def adjacent(first: tuple[int, int], second: tuple[int, int]) -> bool:
    first_orbit, first_index = first
    second_orbit, second_index = second
    if first_orbit > second_orbit:
        return adjacent(second, first)
    return (
        (second_index - first_index) % 14
        in DIFFERENCES[first_orbit, second_orbit]
    )


def verify_distance() -> None:
    q = 13
    squares = {value * value % q for value in range(1, q)}
    projective = (
        [(1, y, z) for y in range(q) for z in range(q)]
        + [(0, 1, z) for z in range(q)]
        + [(0, 0, 1)]
    )
    internal = [
        point
        for point in projective
        if (point[1] * point[1] - point[0] * point[2]) % q
        not in squares | {0}
    ]
    passants = [
        line
        for line in projective
        if (line[1] * line[1] - 4 * line[0] * line[2]) % q
        not in squares | {0}
    ]

    def incident(line: tuple[int, int, int], point: tuple[int, int, int]) -> bool:
        return sum(a * b for a, b in zip(line, point)) % q == 0

    columns = [
        sum(1 << row for row, line in enumerate(passants) if incident(line, point))
        for point in internal
    ]
    base = internal.index((1, 0, 2))
    through = [row for row, line in enumerate(passants) if incident(line, internal[base])]
    fibres = [
        [
            index
            for index, point in enumerate(internal)
            if index != base and incident(passants[row], point)
        ]
        for row in through
    ]
    passant_neighbors = set().union(*(set(fibre) for fibre in fibres))
    secant_neighbors = [
        index
        for index in range(78)
        if index != base and index not in passant_neighbors
    ]

    def xor_columns(indices: tuple[int, ...]) -> int:
        value = 0
        for index in indices:
            value ^= columns[index]
        return value

    for special in range(7):
        remaining = [index for index in range(7) if index != special]
        left = {
            xor_columns(choice)
            for choice in itertools.product(*(fibres[index] for index in remaining[:3]))
        }
        for triple in itertools.combinations(fibres[special], 3):
            target = columns[base] ^ xor_columns(triple)
            assert all(
                target ^ xor_columns(choice) not in left
                for choice in itertools.product(
                    *(fibres[index] for index in remaining[3:])
                )
            )

    left = {
        xor_columns(choice)
        for choice in itertools.product(*(fibres[index] for index in range(3)))
    }
    assert all(
        columns[base] ^ xor_columns(choice) ^ xor_columns(pair) not in left
        for choice in itertools.product(*(fibres[index] for index in range(3, 7)))
        for pair in itertools.combinations(secant_neighbors, 2)
    )

    witness_points = (
        (1, 0, 2), (1, 3, 2), (1, 4, 5), (1, 1, 8),
        (1, 4, 8), (1, 1, 7), (1, 7, 12), (1, 3, 3),
        (1, 9, 11), (1, 10, 11), (1, 0, 5), (1, 8, 7),
    )
    witness = tuple(internal.index(point) for point in witness_points)
    assert xor_columns(witness) == 0


def main() -> None:
    four_cliques = [
        clique
        for clique in itertools.combinations(VERTICES, 4)
        if all(
            adjacent(first, second)
            for first, second in itertools.combinations(clique, 2)
        )
    ]
    assert len(four_cliques) == 70
    assert Counter(
        tuple(sum(orbit == kind for orbit, _ in clique) for kind in range(3))
        for clique in four_cliques
    ) == Counter({(0, 2, 2): 14, (1, 1, 2): 28, (1, 2, 1): 28})

    five_cliques = set()
    for clique in four_cliques:
        common = [
            vertex
            for vertex in VERTICES
            if vertex not in clique
            and all(adjacent(vertex, member) for member in clique)
        ]
        assert len(common) == 1
        five_cliques.add(frozenset((*clique, common[0])))

    assert len(five_cliques) == 14
    assert all(
        not any(
            vertex not in clique
            and all(adjacent(vertex, member) for member in clique)
            for vertex in VERTICES
        )
        for clique in five_cliques
    )
    verify_distance()
    print("C611 independent replay: PASS (omega = 5, d = 12)")


if __name__ == "__main__":
    main()
