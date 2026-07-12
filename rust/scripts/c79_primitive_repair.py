#!/usr/bin/env python3
"""C79: test primitive-torus repair packets against structural clean certificates."""

from __future__ import annotations

import argparse
import importlib.util
import sys
from collections import Counter
from itertools import permutations, product
from pathlib import Path


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def canonical_graph(adj):
    by_degree = {}
    for vertex, neighbors in enumerate(adj):
        by_degree.setdefault(neighbors.bit_count(), []).append(vertex)
    candidates = []
    for blocks in product(*(permutations(by_degree[degree]) for degree in sorted(by_degree))):
        order = tuple(vertex for block in blocks for vertex in block)
        bits = 0
        shift = 0
        for i in range(len(order)):
            for j in range(i + 1, len(order)):
                bits |= bool(adj[order[i]] & (1 << order[j])) << shift
                shift += 1
        candidates.append(bits)
    return min(candidates)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--q", type=int, default=17)
    parser.add_argument("--high", type=int, default=7)
    parser.add_argument("--rows", default="../notes/data/c20-q13-q17-states.jsonl.gz")
    args = parser.parse_args()

    notes = Path(__file__).resolve().parents[2] / "notes"
    geometry = load_module(notes / "2026-07-08-zone-repair-geometry.py", "c79_repair_geometry")
    c31 = geometry.load_c31_module()
    c20 = c31.load_c20_module()
    game = c20.PrimeGridGame(args.q)
    states, _row_counts = c31.load_p_reply_states(Path(args.rows), args.q)
    steering = c31.Steering(game)

    counts = Counter()
    internal_counts = Counter()
    zone_profiles = Counter()
    edge_extrema = Counter()
    clean_graphs = Counter()
    clean_value_failures = []
    primitive_clean_examples = []
    for mask, row in states:
        for move in geometry.bits(game.legal_mask(mask)):
            child = mask | (1 << move)
            live_before = geometry.live_conic(game, child)
            best = geometry.best_replies(game, steering, child)[0]
            score = int(best["score"])
            if score < args.high:
                continue
            move_is_intruder = geometry.kind(game, move) == "intruder"
            packet = []
            for reply in geometry.bits(game.legal_mask(child) & ~game.conic_mask):
                grand = child | (1 << reply)
                features = game.state_features(grand, geometry.intruders(game, grand))
                clean = geometry.clean_empty(features)
                kills_conic = bool(live_before) and not geometry.live_conic(game, grand)
                zone_grundy = features["zone_grundy"]
                zone_edges = features["zone_edges"]
                zone_vertices, zone_adj, _zone_edges_check = game.zone_graph(grand)
                assert _zone_edges_check == zone_edges
                degrees = tuple(sorted(neighbors.bit_count() for neighbors in zone_adj))
                triangles = sum(
                    (zone_adj[i] & zone_adj[j] & ~((1 << (j + 1)) - 1)).bit_count()
                    if zone_adj[i] & (1 << j) else 0
                    for i in range(len(zone_adj)) for j in range(i + 1, len(zone_adj))
                )
                unseen = set(range(len(zone_vertices)))
                component_sizes = []
                while unseen:
                    stack = [unseen.pop()]
                    size = 0
                    while stack:
                        vertex = stack.pop()
                        size += 1
                        neighbors = {i for i in unseen if zone_adj[vertex] & (1 << i)}
                        unseen -= neighbors
                        stack.extend(neighbors)
                    component_sizes.append(size)
                graph_signature = (
                    degrees, triangles, tuple(sorted(component_sizes)), canonical_graph(zone_adj),
                )
                p_value = not game.value(grand)
                if clean and not p_value:
                    clean_value_failures.append((args.q, row["canon"], move, reply))
                order = geometry.prod_order(game, move, reply) if move_is_intruder else None
                primitive = order in (args.q - 1, args.q + 1)
                full_cyclic = order in (args.q - 1, args.q, args.q + 1)
                params = geometry.played_params(game, child)
                internal = geometry.tau(game, reply) == 0 \
                    and geometry.tau_played(game, reply, params) == 0
                packet.append((
                    reply, primitive, full_cyclic, clean, p_value, order, internal,
                    kills_conic, zone_grundy, zone_edges, graph_signature,
                ))
            primitive = [entry for entry in packet if entry[1]]
            full_cyclic = [entry for entry in packet if entry[2]]
            clean = [entry for entry in packet if entry[3]]
            primitive_clean = [entry for entry in packet if entry[1] and entry[3]]
            primitive_p = [entry for entry in packet if entry[1] and entry[4]]
            full_cyclic_clean = [entry for entry in packet if entry[2] and entry[3]]
            full_cyclic_p = [entry for entry in packet if entry[2] and entry[4]]
            primitive_internal = [entry for entry in packet if entry[1] and entry[6]]
            primitive_internal_clean = [entry for entry in primitive_internal if entry[3]]
            full_cyclic_internal = [entry for entry in packet if entry[2] and entry[6]]
            full_cyclic_internal_clean = [entry for entry in full_cyclic_internal if entry[3]]
            primitive_kill = [entry for entry in primitive if entry[7]]
            primitive_kill_zone0 = [entry for entry in primitive_kill if entry[8] == 0]
            counts[(
                score,
                geometry.kind(game, move),
                bool(clean),
                bool(primitive),
                bool(primitive_p),
                bool(primitive_clean),
                len(primitive),
                len(primitive_clean),
                bool(full_cyclic),
                bool(full_cyclic_p),
                bool(full_cyclic_clean),
                len(full_cyclic),
                len(full_cyclic_clean),
            )] += 1
            zone_profiles[(
                score,
                tuple(sorted((entry[9], entry[8], entry[3]) for entry in primitive)),
            )] += 1
            for entry in primitive:
                if entry[3]:
                    clean_graphs[(score, entry[10])] += 1
            for name, candidates in (
                    ("primitive", primitive), ("full-cyclic", full_cyclic),
                    ("all-intruder", packet)):
                if not candidates:
                    edge_extrema[(score, name, "empty")] += 1
                    continue
                maximum = max(entry[9] for entry in candidates)
                maxima = [entry for entry in candidates if entry[9] == maximum]
                edge_extrema[(
                    score, name, "nonempty", len(maxima),
                    all(entry[3] for entry in maxima),
                    all(entry[4] for entry in maxima),
                )] += 1
            for name, key in (
                    ("full-then-edges", lambda entry: (entry[2], entry[9])),
                    ("primitive-then-edges", lambda entry: (entry[1], entry[9])),
                    ("order-then-edges", lambda entry: (entry[5] or 0, entry[9]))):
                maximum = max(key(entry) for entry in packet)
                maxima = [entry for entry in packet if key(entry) == maximum]
                edge_extrema[(
                    score, name, "nonempty", len(maxima),
                    all(entry[3] for entry in maxima),
                    all(entry[4] for entry in maxima),
                )] += 1
            internal_counts[(
                score, geometry.kind(game, move),
                len(primitive), len(primitive_internal), len(primitive_internal_clean),
                len(full_cyclic), len(full_cyclic_internal), len(full_cyclic_internal_clean),
                len(primitive_kill), len(primitive_kill_zone0),
            )] += 1
            if primitive_clean and len(primitive_clean_examples) < 20:
                primitive_clean_examples.append((
                    score, row["canon"], tuple(row["t4"]),
                    geometry.cell(game, move),
                    tuple((geometry.cell(game, entry[0]), entry[5]) for entry in primitive_clean),
                ))

    assert not clean_value_failures, clean_value_failures[:10]
    print(f"PRIMITIVE-REPAIR q={args.q} high={args.high} rows={sum(counts.values())}")
    for key, count in sorted(counts.items()):
        print(f"PRIMITIVE-REPAIR-ROW key={key} count={count}")
    for key, count in sorted(internal_counts.items()):
        print(f"PRIMITIVE-INTERNAL-ROW key={key} count={count}")
    for key, count in sorted(zone_profiles.items()):
        print(f"PRIMITIVE-ZONE-PROFILE key={key} count={count}")
    for key, count in sorted(edge_extrema.items()):
        print(f"PRIMITIVE-EDGE-EXTREMA key={key} count={count}")
    for key, count in sorted(clean_graphs.items()):
        print(f"PRIMITIVE-CLEAN-GRAPH key={key} count={count}")
    print(f"PRIMITIVE-REPAIR-EXAMPLES rows={primitive_clean_examples}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
