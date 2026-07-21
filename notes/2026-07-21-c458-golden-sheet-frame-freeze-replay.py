#!/usr/bin/env python3
"""C458 independent replay -- reduced golden-sheet-frame reconstruction.

Independent cross-check for the C458 M0 addendum
(`2026-07-21-c458-golden-sheet-frame-freeze.md/.py/.json`).  This script is a SEPARATE code path:
it imports ONLY the frozen C379 replay module and the C399 conic module, and reconstructs the
reduced (F_11) sheet-carrying data with its own group / pair-orbit / matching / closure
implementations -- it does NOT import C442 (the primary's math source) or the primary script.  It
then reads the C458 JSON solely to compare the stored values against this independent
reconstruction.

What it independently verifies at the reduced level (the load-bearing claim-3 content):
  * a5(8) and a5(4) are distinct order-60 permutation groups on the 12 conic points, meeting in an
    order-12 subgroup (the common A4);
  * each has a UNIQUE A5-invariant perfect matching, and it equals -- two independent ways -- both
    the polar-pair matching of C379's reduced six-arc AND C406's frozen base / J-mate singleton;
  * the two sheets generate exactly PSL_2(11) (permutation closure order 660), so a5(8), a5(4) both
    lie in PSL.
The char-0 sigma-action (sheet-faithfulness upstairs) and the binary-form sheet-blindness are
verified in the primary via the hash-pinned C442 constructions and, independently, in C442's Fable
review; they are outside this reduced replay's boundary and are noted, not re-derived here.

Run (working directory = repository root):
    uv run python3 notes/2026-07-21-c458-golden-sheet-frame-freeze-replay.py

Exit 0 = all PASS.  Deterministic; no timestamps.  Trusted boundary: exact F_11 arithmetic and the
frozen C379/C399 machinery; all groups, matchings, and the closure are recomputed here, not assumed.
"""
from __future__ import annotations
from pathlib import Path
import importlib.util
import json
import sys

HERE = Path(__file__).resolve().parent
P = 11
JSON_PATH = HERE / "2026-07-21-c458-golden-sheet-frame-freeze.json"
C379_REPLAY_STEM = "2026-07-19-c379-clebsch-deep-hole-extension-replay"
C399_STEM = "2026-07-20-c399-coxeter-number-conic-phase"

# C406 frozen singletons as index-pairs (idx i -> parameter x = i, idx 11 -> inf); the SAME frozen
# labels C442 grounds in notes/2026-07-20-c406-matching-orbit-scout.json.  Independently confirmed
# below as the unique invariant matchings of a5(8) / a5(4).
C406_BASE = frozenset(frozenset(t) for t in [(0, 1), (2, 5), (3, 7), (4, 9), (6, 8), (10, 11)])
C406_JMATE = frozenset(frozenset(t) for t in [(0, 10), (1, 11), (2, 7), (3, 5), (4, 8), (6, 9)])


def load_module(stem):
    path = HERE / f"{stem}.py"
    spec = importlib.util.spec_from_file_location(stem.replace("-", "_"), path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


# ---- own group / matching / closure implementations (no import from C442) -------------------------
def pair_orbits(perms):
    all_pairs = [frozenset((i, j)) for i in range(12) for j in range(i + 1, 12)]
    seen, orbits = set(), []
    for pr in all_pairs:
        if pr in seen:
            continue
        orb, stack = set(), [pr]
        while stack:
            q = stack.pop()
            if q in orb:
                continue
            orb.add(q)
            a, b = tuple(q)
            for p in perms:
                nq = frozenset((p[a], p[b]))
                if nq not in orb:
                    stack.append(nq)
        seen |= orb
        orbits.append(orb)
    return orbits


def is_perfect_matching(orb):
    if len(orb) != 6:
        return False
    pts = [v for pr in orb for v in pr]
    return len(set(pts)) == 12


def unique_invariant_matching(perms):
    ms = [orb for orb in pair_orbits(perms) if is_perfect_matching(orb)]
    assert len(ms) == 1, f"expected a unique invariant matching, found {len(ms)}"
    return frozenset(frozenset(pr) for pr in ms[0])


def perm_closure(gens):
    ident = tuple(range(12))
    G, stack = {ident}, [ident]
    while stack:
        a = stack.pop()
        for g in gens:
            r = tuple(g[a[i]] for i in range(12))  # (g o a)
            if r not in G:
                G.add(r)
                stack.append(r)
    return G


def to_point_labels(matching):
    """Index-pair matching -> canonical point-label form matching C442's show() (idx 11 -> 'inf').

    Returned as lists (not tuples) so it compares equal to the JSON-deserialized form, which has no
    tuple type.
    """
    return sorted([sorted(("inf" if a == 11 else a, "inf" if b == 11 else b), key=str)
                   for f in matching for (a, b) in [tuple(f)]])


def main():
    c379 = load_module(C379_REPLAY_STEM)
    c399 = load_module(C399_STEM)
    conic, _ = c399.conic_parameterization(P)
    conic = list(conic)
    pidx = {pt: i for i, pt in enumerate(conic)}
    assert len(conic) == 12

    def a5_perm_group(tau):
        return {tuple(pidx[c399.normalize_mod(c379.mv(M, pt), P)] for pt in conic) for M in c379.a5(tau)}

    def polar_matching(tau):
        pairs = []
        for v in sorted(c379.six_points(tau)):
            hit = [pidx[pt] for pt in conic if sum(a * b for a, b in zip(v, pt)) % P == 0]
            assert len(hit) == 2, f"polar of a six-arc axis met the conic in {len(hit)} points"
            pairs.append(frozenset(hit))
        return frozenset(pairs)

    A8, A4 = a5_perm_group(8), a5_perm_group(4)
    checks = []

    def check(name, cond):
        checks.append((name, bool(cond)))

    # --- groups ---
    check("a5(8) order 60", len(A8) == 60)
    check("a5(4) order 60", len(A4) == 60)
    check("a5(8) != a5(4)", A8 != A4)
    check("a5(8) cap a5(4) order 12 (common A4)", len(A8 & A4) == 12)

    # --- unique invariant matchings, two independent ways, vs C406 frozen singletons ---
    m8 = unique_invariant_matching(list(A8))
    m4 = unique_invariant_matching(list(A4))
    pm8, pm4 = polar_matching(8), polar_matching(4)
    check("a5(8) unique invariant matching == C406 base", m8 == C406_BASE)
    check("a5(4) unique invariant matching == C406 J-mate", m4 == C406_JMATE)
    check("polar matching of reduced six-arc(8) == a5(8) invariant matching", pm8 == m8)
    check("polar matching of reduced six-arc(4) == a5(4) invariant matching", pm4 == m4)
    check("base and J-mate are distinct", m8 != m4)

    # --- finite closure = PSL_2(11) (order 660) ---
    closure = perm_closure(list(A8) + list(A4))
    check("closure <a5(8), a5(4)> order 660 (= PSL_2(11))", len(closure) == 660)
    check("a5(8) subset of closure", A8 <= closure)
    check("a5(4) subset of closure", A4 <= closure)

    # --- compare to the frozen C458 certificate ---
    if JSON_PATH.exists():
        cert = json.loads(JSON_PATH.read_bytes().decode("utf-8"))
        gsf = cert["golden_sheet_frame"]["polar_pair_matching"]
        check("JSON base matching matches independent reduction",
              gsf["reduction_at_pi_phi_to_8"]["matching"] == to_point_labels(m8))
        check("JSON J-mate matching matches independent reduction",
              gsf["reduction_at_pibar_phi_to_4"]["matching"] == to_point_labels(m4))
        check("JSON records closure order 660",
              cert["bridge"]["char11_finite_closure"]["closure_order"] == 660)
        check("JSON records a5(8) cap a5(4) intersection order 12",
              cert["two_frame_theorem"]["golden_six_arc_frame"]["witnesses"]["a5_8_a5_4_intersection_order"] == 12)
    else:
        check("C458 JSON present for comparison", False)

    width = max(len(n) for n, _ in checks)
    for name, ok in checks:
        print(f"[{'PASS' if ok else 'FAIL'}] {name.ljust(width)}")
    allok = all(ok for _, ok in checks)
    print(f"\n{'ALL PASS' if allok else 'FAILURES PRESENT'} ({sum(ok for _, ok in checks)}/{len(checks)})")
    return 0 if allok else 1


if __name__ == "__main__":
    sys.exit(main())
