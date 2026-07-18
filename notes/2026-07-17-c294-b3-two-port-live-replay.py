#!/usr/bin/env python3
"""Independent replay of the first C294 B3 live two-port cache hit."""

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

with open(sys.argv[1], encoding="utf-8") as source:
    certificate = json.load(source)
hit = certificate["first_full_quotient_hit"]
if hit is None:
    raise SystemExit("primary certificate contains no full quotient hit")


def decode_mask(encoded):
    return encoded["lo"] | (encoded["hi"] << 64)


def decode_candidate(encoded):
    return {
        "piece": decode_mask(encoded["piece"]),
        "residual": decode_mask(encoded["residual"]),
        "first": encoded["first_port"],
        "second": encoded["second_port"],
    }


prior = decode_candidate(hit["prior"])
current = decode_candidate(hit["current"])


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
        return offset, interface(live, next_first & live, next_second & live, next_arity)

    external = []
    all_ports = (1 << arity) - 1
    for deleted in range(1, all_ports + 1):
        selected_ports = [port for port in range(arity) if deleted & (1 << port)]
        for selected in [-1] + selected_ports:
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
        killed = 1 if first & (1 << vertex) else 0
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
    return arity, tuple(external), tuple(tuple(sorted(group)) for group in move_sets)


def interface_records(candidate):
    piece = candidate["piece"]
    first = adjacency[candidate["first"]] & piece
    second = adjacency[candidate["second"]] & piece
    return (
        interface(piece, first, second, 2),
        interface(piece, second, first, 2),
    )


def refined_colors(mask, first_port=-1, second_port=-1):
    vertices = list(bits(mask))
    signatures = []
    for vertex in vertices:
        label = 1 if vertex == first_port else 2 if vertex == second_port else 0
        signatures.append(((adjacency[vertex] & mask).bit_count(), label))
    color_ids = {value: index for index, value in enumerate(sorted(set(signatures)))}
    colors = [color_ids[value] for value in signatures]
    index = {vertex: offset for offset, vertex in enumerate(vertices)}
    while True:
        signatures = [
            (colors[offset], tuple(sorted(colors[index[neighbour]] for neighbour in
             bits(adjacency[vertex] & mask))))
            for offset, vertex in enumerate(vertices)
        ]
        color_ids = {value: index for index, value in enumerate(sorted(set(signatures)))}
        following = [color_ids[value] for value in signatures]
        if following == colors:
            return vertices, colors
        colors = following


def isomorphic(first_mask, second_mask, first_ports=(-1, -1), second_ports=(-1, -1)):
    first_vertices, first_colors = refined_colors(first_mask, *first_ports)
    second_vertices, second_colors = refined_colors(second_mask, *second_ports)
    if len(first_vertices) != len(second_vertices) or sorted(first_colors) != sorted(second_colors):
        return False
    candidates = {
        vertex: [
            target for target, color in zip(second_vertices, second_colors)
            if color == first_colors[offset]
        ]
        for offset, vertex in enumerate(first_vertices)
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


prior_context = prior["residual"] & ~prior["piece"]
current_context = current["residual"] & ~current["piece"]
prior_records = interface_records(prior)
current_records = interface_records(current)
result = {
    "context_isomorphic_fixed_ports": isomorphic(
        prior_context, current_context,
        (prior["first"], prior["second"]),
        (current["first"], current["second"]),
    ),
    "context_isomorphic_swapped_ports": isomorphic(
        prior_context, current_context,
        (prior["first"], prior["second"]),
        (current["second"], current["first"]),
    ),
    "field_order": q,
    "interface_equal_fixed_ports": prior_records[0] == current_records[0],
    "interface_equal_swapped_ports": prior_records[0] == current_records[1],
    "piece_masks_equal": prior["piece"] == current["piece"],
    "piece_nimber": closed_nimber(prior["piece"]),
    "piece_vertices": prior["piece"].bit_count(),
    "residual_isomorphic": isomorphic(prior["residual"], current["residual"]),
    "type_index": type_index,
}
json.dump(result, sys.stdout, sort_keys=True, separators=(",", ":"))
sys.stdout.write("\n")
