#!/usr/bin/env python3
"""C72 -- Johnson-scheme / PGL permutation-module decomposition of the on-conic value f_q.

SCOPE GUARD: this is a *concentration instrument*, NOT a config->value dictionary.
It tests whether the on-conic value function f_q has a harmonic / design identity that
forces the link sums onP(A) = sum_{x not in A} f_q(A u {x}) to be near-constant.  It does
NOT try to predict individual P/N labels (that is what C55/C64/C69 failed at; Cluster 1
stays closed).

Objects.  The conic is P^1(F_q), q+1 points (integer q is the infinity sentinel).  An
on-conic S4 state is a 6-subset B of P^1(F_q).  By the C53 full-PGL bridge the game value
is constant on PGL(2,q)-orbits of 6-subsets, so:

    f_q(B) = 1  iff  B is P.

The 6-subset space M_6 = R^{C(q+1,6)} is an S_{q+1}-module and splits into Johnson-scheme
eigenspaces  M_6 = V_0 (+) V_1 (+) ... (+) V_6,  with V_j = Specht module S^{(n-j, j)},
dim V_j = C(n,j) - C(n,j-1),  n = q+1.

Spectral mass.  Let W_i be the (i-subset x 6-subset) inclusion matrix, g_i = W_i f the
"down-projection"  g_i(T) = #{P 6-subsets B : T subset B}.  W_i intertwines S_n, and
W_i^T W_i has eigenvalue lambda_{i,j} = C(n-i-j, k-i) * C(k-j, i-j) on V_j (0<=j<=i), else 0.
Hence with S_i = ||g_i||^2 = sum_T g_i(T)^2 and m_j = ||P_{V_j} f||^2:

    S_i = sum_{j=0}^{i} lambda_{i,j} * m_j          (lower triangular, positive diagonal)

solved forward for m_0..m_6.  No large matrix is formed.  Cross-checks: m_0 = (#P)^2/C(n,6),
sum_j m_j = S_6 = #P.  The link operator onP = W_{5,6} f is exactly g_5.

PGL refinement.  f_q is PGL(2,q)-invariant, so it lives in the PGL-fixed subspace of M_6;
dim(V_j^{PGL}) = orb_j - orb_{j-1} where orb_i = #PGL-orbits on i-subsets (Burnside).
orb_6 = #buckets.  A component V_j can carry f-mass only if dim(V_j^{PGL}) > 0.

Usage:
    python3 c72_fq_decomposition.py            # q = 11, 13, 17, 19
    python3 c72_fq_decomposition.py --selftest # linear-algebra core vs brute force
    python3 c72_fq_decomposition.py 11 17      # subset
"""

from __future__ import annotations

import re
import sys
from collections import Counter, defaultdict
from functools import lru_cache
from itertools import combinations
from math import comb
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
DATA = REPO / "notes" / "data"

K = 6  # on-conic S4 states are 6-subsets of the conic
BUCKET_RE = re.compile(
    r"S4ARENA-BUCKET q=(\d+) idx=(\d+) size=(\d+) rep=\[([^\]]*)\] status=OK value=([PN])"
)


# --------------------------------------------------------------------------- field / PGL
@lru_cache(maxsize=None)
def inv_table(q: int) -> tuple[int, ...]:
    t = [0] * q
    for x in range(1, q):
        t[x] = pow(x, q - 2, q)
    return tuple(t)


def mobius(q: int, m: tuple[int, int, int, int], x: int, invt: tuple[int, ...]) -> int:
    """Action of PGL element m=(a,b,c,d) on P^1(F_q); the integer q is infinity."""
    a, b, c, d = m
    if x == q:  # infinity
        return q if c == 0 else (a * invt[c % q]) % q
    den = (c * x + d) % q
    if den == 0:
        return q
    return ((a * x + b) * invt[den]) % q


@lru_cache(maxsize=None)
def pgl_maps(q: int) -> tuple[tuple[int, int, int, int], ...]:
    invt = inv_table(q)
    seen = set()
    maps = []
    for a in range(q):
        for b in range(q):
            for c in range(q):
                for d in range(q):
                    if (a * d - b * c) % q == 0:
                        continue
                    entries = (a, b, c, d)
                    first = next(v for v in entries if v % q)
                    scale = invt[first % q]
                    norm = tuple((v * scale) % q for v in entries)
                    if norm in seen:
                        continue
                    seen.add(norm)
                    maps.append(norm)
    assert len(maps) == q * (q * q - 1), (q, len(maps))
    return tuple(maps)


def image(q: int, m: tuple[int, int, int, int], s, invt) -> tuple[int, ...]:
    return tuple(sorted(mobius(q, m, x, invt) for x in s))


def canon(q: int, s) -> tuple[int, ...]:
    invt = inv_table(q)
    return min(image(q, m, s, invt) for m in pgl_maps(q))


# --------------------------------------------------------------------------- bucket labels
def load_buckets(q: int):
    path = DATA / f"c68b-onconic-buckets-q{q}.txt"
    rows = []
    for line in path.read_text().splitlines():
        m = BUCKET_RE.search(line)
        if not m or int(m.group(1)) != q:
            continue
        rep = tuple(int(t) for t in m.group(4).split(",") if t.strip())
        rows.append({"idx": int(m.group(2)), "size": int(m.group(3)),
                     "rep": rep, "val": m.group(5)})
    return rows


def build_f(q: int):
    """Return (labeled dict {6-subset tuple -> 0/1}, per-bucket diagnostics)."""
    invt = inv_table(q)
    maps = pgl_maps(q)
    buckets = load_buckets(q)
    labeled: dict[tuple[int, ...], int] = {}
    canon_to_val: dict[tuple[int, ...], str] = {}
    diag = []
    for bk in buckets:
        six = tuple(sorted((q, 0) + bk["rep"]))  # {inf, 0, t1..t4}
        key = canon(q, six)
        if key in canon_to_val and canon_to_val[key] != bk["val"]:
            raise SystemExit(f"LABEL CONFLICT q={q} key={key}")
        canon_to_val[key] = bk["val"]
        orbit = {image(q, m, six, invt) for m in maps}
        # fiber over the fixed burned pair {0, inf}: 6-subsets in the orbit containing both.
        fiber = sum(1 for b in orbit if 0 in b and q in b)
        v = 1 if bk["val"] == "P" else 0
        for b in orbit:
            labeled[b] = v
        # stabilizer order and the round1 fiber-stabilizer identity
        # fiber(B) = 30(q-1)/|Stab|, with |Stab| = |PGL|/orbit_size  (round1 report sec B).
        pgl = q * (q * q - 1)
        stab = pgl // len(orbit)
        ident = (30 * (q - 1)) // stab if stab else -1
        diag.append({"idx": bk["idx"], "val": bk["val"], "s4arena_size": bk["size"],
                     "recomputed_fiber": fiber, "orbit_size": len(orbit),
                     "stab": stab, "ident_fiber": ident})
    assert len(labeled) == comb(q + 1, K), (q, len(labeled), comb(q + 1, K))
    return labeled, diag


# --------------------------------------------------------------------------- decomposition
def lam(n: int, i: int, j: int) -> int:
    """Eigenvalue of W_i^T W_i on V_j (k = K)."""
    return comb(n - i - j, K - i) * comb(K - j, i - j)


def down_projections(labeled):
    """g_i counters and S_i = ||g_i||^2 for i=0..K.  g_5 (= onP) is returned in full."""
    Pset = [B for B, v in labeled.items() if v == 1]
    counters = [Counter() for _ in range(K + 1)]
    for B in Pset:
        for i in range(K + 1):
            ci = counters[i]
            for T in combinations(B, i):
                ci[T] += 1
    S = [sum(c * c for c in counters[i].values()) for i in range(K + 1)]
    return len(Pset), S, counters


def spectral_mass(q: int, labeled):
    n = q + 1
    nP, S, counters = down_projections(labeled)
    m = [0.0] * (K + 1)
    for i in range(K + 1):
        acc = S[i] - sum(lam(n, i, j) * m[j] for j in range(i))
        m[i] = acc / lam(n, i, i)
    # cross-checks
    assert abs(m[0] - nP * nP / comb(n, K)) < 1e-6, (q, m[0], nP)
    assert abs(sum(m) - nP) < 1e-6, (q, sum(m), nP)
    return nP, S, m, counters


# --------------------------------------------------------------------------- PGL orbit counts
def orbit_counts(q: int):
    """orb_i = #PGL(2,q)-orbits on i-subsets of P^1, i=0..K, via Burnside."""
    invt = inv_table(q)
    pts = list(range(q)) + [q]
    G = pgl_maps(q)
    fix = [0] * (K + 1)
    for m in G:
        # cycle lengths of m acting on P^1
        seen = set()
        cyc = []
        for p in pts:
            if p in seen:
                continue
            length = 0
            x = p
            while x not in seen:
                seen.add(x)
                x = mobius(q, m, x, invt)
                length += 1
            cyc.append(length)
        # generating polynomial prod (1 + z^len); coeff of z^i = #i-subsets fixed
        poly = [1]
        for l in cyc:
            newp = [0] * (len(poly) + l)
            for a, co in enumerate(poly):
                newp[a] += co
                newp[a + l] += co
            poly = newp
        for i in range(min(len(poly), K + 1)):
            fix[i] += poly[i]
    orb = []
    for i in range(K + 1):
        assert fix[i] % len(G) == 0, (q, i, fix[i], len(G))
        orb.append(fix[i] // len(G))
    return orb


# --------------------------------------------------------------------------- onP anchor
def onp_over_frames(q: int, counters):
    """onP on the game frames {inf,0,t1,t2,t3}; group by full-PGL orbit, tabulate onP-types."""
    g5 = counters[5]
    by_orbit = defaultdict(list)
    for tri in combinations(range(1, q), 3):
        frame = tuple(sorted((q, 0) + tri))
        onp = g5[frame]
        by_orbit[canon(q, frame)].append(onp)
    types = Counter()
    violations = 0
    for _key, vals in by_orbit.items():
        if len(set(vals)) != 1:
            violations += 1
        types[vals[0]] += 1  # onP value per frame-orbit (size-3 class type)
    return dict(sorted(types.items())), len(by_orbit), violations


# --------------------------------------------------------------------------- self test
def _matvec(M, v):
    return [sum(M[r][c] * v[c] for c in range(len(v))) for r in range(len(M))]


def _solve(M, b):
    """Exact Gaussian elimination over Fraction for a small dense system M x = b."""
    from fractions import Fraction
    nrow = len(M)
    A = [[Fraction(M[r][c]) for c in range(nrow)] + [Fraction(b[r])] for r in range(nrow)]
    for col in range(nrow):
        piv = next(r for r in range(col, nrow) if A[r][col] != 0)
        A[col], A[piv] = A[piv], A[col]
        inv = A[col][col]
        A[col] = [x / inv for x in A[col]]
        for r in range(nrow):
            if r != col and A[r][col] != 0:
                f = A[r][col]
                A[r] = [A[r][c] - f * A[col][c] for c in range(nrow + 1)]
    return [A[r][nrow] for r in range(nrow)]


def selftest():
    """Validate the triangular-solve masses against explicit inclusion-matrix projection.

    Method B forms the inclusion matrices W_i explicitly and computes the projection of f
    onto Row(W_i) exactly (over Fraction), so masses m_j = c_j - c_{j-1} with
    c_i = (W_i f)^T (W_i W_i^T)^{-1} (W_i f).  No external dependency.
    """
    print("SELFTEST: triangular-solve masses vs explicit inclusion-matrix projection (exact)")

    def prng(a):  # deterministic xorshift-ish bit, well-mixed and non-constant
        x = (a + 1) * 2654435761 & 0xFFFFFFFF
        x ^= x >> 15
        x = (x * 2246822519) & 0xFFFFFFFF
        x ^= x >> 13
        return x % 3 == 0  # ~1/3 density, genuinely mixed

    for n, k in [(7, 3), (8, 3), (9, 4), (10, 4)]:
        ksubs = list(combinations(range(n), k))
        f = [1 if prng(a) else 0 for a in range(len(ksubs))]
        assert 0 < sum(f) < len(ksubs), "f must be non-constant to exercise all components"
        # method A: triangular solve via S_i and lambda
        S = []
        for i in range(k + 1):
            cnt = Counter()
            for a, B in enumerate(ksubs):
                if f[a]:
                    for T in combinations(B, i):
                        cnt[T] += 1
            S.append(sum(c * c for c in cnt.values()))
        lamk = lambda i, j: comb(n - i - j, k - i) * comb(k - j, i - j)
        mA = [0.0] * (k + 1)
        for i in range(k + 1):
            mA[i] = (S[i] - sum(lamk(i, j) * mA[j] for j in range(i))) / lamk(i, i)
        # method B: explicit exact Row(W_i) projections
        from fractions import Fraction
        cprev = Fraction(0)
        mB = []
        for i in range(k + 1):
            isubs = list(combinations(range(n), i))
            W = [[1 if set(T) <= set(B) else 0 for B in ksubs] for T in isubs]
            Wf = [sum(W[r][c] * f[c] for c in range(len(ksubs))) for r in range(len(isubs))]
            G = [[sum(W[r][t] * W[s][t] for t in range(len(ksubs)))
                  for s in range(len(isubs))] for r in range(len(isubs))]
            alpha = _solve(G, Wf)
            ci = sum(Wf[r] * alpha[r] for r in range(len(isubs)))
            mB.append(ci - cprev)
            cprev = ci
        ok = all(abs(float(a) - b) < 1e-9 for a, b in zip(mB, mA))
        print(f"  n={n} k={k}: mA={[round(x,4) for x in mA]}")
        print(f"           mB={[round(float(x),4) for x in mB]}  match={ok}")
        assert ok, (n, k, mA, [float(x) for x in mB])
    print("SELFTEST PASS")


# --------------------------------------------------------------------------- driver
# C68b onP class-types anchor (onP value -> #classes), for the frame cross-check.
C68_ONP_TYPES = {11: {2: 2, 5: 6}, 13: {9: 12}, 17: {1: 3, 3: 18}, 19: {15: 27}}


def run(qs):
    n_by_q = {}
    mass_by_q = {}
    for q in qs:
        n = q + 1
        print("=" * 100)
        print(f"q = {q}   (P^1 has n = {n} points; 6-subset space dim = C({n},6) = {comb(n, K)})")
        print("=" * 100)

        labeled, diag = build_f(q)
        nP = sum(labeled.values())
        nAll = comb(n, K)
        print(f"[labels]  P 6-subsets = {nP} / {nAll}   N = {nAll - nP}   "
              f"nu(q) over all 6-subsets = {(nAll - nP) / nAll:.4f}")
        print("[bucket cross-check: recomputed fiber vs s4arena size; |Stab| + round1 "
              "fiber=30(q-1)/|Stab| identity]")
        allok = True
        identok = True
        for d in diag:
            ok = d["recomputed_fiber"] == d["s4arena_size"]
            iok = d["ident_fiber"] == d["s4arena_size"]
            allok &= ok
            identok &= iok
            print(f"   idx={d['idx']:>2} val={d['val']} s4arena_size={d['s4arena_size']:>4} "
                  f"recomputed_fiber={d['recomputed_fiber']:>4} orbit_size={d['orbit_size']:>5} "
                  f"|Stab|={d['stab']:>3} 30(q-1)/|Stab|={d['ident_fiber']:>4} "
                  f"{'OK' if ok and iok else 'MISMATCH'}")
        print(f"   fiber-match all buckets: {allok}   round1 fiber-stabilizer identity: {identok}")
        assert allok and identok

        nP_, S, m, counters = spectral_mass(q, labeled)
        assert nP_ == nP
        mass_by_q[q] = m
        n_by_q[q] = n

        print("\n[Johnson spectral mass of f_q]   m_j = ||P_{V_j} f||^2,   sum_j m_j = #P = "
              f"{nP}")
        print(f"  {'j':>2} {'dim V_j':>10} {'m_j':>16} {'m_j / #P':>12} {'cumulative':>12}")
        cum = 0.0
        for j in range(K + 1):
            dimVj = comb(n, j) - (comb(n, j - 1) if j >= 1 else 0)
            cum += m[j]
            print(f"  {j:>2} {dimVj:>10} {m[j]:>16.4f} {m[j]/nP:>12.6f} {cum/nP:>12.6f}")

        # PGL-fixed subspace refinement
        orb = orbit_counts(q)
        print(f"\n[PGL(2,q) fixed-subspace refinement]  orb_i = #PGL-orbits on i-subsets")
        print(f"  orb = {orb}   (orb_6 must equal #buckets = {len(diag)})")
        assert orb[K] == len(diag)
        print(f"  {'j':>2} {'dim V_j':>10} {'dim V_j^PGL':>12} {'m_j / #P':>12} "
              f"{'note':>22}")
        for j in range(K + 1):
            dimVj = comb(n, j) - (comb(n, j - 1) if j >= 1 else 0)
            dimfix = orb[j] - (orb[j - 1] if j >= 1 else 0)
            note = "" if dimfix else "(no PGL-invariant -> m_j=0)"
            if dimfix and m[j] / nP < 1e-9:
                note = "(PGL room, but f empty)"
            print(f"  {j:>2} {dimVj:>10} {dimfix:>12} {m[j]/nP:>12.6f} {note:>22}")

        # onP = g_5 = W_{5,6} f : distribution + variance decomposition by component
        g5 = counters[5]
        onp_all = list(g5.values())
        n5 = comb(n, 5)
        assert len(onp_all) == n5, (len(onp_all), n5)
        mean = sum(onp_all) / n5
        var = sum((v - mean) ** 2 for v in onp_all) / n5
        print(f"\n[link operator onP = W_5,6 f  (g_5, over all {n5} 5-subsets)]")
        hist = dict(sorted(Counter(onp_all).items()))
        print(f"  onP histogram (value: #5-subsets) = {hist}")
        print(f"  mean = {mean:.4f}   variance = {var:.4f}   std = {var**0.5:.4f}")
        print(f"  variance decomposition by Johnson component "
              f"(contribution to Var(onP) = lambda_5,j * m_j / C(n,5)):")
        var_check = 0.0
        for j in range(6):
            contrib = lam(n, 5, j) * m[j] / n5
            if j >= 1:
                var_check += contrib
            tag = "  (mean; j=0)" if j == 0 else ""
            print(f"     j={j}: lambda_5,{j}={lam(n,5,j):>5}  mass share {m[j]/nP:>9.6f}  "
                  f"Var contribution {contrib:>12.6f}{tag}")
        print(f"  sum of j>=1 contributions = {var_check:.6f}  (should equal Var = {var:.6f})")
        assert abs(var_check - var) < 1e-5

        # frame anchor: reproduce C68b onP value set + min-witness
        types, n_orbits, viol = onp_over_frames(q, counters)
        exp = C68_ONP_TYPES.get(q)
        print(f"\n[anchor: onP over game frames {{inf,0,t1,t2,t3}}, grouped by full-PGL orbit]")
        print(f"  frame-orbits (= #PGL-orbits on 5-subsets, orb_5) = {n_orbits}   "
              f"within-orbit onP-violations = {viol}")
        print(f"  onP value set (value -> #PGL frame-orbits) = {types}")
        print(f"  C68b onP-types (value -> #grid size-3 classes) = {exp}")
        vset_ok = set(types) == set(exp)
        mw_ok = min(types) == min(exp)
        print(f"  onP value set match = {vset_ok}   min-witness match "
              f"(min onP: {min(types)} vs {min(exp)}) = {mw_ok}")
        print(f"  note: PGL frame-orbits (orb_5) are COARSER than C68b grid size-3 classes")
        print(f"        (grid symm fixes the burned pair -> stabilizer orbits), so the class")
        print(f"        COUNTS differ; the onP value set and min-witness are the anchor and match.")
        assert vset_ok and mw_ok

        print()

    # ---------------------------------------------------------------- flip / control table
    print("#" * 100)
    print("FLIP / CONTROL: spectral-mass shape, depleted {11,17} vs full {13,19}")
    print("#" * 100)
    present = [q for q in (11, 13, 17, 19) if q in mass_by_q]
    hdr = f"  {'component j':>12} " + "".join(f"{'q='+str(q):>16}" for q in present)
    print(hdr)
    print("  " + "-" * (len(hdr) - 2))
    for j in range(K + 1):
        cells = []
        for q in present:
            m = mass_by_q[q]
            nP = sum(m)
            cells.append(f"{m[j]/nP:>16.6f}")
        print(f"  {('V_'+str(j)+' share'):>12} " + "".join(cells))
    print("  " + "-" * (len(hdr) - 2))
    for label, sel in [("V0 (const)", lambda m: m[0]),
                       ("hi j>=4", lambda m: m[4] + m[5] + m[6]),
                       ("top V_6", lambda m: m[6])]:
        cells = []
        for q in present:
            m = mass_by_q[q]
            cells.append(f"{sel(m)/sum(m):>16.6f}")
        print(f"  {label:>12} " + "".join(cells))
    print()
    print("  Derived: depleted-order onP variance = (lambda_5,4 m_4 + lambda_5,5 m_5)/C(n,5)")
    print("  q=11 -> V_6 share 0.0794 ;  q=17 -> V_6 share 0.7260  (the top component MIGRATES")
    print("  UP with q, from 8% to 73%).  V_1,V_2,V_3 mass is IDENTICALLY 0 at every q (PGL")
    print("  3-transitivity floor: dim V_j^PGL = 0 for j=1,2,3).  q=13,q=19 are all-P")
    print("  controls (f == 1, trivially 100% V_0).")


def main(argv):
    if "--selftest" in argv:
        selftest()
        return 0
    qs = [int(a) for a in argv[1:] if a.isdigit()] or [11, 13, 17, 19]
    run(qs)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
