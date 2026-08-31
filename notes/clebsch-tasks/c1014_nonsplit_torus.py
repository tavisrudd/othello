#!/usr/bin/env python3
"""C1014 -- the non-split-torus (u-line) stratification of the Phi_{2m,4} census.

Companion to `c1014_dickson_strata.py` (the lambda-line / split-torus side).

Replay:
    uv run --with sympy --with numpy python3 \
        notes/clebsch-tasks/c1014_nonsplit_torus.py <cmd>

    coords [PMAX]    torus coordinates + split/non-split decomposition
    master [PMAX]    non-split master formula (trace-one Gauss sums)
    collapse [PMAX]  the total-collapse set of the non-split census
    period [PMAX]    minimal period of S1, S2, S_ns; the L vs L/2 question
    sweep [PMAX]     constant non-split strata over the full (i,j) grid
    families [PMAX]  correlation lemma + torus power-residue family tables
    weil [W]         genus + Weil bound + member list per (ii,jj) family
    mirror [PMAX]    is there a torus mirror of the Fermat-cubic family?
    powq [QMAX]      lambda-line constant strata over prime powers (task 4)
    ergodis          cross-check S1, S2 on the Ergodis kernel

Runs behind the numbers in the report:
    coords 200 | master 200 | collapse 300 | period 300 | sweep 300
    | families 4000 | weil 8 | mirror 400 | powq 1100 | ergodis

Notation (report section 1):
    u = lam(1-lam),  tau = 1/u - 2,  nu = tau + 2 = 1/u,
    z + z^{-1} = tau  with z in F_p^* (split) or z in mu_{p+1} (non-split),
    D_j(tau,1) = z^j + z^{-j}  (Dickson polynomial of the first kind, a=1),
    P_m(tau)  = ((tau+2)^m - D_m(tau,1))^2 - 4,
    chi(Phi_{2m,4}) = chi(P_m(tau)).
"""

import sys
from math import gcd, lcm, isqrt

import numpy as np


ERGODIS = "/home/tavis/.cache/ergodis/c1013-census-target/release/c1013-census"


# ---------------------------------------------------------------------------
# basic arithmetic
# ---------------------------------------------------------------------------

def chi_table(p):
    """chi[v] = Legendre symbol of v mod p, as an int8 numpy array."""
    t = np.full(p, -1, dtype=np.int8)
    t[0] = 0
    t[(np.arange(1, p, dtype=np.int64) ** 2) % p] = 1
    return t


def legendre(a, p):
    a %= p
    if a == 0:
        return 0
    return 1 if pow(a, (p - 1) // 2, p) == 1 else -1


def dickson(m, tau, p):
    """D_m(tau, 1) = z^m + z^{-m} mod p, by the standard recurrence."""
    a, b = 2 % p, tau % p          # D_0, D_1
    for _ in range(m):
        a, b = b, (tau * b - a) % p
    return a


def s_lucas(m, u, p):
    """s_m = lam^m + (1-lam)^m = D_m(1,u) mod p."""
    a, b = 2 % p, 1 % p            # s_0 = 2, s_1 = 1
    for _ in range(m):
        a, b = b, (b - u * a) % p
    return a


def Q_tilde(m, u, p):
    """u^2 Phi_{2m,4} as a function of u: (1-s_m^2)(1-s_m^2+4u^m)."""
    s = s_lucas(m, u, p)
    A = (1 - s * s) % p
    return A * (A + 4 * pow(u, m, p)) % p


def P_poly_val(m, tau, p):
    """P_m(tau) = ((tau+2)^m - D_m(tau,1))^2 - 4."""
    c = (pow((tau + 2) % p, m, p) - dickson(m, tau, p)) % p
    return (c * c - 4) % p


# ---------------------------------------------------------------------------
# censuses
# ---------------------------------------------------------------------------

def lambda_census(m, p):
    """S_lam = sum_{lam != 0,1} chi(Phi_{2m,4}(lam))."""
    tot = 0
    for lam in range(2, p):
        u = lam * (1 - lam) % p
        tot += legendre(Q_tilde(m, u, p), p)
    return tot


def u_censuses(m, p):
    """(S1, S2, S_ns) with
       S1 = sum_u chi(Qt(u)), S2 = sum_u chi((1-4u) Qt(u)),
       S_ns = sum over non-split u of chi(Qt(u))."""
    s1 = s2 = sns = 0
    for u in range(p):
        c = legendre(Q_tilde(m, u, p), p)
        e = legendre((1 - 4 * u) % p, p)
        s1 += c
        s2 += e * c
        if e == -1:
            sns += c
    return s1, s2, sns


# ---------------------------------------------------------------------------
# cmd: coords
# ---------------------------------------------------------------------------

def cmd_coords(argv):
    from sympy import primerange
    pmax = int(argv[0]) if argv else 200
    print("task 1a: torus coordinates and the split/non-split decomposition")
    print("  (i)   chi(Qt(u)) = chi(P_m(tau)) pointwise, tau = 1/u - 2")
    print("  (ii)  S1 + S2 = S_lam")
    print("  (iii) S1 - S2 = 2 S_ns + chi(4^{m-1} - 1)")
    print("  (iv)  S1 = (S_lam + kappa)/2 + S_ns")
    bad = [0, 0, 0, 0]
    pairs = 0
    for p in primerange(3, pmax):
        for m in range(2, 9):
            pairs += 1
            s1, s2, sns = u_censuses(m, p)
            sl = lambda_census(m, p)
            kap = legendre(pow(4, m - 1, p) - 1, p)
            # (i) pointwise
            for u in range(1, p):
                tau = (pow(u, p - 2, p) - 2) % p
                if legendre(Q_tilde(m, u, p), p) != legendre(P_poly_val(m, tau, p), p):
                    bad[0] += 1
            if s1 + s2 != sl:
                bad[1] += 1
            if s1 - s2 != 2 * sns + kap:
                bad[2] += 1
            if 2 * s1 != sl + kap + 2 * sns:
                bad[3] += 1
    print(f"\npairs (m=2..8, odd p < {pmax}): {pairs}")
    print(f"failures: (i) {bad[0]}  (ii) {bad[1]}  (iii) {bad[2]}  (iv) {bad[3]}")


# ---------------------------------------------------------------------------
# F_{p^2} arithmetic (log/exp tables)
# ---------------------------------------------------------------------------

class Fq2:
    """F_{p^2} = F_p[theta], theta^2 = t, elements encoded as a + b*p."""

    def __init__(self, p):
        from sympy import factorint
        self.p = p
        self.M = p * p - 1
        self.t = next(t for t in range(2, p) if legendre(t, p) == -1)
        self.g = self._generator(factorint(self.M))
        self.exp = [0] * self.M
        self.log = [-1] * (p * p)
        x = 1
        for k in range(self.M):
            self.exp[k] = x
            self.log[x] = k
            x = self.mul(x, self.g)
        assert x == 1

    def mul(self, x, y):
        p, t = self.p, self.t
        a1, b1 = x % p, x // p
        a2, b2 = y % p, y // p
        return (a1 * a2 + t * b1 * b2) % p + p * ((a1 * b2 + a2 * b1) % p)

    def _pow(self, x, n):
        r, b = 1, x
        while n:
            if n & 1:
                r = self.mul(r, b)
            b = self.mul(b, b)
            n >>= 1
        return r

    def _generator(self, fac):
        for a in range(1, self.p):
            for b in range(1, self.p):
                x = a + self.p * b
                if all(self._pow(x, self.M // q) != 1 for q in fac):
                    return x
        raise RuntimeError("no generator")

    def trace(self, x):
        return 2 * (x % self.p) % self.p

    def norm(self, x):
        p = self.p
        a, b = x % p, x // p
        return (a * a - self.t * b * b) % p


def frak_F(fq, X):
    """cal F(X) = (1 - Tr X)^2 - 4 N(X), an element of F_p."""
    p = fq.p
    return ((1 - fq.trace(X)) ** 2 - 4 * fq.norm(X)) % p


# ---------------------------------------------------------------------------
# cmd: master
# ---------------------------------------------------------------------------

def cmd_master(argv):
    from sympy import primerange
    pmax = int(argv[0]) if argv else 200
    print("task 1b: the non-split master formula")
    print("  sum_{Tr lam = 1} chi(cal F(lam^r)) = 2 S_ns + kappa   (identity)")
    print("  Plancherel: = (1/e) sum_t Mhat(t) conj(Ahat(t)),")
    print("  Mhat(t) = frak G(Theta_t) = sum_{Tr lam = 1} Theta_t(lam)")
    print("          = (G_{p^2}(Theta) / p) * Theta(-1) * g_p(conj Theta|F_p^*)")
    worst = 0.0
    bad_id = bad_planch = bad_mag = bad_closed = 0
    pairs = 0
    mags = {}
    for p in primerange(5, pmax):
        fq = Fq2(p)
        p2 = p * p
        inv2 = (p + 1) // 2
        Lam = [inv2 + p * b for b in range(p)]     # trace-one line
        ind = [fq.log[x] for x in Lam]
        for m in range(2, 9):
            pairs += 1
            r = 2 * m
            M = fq.M
            d = gcd(r, M)
            e = M // d
            rp = r // d
            # A[s] = chi(cal F(g^{d s}))
            chip = chi_table(p)
            A = np.empty(e, dtype=np.int8)
            x = 1
            gd = fq._pow(fq.g, d)
            for s in range(e):
                A[s] = chip[frak_F(fq, x)]
                x = fq.mul(x, gd)
            # M[s] = # {lam in Lam : s(lam) = s}
            Mc = np.zeros(e, dtype=np.int64)
            for a in ind:
                Mc[(rp * a) % e] += 1
            direct = int(np.dot(Mc, A.astype(np.int64)))
            _, _, sns = u_censuses(m, p)
            kap = legendre(pow(4, m - 1, p) - 1, p)
            if direct != 2 * sns + kap:
                bad_id += 1
            Mh = np.fft.fft(Mc).conj()
            Ah = np.fft.fft(A.astype(np.float64)).conj()
            val = (Mh * Ah.conj()).sum().real / e
            worst = max(worst, abs(val - direct))
            if abs(val - direct) > 1e-6:
                bad_planch += 1
            # |Mhat(t)| in {p, sqrt p, 1}
            am = np.abs(Mh)
            ok = (np.abs(am - p) < 1e-6) | (np.abs(am - p ** 0.5) < 1e-6) | \
                 (np.abs(am - 1) < 1e-6)
            bad_mag += int((~ok).sum())
            for v in np.unique(np.round(am, 6)):
                mags[float(v) / (p ** 0.5)] = mags.get(float(v) / (p ** 0.5), 0) + 1
            # closed form on a sample of characters
            if p < 60 and m == 3:
                bad_closed += _check_closed(fq, Mh, e, rp, d)
    print(f"\npairs (m=2..8, 5 <= p < {pmax}): {pairs}")
    print(f"identity failures                     : {bad_id}")
    print(f"Plancherel failures (tol 1e-6)        : {bad_planch}")
    print(f"|Mhat| not in {{p, sqrt p, 1}}          : {bad_mag}")
    print(f"closed-form Gauss-sum failures (p<60) : {bad_closed}")
    print(f"worst |direct - formula|              : {worst:.3e}")


def _check_closed(fq, Mh, e, rp, d, nsample=6):
    """frak G(Theta) = (G_{p^2}(Theta)/p) Theta(-1) g_p(conj Theta|_{F_p^*})."""
    p, M = fq.p, fq.M
    ep = [np.exp(2j * np.pi * k / p) for k in range(p)]
    bad = 0
    step = max(1, e // nsample)
    for t in range(0, e, step):
        c = (t * rp) % e                      # Theta = (g -> w_e^c)
        if c == 0:
            continue
        w = np.exp(2j * np.pi * c / e)
        # G_{p^2}(Theta)
        G = 0j
        x = 1
        for k in range(M):
            G += w ** k * ep[fq.trace(x)]
            x = fq.mul(x, fq.g)
        # Theta restricted to F_p^*: F_p^* = <g^{p+1}>
        gp = fq._pow(fq.g, p + 1)
        th = {}
        y = 1
        for v in range(p - 1):
            th[y] = w ** ((p + 1) * v)
            y = fq.mul(y, gp)
        gsum = sum(np.conj(th[x]) * ep[x] for x in range(1, p))
        pred = G / p * th[p - 1] * gsum
        if abs(pred - Mh[t]) > 1e-6 * max(1.0, abs(Mh[t])):
            bad += 1
    return bad


# ---------------------------------------------------------------------------
# the (i,j) grid:  i = m mod (p-1) drives nu^i, j = m mod (p+1) drives tau_j
# ---------------------------------------------------------------------------

def ns_grid(p):
    """cntp[i,j], cntm[i,j] = # non-split tau with chi(P) = +1 / -1."""
    chip = chi_table(p)
    tt = np.arange(p, dtype=np.int64)
    ns = tt[chip[(tt * tt - 4) % p] == -1]
    nu = (ns + 2) % p
    k = len(ns)
    pw = np.empty((p - 1, k), dtype=np.int64)
    cur = np.ones(k, dtype=np.int64)
    for i in range(p - 1):
        pw[i] = cur
        cur = cur * nu % p
    cntp = np.zeros((p - 1, p + 1), dtype=np.int32)
    cntm = np.zeros((p - 1, p + 1), dtype=np.int32)
    a = np.full(k, 2 % p, dtype=np.int64)      # D_0
    b = ns % p                                  # D_1
    for j in range(p + 1):
        c = (pw - a[None, :]) % p
        s = chip[(c * c - 4) % p]
        cntp[:, j] = (s == 1).sum(axis=1)
        cntm[:, j] = (s == -1).sum(axis=1)
        a, b = b, (ns * b - a) % p
    return cntp, cntm, k


def split_row(p):
    """spos[i], sneg[i] over the split tau (chi(tau^2-4) = +1), plus kappa[i]."""
    chip = chi_table(p)
    tt = np.arange(p, dtype=np.int64)
    sp = tt[chip[(tt * tt - 4) % p] == 1]
    nu = (sp + 2) % p
    k = len(sp)
    spos = np.zeros(p - 1, dtype=np.int32)
    sneg = np.zeros(p - 1, dtype=np.int32)
    kap = np.zeros(p - 1, dtype=np.int32)
    cur = np.ones(k, dtype=np.int64)            # nu^i
    a = np.full(k, 2 % p, dtype=np.int64)       # D_i
    b = sp % p
    four = 1
    for i in range(p - 1):
        c = (cur - a) % p
        s = chip[(c * c - 4) % p]
        spos[i] = int((s == 1).sum())
        sneg[i] = int((s == -1).sum())
        # kappa = chi(4^{i-1} - 1) at tau = 2 (u = 1/4); 4^{i-1} = four * inv4
        kap[i] = chip[(pow(4, (i - 1) % (p - 1), p) - 1) % p]
        cur = cur * nu % p
        a, b = b, (sp * b - a) % p
        four = four * 4 % p
    return spos, sneg, kap


def crt_seq(p, grid):
    """grid[i,j] -> sequence indexed by m in Z/L, L = (p^2-1)/2."""
    L = lcm(p - 1, p + 1)
    m = np.arange(L, dtype=np.int64)
    return grid[m % (p - 1), m % (p + 1)]


def minimal_period(seq):
    L = len(seq)
    for h in range(1, L + 1):
        if L % h == 0 and np.array_equal(seq, np.roll(seq, h)):
            return h
    return L


# ---------------------------------------------------------------------------
# cmd: collapse
# ---------------------------------------------------------------------------

def cmd_collapse(argv):
    from sympy import primerange
    pmax = int(argv[0]) if argv else 300
    print("task 2a: the total-collapse set of the non-split census")
    print("  claim: {(i,|j|)} = {(1,1)} only, i.e. m == 1 or m == p (mod L)")
    bad = []
    for p in primerange(5, pmax):
        cntp, cntm, _ = ns_grid(p)
        tot = cntp + cntm
        ii, jj = np.nonzero(tot == 0)
        got = sorted({(int(i), int(j)) for i, j in zip(ii, jj)
                      if (int(i) - int(j)) % 2 == 0})
        want = sorted({(1, 1), (1, p)})
        if got != want:
            bad.append((p, got))
    print(f"\nprimes 5 <= p < {pmax}: {len(bad)} deviations from {{(1,1),(1,-1)}}")
    for p, got in bad[:8]:
        print(f"  p = {p}: {got}")


# ---------------------------------------------------------------------------
# cmd: period
# ---------------------------------------------------------------------------

def cmd_period(argv):
    from sympy import primerange
    pmax = int(argv[0]) if argv else 300
    print("task 2b: minimal period in m of the u-line censuses")
    print("| p | L = lcm(p-1,p+1) | per(S_ns) | per(S1) | per(S2) | per(S_lam) |")
    print("|---|---|---|---|---|---|")
    bad = 0
    rows = []
    for p in primerange(5, pmax):
        cntp, cntm, _ = ns_grid(p)
        spos, sneg, kap = split_row(p)
        L = lcm(p - 1, p + 1)
        sns = crt_seq(p, (cntp - cntm).astype(np.int64))
        zns = crt_seq(p, (cntp + cntm).astype(np.int64))
        m = np.arange(L, dtype=np.int64)
        i = m % (p - 1)
        sp = (spos - sneg).astype(np.int64)[i]
        ka = kap.astype(np.int64)[i]
        s1 = sp + ka + sns
        s2 = sp - sns
        # census = full sign distribution, so pair the sum with the zero count
        per_ns = minimal_period(sns * (2 * len(cntp) + 3) + zns)
        per_1 = minimal_period(s1)
        per_2 = minimal_period(s2)
        per_l = minimal_period(sp[: p - 1] if False else sp)
        rows.append((p, L, per_ns, per_1, per_2, per_l))
        if per_ns != L or per_1 != L or per_2 != L:
            bad += 1
    for row in rows[:8]:
        print("| " + " | ".join(str(x) for x in row) + " |")
    print(f"... {len(rows)} primes 5 <= p < {pmax}")
    print(f"primes where per(S_ns), per(S1) or per(S2) != L : {bad}")
    lam_ok = sum(1 for r in rows if r[5] == (r[0] - 1) // 2)
    print(f"primes where per(S_lam as a function of m) == (p-1)/2 : "
          f"{lam_ok}/{len(rows)}")


# ---------------------------------------------------------------------------
# dispatch
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# cmd: sweep
# ---------------------------------------------------------------------------

def descr(p, i, j):
    """(ii, jj, k, n) : least-abs exponents and the two torus orders."""
    ii = i if i <= (p - 1) // 2 else i - (p - 1)
    jj = min(j, p + 1 - j)
    k = (p - 1) // gcd(i, p - 1) if i else 1
    n = (p + 1) // gcd(j, p + 1) if j else 1
    return ii, jj, k, n


def cmd_sweep(argv):
    from sympy import primerange
    pmax = int(argv[0]) if argv else 300
    verbose = "-v" in argv
    print("task 3: constant non-split strata over the full (i,j) period window")
    print("  i = m mod (p-1), j = m mod (p+1), i == j (mod 2)")
    tally = {}
    rows = []
    for p in primerange(5, pmax):
        cntp, cntm, k0 = ns_grid(p)
        tot = cntp + cntm
        const = ((cntp == 0) ^ (cntm == 0)) & (tot > 0)
        ii, jj = np.nonzero(const)
        for i, j in zip(ii.tolist(), jj.tolist()):
            if (i - j) % 2:
                continue
            sgn = 1 if cntm[i, j] == 0 else -1
            d = descr(p, i, j)
            rows.append((p, i, j, sgn, d, int(tot[i, j])))
            tally[d[2:]] = tally.get(d[2:], 0) + 1
    print(f"\nconstant non-split strata, 5 <= p < {pmax}: {len(rows)}"
          f" over {len(set(r[0] for r in rows))} primes")
    # cheapest description on each torus
    shape = {}
    sporadic = []
    for p, i, j, sgn, d, t in rows:
        ii, jj, k, n = d
        a = ("e", ii) if 1 + abs(ii) <= k else ("t", k)
        b = ("e", jj) if 1 + abs(jj) <= n else ("t", n)
        if i == j == (p + 1) // 2:
            a, b = ("half",), ("half",)
        key = (a, b)
        shape.setdefault(key, []).append((p, i, j, sgn))
        if a[0] == "e" and b[0] == "e" and (abs(ii) > 1 or abs(jj) > 1):
            sporadic.append((p, i, j, sgn, ii, jj))
    print("\nby cheapest description "
          "(('t',k): nu^i in mu_k · ('e',c): i == c · ('half',): i=j=(p+1)/2):")
    print("| nu-side | z-side | count | primes |")
    print("|---|---|---|---|")
    for key in sorted(shape, key=lambda x: -len(shape[x])):
        v = shape[key]
        ps = sorted({r[0] for r in v})
        s = ",".join(str(x) for x in ps[:6]) + ("..." if len(ps) > 6 else "")
        print(f"| {key[0]} | {key[1]} | {len(v)} | {s} |")
    print(f"\nfixed-exponent (both sides) strata: {len(sporadic)}")
    for r in sporadic:
        print(f"  p={r[0]} i={r[1]} j={r[2]} sign={r[3]:+d} "
              f"(i,j) reduced = ({r[4]},{r[5]})")
    if verbose:
        print("\nfull list (p, i, j, sign, (ii,jj,k,n)):")
        for r in rows:
            print(" ", r[:5])


# ---------------------------------------------------------------------------
# cmd: families
# ---------------------------------------------------------------------------

def ns_taus(p, chip):
    tt = np.arange(p, dtype=np.int64)
    return tt[chip[(tt * tt - 4) % p] == -1]


def dick_vec(j, taus, p):
    """D_j(tau,1) for a vector of taus."""
    a = np.full(len(taus), 2 % p, dtype=np.int64)
    b = taus % p
    for _ in range(j):
        a, b = b, (taus * b - a) % p
    return a


def ns_counts(i, j, p, chip, taus, dj=None):
    nu = (taus + 2) % p
    c = (np.array([pow(int(x), i, p) for x in nu], dtype=np.int64)
         - (dj if dj is not None else dick_vec(j, taus, p))) % p
    s = chip[(c * c - 4) % p]
    return int((s == 1).sum()), int((s == -1).sum())


def cmd_families(argv):
    from sympy import primerange
    pmax = int(argv[0]) if argv else 1200
    print("task 3: the non-split families")

    # (a) the correlation lemma
    bad = 0
    for p in primerange(5, 400):
        chip = chi_table(p)
        taus = ns_taus(p, chip)
        d = dick_vec((p + 1) // 2, taus, p)
        want = (2 * chip[(taus + 2) % p].astype(np.int64)) % p
        bad += int((d % p != want % p).sum())
    print(f"\n(a) correlation lemma  z^((p+1)/2) = chi(nu)  (i.e. "
          f"D_{{(p+1)/2}}(tau,1) = 2 chi(tau+2)):")
    print(f"    failures over all non-split tau, 5 <= p < 400 : {bad}")

    # (b) the two identically constant families
    b0 = bh = 0
    for p in primerange(5, pmax):
        chip = chi_table(p)
        taus = ns_taus(p, chip)
        cp, cm = ns_counts(0, 0, p, chip, taus)
        want = legendre(-3, p)
        if not ((cm == 0 and want == 1) or (cp == 0 and want == -1)):
            b0 += 1
        h = (p + 1) // 2
        cp, cm = ns_counts(h, h, p, chip, taus)
        if cp != 0 or cm == 0:
            bh += 1
    print(f"\n(b) identically constant families, 5 <= p < {pmax}:")
    print(f"    (i,j) = (0,0)          -> chi(-3) everywhere : {b0} failures")
    print(f"    (i,j) = ((p+1)/2, same) -> -1 everywhere     : {bh} failures")

    # (c) torus power-residue families, i = 0
    print(f"\n(c) i == 0 (mod p-1), z^m in mu_n: constant iff the non-zero part")
    print(f"    of W_n = {{(eta + eta^-1 - 1)^2 - 4}} lies in one square class")
    print("| n | primes p < %d with n | p+1 | constant | square-class | mismatch | members |"
          % pmax)
    print("|---|---|---|---|---|---|")
    for n in range(2, 13):
        tot = con = sqc = mis = 0
        mem = []
        for p in primerange(5, pmax):
            if (p + 1) % n or ((p + 1) // n) % 2:
                continue
            chip = chi_table(p)
            taus = ns_taus(p, chip)
            j = (p + 1) // n
            cp, cm = ns_counts(0, j, p, chip, taus)
            isc = (cp == 0) ^ (cm == 0) and cp + cm > 0
            W = set()
            dj = dick_vec(j, taus, p)
            for t in np.unique(dj):
                W.add(int((int(t) - 1) ** 2 - 4) % p)
            nz = {w for w in W if w}
            cls = {chip[w] for w in nz}
            issq = len(cls) == 1 and len(nz) > 0
            tot += 1
            con += isc
            sqc += issq
            mis += (isc != issq)
            if isc:
                mem.append(p)
        ms = ",".join(str(x) for x in mem[:6]) + ("..." if len(mem) > 6 else "")
        print(f"| {n} | {tot} | {con} | {sqc} | {mis} | {ms} |")

    # (d) dual families, j = 0
    print(f"\n(d) j == 0 (mod p+1), nu^m in mu_k: constant iff the non-zero part")
    print(f"    of U_k = {{xi(xi-4)}} lies in one square class")
    print("| k | primes | constant | square-class | mismatch | members |")
    print("|---|---|---|---|---|---|")
    for k in range(2, 13):
        tot = con = sqc = mis = 0
        mem = []
        for p in primerange(5, pmax):
            if (p - 1) % k:
                continue
            i = (p - 1) // k
            if i % 2:
                i *= 2
                if (p - 1) % (i) or ((p - 1) // gcd(i, p - 1)) != k:
                    continue
            chip = chi_table(p)
            taus = ns_taus(p, chip)
            cp, cm = ns_counts(i, 0, p, chip, taus)
            isc = (cp == 0) ^ (cm == 0) and cp + cm > 0
            nu = (taus + 2) % p
            U = {int(pow(int(x), i, p)) for x in nu}
            nz = {v * (v - 4) % p for v in U}
            nz = {w for w in nz if w}
            cls = {chip[w] for w in nz}
            issq = len(cls) == 1 and len(nz) > 0
            tot += 1
            con += isc
            sqc += issq
            mis += (isc != issq)
            if isc:
                mem.append(p)
        ms = ",".join(str(x) for x in mem[:6]) + ("..." if len(mem) > 6 else "")
        print(f"| {k} | {tot} | {con} | {sqc} | {mis} | {ms} |")


# ---------------------------------------------------------------------------
# cmd: weil  --  fixed-exponent families (ii,jj) closed by a Weil bound
# ---------------------------------------------------------------------------

def P_sym(ii, jj):
    """P_{ii,jj}(tau) in Z[tau], the fixed curve datum of the family."""
    from sympy import symbols, expand, Poly, QQ
    t = symbols("t")
    a, b = 2, t                              # D_0, D_1
    for _ in range(abs(jj)):
        a, b = b, expand(t * b - a)
    D = a
    if ii >= 0:
        P = expand(((t + 2) ** ii - D) ** 2 - 4)
    else:
        P = expand((1 - D * (t + 2) ** (-ii)) ** 2 - 4 * (t + 2) ** (-2 * ii))
    return Poly(P, t, domain=QQ), t


def sqfree_deg(poly, t):
    from sympy import Poly, QQ, factor_list
    if poly.is_zero:
        return 0, True, []
    _, facs = poly.factor_list()
    rad = Poly(1, t, domain=QQ)
    for f, e in facs:
        if e % 2:
            rad = rad * f
    return rad.degree(), rad.degree() == 0, rad


def cmd_weil(argv):
    from sympy import primerange, Poly, QQ, symbols
    W = int(argv[0]) if argv else 8
    print("task 3: fixed-exponent non-split families (i == ii mod p-1, "
          "j == jj mod p+1)")
    print("  |S_ns| <= ((D1-1) + (D2-1)) sqrt(p) / 2 + 1,  D1 = deg sqfree P,")
    print("  D2 = deg sqfree((tau^2-4) P); constancy needs (p-1)/2 - z <= that")
    print("| (ii,jj) | D1 | D2 | Weil bound on p | members |")
    print("|---|---|---|---|---|")
    t = symbols("t")
    for ii in range(-W, W + 1):
        for jj in range(0, W + 1):
            if (ii - jj) % 2:
                continue
            if (ii, jj) in ((0, 0), (1, 1)):
                continue
            P, t = P_sym(ii, jj)
            D1, triv1, rad1 = sqfree_deg(P, t)
            P2 = Poly((t ** 2 - 4), t, domain=QQ) * P
            D2, triv2, rad2 = sqfree_deg(P2, t)
            if P.is_zero or (triv1 and triv2):
                print(f"| ({ii},{jj}) | - | - | identically degenerate | all p |")
                continue
            z = P.degree()
            c = (D1 + D2 - 2) / 2.0
            # (p-1)/2 - z <= c sqrt p + 1  ->  solve
            bound = 5
            x = 5.0
            for _ in range(200):
                x = (2 * c * (x ** 0.5) + 2 * z + 3)
            bound = int(x) + 1
            mem = []
            for p in primerange(5, min(bound, 40000) + 1):
                if p - 1 <= 2 * abs(ii) or p + 1 <= 2 * abs(jj):
                    continue
                i = ii % (p - 1)
                j = jj % (p + 1)
                if (i - j) % 2:
                    continue
                chip = chi_table(p)
                taus = ns_taus(p, chip)
                cp, cm = ns_counts(i, j, p, chip, taus)
                if ((cp == 0) ^ (cm == 0)) and cp + cm > 0:
                    mem.append(p)
            ms = ",".join(str(x) for x in mem) if mem else "none"
            print(f"| ({ii},{jj}) | {D1} | {D2} | {bound} | {ms} |")


# ---------------------------------------------------------------------------
# cmd: mirror -- does the Fermat-cubic family have a torus mirror?
# ---------------------------------------------------------------------------

def cmd_mirror(argv):
    from sympy import primerange
    pmax = int(argv[0]) if argv else 600
    print("task 5: torus mirror of the lambda-line Fermat-cubic family")
    print("  lambda-line family: 3m == +-1 (mod p-1); members (17,6),(17,10),(47,30)")
    print("\n(a) the non-split census at the three lambda-line members:")
    for p, r in ((17, 6), (17, 10), (47, 30)):
        for m in (r // 2, r // 2 + (p - 1) // 2):
            i, j = m % (p - 1), m % (p + 1)
            chip = chi_table(p)
            taus = ns_taus(p, chip)
            cp, cm = ns_counts(i, j, p, chip, taus)
            kind = "CONSTANT" if ((cp == 0) ^ (cm == 0)) and cp + cm > 0 else \
                   ("collapse" if cp + cm == 0 else "generic")
            print(f"  p={p} r={r} m={m}: (i,j)=({i},{j}) N+={cp} N-={cm} "
                  f"[{kind}]")
    print("\n(b) constant non-split strata with 3j == +-1 (mod p+1)"
          f" (the z-side mirror), 5 <= p < {pmax}:")
    hits = []
    for p in primerange(5, pmax):
        if (p + 1) % 3 == 0:
            continue
        chip = chi_table(p)
        taus = ns_taus(p, chip)
        for sgn in (1, -1):
            j = (sgn * pow(3, -1, p + 1)) % (p + 1)
            dj = dick_vec(j, taus, p)
            for i in range(p - 1):
                if (i - j) % 2:
                    continue
                cp, cm = ns_counts(i, j, p, chip, taus, dj)
                if ((cp == 0) ^ (cm == 0)) and cp + cm > 0:
                    hits.append((p, i, j, sgn))
    print(f"  hits: {len(hits)}")
    for h in hits[:20]:
        print("   ", h)
    print("\n(c) constant non-split strata with 3m == +-1 (mod L) "
          "(the joint mirror):")
    hits2 = []
    for p in primerange(5, pmax):
        L = lcm(p - 1, p + 1)
        if gcd(3, L) != 1:
            continue
        chip = chi_table(p)
        taus = ns_taus(p, chip)
        for sgn in (1, -1):
            m = (sgn * pow(3, -1, L)) % L
            i, j = m % (p - 1), m % (p + 1)
            cp, cm = ns_counts(i, j, p, chip, taus)
            if ((cp == 0) ^ (cm == 0)) and cp + cm > 0:
                hits2.append((p, m, i, j, sgn))
    print(f"  hits: {len(hits2)}")
    for h in hits2[:20]:
        print("   ", h)


# ---------------------------------------------------------------------------
# cmd: powq -- the 4-set coloring on P^1(F_q) for prime powers q (task 4)
# ---------------------------------------------------------------------------

def build_Fq(p, k):
    """F_q = F_p[x]/(f), elements encoded base p.  Returns tables."""
    q = p ** k
    if k == 1:
        mul_red = None
    # find a monic irreducible f of degree k by brute force over its roots
    def polymul(a, b, f):
        # a, b: coefficient lists length k
        res = [0] * (2 * k - 1)
        for i, ai in enumerate(a):
            if ai:
                for j, bj in enumerate(b):
                    res[i + j] = (res[i + j] + ai * bj) % p
        for d in range(2 * k - 2, k - 1, -1):
            c = res[d]
            if c:
                res[d] = 0
                for i in range(k):
                    res[d - k + i] = (res[d - k + i] - c * f[i]) % p
        return res[:k]

    def enc(a):
        v = 0
        for i in reversed(range(k)):
            v = v * p + a[i]
        return v

    def dec(v):
        a = []
        for _ in range(k):
            a.append(v % p)
            v //= p
        return a

    from sympy import factorint
    fac = factorint(q - 1)
    for fint in range(p ** k):
        f = dec(fint)                       # x^k = -(f_0 + ... )  -> f coeffs
        # test irreducibility by checking x^k - sum has no factorisation:
        # cheaper: test that some element has order q-1 with this modulus
        # first quick check: the polynomial x^k + f_{k-1}x^{k-1}+...+f_0
        # must have no root when k <= 3 and be irreducible in general.
        ok = True
        if k >= 2:
            for a0 in range(p):
                v = 0
                for i in reversed(range(k)):
                    v = (v * a0 + (1 if i == k - 1 and False else 0)) % p
                # evaluate x^k + sum f_i x^i at a0
                val = pow(a0, k, p)
                for i in range(k):
                    val = (val + f[i] * pow(a0, i, p)) % p
                if val == 0:
                    ok = False
                    break
        if not ok:
            continue
        fneg = [(-c) % p for c in f]        # x^k = fneg . (1,x,..,x^{k-1})
        # try to find a generator
        gen = None
        for gi in range(1, q):
            a = dec(gi)
            good = True
            for qq in fac:
                # a^((q-1)/qq) != 1
                e = (q - 1) // qq
                r = [1] + [0] * (k - 1)
                b = a[:]
                ee = e
                while ee:
                    if ee & 1:
                        r = polymul(r, b, f)
                    b = polymul(b, b, f)
                    ee >>= 1
                if r == [1] + [0] * (k - 1):
                    good = False
                    break
            if good:
                # confirm order exactly q-1
                gen = a
                break
        if gen is None:
            continue
        expv = np.zeros(q - 1, dtype=np.int64)
        logv = np.full(q, -1, dtype=np.int64)
        x = [1] + [0] * (k - 1)
        for e in range(q - 1):
            v = enc(x)
            expv[e] = v
            logv[v] = e
            x = polymul(x, gen, f)
        if enc(x) != 1:
            continue
        return q, expv, logv
    raise RuntimeError("no field")


def cmd_powq(argv):
    from sympy import primerange
    qmax = int(argv[0]) if argv else 1100
    print("task 4: constant 4-set colorings on P^1(F_q) for prime powers q")
    print("  the coloring is chi_q(Phi_{2m,4}(lambda)), lambda the cross-ratio,")
    print("  so it is the lambda-line census over F_q; r = 2m mod (q-1)")
    print("| q | p^k | constant r | tags |")
    print("|---|---|---|---|")
    for p in primerange(3, 60):
        for k in (2, 3, 4):
            q = p ** k
            if q > qmax or k == 1:
                continue
            qq, expv, logv = build_Fq(p, k)
            # coefficient decomposition for addition
            co = np.stack([(np.arange(q) // p ** i) % p for i in range(k)])
            def add(a, b):
                c = (co[:, a] + co[:, b]) % p
                return (c * (p ** np.arange(k))[:, None]).sum(axis=0)
            def neg(a):
                c = (-co[:, a]) % p
                return (c * (p ** np.arange(k))[:, None]).sum(axis=0)
            lam = np.array([v for v in range(q) if v not in (0, 1)],
                           dtype=np.int64)
            one = np.ones(len(lam), dtype=np.int64)
            omlam = add(one, neg(lam))       # 1 - lambda
            la, lb = logv[lam], logv[omlam]
            rows = []
            strict = []
            for r in range(0, q - 1, 2):
                X = expv[(r * la) % (q - 1)]
                Y = expv[(r * lb) % (q - 1)]
                W = add(one, neg(add(X, Y)))          # 1 - X - Y
                lw = logv[W]
                W2 = np.where(lw < 0, 0, expv[(2 * np.maximum(lw, 0)) % (q - 1)])
                XY = expv[(la * r + lb * r) % (q - 1)]
                four = 4 % p
                f4 = np.full(len(lam), four, dtype=np.int64)
                XY4 = expv[(logv[f4] + logv[XY]) % (q - 1)] if four else \
                    np.zeros(len(lam), dtype=np.int64)
                G = add(W2, neg(XY4))
                lg = logv[G]
                s = np.where(lg < 0, 0, 1 - 2 * (np.maximum(lg, 0) % 2))
                np_, nm = int((s == 1).sum()), int((s == -1).sum())
                nz = len(lam) - np_ - nm
                if ((np_ == 0) ^ (nm == 0)) and np_ + nm > 0:
                    rows.append((r, 1 if nm == 0 else -1))
                    if nz == 0:
                        strict.append(r)
                elif np_ == nm == 0:
                    strict.append(r)
            tags = []
            for r, sgn in rows:
                n = (q - 1) // gcd(r, q - 1) if r else 1
                c = r if r <= (q - 1) // 2 else r - (q - 1)
                frob = [i for i in range(k) if (2 * p ** i - r) % (q - 1) == 0]
                tg = f"r={r}({sgn:+d})"
                if r == 0:
                    tg += " A"
                elif frob:
                    tg += f" Frob(2p^{frob[0]})"
                if n <= 12:
                    tg += f" mu_{n}"
                if abs(c) <= 8 and r not in (0,):
                    tg += f" c={c}"
                if k == 2 and r == p + 1:
                    tg += " Baer"
                # platform (kk,cc) reduction cost on the lambda-line
                best = None
                for kk in range(1, 13):
                    cc = (kk * r // 2 if r % 2 == 0 else 0) % (q - 1)
                    cc = cc if cc <= (q - 1) // 2 else cc - (q - 1)
                    cost = kk * (1 + abs(cc))
                    if best is None or cost < best[0]:
                        best = (cost, kk, cc)
                tg += f" [{best[1]},{best[2]}]"
                tags.append(tg)
            print(f"| {q} | {p}^{k} | {len(rows)} | strict={strict} | "
                  f"{'; '.join(tags)} |")


# ---------------------------------------------------------------------------
# cmd: ergodis
# ---------------------------------------------------------------------------

def reduce_mod_frob(coeffs, p):
    """reduce a polynomial mod (x^p - x): fold exponents e >= p to
       1 + (e-1) mod (p-1)."""
    out = [0] * p
    for e, c in enumerate(coeffs):
        c %= p
        if not c:
            continue
        ee = e if e < p else 1 + (e - 1) % (p - 1)
        out[ee] = (out[ee] + c) % p
    while len(out) > 1 and out[-1] == 0:
        out.pop()
    return out


def cmd_ergodis(argv):
    import subprocess
    from sympy import symbols, expand, Poly, QQ, primerange
    t = symbols("t")
    print("independent-engine check: S1 and S2 on the Ergodis kernel")
    print("  S1 = sum_tau chi(P_m(tau)),  S2 = sum_tau chi((tau^2-4) P_m(tau))")
    reqs, want = [], []
    for p in list(primerange(5, 60)):
        for m in range(2, 9):
            a, b = 2, t
            for _ in range(m):
                a, b = b, expand(t * b - a)
            P = expand(((t + 2) ** m - a) ** 2 - 4)
            c1 = Poly(P, t, domain=QQ).all_coeffs()[::-1]
            c2 = Poly(expand((t ** 2 - 4) * P), t, domain=QQ).all_coeffs()[::-1]
            r1 = reduce_mod_frob([int(x) for x in c1], p)
            r2 = reduce_mod_frob([int(x) for x in c2], p)
            s1, s2, _ = u_censuses(m, p)
            reqs.append("census s1_%d_%d %d %s" % (p, m, p,
                                                   " ".join(map(str, r1))))
            reqs.append("census s2_%d_%d %d %s" % (p, m, p,
                                                   " ".join(map(str, r2))))
            want += [s1, s2]
    proc = subprocess.run([ERGODIS], input="\n".join(reqs),
                          capture_output=True, text=True)
    if proc.returncode:
        print("ergodis failed:", proc.stderr[:400])
        return
    import json
    got = [json.loads(ln)["sum"] for ln in proc.stdout.strip().split("\n")]
    bad = sum(1 for a, b in zip(got, want) if a != b)
    print(f"\nrequests: {len(reqs)}  (m = 2..8, 5 <= p < 60)")
    print(f"disagreements with the Python census: {bad}")


COMMANDS = {
    "ergodis": cmd_ergodis,
    "coords": cmd_coords,
    "master": cmd_master,
    "collapse": cmd_collapse,
    "period": cmd_period,
    "sweep": cmd_sweep,
    "families": cmd_families,
    "weil": cmd_weil,
    "mirror": cmd_mirror,
    "powq": cmd_powq,
}


def main():
    if len(sys.argv) < 2 or sys.argv[1] not in COMMANDS:
        print(__doc__)
        return 1
    COMMANDS[sys.argv[1]](sys.argv[2:])
    return 0


if __name__ == "__main__":
    sys.exit(main())
