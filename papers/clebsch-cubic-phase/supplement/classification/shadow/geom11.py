"""Shared exact-F_11 machinery for the chordal restriction comparison.

Rebuilds the 22-point matching configuration of the p = 11 Clebsch trade from the
memo recipe (section 1.1 of the Clebsch->quantum memo), the PGL_2(11) action on it,
and the logical cubic F_11.  Everything is exact over F_11.
"""
from pathlib import Path
import sys
sys.path.append(str(Path(__file__).resolve().parents[2]/"reconstruction"))

import itertools
import sys

P = 11
INF = "inf"
PTS = list(range(P)) + [INF]


MON11 = ["X^4", "X^3Y", "X^3Z", "X^2YZ", "X^2Z^2", "XY^2Z", "XYZ^2", "XZ^3",
         "YZ^3", "Z^4"]
EXP11 = [(4, 0, 0), (3, 1, 0), (3, 0, 1), (2, 1, 1), (2, 0, 2), (1, 2, 1),
         (1, 1, 2), (1, 0, 3), (0, 1, 3), (0, 0, 4)]

M11 = frozenset(
    [frozenset({0, 1}), frozenset({2, 5}), frozenset({3, 7}), frozenset({4, 9}),
     frozenset({6, 8}), frozenset({10, INF})])


# ---------------------------------------------------------------- polynomials
def pmul(f, g):
    h = {}
    for e1, c1 in f.items():
        for e2, c2 in g.items():
            e = (e1[0] + e2[0], e1[1] + e2[1], e1[2] + e2[2])
            h[e] = (h.get(e, 0) + c1 * c2) % P
    return {e: c for e, c in h.items() if c}


def padd(f, g, s=1):
    h = dict(f)
    for e, c in g.items():
        h[e] = (h.get(e, 0) + s * c) % P
    return {e: c for e, c in h.items() if c}


def pscale(f, s):
    return {e: (c * s) % P for e, c in f.items() if (c * s) % P}


QFORM = {(1, 0, 1): 1, (0, 2, 0): P - 1}          # Q = XZ - Y^2


def reduce_mod_Q(f):
    """Rewrite Y^2 -> XZ until every term has Y-degree <= 1."""
    g = dict(f)
    while True:
        bad = [e for e in g if e[1] >= 2]
        if not bad:
            return {e: c for e, c in g.items() if c % P}
        e = bad[0]
        c = g.pop(e)
        e2 = (e[0] + 1, e[1] - 2, e[2] + 1)
        g[e2] = (g.get(e2, 0) + c) % P


def divide_by_Q(f):
    """Exact division of f by Q = XZ - Y^2; returns (quotient, remainder)."""
    r = dict(f)
    q = {}
    while True:
        # pick a term divisible by the leading monomial XZ of Q under lex X>Y>Z
        cand = [e for e in r if r[e] % P and e[0] >= 1 and e[2] >= 1]
        if not cand:
            return q, {e: c for e, c in r.items() if c % P}
        e = max(cand)
        c = r[e]
        m = (e[0] - 1, e[1], e[2] - 1)
        q[m] = (q.get(m, 0) + c) % P
        r = padd(r, pmul({m: c}, QFORM), s=-1)


# ---------------------------------------------------------------- P^1 and PGL_2
def act_point(g, t):
    a, b, c, d = g
    if t == INF:
        return INF if c % P == 0 else (a * pow(c, P - 2, P)) % P
    den = (c * t + d) % P
    if den == 0:
        return INF
    return ((a * t + b) * pow(den, P - 2, P)) % P


def pgl_elements():
    out = []
    for a in range(P):
        for b in range(P):
            for c in range(P):
                for d in range(P):
                    if (a * d - b * c) % P == 0:
                        continue
                    if next(x for x in (a, b, c, d) if x % P) == 1:
                        out.append((a, b, c, d))
    return out


def act_matching(g, M):
    return frozenset(frozenset(act_point(g, t) for t in pair) for pair in M)


SQUARES = {(x * x) % P for x in range(1, P)}


# ---------------------------------------------------------------- the config
def secant(pair):
    a, b = sorted(pair, key=lambda t: (t == INF, t))
    if b == INF:
        return {(1, 0, 0): a % P, (0, 1, 0): (P - 1) % P}          # aX - Y
    return {(1, 0, 0): (a * b) % P, (0, 1, 0): (-(a + b)) % P, (0, 0, 1): 1}


def prod_form(M):
    f = {(0, 0, 0): 1}
    for pair in sorted(M, key=lambda s: sorted(str(t) for t in s)):
        f = pmul(f, secant(pair))
    return f


def build():
    """Return (matchings, eps, X) with X[i] the 10-vector of matching i."""
    G = pgl_elements()
    orbit = {}
    for g in G:
        orbit.setdefault(act_matching(g, M11), []).append(g)
    assert len(orbit) == 22, len(orbit)
    # sheet label = square class of det of a transport element
    eps_of = {}
    for M, gs in orbit.items():
        cls = {((a * d - b * c) % P) in SQUARES for (a, b, c, d) in gs}
        assert len(cls) == 1, "square class not well defined"
        eps_of[M] = 1 if cls.pop() else P - 1
    P0 = prod_form(M11)
    R0 = reduce_mod_Q(P0)
    lead = min(R0)
    ms, xs, es, alphas = [], [], [], []
    for M in orbit:
        PM = prod_form(M)
        RM = reduce_mod_Q(PM)
        # scale P_M so that it agrees with P_0 modulo Q
        alpha = (R0[lead] * pow(RM[lead], P - 2, P)) % P
        assert pscale(RM, alpha) == R0, "P_M is not proportional to P_0 mod Q"
        q, r = divide_by_Q(padd(pscale(PM, alpha), P0, s=-1))
        assert not r, "division by Q left a remainder"
        ms.append(M)
        alphas.append(alpha)
        xs.append([q.get(e, 0) % P for e in EXP11])
        es.append(eps_of[M])
    return ms, es, xs, alphas


# ---------------------------------------------------------------- linear algebra
def rref(rows, ncols):
    """Row-reduce, pivoting only on the first `ncols` columns; full width kept."""
    m = [r[:] for r in rows]
    width = len(m[0]) if m else 0
    piv = []
    r = 0
    for c in range(ncols):
        pr = next((i for i in range(r, len(m)) if m[i][c] % P), None)
        if pr is None:
            continue
        m[r], m[pr] = m[pr], m[r]
        iv = pow(m[r][c], P - 2, P)
        m[r] = [x * iv % P for x in m[r]]
        for i in range(len(m)):
            if i != r and m[i][c] % P:
                f = m[i][c]
                m[i] = [(m[i][j] - f * m[r][j]) % P for j in range(width)]
        piv.append(c)
        r += 1
        if r == len(m):
            break
    return m[:r], piv


def solve(A, B):
    """Solve A * Xm = B for Xm over F_11 (A square invertible)."""
    n = len(A)
    k = len(B[0])
    aug = [A[i][:] + B[i][:] for i in range(n)]
    m, piv = rref(aug, n)
    assert piv == list(range(n)), "matrix not invertible"
    return [row[n:n + k] for row in m]


def matmul(A, B):
    n, m, k = len(A), len(B[0]), len(B)
    return [[sum(A[i][t] * B[t][j] for t in range(k)) % P for j in range(m)]
            for i in range(n)]


def transpose(A):
    return [list(r) for r in zip(*A)]


def identity(n):
    return [[1 if i == j else 0 for j in range(n)] for i in range(n)]


def matinv(A):
    n = len(A)
    return solve([r[:] for r in A], identity(n))


def cubic_eval(coeffs, basis, v):
    s = 0
    for c, mono in zip(coeffs, basis):
        t = c
        for i in mono:
            t = t * v[i]
        s += t
    return s % P
