#!/usr/bin/env python3
"""C69 (promoted S1) -- envelope / derived-curve invariants for the flipping configs.

Promoted after C55 (group-side) and C64 (extremal-side) both reported NEGATIVE.
This is the algebraic-geometry-side mechanism candidate for the arc-depleted
dichotomy (119 configs N@{11,17}, P@{13,19}).

Segre's tangent-envelope readings are provably NON-discriminating, and this script
confirms it machine-side (part A):
  * the 6 tangents at 6 distinct conic points are NEVER 3-concurrent (their dual
    points lie on the dual conic, no 3 of which are collinear), so tangent
    concurrence carries no information;
  * those 6 tangents envelope the dual conic, which has q+1 rational points at
    every q -- also non-discriminating;
  * every chord of the 6 points is a secant (both ends on C), so all 15 chord
    poles are external -- non-discriminating.
So the only place an order-dependent envelope invariant can live is the ARITHMETIC
of a derived curve.  Part B tests the genus-2 hyperelliptic curve of the 6 branch
points {inf,0,t1,t2,t3,t4}:

    y^2 = f(x),   f(x) = prod over finite params {0,t1,t2,t3,t4} of (x - r)

whose F_q point count N2 = q + a2, a2 = sum_x chi(f(x)), varies with q for FIXED
integral params -- exactly the degree of freedom C18's static 6-point character
dictionary lacked (a2 is a global character sum over the whole line, not a count of
chi(t_i - t_j)).  Part C tests chi_q of derived integer resultants (Igusa-flavored).

Verdict discipline (same as C55/C64): a mechanism feature must be constant within
{11,17}, constant within {13,19}, differ across, AND separate flip from control.

Run from repo root:
    python3 rust/scripts/c69_envelope.py
"""

from __future__ import annotations

import os
import sys
from collections import Counter, defaultdict
from itertools import combinations

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import c55_side_switch as c55            # noqa: E402  corpus + cohorts + gate
from onconic_child_type_alignment import chi  # noqa: E402  Legendre symbol over F_q

QS = [11, 13, 17, 19]
DEPLETED = {11, 17}
FULL = {13, 19}


# ---------------------------------------------------------------------------
# Part A -- confirm the naive tangent envelope is non-discriminating
# ---------------------------------------------------------------------------

def tangent_line(q, lam):
    """Tangent to conic XY=Z^2 at the point (lam^2:1:lam): X + lam^2 Y - 2 lam Z = 0."""
    return (1 % q, (lam * lam) % q, (-2 * lam) % q)


def concurrent(q, l1, l2, l3):
    a, b, c = l1
    d, e, f = l2
    g, h, i = l3
    det = (a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)) % q
    return det == 0


def cross(q, u, v):
    """Projective cross product, used for joins of points."""
    return ((u[1] * v[2] - u[2] * v[1]) % q,
            (u[2] * v[0] - u[0] * v[2]) % q,
            (u[0] * v[1] - u[1] * v[0]) % q)


def incident(q, point, line):
    return sum(a * b for a, b in zip(point, line)) % q == 0


def projective_points(q):
    """Canonical points of PG(2,q): (x,y,1), (x,1,0), and (1,0,0)."""
    return ([(x, y, 1) for x in range(q) for y in range(q)]
            + [(x, 1, 0) for x in range(q)] + [(1, 0, 0)])


def conic_point(q, lam):
    """Point (lam^2:1:lam) on XY=Z^2; None denotes infinity."""
    return (1, 0, 0) if lam is None else (lam * lam % q, 1, lam % q)


def tangent_line_full(q, lam):
    return (0, 1, 0) if lam is None else tangent_line(q, lam)


def partition_signature(q, params):
    """Histogram of the selected-tangent/selected-secant incidences off the conic.

    The six selected conic points determine six tangents and fifteen chords.  For
    every off-conic rational point record how many of each pass through it.  The
    sorted histogram and its coarse concurrency statistics are genuine residual
    tangent/secant-partition invariants requested by C69.
    """
    selected = [conic_point(q, t) for t in params]
    tangents = [tangent_line_full(q, t) for t in params]
    secants = [cross(q, a, b) for a, b in combinations(selected, 2)]
    all_conic = {conic_point(q, t) for t in [None, *range(q)]}
    hist = Counter()
    for p in projective_points(q):
        if p in all_conic:
            continue
        nt = sum(incident(q, p, l) for l in tangents)
        ns = sum(incident(q, p, l) for l in secants)
        hist[(nt, ns)] += 1
    items = tuple(sorted(hist.items()))
    max_sec = max(ns for (nt, ns), n in hist.items() if n)
    sec_triples = sum(n for (nt, ns), n in hist.items() if ns >= 3)
    sec_hit = sum(n for (nt, ns), n in hist.items() if ns)
    sec_chi = chi(q, sec_triples % q) if sec_triples % q else 0
    hit_chi = chi(q, sec_hit % q) if sec_hit % q else 0
    return (items, len(items), max_sec, sec_triples, sec_triples % 2,
            sec_triples % 3, sec_chi, sec_hit, sec_hit - 15 * q, hit_chi)


def part_a_check():
    """The 6 tangents at 6 distinct conic points are never 3-concurrent, at any q.
    (Params here are conic parameters lam in F_q u {inf}; inf -> tangent is the
    line at infinity's role; we sample finite params, which suffices to exhibit
    the general-position fact -- and prove the negative reading.)"""
    print("=== (A) tangent-envelope triviality (machine confirmation) ===")
    bad = 0
    checked = 0
    for q in QS:
        lams = list(range(1, q))           # finite nonzero conic params
        for tri in combinations(lams, 3):
            ls = [tangent_line(q, x) for x in tri]
            if concurrent(q, *ls):
                bad += 1
            checked += 1
    print(f"  3-concurrent tangent triples over all finite params, q in {QS}: "
          f"{bad}/{checked}  -> tangents in general position (dual conic, no 3 collinear)")
    print("  => tangent concurrence / dual-conic point count carry NO order signal; "
          "the envelope invariant must be arithmetic (Part B/C).\n")


# ---------------------------------------------------------------------------
# Part B -- genus-2 hyperelliptic arithmetic of the 6 branch points
# ---------------------------------------------------------------------------

def finite_params(rec, q):
    """The 5 finite branch points {0, t1, t2, t3, t4} (the 6th, inf, is at infinity)."""
    return [0] + [t % q for t in rec.ts] + [rec.t4 % q]


def projective_params(rec, q):
    """All six branch/conic parameters, with None denoting infinity."""
    return [None, *finite_params(rec, q)]


def a2_trace(q, roots):
    """a2 = sum_{x in F_q} chi(f(x)),  f monic with the given distinct roots.
    N2_affine = q + a2 is the affine point count of y^2 = f(x)."""
    s = 0
    for x in range(q):
        fx = 1
        for r in roots:
            fx = (fx * (x - r)) % q
        if fx:
            s += chi(q, fx)
    return s


def elem_sym_ints(signed_roots):
    """Elementary symmetric integers of the 5 finite branch points as SIGNED ints
    (0 and the signed S3/child ints) -- fixed integers for a fixed integral config."""
    # returns e1..e5 (integers)
    e = [1] + [0] * len(signed_roots)
    for r in signed_roots:
        for k in range(len(e) - 1, 0, -1):
            e[k] = e[k] + r * e[k - 1]
    return e[1:]


# ---------------------------------------------------------------------------
# corpus / cohorts
# ---------------------------------------------------------------------------

def build():
    recs = c55.load_corpus([5, 7, 11, 13, 17, 19])
    table = c55.value_table(recs)
    c55.gate(recs, table)
    coh = c55.cohorts(table)
    rec_by = {}
    for r in recs:
        rec_by[(r.q, r.sig_int)] = r
    return recs, table, coh, rec_by


def signed_roots_of_key(key):
    """key = (sorted signed S3 int tuple, signed child int) -> finite branch ints {0}+S3+child."""
    s3, ch = key
    return [0, *s3, ch]


# ---------------------------------------------------------------------------
# verdict discipline
# ---------------------------------------------------------------------------

def verdict(feature_name, feat_by):
    """feat_by[cohort][q][key] = feature value.  A viable mechanism feature is
    constant within {11,17}, constant within {13,19}, differs across, for the FLIP
    cohort, AND the control cohort does NOT show the same clean split."""
    def pooled(cohort, qs):
        vals = Counter()
        for q in qs:
            for k, v in feat_by[cohort][q].items():
                vals[v] += 1
        return vals
    fd = pooled("flip", DEPLETED)
    ff = pooled("flip", FULL)
    cd = pooled("control", DEPLETED)
    cf = pooled("control", FULL)
    const_dep = len(fd) == 1
    const_full = len(ff) == 1
    differ = const_dep and const_full and set(fd) != set(ff)
    # control must NOT reproduce the same clean constant-within split (else not flip-specific)
    ctrl_clean = len(cd) == 1 and len(cf) == 1 and set(cd) != set(cf)
    viable = differ and not ctrl_clean
    print(f"  -- feature: {feature_name} --")
    print(f"     flip    depleted{sorted(DEPLETED)} dist={dict(fd)}  full{sorted(FULL)} dist={dict(ff)}")
    print(f"     control depleted{sorted(DEPLETED)} dist={dict(cd)}  full{sorted(FULL)} dist={dict(cf)}")
    print(f"     const-within-dep={const_dep} const-within-full={const_full} "
          f"differ-across={differ} control-also-clean={ctrl_clean}  => VIABLE={viable}")
    return viable


def main():
    part_a_check()
    recs, table, coh, rec_by = build()

    # Assemble per-cohort per-q per-config geometric/arithmetic features.
    # feat structures: {feature: {cohort: {q: {key: value}}}}
    a2 = defaultdict(lambda: defaultdict(dict))
    n2 = defaultdict(lambda: defaultdict(dict))
    partition = defaultdict(lambda: defaultdict(dict))
    for name, (qd, qf, lat, flip, ctrl) in coh.items():
        for cohname, keys in (("flip", flip), ("control", ctrl)):
            for key in keys:
                for q in (qd, qf):
                    r = rec_by[(q, key)]
                    roots = finite_params(r, q)
                    t = a2_trace(q, roots)
                    a2[cohname][q][key] = t
                    n2[cohname][q][key] = q + 1 + t
                    partition[cohname][q][key] = partition_signature(
                        q, projective_params(r, q))

    print("=== (A2) residual tangent/secant partition on off-conic points ===")
    # The raw full histogram is retained in partition[...][...][...][0], but its
    # contingency table is too large to be useful in routine output.  Report its
    # dimension plus q-comparable categorical/count transforms instead.
    pnames = ("# occupied (tangent-degree,secant-degree) bins",
              "max selected-secants through a point",
              "# points on >=3 selected secants", "triple-point count parity",
              "triple-point count mod 3", "chi_q(triple-point count)",
              "# points on >=1 selected secant", "secant-hit defect (#hit-15q)",
              "chi_q(secant-hit count)")
    for i, pname in enumerate(pnames, start=1):
        d = defaultdict(lambda: defaultdict(dict))
        for coh_name in ("flip", "control"):
            for q in QS:
                for key, sig in partition[coh_name][q].items():
                    d[coh_name][q][key] = sig[i]
        verdict(pname, d)

    print("=== (B) genus-2 hyperelliptic trace a2 = sum chi(f(x)) ===")
    print("  (raw a2 samples: minimal witness S3={-4,-3,-2} child=1)")
    wk = ((-4, -3, -2), 1)
    for q in QS:
        r = rec_by.get((q, wk))
        if r:
            roots = finite_params(r, q)
            t = a2_trace(q, roots)
            val = table[wk].get(q)
            print(f"    q={q:2d} value={val}  character_sum={t:+3d}  #C(F_q)={q+1+t}")

    print("\n=== verdict discipline over q-comparable arithmetic features ===")
    # q-comparable features derived from a2 / N2
    feats = {}
    def add_feature(fname, fn_over):
        d = defaultdict(lambda: defaultdict(dict))
        for coh_name in ("flip", "control"):
            for q in QS:
                for key, v in a2[coh_name][q].items():
                    d[coh_name][q][key] = fn_over(v, q, n2[coh_name][q][key])
        feats[fname] = d

    add_feature("sign(a2)", lambda a, q, n: (a > 0) - (a < 0))
    add_feature("a2==0", lambda a, q, n: a == 0)
    add_feature("abs(a2)", lambda a, q, n: abs(a))
    add_feature("a2 squared", lambda a, q, n: a * a)
    add_feature("a2 parity", lambda a, q, n: a % 2)
    add_feature("N2 parity", lambda a, q, n: n % 2)
    add_feature("a2 mod 3", lambda a, q, n: a % 3)
    add_feature("a2 mod 4", lambda a, q, n: a % 4)
    add_feature("chi_q(a2) if a2!=0 else 0",
                lambda a, q, n: (chi(q, a % q) if a % q else 0))
    add_feature("N2 mod 3", lambda a, q, n: n % 3)

    any_viable = False
    for fname, d in feats.items():
        if verdict(fname, d):
            any_viable = True

    print("\n=== (C) chi_q of derived integer resultants (Igusa-flavored) ===")
    # These normalized-coordinate polynomials are diagnostics, not absolute PGL
    # invariants.  Preserve every (pair, cohort, key) membership: a key may occur
    # in different roles in the two q-pairs.
    for dname in ("e2", "e4", "sum_sq", "vandermonde_sq"):
        d = defaultdict(lambda: defaultdict(dict))
        for name, (qd, qf, lat, flip, ctrl) in coh.items():
            for coh_name, keys in (("flip", flip), ("control", ctrl)):
                for key in keys:
                    sr = signed_roots_of_key(key)
                    nz = [r for r in sr if r != 0]
                    e = elem_sym_ints(nz)
                    pairprod = 1
                    for a, b in combinations(sr, 2):
                        pairprod *= a - b
                    info = {
                        "e2": e[1] if len(e) > 1 else 0,
                        "e4": e[3] if len(e) > 3 else 0,
                        "sum_sq": sum(r * r for r in sr),
                        "vandermonde_sq": pairprod * pairprod,
                    }
                    D = info[dname]
                    for q in (qd, qf):
                        d[coh_name][q][key] = (chi(q, D % q) if D % q else 0)
        if verdict(f"chi_q({dname})", d):
            any_viable = True

    # ---- Part D: exploratory all-four-orders side pattern ----
    # The witness has a2 = (0,-4,0,-4) over (11,13,17,19): side-constant within
    # {11,17} and {13,19}, side-differ across.  The pooled test above cannot see a
    # per-config side pattern; test it directly over configs present at ALL 4 orders.
    print("\n=== (D) PER-CONFIG all-four-orders a2 side pattern ===")
    at4 = [k for k, perq in table.items() if all(q in perq for q in QS)]
    # value pattern classes
    def vpat(k):
        return "".join(table[k].get(q, "-") for q in QS)  # order 11,13,17,19
    a2_all = {}
    for k in at4:
        a2_all[k] = {}
        for q in QS:
            # need a record for (q,k); reconstruct roots from key (q-independent ints)
            sr = signed_roots_of_key(k)
            roots = [r % q for r in sr]
            a2_all[k][q] = a2_trace(q, roots)

    def side_pattern(k):
        a = a2_all[k]
        side_const = (a[11] == a[17]) and (a[13] == a[19])
        side_differ = side_const and ({a[11]} != {a[13]})
        return side_const, side_differ

    byclass = defaultdict(list)
    for k in at4:
        byclass[vpat(k)].append(k)
    print(f"  integral types present at all 4 orders: {len(at4)}")
    print(f"  value-pattern classes: {dict((p, len(v)) for p, v in sorted(byclass.items()))}")
    print("  (pattern order = value at q=11,13,17,19; NPNP = the arc-depleted flip)")
    for pat in sorted(byclass):
        ks = byclass[pat]
        sc = sum(side_pattern(k)[0] for k in ks)
        sd = sum(side_pattern(k)[1] for k in ks)
        # sample a couple of a2 vectors
        samp = [tuple(a2_all[k][q] for q in QS) for k in ks[:4]]
        print(f"    value-pattern {pat}: n={len(ks):3d}  a2 side-constant={sc:3d}  "
              f"side-constant&differ={sd:3d}   e.g. a2-vectors {samp}")
    print("  NOTE: only two NPNP types survive this four-order intersection.  This is a")
    print("  falsifiable near-hit, not a C69-positive: it neither covers the 119 flips nor")
    print("  passes the paired flip/control verdict discipline used above.")
    print("  NPNP configs (S3params, child):", byclass.get("NPNP", []),
          "(genuinely distinct integral configs, not one orbit)")

    # ---- Part E: does a2 track the flip WITHIN each pair cohort (the real 119)? ----
    # Shows the q=11 'all N-flip a2=0' near-hit is a small-field artifact that does not
    # hold at the other depleted order q=17.
    print("\n=== (E) a2 across each pair cohort: flip (value changes) vs control (same) ===")
    for name, (qd, qf, lat, flip, ctrl) in coh.items():
        print(f"  ---- pair {name} (depleted q={qd} N-side -> full q={qf} P-side) ----")
        for cohname, keys in (("flip", flip), ("control", ctrl)):
            changed, dep_dist, full_dist = 0, Counter(), Counter()
            for k in keys:
                ad = a2_trace(qd, [r % qd for r in signed_roots_of_key(k)])
                af = a2_trace(qf, [r % qf for r in signed_roots_of_key(k)])
                dep_dist[ad] += 1
                full_dist[af] += 1
                changed += (ad != af)
            print(f"    {cohname:7s} n={len(keys):3d}  a2 changed across pair: {changed}/{len(keys)}")
            print(f"            a2@depleted dist={dict(sorted(dep_dist.items()))}")
            print(f"            a2@full     dist={dict(sorted(full_dist.items()))}")
        print()

    print("\n=== VERDICT ===")
    if any_viable:
        print("  At least one envelope/derived-curve feature is VIABLE -- inspect above; "
              "emit q=23/q=25 prediction.")
    else:
        print("  NEGATIVE: no tested envelope/derived-curve feature separates the flip along the")
        print("  {11,17} vs {13,19} dichotomy while sparing controls.  All three dichotomy")
        print("  tested mechanism families (C55 group / C64 extremal / C69 algebraic) are dead;")
        print("  the (ON) uniform route rests on the q-dependent A5 arc-depletion arithmetic")
        print("  with no configuration-level mechanism.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
