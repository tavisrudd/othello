#!/usr/bin/env python3
"""C1014 -- derivation of the finite-field stratification of the Phi_{2m,4}
census from the power-map (Dickson) pullback structure.

All statements in the companion report
`notes/2026-08-30-c1014-dickson-strata-derivation.md` that are marked
"verified-exact" are produced by one of the subcommands below.

Replay (from the repository root):

    uv run --with sympy --with numpy python3 \
        notes/clebsch-tasks/c1014_dickson_strata.py <subcommand> [args]

Subcommands
    periodicity [PMAX]        task 1  census depends only on r = 2m mod (p-1)
    master [PMAX]             task 2  Jacobi/Plancherel master formula, exact
    scan PMAX                 task 3  exhaustive constant-character strata
    cells [NMAX] [PMAX]       task 3  power-residue (c = 0) strata value sets
    fixedm [CMAX]             task 3  fixed-exponent families m = c (mod p-1)
    fermat                    task 4  the (k,c) = (3,-1) Fermat-cubic stratum
    p47                       task 4  settlement of (p,r) = (47,30)
    uline [PMAX]              bonus   period lcm(p-1,p+1) of the u-line census
    ergodis                   cross-check censuses on the ergodis kernel

Runs behind the numbers in the report:
    periodicity 120 | master 200 | scan 4000 | cells 12 1200 | fixedm 9
    | fermat | p47 | uline 24 | ergodis
"""

import json
import subprocess
import sys
from math import gcd

ERGODIS = "/home/tavis/.cache/ergodis/c1013-census-target/release/c1013-census"


# --------------------------------------------------------------------------
# basic arithmetic
# --------------------------------------------------------------------------

def legendre(a, p):
    a %= p
    if a == 0:
        return 0
    return 1 if pow(a, (p - 1) // 2, p) == 1 else -1


def G(lam, r, p):
    """G_r(lambda) = (1 - X - Y)^2 - 4 X Y with X = lam^r, Y = (1-lam)^r.

    Proposition 1 of the report: u^2 Phi_{2m,4}(lam) = G_{2m}(lam) identically.
    """
    X = pow(lam % p, r, p)
    Y = pow((1 - lam) % p, r, p)
    return ((1 - X - Y) ** 2 - 4 * X * Y) % p


def census(r, p):
    """(N+, N-, N0) of chi(G_r) over F_p minus {0,1}."""
    npos = nneg = nzero = 0
    for lam in range(2, p):
        s = legendre(G(lam, r, p), p)
        if s == 1:
            npos += 1
        elif s == -1:
            nneg += 1
        else:
            nzero += 1
    return npos, nneg, nzero


def phi_census(m, p):
    """(N+, N-, N0) of chi(Phi_{2m,4}) over F_p minus {0,1}, computed from the
    four Fermat factors 1 + eps lam^m + eta (1-lam)^m directly (no G_r)."""
    npos = nneg = nzero = 0
    for lam in range(2, p):
        x = pow(lam, m, p)
        y = pow((1 - lam) % p, m, p)
        prod = 1
        for e in (1, -1):
            for f in (1, -1):
                prod = prod * ((1 + e * x + f * y) % p) % p
        s = legendre(prod, p)
        if s == 1:
            npos += 1
        elif s == -1:
            nneg += 1
        else:
            nzero += 1
    return npos, nneg, nzero


def fermat_coloring(m, p):
    """Distribution of the 16-stratum coloring by the four Fermat factors."""
    from collections import Counter
    c = Counter()
    for lam in range(2, p):
        x = pow(lam, m, p)
        y = pow((1 - lam) % p, m, p)
        key = tuple(legendre(1 + e * x + f * y, p)
                    for e in (1, -1) for f in (1, -1))
        c[key] += 1
    return dict(c)


# --------------------------------------------------------------------------
# task 1 -- periodicity
# --------------------------------------------------------------------------

def cmd_periodicity(argv):
    from sympy import primerange
    pmax = int(argv[0]) if argv else 120
    bad_phi = bad_col = 0
    checked_phi = checked_col = 0
    print("task 1: periodicity of the census in the exponent")
    print()
    print("(a) chi(Phi_{2m,4}) census: equal whenever 2m agrees mod (p-1)?")
    for p in primerange(5, pmax):
        base = {}
        for m in range(1, 3 * p):
            r = (2 * m) % (p - 1)
            c = phi_census(m, p)
            g = census(r, p)
            checked_phi += 1
            if g != c:
                bad_phi += 1
                print("   PHI != G_r at", (m, p), c, g)
            if r in base:
                if base[r] != c:
                    bad_phi += 1
                    print("   period failure at", (m, p))
            else:
                base[r] = c
    print(f"   pairs checked = {checked_phi}, failures = {bad_phi}")
    print()
    print("(b) 16-stratum Fermat coloring: period (p-1) in m, not (p-1)/2?")
    same_half = 0
    for p in primerange(5, min(pmax, 60)):
        for m in range(2, 8):
            a = fermat_coloring(m, p)
            b = fermat_coloring(m + (p - 1) // 2, p)
            c = fermat_coloring(m + (p - 1), p)
            checked_col += 1
            if a != c:
                bad_col += 1
                print("   coloring period (p-1) failure at", (m, p))
            if a == b:
                same_half += 1
    print(f"   pairs checked = {checked_col}, period-(p-1) failures = {bad_col},"
          f" coincidences at the half shift = {same_half}")
    return bad_phi + bad_col


# --------------------------------------------------------------------------
# task 2 -- master formula
# --------------------------------------------------------------------------

def master_formula(r, p):
    """Master character-sum formula.

    Let N = p-1, d = gcd(r,N), e = N/d, H = {lam^r} the subgroup of order e.
    Write theta_t (t in Z/e) for the characters of F_p^* of order dividing e,
    theta_t(g^i) = zeta_e^{t i}, and alpha_t(X) = theta_t(lam) for any lam with
    lam^r = X (well defined).  Then

        S(r,p) = (1/e^2) sum_{t1,t2 in Z/e} J(theta_t1, theta_t2) K(t1,t2),
        K(t1,t2) = sum_{X,Y in H} chi(F(X,Y)) conj(alpha_t1(X) alpha_t2(Y)),
        J(A,B)   = sum_{lam != 0,1} A(lam) B(1-lam)   (a Jacobi sum).

    Returns (S_direct, S_formula, e, matrix of |J| for reference).
    """
    import numpy as np
    from sympy import primitive_root
    N = p - 1
    d = N if r % N == 0 else gcd(r, N)
    e = N // d
    rp = (r // d) % e if e > 1 else 0          # r' = r/d, a unit mod e
    g = primitive_root(p)
    powg = [1] * N
    for i in range(1, N):
        powg[i] = powg[i - 1] * g % p
    ind = [0] * p
    for i in range(N):
        ind[powg[i]] = i

    # coordinate on H: s(lam) = r' ind(lam) mod e, so lam^r = g^{d s(lam)}.
    A = np.zeros((e, e))
    for s1 in range(e):
        X = powg[(d * s1) % N]
        for s2 in range(e):
            Y = powg[(d * s2) % N]
            A[s1, s2] = legendre(((1 - X - Y) ** 2 - 4 * X * Y) % p, p)
    H2 = np.zeros((e, e))
    for lam in range(2, p):
        s1 = (rp * ind[lam]) % e
        s2 = (rp * ind[(1 - lam) % p]) % e
        H2[s1, s2] += 1
    # fft2(H2)[t] = sum_lam theta_{-r' t1}(lam) theta_{-r' t2}(1-lam)
    #             = J(theta_{-r' t1}, theta_{-r' t2}),  a Jacobi sum.
    Jm = np.fft.fft2(H2)
    Km = np.fft.fft2(A)
    S_formula = float(np.real((Jm * np.conj(Km)).sum())) / (e * e)
    npos, nneg, _ = census(r, p)
    return npos - nneg, S_formula, e


def cmd_master(argv):
    from sympy import primerange
    pmax = int(argv[0]) if argv else 200
    worst = 0.0
    checked = 0
    fails = []
    for p in primerange(5, pmax):
        for m in range(2, 9):
            r = (2 * m) % (p - 1)
            direct, formula, e = master_formula(r, p)
            checked += 1
            err = abs(direct - formula)
            worst = max(worst, err)
            if err > 1e-6:
                fails.append((m, p, direct, formula))
    print("task 2: master formula  S = (1/e^2) sum J(theta,theta') K(theta,theta')")
    print(f"   (m,p) pairs checked = {checked}   (m = 2..8, odd p < {pmax})")
    print(f"   worst |direct - formula| = {worst:.3e}")
    print(f"   failures = {len(fails)} {fails[:5]}")
    print()
    print("   independent check that the transform entries really are Jacobi")
    print("   sums (definition sum_lam theta1(lam) theta2(1-lam)) and that they")
    print("   obey the classical evaluation:")
    print("   | p | r | e | max |J_fft - J_def| | max ||J| - sqrt p| over the"
          " nondegenerate pairs |")
    print("   |---|---|---|---|---|")
    for (p, r) in [(13, 4), (31, 10), (41, 8), (61, 12), (47, 30)]:
        a, b = jacobi_check(r, p)
        N = p - 1
        e = N // (N if r % N == 0 else gcd(r, N))
        print(f"   | {p} | {r} | {e} | {a:.2e} | {b:.2e} |")
    return len(fails)


def jacobi_check(r, p):
    """Compare the DFT entries of the master formula with Jacobi sums computed
    from the definition, and test |J| = sqrt(p) off the degenerate locus."""
    import numpy as np
    from sympy import primitive_root
    N = p - 1
    d = N if r % N == 0 else gcd(r, N)
    e = N // d
    rp = (r // d) % e if e > 1 else 0
    g = primitive_root(p)
    powg = [1] * N
    for i in range(1, N):
        powg[i] = powg[i - 1] * g % p
    ind = [0] * p
    for i in range(N):
        ind[powg[i]] = i
    H2 = np.zeros((e, e))
    for lam in range(2, p):
        H2[(rp * ind[lam]) % e, (rp * ind[(1 - lam) % p]) % e] += 1
    Jm = np.fft.fft2(H2)
    worst_def = 0.0
    worst_abs = 0.0
    for t1 in range(e):
        for t2 in range(e):
            u1 = (-rp * t1) % e
            u2 = (-rp * t2) % e
            acc = 0j
            for lam in range(2, p):
                acc += np.exp(2j * np.pi * (u1 * ind[lam]
                                            + u2 * ind[(1 - lam) % p]) / e)
            worst_def = max(worst_def, abs(acc - Jm[t1, t2]))
            if u1 % e and u2 % e and (u1 + u2) % e:
                worst_abs = max(worst_abs, abs(abs(acc) - p ** 0.5))
    return worst_def, worst_abs


# --------------------------------------------------------------------------
# task 3 -- exhaustive scan of constant-character strata
# --------------------------------------------------------------------------

def scan_prime(p):
    """All even r in [0,p-2) whose chi(G_r) census is constant on the
    non-vanishing locus.  Returns list of (r, npos, nneg, nzero)."""
    import numpy as np
    from sympy import primitive_root
    n = p - 1
    g = primitive_root(p)
    powg = np.empty(n, dtype=np.int64)
    x = 1
    for i in range(n):
        powg[i] = x
        x = x * g % p
    ind = np.zeros(p, dtype=np.int64)
    for i in range(n):
        ind[powg[i]] = i
    leg = np.zeros(p, dtype=np.int64)
    for a in range(1, p):
        leg[a] = 1 if pow(a, n // 2, p) == 1 else -1
    lam = np.arange(2, p, dtype=np.int64)
    il = ind[lam]
    io = ind[(1 - lam) % p]
    out = []
    for r in range(0, n, 2):
        X = powg[(r * il) % n]
        Y = powg[(r * io) % n]
        v = leg[((1 - X - Y) ** 2 - 4 * X * Y) % p]
        npos = int((v == 1).sum())
        nneg = int((v == -1).sum())
        nz = int((v == 0).sum())
        if npos == 0 or nneg == 0:
            out.append((r, npos, nneg, nz))
    return out


def kc_reduce(m, N, kmax=None):
    """Minimal (k,c) with k*m == c (mod N), |c| <= N/2, ordered by k*(1+|c|)."""
    if kmax is None:
        kmax = N
    best = None
    for k in range(1, kmax + 1):
        c = (k * m) % N
        if c > N // 2:
            c -= N
        key = (k * (1 + abs(c)), k, abs(c))
        if best is None or key < best[0]:
            best = (key, k, c)
        if best[0][0] <= k:            # cannot be beaten by larger k
            break
    return best[1], best[2]


def tag(p, r):
    """Best (k,c) reduction over both lifts m of r/2 modulo (p-1)."""
    N = p - 1
    lifts = [m for m in (r // 2, r // 2 + N // 2) if (2 * m - r) % N == 0]
    best = None
    for m in lifts:
        k, c = kc_reduce(m % N, N)
        key = (k * (1 + abs(c)), k, abs(c))
        if best is None or key < best[0]:
            best = (key, k, c, m % N)
    return best[1], best[2], best[3]


def cmd_scan(argv):
    from sympy import primerange
    from collections import defaultdict
    pmax = int(argv[0]) if argv else 500
    tally = defaultdict(list)
    for p in primerange(5, pmax):
        for (r, npos, nneg, nz) in scan_prime(p):
            k, c, m = tag(p, r)
            tally[(k, c)].append((p, r, m, npos, nneg, nz))
    print(f"task 3: complete constant-character enumeration, 5 <= p < {pmax}")
    print("        every even r in [0,p-2] tested at every p (exhaustive)")
    print()
    print("| (k,c) | count | shape of m | first members (p, r) |")
    print("|-------|-------|------------|----------------------|")
    for key in sorted(tally, key=lambda t: (t[0], abs(t[1]), t[1])):
        v = tally[key]
        shape = describe(key, v[0])
        first = ", ".join(f"({a},{b})" for a, b, *_ in v[:3])
        print(f"| ({key[0]},{key[1]}) | {len(v)} | {shape} | {first} |")
    print()
    for key in sorted(tally, key=lambda t: (t[0], abs(t[1]), t[1])):
        if len(tally[key]) <= 4:
            print(f"   full list for (k,c)={key}: "
                  f"{[(a,b) for a,b,*_ in tally[key]]}")
    return 0


def describe(key, sample):
    k, c = key
    if c == 0:
        return f"lam^m in mu_{k}"
    if abs(c) == 1:
        return f"k*m = {c:+d}: Fermat curve x^{k}+y^{k}=1" if c == 1 else \
               f"k*m = {c:+d}: reciprocal Fermat x^-{k}+y^-{k}=1"
    return f"k*m = {c:+d} (mod p-1)"


# --------------------------------------------------------------------------
# task 3 -- power-residue (c = 0) strata: the value sets Q(zeta^a, zeta^b)
# --------------------------------------------------------------------------

def Qval(x, y, p):
    return ((1 - (x + y) ** 2) * (1 - (x - y) ** 2)) % p


def mu_values(n, p):
    """Set of values Q(zeta^a, zeta^b), zeta of order n in F_p^*."""
    from sympy import primitive_root
    N = p - 1
    assert N % n == 0
    g = primitive_root(p)
    z = pow(g, N // n, p)
    vals = set()
    for a in range(n):
        for b in range(n):
            vals.add(Qval(pow(z, a, p), pow(z, b, p), p))
    return vals


def symbolic_values(n):
    """The fixed set V_n = { Q(zeta^a, zeta^b) } in Z[zeta_n], as algebraic
    numbers.  Independent of p; the mod-p value set is its reduction."""
    import sympy as sp
    z = sp.exp(2 * sp.pi * sp.I / n)
    V = set()
    for a in range(n):
        for b in range(n):
            v = sp.expand((1 - (z ** a + z ** b) ** 2) * (1 - (z ** a - z ** b) ** 2))
            V.add(sp.nsimplify(sp.radsimp(sp.simplify(v))))
    return sorted(V, key=str)


def cmd_cells(argv):
    from sympy import primerange
    nmax = int(argv[0]) if argv else 12
    pmax = int(argv[1]) if len(argv) > 1 else 2000
    print("task 3: power-residue strata (c = 0, lam^m in mu_n)")
    print("        census = sum_{a,b} M_n(a,b) chi(Q(zeta^a, zeta^b)),")
    print("        M_n = cyclotomic numbers of order n (all > 0 once p >> n^4).")
    print("        Constancy <=> the fixed set V_n lies in one square class.")
    print()
    for n in (1, 2, 3, 4, 6, 8):
        print(f"   V_{n} = {symbolic_values(n)}")
    for n in (5, 7, 9):
        print(f"   |V_{n}| = {len(symbolic_values(n))} (printed form unwieldy;"
              f" no square-class collapse occurs, see the table)")
    print()
    print(f"| n | primes p<{pmax} with n | (p-1) | V_n in one square class |"
          " first such p | biconditional against the census |")
    print("|---|---|---|---|---|")
    for n in range(1, nmax + 1):
        avail = 0
        good = []
        agree = mismatch = 0
        bad = []
        for p in primerange(5, pmax):
            if (p - 1) % n:
                continue
            avail += 1
            vals = [v for v in mu_values(n, p) if v]
            one = len({legendre(v, p) for v in vals}) == 1 if vals else True
            if one:
                good.append(p)
            m = (p - 1) // n
            r = (2 * m) % (p - 1)
            npos, nneg, _ = census(r, p)
            const = (npos == 0 or nneg == 0)
            if const == one:
                agree += 1
            else:
                mismatch += 1
                bad.append((p, one, const))
        print(f"| {n} | {avail} | {len(good)} | {good[:4]} |"
              f" {agree} agree, {mismatch} differ {bad[:3]} |")
    return 0


# --------------------------------------------------------------------------
# task 4 -- the Fermat-cubic stratum and (47,30)
# --------------------------------------------------------------------------

def cmd_fermat(argv):
    import sympy as sp
    print("task 4: the (k,c) = (3,-1) stratum -- pullback along the Fermat cubic")
    print()
    xi, eta, lam = sp.symbols("xi eta lam")

    # (a) the reduction identity, symbolically over QQ(lam):
    #     with x = lam^m, 3m = -1 mod (p-1) we get xi = 1/x with xi^3 = lam.
    #     Q(x,y) = prod (1 + eps x + eta y) and, on xi^3 + eta^3 = 1,
    #     chi(Q) = chi( prod (xi eta + eps xi + eta' eta) ).
    Qx = sp.expand((1 - (1 / xi + 1 / eta) ** 2) * (1 - (1 / xi - 1 / eta) ** 2))
    P = sp.expand((xi * eta + xi + eta) * (xi * eta - xi - eta)
                  * (xi * eta + xi - eta) * (xi * eta - xi + eta))
    print("   identity  Q(1/xi,1/eta) * (xi eta)^4 == prod(xi eta +- xi +- eta):",
          sp.simplify(sp.together(Qx * (xi * eta) ** 4 - P)) == 0)
    e1, e2 = sp.symbols("e1 e2")
    Psym = sp.expand((e2 ** 2 - e1 ** 2) * (e2 ** 2 - e1 ** 2 + 4 * e2))
    check = sp.simplify(sp.expand(Psym.subs({e1: xi + eta, e2: xi * eta})) - P)
    print("   identity  prod = (e2^2-e1^2)(e2^2-e1^2+4e2),  e1=xi+eta, e2=xi eta:",
          check == 0)

    # (b) genus of the double cover w^2 = P over the Fermat cubic
    F = xi ** 3 + eta ** 3 - 1
    sextics = []
    for a in (1, -1):
        for b in (1, -1):
            q = xi * eta + a * xi + b * eta
            res = sp.Poly(sp.resultant(F, q, eta), xi)
            sextics.append(((a, b), res))
    print()
    print("   zero divisor of P on the Fermat cubic (resultants in xi):")
    tot = 0
    for (ab, res) in sextics:
        sqfree = sp.gcd(res, res.diff(xi)).degree() == 0
        print(f"     conic {ab}: degree {res.degree()}, squarefree = {sqfree}")
        tot += res.degree()
    pair_coprime = True
    for i in range(4):
        for j in range(i + 1, 4):
            if sp.gcd(sextics[i][1], sextics[j][1]).degree() != 0:
                pair_coprime = False
    print(f"     total zeros (with multiplicity) = {tot},"
          f" the four sextics pairwise coprime = {pair_coprime}")
    gGamma = 1
    B = tot                       # simple zeros; poles have even order 8
    gD = 2 * gGamma - 1 + B // 2
    print(f"   poles: P = N/Z^8 with the line Z=0 meeting the cubic in 3 simple")
    print(f"          points, so every pole has even order 8 -- unramified.")
    print(f"   Riemann-Hurwitz: 2 g_D - 2 = 2(2 g_Gamma - 2) + B"
          f"  =>  g_D = {gD}")

    # (b') primes where the zero divisor could fail to stay reduced: only there
    # can P become a constant times a square on the reduced curve.
    bad = set([2, 3])
    for (_, res) in sextics:
        bad |= set(sp.factorint(sp.Integer(sp.discriminant(res.as_expr(), xi))))
    for i in range(4):
        for j in range(i + 1, 4):
            rr = sp.resultant(sextics[i][1].as_expr(), sextics[j][1].as_expr(), xi)
            bad |= set(sp.factorint(sp.Integer(rr)))
    bad = {q for q in bad if q > 1}
    print(f"   primes where the 24 zeros can collide (discriminants and pairwise"
          f" resultants): {sorted(bad)}")

    # (c) Weil bound  =>  explicit finiteness of the stratum
    import math
    # |sum| <= (2 g_D + 2 g_Gamma) sqrt(p) + (#branch + #poles + 1);
    # constancy forces |sum| = p - 2 - z with z <= B.
    lin = 2 * gD + 2 * gGamma
    slack = B + 3 + 1
    a_, b_, c_ = 1.0, -float(lin), -(2 + B + slack)
    root = (-b_ + math.sqrt(b_ * b_ - 4 * a_ * c_)) / 2
    bound = root ** 2
    print(f"   Weil:  p - 2 - z <= {lin} sqrt(p) + {slack}  with z <= {B}")
    print(f"          => sqrt(p) <= {root:.3f}, p <= {bound:.1f}")

    # (d) exhaustive check of the family below the bound
    from sympy import primerange
    members = []
    for p in primerange(5, int(bound) + 200):
        N = p - 1
        if gcd(3, N) != 1:
            continue
        inv3 = pow(3, -1, N)
        for c in (1, -1):
            m = (c * inv3) % N
            r = (2 * m) % N
            npos, nneg, nz = census(r, p)
            if (npos == 0 or nneg == 0) and not (npos == 0 and nneg == 0):
                members.append((p, r, c, npos, nneg, nz))
    print()
    print(f"   exhaustive check of 3m = +-1 (mod p-1) for every p < "
          f"{int(bound)+200} with p = 2 mod 3:")
    for row in members:
        print(f"     p={row[0]:4d} r={row[1]:4d} 3m={row[2]:+d}  "
              f"(N+,N-,N0)=({row[3]},{row[4]},{row[5]})")
    print(f"   members = {len(members)}; the Weil bound closes the family at "
          f"p <= {bound:.0f}, so this list is complete.")
    over = sorted(q for q in bad if q > bound)
    print(f"   bad primes above the Weil bound (where the genus argument needs a"
          f" separate word): {over}")
    for q in over:
        print(f"     p = {q}: p mod 3 = {q % 3}; 3m = +-1 (mod p-1) solvable = "
              f"{gcd(3, q-1) == 1}")
    return 0


def square_class_poly(c):
    """Polynomial representative of the square class of G_{2c}(lam) over Q(lam),
    for the fixed exponent m = c (c may be negative: multiply out the poles).
    Returns (squarefree part, its degree, genus of y^2 = it)."""
    import sympy as sp
    lam = sp.symbols("lam")
    a = 2 * abs(c)                      # m = c, so the exponent in G_r is r = 2m
    X = lam ** a if c >= 0 else 1 / lam ** a
    Y = (1 - lam) ** a if c >= 0 else 1 / (1 - lam) ** a
    Gc = sp.together(sp.expand((1 - X - Y) ** 2 - 4 * X * Y))
    num, den = sp.fraction(Gc)
    # square class: numerator times denominator (denominator^2 is a square)
    f = sp.Poly(sp.expand(num * den), lam)
    sf = sp.Poly(1, lam)
    for fac, mult in sp.factor_list(f.as_expr(), lam)[1]:
        if mult % 2:
            sf = sf * sp.Poly(fac, lam)
    D = sf.degree()
    g = (D - 1) // 2 if D % 2 else (D - 2) // 2
    return sf, D, max(g, 0)


def cmd_fixedm(argv):
    """Fixed-exponent families m = c (mod p-1): the census is the Frobenius
    trace on ONE curve over Q, so Weil closes each family."""
    import math
    import sympy as sp
    from sympy import primerange
    lam = sp.symbols("lam")
    cmax = int(argv[0]) if argv else 10
    print("task 3/5: fixed-exponent families  m = c (mod p-1)")
    print("   Here lam^m = lam^c identically, so the census is the Frobenius")
    print("   trace on the single curve y^2 = sqcl(G_{2c}) defined over Q.")
    print()
    print("| c | deg sqcl | genus | Weil bound on p | members found | bad primes"
          " above the bound |")
    print("|---|---|---|---|---|---|")
    for c in list(range(-cmax, 0)) + list(range(2, cmax + 1)):
        sf, D, g = square_class_poly(c)
        lin = 2 * g
        slack = D + 2
        a_, b_, c_ = 1.0, -float(lin), -(2 + D + slack)
        root = (-b_ + math.sqrt(b_ * b_ - 4 * a_ * c_)) / 2
        bound = root ** 2
        members = []
        for p in primerange(5, int(bound) + 2):
            N = p - 1
            if N <= 2 * abs(c):        # c is not the least residue: not this family
                continue
            m = c % N
            r = (2 * m) % N
            npos, nneg, nz = census(r, p)
            if (npos == 0 or nneg == 0) and not (npos == 0 and nneg == 0):
                members.append((p, r))
        disc = sp.Integer(sp.discriminant(sf.as_expr(), lam))
        badp = sorted({q for q in sp.factorint(disc)} | {2}) if disc else []
        over = [q for q in badp if q > bound]
        extra = []
        for q in over:
            N = q - 1
            r = (2 * (c % N)) % N
            npos, nneg, nz = census(r, q)
            if (npos == 0 or nneg == 0) and not (npos == 0 and nneg == 0):
                extra.append((q, r))
        print(f"| {c} | {D} | {g} | {bound:.0f} | {members} |"
              f" {over} -> constant at {extra} |")
    return 0


def dickson(m, u, p):
    """D_m(1,u) mod p, by the Dickson recurrence D_k = D_{k-1} - u D_{k-2}."""
    if m == 0:
        return 2 % p
    a, b = 2 % p, 1 % p
    for _ in range(m - 1):
        a, b = b, (b - u * a) % p
    return b


def cmd_uline(argv):
    """The u-line (descent-quotient) census sees the NON-split torus as well,
    so its period in m is lcm(p-1,p+1), not (p-1)/2."""
    from math import lcm
    from sympy import primerange
    pmax = int(argv[0]) if argv else 24
    print("bonus: periodicity of the u-line census sum_u chi(1 - D_m(1,u)^2)")
    print("   (u = lam(1-lam); 1-4u a non-square puts lam in F_{p^2}, i.e. on the")
    print("   non-split torus, where lam^m has period p+1 rather than p-1)")
    print()
    print("| p | lcm(p-1,p+1) | failures of that period | minimal period |")
    print("|---|---|---|---|")
    for p in primerange(5, pmax):
        L = lcm(p - 1, p + 1)
        vals = []
        for m in range(1, 2 * L + 1):
            vals.append(tuple(sorted(legendre((1 - dickson(m, u, p) ** 2) % p, p)
                                     for u in range(p))))
        bad = sum(1 for i in range(L, len(vals)) if vals[i] != vals[i - L])
        per = next(q for q in range(1, L + 1)
                   if L % q == 0 and all(vals[i] == vals[i + q]
                                         for i in range(len(vals) - q)))
        print(f"| {p} | {L} | {bad} | {per} |")
    return 0


def cmd_p47(argv):
    p, r, m = 47, 30, 15
    print("task 4: settlement of (p,r) = (47,30)")
    print()
    npos, nneg, nz = census(r, p)
    print(f"   direct census of chi(G_30) on F_47 - {{0,1}}: "
          f"(N+,N-,N0) = ({npos},{nneg},{nz}), bias = {npos-nneg}")
    print(f"   the Fermat-factor form at m = 15 agrees: {phi_census(m,p)}")
    N = p - 1
    print(f"   gcd(m,p-1) = gcd(15,46) = {gcd(15,46)}  (so lam -> lam^15 is a "
          f"bijection of F_47^*)")
    print(f"   3*15 = 45 = -1 (mod 46): the reduction is (k,c) = (3,-1).")
    k, c, mm = tag(p, r)
    print(f"   automatic (k,c) tag from the minimisation: k={k}, c={c}, m={mm}")

    # the bijection lam <-> point of the Fermat cubic
    pts = []
    for lam in range(2, p):
        x = pow(lam, m, p)
        xi = pow(x, p - 2, p)
        y = pow((1 - lam) % p, m, p)
        et = pow(y, p - 2, p)
        pts.append((lam, xi, et))
    ok = all((pow(a, 3, p) + pow(b, 3, p)) % p == 1 for _, a, b in pts)
    inj = len({(a, b) for _, a, b in pts}) == len(pts)
    print(f"   every lambda gives a point of xi^3 + eta^3 = 1: {ok}; "
          f"the map is injective: {inj}; points used = {len(pts)}")
    # the character sum on the cubic
    tot = 0
    for _, a, b in pts:
        P = 1
        for e in (1, -1):
            for f in (1, -1):
                P = P * ((a * b + e * a + f * b) % p) % p
        tot += legendre(P, p)
    print(f"   sum over the cubic of chi(prod(xi eta +- xi +- eta)) = {tot} "
          f"(= census bias {npos-nneg}: {tot == npos-nneg})")
    # supersingularity of the base
    print(f"   47 = 2 mod 3, so cubing is a bijection of F_47^* and the Fermat")
    print(f"   cubic is supersingular: #E(F_47) = 48 = p+1, a_p = 0.")
    cnt = 0
    for a in range(p):
        for b in range(p):
            if (pow(a, 3, p) + pow(b, 3, p)) % p == 1:
                cnt += 1
    print(f"   affine points of xi^3+eta^3=1 over F_47: {cnt}"
          f" (+1 at infinity = {cnt+1})")
    # which of the 24 geometric branch points are rational at p = 47
    print("   the six census zeros, and which of the four conics they lie on:")
    for lam in range(2, p):
        if G(lam, r, p):
            continue
        x = pow(lam, m, p)
        y = pow((1 - lam) % p, m, p)
        xi = pow(x, p - 2, p)
        et = pow(y, p - 2, p)
        which = [(a, b) for a in (1, -1) for b in (1, -1)
                 if (xi * et + a * xi + b * et) % p == 0]
        print(f"     lam={lam:3d}  (xi,eta)=({xi},{et})  conic {which}")
    return 0


# --------------------------------------------------------------------------
# ergodis cross-check
# --------------------------------------------------------------------------

def reduced_poly(r, p):
    """G_r(lambda) as a polynomial of degree < p, reduced mod (lam^p - lam),
    so that a single-variable census engine can evaluate it."""
    from sympy import Poly, symbols, GF
    lam = symbols("lam")
    X = Poly(lam, lam, modulus=p) ** r
    Y = Poly(1 - lam, lam, modulus=p) ** r
    Gp = (Poly(1, lam, modulus=p) - X - Y) ** 2 - 4 * X * Y
    red = Poly(lam, lam, modulus=p) ** p - Poly(lam, lam, modulus=p)
    return Gp.rem(red)


def cmd_ergodis(argv):
    requests = []
    labels = []
    for (p, r) in [(47, 30), (17, 6), (17, 10), (23, 12), (61, 14), (73, 16)]:
        poly = reduced_poly(r, p)
        coeffs = poly.all_coeffs()[::-1]
        requests.append("census {} {} {}".format(
            f"p{p}r{r}", p, " ".join(str(int(c)) for c in coeffs)))
        labels.append((p, r))
    proc = subprocess.run([ERGODIS], input="\n".join(requests) + "\n",
                          capture_output=True, text=True)
    if proc.returncode != 0:
        print("ergodis front end failed:", proc.stderr[:400])
        return 1
    print("cross-check of the exceptional strata on the ergodis kernel")
    print("(G_r reduced mod lam^p - lam, then one polynomial_census request)")
    print()
    print("| p | r | ergodis (pos,neg,zero,sum) | python punctured census | agree |")
    print("|---|---|---------------------------|--------------------------|-------|")
    agree = True
    for line, (p, r) in zip(proc.stdout.strip().split("\n"), labels):
        d = json.loads(line)
        # the kernel censuses all of F_p; remove lam = 0 and lam = 1
        corr = [0, 0, 0]
        for lam in (0, 1):
            s = legendre(G(lam, r, p), p)
            corr[0 if s == 1 else (1 if s == -1 else 2)] += 1
        erg = (d["positive"] - corr[0], d["negative"] - corr[1],
               d["zero"] - corr[2])
        py = census(r, p)
        ok = erg == py
        agree &= ok
        print(f"| {p} | {r} | ({d['positive']},{d['negative']},{d['zero']},"
              f"{d['sum']}) | {py} | {ok} |")
    print()
    print("all agree:", agree)
    return 0 if agree else 1


# --------------------------------------------------------------------------

COMMANDS = {
    "periodicity": cmd_periodicity,
    "master": cmd_master,
    "scan": cmd_scan,
    "cells": cmd_cells,
    "fermat": cmd_fermat,
    "fixedm": cmd_fixedm,
    "uline": cmd_uline,
    "p47": cmd_p47,
    "ergodis": cmd_ergodis,
}


def main(argv):
    if not argv or argv[0] not in COMMANDS:
        print(__doc__)
        return 2
    return COMMANDS[argv[0]](argv[1:])


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
