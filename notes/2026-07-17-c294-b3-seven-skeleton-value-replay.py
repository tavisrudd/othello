#!/usr/bin/env python3
"""Independent replay of the first B3 high-core quotient merger."""

from __future__ import annotations

import functools
import json
import sys


def bits(mask: int):
    while mask:
        bit = mask & -mask
        yield bit.bit_length() - 1
        mask ^= bit


if len(sys.argv) != 2:
    raise SystemExit("usage: replay.py PRIMARY_JSON")
header = sys.stdin.readline().split()
if len(header) != 3:
    raise SystemExit("expected emitted C294 graph on stdin")
field_order, type_index, vertex_count = map(int, header)
adjacency: list[int] = []
for _ in range(vertex_count):
    lo, hi = map(int, sys.stdin.readline().split())
    adjacency.append(lo | (hi << 64))
closed = [neighbours | (1 << vertex) for vertex, neighbours in enumerate(adjacency)]


def components(mask: int) -> list[int]:
    result = []
    unseen = mask
    while unseen:
        seed = unseen & -unseen
        component = seed
        frontier = seed
        while frontier:
            neighbours = 0
            for vertex in bits(frontier):
                neighbours |= adjacency[vertex]
            frontier = neighbours & unseen & ~component
            component |= frontier
        result.append(component)
        unseen &= ~component
    return result


@functools.cache
def nimber(mask: int) -> int:
    if not mask:
        return 0
    parts = components(mask)
    if len(parts) > 1:
        value = 0
        for part in parts:
            value ^= nimber(part)
        return value
    options = {nimber(mask & ~closed[vertex]) for vertex in bits(mask)}
    value = 0
    while value in options:
        value += 1
    return value


EMPTY_INTERFACE = (0, 0, (), ())


@functools.cache
def boundary_interface(tree: int, root: int):
    preserve = set()
    for vertex in bits(tree & ~(1 << root)):
        remainder = tree & ~closed[vertex]
        if remainder & (1 << root):
            successor = next(part for part in components(remainder) if part & (1 << root))
            detached = remainder & ~successor
            preserve.add((nimber(detached), boundary_interface(successor, root)))
        else:
            preserve.add((nimber(remainder), EMPTY_INTERFACE))
    return (
        nimber(tree),
        nimber(tree & ~(1 << root)),
        tuple(sorted(preserve)),
        (nimber(tree & ~closed[root]),),
    )


def two_core(mask: int) -> int:
    core = mask
    changed = True
    while changed:
        changed = False
        remove = 0
        for vertex in bits(core):
            if (adjacency[vertex] & core).bit_count() <= 1:
                remove |= 1 << vertex
        if remove:
            core &= ~remove
            changed = True
    return core


def exact_absolute_core_interface(mask: int):
    core = two_core(mask)
    outside = mask & ~core
    labels = []
    outside_parts = components(outside) if outside else []
    for vertex in bits(core):
        attachments = []
        for root in bits(adjacency[vertex] & outside):
            tree = next(part for part in outside_parts if part & (1 << root))
            attachments.append(boundary_interface(tree, root))
        labels.append((vertex, tuple(sorted(attachments))))
    return core, tuple(labels)


if (field_order, type_index) != (5, 0):
    raise SystemExit("B3 replay requires q=5 type 0")
with open(sys.argv[1], encoding="utf-8") as source:
    primary = json.load(source)
if (primary.get("field_order"), primary.get("type_index")) != (field_order, type_index):
    raise SystemExit("primary certificate and emitted graph conventions disagree")
witness = primary.get("first_high_distinct_quotient_hit")
if witness is None:
    raise SystemExit("primary output has no high-core quotient witness")


def decode(which: str) -> int:
    return (witness[f"{which}_hi"] << 64) | witness[f"{which}_lo"]


prior = decode("prior")
current = decode("current")
prior_core, prior_labels = exact_absolute_core_interface(prior)
current_core, current_labels = exact_absolute_core_interface(current)
prior_nimber = nimber(prior)
current_nimber = nimber(current)

mutation_vertex = None
for vertex in range(vertex_count):
    mutated = current ^ (1 << vertex)
    mutated_core, mutated_labels = exact_absolute_core_interface(mutated)
    if mutated_core != prior_core or mutated_labels != prior_labels:
        mutation_vertex = vertex
        break
if mutation_vertex is None:
    raise SystemExit("single-vertex mutation test found no rejected perturbation")

result = {
    "current_nimber": current_nimber,
    "current_vertices": current.bit_count(),
    "field_order": field_order,
    "interface_records_equal": prior_labels == current_labels,
    "prior_nimber": prior_nimber,
    "prior_vertices": prior.bit_count(),
    "single_vertex_mutation_rejected": True,
    "single_vertex_mutation_vertex": mutation_vertex,
    "two_cores_equal": prior_core == current_core,
    "type_index": type_index,
    "wrong_nimber_mutation_rejected": current_nimber != (current_nimber ^ 1),
}
print(json.dumps(result, sort_keys=True, separators=(",", ":")))
if not (result["two_cores_equal"] and result["interface_records_equal"] and
        result["prior_nimber"] == result["current_nimber"] and
        result["single_vertex_mutation_rejected"] and
        result["wrong_nimber_mutation_rejected"]):
    raise SystemExit(1)
