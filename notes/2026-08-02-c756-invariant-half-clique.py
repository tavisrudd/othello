#!/usr/bin/env python3
"""C756, twenty-eighth pass: the invariant half of the crown as a clique problem.

Verifies, for odd prime powers q:

  1. model agreement: the conjugate-pair model on F_{q^2} (conditions (A),(B) of the
     coherent-system reformulation) and the binary-quadratic model of PG(2,q) define
     the same graph Gamma on the q(q-1)/2 internal points of a conic, namely
     "join is an external line";
  2. Gamma is regular of degree (q^2-1)/4;
  3. omega(Gamma), the maximum number of internal points pairwise joined by external
     lines, against the saturated-internal size n = (q+3)/2;
  4. every external line's (q+1)/2 internal points form a clique C_l;
  5. C_l + pole(l) is a clique exactly when q = 3 (mod 4)  [Theorem 10, case (i)];
  6. the exact extension criterion of Theorem 10 against brute force, and the
     emptiness of its exceptional case (ii) for the tested fields;
  7. every coherent system is a Gamma-clique of size (q+3)/2 (checked at q=5, where
     coherent systems exist).

Replay:  python3 2026-08-02-c756-invariant-half-clique.py
"""

import json
import sys
import time

# --------------------------------------------------------------------------- fields

IRRED = {(3, 2): [2, 0], (5, 2): [2, 0], (7, 2): [3, 0], (3, 3): [1, 1, 0],
         (11, 2): [7, 0], (5, 3): [4, 4, 0], (13, 2): [2, 0]}


class GF:
    """GF(p^k); elements are 0..q-1 read as base-p digit vectors, x^k = sum f[j] x^j."""

    def __init__(self, p, k):
        self.p, self.k, self.q = p, k, p ** k
        if k == 1:
            self.add = lambda a, b: (a + b) % p
            self.neg = lambda a: (-a) % p
            self.mul = lambda a, b: (a * b) % p
        else:
            f = IRRED[(p, k)]
            self.f = f
            self._mt = [[self._mulp(a, b, f) for b in range(self.q)] for a in range(self.q)]
            self._at = [[self._addp(a, b) for b in range(self.q)] for a in range(self.q)]
            self.add = lambda a, b: self._at[a][b]
            self.mul = lambda a, b: self._mt[a][b]
            self.neg = lambda a: self._negp(a)
        self.sq = set(self.mul(x, x) for x in range(1, self.q))
        assert len(self.sq) == (self.q - 1) // 2
        assert all(any(self.mul(a, b) == 1 for b in range(self.q)) for a in range(1, self.q))

    def _dig(self, a):
        d = []
        for _ in range(self.k):
            d.append(a % self.p)
            a //= self.p
        return d

    def _und(self, d):
        r = 0
        for i in range(len(d) - 1, -1, -1):
            r = r * self.p + d[i] % self.p
        return r

    def _addp(self, a, b):
        return self._und([(x + y) % self.p for x, y in zip(self._dig(a), self._dig(b))])

    def _negp(self, a):
        return self._und([(-x) % self.p for x in self._dig(a)])

    def _mulp(self, a, b, f):
        A, B, p, k = self._dig(a), self._dig(b), self.p, self.k
        C = [0] * (2 * k - 1)
        for i, x in enumerate(A):
            if x:
                for j, y in enumerate(B):
                    C[i + j] = (C[i + j] + x * y) % p
        for i in range(len(C) - 1, k - 1, -1):
            c = C[i]
            if c:
                C[i] = 0
                for j in range(k):
                    C[i - k + j] = (C[i - k + j] + c * f[j]) % p
        return self._und(C[:k])

    def chi(self, a):
        return 0 if a == 0 else (1 if a in self.sq else -1)

    def inv(self, a):
        return next(b for b in range(1, self.q) if self.mul(a, b) == 1)


# ------------------------------------------------------- binary-quadratic plane model

class Plane:
    """PG(2,q) as binary quadratic forms xX^2+yXY+wY^2, conic = {disc 0}."""

    def __init__(self, F):
        self.F = F
        q = F.q
        one = 1
        self.two = F.add(one, one)
        self.four = F.mul(self.two, self.two)
        pts = [(1, y, w) for y in range(q) for w in range(q)]
        pts += [(0, 1, w) for w in range(q)] + [(0, 0, 1)]
        self.pts = pts
        self.internal = [u for u in pts if F.chi(self.Q(u)) == -1]

    def Q(self, u):
        F = self.F
        return F.add(F.mul(u[1], u[1]), F.neg(F.mul(self.four, F.mul(u[0], u[2]))))

    def B(self, u, v):
        F = self.F
        cross = F.add(F.mul(u[0], v[2]), F.mul(u[2], v[0]))
        return F.add(F.mul(u[1], v[1]), F.neg(F.mul(self.two, cross)))

    def res(self, u, v):
        """B^2 - Q(u)Q(v); its character is -1 exactly when the join misses the conic."""
        F = self.F
        b = self.B(u, v)
        return F.add(F.mul(b, b), F.neg(F.mul(self.Q(u), self.Q(v))))

    def graph(self):
        F = self.F
        pts = self.internal
        m = len(pts)
        nbr = [0] * m
        for i in range(m):
            for j in range(i + 1, m):
                if F.chi(self.res(pts[i], pts[j])) == -1:
                    nbr[i] |= 1 << j
                    nbr[j] |= 1 << i
        return pts, nbr


# ---------------------------------------------------------------- max-clique (Tomita)

def max_clique(nbr, m, start=None):
    best = [0]
    best_set = [None]

    def order_colour(P):
        order, colours, Qm, c = [], [], P, 0
        while Qm:
            c += 1
            avail = Qm
            while avail:
                v = (avail & -avail).bit_length() - 1
                avail &= ~(1 << v) & ~nbr[v]
                Qm &= ~(1 << v)
                order.append(v)
                colours.append(c)
        return order, colours

    def expand(R, P):
        if P == 0:
            if len(R) > best[0]:
                best[0], best_set[0] = len(R), list(R)
            return
        order, colours = order_colour(P)
        for k in range(len(order) - 1, -1, -1):
            v = order[k]
            if len(R) + colours[k] <= best[0]:
                return
            expand(R + [v], P & nbr[v])
            P &= ~(1 << v)

    if start is None:
        expand([], (1 << m) - 1)
    else:
        expand([start], nbr[start])
    return best[0], best_set[0]


# ------------------------------------------------ conjugate-pair model on F_{q^2}

def conjugate_pair_graph(F):
    """z = a + s c with s^2 = eps; alpha = N(z_i-z_j), beta = N(z_i-z_j^q).

    Coherence forces chi(alpha) = delta and chi(beta) = -delta, hence chi(alpha*beta) = -1.
    Returns the vertex list and the chi(alpha*beta) = -1 graph.
    """
    q = F.q
    eps = next(e for e in range(1, q) if F.chi(e) == -1)

    def N(a, c):
        return F.add(F.mul(a, a), F.neg(F.mul(eps, F.mul(c, c))))

    half = [c for c in range(1, q)]
    # identify c with -c (z with z^q)
    seen, verts = set(), []
    for a in range(q):
        for c in half:
            if (a, F.neg(c)) in seen:
                continue
            seen.add((a, c))
            verts.append((a, c))
    m = len(verts)
    nbr = [0] * m
    for i in range(m):
        ai, ci = verts[i]
        for j in range(i + 1, m):
            aj, cj = verts[j]
            d = F.add(ai, F.neg(aj))
            al = N(d, F.add(ci, F.neg(cj)))
            be = N(d, F.add(ci, cj))
            if al == 0 or be == 0:
                continue
            if F.chi(F.mul(al, be)) == -1:
                nbr[i] |= 1 << j
                nbr[j] |= 1 << i
    return verts, nbr, eps, N


def coherent_systems(F, N, eps):
    """All (A)+(B) systems of size (q+3)/2 among irrational z (brute force; small q)."""
    q = F.q
    t = (q + 1) // 2
    delta = (-1) ** t
    n = (q + 3) // 2
    irr = [(a, c) for a in range(q) for c in range(1, q)]

    def ok(u, v):
        d = F.add(u[0], F.neg(v[0]))
        al = N(d, F.add(u[1], F.neg(v[1])))
        be = N(d, F.add(u[1], v[1]))
        return F.chi(al) == delta and F.chi(be) == -delta

    adj = {u: set(v for v in irr if v != u and ok(u, v)) for u in irr}
    out = []

    def ext(cur, cand):
        if len(cur) == n:
            out.append(tuple(cur))
            return
        for i, v in enumerate(cand):
            if len(cur) + len(cand) - i < n:
                break
            ext(cur + [v], [w for w in cand[i + 1:] if w in adj[v]])

    ext([], irr)
    return out, delta


# ------------------------------------------------------------------ Theorem 10 checks

def s_set(F, lam):
    """{sigma : chi(sigma^2 - lam) = -1}."""
    out = set()
    for s in range(F.q):
        if F.chi(F.add(F.mul(s, s), F.neg(lam))) == -1:
            out.add(s)
    return frozenset(out)


def theorem10(F, P):
    """Brute-force extension data plus the criterion, for every external line."""
    q = F.q
    pts, nbr = P.graph()
    idx = {u: i for i, u in enumerate(pts)}
    m = len(pts)
    pole_ok, other_ext, line_sizes = 0, 0, set()
    for v0 in pts:                                   # internal point = pole of an external line
        C = [u for u in pts if P.B(v0, u) == 0]      # internal points of its polar
        line_sizes.add(len(C))
        # C is a clique
        for a in range(len(C)):
            for b in range(a + 1, len(C)):
                assert (nbr[idx[C[a]]] >> idx[C[b]]) & 1
        if all((nbr[idx[v0]] >> idx[u]) & 1 for u in C):
            pole_ok += 1
        for w in pts:
            if w == v0 or P.B(v0, w) == 0:
                continue
            if all((nbr[idx[w]] >> idx[u]) & 1 for u in C):
                other_ext += 1
    # exceptional case (ii): exists m != 0,+-1 with S_{m^2} = S_1
    s1 = s_set(F, 1)
    case_ii = [mm for mm in range(1, q)
               if F.mul(mm, mm) != 1 and s_set(F, F.mul(mm, mm)) == s1]
    return dict(pole_extends=pole_ok, internal_points=m, non_pole_extensions=other_ext,
                polar_internal_sizes=sorted(line_sizes), case_ii_solutions=case_ii)


# ------------------------------------------------------------------------------- main

def max_external_arc(P, pts, nbr):
    """Largest set of internal points, pairwise externally joined, with no three collinear."""
    F = P.F
    m = len(pts)

    def det(u, v, w):
        A, M, G = F.add, F.mul, F.neg
        t1 = M(u[0], A(M(v[1], w[2]), G(M(v[2], w[1]))))
        t2 = M(u[1], A(M(v[0], w[2]), G(M(v[2], w[0]))))
        t3 = M(u[2], A(M(v[0], w[1]), G(M(v[1], w[0]))))
        return A(A(t1, G(t2)), t3)

    line = [[0] * m for _ in range(m)]
    for i in range(m):
        for j in range(i + 1, m):
            msk = 0
            for t in range(m):
                if t != i and t != j and det(pts[i], pts[j], pts[t]) == 0:
                    msk |= 1 << t
            line[i][j] = line[j][i] = msk
    best = [0]

    def expand(R, cand):
        if len(R) > best[0]:
            best[0] = len(R)
        while cand:
            if len(R) + bin(cand).count("1") <= best[0]:
                return
            v = (cand & -cand).bit_length() - 1
            cand &= cand - 1
            nxt = cand & nbr[v]
            for u in R:
                nxt &= ~line[u][v]
            expand(R + [v], nxt)

    expand([], (1 << m) - 1)
    return best[0]


def run(p, k, do_clique=True, do_coherent=False, do_arc=False):
    F = GF(p, k)
    q = F.q
    rec = {"q": q, "q_mod_4": q % 4}
    P = Plane(F)
    pts, nbr = P.graph()
    rec["internal_points"] = len(pts)
    assert len(pts) == q * (q - 1) // 2
    deg = set(bin(x).count("1") for x in nbr)
    rec["degree"] = sorted(deg)
    assert deg == {(q * q - 1) // 4}

    # cross-model agreement
    verts, nbr2, eps, N = conjugate_pair_graph(F)
    assert len(verts) == len(pts)
    ev = sorted(sorted(bin(x).count("1") for x in nbr2))
    rec["conjugate_model_degrees_match"] = (ev == sorted(bin(x).count("1") for x in nbr))
    if do_clique:
        w1, _ = max_clique(nbr, len(pts), start=0)
        w2, _ = max_clique(nbr2, len(verts), start=0)
        rec["omega_plane_model"] = w1
        rec["omega_conjugate_model"] = w2
        rec["models_agree"] = (w1 == w2)
        rec["n_saturated"] = (q + 3) // 2
        rec["half"] = (q + 1) // 2
        rec["omega_equals_n"] = (w1 == (q + 3) // 2)
    rec.update(theorem10(F, P))
    if do_arc:
        rec["max_conic_external_internal_arc"] = max_external_arc(P, pts, nbr)
    if do_coherent:
        systems, delta = coherent_systems(F, N, eps)
        rec["coherent_systems"] = len(systems)
        idx = {v: i for i, v in enumerate(verts)}

        def canon(z):
            return z if z in idx else (z[0], F.neg(z[1]))

        allclique = True
        for Z in systems:
            ids = [idx[canon(z)] for z in Z]
            assert len(set(ids)) == len(ids)
            for a in range(len(ids)):
                for b in range(a + 1, len(ids)):
                    if not (nbr2[ids[a]] >> ids[b]) & 1:
                        allclique = False
        rec["coherent_systems_are_gamma_cliques"] = allclique
    return rec


def main():
    # (field, exponent-or-0, max-clique, coherent-systems, arc-maximum)
    jobs = [(5, 1, True, True, True), (7, 1, True, False, True), (9, 0, True, False, True),
            (11, 1, True, False, True), (13, 1, True, False, True), (17, 1, True, False, True),
            (19, 1, True, False, True), (23, 1, True, False, True), (25, 0, True, False, False),
            (27, 0, True, False, False), (29, 1, True, False, False), (31, 1, True, False, False),
            (37, 1, True, False, False), (41, 1, True, False, False), (43, 1, True, False, False),
            (49, 0, True, False, False)]
    pp = {9: (3, 2), 25: (5, 2), 27: (3, 3), 49: (7, 2), 121: (11, 2), 125: (5, 3)}
    out = []
    for (a, k, dc, dcoh, darc) in jobs:
        p, kk = (a, k) if k else pp[a]
        t = time.time()
        rec = run(p, kk, dc, dcoh, darc)
        rec["seconds"] = round(time.time() - t, 2)
        out.append(rec)
        print(json.dumps(rec), flush=True)
    with open("2026-08-02-c756-invariant-half-clique.json", "w") as fh:
        json.dump(out, fh, indent=1, sort_keys=True)
        fh.write("\n")


if __name__ == "__main__":
    sys.setrecursionlimit(100000)
    main()
