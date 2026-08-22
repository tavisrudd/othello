#!/usr/bin/env python3
"""Exact boundary-monodromy cycle denominators for Bl_k P^2 over a box of cocharacters.

For each integral cocharacter b in the box, the characteristic polynomial
P(lam, t) of c_1 * at z_j = z0_j t^{b_j} (rational generic z0) is computed
exactly and its lower Newton polygon is read off.  An edge of horizontal
length L with slope of reduced denominator q whose edge polynomial has simple
roots carries exactly L/q cycles of length q in the boundary monodromy.
Edges with a repeated root are reported separately (deeper Puiseux expansion
would be needed).  The output lists every cycle length that occurs and every
cocharacter whose polygon has an edge denominator >= 5 or a repeated root.

Usage: python3 c925-fable-dp-newton-scan.py K BOX [SEED]
"""
import itertools
import os
import random
import sys
from fractions import Fraction

import sympy as sp


def load_classes(k):
    import importlib.util
    spec = importlib.util.spec_from_file_location(
        "cyc", os.path.join(os.path.dirname(__file__), "c925-fable-dp-sheet-cycles.py"))
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    return m.classes(k), m.dot


def build_matrix(k, cls, dot, z, n):
    t = z[0].free_symbols
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
    for d, m, c in cls:
        q = z[0] ** d
        for i in range(k):
            q *= z[1 + i] ** m[i]
        qb.append(q)
    basisdivs = [(1, tuple(0 for _ in range(k)))]
    for i in range(k):
        yy = [0] * k
        yy[i] = 1
        basisdivs.append((0, tuple(yy)))
    for j, Dp in enumerate(basisdivs):
        col = sp.zeros(n, 1)
        xp, yp = Dp
        col[n - 1] = x * xp - sum(a * bb for a, bb in zip(y, yp))
        for (d, m, c), q in zip(cls, qb):
            w = dot(D, (d, m)) * dot(Dp, (d, m)) * q
            if c == 1:
                col += w * h2vec(d, m)
            elif c == 2:
                col[0] += w
        M[:, 1 + j] = col
    col = sp.zeros(n, 1)
    for (d, m, c), q in zip(cls, qb):
        w = dot(D, (d, m)) * q
        if c == 2:
            col += w * h2vec(d, m)
        elif c == 3:
            col[0] += w
    M[:, n - 1] = col
    return M


def newton_edges(P, lam, t, shift):
    poly = sp.Poly(sp.expand(P * t ** shift), lam, t)
    terms = dict(poly.terms())
    pts = {}
    for (i, j), c in terms.items():
        if c != 0 and (i not in pts or j < pts[i]):
            pts[i] = j
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
    edges = []
    for (x1, y1), (x2, y2) in zip(hull, hull[1:]):
        slope = Fraction(y2 - y1, x2 - x1)
        # edge polynomial: terms (i, j) with j - y1 == slope * (i - x1)
        E = 0
        for (i, j), c in terms.items():
            if x1 <= i <= x2 and Fraction(j - y1) == slope * (i - x1):
                E += c * lam ** (i - x1)
        E = sp.Poly(E, lam)
        simple = sp.discriminant(E.as_expr(), lam) != 0
        status = "simple"
        if not simple:
            status = "repeated"
            if slope.denominator == 1:
                # one further Newton-Puiseux step at each rational repeated root
                deeper = []
                ok = True
                for f, e in sp.factor_list(E.as_expr(), lam)[1]:
                    if e > 1:
                        if sp.degree(f, lam) != 1:
                            ok = False
                            break
                        c = sp.solve(f, lam)[0]
                        mu = sp.symbols("mu")
                        Q = sp.expand(P.subs(lam, t ** int(slope) * (c + mu)) * t ** shift)
                        Qp = sp.Poly(Q, mu, t)
                        pts2 = {}
                        for (i, j), cv in Qp.terms():
                            if cv != 0 and (i not in pts2 or j < pts2[i]):
                                pts2[i] = j
                        h2 = []
                        for p in sorted(pts2.items()):
                            while len(h2) >= 2:
                                (a1, b1), (a2, b2) = h2[-2], h2[-1]
                                if (b2 - b1) * (p[0] - a1) >= (p[1] - b1) * (a2 - a1):
                                    h2.pop()
                                else:
                                    break
                            h2.append(p)
                        for (a1, b1), (a2, b2) in zip(h2, h2[1:]):
                            if a2 - a1 <= e:
                                deeper.append((a2 - a1, Fraction(b2 - b1, a2 - a1)))
                if ok:
                    status = ("second-step", tuple(deeper))
        edges.append((x2 - x1, slope, status))
    return edges


def main():
    k = int(sys.argv[1])
    box = int(sys.argv[2])
    seed = int(sys.argv[3]) if len(sys.argv) > 3 else 1
    random.seed(seed)
    cls, dot = load_classes(k)
    n = k + 3
    t, lam = sp.symbols("t lam")
    z0 = [sp.Rational(random.randint(2, 9), random.randint(2, 9)) for _ in range(k + 1)]
    print(f"k={k} box={box} seed={seed} z0={z0} classes={len(cls)}")
    lengths = set()
    flagged = []
    count = 0
    for b in itertools.product(range(-box, box + 1), repeat=k + 1):
        if all(v == 0 for v in b):
            continue
        count += 1
        z = [z0[j] * t ** b[j] for j in range(k + 1)]
        M = build_matrix(k, cls, dot, z, n)
        P = (lam * sp.eye(n) - M).det(method="berkowitz")
        shift = 40 * box
        edges = newton_edges(P, lam, t, shift)
        for L, slope, status in edges:
            q = slope.denominator
            if status == "simple":
                lengths.add(q)
                if q >= 5:
                    flagged.append((b, L, str(slope), status))
            elif isinstance(status, tuple):
                for L2, s2 in status[1]:
                    if s2.denominator == 1 and L2 > 1:
                        # integral sub-slope of length > 1: a third step would be needed
                        flagged.append((b, L, str(slope), ("unresolved-deeper", L2, str(s2))))
                        continue
                    lengths.add(q * s2.denominator)
                    if q * s2.denominator >= 5:
                        flagged.append((b, L, str(slope), ("second-step", L2, str(s2))))
            else:
                flagged.append((b, L, str(slope), status))
    print("cocharacters scanned:", count)
    print("cycle lengths certified on resolved edges:", sorted(lengths))
    print("flagged (length >= 5, or unresolved repeated algebraic root):", len(flagged))
    for f in flagged[:20]:
        print("  ", f)


if __name__ == "__main__":
    main()
