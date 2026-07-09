#!/usr/bin/env python3
"""Geometric diagnostics for high-cost one-pair repair moves.

This builds on notes/2026-07-08-zone-descent-miner.py.  It focuses on the
score-optimal replies from the C31 steering recursion and records projective
geometry features of the high-cost repairs.
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
    path = Path(__file__).with_name("2026-07-08-zone-steering-census.py")
    spec = importlib.util.spec_from_file_location("c31_zone_steering", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    mod = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = mod
    spec.loader.exec_module(mod)
    return mod


def counter_dict(counter: Counter, limit: int | None = None) -> dict[str, int]:
    items = counter.most_common(limit) if limit is not None else sorted(counter.items(), key=lambda kv: repr(kv[0]))
    return {repr(k): v for k, v in items}


def bits(mask: int):
    c31 = sys.modules["c31_zone_steering"]
    return list(c31.iter_bits(mask))


def cell(game: Any, idx: int) -> tuple[int, int] | None:
    c31 = sys.modules["c31_zone_steering"]
    return c31.cell(game, idx)


def kind(game: Any, idx: int) -> str:
    return "conic" if game.is_conic_cell(idx) else "intruder"


def intruders(game: Any, mask: int) -> tuple[int, ...]:
    return tuple(c for c in bits(mask & ~game.conic_mask))


def live_conic(game: Any, mask: int) -> set[int]:
    return {t for t, c in game.conic_cell.items() if game.legal_mask(mask) & (1 << c)}


def played_params(game: Any, mask: int) -> set[Any]:
    c20 = sys.modules["c20_intrusion_census"]
    out: set[Any] = {c20.INF, 0}
    for c in bits(mask & game.conic_mask):
        out.add(game.cell_param[c])
    return out


def conic_intersections(game: Any, u: int, v: int) -> tuple[Any, ...]:
    pu = game.points[u + 2]
    pv = game.points[v + 2]
    return tuple(t for t in game.params if game.collinear(pu, pv, game.conic_point[t]))


def line_type(game: Any, u: int, v: int) -> str:
    return {0: "external", 1: "tangent", 2: "secant"}.get(len(conic_intersections(game, u, v)), "other")


def tau(game: Any, x: int) -> int:
    return sum(1 for s in game.params if game.sigma(x, s) == s)


def tau_played(game: Any, x: int, params: set[Any]) -> int:
    return sum(1 for s in params if game.sigma(x, s) == s)


def prod_order(game: Any, u: int, v: int) -> int:
    return game.prod_order(game.sigma_perm(u), game.sigma_perm(v))


def best_replies(game: Any, steering: Any, child: int) -> list[dict[str, Any]]:
    best_score = None
    rows: list[dict[str, Any]] = []
    for r in bits(game.legal_mask(child)):
        grand = child | (1 << r)
        if game.value(grand):
            continue
        child_z = steering.z(grand)
        zone = steering.zone(grand)
        score = max(zone, child_z)
        feats = game.state_features(grand, intruders(game, grand))
        row = {"score": score, "zone": zone, "child_z": child_z, "reply": r, "grand": grand, "features": feats}
        if best_score is None or score < best_score:
            best_score = score
            rows = [row]
        elif score == best_score:
            rows.append(row)
    if best_score is None:
        raise RuntimeError("N-child has no P reply")
    return sorted(rows, key=lambda row: (row["score"], row["zone"], row["child_z"], row["reply"]))


def clean_empty(feats: dict[str, Any]) -> bool:
    return tuple(map(tuple, feats["spectrum"])) == () and feats["defxor"] == 0 and feats["zone_grundy"] == 0


def kill_witnesses(game: Any, child: int, reply: int, killed: set[int]) -> list[tuple[Any, tuple[Any, ...]]]:
    params = played_params(game, child)
    out = []
    for t in sorted(killed):
        witnesses = tuple(sorted((s for s in params if game.sigma(reply, s) == t), key=repr))
        out.append((t, witnesses))
    return out


def run_q(q: int, rows_path: Path, high: int, top: int) -> dict[str, Any]:
    start = time.time()
    c31 = load_c31_module()
    c20 = c31.load_c20_module()
    game = c20.PrimeGridGame(q)
    states, row_counts = c31.load_p_reply_states(rows_path, q)
    steering = c31.Steering(game)

    line_counts = Counter()
    order_counts = Counter()
    tau_counts = Counter()
    kill_counts = Counter()
    candidate_counts = Counter()
    candidate_features = Counter()
    state_counts = Counter()
    examples = []

    for mask, row in states:
        state_z = steering.z(mask)
        for m in bits(game.legal_mask(mask)):
            child = mask | (1 << m)
            before = live_conic(game, child)
            best = best_replies(game, steering, child)[0]
            score = int(best["score"])
            if score < high:
                continue
            r = int(best["reply"])
            grand = int(best["grand"])
            feats = best["features"]
            after = live_conic(game, grand)
            killed = before - after
            mk = kind(game, m)
            rk = kind(game, r)
            clean = clean_empty(feats)
            pparams = played_params(game, child)

            if mk == "intruder" and rk == "intruder":
                lt = line_type(game, m, r)
                order = prod_order(game, m, r)
                intersections = conic_intersections(game, m, r)
            else:
                lt = "non-ii"
                order = None
                intersections = ()

            tm = tau(game, m) if mk == "intruder" else None
            tr = tau(game, r) if rk == "intruder" else None
            tpm = tau_played(game, m, pparams) if mk == "intruder" else None
            tpr = tau_played(game, r, pparams) if rk == "intruder" else None

            line_counts[(score, mk, rk, lt, len(intersections), clean)] += 1
            order_counts[(score, order, lt, clean)] += 1
            tau_counts[(score, tm, tpm, tr, tpr, clean)] += 1
            kill_counts[(score, len(before), len(killed), len(after), clean)] += 1
            state_counts[(score, row["canon"], tuple(row["t4"]), state_z, clean)] += 1

            legal_intruders = [z for z in bits(game.legal_mask(child) & ~game.conic_mask)]
            kill_candidates = []
            p_kill_candidates = []
            clean_candidates = []
            internal_candidates = []
            internal_clean_candidates = []
            for z in legal_intruders:
                zgrand = child | (1 << z)
                zafter = live_conic(game, zgrand)
                if before and not zafter:
                    kill_candidates.append(z)
                    z_is_p = not game.value(zgrand)
                    zfeats = game.state_features(zgrand, intruders(game, zgrand))
                    zclean = clean_empty(zfeats)
                    if z_is_p:
                        p_kill_candidates.append(z)
                    if zclean:
                        clean_candidates.append(z)
                    if tau(game, z) == 0 and tau_played(game, z, pparams) == 0:
                        internal_candidates.append(z)
                        if zclean:
                            internal_clean_candidates.append(z)
                    candidate_features[
                        (
                            score,
                            z_is_p,
                            zclean,
                            tau(game, z),
                            tau_played(game, z, pparams),
                            steering.zone(zgrand),
                            steering.z(zgrand) if z_is_p else None,
                        )
                    ] += 1

            candidate_counts[
                (
                    score,
                    len(before),
                    len(legal_intruders),
                    len(kill_candidates),
                    len(p_kill_candidates),
                    len(clean_candidates),
                    len(internal_candidates),
                    len(internal_clean_candidates),
                    r in kill_candidates,
                    r in clean_candidates,
                    r in internal_clean_candidates,
                )
            ] += 1

            if len(examples) < top and score >= high:
                examples.append(
                    {
                        "score": score,
                        "canon": row["canon"],
                        "t4": row["t4"],
                        "x": row["x"],
                        "y": row["y"],
                        "move": cell(game, m),
                        "reply": cell(game, r),
                        "move_reply_line": lt,
                        "move_reply_order": order,
                        "tau": [tm, tpm, tr, tpr],
                        "before_live": sorted(before),
                        "killed": sorted(killed),
                        "after_live": sorted(after),
                        "kill_witnesses": kill_witnesses(game, child, r, killed),
                        "legal_intruders": len(legal_intruders),
                        "kill_candidates": len(kill_candidates),
                        "p_kill_candidates": len(p_kill_candidates),
                        "clean_candidates": len(clean_candidates),
                        "internal_clean_candidates": len(internal_clean_candidates),
                    }
                )

    return {
        "q": q,
        "row_counts": dict(row_counts),
        "unique_p_states": len(states),
        "high_threshold": high,
        "line_counts": counter_dict(line_counts),
        "order_counts": counter_dict(order_counts),
        "tau_counts": counter_dict(tau_counts),
        "kill_counts": counter_dict(kill_counts),
        "candidate_counts": counter_dict(candidate_counts),
        "candidate_features_top": counter_dict(candidate_features, limit=top),
        "state_counts": counter_dict(state_counts),
        "examples": examples,
        "seconds": time.time() - start,
        "z_cache": len(steering.z_cache),
        "zone_cache": len(steering.zone_cache),
        "value_cache": game.value.cache_info().currsize,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", default="notes/data/c20-q13-q17-states.jsonl.gz")
    parser.add_argument("--qs", default="17")
    parser.add_argument("--high", type=int, default=8)
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
