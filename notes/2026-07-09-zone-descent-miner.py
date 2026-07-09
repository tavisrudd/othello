#!/usr/bin/env python3
"""Mine C31 one-pair descent replies.

This is a follow-up diagnostic for notes/2026-07-09-codex-zone-descent-target.md.
It reconstructs the C20 P reply-states, then for every legal opponent move finds the
score-optimal winning replies used by the C31 steering recursion.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import sys
import time
from collections import Counter
from pathlib import Path
from typing import Any


def load_c31_module():
    path = Path(__file__).with_name("2026-07-09-zone-steering-census.py")
    spec = importlib.util.spec_from_file_location("c31_zone_steering", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    mod = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = mod
    spec.loader.exec_module(mod)
    return mod


def stringify_counter(counter: Counter, limit: int | None = None) -> dict[str, int]:
    items = counter.items()
    if limit is not None:
        items = counter.most_common(limit)
    else:
        items = sorted(items, key=lambda kv: repr(kv[0]))
    return {repr(k): v for k, v in items}


def selected_intruders(game: Any, mask: int) -> tuple[int, ...]:
    c31 = sys.modules["c31_zone_steering"]
    return tuple(c for c in c31.iter_bits(mask & ~game.conic_mask))


def move_kind(game: Any, idx: int) -> str:
    return "conic" if game.is_conic_cell(idx) else "intruder"


def cell(game: Any, idx: int) -> tuple[int, int] | None:
    c31 = sys.modules["c31_zone_steering"]
    return c31.cell(game, idx)


def best_replies(game: Any, steering: Any, child: int) -> list[dict[str, Any]]:
    c31 = sys.modules["c31_zone_steering"]
    best_score = None
    rows: list[dict[str, Any]] = []
    for r in c31.iter_bits(game.legal_mask(child)):
        grand = child | (1 << r)
        if game.value(grand):
            continue
        child_z = steering.z(grand)
        zone = steering.zone(grand)
        score = max(zone, child_z)
        feats = game.state_features(grand, selected_intruders(game, grand))
        row = {
            "score": score,
            "zone": zone,
            "child_z": child_z,
            "reply": r,
            "grand": grand,
            "features": feats,
        }
        if best_score is None or score < best_score:
            best_score = score
            rows = [row]
        elif score == best_score:
            rows.append(row)
    if best_score is None:
        raise RuntimeError("N-child has no P reply")
    return sorted(rows, key=lambda row: (row["zone"], row["child_z"], row["reply"]))


def clean_empty(feats: dict[str, Any]) -> bool:
    return tuple(map(tuple, feats["spectrum"])) == () and feats["defxor"] == 0 and feats["zone_grundy"] == 0


def run_q(q: int, rows_path: Path, high: int, top: int) -> dict[str, Any]:
    start = time.time()
    c31 = load_c31_module()
    c20 = c31.load_c20_module()
    game = c20.PrimeGridGame(q)
    states, row_counts = c31.load_p_reply_states(rows_path, q)
    steering = c31.Steering(game)

    selected_move_reply = Counter()
    selected_score = Counter()
    selected_zone = Counter()
    selected_child_z = Counter()
    best_count = Counter()
    best_kind_sets = Counter()
    high_features = Counter()
    high_bucket_rows = Counter()
    high_clean = Counter()
    high_move_reply = Counter()
    childz2_features = Counter()
    score_equals_zone = True
    examples: list[dict[str, Any]] = []
    transitions = 0

    for mask, row in states:
        state_z = steering.z(mask)
        for m in c31.iter_bits(game.legal_mask(mask)):
            transitions += 1
            bests = best_replies(game, steering, mask | (1 << m))
            chosen = bests[0]
            r = int(chosen["reply"])
            feats = chosen["features"]
            spectrum = tuple(map(tuple, feats["spectrum"]))
            mk = move_kind(game, m)
            rk = move_kind(game, r)
            score = int(chosen["score"])
            zone = int(chosen["zone"])
            child_z = int(chosen["child_z"])
            score_equals_zone = score_equals_zone and score == zone

            selected_move_reply[(mk, rk)] += 1
            selected_score[score] += 1
            selected_zone[zone] += 1
            selected_child_z[child_z] += 1
            best_count[len(bests)] += 1
            best_kind_sets["".join(sorted({move_kind(game, int(b["reply"]))[0] for b in bests}))] += 1

            feature_key = (score, zone, child_z, mk, rk, feats["defxor"], feats["zone_grundy"], spectrum)
            if child_z == 2:
                childz2_features[(score, zone, mk, rk, feats["defxor"], feats["zone_grundy"], spectrum)] += 1
            if score >= high:
                high_features[feature_key] += 1
                high_bucket_rows[(row["canon"], tuple(row["t4"]), state_z, score, zone, child_z)] += 1
                high_move_reply[(mk, rk)] += 1
                has_clean = any(clean_empty(b["features"]) for b in bests)
                has_empty = any(tuple(map(tuple, b["features"]["spectrum"])) == () for b in bests)
                high_clean[(score, has_clean, has_empty, mk, len(bests))] += 1
                if not has_clean and len(examples) < top:
                    examples.append(
                        {
                            "canon": row["canon"],
                            "t4": row["t4"],
                            "x": row["x"],
                            "y": row["y"],
                            "move": cell(game, m),
                            "score": score,
                            "best_replies": [
                                {
                                    "reply": cell(game, int(b["reply"])),
                                    "zone": b["zone"],
                                    "child_z": b["child_z"],
                                    "defxor": b["features"]["defxor"],
                                    "zone_grundy": b["features"]["zone_grundy"],
                                    "spectrum": b["features"]["spectrum"],
                                }
                                for b in bests
                            ],
                        }
                    )

    return {
        "q": q,
        "row_counts": dict(row_counts),
        "unique_p_states": len(states),
        "transitions": transitions,
        "selected_score_equals_zone": score_equals_zone,
        "selected_move_reply": stringify_counter(selected_move_reply),
        "selected_score": stringify_counter(selected_score),
        "selected_zone": stringify_counter(selected_zone),
        "selected_child_z": stringify_counter(selected_child_z),
        "best_reply_count": stringify_counter(best_count),
        "best_kind_sets": stringify_counter(best_kind_sets),
        "high_threshold": high,
        "high_features": stringify_counter(high_features),
        "high_bucket_rows": stringify_counter(high_bucket_rows),
        "high_clean_availability": stringify_counter(high_clean),
        "high_move_reply": stringify_counter(high_move_reply),
        "childz2_features_top": stringify_counter(childz2_features, limit=top),
        "high_no_clean_examples": examples,
        "seconds": time.time() - start,
        "z_cache": len(steering.z_cache),
        "zone_cache": len(steering.zone_cache),
        "value_cache": game.value.cache_info().currsize,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", default="notes/data/c20-q13-q17-states.jsonl.gz")
    parser.add_argument("--qs", default="17")
    parser.add_argument("--high", type=int, default=7)
    parser.add_argument("--top", type=int, default=20)
    parser.add_argument("--json-out")
    args = parser.parse_args()

    sys.setrecursionlimit(10000)
    rows_path = Path(args.rows)
    results = [run_q(int(q), rows_path, args.high, args.top) for q in args.qs.split(",") if q]
    text = json.dumps(results, indent=2, sort_keys=True)
    if args.json_out:
        Path(args.json_out).write_text(text + "\n", encoding="utf-8")
    print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
