#!/usr/bin/env python3
"""Exact diagnostics for the unresolved structural 18-gap of C1015.

This is deliberately a proof-search certificate, not a proof of the 18-gap.
It independently re-enumerates exact covers after a fixed Hamilton root and
records three small targets for a hand proof: local H-neighbour degree sums,
the degree-two three-root completions, and the residual degree profiles in the
minimum-degree-three branch.
"""

import argparse
import hashlib
import importlib.util
import itertools
import json
from collections import defaultdict
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "notes/c1015_hamilton_gap_rooted.py"
OUTPUT = ROOT / "notes/c1015_hamilton_gap_local_profiles.json"
MANIFEST = ROOT / "notes/c1015_hamilton_gap_local_profiles.sha256"


def load_rooted_module():
    spec = importlib.util.spec_from_file_location("c1015_rooted", SOURCE)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def canonical_bytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def manifest_bytes(script_bytes, output_bytes):
    entries = (
        ("notes/c1015_hamilton_gap_local_profiles.py", script_bytes),
        ("notes/c1015_hamilton_gap_local_profiles.json", output_bytes),
        ("notes/c1015_hamilton_gap_rooted.py", SOURCE.read_bytes()),
    )
    return "".join(
        f"{hashlib.sha256(data).hexdigest()}  {name}\n" for name, data in entries
    ).encode()


def build_certificate():
    gap = load_rooted_module()
    base = gap.BASE_INDEX
    partner = next(
        index
        for index, matching in enumerate(gap.MATCHINGS)
        if not gap.MASKS[index] & gap.MASKS[base]
        and gap.is_hamilton(gap.BASE, matching)
    )
    rooted_mask = gap.MASKS[base] | gap.MASKS[partner]
    residual_edges = tuple(
        edge for edge in range(len(gap.EDGES)) if not rooted_mask & (1 << edge)
    )
    candidates = tuple(
        index for index, mask in enumerate(gap.MASKS) if not mask & rooted_mask
    )
    by_edge = {edge: [] for edge in residual_edges}
    for index in candidates:
        for edge in gap.MATCHINGS[index]:
            by_edge[gap.EDGE_INDEX[edge]].append(index)

    hamilton_masks = [0] * len(gap.MATCHINGS)
    for left in range(len(gap.MATCHINGS)):
        for right in range(left):
            if gap.is_hamilton(gap.MATCHINGS[left], gap.MATCHINGS[right]):
                hamilton_masks[left] |= 1 << right
                hamilton_masks[right] |= 1 << left

    def hamilton(left, right):
        return bool(hamilton_masks[left] & (1 << right))

    def graph_data(factors):
        adjacency = [set() for _ in factors]
        for left in range(len(factors)):
            for right in range(left):
                if hamilton(factors[left], factors[right]):
                    adjacency[left].add(right)
                    adjacency[right].add(left)
        return adjacency, tuple(len(neighbors) for neighbors in adjacency)

    local_minimum = {degree: 99 for degree in range(2, 9)}
    maximum_degree_two_count = 0
    rooted_cover_count = 0

    def visit(used, chosen):
        nonlocal maximum_degree_two_count, rooted_cover_count
        if len(chosen) == 7:
            rooted_cover_count += 1
            adjacency, degrees = graph_data((base, partner) + chosen)
            if min(degrees) == 0:
                return
            maximum_degree_two_count = max(maximum_degree_two_count, degrees.count(2))
            for vertex, degree in enumerate(degrees):
                if 2 <= degree <= 8:
                    local_minimum[degree] = min(
                        local_minimum[degree],
                        sum(degrees[neighbor] for neighbor in adjacency[vertex]),
                    )
            return
        first_uncovered = next(
            edge for edge in residual_edges if not used & (1 << edge)
        )
        for index in by_edge[first_uncovered]:
            if not gap.MASKS[index] & used:
                visit(used | gap.MASKS[index], chosen + (index,))

    visit(rooted_mask, ())
    assert rooted_cover_count == 173_008
    assert local_minimum == {2: 8, 3: 14, 4: 15, 5: 19, 6: 18, 7: 27, 8: 32}
    assert maximum_degree_two_count == 3

    cycle = gap.hamilton_cycle_order(gap.BASE, gap.MATCHINGS[partner])
    actions = []
    for reflected in (False, True):
        for shift in range(10):
            permutation = {
                cycle[position]: cycle[
                    ((-position if reflected else position) + shift) % 10
                ]
                for position in range(10)
            }
            action = tuple(
                gap.MATCHING_INDEX[gap.matching_action(permutation, matching)]
                for matching in gap.MATCHINGS
            )
            if action[base] == base and action[partner] == partner:
                actions.append(action)
    assert len(actions) == 10

    cycle_position = {vertex: position for position, vertex in enumerate(cycle)}

    def cycle_word(index):
        chords = tuple(
            sorted(
                tuple(sorted((cycle_position[left], cycle_position[right])))
                for left, right in gap.MATCHINGS[index]
            )
        )
        return " ".join(f"{left}{right}" for left, right in chords)

    double_root = {
        index
        for index in candidates
        if hamilton(base, index) and hamilton(partner, index)
    }
    unseen = set(double_root)
    degree_two_orbits = []
    while unseen:
        representative = min(unseen)
        orbit = {action[representative] for action in actions}
        assert orbit <= double_root
        unseen -= orbit
        used = rooted_mask | gap.MASKS[representative]
        edges = tuple(edge for edge in range(len(gap.EDGES)) if not used & (1 << edge))
        available = tuple(
            index
            for index, mask in enumerate(gap.MASKS)
            if not mask & used and not hamilton(representative, index)
        )
        extensions_by_edge = {edge: [] for edge in edges}
        for index in available:
            for edge in gap.MATCHINGS[index]:
                extensions_by_edge[gap.EDGE_INDEX[edge]].append(index)
        extensions = 0
        minimum_edges = 99

        def extend(covered, chosen):
            nonlocal extensions, minimum_edges
            if len(chosen) == 6:
                extensions += 1
                adjacency, degrees = graph_data((base, partner, representative) + chosen)
                assert min(degrees) > 0
                minimum_edges = min(
                    minimum_edges, sum(len(neighbors) for neighbors in adjacency) // 2
                )
                return
            first_uncovered = next(edge for edge in edges if not covered & (1 << edge))
            for index in extensions_by_edge[first_uncovered]:
                if not gap.MASKS[index] & covered:
                    extend(covered | gap.MASKS[index], chosen + (index,))

        extend(used, ())
        degree_two_orbits.append(
            {
                "cycle_word": cycle_word(representative),
                "extensions": extensions,
                "minimum_hamilton_edges": None if extensions == 0 else minimum_edges,
                "orbit_size": len(orbit),
            }
        )
    degree_two_orbits.sort(key=lambda row: row["cycle_word"])
    assert len(double_root) == 148
    assert len(degree_two_orbits) == 24
    assert min(
        row["minimum_hamilton_edges"]
        for row in degree_two_orbits
        if row["minimum_hamilton_edges"] is not None
    ) == 18

    lower_bounds = {3: 14, 4: 15, 5: 19, 6: 18, 7: 27, 8: 32}
    residual_profiles = []
    for degrees in itertools.combinations_with_replacement(range(3, 7), 9):
        if sum(degrees) > 34:
            continue
        if sum(degree * degree for degree in degrees) >= sum(
            lower_bounds[degree] for degree in degrees
        ):
            residual_profiles.append(degrees)
    assert residual_profiles == [
        (3, 3, 3, 3, 3, 3, 3, 6, 6),
        (3, 3, 3, 3, 3, 3, 4, 6, 6),
        (3, 3, 3, 3, 3, 3, 5, 5, 6),
        (3, 3, 3, 3, 3, 4, 4, 5, 6),
        (3, 3, 3, 3, 4, 4, 4, 4, 6),
    ]

    return {
        "degree_two_three_root_orbits": degree_two_orbits,
        "local_neighbor_degree_sum_minima": local_minimum,
        "maximum_number_of_degree_two_factors": maximum_degree_two_count,
        "minimum_degree_three_moment_residual_profiles": residual_profiles,
        "rooted_exact_cover_completions": rooted_cover_count,
        "schema": "c1015-hamilton-gap-local-profiles-v1",
        "trusted_boundary": (
            "exact covers after a fixed ordered Hamilton root; the degree-two "
            "table further fixes a residual matching Hamilton with both roots "
            "and forbids its other Hamilton partners"
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    certificate = build_certificate()
    output_bytes = canonical_bytes(certificate)
    manifest = manifest_bytes(Path(__file__).read_bytes(), output_bytes)
    if arguments.check:
        assert OUTPUT.read_bytes() == output_bytes
        assert MANIFEST.read_bytes() == manifest
        print("C1015 local Hamilton-gap profile checks passed")
        return
    OUTPUT.write_bytes(output_bytes)
    MANIFEST.write_bytes(manifest)
    print(f"wrote {OUTPUT.relative_to(ROOT)} and {MANIFEST.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
