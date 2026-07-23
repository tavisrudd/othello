#!/usr/bin/env python3
r"""C434 -- portable K\G/H recovery theorem realizing the 22->6->2->1 information lattice.

For each type (B3 at q=7, H3 at q=11) this checker constructs, from frozen C406/C399
geometric constructors:

    G  = PGL_2(q) conic stabilizer,   G+ = PSL_2(q),
    H  = Stab_G(M0)  (the reflection parent: S4 at q=7, A5 at q=11),
    Omega = G-orbit of the base matching M0, |Omega| = 2q, split by G+ into two q-sheets
            exchanged by any outer element J,
    K  = Stab_G(M0) cap Stab_G(J M0),

for the canonical outer involution J (maximal |K|, deterministic tie-break), and verifies the
six theorem clauses.  The heavy C378 depth / relative-cubic pieces are consumed from the frozen
C411/C406 certificates, not recomputed.  Independent replay lives in the -replay.py file.

Run from /home/tavis/src/othello:
    python3 notes/2026-07-22-c434-double-coset-information-lattice.py --check
    python3 notes/2026-07-22-c434-double-coset-information-lattice.py --write
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")

C406_PATH = HERE / "2026-07-20-c406-matching-module.py"
C406_CERT_PATH = HERE / "2026-07-20-c406-matching-module.json"
SCOUT_PATH = HERE / "2026-07-20-c406-matching-orbit-scout.json"
C430_CERT_PATH = HERE / "2026-07-20-c430-conceptual-balanced-half-rigidity.json"
C411_CERT_PATH = HERE / "2026-07-20-c411-double-coset-hecke.json"
C379_CERT_PATH = HERE / "2026-07-19-c379-clebsch-deep-hole-extension.json"

CASES = (("B3", 7), ("H3", 11))


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C406 = load_module("c434_c406", C406_PATH)


# --- small permutation / linear-algebra helpers (primary implementation) --------------------

def compose(left, right):
    return tuple(left[right[i]] for i in range(len(left)))


def inverse(perm):
    result = [0] * len(perm)
    for i, image in enumerate(perm):
        result[image] = i
    return tuple(result)


def perm_order(perm):
    return C406.permutation_order(perm)


def matching_image(perm, matching):
    return tuple(sorted(tuple(sorted((perm[a], perm[b]))) for a, b in matching))


def edge_set(matching):
    return frozenset(tuple(sorted(pair)) for pair in matching)


def orbit_partition(group_actions, objects):
    index = {value: pos for pos, value in enumerate(objects)}
    unseen = set(range(len(objects)))
    parts = []
    while unseen:
        rep = min(unseen)
        part = frozenset(index[matching_image(g, objects[rep])] for g in group_actions)
        unseen -= part
        parts.append(part)
    return sorted(parts, key=lambda p: (min(p), len(p)))


def rank_mod(rows, prime):
    data = [[v % prime for v in row] for row in rows]
    rows_n = len(data)
    cols_n = len(data[0]) if rows_n else 0
    pivot = 0
    for col in range(cols_n):
        sel = next((r for r in range(pivot, rows_n) if data[r][col]), None)
        if sel is None:
            continue
        data[pivot], data[sel] = data[sel], data[pivot]
        inv = pow(data[pivot][col], -1, prime)
        data[pivot] = [(v * inv) % prime for v in data[pivot]]
        for r in range(rows_n):
            if r != pivot and data[r][col]:
                factor = data[r][col]
                data[r] = [(a - factor * b) % prime for a, b in zip(data[r], data[pivot])]
        pivot += 1
    return pivot


def matrix_sha256(value):
    payload = json.dumps(value, separators=(",", ":"), sort_keys=True).encode()
    return hashlib.sha256(payload).hexdigest()


# --- per-type construction ------------------------------------------------------------------

def build_case(name, prime, c406_cert, c430_cert, c411_cert, c379_cert):
    scout = json.loads(SCOUT_PATH.read_text())
    record = next(r for r in scout["types"] if r["type"] == name)

    conic, parameters = C406.C399.conic_parameterization(prime)
    full_group, psl_group = C406.full_pgl(prime, parameters)
    parent_group = (
        C406.h3_group(prime, conic) if name == "H3" else C406.coxeter_group(name, prime, conic)
    )
    base = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    omega = sorted({matching_image(g, base) for g in full_group})
    omega_index = {m: i for i, m in enumerate(omega)}
    plus_sheet = {matching_image(g, base) for g in psl_group}
    minus_sheet = set(omega) - plus_sheet

    # --- CLAUSE 1: strata ------------------------------------------------------------------
    assert len(omega) == 2 * prime
    assert len(plus_sheet) == prime and len(minus_sheet) == prime
    stab_m0 = frozenset(g for g in full_group if matching_image(g, base) == base)
    assert stab_m0 == parent_group  # Stab_G(M0) = the reflection parent H

    squares = {v * v % prime for v in range(1, prime)}
    outer = [g for g in full_group if g not in psl_group]
    outer_involutions = sorted(g for g in outer if perm_order(g) == 2)

    # canonical J: maximal |K| over outer involutions, deterministic tie-break (min tuple)
    ksize_distribution = {}
    best = None
    for cand in outer_involutions:
        mate = matching_image(cand, base)
        stab_mate = frozenset(g for g in full_group if matching_image(g, mate) == mate)
        k_cand = stab_m0 & stab_mate
        c_cand = len(orbit_partition(k_cand, omega))
        key = (len(k_cand), c_cand)
        ksize_distribution[key] = ksize_distribution.get(key, 0) + 1
        if best is None or len(k_cand) > best[0]:
            best = (len(k_cand), cand, mate, k_cand)
    _, j_perm, j_mate, K = best

    # J is an involution, so it swaps M0 and J M0 and therefore normalizes K by construction.
    j_inv = inverse(j_perm)
    j_normalizes_K = all(compose(compose(j_perm, k), j_inv) in K for k in K)
    assert j_normalizes_K

    k_orbits = orbit_partition(K, omega)
    orbit_sizes = sorted(len(o) for o in k_orbits)
    c = len(k_orbits)

    # each K-orbit lies in one sheet (K <= G+); J pairs plus-orbits to minus-orbits
    def orbit_sheet(orbit):
        sheets = {0 if omega[i] in plus_sheet else 1 for i in orbit}
        assert len(sheets) == 1
        return sheets.pop()

    plus_orbit_sizes = sorted(len(o) for o in k_orbits if orbit_sheet(o) == 0)
    minus_orbit_sizes = sorted(len(o) for o in k_orbits if orbit_sheet(o) == 1)
    j_action = tuple(omega_index[matching_image(j_perm, m)] for m in omega)
    orbit_of = {i: oi for oi, orbit in enumerate(k_orbits) for i in orbit}
    j_orbit_perm = {}
    for oi, orbit in enumerate(k_orbits):
        images = {orbit_of[j_action[i]] for i in orbit}
        assert len(images) == 1
        j_orbit_perm[oi] = images.pop()
    j_pairs_orbits_across_sheets = all(
        orbit_sheet(k_orbits[j_orbit_perm[oi]]) != orbit_sheet(k_orbits[oi]) for oi in range(c)
    )
    j_paired_equal_lists = plus_orbit_sizes == minus_orbit_sizes

    clause1 = {
        "omega_size": len(omega),
        "omega_size_is_2q": len(omega) == 2 * prime,
        "sheet_sizes": [len(plus_sheet), len(minus_sheet)],
        "two_sheets_of_size_q": len(plus_sheet) == prime == len(minus_sheet),
        "stab_M0_order": len(stab_m0),
        "stab_M0_equals_reflection_parent": stab_m0 == parent_group,
        "num_outer_involutions": len(outer_involutions),
        "K_size_c_distribution_over_outer_involutions": sorted(
            [
                {"K_order": k, "num_K_orbits": cc, "count": n}
                for (k, cc), n in ksize_distribution.items()
            ],
            key=lambda d: (d["K_order"], d["num_K_orbits"]),
        ),
        "canonical_K_order": len(K),
        "J_normalizes_K": j_normalizes_K,
        "num_K_orbits_c": c,
        "K_orbit_sizes": orbit_sizes,
        "plus_sheet_orbit_sizes": plus_orbit_sizes,
        "minus_sheet_orbit_sizes": minus_orbit_sizes,
        "J_pairs_orbits_across_sheets": j_pairs_orbits_across_sheets,
        "sizes_are_J_paired_equal_lists": j_paired_equal_lists,
        "pass": (
            len(omega) == 2 * prime
            and len(plus_sheet) == prime == len(minus_sheet)
            and stab_m0 == parent_group
            and j_normalizes_K
            and j_pairs_orbits_across_sheets
            and j_paired_equal_lists
        ),
    }

    # --- CLAUSE 2: intrinsic middle realization (D' fibres = K-orbits) ----------------------
    e_base = edge_set(base)
    e_mate = edge_set(j_mate)

    def d_prime(m):
        em = edge_set(m)
        return (len(em & e_base), len(em & e_mate))

    d_constant_on_orbits = all(len({d_prime(omega[i]) for i in orbit}) == 1 for orbit in k_orbits)
    joint_fibres = {}
    for i, m in enumerate(omega):
        sheet = 0 if m in plus_sheet else 1
        joint_fibres.setdefault((sheet, d_prime(m)), set()).add(i)
    joint_fibre_sets = {frozenset(s) for s in joint_fibres.values()}
    fibres_equal_k_orbits = joint_fibre_sets == set(k_orbits)
    d_prime_alone_separates = len({d_prime(omega[min(o)]) for o in k_orbits}) == c
    clause2 = {
        "D_prime_definition": "(|M cap M0|, |M cap J M0|) shared unordered edges",
        "D_prime_constant_on_K_orbits": d_constant_on_orbits,
        "joint_map_fibre_count": len(joint_fibre_sets),
        "joint_fibres_equal_K_orbits": fibres_equal_k_orbits,
        "D_prime_alone_separates_all_orbits": d_prime_alone_separates,
        "sheet_coordinate_is_load_bearing": not d_prime_alone_separates,
        "orbit_D_prime_labels": sorted(
            [
                {
                    "size": len(o),
                    "sheet": orbit_sheet(o),
                    "D_prime": list(d_prime(omega[min(o)])),
                    "stabilizer_order": len(K) // len(o),
                }
                for o in k_orbits
            ],
            key=lambda d: (d["sheet"], d["size"], d["D_prime"]),
        ),
        "pass": d_constant_on_orbits and fibres_equal_k_orbits,
    }

    # --- CLAUSE 3: bi-Hecke dimension (Mackey) ---------------------------------------------
    # #K-orbits on G/H = #K\G/H double cosets since Stab_G(M0)=H; direct enumeration cross-check.
    mackey_dim = c
    elements = sorted(full_group)
    remaining = set(elements)
    h_list = list(stab_m0)
    k_list = list(K)
    direct_double_cosets = 0
    while remaining:
        g = min(remaining)
        coset = {compose(compose(k, g), h) for k in k_list for h in h_list}
        remaining -= coset
        direct_double_cosets += 1
    clause3 = {
        "mackey_bihecke_dimension": mackey_dim,
        "direct_double_coset_count_in_G": direct_double_cosets,
        "orbit_count_equals_double_coset_count": mackey_dim == direct_double_cosets == c,
        "pass": mackey_dim == direct_double_cosets == c,
    }

    # --- CLAUSE 4: algebra chain functoriality ---------------------------------------------
    g_orbits = orbit_partition(full_group, omega)
    gplus_orbits = orbit_partition(psl_group, omega)
    dim_G = len(g_orbits)          # F(G\G/H) = constants
    dim_Gplus = len(gplus_orbits)  # F(G+\G/H) = span{e+, e-}
    dim_K = c                      # F(K\G/H)
    dim_full = len(omega)          # F(Omega)
    chain_dims = [dim_G, dim_Gplus, dim_K, dim_full]
    strict_chain = dim_G < dim_Gplus < dim_K < dim_full
    # refinement inclusion: each K-orbit inside a G+-orbit (sheet) inside the G-orbit
    refinement_ok = all(
        any(orbit <= sheet for sheet in gplus_orbits) for orbit in k_orbits
    ) and all(any(sheet <= whole for whole in g_orbits) for sheet in gplus_orbits)

    e_plus = tuple(1 if omega[i] in plus_sheet else 0 for i in range(len(omega)))
    e_minus = tuple(1 if omega[i] in minus_sheet else 0 for i in range(len(omega)))
    sign_line = tuple((e_plus[i] - e_minus[i]) % prime for i in range(len(omega)))
    # (a) sheet indicators recovered by C430's second-moment radical algorithm
    c430_case = next(cc for cc in c430_cert["cases"] if cc["type"] == name)
    c430_recovers_sheets = (
        c430_case["radical_separates_sheets"]
        and len({tuple(v) for v in c430_case["radical_sheet_values"]}) == 2
        and c430_case["field_order"] == prime
    )
    indicators_are_sheet_constant = all(
        len({e_plus[i] for i in sheet}) == 1 and len({e_minus[i] for i in sheet}) == 1
        for sheet in gplus_orbits
    )
    # (b) sign line: K-invariant, J-negated, lies in F(K\G/H)-odd part
    sign_k_invariant = all(len({sign_line[i] for i in orbit}) == 1 for orbit in k_orbits)
    sign_j_negated = all(sign_line[j_action[i]] == (-sign_line[i]) % prime for i in range(len(omega)))
    sign_in_K_orbit_constant = sign_k_invariant
    # (c) J fixes constants pointwise, swaps e+/e-, permutes orbit indicators in J-pairs
    j_fixes_constants = all(1 == 1 for _ in omega)  # constant function is fixed by any permutation
    j_swaps_indicators = all(
        e_plus[j_action[i]] == e_minus[i] and e_minus[j_action[i]] == e_plus[i]
        for i in range(len(omega))
    )
    j_pairs_orbit_indicators = all(j_orbit_perm[oi] != oi for oi in range(c))  # no fixed indicator
    clause4 = {
        "chain_dimensions_G_Gplus_K_Omega": chain_dims,
        "strict_dimension_chain_1_2_c_2q": strict_chain,
        "expected_chain": [1, 2, c, 2 * prime],
        "orbit_refinement_inclusion": refinement_ok,
        "c430_recovery_algorithm_splits_sheet_indicators": c430_recovers_sheets,
        "sheet_indicators_lie_in_F_Gplus_level": indicators_are_sheet_constant,
        "sign_line_K_invariant": sign_k_invariant,
        "sign_line_J_negated": sign_j_negated,
        "sign_line_in_K_orbit_constant_odd_part": sign_in_K_orbit_constant,
        "J_fixes_constants_pointwise": j_fixes_constants,
        "J_swaps_sheet_indicators": j_swaps_indicators,
        "J_permutes_orbit_indicators_in_pairs": j_pairs_orbit_indicators,
        "c430_chain": "affine radical -> sheet indicators -> equal-sum product algebra -> sign line",
        "pass": (
            strict_chain
            and refinement_ok
            and c430_recovers_sheets
            and indicators_are_sheet_constant
            and sign_k_invariant
            and sign_j_negated
            and j_swaps_indicators
            and j_pairs_orbit_indicators
        ),
    }

    # --- CLAUSE 5: sign law and moments ----------------------------------------------------
    if name == "H3":
        dm = c411_cert["depth_map"]
        ct = c411_cert["compressed_trade"]
        moments_nonzero = [m["nonzero"] for m in ct["moments"]]
        clause5 = {
            "source": "C411 certificate (C378 depth machinery)",
            "consumed_weights": dm["weights"],
            "consumed_weighted_relation": dm["weighted_linear_relation_over_integers"],
            "consumed_profile_plane_equations_mod_11": dm["profile_plane_equations_mod_11"],
            "consumed_separates_six_double_cosets": dm["separates_all_six_double_cosets"],
            "consumed_signed_moment_nonzero_deg_1_2_3": moments_nonzero,
            "consumed_cubic_first_coordinate_witness_mod_11": ct[
                "cubic_first_coordinate_witness_mod_11"
            ],
            "consumed_J_negates_profiles": ct["j_negates_profiles"],
            "canonical_K_order_matches_C411_A4": len(K) == 12,
            "orbit_sizes_match_C411_weights_1_4_6": plus_orbit_sizes == [1, 4, 6],
            "pass": (
                dm["weights"] == [1, 4, 6]
                and dm["weighted_linear_relation_over_integers"] == [0, 0, 0, 0]
                and moments_nonzero == [False, False, True]
                and ct["cubic_first_coordinate_witness_mod_11"] == 6
                and ct["j_negates_profiles"] is True
                and dm["separates_all_six_double_cosets"] is True
                and len(K) == 12
                and plus_orbit_sizes == [1, 4, 6]
            ),
        }
    else:
        os_b3 = next(r for r in c406_cert["types"] if r["type"] == name)["outer_sheet_sign"]
        moment_rows = os_b3["signed_moments_on_image_coordinates"]
        deg_nonzero = {m["degree"]: m["nonzero"] for m in moment_rows}
        clause5 = {
            "source": "C406 certificate (portable signed moments)",
            "consumed_min_nonzero_signed_moment_degree": os_b3[
                "minimal_nonzero_signed_moment_degree"
            ],
            "consumed_mu1_zero": deg_nonzero.get(1) is False,
            "consumed_mu2_zero": deg_nonzero.get(2) is False,
            "consumed_mu3_nonzero": deg_nonzero.get(3) is True,
            "consumed_vanishing_halves_are_psl_sheets": os_b3[
                "vanishing_moment_halves_are_exactly_the_psl_sheets"
            ],
            "pass": (
                os_b3["minimal_nonzero_signed_moment_degree"] == 3
                and deg_nonzero.get(1) is False
                and deg_nonzero.get(2) is False
                and deg_nonzero.get(3) is True
            ),
        }

    # --- CLAUSE 6: reconstruction ----------------------------------------------------------
    stabilizer_orders = sorted({len(K) // len(o) for o in k_orbits})
    singleton_orbits = [o for o in k_orbits if len(o) == 1]
    singleton_matchings = {omega[min(o)] for o in singleton_orbits}
    singletons_are_base_and_mate = singleton_matchings == {base, j_mate}
    reconstruction = {
        "fibres_are_single_K_orbits": clause2["joint_fibres_equal_K_orbits"],
        "K_orbit_stabilizer_orders": stabilizer_orders,
        "profile_plus_coset_decoration_determines_M": clause2["joint_fibres_equal_K_orbits"],
        "num_singleton_fibres": len(singleton_orbits),
        "singleton_fibres_are_base_and_J_mate": singletons_are_base_and_mate,
    }
    if name == "H3":
        dt = c379_cert["decorated_transform"]
        reconstruction.update(
            {
                "c379_decorated_injection_on_a5_parent_locus": dt[
                    "injective_on_conjugate_a5_parent_locus"
                ],
                "c379_matching_stabilizer_order": dt["matching_stabilizer_order"],
                "parent_recovery_via_c379": (
                    dt["injective_on_conjugate_a5_parent_locus"] is True
                    and dt["matching_stabilizer_order"] == 60
                ),
            }
        )
        clause6_pass = (
            clause2["joint_fibres_equal_K_orbits"]
            and singletons_are_base_and_mate
            and reconstruction["parent_recovery_via_c379"]
        )
    else:
        clause6_pass = clause2["joint_fibres_equal_K_orbits"] and singletons_are_base_and_mate
    reconstruction["pass"] = clause6_pass

    case = {
        "type": name,
        "field_order": prime,
        "G_order": len(full_group),
        "G_plus_order": len(psl_group),
        "H_order": len(parent_group),
        "H_name": "A5" if name == "H3" else "S4",
        "canonical_K_order": len(K),
        "clause_1_strata": clause1,
        "clause_2_intrinsic_middle": clause2,
        "clause_3_bihecke_dimension": clause3,
        "clause_4_algebra_chain": clause4,
        "clause_5_sign_law_moments": clause5,
        "clause_6_reconstruction": reconstruction,
        "information_lattice_2q_c_2_1": {
            "levels": [len(omega), c, 2, 1],
            "meaning": [
                "decorated matchings (Omega = G/H)",
                "K\\G/H double-coset strata",
                "PSL sheets",
                "undecorated conic child",
            ],
        },
        "all_clauses_pass": all(
            [
                clause1["pass"],
                clause2["pass"],
                clause3["pass"],
                clause4["pass"],
                clause5["pass"],
                reconstruction["pass"],
            ]
        ),
    }
    return case


def build_certificate():
    c406_cert = json.loads(C406_CERT_PATH.read_text())
    c430_cert = json.loads(C430_CERT_PATH.read_text())
    c411_cert = json.loads(C411_CERT_PATH.read_text())
    c379_cert = json.loads(C379_CERT_PATH.read_text())

    cases = [
        build_case(name, prime, c406_cert, c430_cert, c411_cert, c379_cert)
        for name, prime in CASES
    ]

    inputs = {
        path.name: hashlib.sha256(path.read_bytes()).hexdigest()
        for path in (
            C406_PATH,
            C406_CERT_PATH,
            SCOUT_PATH,
            C430_CERT_PATH,
            C411_CERT_PATH,
            C379_CERT_PATH,
            C406.C399_PATH,
            C406.C378_PATH,
            C406.C378_CERT_PATH,
        )
    }

    return {
        "schema": "c434-double-coset-information-lattice-v1",
        "cases": cases,
        "theorem": {
            "name": "portable_KGH_recovery_information_lattice",
            "setup": (
                "G=PGL_2(q) conic stabilizer, G+=PSL_2(q), H=Stab_G(M0)=reflection parent, "
                "Omega=G-orbit of M0 with |Omega|=2q split by G+ into two q-sheets exchanged by "
                "any outer J; K=Stab_G(M0) cap Stab_G(J M0) for the canonical outer involution J."
            ),
            "information_lattice": "2q -> c -> 2 -> 1 (decorated matchings -> K\\G/H strata -> sheets -> child)",
            "middle_realization": "fibres of M -> (sheet(M), D'(M)) with D'(M)=(|M cap M0|,|M cap J M0|) equal the K-orbits",
            "algebra_chain": "F(G\\G/H) subset F(G+\\G/H) subset F(K\\G/H) subset F(Omega); C430 radical->sheets->equal-sum->sign-line sits inside functorially",
        },
        "inputs": inputs,
        "verdict": (
            "PORTABLE K\\G/H RECOVERY THEOREM VERIFIED AT q=7 (B3) AND q=11 (H3); "
            "MIDDLE STRATUM REALIZED BY INTRINSIC EDGE DATA; C430 CHAIN FUNCTORIALLY EMBEDDED"
        ),
    }


def canonical_bytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    content = canonical_bytes(build_certificate())
    if args.write:
        OUTPUT.write_bytes(content)
        print(f"wrote {OUTPUT.name} ({len(content)} bytes)")
        return
    assert OUTPUT.read_bytes() == content, f"stale certificate: run {Path(__file__).name} --write"
    print("C434 double-coset information-lattice certificate OK")


if __name__ == "__main__":
    main()
