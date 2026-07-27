#!/usr/bin/env python3
"""C491 independent replay: deep holes of PRS(q-4) via the Hankel-pencil criterion.

Independent of 2026-07-22-c491-prs-deep-hole-census.py (which marks spans of column
triples): here a point f=(a0..a4) of PG(4,q) is classified via the kernel of the 2x4
Hankel matrix H(f) = [[a0,a1,a2,a3],[a1,a2,a3,a4]]: f lies in the span of 3 distinct
columns nu(t1),nu(t2),nu(t3) of the parity check iff the cubic prod(T - t_i U) (factor U
for t_i = inf) lies in ker H(f) (Lemma 1 of the C491 report); f (off the curve) is a
deep hole iff no member of the kernel pencil is a totally split squarefree cubic.

The replay independently constructs each classified family:
  T   tangent-line points span(nu(t), nu^[1](t)) minus curve points;
  S   rational points of sigma-secants joining conjugate pairs of C(F_{q^2});
  O+  Osc(t1) cap Osc(t2) over rational pairs {t1,t2} (deep iff q = 2 mod 3, char != 3);
  O-  rational point of Osc(w) cap Osc(w^q) over conjugate pairs (deep iff q = 1 mod 3,
      char != 3);
  N   char 3 only: the nucleus e2 (nu^[2] is constantly e2 in char 3, so all osculating
      planes concur there; PGL2-fixed);
  W   char 3 only: orbit of e2 - a*e4 with -a a nonsquare; constructed as the set
      { M_g(e2 - a e4) } via orbit closure under the group generators.

Checks per field q against the census JSON:
  R1 deep-hole count from the Hankel scan == census deep_hole_count;
  R2 every census orbit representative is deep by the Hankel test; orbit sizes sum to the
     total; census tangent/sigma/excess counts match the replay's family counts;
  R3 T, S are deep and disjoint; O+/O- deep exactly per the q mod 3 / char-3 rule; in
     char 3, N and W are deep, W has size (q^2-1)/2;
  R4 residual := deep minus (T u S u O+_deep u O-_deep u N u W) matches the census sporadic
     content: empty for q in {16} and all q >= 23; otherwise its size equals the census
     excess minus the classified-family sizes (sporadic orbits exist only at
     q in {7,8,9,11,13,17,19} in the census range).

Run (from repo root):
  python3 notes/2026-07-22-c491-prs-deep-hole-replay.py \
      [--json notes/2026-07-22-c491-prs-deep-hole-census.json] [--fields 7,8,...]
Exit code 0 iff every check passes.  Deterministic; stdlib only; no timestamps.
"""
import argparse
import json
import sys
from itertools import combinations

MODULI = {  # q = p^m: modulus polynomial coefficients (low degree first) for t^m = ...
    8: (2, [1, 1, 0]),          # t^3 = t + 1
    9: (3, [2, 0]),             # t^2 = -1
    16: (2, [1, 1, 0, 0]),      # t^4 = t + 1
    25: (5, [2, 0]),            # t^2 = 2
    27: (3, [2, 1, 0]),         # t^3 = t - 1
    32: (2, [1, 0, 1, 0, 0]),   # t^5 = t^2 + 1
    49: (7, [3, 0]),            # t^2 = 3
}


class GF:
    """GF(q) as integers 0..q-1; base-p digits = polynomial coefficients, low first."""

    def __init__(self, q):
        self.q = q
        if q in MODULI:
            self.p, red = MODULI[q][0], MODULI[q][1]
            self.m = len(red)
        else:
            self.p, self.m, red = q, 1, None
        p, m = self.p, self.m
        assert p ** m == q
        if m == 1:
            self.add_t = [[(a + b) % q for b in range(q)] for a in range(q)]
            self.mul_t = [[(a * b) % q for b in range(q)] for a in range(q)]
        else:
            def poly(x):
                d = []
                for _ in range(m):
                    d.append(x % p)
                    x //= p
                return d

            def unpoly(d):
                x = 0
                for c in reversed(d):
                    x = x * p + c
                return x
            self.add_t = [[unpoly([(u + v) % p for u, v in zip(poly(a), poly(b))])
                           for b in range(q)] for a in range(q)]
            mul_t = []
            for a in range(q):
                row = []
                da = poly(a)
                for b in range(q):
                    db = poly(b)
                    prod = [0] * (2 * m - 1)
                    for i, u in enumerate(da):
                        if u:
                            for j, v in enumerate(db):
                                prod[i + j] = (prod[i + j] + u * v) % p
                    for k in range(2 * m - 2, m - 1, -1):
                        c = prod[k]
                        if c:
                            prod[k] = 0
                            for j, r in enumerate(red):
                                prod[k - m + j] = (prod[k - m + j] + c * r) % p
                    row.append(unpoly(prod[:m]))
                mul_t.append(row)
            self.mul_t = mul_t
        self.neg_t = [0] * q
        for a in range(q):
            for b in range(q):
                if self.add_t[a][b] == 0:
                    self.neg_t[a] = b
                    break
        self.inv_t = [0] * q
        for a in range(1, q):
            for b in range(1, q):
                if self.mul_t[a][b] == 1:
                    self.inv_t[a] = b
                    break
            assert self.mul_t[a][self.inv_t[a]] == 1, "modulus not irreducible"
        self.squares = set(self.mul_t[a][a] for a in range(1, q))
        self.zero, self.one = 0, 1

    def add(self, a, b):
        return self.add_t[a][b]

    def mul(self, a, b):
        return self.mul_t[a][b]

    def neg(self, a):
        return self.neg_t[a]

    def sub(self, a, b):
        return self.add_t[a][self.neg_t[b]]

    def inv(self, a):
        return self.inv_t[a]

    def intmul(self, n, x):
        r = 0
        for _ in range(n % self.p):
            r = self.add(r, x)
        return r


class GF2:
    """GF(q^2) over GF(q): u^2 = eps (q odd, eps a nonsquare) or u^2 = u + eps (char 2,
    x^2+x+eps irreducible).  Elements are pairs (a0, a1) = a0 + a1*u."""

    def __init__(self, F):
        self.F = F
        q = F.q
        if F.p != 2:
            self.eps = next(a for a in range(1, q) if a not in F.squares)
            self.artin = False
        else:
            self.eps = next(e for e in range(1, q)
                            if all(F.add(F.mul(x, x), F.add(x, e)) != 0 for x in range(q)))
            self.artin = True
        self.zero, self.one = (0, 0), (1, 0)

    def add(self, a, b):
        return (self.F.add(a[0], b[0]), self.F.add(a[1], b[1]))

    def neg(self, a):
        return (self.F.neg(a[0]), self.F.neg(a[1]))

    def sub(self, a, b):
        return self.add(a, self.neg(b))

    def mul(self, a, b):
        F = self.F
        (a0, a1), (b0, b1) = a, b
        t = F.mul(a1, b1)
        c0 = F.add(F.mul(a0, b0), F.mul(self.eps, t))
        c1 = F.add(F.mul(a0, b1), F.mul(a1, b0))
        if self.artin:
            c1 = F.add(c1, t)
        return (c0, c1)

    def inv(self, a):
        # brute inverse (fields are tiny)
        for b0 in range(self.F.q):
            for b1 in range(self.F.q):
                if self.mul(a, (b0, b1)) == self.one:
                    return (b0, b1)
        raise ZeroDivisionError

    def pow(self, a, n):
        r, b = self.one, a
        while n:
            if n & 1:
                r = self.mul(r, b)
            b = self.mul(b, b)
            n >>= 1
        return r

    def intmul(self, n, x):
        r = self.zero
        for _ in range(n % self.F.p):
            r = self.add(r, x)
        return r


def canon(F, vec):
    for c in vec:
        if c:
            iv = F.inv(c)
            return tuple(F.mul(iv, x) for x in vec)
    return None


def all_points(F, dim):
    q = F.q
    pts = []
    for lead in range(dim):
        for rest in range(q ** (dim - 1 - lead)):
            vec = [0] * lead + [1]
            r = rest
            tail = []
            for _ in range(dim - 1 - lead):
                tail.append(r % q)
                r //= q
            vec += tail
            pts.append(tuple(vec))
    return pts


def split_cubics(F):
    q = F.q
    S = set()
    elems = list(range(q)) + ['inf']
    for tri in combinations(elems, 3):
        fin = [t for t in tri if t != 'inf']
        if len(fin) == 3:
            r1, r2, r3 = fin
            e1 = F.add(F.add(r1, r2), r3)
            e2 = F.add(F.add(F.mul(r1, r2), F.mul(r1, r3)), F.mul(r2, r3))
            e3 = F.mul(F.mul(r1, r2), r3)
            c = (F.neg(e3), e2, F.neg(e1), 1)  # (c0,c1,c2,c3), c_j = coeff of T^j U^{3-j}
        else:
            r1, r2 = fin
            c = (F.mul(r1, r2), F.neg(F.add(r1, r2)), 1, 0)
        S.add(canon(F, c))
    return S


def hankel_kernel(F, f):
    """Kernel basis (as (c0,c1,c2,c3) tuples) of sum_j c_j a_{i+j} = 0, i = 0,1."""
    rows = [[f[0], f[1], f[2], f[3]], [f[1], f[2], f[3], f[4]]]
    piv_cols = []
    r = 0
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
        piv_cols.append(col)
        r += 1
        if r == 2:
            break
    free_cols = [c for c in range(4) if c not in piv_cols]
    basis = []
    for fc in free_cols:
        v = [0] * 4
        v[fc] = 1
        for ri, pc in enumerate(piv_cols):
            v[pc] = F.neg(rows[ri][fc])
        basis.append(tuple(v))
    return basis, len(piv_cols)


def is_deep(F, f, SPLIT):
    basis, rank = hankel_kernel(F, f)
    if rank <= 1:
        return False  # on the curve
    q = F.q
    b1, b2 = basis
    for lam in range(q):
        c = tuple(F.add(F.mul(lam, b1[j]), b2[j]) for j in range(4))
        if canon(F, c) in SPLIT:
            return False
    if canon(F, b1) in SPLIT:
        return False
    return True


def nu(K, t):
    t2 = K.mul(t, t)
    return [K.one, t, t2, K.mul(t2, t), K.mul(t2, t2)]


def hasse1(K, t):
    t2 = K.mul(t, t)
    return [K.zero, K.one, K.intmul(2, t), K.intmul(3, t2), K.intmul(4, K.mul(t2, t))]


def hasse2(K, t):
    return [K.zero, K.zero, K.one, K.intmul(3, t), K.intmul(6, K.mul(t, t))]


def reduce_basis(K, gens):
    basis = []
    for g in gens:
        v = list(g)
        for b in basis:
            lead = next(i for i, c in enumerate(b) if c != K.zero)
            if v[lead] != K.zero:
                fac = v[lead]
                v = [K.sub(v[j], K.mul(fac, b[j])) for j in range(5)]
        if any(c != K.zero for c in v):
            iv = K.inv(next(c for c in v if c != K.zero))
            v = [K.mul(iv, c) for c in v]
            basis.append(v)
    return basis


def span_points(F, gens):
    basis = reduce_basis(F, [list(g) for g in gens])
    pts = set()
    for co in all_points(F, len(basis)):
        vec = [0] * 5
        for ci, b in zip(co, basis):
            if ci:
                vec = [F.add(vec[j], F.mul(ci, b[j])) for j in range(5)]
        pts.add(canon(F, tuple(vec)))
    return pts


def curve_points(F):
    pts = [canon(F, tuple(nu(F, t))) for t in range(F.q)]
    pts.append((0, 0, 0, 0, 1))
    return pts


def tangent_family(F):
    fam = set()
    cps = set(curve_points(F))
    for t in range(F.q):
        fam |= span_points(F, [nu(F, t), hasse1(F, t)])
    fam |= span_points(F, [(0, 0, 0, 0, 1), (0, 0, 0, 1, 0)])
    return fam - cps


def conjugate_pairs(K, q):
    """Representatives w (one per pair {w, w^q}) of GF(q^2) - GF(q)."""
    reps = []
    seen = set()
    for a1 in range(1, q):
        for a0 in range(q):
            w = (a0, a1)
            if w in seen:
                continue
            wq = K.pow(w, q)
            seen.add(w)
            seen.add(wq)
            reps.append((w, wq))
    return reps


def sigma_secant_family(F):
    K = GF2(F)
    q = F.q
    fam = set()
    for w, wq in conjugate_pairs(K, q):
        nw, nwq = nu(K, w), nu(K, wq)
        for c0 in range(q):
            for c1 in range(q):
                if c0 == 0 and c1 == 0:
                    continue
                c = (c0, c1)
                cq = K.pow(c, q)
                vec = []
                ok = True
                for i in range(5):
                    z = K.add(K.mul(c, nw[i]), K.mul(cq, nwq[i]))
                    if z[1] != 0:
                        ok = False
                        break
                    vec.append(z[0])
                if ok and any(vec):
                    fam.add(canon(F, tuple(vec)))
    return fam


def intersect_lines(K, gens1, gens2):
    """Intersection of two 3-dim subspaces of K^5 (as span bases); returns basis list."""
    b1 = reduce_basis(K, gens1)
    b2 = reduce_basis(K, gens2)
    # solve sum x_i b1_i - sum y_j b2_j = 0: nullspace of 5 x 6 system
    ncols = len(b1) + len(b2)
    rows = [[(b1[i][r] if i < len(b1) else K.neg(b2[i - len(b1)][r]))
             for i in range(ncols)] for r in range(5)]
    # gaussian elimination over K
    piv = []
    r = 0
    for col in range(ncols):
        pr = next((rr for rr in range(r, 5) if rows[rr][col] != K.zero), None)
        if pr is None:
            continue
        rows[r], rows[pr] = rows[pr], rows[r]
        iv = K.inv(rows[r][col])
        rows[r] = [K.mul(iv, x) for x in rows[r]]
        for rr in range(5):
            if rr != r and rows[rr][col] != K.zero:
                fac = rows[rr][col]
                rows[rr] = [K.sub(rows[rr][j], K.mul(fac, rows[r][j]))
                            for j in range(ncols)]
        piv.append(col)
        r += 1
    sols = []
    for fc in [c for c in range(ncols) if c not in piv]:
        x = [K.zero] * ncols
        x[fc] = K.one
        for ri, pc in enumerate(piv):
            x[pc] = K.neg(rows[ri][fc])
        vec = [K.zero] * 5
        for i in range(len(b1)):
            if x[i] != K.zero:
                vec = [K.add(vec[j], K.mul(x[i], b1[i][j])) for j in range(5)]
        sols.append(vec)
    return sols


def osc_gens(K, t):
    if t == 'inf':
        return [[K.zero] * 4 + [K.one],
                [K.zero] * 3 + [K.one, K.zero],
                [K.zero, K.zero, K.one, K.zero, K.zero]]
    return [nu(K, t), hasse1(K, t), hasse2(K, t)]


def oplus_family(F):
    """char != 3: Osc(t1) cap Osc(t2), rational pairs -> one point each.
       char 3: all osculating planes concur at e2; returns {e2}."""
    q = F.q
    elems = list(range(q)) + ['inf']
    fam = set()
    for t1, t2 in combinations(elems, 2):
        sols = intersect_lines(F, osc_gens(F, t1), osc_gens(F, t2))
        for v in sols:
            fam.add(canon(F, tuple(v)))
    if F.p == 3:
        assert fam == {(0, 0, 1, 0, 0)}
    return fam


def ominus_family(F):
    """char != 3: rational intersection points Osc(w) cap Osc(w^q), conjugate pairs."""
    if F.p == 3:
        return set()
    K = GF2(F)
    fam = set()
    for w, wq in conjugate_pairs(K, F.q):
        sols = intersect_lines(K, osc_gens(K, w), osc_gens(K, wq))
        assert len(sols) == 1
        v = sols[0]
        # the intersection point is Frobenius-fixed, hence rational: normalize
        lead = next(c for c in v if c != K.zero)
        iv = K.inv(lead)
        v = [K.mul(iv, c) for c in v]
        assert all(c[1] == 0 for c in v), "O- intersection not rational"
        fam.add(canon(F, tuple(c[0] for c in v)))
    return fam


def group_matrices(F):
    """Substitution matrices M[k][l] = coeff of s^l in (alpha s+beta)^k (gamma s+delta)^{4-k}
    for the three standard generators; satisfies M nu(t) ~ nu(g t)."""
    def M(alpha, beta, gamma, delta):
        rows = []
        for k in range(5):
            # poly (alpha s + beta)^k * (gamma s + delta)^(4-k), coeffs low->high
            p1 = [1]
            for _ in range(k):
                p1 = polymul(F, p1, [beta, alpha])
            for _ in range(4 - k):
                p1 = polymul(F, p1, [delta, gamma])
            p1 += [0] * (5 - len(p1))
            rows.append(p1[:5])
        return rows
    e = next(a for a in range(2, F.q) if is_primitive(F, a)) if F.q > 3 else F.q - 1
    gens = [M(0, 1, 1, 0), M(1, 1, 0, 1), M(e, 0, 0, 1)]
    # runtime verification: M nu(t) ~ nu(g t)
    for g, (al, be, ga, de) in zip(gens, [(0, 1, 1, 0), (1, 1, 0, 1), (e, 0, 0, 1)]):
        for t in list(range(F.q)) + ['inf']:
            if t == 'inf':
                vin, tout = (0, 0, 0, 0, 1), ('inf' if ga == 0 else
                                              canon_t(F, al, ga))
            else:
                vin = tuple(nu(F, t))
                den = F.add(F.mul(ga, t), de)
                tout = ('inf' if den == 0 else F.mul(F.add(F.mul(al, t), be), F.inv(den)))
            out = tuple(matvec(F, g, vin))
            exp = (0, 0, 0, 0, 1) if tout == 'inf' else tuple(nu(F, tout))
            assert canon(F, out) == canon(F, exp)
    return gens


def canon_t(F, al, ga):
    return F.mul(al, F.inv(ga))


def is_primitive(F, a):
    x, n = a, 1
    while x != 1:
        x = F.mul(x, a)
        n += 1
    return n == F.q - 1


def polymul(F, A, B):
    out = [0] * (len(A) + len(B) - 1)
    for i, u in enumerate(A):
        if u:
            for j, v in enumerate(B):
                out[i + j] = F.add(out[i + j], F.mul(u, v))
    return out


def matvec(F, M, v):
    return [
        # note: (M a)_k = sum_l M[k][l] a_l
        _dot(F, M[k], v) for k in range(5)
    ]


def _dot(F, row, v):
    s = 0
    for x, y in zip(row, v):
        if x and y:
            s = F.add(s, F.mul(x, y))
    return s


def orbit_of(F, gens, start):
    seen = {canon(F, start)}
    frontier = [canon(F, start)]
    while frontier:
        nxt = []
        for p in frontier:
            for M in gens:
                im = canon(F, tuple(matvec(F, M, p)))
                if im not in seen:
                    seen.add(im)
                    nxt.append(im)
        frontier = nxt
    return seen


def w_family(F):
    """char 3: orbit of e2 - a*e4 with -a a nonsquare."""
    if F.p != 3:
        return set()
    a = next(x for x in range(1, F.q) if F.neg(x) not in F.squares)
    gens = group_matrices(F)
    return orbit_of(F, gens, (0, 0, 1, 0, F.neg(a)))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--json', default='notes/2026-07-22-c491-prs-deep-hole-census.json')
    ap.add_argument('--fields', default=None)
    args = ap.parse_args()
    with open(args.json) as fh:
        census = json.load(fh)
    fields = ([int(x) for x in args.fields.split(',')] if args.fields
              else sorted(int(k) for k in census['fields']))
    failures = []
    SPORADIC_Q = {7, 8, 9, 11, 13, 17, 19}
    print('q    deep    census  T      S       O+d    O-d    N  W     sporad verdict')
    for q in fields:
        F = GF(q)
        cj = census['fields'][str(q)]
        SPLIT = split_cubics(F)
        deep = set()
        for f in all_points(F, 5):
            if is_deep(F, f, SPLIT):
                deep.add(f)
        n_deep = len(deep)
        ok = True

        def fail(*info):
            nonlocal ok
            failures.append((q,) + info)
            ok = False

        if n_deep != cj['deep_hole_count']:
            fail('R1 deep count', n_deep, cj['deep_hole_count'])
        tot = 0
        for orb in cj['pgl2_orbits']:
            rep = canon(F, tuple(orb['rep']))
            if rep not in deep:
                fail('R2 census rep not deep', orb['rep'])
            tot += orb['size']
        if tot != n_deep:
            fail('R2 orbit size sum', tot, n_deep)

        T = tangent_family(F)
        S = sigma_secant_family(F)
        OP = oplus_family(F)
        OM = ominus_family(F)
        N = {(0, 0, 1, 0, 0)} if F.p == 3 else set()
        W = w_family(F)
        if len(T) != q * q + q or not T <= deep:
            fail('R3 tangent family', len(T), T <= deep)
        if len(S) != q * (q * q - 1) // 2 or not S <= deep:
            fail('R3 sigma family', len(S), S <= deep)
        if len(T) != cj['tangent_count'] or len(S) != cj['sigma_secant_count']:
            fail('R2 family counts vs census', len(T), cj['tangent_count'],
                 len(S), cj['sigma_secant_count'])
        p = F.p
        if p != 3:
            exp_op = (q % 3 == 2)
            exp_om = (q % 3 == 1)
            if len(OP) != q * (q + 1) // 2:
                fail('R3 |O+|', len(OP))
            if len(OM) != q * (q - 1) // 2:
                fail('R3 |O-|', len(OM))
            if exp_op != (OP <= deep) or (not exp_op and OP & deep):
                fail('R3 O+ verdict', exp_op, len(OP & deep))
            if exp_om != (OM <= deep) or (not exp_om and OM & deep):
                fail('R3 O- verdict', exp_om, len(OM & deep))
        else:
            if not N <= deep:
                fail('R3 nucleus not deep')
            if len(W) != (q * q - 1) // 2 or not W <= deep:
                fail('R3 W family', len(W), W <= deep)
        classified = T | S | (OP & deep) | (OM & deep) | N | W
        resid = deep - classified
        if q in SPORADIC_Q:
            expected_resid = cj['excess_count'] - len((OP & deep) | (OM & deep) | N | W)
            if len(resid) != expected_resid:
                fail('R4 sporadic size', len(resid), expected_resid)
        else:
            if resid:
                fail('R4 unexpected sporadics', len(resid))
        print(f'{q:<4} {n_deep:<7} {cj["deep_hole_count"]:<7} {len(T):<6} {len(S):<7} '
              f'{len(OP & deep):<6} {len(OM & deep):<6} {len(N):<2} {len(W):<5} '
              f'{len(resid):<6} {"PASS" if ok else "FAIL"}')
    if failures:
        print('FAILURES:')
        for f in failures:
            print('  ', f)
        sys.exit(1)
    print('ALL REPLAY CHECKS PASS')


if __name__ == '__main__':
    main()
