#!/usr/bin/env python3
"""Certify the octahedral--toric correspondence in Clebsch Paper IV."""

from __future__ import annotations

import argparse
import importlib.util
import json
from collections import Counter, deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "papers/q13-passant-code/verification/verify_minimum_geometry.py"
TRACKED = ROOT / "notes/2026-08-04-c682-paper-iv-orbit-correspondence.json"


def load_source():
    spec = importlib.util.spec_from_file_location("paper_iv_minimum_geometry", SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def transformed_orbit(module, group, representative):
    support = frozenset(representative)
    return tuple(
        sorted(
            {
                tuple(sorted(module.act_quadratic(g, point) for point in support))
                for g in group
            }
        )
    )


def stabilizer(module, group, support):
    target = frozenset(support)
    return frozenset(
        g
        for g in group
        if {module.act_quadratic(g, point) for point in target} == target
    )


def xor_rows(indices, rows):
    answer = 0
    for index in indices:
        answer ^= rows[index]
    return answer


def transpose_binary(rows, columns):
    answer = [0] * columns
    for i, row in enumerate(rows):
        while row:
            bit = row & -row
            answer[bit.bit_length() - 1] |= 1 << i
            row ^= bit
    return answer


def gram_rows(support_rows, size):
    answer = [0] * size
    for support in support_rows:
        row = support
        while row:
            bit = row & -row
            answer[bit.bit_length() - 1] ^= support
            row ^= bit
    return answer


def graph_girth(left_rows):
    left_size = len(left_rows)
    right_rows = transpose_binary(left_rows, left_size)
    adjacency = [[] for _ in range(2 * left_size)]
    for i, row in enumerate(left_rows):
        while row:
            bit = row & -row
            j = bit.bit_length() - 1
            adjacency[i].append(left_size + j)
            adjacency[left_size + j].append(i)
            row ^= bit
    best = 10**9
    for start in range(2 * left_size):
        distance = [-1] * (2 * left_size)
        parent = [-1] * (2 * left_size)
        distance[start] = 0
        queue = deque([start])
        while queue:
            vertex = queue.popleft()
            if 2 * distance[vertex] + 1 >= best:
                continue
            for neighbor in adjacency[vertex]:
                if distance[neighbor] < 0:
                    distance[neighbor] = distance[vertex] + 1
                    parent[neighbor] = vertex
                    queue.append(neighbor)
                elif parent[vertex] != neighbor:
                    best = min(best, distance[vertex] + distance[neighbor] + 1)
    return best, adjacency


def compute():
    module = load_source()
    group = tuple(module.projective_group())
    points = tuple(module.internal_points())
    point_index = {point: i for i, point in enumerate(points)}
    assert len(group) == 2184 and len(points) == 78

    octahedral = transformed_orbit(module, group, module.REPRESENTATIVES[0])
    toric_five = transformed_orbit(module, group, module.REPRESENTATIVES[1])
    assert len(octahedral) == len(toric_five) == 91

    octahedral_stabilizers = tuple(stabilizer(module, group, word) for word in octahedral)
    toric_stabilizers = tuple(stabilizer(module, group, word) for word in toric_five)
    assert {len(value) for value in octahedral_stabilizers} == {24}
    assert {len(value) for value in toric_stabilizers} == {24}

    correspondence = []
    intersection_orders = Counter()
    for left in octahedral_stabilizers:
        row = 0
        for j, right in enumerate(toric_stabilizers):
            order = len(left & right)
            intersection_orders[order] += 1
            if order == 8:
                row |= 1 << j
        correspondence.append(row)
    correspondence_transpose = transpose_binary(correspondence, 91)
    assert {row.bit_count() for row in correspondence} == {3}
    assert {row.bit_count() for row in correspondence_transpose} == {3}

    octahedral_rows = [sum(1 << point_index[p] for p in word) for word in octahedral]
    toric_rows = [sum(1 << point_index[p] for p in word) for word in toric_five]
    for i, row in enumerate(correspondence):
        neighbors = [j for j in range(91) if row >> j & 1]
        assert xor_rows(neighbors, toric_rows) == octahedral_rows[i]
        assert {len(set(octahedral[i]) & set(toric_five[j])) for j in neighbors} == {4}
    for j, row in enumerate(correspondence_transpose):
        neighbors = [i for i in range(91) if row >> i & 1]
        assert xor_rows(neighbors, octahedral_rows) == toric_rows[j]

    rho_nine = module.relation_matrix(list(points), 9)
    octahedral_gram = gram_rows(octahedral_rows, 78)
    toric_gram = gram_rows(toric_rows, 78)
    assert octahedral_gram == toric_gram == rho_nine

    assert [xor_rows([j for j in range(91) if row >> j & 1], toric_rows)
            for row in correspondence] == octahedral_rows
    assert [xor_rows([i for i in range(91) if row >> i & 1], octahedral_rows)
            for row in correspondence_transpose] == toric_rows

    rank = module.binary_rank(correspondence)
    girth, adjacency = graph_girth(correspondence)
    seen = {0}
    queue = deque([0])
    while queue:
        vertex = queue.popleft()
        for neighbor in adjacency[vertex]:
            if neighbor not in seen:
                seen.add(neighbor)
                queue.append(neighbor)
    assert len(seen) == 182 and girth == 12 and rank == 77

    common_neighbor_counts = Counter()
    for i in range(91):
        for j in range(i + 1, 91):
            common_neighbor_counts[(correspondence[i] & correspondence[j]).bit_count()] += 1
    assert common_neighbor_counts == {0: 3822, 1: 273}

    toric_chords = []
    for subgroup in toric_stabilizers:
        point_orbits = module.orbits(tuple(range(14)), list(subgroup), module.mobius)
        toric_chords.append(next(orbit for orbit in point_orbits if len(orbit) == 2))
    endpoint_rows = [
        sum(1 << j for j, chord in enumerate(toric_chords) if endpoint in chord)
        for endpoint in range(14)
    ]
    endpoint_images = [
        sum(1 << i for i, row in enumerate(correspondence) if (row & vector).bit_count() % 2)
        for vector in endpoint_rows
    ]
    endpoint_rank = module.binary_rank(endpoint_rows)
    endpoint_image_rank = module.binary_rank(endpoint_images)
    assert endpoint_rank == endpoint_image_rank == 13

    toric_columns = transpose_binary(toric_rows, 78)
    octahedral_columns = transpose_binary(octahedral_rows, 78)

    def multiply_row(vector, rows):
        answer = 0
        while vector:
            bit = vector & -vector
            answer ^= rows[bit.bit_length() - 1]
            vector ^= bit
        return answer

    toric_two_step_plus_identity = [
        multiply_row(row, correspondence) ^ (1 << j)
        for j, row in enumerate(correspondence_transpose)
    ]
    octahedral_two_step_plus_identity = [
        multiply_row(row, correspondence_transpose) ^ (1 << i)
        for i, row in enumerate(correspondence)
    ]
    all_vertices = (1 << 91) - 1
    assert module.binary_rank(toric_columns) == module.binary_rank(octahedral_columns) == 36
    assert all(multiply_row(column, toric_two_step_plus_identity) == 0 for column in toric_columns)
    assert all(
        multiply_row(column, octahedral_two_step_plus_identity) == 0
        for column in octahedral_columns
    )
    assert multiply_row(all_vertices, toric_two_step_plus_identity) == 0
    assert multiply_row(all_vertices, octahedral_two_step_plus_identity) == 0
    assert 91 - module.binary_rank(toric_two_step_plus_identity) == 37
    assert 91 - module.binary_rank(octahedral_two_step_plus_identity) == 37
    assert module.binary_rank(toric_columns + [all_vertices]) == 37
    assert module.binary_rank(octahedral_columns + [all_vertices]) == 37

    first_row = correspondence[0]
    first_neighbor = next(j for j in range(91) if first_row >> j & 1)
    edge_group = octahedral_stabilizers[0] & toric_stabilizers[first_neighbor]
    edge_order_profile = Counter(module.projective_order(g) for g in edge_group)
    generated = module.generated_subgroup(
        tuple(sorted(octahedral_stabilizers[0] | toric_stabilizers[first_neighbor]))
    )
    assert len(edge_group) == 8 and edge_order_profile == {1: 1, 2: 5, 4: 2}
    assert len(generated) == 2184

    return {
        "schema": "c682-paper-iv-octahedral-toric-correspondence-v1",
        "field_order": 13,
        "group_order": len(group),
        "coordinate_count": len(points),
        "families": {
            "octahedral": {"count": 91, "support_size": 12, "stabilizer": "S4"},
            "toric_r5": {"count": 91, "support_size": 12, "stabilizer": "D24"},
        },
        "correspondence": {
            "definition": "stabilizer_intersection_order_8",
            "left_degrees": dict(sorted(Counter(row.bit_count() for row in correspondence).items())),
            "right_degrees": dict(sorted(Counter(row.bit_count() for row in correspondence_transpose).items())),
            "edge_count": sum(row.bit_count() for row in correspondence),
            "edge_stabilizer_order": len(edge_group),
            "edge_stabilizer_order_profile": dict(sorted(edge_order_profile.items())),
            "generated_group_order": len(generated),
            "connected": len(seen) == 182,
            "girth": girth,
            "binary_rank": rank,
            "binary_nullity": 91 - rank,
            "same_side_common_neighbor_pair_counts": dict(sorted(common_neighbor_counts.items())),
            "toric_chord_endpoint_incidence_rank": endpoint_rank,
            "toric_chord_endpoint_image_rank": endpoint_image_rank,
            "toric_chord_endpoint_intersection_with_kernel_dimension": 0,
            "two_step_fixed_space_dimension_each_side": 37,
            "two_step_fixed_space_decomposition": "trivial_line_plus_36_dimensional_support_incidence_image",
        },
        "identities": {
            "octahedral_is_xor_of_three_toric_neighbors": True,
            "toric_is_xor_of_three_octahedral_neighbors": True,
            "each_adjacent_support_intersection_size": 4,
            "common_gram_relation_rho": 9,
        },
        "all_stabilizer_intersection_order_counts": dict(sorted(intersection_orders.items())),
        "trusted_inputs": [str(SOURCE.relative_to(ROOT))],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true", help="write the canonical JSON certificate")
    parser.add_argument("--check", action="store_true", help="compare against the tracked certificate")
    args = parser.parse_args()
    result = compute()
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.write:
        TRACKED.write_text(encoded)
    elif args.check:
        assert TRACKED.read_text() == encoded, "tracked certificate is stale"
        print("C682 Paper-IV orbit correspondence: PASS")
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
