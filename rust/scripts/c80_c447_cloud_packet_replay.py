#!/usr/bin/env python3
"""Independent direct-grid replay of the C80/C447 five-point packet certificate."""

from __future__ import annotations

import json
from collections import Counter
from functools import lru_cache
from itertools import combinations
from pathlib import Path


Q = 11
ROOT = Path(__file__).resolve().parents[2]
C447_JSON = ROOT / "notes/2026-07-21-c447-cap-knife-edge.json"
CERT = ROOT / "notes/2026-07-22-c80-c447-cloud-packet.json"
CELLS = tuple((r, c) for r in range(Q) for c in range(Q))


def cross(a, b):
    return tuple(
        (a[(i + 1) % 3] * b[(i + 2) % 3] - a[(i + 2) % 3] * b[(i + 1) % 3]) % Q
        for i in range(3)
    )


def normalize(v):
    pivot = next(x for x in v if x % Q)
    scale = pow(pivot, -1, Q)
    return tuple(x * scale % Q for x in v)


def point(w):
    return (0, 0, 1) if w == "inf" else (1, w, w * w % Q)


def cloud(matching):
    lines = [cross(point(a), point(b)) for a, b in matching]
    return {normalize(cross(a, b)) for a, b in combinations(lines, 2)}


def transform(matrix, p):
    image = normalize(tuple(sum(matrix[i][j] * p[j] for j in range(3)) % Q for i in range(3)))
    assert image[2]
    z = pow(image[2], -1, Q)
    return (image[0] * z % Q, image[1] * z % Q)


def mobius_group():
    return [
        (a, b, c, d)
        for a in range(Q)
        for b in range(Q)
        for c in range(Q)
        for d in range(Q)
        if (a * d - b * c) % Q and next(x for x in (a, b, c, d) if x) == 1
    ]


def mobius_act(matrix, x):
    a, b, c, d = matrix
    if x == "inf":
        return "inf" if c == 0 else a * pow(c, -1, Q) % Q
    denominator = (c * x + d) % Q
    return "inf" if denominator == 0 else (a * x + b) * pow(denominator, -1, Q) % Q


def square_det(matrix):
    a, b, c, d = matrix
    return pow((a * d - b * c) % Q, 5, Q) == 1


def symmetric_square(matrix):
    a, b, c, d = matrix
    return ((d * d, 2 * c * d, c * c), (b * d, a * d + b * c, a * c),
            (b * b, 2 * a * b, a * a))


def act_on_cell(record, matrix, cell):
    first = tuple(
        sum(record["cap_to_standard_projectivity"][i][j] * (cell + (1,))[j] for j in range(3)) % Q
        for i in range(3)
    )
    middle = tuple(sum(symmetric_square(matrix)[i][j] * first[j] for j in range(3)) % Q for i in range(3))
    return transform(record["standard_to_cap_projectivity"], middle)


def edge_quotient_u(record, endpoints, cell):
    a, b = endpoints
    normalizer = (1, -a % Q, 1, -b % Q)
    first = tuple(
        sum(record["cap_to_standard_projectivity"][i][j] * (cell + (1,))[j] for j in range(3)) % Q
        for i in range(3)
    )
    image = normalize(tuple(
        sum(symmetric_square(normalizer)[i][j] * first[j] for j in range(3)) % Q
        for i in range(3)
    ))
    x, y, z = image
    return "inf" if y == 0 else x * z * pow(y * y % Q, -1, Q) % Q


def collinear(a, b, c):
    return ((b[0] - a[0]) * (c[1] - a[1]) - (b[1] - a[1]) * (c[0] - a[0])) % Q == 0


def legal_moves(position):
    selected = set(position)
    used_rows = {cell[0] for cell in selected}
    used_cols = {cell[1] for cell in selected}
    return tuple(
        cell
        for cell in CELLS
        if cell not in selected
        and cell[0] not in used_rows
        and cell[1] not in used_cols
        and all(not collinear(a, b, cell) for a, b in combinations(selected, 2))
    )


@lru_cache(maxsize=None)
def is_n(position):
    return any(not is_n(tuple(sorted(position + (move,)))) for move in legal_moves(position))


def main():
    source = json.loads(C447_JSON.read_text())
    recorded = json.loads(CERT.read_text())
    group = mobius_group()
    replayed = []
    for record in source["knife_edge_classes"]:
        repair = record["canonical_shared_edge_cross_sheet_pair"]
        intersection = cloud(repair["plus_matching"]) & cloud(repair["minus_matching"])
        packet = {transform(record["standard_to_cap_projectivity"], p) for p in intersection}
        frame = set(record["frame_parameters"])
        frame_stabilizer = [
            g for g in group if {mobius_act(g, x) for x in frame} == frame
        ]
        kernel = [
            g for g in frame_stabilizer if square_det(g)
        ]
        assert len(frame_stabilizer) == 10 and len(kernel) == 5
        endpoints = []
        for endpoint in repair["shared_p_edge"]:
            witness = transform(record["standard_to_cap_projectivity"], point(endpoint))
            seed = tuple(sorted(tuple(cell) for cell in record["S3"] + [list(witness)]))
            histogram = Counter()
            signatures = {}
            quotient_rule = {}
            for opponent in legal_moves(seed):
                child = tuple(sorted(seed + (opponent,)))
                candidates = sorted(packet & set(legal_moves(child)))
                winning = [reply for reply in candidates if not is_n(tuple(sorted(child + (reply,))))]
                histogram[(len(candidates), len(winning))] += 1
                signatures[opponent] = (len(candidates), len(winning))
                quotient_rule.setdefault((len(candidates), len(winning)), set()).add(
                    edge_quotient_u(record, repair["shared_p_edge"], opponent)
                )
            assert histogram == Counter({(0, 0): 12, (2, 0): 5, (2, 2): 5})
            assert quotient_rule == {(0, 0): {0, 1, "inf"}, (2, 0): {9}, (2, 2): {8}}
            remaining = set(signatures)
            orbits = []
            while remaining:
                representative = min(remaining)
                orbit = {act_on_cell(record, g, representative) for g in kernel}
                assert len({signatures[cell] for cell in orbit}) == 1
                remaining -= orbit
                orbits.append((sorted(orbit), signatures[representative]))
            assert sorted(len(orbit) for orbit, _signature in orbits) == [1, 1, 5, 5, 5, 5]
            vertices = sorted(signatures)
            adjacency = {vertex: set() for vertex in vertices}
            for i, first in enumerate(vertices):
                child = tuple(sorted(seed + (first,)))
                legal = set(legal_moves(child))
                for second in vertices[i + 1:]:
                    if second in legal and not is_n(tuple(sorted(child + (second,)))):
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
            common = set(matchings[0]) & set(matchings[1])
            alternating = set(matchings[0]) ^ set(matchings[1])
            alternating_vertices = {vertex for edge in alternating for vertex in edge}
            assert len(common) == 6 and len(alternating_vertices) == 10
            quotient = {
                vertex: str(edge_quotient_u(record, repair["shared_p_edge"], vertex))
                for vertex in adjacency
            }
            vertex_orbit_label = {}
            for orbit, _signature in orbits:
                quotient_values = {quotient[cell] for cell in orbit}
                assert len(quotient_values) == 1
                label = f"{next(iter(quotient_values))}[{len(orbit)}]"
                vertex_orbit_label.update({cell: label for cell in orbit})
            winning_edges = {
                (first, second)
                for first in adjacency
                for second in adjacency[first]
                if first < second
            }
            remaining_edges = set(winning_edges)
            edge_orbits = []
            edge_orbit_type_counts = Counter()
            while remaining_edges:
                representative = min(remaining_edges)
                orbit = {
                    tuple(sorted((
                        act_on_cell(record, transformation, representative[0]),
                        act_on_cell(record, transformation, representative[1]),
                    )))
                    for transformation in kernel
                }
                assert orbit <= winning_edges
                orbit_type = "--".join(sorted((
                    vertex_orbit_label[representative[0]],
                    vertex_orbit_label[representative[1]],
                )))
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
            for matching in map(set, matchings):
                used = [(kind, orbit) for kind, orbit in edge_orbits if orbit & matching]
                assert all(orbit <= matching for _kind, orbit in used)
                matching_orbit_types.append(sorted(kind for kind, _orbit in used))
            assert matching_orbit_types == [[
                "0[1]--inf[1]", "1[5]--9[5]", "8[5]--inf[5]"
            ]] * 2
            quotient_counts = Counter(
                "-".join(sorted((quotient[first], quotient[second])))
                for first in adjacency
                for second in adjacency[first]
                if first < second
            )
            endpoints.append(
                (
                    endpoint, witness, histogram, sorted(orbits), adjacency, matchings,
                    quotient_counts, vertex_orbit_label, edge_orbit_type_counts,
                    matching_orbit_types,
                )
            )
        matching_sets = [[set(matching) for matching in endpoint[5]] for endpoint in endpoints]
        for endpoint_index in range(2):
            for transformation in kernel:
                for matching_index, matching in enumerate(matching_sets[endpoint_index]):
                    image = {
                        tuple(sorted((
                            act_on_cell(record, transformation, first),
                            act_on_cell(record, transformation, second),
                        )))
                        for first, second in matching
                    }
                    assert image == matching_sets[endpoint_index][matching_index]
        nonsquare = [g for g in frame_stabilizer if not square_det(g)]
        assert len(nonsquare) == 5
        for transformation in nonsquare:
            for matching_index, matching in enumerate(matching_sets[0]):
                image = {
                    tuple(sorted((
                        act_on_cell(record, transformation, first),
                        act_on_cell(record, transformation, second),
                    )))
                    for first, second in matching
                }
                assert image == matching_sets[1][1 - matching_index]
        replayed.append((record["class"], sorted(packet), endpoints))

    assert [row["class"] for row in recorded["classes"]] == [row[0] for row in replayed]
    for certificate_row, replay_row in zip(recorded["classes"], replayed):
        assert certificate_row["packet_cells"] == [list(cell) for cell in replay_row[1]]
        assert certificate_row["response_matching_action"] == {
            "square_c5_fixes_each_matching": True,
            "nonsquare_d10_coset_swaps_endpoint_and_matching": True,
            "global_calibration_count": 2,
        }
        for certificate_endpoint, replay_endpoint in zip(certificate_row["endpoints"], replay_row[2]):
            assert certificate_endpoint["endpoint_parameter"] == replay_endpoint[0]
            assert certificate_endpoint["witness_cell"] == list(replay_endpoint[1])
            assert certificate_endpoint["candidate_winning_histogram"] == {
                f"{a}/{b}": count for (a, b), count in sorted(replay_endpoint[2].items())
            }
            assert certificate_endpoint["edge_quotient_rule"] == {
                "0/0": [0, 1, "inf"], "2/0": [9], "2/2": [8]
            }
            expected_orbits = [
                {
                    "size": len(orbit),
                    "candidate_winning_signature": f"{signature[0]}/{signature[1]}",
                    "opponents": [list(cell) for cell in orbit],
                }
                for orbit, signature in replay_endpoint[3]
            ]
            assert certificate_endpoint["square_c5_opponent_orbits"] == expected_orbits
            adjacency = replay_endpoint[4]
            matchings = replay_endpoint[5]
            graph = certificate_endpoint["winning_response_graph"]
            assert graph["vertices"] == len(adjacency)
            assert graph["edges"] == sum(map(len, adjacency.values())) // 2
            assert graph["degree_histogram"] == {
                str(degree): count
                for degree, count in sorted(Counter(map(len, adjacency.values())).items())
            }
            assert graph["component_sizes"] == [22]
            winning_edges = sorted(
                (first, second)
                for first in adjacency
                for second in adjacency[first]
                if first < second
            )
            assert graph["winning_edges"] == [
                [list(first), list(second)] for first, second in winning_edges
            ]
            assert graph["quotient_edge_counts"] == dict(sorted(replay_endpoint[6].items()))
            assert graph["perfect_matching_count"] == 2
            assert graph["common_edge_count"] == 6
            assert graph["c5_orbital_decomposition"] == {
                "vertex_orbit_counts": dict(sorted(Counter(replay_endpoint[7].values()).items())),
                "winning_edge_orbit_type_counts": dict(sorted(replay_endpoint[8].items())),
                "perfect_matching_orbit_types": replay_endpoint[9],
                "unforced_bicayley_component": {
                    "parts": ["8[5]", "inf[5]"],
                    "edge_orbits": 2,
                    "vertices": 10,
                    "is_single_cycle": True,
                    "each_edge_orbit_is_a_perfect_matching": True,
                },
            }
            assert graph["perfect_matchings"] == [
                [[list(first), list(second)] for first, second in matching]
                for matching in matchings
            ]
    print("C80 C447 cloud-packet independent replay: PASS")


if __name__ == "__main__":
    main()
