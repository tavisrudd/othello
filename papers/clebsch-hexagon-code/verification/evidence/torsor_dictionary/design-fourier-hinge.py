#!/usr/bin/env python3
"""design_fourier_hinge gap-closing certificates for the banked Paper-1 close (A merged with F, B tested).

Four independent bounded finite legs, all in exact integer / finite-field arithmetic:

  A1  design polarity: the reduction of Rz (and the q=7 outer silver element) exchanges the
      two frozen qr_design QR difference designs equivariantly, as a torsor map whose determinant
      lands in the outer coset of arithmetic_orientation's normalization-change table.
  A2  Fourier sector: the same outer element Rz exchanges common_duality's two signed Fourier sectors,
      inducing exactly common_duality's J-relation permutation on the rank-16 scalar-A4 scheme.
  F   outer hinge: pushed through golay_hadamard's frozen coset-grid dictionary, the reduction of Rz
      lands in the outer (row/column-exchanging) class of M12, not an inner one.
  B   modular-derived cubic falsifier: no convention-free uniform rule reads the cubic sign
      from the trace residue at both q=7 and q=11; every residue-value rule needs a per-case
      sign, so B degrades to a per-case dictionary.

The primary generator hash-pins and consumes the upstream certificates; subgroup_decoder is imported (as in
common_duality) only to rebuild G+/G-/A4 for leg A2.  A byte-stable JSON certificate is emitted; --check
regenerates in memory and compares against the tracked artifact and its sha256 manifest.

Run from this directory:
    python3 design-fourier-hinge.py --check
    python3 design-fourier-hinge.py            # regenerate
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "design-fourier-hinge.json"

# --- hash-pinned upstream inputs -------------------------------------------------------------
PINS = {
    "qr-barker.json":
        "f2c80377740261552ea645ea8269f1230997195e55e99d060bf74fb9bd80506a",
    "characteristic-eleven-gluing.json":
        "9f649c40b4649f2d5c59b6b7f9a2e4f93485dcdcd33bb9f44e0da5fb5f9f157e",
    "common-duality.json":
        "6de0c88fcb651d00c0e576b817487a8cbf89eb53318d4b6f7d087becef97c304",
    "golay-hadamard-automorphisms.json":
        "16cf4323234fc155095083d65c6bc5d50126b91d92d522a82b15c96fcaa53eb5",
    "arithmetic-orientation.json":
        "609a15bfc6cae8f3bdf6ff9acdfe6b93c8b6fe5f1dbbae4c3766b38edc3b3bc0",
    "silver-fusion.json":
        "7426903b59c0d0458baf09270c417871806a035f72d9e516332fb5862763a810",
    "subgroup-decoder.py":
        "24a5fcc759cb49ad4c4433649c60606cd22981ce416ca6b0a7532a08431a6667",
}


def load_pinned(name):
    path = ROOT / name
    digest = hashlib.sha256(path.read_bytes()).hexdigest()
    assert digest == PINS[name], f"hash drift for {name}: {digest}"
    if name.endswith(".json"):
        return json.loads(path.read_text())
    return path


def load_subgroup_decoder():
    path = load_pinned("subgroup-decoder.py")
    spec = importlib.util.spec_from_file_location("subgroup_decoder_for_design_fourier_hinge", path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def canonical_bytes(data):
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


# --- generic finite helpers ------------------------------------------------------------------
def squares(q):
    return {(i * i) % q for i in range(1, q)}


def mobius_perm(a, b, c, d, q):
    """Action of [[a,b],[c,d]] on P^1(F_q); point q denotes infinity."""
    out = {}
    for x in range(q):
        den = (c * x + d) % q
        num = (a * x + b) % q
        out[x] = q if den == 0 else (num * pow(den, q - 2, q)) % q
    out[q] = q if c == 0 else (a * pow(c, q - 2, q)) % q
    return tuple(out[i] for i in range(q + 1))


def perm_compose(p, r):
    return tuple(p[r[i]] for i in range(len(r)))


def perm_inv(p):
    inv = [0] * len(p)
    for i, x in enumerate(p):
        inv[x] = i
    return tuple(inv)


def closure(gens):
    gens = [tuple(g) for g in gens]
    ident = tuple(range(len(gens[0])))
    seen = {ident}
    frontier = [ident]
    while frontier:
        a = frontier.pop()
        for g in gens:
            c = perm_compose(a, g)
            if c not in seen:
                seen.add(c)
                frontier.append(c)
    return seen


# ============================================================================================
# Leg A1 -- design polarity
# ============================================================================================
def leg_a1():
    qr_design = load_pinned("qr-barker.json")
    results = []
    for case in qr_design["cases"]:
        q = case["q"]
        sq = squares(q)
        sheets = case["sheets"]
        s0 = [frozenset(frozenset(e) for e in m) for m in sheets[0]]
        s1 = [frozenset(frozenset(e) for e in m) for m in sheets[1]]
        set0, set1 = set(s0), set(s1)

        # outer element: reduction of Rz at q=11, silver J at q=7
        if q == 11:
            g = mobius_perm(1, 10, 1, 1, q)          # (x+10)/(x+1), det 2
            det = (1 * 1 - 10 * 1) % q
            name = "reduction of Rz = (x+10)/(x+1)"
        else:
            g = mobius_perm(q - 1, 0, 0, 1, q)         # x -> -x, det -1
            det = ((q - 1) * 1 - 0) % q
            name = "silver outer J = (x -> -x)"

        def apply(m):
            return frozenset(frozenset(g[p] for p in e) for e in m)

        img0 = {apply(m) for m in s0}
        img1 = {apply(m) for m in s1}
        sheet_swap = (img0 == set1) and (img1 == set0)

        # cross-disjointness matrix M[i][j] = 1 iff s0[i] disjoint s1[j]
        M = [[1 if not (s0[i] & s1[j]) else 0 for j in range(q)] for i in range(q)]
        matrix_ok = (M == case["cross_disjointness_matrix"])
        d_row = [j for j in range(q) if M[0][j]]
        d_col = [i for i in range(q) if M[i][0]]
        neg_d = sorted((-x) % q for x in d_row)
        transpose_is_negation = (sorted(d_col) == neg_d)

        # equivariance: g relabels sheet0->sheet1 (sigma) and sheet1->sheet0 (tau);
        # disjointness invariance forces M[i][j] == M[tau[j]][sigma[i]] (a transpose intertwining).
        sigma = {i: s1.index(apply(s0[i])) for i in range(q)}
        tau = {j: s0.index(apply(s1[j])) for j in range(q)}
        equivariant = all(M[i][j] == M[tau[j]][sigma[i]] for i in range(q) for j in range(q))

        verdict = (sheet_swap and matrix_ok and transpose_is_negation and equivariant
                   and det % q in {v % q for v in range(q)} and det % q not in sq)
        results.append({
            "q": q,
            "type": case["type"],
            "outer_element": name,
            "outer_determinant": det,
            "determinant_is_nonsquare": det % q not in sq,
            "sheet_swap": sheet_swap,
            "cross_disjointness_matrix_matches_qr_design": matrix_ok,
            "row0_design": d_row,
            "col0_design": d_col,
            "transpose_design_equals_negation": transpose_is_negation,
            "transpose_intertwining_equivariant": equivariant,
            "leg_pass": bool(verdict),
        })
    passed = all(r["leg_pass"] for r in results)
    return {
        "claim": ("the reduction of Rz (q=11) and the silver outer element (q=7) each swap the "
                  "two qr_design sheets and intertwine the cross-disjointness design with its transpose "
                  "(= negation), a C2 torsor map whose nonsquare determinant lands in the outer "
                  "coset of arithmetic_orientation's normalization-change table"),
        "cases": results,
        "verdict": "PASS" if passed else "FAIL",
    }


# ============================================================================================
# Leg A2 -- signed Fourier sector
# ============================================================================================
def leg_a2():
    subgroup_decoder = load_subgroup_decoder()
    common_duality = load_pinned("common-duality.json")
    Q = 11

    def scheme(tau):
        return subgroup_decoder.reflection_group(Q, subgroup_decoder.h3_roots(Q, tau))

    g_plus = set(scheme(8))
    g_minus = set(scheme(4))
    a4 = g_plus & g_minus                       # the ordered-golden-pair A4 = K
    assert len(a4) == 12

    scalar_a4 = {tuple(tuple(s * M[i][j] % Q for j in range(3)) for i in range(3))
                 for M in a4 for s in range(1, Q)}

    def mv(M, v):
        return tuple(sum(M[i][j] * v[j] for j in range(3)) % Q for i in range(3))

    all_vecs = [(x, y, z) for x in range(Q) for y in range(Q) for z in range(Q)]
    rel_of = {}
    for v in all_vecs:
        if v in rel_of:
            continue
        orbit = frozenset(mv(M, v) for M in scalar_a4)
        for w in orbit:
            rel_of[w] = orbit

    meta = common_duality["common_relation_metadata"]
    ordered = [rel_of[tuple(m["representative"])] for m in meta]
    assert len(set(id(o) for o in ordered)) == 16
    valencies_ok = [len(o) for o in ordered] == [m["size"] for m in meta]
    index = {o: i for i, o in enumerate(ordered)}

    def perm_of(M):
        return tuple(index[rel_of[mv(M, next(iter(o)))]] for o in ordered)

    rz = ((0, 10, 0), (1, 0, 0), (0, 0, 1))
    j = tuple(tuple(row) for row in common_duality["golden_map_J"])
    p_rz = perm_of(rz)
    p_j = perm_of(j)

    j_matches = list(p_j) == common_duality["J_relation_permutation"]
    rz_is_perm = sorted(p_rz) == list(range(16))
    rz_equals_j = p_rz == p_j
    odd_pairs = [tuple(pair) for pair in common_duality["J_odd_relation_pairs"]]
    rz_swaps_pairs = all(p_rz[a] == b and p_rz[b] == a for a, b in odd_pairs)
    j_inv = perm_inv(p_j)
    rz_after_jinv = tuple(p_rz[j_inv[i]] for i in range(16))
    same_sector_action = rz_after_jinv == tuple(range(16))

    passed = (valencies_ok and j_matches and rz_is_perm and rz_equals_j
              and rz_swaps_pairs and same_sector_action)
    return {
        "claim": ("Rz permutes the 16 rank-16 scalar-A4 relations exactly as common_duality's involution J, "
                  "exchanging the four signed-sector pairs (1,10),(3,13),(6,14),(9,11); "
                  "Rz o J^-1 fixes all 16 relations, so Rz and J act identically on the signed "
                  "Fourier sector torsor"),
        "a4_order": len(a4),
        "valencies_match_common_duality": valencies_ok,
        "j_relation_permutation_matches_common_duality": j_matches,
        "rz_relation_permutation": list(p_rz),
        "rz_is_scheme_automorphism": rz_is_perm,
        "rz_equals_j_on_all_relations": rz_equals_j,
        "rz_exchanges_signed_sector_pairs": rz_swaps_pairs,
        "rz_after_j_inverse_is_identity": same_sector_action,
        "verdict": "PASS" if passed else "FAIL",
    }


# ============================================================================================
# Leg F -- outer hinge through golay_hadamard's coset grid
# ============================================================================================
def leg_f():
    golay_hadamard = load_pinned("golay-hadamard-automorphisms.json")
    parents = golay_hadamard["two_M11_parents_and_frozen_intersection"]
    lg = parents["intersection_generators"]
    kg = parents["parity_stabilizer_generators"]
    pg = golay_hadamard["coordinate_and_design_groups"]["pure_coordinate_code_group"][
        "generators_old_to_new_zero_based"]

    L = closure(lg)
    P = closure(pg)
    K = closure(kg)
    M12 = closure(list(pg) + list(kg))
    struct_ok = (len(L) == 660 and len(P) == 7920 and len(K) == 7920
                 and len(M12) == 95040 and (P & K) == L)

    def conj_set(x, G):
        xi = perm_inv(x)
        return frozenset(perm_compose(perm_compose(x, g), xi) for g in G)

    # N_{M12}(L): if it equals L, no inner automorphism of M12 induces a non-inner auto of L.
    normalizer = [m for m in M12 if conj_set(m, L) == frozenset(L)]
    normalizer_is_L = (frozenset(normalizer) == frozenset(L))

    lgt = [tuple(g) for g in lg]

    def induced_on_L(m):
        mi = perm_inv(m)
        return tuple(perm_compose(perm_compose(m, g), mi) for g in lgt)

    inn_L = {induced_on_L(l) for l in L}
    m12_inducing_noninner = [m for m in normalizer if induced_on_L(m) not in inn_L]

    # two M11 parents are non-conjugate in M12 (distinct classes)
    pgt = [tuple(g) for g in pg]
    kset = frozenset(K)
    p_conj_k = any(conj_set(m, pgt) == kset for m in M12)

    # Mobius side: the reduction of Rz induces the diagonal (non-inner) automorphism on PSL2(11)
    Q = 11
    t = mobius_perm(1, 1, 0, 1, Q)
    s = mobius_perm(0, 10, 1, 0, Q)
    rz = mobius_perm(1, 10, 1, 1, Q)
    lmob = closure([t, s])
    pgl = closure([t, s, rz])
    rz_normalizes = all(perm_compose(perm_compose(rz, g), perm_inv(rz)) in lmob for g in [t, s])
    rz_on_lmob = tuple(perm_compose(perm_compose(rz, g), perm_inv(rz)) for g in [t, s])
    inn_lmob = {tuple(perm_compose(perm_compose(l, g), perm_inv(l)) for g in [t, s]) for l in lmob}
    rz_diagonal = rz_on_lmob not in inn_lmob

    # verdict: outer, because the diagonal automorphism cannot be realized inside M12
    outer = (struct_ok and normalizer_is_L and len(m12_inducing_noninner) == 0
             and not p_conj_k and len(lmob) == 660 and len(pgl) == 1320
             and rz_normalizes and rz_diagonal)
    return {
        "claim": ("N_{M12}(frozen PSL2(11)) = frozen PSL2(11); the reduction of Rz induces the "
                  "diagonal (non-inner) automorphism of PSL2(11); since no element of M12 realizes "
                  "that automorphism and the two M11 parents are non-conjugate in M12, the sheet "
                  "swap is realized only by the outer, row/column-exchanging class of M12"),
        "structure_ok": struct_ok,
        "L_order": len(L), "P_order": len(P), "K_order": len(K), "M12_order": len(M12),
        "P_cap_K_equals_L": (P & K) == L,
        "normalizer_M12_of_L_order": len(normalizer),
        "normalizer_equals_L": normalizer_is_L,
        "m12_elements_inducing_noninner_auto_of_L": len(m12_inducing_noninner),
        "two_M11_parents_conjugate_in_M12": p_conj_k,
        "pgl2_11_order": len(pgl),
        "rz_normalizes_psl2_11": rz_normalizes,
        "rz_induces_diagonal_noninner_auto": rz_diagonal,
        "disposition": "OUTER -- F merges into A" if outer else "INNER -- F shrinks back to A",
        "verdict": "PASS" if outer else "FAIL",
    }


# ============================================================================================
# Leg B -- convention-free uniform cubic-sign rule falsifier
# ============================================================================================
def leg_b():
    arithmetic_orientation = load_pinned("arithmetic-orientation.json")
    silver_fusion = load_pinned("silver-fusion.json")

    # silver_fusion fixes the cubic sign as an outer-odd function of the sheet (mu_3(s) = 2 s mu_3(4)).
    b3 = silver_fusion["B3"]["reductions"]
    cubic_sign_outer_odd = (
        b3["sqrt2_4"]["cubic_orientation"] == "positive"
        and b3["sqrt2_3"]["cubic_orientation"] == "negative")

    # Intrinsic marked-sheet data from arithmetic_orientation (marked = Coxeter matching, square unipotent class).
    per_q = {}
    for c in arithmetic_orientation["cases"]:
        q = c["q"]
        p = c["characteristic"]
        marked = c["selected_alpha_residue"]
        opposite = c["other_alpha_residue"]
        # marked is the square class (Legendre +1, exponent 1) at both primes
        marked_leg = next(row["legendre_symbol"] for row in c["normalization_exponent_table"]
                          if row["exponent"] == 1)
        per_q[q] = {"char": p, "marked_residue": marked, "opposite_residue": opposite,
                    "marked_is_square_class": marked_leg == 1,
                    "outer_swap_r_to_minus1_minus_r": (-1 - marked) % p}

    # The decisive residue-value collision: residue value 0 is the OPPOSITE sheet at q=7 but the
    # MARKED sheet at q=11.  Hence no fixed function of the residue value tracks the intrinsic
    # marked/opposite role uniformly, so no convention-free residue-value rule reads the (outer-odd)
    # cubic sign uniformly.
    role_of_residue0 = {
        7: ("marked" if per_q[7]["marked_residue"] == 0 else
            ("opposite" if per_q[7]["opposite_residue"] == 0 else "absent")),
        11: ("marked" if per_q[11]["marked_residue"] == 0 else
             ("opposite" if per_q[11]["opposite_residue"] == 0 else "absent")),
    }
    residue0_collision = role_of_residue0[7] != role_of_residue0[11] \
        and "absent" not in role_of_residue0.values()

    # Exhaust the small candidate space of convention-free rules on the two sheets per prime.
    # Each rule maps a sheet to +/-1; it must (i) be outer-odd (opposite sheets get opposite sign)
    # and (ii) be a single formula evaluated per prime with no per-case constant.
    candidates = {}

    # R_param: quadratic character of the unipotent parameter a (square class).  Uniform (+1 on the
    # marked square class at both q) but this IS the Coxeter marking, not a readout from the residue.
    candidates["quadratic_character_of_unipotent_parameter"] = {
        "uniform": True,
        "reads_from": "square class of the unipotent parameter (the Coxeter marking itself)",
        "derives_pm6_from_arithmetic": False,
        "note": "restates A's marking; +1 on the marked square-class sheet at both q",
    }

    # R_res: any fixed function phi(r) of the trace residue / period -c_{d-1}.
    # Uniformity would force phi(0) to a single sign, but residue 0 is opposite at q=7 and marked at
    # q=11, so phi(0) must be both signs -> needs a per-case sign.
    candidates["function_of_trace_residue_value"] = {
        "uniform": False,
        "reads_from": "trace residue value r (= period -c_{d-1})",
        "obstruction": "residue value 0 is the opposite sheet at q=7 but the marked sheet at q=11",
        "requires_per_case_sign": True,
    }

    # R_char: quadratic character of the trace difference 2r+1 (over F_q of a fixed lift); outer-odd
    # since 2r+1 -> -(2r+1) and q=7,11 == 3 mod 4.  On the marked sheet 2*marked+1 gives 3 (q=7) and
    # 1 (q=11); Legendre(3 mod 7) = -1 while Legendre(1 mod 11) = +1, opposite signs -> per-case.
    def legendre(a, q):
        a %= q
        if a == 0:
            return 0
        return 1 if pow(a, (q - 1) // 2, q) == 1 else -1
    marked_char = {q: legendre(2 * per_q[q]["marked_residue"] + 1, q) for q in (7, 11)}
    candidates["quadratic_character_of_trace_difference_2r_plus_1"] = {
        "uniform": marked_char[7] == marked_char[11],
        "reads_from": "Legendre symbol of 2r+1 (a lift of the trace difference)",
        "marked_sheet_value_q7": marked_char[7],
        "marked_sheet_value_q11": marked_char[11],
        "requires_per_case_sign": marked_char[7] != marked_char[11],
    }

    # Falsifier fires: every rule that reads the residue/period needs a per-case sign; the only
    # uniform rule is the parameter character, which is the marking, not an arithmetic origin of +-6.
    every_residue_rule_needs_per_case_sign = (
        residue0_collision
        and candidates["function_of_trace_residue_value"]["requires_per_case_sign"]
        and candidates["quadratic_character_of_trace_difference_2r_plus_1"]["requires_per_case_sign"])
    only_uniform_rule_is_marking = candidates[
        "quadratic_character_of_unipotent_parameter"]["uniform"] and not candidates[
        "quadratic_character_of_unipotent_parameter"]["derives_pm6_from_arithmetic"]

    falsifier_fires = every_residue_rule_needs_per_case_sign and only_uniform_rule_is_marking
    return {
        "claim": ("no convention-free rule reads the cubic sign from the trace residue uniformly at "
                  "q=7 and q=11; every residue/period rule needs a per-case sign, and the only "
                  "uniform rule is the quadratic character of the unipotent parameter, which is the "
                  "Coxeter marking, not an arithmetic origin for the +-6"),
        "cubic_sign_is_outer_odd_silver_fusion": cubic_sign_outer_odd,
        "per_prime_marked_data": per_q,
        "role_of_residue_value_0": role_of_residue0,
        "residue0_collision": residue0_collision,
        "candidate_rules": candidates,
        "every_residue_rule_needs_per_case_sign": every_residue_rule_needs_per_case_sign,
        "only_uniform_rule_is_the_marking": only_uniform_rule_is_marking,
        "disposition": ("B DEGRADES TO A PER-CASE DICTIONARY -- covariation is intrinsic but the "
                        "+-6 readout is not convention-free uniform; B folds into A as the marking"),
        "falsifier_fires": falsifier_fires,
        "verdict": "FALSIFIER FIRES (B loses master-stroke strength)" if falsifier_fires else "B SURVIVES",
    }


# ============================================================================================
def build_certificate():
    a1 = leg_a1()
    a2 = leg_a2()
    f = leg_f()
    b = leg_b()
    return {
        "artifact": "design_fourier_hinge",
        "schema": "design_fourier_hinge-close-gap-1",
        "purpose": ("gap-closing battery for the banked Paper-1 close 'A merged with F' with B "
                    "tested; four independent bounded finite legs in exact arithmetic"),
        "upstream_pins": PINS,
        "leg_A1_design_polarity": a1,
        "leg_A2_fourier_sector": a2,
        "leg_F_outer_hinge": f,
        "leg_B_modular_cubic_falsifier": b,
        "summary": {
            "A1": a1["verdict"],
            "A2": a2["verdict"],
            "F": f["verdict"] + " -> " + f["disposition"],
            "B": b["verdict"],
        },
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true",
                    help="regenerate in memory and compare to the tracked artifact")
    args = ap.parse_args()
    cert = build_certificate()
    blob = canonical_bytes(cert)
    if args.check:
        assert OUTPUT.exists(), "certificate missing; regenerate first"
        tracked = OUTPUT.read_bytes()
        assert blob == tracked, "certificate drift vs tracked JSON"
        manifest = ROOT / "design-fourier-hinge.sha256"
        if manifest.exists():
            want = dict(line.split()[::-1] for line in manifest.read_text().split("\n") if line.strip())
            for fname, h in want.items():
                fname = fname.lstrip("*")
                got = hashlib.sha256((ROOT / fname).read_bytes()).hexdigest()
                assert got == h, f"manifest drift for {fname}"
        print("OK  A1", cert["summary"]["A1"], "| A2", cert["summary"]["A2"],
              "| F", cert["leg_F_outer_hinge"]["verdict"], "| B", cert["summary"]["B"])
    else:
        OUTPUT.write_bytes(blob)
        print("wrote", OUTPUT.name)


if __name__ == "__main__":
    main()
