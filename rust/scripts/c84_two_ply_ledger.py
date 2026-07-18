#!/usr/bin/env python3
"""Audit shared conic measures and a naive ledger proxy on C84 forced reply rounds."""

from __future__ import annotations

import argparse
import gc
import itertools
import json
from collections import Counter
from functools import cache
from pathlib import Path

from c84_adaptive_core import solve as reference_solve
from c84_forced_reply_algebra import parameter_json
from c84_pairing_locus import s4_representatives
from three_centre_probe import (
    centres,
    conic_point,
    determinant,
    projective_line,
    residual_graph,
    sigma,
)


def component_sizes(adjacency: tuple[int, ...], mask: int) -> list[int]:
    sizes = []
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
        sizes.append(component.bit_count())
    return sorted(sizes, reverse=True)


def edge_count(adjacency: tuple[int, ...], mask: int) -> int:
    return sum((adjacency[v] & mask).bit_count() for v in range(len(adjacency))) // 2


def zone_v(selected, offconic_points, q: int) -> int:
    selected_set = set(selected)
    pairs = tuple(itertools.combinations(selected, 2))
    return sum(
        point not in selected_set
        and all(determinant((a, b, point), q) != 0 for a, b in pairs)
        for point in offconic_points
    )


def measures(adjacency, mask: int, selected, offconic_points, q: int) -> dict[str, object]:
    components = component_sizes(adjacency, mask)
    zone = zone_v(selected, offconic_points, q)
    k = len(selected)
    floor = (q - k) * max(0, q - k - k * (k - 1) // 2 - 1)
    reservoir_proxy = zone - floor
    intruders = sum(point in offconic_points for point in selected)
    psi_proxy = reservoir_proxy + 6 * len(components) - 4 * intruders
    return {
        "components": len(components),
        "edges": edge_count(adjacency, mask),
        "largest_component": components[0] if components else 0,
        "live": mask.bit_count(),
        "psi_proxy": psi_proxy,
        "reservoir_proxy": reservoir_proxy,
        "zone_v": zone,
    }


def analyse_root(adjacency, full_indices, parameters, conic, selected, offconic_points, q):
    n = len(adjacency)
    closed = tuple(mask | (1 << vertex) for vertex, mask in enumerate(adjacency))

    @cache
    def grundy(mask: int) -> int:
        pieces = []
        unseen = mask
        while unseen:
            frontier = unseen & -unseen
            piece = 0
            while frontier:
                piece |= frontier
                unseen &= ~frontier
                neighbours = 0
                bits = frontier
                while bits:
                    bit = bits & -bits
                    neighbours |= adjacency[bit.bit_length() - 1]
                    bits ^= bit
                frontier = neighbours & unseen
            pieces.append(piece)
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
    if grundy(full) != 0:
        return []
    root_measures = measures(adjacency, full, selected, offconic_points, q)
    rows = []
    for first in range(n):
        follower = full & ~closed[first]
        replies = []
        bits = follower
        while bits:
            bit = bits & -bits
            reply = bit.bit_length() - 1
            grandchild = follower & ~closed[reply]
            replies.append((reply, grandchild, grundy(grandchild)))
            bits ^= bit
        winning = [reply for reply in replies if reply[2] == 0]
        if len(winning) != 1:
            continue
        measured_replies = []
        for reply, grandchild, value in replies:
            child_selected = (
                *selected,
                conic[full_indices[first]],
                conic[full_indices[reply]],
            )
            child_measures = measures(
                adjacency, grandchild, child_selected, offconic_points, q
            )
            child_measures["grundy"] = value
            child_measures["reply"] = reply
            measured_replies.append(child_measures)
        replies = measured_replies
        winning = [reply for reply in replies if reply["grundy"] == 0]
        win = winning[0]
        losing = [reply for reply in replies if reply["grundy"] != 0]
        blind_keys = (
            "components", "edges", "largest_component", "live",
            "psi_proxy", "reservoir_proxy", "zone_v",
        )
        signature = tuple(win[key] for key in blind_keys)
        collisions = sum(
            tuple(reply[key] for key in blind_keys) == signature for reply in losing
        )
        minimum = min(reply["psi_proxy"] for reply in replies)
        live_minimum = min(reply["live"] for reply in replies)
        component_minimum = min(reply["components"] for reply in replies)
        win_delta = win["psi_proxy"] - root_measures["psi_proxy"]
        rows.append({
            "all_replies_proxy_descend": all(
                reply["psi_proxy"] < root_measures["psi_proxy"] for reply in replies
            ),
            "blind_signature_losing_collisions": collisions,
            "first": parameter_json(parameters[full_indices[first]]),
            "losing_replies": len(losing),
            "reply": parameter_json(parameters[full_indices[win["reply"]]]),
            "root": root_measures,
            "winning": {key: win[key] for key in blind_keys},
            "winning_delta_psi_proxy": win_delta,
            "winning_is_component_minimum": win["components"] == component_minimum,
            "winning_is_live_minimum": win["live"] == live_minimum,
            "winning_is_psi_minimum": win["psi_proxy"] == minimum,
            "winning_psi_minimum_ties": sum(
                reply["psi_proxy"] == minimum for reply in replies
            ) if win["psi_proxy"] == minimum else 0,
            "winning_psi_rank": 1 + sum(
                reply["psi_proxy"] < win["psi_proxy"] for reply in replies
            ),
        })
    return rows


def probe(q: int, label: str) -> dict[str, object]:
    parameters = projective_line(q)
    parameter_index = {parameter: i for i, parameter in enumerate(parameters)}
    conic = tuple(conic_point(t, q) for t in parameters)
    offconic_points = centres(q)
    permutations = {
        point: tuple(parameter_index[sigma(point, t, q)] for t in parameters)
        for point in offconic_points
    }
    representatives, subgroup_points = s4_representatives(
        q, offconic_points, permutations
    )
    selected = representatives[label]
    records = []
    p_roots = 0
    roots = 0
    for candidate in offconic_points:
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
        reference = reference_solve(adjacency)
        if reference["grundy"] == 0:
            p_roots += 1
        full_indices = tuple(i for i in range(len(parameters)) if i not in dead)
        rows = analyse_root(
            adjacency, full_indices, parameters, conic, centres4, offconic_points, q
        )
        if reference["grundy"] != 0:
            assert not rows
        for row in rows:
            row["candidate"] = list(candidate)
            records.append(row)
        gc.collect()

    delta_hist = Counter(row["winning_delta_psi_proxy"] for row in records)
    rank_hist = Counter(row["winning_psi_rank"] for row in records)
    return {
        "class": label,
        "forcing_pairs": len(records),
        "p_roots": p_roots,
        "q": q,
        "records": records,
        "roots": roots,
        "selected": [list(point) for point in selected],
        "summary": {
            "all_replies_proxy_descend": sum(
                row["all_replies_proxy_descend"] for row in records
            ),
            "blind_signature_collision_pairs": sum(
                row["blind_signature_losing_collisions"] > 0 for row in records
            ),
            "winning_delta_psi_proxy_histogram": dict(sorted(delta_hist.items())),
            "winning_is_component_minimum": sum(
                row["winning_is_component_minimum"] for row in records
            ),
            "winning_is_live_minimum": sum(
                row["winning_is_live_minimum"] for row in records
            ),
            "winning_is_psi_minimum": sum(
                row["winning_is_psi_minimum"] for row in records
            ),
            "winning_psi_rank_histogram": dict(sorted(rank_hist.items())),
            "winning_strictly_descends": sum(
                row["winning_delta_psi_proxy"] < 0 for row in records
            ),
            "winning_unique_psi_minimum": sum(
                row["winning_is_psi_minimum"]
                and row["winning_psi_minimum_ties"] == 1
                for row in records
            ),
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("q", nargs="+", type=int)
    parser.add_argument("--class", dest="label", choices=tuple("ABCD"), default="D")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = {
        "cases": [probe(q, args.label) for q in args.q],
        "schema": "c84-two-ply-ledger-v1",
    }
    if args.check:
        tracked = Path(__file__).resolve().parents[2] / "notes" / (
            "2026-07-17-c84-two-ply-ledger.json"
        )
        if json.loads(tracked.read_text()) != json.loads(json.dumps(result, sort_keys=True)):
            raise SystemExit("tracked two-ply-ledger JSON differs from regeneration")
        print(f"OK: {len(result['cases'])} fields; two-ply-ledger JSON matches")
    else:
        print(json.dumps(result, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
