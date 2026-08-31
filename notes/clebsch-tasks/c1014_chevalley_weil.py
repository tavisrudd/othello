#!/usr/bin/env python3
"""C1014 -- Chevalley-Weil multiplicities of the anharmonic S_3 acting on

    C_m : y^2 = f_m(lambda),   f_m = square class of Phi_{2m,4},
    Phi_{2m,4} = P_m (P_m + 4 u^{m-1}),  P_m = (1 - L_m^2)/u,
    u = lambda(1-lambda),  L_m the Dickson polynomial of the first kind.

Everything here is an exact symbolic computation over QQ.  The script

  (1) checks the product identity  u^2 Phi_{2m,4} = prod_{eps,eta} (1 + eps
      lambda^m + eta (1-lambda)^m), from which the exact anharmonic
      invariance of Phi (Theorem H, with constant 1) follows in three lines;
  (2) computes the square class f_m, its degree d_m and the genus g;
  (3) checks the two functional equations for f_m;
  (4) builds the matrices of the lifted generators on the basis
      lambda^i dlambda / y, i = 0..g-1, identifies the group they generate
      (dihedral of order 12; the NAIVE lift of tau has (sigma tau)^3 = the
      hyperelliptic involution, so an honest S_3 needs tau' = iota . tau),
      and decomposes H^0(Omega) into S_3-irreps;
  (5) cross-checks the answer against the Riemann-Hurwitz / Chevalley-Weil
      count for the degree-3 subcover C_m -> C_m/<3-cycle>;
  (6) compares with the closed form  a = b = floor((m-2)/3),
      c = (g - 2a)/2, and with the measured table of the prior report.

Replay:
    uv run --with sympy python3 notes/clebsch-tasks/c1014_chevalley_weil.py
"""

import sys

from sympy import (Poly, QQ, Matrix, Rational, binomial, eye, expand, factor,
                   simplify, symbols, sqf_list)

lam, u = symbols('lam u')

MEASURED = {3: (0, 0, 1), 4: (0, 0, 1), 5: (1, 1, 2),
            6: (1, 1, 3), 7: (1, 1, 3), 8: (2, 2, 4)}


# ---------------------------------------------------------------- objects

def dickson_L(m):
    """L_k(u) = lambda^k + (1-lambda)^k with u = lambda(1-lambda)."""
    a, b = Poly(2, u, domain=QQ), Poly(1, u, domain=QQ)
    if m == 0:
        return a
    for _ in range(m - 1):
        a, b = b, b - Poly(u, u, domain=QQ) * a
    return b


def phi_u(m):
    """Phi_{2m,4} as a polynomial in u."""
    L = dickson_L(m)
    one = Poly(1, u, domain=QQ)
    num = one - L * L
    P, rem = divmod(num, Poly(u, u, domain=QQ))
    assert rem.is_zero, "u does not divide 1 - L_m^2"
    return P * (P + Poly(4, u, domain=QQ) * Poly(u, u, domain=QQ) ** (m - 1))


def phi_lam(m):
    """Phi_{2m,4} as a polynomial in lambda."""
    return Poly(phi_u(m).as_expr().subs(u, lam * (1 - lam)), lam, domain=QQ)


def product_form(m):
    """prod_{eps,eta in {+-1}} (1 + eps lambda^m + eta (1-lambda)^m)."""
    s, t = lam ** m, (1 - lam) ** m
    out = 1
    for eps in (1, -1):
        for eta in (1, -1):
            out *= (1 + eps * s + eta * t)
    return Poly(expand(out), lam, domain=QQ)


def square_class(p, var=lam):
    """Product of the odd-multiplicity irreducible factors, with the constant."""
    coeff, facs = sqf_list(p.as_expr(), var)
    out = Poly(coeff, var, domain=QQ)
    for base, mult in facs:
        if mult % 2 == 1:
            out = out * Poly(base, var, domain=QQ)
    return out


def mult_of_I(p):
    """Multiplicity of I = lambda^2 - lambda + 1 in p."""
    I = Poly(lam ** 2 - lam + 1, lam, domain=QQ)
    k = 0
    while True:
        q, r = divmod(p, I)
        if not r.is_zero:
            return k
        p, k = q, k + 1


# ------------------------------------------------- differentials, matrices

def matrices(f, g):
    """Matrices of sigma^*, tau^* and tau'^* on the basis omega_i = lam^i dlam/y.

    sigma : (lam, y) -> (1-lam, y).       sigma^* omega_i = -(1-lam)^i dlam/y.
    tau   : (lam, y) -> (1/lam, y/lam^k), k = d/2 = g+1  (the naive lift).
            tau^* omega_i = -lam^{k-i-2} dlam/y = -omega_{g-1-i}.
    tau'  = iota . tau : (lam, y) -> (1/lam, -y/lam^k).   tau'^* = -tau^*.
    """
    k = g + 1
    S = [[0] * g for _ in range(g)]
    for i in range(g):
        coeffs = Poly(expand(-(1 - lam) ** i), lam, domain=QQ).all_coeffs()[::-1]
        for j, cj in enumerate(coeffs):
            S[j][i] = cj
    T = [[0] * g for _ in range(g)]
    for i in range(g):
        e = k - i - 2                      # exponent of lam in tau^* omega_i
        assert 0 <= e <= g - 1
        T[e][i] = -1
    return Matrix(S), Matrix(T)


def s3_multiplicities(chi_e, chi_t, chi_3):
    a = Rational(chi_e + 3 * chi_t + 2 * chi_3, 6)
    b = Rational(chi_e - 3 * chi_t + 2 * chi_3, 6)
    c = Rational(chi_e - chi_3, 3)
    return a, b, c


def alt_binom(n):
    """a_n = sum_i (-1)^i C(n-i, i); period 6, generating function 1/(1-x+x^2)."""
    return sum((-1) ** i * binomial(n - i, i) for i in range(0, n // 2 + 1))


# -------------------------------------------------------------------- main

def run(mmax):
    rows = []
    print("m  degPhi  multI  d_m   g   trS  trT'   tr(ST)  (a,b,c)   closed form"
          "   RH g3  2a  measured")
    for m in range(3, mmax + 1):
        Ph = phi_lam(m)

        # (1) product identity  u^2 Phi = prod (1 + eps lam^m + eta (1-lam)^m)
        lhs = Poly(expand((lam * (1 - lam)) ** 2), lam, domain=QQ) * Ph
        assert (lhs - product_form(m)).is_zero, f"product identity fails at m={m}"

        # (2) square class, degree, genus
        vI = mult_of_I(Ph)
        f = square_class(Ph)
        d = f.degree()
        assert d % 2 == 0, f"odd square-class degree at m={m}"
        g = d // 2 - 1

        # (3) functional equations for f_m
        fe = f.as_expr()
        assert expand(fe.subs(lam, 1 - lam) - fe) == 0, f"sigma-eqn fails at m={m}"
        rev = expand(lam ** d * fe.subs(lam, 1 / lam))
        assert expand(rev - fe) == 0, f"tau-eqn fails at m={m}"

        # (4) matrices and the group
        S, T = matrices(f, g)
        Tp = -T                                    # tau' = iota . tau
        I_g = eye(g)
        assert S * S == I_g, f"sigma^2 != 1 at m={m}"
        assert T * T == I_g, f"tau^2 != 1 at m={m}"
        assert Tp * Tp == I_g, f"tau'^2 != 1 at m={m}"
        M = S * T
        assert M ** 3 == -I_g, f"(sigma tau)^3 != iota at m={m}"
        Mp = S * Tp
        assert Mp ** 3 == I_g, f"(sigma tau')^3 != 1 at m={m}"
        assert S * Mp * S == Mp ** 2, f"S_3 relation fails at m={m}"

        chi_e, chi_t, chi_3 = g, S.trace(), Mp.trace()
        assert Tp.trace() == chi_t, f"transposition traces differ at m={m}"
        assert chi_t == 0, f"trace of a transposition != 0 at m={m}"
        assert chi_3 == -alt_binom(g - 1), f"3-cycle trace formula fails at m={m}"
        a, b, c = s3_multiplicities(chi_e, chi_t, chi_3)
        assert a + b + 2 * c == g

        # (5) Riemann-Hurwitz cross-checks.
        # (5a) the 3-cycle fixes the fibres over the two roots of I; that fibre
        #      has 1 point if I | f_m (m = 2 mod 3) and 2 points otherwise.
        nfix3 = 2 if mult_of_I(f) > 0 else 4
        g3 = Rational(2 * g - 2 + 6 - 2 * nfix3, 6)
        assert g3 == 2 * a, f"RH cross-check (3-cycle) fails at m={m}"
        # (5b) the transposition sigma fixes exactly the two points over
        #      lambda = 1/2 (f_m(1/2) != 0) and swaps the two points at
        #      infinity (g even), so #Fix = 2 and g(D_1) = (2g+2-2)/4 = g/2.
        assert f.eval(Rational(1, 2)) != 0, f"f_m(1/2) = 0 at m={m}"
        assert a + c == Rational(g, 2), f"RH cross-check (sigma) fails at m={m}"

        # (6) closed form
        a_cf = (m - 2) // 3
        g_cf = 2 * m - 4 - (2 if m % 3 == 1 else 0)
        c_cf = (g_cf - 2 * a_cf) // 2
        assert g == g_cf, f"genus law fails at m={m}"
        assert (a, b, c) == (a_cf, a_cf, c_cf), f"closed form fails at m={m}"

        meas = MEASURED.get(m, None)
        if meas is not None:
            assert (a, b, c) == meas, f"disagrees with the measured table at m={m}"
        rows.append((m, Ph.degree(), vI, d, g, chi_t, Tp.trace(), M.trace(),
                     (a, b, c), (a_cf, a_cf, c_cf), g3, 2 * a, meas))
        print(f"{m:2d} {Ph.degree():6d} {vI:6d} {d:5d} {g:3d} "
              f"{int(chi_t):4d} {int(Tp.trace()):5d} {int(M.trace()):8d}  "
              f"{(int(a),int(b),int(c))}  {(a_cf,a_cf,c_cf)}  "
              f"{int(g3):5d}  {int(2*a):3d}  {meas}")
    return rows


# ------------------------------------- explicit models of the S_3-quotients
#
# Covariant forms of the anharmonic group on P^1 (homogeneous in (X, Z),
# lambda = X/Z), with their multipliers under A_sigma = [[-1,1],[0,1]] and
# A_tau = [[0,1],[1,0]]:
#
#   I = X^2 - X Z + Z^2         degree 2   (sigma:+1, tau:+1)
#   W = X Z (X - Z)             degree 3   (sigma:+1, tau:-1)
#   V = (2X-Z)(X+Z)(X-2Z)       degree 3   (sigma:-1, tau:+1)
#
# Dehomogenised, w(lambda) = -u and v(lambda) = (2 lam -1)(lam+1)(lam-2).
# J = I^3 / W^2 = I^3 / u^2 generates QQ(lambda)^{S_3}, and K = V/W is
# sign-covariant (sigma: -1, tau: -1, i.e. the sgn character), so K^2 is
# invariant.  The naive lift of gamma sends y to y/(c lam + d)^k, k = g+1;
# hence for a degree-k covariant Omega with multipliers (sigma:+1, tau:-1)
# the function Y = y/Omega is invariant under the HONEST S_3 = <sigma, tau'>.
# k is odd, so Omega = W . I^{(k-3)/2} works and
#
#   C_m/S_3   :  Y^2 = f_m / (u^2 I^{k-3})   =: R(J)
#   C_m/S_3'  :  Z^2 = K^2 . R(J)            (S_3' = <3-cycle, sigma.iota>)
#
# with A_triv = Jac(C_m/S_3) and A_sgn = Jac(C_m/S_3').

xJ = symbols('xJ')


def express_in_J(p, q, nmax=8):
    """Find A, B in QQ[x], deg <= n, with p/q = A(J)/B(J), J = I^3/u^2."""
    Ipol = Poly(lam ** 2 - lam + 1, lam, domain=QQ)
    upol = Poly(lam * (1 - lam), lam, domain=QQ)
    for n in range(1, nmax + 1):
        # Abar = sum a_i I^{3i} u^{2(n-i)},  Bbar likewise; p.Bbar = q.Abar.
        basis = [Ipol ** (3 * i) * upol ** (2 * (n - i)) for i in range(n + 1)]
        cols = []
        for bs in basis:                     # a_i coefficients
            cols.append((-q * bs).all_coeffs()[::-1])
        for bs in basis:                     # b_i coefficients
            cols.append((p * bs).all_coeffs()[::-1])
        rows = max(len(c) for c in cols)
        M = Matrix([[c[r] if r < len(c) else 0 for c in cols] for r in range(rows)])
        ns = M.nullspace()
        if ns:
            vec = ns[0]
            A = Poly(sum(vec[i] * xJ ** i for i in range(n + 1)), xJ, domain=QQ)
            B = Poly(sum(vec[n + 1 + i] * xJ ** i for i in range(n + 1)), xJ, domain=QQ)
            if not A.is_zero and not B.is_zero:
                return A, B
    raise RuntimeError("no expression in J found")


def quotient_models(m):
    """Square-class models in J of C_m/S_3 (trivial part) and C_m/S_3' (sign)."""
    f = square_class(phi_lam(m))
    d = f.degree()
    g = d // 2 - 1
    k = g + 1
    assert k % 2 == 1
    num = f
    den = (Poly(lam * (1 - lam), lam, domain=QQ) ** 2 *
           Poly(lam ** 2 - lam + 1, lam, domain=QQ) ** (k - 3))
    A, B = express_in_J(num, den)
    # verification: f/(u^2 I^{k-3}) - A(J)/B(J) = 0 identically in lambda.
    Jexpr = (lam ** 2 - lam + 1) ** 3 / (lam * (1 - lam)) ** 2
    chk = simplify(num.as_expr() / den.as_expr()
                   - A.as_expr().subs(xJ, Jexpr) / B.as_expr().subs(xJ, Jexpr))
    assert chk == 0, f"J-expression check failed at m={m}"
    Rtriv = square_class(A * B, xJ)
    # K^2 = v^2 / u^2 with v = (2lam-1)(lam+1)(lam-2)
    vnum = Poly(expand((2 * lam - 1) * (lam + 1) * (lam - 2)) ** 2, lam, domain=QQ)
    vden = Poly(expand((lam * (1 - lam)) ** 2), lam, domain=QQ)
    SA, SB = express_in_J(vnum, vden)
    chkK = simplify(vnum.as_expr() / vden.as_expr()
                    - SA.as_expr().subs(xJ, Jexpr) / SB.as_expr().subs(xJ, Jexpr))
    assert chkK == 0, f"K^2 J-expression check failed at m={m}"
    Rsgn = square_class(SA * SB * A * B, xJ)
    return Rtriv, Rsgn, (A, B), (SA, SB)


def hyp_genus(p):
    d = p.degree()
    return (d - 1) // 2 if d >= 1 else 0


def syzygy_check():
    """V^2 = 4 I^3 - 27 W^2 (classical discriminant syzygy); hence K^2 = 4J-27."""
    V = expand(((2 * lam - 1) * (lam + 1) * (lam - 2)) ** 2)
    rhs = expand(4 * (lam ** 2 - lam + 1) ** 3 - 27 * (lam * (lam - 1)) ** 2)
    assert expand(V - rhs) == 0, "syzygy V^2 = 4 I^3 - 27 W^2 fails"
    return True


def run_quotients(mlist, gp_path=None):
    assert syzygy_check()
    gp_lines = []
    print("\nexplicit S_3-quotient models (Y^2 = R_triv(J), Z^2 = R_sgn(J))")
    for m in mlist:
        Rt, Rs, _, _ = quotient_models(m)
        a = (m - 2) // 3
        gt, gs = hyp_genus(Rt), hyp_genus(Rs)
        print(f"m={m}: a={a}  deg R_triv={Rt.degree()} genus={gt}   "
              f"deg R_sgn={Rs.degree()} genus={gs}")
        print(f"   R_triv = {factor(Rt.as_expr())}")
        print(f"   R_sgn  = {factor(Rs.as_expr())}")
        assert gt == a and gs == a, f"quotient genus != a at m={m}"
        for tag, R in (("triv", Rt), ("sgn", Rs)):
            if R.degree() in (3, 4):
                co = [str(c) for c in R.all_coeffs()]
                gp_lines.append(f'R = Pol([{",".join(co)}], \'x);')
                gp_lines.append('E = ellinit(ellfromeqn(y^2 - R));')
                gp_lines.append('E = ellminimalmodel(E);')
                gp_lines.append('gr = ellglobalred(E);')
                gp_lines.append(
                    f'print("m{m}{tag} cond=", gr[1], " fact=", factor(gr[1]), '
                    '" ap=", [[p, ellap(E,p)] | p <- primes(12), gr[1]%p != 0]);')
    if gp_path and gp_lines:
        with open(gp_path, "w") as fh:
            fh.write("\\\\ generated by c1014_chevalley_weil.py -- do not edit\n")
            fh.write("\n".join(gp_lines))
            fh.write("\nquit;\n")
        print(f"wrote {gp_path}")


def periodicity_check():
    """a_n = sum_i (-1)^i C(n-i,i) has period 6: 1,1,0,-1,-1,0."""
    pat = [alt_binom(n) for n in range(6)]
    assert pat == [1, 1, 0, -1, -1, 0], pat
    for n in range(60):
        assert alt_binom(n) == pat[n % 6], n
    return pat


if __name__ == "__main__":
    mmax = int(sys.argv[1]) if len(sys.argv) > 1 else 16
    print("period-6 pattern of a_n = sum_i (-1)^i C(n-i,i):", periodicity_check())
    run(mmax)
    print("all assertions passed for m = 3 ..", mmax)
    import os
    here = os.path.dirname(os.path.abspath(__file__))
    run_quotients([3, 4, 5, 6, 7, 8],
                  os.path.join(here, "c1014_cw_quotients.gp"))
