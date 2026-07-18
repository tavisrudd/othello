#!/usr/bin/env python3
"""Independent direct replay for the C294 B2 mandatory q=5 witness."""

from __future__ import annotations

import functools
import json
import sys


def bits(mask: int):
    while mask:
        bit = mask & -mask
        yield bit.bit_length() - 1
        mask ^= bit


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


def boundary_label_multiset(mask: int):
    core = two_core(mask)
    outside = mask & ~core
    labels = []
    for vertex in bits(core):
        attachments = []
        for root in bits(adjacency[vertex] & outside):
            tree = next(part for part in components(outside) if part & (1 << root))
            attachments.append(boundary_interface(tree, root))
        labels.append(((adjacency[vertex] & core).bit_count(), tuple(sorted(attachments))))
    return tuple(sorted(labels))


if (field_order, type_index) != (5, 0):
    raise SystemExit("independent witness replay requires q=5 type 0")

prior = (2256223630000138 << 64) | 3477912251120222208
current = (4423952646187 << 64) | 3482415833567723520
prior_labels = boundary_label_multiset(prior)
current_labels = boundary_label_multiset(current)
print(
    json.dumps(
        {
            "boundary_label_multisets_equal": prior_labels == current_labels,
            "current_nimber": nimber(current),
            "current_vertices": current.bit_count(),
            "field_order": field_order,
            "prior_nimber": nimber(prior),
            "prior_vertices": prior.bit_count(),
            "type_index": type_index,
        },
        sort_keys=True,
        separators=(",", ":"),
    )
)
