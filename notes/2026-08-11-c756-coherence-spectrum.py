#!/usr/bin/env python3
"""C756 — independent replay and spectrum of the oriented coherence graph.

This is the independent cross-check of
`2026-08-11-c756-coherent-orientation-census.rs`, written against a different
model of F_{q^2} and a different search implementation, plus the spectral data
for the Hoffman ratio bound.

Model.  F_{q^2} = F_q[y]/(y^2 - d) with d a fixed nonsquare of F_q, so
z = a + b y with a, b in F_q, z^q = a - b y, and

    chi_{q^2}(a + b y) = chi_q(a^2 - d b^2).

The Rust census instead builds F_{q^2} as F_p[x]/(g) for a primitive g and reads
characters off discrete logarithms.  The two constructions share no code.

Graph.  Vertices are the z with b != 0 (the non-rational elements); u ~ v iff

    chi_{q^2}(u - v) = c   and   chi_{q^2}(u - v^q) = -c,   c = (-1)^{(q+1)/2}.

These are the sign-coherence relations of notes/2026-08-10-c756-coherent-dual-three-net.md.
A saturated-internal conic-filling arc over F_q forces a clique of size
k = (q+3)/2.  The graph is vertex-transitive under z -> lambda z + t
(lambda in F_q^*, t in F_q), which acts simply transitively, so it is regular and
the maximum clique may be searched through one fixed vertex.

Outputs, per q:
  n_vertices, degree, coherent (number of k-cliques through the fixed vertex),
  omega (maximum clique size), and the spectral data lambda_min,
  lambda_max_nontrivial, and the Delsarte--Hoffman clique bound
  n(1 + lambda_max_nontrivial)/(n - degree + lambda_max_nontrivial).
A clique bound below k would close the saturated-internal branch over that field
without any search.  It does not: see `clique_ratio_bound` and the report.

Run:
  cd ~/src/othello
  uv run --with numpy python3 notes/2026-08-11-c756-coherence-spectrum.py > /tmp/out.json
  uv run --with numpy python3 notes/2026-08-11-c756-coherence-spectrum.py 5 7 9 11
"""

import json
import sys


def is_prime(n):
    if n < 2:
        return False
    d = 2
    while d * d <= n:
        if n % d == 0:
            return False
        d += 1
    return True


def prime_power(q):
    """Return (p, e) with q = p^e, or raise."""
    for p in range(2, q + 1):
        if q % p == 0 and is_prime(p):
            e, t = 0, q
            while t % p == 0:
                t //= p
                e += 1
            if t != 1:
                raise ValueError("not a prime power: %d" % q)
            return p, e
    raise ValueError("not a prime power: %d" % q)


class Fq:
    """F_q = F_p[x]/(f), elements are tuples of length e (little-endian coefficients)."""

    def __init__(self, q):
        self.p, self.e = prime_power(q)
        self.q = q
        self.f = self._irreducible()
        self.elems = self._all()
        self.index = {v: i for i, v in enumerate(self.elems)}
        self.addt = [[self.index[self._add(u, v)] for v in self.elems] for u in self.elems]
        self.mult = [[self.index[self._mul(u, v)] for v in self.elems] for u in self.elems]
        self.negt = [self.index[self._neg(u)] for u in self.elems]
        self.zero = self.index[tuple([0] * self.e)]
        self.one = self.index[tuple([1] + [0] * (self.e - 1))]
        self.chit = self._characters()
        self.d = next(i for i in range(q) if self.chit[i] == -1)  # first nonsquare

    def _all(self):
        out = [()]
        for _ in range(self.e):
            out = [v + (c,) for v in out for c in range(self.p)]
        return sorted(out, key=lambda v: tuple(reversed(v)))

    def _irreducible(self):
        """First monic degree-e polynomial with no root pattern reducibility, by brute
        force over all monic degree-e polynomials in lexicographic coefficient order."""
        if self.e == 1:
            return (0,)
        p, e = self.p, self.e
        # candidate f = x^e + sum c_i x^i; irreducible iff x^(p^e) = x mod f and
        # gcd(x^(p^(e/l)) - x, f) = 1 for every prime l | e.  Use the simpler test:
        # f has no factor of degree <= e//2, checked by trial division.
        def polymul(a, b):
            r = [0] * (len(a) + len(b) - 1)
            for i, ai in enumerate(a):
                if ai:
                    for j, bj in enumerate(b):
                        r[i + j] = (r[i + j] + ai * bj) % p
            return r

        def polymod(a, m):
            a = a[:]
            dm = len(m) - 1
            while len(a) - 1 >= dm and any(a):
                while a and a[-1] == 0:
                    a.pop()
                if len(a) - 1 < dm:
                    break
                shift = len(a) - 1 - dm
                coef = a[-1]
                for i, mi in enumerate(m):
                    a[i + shift] = (a[i + shift] - coef * mi) % p
                while a and a[-1] == 0:
                    a.pop()
            return a

        def monics(deg):
            if deg == 0:
                yield [1]
                return
            cur = [0] * deg + [1]
            while True:
                yield cur[:]
                i = 0
                while i < deg:
                    cur[i] += 1
                    if cur[i] < p:
                        break
                    cur[i] = 0
                    i += 1
                if i == deg:
                    return

        for cand in monics(e):
            ok = True
            for dd in range(1, e // 2 + 1):
                for g in monics(dd):
                    if not polymod(cand[:], g):
                        ok = False
                        break
                if not ok:
                    break
            if ok:
                return tuple(cand[:e])  # low coefficients; leading 1 implicit
        raise RuntimeError("no irreducible polynomial")

    def _add(self, u, v):
        return tuple((a + b) % self.p for a, b in zip(u, v))

    def _neg(self, u):
        return tuple((-a) % self.p for a in u)

    def _mul(self, u, v):
        p, e = self.p, self.e
        r = [0] * (2 * e - 1)
        for i, a in enumerate(u):
            if a:
                for j, b in enumerate(v):
                    r[i + j] = (r[i + j] + a * b) % p
        for i in range(2 * e - 2, e - 1, -1):
            c = r[i]
            if c:
                r[i] = 0
                for j in range(e):
                    r[i - e + j] = (r[i - e + j] - c * self.f[j]) % p
        return tuple(r[:e])

    def add(self, i, j):
        return self.addt[i][j]

    def sub(self, i, j):
        return self.addt[i][self.negt[j]]

    def mul(self, i, j):
        return self.mult[i][j]

    def _characters(self):
        """chi_q by explicit squaring: the squares are the image of x -> x^2."""
        sq = set()
        for i in range(self.q):
            if i != self.zero:
                sq.add(self.mul(i, i))
        return [0 if i == self.zero else (1 if i in sq else -1) for i in range(self.q)]


def build_graph(q):
    F = Fq(q)
    c = 1 if ((q + 1) // 2) % 2 == 0 else -1
    d = F.d
    # chi_{q^2}(a + b y) = chi_q(a^2 - d b^2)
    def chi2(a, b):
        return F.chit[F.sub(F.mul(a, a), F.mul(d, F.mul(b, b)))]

    verts = [(a, b) for a in range(q) for b in range(q) if b != F.zero]
    assert len(verts) == q * q - q
    idx = {v: i for i, v in enumerate(verts)}
    n = len(verts)
    adjmask = [0] * n
    for i in range(n):
        ai, bi = verts[i]
        for j in range(i + 1, n):
            aj, bj = verts[j]
            da = F.sub(ai, aj)
            if chi2(da, F.sub(bi, bj)) != c:
                continue
            if chi2(da, F.add(bi, bj)) != -c:
                continue
            adjmask[i] |= 1 << j
            adjmask[j] |= 1 << i
    return F, verts, idx, adjmask, c


def clique_count(adjmask, cand, need, state):
    """Count cliques of size `need` inside the bitmask `cand`."""
    state["nodes"] += 1
    if need == 0:
        state["found"] += 1
        return
    if bin(cand).count("1") < need:
        return
    c = cand
    while c:
        low = c & -c
        v = low.bit_length() - 1
        c ^= low
        if bin(c).count("1") + 1 < need:
            return
        clique_count(adjmask, c & adjmask[v], need - 1, state)


def max_clique(adjmask, cand, size, best):
    """Simple branch and bound for the maximum clique inside `cand`."""
    if cand == 0:
        return max(best, size)
    if size + bin(cand).count("1") <= best:
        return best
    c = cand
    while c:
        low = c & -c
        v = low.bit_length() - 1
        c ^= low
        if size + bin(c).count("1") + 1 <= best:
            return best
        best = max_clique(adjmask, c & adjmask[v], size + 1, best)
    return best


def clique_ratio_bound(n, deg, lmax2):
    """Delsarte--Hoffman clique bound for a d-regular graph on n vertices.

    A clique of G is an independent set of the complement, which is
    (n-1-d)-regular with least eigenvalue -1-lambda_max_nontrivial(G).  Hoffman's
    coclique bound there gives

        omega(G) <= n (1 + lambda_max_nontrivial) / (n - d + lambda_max_nontrivial).

    The frequently quoted `1 - d/lambda_min` is NOT a clique bound for general
    regular graphs: the prism over K_5 (two disjoint K_5 joined by a perfect
    matching) is 5-regular with lambda_min = -2, giving 3.5, while its clique
    number is 5.  `_selftest` pins both facts.
    """
    return n * (1.0 + lmax2) / (n - deg + lmax2)


def _selftest():
    # prism over K_5: n=10, d=5, spectrum {5, 3, 0^4, -2^4}, omega = 5
    assert abs(clique_ratio_bound(10, 5, 3.0) - 5.0) < 1e-9
    assert abs((1.0 - 5.0 / -2.0) - 3.5) < 1e-9  # the invalid formula, below omega
    # triangular graph T(5) = complement of Petersen: n=10, d=6, eigenvalues 6,1,-2
    assert abs(clique_ratio_bound(10, 6, 1.0) - 4.0) < 1e-9
    # Paley graph of order 13: n=13, d=6, lambda_max_nontrivial = (-1+sqrt(13))/2
    b = clique_ratio_bound(13, 6, (13.0**0.5 - 1) / 2)
    assert 3.0 < b < 3.61 and 13.0**0.5 - b < 1e-9


def spectrum(adjmask, n):
    import numpy as np

    a = np.zeros((n, n), dtype=np.float64)
    for i in range(n):
        m = adjmask[i]
        while m:
            low = m & -m
            j = low.bit_length() - 1
            m ^= low
            a[i, j] = 1.0
    ev = np.linalg.eigvalsh(a)
    return ev


def run(q, spectral_limit=2500, search=True):
    F, verts, idx, adjmask, c = build_graph(q)
    n = len(verts)
    k = (q + 3) // 2
    deg = bin(adjmask[0]).count("1")
    for m in adjmask:
        assert bin(m).count("1") == deg, "graph is not regular at q=%d" % q
    # fixed vertex: y itself, i.e. (a, b) = (0, 1); vertex-transitivity makes the choice free
    v0 = idx[(F.zero, F.one)]
    nbr = adjmask[v0]
    state = {"nodes": 0, "found": 0}
    omega = None
    if search:
        clique_count(adjmask, nbr, k - 1, state)
        omega = max_clique(adjmask, nbr, 1, 0)
    row = {
        "q": q,
        "k": k,
        "c": c,
        "n_vertices": n,
        "degree": deg,
        "n_neighbors": bin(nbr).count("1"),
        "coherent_through_v0": state["found"] if search else None,
        "search_nodes": state["nodes"],
        "omega": omega,
    }
    if n <= spectral_limit:
        ev = spectrum(adjmask, n)
        lmin = float(ev[0])
        lmax2 = float(ev[-2])
        bound = clique_ratio_bound(n, deg, lmax2)
        # multiplicities locate an eigenvalue in the representation theory of the acting
        # group AGL(1,q) = F_q semidirect F_q^*, which acts simply transitively: the q-1
        # linear characters give simple eigenvalues, the (q-1)-dimensional irreducible
        # contributes each of its eigenvalues with multiplicity q-1.
        row["lambda_min_multiplicity"] = int(sum(1 for e in ev if abs(e - lmin) < 1e-6))
        row["lambda_max_nontrivial_multiplicity"] = int(
            sum(1 for e in ev[:-1] if abs(e - lmax2) < 1e-6)
        )
        row["lambda_min"] = round(lmin, 6)
        row["lambda_max_nontrivial"] = round(lmax2, 6)
        row["clique_ratio_bound"] = round(bound, 6)
        # `strict` means the ratio bound alone forbids a coherent k-set.  A bound
        # numerically equal to k is reported as not strict: floating-point noise of
        # order 1e-13 must never be read as a proof.
        row["ratio_bound_strict"] = bool(bound < k - 1e-6)
        row["ratio_bound_over_k"] = round(bound / k, 6)
    return row


# Fixed vertex bounds.  The two searches are exponential in pure Python and the dense
# eigensolve is cubic, so each is skipped above its own bound and reported as null.
SEARCH_VERTEX_LIMIT = 2500
SPECTRUM_VERTEX_LIMIT = 7000


def main():
    _selftest()
    qs = [int(a) for a in sys.argv[1:]] or [
        5, 7, 9, 11, 13, 17, 19, 23, 25, 27, 29, 31, 37, 41, 43, 49, 81
    ]
    rows = [
        run(
            q,
            spectral_limit=SPECTRUM_VERTEX_LIMIT,
            search=(q * q - q <= SEARCH_VERTEX_LIMIT),
        )
        for q in qs
    ]
    print(
        json.dumps(
            {
                "task": "C756",
                "family": "saturated-internal",
                "check": "independent replay and spectrum of the oriented coherence graph",
                "rows": rows,
            },
            indent=1,
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
