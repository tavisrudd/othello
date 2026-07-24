#!/usr/bin/env python3
"""Exact support and coefficient chirality checks for the Clebsch code.

This standalone, standard-library-only checker imports the exact F_11
automorphism primitives from ``check_code_automorphisms.py`` in the same
directory.  It certifies both the support-level A5 orbit split and its lift to
all coefficient-bearing leaders of all 120 deep-hole syndrome cosets.

The two chirality classes are canonically an *unordered* pair.  The script
uses a deterministic order only to print counts and explicitly makes no
preferred-orientation claim.
"""

from __future__ import annotations

from collections import Counter
from itertools import combinations, permutations, product

import check_code_automorphisms as automorphisms


Q = automorphisms.Q
COORDINATES = frozenset(range(6))
IDENTITY = automorphisms.IDENTITY_PERM
Triple = frozenset[int]
Pair = frozenset[int]
Matching = frozenset[Pair]
SynthematicTotal = frozenset[Matching]
Word = tuple[int, int, int, int, int, int]
Syndrome = tuple[int, int, int]


def act_on_subset(permutation: tuple[int, ...], subset: Triple) -> Triple:
    return frozenset(permutation[i] for i in subset)


def complement(triple: Triple) -> Triple:
    return COORDINATES - triple


def subset_orbit(group: set[tuple[int, ...]], seed: Triple) -> frozenset[Triple]:
    return frozenset(act_on_subset(permutation, seed) for permutation in group)


def triple_orbits(group: set[tuple[int, ...]]) -> list[frozenset[Triple]]:
    triples = {frozenset(triple) for triple in combinations(range(6), 3)}
    orbits = []
    remaining = set(triples)
    while remaining:
        orbit = subset_orbit(group, min(remaining, key=lambda s: tuple(sorted(s))))
        assert orbit <= triples
        orbits.append(orbit)
        remaining -= orbit
    return sorted(orbits, key=lambda orbit: min(tuple(sorted(s)) for s in orbit))


def complementary_pairs() -> list[frozenset[Triple]]:
    pairs = {
        frozenset({triple, complement(triple)})
        for triple in (frozenset(t) for t in combinations(range(6), 3))
    }
    return sorted(
        pairs,
        key=lambda pair: tuple(sorted(tuple(sorted(triple)) for triple in pair)),
    )


def perfect_matchings() -> set[Matching]:
    edges = [frozenset(edge) for edge in combinations(range(6), 2)]
    return {
        frozenset(candidate)
        for candidate in combinations(edges, 3)
        if frozenset().union(*candidate) == COORDINATES
    }


def synthematic_totals(matchings: set[Matching]) -> set[SynthematicTotal]:
    all_edges = frozenset(frozenset(edge) for edge in combinations(range(6), 2))
    return {
        frozenset(candidate)
        for candidate in combinations(matchings, 5)
        if frozenset().union(*candidate) == all_edges
        and sum(len(matching) for matching in candidate) == len(all_edges)
    }


def act_on_matching(permutation: tuple[int, ...], matching: Matching) -> Matching:
    return frozenset(act_on_subset(permutation, pair) for pair in matching)


def act_on_total(
    permutation: tuple[int, ...], total: SynthematicTotal
) -> SynthematicTotal:
    return frozenset(act_on_matching(permutation, matching) for matching in total)


def matching_key(matching: Matching) -> tuple[tuple[int, int], ...]:
    return tuple(sorted(tuple(sorted(pair)) for pair in matching))


def projective_normalize(vector: tuple[int, int, int]) -> tuple[int, int, int]:
    """Return the canonical representative of a point or line of PG(2, 11)."""
    assert any(vector)
    pivot = next(coordinate for coordinate in vector if coordinate)
    scalar = automorphisms.inv(pivot)
    return tuple(scalar * coordinate % Q for coordinate in vector)  # type: ignore[return-value]


def alternating_bipartition(left: Matching, right: Matching) -> frozenset[Triple]:
    """Bipartition the alternating six-cycle formed by two disjoint synthemes."""
    assert left.isdisjoint(right)
    edges = left | right
    adjacency = {vertex: set() for vertex in COORDINATES}
    for edge in edges:
        a, b = tuple(edge)
        adjacency[a].add(b)
        adjacency[b].add(a)
    assert all(len(neighbors) == 2 for neighbors in adjacency.values())

    seed = min(COORDINATES)
    colors = {seed: 0}
    frontier = [seed]
    while frontier:
        vertex = frontier.pop()
        for neighbor in adjacency[vertex]:
            if neighbor not in colors:
                colors[neighbor] = 1 - colors[vertex]
                frontier.append(neighbor)
            else:
                assert colors[neighbor] != colors[vertex]
    assert set(colors) == set(COORDINATES)
    part = frozenset(vertex for vertex, color in colors.items() if color == 0)
    assert len(part) == 3
    result = frozenset({part, complement(part)})
    assert all(
        len(edge & triple) == 1
        for edge in edges
        for triple in result
    )
    return result


def antipodal_matching(left: Matching, right: Matching) -> Matching:
    """The unique distance-three matching of the alternating six-cycle."""
    assert left.isdisjoint(right)
    edges = left | right
    adjacency = {vertex: set() for vertex in COORDINATES}
    for edge in edges:
        a, b = tuple(edge)
        adjacency[a].add(b)
        adjacency[b].add(a)
    assert all(len(neighbors) == 2 for neighbors in adjacency.values())

    antipodes = set()
    for vertex in COORDINATES:
        distance = {vertex: 0}
        frontier = [vertex]
        while frontier:
            current = frontier.pop(0)
            for neighbor in adjacency[current]:
                if neighbor not in distance:
                    distance[neighbor] = distance[current] + 1
                    frontier.append(neighbor)
        opposite = [candidate for candidate, d in distance.items() if d == 3]
        assert len(opposite) == 1
        antipodes.add(frozenset({vertex, opposite[0]}))
    result = frozenset(antipodes)
    assert len(result) == 3
    assert frozenset().union(*result) == COORDINATES
    assert result.isdisjoint(edges)
    return result


def cross_product(
    left: tuple[int, int, int], right: tuple[int, int, int]
) -> tuple[int, int, int]:
    return tuple(
        (
            left[(coordinate + 1) % 3] * right[(coordinate + 2) % 3]
            - left[(coordinate + 2) % 3] * right[(coordinate + 1) % 3]
        )
        % Q
        for coordinate in range(3)
    )  # type: ignore[return-value]


def conic_polar(point: tuple[int, int, int]) -> tuple[int, int, int]:
    """Polar line for XZ=Y^2, up to a nonzero scalar."""
    x, y, z = point
    return (z, -2 * y % Q, x)


def chord_line(pair: Pair) -> tuple[int, int, int]:
    i, j = tuple(pair)
    return projective_normalize(
        cross_product(automorphisms.COLUMNS[i], automorphisms.COLUMNS[j])
    )


def concurrence_point(matching: Matching) -> tuple[int, int, int]:
    """Return the common point of the three chord lines in a matching."""
    assert len(matching) == 3
    lines = [chord_line(pair) for pair in sorted(matching, key=lambda p: tuple(p))]
    assert len(set(lines)) == 3
    point = projective_normalize(cross_product(lines[0], lines[1]))
    assert all(sum(a * b for a, b in zip(line, point)) % Q == 0 for line in lines)
    return point


def petersen_edges(
    pairs: list[frozenset[Triple]], representatives: dict[frozenset[Triple], Triple]
) -> frozenset[frozenset[int]]:
    edges = set()
    for i, j in combinations(range(len(pairs)), 2):
        if len(representatives[pairs[i]] & representatives[pairs[j]]) == 2:
            edges.add(frozenset({i, j}))
    return frozenset(edges)


def graph_is_connected(vertex_count: int, edges: frozenset[frozenset[int]]) -> bool:
    adjacency = {vertex: set() for vertex in range(vertex_count)}
    for edge in edges:
        a, b = tuple(edge)
        adjacency[a].add(b)
        adjacency[b].add(a)
    seen = {0}
    frontier = [0]
    while frontier:
        vertex = frontier.pop()
        for neighbor in adjacency[vertex] - seen:
            seen.add(neighbor)
            frontier.append(neighbor)
    return len(seen) == vertex_count


def conjugate(
    normalizer_element: tuple[int, ...], group_element: tuple[int, ...]
) -> tuple[int, ...]:
    return automorphisms.compose_perm(
        automorphisms.compose_perm(normalizer_element, group_element),
        automorphisms.inverse_perm(normalizer_element),
    )


def symmetric_normalizer(group: set[tuple[int, ...]]) -> set[tuple[int, ...]]:
    return {
        permutation
        for permutation in permutations(range(6))
        if {conjugate(permutation, g) for g in group} == group
    }


def klein_four_subgroups(group: set[tuple[int, ...]]) -> list[frozenset[tuple[int, ...]]]:
    involutions = [g for g in group if automorphisms.perm_order(g) == 2]
    subgroups = set()
    for a, b in combinations(involutions, 2):
        if automorphisms.compose_perm(a, b) != automorphisms.compose_perm(b, a):
            continue
        ab = automorphisms.compose_perm(a, b)
        candidate = frozenset({IDENTITY, a, b, ab})
        if len(candidate) == 4 and all(
            automorphisms.compose_perm(x, y) in candidate
            for x in candidate
            for y in candidate
        ):
            subgroups.add(candidate)
    return sorted(subgroups, key=lambda subgroup: tuple(sorted(subgroup)))


def action_on_klein_fours(
    normalizer: set[tuple[int, ...]],
    subgroups: list[frozenset[tuple[int, ...]]],
) -> set[tuple[int, ...]]:
    index = {subgroup: i for i, subgroup in enumerate(subgroups)}
    action = set()
    for n in normalizer:
        images = []
        for subgroup in subgroups:
            image = frozenset(conjugate(n, g) for g in subgroup)
            assert image in index
            images.append(index[image])
        action.add(tuple(images))
    return action


def syndrome(word: Word) -> Syndrome:
    return tuple(
        sum(word[i] * automorphisms.COLUMNS[i][coordinate] for i in range(6)) % Q
        for coordinate in range(3)
    )  # type: ignore[return-value]


def leader_on_support(target: Syndrome, support: Triple) -> Word:
    ordered_support = tuple(sorted(support))
    basis = automorphisms.matrix_from_columns(
        tuple(automorphisms.COLUMNS[i] for i in ordered_support)
    )
    coefficients = automorphisms.matrix_vec(
        automorphisms.matrix_inverse_3(basis), target
    )
    assert all(coefficient != 0 for coefficient in coefficients)
    word = [0] * 6
    for index, coefficient in zip(ordered_support, coefficients):
        word[index] = coefficient
    result = tuple(word)
    assert syndrome(result) == target
    assert frozenset(i for i, coefficient in enumerate(result) if coefficient) == support
    return result  # type: ignore[return-value]


def transform_word(element: automorphisms.Monomial, word: Word) -> Word:
    permutation, multipliers = element
    result = [0] * 6
    for i in range(6):
        result[permutation[i]] = multipliers[i] * word[i] % Q
    return tuple(result)  # type: ignore[return-value]


def add_words(left: Word, right: Word) -> Word:
    return tuple((a + b) % Q for a, b in zip(left, right))  # type: ignore[return-value]


def parity_check_kernel() -> set[Word]:
    """Construct C=ker(H), using three free coordinates—not row(H)."""
    leading_columns = automorphisms.matrix_from_columns(
        automorphisms.COLUMNS[:3]
    )
    leading_inverse = automorphisms.matrix_inverse_3(leading_columns)
    code = set()
    for free in product(range(Q), repeat=3):
        free_syndrome = tuple(
            sum(free[j] * automorphisms.COLUMNS[j + 3][coordinate] for j in range(3)) % Q
            for coordinate in range(3)
        )
        leading = automorphisms.matrix_vec(
            leading_inverse, tuple((-entry) % Q for entry in free_syndrome)
        )
        word = tuple(leading) + free
        assert syndrome(word) == (0, 0, 0)
        code.add(word)  # type: ignore[arg-type]
    # Invertibility of the leading 3x3 block gives one and only one kernel
    # word for every choice of the final three coordinates.
    assert len(code) == Q**3 == 1331
    return code


def main() -> None:
    lifts = automorphisms.projective_lifts()
    support_group = set(lifts)
    assert len(support_group) == 60

    orbits = triple_orbits(support_group)
    assert [len(orbit) for orbit in orbits] == [10, 10]
    orbit_a, orbit_b = orbits
    assert {complement(triple) for triple in orbit_a} == set(orbit_b)
    assert {complement(triple) for triple in orbit_b} == set(orbit_a)

    pairs = complementary_pairs()
    assert len(pairs) == 10
    assert all(len(pair & orbit_a) == len(pair & orbit_b) == 1 for pair in pairs)
    representatives_a = {pair: next(iter(pair & orbit_a)) for pair in pairs}
    representatives_b = {pair: next(iter(pair & orbit_b)) for pair in pairs}
    edges_a = petersen_edges(pairs, representatives_a)
    edges_b = petersen_edges(pairs, representatives_b)
    assert edges_a == edges_b
    degrees = Counter()
    for edge in edges_a:
        for vertex in edge:
            degrees[vertex] += 1
    assert len(edges_a) == 15
    assert set(degrees.values()) == {3}
    assert len(degrees) == 10
    assert graph_is_connected(10, edges_a)
    adjacency = {vertex: set() for vertex in range(10)}
    for edge in edges_a:
        left, right = tuple(edge)
        adjacency[left].add(right)
        adjacency[right].add(left)
    adjacent_common_neighbors = set()
    nonadjacent_common_neighbors = set()
    for left, right in combinations(range(10), 2):
        common = len(adjacency[left] & adjacency[right])
        if frozenset({left, right}) in edges_a:
            adjacent_common_neighbors.add(common)
        else:
            nonadjacent_common_neighbors.add(common)
    assert adjacent_common_neighbors == {0}
    assert nonadjacent_common_neighbors == {1}

    normalizer = symmetric_normalizer(support_group)
    assert len(normalizer) == 120
    assert support_group < normalizer
    normalizer_order_histogram = Counter(
        automorphisms.perm_order(permutation) for permutation in normalizer
    )
    assert normalizer_order_histogram == Counter(
        {1: 1, 2: 25, 3: 20, 4: 30, 5: 24, 6: 20}
    )

    # The five V4 subgroups of A5 give a faithful degree-five action of the
    # normalizer.  Its image has 120 elements, hence is all S5.
    klein_fours = klein_four_subgroups(support_group)
    assert len(klein_fours) == 5
    normalizer_degree_five_action = action_on_klein_fours(normalizer, klein_fours)
    assert len(normalizer_degree_five_action) == 120

    # Edge's/Dye's five self-polar triangles are combinatorially the five
    # synthemes in the unique A5-invariant synthematic total.  Pairing two
    # triangles gives an alternating six-cycle, whose bipartition is one of
    # the ten complementary three-support pairs.
    matchings = perfect_matchings()
    assert len(matchings) == 15
    totals = synthematic_totals(matchings)
    assert len(totals) == 6
    support_fixed_totals = {
        total
        for total in totals
        if all(act_on_total(g, total) == total for g in support_group)
    }
    normalizer_fixed_totals = {
        total
        for total in totals
        if all(act_on_total(g, total) == total for g in normalizer)
    }
    assert len(support_fixed_totals) == 1
    assert support_fixed_totals == normalizer_fixed_totals
    invariant_total = next(iter(support_fixed_totals))
    triangles = sorted(invariant_total, key=matching_key)
    assert len(triangles) == 5
    for triangle in triangles:
        chord_lines = [
            cross_product(
                automorphisms.COLUMNS[i], automorphisms.COLUMNS[j]
            )
            for i, j in (tuple(pair) for pair in triangle)
        ]
        triangle_vertices = [
            cross_product(
                chord_lines[(i + 1) % 3], chord_lines[(i + 2) % 3]
            )
            for i in range(3)
        ]
        assert all(any(vertex) for vertex in triangle_vertices)
        assert all(
            automorphisms.proportionality_scalar(
                chord_lines[i], conic_polar(triangle_vertices[i])
            )
            is not None
            for i in range(3)
        )
    triangle_index = {triangle: i for i, triangle in enumerate(triangles)}
    normalizer_triangle_action = {
        tuple(triangle_index[act_on_matching(g, triangle)] for triangle in triangles)
        for g in normalizer
    }
    support_triangle_action = {
        tuple(triangle_index[act_on_matching(g, triangle)] for triangle in triangles)
        for g in support_group
    }
    assert len(normalizer_triangle_action) == 120
    assert len(support_triangle_action) == 60

    triangle_pair_to_support_pair = {
        frozenset({i, j}): alternating_bipartition(triangles[i], triangles[j])
        for i, j in combinations(range(5), 2)
    }
    assert len(triangle_pair_to_support_pair) == 10
    assert set(triangle_pair_to_support_pair.values()) == set(pairs)
    triangle_pair_equivariance_checks = 0
    for g in normalizer:
        for triangle_pair, support_pair in triangle_pair_to_support_pair.items():
            transformed_triangle_pair = frozenset(
                triangle_index[act_on_matching(g, triangles[i])]
                for i in triangle_pair
            )
            transformed_support_pair = frozenset(
                act_on_subset(g, triple) for triple in support_pair
            )
            assert (
                triangle_pair_to_support_pair[transformed_triangle_pair]
                == transformed_support_pair
            )
            triangle_pair_equivariance_checks += 1
    assert triangle_pair_equivariance_checks == 120 * 10

    # The alternating cycle of each triangle pair has a unique antipodal
    # perfect matching.  The ten resulting matchings are exactly the ten
    # synthemes outside the invariant total.  Their chord triples are the ten
    # Brianchon concurrences of the displayed Clebsch hexagon.
    triangle_pair_to_antipodal_matching = {
        triangle_pair: antipodal_matching(
            triangles[tuple(triangle_pair)[0]],
            triangles[tuple(triangle_pair)[1]],
        )
        for triangle_pair in triangle_pair_to_support_pair
    }
    assert len(set(triangle_pair_to_antipodal_matching.values())) == 10
    assert set(triangle_pair_to_antipodal_matching.values()) == matchings - invariant_total

    triangle_pair_to_brianchon_point = {
        triangle_pair: concurrence_point(matching)
        for triangle_pair, matching in triangle_pair_to_antipodal_matching.items()
    }
    brianchon_points = set(triangle_pair_to_brianchon_point.values())
    assert len(brianchon_points) == 10

    support_pair_to_brianchon_point = {
        triangle_pair_to_support_pair[triangle_pair]: point
        for triangle_pair, point in triangle_pair_to_brianchon_point.items()
    }
    assert len(support_pair_to_brianchon_point) == 10
    assert set(support_pair_to_brianchon_point) == set(pairs)
    assert set(support_pair_to_brianchon_point.values()) == brianchon_points

    brianchon_combinatorial_equivariance_checks = 0
    for g in normalizer:
        for triangle_pair, antipodal in triangle_pair_to_antipodal_matching.items():
            transformed_triangle_pair = frozenset(
                triangle_index[act_on_matching(g, triangles[i])]
                for i in triangle_pair
            )
            assert (
                triangle_pair_to_antipodal_matching[transformed_triangle_pair]
                == act_on_matching(g, antipodal)
            )
            transformed_support_pair = frozenset(
                act_on_subset(g, triple)
                for triple in triangle_pair_to_support_pair[triangle_pair]
            )
            assert (
                triangle_pair_to_support_pair[transformed_triangle_pair]
                == transformed_support_pair
            )
            brianchon_combinatorial_equivariance_checks += 1
    assert brianchon_combinatorial_equivariance_checks == 120 * 10

    brianchon_geometric_equivariance_checks = 0
    support_brianchon_compatibility_checks = 0
    for g in support_group:
        projectivity, _ = lifts[g]
        for triangle_pair, point in triangle_pair_to_brianchon_point.items():
            transformed_triangle_pair = frozenset(
                triangle_index[act_on_matching(g, triangles[i])]
                for i in triangle_pair
            )
            transformed_point = projective_normalize(
                automorphisms.matrix_vec(projectivity, point)
            )
            assert (
                triangle_pair_to_brianchon_point[transformed_triangle_pair]
                == transformed_point
            )
            transformed_support_pair = frozenset(
                act_on_subset(g, triple)
                for triple in triangle_pair_to_support_pair[triangle_pair]
            )
            assert support_pair_to_brianchon_point[transformed_support_pair] == transformed_point
            brianchon_geometric_equivariance_checks += 1
            support_brianchon_compatibility_checks += 1
    assert brianchon_geometric_equivariance_checks == 60 * 10
    assert support_brianchon_compatibility_checks == 60 * 10

    # Independently enumerate every intersection of two chords with four
    # distinct endpoints.  There are 45 formal intersections.  The geometric
    # ledger has exactly ten triple points and fifteen singleton points, and
    # its triple points are precisely the points constructed above.
    chords = {
        frozenset(pair): chord_line(frozenset(pair))
        for pair in combinations(range(6), 2)
    }
    assert len(chords) == 15
    assert len(set(chords.values())) == 15
    formal_disjoint_chord_intersections = []
    for left, right in combinations(chords, 2):
        if left.isdisjoint(right):
            formal_disjoint_chord_intersections.append(
                projective_normalize(cross_product(chords[left], chords[right]))
            )
    assert len(formal_disjoint_chord_intersections) == 45
    disjoint_chord_intersection_multiplicities = Counter(
        formal_disjoint_chord_intersections
    )
    assert len(disjoint_chord_intersection_multiplicities) == 25
    assert Counter(disjoint_chord_intersection_multiplicities.values()) == Counter(
        {1: 15, 3: 10}
    )
    triple_chord_points = {
        point
        for point, multiplicity in disjoint_chord_intersection_multiplicities.items()
        if multiplicity == 3
    }
    assert triple_chord_points == brianchon_points

    pair_index = {pair: i for i, pair in enumerate(pairs)}
    disjoint_triangle_pair_edges = {
        frozenset(
            {
                pair_index[triangle_pair_to_support_pair[left]],
                pair_index[triangle_pair_to_support_pair[right]],
            }
        )
        for left, right in combinations(triangle_pair_to_support_pair, 2)
        if left.isdisjoint(right)
    }
    assert disjoint_triangle_pair_edges == set(edges_a)

    outside = normalizer - support_group
    assert len(outside) == 60
    assert all(
        {act_on_subset(permutation, triple) for triple in orbit_a} == set(orbit_b)
        and {act_on_subset(permutation, triple) for triple in orbit_b} == set(orbit_a)
        for permutation in outside
    )

    monomial = automorphisms.monomial_group(lifts)
    assert len(monomial) == 600
    monomial_support_image = {permutation for permutation, _ in monomial}
    assert monomial_support_image == support_group
    assert outside.isdisjoint(monomial_support_image)

    holes = automorphisms.nonzero_conic_syndromes()
    assert len(holes) == 120
    low_weight_syndromes = {
        tuple(
            (a * automorphisms.COLUMNS[i][coordinate]
             + b * automorphisms.COLUMNS[j][coordinate])
            % Q
            for coordinate in range(3)
        )
        for i, j in combinations(range(6), 2)
        for a, b in product(range(Q), repeat=2)
    }
    assert holes.isdisjoint(low_weight_syndromes)

    triples = sorted(orbit_a | orbit_b, key=lambda triple: tuple(sorted(triple)))
    leaders: dict[tuple[Syndrome, Triple], Word] = {}
    chirality_count = Counter()
    per_syndrome_counts = set()
    per_syndrome_splits = set()
    for target in sorted(holes):
        local_words = set()
        local_split = Counter()
        for support in triples:
            word = leader_on_support(target, support)
            leaders[(target, support)] = word
            local_words.add(word)
            chirality = 0 if support in orbit_a else 1
            local_split[chirality] += 1
            chirality_count[chirality] += 1
        per_syndrome_counts.add(len(local_words))
        per_syndrome_splits.add((local_split[0], local_split[1]))

    assert per_syndrome_counts == {20}
    assert per_syndrome_splits == {(10, 10)}
    assert len(leaders) == 2400
    assert len(set(leaders.values())) == 2400
    assert chirality_count == Counter({0: 1200, 1: 1200})

    equivariance_checks = 0
    for element, syndrome_matrix in monomial.items():
        permutation, _ = element
        for (target, support), word in leaders.items():
            transformed_target = automorphisms.matrix_vec(syndrome_matrix, target)
            transformed_support = act_on_subset(permutation, support)
            transformed_word = transform_word(element, word)
            assert transformed_target in holes
            assert transformed_word == leaders[(transformed_target, transformed_support)]
            assert (support in orbit_a) == (transformed_support in orbit_a)
            equivariance_checks += 1
    assert equivariance_checks == 600 * 2400

    word_metadata = {word: key for key, word in leaders.items()}
    assert len(word_metadata) == 2400
    unseen_leaders = set(word_metadata)
    leader_orbit_records = []
    while unseen_leaders:
        representative = min(unseen_leaders)
        orbit = {transform_word(element, representative) for element in monomial}
        assert orbit <= set(word_metadata)
        orbit_chirality = Counter(
            0 if word_metadata[word][1] in orbit_a else 1 for word in orbit
        )
        stabilizer_order = sum(
            transform_word(element, representative) == representative
            for element in monomial
        )
        assert len(orbit) * stabilizer_order == len(monomial)
        leader_orbit_records.append(
            (0 if word_metadata[representative][1] in orbit_a else 1,
             representative, orbit, orbit_chirality, stabilizer_order)
        )
        unseen_leaders -= orbit
    leader_orbit_records.sort(key=lambda record: (record[0], record[1]))
    assert len(leader_orbit_records) == 4
    assert [len(record[2]) for record in leader_orbit_records] == [600] * 4
    assert [record[4] for record in leader_orbit_records] == [1] * 4
    assert [record[3] for record in leader_orbit_records] == [
        Counter({0: 600}), Counter({0: 600}),
        Counter({1: 600}), Counter({1: 600}),
    ]

    base_syndrome = min(holes)
    syndrome_stabilizer = {
        element
        for element, syndrome_matrix in monomial.items()
        if automorphisms.matrix_vec(syndrome_matrix, base_syndrome) == base_syndrome
    }
    assert len(syndrome_stabilizer) == 5
    local_leader_set = {
        leaders[(base_syndrome, support)] for support in triples
    }
    local_unseen = set(local_leader_set)
    local_orbit_records = []
    while local_unseen:
        representative = min(local_unseen)
        orbit = {
            transform_word(element, representative)
            for element in syndrome_stabilizer
        }
        assert orbit <= local_leader_set
        chirality = {
            0 if word_metadata[word][1] in orbit_a else 1 for word in orbit
        }
        assert len(chirality) == 1
        local_orbit_records.append((orbit, next(iter(chirality))))
        local_unseen -= orbit
    assert sorted(len(record[0]) for record in local_orbit_records) == [5, 5, 5, 5]
    assert Counter(record[1] for record in local_orbit_records) == Counter({0: 2, 1: 2})

    # The translation group is the actual parity-check kernel C, not the
    # dual row space row(H).  Since the first three columns are invertible,
    # the explicit 1,331-word construction is the whole kernel.
    code = parity_check_kernel()
    kernel_preservation_checks = 0
    for element in monomial:
        for codeword in code:
            assert syndrome(transform_word(element, codeword)) == (0, 0, 0)
            kernel_preservation_checks += 1
    assert kernel_preservation_checks == 600 * 1331

    base_leader = leaders[(base_syndrome, triples[0])]
    syndrome_representatives = {}
    for element, syndrome_matrix in monomial.items():
        transformed_word = transform_word(element, base_leader)
        transformed_syndrome = automorphisms.matrix_vec(
            syndrome_matrix, base_syndrome
        )
        assert syndrome(transformed_word) == transformed_syndrome
        syndrome_representatives.setdefault(transformed_syndrome, transformed_word)
    assert set(syndrome_representatives) == holes
    assert len(syndrome_representatives) == 120

    affine_deep_hole_orbit = set()
    for target, representative in syndrome_representatives.items():
        fiber = {add_words(representative, codeword) for codeword in code}
        assert len(fiber) == 1331
        assert all(syndrome(word) == target for word in fiber)
        affine_deep_hole_orbit.update(fiber)
    assert len(affine_deep_hole_orbit) == 120 * 1331 == 159720
    assert {syndrome(word) for word in affine_deep_hole_orbit} == holes

    print(f"field=F_{Q}")
    print(f"support_group_order={len(support_group)}")
    print(f"triple_orbit_sizes={[len(orbit) for orbit in orbits]}")
    print("complement_swaps_triple_orbits=True")
    print(f"complementary_pairs={len(pairs)}")
    print(f"petersen_degree={next(iter(set(degrees.values())))}")
    print(f"petersen_edges={len(edges_a)}")
    print("petersen_connected=True")
    print("petersen_adjacent_common_neighbors=0")
    print("petersen_nonadjacent_common_neighbors=1")
    print("petersen_strongly_regular_parameters=[10, 3, 0, 1]")
    print("petersen_independent_of_orbit_representatives=True")
    print(f"perfect_matchings={len(matchings)}")
    print(f"synthematic_totals={len(totals)}")
    print(f"A5_invariant_synthematic_totals={len(support_fixed_totals)}")
    print(f"invariant_synthematic_total_size={len(invariant_total)}")
    print("invariant_synthematic_total_self_polar_for_XZ_eq_Y2=True")
    print(f"triangle_pairs={len(triangle_pair_to_support_pair)}")
    print("triangle_pair_support_bijection=True")
    print(f"triangle_pair_equivariance_checks={triangle_pair_equivariance_checks}")
    print("petersen_adjacency=disjoint_triangle_pairs")
    print("triangle_pair_antipodal_matchings=10")
    print("antipodal_matchings=complement_of_invariant_total")
    print(f"brianchon_points={len(brianchon_points)}")
    print("brianchon_chord_concurrences=10")
    print("formal_disjoint_chord_intersections=45")
    print("disjoint_chord_intersection_multiplicities=[1x15, 3x10]")
    print("multiplicity_three_points_equal_brianchon_points=True")
    print(
        "brianchon_combinatorial_equivariance_checks="
        f"{brianchon_combinatorial_equivariance_checks}"
    )
    print(
        "brianchon_geometric_equivariance_checks="
        f"{brianchon_geometric_equivariance_checks}"
    )
    print(
        "support_brianchon_compatibility_checks="
        f"{support_brianchon_compatibility_checks}"
    )
    brianchon_dictionary = []
    for triangle_pair in sorted(
        triangle_pair_to_brianchon_point, key=lambda pair: tuple(sorted(pair))
    ):
        triangle_label = "T" + "T".join(str(i) for i in sorted(triangle_pair))
        antipodal_label = "|".join(
            "".join(str(i) for i in sorted(pair))
            for pair in sorted(
                triangle_pair_to_antipodal_matching[triangle_pair],
                key=lambda pair: tuple(sorted(pair)),
            )
        )
        support_label = "|".join(
            "".join(str(i) for i in sorted(triple))
            for triple in sorted(
                triangle_pair_to_support_pair[triangle_pair],
                key=lambda triple: tuple(sorted(triple)),
            )
        )
        point_label = ",".join(
            str(coordinate)
            for coordinate in triangle_pair_to_brianchon_point[triangle_pair]
        )
        brianchon_dictionary.append(
            f"{triangle_label}:{antipodal_label}:{support_label}:({point_label})"
        )
    print("brianchon_dictionary=[" + "; ".join(brianchon_dictionary) + "]")
    print("normalizer_triangle_action=S5")
    print(f"normalizer_S6_order={len(normalizer)}")
    print("normalizer_identification=S5")
    print(f"normalizer_outside={len(outside)}")
    print(f"normalizer_outside_swapping_orbits={len(outside)}")
    print("outside_in_monomial_support_image=0")
    print(f"deep_hole_affine_syndromes={len(holes)}")
    print("leaders_per_syndrome=20")
    print("leader_chirality_per_syndrome=[10, 10]")
    print(f"global_syndrome_leader_pairs={len(leaders)}")
    print(f"global_distinct_leaders={len(set(leaders.values()))}")
    print(
        "global_chirality_counts="
        f"[{chirality_count[0]}, {chirality_count[1]}]"
    )
    print(f"monomial_automorphisms_checked={len(monomial)}")
    print(f"coefficient_equivariance_checks={equivariance_checks}")
    print(f"leader_monomial_orbits={len(leader_orbit_records)}")
    print(
        "leader_monomial_orbit_sizes="
        f"{[len(record[2]) for record in leader_orbit_records]}"
    )
    print(
        "leader_monomial_orbit_chirality_counts="
        f"{[[record[3][0], record[3][1]] for record in leader_orbit_records]}"
    )
    print(
        "leader_monomial_stabilizer_orders="
        f"{[record[4] for record in leader_orbit_records]}"
    )
    print(f"deep_hole_syndrome_stabilizer_order={len(syndrome_stabilizer)}")
    print("fixed_syndrome_leader_orbit_sizes=[5, 5, 5, 5]")
    print("fixed_syndrome_leader_orbits_per_chirality=[2, 2]")
    print(f"translation_codewords={len(code)}")
    print("translation_code_is_parity_check_kernel=True")
    print(f"kernel_preservation_checks={kernel_preservation_checks}")
    print(f"received_word_deep_holes={len(affine_deep_hole_orbit)}")
    print(f"affine_deep_hole_orbit={len(affine_deep_hole_orbit)}")
    print("affine_deep_hole_transitive=True")
    print("orientation_preferred=False")
    print("all assertions passed")


if __name__ == "__main__":
    main()
