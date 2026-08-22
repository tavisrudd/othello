#!/usr/bin/env python3
"""Exact Newton-polygon check of a boundary monodromy cycle for Bl_k P^2.

For an integral cocharacter b and a rational generic base point z0, the
characteristic polynomial P(lam, t) of c_1 * at z_j = z0_j t^{b_j} is
computed exactly.  The lower Newton polygon of P in the (lam-degree, t-order)
plane gives the Puiseux exponents of the eigenvalue branches at t = 0; an
edge of horizontal length n with slope whose reduced denominator is n
carries an n-cycle of the boundary monodromy (its edge polynomial is
c lam^n + d up to the scaling, so the branches are the n-th roots).

Usage: python3 c925-fable-dp-puiseux-check.py K b_0 b_1 ... b_k [SEED]
"""
import sys
from fractions import Fraction

import sympy as sp

def classes(k):
    import importlib.util
    import os
    spec = importlib.util.spec_from_file_location(
        "cyc", os.path.join(os.path.dirname(__file__), "c925-fable-dp-sheet-cycles.py"))
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    return m.classes(k), m.dot


def main():
    k = int(sys.argv[1])
    b = [int(x) for x in sys.argv[2:3 + k]]
    seed = int(sys.argv[3 + k]) if len(sys.argv) > 3 + k else 1
    import random
    random.seed(seed)
    cls, dot = classes(k)
    n = k + 3
    t, lam = sp.symbols("t lam")
    z0 = [sp.Rational(random.randint(2, 9), random.randint(2, 9)) for _ in range(k + 1)]
    z = [z0[j] * t ** b[j] for j in range(k + 1)]
    D = (3, tuple(-1 for _ in range(k)))
    x, y = D
    M = sp.zeros(n, n)

    def h2vec(xx, yy):
        v = sp.zeros(n, 1)
        v[1] = xx
        for i in range(k):
            v[2 + i] = yy[i]
        return v

    M[:, 0] = h2vec(x, y)
    qb = []
    for d, m, c, nb in cls:
        q = nb * z[0] ** d
        for i in range(k):
            q *= z[1 + i] ** m[i]
        qb.append(sp.simplify(q))
    basisdivs = [(1, tuple(0 for _ in range(k)))]
    for i in range(k):
        yy = [0] * k
        yy[i] = 1
        basisdivs.append((0, tuple(yy)))
    for j, Dp in enumerate(basisdivs):
        col = sp.zeros(n, 1)
        xp, yp = Dp
        col[n - 1] = x * xp - sum(a * bb for a, bb in zip(y, yp))
        for (d, m, c, _nb), q in zip(cls, qb):
            w = dot(D, (d, m)) * dot(Dp, (d, m)) * q
            if c == 1:
                col += w * h2vec(d, m)
            elif c == 2:
                col[0] += w
        M[:, 1 + j] = col
    col = sp.zeros(n, 1)
    for (d, m, c, _nb), q in zip(cls, qb):
        w = dot(D, (d, m)) * q
        if c == 2:
            col += w * h2vec(d, m)
        elif c == 3:
            col[0] += w
    M[:, n - 1] = col
    P = sp.expand((lam * sp.eye(n) - M).det())
    # clear negative powers of t
    shift = 60
    num = sp.Poly(sp.expand(P * t ** shift), lam, t)
    pts = {}
    for (i, j), cval in num.terms():
        if cval != 0:
            pts[i] = min(pts.get(i, 10 ** 9), j)
    # lower convex hull over lam-degree i with height = t-order
    P2 = sorted(pts.items())
    hull = []
    for p in P2:
        while len(hull) >= 2:
            (x1, y1), (x2, y2) = hull[-2], hull[-1]
            if (y2 - y1) * (p[0] - x1) >= (p[1] - y1) * (x2 - x1):
                hull.pop()
            else:
                break
        hull.append(p)
    print("k =", k, "b =", b, "z0 =", z0)
    print("lower Newton polygon vertices (lam-degree, t-order):", hull)
    terms = dict(num.terms())
    for (x1, y1), (x2, y2) in zip(hull, hull[1:]):
        slope = Fraction(y2 - y1, x2 - x1)
        print(f"  edge length {x2 - x1}: exponent slope {slope}  -> branch denominators {slope.denominator}")
        E = 0
        for (i, j), cval in terms.items():
            if x1 <= i <= x2 and Fraction(j - y1) == slope * (i - x1):
                E += cval * lam ** (i - x1)
        fac = sp.factor_list(sp.Poly(E, lam).as_expr(), lam)[1]
        print("    edge polynomial factors (factor, multiplicity):",
              [(str(f), e) for f, e in fac])
        if slope.denominator == 1:
            for f, e in fac:
                if e > 1 and sp.degree(f, lam) == 1:
                    c = sp.solve(f, lam)[0]
                    # one Newton-Puiseux step: lam = t^slope (c + mu)
                    mu = sp.symbols("mu")
                    Q = sp.expand(P.subs(lam, t ** int(slope) * (c + mu)) * t ** shift)
                    Qp = sp.Poly(Q, mu, t)
                    pts2 = {}
                    for (i, j), cv in Qp.terms():
                        if cv != 0 and (i not in pts2 or j < pts2[i]):
                            pts2[i] = j
                    P3 = sorted(pts2.items())
                    h2 = []
                    for p in P3:
                        while len(h2) >= 2:
                            (a1, b1), (a2, b2) = h2[-2], h2[-1]
                            if (b2 - b1) * (p[0] - a1) >= (p[1] - b1) * (a2 - a1):
                                h2.pop()
                            else:
                                break
                        h2.append(p)
                    sub = [(a2 - a1, str(Fraction(b2 - b1, a2 - a1)))
                           for (a1, b1), (a2, b2) in zip(h2, h2[1:]) if a2 - a1 <= e]
                    print(f"    second step at root {c} (mult {e}): sub-edges (length, slope) {sub}")
                elif e > 1:
                    print(f"    repeated algebraic root of degree {sp.degree(f, lam)}: deeper step not attempted")


if __name__ == "__main__":
    main()
