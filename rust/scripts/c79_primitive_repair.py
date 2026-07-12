#!/usr/bin/env python3
"""C79: test primitive-torus repair packets against structural clean certificates."""

from __future__ import annotations

import argparse
import importlib.util
import sys
from collections import Counter
from pathlib import Path


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


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
    clean_value_failures = []
    primitive_clean_examples = []
    for mask, row in states:
        for move in geometry.bits(game.legal_mask(mask)):
            child = mask | (1 << move)
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
                p_value = not game.value(grand)
                if clean and not p_value:
                    clean_value_failures.append((args.q, row["canon"], move, reply))
                order = geometry.prod_order(game, move, reply) if move_is_intruder else None
                primitive = order in (args.q - 1, args.q + 1)
                full_cyclic = order in (args.q - 1, args.q, args.q + 1)
                packet.append((reply, primitive, full_cyclic, clean, p_value, order))
            primitive = [entry for entry in packet if entry[1]]
            full_cyclic = [entry for entry in packet if entry[2]]
            clean = [entry for entry in packet if entry[3]]
            primitive_clean = [entry for entry in packet if entry[1] and entry[3]]
            primitive_p = [entry for entry in packet if entry[1] and entry[4]]
            full_cyclic_clean = [entry for entry in packet if entry[2] and entry[3]]
            full_cyclic_p = [entry for entry in packet if entry[2] and entry[4]]
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
    print(f"PRIMITIVE-REPAIR-EXAMPLES rows={primitive_clean_examples}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
