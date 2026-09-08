import sys
from collections import Counter
from common import data

INF = "inf"


# ---------- multivariate polynomials over F_p in X,Y,Z as dicts ----------
def pmul(f, g, p):
    h = {}
    for m1, c1 in f.items():
        for m2, c2 in g.items():
            m = (m1[0] + m2[0], m1[1] + m2[1], m1[2] + m2[2])
            h[m] = (h.get(m, 0) + c1 * c2) % p
    return {m: c for m, c in h.items() if c}


def psub(f, g, p):
    h = dict(f)
    for m, c in g.items():
        h[m] = (h.get(m, 0) - c) % p
    return {m: c for m, c in h.items() if c}


def lt(f):
    return max(f)          # lex on (eX, eY, eZ) with X > Y > Z


def divide_by_Q(f, p):
    """Divide by Q = XZ - Y^2 (a single-element Groebner basis, lex X>Y>Z)."""
    Q = {(1, 0, 1): 1, (0, 2, 0): (-1) % p}
    q, r = {}, {}
    f = dict(f)
    while f:
        m = lt(f)
        c = f[m]
        if m[0] >= 1 and m[2] >= 1:
            t = {(m[0] - 1, m[1], m[2] - 1): c}
            q = psub(q, {k: (-v) % p for k, v in t.items()}, p)
            f = psub(f, pmul(t, Q, p), p)
        else:
            r[m] = c
            f = psub(f, {m: c}, p)
    return q, r


# ---------- P^1 and PGL_2 ----------
def norm_pt(x, y, p):
    x, y = x % p, y % p
    if y:
        return ((x * pow(y, p - 2, p)) % p, 1)
    return (1, 0)


def lab(pt):
    return INF if pt[1] == 0 else pt[0]


def pt_of(label, p):
    return (1, 0) if label == INF else (label % p, 1)


def act(g, label, p):
    a, b, c, d = g
    x, y = pt_of(label, p)
    return lab(norm_pt(a * x + b * y, c * x + d * y, p))


def pgl2(p):
    out = []
    for a in range(p):
        for b in range(p):
            for c in range(p):
                for d in range(p):
                    if (a * d - b * c) % p:
                        out.append((a, b, c, d))
    return out


def legendre(x, p):
    return 1 if pow(x % p, (p - 1) // 2, p) == 1 else -1


def sec_factor(u, v, p):
    """Linear form vanishing on the two conic points labelled u, v."""
    if u == INF or v == INF:
        a = v if u == INF else u
        return {(1, 0, 0): a % p, (0, 1, 0): (-1) % p}
    return {(1, 0, 0): (u * v) % p, (0, 1, 0): (-(u + v)) % p,
            (0, 0, 1): 1}


def prod_matching(M, p):
    f = {(0, 0, 0): 1}
    for pair in sorted(M, key=lambda s: sorted(map(str, s))):
        u, v = tuple(pair)
        f = pmul(f, sec_factor(u, v, p), p)
    return f


BASE = {7: [(0, 2), (1, 4), (3, INF), (5, 6)],
        11: [(0, 1), (2, 5), (3, 7), (4, 9), (6, 8), (10, INF)]}


def run(p):
    E, EXPS, MONS = data(p)
    k = p - 1
    base = frozenset(frozenset(pair) for pair in BASE[p])
    G = pgl2(p)
    orbit = {}
    for g in G:
        M = frozenset(frozenset(act(g, x, p) for x in pair) for pair in base)
        assert all(len(s) == 2 for s in M)
        orbit.setdefault(M, []).append(g)
    print(f"--- p={p}: PGL_2 order {len(G)}, orbit size {len(orbit)}"
          f" (claim {2 * p})")
    stab = orbit[base]
    print(f"    stabiliser order {len(stab)};"
          f" all stabiliser dets are squares:",
          all(legendre((g[0] * g[3] - g[1] * g[2]), p) == 1 for g in stab))
    signs = {}
    welldef = True
    for M, gs in orbit.items():
        vals = {legendre(g[0] * g[3] - g[1] * g[2], p) for g in gs}
        if len(vals) != 1:
            welldef = False
        signs[M] = vals.pop() if len(vals) == 1 else None
    print("    sheet labelling by square class of det is well defined:", welldef)
    print("    sheet sizes:", Counter(signs.values()))

    Pbase = prod_matching(base, p)
    rows_pos, rows_neg = [], []
    extra_mon = set()
    for M, gs in orbit.items():
        PM = prod_matching(M, p)
        num = psub(PM, Pbase, p)
        q, r = divide_by_Q(num, p)
        assert not r, ("P_M - P_base not divisible by Q", M, r)
        vec = tuple(q.get(e, 0) % p for e in EXPS)
        extra_mon |= (set(q) - set(EXPS))
        (rows_pos if signs[M] == 1 else rows_neg).append(vec)
    print("    monomials outside the stated order that occur:",
          sorted(extra_mon) if extra_mon else "none")
    print("    #pos rows", len(rows_pos), "#neg rows", len(rows_neg))

    Epos = [tuple(r) for r in E[:p]]
    Eneg = [tuple(r) for r in E[p:]]
    ok_pos = Counter(rows_pos) == Counter(Epos)
    ok_neg = Counter(rows_neg) == Counter(Eneg)
    print("    positive sheet matches E rows 0..p-1 as a multiset:", ok_pos)
    print("    negative sheet matches E rows p..2p-1 as a multiset:", ok_neg)
    if not (ok_pos and ok_neg):
        swap_pos = Counter(rows_pos) == Counter(Eneg)
        swap_neg = Counter(rows_neg) == Counter(Epos)
        print("    with sheets swapped:", swap_pos, swap_neg)
        print("    computed pos rows:", sorted(rows_pos)[:3], "...")
        print("    E pos rows       :", sorted(Epos)[:3], "...")
    return rows_pos, rows_neg


for p in (7, 11):
    run(p)
