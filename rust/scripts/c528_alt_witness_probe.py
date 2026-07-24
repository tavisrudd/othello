#!/usr/bin/env python3
"""C528 (cap) probe: does an ALTERNATIVE depth-2 witness restore a pairing for the q19 failures?

The C528 pairing probe (c528_pairing_probe.py) found that at q19, 1,104 even-|O| residual
capOVER-core children have NO single-level perfect matching on their FIRST depth-2 witness
r0 (the copycat-involution reframe breaks at q19). That probe is explicitly witness-choice
dependent: a non-matchable first witness does not preclude a matchable ALTERNATIVE witness.

This probe closes that caveat. For each residual child C (responder to move) whose first
witness fails to admit a perfect matching (the 1,104 q19 failures), enumerate ALL legal
responder moves r, form G = C u {r}, and test whether the legal-reply pairing graph
    H = (legal(G), {o,p} : p a legal reply to o AND G u {o,p} in Y_NK)
has a perfect matching. A perfect matching in H is a fixed-point-free involution of legal
replies answering every opponent move o into a Y_NK(=P) state -- and it automatically
certifies G as a valid depth-2 witness (every opponent move is answerable by its matched
legal reply). So any matchable G is an alternative depth-2 witness with a one-level copycat.

The legal-reply check on edges is load-bearing: is_ynk = capOK & Grundy0 does not reject a
non-cap mask, so the pairing probe's H (is_ynk only) over-counts matchings via illegal-reply
edges. This probe reproduces the pairing-probe failure set with that loose H (cross-check),
but decides restored/failing with the rigorous legal-reply H.

Verdict interpretation:
  all 1,104 restored  => the pairing route survives as a WITNESS-SELECTION lemma (some
                         depth-2 witness always admits a single-level copycat).
  some not restored   => single-level copycat is genuinely insufficient at q19; the route
                         needs multi-level (persistent) copycat or is dead.

Run:  uv run --with networkx python3 rust/scripts/c528_alt_witness_probe.py [--check]
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

import networkx as nx

ROOT = Path(__file__).resolve().parents[2]
Q13_Q17_ROWS = ROOT / "notes/data/c20-q13-q17-states.jsonl.gz"
Q19_ROWS = ROOT / "notes/data/c20-q19-states.jsonl.gz"
OUT = ROOT / "notes/2026-07-23-c528-alt-witness-probe.json"


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

    @lru_cache(maxsize=None)
    def is_ynk(mask: int) -> bool:
        return CENSUS.node_kayles_exact(game, lines, mask) and full_grundy0(mask)

    def has_ynk_reply(mask: int) -> bool:
        return any(is_ynk(mask | (1 << p)) for p in GEOMETRY.bits(game.legal_mask(mask)))

    def perfect_matching_loose(gstate: int) -> tuple[bool, int]:
        """Pairing-probe H VERBATIM: edge {o,p} iff is_ynk(G|o|p), no legality check on the
        response. Used ONLY to reproduce the pairing probe's first-witness failure set (1,104
        at q19), so this run cross-validates that certificate."""
        O = list(GEOMETRY.bits(game.legal_mask(gstate)))
        if len(O) % 2 == 1:
            return False, len(O)
        H = nx.Graph()
        H.add_nodes_from(O)
        for i, o in enumerate(O):
            for p in O[i + 1:]:
                if is_ynk(gstate | (1 << o) | (1 << p)):
                    H.add_edge(o, p)
        m = nx.max_weight_matching(H, maxcardinality=True)
        return 2 * len(m) == len(O), len(O)

    def perfect_matching_legal(gstate: int) -> tuple[bool, int]:
        """Rigorous copycat H: edge {o,p} iff p is a LEGAL reply to o (p in legal(G|o), which
        is symmetric: G|o|p is a legal cap <=> p legal after o <=> o legal after p) AND
        is_ynk(G|o|p). A perfect matching is then a genuine fixed-point-free involution of
        legal replies answering every opponent move into Y_NK -- and it automatically certifies
        G as a valid depth-2 witness (every o has its matched legal reply). This is the correct
        single-level copycat test; the loose H above over-counts by admitting illegal-reply
        edges (is_ynk does not reject a non-cap mask)."""
        O = list(GEOMETRY.bits(game.legal_mask(gstate)))
        if len(O) % 2 == 1:
            return False, len(O)
        H = nx.Graph()
        H.add_nodes_from(O)
        for i, o in enumerate(O):
            after_o = game.legal_mask(gstate | (1 << o))
            for p in O[i + 1:]:
                if (after_o >> p) & 1 and is_ynk(gstate | (1 << o) | (1 << p)):
                    H.add_edge(o, p)
        m = nx.max_weight_matching(H, maxcardinality=True)
        return 2 * len(m) == len(O), len(O)

    # Rebuild the residual capOVER-core children exactly as the pairing probe does.
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

    # First-witness pass (reproduce the pairing probe's failure set): even-|O| children with
    # no perfect matching on the FIRST depth-2 witness r0.
    failures: list[int] = []
    first_witness_matched = 0
    first_witness_no_witness = 0
    for child in residual:
        gstate = None
        for r in GEOMETRY.bits(game.legal_mask(child)):
            g = child | (1 << r)
            if all(has_ynk_reply(g | (1 << o)) for o in GEOMETRY.bits(game.legal_mask(g))):
                gstate = g
                break
        if gstate is None:
            first_witness_no_witness += 1
            continue
        ok, o_len = perfect_matching_loose(gstate)
        if ok:
            first_witness_matched += 1
        elif o_len % 2 == 0:
            failures.append(child)

    # Alternative-witness search over the failure set, using the RIGOROUS legal-reply H. For
    # each failure child, walk ALL legal responder moves r (any r whose G admits a perfect
    # matching in the legal-reply H is, by construction, a valid depth-2 witness with a genuine
    # single-level copycat). Restored iff some r works.
    restored = 0
    still_failing: list[int] = []
    restoring_o_sizes = Counter()
    restoring_witness_index = Counter()   # 1-indexed legal-move index of the restoring witness
    for child in failures:
        found = False
        idx = 0
        for r in GEOMETRY.bits(game.legal_mask(child)):
            idx += 1
            gstate = child | (1 << r)
            ok, o_len = perfect_matching_legal(gstate)
            if ok:
                found = True
                restored += 1
                restoring_o_sizes[o_len] += 1
                restoring_witness_index[idx] += 1
                break
        if not found:
            still_failing.append(child)

    return {
        "q": args_q,
        "rows": str(rows.relative_to(ROOT)),
        "residual_children": len(residual),
        "first_witness_matched": first_witness_matched,
        "first_witness_no_witness": first_witness_no_witness,
        "first_witness_even_failures": len(failures),
        "alt_witness_restored": restored,
        "alt_witness_still_failing": len(still_failing),
        "all_failures_restored": len(still_failing) == 0,
        "restoring_witness_O_size_distribution": {
            str(k): v for k, v in sorted(restoring_o_sizes.items())
        },
        "restoring_witness_legal_index_distribution": {
            str(k): v for k, v in sorted(restoring_witness_index.items())
        },
        "still_failing_children": still_failing[:64],
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--q", type=int, nargs="+", default=[19])
    parser.add_argument("--output", type=Path, default=OUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    orders = [run_q(q) for q in args.q]
    sources = {}
    for q in args.q:
        rows = Q19_ROWS if q == 19 else Q13_Q17_ROWS
        rel = str(rows.relative_to(ROOT))
        if rel not in sources:
            sources[rel] = {"sha256": sha256(rows), "bytes": rows.stat().st_size}

    payload = {
        "task": "C528",
        "claim_scope": (
            "Alternative-witness de-risking probe on the 1,104 q19 pairing-probe failures "
            "(even-|O| residual capOVER-core children with no single-level perfect matching on "
            "their FIRST depth-2 witness; this run reproduces that failure set with the "
            "pairing-probe H VERBATIM as a cross-check). For each failure child C, walk ALL "
            "legal responder moves r and test the RIGOROUS legal-reply H = (legal(G), {o,p} : "
            "p legal reply to o AND G u {o,p} in Y_NK), G = C u {r}, for a perfect matching. A "
            "perfect matching in this H is a genuine fixed-point-free copycat involution of "
            "legal replies answering every opponent move into Y_NK, and it automatically "
            "certifies G as a valid depth-2 witness. NOTE: the pairing-probe H omits the "
            "legal-reply check and so admits illegal-reply edges (is_ynk = capOK & Grundy0 does "
            "not reject a non-cap mask); the legal-reply H is the correct single-level copycat "
            "test and is the sole basis for the restored/still_failing verdict below."
        ),
        "verdict": (
            "all_failures_restored=true would mean every q19 first-witness failure admits an "
            "ALTERNATIVE depth-2 witness with a genuine single-level legal-reply copycat -- the "
            "pairing route would survive as a cheap WITNESS-SELECTION lemma. all_failures_"
            "restored=false (alt_witness_still_failing>0) means single-level copycat is "
            "genuinely insufficient at q19 even after searching every alternative witness: the "
            "route needs a multi-level (persistent) copycat argument, or is dead as a cheap win."
        ),
        "sources": dict(sorted(sources.items())),
        "orders": orders,
    }
    rendered = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.check:
        assert args.output.read_text() == rendered, "C528 alt-witness probe: MISMATCH"
        print("C528 alt-witness probe: PASS")
    else:
        args.output.write_text(rendered)
        print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
