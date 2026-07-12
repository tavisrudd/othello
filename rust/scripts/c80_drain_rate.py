#!/usr/bin/env python3
"""C80(c): exhaustive verification of the drain-rate lemma and exchange equality.

Drain-rate lemma. For a legal residual position S with off-conic intruders I(S)
and live conic params L(S), and any live conic point t, the map x -> sigma_x(t)
is injective on the active intruders {x in I(S): sigma_x(t) != t, sigma_x(t) in
L(S)}. (Proof: a coincidence sigma_x(t)=sigma_y(t)=t' puts x,y both on the
secant P_t P_t', saturating it, so P_t is illegal and t is not live.)

Exchange equality. Selecting a live conic point t deletes exactly 1 + k_t(S)
live conic points, where k_t(S) = #{x in I(S): sigma_x(t) != t, sigma_x(t) in
L(S)}. This gives |live conic| as a well-founded descent measure with an exact,
bulk-free drain rate.

This script BFS-enumerates legal positions up to a size cap and checks both
statements exhaustively, plus the C79 overlap lemma (matching overlap in {0,1}),
and reports the k_t (active-intruder-per-live-point) distribution and the
per-conic-move drain distribution.

Usage:  c80_drain_rate.py [q ...] [--maxsize N]
"""
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
    parser.add_argument("q", nargs="*", type=int, default=[11, 13])
    parser.add_argument("--maxsize", type=int, default=6,
                        help="cap on residual position size to enumerate")
    args = parser.parse_args()

    notes = Path(__file__).resolve().parents[2] / "notes"
    c20 = load_module(notes / "2026-07-08-intrusion-census.py", "c80_c20")

    for q in args.q:
        game = c20.PrimeGridGame(q)
        conic_cells = set(game.conic_cell.values())
        # precompute sigma perms for every off-conic cell
        sigma = {}
        for c in range(q * q):
            if c not in game.cell_param:
                sigma[c] = game.sigma_perm(c)

        # BFS over legal positions up to maxsize (dedup by mask)
        seen = {0}
        frontier = [0]
        positions = [0]
        while frontier:
            nxt = []
            for mask in frontier:
                if bin(mask).count("1") >= args.maxsize:
                    continue
                moves = game.legal_mask(mask)
                m = moves
                while m:
                    bit = m & -m
                    m ^= bit
                    child = mask | bit
                    if child not in seen:
                        seen.add(child)
                        positions.append(child)
                        nxt.append(child)
            frontier = nxt

        inj_fail = 0
        exch_fail = 0
        overlap_fail = 0
        kt_dist = Counter()
        drain_dist = Counter()
        checked_positions = 0
        checked_live_pts = 0
        checked_conic_moves = 0

        for mask in positions:
            legal = game.legal_mask(mask)
            live = {t: cc for t, cc in game.conic_cell.items() if legal & (1 << cc)}
            if not live:
                continue
            intr = [c for c in range(q * q)
                    if (mask >> c) & 1 and c not in game.cell_param]
            if not intr:
                continue
            checked_positions += 1

            # overlap lemma: any two intruders share <=1 conic edge
            for i in range(len(intr)):
                pi = sigma[intr[i]]
                for j in range(i + 1, len(intr)):
                    pj = sigma[intr[j]]
                    shared = sum(1 for t in game.params
                                 if pi[t] == pj[t] and pi[t] != t)
                    assert shared % 2 == 0
                    if shared // 2 > 1:
                        overlap_fail += 1

            for t, cc_t in live.items():
                checked_live_pts += 1
                partners = []
                for x in intr:
                    u = sigma[x][t]
                    if u != t and u in live:
                        partners.append(u)
                kt = len(partners)
                kt_dist[kt] += 1
                if len(set(partners)) != kt:
                    inj_fail += 1
                # exchange equality: select t, count live-conic drop
                child = mask | (1 << cc_t)
                clegal = game.legal_mask(child)
                live_after = sum(1 for cc in game.conic_cell.values()
                                 if clegal & (1 << cc))
                drop = len(live) - live_after
                drain_dist[drop] += 1
                checked_conic_moves += 1
                if drop != 1 + kt:
                    exch_fail += 1

        print(
            f"C80-DRAIN q={q} maxsize={args.maxsize} positions_enum={len(positions)} "
            f"checked_positions={checked_positions} live_pts={checked_live_pts} "
            f"conic_moves={checked_conic_moves} "
            f"injectivity_failures={inj_fail} exchange_failures={exch_fail} "
            f"overlap_failures={overlap_fail} "
            f"kt_active_per_live_pt={dict(sorted(kt_dist.items()))} "
            f"drain_per_conic_move={dict(sorted(drain_dist.items()))}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
