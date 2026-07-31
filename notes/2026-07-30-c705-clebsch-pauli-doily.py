#!/usr/bin/env python3
"""Exact C705 certificate for the Clebsch/Pauli-doily comparison."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from itertools import combinations, permutations, product
from math import lcm, prod
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-30-c705-clebsch-pauli-doily.json"

C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)


def parity(word: tuple[int, ...]) -> int:
    inversions = sum(
        word[i] > word[j]
        for i in range(len(word))
        for j in range(i + 1, len(word))
    )
    return -1 if inversions % 2 else 1


def perfect_matchings(vertices: tuple[int, ...] = tuple(range(6))):
    if not vertices:
        yield ()
        return
    first = vertices[0]
    for second in vertices[1:]:
        remainder = tuple(v for v in vertices[1:] if v != second)
        for tail in perfect_matchings(remainder):
            yield ((first, second),) + tail


def bit_dot(left: int, right: int) -> int:
    return (left & right).bit_count()


def symplectic(left: tuple[int, int], right: tuple[int, int]) -> int:
    x, z = left
    y, t = right
    return (bit_dot(x, t) + bit_dot(z, y)) % 2


ODD_CHARACTERISTICS = tuple(
    (a, b)
    for a in range(4)
    for b in range(4)
    if bit_dot(a, b) % 2
)


def duad_vector(i: int, j: int) -> tuple[int, int]:
    a_i, b_i = ODD_CHARACTERISTICS[i]
    a_j, b_j = ODD_CHARACTERISTICS[j]
    # Q_i+Q_j=B((b_i+b_j,a_i+a_j),-).
    return b_i ^ b_j, a_i ^ a_j


def pauli_name(vector: tuple[int, int]) -> str:
    x, z = vector
    labels = {(0, 0): "I", (1, 0): "X", (0, 1): "Z", (1, 1): "Y"}
    return "".join(labels[((x >> bit) & 1, (z >> bit) & 1)] for bit in range(2))


def pauli_multiply(
    state: tuple[complex, tuple[int, int]],
    vector: tuple[int, int],
) -> tuple[complex, tuple[int, int]]:
    """Multiply Hermitian P(x,z)=i^(x.z) X^x Z^z using exact fourth roots."""
    phase, (x, z) = state
    y, t = vector
    exponent = bit_dot(x, z) + bit_dot(y, t) - bit_dot(x ^ y, z ^ t)
    phase *= (1j**exponent) * ((-1) ** bit_dot(z, y))
    return phase, (x ^ y, z ^ t)


def context_pauli_sign(matching: tuple[tuple[int, int], ...]) -> int:
    state = (1 + 0j, (0, 0))
    for pair in matching:
        state = pauli_multiply(state, duad_vector(*pair))
    phase, vector = state
    assert vector == (0, 0) and phase.imag == 0
    return int(phase.real)


def pfaffian_sign(matching: tuple[tuple[int, int], ...]) -> int:
    word = tuple(index for pair in matching for index in pair)
    return parity(word)


def clebsch_context_sign(matching: tuple[tuple[int, int], ...]) -> int:
    return pfaffian_sign(matching) * prod(C[i][j] for i, j in matching)


def triangle_sign(i: int, j: int, k: int) -> int:
    return C[i][j] * C[j][k] * C[k][i]


def triangle_pauli_phase(i: int, j: int, k: int) -> int:
    state = (1 + 0j, (0, 0))
    for pair in ((i, j), (j, k), (i, k)):
        state = pauli_multiply(state, duad_vector(*pair))
    phase, vector = state
    assert vector == (0, 0) and phase.real == 0
    return int((phase / 1j).real)


def gf2_rank(rows: list[int], width: int) -> int:
    work = list(rows)
    rank = 0
    for column in range(width):
        pivot = next(
            (row for row in range(rank, len(work)) if (work[row] >> column) & 1),
            None,
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        for row in range(len(work)):
            if row != rank and ((work[row] >> column) & 1):
                work[row] ^= work[rank]
        rank += 1
    return rank


def gf2_solve(rows: list[int], rhs: list[int], width: int) -> tuple[int, ...]:
    work = [row | (value << width) for row, value in zip(rows, rhs)]
    pivot_columns: list[int] = []
    rank = 0
    for column in range(width):
        pivot = next(
            (row for row in range(rank, len(work)) if (work[row] >> column) & 1),
            None,
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        for row in range(len(work)):
            if row != rank and ((work[row] >> column) & 1):
                work[row] ^= work[rank]
        pivot_columns.append(column)
        rank += 1
    mask = (1 << width) - 1
    assert all((row & mask) or not ((row >> width) & 1) for row in work)
    solution = [0] * width
    for row, column in enumerate(pivot_columns):
        solution[column] = (work[row] >> width) & 1
    return tuple(solution)


def induced_symplectic_maps(duads, duad_index) -> int:
    maps = set()
    for permutation in permutations(range(6)):
        image = {}
        for i, j in duads:
            source = duad_vector(i, j)
            target_pair = tuple(sorted((permutation[i], permutation[j])))
            image[source] = duad_vector(*target_pair)
        assert len(image) == 15
        for left in image:
            for right in image:
                assert image[(left[0] ^ right[0], left[1] ^ right[1])] == (
                    image[left][0] ^ image[right][0],
                    image[left][1] ^ image[right][1],
                ) if left != right else True
                assert symplectic(left, right) == symplectic(image[left], image[right])
        maps.add(tuple(image[duad_vector(*pair)] for pair in duads))
    assert len(maps) == 720
    assert len(duad_index) == 15
    return len(maps)


def build_certificate() -> dict:
    duads = tuple(combinations(range(6), 2))
    matchings = tuple(perfect_matchings())
    duad_index = {pair: index for index, pair in enumerate(duads)}
    vectors = tuple(duad_vector(*pair) for pair in duads)
    assert len(ODD_CHARACTERISTICS) == 6
    assert len(set(vectors)) == 15
    assert set(vectors) == set(product(range(4), repeat=2)) - {(0, 0)}

    for matching in matchings:
        context = tuple(duad_vector(*pair) for pair in matching)
        assert all(symplectic(left, right) == 0 for left, right in combinations(context, 2))
        assert (context[0][0] ^ context[1][0] ^ context[2][0]) == 0
        assert (context[0][1] ^ context[1][1] ^ context[2][1]) == 0

    incidence_rows = [
        sum(1 << duad_index[pair] for pair in matching)
        for matching in matchings
    ]
    incidence_rank = gf2_rank(incidence_rows, len(duads))
    assert incidence_rank == 10

    clebsch_signs = tuple(clebsch_context_sign(matching) for matching in matchings)
    pauli_signs = tuple(context_pauli_sign(matching) for matching in matchings)
    rhs = [int(left != right) for left, right in zip(clebsch_signs, pauli_signs)]
    gauge_bits = gf2_solve(incidence_rows, rhs, len(duads))
    gauge = tuple(-1 if bit else 1 for bit in gauge_bits)
    assert all(
        clebsch_signs[index]
        == pauli_signs[index] * prod(gauge[duad_index[pair]] for pair in matching)
        for index, matching in enumerate(matchings)
    )

    # The Clebsch factor is itself point gauge: deleting C leaves the same class.
    pfaffian_signs = tuple(pfaffian_sign(matching) for matching in matchings)
    assert all(
        clebsch_signs[index]
        == pfaffian_signs[index] * prod(C[i][j] for i, j in matching)
        for index, matching in enumerate(matchings)
    )

    grids = []
    node_partitions = []
    grid_context_rows = []
    matching_index = {matching: index for index, matching in enumerate(matchings)}
    for left_tuple in combinations(range(6), 3):
        if 0 not in left_tuple:
            continue
        left = frozenset(left_tuple)
        right = frozenset(set(range(6)) - left)
        points = tuple(pair for pair in duads if (pair[0] in left) != (pair[1] in left))
        lines = tuple(
            matching
            for matching in matchings
            if all((i in left) != (j in left) for i, j in matching)
        )
        assert len(points) == 9 and len(lines) == 6
        assert all(sum(pair in matching for matching in lines) == 2 for pair in points)
        c_parity = prod(clebsch_context_sign(matching) for matching in lines)
        p_parity = prod(context_pauli_sign(matching) for matching in lines)
        pf_parity = prod(pfaffian_sign(matching) for matching in lines)
        assert c_parity == p_parity == pf_parity == -1
        grid_context_rows.append(
            sum(1 << matching_index[matching] for matching in lines)
        )
        node_partitions.append(left)
        grids.append(
            {
                "partition": [sorted(left), sorted(right)],
                "points": ["".join(map(str, pair)) for pair in points],
                "contexts": [
                    ["".join(map(str, pair)) for pair in matching] for matching in lines
                ],
                "clebsch_parity": c_parity,
                "pauli_parity": p_parity,
                "pfaffian_parity": pf_parity,
            }
        )
    assert len(grids) == 10
    grid_checker_rank = gf2_rank(grid_context_rows, len(matchings))
    assert grid_checker_rank == 5
    assert all(
        not sum(
            ((grid_row >> context) & 1)
            * ((incidence_rows[context] >> point) & 1)
            for context in range(len(matchings))
        )
        % 2
        for grid_row in grid_context_rows
        for point in range(len(duads))
    )

    # Grid parities completely classify context signs modulo point rephasing.
    parity_code_generators = tuple(
        sum(
            ((grid_context_rows[grid] >> context) & 1) << grid
            for grid in range(len(grids))
        )
        for context in range(len(matchings))
    )
    parity_code = {0}
    for generator in parity_code_generators:
        parity_code |= {word ^ generator for word in tuple(parity_code)}
    parity_weight_enumerator = dict(
        sorted(Counter(word.bit_count() for word in parity_code).items())
    )
    assert len(parity_code) == 32
    assert parity_weight_enumerator == {0: 1, 4: 15, 6: 15, 10: 1}
    assert (1 << len(grids)) - 1 in parity_code
    weight_four_words = {word for word in parity_code if word.bit_count() == 4}
    assert weight_four_words == set(parity_code_generators)
    assert all(
        sum(((word >> left) & 1) and ((word >> right) & 1) for word in weight_four_words)
        == 2
        for left, right in combinations(range(len(grids)), 2)
    )

    dual_code = {
        word
        for word in range(1 << len(grids))
        if all((word & codeword).bit_count() % 2 == 0 for codeword in parity_code)
    }
    dual_weight_enumerator = dict(
        sorted(Counter(word.bit_count() for word in dual_code).items())
    )
    assert dual_weight_enumerator == parity_weight_enumerator
    assert dual_code != parity_code
    dual_weight_four_words = {word for word in dual_code if word.bit_count() == 4}
    duad_blocks = {
        pair: sum(
            ((pair[0] in partition) == (pair[1] in partition)) << index
            for index, partition in enumerate(node_partitions)
        )
        for pair in duads
    }
    assert set(duad_blocks.values()) == dual_weight_four_words
    all_weight_four_words = weight_four_words | dual_weight_four_words
    assert len(all_weight_four_words) == 30
    assert all(
        sum(
            all((word >> point) & 1 for point in triple)
            for word in all_weight_four_words
        )
        == 1
        for triple in combinations(range(len(grids)), 3)
    )
    hull = parity_code & dual_code
    assert hull == {0, (1 << len(grids)) - 1}
    code_sum = {left ^ right for left in parity_code for right in dual_code}
    assert code_sum == {
        word
        for word in range(1 << len(grids))
        if word.bit_count() % 2 == 0
    }

    def permute_word(word: int, permutation: tuple[int, ...]) -> int:
        return sum(
            ((word >> index) & 1) << permutation[index]
            for index in range(len(permutation))
        )

    def cycle_type(permutation: tuple[int, ...]) -> tuple[int, ...]:
        seen = set()
        lengths = []
        for start in range(len(permutation)):
            if start in seen:
                continue
            point = start
            length = 0
            while point not in seen:
                seen.add(point)
                length += 1
                point = permutation[point]
            lengths.append(length)
        return tuple(sorted(lengths, reverse=True))

    automorphism_count = 0
    isodual_count = 0
    witt_automorphism_count = 0
    isodual_cycle_types: Counter[tuple[int, ...]] = Counter()
    automorphisms = []
    witt_automorphism_permutations = []
    involutory_isodualities = []
    first_isodual_permutation = None
    for permutation in permutations(range(len(grids))):
        is_automorphism = True
        is_isodual = True
        for word in weight_four_words:
            image = permute_word(word, permutation)
            is_automorphism &= image in weight_four_words
            is_isodual &= image in dual_weight_four_words
            if not is_automorphism and not is_isodual:
                break
        is_witt_automorphism = is_automorphism or is_isodual
        if not is_witt_automorphism:
            is_witt_automorphism = all(
                permute_word(word, permutation) in all_weight_four_words
                for word in all_weight_four_words
            )
        if is_automorphism:
            automorphism_count += 1
            automorphisms.append(permutation)
        if is_isodual:
            isodual_count += 1
            kind = cycle_type(permutation)
            isodual_cycle_types[kind] += 1
            if kind == (2, 2, 2, 2, 2):
                involutory_isodualities.append(permutation)
            if first_isodual_permutation is None:
                first_isodual_permutation = permutation
        if is_witt_automorphism:
            witt_automorphism_count += 1
            witt_automorphism_permutations.append(permutation)
    assert automorphism_count == isodual_count == 720
    assert witt_automorphism_count == 1440
    assert isodual_cycle_types == {
        (2, 2, 2, 2, 2): 36,
        (4, 4, 1, 1): 180,
        (8, 1, 1): 180,
        (8, 2): 180,
        (10,): 144,
    }
    assert first_isodual_permutation is not None
    isodual_order_distribution = Counter(
        lcm(*kind)
        for kind, multiplicity in isodual_cycle_types.items()
        for _ in range(multiplicity)
    )
    assert isodual_order_distribution == {2: 36, 4: 180, 8: 360, 10: 144}

    def compose(left, right):
        return tuple(left[right[index]] for index in range(len(left)))

    def inverse(permutation):
        result = [0] * len(permutation)
        for source, target in enumerate(permutation):
            result[target] = source
        return tuple(result)

    polarity = involutory_isodualities[0]
    assert {
        compose(compose(automorphism, polarity), inverse(automorphism))
        for automorphism in automorphisms
    } == set(involutory_isodualities)

    def induced_node_permutation(permutation):
        result = []
        for partition in node_partitions:
            image = frozenset(permutation[index] for index in partition)
            if 0 not in image:
                image = frozenset(set(range(6)) - image)
            result.append(node_partitions.index(image))
        return tuple(result)

    inner_node_group = {
        induced_node_permutation(permutation)
        for permutation in permutations(range(6))
    }
    assert inner_node_group == set(automorphisms)
    identity_node_permutation = tuple(range(len(grids)))
    assert [
        permutation
        for permutation in witt_automorphism_permutations
        if all(
            compose(permutation, inner) == compose(inner, permutation)
            for inner in inner_node_group
        )
    ] == [identity_node_permutation]

    # A dual block is a duad, a primal block a syntheme.  Every polarity
    # therefore realizes an exceptional duad--syntheme outer automorphism.
    matching_by_block = {
        generator: matching
        for generator, matching in zip(parity_code_generators, matchings)
    }
    polarity_duad_syntheme_maps = {
        polarity: {
            pair: matching_by_block[permute_word(block, polarity)]
            for pair, block in duad_blocks.items()
        }
        for polarity in involutory_isodualities
    }
    assert all(
        set(mapping.values()) == set(matchings)
        for mapping in polarity_duad_syntheme_maps.values()
    )

    # The golden conference marking has a 120-element switching stabilizer.
    # Its sign-preserving half is the A5 action already visible in C705.
    def conference_switch_data(permutation):
        for global_factor in (1, -1):
            switches = (1,) + tuple(
                global_factor
                * C[permutation[0]][permutation[index]]
                * C[0][index]
                for index in range(1, 6)
            )
            if all(
                C[permutation[i]][permutation[j]]
                == global_factor * switches[i] * switches[j] * C[i][j]
                for i, j in duads
            ):
                return global_factor, switches
        return None

    conference_group = tuple(
        (
            permutation,
            conference_switch_data(permutation),
            induced_node_permutation(permutation),
        )
        for permutation in permutations(range(6))
        if conference_switch_data(permutation) is not None
    )
    assert len(conference_group) == 120
    assert Counter(data[0] for _, data, _ in conference_group) == {1: 60, -1: 60}
    conference_a5 = tuple(
        item for item in conference_group if item[1][0] == 1
    )

    remaining_polarities = set(involutory_isodualities)
    conference_polarity_orbits = []
    while remaining_polarities:
        representative = next(iter(remaining_polarities))
        orbit = {
            compose(compose(node_map, representative), inverse(node_map))
            for _, _, node_map in conference_group
        }
        conference_polarity_orbits.append(orbit)
        remaining_polarities -= orbit
    assert sorted(map(len, conference_polarity_orbits)) == [6, 30]
    special_polarities = next(
        orbit for orbit in conference_polarity_orbits if len(orbit) == 6
    )

    special_polarity_axes = {}
    for special_polarity in special_polarities:
        stabilizer = tuple(
            permutation
            for permutation, _, node_map in conference_a5
            if compose(
                compose(node_map, special_polarity),
                inverse(node_map),
            )
            == special_polarity
        )
        assert len(stabilizer) == 10
        fixed_axes = tuple(
            axis
            for axis in range(6)
            if all(permutation[axis] == axis for permutation in stabilizer)
        )
        assert len(fixed_axes) == 1
        special_polarity_axes[fixed_axes[0]] = special_polarity
    assert set(special_polarity_axes) == set(range(6))

    # A tempting frozen-sign selector fails: no polarity directly matches
    # the conference duad signs with the induced Clebsch syntheme signs.
    clebsch_sign_by_matching = dict(zip(matchings, clebsch_signs))
    frozen_sign_mismatch_distribution = Counter(
        sum(
            C[pair[0]][pair[1]]
            != clebsch_sign_by_matching[matching]
            for pair, matching in mapping.items()
        )
        for mapping in polarity_duad_syntheme_maps.values()
    )
    assert frozen_sign_mismatch_distribution == {3: 2, 5: 10, 7: 16, 9: 8}

    # Explicit equivalence with Seymour's exceptional regular-matroid code R10.
    r10_parity_check_rows = (
        0b0000110011,
        0b0001000111,
        0b0010001110,
        0b0100011100,
        0b1000011001,
    )
    r10 = {
        word
        for word in range(1 << len(grids))
        if all(
            (word & check).bit_count() % 2 == 0
            for check in r10_parity_check_rows
        )
    }
    r10_weight_four = {word for word in r10 if word.bit_count() == 4}
    r10_equivalence = next(
        permutation
        for permutation in permutations(range(len(grids)))
        if all(
            permute_word(word, permutation) in r10_weight_four
            for word in weight_four_words
        )
    )
    assert r10_equivalence == (0, 1, 2, 6, 4, 9, 3, 7, 8, 5)

    ovoids = []
    for vertex in range(6):
        points = tuple(pair for pair in duads if vertex in pair)
        assert len(points) == 5
        assert all(
            symplectic(duad_vector(*left), duad_vector(*right)) == 1
            for left, right in combinations(points, 2)
        )
        ovoids.append(["".join(map(str, pair)) for pair in points])

    triangles = []
    for i, j, k in combinations(range(6), 3):
        phase = triangle_pauli_phase(i, j, k)
        triangles.append(
            {
                "triple": [i, j, k],
                "K_diagonal_over_4": triangle_sign(i, j, k),
                "pauli_phase_over_i": phase,
            }
        )
    for quadruple in combinations(range(6), 4):
        assert prod(triangle_sign(*triple) for triple in combinations(quadruple, 3)) == 1
        assert prod(triangle_pauli_phase(*triple) for triple in combinations(quadruple, 3)) == 1

    # Switching C changes every line sign by one common, hence gauge-trivial, factor.
    for switch in product((-1, 1), repeat=6):
        global_factor = prod(switch)
        for matching in matchings:
            switched = pfaffian_sign(matching) * prod(
                switch[i] * C[i][j] * switch[j] for i, j in matching
            )
            assert switched == global_factor * clebsch_context_sign(matching)

    return {
        "schema": "c705-clebsch-pauli-doily-v3",
        "odd_theta_characteristics": [list(pair) for pair in ODD_CHARACTERISTICS],
        "duads": [
            {
                "duad": list(pair),
                "symplectic_vector_xz": list(vector),
                "pauli": pauli_name(vector),
                "clebsch_point_gauge": C[pair[0]][pair[1]],
                "comparison_gauge": gauge[index],
            }
            for index, (pair, vector) in enumerate(zip(duads, vectors))
        ],
        "counts": {
            "points": len(duads),
            "contexts": len(matchings),
            "grids": len(grids),
            "ovoids": len(ovoids),
            "S6_induced_symplectic_maps": induced_symplectic_maps(duads, duad_index),
            "incidence_rank_F2": incidence_rank,
            "grid_checker_rank_F2": grid_checker_rank,
            "ordinary_gauge_quotient_dimension": len(matchings) - incidence_rank,
            "parity_code_automorphism_order": automorphism_count,
            "parity_code_isodual_maps": isodual_count,
            "witt_design_automorphism_order": witt_automorphism_count,
            "involutory_isodual_maps": isodual_cycle_types[(2, 2, 2, 2, 2)],
            "conference_switching_group_order": len(conference_group),
            "conference_selected_polarities": len(special_polarities),
        },
        "contexts": [
            {
                "matching": [list(pair) for pair in matching],
                "pfaffian_sign": pfaffian_signs[index],
                "clebsch_sign": clebsch_signs[index],
                "pauli_sign": pauli_signs[index],
            }
            for index, matching in enumerate(matchings)
        ],
        "grids": grids,
        "ovoids": ovoids,
        "triangles": triangles,
        "ordinary_gauge_classification": {
            "grid_checks_span_full_left_kernel": True,
            "grid_parities_are_complete_gauge_invariants": True,
            "parity_code_parameters": [10, 5, 4],
            "parity_code_weight_enumerator": {
                str(weight): multiplicity
                for weight, multiplicity in parity_weight_enumerator.items()
            },
            "weight_four_words_are_context_blocks": True,
            "weight_four_design_parameters": [2, 10, 4, 2],
            "full_permutation_automorphism_group_order": automorphism_count,
            "code_is_self_dual": False,
            "code_is_isodual": True,
            "dual_weight_enumerator": {
                str(weight): multiplicity
                for weight, multiplicity in dual_weight_enumerator.items()
            },
            "isodual_permutation_count": isodual_count,
            "first_isodual_permutation": list(first_isodual_permutation),
            "hull_dimension": 1,
            "hull_generator": "1111111111",
            "code_plus_dual_is_even_weight_code": True,
            "minimum_blocks_with_dual_form_S_3_4_10": True,
            "minimum_block_union_size": len(all_weight_four_words),
            "minimum_block_union_automorphism_order": witt_automorphism_count,
            "isodual_cycle_type_distribution": {
                ",".join(map(str, kind)): multiplicity
                for kind, multiplicity in sorted(isodual_cycle_types.items())
            },
            "isodual_order_distribution": {
                str(order): multiplicity
                for order, multiplicity in sorted(isodual_order_distribution.items())
            },
            "involutory_isodual_maps_are_fixed_point_free": True,
            "involutory_isodual_maps_form_one_automorphism_conjugacy_class": True,
            "dual_minimum_blocks_are_duad_same_side_blocks": True,
            "witt_halves_are_synthemes_and_duads": True,
            "witt_group_realizes_Aut_S6_outer_extension": True,
            "conference_polarity_orbit_sizes": sorted(
                map(len, conference_polarity_orbits)
            ),
            "special_polarities_are_equivariantly_indexed_by_six_axes": True,
            "special_polarity_by_axis": {
                str(axis): list(permutation)
                for axis, permutation in sorted(special_polarity_axes.items())
            },
            "direct_conference_to_clebsch_sign_mismatch_distribution": {
                str(distance): multiplicity
                for distance, multiplicity
                in sorted(frozen_sign_mismatch_distribution.items())
            },
            "r10_parity_check_rows": [
                f"{row:010b}"[::-1] for row in r10_parity_check_rows
            ],
            "coordinate_equivalence_to_R10": list(r10_equivalence),
            "clebsch_and_pauli_parity_word": "1111111111",
        },
        "conclusions": {
            "incidence_dictionary": True,
            "all_ten_grid_parities_are_negative": True,
            "clebsch_and_pauli_context_signs_are_point_gauge_equivalent": True,
            "clebsch_conference_factor_is_point_gauge": True,
            "usual_contextuality_class_depends_on_C_or_K": False,
            "K_triangle_and_pauli_triangle_signs_are_both_simplex_coboundaries": True,
            "no_further_unrestricted_context_sign_invariant_remains": True,
            "ordinary_gauge_quotient_recovers_S6_symmetric_node_plane_design": True,
            "ordinary_gauge_quotient_is_isodual_not_self_dual": True,
            "code_dual_minimum_blocks_complete_to_Witt_W10": True,
            "isoduality_torsor_contains_one_36_element_involution_class": True,
            "ordinary_gauge_quotient_is_equivalent_to_Seymour_R10": True,
            "conference_marking_selects_six_axis_indexed_outer_involutions": True,
            "conference_signs_do_not_select_one_by_direct_equality": True,
        },
    }


def canonical_json(value: dict) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    content = canonical_json(build_certificate())
    if args.check:
        assert OUTPUT.read_bytes() == content
        print(
            "PASS C705 Pauli doily: 15 points, 15 contexts, 10 negative "
            "Mermin grids, 6 ovoids; Clebsch factor is gauge-trivial"
        )
        return
    OUTPUT.write_bytes(content)
    print(f"WROTE {OUTPUT.name} sha256={hashlib.sha256(content).hexdigest()}")


if __name__ == "__main__":
    main()
