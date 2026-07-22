#!/usr/bin/env python3
"""Independent frame-normalization replay of the decorated deep-hole theorem."""

from __future__ import annotations

import importlib.util
import json
from collections import Counter
from itertools import combinations, permutations
from pathlib import Path


UPSTREAM = "2026-07-20-c398-conic-deep-hole-classification"
OUTPUT = "2026-07-22-c474-reed-solomon-decorated-deep-holes"


def load_module(root):
    path = root / "notes" / f"{UPSTREAM}.py"
    spec = importlib.util.spec_from_file_location("c398_replay", path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def signature(module, field, parent, locus):
    blocks = []
    for omitted_index in range(6):
        five = parent[:omitted_index] + parent[omitted_index + 1:]
        basis = module.nullspace(field, [module.quadratic_row(field, point) for point in five])
        assert len(basis) == 1
        blocks.append(tuple(
            index for index, point in enumerate(locus)
            if module.evaluate_form(field, basis[0], point) == 0
        ))
    return tuple(sorted(blocks))


def fixed_child_fibre(module, field, parent, locus):
    target = module.canonical_arc(field, locus)
    parents = set()
    for power in range(field.degree):
        twisted_locus = tuple(tuple(field.frobenius(value, power) for value in point) for point in locus)
        twisted_parent = tuple(tuple(field.frobenius(value, power) for value in point) for point in parent)
        for ordered_frame in permutations(twisted_locus, 4):
            if module.frame_normalize(field, ordered_frame, twisted_locus) != target:
                continue
            parents.add(module.frame_normalize(field, ordered_frame, twisted_parent))
    return target, tuple(sorted(parents))


def rank(rows, prime):
    matrix = [[value % prime for value in row] for row in rows]
    answer = 0
    for column in range(len(matrix[0]) if matrix else 0):
        pivot = next((row for row in range(answer, len(matrix)) if matrix[row][column]), None)
        if pivot is None:
            continue
        matrix[answer], matrix[pivot] = matrix[pivot], matrix[answer]
        scale = pow(matrix[answer][column], -1, prime)
        matrix[answer] = [(scale * value) % prime for value in matrix[answer]]
        for row in range(len(matrix)):
            if row == answer or matrix[row][column] == 0:
                continue
            factor = matrix[row][column]
            matrix[row] = [(x - factor * y) % prime for x, y in zip(matrix[row], matrix[answer])]
        answer += 1
    return answer


def relation_summary(signatures, locus_size, prime):
    blocks = tuple(sorted({block for value in signatures for block in value if block}))
    counts = Counter(block for value in signatures for block in value if block)
    if not blocks or set(counts.values()) != {2}:
        return None
    adjacency = {index: set() for index in range(len(signatures))}
    for block in blocks:
        endpoints = [index for index, value in enumerate(signatures) if block in value]
        assert len(endpoints) == 2
        adjacency[endpoints[0]].add(endpoints[1])
        adjacency[endpoints[1]].add(endpoints[0])
    colors = {0: 0}
    frontier = [0]
    while frontier:
        vertex = frontier.pop()
        for neighbor in adjacency[vertex]:
            if neighbor not in colors:
                colors[neighbor] = 1 - colors[vertex]
                frontier.append(neighbor)
            else:
                assert colors[neighbor] != colors[vertex]
    assert len(colors) == len(signatures)
    parts = [[index for index in range(len(signatures)) if colors[index] == color] for color in (0, 1)]
    shared = [[int(right in adjacency[left]) for right in parts[1]] for left in parts[0]]
    zero = [[1 - value for value in row] for row in shared]
    missing = set(combinations(range(locus_size), 2)) - set(blocks)
    return {
        "degree": sorted({len(value) for value in adjacency.values()}),
        "edges": sum(map(len, adjacency.values())) // 2,
        "parts": sorted(map(len, parts)),
        "blocks": len(blocks),
        "missing_pairs": len(missing),
        "missing_degree_profile": sorted(Counter(index for block in missing for index in block).values()),
        "shared_rank": rank(shared, prime),
        "zero_rank": rank(zero, prime),
    }


def parent_deep_hole_orbits(module, field, parent, locus):
    target_parent = module.canonical_arc(field, parent)
    target_locus = None
    actions = set()
    for power in range(field.degree):
        twisted_parent = tuple(tuple(field.frobenius(value, power) for value in point) for point in parent)
        twisted_locus = tuple(tuple(field.frobenius(value, power) for value in point) for point in locus)
        for ordered_frame in permutations(twisted_parent, 4):
            if module.frame_normalize(field, ordered_frame, twisted_parent) != target_parent:
                continue
            normalized_locus = module.frame_normalize(field, ordered_frame, twisted_locus)
            if target_locus is None:
                target_locus = normalized_locus
            assert normalized_locus == target_locus
            index = {point: i for i, point in enumerate(target_locus)}
            actions.add(tuple(
                index[module.frame_normalize(field, ordered_frame, (point,))[0]] for point in twisted_locus
            ))
    assert target_locus is not None
    unseen = set(range(len(target_locus)))
    sizes = []
    while unseen:
        seed = min(unseen)
        orbit = {action[seed] for action in actions}
        unseen -= orbit
        sizes.append(len(orbit))
    return len(actions), tuple(sorted(sizes))


def main():
    root = Path(__file__).resolve().parents[1]
    module = load_module(root)
    upstream = json.loads((root / "notes" / f"{UPSTREAM}.json").read_text())
    recorded = json.loads((root / "notes" / f"{OUTPUT}.json").read_text())
    replay = []
    for field_record in upstream["fields"]:
        if field_record["q"] not in (8, 9, 11):
            continue
        field = module.FiniteField(field_record["q"])
        for survivor_index, survivor in enumerate(field_record["survivors"]):
            parent = tuple(tuple(point) for point in survivor["arc"])
            locus = tuple(tuple(point) for point in survivor["locus"])
            target, parents = fixed_child_fibre(module, field, parent, locus)
            signatures = tuple(sorted({signature(module, field, value, target) for value in parents}))
            profile = tuple(sorted(map(len, signatures[0])))
            prime = field.p if field.q == 9 else (3 if field.q == 11 else field.p)
            parent_action_order, deep_hole_orbits = parent_deep_hole_orbits(module, field, parent, locus)
            replay.append({
                "q": field.q,
                "locus_size": len(target),
                "parents": len(parents),
                "signatures": len(signatures),
                "profile": profile,
                "relation": relation_summary(signatures, len(target), prime),
                "parent_action_order": parent_action_order,
                "deep_hole_orbits": deep_hole_orbits,
            })
    replay.sort(key=lambda row: (row["q"], row["locus_size"]))
    assert [(row["q"], row["locus_size"], row["parents"], row["signatures"], row["profile"]) for row in replay] == [
        (8, 4, 6, 1, (0, 0, 0, 0, 0, 4)),
        (9, 6, 8, 8, (0, 0, 0, 2, 2, 2)),
        (9, 7, 2, 1, (1, 1, 1, 1, 1, 1)),
        (11, 12, 22, 22, (2, 2, 2, 2, 2, 2)),
    ]
    assert replay[1]["relation"] == {
        "degree": [3], "edges": 12, "parts": [4, 4], "blocks": 12,
        "missing_pairs": 3, "missing_degree_profile": [1, 1, 1, 1, 1, 1],
        "shared_rank": 3, "zero_rank": 4,
    }
    assert replay[3]["relation"] == {
        "degree": [6], "edges": 66, "parts": [11, 11], "blocks": 66,
        "missing_pairs": 0, "missing_degree_profile": [],
        "shared_rank": 5, "zero_rank": 6,
    }
    assert [(row["parent_action_order"], row["deep_hole_orbits"]) for row in replay] == [
        (12, (4,)), (6, (6,)), (6, (1, 6)), (60, (12,)),
    ]
    assert [(case["q"], case["locus_size"], case["fixed_locus_parent_fibre_size"],
             case["distinct_deletion_trace_signatures"]) for case in recorded["cases"]] == [
        (row["q"], row["locus_size"], row["parents"], row["signatures"]) for row in replay
    ]
    assert [(case["induced_parent_automorphism_action_on_locus_order"],
             tuple(case["projective_deep_hole_orbit_sizes"])) for case in recorded["cases"]] == [
        (row["parent_action_order"], row["deep_hole_orbits"]) for row in replay
    ]
    print(json.dumps({"status": "ok", "cases": replay}, sort_keys=True))


if __name__ == "__main__":
    main()
