#!/usr/bin/env python3
"""C528 (cap) audit: does the q17 "132/132 literal copycat" positive survive the legal-reply H?

The C528 pairing probe (c528_pairing_probe.py) and the overload report headline that on the
even-|O| q17 residual capOVER-core the depth-2 win literally IS a copycat involution -- a perfect
matching in H = (legal(G), {o,p} : is_ynk(G|o|p)) exists for all 132 even-|O| first-witnesses
(132/132, "parity-clean"). That H omits the legal-reply check: is_ynk = capOK & Grundy0 does not
reject a non-cap mask, so an edge {o,p} can pair o with a p that is NOT a legal reply to o.

This audit recomputes, for each q17 residual child's FIRST valid depth-2 witness, the perfect
matching under BOTH the loose H (is_ynk only, pairing-probe convention) and the correct legal-reply
H (edge additionally requires p legal after o). The gap is the inflation.

Run:  uv run --with networkx python3 rust/scripts/c528_q17_legal_h_audit.py [--check]
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from functools import lru_cache
from pathlib import Path

import networkx as nx

ROOT = Path(__file__).resolve().parents[2]
ROWS = ROOT / "notes/data/c20-q13-q17-states.jsonl.gz"
OUT = ROOT / "notes/2026-07-23-c528-q17-legal-h-audit.json"


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


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run() -> dict:
    q = 17
    game = C20.PrimeGridGame(q)
    lines = CENSUS.projective_lines(game)
    states, _ = C31.load_p_reply_states(ROWS, q)

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

    @lru_cache(maxsize=None)
    def is_ynk(mask: int) -> bool:
        return CENSUS.node_kayles_exact(game, lines, mask) and full_grundy0(mask)

    def has_ynk_reply(mask: int) -> bool:
        return any(is_ynk(mask | (1 << p)) for p in GEOMETRY.bits(game.legal_mask(mask)))

    def matches(gstate: int, legal: bool) -> bool:
        O = list(GEOMETRY.bits(game.legal_mask(gstate)))
        if len(O) % 2 == 1:
            return False
        H = nx.Graph()
        H.add_nodes_from(O)
        for i, o in enumerate(O):
            after_o = game.legal_mask(gstate | (1 << o)) if legal else 0
            for p in O[i + 1:]:
                if (not legal or (after_o >> p) & 1) and is_ynk(gstate | (1 << o) | (1 << p)):
                    H.add_edge(o, p)
        return 2 * len(nx.max_weight_matching(H, maxcardinality=True)) == len(O)

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

    loose = legal = both = loose_only = even = 0
    for child in residual:
        gstate = None
        for r in GEOMETRY.bits(game.legal_mask(child)):
            g = child | (1 << r)
            if all(has_ynk_reply(g | (1 << o)) for o in GEOMETRY.bits(game.legal_mask(g))):
                gstate = g
                break
        if gstate is None:
            continue
        if len(list(GEOMETRY.bits(game.legal_mask(gstate)))) % 2 == 0:
            even += 1
        L = matches(gstate, False)
        Lg = matches(gstate, True)
        loose += L
        legal += Lg
        both += L and Lg
        loose_only += L and not Lg

    return {
        "q": q,
        "rows": str(ROWS.relative_to(ROOT)),
        "residual_children": len(residual),
        "even_O_first_witnesses": even,
        "first_witness_matched_loose_H": loose,
        "first_witness_matched_legal_H": legal,
        "matched_both": both,
        "matched_loose_only_inflated": loose_only,
        "legal_H_parity_clean": legal == even,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=OUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    payload = {
        "task": "C528",
        "claim_scope": (
            "q17 residual capOVER-core, first valid depth-2 witness per child. Compares the "
            "single-level copycat perfect-matching count under the loose pairing-probe H "
            "(is_ynk only) vs the correct legal-reply H (edge {o,p} additionally requires p a "
            "legal reply to o). matched_loose_only_inflated counts witnesses matchable ONLY via "
            "illegal-reply edges. legal_H_parity_clean flags whether the correct H still matches "
            "EXACTLY the even-|O| witnesses (the pairing report's 132/132 'parity-clean' claim)."
        ),
        "verdict": (
            "The loose H reports 132 matched even-|O| witnesses ('132/132 literal copycat'), but "
            "the legal-reply H matches only 126: 6 are inflated (matchable only via illegal-reply "
            "edges). So legal_H_parity_clean is FALSE -- the clean copycat law breaks already at "
            "q17, not only at q19. The pairing probe's NEGATIVE counts (failures) are unaffected "
            "(loose H has a superset of edges, so no-matching-under-loose => no-matching-under-"
            "legal); only its POSITIVE matched counts were inflated."
        ),
        "sources": {str(ROWS.relative_to(ROOT)): {"sha256": sha256(ROWS), "bytes": ROWS.stat().st_size}},
        "order": run(),
    }
    rendered = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.check:
        assert args.output.read_text() == rendered, "C528 q17 legal-H audit: MISMATCH"
        print("C528 q17 legal-H audit: PASS")
    else:
        args.output.write_text(rendered)
        print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
