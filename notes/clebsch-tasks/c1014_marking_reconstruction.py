#!/usr/bin/env python3
"""C1014 -- marking loss / reconstruction for the Phi_{2m,4} square-class coloring.

Colour every unordered 4-subset S of P^1(F_q) (q odd) by the square class of
the Veronese Gram determinant

    G_{2m,4}(p_1..p_4) = det( [v_i, v_j]^{2m} )_{i,j}   (hollow 4x4),

which equals Delta * Phi_{2m,4}(lambda) with Delta = lambda^2 (1-lambda)^2 for
the normalization (infty, 0, 1, lambda).  This script

  (0) validates the Gram <-> cross-ratio dictionary symbolically,
  (1) validates the exponent reduction 2m -> r = 2m mod (q-1),
  (2) computes, for every odd prime power q <= 121 (primes and p^2) and every
      r in the fundamental window, an EXACT automorphism certificate for the
      coloured 4-hypergraph on P^1(F_q) by individualization-refinement,
  (3) cross-checks m = 2, q = 11 against Paper V / C1011 (harmonic design,
      Aut = PGL_2(11), order 1320),
  (4) measures star-separation numbers (query complexity upper bounds) and
      5-set colour-vector realizability (distinguisher from a random colouring).

Output: a plain-text report on stdout.  No files are written.
"""

import sys
from itertools import combinations

# --------------------------------------------------------------------------
# finite fields F_q, q = p or p^2, p odd
# --------------------------------------------------------------------------


def is_prime(n):
    if n < 2:
        return False
    d = 2
    while d * d <= n:
        if n % d == 0:
            return False
        d += 1
    return True


class GF:
    """F_q with q = p^e, e in {1,2}.  Elements are ints 0..q-1; for e = 2 the
    int a + b*p denotes a + b*t with t^2 = nsq, nsq a fixed non-residue."""

    def __init__(self, p, e):
        assert p % 2 == 1 and is_prime(p) and e in (1, 2)
        self.p, self.e, self.q = p, e, p ** e
        q = self.q
        if e == 2:
            sq = {(x * x) % p for x in range(1, p)}
            self.nsq = next(n for n in range(2, p) if n not in sq)
        # addition / negation tables
        self.addt = [[0] * q for _ in range(q)]
        self.negt = [0] * q
        for x in range(q):
            for y in range(q):
                self.addt[x][y] = self._add_raw(x, y)
            self.negt[x] = self._add_inverse(x)
        # multiplicative structure via a generator
        self.mult_raw = self._mul_raw
        g = self._find_generator()
        self.g = g
        self.expt = [0] * (q - 1)
        self.logt = [None] * q
        x = 1
        for i in range(q - 1):
            self.expt[i] = x
            self.logt[x] = i
            x = self._mul_raw(x, g)
        assert x == 1

    # -- raw arithmetic --------------------------------------------------
    def _split(self, x):
        if self.e == 1:
            return (x, 0)
        return (x % self.p, x // self.p)

    def _join(self, a, b):
        if self.e == 1:
            return a % self.p
        return (a % self.p) + (b % self.p) * self.p

    def _add_raw(self, x, y):
        a, b = self._split(x)
        c, d = self._split(y)
        return self._join(a + c, b + d)

    def _add_inverse(self, x):
        a, b = self._split(x)
        return self._join(-a, -b)

    def _mul_raw(self, x, y):
        a, b = self._split(x)
        c, d = self._split(y)
        if self.e == 1:
            return (a * c) % self.p
        return self._join(a * c + b * d * self.nsq, a * d + b * c)

    def _order(self, x):
        n, y = 1, x
        while y != 1:
            y = self._mul_raw(y, x)
            n += 1
        return n

    def _find_generator(self):
        for g in range(2, self.q):
            if self._order(g) == self.q - 1:
                return g
        raise RuntimeError("no generator")

    # -- public arithmetic ------------------------------------------------
    def add(self, x, y):
        return self.addt[x][y]

    def sub(self, x, y):
        return self.addt[x][self.negt[y]]

    def neg(self, x):
        return self.negt[x]

    def mul(self, x, y):
        if x == 0 or y == 0:
            return 0
        return self.expt[(self.logt[x] + self.logt[y]) % (self.q - 1)]

    def inv(self, x):
        return self.expt[(-self.logt[x]) % (self.q - 1)]

    def div(self, x, y):
        if x == 0:
            return 0
        return self.expt[(self.logt[x] - self.logt[y]) % (self.q - 1)]

    def powr(self, x, r):
        if x == 0:
            return 0
        return self.expt[(self.logt[x] * r) % (self.q - 1)]

    def chi(self, x):
        if x == 0:
            return 0
        return 1 if self.logt[x] % 2 == 0 else -1

    def fromint(self, n):
        return self._join(n, 0)

    def frob(self, x):
        """x -> x^p (identity for e = 1)."""
        return self.powr(x, self.p) if x else 0


# --------------------------------------------------------------------------
# the colouring
# --------------------------------------------------------------------------


def col_table(F, r):
    """col[lambda] = chi(G_r(lambda)) for lambda in F_q \\ {0,1}, where
    G_r(lam) = (1 - lam^r - (1-lam)^r)^2 - 4 (lam(1-lam))^r."""
    one, four = 1, F.fromint(4)
    col = {}
    for lam in range(F.q):
        if lam == 0 or lam == one:
            continue
        om = F.sub(one, lam)
        A = F.sub(F.sub(one, F.powr(lam, r)), F.powr(om, r))
        u = F.mul(lam, om)
        G = F.sub(F.mul(A, A), F.mul(four, F.powr(u, r)))
        col[lam] = F.chi(G)
    return col


def cross_ratio(F, a, b, c, d, INF):
    """(a,b;c,d) = (a-c)(b-d) / ((a-d)(b-c)) on P^1(F_q)."""
    if a == INF:
        return F.div(F.sub(b, d), F.sub(b, c))
    if b == INF:
        return F.div(F.sub(a, c), F.sub(a, d))
    if c == INF:
        return F.div(F.sub(b, d), F.sub(a, d))
    if d == INF:
        return F.div(F.sub(a, c), F.sub(b, c))
    return F.div(F.mul(F.sub(a, c), F.sub(b, d)), F.mul(F.sub(a, d), F.sub(b, c)))


def set_colour(F, col, S, INF):
    a, b, c, d = S
    return col[cross_ratio(F, a, b, c, d, INF)]


# --------------------------------------------------------------------------
# (0) symbolic validation of the Gram <-> cross-ratio dictionary
# --------------------------------------------------------------------------


def validate_symbolic(mmax=6):
    import sympy as sp

    lam = sp.symbols("lam")
    v = [(sp.Integer(1), sp.Integer(0)), (sp.Integer(0), sp.Integer(1)),
         (sp.Integer(1), sp.Integer(1)), (lam, sp.Integer(1))]

    def br(x, y):
        return x[0] * y[1] - x[1] * y[0]

    lines = []
    for m in range(2, mmax + 1):
        d = 2 * m
        M = sp.Matrix(4, 4, lambda i, j: br(v[i], v[j]) ** d)
        G = sp.expand(M.det())
        Gc = sp.expand((1 - lam ** d - (1 - lam) ** d) ** 2
                       - 4 * (lam * (1 - lam)) ** d)
        Delta = lam ** 2 * (1 - lam) ** 2
        Phi = sp.simplify(sp.cancel(G / Delta))
        ok_form = sp.simplify(G - Gc) == 0
        ok_poly = sp.denom(sp.together(Phi)) == 1
        # S_3 invariance of chi(Phi): Phi(1-lam) == Phi(lam) and
        # lam^(4m-6) Phi(1/lam) == Phi(lam)
        ok_s = sp.simplify(Phi.subs(lam, 1 - lam) - Phi) == 0
        ok_r = sp.simplify(sp.expand(lam ** (4 * m - 6) * Phi.subs(lam, 1 / lam)) - Phi) == 0
        # weight: G is homogeneous of degree 2d in each v_i (checked by
        # scaling v_4 -> s v_4 in the unnormalized determinant)
        s = sp.symbols("s")
        vv = list(v)
        vv[3] = (s * lam, s)
        Ms = sp.Matrix(4, 4, lambda i, j: br(vv[i], vv[j]) ** d)
        wt = sp.simplify(sp.expand(Ms.det()) - s ** (2 * d) * G) == 0
        lines.append((m, ok_form, ok_poly, ok_s, ok_r, wt))
    return lines


def validate_reduction(F, mmax=8):
    """chi(Phi_{2m,4}(lam)) == chi(G_r(lam)) with r = 2m mod (q-1)."""
    bad = 0
    one = 1
    four = F.fromint(4)
    for m in range(2, mmax + 1):
        d = 2 * m
        r = d % (F.q - 1)
        colr = col_table(F, r)
        for lam in range(F.q):
            if lam in (0, one):
                continue
            om = F.sub(one, lam)
            # direct evaluation with the true exponent d (repeated squaring)
            def pw(x, n):
                res, b = 1, x
                while n:
                    if n & 1:
                        res = F.mul(res, b)
                    b = F.mul(b, b)
                    n >>= 1
                return res
            A = F.sub(F.sub(one, pw(lam, d)), pw(om, d))
            u = F.mul(lam, om)
            G = F.sub(F.mul(A, A), F.mul(four, pw(u, d)))
            if F.chi(G) != colr[lam]:
                bad += 1
    return bad


def validate_wellposed(F, col):
    """chi is constant on each anharmonic S_3 orbit, and set_colour does not
    depend on the ordering of the 4-set."""
    INF = F.q
    one = 1
    bad_orbit = 0
    for lam in col:
        for mu in anharmonic_orbit(F, lam):
            if col[mu] != col[lam]:
                bad_orbit += 1
    pts = list(range(F.q)) + [INF]
    bad_order = 0
    import itertools
    for S in itertools.islice(combinations(pts, 4), 0, 400):
        vals = {set_colour(F, col, P, INF) for P in itertools.permutations(S)}
        if len(vals) != 1:
            bad_order += 1
    return bad_orbit, bad_order


def anharmonic_orbit(F, lam):
    one = 1
    out = {lam}
    out.add(F.sub(one, lam))
    out.add(F.inv(lam))
    out.add(F.inv(F.sub(one, lam)))
    out.add(F.div(lam, F.sub(lam, one)))
    out.add(F.div(F.sub(lam, one), lam))
    return out


# --------------------------------------------------------------------------
# (2) automorphism certificate
# --------------------------------------------------------------------------


def edge_codes(F, col):
    """EC[i][j] for i, j indices into X = F_q \\ {0,1}: the ordered triple of
    colours of {infty,0,x_i,x_j}, {infty,1,x_i,x_j}, {0,1,x_i,x_j}, packed."""
    one = 1
    X = [x for x in range(F.q) if x not in (0, one)]
    n = len(X)
    idx = {x: i for i, x in enumerate(X)}
    EC = [[0] * n for _ in range(n)]
    for i in range(n):
        lam = X[i]
        oml = F.sub(one, lam)
        for j in range(i + 1, n):
            mu = X[j]
            omm = F.sub(one, mu)
            c1 = col[F.div(mu, lam)]
            c2 = col[F.div(omm, oml)]
            c3 = col[F.div(F.mul(lam, omm), F.mul(mu, oml))]
            code = (c1 + 1) * 9 + (c2 + 1) * 3 + (c3 + 1)
            EC[i][j] = code
            EC[j][i] = code
    return X, idx, EC


def refine(n, init, EC):
    """1-dimensional Weisfeiler--Leman refinement on n vertices with vertex
    colours `init` and symmetric edge colours EC.  Returns the stable colour
    vector (as small ints).  Sound: every automorphism preserves it."""
    cur = list(init)
    while True:
        sig = []
        for i in range(n):
            row = EC[i]
            nb = sorted((row[j], cur[j]) for j in range(n) if j != i)
            sig.append((cur[i], tuple(nb)))
        order = {}
        new = []
        for s in sig:
            if s not in order:
                order[s] = len(order)
            new.append(order[s])
        if len(set(new)) == len(set(cur)):
            return new
        cur = new


def cells_of(colours):
    d = {}
    for i, c in enumerate(colours):
        d.setdefault(c, []).append(i)
    return list(d.values())


def h_upper_bound(n, base_init, EC, limit=10 ** 7):
    """Upper bound on |H| where H = Aut(colouring) fixing infty, 0, 1
    pointwise, by iterated individualization-refinement.  Sound because the
    H-orbit of the individualized point lies inside its refined cell."""
    init = list(base_init)
    bound = 1
    picked = []
    while True:
        col = refine(n, init, EC)
        cs = [c for c in cells_of(col) if len(c) > 1]
        if not cs:
            return bound, picked
        cs.sort(key=len)
        C = cs[0]
        bound *= len(C)
        if bound > limit:
            return bound, picked
        b = C[0]
        picked.append(b)
        init = list(col)
        init[b] = max(init) + 1


def analyse(F, r, want_extra=False):
    col = col_table(F, r)
    vals = set(col.values())
    if len(vals) == 1:
        return {"r": r, "constant": True, "colour": vals.pop(),
                "aut": "Sym(q+1)", "bound": None,
                "counts": {c: sum(1 for v in col.values() if v == c) for c in (-1, 0, 1)}}
    X, idx, EC = edge_codes(F, col)
    n = len(X)
    init = [col[x] + 1 for x in X]
    bound, picked = h_upper_bound(n, init, EC)
    return {"r": r, "constant": False, "bound": bound, "e": F.e,
            "exact": bound == F.e, "npicked": len(picked),
            "counts": {c: sum(1 for v in col.values() if v == c) for c in (-1, 0, 1)}}


# --------------------------------------------------------------------------
# (2b) exact search for H = Aut fixing (infty, 0, 1), and the Baer certificate
# --------------------------------------------------------------------------


def backtrack_H(F, col, cellcol=None, cap=10 ** 9, anchor_min=0):
    """Exhaustive backtracking enumeration of H = { sigma in Sym(P^1(F_q)) :
    sigma fixes infty, 0, 1 and preserves the 4-set colouring }.

    Complete and sound: a partial map is extended only if EVERY 4-set inside
    the already-mapped domain keeps its colour, so a completed leaf is a
    genuine automorphism and no automorphism is pruned."""
    one = 1
    INF = F.q
    X = [x for x in range(F.q) if x not in (0, one)]
    n = len(X)
    fixed = [INF, 0, one]
    if cellcol is None:
        cellcol = {x: col[x] for x in X}
    dom = fixed + X
    img = fixed + [None] * n
    used = set(fixed)
    sols = []
    nodes = [0]

    def ok(k, y):
        """x_k = X[k] -> y: check all 4-sets {T, X[k]} with T a 3-subset of the
        first 3 + k mapped points."""
        m = 3 + k
        for T in combinations(range(m), 3):
            if anchor_min and sum(1 for i in T if i < 3) < anchor_min:
                continue
            a, b, c = dom[T[0]], dom[T[1]], dom[T[2]]
            A, B, C = img[T[0]], img[T[1]], img[T[2]]
            if col[cross_ratio(F, a, b, c, dom[3 + k], INF)] != \
               col[cross_ratio(F, A, B, C, y, INF)]:
                return False
        return True

    def rec(k):
        if nodes[0] > cap:
            return
        if k == n:
            sols.append(list(img[3:]))
            return
        x = X[k]
        for y in X:
            if y in used or cellcol[y] != cellcol[x]:
                continue
            nodes[0] += 1
            img[3 + k] = y
            if ok(k, y):
                used.add(y)
                rec(k + 1)
                used.discard(y)
            img[3 + k] = None

    rec(0)
    return sols, nodes[0], X


def classify_solutions(F, X, sols):
    """Label each element of H: identity, a power of Frobenius, or new."""
    labels = []
    for s in sols:
        mp = dict(zip(X, s))
        kind = None
        for k in range(F.e):
            if all(mp[x] == F.powr(x, F.p ** k) if x else True for x in X):
                kind = f"Frobenius^{k}"
                break
        labels.append(kind if kind else "NEW (outside PGammaL_2)")
    return labels


def baer_certificate(F, r):
    """For q = p^2 and r = p+1 the colouring is the Baer-subline (Miquelian
    inversive plane) colouring: colour 0 exactly on cross-ratio in F_p."""
    one = 1
    INF = F.q
    col = col_table(F, r)
    zero_locus = sorted(x for x in col if col[x] == 0)
    subfield = sorted(x for x in range(F.q) if x not in (0, one) and F.powr(x, F.p) == x)
    other = {col[x] for x in col if col[x] != 0}
    # circles: maximal sets all of whose 4-subsets are colour 0
    pts = list(range(F.q)) + [INF]
    circle = [x for x in pts if x == INF or x == 0 or x == one or
              (x != 0 and F.powr(x, F.p) == x)]
    ok_circle = all(col[cross_ratio(F, *T, INF)] == 0
                    for T in combinations(circle, 4))
    ok_max = all(col[cross_ratio(F, INF, 0, one, y, INF)] != 0
                 for y in pts if y not in circle)
    ncircles = (F.q + 1) * F.q * (F.q - 1) // ((F.p + 1) * F.p * (F.p - 1))
    return {"zero_locus_is_subfield": zero_locus == subfield,
            "other_colours": other, "circle_size": len(circle),
            "circle_all_zero": ok_circle, "circle_maximal": ok_max,
            "n_circles": ncircles}


def check_pgammal_invariance(F, col, ntest=200):
    """Sanity: random PGL_2(F_q) elements and the Frobenius preserve the
    colouring."""
    import random
    one = 1
    INF = F.q
    pts = list(range(F.q)) + [INF]

    def act(g, x):
        a, b, c, d = g
        if x == INF:
            return F.div(a, c) if c else INF
        num = F.add(F.mul(a, x), b)
        den = F.add(F.mul(c, x), d)
        return F.div(num, den) if den else INF

    rng = random.Random(20260830)
    bad = 0
    tests = 0
    for _ in range(ntest):
        while True:
            g = tuple(rng.randrange(F.q) for _ in range(4))
            if F.sub(F.mul(g[0], g[3]), F.mul(g[1], g[2])) != 0:
                break
        S = rng.sample(pts, 4)
        T = [act(g, x) for x in S]
        if len(set(T)) == 4:
            tests += 1
            if col[cross_ratio(F, *S, INF)] != col[cross_ratio(F, *T, INF)]:
                bad += 1
    # Frobenius
    fbad = 0
    for _ in range(ntest):
        S = rng.sample(pts, 4)
        T = [INF if x == INF else F.powr(x, F.p) for x in S]
        if col[cross_ratio(F, *S, INF)] != col[cross_ratio(F, *T, INF)]:
            fbad += 1
    return tests, bad, fbad


def stratum_label(F, r):
    q = F.q
    if r == 0:
        return "A  (r=0)"
    if r == 2:
        return "B  (r=2)"
    for i in range(1, F.e):
        if r == (2 * F.p ** i) % (q - 1):
            return f"B o Frob^{i}  (r=2p^{i})"
    if r == (q - 1) // 2:
        return "C  (r=(q-1)/2)"
    if r == (q - 1) // 2 + 1:
        return "G  (r=(q-1)/2+1)"
    if r == (q - 1) - 2:
        return "A* (r=-2)"
    if F.e == 2 and r % (q - 1) == (F.p + 1) % (q - 1):
        return "Baer (r=p+1)"
    # smallest (n, j) fit: r == k(q-1)/n + j
    best = None
    for n in range(2, q):
        if (q - 1) % n:
            continue
        for k in range(1, n):
            for j in range(-3, 4):
                if (k * (q - 1) // n + j) % (q - 1) == r:
                    cand = (n, abs(j), k)
                    if best is None or cand < best:
                        best = cand
    if best:
        return f"n={best[0]}, j=+-{best[1]}"
    return "unfitted"


# --------------------------------------------------------------------------
# (4) query complexity probes
# --------------------------------------------------------------------------


def star_separation(F, col, kmax=8):
    """Smallest k such that, after declaring three points (infty,0,1) and
    fixing k further reference points, the vector of colours of the 4-sets
    {T, y} (T a 3-subset of the reference set) separates all remaining y."""
    one = 1
    INF = F.q
    X = [x for x in range(F.q) if x not in (0, one)]
    if len(X) < 2:
        return 0, 0
    base = [INF, 0, one]
    for k in range(0, kmax + 1):
        refs = base + X[:k]
        rest = X[k:]
        trip = list(combinations(refs, 3))
        sigs = {}
        ok = True
        for y in rest:
            s = tuple(col[cross_ratio(F, T[0], T[1], T[2], y, INF)] for T in trip)
            # separation can only ever be up to the Galois orbit of y, since
            # every field automorphism fixing the references preserves colours
            if s in sigs and sigs[s] != F.frob(y):
                ok = False
                break
            sigs[s] = y
        if ok:
            nq = len(trip) * len(rest)
            return k, nq
    return None, None


def fiveset_vectors(F, col):
    """Realizable multisets of the five 4-subset colours of a 5-subset."""
    one = 1
    X = [x for x in range(F.q) if x not in (0, one)]
    seen = set()
    for i, lam in enumerate(X):
        oml = F.sub(one, lam)
        for mu in X[i + 1:]:
            omm = F.sub(one, mu)
            c = (col[lam], col[mu],
                 col[F.div(mu, lam)],
                 col[F.div(omm, oml)],
                 col[F.div(F.mul(lam, omm), F.mul(mu, oml))])
            seen.add(tuple(sorted(c)))
    return seen


ALL_MULTISETS = set()
for _a in range(6):
    for _b in range(6 - _a):
        _c = 5 - _a - _b
        ALL_MULTISETS.add(tuple(sorted([-1] * _a + [0] * _b + [1] * _c)))


def random_hit_probability(seen):
    """Probability that a uniformly random 3-colouring of the five 4-subsets
    of a 5-set lands in the realizable multiset set."""
    from math import factorial
    tot = 0
    for ms in seen:
        a = sum(1 for x in ms if x == -1)
        b = sum(1 for x in ms if x == 0)
        c = 5 - a - b
        tot += factorial(5) // (factorial(a) * factorial(b) * factorial(c))
    return tot / 3 ** 5


# --------------------------------------------------------------------------
# (1) orbit dictionary
# --------------------------------------------------------------------------


def orbit_dictionary(F):
    one = 1
    X = [x for x in range(F.q) if x not in (0, one)]
    seen = set()
    orbs = []
    for lam in X:
        if lam in seen:
            continue
        O = anharmonic_orbit(F, lam)
        seen |= O
        orbs.append(sorted(O))
    sizes = {}
    for O in orbs:
        sizes[len(O)] = sizes.get(len(O), 0) + 1
    return len(orbs), sizes


# --------------------------------------------------------------------------
# Paper V cross-check
# --------------------------------------------------------------------------


def paper_v_check():
    F = GF(11, 1)
    INF = F.q
    col = col_table(F, 4 % (F.q - 1))
    pts = list(range(F.q)) + [INF]
    blocks = {-1: [], 0: [], 1: []}
    for S in combinations(pts, 4):
        blocks[set_colour(F, col, S, INF)].append(S)
    pos = blocks[1]
    # design parameters of the positive class
    p1 = {x: 0 for x in pts}
    p2 = {}
    p3 = {}
    for S in pos:
        for x in S:
            p1[x] += 1
        for T in combinations(S, 2):
            p2[T] = p2.get(T, 0) + 1
        for T in combinations(S, 3):
            p3[T] = p3.get(T, 0) + 1
    harmonic = sorted(anharmonic_orbit(F, F.fromint(2)))
    pos_lams = sorted({x for x in col if col[x] == 1})
    res = analyse(F, 4)
    return {
        "counts": {k: len(v) for k, v in blocks.items()},
        "lambda1": set(p1.values()), "lambda2": set(p2.values()),
        "lambda3": set(p3.values()),
        "positive_lambdas": pos_lams, "harmonic_orbit": harmonic,
        "hbound": res["bound"],
        "aut_order": res["bound"] * (F.q + 1) * F.q * (F.q - 1),
    }


# --------------------------------------------------------------------------
# main
# --------------------------------------------------------------------------


def prime_powers(limit):
    out = []
    for p in range(3, limit + 1, 2):
        if not is_prime(p):
            continue
        if p <= limit:
            out.append((p, 1))
        if p * p <= limit:
            out.append((p, 2))
    out.sort(key=lambda pe: pe[0] ** pe[1])
    return out


def main():
    print("=" * 74)
    print("SECTION 0 -- symbolic validation of the Gram <-> cross-ratio dictionary")
    print("=" * 74)
    for (m, a, b, c, d, w) in validate_symbolic(6):
        print(f"m={m:2d}  det=compact:{a}  Phi in Z[lam]:{b}  "
              f"Phi(1-lam)=Phi:{c}  lam^(4m-6)Phi(1/lam)=Phi:{d}  "
              f"weight s^(2d) in each point:{w}")

    print()
    print("=" * 74)
    print("SECTION 1 -- exponent reduction and well-posedness")
    print("=" * 74)
    for (p, e) in [(5, 1), (7, 1), (11, 1), (13, 1), (17, 1), (9, 0), (25, 0)]:
        if e == 0:
            F = GF(int(round(p ** 0.5)), 2)
        else:
            F = GF(p, 1)
        bad = validate_reduction(F, 8)
        col = col_table(F, 4 % (F.q - 1))
        bo, bd = validate_wellposed(F, col)
        no, sz = orbit_dictionary(F)
        print(f"q={F.q:4d}  chi(Phi_2m)=chi(G_r) mismatches (m=2..8): {bad}; "
              f"S_3-orbit colour mismatches: {bo}; ordering mismatches: {bd}; "
              f"PGL_2-orbits on 4-sets: {no} (sizes {dict(sorted(sz.items()))})")

    print()
    print("=" * 74)
    print("SECTION 2 -- Paper V / C1011 cross-check at m = 2, q = 11")
    print("=" * 74)
    pv = paper_v_check()
    for k, v in pv.items():
        print(f"  {k}: {v}")

    print()
    print("=" * 74)
    print("SECTION 3 -- automorphism sweep, odd prime powers q <= 121")
    print("=" * 74)
    print("q     e  |X|  #r  #constant  #refine-exact  #residual")
    residual = []
    all_collapses = []
    tot = [0, 0, 0]
    for (p, e) in prime_powers(121):
        F = GF(p, e)
        q = F.q
        collapses, nconst, nexact, nres = [], 0, 0, 0
        for m in range(1, (q - 1) // 2 + 1):
            r = (2 * m) % (q - 1)
            res = analyse(F, r)
            if res["constant"]:
                nconst += 1
                collapses.append((r, res["colour"]))
                all_collapses.append((q, r, res["colour"], stratum_label(F, r)))
            elif res["exact"]:
                nexact += 1
            else:
                nres += 1
                residual.append((q, p, e, r, res["bound"], res["counts"]))
        tot[0] += nconst
        tot[1] += nexact
        tot[2] += nres
        print(f"q={q:4d}  {e}  {q-2:4d}  {(q-1)//2:3d}  {nconst:9d}  "
              f"{nexact:13d}  {nres:9d}")
        sys.stdout.flush()
    print(f"TOTAL  constant={tot[0]}  refinement-exact={tot[1]}  residual={tot[2]}")

    print()
    print("--- 3a. constant-character strata (Aut = Sym(q+1)), q <= 121 ---")
    print("q     r   chi   stratum")
    for (q, r, c, lab) in all_collapses:
        print(f"{q:4d} {r:4d}   {c:+d}   {lab}")

    print()
    print("--- 3b. residual cases (refinement bound > e): the Baer stratum ---")
    for (q, p, e, r, bound, counts) in residual:
        F = GF(p, e)
        cert = baer_certificate(F, r)
        print(f"q={q} r={r} (p+1={p+1}) 1-WL bound |H|<={bound}; counts={counts}")
        print(f"    baer certificate: {cert}")
        if q <= 49:
            col = col_table(F, r)
            sols, nodes, X = backtrack_H(F, col)
            print(f"    exhaustive search over H: |H|={len(sols)} "
                  f"(nodes={nodes}) -> {classify_solutions(F, X, sols)}")
        sys.stdout.flush()

    print()
    print("--- 3c. over F_{p^2}: (p+1) | r forces the colour -1 to be absent ---")
    for p in (3, 5, 7, 11):
        F = GF(p, 2)
        q = F.q
        rows = []
        for m in range(1, (q - 1) // 2 + 1):
            r = (2 * m) % (q - 1)
            col = col_table(F, r)
            vals = sorted(set(col.values()))
            rows.append((r, r % (p + 1) == 0, vals))
        div = [r for r, d, v in rows if d]
        bad = [(r, v) for r, d, v in rows if d and -1 in v]
        nod = [(r, v) for r, d, v in rows if not d and -1 not in v]
        print(f"q={q:4d}: r divisible by p+1 = {div}; with colour -1 present: "
              f"{bad}; r NOT divisible by p+1 yet missing -1: {nod}")

    print()
    print("--- 3e. Frobenius twists of the total-collapse stratum: r = 2 p^i ---")
    for p in (3, 5, 7, 11):
        F = GF(p, 2)
        q = F.q
        out = []
        for i in range(2):
            r = (2 * p ** i) % (q - 1)
            col = col_table(F, r)
            out.append((r, sorted(set(col.values()))))
        print(f"q={q:4d}: (r, colour values) for r = 2, 2p: {out}")

    print()
    print("--- 3f. is the 2-anchored query set enough on the Baer stratum? ---")
    print("(query set = 4-sets meeting the anchor {infty,0,1} in >= 2 points)")
    for (p, r) in [(3, 4), (5, 6)]:
        F = GF(p, 2)
        col = col_table(F, r)
        s2, n2, X = backtrack_H(F, col, anchor_min=2)
        s1, n1, _ = backtrack_H(F, col, anchor_min=1)
        s0, n0, _ = backtrack_H(F, col, anchor_min=0)
        print(f"q={F.q}: |H| from 2-anchored queries = {len(s2)}; "
              f"from 1-anchored = {len(s1)}; from all 4-sets = {len(s0)}")

    print()
    print("--- 3d. PGammaL_2-invariance sanity check ---")
    for (p, e) in [(11, 1), (13, 1), (23, 1), (9, 0), (25, 0), (49, 0)]:
        F = GF(p, 1) if e else GF(int(round(p ** 0.5)), 2)
        col = col_table(F, 4 % (F.q - 1))
        t, b, fb = check_pgammal_invariance(F, col)
        print(f"q={F.q:4d} r=4: PGL_2 tests={t} failures={b}; "
              f"Frobenius failures={fb}")

    print()
    print("=" * 74)
    print("SECTION 4 -- query complexity probes")
    print("=" * 74)
    print("q     r   min-colour-density  star-k  star-queries  "
          "5-set multisets/21  random-hit")
    for (p, e) in prime_powers(121):
        F = GF(p, e)
        q = F.q
        if q < 7:
            continue
        # first nonconstant r
        for m in range(1, (q - 1) // 2 + 1):
            r = (2 * m) % (q - 1)
            col = col_table(F, r)
            if len(set(col.values())) > 1:
                break
        cnt = {c: sum(1 for v in col.values() if v == c) for c in (-1, 0, 1)}
        dens = min(v for v in cnt.values() if v > 0) / (q - 2)
        k, nq = star_separation(F, col)
        seen = fiveset_vectors(F, col)
        ks = "--" if k is None else str(k)
        nqs = "--" if nq is None else str(nq)
        print(f"q={q:4d} r={r:3d}  {dens:8.4f}          {ks}     {nqs:>8s}     "
              f"{len(seen):3d}/21           {random_hit_probability(seen):.4f}")
        sys.stdout.flush()

    print()
    print("=" * 74)
    print("SECTION 5 -- star separation across ALL nonconstant r (max over r)")
    print("=" * 74)
    for (p, e) in prime_powers(121):
        F = GF(p, e)
        q = F.q
        if q < 7:
            continue
        ks = []
        for m in range(1, (q - 1) // 2 + 1):
            r = (2 * m) % (q - 1)
            col = col_table(F, r)
            if len(set(col.values())) == 1:
                continue
            k, nq = star_separation(F, col)
            ks.append((k if k is not None else 99, r))
        if ks:
            mk = max(ks)
            print(f"q={q:4d}  max star-k over nonconstant r = {mk[0]} (at r={mk[1]}), "
                  f"#nonconstant r = {len(ks)}")
        sys.stdout.flush()


if __name__ == "__main__":
    main()
