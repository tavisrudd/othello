#!/usr/bin/env python3
"""C1013 -- modular and transvectant foundations for the Gram-discriminant hierarchy.

Replay:
    uv run --with sympy python3 notes/clebsch-tasks/c1013_modular_foundations.py <section>

sections: t1 t2 t3 t4 t5 all

Conventions fixed once here and quoted in the report:

* V = <x, y>.  A linear form is l = a*x + b*y, recorded as the pair (a, b).
* Bracket [l, m] = a_l * b_m - b_l * a_m.
* B_d is the invariant bilinear form on the degree-d Veronese module normalized on
  pure powers by B_d(l^d, m^d) = [l, m]^d.
* Root l_t = x - t*y has bracket [l_s, l_t] = s - t;  l_inf = y.
* Normalized four-point chart: (inf, 0, 1, lam) -> l_1 = y, l_2 = x, l_3 = x - y,
  l_4 = x - lam*y.  Extra points are l_k = x - lam_k * y.
* G_{d,r} = det( [l_i, l_j]^d ),  Delta = prod_{i<j} [l_i, l_j]^2,  Phi = G / Delta.
"""

import sys
from itertools import permutations

import sympy as sp

# --------------------------------------------------------------------------
# shared helpers
# --------------------------------------------------------------------------

PRIMES = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]


def bracket(l1, l2):
    return sp.expand(l1[0] * l2[1] - l1[1] * l2[0])


def normalized_chart(r, lams):
    """l_1 = y (inf), l_2 = x (0), l_3 = x - y (1), then x - lam_k y."""
    forms = [(sp.Integer(0), sp.Integer(1)), (sp.Integer(1), sp.Integer(0)),
             (sp.Integer(1), sp.Integer(-1))]
    for k in range(r - 3):
        forms.append((sp.Integer(1), -lams[k]))
    return forms[:r]


def generic_chart(ts):
    return [(sp.Integer(1), -t) for t in ts]


def bracket_matrix(forms):
    r = len(forms)
    return [[bracket(forms[i], forms[j]) for j in range(r)] for i in range(r)]


def power_matrix(M, e):
    return [[sp.expand(x ** e) for x in row] for row in M]


def det_exact(M):
    return sp.expand(sp.Matrix(M).det(method="berkowitz"))


def permanent(M):
    n = len(M)
    total = sp.Integer(0)
    for sigma in permutations(range(n)):
        term = sp.Integer(1)
        for i in range(n):
            term *= M[i][sigma[i]]
        total += term
    return sp.expand(total)


def pfaffian4(M):
    return sp.expand(M[0][1] * M[2][3] - M[0][2] * M[1][3] + M[0][3] * M[1][2])


def pfaffian(M):
    """Recursive Pfaffian along the first row (even size)."""
    n = len(M)
    if n == 0:
        return sp.Integer(1)
    if n == 2:
        return M[0][1]
    total = sp.Integer(0)
    for j in range(1, n):
        idx = [k for k in range(1, n) if k != j]
        minor = [[M[a][b] for b in idx] for a in idx]
        total += (-1) ** j * M[0][j] * pfaffian(minor)
    return sp.expand(total)


def delta_of(M):
    r = len(M)
    prod = sp.Integer(1)
    for i in range(r):
        for j in range(i + 1, r):
            prod *= M[i][j]
    return sp.expand(prod ** 2), sp.expand(prod)


def exact_quotient(num, den, gens):
    """Exact polynomial division; returns None if the remainder is nonzero."""
    q, rem = sp.div(sp.Poly(num, *gens), sp.Poly(den, *gens))
    if not rem.is_zero:
        return None
    return sp.expand(q.as_expr())


# --------------------------------------------------------------------------
# task 1 -- modular radical of B_d
# --------------------------------------------------------------------------

def gram_antidiagonal(d, model):
    """Antidiagonal entries of B_d, indexed by i (row), column d - i.

    model 'gamma'  : divided-power (Gamma^d) basis, entries (-1)^(d-i) * C(d,i).
    model 'sym'    : monomial basis of Sym^d, entries (-1)^(d-i) / C(d,i),
                     rescaled by L_d = lcm_i C(d,i) to a primitive integral matrix.
    """
    binoms = [sp.binomial(d, i) for i in range(d + 1)]
    if model == "gamma":
        return [(-1) ** (d - i) * binoms[i] for i in range(d + 1)]
    L = sp.ilcm(*[int(b) for b in binoms]) if d > 0 else sp.Integer(1)
    return [(-1) ** (d - i) * sp.Integer(L) / binoms[i] for i in range(d + 1)]


def rank_mod_p_antidiag(entries, p):
    return sum(1 for e in entries if int(e) % p != 0)


def rank_mod_p_full(entries, p):
    """Independent check: build the full matrix and eliminate mod p."""
    n = len(entries)
    A = [[0] * n for _ in range(n)]
    for i, e in enumerate(entries):
        A[i][n - 1 - i] = int(e) % p
    rank = 0
    row = 0
    for col in range(n):
        piv = None
        for rr in range(row, n):
            if A[rr][col] % p:
                piv = rr
                break
        if piv is None:
            continue
        A[row], A[piv] = A[piv], A[row]
        inv = pow(A[row][col], p - 2, p) if p > 2 else A[row][col]
        inv = pow(A[row][col], -1, p)
        for rr in range(n):
            if rr != row and A[rr][col] % p:
                f = (A[rr][col] * inv) % p
                for cc in range(n):
                    A[rr][cc] = (A[rr][cc] - f * A[row][cc]) % p
        row += 1
        rank += 1
    return rank


def base_digits(n, p):
    ds = []
    while n:
        ds.append(n % p)
        n //= p
    return ds or [0]


def lucas_rank(d, p):
    prod = 1
    for dk in base_digits(d, p):
        prod *= dk + 1
    return prod


def vp(n, p):
    v = 0
    n = int(n)
    while n % p == 0:
        n //= p
        v += 1
    return v


def task1():
    print("== task 1: modular radical of B_d ==")
    bad_gamma = []
    bad_full = []
    bad_sym = []
    nondeg = {p: [] for p in PRIMES}
    for d in range(1, 30):
        binoms = [sp.binomial(d, i) for i in range(d + 1)]
        eg = gram_antidiagonal(d, "gamma")
        es = gram_antidiagonal(d, "sym")
        for p in PRIMES:
            rg = rank_mod_p_antidiag(eg, p)
            if rg != lucas_rank(d, p):
                bad_gamma.append((d, p, rg, lucas_rank(d, p)))
            if d <= 14 and rank_mod_p_full(eg, p) != rg:
                bad_full.append((d, p))
            rs = rank_mod_p_antidiag(es, p)
            M = max(vp(b, p) for b in binoms)
            pred = sum(1 for b in binoms if vp(b, p) == M)
            if rs != pred:
                bad_sym.append((d, p, rs, pred))
            if rg == d + 1:
                nondeg[p].append(d)
    print("gamma-model rank == prod(digit+1) [Lucas] for all d<30, p<=29 :",
          not bad_gamma, bad_gamma[:3])
    print("independent full-matrix elimination agrees (d<=14)           :",
          not bad_full, bad_full[:3])
    print("sym-model rank == #{i : v_p C(d,i) = max_j v_p C(d,j)}       :",
          not bad_sym, bad_sym[:3])
    for p in PRIMES[:6]:
        print(f"  p={p:<3} nondegenerate d<30: {nondeg[p]}")
    # the a*p^k - 1 law
    bad_law = []
    for d in range(1, 30):
        for p in PRIMES:
            k = 0
            m = d + 1
            while m % p == 0:
                m //= p
                k += 1
            law = m < p
            if law != (lucas_rank(d, p) == d + 1):
                bad_law.append((d, p))
    print("nondegenerate  <=>  writing d+1 = a*p^k with p!|a one has a<p :",
          not bad_law, bad_law[:5])
    # max valuation: maximal carry chain (Kummer)
    def maxcarry(d, p):
        ds = base_digits(d, p)
        n = len(ds) - 1
        starts = [k for k in range(0, n) if ds[k] <= p - 2]
        return (n - min(starts)) if starts else 0

    bad_max = []
    for d in range(1, 30):
        for p in PRIMES:
            binoms = [sp.binomial(d, i) for i in range(d + 1)]
            if max(vp(b, p) for b in binoms) != maxcarry(d, p):
                bad_max.append((d, p))
    print("max_i v_p C(d,i) == n - min{k<n : d_k <= p-2}  (0 if none)   :",
          not bad_max, bad_max[:3])
    # sym-model nondegeneracy
    symnd = {p: [] for p in PRIMES}
    for d in range(1, 30):
        binoms = [sp.binomial(d, i) for i in range(d + 1)]
        for p in PRIMES:
            M = max(vp(b, p) for b in binoms)
            if all(vp(b, p) == M for b in binoms):
                symnd[p].append(d)
    for p in PRIMES[:4]:
        print(f"  p={p:<3} sym-model nondegenerate d<30: {symnd[p]}")
    # a compact witness table
    print("  d | dim | gamma-rank p=2,3,5,7 | sym-rank p=2,3,5,7")
    for d in range(2, 15):
        g = [lucas_rank(d, p) for p in (2, 3, 5, 7)]
        s = []
        binoms = [sp.binomial(d, i) for i in range(d + 1)]
        for p in (2, 3, 5, 7):
            M = max(vp(b, p) for b in binoms)
            s.append(sum(1 for b in binoms if vp(b, p) == M))
        print("  %2d | %3d | %-20s | %s" % (d, d + 1, g, s))


# --------------------------------------------------------------------------
# task 2 -- integrality and content of Phi_{2m,4}
# --------------------------------------------------------------------------

LAM = sp.Symbol("lam")


def four_point_G(d):
    forms = normalized_chart(4, [LAM])
    M = power_matrix(bracket_matrix(forms), d)
    return det_exact(M)


def four_point_phi(d):
    G = four_point_G(d)
    Delta = sp.expand(LAM ** 2 * (1 - LAM) ** 2)
    Phi = exact_quotient(G, Delta, (LAM,))
    return G, Delta, Phi


INOTE = LAM ** 2 - LAM + 1
JNOTE = sp.expand((LAM + 1) * (LAM - 2) * (2 * LAM - 1))


def express_in_IJ(Phi, deg):
    """Write Phi as sum c_{a,b} I^a J^b with 2a+3b = deg (note normalization)."""
    terms = [(a, b) for a in range(deg // 2 + 1) for b in range(deg // 3 + 1)
             if 2 * a + 3 * b == deg]
    cs = sp.symbols("c0:%d" % len(terms))
    expr = sum(c * INOTE ** a * JNOTE ** b for c, (a, b) in zip(cs, terms))
    sol = sp.solve(sp.Poly(sp.expand(expr - Phi), LAM).all_coeffs(), cs, dict=True)
    if not sol:
        return None, terms
    return [sp.nsimplify(sol[0].get(c, 0)) for c in cs], terms


def task2():
    print("== task 2: content of Phi_{2m,4} in Z[lam] ==")
    print(" m   deg  content c(m)          factorization        I,J denominator")
    rows = []
    for m in range(2, 19):
        d = 2 * m
        G, Delta, Phi = four_point_phi(d)
        P = sp.Poly(Phi, LAM)
        assert all(c.is_integer for c in P.all_coeffs()), (m, "not integral")
        cont = sp.gcd(list(P.all_coeffs()))
        coeffs, terms = express_in_IJ(sp.expand(Phi), 4 * m - 6) if m <= 10 else (None, None)
        dens = [sp.denom(c) for c in coeffs] if coeffs else [1]
        den = sp.ilcm(*(dens + [1]))
        rows.append((m, P.degree(), cont, sp.factorint(int(cont)), den))
        print("%2d %5d  %-20s %-20s %-10s %s" % (m, P.degree(), cont,
                                                 sp.factorint(int(cont)), den,
                                                 sp.factorint(int(den)) if den > 1 else ""))
    print(" -- factorwise content: G = (1-s)(1+s)(1-t)(1+t), s=lam^m+(1-lam)^m,")
    print("    t=lam^m-(1-lam)^m;  lam(1-lam)|(1-s), lam|(1+t), (1-lam)|(1-t)")
    print(" m  cont A=(1-s)/lam(1-lam)  cont(1+s)  cont C1=(1+t)/lam  cont C2=(1-t)/(1-lam)")
    for m in range(2, 13):
        s = sp.expand(LAM ** m + (1 - LAM) ** m)
        t = sp.expand(LAM ** m - (1 - LAM) ** m)
        A = exact_quotient(sp.expand(1 - s), sp.expand(LAM * (1 - LAM)), (LAM,))
        C1 = exact_quotient(sp.expand(1 + t), LAM, (LAM,))
        C2 = exact_quotient(sp.expand(1 - t), sp.expand(1 - LAM), (LAM,))
        def ct(e):
            return sp.gcd(sp.Poly(e, LAM).all_coeffs()) if e != 0 else 0
        print(" %2d  %-22s %-10s %-18s %s" %
              (m, ct(A), ct(sp.expand(1 + s)), ct(C1), ct(C2)))
    return rows


# --------------------------------------------------------------------------
# task 3 -- small-characteristic validity
# --------------------------------------------------------------------------

def ord_at(poly, a, p):
    """Order of vanishing of a GF(p) polynomial at lam = a."""
    if poly.is_zero:
        return None
    k = 0
    Q = poly
    while Q.eval(a) == 0:
        Q = Q.quo(sp.Poly(LAM - a, LAM, domain=sp.GF(p)))
        k += 1
    return k


def task3():
    print("== task 3: G_{2m,4} = lam^2 (1-lam)^2 Phi_{2m,4} mod p ==")
    print(" m  p | raw id | Phi=0 | c(m) | p|c | prim id | ord0 ord1 | rank | verdict")
    for m in range(2, 9):
        d = 2 * m
        G, Delta, Phi = four_point_phi(d)
        c = sp.gcd(sp.Poly(Phi, LAM).all_coeffs())
        Phip = sp.expand(Phi / c)
        Gp0 = sp.expand(G / c)
        for p in (2, 3, 5, 7, 11, 13):
            F = sp.GF(p)
            Gm = sp.Poly(G, LAM, domain=F)
            Dm = sp.Poly(Delta, LAM, domain=F)
            Pm = sp.Poly(Phi, LAM, domain=F)
            Pprim = sp.Poly(Phip, LAM, domain=F)
            Gprim = sp.Poly(Gp0, LAM, domain=F)
            raw = (Gm - Dm * Pm).is_zero
            prim = (Gprim - Dm * Pprim).is_zero and not Pprim.is_zero
            divides = int(c) % p == 0
            o0, o1 = ord_at(Pprim, 0, p), ord_at(Pprim, 1, p)
            rk = lucas_rank(d, p)
            if not divides and o0 == 0:
                verdict = "holds"
            elif divides:
                verdict = "holds after renormalization"
            else:
                verdict = "holds; extra Delta order"
            print("%2d %2d | %-6s | %-5s | %-4s | %-3s | %-7s | %-4s %-4s | %2d/%-2d | %s" %
                  (m, p, raw, Pm.is_zero, c, divides, prim, o0, o1, rk, d + 1, verdict))
    print(" -- boundary values: Phi_{2m,4}(0) = Phi_{2m,4}(1) = 4 m^2 ?")
    bad = []
    for m in range(2, 15):
        _, _, Phi = four_point_phi(2 * m)
        if sp.expand(Phi.subs(LAM, 0)) != 4 * m ** 2 or sp.expand(Phi.subs(LAM, 1)) != 4 * m ** 2:
            bad.append(m)
    print("    verified for m=2..14 :", not bad, bad)
    print("    hence ord_0 of the primitive Phi mod p is > 0 iff p | 4m^2/c(m)")


# --------------------------------------------------------------------------
# task 4 / 5 -- general (d, r), permanent identity, Pfaffian residual
# --------------------------------------------------------------------------

CASES = [(4, 3), (5, 3), (6, 3), (7, 3),
         (4, 4), (5, 4), (6, 4), (7, 4),
         (6, 5), (7, 5), (8, 5),
         (6, 6), (7, 6), (8, 6)]


def case_data(d, r, generic=False):
    if generic:
        ts = sp.symbols("t1:%d" % (r + 1))
        forms = generic_chart(ts)
        gens = tuple(ts)
    else:
        lams = sp.symbols("m4:%d" % (r + 1)) if r > 3 else ()
        forms = normalized_chart(r, list(lams))
        gens = tuple(lams) if lams else (sp.Symbol("z"),)
    Mb = bracket_matrix(forms)
    Md = power_matrix(Mb, d)
    G = det_exact(Md)
    Delta, vand = delta_of(Mb)
    if G == 0:
        return dict(d=d, r=r, G=0, Delta=Delta, Phi=0, gens=gens, Mb=Mb, vand=vand)
    Phi = exact_quotient(G, Delta, gens) if Delta != 1 else G
    return dict(d=d, r=r, G=G, Delta=Delta, Phi=Phi, gens=gens, Mb=Mb, vand=vand)


def proportional(A, B, gens):
    """Exact test A = c*B for a rational constant c; returns c or None."""
    if B == 0:
        return sp.Integer(0) if A == 0 else None
    for seed in range(1, 12):
        sub = {g: sp.Rational(seed * 3 + 1 + 5 * k, 7 + k) for k, g in enumerate(gens)}
        bv = sp.expand(B.subs(sub))
        if bv != 0:
            c = sp.nsimplify(sp.expand(A.subs(sub)) / bv)
            return c if sp.expand(A - c * B) == 0 else None
    return None


def task4(cases=None, generic=False):
    print("== task 4/5: Delta | G, permanent identity, Pfaffian residual ==")
    print(" (d,r)  e  G=0   Delta|G  degPhi  Phi = c*perm([ij]^e)  c")
    out = {}
    for (d, r) in (cases or CASES):
        gen = generic or r == 3
        data = case_data(d, r, generic=gen)
        gens = data["gens"]
        G, Delta, Phi = data["G"], data["Delta"], data["Phi"]
        if G == 0:
            print(" (%d,%d)   -  True   -        -       G identically 0 (parity)" % (d, r))
            out[(d, r)] = dict(zero=True)
            continue
        e = d - r + 1
        Pm = permanent(power_matrix(data["Mb"], e))
        c = proportional(sp.expand(Phi), Pm, gens)
        degPhi = sp.Poly(Phi, *gens).total_degree() if Phi != 0 else 0
        print(" (%d,%d) %3d  False  %-7s %-7s %-20s %s" %
              (d, r, e, Phi is not None, degPhi, c is not None,
               c if c is not None else "NOT PROPORTIONAL"))
        out[(d, r)] = dict(zero=False, c=c, Phi=Phi, perm=Pm, gens=gens, data=data)
    return out


def task4_plucker():
    """r = 4: everything is a polynomial in the two independent Pluecker brackets."""
    print("-- r=4 reduction via the Pluecker/Jacobi relation [12][34]-[13][24]+[14][23]=0 --")
    forms = normalized_chart(4, [LAM])
    Mb = bracket_matrix(forms)
    P = sp.expand(Mb[0][1] * Mb[2][3])
    Q = sp.expand(Mb[0][2] * Mb[1][3])
    R = sp.expand(Mb[0][3] * Mb[1][2])
    print("   P,Q,R in the (inf,0,1,lam) chart :", P, ",", Q, ",", R,
          "  P-Q+R =", sp.expand(P - Q + R))
    for d in (4, 5, 6, 7, 8):
        M = power_matrix(Mb, d)
        G = det_exact(M)
        pred_even = sp.expand(P ** (2 * d) + Q ** (2 * d) + R ** (2 * d)
                              - 2 * (P ** d * Q ** d + Q ** d * R ** d + P ** d * R ** d))
        pred_odd = sp.expand((P ** d - Q ** d + R ** d) ** 2)
        pred = pred_even if d % 2 == 0 else pred_odd
        print("   d=%d  G = %s in P,Q,R : %s" %
              (d, "det-form" if d % 2 == 0 else "Pf^2-form",
               sp.expand(G - pred) == 0))
    print("   Delta = (P Q R)^2 :", sp.expand(sp.expand(LAM ** 2 * (1 - LAM) ** 2)
                                              - (P * Q * R) ** 2) == 0)


def express_in_I_Delta(Phi, deg):
    """Phi = sum a_{k,l} I^k Delta^l with 2k + 6l = deg;  I = lam^2-lam+1,
    Delta = lam^2 (1-lam)^2 (coefficient degrees 2 and 6)."""
    D = sp.expand(LAM ** 2 * (1 - LAM) ** 2)
    terms = [(k, l) for l in range(deg // 6 + 1) for k in range((deg - 6 * l) // 2 + 1)
             if 2 * k + 6 * l == deg]
    cs = sp.symbols("a0:%d" % len(terms))
    expr = sum(c * INOTE ** k * D ** l for c, (k, l) in zip(cs, terms))
    sol = sp.solve(sp.Poly(sp.expand(expr - Phi), LAM).all_coeffs(), cs, dict=True)
    if not sol:
        return None, terms
    return [sp.nsimplify(sol[0].get(c, 0)) for c in cs], terms


def task4_IDelta():
    print("-- r=4: Phi_{d,4} as a polynomial in I = lam^2-lam+1 and Delta = lam^2(1-lam)^2 --")
    print("   (equivalently in e_2 and e_3^2 for the Pluecker triple; J occurs only squared)")
    for d in range(4, 17):
        _, _, Phi = four_point_phi(d)
        coeffs, terms = express_in_I_Delta(sp.expand(Phi), 2 * (d - 3))
        if coeffs is None:
            print("   d=%-3d NOT in Q[I,Delta]" % d)
            continue
        nz = [(t, c) for t, c in zip(terms, coeffs) if c != 0]
        dens = [sp.denom(c) for _, c in nz] + [1]
        print("   d=%-3d Phi = %s   (denominators lcm = %s)" %
              (d, " + ".join("%s*I^%d*Delta^%d" % (c, k, l) for (k, l), c in nz),
               sp.ilcm(*dens)))


IS, ES = sp.symbols("Isym e3")


def power_sums(N):
    """p_k for the Pluecker triple x+y+z=0, e_2 = -I, e_3 = e3.
    Newton: p_k = I*p_{k-2} + e3*p_{k-3}."""
    p = {0: sp.Integer(3), 1: sp.Integer(0), 2: 2 * IS}
    for k in range(3, N + 1):
        p[k] = sp.expand(IS * p[k - 2] + ES * p[k - 3])
    return p


def task4_powersum():
    print("-- r=4 closed form via power sums of the Pluecker triple --")
    print("   x=[12][34], y=-[13][24], z=[14][23];  x+y+z=0 (Pluecker),")
    print("   e2 = -I, e3 = xyz, Delta = e3^2, I = ([12]^2[34]^2+[13]^2[24]^2+[14]^2[23]^2)/2")
    print("   Newton: p_k = I p_{k-2} + e3 p_{k-3},  p_0=3, p_1=0, p_2=2I")
    p = power_sums(40)
    D = sp.expand(LAM ** 2 * (1 - LAM) ** 2)
    ok = []
    for d in range(4, 17):
        _, _, Phi = four_point_phi(d)
        if d % 2 == 0:
            pred = sp.expand(2 * p[2 * d] - p[d] ** 2)
        else:
            pred = sp.expand(p[d] ** 2)
        q, rem = sp.div(sp.Poly(pred, IS, ES), sp.Poly(ES ** 2, IS, ES))
        good = rem.is_zero
        # substitute the chart values I = lam^2-lam+1, e3 = -(lam^2-lam)
        sub = {IS: INOTE, ES: sp.expand(-(LAM ** 2 - LAM))}
        val = sp.expand(q.as_expr().subs(sub))
        ok.append((d, good, sp.expand(val - Phi) == 0))
    print("   e3^2 | (2 p_2d - p_d^2) [d even] / p_d^2 [d odd], and quotient = Phi:")
    print("  ", [(d, a, b) for d, a, b in ok])
    print("   Pfaffian residual, d odd: pi_{d,4} = p_d / e3 :")
    for d in (5, 7, 9, 11, 13, 15):
        q, rem = sp.div(sp.Poly(p[d], IS, ES), sp.Poly(ES, IS, ES))
        print("     d=%-3d pi = %-40s exact: %s" % (d, sp.factor(q.as_expr()), rem.is_zero))


def task4_perm_in_IDelta():
    print("-- r=4: the permanent candidate in the same I, Delta basis --")
    forms = normalized_chart(4, [LAM])
    Mb = bracket_matrix(forms)
    for d in range(4, 11):
        e = d - 3
        Pm = permanent(power_matrix(Mb, e))
        _, _, Phi = four_point_phi(d)
        cP, tP = express_in_I_Delta(sp.expand(Pm), 2 * e)
        cF, tF = express_in_I_Delta(sp.expand(Phi), 2 * e)
        fmt = lambda cs, ts: " + ".join("%s*I^%d*D^%d" % (c, k, l)
                                        for (k, l), c in zip(ts, cs) if c != 0)
        print("   d=%-3d perm = %-34s  Phi = %s" %
              (d, fmt(cP, tP) if cP else "not in Q[I,D]",
               fmt(cF, tF) if cF else "not in Q[I,D]"))


def task4_perm_closed_form():
    print("-- r=4: perm([ij]^e) = p_e^2 (e even) / 2p_2e - p_e^2 (e odd) --")
    p = power_sums(30)
    forms = normalized_chart(4, [LAM])
    Mb = bracket_matrix(forms)
    sub = {IS: INOTE, ES: sp.expand(-(LAM ** 2 - LAM))}
    res = []
    for e in range(1, 8):
        pm = permanent(power_matrix(Mb, e))
        pred = p[e] ** 2 if e % 2 == 0 else 2 * p[2 * e] - p[e] ** 2
        res.append((e, sp.expand(pm - sp.expand(pred).subs(sub)) == 0))
    print("   ", res)
    D = sp.expand(LAM ** 2 * (1 - LAM) ** 2)
    print("    J^2 = 4 I^3 - 27 Delta :",
          sp.expand(JNOTE ** 2 - (4 * INOTE ** 3 - 27 * D)) == 0)


def task4_r3():
    print("-- r=3: Phi_{d,3} = c * Delta_3^{(d-2)/2} --")
    ts = sp.symbols("t1:4")
    forms = generic_chart(ts)
    Mb = bracket_matrix(forms)
    D3, vand3 = delta_of(Mb)
    for d in (4, 6, 8):
        G = det_exact(power_matrix(Mb, d))
        Phi = exact_quotient(G, D3, ts)
        k = (d - 2) // 2
        c = proportional(sp.expand(Phi), sp.expand(D3 ** k), ts)
        print("   d=%-3d Phi_{d,3} = %s * Delta_3^%d : %s" % (d, c, k, c is not None))
    for d in (5, 7, 9):
        print("   d=%-3d G_{d,3} = 0 : %s" % (d, det_exact(power_matrix(Mb, d)) == 0))


def task4_pfaffian():
    print("-- Pfaffian residual, d odd & r even --")
    print(" (d,r)  Pf=vand*pi  deg pi   Phi = pi^2   pi = c*perm-sqrt")
    for (d, r) in [(5, 4), (7, 4), (7, 6)]:
        data = case_data(d, r)
        gens = data["gens"]
        Mb, vand = data["Mb"], data["vand"]
        Md = power_matrix(Mb, d)
        Pf = pfaffian(Md)
        G = data["G"]
        assert sp.expand(Pf ** 2 - G) == 0, (d, r, "G != Pf^2")
        pi = exact_quotient(Pf, vand, gens)
        if pi is None:
            print(" (%d,%d)  vand does not divide Pf" % (d, r))
            continue
        degpi = sp.Poly(pi, *gens).total_degree()
        sq = sp.expand(pi ** 2 - data["Phi"]) == 0
        e = d - r + 1
        Pm = permanent(power_matrix(Mb, e))
        # for r = 4 the permanent of a symmetric zero-diagonal matrix is (P+Q+R)^2
        rt = sp.sqrt(sp.factor(Pm))
        ratio = sp.cancel(sp.expand(pi) / rt) if rt.is_polynomial(*gens) else None
        print(" (%d,%d)  %-11s %-8s %-12s %s" % (d, r, True, degpi, sq,
                                                 sp.simplify(ratio) if ratio is not None else "sqrt(perm) not poly"))


# --------------------------------------------------------------------------
# task 5 -- transvectants and the Wronskian identification
# --------------------------------------------------------------------------

X, Y = sp.symbols("x y")


def transvectant(f, g, k, m, n):
    """Classical transvectant (f,g)_k for forms of degrees m and n."""
    pref = sp.Rational(sp.factorial(m - k) * sp.factorial(n - k),
                       sp.factorial(m) * sp.factorial(n))
    s = 0
    for i in range(k + 1):
        s += (-1) ** i * sp.binomial(k, i) * \
             sp.diff(f, X, k - i, Y, i) * sp.diff(g, X, i, Y, k - i)
    return sp.expand(pref * s)


def quartic_from_lambda():
    """F with roots inf, 0, 1, lam in the chart above: F = y * x * (x-y) * (x-lam y)."""
    return sp.expand(Y * X * (X - Y) * (X - LAM * Y))


def task5():
    print("== task 5: transvectants and the Wronskian/permanent identification ==")
    F = quartic_from_lambda()
    I_t = sp.expand(transvectant(F, F, 4, 4, 4))
    H = sp.expand(transvectant(F, F, 2, 4, 4))
    J_t = sp.expand(transvectant(F, H, 4, 4, 4))
    print(" transvectant normalization: (f,g)_k = ((m-k)!(n-k)!/(m!n!)) *")
    print("   sum_i (-1)^i C(k,i) d^k f/dx^(k-i)dy^i * d^k g/dx^i dy^(k-i)")
    print(" (F,F)_4            =", sp.factor(I_t))
    print(" (F,(F,F)_2)_4      =", sp.factor(J_t))
    print(" note's I           =", sp.factor(INOTE), " ratio I_note/(F,F)_4 =",
          sp.simplify(INOTE / I_t))
    print(" note's J           =", sp.factor(JNOTE), " ratio J_note/(F,(F,F)_2)_4 =",
          sp.simplify(JNOTE / J_t))
    for m in (2, 3, 4, 5):
        d = 2 * m
        _, _, Phi = four_point_phi(d)
        coeffs, terms = express_in_IJ(sp.expand(Phi), 4 * m - 6)
        print("  Phi_{%d,4} in note I,J : %s over %s" %
              (d, list(zip(terms, coeffs)), "1"))
        # same expansion in transvectant generators
        deg = 4 * m - 6
        tt = [(a, b) for a in range(deg // 2 + 1) for b in range(deg // 3 + 1)
              if 2 * a + 3 * b == deg]
        cs = sp.symbols("k0:%d" % len(tt))
        expr = sum(c * I_t ** a * J_t ** b for c, (a, b) in zip(cs, tt))
        sol = sp.solve(sp.Poly(sp.expand(expr - Phi), LAM).all_coeffs(), cs, dict=True)
        vals = [sp.nsimplify(sol[0].get(c, 0)) for c in cs] if sol else None
        print("  Phi_{%d,4} in transvectants (F,F)_4,(F,(F,F)_2)_4 : %s" %
              (d, list(zip(tt, vals)) if vals else "NO SOLUTION"))
    # Wronskian identification for (4,4): Psi in wedge^4 Sym^4 <-> Sym^4 V
    print("-- Wronskian identification scalar, (d,r)=(4,4) --")
    forms = normalized_chart(4, [LAM])
    Mb = bracket_matrix(forms)
    _, vand = delta_of(Mb)
    # wedge^4 Sym^4 -> (Sym^4)^* by complementary index; then to Sym^4 by B_4.
    d = 4
    cols = []
    for f in forms:
        cols.append([sp.binomial(d, i) * f[0] ** i * f[1] ** (d - i) for i in range(d + 1)])
    W = {}
    for skip in range(d + 1):
        idx = [i for i in range(d + 1) if i != skip]
        Mm = sp.Matrix([[cols[a][i] for i in idx] for a in range(4)])
        W[skip] = sp.expand((-1) ** skip * Mm.det())
    Psi = {k: exact_quotient(v, vand, (LAM,)) for k, v in W.items()}
    # B_4 in the monomial basis: antidiagonal (-1)^(d-i)/C(d,i); raise index
    vec = []
    for i in range(d + 1):
        # B_4(e_i, e_j) = 0 unless j = d-i, value (-1)^(d-i)/C(d,i);
        # raising the functional Psi gives v_i = (-1)^(d-i) C(d,i) Psi[d-i]
        vec.append(sp.expand(Psi[d - i] * (-1) ** (d - i) * sp.binomial(d, i)))
    Fpoly = sp.expand(sum(vec[i] * X ** i * Y ** (d - i) for i in range(d + 1)))
    print("  Psi_{4,4} raised to Sym^4 :", sp.factor(Fpoly))
    print("  F (roots inf,0,1,lam)     :", sp.factor(F))
    print("  ratio                      :", sp.simplify(sp.cancel(Fpoly / F)))
    print("  hence <Psi,Psi> = c^2 * (F,F)_4-norm; c =", sp.simplify(sp.cancel(Fpoly / F)))
    wronskian_raise(6)


def wronskian_raise(d):
    """r = d case: wedge^d Sym^d = (Sym^d)^*  ->  Sym^d V.  Check Psi_{d,d} = c F."""
    r = d
    lams = list(sp.symbols("w4:%d" % (r + 1)))
    forms = normalized_chart(r, lams)
    gens = tuple(lams)
    Mb = bracket_matrix(forms)
    _, vand = delta_of(Mb)
    cols = [[sp.binomial(d, i) * f[0] ** i * f[1] ** (d - i) for i in range(d + 1)]
            for f in forms]
    Psi = {}
    for skip in range(d + 1):
        idx = [i for i in range(d + 1) if i != skip]
        Mm = sp.Matrix([[cols[a][i] for i in idx] for a in range(r)])
        Psi[skip] = exact_quotient(sp.expand((-1) ** skip * Mm.det(method="berkowitz")),
                                   vand, gens)
    vec = [sp.expand(Psi[d - i] * (-1) ** (d - i) * sp.binomial(d, i)) for i in range(d + 1)]
    P = sp.expand(sum(vec[i] * X ** i * Y ** (d - i) for i in range(d + 1)))
    Fd = sp.expand(Y * X * (X - Y) * sp.prod([X - l * Y for l in lams]))
    c = proportional(P, Fd, gens + (X, Y))
    print("-- Wronskian identification scalar, (d,r)=(%d,%d): Psi = c * F, c = %s" %
          (d, d, c))


def main():
    which = sys.argv[1] if len(sys.argv) > 1 else "all"
    if which in ("t1", "all"):
        task1()
    if which in ("t2", "all"):
        task2()
    if which in ("t3", "all"):
        task3()
    if which in ("t4", "all"):
        task4()
        task4_pfaffian()
        task4_plucker()
        task4_IDelta()
        task4_powersum()
        task4_perm_in_IDelta()
        task4_perm_closed_form()
        task4_r3()
    if which in ("t4g",):
        task4(cases=[(4, 3), (6, 3), (4, 4), (6, 4), (5, 4)], generic=True)
    if which in ("t5", "all"):
        task5()


if __name__ == "__main__":
    main()
