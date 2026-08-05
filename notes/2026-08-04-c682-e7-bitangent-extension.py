#!/usr/bin/env python3
"""Exact E7 bitangent code and its shortening to the E6 tritangent code."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
E6_SOURCE = HERE / "2026-08-04-c682-e6-e8-code-ladder.py"
OUTPUT = HERE / "2026-08-04-c682-e7-bitangent-extension.json"


def parity(value):
    return value.bit_count() & 1


def qform(point, vector):
    """q_(a,b)(x,y) = x.y + a.x + b.y on F_2^3 + F_2^3."""
    a, b = point
    x, y = vector
    return parity(x & y) ^ parity(a & x) ^ parity(b & y)


def symplectic(left, right):
    x, y = left
    u, v = right
    return parity(x & v) ^ parity(y & u)


def odd_quadratics():
    return tuple(
        (a, b) for a in range(8) for b in range(8) if parity(a & b) == 1
    )


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


def rank_binary(rows, length):
    pivots = {}
    for value in rows:
        while value:
            pivot = value.bit_length() - 1
            if pivot in pivots:
                value ^= pivots[pivot]
            else:
                pivots[pivot] = value
                break
    assert all(value < (1 << length) for value in pivots.values())
    return len(pivots)


def shorten(words, coordinate, length):
    low = (1 << coordinate) - 1
    return tuple(
        sorted(
            (word & low) | ((word >> (coordinate + 1)) << coordinate)
            for word in words
            if not ((word >> coordinate) & 1)
        )
    )


def pair_cooccurrences(words, length):
    counts = {}
    for left, right in itertools.combinations(range(length), 2):
        counts[(left, right)] = sum(
            ((word >> left) & 1) and ((word >> right) & 1) for word in words
        )
    return counts


def adjacency_from_pair_count(words, length, target):
    adjacency = [0] * length
    for (left, right), count in pair_cooccurrences(words, length).items():
        if count == target:
            adjacency[left] |= 1 << right
            adjacency[right] |= 1 << left
    return tuple(adjacency)


def refine_colors(left_graph, right_graph, paired):
    """Shared equitable refinement with already paired vertices individualized."""
    size = len(left_graph)
    left_colors = [0] * size
    right_colors = [0] * size
    for color, (left, right) in enumerate(paired, start=1):
        left_colors[left] = color
        right_colors[right] = color
    while True:
        color_count = max(left_colors + right_colors) + 1

        def signatures(graph, colors):
            answer = []
            for vertex in range(size):
                counts = [0] * color_count
                neighbors = graph[vertex]
                while neighbors:
                    bit = neighbors & -neighbors
                    neighbor = bit.bit_length() - 1
                    counts[colors[neighbor]] += 1
                    neighbors ^= bit
                answer.append((colors[vertex], tuple(counts)))
            return answer

        left_signatures = signatures(left_graph, left_colors)
        right_signatures = signatures(right_graph, right_colors)
        labels = {
            signature: index
            for index, signature in enumerate(
                sorted(set(left_signatures + right_signatures))
            )
        }
        new_left = [labels[signature] for signature in left_signatures]
        new_right = [labels[signature] for signature in right_signatures]
        if Counter(new_left) != Counter(new_right):
            return None
        if new_left == left_colors and new_right == right_colors:
            return new_left, new_right
        left_colors, right_colors = new_left, new_right


def graph_isomorphism(left_graph, right_graph):
    assert len(left_graph) == len(right_graph)
    size = len(left_graph)

    def search(paired):
        refined = refine_colors(left_graph, right_graph, paired)
        if refined is None:
            return None
        left_colors, right_colors = refined
        classes = Counter(left_colors)
        if all(count == 1 for count in classes.values()):
            right_by_color = {color: vertex for vertex, color in enumerate(right_colors)}
            mapping = tuple(right_by_color[color] for color in left_colors)
            if all(
                ((left_graph[i] >> j) & 1)
                == ((right_graph[mapping[i]] >> mapping[j]) & 1)
                for i in range(size)
                for j in range(size)
            ):
                return mapping
            return None
        color = min(
            (color for color, count in classes.items() if count > 1),
            key=lambda entry: (classes[entry], entry),
        )
        left_vertex = next(
            vertex for vertex, entry in enumerate(left_colors) if entry == color
        )
        used_left = {left for left, _ in paired}
        used_right = {right for _, right in paired}
        if left_vertex in used_left:
            return None
        candidates = [
            vertex
            for vertex, entry in enumerate(right_colors)
            if entry == color and vertex not in used_right
        ]
        for right_vertex in candidates:
            result = search(paired + ((left_vertex, right_vertex),))
            if result is not None:
                return result
        return None

    result = search(())
    assert result is not None
    return result


def permute_word(word, mapping):
    answer = 0
    for source, target in enumerate(mapping):
        if (word >> source) & 1:
            answer |= 1 << target
    return answer


def generator_columns(rows, length):
    return tuple(
        sum(
            ((row >> coordinate) & 1) << index
            for index, row in enumerate(rows)
        )
        for coordinate in range(length)
    )


def zero_sum_subsets(columns, size):
    answer = []
    for indices in itertools.combinations(range(len(columns)), size):
        total = 0
        for index in indices:
            total ^= columns[index]
        if total == 0:
            answer.append(indices)
    return tuple(answer)


def load_e6_module():
    spec = importlib.util.spec_from_file_location("c682_e6_ladder", E6_SOURCE)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def certificate():
    points = odd_quadratics()
    assert len(points) == 28
    vectors = tuple(
        (x, y) for x in range(8) for y in range(8) if (x, y) != (0, 0)
    )
    assert len(vectors) == 63

    ones = (1 << len(points)) - 1
    affine_basis = [ones]
    for bit in range(3):
        affine_basis.append(
            sum(((a >> bit) & 1) << index for index, (a, _) in enumerate(points))
        )
    for bit in range(3):
        affine_basis.append(
            sum(((b >> bit) & 1) << index for index, (_, b) in enumerate(points))
        )
    code = span(affine_basis)
    assert len(code) == 128
    assert enumerator(code) == {"0": 1, "12": 63, "16": 63, "28": 1}

    steiner_by_vector = {}
    for vector in vectors:
        support = sum(
            (1 << index)
            for index, point in enumerate(points)
            if qform(point, vector) == 0
        )
        assert support.bit_count() == 12
        steiner_by_vector[vector] = support
    minimum_shell = {word for word in code if word.bit_count() == 12}
    assert minimum_shell == set(steiner_by_vector.values())
    assert rank_binary(minimum_shell, 28) == 7

    shell_intersections = {0: Counter(), 1: Counter()}
    for left, right in itertools.combinations(vectors, 2):
        shell_intersections[symplectic(left, right)][
            (steiner_by_vector[left] & steiner_by_vector[right]).bit_count()
        ] += 1
    assert shell_intersections == {
        0: Counter({4: 945}),
        1: Counter({6: 1008}),
    }
    coordinate_pair_counts = Counter(pair_cooccurrences(minimum_shell, 28).values())
    assert coordinate_pair_counts == Counter({11: 378})
    assert all(
        (left & right).bit_count() % 2 == 0
        for left in affine_basis
        for right in affine_basis
    )
    columns = generator_columns(affine_basis, 28)
    assert not zero_sum_subsets(columns, 1)
    assert not zero_sum_subsets(columns, 2)
    assert not zero_sum_subsets(columns, 3)
    syzygetic_tetrads = zero_sum_subsets(columns, 4)
    assert len(syzygetic_tetrads) == 315
    column_supports = {
        sum(
            1 << vector_index
            for vector_index, vector in enumerate(vectors)
            if (steiner_by_vector[vector] >> coordinate) & 1
        )
        for coordinate in range(28)
    }
    assert len(column_supports) == 28
    assert {support.bit_count() for support in column_supports} == {27}

    shortening_enumerators = Counter()
    for coordinate in range(28):
        shortened = shorten(code, coordinate, 28)
        shortening_enumerators[tuple(enumerator(shortened).items())] += 1
    expected_short_enumerator = {"0": 1, "12": 36, "16": 27}
    assert shortening_enumerators == Counter(
        {tuple(expected_short_enumerator.items()): 28}
    )

    fixed_coordinate = 0
    fixed_shortened = shorten(code, fixed_coordinate, 28)
    short_minimum = {
        word for word in fixed_shortened if word.bit_count() == 12
    }
    short_pair_counts = Counter(pair_cooccurrences(short_minimum, 27).values())
    assert short_pair_counts == Counter({6: 216, 8: 135})

    e6 = load_e6_module()
    source = e6.load_source()
    vertices, edges = e6.cartan_support(source)
    vertex_index = {vertex: index for index, vertex in enumerate(vertices)}
    e6_rows = [
        sum(1 << vertex_index[vertex] for vertex in edge) for edge in edges
    ]
    e6_basis = e6.binary_nullspace(e6_rows, len(vertices))
    e6_code = e6.span(e6_basis)
    e6_minimum = {word for word in e6_code if word.bit_count() == 12}
    short_graph = adjacency_from_pair_count(short_minimum, 27, 8)
    e6_graph = adjacency_from_pair_count(e6_minimum, 27, 8)
    mapping = graph_isomorphism(short_graph, e6_graph)
    transported_code = tuple(sorted(permute_word(word, mapping) for word in fixed_shortened))
    assert transported_code == e6_code
    assert {permute_word(word, mapping) for word in short_minimum} == e6_minimum
    e6_columns = generator_columns(e6_basis, 27)
    assert not zero_sum_subsets(e6_columns, 1)
    assert not zero_sum_subsets(e6_columns, 2)
    assert zero_sum_subsets(e6_columns, 3)

    # Griesmer excludes distance 13 at both parameter sets.
    griesmer_28_7_13 = sum((13 + (1 << power) - 1) >> power for power in range(7))
    griesmer_27_6_13 = sum((13 + (1 << power) - 1) >> power for power in range(6))
    assert griesmer_28_7_13 == 29
    assert griesmer_27_6_13 == 28

    input_hashes = {
        path.name: hashlib.sha256(path.read_bytes()).hexdigest()
        for path in (E6_SOURCE, e6.SOURCE)
    }
    return {
        "construction": {
            "coordinates": "28 odd quadratic refinements of a 6D symplectic F2-space",
            "minimum_shell": "63 Steiner complexes indexed by nonzero vectors",
        },
        "e7_code": {
            "parameters": [28, 7, 12],
            "weight_enumerator": enumerator(code),
            "minimum_shell_size": len(minimum_shell),
            "minimum_shell_rank": rank_binary(minimum_shell, 28),
            "coordinate_pair_cooccurrences": dict(sorted(coordinate_pair_counts.items())),
            "shell_intersections_by_symplectic_pairing": {
                str(pairing): dict(sorted(counts.items()))
                for pairing, counts in shell_intersections.items()
            },
            "transposed_column_count": len(column_supports),
            "transposed_column_weight": 27,
            "design": "2-(28,12,11)",
            "dual_parameters": [28, 21, 4],
            "dual_minimum_shell_size": len(syzygetic_tetrads),
            "dual_minimum_shell": "315 syzygetic tetrads",
            "self_orthogonal": True,
            "css_parameters": [28, 14, 4],
        },
        "shortening": {
            "all_coordinates_checked": 28,
            "parameters": [27, 6, 12],
            "weight_enumerator": expected_short_enumerator,
            "minimum_shell_pair_cooccurrences": dict(sorted(short_pair_counts.items())),
            "exactly_equivalent_to_e6_tritangent_code": True,
            "e6_dual_distance": 3,
            "e6_css_parameters": [27, 15, 3],
            "coordinate_mapping_to_e6_labels": {
                str(source_index): vertices[target_index]
                for source_index, target_index in enumerate(mapping)
            },
        },
        "optimality": {
            "griesmer_length_for_28_7_13": griesmer_28_7_13,
            "griesmer_length_for_27_6_13": griesmer_27_6_13,
        },
        "input_sha256": input_hashes,
    }


def serialized():
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    payload = serialized()
    if args.check:
        assert OUTPUT.read_text() == payload
    if args.write:
        OUTPUT.write_text(payload)
    if not args.check and not args.write:
        print(payload, end="")


if __name__ == "__main__":
    main()
