#!/usr/bin/env python3
"""Independent replay of the first exact C294 B3 two-port merger."""

import functools
import json
import sys


def bits(mask):
    while mask:
        low = mask & -mask
        yield low.bit_length() - 1
        mask ^= low


data = list(map(int, sys.stdin.read().split()))
if len(sys.argv) != 2 or len(data) < 4:
    raise SystemExit("usage: ... --emit-graph | replay.py PRIMARY_JSON")
q, type_index, order = data[:3]
cursor = 3
adjacency = []
for _ in range(order):
    lo, hi = data[cursor : cursor + 2]
    cursor += 2
    adjacency.append(lo | (hi << 64))
root_lo, root_hi = data[cursor : cursor + 2]
root = root_lo | (root_hi << 64)
assert root.bit_count() == order - 4

with open(sys.argv[1], encoding="utf-8") as source:
    certificate = json.load(source)
merger = certificate["first_merger"]
if merger["prior"] is None or merger["current"] is None:
    raise SystemExit("primary certificate contains no merger")


def decode_mask(encoded):
    return encoded["lo"] | (encoded["hi"] << 64)


def components(mask):
    result = []
    while mask:
        seed = mask & -mask
        component = seed
        frontier = seed
        while frontier:
            vertex_bit = frontier & -frontier
            frontier ^= vertex_bit
            vertex = vertex_bit.bit_length() - 1
            fresh = adjacency[vertex] & mask & ~component
            component |= fresh
            frontier |= fresh
        result.append(component)
        mask &= ~component
    return result


def two_core(mask):
    degree = {vertex: (adjacency[vertex] & mask).bit_count() for vertex in bits(mask)}
    leaves = [vertex for vertex, value in degree.items() if value == 1]
    core = mask
    while leaves:
        following = []
        for leaf in leaves:
            core &= ~(1 << leaf)
            for neighbour in bits(adjacency[leaf] & core):
                degree[neighbour] -= 1
                if degree[neighbour] == 1:
                    following.append(neighbour)
        leaves = following
    return core


def expanded_piece(occurrence):
    residual = decode_mask(occurrence["residual"])
    component = decode_mask(occurrence["component"])
    core = two_core(residual)
    outside = residual & ~core
    expanded = component
    for part in components(outside):
        if any(adjacency[vertex] & component for vertex in bits(part)):
            expanded |= part
    first, second = occurrence["separators"]
    assert first != second
    assert component & ((1 << first) | (1 << second)) == 0
    assert adjacency[first] & component and adjacency[second] & component
    return expanded, adjacency[first] & expanded, adjacency[second] & expanded


@functools.cache
def closed_nimber(mask):
    if not mask:
        return 0
    parts = components(mask)
    if len(parts) > 1:
        value = 0
        for part in parts:
            value ^= closed_nimber(part)
        return value
    options = {
        closed_nimber(mask & ~(adjacency[vertex] | (1 << vertex)))
        for vertex in bits(mask)
    }
    value = 0
    while value in options:
        value += 1
    return value


node_ids = {}


def intern(record):
    if record not in node_ids:
        node_ids[record] = len(node_ids)
    return node_ids[record]


@functools.cache
def interface(mask, first, second, arity):
    first &= mask
    second = second & mask if arity == 2 else 0

    def successor(remainder, next_first, next_second, next_arity):
        live_incidence = next_first | (next_second if next_arity == 2 else 0)
        live = 0
        offset = 0
        for part in components(remainder):
            if part & live_incidence:
                live |= part
            else:
                offset ^= closed_nimber(part)
        return offset, interface(
            live, next_first & live, next_second & live, next_arity
        )

    external = []
    all_ports = (1 << arity) - 1
    for deleted in range(1, all_ports + 1):
        for selected in [-1] + [port for port in range(arity) if deleted & (1 << port)]:
            remainder = mask
            if selected == 0:
                remainder &= ~first
            elif selected == 1:
                remainder &= ~second
            survivors = arity - deleted.bit_count()
            if survivors == 0:
                external.append((closed_nimber(remainder),))
            elif arity == 1 or deleted & 1:
                external.append(successor(remainder, second, 0, 1))
            else:
                external.append(successor(remainder, first, 0, 1))

    move_sets = [set() for _ in range(1 << arity)]
    for vertex in bits(mask):
        killed = (1 if first & (1 << vertex) else 0)
        if arity == 2 and second & (1 << vertex):
            killed |= 2
        remainder = mask & ~(adjacency[vertex] | (1 << vertex))
        if killed == all_ports:
            move_sets[killed].add((closed_nimber(remainder),))
        elif arity == 1:
            move_sets[killed].add(successor(remainder, first, 0, 1))
        elif killed & 1:
            move_sets[killed].add(successor(remainder, second, 0, 1))
        elif killed & 2:
            move_sets[killed].add(successor(remainder, first, 0, 1))
        else:
            move_sets[killed].add(successor(remainder, first, second, 2))
    record = (arity, tuple(external), tuple(tuple(sorted(group)) for group in move_sets))
    return intern(record)


def unordered_interface(piece):
    mask, first, second = piece
    return min(interface(mask, first, second, 2), interface(mask, second, first, 2))


def refined_colors(piece, swap=False):
    mask, first, second = piece
    vertices = list(bits(mask))
    signatures = []
    for vertex in vertices:
        port_bits = (1 if first & (1 << vertex) else 0) | (
            2 if second & (1 << vertex) else 0
        )
        if swap:
            port_bits = ((port_bits & 1) << 1) | ((port_bits & 2) >> 1)
        signatures.append(((adjacency[vertex] & mask).bit_count(), port_bits))
    colors = {signature: index for index, signature in enumerate(sorted(set(signatures)))}
    assigned = [colors[signature] for signature in signatures]
    while True:
        signatures = [
            (assigned[index], tuple(sorted(
                assigned[vertices.index(neighbour)]
                for neighbour in bits(adjacency[vertex] & mask)
            )))
            for index, vertex in enumerate(vertices)
        ]
        colors = {signature: index for index, signature in enumerate(sorted(set(signatures)))}
        following = [colors[signature] for signature in signatures]
        if following == assigned:
            return vertices, assigned
        assigned = following


def isomorphic(first_piece, second_piece, swap=False):
    first_vertices, first_colors = refined_colors(first_piece)
    second_vertices, second_colors = refined_colors(second_piece, swap=swap)
    if len(first_vertices) != len(second_vertices):
        return False
    if sorted(first_colors) != sorted(second_colors):
        return False
    candidates = {
        vertex: [
            target for target, color in zip(second_vertices, second_colors)
            if color == first_colors[index]
        ]
        for index, vertex in enumerate(first_vertices)
    }
    mapping = {}
    used = set()

    def search():
        if len(mapping) == len(first_vertices):
            return True
        vertex = min(
            (item for item in first_vertices if item not in mapping),
            key=lambda item: sum(target not in used for target in candidates[item]),
        )
        for target in candidates[vertex]:
            if target in used:
                continue
            if any(
                bool(adjacency[vertex] & (1 << other)) !=
                bool(adjacency[target] & (1 << image))
                for other, image in mapping.items()
            ):
                continue
            mapping[vertex] = target
            used.add(target)
            if search():
                return True
            used.remove(target)
            del mapping[vertex]
        return False

    return search()


prior = expanded_piece(merger["prior"])
current = expanded_piece(merger["current"])
prior_id = unordered_interface(prior)
current_id = unordered_interface(current)
result = {
    "current_interface_id": current_id,
    "current_nimber": closed_nimber(current[0]),
    "current_vertices": current[0].bit_count(),
    "field_order": q,
    "interface_equal": prior_id == current_id,
    "interface_nodes": len(node_ids),
    "isomorphic_fixed_ports": isomorphic(prior, current),
    "isomorphic_swapped_ports": isomorphic(prior, current, swap=True),
    "prior_interface_id": prior_id,
    "prior_nimber": closed_nimber(prior[0]),
    "prior_vertices": prior[0].bit_count(),
    "type_index": type_index,
}
json.dump(result, sys.stdout, sort_keys=True, separators=(",", ":"))
sys.stdout.write("\n")
