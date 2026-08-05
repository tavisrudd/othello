#!/usr/bin/env python3
"""Exact E6 tritangent code and its E6 x A2 bracket-support lift."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "2026-07-29-c697-schlafli-hodge-e6.py"
OUTPUT = HERE / "2026-08-04-c682-e6-e8-code-ladder.json"
PRIMES = (2, 3, 5, 7, 11, 13)


def load_source():
    spec = importlib.util.spec_from_file_location("c682_e6_source", SOURCE)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def rank_mod(matrix, prime):
    work = [[entry % prime for entry in row] for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, prime)
        work[row] = [(inverse * entry) % prime for entry in work[row]]
        for index in range(len(work)):
            if index == row or not work[index][column]:
                continue
            scale = work[index][column]
            work[index] = [
                (left - scale * right) % prime
                for left, right in zip(work[index], work[row], strict=True)
            ]
        row += 1
    return row


def binary_nullspace(row_masks, length):
    pivots = []
    rows = []
    for value in row_masks:
        for pivot, basis_row in zip(pivots, rows, strict=True):
            if (value >> pivot) & 1:
                value ^= basis_row
        if not value:
            continue
        pivot = (value & -value).bit_length() - 1
        for index, basis_row in enumerate(rows):
            if (basis_row >> pivot) & 1:
                rows[index] ^= value
        position = sum(old < pivot for old in pivots)
        pivots.insert(position, pivot)
        rows.insert(position, value)
    free = [column for column in range(length) if column not in pivots]
    basis = []
    for column in free:
        value = 1 << column
        for pivot, basis_row in reversed(list(zip(pivots, rows, strict=True))):
            if (basis_row & value).bit_count() & 1:
                value ^= 1 << pivot
        basis.append(value)
    return basis


def span(basis):
    words = []
    for coefficients in range(1 << len(basis)):
        word = 0
        for index, vector in enumerate(basis):
            if (coefficients >> index) & 1:
                word ^= vector
        words.append(word)
    return tuple(sorted(words))


def enumerator(words):
    return {
        str(weight): multiplicity
        for weight, multiplicity in sorted(
            Counter(word.bit_count() for word in words).items()
        )
    }


def cartan_support(module):
    mixed = [
        (f"x{i}", f"y{j}", f"w{min(i, j)}{max(i, j)}")
        for i in module.INDICES
        for j in module.INDICES
        if i != j
    ]
    pfaffian = [
        tuple(f"w{i}{j}" for i, j in matching)
        for matching in module.perfect_matchings(module.INDICES)
    ]
    edges = tuple(mixed + pfaffian)
    assert len(edges) == 45 and len(set(edges)) == 45
    return tuple(module.VERTICES), edges


def two_section_connected(vertices, edges):
    neighbors = {vertex: set() for vertex in vertices}
    for edge in edges:
        for left, right in itertools.combinations(edge, 2):
            neighbors[left].add(right)
            neighbors[right].add(left)
    seen = {vertices[0]}
    frontier = [vertices[0]]
    while frontier:
        vertex = frontier.pop()
        for neighbor in neighbors[vertex] - seen:
            seen.add(neighbor)
            frontier.append(neighbor)
    return len(seen) == len(vertices)


def lift_word(word, color_word, length):
    result = 0
    for vertex in range(length):
        bit = (word >> vertex) & 1
        for color in range(3):
            if bit ^ ((color_word >> color) & 1):
                result |= 1 << (3 * vertex + color)
    return result


def certificate():
    module = load_source()
    vertices, edges = cartan_support(module)
    assert two_section_connected(vertices, edges)
    vertex_index = {vertex: index for index, vertex in enumerate(vertices)}
    base_rows = [
        sum(1 << vertex_index[vertex] for vertex in edge) for edge in edges
    ]
    base_matrix = [
        [(row >> column) & 1 for column in range(len(vertices))]
        for row in base_rows
    ]
    base_basis = binary_nullspace(base_rows, len(vertices))
    base_words = span(base_basis)
    base_weights = enumerator(base_words)
    assert len(base_basis) == 6
    assert base_weights == {"0": 1, "12": 36, "16": 27}

    intersection_neighbors = [0] * len(vertices)
    for edge in edges:
        for left, right in itertools.combinations(edge, 2):
            i = vertex_index[left]
            j = vertex_index[right]
            intersection_neighbors[i] |= 1 << j
            intersection_neighbors[j] |= 1 << i
    sixers = []
    for indices in itertools.combinations(range(len(vertices)), 6):
        support = sum(1 << index for index in indices)
        if all(not (intersection_neighbors[index] & support) for index in indices):
            sixers.append(support)
    assert len(sixers) == 72
    double_sixes = set()
    for first_row in sixers:
        candidates = [
            index
            for index in range(len(vertices))
            if not ((first_row >> index) & 1)
            and (intersection_neighbors[index] & first_row).bit_count() == 5
        ]
        for indices in itertools.combinations(candidates, 6):
            second_row = sum(1 << index for index in indices)
            if all(
                not (intersection_neighbors[index] & second_row)
                for index in indices
            ):
                double_sixes.add(first_row | second_row)
    minimum_supports = {word for word in base_words if word.bit_count() == 12}
    assert len(double_sixes) == 36
    assert minimum_supports == double_sixes
    minimum_shell_rank = len(vertices) - len(
        binary_nullspace(sorted(minimum_supports), len(vertices))
    )
    assert minimum_shell_rank == 6

    pair_counts = {}
    recovered_intersections = set()
    for left, right in itertools.combinations(range(len(vertices)), 2):
        count = sum(
            ((support >> left) & 1) and ((support >> right) & 1)
            for support in minimum_supports
        )
        pair_counts[count] = pair_counts.get(count, 0) + 1
        if count == 8:
            recovered_intersections.add((left, right))
    expected_intersections = {
        tuple(sorted((vertex_index[left], vertex_index[right])))
        for edge in edges
        for left, right in itertools.combinations(edge, 2)
    }
    assert pair_counts == {6: 216, 8: 135}
    assert recovered_intersections == expected_intersections
    recovered_tritangents = {
        triple
        for triple in itertools.combinations(range(len(vertices)), 3)
        if all(
            tuple(sorted(pair)) in recovered_intersections
            for pair in itertools.combinations(triple, 2)
        )
    }
    expected_tritangents = {
        tuple(sorted(vertex_index[vertex] for vertex in edge)) for edge in edges
    }
    assert recovered_tritangents == expected_tritangents

    lifted_rows = []
    for edge in edges:
        for colors in itertools.permutations(range(3)):
            row = 0
            for vertex, color in zip(edge, colors, strict=True):
                row |= 1 << (3 * vertex_index[vertex] + color)
            lifted_rows.append(row)
    assert len(lifted_rows) == 270 and len(set(lifted_rows)) == 270
    lifted_matrix = [
        [(row >> column) & 1 for column in range(3 * len(vertices))]
        for row in lifted_rows
    ]
    lifted_basis = binary_nullspace(lifted_rows, 3 * len(vertices))
    lifted_words_elimination = span(lifted_basis)
    even_color_words = (0b000, 0b011, 0b101, 0b110)
    lifted_words_formula = tuple(
        sorted(
            lift_word(word, colors, len(vertices))
            for word in base_words
            for colors in even_color_words
        )
    )
    assert len(set(lifted_words_formula)) == 256
    assert lifted_words_formula == lifted_words_elimination
    lifted_weights = enumerator(lifted_words_formula)
    assert len(lifted_basis) == 8
    assert lifted_weights == {
        "0": 1,
        "36": 36,
        "38": 81,
        "42": 108,
        "48": 27,
        "54": 3,
    }
    predicted = Counter()
    for weight_text, multiplicity in base_weights.items():
        weight = int(weight_text)
        predicted[3 * weight] += multiplicity
        predicted[2 * len(vertices) - weight] += 3 * multiplicity
    assert dict(sorted(predicted.items())) == {
        int(weight): multiplicity for weight, multiplicity in lifted_weights.items()
    }

    ranks = {
        str(prime): rank_mod(lifted_matrix, prime) for prime in PRIMES
    }
    assert set(ranks.values()) == {73}
    base_ranks = {
        str(prime): rank_mod(base_matrix, prime) for prime in PRIMES
    }
    assert set(base_ranks.values()) == {21}

    return {
        "schema": "c682-e6-e8-code-ladder-v1",
        "trusted_input": {
            "path": SOURCE.name,
            "sha256": hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
            "role": "canonical 27 labels and 45 Cartan tritangent monomials",
        },
        "e6_tritangent_code": {
            "coordinates": 27,
            "checks": 45,
            "check_weight": 3,
            "ranks_by_prime": base_ranks,
            "binary_parameters": [27, 6, 12],
            "binary_weight_enumerator": base_weights,
            "maximum_nonzero_weight": 16,
            "minimum_shell": {
                "size": 36,
                "span_dimension": minimum_shell_rank,
                "equals_all_schlaefli_double_sixes": True,
                "sixers_enumerated": len(sixers),
                "double_sixes_enumerated": len(double_sixes),
                "pair_cooccurrence_profile": {
                    str(count): multiplicity
                    for count, multiplicity in sorted(pair_counts.items())
                },
                "intersection_relation_recovered_by_cooccurrence_8": True,
                "tritangent_planes_recovered_as_45_triangles": True,
            },
        },
        "e6_a2_bracket_support_lift": {
            "coordinates": 81,
            "checks": 270,
            "check_weight": 3,
            "construction": "45 E6 tritangents times all 6 A2 color bijections",
            "ranks_by_prime": ranks,
            "binary_parameters": [81, 8, 36],
            "binary_weight_enumerator": lifted_weights,
        },
        "normal_form": {
            "formula": "x_(v,a) = u_v + s_a",
            "u_space": "kernel of the 45-by-27 E6 tritangent incidence matrix",
            "s_space": ["000", "011", "101", "110"],
            "two_section_connected": True,
            "elimination_equals_formula_word_set": True,
            "dimension_formula": "k+2",
            "distance_formula": "min(3*d, 2*n-maxwt(D))",
            "weight_enumerator_formula_checked": True,
        },
        "bounded_scope": {
            "primes_with_rank_checked": list(PRIMES),
            "binary_codewords_enumerated": {
                "base": len(base_words),
                "lift": len(lifted_words_formula),
            },
            "claim": "support-incidence code of the E8 bracket tensor",
            "not_claimed": "kernel of a scalar cubic on 27 tensor 3",
        },
    }


def serialized():
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    payload = serialized()
    if args.check:
        assert OUTPUT.read_text() == payload
        print("C682 E6/E8 code-ladder certificate matches")
    elif args.write:
        OUTPUT.write_text(payload)
        print(OUTPUT)
    else:
        print(payload, end="")


if __name__ == "__main__":
    main()
