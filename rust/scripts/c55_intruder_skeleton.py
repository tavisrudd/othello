#!/usr/bin/env python3
"""C55 step 3 -- ACTUAL legal-intruder secant/defect skeleton across the pair.

The abstract C18 involution-product dictionary (c55_side_switch.py) is a proxy;
the geometrically faithful object of Lemma VI is the pair of ACTUAL legal
off-conic intruders x, x' in the S4 follower and the secant of line xx' (present
iff rho = sigma_x sigma_x' is SPLIT, i.e. has 2 fixed conic params; absent iff
ELLIPTIC, 0 fixed params).  For each flipping on-conic S4 (and matched controls)
this computes, at BOTH orders of the pair, the split/elliptic/parabolic
composition of the actual intruder-pair spectrum and the NK defect spectra, and
tests whether the skeleton SWAPS where the value flips (H-side-switch) vs where
it does not (controls).

Self-contained conic model (as 2026-07-08-nk-involution-check.py):
    pre-played a=(1:0:0)=INF, b=(0:1:0)=0; conic C: r*c=1, cell(t)=(t, 1/t);
    on-conic S4 = the 4 params {t1,t2,t3,t4}.

Run from repo root:
    python3 rust/scripts/c55_intruder_skeleton.py                 # sample
    python3 rust/scripts/c55_intruder_skeleton.py --all           # all cohort configs
    python3 rust/scripts/c55_intruder_skeleton.py --witness       # minimal-witness solve
"""

from __future__ import annotations

import itertools
import os
import sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import c55_side_switch as c55   # noqa: E402  (corpus, cohorts, gate)
from onconic_child_type_alignment import build_records_prime, FEAT_FILES, DATA  # noqa: E402

INF = "INF"


class Conic:
    """Geometry over F_q for the standard hyperbola r*c=1 model."""

    def __init__(self, q):
        self.q = q
        self.inv = {t: pow(t, q - 2, q) for t in range(1, q)}
        self.A = (1, 0, 0)          # INF
        self.B = (0, 1, 0)          # 0
        self.params = [INF, 0] + list(range(1, q))

    def pt(self, s):
        if s == INF:
            return self.A
        if s == 0:
            return self.B
        return (s % self.q, self.inv[s % self.q], 1)

    def cell(self, s):
        return (s % self.q, self.inv[s % self.q])

    def det(self, p, r, s):
        q = self.q
        return (p[0] * (r[1] * s[2] - r[2] * s[1])
                - p[1] * (r[0] * s[2] - r[2] * s[0])
                + p[2] * (r[0] * s[1] - r[1] * s[0])) % q

    def collinear(self, p, r, s):
        return self.det(p, r, s) == 0

    def sigma(self, x_pt):
        """Involution on params induced by projection from off-conic x_pt."""
        perm = {}
        for s in self.params:
            hits = [s2 for s2 in self.params
                    if s2 != s and self.collinear(x_pt, self.pt(s), self.pt(s2))]
            perm[s] = hits[0] if len(hits) == 1 else s   # tangency param -> fixed
        return perm

    def legal_intruders(self, T4):
        """Off-conic cells legal above the on-conic S4 with params T4."""
        q = self.q
        played_pts = [self.A, self.B] + [self.pt(t) for t in T4]
        played_cells = {self.cell(t) for t in T4}
        out = []
        for u in range(q):
            for v in range(q):
                if (u * v) % q == 1:            # on conic
                    continue
                if (u, v) in played_cells:
                    continue
                x = (u, v, 1)
                ok = True
                for i in range(len(played_pts)):
                    for j in range(i + 1, len(played_pts)):
                        if self.collinear(x, played_pts[i], played_pts[j]):
                            ok = False
                            break
                    if not ok:
                        break
                if ok:
                    out.append((u, v))
        return out

    def second_legal(self, T4, x, y):
        """Is y legal after x is played above S4 (simultaneous 2-intruder)?"""
        played_pts = [self.A, self.B] + [self.pt(t) for t in T4] + [(x[0], x[1], 1)]
        yp = (y[0], y[1], 1)
        for i in range(len(played_pts)):
            for j in range(i + 1, len(played_pts)):
                if self.collinear(yp, played_pts[i], played_pts[j]):
                    return False
        return True

    def rho_fixed_params(self, sx, sy):
        """# fixed params of rho = sx o sy among the q+1 params (Lemma VI:
        2 => split/secant present, 0 => elliptic/absent, 1 => parabolic/tangent)."""
        return sum(1 for s in self.params if sx[sy[s]] == s)


def side_of_pair(nfix):
    return {2: "split", 0: "elliptic", 1: "parabolic"}.get(nfix, f"fix{nfix}")


def intruder_pair_census(q, T4, cap_pairs=None):
    """(d/side census of ACTUAL simultaneously-legal intruder pairs) for on-conic
    S4 with params T4.  Returns Counter over side, secant-present count, #pairs,
    #intruders."""
    C = Conic(q)
    intr = C.legal_intruders(T4)
    sig = {x: C.sigma((x[0], x[1], 1)) for x in intr}
    side = Counter()
    npairs = 0
    pairs = itertools.combinations(intr, 2)
    for (x, y) in pairs:
        if not C.second_legal(T4, x, y):
            continue
        nfix = C.rho_fixed_params(sig[x], sig[y])
        side[side_of_pair(nfix)] += 1
        npairs += 1
        if cap_pairs and npairs >= cap_pairs:
            break
    return side, npairs, len(intr)


def params_at(rec, q):
    """The 4 on-conic S4 params (S3 params + child) as F_q residues."""
    return tuple(sorted((t % q for t in rec.ts)) + [rec.t4 % q])


def run_skeleton(all_configs=False, cap_pairs=4000):
    qs = [5, 7, 11, 13, 17, 19]
    recs = c55.load_corpus(qs)
    table = c55.value_table(recs)
    c55.gate(recs, table)
    coh = c55.cohorts(table)
    rec_by = {}
    for r in recs:
        rec_by[(r.q, r.sig_int)] = r

    print("\n=== (3) ACTUAL-INTRUDER SECANT SKELETON across each pair ===")
    print("  For each config: split/elliptic share of the ACTUAL simultaneously-legal")
    print("  intruder-pair spectrum at the depleted vs full order.  H-side-switch")
    print("  predicts flip configs GAIN secants (split share up) going depleted->full,")
    print("  more than controls.\n")

    for name, (qd, qf, lat, flip, ctrl) in coh.items():
        print(f"  ---- pair {name} (q={qd} -> {qf}) ----")
        for cohname, keys in (("flip", flip), ("control", ctrl)):
            sample = keys if all_configs else keys[:12]
            d_split_frac = []
            f_split_frac = []
            delta = []          # (split share at full) - (split share at depleted)
            for key in sample:
                rd, rf = rec_by[(qd, key)], rec_by[(qf, key)]
                sd, nd, _id = intruder_pair_census(qd, params_at(rd, qd), cap_pairs)
                sf, nf, _if = intruder_pair_census(qf, params_at(rf, qf), cap_pairs)
                sp_d = sd["split"] / nd if nd else 0.0
                sp_f = sf["split"] / nf if nf else 0.0
                d_split_frac.append(sp_d)
                f_split_frac.append(sp_f)
                delta.append(sp_f - sp_d)
            n = len(sample)
            md = sum(d_split_frac) / n
            mf = sum(f_split_frac) / n
            mdelta = sum(delta) / n
            print(f"    {cohname:7s} n={n:3d}  mean secant(split) share: "
                  f"depleted={md:.3f}  full={mf:.3f}  "
                  f"mean delta(full-depleted)={mdelta:+.3f}")
        print()


def within_q_by_value(cap_pairs=6000):
    """Within-q control: at a FIXED order, do N-valued on-conic children have a
    LOWER actual-intruder secant(split) share than P-valued ones?  This is the
    mechanism's core prediction (secant absent -> N) with q held constant -- the
    cleanest discriminator, immune to the generic q-monotone secant growth."""
    print("\n=== (3c) WITHIN-Q secant(split) share by value (q held constant) ===")
    print("  H-side-switch core prediction: N children have LOWER secant share than P.\n")
    for q in (11, 13, 17, 19):
        recs = build_records_prime(q, os.path.join(DATA, FEAT_FILES[q]))
        by_val = {"P": [], "N": []}
        for r in recs:
            side, npairs, _ = intruder_pair_census(q, params_at(r, q), cap_pairs)
            if npairs:
                by_val[r.val].append(side["split"] / npairs)
        def ms(xs):
            return (sum(xs) / len(xs)) if xs else float("nan")
        nP, nN = len(by_val["P"]), len(by_val["N"])
        print(f"  q={q:2d}  P: n={nP:3d} mean secant share={ms(by_val['P']):.3f}   "
              f"N: n={nN:3d} mean secant share={ms(by_val['N']):.3f}   "
              f"(N<P predicted; {'HOLDS' if nN and ms(by_val['N'])<ms(by_val['P']) else 'FAILS/na'})")


def solve_witness():
    """Full-game solve of the minimal witness config to ground the skeleton:
       config {inf,0,-4,-3,-2,1}: N@11, P@13, N@17, P@19 (child t4=1)."""
    print("\n=== (3b) MINIMAL-WITNESS full-game solve + winning-structure ===")
    print("  config S3 params {-4,-3,-2}, child 1  (alignment report minimal witness)")
    S3 = [-4, -3, -2]
    child = 1
    for q in (11, 13, 17, 19):
        C = Conic(q)
        T4 = tuple(sorted((t % q for t in S3)) + [child % q])
        all_cells = [(u, v) for u in range(q) for v in range(q)]

        def legal(c, ppts, pcells):
            if c in pcells:
                return False
            x = (c[0], c[1], 1)
            for i in range(len(ppts)):
                for j in range(i + 1, len(ppts)):
                    if C.collinear(x, ppts[i], ppts[j]):
                        return False
            return True

        memo = {}

        def value(pcells):
            key = frozenset(pcells)
            if key in memo:
                return memo[key]
            ppts = [C.A, C.B] + [(c[0], c[1], 1) for c in pcells]
            res = False
            for c in all_cells:
                if legal(c, ppts, key):
                    if not value(key | {c}):
                        res = True
                        break
            memo[key] = res
            return res

        base = frozenset(C.cell(t) for t in T4)
        v = value(base)                       # True = N (mover wins)
        # winning move census
        ppts6 = [C.A, C.B] + [C.pt(t) for t in T4]
        win_conic = win_intr = 0
        for c in all_cells:
            if legal(c, ppts6, base) and not value(base | {c}):
                if (c[0] * c[1]) % q == 1:
                    win_conic += 1
                else:
                    win_intr += 1
        # actual-intruder secant census
        side, npairs, nintr = intruder_pair_census(q, T4)
        sp = side["split"] / npairs if npairs else 0.0
        print(f"  q={q:2d} T4={T4}  value={'N' if v else 'P'}  "
              f"winning moves: conic={win_conic} intruder={win_intr}  | "
              f"intruders={nintr} pairs={npairs} secant(split)share={sp:.3f} "
              f"sides={dict(side)}")


def main():
    if "--witness" in sys.argv:
        solve_witness()
        return 0
    run_skeleton(all_configs="--all" in sys.argv)
    within_q_by_value()
    if "--all" not in sys.argv:
        solve_witness()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
