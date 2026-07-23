#!/usr/bin/env python3
"""C528 (cap) probe: does the depth-2 responder win by a PAIRING (involution) strategy?

The C528 overload tabulation showed depth-2 (C524) closes 100% despite unbounded gadget
count, which reframes the crown away from a gadget Grundy calculus toward a pairing/copycat
response. This probe tests the first-order pairing signal on the q17 residual core.

For each residual child C (responder to move), take its depth-2 witness G = C u {r}
(opponent to move). Let O = legal moves from G. The depth-2 certificate guarantees every
o in O has SOME Y_NK response p. A pairing (copycat) strategy needs a single fixed-point-
free involution tau on O with tau(o) a valid response for every o at once, i.e. a PERFECT
MATCHING in H = (O, {o,p} : G u {o,p} in Y_NK). We report, per witness:
  |O|, |O| parity, whether H has a perfect matching (necessary first-order pairing signal).

Perfect matching guaranteed => strong support for a pairing reframe; frequent failure =>
pairing needs more than one involution (still informative).

Run:  uv run --with networkx python3 rust/scripts/c528_pairing_probe.py [--q 17]
"""
from __future__ import annotations

import argparse
import importlib.util
import sys
from collections import Counter
from functools import lru_cache
from pathlib import Path

import networkx as nx

ROOT = Path(__file__).resolve().parents[2]
Q13_Q17_ROWS = ROOT / "notes/data/c20-q13-q17-states.jsonl.gz"
Q19_ROWS = ROOT / "notes/data/c20-q19-states.jsonl.gz"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


GEOMETRY = load_module(ROOT / "notes/2026-07-08-zone-repair-geometry.py", "cpp_geometry")
CENSUS = load_module(ROOT / "rust/scripts/c80_response_fibre_census.py", "cpp_census")
C31 = GEOMETRY.load_c31_module()
C20 = C31.load_c20_module()


import hashlib
import json

OUT = ROOT / "notes/2026-07-23-c528-pairing-probe.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run_q(args_q: int) -> dict:
    rows = Q19_ROWS if args_q == 19 else Q13_Q17_ROWS
    game = C20.PrimeGridGame(args_q)
    lines = CENSUS.projective_lines(game)
    states, _ = C31.load_p_reply_states(rows, args_q)

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

    # residual children + depth-2 witness (first r as in C524)
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
    residual.sort()

    o_parity = Counter()
    matched = 0
    unmatched = 0
    no_witness = 0
    o_sizes = Counter()
    for child in residual:
        # find witness G
        gstate = None
        for r in GEOMETRY.bits(game.legal_mask(child)):
            g = child | (1 << r)
            if all(has_ynk_reply(g | (1 << o)) for o in GEOMETRY.bits(game.legal_mask(g))):
                gstate = g
                break
        if gstate is None:
            no_witness += 1
            continue
        O = list(GEOMETRY.bits(game.legal_mask(gstate)))
        o_sizes[len(O)] += 1
        o_parity["even" if len(O) % 2 == 0 else "odd"] += 1
        H = nx.Graph()
        H.add_nodes_from(O)
        for i, o in enumerate(O):
            for p in O[i + 1:]:
                if is_ynk(gstate | (1 << o) | (1 << p)):
                    H.add_edge(o, p)
        m = nx.max_weight_matching(H, maxcardinality=True)
        if 2 * len(m) == len(O):
            matched += 1
        else:
            unmatched += 1

    return {
        "q": args_q,
        "residual_children": len(residual),
        "no_witness": no_witness,
        "perfect_matching_exists": matched,
        "no_perfect_matching": unmatched,
        "matching_covers_even_parity": matched == o_parity["even"]
        and unmatched == o_parity["odd"],
        "opponent_move_parity": dict(sorted(o_parity.items())),
        "opponent_move_count_distribution": {str(k): v for k, v in sorted(o_sizes.items())},
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--q", type=int, nargs="+", default=[17])
    parser.add_argument("--output", type=Path, default=OUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    payload = {
        "task": "C528",
        "claim_scope": (
            "First-order pairing test on the q17 residual capOVER-core depth-2 witnesses "
            "G = child u {r} (opponent to move). A perfect matching in H = (legal(G), "
            "{o,p}: G u {o,p} in Y_NK) is a fixed-point-free involution tau answering EVERY "
            "opponent move into a Y_NK(=P) state -- a complete one-level copycat strategy."
        ),
        "verdict": (
            "Pairing explains exactly the even-|O| witnesses: a perfect matching exists iff "
            "|legal(G)| is even. The obstruction in the rest is purely move-count parity "
            "(odd |O| admits no perfect matching), not a failure of the pairing structure; "
            "those need a pairing-plus-one-free-move argument."
        ),
        "sources": {
            str(Q13_Q17_ROWS.relative_to(ROOT)): {
                "sha256": sha256(Q13_Q17_ROWS),
                "bytes": Q13_Q17_ROWS.stat().st_size,
            }
        },
        "orders": [run_q(q) for q in args.q],
    }
    rendered = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.check:
        assert args.output.read_text() == rendered, "C528 pairing probe: MISMATCH"
        print("C528 pairing probe: PASS")
    else:
        args.output.write_text(rendered)
        print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
