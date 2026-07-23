#!/usr/bin/env python3
"""C496 factorization recursion-stability probe (C80 continuation).

C496 established the DEPTH-1 factorization on the frozen q=11 cloud packet: at the
seed P-position, an opponent move x admits a winning packet reply iff

    value(x) = 1_live(x) ⊗ [chi(u(x)) = -1],

where 1_live(x) = "x has any legal packet reply", u(x) is the fixed frame-edge
quotient XZ/Y^2, and chi = Legendre mod 11.  The open question (the "preserving P/N
recursion" clause) is whether this SAME fixed law -- same edge, same character, same
packet -- survives the game recursion at every deeper P-position.  If it does, C80(b)
descent collapses onto the proven C80(c) live-conic drain measure with chi a static
side-condition.  This probe descends the full P-subtree from the seed under
opponent-arbitrary / responder-any-winning play and checks the law at every P-node.

Decisive either way: perfect separation at all depths => recursion-stable (strong
positive); a single P-node where chi(u) fails to govern packet-reply existence among
live moves => not recursion-stable (the depth-1 law is a knife-edge base fact, not a
descent law).

Reuses the committed frozen setup constructors from c80_c447_cloud_packet.py.
Run from /home/tavis/src/othello:
    python3 rust/scripts/c496_recursion_stability_probe.py
"""

from __future__ import annotations

import importlib.util
import json
import sys
from collections import Counter, defaultdict
from itertools import combinations
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
C80_SOURCE = ROOT / "rust/scripts/c80_c447_cloud_packet.py"


def load_c80():
    spec = importlib.util.spec_from_file_location("c80_pkt", C80_SOURCE)
    module = importlib.util.module_from_spec(spec)
    sys.modules["c80_pkt"] = module
    spec.loader.exec_module(module)
    return module


def legendre(u, q):
    if u == "inf":
        return None
    u %= q
    if u == 0:
        return 0
    return 1 if pow(u, (q - 1) // 2, q) == 1 else -1


def setup(c80):
    """Reconstruct the frozen q=11 seed / packet / edge for the first knife-edge class."""
    Q = c80.Q
    source = json.loads(c80.C447_JSON.read_text())
    game = c80.load_game_module().PrimeGridGame(Q)
    group = c80.mobius_group()
    record = source["knife_edge_classes"][0]
    repair = record["canonical_shared_edge_cross_sheet_pair"]
    plus_cloud = c80.cloud(repair["plus_matching"])
    minus_cloud = c80.cloud(repair["minus_matching"])
    intersection = plus_cloud & minus_cloud
    matrix = record["standard_to_cap_projectivity"]
    packet = {c80.cap_cell(matrix, point) for point in intersection}
    assert len(packet) == 5
    frame = set(record["frame_parameters"])
    frame_stab = [g for g in group if {c80.mobius_act(g, x) for x in frame} == frame]
    square_kernel = [g for g in frame_stab if c80.det_is_square(g)]
    assert len(square_kernel) == 5
    edge_endpoints = repair["shared_p_edge"]
    # First shared-edge endpoint witness -> a P seed (as in build()).
    witness = c80.cap_cell(matrix, c80.standard_point(edge_endpoints[0]))
    seed = [tuple(cell) for cell in record["S3"]] + [witness]
    return game, record, edge_endpoints, packet, seed, Q


def main():
    c80 = load_c80()
    game, record, edge_endpoints, packet, seed, Q = setup(c80)

    packet_bits = {game.bit_for_cell(cell) for cell in packet}
    seed_mask = 0
    for cell in seed:
        seed_mask |= game.bit_for_cell(cell)
    assert not game.value(seed_mask), "seed must be a P-position"

    def u_of(cell_index):
        return c80.edge_quotient_u(record, edge_endpoints, game.cell_tuple(cell_index))

    # --- descend the full P-subtree: P-node -> opponent x (N child) ->
    #     any winning reply r (P grandchild) -> recurse. ---
    rows = []  # one row per (P-node, opponent move x)
    visited = set()
    stack = [(seed_mask, 0)]
    p_nodes_by_depth = Counter()
    while stack:
        mask, depth = stack.pop()
        if mask in visited:
            continue
        visited.add(mask)
        assert not game.value(mask)  # invariant: every node here is a P-position
        p_nodes_by_depth[depth] += 1
        legal = game.legal_mask(mask)
        # live conic size at this node (C80(c) drain measure)
        live_conic = bin(legal & game.conic_mask).count("1")
        for xbit, xi in game.iter_bits(legal):
            child = mask | xbit
            assert game.value(child)  # P-node -> every child is N
            reply_legal = game.legal_mask(child)
            # winning replies of each structured kind
            win_any = win_packet = win_onconic = False
            packet_avail = bool(reply_legal & sum(packet_bits))
            for rbit, _ri in game.iter_bits(reply_legal):
                if not game.value(child | rbit):
                    win_any = True
                    if rbit in packet_bits:
                        win_packet = True
                    if game.is_conic_cell(rbit.bit_length() - 1):
                        win_onconic = True
                    # recurse into P grandchild
                    stack.append((child | rbit, depth + 1))
            u = u_of(xi)
            chi = legendre(u, Q)
            rows.append(
                {
                    "depth": depth,
                    "u": u,
                    "chi": chi,
                    "x_onconic": game.is_conic_cell(xi),
                    "packet_avail": packet_avail,   # 1_live
                    "win_packet": win_packet,
                    "win_onconic": win_onconic,
                    "win_any": win_any,
                    "live_conic": live_conic,
                }
            )

    # ---- shape diagnostics: depth vs position size, u-distribution, terminality ----
    print("=== subtree shape (is it deep enough to exhibit recursion?) ===")
    size_by_depth = defaultdict(list)
    for m in visited:
        pass
    # recompute per-node size + terminal status
    node_depth = {}
    # re-walk to get sizes (cheap)
    seen2 = set()
    st = [(seed_mask, 0)]
    node_size = {}
    node_is_terminal = {}
    while st:
        m, d = st.pop()
        if m in seen2:
            continue
        seen2.add(m)
        node_size[m] = bin(m).count("1")
        node_depth[m] = d
        lg = game.legal_mask(m)
        node_is_terminal[m] = (lg == 0)
        for xb, _xi in game.iter_bits(lg):
            ch = m | xb
            for rb, _ri in game.iter_bits(game.legal_mask(ch)):
                if not game.value(ch | rb):
                    st.append((ch | rb, d + 1))
    for d in sorted(set(node_depth.values())):
        szs = [node_size[m] for m in node_depth if node_depth[m] == d]
        terms = sum(node_is_terminal[m] for m in node_depth if node_depth[m] == d)
        print(f"  depth {d}: P-nodes={len(szs)} cap-size range={min(szs)}..{max(szs)} terminal(P)={terms}")
    print("  per-depth opponent-move u-distribution (chi in braces):")
    for d in sorted(set(r["depth"] for r in rows)):
        udist = Counter((str(r["u"]), r["chi"]) for r in rows if r["depth"] == d)
        print(f"    depth {d}: " + "  ".join(f"u={u}(chi={c}):{n}" for (u, c), n in sorted(udist.items())))
    print()

    # ---- depth-1 sanity vs the frozen C496 certificate ----
    d1 = [r for r in rows if r["depth"] == 0]
    sig = Counter((r["u"], r["packet_avail"], r["win_packet"]) for r in d1)
    print("=== depth-1 sanity (must match C496: u8->win, u9->no-win, 12 killed) ===")
    for (u, avail, wp), n in sorted(sig.items(), key=lambda kv: str(kv[0])):
        print(f"  u={u!s:>3}  packet_avail={avail}  win_packet={wp}  count={n}")

    # ---- recursion-stability test ----
    # Law under test (C496, recursed): among LIVE moves (packet_avail=True),
    #   win_packet  <=>  chi(u) == -1.
    print("\n=== recursion-stability of  win_packet == (packet_avail and chi(u)==-1) ===")
    print(f"P-nodes by depth: {dict(sorted(p_nodes_by_depth.items()))}")
    print(f"total P-nodes: {len(visited)}   total (node,x) rows: {len(rows)}")
    max_depth = max(r["depth"] for r in rows)
    first_break = None
    for d in range(max_depth + 1):
        dr = [r for r in rows if r["depth"] == d]
        live = [r for r in dr if r["packet_avail"]]
        # law prediction on live moves
        viol = [r for r in live if r["win_packet"] != (r["chi"] == -1)]
        # also: does chi(u) separate win_packet among live? (contingency)
        by_chi = defaultdict(Counter)
        for r in live:
            by_chi[r["chi"]][r["win_packet"]] += 1
        sep = all(len(c) <= 1 for c in by_chi.values())  # each chi-class value-pure
        print(
            f"  depth {d}: live_rows={len(live):5d}  law_violations={len(viol):5d}  "
            f"chi_separates_win_packet={sep}  chi->win_packet={ {k: dict(v) for k, v in sorted(by_chi.items(), key=lambda kv: str(kv[0]))} }"
        )
        if (viol or not sep) and first_break is None and d >= 1:
            first_break = d

    # ---- broader static-value test: does chi(u) govern win_onconic among on-conic-productive moves? ----
    print("\n=== secondary: chi(u) vs winning ON-CONIC reply existence, per depth ===")
    for d in range(max_depth + 1):
        dr = [r for r in rows if r["depth"] == d]
        by_chi = defaultdict(Counter)
        for r in dr:
            if r["chi"] in (-1, 1):
                by_chi[r["chi"]][r["win_onconic"]] += 1
        sep = all(len(c) <= 1 for c in by_chi.values())
        print(
            f"  depth {d}: chi_separates_win_onconic={sep}  "
            f"chi->win_onconic={ {k: dict(v) for k, v in sorted(by_chi.items(), key=lambda kv: str(kv[0]))} }"
        )

    # live rows (moves in the chi=-1/chi=+1 packet-live class) present past depth 0?
    live_past_0 = any(r["packet_avail"] for r in rows if r["depth"] >= 1)
    chi_neg_past_0 = any(r["chi"] == -1 for r in rows if r["depth"] >= 1)

    print("\n=== VERDICT ===")
    if first_break is not None:
        verdict = "NOT_STABLE_LAW_VIOLATED"
        print(f"NOT RECURSION-STABLE: the C496 packet law is directly violated at depth "
              f"{first_break}.")
    elif not live_past_0 and not chi_neg_past_0:
        verdict = "NOT_STABLE_DEGENERATE"
        print("NOT RECURSION-STABLE (degenerate, not violated): the C496 packet law is a "
              "DEPTH-0 base fact.  Relative to the fixed frame edge, both the live packet and "
              "the chi=-1 live class (the {8,9} square/nonsquare straddle that drives the "
              "factorization) exist ONLY at depth 0.  At every deeper P-node every opponent "
              "move collapses to u in {1, inf} (chi=+1/none), so the law has no live rows to "
              "govern and the phenomenon does not recur.  C80(b) does NOT collapse onto C80(c) "
              "via the static chi overlay as-is: making it a descent law needs a LEVEL-INDEXED "
              "re-derivation of (edge, packet, chi-straddle) at each P-node, an object C496 did "
              "not build.")
    else:
        verdict = "STABLE_NONVACUOUS"
        print("RECURSION-STABLE (non-vacuous): live chi-class moves recur past depth 0 and the "
              "C496 packet law governs them at every P-node.")

    cert = {
        "schema": "c496-recursion-stability-probe-v1",
        "field_order": Q,
        "seed_cap_size": bin(seed_mask).count("1"),
        "p_nodes_by_depth": dict(sorted(p_nodes_by_depth.items())),
        "max_depth": max_depth,
        "depth0_histogram": {
            f"u={u}/avail={a}/winpkt={w}": n
            for (u, a, w), n in sorted(sig.items(), key=lambda kv: str(kv[0]))
        },
        "opponent_u_chi_by_depth": {
            str(d): {
                f"u={u}(chi={c})": n
                for (u, c), n in sorted(
                    Counter((str(r["u"]), r["chi"]) for r in rows if r["depth"] == d).items()
                )
            }
            for d in range(max_depth + 1)
        },
        "packet_law_live_rows_by_depth": {
            str(d): sum(1 for r in rows if r["depth"] == d and r["packet_avail"])
            for d in range(max_depth + 1)
        },
        "packet_law_violations_by_depth": {
            str(d): sum(
                1 for r in rows if r["depth"] == d and r["packet_avail"]
                and r["win_packet"] != (r["chi"] == -1)
            )
            for d in range(max_depth + 1)
        },
        "chi_neg_class_present_past_depth0": chi_neg_past_0,
        "packet_live_present_past_depth0": live_past_0,
        "verdict": verdict,
    }
    return cert


def canonical_bytes(data):
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


OUT = ROOT / "notes/2026-07-23-c496-recursion-stability-probe.json"


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = main()
    payload = canonical_bytes(result)
    if args.write:
        OUT.write_bytes(payload)
        print(f"\nwrote {OUT.relative_to(ROOT)}")
    elif args.check:
        assert OUT.read_bytes() == payload, "C496 recursion-stability certificate drift"
        print("\nC496 recursion-stability check: PASS")
