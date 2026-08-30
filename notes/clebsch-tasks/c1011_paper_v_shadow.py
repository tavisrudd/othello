#!/usr/bin/env python3
"""Exact evidence for the Paper V unmarked metric-shadow obstruction."""

from __future__ import annotations

import argparse
import itertools
import json
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
EXPORT = ROOT / "papers/chordal-conference-reconstruction/verification/evidence/sparse_shadow_export.json"
AXIS = ROOT / "papers/chordal-conference-reconstruction/verification/evidence/paper_ii_chordal_axis.json"
SCOUT = ROOT / "papers/chordal-conference-reconstruction/verification/evidence/frozen/matching_orbit_scout.json"
OUTPUT = Path(__file__).with_suffix(".json")
P = 11


def normalize(vector):
    pivot = next(value % P for value in vector if value % P)
    inverse = pow(pivot, -1, P)
    return tuple(value * inverse % P for value in vector)


def bilinear(left, right):
    return (sum(a * b for a, b in zip(left, right)) + sum(left) * sum(right)) % P


def determinant(matrix):
    work = [row[:] for row in matrix]
    value = 1
    for column in range(len(work)):
        pivot = next(row for row in range(column, len(work)) if work[row][column] % P)
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            value = -value
        entry = work[column][column] % P
        value = value * entry % P
        inverse = pow(entry, -1, P)
        for row in range(column + 1, len(work)):
            scalar = work[row][column] * inverse % P
            for index in range(column, len(work)):
                work[row][index] = (work[row][index] - scalar * work[column][index]) % P
    return value % P


def character(value):
    assert value % P
    return 1 if pow(value % P, (P - 1) // 2, P) == 1 else -1


def pgl_permutations():
    permutations = set()
    for a, b, c, d in itertools.product(range(P), repeat=4):
        if (a * d - b * c) % P == 0:
            continue
        image = []
        for x in range(P + 1):
            if x == P:
                image.append(P if c == 0 else a * pow(c, -1, P) % P)
            else:
                denominator = (c * x + d) % P
                image.append(P if denominator == 0 else (a * x + b) * pow(denominator, -1, P) % P)
        permutations.add(tuple(image))
    assert len(permutations) == 1320
    return sorted(permutations)


def point_label_map(points, projectivity):
    point_index = {normalize(point): index for index, point in enumerate(points)}
    result = []
    for x in range(P + 1):
        vector = [pow(x, 4, P), pow(x, 3, P), x * x % P, x, 1] if x < P else [1, 0, 0, 0, 0]
        image = [sum(projectivity[row][column] * vector[column] for column in range(5)) % P for row in range(5)]
        result.append(point_index[normalize(image)])
    assert sorted(result) == list(range(12))
    return tuple(result)


def matching_image(permutation, matching):
    return tuple(sorted(tuple(sorted((permutation[left], permutation[right]))) for left, right in matching))


def p1_vector(label):
    return (label, 1) if label < P else (1, 0)


def cross_ratio(first, second, third, fourth):
    def bracket(left, right):
        a, b = p1_vector(left), p1_vector(right)
        return (a[0] * b[1] - a[1] * b[0]) % P

    numerator = bracket(fourth, second) * bracket(third, first) % P
    denominator = bracket(fourth, first) * bracket(third, second) % P
    return numerator * pow(denominator, -1, P) % P


def find_path_factor(adjacency):
    degree = len(adjacency)
    paths = []
    for middle in range(degree):
        for left, right in itertools.combinations(sorted(adjacency[middle]), 2):
            paths.append((frozenset((left, middle, right)), ((left, middle), (middle, right))))
    by_vertex = {vertex: [path for path in paths if vertex in path[0]] for vertex in range(degree)}

    for isolated in range(degree):
        target = ((1 << degree) - 1) ^ (1 << isolated)
        memo = set()

        def search(remaining):
            if not remaining:
                return []
            if remaining in memo:
                return None
            vertices = [vertex for vertex in range(degree) if remaining >> vertex & 1]
            vertex = min(vertices, key=lambda item: sum(path[0] <= frozenset(vertices) for path in by_vertex[item]))
            for support, edges in by_vertex[vertex]:
                mask = sum(1 << item for item in support)
                if mask & remaining == mask:
                    tail = search(remaining ^ mask)
                    if tail is not None:
                        return [edges] + tail
            memo.add(remaining)
            return None

        answer = search(target)
        if answer is not None:
            return isolated, answer
    raise AssertionError("no seven-P3 factor")


def find_ten_matching(edges):
    edges = [tuple(sorted(edge)) for edge in edges]

    def search(available, chosen):
        if len(chosen) == 10:
            return chosen
        used = {vertex for edge in chosen for vertex in edge}
        if (22 - len(used)) // 2 < 10 - len(chosen):
            return None
        candidates = [edge for edge in available if not used.intersection(edge)]
        for index, edge in enumerate(candidates):
            answer = search(candidates[index + 1 :], chosen + [edge])
            if answer is not None:
                return answer
        return None

    answer = search(edges, [])
    assert answer is not None
    return answer


def compute():
    sparse = json.loads(EXPORT.read_text())["profile"]["input"]
    axis = json.loads(AXIS.read_text())
    scout = json.loads(SCOUT.read_text())
    points = [tuple(point) for point in sparse["chordal_singular_points"]]
    assert all(bilinear(point, point) == 0 for point in points)
    pair_values = {(left, right): bilinear(points[left], points[right]) for left in range(12) for right in range(left + 1, 12)}
    assert all(value for value in pair_values.values())

    triangle_characters = []
    for triple in itertools.combinations(range(12), 3):
        a, b, c = triple
        triangle_characters.append(character(pair_values[tuple(sorted((a, b)))] * pair_values[tuple(sorted((a, c)))] * pair_values[tuple(sorted((b, c)))]))
    assert Counter(triangle_characters) == {1: 220}

    blocks = {1: set(), -1: set()}
    determinant_values = {}
    for subset in itertools.combinations(range(12), 4):
        gram = [[bilinear(points[left], points[right]) for right in subset] for left in subset]
        value = determinant(gram)
        sign = character(value)
        blocks[sign].add(frozenset(subset))
        determinant_values[subset] = value
    assert {sign: len(value) for sign, value in blocks.items()} == {1: 165, -1: 330}

    positive = blocks[1]
    triple_degrees = Counter(triple for block in positive for triple in itertools.combinations(sorted(block), 3))
    pair_degrees = Counter(pair for block in positive for pair in itertools.combinations(sorted(block), 2))
    point_degrees = Counter(point for block in positive for point in block)
    assert set(triple_degrees.values()) == {3}
    assert set(pair_degrees.values()) == {15}
    assert set(point_degrees.values()) == {55}

    projectivity = axis["projected_sheet_cubic_chordal_identification"]["projectivity"]
    labels_to_points = point_label_map(points, projectivity)
    points_to_labels = {point: label for label, point in enumerate(labels_to_points)}
    harmonic_blocks = set()
    for block, value in determinant_values.items():
        labels = [points_to_labels[point] for point in block]
        ratio = cross_ratio(*labels)
        assert character(value) == character((ratio * ratio - ratio + 1) % P)
        if ratio in {P - 1, 2, pow(2, -1, P)}:
            harmonic_blocks.add(frozenset(block))
    assert harmonic_blocks == positive
    pgl = pgl_permutations()
    point_actions = [tuple(labels_to_points[permutation[label]] for label in range(12)) for permutation in pgl]
    point_actions = [tuple(action[labels_to_points.index(point)] for point in range(12)) for action in point_actions]
    assert len(set(point_actions)) == 1320
    assert all({frozenset(action[point] for point in block) for block in positive} == positive for action in point_actions)

    # A design automorphism is bounded by the image of one ordered triple.
    # Verify directly that its pointwise stabilizer is trivial.
    fixed = (0, 1, 2)
    remaining = tuple(range(3, 12))
    stabilizer = 0
    ordered_blocks = [tuple(block) for block in positive]
    for image_tail in itertools.permutations(remaining):
        action = fixed + image_tail
        if all(frozenset(action[point] for point in block) in positive for block in ordered_blocks):
            stabilizer += 1
    assert stabilizer == 1

    h3 = next(record for record in scout["types"] if record["type"] == "H3")
    base_matching = tuple(tuple(pair) for pair in h3["coxeter_invariant_matching"])
    matching_orbit = sorted({matching_image(permutation, base_matching) for permutation in pgl})
    assert len(matching_orbit) == 22
    query_masks = {}
    for pair in itertools.combinations(range(12), 2):
        mask = tuple(index for index, matching in enumerate(matching_orbit) if pair in matching)
        assert len(mask) == 2
        query_masks[pair] = mask
    query_edges = set(query_masks.values())
    assert len(query_edges) == 66
    adjacency = [set() for _ in range(22)]
    for left, right in query_edges:
        adjacency[left].add(right)
        adjacency[right].add(left)
    assert {len(neighbors) for neighbors in adjacency} == {6}

    isolated, path_factor = find_path_factor(adjacency)
    nonadaptive_queries = [tuple(sorted(edge)) for path in path_factor for edge in path]
    assert len(set(nonadaptive_queries)) == 14
    answer_words = [tuple(index in edge for edge in nonadaptive_queries) for index in range(22)]
    assert len(set(answer_words)) == 22
    ten_matching = find_ten_matching(sorted(query_edges))
    unmatched = sorted(set(range(22)) - {vertex for edge in ten_matching for vertex in edge})
    assert len(unmatched) == 2
    separators = []
    for left, right in ten_matching + [tuple(unmatched)]:
        separator = next(tuple(sorted((left, other))) for other in adjacency[left] if other != right)
        separators.append(separator)

    axis_pairs = [tuple(sorted((labels_to_points[left], labels_to_points[right]))) for left, right in base_matching]
    return {
        "schema": "c1011-paper-v-unmarked-shadow-v1",
        "metric_shadow": {
            "isotropic_points": 12,
            "orthogonal_distinct_pairs": 0,
            "triangle_gram_character_counts": {"positive": 220, "negative": 0},
            "four_set_gram_character_counts": {"positive": 165, "negative": 330},
            "positive_design": {"parameters": "3-(12,4,3)", "point_degree": 55, "pair_degree": 15},
            "positive_blocks_are_harmonic_quadruples": True,
            "normalized_determinant_square_class": "chi(lambda^2-lambda+1)",
            "positive_design_automorphism_order": 1320,
            "automorphism_identification": "PGL(2,11)",
            "pointwise_ordered_triple_stabilizer": stabilizer,
        },
        "marking": {
            "h3_matching_orbit_size": 22,
            "base_axis_pairs_in_export_point_order": axis_pairs,
            "pgl_order": 1320,
            "a5_stabilizer_order": 60,
        },
        "pair_membership_queries": {
            "candidate_count": 22,
            "query_count": 66,
            "candidates_per_query": 2,
            "query_graph_degree": 6,
            "optimal_nonadaptive_queries": 14,
            "nonadaptive_witness_isolated_candidate": isolated,
            "nonadaptive_witness_query_edges": nonadaptive_queries,
            "optimal_adaptive_queries": 11,
            "adaptive_first_ten_query_edges": ten_matching,
            "adaptive_all_no_remaining_candidates": unmatched,
            "adaptive_branch_separators": separators,
        },
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(compute(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
    else:
        assert OUTPUT.read_text() == rendered
        print("C1011 Paper V unmarked shadow: PASS")


if __name__ == "__main__":
    main()
