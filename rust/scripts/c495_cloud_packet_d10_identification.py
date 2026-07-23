#!/usr/bin/env python3
r"""C495 -- q=11 identification falsifier: is C80's C447/C460 cloud packet the C434 D10
two-sheet coset space?

Falsifier-first question (Fable transfer note 2026-07-22-c434-c80-cross-lane-transfers.md):
is C80's 22-move opponent set, with its square-C5-kernel orbit structure [1,1,5,5,5,5] and
intrinsic edge coordinate u = XZ/Y^2, G-equivariantly the C434 D10 J-class two-sheet coset
space, with the C5 orbits refining the double-coset strata and u's square/nonsquare class equal
to the sheet sign?

Verdict: NO (clean structural refutation), with a precise partial match:
  * the two objects are isomorphic as C5-sets ([1,1,5,5,5,5] = two fixed points + four regular
    orbits on both sides);
  * they are NOT identifiable as D10-sets / G-equivariantly: C80's single-state packet has full
    setwise stabilizer exactly C5 in PGL_2(q) -- there is no internal D10 at all -- while C434's
    Omega is a genuine internal-D10 orbit; the cap-frame D10's nonsquare coset is an inter-state
    endpoint swap (state0 != state1), not an internal symmetry;
  * u's square class does NOT realize the sheet sign: it splits the four 5-orbits 2-1-1
    ({sq,sq},{nonsq},{deg-inf}), whereas the C434 sheet coordinate splits them 2-2.

The two frozen bundles are consumed (and hashed) as inputs:
  rust/scripts/c80_c447_cloud_packet.py   (C447/C460 cloud packet, q=11)
  notes/2026-07-22-c434-double-coset-information-lattice.py (C434 K\\G/H lattice, D10 + A4 classes)

Run from /home/tavis/src/othello:
    python3 rust/scripts/c495_cloud_packet_d10_identification.py --check
    python3 rust/scripts/c495_cloud_packet_d10_identification.py --write
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
C80_PATH = ROOT / "rust/scripts/c80_c447_cloud_packet.py"
C434_PATH = ROOT / "notes/2026-07-22-c434-double-coset-information-lattice.py"
OUT = ROOT / "notes/2026-07-22-c495-cloud-packet-d10-identification.json"
Q = 11


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sqclass(u, squares) -> str:
    if u == "inf":
        return "inf"
    if u == 0:
        return "zero"
    return "sq" if u in squares else "nonsq"


def c80_state(c80, game, group, record, endpoint_index):
    """Reconstruct one pointed state's 22-move set and its symmetry data."""
    repair = record["canonical_shared_edge_cross_sheet_pair"]
    matrix = record["standard_to_cap_projectivity"]
    endpoint = repair["shared_p_edge"][endpoint_index]
    witness = c80.cap_cell(matrix, c80.standard_point(endpoint))
    seed = [tuple(cell) for cell in record["S3"]] + [witness]
    mask = sum(game.bit_for_cell(cell) for cell in seed)
    moves = [game.cell_tuple(idx) for _bit, idx in game.iter_bits(game.legal_mask(mask))]
    moves_set = set(moves)
    u_of = {m: c80.edge_quotient_u(record, repair["shared_p_edge"], m) for m in moves}

    frame = set(record["frame_parameters"])
    frame_stab = [g for g in group if {c80.mobius_act(g, x) for x in frame} == frame]
    square_kernel = [g for g in frame_stab if c80.det_is_square(g)]
    nonsquare = [g for g in frame_stab if not c80.det_is_square(g)]

    def act(g, m):
        return c80.cap_cell_action(record, g, m)

    # C5-orbits of the 22-move set
    seen, c5_orbits = set(), []
    for p in sorted(moves_set):
        if p in seen:
            continue
        orbit = {act(g, p) for g in square_kernel}
        c5_orbits.append(frozenset(orbit))
        seen |= orbit
    assert seen == moves_set

    # does the nonsquare coset preserve THIS single state's 22-set?
    nonsq_preserves = all(act(g, m) in moves_set for g in nonsquare for m in moves)

    # full setwise stabilizer of the 22-set inside the whole conic group PGL_2(q)
    stab_order, stab_nonsquare = 0, 0
    for g in group:
        try:
            image = {act(g, m) for m in moves}
        except AssertionError:
            continue  # a cell maps to infinity -> cannot preserve the finite 22-set
        if image == moves_set:
            stab_order += 1
            if not c80.det_is_square(g):
                stab_nonsquare += 1

    squares = {v * v % Q for v in range(1, Q)}
    five_orbit_u = sorted(
        (str(u_of[min(o)]), sqclass(u_of[min(o)], squares))
        for o in c5_orbits
        if len(o) == 5
    )
    fixed_u = sorted(
        (str(u_of[min(o)]), sqclass(u_of[min(o)], squares))
        for o in c5_orbits
        if len(o) == 1
    )
    sqcounts = Counter(sc for _u, sc in five_orbit_u)

    # ej: the packet symmetry is EXACTLY the determinant-square kernel of the cap-frame D10
    packet_symmetry_is_det_square_kernel = (
        stab_order == 5 == len(square_kernel) and stab_nonsquare == 0
    )

    return {
        "class": record["class"],
        "endpoint_parameter": endpoint,
        "legal_opponent_moves": len(moves),
        "c5_orbit_sizes": sorted(len(o) for o in c5_orbits),
        "nonsquare_coset_preserves_single_state": nonsq_preserves,
        "setwise_stabilizer_order_in_PGL2": stab_order,
        "setwise_stabilizer_nonsquare_elements": stab_nonsquare,
        "cap_frame_det_square_kernel_order": len(square_kernel),
        "packet_symmetry_is_det_square_kernel": packet_symmetry_is_det_square_kernel,
        "has_internal_d10": stab_order >= 10,
        "fixed_point_u": fixed_u,
        "five_orbit_u_sqclass": five_orbit_u,
        "u_square_class_5orbit_split": dict(sorted(sqcounts.items())),
        "u_square_class_gives_2_2_split": sorted(sqcounts.values()) == [2, 2],
    }


def build_c80(c80):
    source = json.loads(c80.C447_JSON.read_text())
    game = c80.load_game_module().PrimeGridGame(Q)
    group = c80.mobius_group()
    states = []
    for record in source["knife_edge_classes"]:
        for endpoint_index in range(2):
            states.append(c80_state(c80, game, group, record, endpoint_index))
    # the two endpoint states of a class are genuinely distinct move-sets
    repair0 = source["knife_edge_classes"][0]["canonical_shared_edge_cross_sheet_pair"]
    matrix0 = source["knife_edge_classes"][0]["standard_to_cap_projectivity"]
    s3 = [tuple(cell) for cell in source["knife_edge_classes"][0]["S3"]]
    endpoint_states = []
    for endpoint in repair0["shared_p_edge"]:
        witness = c80.cap_cell(matrix0, c80.standard_point(endpoint))
        mask = sum(game.bit_for_cell(cell) for cell in s3 + [witness])
        endpoint_states.append(
            frozenset(game.cell_tuple(idx) for _b, idx in game.iter_bits(game.legal_mask(mask)))
        )
    state0_ne_state1 = endpoint_states[0] != endpoint_states[1]
    overlap = len(endpoint_states[0] & endpoint_states[1])
    return states, state0_ne_state1, overlap


def build_c434_d10(c434):
    scout = json.loads(c434.SCOUT_PATH.read_text())
    rec = next(r for r in scout["types"] if r["type"] == "H3")
    conic, parameters = c434.C406.C399.conic_parameterization(Q)
    full_group, psl_group = c434.C406.full_pgl(Q, parameters)
    base = tuple(tuple(pair) for pair in rec["coxeter_invariant_matching"])
    omega = sorted({c434.matching_image(g, base) for g in full_group})
    plus_sheet = {c434.matching_image(g, base) for g in psl_group}
    psl_set = set(psl_group)
    stab_m0 = frozenset(g for g in full_group if c434.matching_image(g, base) == base)

    # pick the outer involution whose |K| = 10 (the D10 J-class)
    d10 = j_mate = None
    for cand in sorted(g for g in full_group if g not in psl_set and c434.perm_order(g) == 2):
        mate = c434.matching_image(cand, base)
        stab_mate = frozenset(g for g in full_group if c434.matching_image(g, mate) == mate)
        k = stab_m0 & stab_mate
        if len(k) == 10:
            d10, j_mate = k, mate
            break
    assert d10 is not None, "no |K|=10 (D10) outer involution class found"

    korbits = c434.orbit_partition(d10, omega)
    e_base = c434.edge_set(base)
    e_mate = c434.edge_set(j_mate)

    def sheet(m):
        return 0 if m in plus_sheet else 1

    def dprime(m):
        em = c434.edge_set(m)
        return (len(em & e_base), len(em & e_mate))

    orbit_rows = sorted(
        (
            {
                "size": len(o),
                "sheet": sheet(omega[min(o)]),
                "d_prime": list(dprime(omega[min(o)])),
                "stabilizer_order": len(d10) // len(o),
            }
            for o in korbits
        ),
        key=lambda r: (r["sheet"], r["size"], r["d_prime"]),
    )
    per_sheet = {
        s: sorted(len(o) for o in korbits if sheet(omega[min(o)]) == s) for s in (0, 1)
    }
    five_orbit_sheets = Counter(sheet(omega[min(o)]) for o in korbits if len(o) == 5)
    singletons = [o for o in korbits if len(o) == 1]
    singleton_matchings = {omega[min(o)] for o in singletons}
    singletons_are_base_and_mate = singleton_matchings == {base, j_mate}
    return {
        "omega_size": len(omega),
        "K_order": len(d10),
        "K_is_d10": len(d10) == 10,
        "k_orbit_sizes": sorted(len(o) for o in korbits),
        "per_sheet_orbit_sizes": {str(s): v for s, v in per_sheet.items()},
        "five_orbit_sheet_split": {str(s): c for s, c in sorted(five_orbit_sheets.items())},
        "sheet_gives_2_2_split_of_5orbits": sorted(five_orbit_sheets.values()) == [2, 2],
        "orbit_rows": orbit_rows,
        "two_d10_fixed_points_one_per_sheet": (
            len(singletons) == 2
            and singletons_are_base_and_mate
            and {sheet(m) for m in singleton_matchings} == {0, 1}
        ),
    }


def build_certificate():
    c80 = load("c495_c80", C80_PATH)
    c434 = load("c495_c434", C434_PATH)
    c80_states, state0_ne_state1, overlap = build_c80(c80)
    c434_d10 = build_c434_d10(c434)

    # consistency across all four pointed states
    profile = [1, 1, 5, 5, 5, 5]
    assert all(s["c5_orbit_sizes"] == profile for s in c80_states)
    assert all(s["legal_opponent_moves"] == 22 for s in c80_states)
    assert all(s["setwise_stabilizer_order_in_PGL2"] == 5 for s in c80_states)
    assert all(s["setwise_stabilizer_nonsquare_elements"] == 0 for s in c80_states)
    assert all(not s["nonsquare_coset_preserves_single_state"] for s in c80_states)
    assert all(not s["u_square_class_gives_2_2_split"] for s in c80_states)

    c5_set_isomorphic = c80_states[0]["c5_orbit_sizes"] == c434_d10["k_orbit_sizes"] == profile
    c80_has_internal_d10 = any(s["has_internal_d10"] for s in c80_states)
    d10_equivariant_identification = c80_has_internal_d10  # necessary condition, and it fails
    u_equals_sheet_sign = any(s["u_square_class_gives_2_2_split"] for s in c80_states)

    findings = {
        "c5_set_isomorphic": c5_set_isomorphic,
        "c80_packet_has_internal_d10": c80_has_internal_d10,
        "c80_setwise_stabilizer_is_exactly_c5": all(
            s["setwise_stabilizer_order_in_PGL2"] == 5
            and s["setwise_stabilizer_nonsquare_elements"] == 0
            for s in c80_states
        ),
        "c80_cap_frame_nonsquare_coset_is_interstate_endpoint_swap": (
            all(not s["nonsquare_coset_preserves_single_state"] for s in c80_states)
            and state0_ne_state1
        ),
        "endpoint_states_distinct_overlap": overlap,
        "c434_omega_is_internal_d10_set": c434_d10["K_is_d10"]
        and c434_d10["two_d10_fixed_points_one_per_sheet"],
        "u_square_class_equals_sheet_sign": u_equals_sheet_sign,
        "d10_or_g_equivariant_identification_holds": d10_equivariant_identification,
        # ej: the surviving faithful transfer -- the governing two-fold is, on BOTH sides, the
        # determinant-square class of PGL_2(11). C80: the packet symmetry is exactly the det-square
        # kernel C5 and the missing endpoint-swap coset is det-nonsquare (computed). C434: the sheet
        # sign is "PSL vs outer = determinant square class" by construction (its own clause 4). So
        # the identification fails as a 22-point G-set iso but survives as a C2-torsor correspondence
        # (C434 sheet swap <-> C80 endpoint swap <-> C448 orientation bit <-> C474 D10/C5 torsor);
        # this also explains why the packet symmetry is exactly C5 -- the state is endpoint-marked
        # (C474: the calibration class restricts to zero on C5).
        "governing_c2_is_determinant_square_class_on_c80_side": all(
            s["packet_symmetry_is_det_square_kernel"] for s in c80_states
        ),
        "faithful_transfer_survives_as_c2_torsor_correspondence": all(
            s["packet_symmetry_is_det_square_kernel"] for s in c80_states
        ),
    }

    verdict = (
        "FALSIFIER_NO: C80 cloud packet is NOT G-equivariantly the C434 D10 two-sheet coset "
        "space. Isomorphic as C5-sets ([1,1,5,5,5,5]); but C80's single-state 22-move packet has "
        "setwise stabilizer exactly C5 in PGL_2(11) (no internal D10), the cap-frame D10 nonsquare "
        "coset is an inter-state endpoint swap, and u's square class splits the four 5-orbits "
        "2-1-1 rather than realizing the C434 sheet sign's 2-2 split."
    )
    assert c5_set_isomorphic
    assert not d10_equivariant_identification
    assert not u_equals_sheet_sign
    assert findings["governing_c2_is_determinant_square_class_on_c80_side"]
    assert all(s["packet_symmetry_is_det_square_kernel"] for s in c80_states)

    return {
        "schema": "c495-cloud-packet-d10-identification-v1",
        "field_order": Q,
        "question": (
            "Is C80's 22-move cloud packet G-equivariantly the C434 D10 J-class two-sheet coset "
            "space, with C5 orbits refining the double-coset strata and u = XZ/Y^2 square class "
            "equal to the sheet sign?"
        ),
        "inputs": {
            "rust/scripts/c80_c447_cloud_packet.py": sha256(C80_PATH),
            "notes/2026-07-22-c434-double-coset-information-lattice.py": sha256(C434_PATH),
            "notes/2026-07-21-c447-cap-knife-edge.json": sha256(
                ROOT / "notes/2026-07-21-c447-cap-knife-edge.json"
            ),
            "notes/2026-07-08-intrusion-census.py": sha256(
                ROOT / "notes/2026-07-08-intrusion-census.py"
            ),
            "notes/2026-07-20-c406-matching-orbit-scout.json": sha256(
                ROOT / "notes/2026-07-20-c406-matching-orbit-scout.json"
            ),
        },
        "c80_cloud_packet_states": c80_states,
        "c434_d10_two_sheet_space": c434_d10,
        "findings": findings,
        "verdict": verdict,
    }


def canonical_bytes(data) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    expected = canonical_bytes(build_certificate())
    if args.write:
        OUT.write_bytes(expected)
        print(f"wrote {OUT.relative_to(ROOT)} ({len(expected)} bytes)")
    else:
        assert OUT.read_bytes() == expected, "C495 identification certificate drift"
        print("C495 cloud-packet / D10 identification check: PASS (falsifier NO)")


if __name__ == "__main__":
    main()
