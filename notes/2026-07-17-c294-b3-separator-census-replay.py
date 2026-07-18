#!/usr/bin/env python3
"""Independent replay of nontrivial cross-core separator-piece witnesses."""

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
    raise SystemExit("usage: separator-census-replay.py PRIMARY_JSON")
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
    labels = {}
    for vertex in bits(core):
        attachments = []
        for root in bits(adjacency[vertex] & outside):
            tree = next(part for part in outside_parts if part & (1 << root))
            attachments.append(boundary_interface(tree, root))
        labels[vertex] = tuple(sorted(attachments))
    return core, labels


def decode_mask(record) -> int:
    return record["lo"] | (record["hi"] << 64)


def piece_record(occurrence):
    residual = decode_mask(occurrence["residual"])
    component = decode_mask(occurrence["component"])
    separators = tuple(occurrence["separators"])
    core, core_labels = labelled_core(residual)
    removed = 0
    for separator in separators:
        if not (core & (1 << separator)):
            raise SystemExit("recorded separator is outside the reconstructed two-core")
        removed |= 1 << separator
    parts = components(core & ~removed)
    if len(parts) < 2 or component not in parts:
        raise SystemExit("recorded component is not a side of the stated separator")
    if any(not (adjacency[separator] & component) for separator in separators):
        raise SystemExit("recorded genuine boundary port does not touch its component")

    internal = tuple(bits(component))
    ports = tuple(vertex_count + index for index in range(len(separators)))
    neighbours = {vertex: set(bits(adjacency[vertex] & component)) for vertex in internal}
    labels = {vertex: (0, core_labels[vertex]) for vertex in internal}
    for port, separator in zip(ports, separators, strict=True):
        neighbours[port] = set()
        labels[port] = (1,)
        for vertex in internal:
            if adjacency[vertex] & (1 << separator):
                neighbours[vertex].add(port)
                neighbours[port].add(vertex)
    return neighbours, labels, len(internal), len(ports)


def joint_colors(first_neighbours, first_labels, second_neighbours, second_labels):
    signatures = {
        (0, vertex): (len(first_neighbours[vertex]), first_labels[vertex])
        for vertex in first_neighbours
    }
    signatures.update({
        (1, vertex): (len(second_neighbours[vertex]), second_labels[vertex])
        for vertex in second_neighbours
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


def explicit_isomorphism(first_neighbours, first_labels, second_neighbours, second_labels):
    if len(first_neighbours) != len(second_neighbours):
        return None
    colors = joint_colors(first_neighbours, first_labels, second_neighbours, second_labels)
    if sorted(colors[(0, vertex)] for vertex in first_neighbours) != sorted(
        colors[(1, vertex)] for vertex in second_neighbours
    ):
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


def verify_witness(primary, name):
    witness = primary[name]
    if witness is None or witness["component_vertices"] < 8:
        raise SystemExit(f"{name} is absent or below the nontrivial size threshold")
    prior = piece_record(witness["prior"])
    current = piece_record(witness["current"])
    mapping = explicit_isomorphism(prior[0], prior[1], current[0], current[1])
    if mapping is None:
        raise SystemExit(f"independent boundary-piece isomorphism rejected {name}")
    valid = all(
        prior[1][vertex] == current[1][other] and
        {mapping[neighbour] for neighbour in prior[0][vertex]} == current[0][other]
        for vertex, other in mapping.items()
    )
    mutated_labels = dict(current[1])
    internal = next(vertex for vertex, label in mutated_labels.items() if label[0] == 0)
    mutated_labels[internal] = (2, mutated_labels[internal])
    mutation_rejected = explicit_isomorphism(
        prior[0], prior[1], current[0], mutated_labels
    ) is None
    return {
        "adjacency_and_labels_preserved": valid,
        "component_vertices": prior[2],
        "mapping_size": len(mapping),
        "port_count": prior[3],
        "single_label_mutation_rejected": mutation_rejected,
    }


if (field_order, type_index) != (5, 0):
    raise SystemExit("separator-census replay requires q=5 type 0")
with open(sys.argv[1], encoding="utf-8") as source:
    primary = json.load(source)
expected = {
    "connected_states": 100000,
    "decompositions": 1946240,
    "field_order": 5,
    "high_absolute_classes": 11031,
    "high_isomorphic_duplicates": 943,
    "high_isomorphism_classes": 10088,
    "limit_vertices": 24,
    "quotient_cache_hits": 1708125,
    "quotient_classes": 84964,
    "stopped_at_limit": True,
    "type_index": 0,
}
if any(primary.get(key) != value for key, value in expected.items()):
    raise SystemExit("primary traversal does not match the pinned fixed-prefix invariants")

result = {
    "field_order": field_order,
    "one_port_min_8": verify_witness(primary, "one_port_min_8_cross_core_witness"),
    "traversal_invariants_match": True,
    "two_port_min_8": verify_witness(primary, "two_port_min_8_cross_core_witness"),
    "type_index": type_index,
}
print(json.dumps(result, sort_keys=True, separators=(",", ":")))
if not all(
    record["adjacency_and_labels_preserved"] and record["single_label_mutation_rejected"]
    for record in (result["one_port_min_8"], result["two_port_min_8"])
):
    raise SystemExit(1)
