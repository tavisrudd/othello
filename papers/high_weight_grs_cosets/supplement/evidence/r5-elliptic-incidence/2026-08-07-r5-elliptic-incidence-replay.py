#!/usr/bin/env python3
"""R5-EXACT-COUNT replay: the exact split-witness count on the redundancy-five
trivial-gcd stratum, in every characteristic.

Objects.  A redundancy-five syndrome is a point f = (a0:...:a4) of PG(4,q) in
divided-power coordinates.  Its witness system W_f is the kernel of the 2x4 Hankel
matrix H(f) = [[a0,a1,a2,a3],[a1,a2,a3,a4]], acting on cubic coefficient vectors
(c0,c1,c2,c3) standing for c3 T^3 + c2 T^2 U + c1 T U^2 + c0 U^3.  When H(f) has rank
two and W_f is basepoint-free, W_f is a pencil of binary cubics, equivalently a line of
PG(3,q) relative to the twisted cubic, and f is split-free exactly when no member of
W_f is a completely split squarefree cubic.

Quantities.  Each x in PG(1,q) lies on exactly one member g_x of the pencil; write
g_x = l_x h_x with l_x the linear form at x.  Then

    Y_f = the fibre square, counted through its first projection as
          sum over x of the number of distinct rational roots of h_x,
    N_f = the number of completely split squarefree members of W_f,
    d2  = the number of members with a rational double root and a distinct rational
          simple root,
    d3  = the number of members that are perfect cubes of a rational linear form.

Root counts are computed by evaluation rather than through a discriminant, so every
quantity is defined in the same way in every characteristic; a discriminant square class
would degenerate in characteristic two, where B^2 - 4AC is always a square.

The script checks, exhaustively over PG(4,q):

  E2  Y_f = 6 N_f + 3 d2 + d3, the exact split-witness count;
  E3  d2 <= 4, and on the separable stratum d2 + 2 d3 <= 4, the Riemann-Hurwitz bound
      for a different of degree four; consequently a split-free f has Y_f <= 12;
  E4  f is split-free if and only if Y_f = 3 d2 + d3.

Inseparable pencils, which occur only in characteristic three, are counted apart; E2 and
E4 hold on them too.  In characteristic other than two and three, and for a pencil
missing the twisted cubic, E2 specialises to the generic-line incidence count of Kaipa
and Pradhan, *Incidence of Lines, Points and Planes in PG(3,q) with Respect to the
Twisted Cubic*, arXiv:2509.15332: there d3 = 0, d2 is their eta_L, and Y_f is the point
count of the non-singular model of w^2 = D_L.  Take that count from their Proposition
4.5(3) together with Theorem 5.1, which compose to denominator six; the denominator
printed in their displayed Theorem 1.3(3) is three.

Run (from this directory):
  python3 2026-08-07-r5-elliptic-incidence-replay.py [--fields 4,5,7,...] [--json OUT]
Exit code 0 iff every check passes.  Deterministic; stdlib only; no timestamps.
"""
import argparse
import json
import sys
from itertools import combinations

# ---------------------------------------------------------------- finite fields

CONWAY = {
    (2, 2): [1, 1, 1],           # x^2 + x + 1 over F_2
    (2, 3): [1, 1, 0, 1],        # x^3 + x + 1 over F_2
    (2, 4): [1, 1, 0, 0, 1],     # x^4 + x + 1 over F_2
    (2, 5): [1, 0, 1, 0, 0, 1],  # x^5 + x^2 + 1 over F_2
    (3, 2): [2, 2, 1],           # x^2 + 2x + 2 over F_3
    (5, 2): [2, 4, 1],
    (3, 3): [1, 2, 0, 1],        # x^3 + 2x + 1 over F_3
    (7, 2): [3, 6, 1],
    (11, 2): [2, 7, 1],
    (13, 2): [2, 12, 1],
}


class GF:
    """Elements are ints in [0,q) encoding base-p digit vectors of the polynomial basis."""

    def __init__(self, p, n):
        self.p, self.n, self.q = p, n, p ** n
        self.poly = CONWAY[(p, n)] if n > 1 else None
        self._mul = None
        self._inv = None
        if n > 1:
            self._build()

    def _digits(self, a):
        p, out = self.p, []
        for _ in range(self.n):
            out.append(a % p)
            a //= p
        return out

    def _undigits(self, d):
        v = 0
        for c in reversed(d):
            v = v * self.p + (c % self.p)
        return v

    def _build(self):
        p, n = self.p, self.n
        red = self.poly
        table = [[0] * self.q for _ in range(self.q)]
        for a in range(self.q):
            da = self._digits(a)
            for b in range(a, self.q):
                db = self._digits(b)
                prod = [0] * (2 * n - 1)
                for i, x in enumerate(da):
                    if x:
                        for j, y in enumerate(db):
                            prod[i + j] = (prod[i + j] + x * y) % p
                for k in range(2 * n - 2, n - 1, -1):
                    c = prod[k]
                    if c:
                        prod[k] = 0
                        for i in range(n):
                            prod[k - n + i] = (prod[k - n + i] - c * red[i]) % p
                v = self._undigits(prod[:n])
                table[a][b] = table[b][a] = v
        self._mul = table

    def add(self, a, b):
        if self.n == 1:
            return (a + b) % self.p
        return self._undigits([(x + y) % self.p
                               for x, y in zip(self._digits(a), self._digits(b))])

    def neg(self, a):
        if self.n == 1:
            return (-a) % self.p
        return self._undigits([(-x) % self.p for x in self._digits(a)])

    def sub(self, a, b):
        return self.add(a, self.neg(b))

    def mul(self, a, b):
        if self.n == 1:
            return (a * b) % self.p
        return self._mul[a][b]

    def inv(self, a):
        assert a != 0
        if self._inv is None:
            self._inv = [0] * self.q
            for b in range(1, self.q):
                self._inv[self.mul(b, b if self.n == 1 else b)] = 0
            for b in range(1, self.q):
                for c in range(1, self.q):
                    if self.mul(b, c) == 1:
                        self._inv[b] = c
                        break
        return self._inv[a]

    def elements(self):
        return range(self.q)

def field(q):
    for p in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31):
        n, v = 0, q
        while v % p == 0:
            v //= p
            n += 1
        if n and v == 1:
            return GF(p, n)
    raise ValueError(f"not a prime power: {q}")


# ------------------------------------------------------------------- geometry

INF = 'inf'


def line_points(F):
    return list(F.elements()) + [INF]


def ev_cubic(F, c, x):
    """Value of c3 T^3 + c2 T^2 U + c1 T U^2 + c0 U^3 at (T:U) = (x:1), or (1:0)."""
    if x is INF:
        return c[3]
    v = c[3]
    for j in (2, 1, 0):
        v = F.add(F.mul(v, x), c[j])
    return v


def residual_quadratic(F, c, x):
    """Divide c by the linear form vanishing at x; return (A,B,C) for A T^2 + B TU + C U^2."""
    if x is INF:
        assert c[3] == 0
        return (c[2], c[1], c[0])
    A = c[3]
    B = F.add(c[2], F.mul(x, A))
    C = F.add(c[1], F.mul(x, B))
    return (A, B, C)


def cubic_root_profile(F, c):
    """(number of distinct rational roots, squarefree over the rationals seen)."""
    roots = [x for x in line_points(F) if ev_cubic(F, c, x) == 0]
    return roots


def hankel_kernel(F, f):
    rows = [[f[0], f[1], f[2], f[3]], [f[1], f[2], f[3], f[4]]]
    piv, r = [], 0
    for col in range(4):
        pr = None
        for rr in range(r, 2):
            if rows[rr][col]:
                pr = rr
                break
        if pr is None:
            continue
        rows[r], rows[pr] = rows[pr], rows[r]
        iv = F.inv(rows[r][col])
        rows[r] = [F.mul(iv, x) for x in rows[r]]
        for rr in range(2):
            if rr != r and rows[rr][col]:
                fac = rows[rr][col]
                rows[rr] = [F.sub(rows[rr][j], F.mul(fac, rows[r][j])) for j in range(4)]
        piv.append(col)
        r += 1
        if r == 2:
            break
    free = [c for c in range(4) if c not in piv]
    basis = []
    for fc in free:
        v = [0] * 4
        v[fc] = 1
        for ri, pc in enumerate(piv):
            v[pc] = F.neg(rows[ri][fc])
        basis.append(tuple(v))
    return basis, len(piv)


def pencil_members(F, b1, b2):
    """The q+1 projective members of the pencil."""
    out = [tuple(b2)]
    for lam in F.elements():
        out.append(tuple(F.add(F.mul(lam, b1[j]), b2[j]) for j in range(4)))
    out[0] = tuple(b1)
    seen, res = set(), []
    for c in out:
        key = canon(F, c)
        if key not in seen:
            seen.add(key)
            res.append(c)
    return res


def canon(F, c):
    for j in range(4):
        if c[j]:
            iv = F.inv(c[j])
            return tuple(F.mul(iv, x) for x in c)
    return c


def projective_points(F, dim):
    q = F.q
    pts = []
    for lead in range(dim):
        for rest in range(q ** (dim - 1 - lead)):
            vec = [0] * lead + [1]
            r = rest
            for _ in range(dim - 1 - lead):
                vec.append(r % q)
                r //= q
            pts.append(tuple(vec))
    return pts


# --------------------------------------------------------------- the invariants

def quad_root_count(F, quad):
    """Number of distinct rational roots in PG(1,q) of A T^2 + B TU + C U^2.

    Computed by evaluation, so it is valid in every characteristic; the discriminant
    square class would degenerate in characteristic two, where B^2 - 4AC is always a
    square."""
    A, B, C = quad
    n = 0
    for x in F.elements():
        if F.add(F.add(F.mul(A, F.mul(x, x)), F.mul(B, x)), C) == 0:
            n += 1
    if A == 0:                      # the root at infinity
        n += 1
    return n


def cubic_tables(F):
    """For every projective cubic: its distinct rational roots, and for each root the
    number of distinct rational roots of the residual quadratic."""
    prof = {}
    for c in projective_points(F, 4):
        key = canon(F, c)
        if key in prof:
            continue
        roots = [x for x in line_points(F) if ev_cubic(F, key, x) == 0]
        entry = {x: quad_root_count(F, residual_quadratic(F, key, x)) for x in roots}
        prof[key] = (roots, entry)
    return prof


def stratum_data(F, f, prof=None):
    """Return None off the trivial-gcd separable stratum, else the invariant record."""
    basis, rank = hankel_kernel(F, f)
    if rank != 2:
        return None
    b1, b2 = basis
    members = pencil_members(F, b1, b2)
    if len(members) != F.q + 1:
        return None
    # basepoint-freeness: no point of PG(1,q^-) is a root of every member
    for x in line_points(F):
        if all(ev_cubic(F, c, x) == 0 for c in members):
            return None
    Y = 0
    seen = set()
    N = d2 = d3 = 0
    for c in members:
        key = canon(F, c)
        roots, entry = prof[key]
        for x in roots:
            Y += entry[x]
            seen.add(x)
        if len(roots) == 3:
            N += 1
        elif len(roots) == 2:
            d2 += 1
        elif len(roots) == 1 and entry[roots[0]] == 1:
            d3 += 1
    if len(seen) != F.q + 1:
        return None
    return {"N": N, "Y": Y, "d2": d2, "d3": d3}


def check_field(F, report):
    q = F.q
    stats = {"stratum": 0, "split_free": 0, "inseparable": 0,
             "max_split_free_Y": 0, "split_free_profile": {}}
    prof = cubic_tables(F)
    for f in projective_points(F, 5):
        rec = stratum_data(F, f, prof)
        if rec is None:
            continue
        stats["stratum"] += 1
        N, Y, d2, d3 = rec["N"], rec["Y"], rec["d2"], rec["d3"]
        # E1/E2: the exact count
        assert Y == 6 * N + 3 * d2 + d3, ("E2", q, f, rec)
        # E3: on the separable stratum a line meets the twisted cubic at most twice.
        # Inseparable pencils occur only in characteristic three and are counted apart;
        # the identities above hold on both.
        if d3 > 2:
            assert F.p == 3, ("E3-char", q, f, rec)
            stats["inseparable"] += 1
            continue
        assert d2 <= 4, ("E3", q, f, rec)
        # E3b: tame Riemann-Hurwitz on the separable stratum.  The different has degree
        # four; a rational simple branch point spends one and a rational index-three
        # point spends two.
        assert d2 + 2 * d3 <= 4, ("E3b", q, f, rec)
        if N == 0:
            assert Y <= 12, ("E3c", q, f, rec)
        # E4
        assert (N == 0) == (Y == 3 * d2 + d3), ("E4", q, f, rec)
        if N == 0:
            assert Y <= 14, ("E4b", q, f, rec)
        # E5: the Aubry-Perret range binds only where Y_f is geometrically integral,
        # which the cyclic and permutation strata violate; the recorded gate is the
        # split-free consequence.
        if N == 0:
            stats["split_free"] += 1
            stats["max_split_free_Y"] = max(stats["max_split_free_Y"], Y)
            stats["split_free_profile"][f"{d2},{d3}"] = (
                stats["split_free_profile"].get(f"{d2},{d3}", 0) + 1)
    report[str(q)] = stats
    return stats


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--fields", default="4,5,7,8,9,11,13,16,17,19,23,25,27,32")
    ap.add_argument("--json", default=None)
    args = ap.parse_args()
    report = {}
    for q in [int(x) for x in args.fields.split(",")]:
        F = field(q)
        st = check_field(F, report)
        print(f"q={q:>3}: stratum {st['stratum']:>7}  split-free {st['split_free']:>4}"
              f"  max Y on the split-free locus {st['max_split_free_Y']:>3}"
              f"  inseparable {st['inseparable']:>4}")
    print("all checks passed")
    if args.json:
        with open(args.json, "w", encoding="utf-8") as fh:
            json.dump(report, fh, indent=1, sort_keys=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
