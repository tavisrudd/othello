#!/usr/bin/env python3
"""C55 -- d-lattice side-switch diagnostic for the arc-depleted-orders dichotomy.

Hypothesis (H-side-switch, Fable 2026-07-09):
    the 119 cross-q value flips (the on-conic size-4 children that are N at the
    arc-depleted orders q in {11,17} and P at the full orders q in {13,19}) are
    mediated by SHARED-LATTICE product orders d = ord(sigma sigma') realised
    SPLIT at 13/19 (d | q-1) and ELLIPTIC at 11/17 (d | q+1).  The flip pairs
    share a divisor lattice:  11+1 = 13-1 = 12  and  17+1 = 19-1 = 18.  By
    Lemma VI (2026-07-08-nk-involution-residual.md) the xx'-secant K2 is PRESENT
    iff d | q-1 (split) and ABSENT iff d | q+1 (elliptic), so if the SAME
    configuration realises the same shared-lattice d on opposite split/elliptic
    sides across a pair, its defect skeleton genuinely differs -- a mechanism for
    the flip that C18 never tested (C18 pooled bucket values across q; this is a
    PAIRED CONTRAST on matched configurations).

This script:
  (0) rebuilds the on-conic child corpus and re-runs the alignment GATE
      (119 obstructions, N@{11,17}/P@{13,19}; C5/C15 bucket labels reproduced);
  (1) forms the involution-product order profile of each 6-subset at each q,
      using the SAME "involution fixing a 2-subset of the six points" dictionary
      as C18, each product tagged by divisor class (d|q-1 split / d|q+1 elliptic
      / d=p parabolic);
  (2) runs the paired side-switch contingency test, flip cohort vs control;
  (3) is imported by the skeleton-verification / prediction drivers.

Run from repo root:
    python3 rust/scripts/c55_side_switch.py           # q = 5,7,11,13,17,19
"""

from __future__ import annotations

import os
import sys
from collections import Counter, defaultdict
from itertools import combinations

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

# Reuse the vetted corpus machinery (conic reconstruction, PGL canon, integral
# type, feat parsing, Legendre symbol) verbatim -- do not re-derive it.
import onconic_child_type_alignment as base  # noqa: E402
from onconic_child_type_alignment import (  # noqa: E402
    INF, FEAT_FILES, DATA, chi, inv,
    build_records_prime, integral_type,
)

# ---------------------------------------------------------------------------
# involution machinery over P^1(F_q)  (PGL(2,q), entries mod q)
# ---------------------------------------------------------------------------

def invol_fix(q, a, b):
    """2x2 matrix (A,B,C,D) of the (unique) involution fixing the pair {a,b}.

    Trace 0 => M^2 = -det*I is scalar => genuine involution.  a,b in F_q u {inf},
    a != b.  Finite pair: [[a+b, -2ab],[2, -(a+b)]] (fixed pts roots of
    (x-a)(x-b)).  With inf: x -> 2b - x, matrix [[-1, 2b],[0,1]]."""
    if a == INF:
        return ((-1) % q, (2 * b) % q, 0, 1)
    if b == INF:
        return ((-1) % q, (2 * a) % q, 0, 1)
    return ((a + b) % q, (-2 * a * b) % q, 2 % q, (-(a + b)) % q)


def mat_mul(q, m, n):
    a, b, c, d = m
    e, f, g, h = n
    return ((a * e + b * g) % q, (a * f + b * h) % q,
            (c * e + d * g) % q, (c * f + d * h) % q)


def det(q, m):
    a, b, c, d = m
    return (a * d - b * c) % q


def is_scalar(q, m):
    a, b, c, d = m
    return b % q == 0 and c % q == 0 and a % q == d % q


def pgl_order(q, m):
    """Order of m in PGL(2,q): least k>=1 with m^k scalar."""
    if is_scalar(q, m):
        return 1
    p = m
    for k in range(1, q * q):
        if is_scalar(q, p):
            return k
        p = mat_mul(q, p, m)
    raise RuntimeError(("no order", q, m))


def side_of(q, m):
    """Classify m in PGL(2,q) by fixed-point structure of the field:
    'split' (2 fixed pts in F_q, d|q-1), 'elliptic' (0 in F_q, d|q+1),
    'parabolic' (1 fixed pt, d=p), 'id' (scalar)."""
    if is_scalar(q, m):
        return "id"
    a, b, c, d = m
    delta = ((a + d) * (a + d) - 4 * det(q, m)) % q   # tr^2 - 4 det
    if delta == 0:
        return "parabolic"
    return "split" if chi(q, delta) == 1 else "elliptic"


# ---------------------------------------------------------------------------
# per-record involution-product profile (C18 dictionary: 15 point-pair
# involutions, C(15,2)=105 products)
# ---------------------------------------------------------------------------

def roled_points(q, rec):
    """List of (F_q value, role label) for the six conic params of a record.
    Roles are q-INDEPENDENT so products align across the pair:
      'INF', 'B0' (burned 0), 'C' (child), 'S<signed-int>' (each S3 param)."""
    pts = [(INF, "INF"), (0, "B0"), (rec.t4, "C")]
    for t in rec.ts:
        pts.append((t % q, "S%+d" % base.signed(t, q)))
    labels = [lab for _, lab in pts]
    assert len(set(labels)) == 6, (q, rec.sig_int, labels)
    return pts


def invprod_profile_roled(q, rec):
    """Map (rolepair_i, rolepair_j) -> (d, side) over the 105 products of the 15
    point-pair involutions.  Keyed by role labels so the same abstract product is
    comparable at a different q."""
    pts = roled_points(q, rec)
    invs = {}   # frozenset(role_a, role_b) -> matrix
    for (va, la), (vb, lb) in combinations(pts, 2):
        invs[frozenset((la, lb))] = invol_fix(q, va, vb)
    assert len(invs) == 15
    keys = sorted(invs, key=lambda s: tuple(sorted(s)))
    prof = {}
    for i in range(len(keys)):
        for j in range(i + 1, len(keys)):
            m = mat_mul(q, invs[keys[i]], invs[keys[j]])
            d, s = pgl_order(q, m), side_of(q, m)
            prof[(keys[i], keys[j])] = (d, s)
    assert len(prof) == 105
    return prof


# ---------------------------------------------------------------------------
# corpus assembly + paired cohorts
# ---------------------------------------------------------------------------

PAIRS = {                    # arc-depleted (elliptic side) -> full (split side)
    "11/13": (11, 13, 12),   # 11+1 = 13-1 = 12
    "17/19": (17, 19, 18),   # 17+1 = 19-1 = 18
}


def load_corpus(qs):
    recs = []
    for q in qs:
        recs.extend(build_records_prime(q, os.path.join(DATA, FEAT_FILES[q])))
    return recs


def value_table(recs):
    """integral-type key -> {q: value}, only where within-q value is unique."""
    tmp = defaultdict(lambda: defaultdict(set))
    for r in recs:
        tmp[r.sig_int][r.q].add(r.val)
    table = {}
    for key, perq in tmp.items():
        table[key] = {q: next(iter(v)) for q, v in perq.items() if len(v) == 1}
    return table


def gate(recs, table):
    """Reproduce the alignment report's headline gate numbers."""
    multi = [k for k, perq in table.items() if len(perq) >= 2]
    obstr, aligned = [], []
    for k in multi:
        vals = set(table[k].values())
        (obstr if len(vals) > 1 else aligned).append(k)
    n11 = sum(1 for k in obstr if table[k].get(11) == "N")
    n17 = sum(1 for k in obstr if table[k].get(17) == "N")
    n_full_N = sum(1 for k in obstr if table[k].get(13) == "N" or table[k].get(19) == "N")
    print("=== (0) ALIGNMENT GATE (must match 2026-07-09-onconic-child-type-alignment.md) ===")
    print(f"  integral types total={len(table)}  appear at >=2 q={len(multi)}  "
          f"aligned={len(aligned)}  OBSTRUCTIONS={len(obstr)}")
    print(f"  obstructions N@q=11: {n11}   N@q=17: {n17}   "
          f"N at a full order (13 or 19): {n_full_N}")
    ok = (len(obstr) == 119 and n11 == 16 and n17 == 105 and n_full_N == 0)
    print(f"  GATE: {'PASS' if ok else 'FAIL -- corpus does not reproduce the report'}")
    return obstr, aligned, ok


def cohorts(table):
    """For each pair, split the shared configs into flip / control cohorts.

    flip    : N at the depleted order, P at the full order (the mechanism target)
    control : appears at both orders of the pair with the SAME value (matched
              non-flipping shared configuration)
    """
    out = {}
    for name, (qd, qf, lat) in PAIRS.items():
        flip, ctrl = [], []
        for key, perq in table.items():
            if qd in perq and qf in perq:
                vd, vf = perq[qd], perq[qf]
                if vd == "N" and vf == "P":
                    flip.append(key)
                elif vd == vf:
                    ctrl.append(key)
                # (P@depleted,N@full) never occurs per the report; ignore if seen
        out[name] = (qd, qf, lat, flip, ctrl)
    return out


def divisors(n):
    return {k for k in range(1, n + 1) if n % k == 0}


def paired_switch_counts(rec_d, rec_f, qd, qf, disjoint_only=True):
    """Per-config side-switch census over the aligned involution products.

    disjoint_only restricts to the 45 pairs of point-pair involutions whose
    fixed-point pairs are DISJOINT -- the 60 pairs sharing a point are parabolic
    at every q (product fixes the shared point) and carry no secant information.
    Returns Counter over (side_at_depleted, side_at_full) plus the ell->split and
    split->ell product lists, and the per-d full-order order histogram of the
    ell->split switches."""
    pd = invprod_profile_roled(qd, rec_d)
    pf = invprod_profile_roled(qf, rec_f)
    assert set(pd) == set(pf)
    cnt = Counter()
    ell2split, split2ell = [], []
    for k in pd:
        (ra, rb) = k
        if disjoint_only and (ra & rb):     # shared fixed point -> skip
            continue
        sd, sf = pd[k][1], pf[k][1]
        cnt[(sd, sf)] += 1
        if sd == "elliptic" and sf == "split":
            ell2split.append((k, pd[k][0], pf[k][0]))
        elif sd == "split" and sf == "elliptic":
            split2ell.append((k, pd[k][0], pf[k][0]))
    return cnt, ell2split, split2ell


def run_paired_test(recs, coh):
    rec_by = defaultdict(dict)     # q -> {sig_int: rec}
    for r in recs:
        rec_by[r.q][r.sig_int] = r

    print("\n=== (1)-(2) PAIRED SIDE-SWITCH TEST (involution-product dictionary) ===")
    print("  A product is 'ell->split' if it is ELLIPTIC (secant K2 absent) at the")
    print("  depleted order and SPLIT (secant K2 present) at the full order -- the")
    print("  depletion-consistent switch H-side-switch predicts to drive N->P.\n")

    for name, (qd, qf, lat, flip, ctrl) in coh.items():
        print(f"  ---- pair {name}  (depleted q={qd} -> full q={qf}, lattice={lat};"
              f" 45 disjoint products/config) ----")
        rows = {"flip": flip, "control": ctrl}
        agg_dir = Counter()      # (cohort, (sd,sf)) over disjoint products
        agg_d = Counter()        # (cohort, d_full) over ell->split switches
        nets = {}                # cohort -> list of per-config (e2s - s2e)
        for cohname, keys in rows.items():
            e2s_counts, net_counts = [], []
            for key in keys:
                cnt, e2s, s2e = paired_switch_counts(rec_by[qd][key], rec_by[qf][key], qd, qf)
                e2s_counts.append(len(e2s))
                net_counts.append(len(e2s) - len(s2e))
                for (sd, sf), c in cnt.items():
                    agg_dir[(cohname, (sd, sf))] += c
                for (_k, _dd, df) in e2s:
                    agg_d[(cohname, df)] += 1
            nets[cohname] = net_counts
            mean_e2s = sum(e2s_counts) / len(e2s_counts)
            mean_net = sum(net_counts) / len(net_counts)
            print(f"    {cohname:7s} n={len(keys):3d}  mean ell->split = {mean_e2s:5.2f}   "
                  f"mean NET (ell->spl minus spl->ell) = {mean_net:+5.2f}   "
                  f"net dist={dict(sorted(Counter(net_counts).items()))}")
        print("    aggregate side-pair census (share of 45*n disjoint products):")
        for cohname in ("flip", "control"):
            tot = len(rows[cohname]) * 45
            parts = {f"{sd[:3]}->{sf[:3]}": agg_dir[(cohname, (sd, sf))]
                     for (cn, (sd, sf)) in agg_dir if cn == cohname}
            frac = {k: f"{v/tot:.3f}" for k, v in
                    sorted(parts.items(), key=lambda kv: -kv[1])}
            print(f"      {cohname:9s} (tot={tot}) {frac}")
        print("    ell->split switches by order d at the full order:")
        for cohname in ("flip", "control"):
            perd = {d: agg_d[(cohname, d)] for (cn, d) in agg_d if cn == cohname}
            n = len(rows[cohname])
            perd = {d: f"{c}({c/n:.2f}/cfg)" for d, c in sorted(perd.items())}
            print(f"      {cohname:9s} {perd}")
        print()


def main():
    qs = [5, 7, 11, 13, 17, 19]
    if len(sys.argv) > 1:
        qs = [int(x) for x in sys.argv[1:]]
    recs = load_corpus(qs)
    print(f"loaded on-conic children = {len(recs)} over q = {qs}\n")

    table = value_table(recs)
    obstr, aligned, ok = gate(recs, table)

    print("\n=== paired cohorts (shared integral types present at both orders) ===")
    coh = cohorts(table)
    for name, (qd, qf, lat, flip, ctrl) in coh.items():
        print(f"  pair {name} (depleted q={qd} elliptic-side, full q={qf} split-side, "
              f"lattice={lat}): flip={len(flip)}  control={len(ctrl)}")

    run_paired_test(recs, coh)
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
