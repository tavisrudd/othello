#!/usr/bin/env python3
"""C294 E0: exact coloured-Cayley coordinate audit without game recursion."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from collections import Counter, deque
from pathlib import Path
from types import ModuleType
from typing import Iterable


HARD_TYPES = (0, 1, 2, 3, 7, 9, 11)
COLOUR_PAIRS = ((0, 1), (0, 2), (1, 2))


def load_module(filename: str, name: str) -> ModuleType:
    path = Path(__file__).with_name(filename)
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


R = load_module("2026-07-17-c294-recursive-defective-mirror.py", "c294_coordinate_r")
M = R.M


def stable_hash(value: object) -> str:
    encoded = json.dumps(value, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(encoded).hexdigest()


def histogram(values: Iterable[object]) -> list[list[object]]:
    counts = Counter(values)
    return [[key, counts[key]] for key in sorted(counts)]


def coloured_targets(model: object) -> tuple[tuple[int, int, int], ...]:
    targets = tuple(
        tuple(model.index[M.compose(generator, element)] for generator in model.generators)
        for element in model.elements
    )
    rebuilt = tuple(sum(1 << target for target in row) for row in targets)
    assert rebuilt == model.adjacency
    assert all(len(set(row)) == 3 for row in targets)
    return targets  # type: ignore[return-value]


def determinant_sheets(
    model: object, targets: tuple[tuple[int, int, int], ...]
) -> tuple[int, ...]:
    sheets: list[int | None] = [None] * len(targets)
    sheets[model.identity_index] = 0
    queue = deque([model.identity_index])
    while queue:
        vertex = queue.popleft()
        assert sheets[vertex] is not None
        for colour, target in enumerate(targets[vertex]):
            candidate = sheets[vertex] ^ model.classes[colour]
            if sheets[target] is None:
                sheets[target] = candidate
                queue.append(target)
            else:
                assert sheets[target] == candidate
    assert all(sheet is not None for sheet in sheets)
    return tuple(int(sheet) for sheet in sheets)


def pair_blocks(
    targets: tuple[tuple[int, int, int], ...], first: int, second: int
) -> tuple[tuple[int, ...], ...]:
    unseen = set(range(len(targets)))
    blocks = []
    while unseen:
        seed = min(unseen)
        block = {seed}
        queue = [seed]
        while queue:
            vertex = queue.pop()
            for colour in (first, second):
                target = targets[vertex][colour]
                if target not in block:
                    block.add(target)
                    queue.append(target)
        unseen -= block
        blocks.append(tuple(sorted(block)))
    return tuple(sorted(blocks))


def alternating_word(
    targets: tuple[tuple[int, int, int], ...], block: tuple[int, ...], first: int, second: int
) -> tuple[int, ...]:
    start = min(block)
    word = [start]
    current = start
    colour = first
    while True:
        current = targets[current][colour]
        if current == start:
            break
        assert current not in word
        word.append(current)
        colour = second if colour == first else first
    assert set(word) == set(block)
    return tuple(word)


def live_boundary_width(
    adjacency: tuple[int, ...], blocks: tuple[tuple[int, ...], ...], order: list[int]
) -> int:
    assert sorted(order) == list(range(len(blocks)))
    eliminated = 0
    maximum = 0
    full = (1 << len(adjacency)) - 1
    for block_index in order:
        for vertex in blocks[block_index]:
            eliminated |= 1 << vertex
        live = full ^ eliminated
        boundary = 0
        for vertex in R.M.bits(eliminated):
            boundary |= adjacency[vertex] & live
        maximum = max(maximum, boundary.bit_count())
    return maximum


def prefix_live_boundary(
    adjacency: tuple[int, ...], blocks: tuple[tuple[int, ...], ...], order: list[int]
) -> int:
    eliminated = 0
    for block_index in order:
        for vertex in blocks[block_index]:
            eliminated |= 1 << vertex
    live = ((1 << len(adjacency)) - 1) ^ eliminated
    boundary = 0
    for vertex in R.M.bits(eliminated):
        boundary |= adjacency[vertex] & live
    return boundary.bit_count()


def quotient_neighbours(
    blocks: tuple[tuple[int, ...], ...], targets: tuple[tuple[int, int, int], ...], colour: int
) -> tuple[tuple[int, ...], ...]:
    block_of = {vertex: block for block, vertices in enumerate(blocks) for vertex in vertices}
    return tuple(
        tuple(sorted({block_of[targets[vertex][colour]] for vertex in vertices} - {block}))
        for block, vertices in enumerate(blocks)
    )


def bfs_order(neighbours: tuple[tuple[int, ...], ...], start: int) -> list[int]:
    seen = {start}
    order = []
    queue = deque([start])
    while queue:
        block = queue.popleft()
        order.append(block)
        for target in neighbours[block]:
            if target not in seen:
                seen.add(target)
                queue.append(target)
    assert len(order) == len(neighbours)
    return order


def greedy_order(adjacency: tuple[int, ...], blocks: tuple[tuple[int, ...], ...]) -> list[int]:
    remaining = set(range(len(blocks)))
    order: list[int] = []
    while remaining:
        chosen = min(
            remaining,
            key=lambda block: (prefix_live_boundary(adjacency, blocks, order + [block]), block),
        )
        order.append(chosen)
        remaining.remove(chosen)
    return order


def action_orbit_count(items: set[object], actions: tuple[object, ...], act: object) -> int:
    unseen = set(items)
    count = 0
    while unseen:
        seed = min(unseen)  # type: ignore[type-var]
        orbit = {act(seed, action) for action in actions}  # type: ignore[operator]
        assert orbit <= items
        unseen -= orbit
        count += 1
    return count


def audit_type(type_index: int) -> dict[str, object]:
    model = R.Model(5, type_index)
    targets = coloured_targets(model)
    sheets = determinant_sheets(model, targets)
    deleted_mask = model.closed[model.identity_index]
    deleted = tuple(M.bits(deleted_mask))
    stabilizer = tuple(
        action for action in model.right_actions if R.map_mask(deleted_mask, action) == deleted_mask
    )
    assert stabilizer

    pair_results = []
    deleted_coordinates: dict[str, object] = {}
    for first, second in COLOUR_PAIRS:
        third = 3 - first - second
        blocks = pair_blocks(targets, first, second)
        block_of = {vertex: block for block, vertices in enumerate(blocks) for vertex in vertices}
        words = tuple(alternating_word(targets, block, first, second) for block in blocks)
        position = {vertex: offset for word in words for offset, vertex in enumerate(word)}

        subgroup = M.generated_group((model.generators[first], model.generators[second]))
        cosets = {
            frozenset(model.index[M.compose(element, model.elements[seed])] for element in subgroup)
            for seed in range(len(model.elements))
        }
        assert cosets == {frozenset(block) for block in blocks}

        matching_edges = {
            tuple(sorted((vertex, targets[vertex][third]))) for vertex in range(len(targets))
        }
        block_edges = Counter(
            tuple(sorted((block_of[first_vertex], block_of[second_vertex])))
            for first_vertex, second_vertex in matching_edges
        )
        neighbours = quotient_neighbours(blocks, targets, third)
        identity_block = block_of[model.identity_index]
        orders = {
            "canonical": list(range(len(blocks))),
            "identity_bfs": bfs_order(neighbours, identity_block),
            "greedy_min_boundary": greedy_order(model.adjacency, blocks),
        }
        widths = {
            name: live_boundary_width(model.adjacency, blocks, order)
            for name, order in orders.items()
        }

        def act_block(block: int, action: tuple[int, ...]) -> int:
            images = {block_of[action[vertex]] for vertex in blocks[block]}
            assert len(images) == 1
            return images.pop()

        def act_edge(edge: tuple[int, int], action: tuple[int, ...]) -> tuple[int, int]:
            return tuple(sorted((action[edge[0]], action[edge[1]])))  # type: ignore[return-value]

        product_order = M.permutation_order(
            M.compose(model.generators[first], model.generators[second])
        )
        assert len(subgroup) == 2 * product_order
        pair_results.append(
            {
                "alternating_cycle_length_histogram": histogram(map(len, words)),
                "block_count": len(blocks),
                "block_orbits_under_initial_stabilizer": action_orbit_count(
                    set(range(len(blocks))), stabilizer, act_block
                ),
                "block_orders": orders,
                "block_sheet_profile_histogram": histogram(
                    tuple(sorted(Counter(sheets[vertex] for vertex in block).items()))
                    for block in blocks
                ),
                "blocks_sha256": stable_hash(blocks),
                "colours": [first, second],
                "coset_count": len(cosets),
                "elimination_live_boundary_widths": widths,
                "pair_product_order": product_order,
                "subgroup_size": len(subgroup),
                "third_colour": third,
                "third_matching_block_multiplicity_histogram": histogram(block_edges.values()),
                "third_matching_block_quotient_sha256": stable_hash(sorted(block_edges.items())),
                "third_matching_edge_orbits_under_initial_stabilizer": action_orbit_count(
                    set(matching_edges), stabilizer, act_edge
                ),
                "third_matching_edges_inside_blocks": sum(
                    multiplicity for (left, right), multiplicity in block_edges.items() if left == right
                ),
            }
        )
        deleted_coordinates[f"{first}{second}"] = [
            {"block": block_of[vertex], "position": position[vertex], "vertex": vertex}
            for vertex in deleted
        ]

    def act_vertex(vertex: int, action: tuple[int, ...]) -> int:
        return action[vertex]

    case: dict[str, object] = {
        "coloured_graph_sha256": stable_hash(targets),
        "deleted_neighbourhood_sha256": stable_hash(deleted),
        "edge_colour_sheet_transition_counts": [
            histogram(sheets[vertex] ^ sheets[targets[vertex][colour]] for vertex in range(len(targets)))
            for colour in range(3)
        ],
        "field_order": 5,
        "generator_determinant_bits": list(model.classes),
        "initial_defect_stabilizer_order": len(stabilizer),
        "initial_defect_vertex_orbits": action_orbit_count(set(deleted), stabilizer, act_vertex),
        "orbit_size": model.orbit_size,
        "pair_systems": pair_results,
        "representative_centres": [list(point) for point in model.representative],
        "sheet_counts": histogram(sheets),
        "type_index": type_index,
        "uncoloured_adjacency_sha256": stable_hash(model.adjacency),
        "vertices": len(model.elements),
    }
    if type_index == 0:
        case["identity_follower"] = {
            "deleted_coordinates_by_pair": deleted_coordinates,
            "deleted_sheets": [sheets[vertex] for vertex in deleted],
            "deleted_vertices": list(deleted),
            "follower_vertices": len(model.elements) - len(deleted),
            "identity_vertex": model.identity_index,
        }
    return case


def generate() -> dict[str, object]:
    return {
        "cases": [audit_type(type_index) for type_index in HARD_TYPES],
        "hard_types": list(HARD_TYPES),
        "schema": "c294-b3-coloured-coordinate-audit-v1",
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    result = generate()
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.check is not None and args.check.read_text() != encoded:
        raise SystemExit(f"generated output differs from {args.check}")
    if args.output is not None:
        args.output.write_text(encoded)
    elif args.check is None:
        print(encoded, end="")


if __name__ == "__main__":
    main()
