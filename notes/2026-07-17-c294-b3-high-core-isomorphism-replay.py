#!/usr/bin/env python3
"""Independent replay of the first labelled-high-two-core isomorphism merger."""

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
    while True:
        remove = 0
        for vertex in bits(core):
            if (adjacency[vertex] & core).bit_count() <= 1:
                remove |= 1 << vertex
        if not remove:
            return core
        core &= ~remove


def labelled_core(mask: int):
    core = two_core(mask)
    outside = mask & ~core
    outside_parts = components(outside) if outside else []
    neighbours = {}
    labels = {}
    for vertex in bits(core):
        neighbours[vertex] = frozenset(bits(adjacency[vertex] & core))
        attachments = []
        for root in bits(adjacency[vertex] & outside):
            tree = next(part for part in outside_parts if part & (1 << root))
            attachments.append(boundary_interface(tree, root))
        labels[vertex] = tuple(sorted(attachments))
    return core, neighbours, labels


def joint_colors(first_neighbours, first_labels, second_neighbours, second_labels):
    first_vertices = tuple(first_neighbours)
    second_vertices = tuple(second_neighbours)
    signatures = {
        (0, vertex): (len(first_neighbours[vertex]), first_labels[vertex])
        for vertex in first_vertices
    }
    signatures.update({
        (1, vertex): (len(second_neighbours[vertex]), second_labels[vertex])
        for vertex in second_vertices
    })

    def normalize(records):
        ordered = {record: index for index, record in enumerate(sorted(set(records.values())))}
        return {vertex: ordered[record] for vertex, record in records.items()}

    colors = normalize(signatures)
    while True:
        records = {}
        for side, neighbours in ((0, first_neighbours), (1, second_neighbours)):
            for vertex in neighbours:
                records[(side, vertex)] = (
                    colors[(side, vertex)],
                    tuple(sorted(colors[(side, other)] for other in neighbours[vertex])),
                )
        refined = normalize(records)
        if refined == colors:
            return colors
        colors = refined


def explicit_isomorphism(first, second):
    _, first_neighbours, first_labels = first
    _, second_neighbours, second_labels = second
    if len(first_neighbours) != len(second_neighbours):
        return None
    colors = joint_colors(
        first_neighbours, first_labels, second_neighbours, second_labels
    )
    first_histogram = sorted(colors[(0, vertex)] for vertex in first_neighbours)
    second_histogram = sorted(colors[(1, vertex)] for vertex in second_neighbours)
    if first_histogram != second_histogram:
        return None
    candidates = {
        vertex: {
            other for other in second_neighbours
            if colors[(0, vertex)] == colors[(1, other)]
        }
        for vertex in first_neighbours
    }

    def search(mapping, used):
        if len(mapping) == len(first_neighbours):
            return dict(mapping)
        choices = []
        for vertex in first_neighbours:
            if vertex in mapping:
                continue
            possible = []
            for other in candidates[vertex] - used:
                if all(
                    ((mapped_vertex in first_neighbours[vertex]) ==
                     (mapped_other in second_neighbours[other]))
                    for mapped_vertex, mapped_other in mapping.items()
                ):
                    possible.append(other)
            if not possible:
                return None
            choices.append((len(possible), vertex, sorted(possible)))
        _, vertex, possible = min(choices)
        for other in possible:
            mapping[vertex] = other
            result = search(mapping, used | {other})
            if result is not None:
                return result
            del mapping[vertex]
        return None

    return search({}, set())


if (field_order, type_index) != (5, 0):
    raise SystemExit("B3 replay requires q=5 type 0")
with open(sys.argv[1], encoding="utf-8") as source:
    primary = json.load(source)
if (primary.get("field_order"), primary.get("type_index")) != (field_order, type_index):
    raise SystemExit("primary certificate and emitted graph conventions disagree")
witness = primary.get("first_high_isomorphism_merger")
if witness is None:
    raise SystemExit("primary output has no high-core isomorphism witness")


def decode(which: str) -> int:
    return (witness[f"{which}_hi"] << 64) | witness[f"{which}_lo"]


prior = decode("prior")
current = decode("current")
prior_record = labelled_core(prior)
current_record = labelled_core(current)
mapping = explicit_isomorphism(prior_record, current_record)
if mapping is None:
    raise SystemExit("independent labelled-core isomorphism search rejected witness")

mapping_valid = all(
    prior_record[2][vertex] == current_record[2][other] and
    {mapping[neighbour] for neighbour in prior_record[1][vertex]} ==
        set(current_record[1][other])
    for vertex, other in mapping.items()
)
prior_nimber = nimber(prior)
current_nimber = nimber(current)

mutation_vertex = None
for vertex in range(vertex_count):
    mutated = current ^ (1 << vertex)
    if explicit_isomorphism(prior_record, labelled_core(mutated)) is None:
        mutation_vertex = vertex
        break
if mutation_vertex is None:
    raise SystemExit("single-vertex mutation test found no rejected perturbation")

result = {
    "adjacency_preserved": mapping_valid,
    "current_core_vertices": current_record[0].bit_count(),
    "current_nimber": current_nimber,
    "current_vertices": current.bit_count(),
    "field_order": field_order,
    "labelled_core_isomorphic": True,
    "labels_preserved": mapping_valid,
    "mapping_size": len(mapping),
    "prior_core_vertices": prior_record[0].bit_count(),
    "prior_nimber": prior_nimber,
    "prior_vertices": prior.bit_count(),
    "single_vertex_mutation_rejected": True,
    "single_vertex_mutation_vertex": mutation_vertex,
    "type_index": type_index,
    "wrong_nimber_mutation_rejected": current_nimber != (current_nimber ^ 1),
}
print(json.dumps(result, sort_keys=True, separators=(",", ":")))
if not (
    result["adjacency_preserved"] and result["labels_preserved"] and
    result["prior_nimber"] == result["current_nimber"] and
    result["single_vertex_mutation_rejected"] and
    result["wrong_nimber_mutation_rejected"]
):
    raise SystemExit(1)
