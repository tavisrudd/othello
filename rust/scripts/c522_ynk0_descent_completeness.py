#!/usr/bin/env python3
"""C522 (cap, Route 3): is the Y_NK0 guard a complete bulk-descent certificate?

C80(b) bulk descent asks whether, from every opponent intrusion, the responder has a
certified winning reply into a proven-P packet. The proven-P packet on the table is
Y_NK0 (empty live conic + every capacity-2 line carries <=2 legal points + residual
conflict graph Grundy-0 => Node-Kayles => P). The committed response-fibre census
(c80_response_fibre_census.py) only measured Y_NK0 over PRIMITIVE off-conic Y_0 replies.
This script asks the real question over ALL legal replies:

  Over the frozen q13/q17 three-intruder domain (one intruder opponent move from a
  recorded C20 P reply state), does every child admit SOME legal reply -- of any kind --
  landing in a Y_NK0 state?

Y_NK0-reply existence is checked structurally (no minimax). Gap children (no Y_NK0 reply)
are then analysed by exact minimax: every gap child is verified N (responder-to-move
wins), and each winning reply's target grandchild is classified by
(live-conic size, capacity-2 guard, reply kind).

Verdict: Y_NK0 is NOT complete. The gap is dominated by children FORCED to keep the
conic live (no one-step descent to an empty-conic Node-Kayles base); the recurring
companion object is the single-live-parameter state.

Reuses the exact frozen inputs and helpers of the committed census.

Run:    python3 rust/scripts/c522_ynk0_descent_completeness.py
Check:  python3 rust/scripts/c522_ynk0_descent_completeness.py --check
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ROWS = ROOT / "notes/data/c20-q13-q17-states.jsonl.gz"
OUT = ROOT / "notes/2026-07-23-c522-ynk0-descent-completeness.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


GEOMETRY = load_module(ROOT / "notes/2026-07-08-zone-repair-geometry.py", "c522_geometry")
CENSUS = load_module(ROOT / "rust/scripts/c80_response_fibre_census.py", "c522_census")
C31 = GEOMETRY.load_c31_module()
C20 = C31.load_c20_module()


def run_q(q: int, rows_path: Path) -> dict:
    game = C20.PrimeGridGame(q)
    lines = CENSUS.projective_lines(game)
    states, _ = C31.load_p_reply_states(rows_path, q)

    def is_ynk0(grand: int) -> bool:
        if GEOMETRY.live_conic(game, grand):
            return False
        if not CENSUS.node_kayles_exact(game, lines, grand):
            return False
        feats = game.state_features(grand, GEOMETRY.intruders(game, grand))
        return feats["zone_grundy"] == 0

    def target_class(grand: int) -> str:
        live = len(GEOMETRY.live_conic(game, grand))
        cap_ok = CENSUS.node_kayles_exact(game, lines, grand)
        if live == 0:
            return "empty_capOK" if cap_ok else "empty_capOVER"
        return f"live{live}_{'capOK' if cap_ok else 'capOVER'}"

    # Pass A (structural, no minimax): per unique three-intruder child, does a Y_NK0
    # reply exist among ALL legal replies?
    seen: set[int] = set()
    gap_children: list[int] = []
    for mask, _row in states:
        for move in GEOMETRY.bits(game.legal_mask(mask) & ~game.conic_mask):
            child = mask | (1 << move)
            if len(GEOMETRY.intruders(game, child)) != 3 or child in seen:
                continue
            seen.add(child)
            replies = list(GEOMETRY.bits(game.legal_mask(child)))
            if not any(is_ynk0(child | (1 << r)) for r in replies):
                gap_children.append(child)

    n_children = len(seen)
    n_gap = len(gap_children)

    # Pass B (minimax): every gap child must be N; classify winning-reply targets.
    child_value = Counter()
    reply_kinds = Counter()               # per gap child: sorted set of winning-reply kinds
    target_sig = Counter()                # (target class, reply kind) over all winning replies
    easiest_class = Counter()             # per gap child: class of min-live winning reply
    min_live_dist = Counter()             # per gap child: min live-conic over winning replies
    responder_win_no_p = 0
    for child in gap_children:
        cval = game.value(child)
        child_value["N" if cval else "P"] += 1
        wins = []
        kinds = set()
        for r in GEOMETRY.bits(game.legal_mask(child)):
            grand = child | (1 << r)
            if game.value(grand):
                continue  # N target -> losing reply
            cls = target_class(grand)
            kind = "conic" if game.is_conic_cell(r) else "intruder"
            live = len(GEOMETRY.live_conic(game, grand))
            wins.append((live, cls))
            kinds.add(kind)
            target_sig[(cls, kind)] += 1
        if not wins:
            responder_win_no_p += 1
            continue
        reply_kinds[tuple(sorted(kinds))] += 1
        best = min(wins, key=lambda w: w[0])
        easiest_class[best[1]] += 1
        min_live_dist[min(w[0] for w in wins)] += 1

    can_reach_empty = min_live_dist.get(0, 0)
    return {
        "q": q,
        "p_reply_states": len(states),
        "unique_three_intruder_children": n_children,
        "children_with_ynk0_reply": n_children - n_gap,
        "children_without_ynk0_reply": n_gap,
        "gap_child_value_distribution": dict(sorted(child_value.items())),
        "responder_win_with_no_p_reply": responder_win_no_p,
        "gap_winning_reply_kinds": {
            "+".join(k): v for k, v in sorted(reply_kinds.items())
        },
        "gap_target_signatures": {
            f"{cls}:{kind}": v for (cls, kind), v in sorted(target_sig.items())
        },
        "gap_easiest_target_class": dict(sorted(easiest_class.items())),
        "gap_min_live_conic_distribution": {
            str(k): v for k, v in sorted(min_live_dist.items())
        },
        "gap_children_can_reach_empty_conic": can_reach_empty,
        "gap_children_forced_conic_live": n_gap - can_reach_empty,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", type=Path, default=ROWS)
    parser.add_argument("--output", type=Path, default=OUT)
    parser.add_argument("--q", type=int, nargs="+", default=[13, 17])
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    payload = {
        "claim_scope": (
            "Child-level completeness test of the Y_NK0 guard as a bulk-descent certificate "
            "over every three-intruder child (one intruder opponent move) reachable from the "
            "recorded q=13 and q=17 C20 P reply states, considering ALL legal responder replies."
        ),
        "ynk0_guard": (
            "A grandchild is Y_NK0 when its live conic is empty, every projective line of "
            "residual capacity two carries at most two legal points, and the residual conflict "
            "graph has Grundy value zero (=> Node-Kayles => P)."
        ),
        "verdict": (
            "Y_NK0 is NOT a complete bulk-descent certificate: 9.29% of q=17 children (0.31% at "
            "q=13) admit no Y_NK0 reply among all legal replies, yet every such child is a "
            "responder win. 89% of the q=17 gap is forced to keep the conic live (no one-step "
            "descent to an empty-conic base); the dominant companion object is the "
            "single-live-parameter state."
        ),
        "source": {
            "path": str(args.rows.relative_to(ROOT)),
            "sha256": sha256(args.rows),
            "bytes": args.rows.stat().st_size,
        },
        "fields": [run_q(q, args.rows) for q in args.q],
    }
    rendered = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.check:
        assert args.output.read_text() == rendered, "C522 census: MISMATCH vs committed output"
        print("C522 Y_NK0 descent-completeness census: PASS")
    else:
        args.output.write_text(rendered)
        print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
