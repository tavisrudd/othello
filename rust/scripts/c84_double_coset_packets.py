#!/usr/bin/env python3
"""Test rooted-S4/fourth-centre double-coset response packets for C84."""

from __future__ import annotations

import argparse
import gc
import itertools
import json
from collections import Counter, deque
from functools import cache
from pathlib import Path

from c84_adaptive_core import solve as reference_solve
from c84_pairing_locus import generated_group_cap, s4_representatives
from c84_forced_reply_algebra import parameter_json
from three_centre_probe import (
    centres,
    conic_point,
    determinant,
    projective_line,
    residual_graph,
    sigma,
)


def orbit(group: tuple[tuple[int, ...], ...], seeds: set[int]) -> set[int]:
    return {element[seed] for element in group for seed in seeds}


def double_coset_layers(
    group: tuple[tuple[int, ...], ...], fourth: tuple[int, ...], source: int
) -> dict[int, int]:
    """Minimum number of fourth-involution uses in an H/fourth alternating word."""
    reached = orbit(group, {source})
    layers = {vertex: 0 for vertex in reached}
    layer = 0
    while len(reached) < len(fourth):
        layer += 1
        frontier = orbit(group, {fourth[vertex] for vertex in reached}) - reached
        if not frontier:
            break
        for vertex in frontier:
            layers[vertex] = layer
        reached |= frontier
    return layers


def analyse(adjacency: tuple[int, ...], full_indices: tuple[int, ...], group, fourth):
    n = len(adjacency)
    closed = tuple(mask | (1 << vertex) for vertex, mask in enumerate(adjacency))

    def components(mask: int) -> list[int]:
        out = []
        unseen = mask
        while unseen:
            frontier = unseen & -unseen
            component = 0
            while frontier:
                component |= frontier
                unseen &= ~frontier
                neighbours = 0
                bits = frontier
                while bits:
                    bit = bits & -bits
                    neighbours |= adjacency[bit.bit_length() - 1]
                    bits ^= bit
                frontier = neighbours & unseen
            out.append(component)
        return out

    @cache
    def grundy(mask: int) -> int:
        pieces = components(mask)
        if not pieces:
            return 0
        if len(pieces) > 1:
            value = 0
            for piece in pieces:
                value ^= grundy(piece)
            return value
        options = set()
        bits = mask
        while bits:
            bit = bits & -bits
            vertex = bit.bit_length() - 1
            options.add(grundy(mask & ~closed[vertex]))
            bits ^= bit
        value = 0
        while value in options:
            value += 1
        return value

    full = (1 << n) - 1
    value = grundy(full)
    first_rows = []
    if value == 0:
        for first in range(n):
            follower = full & ~closed[first]
            winning = set()
            bits = follower
            while bits:
                bit = bits & -bits
                reply = bit.bit_length() - 1
                if grundy(follower & ~closed[reply]) == 0:
                    winning.add(reply)
                bits ^= bit
            assert winning

            layers = double_coset_layers(group, fourth, full_indices[first])
            packets: dict[int, list[int]] = {}
            bits = follower
            while bits:
                bit = bits & -bits
                reply = bit.bit_length() - 1
                layer = layers.get(full_indices[reply])
                if layer is not None:
                    packets.setdefault(layer, []).append(reply)
                bits ^= bit
            packet_rows = []
            for layer, replies in sorted(packets.items()):
                wins = sum(reply in winning for reply in replies)
                packet_rows.append({
                    "layer": layer,
                    "legal": len(replies),
                    "pure_winning": wins == len(replies),
                    "winning": wins,
                })
            winning_layers = [
                layer for layer, replies in packets.items()
                if any(reply in winning for reply in replies)
            ]
            assert winning_layers
            row = {
                "has_pure_winning_packet": any(
                    packet["pure_winning"] for packet in packet_rows
                ),
                "packets": packet_rows,
                "winning_replies": len(winning),
            }
            if len(winning) == 1:
                reply = next(iter(winning))
                reply_layer = layers[full_indices[reply]]
                packet = next(
                    packet for packet in packet_rows if packet["layer"] == reply_layer
                )
                row["forcing"] = {
                    "first": first,
                    "packet_legal": packet["legal"],
                    "packet_winning": packet["winning"],
                    "reply": reply,
                    "reply_layer": reply_layer,
                }
            first_rows.append(row)
    return value, first_rows, grundy.cache_info().currsize


def probe(q: int, label: str) -> dict[str, object]:
    parameters = projective_line(q)
    parameter_index = {parameter: i for i, parameter in enumerate(parameters)}
    conic = tuple(conic_point(t, q) for t in parameters)
    points = centres(q)
    permutations = {
        point: tuple(parameter_index[sigma(point, t, q)] for t in parameters)
        for point in points
    }
    representatives, subgroup_points = s4_representatives(q, points, permutations)
    selected = representatives[label]
    group = generated_group_cap(tuple(permutations[point] for point in selected), 24)
    assert group is not None and len(group) == 24

    p_roots = 0
    first_moves = 0
    pure_covered = 0
    fully_pure_covered_roots = 0
    zero_pure_covered_roots = 0
    root_pure_coverage: Counter[str] = Counter()
    forcing_records = []
    layer_histogram: Counter[int] = Counter()
    packet_size_histogram: Counter[int] = Counter()
    roots = 0
    for candidate in points:
        if candidate in selected or candidate in subgroup_points:
            continue
        if any(
            determinant((a, b, candidate), q) == 0
            for a, b in itertools.combinations(selected, 2)
        ):
            continue
        roots += 1
        centres4 = (*selected, candidate)
        dead, adjacency, _ = residual_graph(centres4, parameters, conic, q)
        full_indices = tuple(i for i in range(len(parameters)) if i not in dead)
        value, rows, _ = analyse(
            adjacency, full_indices, group, permutations[candidate]
        )
        assert value == reference_solve(adjacency)["grundy"]
        if value != 0:
            gc.collect()
            continue
        p_roots += 1
        first_moves += len(rows)
        root_covered = sum(row["has_pure_winning_packet"] for row in rows)
        pure_covered += root_covered
        fully_pure_covered_roots += root_covered == len(rows)
        zero_pure_covered_roots += root_covered == 0
        root_pure_coverage[f"{root_covered}/{len(rows)}"] += 1
        for row in rows:
            if "forcing" not in row:
                continue
            forcing = row["forcing"]
            first = forcing.pop("first")
            reply = forcing.pop("reply")
            layer_histogram[forcing["reply_layer"]] += 1
            packet_size_histogram[forcing["packet_legal"]] += 1
            forcing_records.append({
                "candidate": list(candidate),
                "first": parameter_json(parameters[full_indices[first]]),
                **forcing,
                "reply": parameter_json(parameters[full_indices[reply]]),
            })
        gc.collect()

    return {
        "class": label,
        "first_moves_at_p_roots": first_moves,
        "fully_pure_packet_covered_roots": fully_pure_covered_roots,
        "forcing_pairs": len(forcing_records),
        "forcing_records": forcing_records,
        "p_roots": p_roots,
        "pure_packet_covered_first_moves": pure_covered,
        "q": q,
        "roots": roots,
        "selected": [list(point) for point in selected],
        "summary": {
            "forcing_packet_size_histogram": dict(sorted(packet_size_histogram.items())),
            "forcing_reply_layer_histogram": dict(sorted(layer_histogram.items())),
            "root_pure_packet_coverage_histogram": dict(sorted(
                root_pure_coverage.items()
            )),
            "singleton_forcing_packets": packet_size_histogram[1],
        },
        "zero_pure_packet_covered_roots": zero_pure_covered_roots,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("q", nargs="+", type=int)
    parser.add_argument("--class", dest="label", choices=tuple("ABCD"), default="D")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = {
        "cases": [probe(q, args.label) for q in args.q],
        "schema": "c84-double-coset-packets-v1",
    }
    if args.check:
        tracked = Path(__file__).resolve().parents[2] / "notes" / (
            "2026-07-17-c84-double-coset-packets.json"
        )
        if json.loads(tracked.read_text()) != json.loads(json.dumps(result, sort_keys=True)):
            raise SystemExit("tracked double-coset JSON differs from regeneration")
        print(f"OK: {len(result['cases'])} fields; double-coset JSON matches")
    else:
        print(json.dumps(result, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
