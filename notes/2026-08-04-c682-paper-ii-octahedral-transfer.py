#!/usr/bin/env python3
"""Certify the octahedral matching--chord transfer in Clebsch Paper II."""

from __future__ import annotations

import argparse
import importlib.util
import itertools
import json
from collections import Counter, deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "papers/clebsch-factorization/verification/evidence/matching_module.py"
TRACKED = ROOT / "notes/2026-08-04-c682-paper-ii-octahedral-transfer.json"


def load_source():
    spec = importlib.util.spec_from_file_location("paper_ii_matching_module", SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def edge_image(permutation, edge):
    return tuple(sorted((permutation[edge[0]], permutation[edge[1]])))


def stabilizer(group, obj, action):
    return frozenset(g for g in group if action(g, obj) == obj)


def graph_connected(rows):
    left = len(rows)
    right = len(rows[0]) if rows else 0
    adjacency = [[] for _ in range(left + right)]
    for i, row in enumerate(rows):
        for j, value in enumerate(row):
            if value:
                adjacency[i].append(left + j)
                adjacency[left + j].append(i)
    seen = {0}
    queue = deque([0])
    while queue:
        vertex = queue.popleft()
        for neighbor in adjacency[vertex]:
            if neighbor not in seen:
                seen.add(neighbor)
                queue.append(neighbor)
    return len(seen) == left + right


def compute():
    module = load_source()
    prime = 7
    conic, parameters = module.COXETER.conic_parameterization(prime)
    group, psl = module.full_pgl(prime, parameters)
    octahedral = module.coxeter_group("B3", prime, conic)
    base_matching = ((0, 2), (1, 4), (3, 7), (5, 6))
    matchings = tuple(sorted({module.matching_image(g, base_matching) for g in group}))
    chords = tuple(itertools.combinations(range(8), 2))
    assert len(group) == 336 and len(psl) == 168
    assert len(octahedral) == 24 and len(matchings) == 14 and len(chords) == 28

    matching_stabilizers = tuple(
        stabilizer(group, matching, module.matching_image) for matching in matchings
    )
    chord_stabilizers = tuple(stabilizer(group, chord, edge_image) for chord in chords)
    assert {len(value) for value in matching_stabilizers} == {24}
    assert {len(value) for value in chord_stabilizers} == {12}

    incidence = [[int(chord in matching) for chord in chords] for matching in matchings]
    intersection_incidence = [
        [int(len(left & right) == 6) for right in chord_stabilizers]
        for left in matching_stabilizers
    ]
    assert incidence == intersection_incidence
    assert {sum(row) for row in incidence} == {4}
    assert {sum(incidence[i][j] for i in range(14)) for j in range(28)} == {2}
    assert graph_connected(incidence)

    intersection_counts = Counter(
        len(left & right) for left in matching_stabilizers for right in chord_stabilizers
    )
    first_chord = next(j for j, chord in enumerate(chords) if chord in matchings[0])
    edge_group = matching_stabilizers[0] & chord_stabilizers[first_chord]
    edge_profile = Counter(module.permutation_order(g) for g in edge_group)
    generated = module.COXETER.generated_permutation_group(
        list(matching_stabilizers[0] | chord_stabilizers[first_chord])
    )
    assert intersection_counts == {2: 336, 6: 56}
    assert len(edge_group) == 6 and edge_profile == {1: 1, 2: 3, 3: 2}
    assert len(generated) == 336

    sheets = []
    unseen = set(matchings)
    while unseen:
        representative = min(unseen)
        sheet = {module.matching_image(g, representative) for g in psl}
        unseen -= sheet
        sheets.append(sheet)
    assert [len(sheet) for sheet in sheets] == [7, 7]
    sign = [1 if matching in sheets[0] else -1 for matching in matchings]
    sheet_degrees = []
    for j in range(28):
        sheet_degrees.append(
            tuple(sum(incidence[i][j] for i, matching in enumerate(matchings) if matching in sheet)
                  for sheet in sheets)
        )
    assert set(sheet_degrees) == {(1, 1)}
    assert all(sum(incidence[i][j] * sign[i] for i in range(14)) == 0 for j in range(28))

    transpose = module.transpose(incidence)
    rank_mod_7 = module.rank(transpose, 7)
    rank_mod_2 = module.rank(transpose, 2)
    kernel_mod_7 = module.nullspace(transpose, 7)
    assert rank_mod_7 == rank_mod_2 == 13 and len(kernel_mod_7) == 1
    normalized_sign = [value % 7 for value in sign]
    pivot = next(i for i, value in enumerate(kernel_mod_7[0]) if value)
    scale = normalized_sign[pivot] * pow(kernel_mod_7[0][pivot], -1, 7) % 7
    assert [scale * value % 7 for value in kernel_mod_7[0]] == normalized_sign

    matching_adjacency = [[0] * 14 for _ in range(14)]
    for i in range(14):
        for j in range(14):
            common = sum(incidence[i][e] * incidence[j][e] for e in range(28))
            matching_adjacency[i][j] = common - (4 if i == j else 0)
    assert {sum(row) for row in matching_adjacency} == {4}
    assert all(
        sum(matching_adjacency[i][j] * sign[j] for j in range(14)) == -4 * sign[i]
        for i in range(14)
    )

    return {
        "schema": "c682-paper-ii-octahedral-transfer-v1",
        "field_order": 7,
        "group_order": len(group),
        "psl_order": len(psl),
        "matching_family": {
            "count": len(matchings),
            "matching_size": len(base_matching),
            "stabilizer_order": 24,
            "stabilizer_type": "S4",
            "sheet_sizes": [len(sheet) for sheet in sheets],
        },
        "chord_family": {
            "count": len(chords),
            "stabilizer_order": 12,
            "stabilizer_type": "D12",
        },
        "correspondence": {
            "equivalent_definitions": ["chord_membership", "stabilizer_intersection_order_6"],
            "matching_degree": 4,
            "chord_degree": 2,
            "flag_count": 56,
            "flag_stabilizer_order": len(edge_group),
            "flag_stabilizer_type": "S3",
            "flag_stabilizer_order_profile": dict(sorted(edge_profile.items())),
            "generated_group_order": len(generated),
            "connected": True,
            "rank_mod_7": rank_mod_7,
            "rank_mod_2": rank_mod_2,
            "kernel_dimension_mod_7": len(kernel_mod_7),
        },
        "trade": {
            "each_chord_occurs_once_in_each_sheet": True,
            "sheet_sign_spans_correspondence_kernel": True,
            "shared_chord_graph_degree": 4,
            "sheet_sign_adjacency_eigenvalue": -4,
        },
        "all_stabilizer_intersection_order_counts": dict(sorted(intersection_counts.items())),
        "trusted_inputs": [str(SOURCE.relative_to(ROOT))],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    encoded = json.dumps(compute(), indent=2, sort_keys=True) + "\n"
    if args.write:
        TRACKED.write_text(encoded)
    elif args.check:
        assert TRACKED.read_text() == encoded, "tracked certificate is stale"
        print("C682 Paper-II octahedral transfer: PASS")
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
