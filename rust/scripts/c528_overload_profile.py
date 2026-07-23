#!/usr/bin/env python3
"""C528 (cap), Step 1 [DECISIVE]: q19 overload-profile tabulation on frozen data.

The gadget-Node-Kayles route (see notes/2026-07-23-c80-gadget-nk-plan.md) models
capOVER states as NK+(G, gadgets): one gadget per overloaded capacity-two line (a line
with no selected point carrying >=3 legal points -- an independent k-set that collapses
to a clique on first touch). The value law is proven by induction on the overload
measure; the shape of that induction depends on the observed overload profile.

Deduction: every residual (capOVER-core) child from C523/C524 is itself capOVER. A capOK
child would be static Node-Kayles (Y_NK theorem); being a responder-win (N) it would have
Grundy != 0, hence a Grundy-0 = Y_NK reply, contradicting "no Y_NK reply". So the residual
children ARE the gadget-bearing states, and their overload profiles decide the branch.

This pass tabulates, over the frozen q19 residual children (and, with --witnesses, their
depth-2 witness states G = child u {r}):
  g   = number of overloaded capacity-two lines (gadgets)
  k   = multiset of overloads (legal-point counts >= 3 on those lines)
  pairwise shared LEGAL points between overloaded lines (gadget interaction).

Branch decision:
  (a) all g==1 and max k <= 4  -> prove exactly the g=1 gadget law (depth-2 a corollary)
  (b) any g>=2 or any k>=5     -> general gadget induction is mandatory (depth-2 was luck)

Also tabulates the secant/tangent/external type of each overloaded line vs the live conic
(Fable geometric handle, plan Step 1 / 4.5).

Run:   python3 rust/scripts/c528_overload_profile.py [--q 19] [--witnesses]
"""
from __future__ import annotations

import argparse
import importlib.util
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
Q19_ROWS = ROOT / "notes/data/c20-q19-states.jsonl.gz"
Q13_Q17_ROWS = ROOT / "notes/data/c20-q13-q17-states.jsonl.gz"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


GEOMETRY = load_module(ROOT / "notes/2026-07-08-zone-repair-geometry.py", "c528_geometry")
CENSUS = load_module(ROOT / "rust/scripts/c80_response_fibre_census.py", "c528_census")
C31 = GEOMETRY.load_c31_module()
C20 = C31.load_c20_module()


def overloaded_lines(game, lines, mask):
    """Return [(line_mask, overload)] for capacity-two lines carrying >=3 legal points."""
    legal = game.legal_mask(mask)
    out = []
    for line_mask, fixed_load in lines:
        if fixed_load + (mask & line_mask).bit_count() == 0:  # no selected point
            cnt = (legal & line_mask).bit_count()
            if cnt >= 3:
                out.append((line_mask, cnt))
    return out, legal


def conic_line_type(game, line_mask):
    """secant (2) / tangent (1) / external (0): live-conic points on the line."""
    return (line_mask & game.conic_mask).bit_count()


def profile_states(game, lines, masks, label):
    g_dist = Counter()
    k_dist = Counter()          # multiset of overloads as a sorted tuple
    max_k = 0
    max_g = 0
    pair_shared = Counter()     # shared legal points between two gadgets
    type_dist = Counter()       # conic type of each overloaded line
    n = 0
    for mask in masks:
        n += 1
        ovr, legal = overloaded_lines(game, lines, mask)
        g = len(ovr)
        g_dist[g] += 1
        max_g = max(max_g, g)
        ks = tuple(sorted(c for _, c in ovr))
        k_dist[ks] += 1
        if ks:
            max_k = max(max_k, ks[-1])
        for lm, _ in ovr:
            type_dist[conic_line_type(game, lm)] += 1
        for i in range(g):
            for j in range(i + 1, g):
                shared = (legal & ovr[i][0] & ovr[j][0]).bit_count()
                pair_shared[shared] += 1
    return {
        "label": label,
        "n_states": n,
        "g_distribution": dict(sorted(g_dist.items())),
        "max_g": max_g,
        "max_k": max_k,
        "k_multiset_distribution": {str(k): v for k, v in sorted(k_dist.items())},
        "pairwise_shared_legal_points": dict(sorted(pair_shared.items())),
        "overloaded_line_conic_type": {
            {0: "external", 1: "tangent", 2: "secant"}[t]: c
            for t, c in sorted(type_dist.items())
        },
    }


def find_residual_and_witnesses(game, lines, states, want_witnesses):
    from functools import lru_cache

    @lru_cache(maxsize=None)
    def full_grundy0(mask: int) -> bool:
        cells = [c for _b, c in game.iter_bits(game.legal_mask(mask))]
        nn = len(cells)
        adj = [0] * nn
        for i, z in enumerate(cells):
            after = game.legal_mask(mask | (1 << z))
            for j in range(i + 1, nn):
                if not (after & (1 << cells[j])):
                    adj[i] |= 1 << j
                    adj[j] |= 1 << i

        @lru_cache(maxsize=None)
        def gg(bits: int) -> int:
            if bits == 0:
                return 0
            opts = set()
            b = bits
            while b:
                low = b & -b
                i = low.bit_length() - 1
                opts.add(gg(bits & ~(low | adj[i])))
                b ^= low
            k = 0
            while k in opts:
                k += 1
            return k

        return gg((1 << nn) - 1) == 0

    def is_ynk(mask: int) -> bool:
        return CENSUS.node_kayles_exact(game, lines, mask) and full_grundy0(mask)

    def has_ynk_reply(mask: int) -> bool:
        return any(is_ynk(mask | (1 << p)) for p in GEOMETRY.bits(game.legal_mask(mask)))

    seen: set[int] = set()
    residual: list[int] = []
    for mask, _row in states:
        for move in GEOMETRY.bits(game.legal_mask(mask) & ~game.conic_mask):
            child = mask | (1 << move)
            if len(GEOMETRY.intruders(game, child)) != 3 or child in seen:
                continue
            seen.add(child)
            if not has_ynk_reply(child):
                residual.append(child)

    witnesses: list[int] = []
    if want_witnesses:
        for child in sorted(residual):
            for r in GEOMETRY.bits(game.legal_mask(child)):
                g_state = child | (1 << r)
                if all(
                    has_ynk_reply(g_state | (1 << o))
                    for o in GEOMETRY.bits(game.legal_mask(g_state))
                ):
                    witnesses.append(g_state)
                    break
    return residual, witnesses


import hashlib
import json

OUT = ROOT / "notes/2026-07-23-c528-overload-profile.json"
ORDERS = ((13, Q13_Q17_ROWS), (17, Q13_Q17_ROWS), (19, Q19_ROWS))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run_q(q: int, rows: Path) -> dict:
    game = C20.PrimeGridGame(q)
    lines = CENSUS.projective_lines(game)
    states, _ = C31.load_p_reply_states(rows, q)
    residual, _ = find_residual_and_witnesses(game, lines, states, False)
    prof = profile_states(game, lines, residual, "residual_children")
    prof["q"] = q
    return prof


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=OUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    sources = {}
    for _q, rows in ORDERS:
        rel = str(rows.relative_to(ROOT))
        if rel not in sources:
            sources[rel] = {"sha256": sha256(rows), "bytes": rows.stat().st_size}

    payload = {
        "task": "C528",
        "claim_scope": (
            "Overload-profile tabulation of the capOVER-core residual children (every winning "
            "reply capOVER) over the frozen q=13/17/19 three-intruder domains from the recorded "
            "C20 P reply states. Each residual child is itself capOVER (a capOK child would be "
            "static Node-Kayles and, being a responder-win, would have Grundy != 0 hence a Y_NK "
            "reply). Gadget = an overloaded capacity-two line (no selected point, >=3 legal "
            "points); g = gadget count, k = per-gadget overload."
        ),
        "verdict": (
            "BRANCH (b): the general multi-gadget induction is mandatory, sharpened -- gadget "
            "complexity is unbounded in q on BOTH axes. q13: 0 residual (Y_NK closes at depth 0). "
            "q17: 349 residual, g in 1..7, max overload k=4. q19: 48,084 residual, 100% g>=2 "
            "(mean 19.2, max g=47), max overload k=7. The plan's g=1/k<=4 special-case premise "
            "does not hold; there is no finite bounded-gadget base family to induct into."
        ),
        "sources": dict(sorted(sources.items())),
        "orders": [run_q(q, rows) for q, rows in ORDERS],
    }
    rendered = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.check:
        assert args.output.read_text() == rendered, "C528 overload profile: MISMATCH"
        print("C528 overload-profile tabulation: PASS")
    else:
        args.output.write_text(rendered)
        print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
