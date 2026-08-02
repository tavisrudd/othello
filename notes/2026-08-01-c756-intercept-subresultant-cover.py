#!/usr/bin/env python3
"""C756 intercept-subresultant probe: finite-field covering instances.

For each (n, q) with delta = C(n,2) - q small, find (seeded, deterministic)
a direction-covering configuration B of n affine points over F_q (distinct
x_i, no three collinear, chord slopes covering all of F_q), then compute the
first subresultant S_1 of H(U,T) = prod_i (U + x_i T - y_i) and dH/dU with
respect to U, over F_q[T], via the Collins subresultant PRS.  Measure:

  * deg_T of the two coefficients S_{1,1}, S_{1,0};
  * the forced factor: E_P^2 divides both (E_P = D_P/(T^q-T));
  * that no Moore factor (T^q-T) divides S_{1,1};
  * the residual intercept ratio N/G with G = S_{1,1}/(c E^2),
    N = -S_{1,0}/(c E^2), its gcd, and its reduced degrees;
  * the structural identities G = sum_m Phi_m^2, N = sum_m r_m Phi_m^2,
    Phi_m = (T^q - T)/w_m, w_m = prod_{i != m} (r_m - r_i), r_i = y_i - x_i T;
  * pointwise agreement of N(t)/G(t) with the actual unique-chord intercept;
  * the interpolation degree of the intercept function on unique directions.

Deterministic: fixed seed per instance (recorded in the JSON output).

Replay:
  python3 notes/2026-08-01-c756-intercept-subresultant-cover.py \
      > notes/2026-08-01-c756-intercept-subresultant-cover.json
"""

import json
import random
import sys
from itertools import combinations

# ---------- dense polynomial arithmetic over F_p, little-endian ----------

def pnorm(a, p):
    a = [c % p for c in a]
    while a and a[-1] == 0:
        a.pop()
    return a

def padd(a, b, p):
    n = max(len(a), len(b))
    return pnorm([(a[i] if i < len(a) else 0) + (b[i] if i < len(b) else 0)
                  for i in range(n)], p)

def psub(a, b, p):
    n = max(len(a), len(b))
    return pnorm([(a[i] if i < len(a) else 0) - (b[i] if i < len(b) else 0)
                  for i in range(n)], p)

def pmul(a, b, p):
    if not a or not b:
        return []
    out = [0] * (len(a) + len(b) - 1)
    for i, ai in enumerate(a):
        if ai:
            for j, bj in enumerate(b):
                out[i + j] = (out[i + j] + ai * bj) % p
    return pnorm(out, p)

def pscale(a, c, p):
    return pnorm([x * c for x in a], p)

def pdivmod(a, b, p):
    assert b, "division by zero polynomial"
    a = a[:]
    binv = pow(b[-1], p - 2, p)
    q = [0] * max(0, len(a) - len(b) + 1)
    while len(a) >= len(b) and a:
        c = a[-1] * binv % p
        k = len(a) - len(b)
        q[k] = c
        for i, bi in enumerate(b):
            a[k + i] = (a[k + i] - c * bi) % p
        a = pnorm(a, p)
    return pnorm(q, p), a

def pexactdiv(a, b, p):
    q, r = pdivmod(a, b, p)
    assert not r, "division not exact"
    return q

def pgcd(a, b, p):
    while b:
        a, b = b, pdivmod(a, b, p)[1]
    if a:
        a = pscale(a, pow(a[-1], p - 2, p), p)  # monic
    return a

def peval(a, t, p):
    v = 0
    for c in reversed(a):
        v = (v * t + c) % p
    return v

def pdeg(a):
    return len(a) - 1 if a else -1

# ---------- polynomials in U with coefficients in F_p[T] ----------
# representation: list of T-polys, little-endian in U

def unorm(A):
    A = list(A)
    while A and not A[-1]:
        A.pop()
    return A

def udeg(A):
    return len(A) - 1 if A else -1

def uscaleT(A, c, p):
    return unorm([pmul(x, c, p) for x in A])

def usub(A, B, p):
    n = max(len(A), len(B))
    return unorm([psub(A[i] if i < len(A) else [],
                       B[i] if i < len(B) else [], p) for i in range(n)])

def ushift(A, k):
    return [[]] * k + list(A)

def uprem(A, B, p):
    """Pseudo-remainder: lc(B)^(degA-degB+1) * A mod B, in U over F_p[T]."""
    dA, dB = udeg(A), udeg(B)
    assert dB >= 0
    l = B[-1]
    e = dA - dB + 1
    R = list(A)
    while R and udeg(R) >= dB:
        c = R[-1]
        k = udeg(R) - dB
        R = usub(uscaleT(R, l, p), uscaleT(ushift(B, k), c, p), p)
        e -= 1
    for _ in range(e):
        R = uscaleT(R, l, p)
    return unorm(R)

def subresultant_prs(A, B, p):
    """Collins subresultant PRS.  Returns list of PRS members (in U over
    F_p[T]) and the degree sequence.  In the non-defective case (all degree
    drops equal 1) the member of U-degree j is the j-th subresultant up to
    sign."""
    prs = [unorm(A), unorm(B)]
    g, h = [1], [1]
    degseq = [udeg(A), udeg(B)]
    Acur, Bcur = prs[0], prs[1]
    while udeg(Bcur) > 0:
        d = udeg(Acur) - udeg(Bcur)
        R = uprem(Acur, Bcur, p)
        if not R:
            break
        hd = h[:]
        for _ in range(d - 1):
            hd = pmul(hd, h, p)
        divisor = pmul(g, hd, p)
        Bnew = unorm([pexactdiv(c, divisor, p) for c in R])
        Acur, Bcur = Bcur, Bnew
        g = Acur[-1]
        if d == 1:
            h = g[:]
        else:
            # h = h^(1-d) g^d  (exact in the domain)
            num = g[:]
            for _ in range(d - 1):
                num = pmul(num, g, p)
            den = h[:]
            for _ in range(d - 2):
                den = pmul(den, h, p)
            h = pexactdiv(num, den, p)
        prs.append(Bcur)
        degseq.append(udeg(Bcur))
    return prs, degseq

# ---------- covering-configuration search (seeded, deterministic) ----------

def collinear(P, Q, R, p):
    return ((Q[0] - P[0]) * (R[1] - P[1]) - (R[0] - P[0]) * (Q[1] - P[1])) % p == 0

def config_ok(pts, p):
    xs = [x for x, _ in pts]
    if len(set(xs)) != len(xs):
        return False
    for a, b, c in combinations(range(len(pts)), 3):
        if collinear(pts[a], pts[b], pts[c], p):
            return False
    return True

def slopes(pts, p):
    out = []
    for i, j in combinations(range(len(pts)), 2):
        dx = (pts[i][0] - pts[j][0]) % p
        dy = (pts[i][1] - pts[j][1]) % p
        out.append(dy * pow(dx, p - 2, p) % p)
    return out

def n_uncovered(pts, p):
    return p - len(set(slopes(pts, p)))

def find_cover(n, p, seed, budget=2000000):
    rng = random.Random(seed)
    spent = 0
    while spent < budget:
        # random restart
        pts = None
        for _ in range(1000):
            xs = rng.sample(range(p), n)
            cand = [(x, rng.randrange(p)) for x in xs]
            if config_ok(cand, p):
                pts = cand
                break
        assert pts is not None
        score = n_uncovered(pts, p)
        stall = 0
        while score > 0 and spent < budget and stall < 40000:
            spent += 1
            i = rng.randrange(n)
            old = pts[i]
            missing = sorted(set(range(p)) - set(slopes(pts, p)))
            if missing and rng.random() < 0.7:
                # targeted: place point i on a line of a missing slope
                # through another point j
                s = missing[rng.randrange(len(missing))]
                j = rng.randrange(n)
                while j == i:
                    j = rng.randrange(n)
                x = rng.randrange(p)
                y = (pts[j][1] + s * (x - pts[j][0])) % p
                pts[i] = (x, y)
            else:
                pts[i] = (rng.randrange(p), rng.randrange(p))
            if not config_ok(pts, p):
                pts[i] = old
                continue
            s2 = n_uncovered(pts, p)
            # accept improvements, sideways moves, and rare uphill moves
            if s2 < score:
                score, stall = s2, 0
            elif s2 == score or rng.random() < 0.02:
                score = s2
                stall += 1
            else:
                pts[i] = old
                stall += 1
        if score == 0:
            return pts
    return None

# ---------- per-instance analysis ----------

def analyze(n, q, seed, pinned=None):
    p = q  # all instances prime
    delta = n * (n - 1) // 2 - q
    if pinned is not None:
        # configuration found by the companion Rust annealer
        # (2026-08-01-c756-intercept-subresultant-search.rs, seed 20260801);
        # re-verified from scratch here, not trusted.
        pts = [tuple(pt) for pt in pinned]
        assert config_ok(pts, p)
        assert n_uncovered(pts, p) == 0
    else:
        pts = find_cover(n, p, seed)
        assert pts is not None, \
            f"no covering configuration found for (n,q)=({n},{q})"
    res = {"n": n, "q": q, "delta": delta, "seed": seed, "points": pts,
           "provenance": "rust-annealer-seed-20260801" if pinned else
                         "in-script-search"}

    # roots r_i = y_i - x_i T
    r = [[y % p, (-x) % p] for (x, y) in pts]
    r = [pnorm(a, p) for a in r]

    # direction discriminant D = prod_{i<j} (r_i - r_j)
    D = [1]
    for i, j in combinations(range(n), 2):
        D = pmul(D, psub(r[i], r[j], p), p)
    moore = pnorm([0, -1] + [0] * (q - 2) + [1], p)  # T^q - T
    E = pexactdiv(D, moore, p)
    assert pdeg(E) == delta
    res["deg_E"] = pdeg(E)

    # multiplicity profile of E (roots are exceptional directions)
    Emon = pscale(E, pow(E[-1], p - 2, p), p)
    mults = {}
    Ew = Emon[:]
    for t in range(p):
        while Ew and peval(Ew, t, p) == 0 and pdeg(Ew) > 0:
            Ew = pexactdiv(Ew, [(-t) % p, 1], p)
            mults[t] = mults.get(t, 0) + 1
        if not Ew or pdeg(Ew) == 0:
            break
    assert sum(mults.values()) == delta, "E_P not completely split"
    res["exceptional_dirs"] = {str(t): m + 1 for t, m in mults.items()}  # mu_t

    # chord bookkeeping
    pairs = list(combinations(range(n), 2))
    slope_of = {}
    for (i, j) in pairs:
        dx = (pts[i][0] - pts[j][0]) % p
        dy = (pts[i][1] - pts[j][1]) % p
        t = dy * pow(dx, p - 2, p) % p
        slope_of.setdefault(t, []).append((i, j))
    unique_dirs = sorted(t for t, ch in slope_of.items() if len(ch) == 1)
    res["n_unique_dirs"] = len(unique_dirs)
    assert len(unique_dirs) == q - len(mults)

    # H(U,T) = prod (U - r_i)  (roots r_i), and dH/dU
    f = [[1]]
    for ri in r:
        new = [[] for _ in range(len(f) + 1)]
        for k, c in enumerate(f):
            new[k + 1] = padd(new[k + 1], c, p)
            new[k] = psub(new[k], pmul(c, ri, p), p)
        f = unorm(new)
    fp = unorm([pscale(f[k], k, p) for k in range(1, len(f))])

    prs, degseq = subresultant_prs(f, fp, p)
    res["prs_degree_sequence"] = degseq
    res["prs_nondefective"] = all(degseq[i] - degseq[i + 1] == 1
                                  for i in range(len(degseq) - 1))
    S1 = None
    for member in prs:
        if udeg(member) == 1:
            S1 = member
    assert S1 is not None, "no degree-1 PRS member"
    S10, S11 = S1[0], S1[1]
    res["deg_S11"] = pdeg(S11)
    res["deg_S10"] = pdeg(S10)
    res["S11_generic_degree"] = (n - 1) * (n - 2)

    # forced factors
    E2 = pmul(Emon, Emon, p)
    g_moore = pgcd(S11, moore, p)
    res["deg_gcd_S11_moore"] = pdeg(g_moore)
    q11, r11 = pdivmod(S11, E2, p)
    q10, r10 = pdivmod(S10, E2, p)
    res["E2_divides_S11"] = not r11
    res["E2_divides_S10"] = not r10
    assert not r11 and not r10

    # structural identities: w_m, Phi_m, G, N
    G_id = []
    N_id = []
    for m in range(n):
        wm = [1]
        for i in range(n):
            if i != m:
                wm = pmul(wm, psub(r[m], r[i], p), p)
        Phim = pexactdiv(moore, wm, p)
        Phim2 = pmul(Phim, Phim, p)
        G_id = padd(G_id, Phim2, p)
        N_id = padd(N_id, pmul(r[m], Phim2, p), p)
    # S1 = c * E^2 * (G_id * U - N_id) for a scalar c
    # check: q11 proportional to G_id, q10 proportional to -N_id, same c
    assert pdeg(G_id) >= 0
    c_num, c_rem = pdivmod(q11, G_id, p)
    res["S11_eq_cE2G"] = (not c_rem) and pdeg(c_num) == 0
    c = c_num[0] if res["S11_eq_cE2G"] else None
    res["scalar_c"] = c
    if c is not None:
        res["S10_eq_minus_cE2N"] = (q10 == pscale(N_id, (-c) % p, p))
        assert res["S10_eq_minus_cE2N"]

    # residual intercept ratio N/G
    G, N = G_id, N_id
    res["deg_G"] = pdeg(G)
    res["deg_N"] = pdeg(N)
    res["predicted_deg_G"] = 2 * (q - n + 1)
    gGN = pgcd(G, N, p)
    res["deg_gcd_G_N"] = pdeg(gGN)
    res["residual_deg_den"] = pdeg(G) - pdeg(gGN)
    res["residual_deg_num"] = pdeg(N) - pdeg(gGN)
    gGm = pgcd(G, moore, p)
    res["deg_gcd_G_moore"] = pdeg(gGm)  # accidental F_q-roots of G

    # pointwise verification on unique directions
    ok = 0
    gzero = []
    for t in unique_dirs:
        (i, j) = slope_of[t][0]
        c_t = (pts[i][1] - t * pts[i][0]) % p          # intercept y - t x
        c_t2 = (pts[j][1] - t * pts[j][0]) % p
        assert c_t == c_t2
        Gt = peval(G, t, p)
        if Gt == 0:
            gzero.append(t)
            continue
        if peval(N, t, p) == c_t * Gt % p:
            ok += 1
    res["pointwise_ok"] = ok
    res["pointwise_G_vanished_at"] = gzero

    # interpolation degree of the intercept function on unique directions
    pts_interp = []
    for t in unique_dirs:
        (i, j) = slope_of[t][0]
        pts_interp.append((t, (pts[i][1] - t * pts[i][0]) % p))
    # Lagrange interpolation
    poly = []
    nodes = [t for t, _ in pts_interp]
    master = [1]
    for t in nodes:
        master = pmul(master, [(-t) % p, 1], p)
    for t, v in pts_interp:
        li = pexactdiv(master, [(-t) % p, 1], p)
        denom = peval(li, t, p)
        poly = padd(poly, pscale(li, v * pow(denom, p - 2, p) % p, p), p)
    res["intercept_interpolation_degree"] = pdeg(poly)
    res["intercept_interpolation_max"] = len(pts_interp) - 1
    return res


PINNED = {
    (9, 31): [(17, 16), (11, 3), (24, 10), (9, 6), (20, 27), (0, 27),
              (14, 1), (26, 0), (30, 22)],
    (10, 41): [(26, 16), (7, 16), (29, 35), (25, 36), (8, 9), (21, 12),
               (23, 23), (5, 27), (24, 14), (4, 22)],
}


def main():
    instances = [(5, 7), (6, 13), (7, 19), (7, 17), (9, 31), (10, 41)]
    out = {"script": "2026-08-01-c756-intercept-subresultant-cover.py",
           "search_negative": {
               "instance": [10, 43], "delta": 2,
               "method": "rust annealer, targeted+uniform moves, reheating",
               "stop_condition": "8 seeds (20260801..20260808) x 3e7 moves,"
                                 " plus parabola-restricted sumset search;"
                                 " no covering configuration found",
               "claim": "bounded search negative only, not nonexistence"},
           "instances": []}
    for (n, q) in instances:
        seed = 20260801 + 100 * n + q
        res = analyze(n, q, seed, pinned=PINNED.get((n, q)))
        out["instances"].append(res)
        print(f"# (n,q)=({n},{q}) delta={res['delta']} "
              f"degS11={res['deg_S11']} degG={res['deg_G']} "
              f"pred={res['predicted_deg_G']} gcd(G,N)={res['deg_gcd_G_N']} "
              f"residual_den={res['residual_deg_den']} "
              f"interp={res['intercept_interpolation_degree']}",
              file=sys.stderr)
    json.dump(out, sys.stdout, indent=1)
    print()


if __name__ == "__main__":
    main()
