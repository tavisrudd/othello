#!/usr/bin/env python3
"""C1014 -- Hasse-Witt census (leg A) and Sato-Tate decision (leg B).

Leg A: the isometry invariants of the four-point pure-power Gram form
       M(lambda)_ij = [p_i, p_j]^{2m},  (p_1..p_4) = (oo, 0, 1, lambda),
       over an arbitrary field of characteristic != 2; the principal-minor
       stratification; the Hasse-Witt invariant as a quaternion class over
       QQ(lambda) and its ramification; and the finite-field census of the
       genuine second coloring that survives (the Fermat/Dickson factor
       square-class vector).

Leg B: local L-data at m = 8 for the S_3-isotypic pieces of Jac(C_8), and
       Sato-Tate moment statistics deciding the Sato-Tate group of the two
       abelian surfaces A_triv, A_sgn.

Subcommands
    legA-symbolic   diagonalisation, Witt theorem, minors, Hasse symbol;
                    writes c1014_st_ram.gp
    legA-census     F_p census of the refined (four-factor) coloring,
                    routed through the Ergodis character kernel
    legA-period     periodicity of the refined coloring in m mod (p-1)
    legA-covers     genus of the cover governing each correlation sum
    legB-emit       writes c1014_st_legb.gp and c1014_st_moments.gp
    legB-quotients  S_3-quotient models R_m(J) for m = 5..10; writes
                    c1014_st_cond2.gp (genus-2 conductors via genus2red)
    legB-analyze    reads the gp output files and reports moments/verdict
    moments-ref     reference Sato-Tate moments by Weyl integration

Usage
    uv run --with sympy python3 c1014_hasse_sato_tate.py <subcommand>
    nix shell nixpkgs#pari --command gp -q c1014_st_ram.gp
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
ERGODIS = "/home/tavis/.cache/ergodis/c1013-census-target/release/c1013-census"

# ---------------------------------------------------------------------------
# integer polynomial helpers (ascending coefficient lists)
# ---------------------------------------------------------------------------


def trim(a):
    while len(a) > 1 and a[-1] == 0:
        a.pop()
    return a


def padd(a, b):
    n = max(len(a), len(b))
    return trim([(a[i] if i < len(a) else 0) + (b[i] if i < len(b) else 0) for i in range(n)])


def pscale(a, c):
    return trim([c * x for x in a])


def pmul(a, b):
    out = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        if x:
            for j, y in enumerate(b):
                out[i + j] += x * y
    return trim(out)


def ppow(a, n):
    out = [1]
    while n:
        if n & 1:
            out = pmul(out, a)
        a = pmul(a, a)
        n >>= 1
    return out


def peval(a, x, p=None):
    v = 0
    for c in reversed(a):
        v = v * x + c
        if p is not None:
            v %= p
    return v


LAM = [0, 1]
ONE_M_LAM = [1, -1]


def fermat_factors(m):
    """A_{eps,eta} = 1 + eps lambda^m + eta (1-lambda)^m, as lambda-polynomials."""
    s = ppow(LAM, m)
    t = ppow(ONE_M_LAM, m)
    out = {}
    for eps in (1, -1):
        for eta in (1, -1):
            out[(eps, eta)] = padd([1], padd(pscale(s, eps), pscale(t, eta)))
    return out


def phi_lambda(m):
    """Phi_{2m,4}(lambda) = det Gram / (lambda^2 (1-lambda)^2)."""
    s2 = ppow(LAM, 2 * m)
    t2 = ppow(ONE_M_LAM, 2 * m)
    det = padd([1], padd(padd(ppow(s2, 2), ppow(t2, 2)),
                         padd(pscale(s2, -2), padd(pscale(t2, -2), pscale(pmul(s2, t2), -2)))))
    num = det[:]
    den = pmul(ppow(LAM, 2), ppow(ONE_M_LAM, 2))
    q = [Fraction(0)] * (len(num) - len(den) + 1)
    num = [Fraction(x) for x in num]
    den = [Fraction(x) for x in den]
    while len(num) >= len(den) and any(num):
        shift = len(num) - len(den)
        c = num[-1] / den[-1]
        q[shift] = c
        for j, v in enumerate(den):
            num[shift + j] -= c * v
        trim(num)
    assert all(x == 0 for x in num), "Phi division failed"
    return [int(x) for x in trim(q)]


# ---------------------------------------------------------------------------
# leg A -- symbolic
# ---------------------------------------------------------------------------


def legA_symbolic():
    import sympy as sp

    lam = sp.symbols("lam")
    print("== Leg A.1: the Gram form over QQ(lambda) ==")
    print()

    def gram(m):
        A = lam ** (2 * m)
        B = (1 - lam) ** (2 * m)
        return sp.Matrix([[0, 1, 1, 1], [1, 0, 1, A], [1, 1, 0, B], [1, A, B, 0]])

    def diagonalise(M0):
        n = M0.shape[0]
        P = sp.eye(n)
        M = sp.Matrix(M0)
        d = []
        for k in range(n):
            piv = None
            for i in range(k, n):
                if sp.cancel(M[i, i]) != 0:
                    piv = i
                    break
            if piv is None:
                i = j = None
                for r in range(k, n):
                    for s in range(r + 1, n):
                        if sp.cancel(M[r, s]) != 0:
                            i, j = r, s
                            break
                    if i is not None:
                        break
                assert i is not None, "form is identically zero on the remaining block"
                P[:, i] = sp.Matrix(P[:, i] + P[:, j])
                M = sp.Matrix(P.T * M0 * P).applyfunc(sp.cancel)
                piv = i
            if piv != k:
                P.col_swap(k, piv)
                M = sp.Matrix(P.T * M0 * P).applyfunc(sp.cancel)
            a = sp.cancel(M[k, k])
            d.append(a)
            for i in range(k + 1, n):
                c = sp.cancel(M[i, k] / a)
                if c != 0:
                    P[:, i] = sp.Matrix(sp.expand(P[:, i] - c * P[:, k]))
            M = sp.Matrix(P.T * M0 * P).applyfunc(sp.cancel)
        return d, P

    for m in range(2, 9):
        M = gram(m)
        d, P = diagonalise(M)
        det = sp.factor(M.det())
        head = [sp.nsimplify(x) for x in d[:3]]
        tail_ratio = sp.cancel(d[3] / M.det())
        print(f"m = {m}: diag = <{head[0]}, {head[1]}, {head[2]}, "
              f"({tail_ratio}) * det>   [det = Delta * Phi_{{{2*m}}},4]")

    print()
    print("== Leg A.2: principal minors of M(lambda) ==")
    for m in range(2, 7):
        M = gram(m)
        mins = [sp.factor(M[:k, :k].det()) for k in range(1, 5)]
        print(f"m = {m}: G_1 = {mins[0]}, G_2 = {mins[1]}, G_3 = {mins[2]}")
    print("  (G_4 = det = Delta * Phi.)")

    print()
    print("== Leg A.3: square-class factors of Phi and the (2, Phi) ramification test ==")
    lines = ["\\\\ generated by c1014_hasse_sato_tate.py legA-symbolic",
             "\\\\ ramification of the Hasse-Witt class (2, Phi_{2m,4}) over QQ(lambda):",
             "\\\\ a square-class factor pi ramifies iff 2 is NOT a square in QQ[lam]/(pi).",
             "default(parisize, 200000000);"]
    for m in range(2, 9):
        Phi = phi_lambda(m)
        poly = sum(c * lam ** i for i, c in enumerate(Phi))
        cont, facs = sp.factor_list(sp.Poly(poly, lam))
        odd = [sp.Poly(g, lam).as_expr() for g, e in facs if e % 2 == 1]
        even = [(sp.Poly(g, lam).as_expr(), e) for g, e in facs if e % 2 == 0]
        print(f"m = {m}: content {cont}, sqcl degree "
              f"{sum(sp.degree(g, lam) for g in odd)}"
              + (f", squared part {even}" if even else ""))
        for g in odd:
            coeffs = [int(c) for c in sp.Poly(g, lam).all_coeffs()[::-1]]
            n = len(coeffs) - 1
            lead = coeffs[-1]
            # monicise: the field QQ[lam]/(pi) equals QQ[z]/(pitilde) with
            # z = lead * lam and pitilde(z) = lead^(n-1) * pi(z/lead).
            monic = [c * lead ** (n - 1 - i) for i, c in enumerate(coeffs[:-1])] + [1]
            gp = " + ".join(f"({c})*x^{i}" for i, c in enumerate(monic))
            gp = f"polredbest({gp})"
            tag = f"m={m} deg={n} pi={sp.Poly(g, lam).as_expr()}"
            if n == 1:
                lines.append(f'print("{tag}  2 a square in kappa(pi)? 0");')
            else:
                lines.append(f'print("{tag}  2 a square in kappa(pi)? ", '
                             f'nfisincl(x^2-2, {gp}) != 0);')
        # constant part of the Hasse-Witt class: (2, content) . (-1,-1)
        c = sp.Rational(cont)
        n = c.p * c.q
        sf = -1 if n < 0 else 1
        for pr, e in sp.factorint(abs(n)).items():
            if e % 2:
                sf *= pr
        lines.append(
            f'print("m={m} constant class (2,{sf}).(-1,-1) ramified at: ", '
            f'select(q -> hilbert(2,{sf},q)*hilbert(-1,-1,q) == -1, '
            f'[2,3,5,7,11,13,17,19,23,29,31,43,127]), '
            f'" oo:", hilbert(2,{sf},0)*hilbert(-1,-1,0) == -1);')
    lines.append("quit;")
    path = os.path.join(HERE, "c1014_st_ram.gp")
    with open(path, "w") as fh:
        fh.write("\n".join(lines) + "\n")
    print(f"\nwrote {path}")


# ---------------------------------------------------------------------------
# leg A -- finite-field census of the refined coloring
# ---------------------------------------------------------------------------

KEYS = [(1, 1), (1, -1), (-1, 1), (-1, -1)]


def legendre(x, p):
    x %= p
    if x == 0:
        return 0
    return 1 if pow(x, (p - 1) // 2, p) == 1 else -1


def direct_census(m, p):
    """Joint distribution of (chi(A_++), chi(A_+-), chi(A_-+), chi(A_--))."""
    facs = [fermat_factors(m)[k] for k in KEYS]
    counts = {}
    bad = 0
    for x in range(p):
        if x % p in (0, 1 % p):      # degenerate configurations
            bad += 1
            continue
        vals = [legendre(peval(f, x, p), p) for f in facs]
        if 0 in vals:
            bad += 1
            continue
        counts[tuple(vals)] = counts.get(tuple(vals), 0) + 1
    return counts, p - bad


def ergodis_census(m, p, requests_only=False):
    """Same distribution, obtained from 16 Ergodis product-censuses."""
    facs = {k: fermat_factors(m)[k] for k in KEYS}
    subsets = []
    for mask in range(16):
        subsets.append([KEYS[i] for i in range(4) if mask >> i & 1])
    reqs = []
    for mask, S in enumerate(subsets):
        prod = [1]
        for k in S:
            prod = pmul(prod, facs[k])
        reqs.append(f"census S{mask} {p} " + " ".join(str(c) for c in prod))
    if requests_only:
        return reqs
    proc = subprocess.run([ERGODIS], input="\n".join(reqs) + "\n",
                          capture_output=True, text=True, check=True)
    sums = {}
    for line in proc.stdout.strip().splitlines():
        obj = json.loads(line)
        sums[int(obj["label"][1:])] = obj["sum"]
    # restrict every correlation sum to the common good set
    badset = [x for x in range(p)
              if x % p in (0, 1 % p)
              or any(peval(facs[k], x, p) % p == 0 for k in KEYS)]
    good = {}
    for mask, S in enumerate(subsets):
        corr = sums[mask]
        for x in badset:
            v = 1
            for k in S:
                v *= legendre(peval(facs[k], x, p), p)
            corr -= v
        good[mask] = corr
    counts = {}
    for eps in [(a, b, c, d) for a in (1, -1) for b in (1, -1)
                for c in (1, -1) for d in (1, -1)]:
        tot = 0
        for mask, S in enumerate(subsets):
            sgn = 1
            for i in range(4):
                if mask >> i & 1:
                    sgn *= eps[i]
            tot += sgn * good[mask]
        assert tot % 16 == 0, (m, p, eps, tot)
        if tot:
            counts[eps] = tot // 16
    return counts, p - len(badset)


def primes_upto(n):
    sieve = [True] * (n + 1)
    sieve[0] = sieve[1] = False
    for i in range(2, int(n ** 0.5) + 1):
        if sieve[i]:
            for j in range(i * i, n + 1, i):
                sieve[j] = False
    return [i for i, ok in enumerate(sieve) if ok]


def legA_census(pmax=200, mmax=6):
    print("== Leg A.4: census of the refined four-factor coloring ==")
    print()
    print("| m | p range | strata seen (of 16) | max stratum bias | Ergodis == direct |")
    print("|---|---------|---------------------|------------------|-------------------|")
    agree = True
    detail = {}
    for m in range(2, mmax + 1):
        seen = set()
        worst = 0.0
        worst_at = None
        for p in primes_upto(pmax):
            if p == 2:
                continue
            c1, g1 = direct_census(m, p)
            c2, g2 = ergodis_census(m, p)
            if {k: v for k, v in c1.items() if v} != c2 or g1 != g2:
                agree = False
                print(f"  MISMATCH m={m} p={p}")
            seen |= set(c2)
            n = sum(c2.values())
            if n:
                for k, v in c2.items():
                    dev = abs(v - n / 16) / (n ** 0.5)
                    if dev > worst:
                        worst, worst_at = dev, (p, k)
            detail[(m, p)] = (dict(c2), g2)
        print(f"| {m} | 3..{pmax} | {len(seen)} | {worst:.2f} sd at p={worst_at[0]} | "
              f"{'yes' if agree else 'NO'} |")
    return detail


def legA_covers(mmax=8):
    """Genus of the cover y^2 = sqcl(prod_{S} A_{eps,eta}) for every subset S."""
    import sympy as sp

    lam = sp.symbols("lam")
    names = {(1, 1): "A++", (1, -1): "A+-", (-1, 1): "A-+", (-1, -1): "A--"}
    print("== Leg A.6: the covers governing each correlation sum ==")
    print()
    print("| m | subset S | deg sqcl(prod_S) | genus |")
    print("|---|----------|------------------|-------|")
    for m in range(2, mmax + 1):
        facs = fermat_factors(m)
        for mask in range(1, 16):
            S = [KEYS[i] for i in range(4) if mask >> i & 1]
            prod = [1]
            for k in S:
                prod = pmul(prod, facs[k])
            poly = sum(c * lam ** i for i, c in enumerate(prod))
            cont, fl = sp.factor_list(sp.Poly(poly, lam))
            odd = sp.Integer(1)
            for g, e in fl:
                if e % 2:
                    odd *= sp.Poly(g, lam).as_expr()
            d = sp.degree(sp.Poly(sp.expand(odd), lam))
            g = (d - 1) // 2 if d % 2 else (d - 2) // 2
            print(f"| {m} | {'.'.join(names[k] for k in S)} | {d} | {max(g, 0)} |")


def legA_period(pmax=120, mmax=6):
    """Refined coloring has period (p-1) in m; chi(Phi) has period (p-1)/2."""
    print()
    print("== Leg A.5: periodicity in m ==")
    print()
    print("| p | refined census m vs m+(p-1)/2 | chi(Phi) census m vs m+(p-1)/2 |")
    print("|---|-------------------------------|--------------------------------|")
    for p in primes_upto(pmax):
        if p < 5:
            continue
        h = (p - 1) // 2
        same_ref, same_disc = True, True
        for m in range(2, mmax + 1):
            c1, _ = direct_census(m, p)
            c2, _ = direct_census(m + h, p)
            if c1 != c2:
                same_ref = False
            d1 = sorted(legendre(peval(phi_lambda(m), x, p), p) for x in range(2, p))
            d2 = sorted(legendre(peval(phi_lambda(m + h), x, p), p) for x in range(2, p))
            if d1 != d2:
                same_disc = False
        print(f"| {p} | {'equal' if same_ref else 'differs'} | "
              f"{'equal' if same_disc else 'differs'} |")


# ---------------------------------------------------------------------------
# leg B
# ---------------------------------------------------------------------------


def dickson_L(m):
    """L_m(u) = lambda^m + (1-lambda)^m as a polynomial in u = lambda(1-lambda)."""
    a, b = [2], [1]
    if m == 0:
        return a
    for _ in range(m - 1):
        a, b = b, padd(b, pscale(pmul([0, 1], a), -1))
    return b


def phi_u(m):
    """Phi_{2m,4} as a polynomial in u."""
    num = padd([1], pscale(ppow(dickson_L(m), 2), -1))
    assert num[0] == 0
    P = num[1:]
    return pmul(P, padd(P, pscale(ppow([0, 1], m - 1), 4)))


def sqcl_int(f):
    """Square class of an integer polynomial (sympy-backed)."""
    import sympy as sp

    u = sp.symbols("u")
    poly = sum(c * u ** i for i, c in enumerate(f))
    cont, facs = sp.factor_list(sp.Poly(poly, u))
    out = sp.Integer(1)
    for g, e in facs:
        if e % 2:
            out *= sp.Poly(g, u).as_expr()
    cont = sp.Rational(cont)
    n = cont.p * cont.q
    sf = -1 if n < 0 else 1
    for pr, e in sp.factorint(abs(n)).items():
        if e % 2:
            sf *= pr
    poly = sp.Poly(sp.expand(sf * out), u)
    return [int(c) for c in poly.all_coeffs()[::-1]]


def gp_poly(coeffs, var="x"):
    terms = []
    for i, c in enumerate(coeffs):
        if c:
            terms.append(f"{c:+d}*{var}^{i}" if i else f"{c:+d}")
    return "".join(terms) or "0"


# A_triv(m=8) : Y^2 = J (J+4) (16 J^3 + 68 J^2 + 16 J + 1)      (16 dropped: square)
# A_sgn (m=8) : Z^2 = (4J-27) J (J+4) (16 J^3 + 68 J^2 + 16 J + 1)


def legB_quotients(ms=(5, 6, 7, 8, 9, 10)):
    """R_m(J) for the S_3-quotient C_m/S_3, by exact interpolation in J.

    Y = y / (W I^{(g-2)/2}) is S_3-invariant, so Y^2 = f_m / (W^2 I^{g-2})
    is a rational function of J = I^3 / W^2; it is a polynomial R_m(J).
    """
    import sympy as sp

    lam = sp.symbols("lam")
    Jv = sp.symbols("J")
    I = lam ** 2 - lam + 1
    W = lam * (lam - 1)
    J = sp.cancel(I ** 3 / W ** 2)
    lines = ["\\\\ generated by c1014_hasse_sato_tate.py legB-quotients",
             "default(parisize, 2000000000);"]
    for m in ms:
        Phi = phi_lambda(m)
        poly = sum(c * lam ** i for i, c in enumerate(Phi))
        cont, facs = sp.factor_list(sp.Poly(poly, lam))
        f = sp.Integer(1)
        for gpoly, e in facs:
            if e % 2:
                f *= sp.Poly(gpoly, lam).as_expr()
        cont = sp.Rational(cont)
        nn = cont.p * cont.q
        sf = -1 if nn < 0 else 1
        for pr, e in sp.factorint(abs(nn)).items():
            if e % 2:
                sf *= pr
        f = sp.expand(sf * f)
        g = sp.degree(sp.Poly(f, lam)) // 2 - 1
        # tau-invariance of  G = f I^beta / W^alpha  forces  3 alpha = 2k + 2beta
        # with alpha even; take the smallest such alpha with beta >= 0.
        k = sp.degree(sp.Poly(f, lam)) // 2
        alpha = 2 * ((2 * k + 5) // 6)
        while (3 * alpha - 2 * k) % 2 or 3 * alpha < 2 * k:
            alpha += 2
        beta = (3 * alpha - 2 * k) // 2
        F = sp.cancel(sp.expand(f * I ** beta) / W ** alpha)
        R = None
        for deg in range(1, 14):
            pts, vals = [], []
            x = sp.Rational(3)
            while len(pts) < deg + 1:
                x += 1
                jj = J.subs(lam, x)
                if jj in pts:
                    continue
                pts.append(jj)
                vals.append(F.subs(lam, x))
            cand = sp.expand(sp.interpolate(list(zip(pts, vals)), Jv))
            if sp.simplify(sp.cancel(cand.subs(Jv, J) - F)) == 0:
                R = sp.Poly(cand, Jv)
                break
        assert R is not None, f"no polynomial R_m found for m = {m}"
        def square_class(expr):
            expr = sp.together(expr)
            num, den = sp.fraction(expr)
            expr = sp.expand(num * den)          # clear denominators by a square
            cont2, fl = sp.factor_list(sp.Poly(expr, Jv))
            out = sp.Integer(1)
            for gg, e in fl:
                if e % 2:
                    out *= sp.Poly(gg, Jv).as_expr()
            cont2 = sp.Rational(cont2)
            nn = cont2.p * cont2.q
            sfc = -1 if nn < 0 else 1
            for pr, e in sp.factorint(abs(nn)).items():
                if e % 2:
                    sfc *= pr
            return sp.expand(sfc * out)

        Rt = square_class(R.as_expr())
        Rs = square_class((4 * Jv - 27) * R.as_expr())
        dt, ds = sp.degree(sp.Poly(Rt, Jv)), sp.degree(sp.Poly(Rs, Jv))
        gt = (dt - 1) // 2 if dt % 2 else (dt - 2) // 2
        gs = (ds - 1) // 2 if ds % 2 else (ds - 2) // 2
        print(f"m = {m}: g(C_m) = {g}, a = {(m-2)//3}, (alpha,beta) = ({alpha},{beta})")
        print(f"   R_m(J)         = {sp.factor(Rt)}   (genus {gt})")
        print(f"   (4J-27) R_m(J) = {sp.factor(Rs)}   (genus {gs})")
        co = [int(c) for c in sp.Poly(Rt, Jv).all_coeffs()[::-1]]
        cs = [int(c) for c in sp.Poly(Rs, Jv).all_coeffs()[::-1]]
        lines.append(f"Rt{m} = {gp_poly(co)};")
        lines.append(f"Rs{m} = {gp_poly(cs)};")
        for tag in ("t", "s"):
            lines.append(
                f'v = genus2red(R{tag}{m}); '
                f'print("m={m} {tag} genus2red N=", v[1], " faN=", v[2]);')
    lines.append("quit;")
    path = os.path.join(HERE, "c1014_st_cond2.gp")
    with open(path, "w") as fh:
        fh.write("\n".join(lines) + "\n")
    print(f"wrote {path}")


def legB_emit(pmax_split=700, pmax_moments=10000):
    triv = "x*(x+4)*(16*x^3+68*x^2+16*x+1)"
    sgn = f"(4*x-27)*{triv}"
    d1 = gp_poly(sqcl_int(phi_u(8)))
    d2 = gp_poly(sqcl_int(pmul([1, -4], phi_u(8))))

    split = [
        "\\\\ generated by c1014_hasse_sato_tate.py legB-emit",
        "\\\\ isotypic split check at m = 8:  L(D_1) = L(A_triv) * L_std,",
        "\\\\                                 L(D_2) = L(A_sgn)  * L_std.",
        "default(parisize, 4000000000);",
        f"D1 = {d1};",
        f"D2 = {d2};",
        f"Rt = {triv};",
        f"Rs = {sgn};",
        "bad = lcm([poldisc(D1), poldisc(D2), poldisc(Rt), poldisc(Rs)]);",
        "{",
        f"forprime(p = 3, {pmax_split},",
        "  if(Mod(bad, p) == 0, next);",
        "  L1 = hyperellcharpoly(Mod(1,p)*D1);",
        "  L2 = hyperellcharpoly(Mod(1,p)*D2);",
        "  Lt = hyperellcharpoly(Mod(1,p)*Rt);",
        "  Ls = hyperellcharpoly(Mod(1,p)*Rs);",
        "  q1 = L1 / Lt; q2 = L2 / Ls;",
        "  print(\"SPLIT \", p, \" \", (type(q1)==\"t_POL\"), \" \", (type(q2)==\"t_POL\"),",
        "        \" \", if(type(q1)==\"t_POL\" && type(q2)==\"t_POL\", q1 == q2, -1),",
        "        \" \", polcoeff(Lt,3), \" \", polcoeff(Ls,3),",
        "        \" \", if(type(q1)==\"t_POL\", polcoeff(q1,7), 999),",
        "        \" \", if(type(q1)==\"t_POL\", #factor(q1)~, 0));",
        ");",
        "}",
        "quit;",
    ]
    path1 = os.path.join(HERE, "c1014_st_legb.gp")
    with open(path1, "w") as fh:
        fh.write("\n".join(split) + "\n")

    mom = [
        "\\\\ generated by c1014_hasse_sato_tate.py legB-emit",
        "\\\\ genus-2 L-polynomial data for the m=8 isotypic surfaces.",
        "\\\\ line format:  MOM p a1 a2 nfactors",
        "\\\\   L(T) = T^4 - a1 T^3 + a2 T^2 - p a1 T + p^2",
        "default(parisize, 2000000000);",
        f"Rt = {triv};",
        f"Rs = {sgn};",
        "bt = poldisc(Rt); bs = poldisc(Rs);",
        "{",
        f"forprime(p = 3, {pmax_moments},",
        "  if(Mod(bt,p) != 0,",
        "    L = hyperellcharpoly(Mod(1,p)*Rt);",
        "    print(\"MOMT \", p, \" \", -polcoeff(L,3), \" \", polcoeff(L,2), \" \", #factor(L)~));",
        "  if(Mod(bs,p) != 0,",
        "    L = hyperellcharpoly(Mod(1,p)*Rs);",
        "    print(\"MOMS \", p, \" \", -polcoeff(L,3), \" \", polcoeff(L,2), \" \", #factor(L)~));",
        ");",
        "}",
        "quit;",
    ]
    path2 = os.path.join(HERE, "c1014_st_moments.gp")
    with open(path2, "w") as fh:
        fh.write("\n".join(mom) + "\n")
    print(f"wrote {path1}\nwrote {path2}")
    print("D1 =", d1)
    print("D2 =", d2)


# ---------------------------------------------------------------------------
# Sato-Tate reference moments
# ---------------------------------------------------------------------------


def usp_moments(g, nmax):
    """E[tr^n] on USp(2g): paths of length n from the empty partition to itself
    on the Bratteli diagram of partitions with at most g rows (add/remove one
    box).  This is dim (V^{tensor n})^{USp(2g)}."""
    from collections import defaultdict

    state = {(): 1}
    out = [1]
    for _ in range(nmax):
        nxt = defaultdict(int)
        for part, mult in state.items():
            lst = list(part)
            for i in range(len(lst) + 1):
                if i >= g:
                    break
                cur = lst[:]
                if i == len(cur):
                    cur.append(1)
                else:
                    cur[i] += 1
                if i == 0 or cur[i - 1] >= cur[i]:
                    nxt[tuple(cur)] += mult
            for i in range(len(lst)):
                cur = lst[:]
                cur[i] -= 1
                if cur[i] < 0:
                    continue
                if i + 1 < len(cur) and cur[i] < cur[i + 1]:
                    continue
                while cur and cur[-1] == 0:
                    cur.pop()
                nxt[tuple(cur)] += mult
        state = dict(nxt)
        out.append(state.get((), 0))
    return out


def catalan(n):
    from math import comb
    return comb(2 * n, n) // (n + 1)


def conv(a, b):
    """Moment sequence of X+Y for independent X, Y."""
    from math import comb
    n = min(len(a), len(b))
    return [sum(comb(k, i) * a[i] * b[k - i] for i in range(k + 1)) for k in range(n)]


def scale_moments(a, c):
    return [c ** k * v for k, v in enumerate(a)]


def moments_ref(nmax=8):
    from math import comb

    su2 = [catalan(k // 2) if k % 2 == 0 else 0 for k in range(nmax + 1)]
    u1 = [comb(k, k // 2) if k % 2 == 0 else 0 for k in range(nmax + 1)]
    zero = [1] + [0] * nmax
    usp4 = usp_moments(2, nmax)
    usp8 = usp_moments(4, nmax)

    def avg(seqs):
        n = len(seqs)
        return [sum(s[k] for s in seqs) / n for k in range(nmax + 1)]

    cands = {
        "USp(4)  [A simple, End=Z, generic]": usp4,
        "SU(2)xSU(2)  [E1 x E2 non-isogenous non-CM; also GL2-type with RM]":
            conv(su2, su2),
        "N(SU(2)xSU(2))  [Q-simple, splits over a quadratic field]":
            avg([conv(su2, su2), zero]),
        "SU(2) diagonal  [E x E, isogenous]": scale_moments(su2, 2),
        "N(SU(2)) diagonal  [E x E^d, quadratic twist]":
            avg([scale_moments(su2, 2), zero]),
        "SU(2) x N(U(1))  [non-CM x CM over Q]": conv(su2, avg([u1, zero])),
        "SU(2) x U(1)  [non-CM x CM with CM over Q]": conv(su2, u1),
        "N(U(1)) x N(U(1))  [two CM curves over Q]":
            conv(avg([u1, zero]), avg([u1, zero])),
        "U(1) x U(1)  [CM abelian surface, CM field in Q]": conv(u1, u1),
    }
    print("== Leg B reference Sato-Tate moments of the normalised trace ==")
    print()
    print("| Sato-Tate group | E[t^2] | E[t^4] | E[t^6] | E[t^8] |")
    print("|-----------------|--------|--------|--------|--------|")
    for name, seq in cands.items():
        print(f"| {name} | {seq[2]:g} | {seq[4]:g} | {seq[6]:g} | {seq[8]:g} |")
    print()
    print("USp(8) (dim-4 reference): "
          f"E[t^2]={usp8[2]}, E[t^4]={usp8[4]}, E[t^6]={usp8[6]}, E[t^8]={usp8[8]}")
    return cands


def legB_analyze(momfile, splitfile=None):
    import math

    data = {"MOMT": [], "MOMS": []}
    with open(momfile) as fh:
        for line in fh:
            f = line.split()
            if not f or f[0] not in data:
                continue
            data[f[0]].append((int(f[1]), int(f[2]), int(f[3]), int(f[4])))
    cands = moments_ref()
    print()
    print("== Measured moments ==")
    print()
    print("| curve | #primes | p max | E[t^2] | E[t^4] | E[t^6] | E[a2/p] | "
          "frac a1=0 | frac L splits over QQ |")
    print("|-------|---------|-------|--------|--------|--------|---------|"
          "-----------|-----------------------|")
    for key, label in (("MOMT", "A_triv (m=8)"), ("MOMS", "A_sgn (m=8)")):
        rows = data[key]
        if not rows:
            continue
        n = len(rows)
        ts = [a1 / math.sqrt(p) for p, a1, a2, nf in rows]
        m2 = sum(t ** 2 for t in ts) / n
        m4 = sum(t ** 4 for t in ts) / n
        m6 = sum(t ** 6 for t in ts) / n
        e2 = sum(a2 / p for p, a1, a2, nf in rows) / n
        z = sum(1 for p, a1, a2, nf in rows if a1 == 0) / n
        sp_ = sum(1 for p, a1, a2, nf in rows if nf > 1) / n
        print(f"| {label} | {n} | {rows[-1][0]} | {m2:.3f} | {m4:.3f} | {m6:.3f} "
              f"| {e2:.3f} | {z:.3f} | {sp_:.3f} |")
    print()
    print("nearest reference group by (E[t^2], E[t^4], E[t^6]) L^2 distance:")
    for key, label in (("MOMT", "A_triv (m=8)"), ("MOMS", "A_sgn (m=8)")):
        rows = data[key]
        if not rows:
            continue
        n = len(rows)
        ts = [a1 / math.sqrt(p) for p, a1, a2, nf in rows]
        obs = [sum(t ** k for t in ts) / n for k in (2, 4, 6)]
        best = sorted(cands.items(),
                      key=lambda kv: sum((obs[i] - kv[1][2 * (i + 1)]) ** 2
                                         for i in range(3)))
        print(f"  {label}: {best[0][0]}   "
              f"(obs {obs[0]:.3f}, {obs[1]:.3f}, {obs[2]:.3f})")

    if splitfile and os.path.exists(splitfile):
        tot = ok = same = 0
        stdpat = {}
        with open(splitfile) as fh:
            for line in fh:
                f = line.split()
                if not f or f[0] != "SPLIT":
                    continue
                tot += 1
                if f[2] == "1" and f[3] == "1":
                    ok += 1
                if f[4] == "1":
                    same += 1
                stdpat[int(f[8])] = stdpat.get(int(f[8]), 0) + 1
        print()
        print(f"isotypic split check (m = 8): {tot} good primes; "
              f"L(A_triv) | L(D_1) and L(A_sgn) | L(D_2) at {ok}; "
              f"the two degree-8 cofactors agree at {same}.")
        print(f"  number of QQ-irreducible factors of the std degree-8 factor: {stdpat}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("cmd", choices=["legA-symbolic", "legA-census", "legA-period",
                                    "legA-covers", "legB-emit", "legB-quotients",
                                    "legB-analyze", "moments-ref"])
    ap.add_argument("--pmax", type=int, default=200)
    ap.add_argument("--mmax", type=int, default=6)
    ap.add_argument("--momfile", default="")
    ap.add_argument("--splitfile", default="")
    args = ap.parse_args()
    if args.cmd == "legA-symbolic":
        legA_symbolic()
    elif args.cmd == "legA-census":
        legA_census(args.pmax, args.mmax)
    elif args.cmd == "legA-period":
        legA_period(args.pmax)
    elif args.cmd == "legA-covers":
        legA_covers(args.mmax)
    elif args.cmd == "legB-emit":
        legB_emit()
    elif args.cmd == "legB-quotients":
        legB_quotients()
    elif args.cmd == "legB-analyze":
        legB_analyze(args.momfile, args.splitfile or None)
    elif args.cmd == "moments-ref":
        moments_ref()


if __name__ == "__main__":
    main()
