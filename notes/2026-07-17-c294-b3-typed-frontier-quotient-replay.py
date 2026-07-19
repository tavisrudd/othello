#!/usr/bin/env python3
"""Independent small-kernel replay for the C294 B3 E2 bounded negative."""

from __future__ import annotations

import argparse
import importlib.util
import json
from functools import cache
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


E0 = load_module("2026-07-17-c294-b3-coordinate-audit.py", "c294_e2_replay_e0")


def components(mask: int, adjacency: tuple[int, ...]) -> tuple[int, ...]:
    result: list[int] = []
    unseen = mask
    while unseen:
        seed = unseen & -unseen
        part = seed
        frontier = seed
        unseen ^= seed
        while frontier:
            vertex_bit = frontier & -frontier
            frontier ^= vertex_bit
            vertex = vertex_bit.bit_length() - 1
            reached = adjacency[vertex] & unseen
            unseen ^= reached
            frontier |= reached
            part |= reached
        result.append(part)
    return tuple(result)


def direct_nimber(mask: int, adjacency: tuple[int, ...]) -> int:
    closed = tuple(neighbours | (1 << vertex) for vertex, neighbours in enumerate(adjacency))

    @cache
    def solve(position: int) -> int:
        parts = components(position, adjacency)
        if len(parts) > 1:
            value = 0
            for part in parts:
                value ^= solve(part)
            return value
        options: set[int] = set()
        moves = position
        while moves:
            bit = moves & -moves
            moves ^= bit
            options.add(solve(position & ~closed[bit.bit_length() - 1]))
        value = 0
        while value in options:
            value += 1
        return value

    return solve(mask)


def isomorphic(left: int, right: int, adjacency: tuple[int, ...]) -> bool:
    if left.bit_count() != right.bit_count():
        return False
    a = tuple(index for index in range(len(adjacency)) if left >> index & 1)
    b = tuple(index for index in range(len(adjacency)) if right >> index & 1)
    degree_a = tuple((adjacency[vertex] & left).bit_count() for vertex in a)
    degree_b = tuple((adjacency[vertex] & right).bit_count() for vertex in b)
    if sorted(degree_a) != sorted(degree_b):
        return False
    local_a = {vertex: index for index, vertex in enumerate(a)}
    local_b = {vertex: index for index, vertex in enumerate(b)}
    edges_a = tuple(
        frozenset(local_a[neighbour] for neighbour in a if adjacency[vertex] >> neighbour & 1)
        for vertex in a
    )
    edges_b = tuple(
        frozenset(local_b[neighbour] for neighbour in b if adjacency[vertex] >> neighbour & 1)
        for vertex in b
    )
    mapping = [-1] * len(a)
    used: set[int] = set()

    def compatible(source: int, target: int) -> bool:
        if degree_a[source] != degree_b[target]:
            return False
        return all(
            ((prior in edges_a[source]) == (mapping[prior] in edges_b[target]))
            for prior in range(len(a))
            if mapping[prior] >= 0
        )

    def search() -> bool:
        if len(used) == len(a):
            return True
        choices = [source for source in range(len(a)) if mapping[source] < 0]
        source = min(
            choices,
            key=lambda item: sum(
                target not in used and compatible(item, target) for target in range(len(b))
            ),
        )
        for target in range(len(b)):
            if target in used or not compatible(source, target):
                continue
            mapping[source] = target
            used.add(target)
            if search():
                return True
            used.remove(target)
            mapping[source] = -1
        return False

    return search()


def mask_from_json(record: dict[str, int]) -> int:
    return (record["hi"] << 64) | record["lo"]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("q3")
    parser.add_argument("q5")
    parser.add_argument("output")
    args = parser.parse_args()
    q3 = json.loads(Path(args.q3).read_text())
    q5 = json.loads(Path(args.q5).read_text())

    assert q3["field_order"] == 3 and q3["type_index"] == 0
    assert q3["refinement"]["class_counts"] == [49, 49]
    assert q3["gate"]["nimber_conflicts"] == 0
    assert q3["first_merger"] is None
    assert q5["field_order"] == 5 and q5["type_index"] == 0
    assert q5["typed_grammar"]["missing_symbolic_successors"] == 0
    counts = q5["refinement"]["class_counts"]
    assert counts[-1] == counts[-2] == q5["refinement"]["stable_classes"]
    assert q5["gate"]["nimber_conflicts"] == 0
    assert q5["gate"]["genuine_removals"] < q5["gate"]["promotion_threshold"]
    assert q5["gate"]["passed"] is False

    witness = q5["first_nonisomorphic_merger"]
    assert witness is not None
    prior = mask_from_json(witness["prior"])
    current = mask_from_json(witness["current"])
    model = E0.R.Model(5, 0)
    adjacency = tuple(model.adjacency)
    prior_nimber = direct_nimber(prior, adjacency)
    current_nimber = direct_nimber(current, adjacency)
    assert prior_nimber == witness["prior_nimber"]
    assert current_nimber == witness["current_nimber"]
    assert not isomorphic(prior, current, adjacency)

    result = {
        "field_order": 5,
        "gate_passed": False,
        "genuine_removals": q5["gate"]["genuine_removals"],
        "nimber_conflicts": q5["gate"]["nimber_conflicts"],
        "q3_classes": q3["refinement"]["stable_classes"],
        "q5_classes": q5["refinement"]["stable_classes"],
        "witness": {
            "current_nimber": current_nimber,
            "current_vertices": current.bit_count(),
            "isomorphic": False,
            "prior_nimber": prior_nimber,
            "prior_vertices": prior.bit_count(),
        },
    }
    Path(args.output).write_text(json.dumps(result, sort_keys=True, separators=(",", ":")) + "\n")


if __name__ == "__main__":
    main()
