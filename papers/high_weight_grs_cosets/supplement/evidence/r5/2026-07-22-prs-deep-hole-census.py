#!/usr/bin/env python3
"""REDUNDANCY_FIVE PRS(q-4) deep-hole census generator.

Ambient PG(4,q); curve nu(t)=(1,t,t^2,t^3,t^4), nu(inf)=(0,0,0,0,1) -- the q+1
columns of the parity check of the projective Reed-Solomon code PRS(q-4)
(redundancy 5). Deep holes = points of PG(4,q) not in the span of any 3 distinct
curve points. See the task spec for the full mathematical contract.

Stdlib only, deterministic, canonical/sorted output. No timestamps, no randomness.
"""
import json
import sys
from itertools import combinations

# --------------------------------------------------------------------------
# Finite field GF(q) = GF(p^m) via polynomial basis with fixed moduli.
# Element = integer whose base-p digits are the coefficients (low degree = LSB).
# Rvec[i] gives t^m expressed in the basis (coeff of t^i), all mod p.
# --------------------------------------------------------------------------
FIELD_SPEC = {
    7:  (7, 1, None,          "GF(7) prime"),
    8:  (2, 3, [1, 1, 0],     "t^3 = t + 1  (t^3+t+1)"),
    9:  (3, 2, [2, 0],        "t^2 = -1  (t^2+1)"),
    11: (11, 1, None,         "GF(11) prime"),
    13: (13, 1, None,         "GF(13) prime"),
    16: (2, 4, [1, 1, 0, 0],  "t^4 = t + 1  (t^4+t+1)"),
    17: (17, 1, None,         "GF(17) prime"),
    19: (19, 1, None,         "GF(19) prime"),
    23: (23, 1, None,         "GF(23) prime"),
    25: (5, 2, [2, 0],        "t^2 = 2  (t^2-2, 2 nonsquare mod 5)"),
    27: (3, 3, [2, 1, 0],     "t^3 = t - 1  (t^3-t+1)"),
    29: (29, 1, None,         "GF(29) prime"),
    31: (31, 1, None,         "GF(31) prime"),
    32: (2, 5, [1, 0, 1, 0, 0], "t^5 = t^2 + 1  (t^5+t^2+1)"),
    37: (37, 1, None,         "GF(37) prime"),
    41: (41, 1, None,         "GF(41) prime"),
    43: (43, 1, None,         "GF(43) prime"),
    47: (47, 1, None,         "GF(47) prime"),
    49: (7, 2, [3, 0],        "t^2 = 3  (t^2-3, 3 nonsquare mod 7)"),
}

FIELDS = [7, 8, 9, 11, 13, 16, 17, 19, 23, 25, 27, 29, 31, 32,
          37, 41, 43, 47, 49]


class GF:
    def __init__(self, q):
        p, m, rvec, desc = FIELD_SPEC[q]
        self.q = q
        self.p = p
        self.m = m
        self.rvec = rvec
        self.desc = desc
        self._build_arith()
        self._find_primitive()
        self._build_tables()

    # ---- low-level polynomial arithmetic on integer-encoded elements -------
    def _digits(self, a):
        p, m = self.p, self.m
        d = [0] * m
        for i in range(m):
            d[i] = a % p
            a //= p
        return d

    def _from_digits(self, d):
        p = self.p
        v = 0
        for c in reversed(d):
            v = v * p + (c % p)
        return v

    def _mult_t(self, vec):
        # multiply polynomial vec (length m) by t, reduce via rvec
        p, m, rv = self.p, self.m, self.rvec
        hi = vec[m - 1]
        w = [0] * m
        w[0] = (hi * rv[0]) % p
        for i in range(1, m):
            w[i] = (vec[i - 1] + hi * rv[i]) % p
        return w

    def _build_arith(self):
        p, m = self.p, self.m
        # precompute redpow[j] = t^j as a length-m vector, j = 0 .. 2m-2
        redpow = []
        cur = [0] * m
        cur[0] = 1
        for j in range(2 * m - 1):
            redpow.append(cur[:])
            if m > 1:
                cur = self._mult_t(cur)
        self.redpow = redpow

    def _raw_mul(self, a, b):
        p, m = self.p, self.m
        if m == 1:
            return (a * b) % p
        va = self._digits(a)
        vb = self._digits(b)
        conv = [0] * (2 * m - 1)
        for i in range(m):
            ai = va[i]
            if ai == 0:
                continue
            for j in range(m):
                conv[i + j] = (conv[i + j] + ai * vb[j]) % p
        res = [0] * m
        for j in range(2 * m - 1):
            cj = conv[j]
            if cj == 0:
                continue
            rp = self.redpow[j]
            for i in range(m):
                if rp[i]:
                    res[i] = (res[i] + cj * rp[i]) % p
        return self._from_digits(res)

    def _raw_add(self, a, b):
        p, m = self.p, self.m
        if m == 1:
            return (a + b) % p
        va = self._digits(a)
        vb = self._digits(b)
        return self._from_digits([(va[i] + vb[i]) % p for i in range(m)])

    def _raw_neg(self, a):
        p, m = self.p, self.m
        if m == 1:
            return (-a) % p
        va = self._digits(a)
        return self._from_digits([(-va[i]) % p for i in range(m)])

    # ---- primitive element + irreducibility verification -------------------
    def _find_primitive(self):
        q = self.q
        for g in range(2, q):
            seen = set()
            x = 1
            order = 0
            for _ in range(q - 1):
                x = self._raw_mul(x, g)
                order += 1
                if x == 1:
                    break
            if order == q - 1:
                self.gen = g
                return
        raise RuntimeError(f"no primitive element for q={q}: modulus reducible?")

    def _build_tables(self):
        q = self.q
        g = self.gen
        exp = [0] * (q - 1)
        log = [None] * q
        x = 1
        for i in range(q - 1):
            exp[i] = x
            log[x] = i
            x = self._raw_mul(x, g)
        assert x == 1, "primitive cycle mismatch (field not a field)"
        self.exp = exp
        self.log = log
        # dense op tables
        ADD = [[0] * q for _ in range(q)]
        MUL = [[0] * q for _ in range(q)]
        NEG = [0] * q
        INV = [0] * q
        for a in range(q):
            NEG[a] = self._raw_neg(a)
            for b in range(q):
                ADD[a][b] = self._raw_add(a, b)
                MUL[a][b] = self._raw_mul(a, b)
        for a in range(1, q):
            INV[a] = exp[(q - 1 - log[a]) % (q - 1)]
        self.ADD = ADD
        self.MUL = MUL
        self.NEG = NEG
        self.INV = INV

    # ---- convenience -------------------------------------------------------
    def add(self, a, b):
        return self.ADD[a][b]

    def sub(self, a, b):
        return self.ADD[a][self.NEG[b]]

    def mul(self, a, b):
        return self.MUL[a][b]

    def inv(self, a):
        return self.INV[a]

    def powe(self, a, e):
        if a == 0:
            return 0 if e > 0 else 1
        return self.exp[(self.log[a] * e) % (self.q - 1)]

    def frob(self, a):
        # x -> x^p
        return self.powe(a, self.p)


# --------------------------------------------------------------------------
# Point encoding for PG(4,q): canonical vector (first nonzero coord = 1),
# index = radix-q integer with a0 most significant.
# --------------------------------------------------------------------------
def make_codec(F):
    q = F.q
    MUL = F.MUL
    INV = F.INV

    def encode(vec):
        for i in range(5):
            if vec[i] != 0:
                inv = INV[vec[i]]
                idx = 0
                for j in range(5):
                    idx = idx * q + MUL[inv][vec[j]]
                return idx
        return -1

    def decode(idx):
        v = [0] * 5
        for j in range(4, -1, -1):
            v[j] = idx % q
            idx //= q
        return v

    return encode, decode


# --------------------------------------------------------------------------
# Univariate / binary-form factorization over GF(q).
# poly represented low->high (index = power).
# --------------------------------------------------------------------------
def poly_deg(p):
    d = len(p) - 1
    while d >= 0 and p[d] == 0:
        d -= 1
    return d


def poly_eval(F, p, x):
    r = 0
    for c in reversed(p):
        r = F.ADD[F.MUL[r][x]][c]
    return r


def poly_div_linear(F, p, r):
    # divide p by (x - r), assume exact; return quotient low->high
    d = poly_deg(p)
    q = [0] * d
    carry = 0
    # synthetic division high->low
    coeffs = p[:d + 1]
    prev = coeffs[d]
    out = [prev]
    for k in range(d - 1, 0, -1):
        prev = F.ADD[coeffs[k]][F.MUL[prev][r]]
        out.append(prev)
    # out is high->low of quotient (len d)
    quo = list(reversed(out))
    return quo


def poly_monic(F, p):
    d = poly_deg(p)
    lead = p[d]
    inv = F.INV[lead]
    return [F.MUL[inv][c] for c in p[:d + 1]]


def poly_gcd(F, a, b):
    a = a[:poly_deg(a) + 1] if poly_deg(a) >= 0 else [0]
    b = b[:poly_deg(b) + 1] if poly_deg(b) >= 0 else [0]
    while poly_deg(b) >= 0:
        a, b = b, poly_mod(F, a, b)
    if poly_deg(a) < 0:
        return [0]
    return poly_monic(F, a)


def poly_mod(F, a, b):
    a = a[:]
    db = poly_deg(b)
    if db < 0:
        return a
    lb_inv = F.INV[b[db]]
    da = poly_deg(a)
    while da >= db and da >= 0:
        coef = F.MUL[a[da]][lb_inv]
        shift = da - db
        for i in range(db + 1):
            a[shift + i] = F.ADD[a[shift + i]][F.NEG[F.MUL[coef][b[i]]]]
        da = poly_deg(a)
    if da < 0:
        return [0]
    return a[:da + 1]


def rational_roots_mult(F, p):
    """Return (list of (root, mult), remaining monic poly low->high)."""
    q = F.q
    roots = []
    cur = poly_monic(F, p)
    changed = True
    while poly_deg(cur) >= 1 and changed:
        changed = False
        for r in range(q):
            if poly_eval(F, cur, r) == 0:
                mult = 0
                while poly_deg(cur) >= 1 and poly_eval(F, cur, r) == 0:
                    cur = poly_div_linear(F, cur, r)
                    mult += 1
                roots.append((r, mult))
                changed = True
                break
    return roots, cur


def irreducible_quadratic_divisor(F, p):
    """p monic low->high, no rational roots. Return a monic irreducible
    quadratic divisor (low->high len 3) or None."""
    q = F.q
    for c in range(q):
        for b in range(q):
            # x^2 + b x + c
            # irreducible iff no rational root
            disc_has_root = False
            for r in range(q):
                if F.ADD[F.ADD[F.MUL[r][r]][F.MUL[b][r]]][c] == 0:
                    disc_has_root = True
                    break
            if disc_has_root:
                continue
            g = [c, b, 1]
            if poly_deg(poly_mod(F, p, g)) < 0:
                return g
    return None


def factor_monic(F, p):
    """Factor monic poly p (low->high) into list of (deg, mult)."""
    factors = []
    roots, rem = rational_roots_mult(F, p)
    for (r, mult) in roots:
        factors.append((1, mult))
    d = poly_deg(rem)
    if d <= 0:
        return factors
    if d == 2:
        factors.append((2, 1))
    elif d == 3:
        factors.append((3, 1))
    elif d == 4:
        g = irreducible_quadratic_divisor(F, rem)
        if g is None:
            factors.append((4, 1))
        else:
            quo = poly_monic(F, poly_mod_exact(F, rem, g))
            gm = poly_monic(F, g)
            if quo == gm:
                factors.append((2, 2))
            else:
                factors.append((2, 1))
                factors.append((2, 1))
    else:
        raise RuntimeError(f"unexpected remainder degree {d}")
    return factors


def poly_mod_exact(F, a, b):
    """exact quotient of a / b (b divides a), low->high."""
    a = a[:]
    db = poly_deg(b)
    lb_inv = F.INV[b[db]]
    da = poly_deg(a)
    quo = [0] * (da - db + 1)
    while da >= db and da >= 0:
        coef = F.MUL[a[da]][lb_inv]
        shift = da - db
        quo[shift] = coef
        for i in range(db + 1):
            a[shift + i] = F.ADD[a[shift + i]][F.NEG[F.MUL[coef][b[i]]]]
        da = poly_deg(a)
    return quo


def binary_factor(F, coeffs_high):
    """coeffs_high = form coefficients top T-power down to U-power.
    Returns list of (deg, mult) including the infinity (U) factor."""
    i = 0
    n = len(coeffs_high)
    while i < n and coeffs_high[i] == 0:
        i += 1
    uz = i
    factors = []
    if uz > 0:
        factors.append((1, uz))
    rest = coeffs_high[i:]
    d = len(rest) - 1
    if d >= 1:
        low = list(reversed(rest))  # low->high
        low = poly_monic(F, low)
        factors += factor_monic(F, low)
    return factors


def factor_signature(factors):
    """Canonical string 'deg^mult+...' sorted by (deg, -mult)."""
    fs = sorted(factors, key=lambda dm: (dm[0], -dm[1]))
    toks = []
    for (deg, mult) in fs:
        toks.append(str(deg) if mult == 1 else f"{deg}^{mult}")
    return "+".join(toks)


def cubic_pattern(factors):
    """Map cubic factor list to {'111','1.2','3','1^2.1','1^3'}."""
    fs = sorted(factors, key=lambda dm: (dm[0], -dm[1]))
    if fs == [(1, 1), (1, 1), (1, 1)]:
        return "111"
    if fs == [(1, 2), (1, 1)]:
        return "1^2.1"
    if fs == [(1, 3)]:
        return "1^3"
    if fs == [(1, 1), (2, 1)]:
        return "1.2"
    if fs == [(3, 1)]:
        return "3"
    raise RuntimeError(f"unexpected cubic factor list {factors}")


# --------------------------------------------------------------------------
# Projective coefficient enumeration for PG(k-1,q) (first nonzero = 1).
# --------------------------------------------------------------------------
def pg_coeffs(F, k):
    q = F.q
    res = []

    def rec(prefix):
        pos = len(prefix)
        if pos == k:
            return
        # leading coord = 1 here
        # fill remaining freely
        tail_positions = k - pos - 1
        # enumerate all tails
        def fill(cur):
            if len(cur) == tail_positions:
                res.append(tuple(prefix) + (1,) + tuple(cur))
                return
            for v in range(q):
                fill(cur + [v])
        fill([])
        rec(prefix + [0])

    rec([])
    return res


# --------------------------------------------------------------------------
# Quadratic extension GF(q^2) for tangent / sigma-secant constructions.
# --------------------------------------------------------------------------
class GF2:
    def __init__(self, F):
        self.F = F
        q = F.q
        self.q = q
        if F.p == 2:
            # theta^2 = theta + delta, need absolute-trace(delta)=1
            self.char2 = True
            self.delta = self._find_delta()
        else:
            self.char2 = False
            self.n = self._find_nonsquare()

    def _find_nonsquare(self):
        F = self.F
        q = self.q
        sq = set()
        for a in range(q):
            sq.add(F.MUL[a][a])
        for n in range(1, q):
            if n not in sq:
                return n
        raise RuntimeError("no nonsquare")

    def _abs_trace(self, a):
        F = self.F
        m = F.m
        s = 0
        x = a
        for _ in range(m):
            s ^= (x & 1) if False else 0
            # compute over GF(2): trace = sum a^(2^i), then it's an element of
            # GF(2) if a in GF(q); accumulate as field element and check ==1
            pass
        # proper: t = sum_{i=0}^{m-1} a^(2^i)
        t = 0
        x = a
        for _ in range(F.m):
            t = F.ADD[t][x]
            x = F.MUL[x][x]
        return t  # should be 0 or 1

    def _find_delta(self):
        F = self.F
        for delta in range(1, self.q):
            if self._abs_trace(delta) == 1:
                return delta
        raise RuntimeError("no delta with trace 1")

    def add(self, a, b):
        F = self.F
        return (F.ADD[a[0]][b[0]], F.ADD[a[1]][b[1]])

    def mul(self, a, b):
        F = self.F
        x, y = a
        u, v = b
        if self.char2:
            # (x+y th)(u+v th) = (xu + yv delta) + (xv+yu+yv) th
            xu = F.MUL[x][u]
            yv = F.MUL[y][v]
            xv = F.MUL[x][v]
            yu = F.MUL[y][u]
            re = F.ADD[xu][F.MUL[yv][self.delta]]
            im = F.ADD[F.ADD[xv][yu]][yv]
            return (re, im)
        else:
            xu = F.MUL[x][u]
            yv = F.MUL[y][v]
            xv = F.MUL[x][v]
            yu = F.MUL[y][u]
            re = F.ADD[xu][F.MUL[yv][self.n]]
            im = F.ADD[xv][yu]
            return (re, im)

    def conj(self, a):
        F = self.F
        x, y = a
        if self.char2:
            return (F.ADD[x][y], y)
        else:
            return (x, F.NEG[y])

    def trace(self, a):
        # a + conj(a), lands in base field (im part 0); return base int
        s = self.add(a, self.conj(a))
        assert s[1] == 0
        return s[0]

    def powi(self, a, e):
        r = (1, 0)
        for _ in range(e):
            r = self.mul(r, a)
        return r


# --------------------------------------------------------------------------
# PGL_2(q) action on PG(4,q) via the degree-4 substitution.
# M_g[i][j] = coeff of t^i in (alpha t + beta)^j (gamma t + delta)^(4-j).
# --------------------------------------------------------------------------
def build_Mg(F, g):
    alpha, beta, gamma, delta = g
    MUL = F.MUL
    ADD = F.ADD
    # Row i is the binary form (alpha t + beta)^i (gamma t + delta)^(4-i);
    # M[i][j] = coeff of t^j. Then (M nu(t))_i = (alpha t+beta)^i (gamma t+delta)^(4-i)
    # = (gamma t+delta)^4 * nu(g(t))_i, so M nu(t) ~ nu(g(t)).
    M = [[0] * 5 for _ in range(5)]
    for i in range(5):
        pa = [1]
        for _ in range(i):
            pa = poly_mul_small(F, pa, [beta, alpha])   # low->high: beta + alpha t
        pb = [1]
        for _ in range(4 - i):
            pb = poly_mul_small(F, pb, [delta, gamma])
        prod = poly_mul_small(F, pa, pb)  # length 5
        for j in range(5):
            M[i][j] = prod[j] if j < len(prod) else 0
    return M


def poly_mul_small(F, a, b):
    MUL = F.MUL
    ADD = F.ADD
    res = [0] * (len(a) + len(b) - 1)
    for i, ai in enumerate(a):
        if ai == 0:
            continue
        for k, bk in enumerate(b):
            if bk:
                res[i + k] = ADD[res[i + k]][MUL[ai][bk]]
    return res


def apply_M(F, M, vec):
    MUL = F.MUL
    ADD = F.ADD
    out = [0] * 5
    for i in range(5):
        s = 0
        Mi = M[i]
        for j in range(5):
            if vec[j] and Mi[j]:
                s = ADD[s][MUL[Mi[j]][vec[j]]]
        out[i] = s
    return out


# --------------------------------------------------------------------------
# Per-field census.
# --------------------------------------------------------------------------
def curve_points(F):
    q = F.q
    pts = []
    for t in range(q):
        pts.append([1, t, F.MUL[t][t], F.MUL[F.MUL[t][t]][t],
                    F.MUL[F.MUL[t][t]][F.MUL[t][t]]])
    pts.append([0, 0, 0, 0, 1])  # infinity
    return pts  # index i in 0..q-1 = t=i; index q = infinity


def census_field(q, verbose=False):
    F = GF(q)
    encode, decode = make_codec(F)
    N = q ** 4 + q ** 3 + q ** 2 + q + 1
    SIZE = q ** 5  # index range (canonical indices are sparse within this)
    cpts = curve_points(F)
    ncurve = q + 1
    point_indices = [encode(v) for v in pg_coeffs(F, 5)]
    assert len(point_indices) == N

    # sanity: any 3 distinct curve points are linearly independent (rank 3)
    for tri in [(0, 1, 2), (0, 1, q), (2, 5 % q, q)] if q >= 6 else [(0, 1, 2)]:
        vs = [cpts[i] for i in tri]
        assert matrix_rank(F, vs) == 3, f"curve triple {tri} not rank 3"

    curve_idx = set(encode(p) for p in cpts)

    # -------- plane marking: deep = points not in any 3-point span ----------
    marked = bytearray(SIZE)
    ADD = F.ADD
    MUL = F.MUL
    pg2 = pg_coeffs(F, 3)  # canonical (a,b,c) for PG(2,q)
    for i1, i2, i3 in combinations(range(ncurve), 3):
        P1 = cpts[i1]; P2 = cpts[i2]; P3 = cpts[i3]
        for (a, b, c) in pg2:
            v0 = ADD[ADD[MUL[a][P1[0]]][MUL[b][P2[0]]]][MUL[c][P3[0]]]
            v1 = ADD[ADD[MUL[a][P1[1]]][MUL[b][P2[1]]]][MUL[c][P3[1]]]
            v2 = ADD[ADD[MUL[a][P1[2]]][MUL[b][P2[2]]]][MUL[c][P3[2]]]
            v3 = ADD[ADD[MUL[a][P1[3]]][MUL[b][P2[3]]]][MUL[c][P3[3]]]
            v4 = ADD[ADD[MUL[a][P1[4]]][MUL[b][P2[4]]]][MUL[c][P3[4]]]
            marked[encode([v0, v1, v2, v3, v4])] = 1

    deep = [idx for idx in point_indices if not marked[idx]]
    deep_set = set(deep)
    deep_count = len(deep)

    # -------- V1: covering radius (q<=16): 4-subsets cover all of PG(4,q) ----
    rho_le_4 = None
    if q <= 16:
        covered = bytearray(SIZE)
        pg3 = pg_coeffs(F, 4)
        for i1, i2, i3, i4 in combinations(range(ncurve), 4):
            P1 = cpts[i1]; P2 = cpts[i2]; P3 = cpts[i3]; P4 = cpts[i4]
            for (a, b, c, d) in pg3:
                v = [ADD[ADD[ADD[MUL[a][P1[k]]][MUL[b][P2[k]]]][MUL[c][P3[k]]]][MUL[d][P4[k]]]
                     for k in range(5)]
                covered[encode(v)] = 1
        rho_le_4 = all(covered[idx] for idx in point_indices)
        assert rho_le_4, f"q={q}: some point not covered by a 4-subset (rho>4)!"

    # -------- V2a: tangent-line deep points ---------------------------------
    tangent_set = set()
    for t in range(q):
        nu = cpts[t]
        # Hasse derivative nu^[1](t) = (0, 1, 2t, 3t^2, 4t^3); the integer
        # coefficients binom(i,1)=i are reduced mod p (the characteristic)
        # and embedded in the prime subfield (element code = i mod p).
        p = F.p
        der = [0, 1,
               F.MUL[2 % p][t],
               F.MUL[3 % p][F.MUL[t][t]],
               F.MUL[4 % p][F.MUL[F.MUL[t][t]][t]]]
        for (a, b) in pg_coeffs(F, 2):
            v = [ADD[MUL[a][nu[k]]][MUL[b][der[k]]] for k in range(5)]
            tangent_set.add(encode(v))
    # tangent at infinity: nu(inf)=(0,0,0,0,1), der = (0,0,0,1,0)
    nu_inf = cpts[q]
    der_inf = [0, 0, 0, 1, 0]
    for (a, b) in pg_coeffs(F, 2):
        v = [ADD[MUL[a][nu_inf[k]]][MUL[b][der_inf[k]]] for k in range(5)]
        tangent_set.add(encode(v))
    tangent_set -= curve_idx
    tangent_count = len(tangent_set)
    assert tangent_set <= deep_set, f"q={q}: tangent points not all deep!"

    # -------- V2b: sigma-secant deep points ---------------------------------
    E = GF2(F)
    sigma_set = set()
    seen_w = set()
    for wy in range(1, q):
        for wx in range(q):
            w = (wx, wy)
            if w in seen_w:
                continue
            wc = E.conj(w)
            seen_w.add(w)
            seen_w.add(wc)
            # powers w^0..w^4
            wp = [(1, 0)]
            for _ in range(4):
                wp.append(E.mul(wp[-1], w))
            # rational points: c in GF(q^2)^*, coord_i = trace(c * w^i)
            for cy in range(q):
                for cx in range(q):
                    if cx == 0 and cy == 0:
                        continue
                    cc = (cx, cy)
                    v = [E.trace(E.mul(cc, wp[k])) for k in range(5)]
                    if any(v):
                        sigma_set.add(encode(v))
    sigma_count = len(sigma_set)
    assert sigma_set <= deep_set, f"q={q}: sigma-secant points not all deep!"

    # disjointness + excess
    assert not (tangent_set & sigma_set), f"q={q}: tangent/sigma overlap!"
    excess_set = deep_set - tangent_set - sigma_set
    excess_count = len(excess_set)

    # -------- V3: Hankel cross-check (q<=11) --------------------------------
    hankel = None
    if q <= 11:
        hankel_deep = set()
        for idx in point_indices:
            v = decode(idx)
            basis = hankel_kernel(F, v)
            # f non-deep iff some kernel member is 3 distinct rational linears
            split = False
            for coeffs in kernel_projective_members(F, basis):
                fac = binary_factor(F, coeffs)  # coeffs high->low: (c3,c2,c1,c0)
                if cubic_pattern_safe(fac) == "111":
                    split = True
                    break
            if not split:
                hankel_deep.add(idx)
        hankel = "pass" if hankel_deep == deep_set else "FAIL"
        assert hankel == "pass", f"q={q}: Hankel cross-check FAILED"

    # -------- PGL_2(q) orbit decomposition ----------------------------------
    e = F.gen
    gens = [
        (0, 1, 1, 0),   # S
        (1, 1, 0, 1),   # T1
        (e, 0, 0, 1),   # D
    ]
    Ms = [build_Mg(F, g) for g in gens]
    # verify M_g nu(t) ~ nu(g(t)) for each generator
    for gi, (g, M) in enumerate(zip(gens, Ms)):
        verify_action(F, g, M, cpts, encode)

    pgl_order = q ** 3 - q
    orbit_id = {}
    orbits = []  # list of set-of-indices
    for start in deep:
        if start in orbit_id:
            continue
        oid = len(orbits)
        comp = []
        stack = [start]
        orbit_id[start] = oid
        while stack:
            cur = stack.pop()
            comp.append(cur)
            cv = decode(cur)
            for M in Ms:
                nb = encode(apply_M(F, M, cv))
                assert nb in deep_set, f"q={q}: PGL image left deep set!"
                if nb not in orbit_id:
                    orbit_id[nb] = oid
                    stack.append(nb)
        orbits.append(set(comp))

    # -------- Frobenius map on orbits ---------------------------------------
    def frob_point(idx):
        v = decode(idx)
        return encode([F.frob(x) for x in v])

    orbit_reps = []
    for comp in orbits:
        rep_idx = min(comp)
        orbit_reps.append(rep_idx)

    # rep_index -> orbit id
    rep_to_oid = {}
    for oid, comp in enumerate(orbits):
        rep_to_oid[orbit_reps[oid]] = oid

    frob_target = {}  # oid -> oid
    for oid, comp in enumerate(orbits):
        rep = orbit_reps[oid]
        fr = frob_point(rep)
        toid = orbit_id[fr]
        frob_target[oid] = toid

    # PGammaL orbit count: cycles of frob_target (a permutation of orbit ids)
    pgammal = count_frob_orbits(orbits, frob_target)

    # -------- per-orbit invariants ------------------------------------------
    orbit_records = []
    for oid, comp in enumerate(orbits):
        rep = orbit_reps[oid]
        v = decode(rep)
        size = len(comp)
        assert pgl_order % size == 0, f"q={q}: orbit size {size} not dividing {pgl_order}"
        stab = pgl_order // size
        if rep in tangent_set:
            family = "tangent"
        elif rep in sigma_set:
            family = "sigma_secant"
        else:
            family = "excess"
        # factor_type of standard quartic a0 T^4 + a1 T^3 U + ... + a4 U^4
        ftype = factor_signature(binary_factor(F, [v[0], v[1], v[2], v[3], v[4]]))
        # Hankel pencil
        basis = hankel_kernel(F, v)
        assert len(basis) == 2, f"q={q}: deep point rep pencil dim {len(basis)} != 2"
        gcd_deg = pencil_gcd_deg(F, basis[0], basis[1])
        stats = {"111": 0, "1.2": 0, "3": 0, "1^2.1": 0, "1^3": 0}
        osc = 0
        for coeffs in kernel_projective_members(F, basis):
            fac = binary_factor(F, coeffs)
            pat = cubic_pattern(fac)
            stats[pat] += 1
            if pat == "1^3":
                osc += 1
        assert stats["111"] == 0, f"q={q}: deep orbit has split member!"
        orbit_records.append({
            "rep": [int(x) for x in v],
            "rep_index": rep,
            "size": size,
            "stab_order": stab,
            "family": family,
            "factor_type": ftype,
            "pencil_gcd_deg": gcd_deg,
            "member_stats": stats,
            "osc_rational_points": osc,
            "_oid": oid,
        })

    # sort orbits by (size, rep_index); remap frobenius targets to rep_index
    orbit_records.sort(key=lambda r: (r["size"], r["rep_index"]))
    oid_to_repidx = {r["_oid"]: r["rep_index"] for r in orbit_records}
    for r in orbit_records:
        r["frobenius_maps_to_rep_index"] = oid_to_repidx[frob_target[r["_oid"]]]
        del r["_oid"]

    field_rec = {
        "pg4_points": N,
        "deep_hole_count": deep_count,
        "rho_le_4_verified": rho_le_4,
        "tangent_count": tangent_count,
        "sigma_secant_count": sigma_count,
        "excess_count": excess_count,
        "hankel_crosscheck": hankel,
        "pgl2_order": pgl_order,
        "pgl2_orbits": orbit_records,
        "pgammal_orbit_count": pgammal,
    }
    return F, field_rec, excess_set


def cubic_pattern_safe(fac):
    try:
        return cubic_pattern(fac)
    except RuntimeError:
        return None


def matrix_rank(F, rows):
    m = [r[:] for r in rows]
    nr = len(m)
    nc = len(m[0])
    rank = 0
    col = 0
    for col in range(nc):
        piv = None
        for r in range(rank, nr):
            if m[r][col] != 0:
                piv = r
                break
        if piv is None:
            continue
        m[rank], m[piv] = m[piv], m[rank]
        inv = F.INV[m[rank][col]]
        m[rank] = [F.MUL[inv][x] for x in m[rank]]
        for r in range(nr):
            if r != rank and m[r][col] != 0:
                f = m[r][col]
                m[r] = [F.ADD[m[r][k]][F.NEG[F.MUL[f][m[rank][k]]]] for k in range(nc)]
        rank += 1
    return rank


def hankel_kernel(F, v):
    """Kernel basis of [[a0,a1,a2,a3],[a1,a2,a3,a4]] as cubic coeff vectors
    (c0,c1,c2,c3). Returned as high->low (c3,c2,c1,c0) for binary_factor."""
    rows = [[v[0], v[1], v[2], v[3]], [v[1], v[2], v[3], v[4]]]
    basis_c = nullspace(F, rows, 4)  # each vector is (c0,c1,c2,c3)
    # binary_factor wants coeffs top T-power down: cubic = c3 T^3 + c2 T^2 U + c1 T U^2 + c0 U^3
    # coeffs_high = (c3, c2, c1, c0)
    return [(c[3], c[2], c[1], c[0]) for c in basis_c]


def nullspace(F, rows, ncol):
    m = [r[:] for r in rows]
    nr = len(m)
    pivots = []
    rank = 0
    for col in range(ncol):
        piv = None
        for r in range(rank, nr):
            if m[r][col] != 0:
                piv = r
                break
        if piv is None:
            continue
        m[rank], m[piv] = m[piv], m[rank]
        inv = F.INV[m[rank][col]]
        m[rank] = [F.MUL[inv][x] for x in m[rank]]
        for r in range(nr):
            if r != rank and m[r][col] != 0:
                f = m[r][col]
                m[r] = [F.ADD[m[r][k]][F.NEG[F.MUL[f][m[rank][k]]]] for k in range(ncol)]
        pivots.append(col)
        rank += 1
    free = [c for c in range(ncol) if c not in pivots]
    basis = []
    for fc in free:
        vec = [0] * ncol
        vec[fc] = 1
        for ri, pc in enumerate(pivots):
            vec[pc] = F.NEG[m[ri][fc]]
        basis.append(vec)
    return basis


def kernel_projective_members(F, basis):
    """Yield high->low cubic coeff tuples for each projective member of the
    span of basis (each basis vec already high->low)."""
    k = len(basis)
    for coeffs in pg_coeffs(F, k):
        member = [0, 0, 0, 0]
        for ci, bvec in zip(coeffs, basis):
            if ci == 0:
                continue
            for j in range(4):
                member[j] = F.ADD[member[j]][F.MUL[ci][bvec[j]]]
        yield tuple(member)


def pencil_gcd_deg(F, b1, b2):
    """b1,b2 are high->low cubic tuples (c3,c2,c1,c0). Return gcd degree as
    binary forms (0..2)."""
    # U-multiplicity = leading zeros (high side)
    def uz(b):
        i = 0
        while i < 4 and b[i] == 0:
            i += 1
        return i, list(reversed(b[i:]))  # (u-mult, low->high finite part)
    u1, f1 = uz(b1)
    u2, f2 = uz(b2)
    common_u = min(u1, u2)
    if not f1 or poly_deg(f1) < 0:
        gdeg = poly_deg(f2) if f2 else -1
    elif not f2 or poly_deg(f2) < 0:
        gdeg = poly_deg(f1)
    else:
        g = poly_gcd(F, f1, f2)
        gdeg = poly_deg(g)
    gdeg = max(gdeg, 0)
    return common_u + gdeg


def verify_action(F, g, M, cpts, encode):
    q = F.q
    alpha, beta, gamma, delta = g
    for t in range(q):
        img = apply_M(F, M, cpts[t])
        # g(t) = (alpha t + beta)/(gamma t + delta)
        num = F.ADD[F.MUL[alpha][t]][beta]
        den = F.ADD[F.MUL[gamma][t]][delta]
        if den == 0:
            gt = q  # infinity
            target = cpts[q]
        else:
            gt = F.MUL[num][F.INV[den]]
            target = cpts[gt]
        assert encode(img) == encode(target), \
            f"action mismatch g={g} t={t}"
    # t = infinity
    img = apply_M(F, M, cpts[q])
    if gamma == 0:
        target = cpts[q]
    else:
        gt = F.MUL[alpha][F.INV[gamma]]
        target = cpts[gt]
    assert encode(img) == encode(target), f"action mismatch g={g} t=inf"


def count_frob_orbits(orbits, frob_target):
    n = len(orbits)
    seen = [False] * n
    count = 0
    for i in range(n):
        if seen[i]:
            continue
        count += 1
        j = i
        while not seen[j]:
            seen[j] = True
            j = frob_target[j]
    return count


def main():
    argv = sys.argv[1:]
    if argv:
        fields = [int(x) for x in argv]
    else:
        fields = FIELDS

    out = {
        "schema": "redundancy_five-prs-deep-hole-census-v1",
        "moduli": {str(q): FIELD_SPEC[q][3] for q in FIELDS},
        "fields": {},
    }

    summary_rows = []
    header = ("q", "deep", "tangent", "sigma", "excess",
             "#PGL", "#PGammaL", "excess orbits (size:factor_type)")
    print(f"{header[0]:>3} {header[1]:>7} {header[2]:>7} {header[3]:>7} "
          f"{header[4]:>7} {header[5]:>5} {header[6]:>8}  {header[7]}")
    for q in fields:
        F, rec, excess_set = census_field(q)
        out["fields"][str(q)] = rec
        exc = [o for o in rec["pgl2_orbits"] if o["family"] == "excess"]
        exc_desc = ", ".join(f"{o['size']}:{o['factor_type']}" for o in exc)
        npgl = len(rec["pgl2_orbits"])
        line = (f"{q:>3} {rec['deep_hole_count']:>7} {rec['tangent_count']:>7} "
                f"{rec['sigma_secant_count']:>7} {rec['excess_count']:>7} "
                f"{npgl:>5} {rec['pgammal_orbit_count']:>8}  {exc_desc}")
        print(line)
        summary_rows.append(line)
        sys.stdout.flush()

    # canonical JSON
    with open(JSON_OUT, "w") as fh:
        json.dump(out, fh, sort_keys=True, indent=2)
        fh.write("\n")


import os
_HERE = os.path.dirname(os.path.abspath(__file__))
JSON_OUT = os.path.join(_HERE, "2026-07-22-prs-deep-hole-census.json")

if __name__ == "__main__":
    main()
