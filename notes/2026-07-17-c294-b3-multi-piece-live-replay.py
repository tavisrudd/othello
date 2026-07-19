#!/usr/bin/env python3
"""Independent replay of the first full C294 two-port cache collision."""

import json
import os
import subprocess
import sys
import tempfile


def bits(mask):
    while mask:
        low = mask & -mask
        yield low.bit_length() - 1
        mask ^= low


def decode_mask(encoded):
    return encoded["lo"] | (encoded["hi"] << 64)


def refined_colors(mask, adjacency, labels):
    vertices = list(bits(mask))
    signatures = [
        ((adjacency[vertex] & mask).bit_count(), labels.get(vertex, 0))
        for vertex in vertices
    ]
    palette = {item: index for index, item in enumerate(sorted(set(signatures)))}
    colors = [palette[item] for item in signatures]
    local = {vertex: index for index, vertex in enumerate(vertices)}
    while True:
        signatures = [
            (colors[index], tuple(sorted(
                colors[local[neighbour]]
                for neighbour in bits(adjacency[vertex] & mask)
            )))
            for index, vertex in enumerate(vertices)
        ]
        palette = {item: index for index, item in enumerate(sorted(set(signatures)))}
        following = [palette[item] for item in signatures]
        if following == colors:
            return vertices, colors
        colors = following


def isomorphic(first_mask, second_mask, adjacency, first_labels=None, second_labels=None):
    first_labels = first_labels or {}
    second_labels = second_labels or {}
    first_vertices, first_colors = refined_colors(first_mask, adjacency, first_labels)
    second_vertices, second_colors = refined_colors(second_mask, adjacency, second_labels)
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


def adapted_occurrence(entry):
    if len(entry["pieces"]) != 1:
        raise SystemExit("first full collision is not a one-piece witness")
    piece = entry["pieces"][0]
    return {
        "component": piece["piece"],
        "residual": entry["residual"],
        "separators": [piece["first_port"], piece["second_port"]],
    }


graph_text = sys.stdin.read()
data = list(map(int, graph_text.split()))
if len(sys.argv) not in (2, 3) or len(data) < 4:
    raise SystemExit("usage: ... --emit-graph | replay.py PRIMARY_JSON [OUTPUT]")
field_order, type_index, order = data[:3]
cursor = 3
adjacency = []
for _ in range(order):
    lo, hi = data[cursor : cursor + 2]
    cursor += 2
    adjacency.append(lo | (hi << 64))

with open(sys.argv[1], encoding="utf-8") as source:
    certificate = json.load(source)
collision = certificate["first_cross_exact_full_hit"]
if collision is None:
    raise SystemExit("primary certificate contains no full collision")
prior = collision["prior"]
current = collision["current"]
prior_occurrence = adapted_occurrence(prior)
current_occurrence = adapted_occurrence(current)

adapter = {"first_merger": {
    "prior": prior_occurrence,
    "current": current_occurrence,
}}
replay_path = os.path.join(
    os.path.dirname(__file__),
    "2026-07-17-c294-b3-two-port-transition-replay.py",
)
with tempfile.NamedTemporaryFile("w", encoding="utf-8") as temporary:
    json.dump(adapter, temporary)
    temporary.flush()
    process = subprocess.run(
        [sys.executable, replay_path, temporary.name],
        input=graph_text,
        text=True,
        capture_output=True,
        check=True,
    )
piece_check = json.loads(process.stdout)

prior_mask = decode_mask(prior["residual"])
current_mask = decode_mask(current["residual"])
prior_piece = decode_mask(prior["pieces"][0]["piece"])
current_piece = decode_mask(current["pieces"][0]["piece"])
prior_context = prior_mask & ~prior_piece
current_context = current_mask & ~current_piece
prior_ports = (
    prior["pieces"][0]["first_port"], prior["pieces"][0]["second_port"]
)
current_ports = (
    current["pieces"][0]["first_port"], current["pieces"][0]["second_port"]
)
fixed_context = isomorphic(
    prior_context,
    current_context,
    adjacency,
    {prior_ports[0]: 1, prior_ports[1]: 2},
    {current_ports[0]: 1, current_ports[1]: 2},
)
swapped_context = isomorphic(
    prior_context,
    current_context,
    adjacency,
    {prior_ports[0]: 1, prior_ports[1]: 2},
    {current_ports[0]: 2, current_ports[1]: 1},
)

result = {
    "context_isomorphic_fixed_ports": fixed_context,
    "context_isomorphic_swapped_ports": swapped_context,
    "field_order": field_order,
    "full_residuals_isomorphic": isomorphic(
        prior_mask, current_mask, adjacency
    ),
    "piece_interface_equal": piece_check["interface_equal"],
    "piece_isomorphic_fixed_ports": piece_check["isomorphic_fixed_ports"],
    "piece_isomorphic_swapped_ports": piece_check["isomorphic_swapped_ports"],
    "piece_nimbers": [piece_check["prior_nimber"], piece_check["current_nimber"]],
    "piece_vertices": [piece_check["prior_vertices"], piece_check["current_vertices"]],
    "type_index": type_index,
}
output = sys.stdout
if len(sys.argv) == 3:
    output = open(sys.argv[2], "w", encoding="utf-8")
json.dump(result, output, sort_keys=True, separators=(",", ":"))
output.write("\n")
if output is not sys.stdout:
    output.close()
