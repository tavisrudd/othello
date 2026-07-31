#!/usr/bin/env python3
"""Exact C705 certificate for the Clebsch/Pauli-doily comparison."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from itertools import combinations, permutations, product
from math import prod
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

    def permute_word(word: int, permutation: tuple[int, ...]) -> int:
        return sum(
            ((word >> index) & 1) << permutation[index]
            for index in range(len(permutation))
        )

    automorphism_count = 0
    isodual_count = 0
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
        if is_automorphism:
            automorphism_count += 1
        if is_isodual:
            isodual_count += 1
            if first_isodual_permutation is None:
                first_isodual_permutation = permutation
    assert automorphism_count == isodual_count == 720
    assert first_isodual_permutation is not None

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
        "schema": "c705-clebsch-pauli-doily-v2",
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
