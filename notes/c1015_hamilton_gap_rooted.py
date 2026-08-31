#!/usr/bin/env python3
"""Rooted Hamilton-gap certificate for one-factorizations of K10.

Fix two factors whose union is a Hamilton cycle, then enumerate exact covers
of the remaining 35 edges by seven factors.  This proves the gap from one
rooted Hamilton pair and does not use the 396-class isomorphism census.
"""

from __future__ import annotations

import argparse
from collections import Counter, defaultdict
import hashlib
import itertools
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "notes/c1015_hamilton_gap_rooted.json"
MANIFEST = ROOT / "notes/c1015_hamilton_gap_rooted.sha256"
VERTICES = tuple(range(10))
EDGES = tuple(itertools.combinations(VERTICES, 2))
EDGE_INDEX = {edge: index for index, edge in enumerate(EDGES)}
FULL_MASK = (1 << len(EDGES)) - 1
BASE = ((0, 1), (2, 3), (4, 5), (6, 7), (8, 9))


def perfect_matchings(vertices):
    if not vertices:
        return ((),)
    first = vertices[0]
    answer = []
    for position, second in enumerate(vertices[1:]):
        rest = vertices[1 : position + 1] + vertices[position + 2 :]
        for tail in perfect_matchings(rest):
            answer.append(tuple(sorted(((first, second),) + tail)))
    return tuple(answer)


MATCHINGS = tuple(sorted(set(perfect_matchings(VERTICES))))
MATCHING_INDEX = {matching: index for index, matching in enumerate(MATCHINGS)}
MASKS = tuple(
    sum(1 << EDGE_INDEX[edge] for edge in matching) for matching in MATCHINGS
)
BASE_INDEX = MATCHING_INDEX[BASE]


def components(first, second):
    adjacency = {vertex: [] for vertex in VERTICES}
    for left, right in first + second:
        adjacency[left].append(right)
        adjacency[right].append(left)
    unseen = set(VERTICES)
    sizes = []
    while unseen:
        stack = [unseen.pop()]
        size = 0
        while stack:
            vertex = stack.pop()
            size += 1
            for neighbor in adjacency[vertex]:
                if neighbor in unseen:
                    unseen.remove(neighbor)
                    stack.append(neighbor)
        sizes.append(size)
    return tuple(sorted(sizes))


def product_cycle_lengths(first, second):
    first_mate = {x: y for x, y in first for x, y in ((x, y), (y, x))}
    second_mate = {x: y for x, y in second for x, y in ((x, y), (y, x))}
    permutation = {x: first_mate[second_mate[x]] for x in VERTICES}
    unseen = set(VERTICES)
    lengths = []
    while unseen:
        vertex = min(unseen)
        length = 0
        while vertex in unseen:
            unseen.remove(vertex)
            length += 1
            vertex = permutation[vertex]
        lengths.append(length)
    return tuple(sorted(lengths))


def is_hamilton(first, second):
    by_components = components(first, second) == (10,)
    by_product = product_cycle_lengths(first, second) == (5, 5)
    assert by_components == by_product
    return by_components


def hamilton_cycle_order(first, second):
    adjacency = {vertex: [] for vertex in VERTICES}
    for left, right in first + second:
        adjacency[left].append(right)
        adjacency[right].append(left)
    order = [0]
    previous = None
    while len(order) < 10:
        following = next(x for x in adjacency[order[-1]] if x != previous)
        previous = order[-1]
        order.append(following)
    assert len(set(order)) == 10
    return tuple(order)


def matching_action(permutation, matching):
    return tuple(
        sorted(tuple(sorted((permutation[left], permutation[right]))) for left, right in matching)
    )


def encode_counter(counter):
    return {str(key): counter[key] for key in sorted(counter)}


def build_certificate():
    partner_index = next(
        index
        for index, matching in enumerate(MATCHINGS)
        if not MASKS[index] & MASKS[BASE_INDEX] and is_hamilton(BASE, matching)
    )
    partner = MATCHINGS[partner_index]
    rooted_mask = MASKS[BASE_INDEX] | MASKS[partner_index]
    residual_edges = tuple(
        edge for edge in range(len(EDGES)) if not rooted_mask & (1 << edge)
    )
    candidates = tuple(
        index for index, mask in enumerate(MASKS) if not mask & rooted_mask
    )
    active = (BASE_INDEX, partner_index) + candidates
    hamilton = {}
    for position, left in enumerate(active):
        for right in active[:position]:
            hamilton[min(left, right), max(left, right)] = is_hamilton(
                MATCHINGS[left], MATCHINGS[right]
            )

    by_edge = {edge: [] for edge in residual_edges}
    for index in candidates:
        for edge in MATCHINGS[index]:
            by_edge[EDGE_INDEX[edge]].append(index)

    joint_distribution = Counter()
    root_degree_distribution = Counter()
    degree_distribution = defaultdict(Counter)
    equality_rows = []
    completion_count = 0

    def visit(used, chosen):
        nonlocal completion_count
        if len(chosen) == 7:
            assert used == FULL_MASK
            completion_count += 1
            factors = (BASE_INDEX, partner_index) + chosen
            degrees = [0] * 9
            count = 0
            for left in range(9):
                for right in range(left):
                    pair = min(factors[left], factors[right]), max(
                        factors[left], factors[right]
                    )
                    if hamilton[pair]:
                        count += 1
                        degrees[left] += 1
                        degrees[right] += 1
            minimum_degree = min(degrees)
            degree_sequence = tuple(sorted(degrees))
            joint_distribution[count, minimum_degree] += 1
            root_degree_distribution[degrees[0], degrees[1]] += 1
            degree_distribution[count][degree_sequence] += 1
            if count == 12 or (count == 18 and minimum_degree > 0):
                equality_rows.append((tuple(sorted(factors)), count, degree_sequence))
            return
        first_uncovered = next(
            edge for edge in residual_edges if not used & (1 << edge)
        )
        for index in by_edge[first_uncovered]:
            if not MASKS[index] & used:
                visit(used | MASKS[index], chosen + (index,))

    visit(rooted_mask, ())

    cycle = hamilton_cycle_order(BASE, partner)
    actions = []
    for reflected in (False, True):
        for shift in range(10):
            permutation = {
                cycle[position]: cycle[((-position if reflected else position) + shift) % 10]
                for position in range(10)
            }
            action = tuple(
                MATCHING_INDEX[matching_action(permutation, matching)]
                for matching in MATCHINGS
            )
            assert {
                action[BASE_INDEX], action[partner_index]
            } == {BASE_INDEX, partner_index}
            actions.append(action)
    assert len(set(actions)) == 20

    equality_orbits = defaultdict(set)
    for factors, count, degree_sequence in equality_rows:
        canonical = min(
            tuple(sorted(action[index] for index in factors)) for action in actions
        )
        equality_orbits[count, degree_sequence].add(canonical)

    positive_counts = [
        count
        for count, minimum_degree in joint_distribution
        if joint_distribution[count, minimum_degree]
    ]
    no_isolate_counts = [
        count
        for count, minimum_degree in joint_distribution
        if minimum_degree > 0 and joint_distribution[count, minimum_degree]
    ]
    assert min(positive_counts) == 12
    assert min(no_isolate_counts) == 18
    assert min(sum(pair) for pair in root_degree_distribution) == 6
    assert all(left != 2 or right >= 4 for left, right in root_degree_distribution)
    assert all(right != 2 or left >= 4 for left, right in root_degree_distribution)
    assert completion_count == 173008

    return {
        "schema": "c1015-hamilton-gap-rooted-v1",
        "root": {
            "base_factor": BASE,
            "hamilton_partner": partner,
            "residual_candidate_matchings": len(candidates),
            "residual_exact_cover_completions": completion_count,
            "root_stabilizer_order": len(actions),
        },
        "joint_hamilton_count_minimum_degree_distribution": {
            f"{count}|{minimum_degree}": multiplicity
            for (count, minimum_degree), multiplicity in sorted(
                joint_distribution.items()
            )
        },
        "root_hamilton_edge_degree_distribution": {
            f"{left}|{right}": multiplicity
            for (left, right), multiplicity in sorted(root_degree_distribution.items())
        },
        "equality_degree_sequence_distribution": {
            str(count): {
                ",".join(map(str, sequence)): multiplicity
                for sequence, multiplicity in sorted(degree_distribution[count].items())
            }
            for count in (12, 18)
        },
        "equality_rooted_orbits": {
            f"{count}|{','.join(map(str, sequence))}": len(orbits)
            for (count, sequence), orbits in sorted(equality_orbits.items())
        },
        "theorem_checks": {
            "nonempty_hamilton_graph_minimum_edges": min(positive_counts),
            "no_isolated_factor_minimum_edges": min(no_isolate_counts),
            "hamilton_edge_minimum_degree_sum": min(
                sum(pair) for pair in root_degree_distribution
            ),
            "hamilton_test": "component size 10 iff product cycle lengths are [5,5]",
            "independent_full_census_bundle": "notes/c1015_k10_factorization_closure.py",
        },
        "trusted_boundary": (
            "deterministic exact cover after fixing one Hamilton pair; equality rows "
            "quotiented only by its explicit order-20 dihedral stabilizer; no graph-"
            "isomorphism or global one-factorization census"
        ),
    }


def canonical_bytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def manifest_bytes(script_path, output_bytes):
    rows = []
    for path, data in ((script_path, script_path.read_bytes()), (OUTPUT, output_bytes)):
        rows.append(f"{hashlib.sha256(data).hexdigest()}  {path.relative_to(ROOT)}")
    return ("\n".join(rows) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    certificate = build_certificate()
    output_bytes = canonical_bytes(certificate)
    script_path = Path(__file__).resolve()
    manifest = manifest_bytes(script_path, output_bytes)
    if arguments.check:
        assert OUTPUT.read_bytes() == output_bytes
        assert MANIFEST.read_bytes() == manifest
        print("C1015 rooted Hamilton-gap checks passed")
        return
    OUTPUT.write_bytes(output_bytes)
    MANIFEST.write_bytes(manifest)
    print(f"wrote {OUTPUT.relative_to(ROOT)} and {MANIFEST.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
