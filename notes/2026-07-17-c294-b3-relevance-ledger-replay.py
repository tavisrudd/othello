#!/usr/bin/env python3
"""Independent bounded replay for the C294 B3 E1 relevance ledger."""

from __future__ import annotations

import argparse
import importlib.util
import json
from collections import deque
from functools import lru_cache
from pathlib import Path
from types import ModuleType


def load_module(filename: str, name: str) -> ModuleType:
    path = Path(__file__).with_name(filename)
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


R = load_module("2026-07-17-c294-recursive-defective-mirror.py", "c294_e1_replay_r")


def mask(record: dict[str, int]) -> int:
    return record["lo"] | (record["hi"] << 64)


def components(adjacency: tuple[int, ...], live: int) -> tuple[int, ...]:
    result = []
    unseen = live
    while unseen:
        seed = unseen & -unseen
        part = seed
        queue = seed
        unseen ^= seed
        while queue:
            bit = queue & -queue
            queue ^= bit
            vertex = bit.bit_length() - 1
            reached = adjacency[vertex] & unseen
            unseen ^= reached
            queue |= reached
            part |= reached
        result.append(part)
    return tuple(sorted(result))


def direct_nimber(adjacency: tuple[int, ...], closed: tuple[int, ...], start: int) -> int:
    @lru_cache(maxsize=None)
    def nimber(live: int) -> int:
        parts = components(adjacency, live)
        if len(parts) > 1:
            value = 0
            for part in parts:
                value ^= nimber(part)
            return value
        options = set()
        moves = live
        while moves:
            bit = moves & -moves
            moves ^= bit
            options.add(nimber(live & ~closed[bit.bit_length() - 1]))
        value = 0
        while value in options:
            value += 1
        return value

    return nimber(start)


def coloured_targets(model: object) -> tuple[tuple[int, int, int], ...]:
    return tuple(
        tuple(model.index[R.M.compose(generator, element)] for generator in model.generators)
        for element in model.elements
    )


def pair_blocks(targets: tuple[tuple[int, int, int], ...]) -> tuple[tuple[int, ...], ...]:
    unseen = set(range(len(targets)))
    result = []
    while unseen:
        seed = min(unseen)
        block = {seed}
        queue = [seed]
        while queue:
            vertex = queue.pop()
            for colour in (0, 2):
                target = targets[vertex][colour]
                if target not in block:
                    block.add(target)
                    queue.append(target)
        unseen -= block
        result.append(tuple(sorted(block)))
    return tuple(sorted(result))


def prefix_width(adjacency: tuple[int, ...], blocks: tuple[tuple[int, ...], ...], order: list[int]) -> int:
    past = sum((sum(1 << vertex for vertex in blocks[block]) for block in order), 0)
    future = ((1 << len(adjacency)) - 1) ^ past
    boundary = 0
    scan = past
    while scan:
        bit = scan & -scan
        scan ^= bit
        boundary |= adjacency[bit.bit_length() - 1] & future
    return boundary.bit_count()


def greedy_order(adjacency: tuple[int, ...], blocks: tuple[tuple[int, ...], ...]) -> list[int]:
    remaining = set(range(len(blocks)))
    result: list[int] = []
    while remaining:
        chosen = min(remaining, key=lambda block: (prefix_width(adjacency, blocks, result + [block]), block))
        result.append(chosen)
        remaining.remove(chosen)
    return result


def cut_ports(adjacency: tuple[int, ...], blocks: tuple[tuple[int, ...], ...], order: list[int], cut: int) -> list[int]:
    past = sum((sum(1 << vertex for vertex in blocks[order[index]]) for index in range(cut)), 0)
    future = ((1 << len(adjacency)) - 1) ^ past
    boundary = 0
    scan = past
    while scan:
        bit = scan & -scan
        scan ^= bit
        boundary |= adjacency[bit.bit_length() - 1] & future
    return [vertex for vertex in range(len(adjacency)) if boundary >> vertex & 1]


def check_one(path: Path) -> dict[str, object]:
    data = json.loads(path.read_text())
    q = data["field_order"]
    expected = {
        3: (108, 680, 49, 1, False),
        5: (100000, 1946240, 84964, -1, True),
    }[q]
    fixed = data["fixed_prefix"]
    observed = (
        fixed["connected_states"], fixed["decompositions"], fixed["quotient_classes"],
        fixed["follower_nimber"], fixed["stopped_at_limit"],
    )
    assert observed == expected
    search = data["search_relevance"]
    assert search["duplicate_mex_options"] == search["legal_moves"] - search["distinct_option_nimbers"]
    assert search["evaluated_states_audited"] + search["incomplete_states_at_stop"] == fixed["connected_states"]
    assert search["incomplete_states_at_stop"] == (0 if q == 3 else 19)

    model = R.Model(q, data["type_index"])
    adjacency = model.adjacency
    closed = tuple(neighbours | (1 << vertex) for vertex, neighbours in enumerate(adjacency))
    targets = coloured_targets(model)
    blocks = pair_blocks(targets)
    order = greedy_order(adjacency, blocks)
    witness = data["first_repeated_boundary_record"]
    ports = cut_ports(adjacency, blocks, order, witness["cut"])
    assert ports == witness["ports"]
    for name in ("prior", "current"):
        live = mask(witness[name])
        word = sum((1 << index) for index, vertex in enumerate(ports) if live >> vertex & 1)
        assert word == witness["live_word"]

    xor = data["first_small_xor_witness"]
    parent = mask(xor["parent"])
    child = mask(xor["child"])
    assert child == parent & ~closed[xor["move"]]
    emitted_parts = tuple(sorted(mask(item["mask"]) for item in xor["components"]))
    assert emitted_parts == components(adjacency, child)
    replay_values = [direct_nimber(adjacency, closed, part) for part in emitted_parts]
    emitted_values = {mask(item["mask"]): item["nimber"] for item in xor["components"]}
    assert replay_values == [emitted_values[part] for part in emitted_parts]
    value = 0
    for item in replay_values:
        value ^= item
    assert value == xor["child_nimber"]

    best = max(item["maximum_genuine_removals"] for item in data["candidate_headroom"])
    return {
        "best_genuine_headroom": best,
        "field_order": q,
        "fixed_prefix_counts_checked": True,
        "repeated_boundary_record_checked": True,
        "small_xor_witness_checked": True,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("q3", type=Path)
    parser.add_argument("q5", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    cases = [check_one(args.q3), check_one(args.q5)]
    result = {
        "cases": cases,
        "e2_headroom_gate": cases[1]["best_genuine_headroom"] >= 850,
        "schema": "c294-b3-relevance-ledger-replay-v1",
        "status": "passed",
    }
    args.output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
