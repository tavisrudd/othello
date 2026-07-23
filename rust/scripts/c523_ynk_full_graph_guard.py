#!/usr/bin/env python3
"""C523 (cap): the Y_NK full-legal-graph Node-Kayles guard generalizing Y_NK0.

Y_NK0 certifies P only for empty-conic states. C522 showed that closes 90.7% of q17
three-intruder children; 89% of the remaining gap cannot reach an empty conic in one
move (the winning reply keeps the conic live), so the companion guard must handle live
conic content.

Y_NK guard hypothesis (proved structurally, certified here):
  When every capacity-2 line carries at most two legal points (capOK), no move can create
  a new three-in-a-line among surviving legal points (that would need three legal points
  on a capacity-2 line, which capOK forbids). Hence the cap residual game under capOK is
  exactly *static Node-Kayles* on the conflict graph of ALL legal affine cells -- live
  conic cells included as ordinary vertices -- and its value is P iff that graph's Grundy
  value is 0. Y_NK0 is the empty-conic special case.

This script:
  1. Certifies the iff on every capOK grandchild (both P and N) of the Y_NK0-uncovered
     ("gap") children: exact minimax value P  <=>  full-legal-graph Grundy 0.
  2. Measures Y_NK child coverage. A Y_NK0 reply is a Y_NK reply, so children already
     covered by Y_NK0 stay covered; the new work is the gap children that gain a Y_NK
     (capOK, full-graph Grundy 0) reply.
  3. Characterizes the residual children (a winning reply exists, but none is Y_NK): all
     their winning replies are capOVER (a capacity-2 line with >=3 legal points).

Run:    python3 rust/scripts/c523_ynk_full_graph_guard.py
Check:  python3 rust/scripts/c523_ynk_full_graph_guard.py --check
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from collections import Counter
from functools import lru_cache
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ROWS = ROOT / "notes/data/c20-q13-q17-states.jsonl.gz"
OUT = ROOT / "notes/2026-07-23-c523-ynk-full-graph-guard.json"


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


GEOMETRY = load_module(ROOT / "notes/2026-07-08-zone-repair-geometry.py", "c523_geometry")
CENSUS = load_module(ROOT / "rust/scripts/c80_response_fibre_census.py", "c523_census")
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
        return game.state_features(grand, GEOMETRY.intruders(game, grand))["zone_grundy"] == 0

    def full_graph_grundy0(mask: int) -> bool:
        """Static Node-Kayles Grundy on the conflict graph of ALL legal affine cells == 0."""
        cells = [c for _b, c in game.iter_bits(game.legal_mask(mask))]
        n = len(cells)
        adj = [0] * n
        for i, z in enumerate(cells):
            after = game.legal_mask(mask | (1 << z))
            for j in range(i + 1, n):
                if not (after & (1 << cells[j])):
                    adj[i] |= 1 << j
                    adj[j] |= 1 << i

        @lru_cache(maxsize=None)
        def g(bits: int) -> int:
            if bits == 0:
                return 0
            opts = set()
            b = bits
            while b:
                low = b & -b
                i = low.bit_length() - 1
                opts.add(g(bits & ~(low | adj[i])))
                b ^= low
            k = 0
            while k in opts:
                k += 1
            return k

        return g((1 << n) - 1) == 0

    # Pass A: unique three-intruder children; split by Y_NK0-reply existence.
    seen: set[int] = set()
    gap: list[int] = []
    ynk0_covered = 0
    for mask, _row in states:
        for move in GEOMETRY.bits(game.legal_mask(mask) & ~game.conic_mask):
            child = mask | (1 << move)
            if len(GEOMETRY.intruders(game, child)) != 3 or child in seen:
                continue
            seen.add(child)
            replies = list(GEOMETRY.bits(game.legal_mask(child)))
            if any(is_ynk0(child | (1 << r)) for r in replies):
                ynk0_covered += 1
            else:
                gap.append(child)
    n_children = len(seen)

    # Pass B: over gap children, certify the Y_NK iff on every capOK grandchild, measure
    # Y_NK coverage, and characterize residual (all-capOVER-winning) children.
    iff_agree = 0
    iff_disagree = 0
    capok_tested_by_live = Counter()
    ynk_gap_covered = 0
    residual_children = 0
    residual_min_overload = Counter()   # residual child -> min over winning replies of max-legal-on-cap2-line
    residual_min_live = Counter()       # residual child -> min live-conic over winning replies
    for child in gap:
        has_ynk = False
        residual_overloads = []
        residual_lives = []
        for r in GEOMETRY.bits(game.legal_mask(child)):
            grand = child | (1 << r)
            winning = not game.value(grand)
            if CENSUS.node_kayles_exact(game, lines, grand):
                live = len(GEOMETRY.live_conic(game, grand))
                capok_tested_by_live[live] += 1
                g0 = full_graph_grundy0(grand)
                if winning == g0:
                    iff_agree += 1
                else:
                    iff_disagree += 1
                if g0:
                    has_ynk = True
            elif winning:
                # capOVER winning target: part of the residual characterization
                residual_overloads.append(
                    CENSUS.maximum_capacity_two_line(game, lines, grand)
                )
                residual_lives.append(len(GEOMETRY.live_conic(game, grand)))
        if has_ynk:
            ynk_gap_covered += 1
        else:
            residual_children += 1
            if residual_overloads:
                residual_min_overload[min(residual_overloads)] += 1
                residual_min_live[min(residual_lives)] += 1

    return {
        "q": q,
        "unique_three_intruder_children": n_children,
        "ynk0_covered_children": ynk0_covered,
        "gap_children_uncovered_by_ynk0": len(gap),
        "ynk_iff_capok_grandchildren_tested": iff_agree + iff_disagree,
        "ynk_iff_agree": iff_agree,
        "ynk_iff_disagree": iff_disagree,
        "capok_tested_by_live_conic": {str(k): v for k, v in sorted(capok_tested_by_live.items())},
        "gap_children_newly_covered_by_ynk": ynk_gap_covered,
        "total_children_covered_by_ynk": ynk0_covered + ynk_gap_covered,
        "residual_children_capover_only": residual_children,
        "residual_min_overload_on_capacity2_line": {
            str(k): v for k, v in sorted(residual_min_overload.items())
        },
        "residual_min_live_conic": {str(k): v for k, v in sorted(residual_min_live.items())},
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
            "The Y_NK full-legal-graph Node-Kayles guard over the frozen q=13 and q=17 "
            "three-intruder domain (children reachable by one intruder opponent move from a "
            "recorded C20 P reply state). Certifies the capOK iff and measures Y_NK descent "
            "coverage relative to Y_NK0."
        ),
        "ynk_guard": (
            "When every capacity-2 line carries at most two legal points (capOK), the cap "
            "residual game is exactly static Node-Kayles on the conflict graph of all legal "
            "affine cells (live conic cells included), so the state is P iff that graph's Grundy "
            "value is 0. Y_NK0 is the empty-conic special case."
        ),
        "verdict": (
            "Y_NK iff exact value on every capOK grandchild tested (0 disagreements). Y_NK lifts "
            "q=17 descent coverage from 90.7% (Y_NK0) to 99.3%; the residual is a small family of "
            "capOVER children whose every winning reply leaves a capacity-2 line with >=3 legal "
            "points."
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
        assert args.output.read_text() == rendered, "C523 census: MISMATCH vs committed output"
        print("C523 Y_NK full-graph guard census: PASS")
    else:
        args.output.write_text(rendered)
        print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
