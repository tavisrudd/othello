#!/usr/bin/env python3
"""Exact decoding census and equivariant-list checks for the Clebsch code.

The syndrome and nearest-word census is replayed independently from first
principles over F_11.  The final symmetry section deliberately separates:

* the 60-element projective A5 action on coordinate supports; and
* the 600-element monomial automorphism action on coefficient-bearing words.

The latter uses the exact projective lifts from ``check_code_automorphisms``
and the word-action primitives from ``check_chirality``.  This avoids treating
projective ray stabilizers as affine-syndrome stabilizers.  Every printed
headline has a preceding fail-closed assertion.  No third-party packages are
required.
"""

from __future__ import annotations

from collections import Counter
from itertools import combinations, product

import check_chirality as chirality
import check_code_automorphisms as automorphisms


Q = 11
ZERO_SYNDROME = (0, 0, 0)
Point = tuple[int, int, int]
Syndrome = tuple[int, int, int]
Word = tuple[int, int, int, int, int, int]
Support = frozenset[int]


def normalize(vector: Point) -> Point:
    """Canonical projective representative with first nonzero entry one."""
    pivot = next(entry % Q for entry in vector if entry % Q)
    inverse = pow(pivot, Q - 2, Q)
    return tuple(entry * inverse % Q for entry in vector)  # type: ignore[return-value]


def cross(left: Point, right: Point) -> Point:
    return normalize(
        (
            left[1] * right[2] - left[2] * right[1],
            left[2] * right[0] - left[0] * right[2],
            left[0] * right[1] - left[1] * right[0],
        )
    )


def dot(left: Point, right: Point) -> int:
    return sum(a * b for a, b in zip(left, right)) % Q


def determinant(left: Point, middle: Point, right: Point) -> int:
    return (
        left[0] * (middle[1] * right[2] - middle[2] * right[1])
        - left[1] * (middle[0] * right[2] - middle[2] * right[0])
        + left[2] * (middle[0] * right[1] - middle[1] * right[0])
    ) % Q


def syndrome(word: Word) -> Syndrome:
    return tuple(
        sum(automorphisms.COLUMNS[column][row] * word[column] for column in range(6)) % Q
        for row in range(3)
    )  # type: ignore[return-value]


def hamming_weight(word: Word) -> int:
    return sum(entry != 0 for entry in word)


def hamming_support(word: Word) -> Support:
    return frozenset(index for index, entry in enumerate(word) if entry)


def projective_points() -> list[Point]:
    points = {
        normalize(vector)
        for vector in product(range(Q), repeat=3)
        if vector != ZERO_SYNDROME
    }
    result = sorted(points)
    assert len(result) == Q * Q + Q + 1 == 133
    return result


def perfect_matchings() -> set[frozenset[tuple[int, int]]]:
    edges = {tuple(edge) for edge in combinations(range(6), 2)}
    return {
        frozenset(candidate)
        for candidate in combinations(edges, 3)
        if set().union(*(set(edge) for edge in candidate)) == set(range(6))
    }


def main() -> None:
    points = projective_points()
    arc = tuple(normalize(column) for column in automorphisms.COLUMNS)
    assert len(set(arc)) == 6
    assert all(determinant(*triple) != 0 for triple in combinations(arc, 3))

    conic = {
        point for point in points
        if (point[0] * point[2] - point[1] * point[1]) % Q == 0
    }
    assert len(conic) == Q + 1 == 12
    assert conic.isdisjoint(arc)

    # Independent projective secant-index census.
    secants = {cross(left, right) for left, right in combinations(arc, 2)}
    assert len(secants) == 15
    secant_index = {
        point: sum(dot(line, point) == 0 for line in secants)
        for point in points if point not in arc
    }
    index_spectrum = Counter(secant_index.values())
    assert index_spectrum == Counter({0: 12, 1: 90, 2: 15, 3: 10})
    assert {point for point, index in secant_index.items() if index == 0} == conic
    brianchon_directions = {
        point for point, index in secant_index.items() if index == 3
    }
    assert len(brianchon_directions) == 10

    # Exhaust all coefficient-bearing errors of weights one, two, and three.
    distance: dict[Syndrome, int] = {}
    leaders: dict[Syndrome, set[Word]] = {}
    for weight in (1, 2, 3):
        for support in combinations(range(6), weight):
            for coefficients in product(range(1, Q), repeat=weight):
                mutable = [0] * 6
                for index, coefficient in zip(support, coefficients):
                    mutable[index] = coefficient
                word: Word = tuple(mutable)  # type: ignore[assignment]
                target = syndrome(word)
                if target == ZERO_SYNDROME:
                    continue
                if target not in distance:
                    distance[target] = weight
                    leaders[target] = {word}
                elif distance[target] == weight:
                    leaders[target].add(word)

    assert len(distance) == Q**3 - 1 == 1330
    assert all(hamming_weight(word) == distance[target]
               for target, words in leaders.items() for word in words)
    coset_distance_distribution = Counter(distance.values())
    assert coset_distance_distribution == Counter({1: 60, 2: 1150, 3: 120})

    # Complete O(1) syndrome-distance decision tree, including the zero coset.
    arc_directions = set(arc)
    for target in product(range(Q), repeat=3):
        if target == ZERO_SYNDROME:
            expected = 0
        elif normalize(target) in arc_directions:
            expected = 1
        elif (target[0] * target[2] - target[1] * target[1]) % Q == 0:
            expected = 3
        else:
            expected = 2
        actual = 0 if target == ZERO_SYNDROME else distance[target]
        assert actual == expected

    ambiguity_distribution = Counter(len(words) for words in leaders.values())
    assert ambiguity_distribution == Counter({1: 960, 2: 150, 3: 100, 20: 120})

    all_triples = {frozenset(triple) for triple in combinations(range(6), 3)}
    assert len(all_triples) == 20
    for target, minimum in distance.items():
        supports = {hamming_support(word) for word in leaders[target]}
        assert len(supports) == len(leaders[target])
        if minimum == 2:
            assert len(leaders[target]) == secant_index[normalize(target)]
        elif minimum == 3:
            assert supports == all_triples

    # Triple ambiguity gives ten perfect matchings, precisely the complement
    # of one synthematic total.
    ambiguity_matching_by_direction: dict[Point, frozenset[tuple[int, int]]] = {}
    for target, minimum in distance.items():
        if minimum != 2 or len(leaders[target]) != 3:
            continue
        supports = frozenset(
            tuple(sorted(hamming_support(word))) for word in leaders[target]
        )
        assert sorted(vertex for edge in supports for vertex in edge) == list(range(6))
        direction = normalize(target)
        if direction in ambiguity_matching_by_direction:
            assert ambiguity_matching_by_direction[direction] == supports
        else:
            ambiguity_matching_by_direction[direction] = supports
    assert set(ambiguity_matching_by_direction) == brianchon_directions
    ambiguity_matchings = set(ambiguity_matching_by_direction.values())
    assert len(ambiguity_matchings) == 10
    all_matchings = perfect_matchings()
    assert len(all_matchings) == 15
    invariant_total = all_matchings - ambiguity_matchings
    assert len(invariant_total) == 5
    total_edges = [edge for matching in invariant_total for edge in matching]
    assert len(total_edges) == len(set(total_edges)) == 15

    # Projective A5 support action.  This does not yet assert coefficient-level
    # monomial equivariance.
    lifts = automorphisms.projective_lifts()
    projective_support_group = set(lifts)
    assert len(projective_support_group) == 60
    assert automorphisms.IDENTITY_PERM in projective_support_group
    assert all(
        automorphisms.compose_perm(left, right) in projective_support_group
        for left in projective_support_group for right in projective_support_group
    )
    assert all(
        automorphisms.normal_closure(element, projective_support_group)
        == projective_support_group
        for element in projective_support_group
        if element != automorphisms.IDENTITY_PERM
    )
    support_orbits = chirality.triple_orbits(projective_support_group)
    assert [len(orbit) for orbit in support_orbits] == [10, 10]
    orbit_a, orbit_b = support_orbits
    assert {chirality.complement(support) for support in orbit_a} == set(orbit_b)
    assert {chirality.complement(support) for support in orbit_b} == set(orbit_a)

    # Full coefficient-bearing monomial action.  The support image is exactly
    # the projective A5, but the extra scalar/lambda data is essential for
    # acting on words and affine syndrome vectors.
    monomial_group = automorphisms.monomial_group(lifts)
    assert len(monomial_group) == 600
    automorphisms.verify_monomial_group(monomial_group)
    assert {element[0] for element in monomial_group} == projective_support_group
    holes = {target for target, minimum in distance.items() if minimum == 3}
    assert holes == automorphisms.nonzero_conic_syndromes()
    assert len(holes) == 120

    exact_deep_leader: dict[tuple[Syndrome, Support], Word] = {}
    for target in holes:
        for support in all_triples:
            word = chirality.leader_on_support(target, support)
            assert word in leaders[target]
            exact_deep_leader[target, support] = word
    assert len(exact_deep_leader) == 2400
    assert len(set(exact_deep_leader.values())) == 2400

    coefficient_equivariance_checks = 0
    for element, syndrome_matrix in monomial_group.items():
        permutation, _ = element
        for (target, support), word in exact_deep_leader.items():
            transformed_target = automorphisms.matrix_vec(syndrome_matrix, target)
            transformed_support = chirality.act_on_subset(permutation, support)
            transformed_word = chirality.transform_word(element, word)
            assert transformed_word == exact_deep_leader[
                transformed_target, transformed_support
            ]
            assert (support in orbit_a) == (transformed_support in orbit_a)
            coefficient_equivariance_checks += 1
    assert coefficient_equivariance_checks == 600 * 2400 == 1_440_000

    # The two chirality decoders are unordered alternatives.  Each returns ten
    # leaders and is equivariant under the full 600-element monomial group.
    chirality_a_lists = {
        target: {exact_deep_leader[target, support] for support in orbit_a}
        for target in holes
    }
    chirality_b_lists = {
        target: {exact_deep_leader[target, support] for support in orbit_b}
        for target in holes
    }
    assert {len(words) for words in chirality_a_lists.values()} == {10}
    assert {len(words) for words in chirality_b_lists.values()} == {10}

    # Use an affine syndrome stabilizer, not merely a projective direction
    # stabilizer, for the lower bound on equivariant nonempty returned lists.
    base_syndrome = min(holes)
    affine_syndrome_stabilizer = {
        element for element, syndrome_matrix in monomial_group.items()
        if automorphisms.matrix_vec(syndrome_matrix, base_syndrome) == base_syndrome
    }
    assert len(affine_syndrome_stabilizer) == 5
    local_words = leaders[base_syndrome]
    unseen = set(local_words)
    local_orbits: list[set[Word]] = []
    while unseen:
        representative = min(unseen)
        orbit = {
            chirality.transform_word(element, representative)
            for element in affine_syndrome_stabilizer
        }
        assert orbit <= local_words
        local_orbits.append(orbit)
        unseen -= orbit
    assert sorted(len(orbit) for orbit in local_orbits) == [5, 5, 5, 5]
    local_chirality = Counter()
    for orbit in local_orbits:
        support_classes = {
            0 if hamming_support(word) in orbit_a else 1 for word in orbit
        }
        assert len(support_classes) == 1
        local_chirality[next(iter(support_classes))] += 1
    assert local_chirality == Counter({0: 2, 1: 2})
    minimum_nonempty_invariant_list_size = min(len(orbit) for orbit in local_orbits)
    assert minimum_nonempty_invariant_list_size == 5

    # Each of the four stabilizer orbits transports consistently to every
    # deep-hole syndrome, giving four full monomial-equivariant size-five
    # decoders.  This proves attainability as well as the local lower bound.
    assert {
        automorphisms.matrix_vec(matrix, base_syndrome)
        for matrix in monomial_group.values()
    } == holes
    minimal_equivariant_decoders: list[dict[Syndrome, set[Word]]] = []
    for base_orbit in local_orbits:
        decoder: dict[Syndrome, set[Word]] = {}
        for element, syndrome_matrix in monomial_group.items():
            target = automorphisms.matrix_vec(syndrome_matrix, base_syndrome)
            image = {
                chirality.transform_word(element, word) for word in base_orbit
            }
            assert image <= leaders[target]
            if target in decoder:
                assert decoder[target] == image
            else:
                decoder[target] = image
        assert set(decoder) == holes
        assert {len(words) for words in decoder.values()} == {5}
        minimal_equivariant_decoders.append(decoder)
    assert len(minimal_equivariant_decoders) == 4
    assert len({frozenset(decoder[base_syndrome])
                for decoder in minimal_equivariant_decoders}) == 4

    minimal_decoder_equivariance_checks = 0
    for decoder in minimal_equivariant_decoders:
        for element, syndrome_matrix in monomial_group.items():
            for target, words in decoder.items():
                transformed_target = automorphisms.matrix_vec(syndrome_matrix, target)
                transformed_words = {
                    chirality.transform_word(element, word) for word in words
                }
                assert transformed_words == decoder[transformed_target]
                minimal_decoder_equivariance_checks += 1
    assert minimal_decoder_equivariance_checks == 4 * 600 * 120 == 288_000

    # Output only after every corresponding assertion has passed.
    print("field=F_11")
    print("projective_points=133")
    print("secants=15")
    print("secant_index_spectrum=[n0:12,n1:90,n2:15,n3:10]")
    print("uncovered_directions=standard_conic_12")
    print("brianchon_directions=10")
    print("nonzero_coset_distance_distribution=[d1:60,d2:1150,d3:120]")
    print("syndrome_distance_oracle=[zero:0,arc_ray:1,conic_ray:3,otherwise:2]")
    print("nearest_word_ambiguity_distribution=[1:960,2:150,3:100,20:120]")
    print("distance_two_leader_count=secant_index")
    print("deep_hole_supports=all_20_triples")
    print("triple_ambiguity_matchings=10")
    print("triple_ambiguity_matchings=complement_of_one_synthematic_total")
    print("projective_support_group_order=60")
    print("projective_support_group=A5")
    print("projective_A5_triple_orbits=[10,10]")
    print("complement_swaps_projective_triple_orbits=True")
    print("monomial_automorphism_group_order=600")
    print("monomial_support_image=projective_A5")
    print("coefficient_equivariance_checks=1440000")
    print("chirality_decoder_list_sizes=[10,10]")
    print("chirality_decoders_full_monomial_equivariant=True")
    print("chirality_orientation_preferred=False")
    print("affine_deep_hole_syndrome_stabilizer_order=5")
    print("affine_stabilizer_leader_orbit_sizes=[5,5,5,5]")
    print("affine_stabilizer_orbits_per_chirality=[2,2]")
    print("minimum_nonempty_equivariant_list_size_at_deep_hole=5")
    print("size_five_full_monomial_equivariant_decoders=4")
    print("minimal_decoder_equivariance_checks=288000")
    print("all assertions passed")


if __name__ == "__main__":
    main()
