#!/usr/bin/env python3
"""C973 GF(64) review recount (2026-08-28).

Recomputes, from scratch and deterministically, the numbers used by the
"Review repairs (2026-08-28)" section of
notes/reed-solomon-tasks/c973-2026-08-27-gf64-trace-balance.md:

  * the true smooth-model point counts of the final-pair Artin-Schreier covers
    on the dense chart, the (0,0) and (0,1) marked-torus boundaries, the
    a = tau strata, and the two subfield strata;
  * the (#C0, #C1, #rootless a) data on all 42 trace-one forms;
  * the failure of the slope-pencil gate off the forced-root surface (22).

Python 3 standard library only.  No randomness beyond an explicit LCG whose
seed and recurrence are fixed below, so the output is byte-identical on any
platform.

    python3 c973-gf64-review-recount.py

Field model: GF(64) = F2[t]/(t^6+t+1), elements are ints 0..63 (bit i = t^i).
Subfields GF(8) = {x : x^8 = x} and GF(4) = {x : x^4 = x} sit inside it.
"""

import functools

# --------------------------------------------------------------------------
# GF(64)
# --------------------------------------------------------------------------
MODP = 0b1000011  # t^6 + t + 1


def mul(a, b):
    r = 0
    while b:
        if b & 1:
            r ^= a
        b >>= 1
        a <<= 1
        if a & 0b1000000:
            a ^= MODP
    return r


def pw(a, n):
    r = 1
    while n:
        if n & 1:
            r = mul(r, a)
        a = mul(a, a)
        n >>= 1
    return r


def inv(a):
    assert a
    return pw(a, 62)


def div(a, b):
    return mul(a, inv(b))


def sqrtf(a):
    return pw(a, 32)


def tr(a, m=6):
    """absolute trace GF(2^m) -> F2, for a in the subfield GF(2^m)"""
    s, x = 0, a
    for _ in range(m):
        s ^= x
        x = mul(x, x)
    return s


def subfield(m):
    return [x for x in range(64) if pw(x, 1 << m) == x]


# --------------------------------------------------------------------------
# polynomials over GF(64): list of coefficients, index = degree
# --------------------------------------------------------------------------
def pn(p):
    p = list(p)
    while p and p[-1] == 0:
        p.pop()
    return p


def padd(*ps):
    n = max((len(p) for p in ps), default=0)
    r = [0] * n
    for p in ps:
        for i, c in enumerate(p):
            r[i] ^= c
    return pn(r)


def pmul(p, q):
    if not p or not q:
        return []
    r = [0] * (len(p) + len(q) - 1)
    for i, a in enumerate(p):
        if a:
            for j, b in enumerate(q):
                if b:
                    r[i + j] ^= mul(a, b)
    return pn(r)


def pscal(c, p):
    return pn([mul(c, a) for a in p])


def peval(p, x):
    r = 0
    for c in reversed(p):
        r = mul(r, x) ^ c
    return r


def pshift(p, x0):
    """coefficients of p(x0 + s) as a polynomial in s"""
    acc, cur, base = [0], [1], [x0, 1]
    for c in p:
        acc = padd(acc, pscal(c, cur))
        cur = pmul(cur, base)
    return pn(acc)


PREC = 40


def laurent(num, den, x0):
    u, v = pshift(num, x0), pshift(den, x0)
    a = next(i for i, c in enumerate(u) if c)
    b = next(i for i, c in enumerate(v) if c)
    u, v = u[a:], v[b:]
    w = []
    for k in range(PREC):
        s = u[k] if k < len(u) else 0
        for j in range(1, k + 1):
            if j < len(v) and w[k - j]:
                s ^= mul(v[j], w[k - j])
        w.append(div(s, v[0]))
    return a - b, w


def as_points_at(num, den, x0, m):
    """number of points of y^2 + y = num/den above the finite place x0"""
    vmin, w = laurent(num, den, x0)
    co = {vmin + i: c for i, c in enumerate(w)}
    while True:
        neg = sorted(k for k, c in co.items() if k < 0 and c)
        if not neg:
            break
        k = neg[0]
        if (-k) % 2 == 1:
            return 1  # ramified place
        c = co[k]
        co[k] ^= c
        co[k // 2] = co.get(k // 2, 0) ^ sqrtf(c)
    return 2 if tr(co.get(0, 0), m) == 0 else 0


def revpoly(p, D):
    r = [0] * (D + 1)
    for i, c in enumerate(p):
        r[D - i] ^= c
    return pn(r)


def as_count(num, den, m):
    """rational points on the smooth model of y^2 + y = num/den over GF(2^m)"""
    num, den = pn(num), pn(den)
    tot = 0
    for x0 in subfield(m):
        if peval(den, x0):
            tot += 2 if tr(div(peval(num, x0), peval(den, x0)), m) == 0 else 0
        else:
            tot += as_points_at(num, den, x0, m)
    D = max(len(num), len(den))
    tot += as_points_at(revpoly(num, D), revpoly(den, D), 0, m)
    return tot


# --------------------------------------------------------------------------
# final-pair machinery.  z = {i: z_i} for i = 3..7 ; g = quintic coefficients.
#   B_j = sum_i z_i g_{i+j-4}   (j = 0..4)
#   A_j = B_j + x B_{j+1}       (j = 0..3)
#   Delta = A1 A3 + A2^2 ,  Q = A0 A3 + A1 A2 ,  N = A1^2 + A0 A2
# --------------------------------------------------------------------------
def Bs(z, g):
    def gg(k):
        return g[k] if 0 <= k < len(g) else 0

    return [functools.reduce(lambda s, i: s ^ mul(z.get(i, 0), gg(i + j - 4)),
                             range(3, 8), 0) for j in range(5)]


def DQN(B):
    A = [pn([B[j], B[j + 1]]) for j in range(4)]
    return (padd(pmul(A[1], A[3]), pmul(A[2], A[2])),
            padd(pmul(A[0], A[3]), pmul(A[1], A[2])),
            padd(pmul(A[1], A[1]), pmul(A[0], A[2])))


H = [1, 1, 1, 0, 1]                      # H(t) = t^4 + t^2 + t + 1
HROOTS = [x for x in range(64) if peval(H, x) == 0]


def quintic(a):
    return pmul([a, 1], H)


def zsurf(u, v):
    """the forced-root surface (22), normalized z3 = 1"""
    return {3: 1, 4: u, 5: v, 6: pw(u, 3),
            7: pw(u, 4) ^ mul(v, v) ^ mul(mul(u, u), v)}


def hankel_ok(z, G):
    e1 = functools.reduce(
        lambda s, i: s ^ mul(z.get(i, 0), G[i - 1] if 0 <= i - 1 < len(G) else 0),
        range(3, 8), 0)
    e2 = functools.reduce(
        lambda s, i: s ^ mul(z.get(i, 0), G[i] if 0 <= i < len(G) else 0),
        range(3, 8), 0)
    return e1 == 0 and e2 == 0


def valid_moving_roots(z, g, fixed):
    """moving roots x giving an octic with 8 distinct nonzero roots and both
    Hankel equations satisfied"""
    D, Q, N = DQN(Bs(z, g))
    good = []
    for x in range(64):
        if x == 0 or x in fixed:
            continue
        dd = peval(D, x)
        if dd == 0:
            continue
        s, p = div(peval(Q, x), dd), div(peval(N, x), dd)
        if p == 0 or s == 0 or tr(div(p, mul(s, s))) != 0:
            continue
        rs = [t for t in range(64) if mul(t, t) ^ mul(s, t) ^ p == 0]
        if len(rs) != 2:
            continue
        allr = list(fixed) + [x] + rs
        if len(set(allr)) != 8 or 0 in allr:
            continue
        G = [1]
        for r in allr:
            G = pmul(G, [r, 1])
        if hankel_ok(z, G):
            good.append(x)
    return good


def cover_count(z, a, m=6):
    D, Q, N = DQN(Bs(z, quintic(a)))
    if not pn(Q):
        return None
    return as_count(pmul(N, D), pmul(Q, Q), m)


def npolys(z):
    """n0, n1, n2 as polynomials in the added root a"""
    b0 = Bs(z, quintic(0))
    b1 = Bs(z, quintic(1))
    Bp = [pn([b0[j], b0[j] ^ b1[j]]) for j in range(5)]
    return (padd(pmul(Bp[1], Bp[1]), pmul(Bp[0], Bp[2])),
            padd(pmul(Bp[0], Bp[3]), pmul(Bp[1], Bp[2])),
            padd(pmul(Bp[2], Bp[2]), pmul(Bp[1], Bp[3])))


def rootsof(co):
    return [x for x in range(64)
            if functools.reduce(lambda s, i: s ^ (pw(x, i) if co[i] else 0),
                                range(len(co)), 0) == 0]


# --------------------------------------------------------------------------
# slope pencil (6): kernel of U1 = U2 = U3 = 0 on binary quartics
# --------------------------------------------------------------------------
def kernel(rows):
    M = [r[:] for r in rows]
    piv, r = [], 0
    for c in range(5):
        p = next((i for i in range(r, len(M)) if M[i][c]), None)
        if p is None:
            continue
        M[r], M[p] = M[p], M[r]
        iv = inv(M[r][c])
        M[r] = [mul(iv, v) for v in M[r]]
        for i in range(len(M)):
            if i != r and M[i][c]:
                f = M[i][c]
                M[i] = [a ^ mul(f, b) for a, b in zip(M[i], M[r])]
        piv.append(c)
        r += 1
        if r == len(M):
            break
    free = [c for c in range(5) if c not in piv]
    basis = []
    for fc in free:
        v = [0] * 5
        v[fc] = 1
        for i, c in enumerate(piv):
            v[c] = M[i][fc]
        basis.append(v)
    return basis


def rowsU(z):
    return [[z[3], z[4], z[5], z[6], z[7]],
            [0, z[3], z[4], z[5], z[6]],
            [0, 0, z[3], z[4], z[5]]]


def U0(z, p):
    return mul(z[4], p[0]) ^ mul(z[5], p[1]) ^ mul(z[6], p[2]) ^ mul(z[7], p[3])


def split_ok(P):
    """P monic of degree 4: four distinct nonzero roots?"""
    rs = [x for x in range(64) if peval(P, x) == 0]
    return len(rs) == 4 and 0 not in rs


def on_surface(z):
    if z[3] == 0:
        return False
    s = inv(z[3])
    u, v = mul(s, z[4]), mul(s, z[5])
    return (mul(s, z[6]) == pw(u, 3)
            and mul(s, z[7]) == (pw(u, 4) ^ mul(v, v) ^ mul(mul(u, u), v)))


def slope_usable(z):
    """(usable, kernel dim, monic-quartic slice size).

    usable: the slope kernel contains a monic split squarefree quartic with
    nonzero constant term and U0 != 0."""
    B = kernel(rowsU(z))
    k = len(B)
    lead = [b for b in B if b[4]]
    if not lead:
        return False, k, 0                       # every kernel element has p4 = 0
    b0 = [mul(inv(lead[0][4]), c) for c in lead[0]]
    dirs = []
    for b in B:
        if b is lead[0]:
            continue
        d = [b[i] ^ mul(b[4], b0[i]) for i in range(5)]   # kill the p4 component
        if any(d):
            dirs.append(d)
    size = 64 ** len(dirs)
    idx = [0] * len(dirs)
    for n in range(size):
        p = b0[:]
        m = n
        for d in dirs:
            c = m % 64
            m //= 64
            if c:
                p = [x ^ mul(c, y) for x, y in zip(p, d)]
        if p[0] and U0(z, p) and split_ok(p):
            return True, k, size
    return False, k, size


# deterministic sampler: 64-bit LCG (Knuth MMIX constants), seed fixed
class LCG:
    def __init__(self, seed):
        self.s = seed & ((1 << 64) - 1)

    def next6(self):
        self.s = (6364136223846793005 * self.s + 1442695040888963407) & ((1 << 64) - 1)
        return (self.s >> 40) & 63


# --------------------------------------------------------------------------
def main():
    print("C973 GF(64) review recount  (deterministic; stdlib only)")
    print("field: GF(64) = F2[t]/(t^6+t+1)")
    print()

    print("-- point counter validation --")
    for lbl, num, den, m, exp in [("y^2+y=x^3   /GF(64)", [0, 0, 0, 1], [1], 6, 81),
                                  ("y^2+y=x^3+x /GF(64)", [0, 1, 0, 1], [1], 6, 65),
                                  ("y^2+y=x^3   /GF(8) ", [0, 0, 0, 1], [1], 3, 9),
                                  ("y^2+y=x^3+x /GF(4) ", [0, 1, 0, 1], [1], 2, 5),
                                  ("y^2+y=x     /GF(64)", [0, 1], [1], 6, 65)]:
        got = as_count(num, den, m)
        print("   %s = %3d (expected %3d) %s" % (lbl, got, exp, "ok" if got == exp else "MISMATCH"))
    print()

    print("-- F1: dense syndrome z = (1,1,1,1,1), chart H(t)(t+a) --")
    zd = {i: 1 for i in range(3, 8)}
    adm = [a for a in range(1, 64)
           if tr(pw(a, 3)) == 1 and peval(H, a) != 0 and (pw(a, 4) ^ pw(a, 3) ^ 1) != 0]
    print("   #{a : Tr(a^3)=1} = %d ; admissible a (a!=0, H(a)!=0, a^4+a^3+1!=0) = %d"
          % (sum(1 for a in range(64) if tr(pw(a, 3)) == 1), len(adm)))
    dist, rq, rinf, ee = {}, set(), set(), []
    for a in adm:
        D, Q, N = DQN(Bs(zd, quintic(a)))
        num, den = pmul(N, D), pmul(Q, Q)
        Dg = max(len(num), len(den))
        dist[as_count(num, den, 6)] = dist.get(as_count(num, den, 6), 0) + 1
        rq.add(as_points_at(num, den, inv(a), 6))
        rinf.add(as_points_at(revpoly(num, Dg), revpoly(den, Dg), 0, 6))
        ee.append(len(valid_moving_roots(zd, quintic(a), HROOTS + [a])))
    print("   cover point counts over GF(64): %s   (note claimed: genus 0, 65)"
          % dict(sorted(dist.items())))
    print("   points above the root of Q: %s ; above infinity: %s  (both ramified => genus 1)"
          % (sorted(rq), sorted(rinf)))
    print("   end-to-end valid moving roots per admissible a: min %d, max %d"
          % (min(ee), max(ee)))
    print()

    print("-- F2: identity (25) is the B_4 = 0 specialization --")
    z00 = {3: 1}
    print("   (0,0) boundary, syndrome e_3: B_4 = %s for all a  (identity (25) needs B_4 = 0)"
          % sorted({Bs(z00, quintic(a))[4] for a in range(64)}))
    sel = [a for a in range(64)
           if a != 0 and (a ^ 1) != 0 and peval(H, a) != 0 and tr(inv(a ^ 1)) == 0]
    d00, e00 = {}, []
    for a in sel:
        c = cover_count(z00, a)
        d00[c] = d00.get(c, 0) + 1
        e00.append(len(valid_moving_roots(z00, quintic(a), HROOTS + [a])))
    print("   parameters with Tr(1/(a+1))=0, a!=0, H(a)!=0 : %d" % len(sel))
    print("   true cover point counts: %s   (note claimed: 130 for all)"
          % dict(sorted(d00.items())))
    print("   end-to-end valid moving roots: min %d, max %d" % (min(e00), max(e00)))
    for name, poly in [("tau^6+tau^5+1          ", [1, 0, 0, 0, 0, 1, 1]),
                       ("tau^3+tau+1            ", [1, 1, 0, 1]),
                       ("tau^6+tau^5+tau^2+tau+1", [1, 1, 1, 0, 0, 1, 1])]:
        cs, b4, ev = set(), set(), set()
        for t in rootsof(poly):
            z = zsurf(1, t)
            cs.add(cover_count(z, t))
            b4.add(Bs(z, quintic(t))[4])
            ev.add(len(valid_moving_roots(z, quintic(t), HROOTS + [t])))
        print("   a = tau on %s : counts %s (claimed 130), B_4 %s, valid x %s"
              % (name, sorted(cs), sorted(b4), sorted(ev)))
    print()

    print("-- strata that were already correct --")
    z01 = {3: 1, 5: 1, 7: 1}
    a01 = [x for x in subfield(3) if pw(x, 3) ^ x ^ 1 == 0][0]
    print("   (0,1) boundary, a^3+a+1=0 : #C(GF(8)) = %d, #C(GF(64)) = %d  (note 12, 72)"
          % (cover_count(z01, a01, 3), cover_count(z01, a01)))
    for name, poly, m, claim in [("tau^3+tau^2+1", [1, 0, 1, 1], 3, "12, 72"),
                                 ("tau^2+tau+1  ", [1, 1, 1], 2, "6, 54")]:
        t = rootsof(poly)[0]
        z = zsurf(1, t)
        print("   %s , a = tau+1 : #C(GF(2^%d)) = %d, #C(GF(64)) = %d  (note %s)"
              % (name, m, cover_count(z, t ^ 1, m), cover_count(z, t ^ 1), claim))
    print()

    print("-- the 42 trace-one forms (unchanged by the review) --")
    den2 = [t for t in range(64) if mul(t, t) ^ t ^ 1 == 0]
    tz = [t for t in range(64) if t not in den2 and tr(t ^ inv(mul(t, t) ^ t ^ 1)) == 0]
    t1 = sorted(set(range(64)) - set(den2) - set(tz))
    c1e = next(c for c in range(64) if tr(c) == 1)
    agg, mn = {}, 64
    for t in t1:
        n0, n1, n2 = npolys(zsurf(1, t))
        f, d2 = pmul(n0, n2), pmul(n1, n1)
        C0 = as_count(f, d2, 6)
        C1 = as_count(padd(f, pmul([c1e], d2)), d2, 6)
        rl = sum(1 for a in range(64) if peval(n1, a) != 0
                 and tr(div(mul(peval(n0, a), peval(n2, a)),
                            mul(peval(n1, a), peval(n1, a)))) == 1)
        agg[(C0, C1, rl)] = agg.get((C0, C1, rl), 0) + 1
        mn = min(mn, rl)
    print("   |trace-one| = %d ; (#C0,#C1,#rootless a) multiplicities: %s"
          % (len(t1), dict(sorted(agg.items()))))
    print("   3 | #C0 always: %s ; #C1 even: %s ; #C1 = 1 mod 3: %s ; #C0+#C1 = 130: %s"
          % (all(k[0] % 3 == 0 for k in agg), all(k[1] % 2 == 0 for k in agg),
             all(k[1] % 3 == 1 for k in agg), all(k[0] + k[1] == 130 for k in agg)))
    print("   minimum rootless parameter count = %d (selector budget 23)" % mn)
    print()

    print("-- F3: the slope-pencil gate off the forced-root surface (22) --")
    for lbl, z in [("e_4", {3: 0, 4: 1, 5: 0, 6: 0, 7: 0}),
                   ("e_5", {3: 0, 4: 0, 5: 1, 6: 0, 7: 0}),
                   ("e_7", {3: 0, 4: 0, 5: 0, 6: 0, 7: 1})]:
        ok, k, sz = slope_usable(z)
        B = kernel(rowsU(z))
        deg4 = any(b[4] for b in B)
        print("   z = %s : kernel dim %d, contains a degree-4 element: %s, usable quartic: %s"
              % (lbl, k, deg4, ok))
    zo_tot, zo_fail = 0, []
    for bits in range(1, 32):
        z = {3 + i: (bits >> i) & 1 for i in range(5)}
        if on_surface(z):
            continue
        zo_tot += 1
        if not slope_usable(z)[0]:
            zo_fail.append([z[i] for i in range(3, 8)])
    print("   zero-one syndromes off (22): %d tested, %d with no usable quartic"
          % (zo_tot, len(zo_fail)))
    rng = LCG(20260828)
    tot, fail, first = 0, 0, None
    while tot < 1500:
        z = {i: rng.next6() for i in range(3, 8)}
        if all(v == 0 for v in z.values()) or on_surface(z):
            continue
        tot += 1
        if not slope_usable(z)[0]:
            fail += 1
            if first is None:
                first = [z[i] for i in range(3, 8)]
    print("   random syndromes off (22) (LCG seed 20260828): %d tested, %d failures (%.1f%%)"
          % (tot, fail, 100.0 * fail / tot))
    print("   first failing sample z3..z7 = %s" % first)


if __name__ == "__main__":
    main()
