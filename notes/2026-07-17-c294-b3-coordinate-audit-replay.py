#!/usr/bin/env python3
"""Independent structural replay for the C294 E0 coordinate-audit certificate."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from collections import Counter, deque
from pathlib import Path


def load(filename: str, name: str):
    path = Path(__file__).with_name(filename)
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


R = load("2026-07-17-c294-recursive-defective-mirror.py", "c294_coordinate_replay_r")
M = R.M


def digest(value: object) -> str:
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(",", ":")).encode()).hexdigest()


def targets(model):
    return tuple(
        tuple(model.index[M.compose(generator, element)] for generator in model.generators)
        for element in model.elements
    )


def coset_blocks(model, first: int, second: int):
    subgroup = M.generated_group((model.generators[first], model.generators[second]))
    unseen = set(range(len(model.elements)))
    blocks = []
    while unseen:
        seed = min(unseen)
        block = tuple(sorted(model.index[M.compose(element, model.elements[seed])] for element in subgroup))
        assert set(block) <= unseen
        unseen -= set(block)
        blocks.append(block)
    return tuple(sorted(blocks)), len(subgroup)


def width(adjacency, blocks, order):
    eliminated = set()
    maximum = 0
    for block_index in order:
        eliminated.update(blocks[block_index])
        boundary = {
            neighbour
            for vertex in eliminated
            for neighbour in M.bits(adjacency[vertex])
            if neighbour not in eliminated
        }
        maximum = max(maximum, len(boundary))
    return maximum


def check_case(record):
    model = R.Model(5, record["type_index"])
    coloured = targets(model)
    assert digest(coloured) == record["coloured_graph_sha256"]
    rebuilt = tuple(sum(1 << target for target in row) for row in coloured)
    assert rebuilt == model.adjacency
    assert digest(model.adjacency) == record["uncoloured_adjacency_sha256"]

    sheets = {model.identity_index: 0}
    queue = deque([model.identity_index])
    while queue:
        vertex = queue.popleft()
        for colour, target in enumerate(coloured[vertex]):
            candidate = sheets[vertex] ^ model.classes[colour]
            if target in sheets:
                assert sheets[target] == candidate
            else:
                sheets[target] = candidate
                queue.append(target)
    assert Counter(sheets.values()) == Counter({0: 60, 1: 60})
    assert list(model.classes) == record["generator_determinant_bits"]
    transition_counts = [
        Counter(sheets[vertex] ^ sheets[coloured[vertex][colour]] for vertex in range(len(coloured)))
        for colour in range(3)
    ]
    recorded_transitions = [
        Counter({int(bit): count for bit, count in colour_counts})
        for colour_counts in record["edge_colour_sheet_transition_counts"]
    ]
    assert transition_counts == recorded_transitions

    by_pair = {tuple(item["colours"]): item for item in record["pair_systems"]}
    for first, second in ((0, 1), (0, 2), (1, 2)):
        item = by_pair[(first, second)]
        blocks, subgroup_size = coset_blocks(model, first, second)
        assert subgroup_size == item["subgroup_size"]
        assert len(blocks) == item["coset_count"] == item["block_count"]
        assert digest(blocks) == item["blocks_sha256"]
        block_of = {vertex: block for block, vertices in enumerate(blocks) for vertex in vertices}
        third = 3 - first - second
        matching = {
            tuple(sorted((vertex, coloured[vertex][third]))) for vertex in range(len(coloured))
        }
        multiplicities = Counter(
            tuple(sorted((block_of[left], block_of[right]))) for left, right in matching
        )
        assert digest(sorted(multiplicities.items())) == item["third_matching_block_quotient_sha256"]
        product_order = M.permutation_order(M.compose(model.generators[first], model.generators[second]))
        assert item["pair_product_order"] == product_order
        for block in blocks:
            start = block[0]
            visited = {start}
            vertex = start
            colour = first
            for _ in range(2 * product_order - 1):
                vertex = coloured[vertex][colour]
                assert vertex not in visited
                visited.add(vertex)
                colour = second if colour == first else first
            assert coloured[vertex][colour] == start
            assert visited == set(block)
        for name, order in item["block_orders"].items():
            assert sorted(order) == list(range(len(blocks)))
            assert width(model.adjacency, blocks, order) == item["elimination_live_boundary_widths"][name]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("certificate", type=Path)
    args = parser.parse_args()
    certificate = json.loads(args.certificate.read_text())
    assert certificate["schema"] == "c294-b3-coloured-coordinate-audit-v1"
    assert certificate["hard_types"] == [0, 1, 2, 3, 7, 9, 11]
    for case in certificate["cases"]:
        check_case(case)
    print(json.dumps({"cases_checked": len(certificate["cases"]), "status": "passed"}, sort_keys=True))


if __name__ == "__main__":
    main()
