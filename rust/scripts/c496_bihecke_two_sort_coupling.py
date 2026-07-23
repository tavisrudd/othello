#!/usr/bin/env python3
r"""C496 -- is the bi-Hecke bimodule e_K F[G] e_H the two-sorted coupling of C80's ledger?

Verdict, decided on the frozen q=11 C447/C460 cloud packet (all four pointed states):

  NO as a single bimodule (exact obstruction), YES as a bilinear additive x multiplicative
  Gauss/Jacobi pairing (corrected coupling design).

C80's open ledger item asks for "a canonical incidence bimodule carrying both conic-word traces and
reply-pencil energy while preserving P/N recursion".  C495 sharpened the two sorts to
  sort 1 (additive / incidence): the double-coset / D' label, the det-square C2, moved by the
          nonsquare cap-frame reflection (the endpoint swap);
  sort 2 (multiplicative): the game value P/N = Legendre(u), u = XZ/Y^2, C2-invariant.
The bi-Hecke bimodule e_K F[G] e_H = F[K\G/H] (C434 clause 3) is a permutation / incidence object;
its coordinates are the additive sort.  C496 tests directly whether it also carries the value.

MEASURED OBSTRUCTION.  The 22 opponent moves of a pointed state split into six C5-orbits with
u in {0, 1, 8, 9, inf, inf} and sizes 1,1,5,5,5,5.  Exactly two orbits are incidence-live (have
packet-reply candidates): u=8 and u=9, and they carry OPPOSITE value (u=8 -> P, u=9 -> N).  Their
additive-incidence realizations are IDENTICAL: same per-vertex candidate count (2), same packet-cell
support (all five), and the same 5-cycle candidate-pair multiset (the pentagon blossom).  So the
incidence bimodule is constant on the fibre where value splits -- not merely rank-dropping, but
literally value-blind.  It sorts the six orbits into only TWO incidence classes (killed / live)
while value needs THREE (killed / P / N); this is the value-layer face of C411's
"set-faithful, rank-2-on-dimension-6" caveat.

CORRECTED COUPLING.  The separating datum is chi(u) = Legendre(u), a quadratic multiplicative
character orthogonal to the incidence sort (the nonsquare C2 preserves u pointwise, hence preserves
value, while it moves the incidence/endpoint label).  The coupling is therefore a bilinear pairing
M_inc (x) M_chi of Gauss/Jacobi-sum shape, not a single bimodule: value = [chi(u) = -1] on the
incidence-live fibre, and the balanced live sum sum_live chi(u) = 5*chi(8) + 5*chi(9) = 0 is the
knife-edge C2-torsor calibration (C474/C495).

This checker reconstructs the frozen packet via the committed C80 constructors and emits the
certificate.  It makes no general-q claim (q17 orthogonality is the separate C497 evidence) and no
novelty/priority claim.

Run from /home/tavis/src/othello:
    python3 rust/scripts/c496_bihecke_two_sort_coupling.py --check
    python3 rust/scripts/c496_bihecke_two_sort_coupling.py --write   # intentional regeneration
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from collections import Counter
from pathlib import Path

Q = 11
ROOT = Path(__file__).resolve().parents[2]
CLOUD_PACKET_SOURCE = ROOT / "rust/scripts/c80_c447_cloud_packet.py"
C447_JSON = ROOT / "notes/2026-07-21-c447-cap-knife-edge.json"
C20_SOURCE = ROOT / "notes/2026-07-08-intrusion-census.py"
OUT = ROOT / "notes/2026-07-23-c496-bihecke-two-sort-coupling.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_cloud_packet_module():
    spec = importlib.util.spec_from_file_location("c496_cp", CLOUD_PACKET_SOURCE)
    module = importlib.util.module_from_spec(spec)
    sys.modules["c496_cp"] = module
    spec.loader.exec_module(module)
    return module


def legendre(u):
    if u == "inf":
        return "inf"
    if u % Q == 0:
        return 0
    return 1 if pow(u, (Q - 1) // 2, Q) == 1 else -1


def analyze_pointed_state(cp, game, group, record, endpoint):
    """Return the two-sort structure for one pointed state (class, chosen P-edge endpoint)."""
    repair = record["canonical_shared_edge_cross_sheet_pair"]
    intersection = cp.cloud(repair["plus_matching"]) & cp.cloud(repair["minus_matching"])
    matrix = record["standard_to_cap_projectivity"]
    packet = sorted({cp.cap_cell(matrix, point) for point in intersection})
    assert len(packet) == 5

    frame = set(record["frame_parameters"])
    frame_stab = [g for g in group if {cp.mobius_act(g, x) for x in frame} == frame]
    square_kernel = [g for g in frame_stab if cp.det_is_square(g)]
    nonsquare_coset = [g for g in frame_stab if not cp.det_is_square(g)]
    assert len(square_kernel) == 5 and len(nonsquare_coset) == 5

    witness = cp.cap_cell(matrix, cp.standard_point(endpoint))
    seed = [tuple(cell) for cell in record["S3"]] + [witness]
    mask = sum(game.bit_for_cell(cell) for cell in seed)

    # Per opponent vertex: u, candidate packet-reply cell indices, winning subset.
    vinfo = {}
    for _bit, oi in game.iter_bits(game.legal_mask(mask)):
        opponent = game.cell_tuple(oi)
        after = mask | (1 << oi)
        legal = game.legal_mask(after)
        candidates = frozenset(
            i for i, cell in enumerate(packet) if legal & game.bit_for_cell(cell)
        )
        winning = frozenset(
            i for i in candidates if not game.value(after | game.bit_for_cell(packet[i]))
        )
        vinfo[opponent] = (
            cp.edge_quotient_u(record, repair["shared_p_edge"], opponent),
            candidates,
            winning,
        )
    assert len(vinfo) == 22

    # Six C5-orbits.
    remaining = set(vinfo)
    orbits = []
    while remaining:
        rep = min(remaining)
        orb = {cp.cap_cell_action(record, g, rep) for g in square_kernel}
        assert orb <= set(vinfo)
        us = {vinfo[c][0] for c in orb}
        assert len(us) == 1  # u constant on C5-orbit
        orbits.append((us.pop(), orb))
        remaining -= orb
    assert sorted(len(orb) for _u, orb in orbits) == [1, 1, 5, 5, 5, 5]

    def pair_multiset(orb):
        # Canonical, order-stable description of the additive-incidence realization of an orbit:
        # the sorted multiset of candidate-reply cell-index sets over the orbit's vertices.
        return sorted(sorted(vinfo[c][1]) for c in orb)

    orbit_rows = []
    for u, orb in orbits:
        vertex = next(iter(orb))
        cand, win = vinfo[vertex][1], vinfo[vertex][2]
        # candidate count / winning count are C5-invariant across the orbit (assert it)
        assert {len(vinfo[c][1]) for c in orb} == {len(cand)}
        assert {len(vinfo[c][2]) for c in orb} == {len(win)}
        value = (
            "P" if len(win) > 0 else ("N" if len(cand) > 0 else "killed")
        )
        orbit_rows.append(
            {
                "u": u,
                "legendre_u": legendre(u),
                "size": len(orb),
                "per_vertex_candidate_count": len(cand),
                "per_vertex_winning_count": len(win),
                "candidate_cell_support": sorted(
                    frozenset().union(*[vinfo[c][1] for c in orb]) or frozenset()
                ),
                "candidate_pair_multiset": [list(s) for s in pair_multiset(orb)],
                "value": value,
            }
        )
    orbit_rows.sort(key=lambda r: (str(r["u"]), r["size"]))

    # --- OBSTRUCTION: the incidence realization is constant on the value-splitting live orbits. ---
    live = {r["u"]: r for r in orbit_rows if r["per_vertex_candidate_count"] > 0}
    assert set(live) == {8, 9}, sorted(str(k) for k in live)
    assert live[8]["value"] == "P" and live[9]["value"] == "N"
    incidence_profiles_identical = (
        live[8]["candidate_pair_multiset"] == live[9]["candidate_pair_multiset"]
        and live[8]["candidate_cell_support"] == live[9]["candidate_cell_support"]
        and live[8]["per_vertex_candidate_count"] == live[9]["per_vertex_candidate_count"]
    )
    assert incidence_profiles_identical  # the airtight collapse

    # Set-level rank of the additive-incidence realization = number of distinct reachability
    # supports (which packet cells the orbit can reply to): killed(empty) vs live(pentagon).
    distinct_incidence_profiles = {
        tuple(r["candidate_cell_support"]) for r in orbit_rows
    }
    additive_incidence_classes = len(distinct_incidence_profiles)  # killed(empty) + live(pentagon)
    value_classes = len({r["value"] for r in orbit_rows})  # killed / P / N
    assert additive_incidence_classes == 2 and value_classes == 3

    # --- COUPLING: the quadratic character separates the collapsed live fibre; C2 preserves u. ---
    value_equals_legendre_on_live = (
        live[8]["legendre_u"] == -1 and live[9]["legendre_u"] == 1
    )
    assert value_equals_legendre_on_live

    # Move-level product formula: value(x) = [x live] AND [chi(u(x)) = -1], checked on all 22 moves
    # (the bilinear pairing 1_live (x) chi realized per move, not just per orbit).
    move_level_holds = 0
    for opponent, (u, cand, win) in vinfo.items():
        is_live = len(cand) > 0
        chi = legendre(u)
        predicted = (
            "P" if (is_live and chi == -1) else ("N" if (is_live and chi == 1) else "killed")
        )
        observed = "P" if len(win) > 0 else ("N" if len(cand) > 0 else "killed")
        assert predicted == observed
        move_level_holds += 1
    assert move_level_holds == 22

    # Knife-edge straddle: the live u-values are a square/nonsquare pair (both P and N present).
    live_legendre_classes = {live[u]["legendre_u"] for u in live}
    knife_edge_straddle = live_legendre_classes == {-1, 1}
    assert knife_edge_straddle
    # Balanced live Gauss sum sum_{live vertices} chi(u): 5*chi(8) + 5*chi(9).
    live_gauss_sum = sum(
        r["size"] * r["legendre_u"] for r in orbit_rows if r["u"] in (8, 9)
    )
    assert live_gauss_sum == 0  # knife-edge calibration
    # The nonsquare coset is the inter-state endpoint swap (C495): it maps this state's vertices to
    # the sibling state's, so it need not fix vinfo setwise -- but it preserves u pointwise as a
    # coordinate.  Check u(g.opp) == u(opp) via the edge-quotient formula directly on the image cell.
    c2_preserves_u = all(
        cp.edge_quotient_u(record, repair["shared_p_edge"], cp.cap_cell_action(record, g, opp))
        == vinfo[opp][0]
        for g in nonsquare_coset
        for opp in vinfo
    )
    assert c2_preserves_u

    return {
        "class": record["class"],
        "endpoint_parameter": endpoint,
        "packet_cells": [list(cell) for cell in packet],
        "orbits": orbit_rows,
        "obstruction": {
            "value_splitting_live_orbits_u": [8, 9],
            "live_orbit_values": {"8": "P", "9": "N"},
            "additive_incidence_profiles_identical_on_live": incidence_profiles_identical,
            "shared_candidate_pair_multiset": live[8]["candidate_pair_multiset"],
            "additive_incidence_set_classes": additive_incidence_classes,
            "value_set_classes": value_classes,
            "conclusion": (
                "e_K F[G] e_H is constant on the value-splitting live fibre; "
                "it carries the additive sort only and cannot be the two-sorted coupling"
            ),
        },
        "coupling": {
            "separating_datum": "chi(u) = Legendre(u) (quadratic residue character)",
            "value_equals_legendre_u_on_live_fibre": value_equals_legendre_on_live,
            "move_level_product_formula_holds_on_all_22": move_level_holds == 22,
            "knife_edge_straddle_live_u_is_square_nonsquare_pair": knife_edge_straddle,
            "balanced_live_gauss_sum": live_gauss_sum,
            "nonsquare_c2_preserves_u_pointwise": c2_preserves_u,
            "design": (
                "bilinear additive-incidence (x) multiplicative-character pairing of "
                "Gauss/Jacobi-sum shape, not a single bimodule; realized per move as "
                "value(x) = [x live] AND [chi(u(x)) = -1]"
            ),
        },
    }


def build():
    cp = load_cloud_packet_module()
    game = cp.load_game_module().PrimeGridGame(Q)
    group = cp.mobius_group()
    source = json.loads(C447_JSON.read_text())
    states = []
    for record in source["knife_edge_classes"]:
        repair = record["canonical_shared_edge_cross_sheet_pair"]
        for endpoint in repair["shared_p_edge"]:
            states.append(analyze_pointed_state(cp, game, group, record, endpoint))
    states.sort(key=lambda s: (s["class"], str(s["endpoint_parameter"])))

    # All four pointed states must agree on the obstruction / coupling verdict (as in C495).
    obstruction_fingerprint = {
        (
            s["obstruction"]["additive_incidence_profiles_identical_on_live"],
            s["obstruction"]["additive_incidence_set_classes"],
            s["obstruction"]["value_set_classes"],
        )
        for s in states
    }
    coupling_fingerprint = {
        (
            s["coupling"]["value_equals_legendre_u_on_live_fibre"],
            s["coupling"]["move_level_product_formula_holds_on_all_22"],
            s["coupling"]["knife_edge_straddle_live_u_is_square_nonsquare_pair"],
            s["coupling"]["balanced_live_gauss_sum"],
            s["coupling"]["nonsquare_c2_preserves_u_pointwise"],
        )
        for s in states
    }
    assert obstruction_fingerprint == {(True, 2, 3)}
    assert coupling_fingerprint == {(True, True, True, 0, True)}

    return {
        "schema": "c496-bihecke-two-sort-coupling-v1",
        "field_order": Q,
        "inputs": {
            str(CLOUD_PACKET_SOURCE.relative_to(ROOT)): sha256(CLOUD_PACKET_SOURCE),
            str(C447_JSON.relative_to(ROOT)): sha256(C447_JSON),
            str(C20_SOURCE.relative_to(ROOT)): sha256(C20_SOURCE),
        },
        "pointed_states": states,
        "summary": {
            "pointed_states_checked": len(states),
            "all_states_agree": True,
            "obstruction": (
                "bi-Hecke / additive-incidence bimodule is value-blind: identical incidence "
                "realization on the two live orbits (u=8 -> P, u=9 -> N); 2 incidence classes "
                "vs 3 value classes"
            ),
            "coupling": (
                "value = [Legendre(u) = -1] on the live fibre; the coupling is a bilinear "
                "additive x multiplicative Gauss/Jacobi pairing, not a single bimodule"
            ),
        },
        "verdict": (
            "BI_HECKE_BIMODULE_IS_VALUE_BLIND_OBSTRUCTION; "
            "COUPLING_IS_ADDITIVE_TIMES_MULTIPLICATIVE_GAUSS_PAIRING_NOT_A_SINGLE_BIMODULE"
        ),
    }


def canonical_bytes(data):
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    expected = canonical_bytes(build())
    if args.write:
        OUT.write_bytes(expected)
        print(f"wrote {OUT.relative_to(ROOT)}")
    else:
        assert OUT.read_bytes() == expected, "C496 bi-Hecke two-sort certificate drift"
        print("C496 bi-Hecke two-sort coupling check: PASS")


if __name__ == "__main__":
    main()
