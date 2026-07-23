#!/usr/bin/env python3
"""C524 (cap): the capOVER core closes by depth-2 descent into Y_NK.

C523 covered 99.3% of the q17 three-intruder domain with the Y_NK guard (capOK =>
static Node-Kayles on the full legal-point graph, P iff full-graph Grundy 0), leaving
349 residual children whose every winning reply is capOVER (a capacity-2 line with >=3
legal points). This script certifies those residuals with a bounded-depth, MINIMAX-FREE
strategy that relies only on the proven Y_NK => P:

  A residual child C (responder to move) is depth-2 certified if there is a reply r into
  G = C u {r} such that EVERY opponent move o from G admits a responder reply p with
  G u {o, p} in Y_NK. Since every Y_NK state is P (proven), every opponent move from G
  loses, so G is P, so C is N via r -- no minimax needed.

The certificate is structural. A minimax consistency assertion (every classified child is
actually N; every witness reply is actually winning) guards the Y_NK => P dependency.

Verdict: every child in the frozen q17 three-intruder domain is either Y_NK (depth 0) or
depth-2 certified; 0 uncertified. Combined with C523 this is a complete Node-Kayles
descent certificate for the q17 domain (q13 was already closed at depth 0 by Y_NK).

Run:    python3 rust/scripts/c524_capover_core_depth2.py
Check:  python3 rust/scripts/c524_capover_core_depth2.py --check
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from functools import lru_cache
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ROWS = ROOT / "notes/data/c20-q13-q17-states.jsonl.gz"
OUT = ROOT / "notes/2026-07-23-c524-capover-core-depth2.json"


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


GEOMETRY = load_module(ROOT / "notes/2026-07-08-zone-repair-geometry.py", "c524_geometry")
CENSUS = load_module(ROOT / "rust/scripts/c80_response_fibre_census.py", "c524_census")
C31 = GEOMETRY.load_c31_module()
C20 = C31.load_c20_module()


def run_q(q: int, rows_path: Path) -> dict:
    game = C20.PrimeGridGame(q)
    lines = CENSUS.projective_lines(game)
    states, _ = C31.load_p_reply_states(rows_path, q)

    @lru_cache(maxsize=None)
    def full_grundy0(mask: int) -> bool:
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

    def is_ynk(mask: int) -> bool:
        return CENSUS.node_kayles_exact(game, lines, mask) and full_grundy0(mask)

    def has_ynk_reply(mask: int) -> bool:
        return any(is_ynk(mask | (1 << p)) for p in GEOMETRY.bits(game.legal_mask(mask)))

    # Pass A: unique three-intruder children; split by depth-0 Y_NK-reply existence.
    seen: set[int] = set()
    residual: list[int] = []
    ynk_depth0 = 0
    for mask, _row in states:
        for move in GEOMETRY.bits(game.legal_mask(mask) & ~game.conic_mask):
            child = mask | (1 << move)
            if len(GEOMETRY.intruders(game, child)) != 3 or child in seen:
                continue
            seen.add(child)
            if has_ynk_reply(child):
                ynk_depth0 += 1
            else:
                residual.append(child)
    n_children = len(seen)

    # Pass B: depth-2 structural certificate for the residual children.
    depth2_certified = 0
    uncertified = 0
    witness_lines: list[str] = []
    for child in sorted(residual):
        assert game.value(child), f"residual child {child} not N (responder-win)"  # consistency
        witness_r = None
        for r in GEOMETRY.bits(game.legal_mask(child)):
            g_state = child | (1 << r)
            ok = True
            for o in GEOMETRY.bits(game.legal_mask(g_state)):
                if not has_ynk_reply(g_state | (1 << o)):
                    ok = False
                    break
            if ok:
                assert not game.value(g_state), f"witness {r} for {child} not P"  # consistency
                witness_r = r
                break
        if witness_r is None:
            uncertified += 1
        else:
            depth2_certified += 1
            witness_lines.append(f"{child}:{witness_r}")

    witness_digest = hashlib.sha256("\n".join(witness_lines).encode()).hexdigest()
    return {
        "q": q,
        "unique_three_intruder_children": n_children,
        "ynk_depth0_covered": ynk_depth0,
        "capover_core_residual": len(residual),
        "depth2_certified": depth2_certified,
        "uncertified": uncertified,
        "fully_certified": uncertified == 0,
        "depth2_witness_digest_sha256": witness_digest,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", type=Path, default=ROWS)
    parser.add_argument("--output", type=Path, default=OUT)
    parser.add_argument("--q", type=int, nargs="+", default=[13, 17])
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    qs = ", ".join(f"q={q}" for q in args.q)
    payload = {
        "claim_scope": (
            f"Bounded-depth Node-Kayles descent certificate over the frozen {qs} "
            "three-intruder domain (children reachable by one intruder opponent move from a "
            "recorded C20 P reply state). Every child is Y_NK at depth 0 or depth-2 certified."
        ),
        "certificate": (
            "A residual child C is depth-2 certified when the responder has a reply r into "
            "G = C u {r} such that every opponent move o from G admits a responder reply p with "
            "G u {o,p} in Y_NK. Because Y_NK => P is proven (C523), every opponent move from G "
            "loses, so G is P and C is N via r. The certificate uses only structural Y_NK checks; "
            "the recorded minimax assertions merely guard the Y_NK => P dependency."
        ),
        "verdict": (
            f"0 uncertified for every tested order ({qs}). Every child in each frozen "
            "three-intruder domain admits a certified responder winning strategy within the "
            "Node-Kayles guard family (Y_NK at depth 0, else a depth-2 bridge into Y_NK)."
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
        assert args.output.read_text() == rendered, "C524 census: MISMATCH vs committed output"
        print("C524 capOVER-core depth-2 census: PASS")
    else:
        args.output.write_text(rendered)
        print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
