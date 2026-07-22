#!/usr/bin/env python3
"""C80: test C447's canonical q=11 cloud-intersection packet in the cap game."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from collections import Counter
from itertools import combinations
from pathlib import Path


Q = 11
ROOT = Path(__file__).resolve().parents[2]
C447_JSON = ROOT / "notes/2026-07-21-c447-cap-knife-edge.json"
C20_SOURCE = ROOT / "notes/2026-07-08-intrusion-census.py"
OUT = ROOT / "notes/2026-07-22-c80-c447-cloud-packet.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def cross(a, b):
    return tuple(
        (a[(i + 1) % 3] * b[(i + 2) % 3] - a[(i + 2) % 3] * b[(i + 1) % 3]) % Q
        for i in range(3)
    )


def normalize(v):
    pivot = next(x for x in v if x % Q)
    scale = pow(pivot, -1, Q)
    return tuple(x * scale % Q for x in v)


def standard_point(w):
    return (0, 0, 1) if w == "inf" else (1, w, w * w % Q)


def mat_vec(matrix, vector):
    return tuple(sum(matrix[i][j] * vector[j] for j in range(3)) % Q for i in range(3))


def mobius_group():
    group = []
    for a in range(Q):
        for b in range(Q):
            for c in range(Q):
                for d in range(Q):
                    if (a * d - b * c) % Q and next(x for x in (a, b, c, d) if x) == 1:
                        group.append((a, b, c, d))
    assert len(group) == Q * (Q * Q - 1)
    return group


def mobius_act(matrix, x):
    a, b, c, d = matrix
    if x == "inf":
        return "inf" if c == 0 else a * pow(c, -1, Q) % Q
    denominator = (c * x + d) % Q
    return "inf" if denominator == 0 else (a * x + b) * pow(denominator, -1, Q) % Q


def det_is_square(matrix):
    a, b, c, d = matrix
    return pow((a * d - b * c) % Q, (Q - 1) // 2, Q) == 1


def symmetric_square(matrix):
    a, b, c, d = matrix
    return [
        [d * d % Q, 2 * c * d % Q, c * c % Q],
        [b * d % Q, (a * d + b * c) % Q, a * c % Q],
        [b * b % Q, 2 * a * b % Q, a * a % Q],
    ]


def cloud(matching):
    chords = [cross(standard_point(a), standard_point(b)) for a, b in matching]
    return {normalize(cross(a, b)) for a, b in combinations(chords, 2)}


def cap_cell(matrix, point):
    image = normalize(mat_vec(matrix, point))
    assert image[2] != 0
    scale = pow(image[2], -1, Q)
    return (image[0] * scale % Q, image[1] * scale % Q)


def cap_cell_action(record, transformation, cell):
    standard = mat_vec(record["cap_to_standard_projectivity"], (cell[0], cell[1], 1))
    image = mat_vec(symmetric_square(transformation), standard)
    return cap_cell(record["standard_to_cap_projectivity"], image)


def load_game_module():
    spec = importlib.util.spec_from_file_location("c80_c20", C20_SOURCE)
    module = importlib.util.module_from_spec(spec)
    sys.modules["c80_c20"] = module
    spec.loader.exec_module(module)
    return module


def edge_quotient_u(record, edge_endpoints, cell):
    a, b = edge_endpoints
    edge_normalizer = (1, -a % Q, 1, -b % Q)
    standard = mat_vec(record["cap_to_standard_projectivity"], (cell[0], cell[1], 1))
    x, y, z = normalize(mat_vec(symmetric_square(edge_normalizer), standard))
    return "inf" if y == 0 else x * z * pow(y * y % Q, -1, Q) % Q


def analyze_seed(game, record, edge_endpoints, square_kernel, seed, packet):
    mask = sum(game.bit_for_cell(cell) for cell in seed)
    records = []
    histogram = Counter()
    for _bit, opponent_index in game.iter_bits(game.legal_mask(mask)):
        opponent = game.cell_tuple(opponent_index)
        after_opponent = mask | (1 << opponent_index)
        legal_replies = game.legal_mask(after_opponent)
        candidates = sorted(cell for cell in packet if legal_replies & game.bit_for_cell(cell))
        winning = sorted(
            cell
            for cell in candidates
            if not game.value(after_opponent | game.bit_for_cell(cell))
        )
        histogram[(len(candidates), len(winning))] += 1
        records.append(
            {
                "opponent": list(opponent),
                "edge_quotient_u": edge_quotient_u(record, edge_endpoints, opponent),
                "packet_replies": [list(cell) for cell in candidates],
                "winning_packet_replies": [list(cell) for cell in winning],
            }
        )
    assert histogram == Counter({(0, 0): 12, (2, 0): 5, (2, 2): 5})
    quotient_rule = {
        signature: sorted(
            {branch["edge_quotient_u"] for branch in records
             if f"{len(branch['packet_replies'])}/{len(branch['winning_packet_replies'])}" == signature},
            key=str,
        )
        for signature in ("0/0", "2/0", "2/2")
    }
    assert quotient_rule == {"0/0": [0, 1, "inf"], "2/0": [9], "2/2": [8]}
    branch_by_opponent = {
        tuple(branch["opponent"]): (
            len(branch["packet_replies"]), len(branch["winning_packet_replies"])
        )
        for branch in records
    }
    quotient_by_vertex = {
        tuple(branch["opponent"]): str(branch["edge_quotient_u"]) for branch in records
    }
    remaining = set(branch_by_opponent)
    orbits = []
    vertex_orbit_label = {}
    while remaining:
        representative = min(remaining)
        orbit = {cap_cell_action(record, g, representative) for g in square_kernel}
        assert orbit <= set(branch_by_opponent)
        signatures = {branch_by_opponent[cell] for cell in orbit}
        assert len(signatures) == 1
        quotient_values = {quotient_by_vertex[cell] for cell in orbit}
        assert len(quotient_values) == 1
        orbit_label = f"{next(iter(quotient_values))}[{len(orbit)}]"
        vertex_orbit_label.update({cell: orbit_label for cell in orbit})
        remaining -= orbit
        candidate_count, winning_count = next(iter(signatures))
        orbits.append(
            {
                "size": len(orbit),
                "candidate_winning_signature": f"{candidate_count}/{winning_count}",
                "opponents": [list(cell) for cell in sorted(orbit)],
            }
        )
    assert sorted(orbit["size"] for orbit in orbits) == [1, 1, 5, 5, 5, 5]
    vertices = sorted(branch_by_opponent)
    adjacency = {vertex: set() for vertex in vertices}
    for i, first in enumerate(vertices):
        after_first = mask | game.bit_for_cell(first)
        legal_second = game.legal_mask(after_first)
        for second in vertices[i + 1:]:
            if legal_second & game.bit_for_cell(second):
                grandchild = after_first | game.bit_for_cell(second)
                if not game.value(grandchild):
                    adjacency[first].add(second)
                    adjacency[second].add(first)

    matchings = []

    def enumerate_matchings(remaining, edges):
        if not remaining:
            matchings.append(tuple(sorted(edges)))
            return
        first = min(remaining)
        for second in sorted(adjacency[first] & remaining):
            enumerate_matchings(remaining - {first, second}, edges + [(first, second)])

    enumerate_matchings(set(vertices), [])
    matchings = sorted(set(matchings))
    assert len(matchings) == 2
    edge_sets = [set(matching) for matching in matchings]
    common_edges = edge_sets[0] & edge_sets[1]
    alternating_edges = edge_sets[0] ^ edge_sets[1]
    alternating_vertices = {vertex for edge in alternating_edges for vertex in edge}
    alternating_adjacency = {vertex: set() for vertex in alternating_vertices}
    for first, second in alternating_edges:
        alternating_adjacency[first].add(second)
        alternating_adjacency[second].add(first)
    assert len(common_edges) == 6
    assert len(alternating_vertices) == 10
    assert all(len(neighbors) == 2 for neighbors in alternating_adjacency.values())
    for matching in matchings:
        quotient_pairs = Counter(
            tuple(sorted((quotient_by_vertex[first], quotient_by_vertex[second])))
            for first, second in matching
        )
        assert quotient_pairs == Counter({("1", "9"): 5, ("8", "inf"): 5, ("0", "inf"): 1})
    winning_edges = sorted(
        (first, second) for first in vertices for second in adjacency[first] if first < second
    )
    remaining_edges = set(winning_edges)
    edge_orbits = []
    edge_orbit_type_counts = Counter()
    while remaining_edges:
        representative = min(remaining_edges)
        orbit = {
            tuple(sorted((
                cap_cell_action(record, transformation, representative[0]),
                cap_cell_action(record, transformation, representative[1]),
            )))
            for transformation in square_kernel
        }
        assert orbit <= set(winning_edges)
        orbit_type = "--".join(sorted((
            vertex_orbit_label[representative[0]],
            vertex_orbit_label[representative[1]],
        )))
        assert {
            "--".join(sorted((vertex_orbit_label[first], vertex_orbit_label[second])))
            for first, second in orbit
        } == {orbit_type}
        edge_orbits.append((orbit_type, orbit))
        edge_orbit_type_counts[orbit_type] += 1
        remaining_edges -= orbit
    assert edge_orbit_type_counts == Counter({
        "0[1]--inf[1]": 1,
        "1[5]--inf[1]": 1,
        "1[5]--1[5]": 2,
        "1[5]--8[5]": 1,
        "1[5]--9[5]": 1,
        "8[5]--9[5]": 1,
        "8[5]--inf[5]": 2,
    })
    matching_orbit_types = []
    for matching in edge_sets:
        used_orbits = [(orbit_type, orbit) for orbit_type, orbit in edge_orbits if orbit & matching]
        assert all(orbit <= matching for _orbit_type, orbit in used_orbits)
        matching_orbit_types.append(sorted(orbit_type for orbit_type, _orbit in used_orbits))
    assert matching_orbit_types == [[
        "0[1]--inf[1]", "1[5]--9[5]", "8[5]--inf[5]"
    ]] * 2
    orbit_labels = set(vertex_orbit_label.values())
    minimum_orbit_covers = []
    for cover_size in range(1, len(edge_orbits) + 1):
        for chosen in combinations(range(len(edge_orbits)), cover_size):
            covered = {
                label
                for index in chosen
                for label in edge_orbits[index][0].split("--")
            }
            if covered == orbit_labels:
                minimum_orbit_covers.append(chosen)
        if minimum_orbit_covers:
            break
    minimum_orbit_cover_types = [
        sorted(edge_orbits[index][0] for index in chosen)
        for chosen in minimum_orbit_covers
    ]
    assert cover_size == 3
    assert minimum_orbit_cover_types == [[
        "0[1]--inf[1]", "1[5]--9[5]", "8[5]--inf[5]"
    ]] * 2
    representative_cover_edges = [
        {
            "orbit_type": edge_orbits[index][0],
            "edge": [list(cell) for cell in min(edge_orbits[index][1])],
        }
        for index in minimum_orbit_covers[0]
    ]
    quotient_edge_counts = Counter(
        "-".join(sorted((quotient_by_vertex[first], quotient_by_vertex[second])))
        for first, second in winning_edges
    )
    assert quotient_edge_counts == Counter(
        {"0-inf": 1, "1-1": 10, "1-8": 5, "1-9": 5, "1-inf": 5, "8-9": 5, "8-inf": 10}
    )
    seen = set()
    components = []
    for vertex in vertices:
        if vertex in seen:
            continue
        stack = [vertex]
        component = set()
        while stack:
            current = stack.pop()
            if current in component:
                continue
            component.add(current)
            stack.extend(adjacency[current] - component)
        seen |= component
        components.append(component)
    assert [len(component) for component in components] == [22]
    return {
        "legal_opponent_moves": len(records),
        "candidate_winning_histogram": {
            f"{candidate_count}/{winning_count}": count
            for (candidate_count, winning_count), count in sorted(histogram.items())
        },
        "branches": records,
        "edge_quotient_rule": quotient_rule,
        "square_c5_opponent_orbits": sorted(orbits, key=lambda orbit: orbit["opponents"]),
        "winning_response_graph": {
            "vertices": len(vertices),
            "edges": sum(map(len, adjacency.values())) // 2,
            "degree_histogram": {
                str(degree): count
                for degree, count in sorted(Counter(map(len, adjacency.values())).items())
            },
            "component_sizes": [len(component) for component in components],
            "quotient_edge_counts": dict(sorted(quotient_edge_counts.items())),
            "winning_edges": [[list(first), list(second)] for first, second in winning_edges],
            "perfect_matching_count": len(matchings),
            "common_edge_count": len(common_edges),
            "alternating_cycle_vertices": [list(cell) for cell in sorted(alternating_vertices)],
            "c5_orbital_decomposition": {
                "vertex_orbit_counts": dict(sorted(Counter(vertex_orbit_label.values()).items())),
                "winning_edge_orbit_type_counts": dict(sorted(edge_orbit_type_counts.items())),
                "perfect_matching_orbit_types": matching_orbit_types,
                "unforced_bicayley_component": {
                    "parts": ["8[5]", "inf[5]"],
                    "edge_orbits": 2,
                    "vertices": 10,
                    "is_single_cycle": True,
                    "each_edge_orbit_is_a_perfect_matching": True,
                },
                "minimum_opponent_orbit_cover": {
                    "opponent_orbits": 6,
                    "edge_orbits": cover_size,
                    "unique_type_cover": minimum_orbit_cover_types[0],
                    "lift_count": len(minimum_orbit_covers),
                    "representative_edges": representative_cover_edges,
                    "matching_or_injective_reply_not_required_for_p_existence": True,
                },
            },
            "perfect_matchings": [
                [[list(first), list(second)] for first, second in matching]
                for matching in matchings
            ],
        },
    }


def build():
    source = json.loads(C447_JSON.read_text())
    game = load_game_module().PrimeGridGame(Q)
    group = mobius_group()
    classes = []
    for record in source["knife_edge_classes"]:
        repair = record["canonical_shared_edge_cross_sheet_pair"]
        plus_cloud = cloud(repair["plus_matching"])
        minus_cloud = cloud(repair["minus_matching"])
        assert len(plus_cloud) == len(minus_cloud) == 15
        intersection = plus_cloud & minus_cloud
        assert len(intersection) == 5
        matrix = record["standard_to_cap_projectivity"]
        packet = {cap_cell(matrix, point) for point in intersection}
        assert len(packet) == 5
        frame = set(record["frame_parameters"])
        frame_stabilizer = [g for g in group if {mobius_act(g, x) for x in frame} == frame]
        square_kernel = [g for g in frame_stabilizer if det_is_square(g)]
        assert len(frame_stabilizer) == 10 and len(square_kernel) == 5
        endpoint_records = []
        for endpoint in repair["shared_p_edge"]:
            witness = cap_cell(matrix, standard_point(endpoint))
            seed = [tuple(cell) for cell in record["S3"]] + [witness]
            endpoint_records.append(
                {
                    "endpoint_parameter": endpoint,
                    "witness_cell": list(witness),
                    **analyze_seed(
                        game, record, repair["shared_p_edge"], square_kernel, seed, packet
                    ),
                }
            )
        matching_sets = [
            [
                {
                    tuple(sorted((tuple(edge[0]), tuple(edge[1]))))
                    for edge in matching
                }
                for matching in endpoint_record["winning_response_graph"]["perfect_matchings"]
            ]
            for endpoint_record in endpoint_records
        ]
        for endpoint_index in range(2):
            for transformation in square_kernel:
                for matching_index, matching in enumerate(matching_sets[endpoint_index]):
                    image = {
                        tuple(sorted((
                            cap_cell_action(record, transformation, first),
                            cap_cell_action(record, transformation, second),
                        )))
                        for first, second in matching
                    }
                    assert image == matching_sets[endpoint_index][matching_index]
        nonsquare_coset = [g for g in frame_stabilizer if not det_is_square(g)]
        assert len(nonsquare_coset) == 5
        for transformation in nonsquare_coset:
            assert mobius_act(transformation, repair["shared_p_edge"][0]) == repair["shared_p_edge"][1]
            for matching_index, matching in enumerate(matching_sets[0]):
                image = {
                    tuple(sorted((
                        cap_cell_action(record, transformation, first),
                        cap_cell_action(record, transformation, second),
                    )))
                    for first, second in matching
                }
                assert image == matching_sets[1][1 - matching_index]
        classes.append(
            {
                "class": record["class"],
                "cloud_sizes": [len(plus_cloud), len(minus_cloud)],
                "cloud_intersection_size": len(intersection),
                "packet_cells": [list(cell) for cell in sorted(packet)],
                "response_matching_action": {
                    "square_c5_fixes_each_matching": True,
                    "nonsquare_d10_coset_swaps_endpoint_and_matching": True,
                    "global_calibration_count": 2,
                },
                "endpoints": endpoint_records,
            }
        )
    return {
        "schema": "c80-c447-cloud-packet-v1",
        "field_order": Q,
        "inputs": {
            str(C447_JSON.relative_to(ROOT)): sha256(C447_JSON),
            str(C20_SOURCE.relative_to(ROOT)): sha256(C20_SOURCE),
        },
        "classes": classes,
        "verdict": (
            "PARTIAL_PACKET_12_KILLED_5_TWO_N_5_TWO_P_FOR_EACH_OF_FOUR_ENDPOINT_CHOICES"
        ),
    }


def canonical_bytes(data):
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    expected = canonical_bytes(build())
    if args.write:
        OUT.write_bytes(expected)
        print(f"wrote {OUT.relative_to(ROOT)}")
    else:
        assert OUT.read_bytes() == expected, "C80 cloud-packet certificate drift"
        print("C80 C447 cloud-packet check: PASS")


if __name__ == "__main__":
    main()
