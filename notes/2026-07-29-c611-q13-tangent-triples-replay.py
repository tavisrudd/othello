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
    print("C611 independent cyclic replay: PASS (omega = 5)")


if __name__ == "__main__":
    main()
