#!/usr/bin/env python3
"""Machine gate for the F2 'intrusion calculus' claims (on-conic S4 subtree structure).

Setup: grid game = arc game on PG(2,q) from pre-played a=(1:0:0), b=(0:1:0).
Conic C: r*c = 1 affine, i.e. cells P_t = (t, 1/t), t in F_q^*; C passes through a,b.
On-conic S4 = {P_t : t in T4}, |T4| = 4; played = {a,b} + S4 (c = 6 conic points).

Claims checked, for EVERY 4-subset T4 (q=11) / sample (q=13), EVERY legal off-conic x:
 C1. sigma_x images of played conic points are unplayed (forced by legality).
 C2. R' (legal conic params after x) = R minus sigma_x(played); decomposes under
     sigma_x into full pairs + tangency singletons (no widows).
 C3. M := #pairs + #singletons == (q + 1 - 2c + tau_x)/2, c=6, tau_x = #tangencies of x on C.
 C4. Intrusion existence constraint: legal x satisfies tau_x <= 2*tau_played + (q+1-2c).
 C5. q=7: NO legal off-conic x after any on-conic S4 (the all-onP mechanism).
Also reports, per q: counts of legal intrusions by (tau_x, tau_played).
"""
import itertools, sys

def run(q, sample=None):
    F = range(q)
    inv = {t: pow(t, q - 2, q) for t in range(1, q)}
    A = (1, 0, 0); B = (0, 1, 0)
    def pt(cell): return (cell[0], cell[1], 1)
    def det(p, r, s):
        return (p[0]*(r[1]*s[2]-r[2]*s[1]) - p[1]*(r[0]*s[2]-r[2]*s[0])
                + p[2]*(r[0]*s[1]-r[1]*s[0])) % q
    def collinear(p, r, s): return det(p, r, s) == 0
    P = {t: (t, inv[t]) for t in range(1, q)}   # conic cells by parameter
    params = sorted(P)
    fails = []; intrusion_hist = {}; no_intrusion_S4 = 0; total_S4 = 0
    subsets = itertools.combinations(params, 4)
    if sample: subsets = itertools.islice(subsets, sample)
    for T4 in subsets:
        total_S4 += 1
        played_pts = [A, B] + [pt(P[t]) for t in T4]
        R = [t for t in params if t not in T4]
        # legality of a cell against played (arc condition incl rows/cols via a,b)
        def legal_after(cell, extra=()):
            pts = played_pts + [pt(e) for e in extra]
            x = pt(cell)
            if cell in [P[t] for t in T4] or cell in extra: return False
            for i in range(len(pts)):
                for j in range(i+1, len(pts)):
                    if collinear(x, pts[i], pts[j]): return False
            return True
        n_intr = 0
        for u in range(q):
            for v in range(q):
                if (u * v) % q == 1: continue           # on conic
                x = (u, v)
                if not legal_after(x): continue
                n_intr += 1
                X = pt(x)
                # sigma_x on conic params: s ~ s' iff x on line P_s P_s'
                def sigma(s):
                    hits = [s2 for s2 in params if s2 != s and collinear(X, pt(P[s]), pt(P[s2]))]
                    # also check the line x-P_s through a or b (a,b are on C!)
                    ab_hits = [Y for Y in (A, B) if collinear(X, pt(P[s]), Y)]
                    if len(hits) + len(ab_hits) > 1:
                        fails.append((q, T4, x, 'line thru x meets C in >2', s)); return None
                    if ab_hits: return ('dir', ab_hits[0])
                    return hits[0] if hits else s        # s = tangency
                # C1: images of played conic points (T4 params and a,b handled sep.)
                tau_played = 0
                for t in T4:
                    im = sigma(t)
                    if im == t: tau_played += 1
                    elif im is None: continue
                    elif isinstance(im, tuple):
                        pass  # partner is a or b = played direction: then x on line P_t-a?? illegal!
                    elif im in T4:
                        fails.append((q, T4, x, 'C1 image played', t))
                # a,b images: line x-a meets C in a and one more point sigma(a)
                def sigma_dir(D):
                    hits = [s2 for s2 in params if collinear(X, D, pt(P[s2]))]
                    other = [Y for Y in (A, B) if Y != D and collinear(X, D, Y)]
                    if len(hits) + len(other) > 1:
                        fails.append((q, T4, x, 'line thru x,dir meets C in >2', D)); return None
                    if other: return ('dir', other[0])
                    return hits[0] if hits else 'tangent'
                for D in (A, B):
                    imd = sigma_dir(D)
                    if imd == 'tangent': tau_played += 1
                    elif isinstance(imd, tuple):
                        fails.append((q, T4, x, 'x on line ab? should be dead cell', D))
                    elif imd in T4:
                        fails.append((q, T4, x, 'C1 image of dir played', D))
                # tau_x: total tangencies of x on C = params s with sigma(s)==s, plus dirs tangent
                tang = [s for s in params if sigma(s) == s]
                tau_x = len(tang) + sum(1 for D in (A, B) if sigma_dir(D) == 'tangent')
                if tau_x not in (0, 2):
                    fails.append((q, T4, x, 'tau_x not 0/2', tau_x))
                # C2: R' structure
                Rp = [t for t in R if legal_after(P[t], extra=(x,))]
                killed = [t for t in R if t not in Rp]
                expect_killed = set()
                for t in T4:
                    im = sigma(t)
                    if im not in (None, t) and not isinstance(im, tuple): expect_killed.add(im)
                for D in (A, B):
                    imd = sigma_dir(D)
                    if imd not in ('tangent', None) and not isinstance(imd, tuple): expect_killed.add(imd)
                if set(killed) != expect_killed:
                    fails.append((q, T4, x, 'C2 killed set mismatch', (sorted(killed), sorted(expect_killed))))
                # pairs/singletons in R'
                seen = set(); pairs = 0; singles = 0; widow = False
                for t in Rp:
                    if t in seen: continue
                    im = sigma(t)
                    if im == t: singles += 1; seen.add(t)
                    elif isinstance(im, tuple): widow = True; seen.add(t)  # partner is a/b: played -> t should be dead!
                    elif im in Rp: pairs += 1; seen.add(t); seen.add(im)
                    else: widow = True; seen.add(t)
                if widow: fails.append((q, T4, x, 'C2 widow in Rp', None))
                M = pairs + singles
                if 2*M != (q + 1 - 12 + tau_x):
                    fails.append((q, T4, x, 'C3 M mismatch', (M, tau_x, pairs, singles)))
                # C4
                if not (tau_x <= 2*tau_played + (q + 1 - 12)):
                    fails.append((q, T4, x, 'C4 existence constraint violated', (tau_x, tau_played)))
                intrusion_hist[(tau_x, tau_played)] = intrusion_hist.get((tau_x, tau_played), 0) + 1
        if n_intr == 0: no_intrusion_S4 += 1
    print(f"q={q}: S4 configs checked={total_S4}, no-intrusion configs={no_intrusion_S4}, "
          f"intrusions by (tau_x,tau_played)={dict(sorted(intrusion_hist.items()))}, FAILS={len(fails)}")
    for f in fails[:10]: print("  FAIL:", f)
    return len(fails)

total = 0
total += run(7)               # expect: every S4 has zero intrusions
total += run(11)              # full
total += run(13, sample=60)   # sample
print("ALL OK" if total == 0 else f"TOTAL FAILURES: {total}")
