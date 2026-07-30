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


def matrix_product(
    first: tuple[int, int, int, int], second: tuple[int, int, int, int]
) -> tuple[int, int, int, int]:
    a, b, c, d = first
    e, f, g, h = second
    return canonical(
        (
            (a * e + b * g) % Q,
            (a * f + b * h) % Q,
            (c * e + d * g) % Q,
            (c * f + d * h) % Q,
        )
    )


def matrix_power(
    matrix: tuple[int, int, int, int], exponent: int
) -> tuple[int, int, int, int]:
    value = (1, 0, 0, 1)
    for _ in range(exponent):
        value = matrix_product(value, matrix)
    return value


def translate(
    clique: frozenset[tuple[int, int]], shift: int
) -> frozenset[tuple[int, int]]:
    return frozenset((orbit, (index + shift) % 14) for orbit, index in clique)


def incidence_distance_certificate() -> dict[str, object]:
    columns = [
        sum(1 << row for row, line in enumerate(PASSANTS) if dot(line, point) == 0)
        for point in INTERNAL
    ]
    assert {column.bit_count() for column in columns} == {7}
    incidence_rank = gf2_rank(columns)
    assert incidence_rank == 42
    code_dimension = len(INTERNAL) - incidence_rank
    assert code_dimension == 36

    base = 0
    through_base = [
        row for row, line in enumerate(PASSANTS) if dot(line, INTERNAL[base]) == 0
    ]
    fibres = [
        [
            index
            for index, point in enumerate(INTERNAL)
            if index != base and dot(PASSANTS[row], point) == 0
        ]
        for row in through_base
    ]
    assert len(fibres) == 7 and {len(fibre) for fibre in fibres} == {6}
    passant_neighbors = set().union(*(set(fibre) for fibre in fibres))
    secant_neighbors = [
        index
        for index in range(len(INTERNAL))
        if index != base and index not in passant_neighbors
    ]
    assert len(secant_neighbors) == 35

    def xor_columns(indices: tuple[int, ...] | list[int] | frozenset[int]) -> int:
        value = 0
        for index in indices:
            value ^= columns[index]
        return value

    # A weight-ten support through the base has one of exactly two pencil
    # profiles: 3+1+...+1 on the seven passant lines, or 1+...+1 there
    # together with two points on secant joins from the base.
    for special in range(7):
        remaining = [index for index in range(7) if index != special]
        left = {
            xor_columns(choice)
            for choice in itertools.product(*(fibres[index] for index in remaining[:3]))
        }
        for triple in itertools.combinations(fibres[special], 3):
            target = columns[base] ^ xor_columns(triple)
            for choice in itertools.product(
                *(fibres[index] for index in remaining[3:])
            ):
                assert target ^ xor_columns(choice) not in left

    left = {
        xor_columns(choice)
        for choice in itertools.product(*(fibres[index] for index in range(3)))
    }
    for choice in itertools.product(*(fibres[index] for index in range(3, 7))):
        target = columns[base] ^ xor_columns(choice)
        for pair in itertools.combinations(secant_neighbors, 2):
            assert target ^ xor_columns(pair) not in left

    # Exhaust all weight-twelve pencil profiles through the base.
    solutions: set[frozenset[int]] = set()
    solution_profiles: Counter[str] = Counter()

    def add_solution(indices: tuple[int, ...], profile: str) -> None:
        support = frozenset((base,) + indices)
        assert len(support) == 12 and xor_columns(support) == 0
        if support not in solutions:
            solutions.add(support)
            solution_profiles[profile] += 1

    # No secant-join points: either 5+1+...+1 or 3+3+1+...+1.
    for special in range(7):
        remaining = [index for index in range(7) if index != special]
        left_choices: dict[int, list[tuple[int, ...]]] = {}
        for choice in itertools.product(
            *(fibres[index] for index in remaining[:3])
        ):
            left_choices.setdefault(xor_columns(choice), []).append(choice)
        for five in itertools.combinations(fibres[special], 5):
            target = columns[base] ^ xor_columns(five)
            for tail in itertools.product(
                *(fibres[index] for index in remaining[3:])
            ):
                for head in left_choices.get(target ^ xor_columns(tail), []):
                    add_solution(five + head + tail, "five_plus_singles")

    for first, second in itertools.combinations(range(7), 2):
        remaining = [
            index for index in range(7) if index not in (first, second)
        ]
        left_choices = {}
        for choice in itertools.product(
            *(fibres[index] for index in remaining[:2])
        ):
            left_choices.setdefault(xor_columns(choice), []).append(choice)
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
                        add_solution(
                            first_triple + second_triple + head + tail,
                            "two_triples_plus_singles",
                        )

    secant_pairs = list(itertools.combinations(secant_neighbors, 2))

    # Two secant-join points: one passant triple and six passant singles.
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
                for head in left_choices.get(
                    target ^ xor_columns(pair), []
                ):
                    add_solution(
                        head + tail + pair,
                        "one_triple_singles_two_secants",
                    )

    # Four secant-join points: one point in each passant fibre.
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
                    add_solution(
                        head + tail + first_pair + second_pair,
                        "passant_singles_four_secants",
                    )

    assert len(solutions) == 56
    assert solution_profiles == Counter({"passant_singles_four_secants": 56})

    witness_points = [
        (1, 0, 2),
        (1, 3, 2),
        (1, 4, 5),
        (1, 1, 8),
        (1, 4, 8),
        (1, 1, 7),
        (1, 7, 12),
        (1, 3, 3),
        (1, 9, 11),
        (1, 10, 11),
        (1, 0, 5),
        (1, 8, 7),
    ]
    witness = tuple(INTERNAL.index(point) for point in witness_points)
    assert len(set(witness)) == 12
    assert xor_columns(witness) == 0
    intersection_spectrum = sorted(
        {
            sum(dot(line, INTERNAL[index]) == 0 for index in witness)
            for line in PASSANTS
        }
    )
    assert intersection_spectrum == [0, 2]

    projective_linear_group = [
        matrix
        for matrix in projective_vectors(4)
        if (matrix[0] * matrix[3] - matrix[1] * matrix[2]) % Q
    ]

    def quadratic(point: tuple[int, int, int]) -> int:
        return (point[1] * point[1] - point[0] * point[2]) % Q

    def polar(
        first: tuple[int, int, int], second: tuple[int, int, int]
    ) -> int:
        return (
            2 * first[1] * second[1]
            - first[0] * second[2]
            - first[2] * second[0]
        ) % Q

    def orthogonal_rho(first: int, second: int) -> int:
        first_point = INTERNAL[first]
        second_point = INTERNAL[second]
        return (
            polar(first_point, second_point) ** 2
            * pow(quadratic(first_point) * quadratic(second_point), -1, Q)
            % Q
        )

    minimum_word_orbits = []
    all_minimum_words: set[frozenset[int]] = set()
    unclassified = set(solutions)
    while unclassified:
        representative = min(unclassified, key=lambda support: sorted(support))
        representative_points = [INTERNAL[index] for index in representative]

        def image(matrix: tuple[int, int, int, int]) -> frozenset[int]:
            return frozenset(
                INTERNAL.index(symmetric_square_action(matrix, point))
                for point in representative_points
            )

        global_orbit = {image(matrix) for matrix in projective_linear_group}
        all_minimum_words |= global_orbit
        base_slice = {support for support in global_orbit if base in support}
        stabilizer = [
            matrix for matrix in projective_linear_group if image(matrix) == representative
        ]
        assert len(global_orbit) == 91
        assert len(base_slice) == 14
        assert len(stabilizer) == 24
        stabilizer_orders = Counter(
            permutation_order(matrix, representative_points) for matrix in stabilizer
        )
        orbit_pair_concurrences: Counter[tuple[int, int]] = Counter()
        for support in global_orbit:
            orbit_pair_concurrences.update(
                itertools.combinations(sorted(support), 2)
            )
        odd_gram_relations = {
            orthogonal_rho(first, second)
            for (first, second), concurrence in orbit_pair_concurrences.items()
            if concurrence % 2
        }
        assert len(odd_gram_relations) == 1
        gram_relation = next(iter(odd_gram_relations))

        secant_triangles = sum(
            1
            for first, second, third in itertools.combinations(representative, 3)
            if not is_passant_join(INTERNAL[first], INTERNAL[second])
            and not is_passant_join(INTERNAL[first], INTERNAL[third])
            and not is_passant_join(INTERNAL[second], INTERNAL[third])
        )
        entry: dict[str, object] = {
            "representative_points": [
                list(INTERNAL[index]) for index in sorted(representative)
            ],
            "global_orbit_size": len(global_orbit),
            "words_through_fixed_base": len(base_slice),
            "stabilizer_order": len(stabilizer),
            "secant_graph_triangles": secant_triangles,
            "binary_span_dimension": gf2_rank(
                [sum(1 << index for index in support) for support in global_orbit]
            ),
            "binary_gram_relation_rho": gram_relation,
        }
        assert entry["binary_span_dimension"] == code_dimension
        if stabilizer_orders == Counter({1: 1, 2: 9, 3: 8, 4: 6}):
            entry["stabilizer_type"] = "S4"
            point_involution = next(
                matrix
                for matrix in stabilizer
                if matrix != (1, 0, 0, 1)
                and symmetric_square_action(matrix, representative_points[0])
                == representative_points[0]
            )
            fixed_points = sum(
                symmetric_square_action(point_involution, point) == point
                for point in representative_points
            )
            assert fixed_points == 2
            entry["action"] = "S4/C2_transposition"
        else:
            assert stabilizer_orders == Counter(
                {1: 1, 2: 13, 3: 2, 4: 2, 6: 2, 12: 4}
            )
            entry["stabilizer_type"] = "D24"
            rotation_matrix = next(
                matrix
                for matrix in stabilizer
                if permutation_order(matrix, representative_points) == 12
            )
            cyclic_points = []
            point = representative_points[0]
            while point not in cyclic_points:
                cyclic_points.append(point)
                point = symmetric_square_action(rotation_matrix, point)
            differences = [
                index
                for index in range(1, 12)
                if not is_passant_join(cyclic_points[0], cyclic_points[index])
            ]
            normalized_differences = min(
                tuple(sorted(unit * index % 12 for index in differences))
                for unit in (1, 5, 7, 11)
            )
            entry["secant_differences_mod_12"] = list(normalized_differences)
        minimum_word_orbits.append(entry)
        unclassified -= base_slice

    assert len(minimum_word_orbits) == 4
    assert Counter(
        entry["stabilizer_type"] for entry in minimum_word_orbits
    ) == Counter({"D24": 3, "S4": 1})
    assert Counter(
        entry["binary_gram_relation_rho"] for entry in minimum_word_orbits
    ) == Counter({9: 2, 10: 1, 12: 1})
    assert sorted(
        tuple(entry["secant_differences_mod_12"])
        for entry in minimum_word_orbits
        if entry["stabilizer_type"] == "D24"
    ) == [
        (1, 3, 9, 11),
        (1, 4, 8, 11),
        (2, 3, 9, 10),
    ]
    assert sum(entry["global_orbit_size"] for entry in minimum_word_orbits) == 364
    assert len(all_minimum_words) == 364

    point_replications = Counter(
        sum(index in support for support in all_minimum_words)
        for index in range(len(INTERNAL))
    )
    assert point_replications == Counter({56: 78})
    pair_concurrences: Counter[tuple[int, int]] = Counter()
    for support in all_minimum_words:
        for first, second in itertools.combinations(sorted(support), 2):
            pair_concurrences[first, second] += 1
    concurrence_spectrum = Counter(pair_concurrences.values())
    assert concurrence_spectrum == Counter({6: 1092, 7: 546, 8: 273, 9: 546, 12: 546})
    assert len(pair_concurrences) == len(INTERNAL) * (len(INTERNAL) - 1) // 2
    assert all(
        is_passant_join(INTERNAL[first], INTERNAL[second])
        == (concurrence in {7, 9, 12})
        for (first, second), concurrence in pair_concurrences.items()
    )

    triple_concurrences: Counter[tuple[int, int, int]] = Counter()
    for support in all_minimum_words:
        triple_concurrences.update(itertools.combinations(sorted(support), 3))

    pair_profiles: dict[int, dict[str, object]] = {}
    pair_relations: dict[tuple[int, int], int] = {}
    for (first, second), concurrence in pair_concurrences.items():
        histogram = Counter(
            triple_concurrences[
                tuple(sorted((first, second, third)))
            ]
            for third in range(len(INTERNAL))
            if third not in (first, second)
        )
        rho = orthogonal_rho(first, second)
        pair_relations[first, second] = rho
        profile = {
            "pairs": 0,
            "pair_concurrence": concurrence,
            "triple_concurrence_histogram": {
                str(value): count for value, count in sorted(histogram.items())
            },
        }
        if rho in pair_profiles:
            assert pair_profiles[rho]["pair_concurrence"] == concurrence
            assert (
                pair_profiles[rho]["triple_concurrence_histogram"]
                == profile["triple_concurrence_histogram"]
            )
        else:
            pair_profiles[rho] = profile
        pair_profiles[rho]["pairs"] = int(pair_profiles[rho]["pairs"]) + 1

    expected_profiles = {
        0: (273, 8, {0: 16, 1: 40, 2: 20}),
        1: (546, 6, {0: 26, 1: 42, 2: 6, 3: 2}),
        3: (546, 6, {0: 32, 1: 28, 2: 16}),
        9: (546, 12, {0: 7, 1: 34, 2: 27, 3: 4, 5: 4}),
        10: (546, 7, {0: 25, 1: 36, 2: 13, 4: 2}),
        12: (546, 9, {0: 18, 1: 32, 2: 24, 5: 2}),
    }
    assert {
        rho: (
            profile["pairs"],
            profile["pair_concurrence"],
            {
                int(value): count
                for value, count in profile[
                    "triple_concurrence_histogram"
                ].items()
            },
        )
        for rho, profile in pair_profiles.items()
    } == expected_profiles

    reconstructed_adjacency = [
        sum(
            1 << second
            for second in range(len(INTERNAL))
            if first != second
            and pair_concurrences[tuple(sorted((first, second)))] in {7, 9, 12}
        )
        for first in range(len(INTERNAL))
    ]
    seven_cliques: list[frozenset[int]] = []

    def bron_kerbosch(
        clique: list[int], candidates: int, excluded: int
    ) -> None:
        if not candidates and not excluded:
            if len(clique) >= 7:
                seven_cliques.append(frozenset(clique))
            return
        if len(clique) + candidates.bit_count() < 7:
            return
        union = candidates | excluded
        pivot = max(
            (index for index in range(len(INTERNAL)) if union >> index & 1),
            key=lambda index: (candidates & reconstructed_adjacency[index]).bit_count(),
            default=0,
        )
        extensions = candidates & ~reconstructed_adjacency[pivot]
        while extensions:
            bit = extensions & -extensions
            vertex = bit.bit_length() - 1
            bron_kerbosch(
                clique + [vertex],
                candidates & reconstructed_adjacency[vertex],
                excluded & reconstructed_adjacency[vertex],
            )
            candidates &= ~bit
            excluded |= bit
            extensions &= ~bit

    bron_kerbosch([], (1 << len(INTERNAL)) - 1, 0)
    assert len(seven_cliques) == 1716
    assert {len(clique) for clique in seven_cliques} == {7}
    reconstructed_rows = {
        clique
        for clique in seven_cliques
        if all(
            triple_concurrences[triple] == 0
            for triple in itertools.combinations(sorted(clique), 3)
        )
    }
    actual_rows = {
        frozenset(
            index
            for index, point in enumerate(INTERNAL)
            if dot(line, point) == 0
        )
        for line in PASSANTS
    }
    assert len(reconstructed_rows) == 78
    assert reconstructed_rows == actual_rows

    relation_matrices = {
        rho: [
            sum(
                1 << second
                for second in range(len(INTERNAL))
                if first != second
                and pair_relations[tuple(sorted((first, second)))] == rho
            )
            for first in range(len(INTERNAL))
        ]
        for rho in (0, 1, 3, 9, 10, 12)
    }
    assert {
        frozenset(
            index for index in range(len(INTERNAL)) if row >> index & 1
        )
        for row in relation_matrices[0]
    } == actual_rows

    def matrix_product_mod_two(
        first: list[int], second: list[int]
    ) -> list[int]:
        return [
            sum(
                1 << column
                for column in range(len(INTERNAL))
                if (first[row] & second[column]).bit_count() % 2
            )
            for row in range(len(INTERNAL))
        ]

    zero_matrix = [0] * len(INTERNAL)
    identity_matrix = [1 << index for index in range(len(INTERNAL))]

    def matrix_xor(*matrices: list[int]) -> list[int]:
        result = [0] * len(INTERNAL)
        for matrix in matrices:
            result = [
                first ^ second for first, second in zip(result, matrix)
            ]
        return result

    assert matrix_product_mod_two(
        relation_matrices[0], relation_matrices[0]
    ) == matrix_xor(
        identity_matrix,
        relation_matrices[9],
        relation_matrices[10],
        relation_matrices[12],
    )
    assert all(
        matrix_product_mod_two(
            relation_matrices[0], relation_matrices[rho]
        )
        == zero_matrix
        for rho in (9, 10, 12)
    )
    assert matrix_product_mod_two(
        relation_matrices[9], relation_matrices[9]
    ) == relation_matrices[10]
    assert matrix_product_mod_two(
        relation_matrices[10], relation_matrices[10]
    ) == relation_matrices[12]
    assert matrix_product_mod_two(
        relation_matrices[12], relation_matrices[12]
    ) == relation_matrices[9]
    relation_ranks = {
        rho: gf2_rank(matrix) for rho, matrix in relation_matrices.items()
    }
    assert relation_ranks[0] == 42
    assert {
        rho: relation_ranks[rho] for rho in (9, 10, 12)
    } == {9: 36, 10: 36, 12: 36}

    minimum_word_span_dimension = gf2_rank(
        [sum(1 << index for index in support) for support in all_minimum_words]
    )
    assert minimum_word_span_dimension == code_dimension

    def relation_color(first: int, second: int) -> int:
        if first == second:
            return -1
        return pair_relations[tuple(sorted((first, second)))]

    automorphism_base = [0, 8, 3, 6]
    source_signatures = {
        tuple(relation_color(vertex, base_vertex) for base_vertex in automorphism_base):
        vertex
        for vertex in range(len(INTERNAL))
    }
    assert len(source_signatures) == len(INTERNAL)
    target_base: list[int] = []
    search_nodes: Counter[int] = Counter()
    scheme_automorphisms = 0

    def enumerate_scheme_automorphisms(depth: int) -> None:
        nonlocal scheme_automorphisms
        search_nodes[depth] += 1
        if depth == len(automorphism_base):
            target_signatures = {
                tuple(
                    relation_color(vertex, base_vertex)
                    for base_vertex in target_base
                ): vertex
                for vertex in range(len(INTERNAL))
            }
            if len(target_signatures) != len(INTERNAL):
                return
            permutation = [
                target_signatures[
                    tuple(
                        relation_color(vertex, base_vertex)
                        for base_vertex in automorphism_base
                    )
                ]
                for vertex in range(len(INTERNAL))
            ]
            assert all(
                relation_color(permutation[first], permutation[second])
                == relation_color(first, second)
                for first in range(len(INTERNAL))
                for second in range(first)
            )
            scheme_automorphisms += 1
            return
        for image_vertex in range(len(INTERNAL)):
            if image_vertex in target_base:
                continue
            if all(
                relation_color(image_vertex, target_base[index])
                == relation_color(
                    automorphism_base[depth], automorphism_base[index]
                )
                for index in range(depth)
            ):
                target_base.append(image_vertex)
                enumerate_scheme_automorphisms(depth + 1)
                target_base.pop()

    enumerate_scheme_automorphisms(0)
    assert search_nodes == Counter({0: 1, 1: 78, 2: 1092, 3: 2184, 4: 2184})
    assert scheme_automorphisms == 2184
    assert len(projective_linear_group) == 2184

    witness_set = set(witness_points)
    stabilizer = [
        matrix
        for matrix in projective_linear_group
        if {
            symmetric_square_action(matrix, point) for point in witness_set
        }
        == witness_set
    ]
    assert len(stabilizer) == 24
    stabilizer_orders = Counter(
        permutation_order(matrix, witness_points) for matrix in stabilizer
    )
    assert stabilizer_orders == Counter({1: 1, 2: 13, 3: 2, 4: 2, 6: 2, 12: 4})
    rotation = (0, 1, 6, 4)
    reflection = (0, 1, 7, 0)
    assert permutation_order(rotation, witness_points) == 12
    assert matrix_power(reflection, 2) == (1, 0, 0, 1)
    assert (
        matrix_product(matrix_product(reflection, rotation), reflection)
        == matrix_power(rotation, 11)
    )
    cyclic_witness = []
    point = witness_points[0]
    while point not in cyclic_witness:
        cyclic_witness.append(point)
        point = symmetric_square_action(rotation, point)
    assert len(cyclic_witness) == 12 and set(cyclic_witness) == witness_set
    secant_differences = [
        index
        for index in range(1, 12)
        if not is_passant_join(cyclic_witness[0], cyclic_witness[index])
    ]
    assert secant_differences == [4, 5, 7, 8]

    return {
        "fixed_base_point": list(INTERNAL[base]),
        "passant_pencil_fibre_sizes": [len(fibre) for fibre in fibres],
        "secant_join_neighbors": len(secant_neighbors),
        "weight_10_profiles_checked": {
            "three_on_one_passant_then_singles": (
                7 * len(list(itertools.combinations(range(6), 3))) * 6**6
            ),
            "passant_singles_plus_two_secant_neighbors": (
                6**7 * len(list(itertools.combinations(range(35), 2)))
            ),
        },
        "weight_10_word_exists": False,
        "weight_12_witness_indices": list(witness),
        "weight_12_witness_points": [list(point) for point in witness_points],
        "weight_12_passant_intersection_sizes": intersection_spectrum,
        "weight_12_classification": {
            "words_through_fixed_base": len(solutions),
            "fixed_base_profile_counts": dict(sorted(solution_profiles.items())),
            "global_words": 364,
            "projective_orbits": minimum_word_orbits,
            "minimum_word_incidence": {
                "code_dimension": code_dimension,
                "minimum_word_span_dimension": minimum_word_span_dimension,
                "each_projective_orbit_spans_code": True,
                "point_replication": 56,
                "pair_concurrence_spectrum": {
                    str(value): count
                    for value, count in sorted(concurrence_spectrum.items())
                },
                "passant_pair_concurrences": [7, 9, 12],
                "secant_pair_concurrences": [6, 8],
                "join_type_reconstructed": True,
                "elliptic_pair_profiles_by_rho": {
                    str(rho): profile
                    for rho, profile in sorted(pair_profiles.items())
                },
                "full_six_class_scheme_reconstructed": True,
                "mod2_association_algebra": {
                    "incidence_relation_rho": 0,
                    "incidence_rank": relation_ranks[0],
                    "passant_relation_ranks": {
                        str(rho): relation_ranks[rho]
                        for rho in (9, 10, 12)
                    },
                    "A0_squared": "I+A9+A10+A12",
                    "A0_times_passant_relations": "0",
                    "passant_squares": {
                        "A9^2": "A10",
                        "A10^2": "A12",
                        "A12^2": "A9",
                    },
                    "orbit_gram_relations": [
                        entry["binary_gram_relation_rho"]
                        for entry in minimum_word_orbits
                    ],
                    "rank_36_forced_from_rank_A0_42": True,
                },
                "passant_graph_seven_cliques": len(seven_cliques),
                "zero_triple_seven_cliques": len(reconstructed_rows),
                "passant_incidence_rows_reconstructed": True,
                "automorphism_group": {
                    "name": "PGL(2,13)",
                    "order": scheme_automorphisms,
                    "distinguishing_base_indices": automorphism_base,
                    "distinguishing_base_points": [
                        list(INTERNAL[index]) for index in automorphism_base
                    ],
                    "search_nodes_by_depth": {
                        str(depth): count
                        for depth, count in sorted(search_nodes.items())
                    },
                    "minimum_hypergraph_equals_scheme_equals_code": True,
                },
            },
        },
        "weight_12_stabilizer": {
            "order": len(stabilizer),
            "element_order_distribution": {
                str(order): count for order, count in sorted(stabilizer_orders.items())
            },
            "dihedral_rotation": list(rotation),
            "dihedral_reflection": list(reflection),
            "secant_differences_mod_12": secant_differences,
        },
        "minimum_distance": 12,
    }


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
            "distance_certificate": incidence_distance_certificate(),
            "binary_nullspace_minimum_distance": 12,
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
