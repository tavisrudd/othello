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

    solutions: set[frozenset[int]] = set()

    def add(indices: tuple[int, ...]) -> None:
        support = frozenset((base,) + indices)
        assert len(support) == 12 and xor_columns(tuple(support)) == 0
        solutions.add(support)

    # Exhaust the three possible numbers 0, 2, 4 of secant-join neighbors.
    for special in range(7):
        remaining = [index for index in range(7) if index != special]
        left_choices: dict[int, list[tuple[int, ...]]] = {}
        for head in itertools.product(*(fibres[index] for index in remaining[:3])):
            left_choices.setdefault(xor_columns(head), []).append(head)
        for five in itertools.combinations(fibres[special], 5):
            target = columns[base] ^ xor_columns(five)
            for tail in itertools.product(
                *(fibres[index] for index in remaining[3:])
            ):
                for head in left_choices.get(target ^ xor_columns(tail), []):
                    add(five + head + tail)

    for first, second in itertools.combinations(range(7), 2):
        remaining = [
            index for index in range(7) if index not in (first, second)
        ]
        left_choices = {}
        for head in itertools.product(*(fibres[index] for index in remaining[:2])):
            left_choices.setdefault(xor_columns(head), []).append(head)
        for first_triple in itertools.combinations(fibres[first], 3):
            for second_triple in itertools.combinations(fibres[second], 3):
                target = (
                    columns[base]
                    ^ xor_columns(first_triple)
                    ^ xor_columns(second_triple)
                )
                for tail in itertools.product(
                    *(fibres[index] for index in remaining[2:])
                ):
                    for head in left_choices.get(target ^ xor_columns(tail), []):
                        add(first_triple + second_triple + head + tail)

    secant_pairs = list(itertools.combinations(secant_neighbors, 2))
    for special in range(7):
        remaining = [index for index in range(7) if index != special]
        left_choices = {}
        for triple in itertools.combinations(fibres[special], 3):
            for head in itertools.product(
                *(fibres[index] for index in remaining[:3])
            ):
                choice = triple + head
                left_choices.setdefault(xor_columns(choice), []).append(choice)
        for tail in itertools.product(
            *(fibres[index] for index in remaining[3:])
        ):
            target = columns[base] ^ xor_columns(tail)
            for pair in secant_pairs:
                for head in left_choices.get(target ^ xor_columns(pair), []):
                    add(head + tail + pair)

    left_choices = {}
    for head in itertools.product(*(fibres[index] for index in range(3))):
        for first_pair in secant_pairs:
            left_choices.setdefault(
                xor_columns(head) ^ xor_columns(first_pair), []
            ).append((head, first_pair))
    for tail in itertools.product(*(fibres[index] for index in range(3, 7))):
        target = columns[base] ^ xor_columns(tail)
        for second_pair in secant_pairs:
            for head, first_pair in left_choices.get(
                target ^ xor_columns(second_pair), []
            ):
                if set(first_pair).isdisjoint(second_pair):
                    add(head + tail + first_pair + second_pair)

    assert len(solutions) == 56
    assert all(
        sum(index in secant_neighbors for index in support) == 4
        for support in solutions
    )

    witness_points = (
        (1, 0, 2), (1, 3, 2), (1, 4, 5), (1, 1, 8),
        (1, 4, 8), (1, 1, 7), (1, 7, 12), (1, 3, 3),
        (1, 9, 11), (1, 10, 11), (1, 0, 5), (1, 8, 7),
    )
    witness = tuple(internal.index(point) for point in witness_points)
    assert xor_columns(witness) == 0

    representatives = [
        (
            (1, 0, 2), (1, 0, 5), (1, 1, 3), (1, 1, 6),
            (1, 2, 9), (1, 3, 4), (1, 3, 7), (1, 6, 5),
            (1, 8, 7), (1, 11, 2), (1, 11, 12), (1, 12, 6),
        ),
        (
            (1, 0, 2), (1, 0, 5), (1, 1, 3), (1, 1, 6),
            (1, 2, 12), (1, 5, 5), (1, 6, 2), (1, 6, 4),
            (1, 8, 4), (1, 8, 6), (1, 9, 9), (1, 12, 9),
        ),
        witness_points,
        (
            (1, 0, 2), (1, 0, 7), (1, 1, 6), (1, 2, 11),
            (1, 3, 7), (1, 3, 11), (1, 5, 1), (1, 5, 10),
            (1, 6, 4), (1, 7, 2), (1, 8, 1), (1, 8, 6),
        ),
    ]

    def canonical(vector: tuple[int, ...]) -> tuple[int, ...]:
        first = next(value for value in vector if value)
        inverse = pow(first, -1, q)
        return tuple(value * inverse % q for value in vector)

    matrices = (
        [(1, b, c, d) for b in range(q) for c in range(q) for d in range(q)]
        + [(0, 1, c, d) for c in range(q) for d in range(q)]
        + [(0, 0, 1, d) for d in range(q)]
        + [(0, 0, 0, 1)]
    )
    matrices = [
        matrix
        for matrix in matrices
        if (matrix[0] * matrix[3] - matrix[1] * matrix[2]) % q
    ]

    def act(
        matrix: tuple[int, int, int, int], point: tuple[int, int, int]
    ) -> tuple[int, int, int]:
        a, b, c, d = matrix
        x, y, z = point
        return canonical(
            (
                (a * a * x + 2 * a * b * y + b * b * z) % q,
                (a * c * x + (a * d + b * c) * y + b * d * z) % q,
                (c * c * x + 2 * c * d * y + d * d * z) % q,
            )
        )

    covered = set()
    all_words = set()
    stabilizer_sizes = []
    for representative in representatives:
        orbit = {
            frozenset(internal.index(act(matrix, point)) for point in representative)
            for matrix in matrices
        }
        stabilizer_sizes.append(
            sum(
                {
                    act(matrix, point) for point in representative
                }
                == set(representative)
                for matrix in matrices
            )
        )
        assert len(orbit) == 91
        all_words |= orbit
        base_slice = {support for support in orbit if base in support}
        assert len(base_slice) == 14
        assert covered.isdisjoint(base_slice)
        covered |= base_slice
    assert stabilizer_sizes == [24, 24, 24, 24]
    assert covered == solutions
    assert len(all_words) == 364

    pair_concurrences: Counter[tuple[int, int]] = Counter()
    for support in all_words:
        for first, second in itertools.combinations(sorted(support), 2):
            pair_concurrences[first, second] += 1
    assert Counter(pair_concurrences.values()) == Counter(
        {6: 1092, 7: 546, 8: 273, 9: 546, 12: 546}
    )

    def passant_join(first: int, second: int) -> bool:
        return any(
            incident(line, internal[first]) and incident(line, internal[second])
            for line in passants
        )

    assert all(
        passant_join(first, second) == (concurrence in {7, 9, 12})
        for (first, second), concurrence in pair_concurrences.items()
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
    verify_distance()
    print("C611 independent replay: PASS (omega = 5, d = 12, 364 minimum words)")


if __name__ == "__main__":
    main()
