#!/usr/bin/env python3
"""Levelt exponent classes of Picard-rank-one Fano threefolds from their
quantum periods.

Pipeline
  1. unregularized quantum period G(t) = sum c_d t^{r d} (r = Fano index),
     generated to many terms from a closed formula;
  2. guess the order-four operator L = sum_j p_j(s) theta^j, theta = s d/ds,
     s = t^r, annihilating G (heavily overdetermined);
  3. the unit section v_0 = 1 of the quantum D-module satisfies the same
     relation with theta = q d/dq = z^{-1} Theta, Theta = z q d/dq, s = q/z^r;
     clearing powers of z gives L' = sum_j b_j(q,z) Theta^j and the companion
     matrix C(q,z) of Theta on the cyclic basis v_k = Theta^k v_0;
  4. flat sections y satisfy  z^2 y' = (r C(q,z) - z diag(k - 3/2)) y,
     from nabla_{z dz} v_k = (k - 3/2) v_k - (r/z) v_{k+1};
  5. expand at z = 0 to second order and run the block reduction of
     c925-fable-levelt-exponent-tool.py (generalized to A = A0 + z A1 + z^2 A2).

Validation: the cubic threefold, whose companion data are built directly from
its known small quantum product, must give exponents {1/6, 5/6}.
"""
import sys
from fractions import Fraction as F
from math import factorial as fa

import sympy as sp
from sympy import Rational as Q

sys.path.insert(0, __file__.rsplit("/", 1)[0])
from importlib import import_module
tool = import_module("c925-fable-levelt-exponent-tool".replace("-", "_")) if False else None


# ---------- generic block reduction with A(z) = A0 + z A1 + z^2 A2 ----------

def sylvester_solve(Ji, Jj, C):
    n, m = Ji.shape[0], Jj.shape[0]
    xs = sp.symbols(f"x0:{n*m}")
    X = sp.Matrix(n, m, xs)
    sol = sp.solve(list(Ji * X - X * Jj - C), xs, dict=True)
    assert len(sol) == 1
    return X.subs(sol[0])


def exponent_classes(A0, A1, A2, label):
    P, J = A0.jordan_form()
    n = A0.shape[0]
    blocks, i = [], 0
    while i < n:
        j = i + 1
        while j < n and J[j, j] == J[i, i] and J[j - 1, j] != 0:
            j += 1
        blocks.append((i, j)); i = j
    merged = []
    for (a, b) in blocks:
        if merged and J[merged[-1][0], merged[-1][0]] == J[a, a]:
            merged[-1] = (merged[-1][0], b)
        else:
            merged.append((a, b))
    blocks = merged
    Pi = P.inv()
    A1j, A2j = sp.simplify(Pi * A1 * P), sp.simplify(Pi * A2 * P)
    G1 = sp.zeros(n, n)
    for (a, b) in blocks:
        for (c, d) in blocks:
            if (a, b) != (c, d):
                G1[a:b, c:d] = sylvester_solve(J[a:b, a:b], J[c:d, c:d], -A1j[a:b, c:d])
    B1 = sp.simplify(A1j + J * G1 - G1 * J)
    B2 = sp.simplify(A2j + A1j * G1 - G1 * B1 - G1)
    print(f"== {label}")
    out = []
    for (a, b) in blocks:
        u = sp.nsimplify(J[a, a])
        if b - a == 2 and J[a, a + 1] != 0:
            b1 = B1[a:b, a:b]
            assert sp.simplify(b1[1, 0]) == 0, f"(2,1) entry {b1[1,0]}"
            R = sp.Matrix([[b1[0, 0], J[a, a + 1]], [B2[a + 1, a], b1[1, 1] - 1]])
            lam = sp.symbols("lam")
            cp = sp.factor(R.charpoly(lam).as_expr())
            d2 = sp.simplify(R.trace() ** 2 - 4 * R.det())
            print(f"  eigenvalue {u}: J2 block, residue charpoly {cp}, delta^sharp {d2}")
            out.append((u, cp, d2))
        else:
            print(f"  eigenvalue {u}: dim {b-a}")
    return out


# ---------- companion data from a known small quantum product (validation) ----------

def companion_from_product(Hstar, r, q, z):
    """v_k = (z q d/dq + H*)^k 1 with H* the matrix of quantum multiplication
    by H on (1,H,H^2,H^3) over Q[q]; returns companion matrix C(q,z) and the
    relation coefficients."""
    n = Hstar.shape[0]
    v = [sp.Matrix([1] + [0] * (n - 1))]
    for k in range(n):
        w = v[-1]
        v.append(sp.expand(z * q * sp.diff(w, q) + Hstar * w))
    V = sp.Matrix.hstack(*v[:n])
    coeffs = sp.simplify(V.inv() * v[n])  # v_n = sum coeffs_k v_k
    C = sp.zeros(n, n)
    for k in range(n - 1):
        C[k + 1, k] = 1
    C[:, n - 1] = coeffs
    return C


def flat_system_from_companion(C, r, n, q, z, qval):
    A = (r * C - z * sp.diag(*[Q(2 * k - 3, 2) for k in range(n)])).subs(q, qval)
    A = A.applyfunc(lambda e: sp.series(e, z, 0, 3).removeO())
    A0 = A.applyfunc(lambda e: e.subs(z, 0))
    A1 = A.applyfunc(lambda e: e.coeff(z, 1))
    A2 = A.applyfunc(lambda e: e.coeff(z, 2))
    return A0, A1, A2


# ---------- operator guessing from a series ----------

def guess_operator(coeffs, order, degree):
    """Find p_{j,m} with sum_{j<=order, m<=degree} p_{j,m} s^m theta^j G = 0,
    G = sum coeffs[d] s^d.  Returns matrix p[j][m] (exact rationals) or None."""
    N = len(coeffs)
    unknowns = [(j, m) for j in range(order + 1) for m in range(degree + 1)]
    rows = []
    for d in range(N):
        row = []
        for (j, m) in unknowns:
            # coefficient of s^d in s^m theta^j G  is (d-m)^j c_{d-m}
            row.append(F((d - m) ** j) * coeffs[d - m] if d - m >= 0 else F(0))
        rows.append(row)
    M = sp.Matrix(rows)
    ns = M.nullspace()
    if len(ns) != 1:
        return None, len(ns)
    vec = ns[0]
    vec = vec / sp.gcd(list(vec)) if all(x.is_integer for x in vec) else vec
    p = [[0] * (degree + 1) for _ in range(order + 1)]
    for (j, m), val in zip(unknowns, vec):
        p[j][m] = sp.nsimplify(val)
    return p, 1


def companion_from_operator(p, order, degree, r, q, z):
    """theta = z^{-1} Theta, s = q z^{-r}; L' = z^{order + r*degree} L."""
    b = [0] * (order + 1)
    for j in range(order + 1):
        for m in range(degree + 1):
            b[j] += p[j][m] * q ** m * z ** (order + r * degree - r * m - j)
    lead = sp.expand(b[order])
    n = order
    C = sp.zeros(n, n)
    for k in range(n - 1):
        C[k + 1, k] = 1
    for j in range(n):
        C[j, n - 1] = -sp.cancel(b[j] / lead)
    return C


# ---------- quantum periods ----------

def period_V14(N):
    H = [F(0)]
    for m in range(1, N + 1):
        H.append(H[-1] + F(1, m))
    S = [F(0)] * (N + 1)
    for l in range(N + 1):
        for m in range(N + 1 - l):
            d = l + m
            S[d] += (-1) ** d * F(fa(d) ** 5, fa(l) ** 6 * fa(m) ** 6) * (1 - 6 * (m - l) * H[m])
    E = [F((-4) ** k, fa(k)) for k in range(N + 1)]
    return [sum(E[k] * S[d - k] for k in range(d + 1)) for d in range(N + 1)]


def _harm(N):
    H = [F(0)]
    for m in range(1, 3 * N + 2):
        H.append(H[-1] + F(1, m))
    return H


def period_V12(N):
    H = _harm(N)
    S = [F(0)] * (N + 1)
    for l in range(N + 1):
        for m in range(N + 1 - l):
            d = l + m
            S[d] += (-1) ** d * F(fa(d) * fa(2 * l + m) * fa(l + 2 * m), fa(l) ** 5 * fa(m) ** 5) * \
                (1 + (m - l) * (H[2 * l + m] + 2 * H[l + 2 * m] - 5 * H[m]))
    E = [F((-5) ** k, fa(k)) for k in range(N + 1)]
    return [sum(E[k] * S[d - k] for k in range(d + 1)) for d in range(N + 1)]


def period_V10(N):
    H = _harm(N)
    S = [F(0)] * (N + 1)
    for l in range(N + 1):
        for m in range(N + 1 - l):
            d = l + m
            S[d] += (-1) ** d * F(fa(d) ** 2 * fa(2 * d), fa(l) ** 5 * fa(m) ** 5) * (1 - 5 * (m - l) * H[m])
    E = [F((-6) ** k, fa(k)) for k in range(N + 1)]
    return [sum(E[k] * S[d - k] for k in range(d + 1)) for d in range(N + 1)]


def period_V2(N):
    # index 1: G(t) = e^{-120 t} sum_d t^d (6d)!/((d!)^4 (3d)!)
    S = [F(fa(6 * d), fa(d) ** 4 * fa(3 * d)) for d in range(N + 1)]
    E = [F((-120) ** k, fa(k)) for k in range(N + 1)]
    return [sum(E[k] * S[d - k] for k in range(d + 1)) for d in range(N + 1)]


def run_rank_one(name, G, r, expect, qval=Q(1)):
    q, z = sp.symbols("q z")
    if r == 2:
        assert all(G[d] == 0 for d in range(1, len(G), 2))
        G = G[::2]
    for degree in range(1, 7):
        p, k = guess_operator(G, 4, degree)
        if p is not None:
            break
    print(f"{name}: order-4 operator of degree {degree} in s=t^{r} ({k} relation); p4 =",
          [str(x) for x in p[4]])
    C = companion_from_operator(p, 4, degree, r, q, z)
    A0, A1, A2 = flat_system_from_companion(C, r, 4, q, z, qval)
    print(f"{name} c1* charpoly at q={qval}:", sp.factor(A0.charpoly().as_expr()))
    return exponent_classes(A0, A1, A2, f"{name} (prediction: {expect})")


if __name__ == "__main__":
    q, z = sp.symbols("q z")
    # validation: cubic threefold from its known product, index 2
    Hstar = sp.Matrix([[0, 6 * q, 0, 36 * q**2], [1, 0, 15 * q, 0], [0, 1, 0, 6 * q], [0, 0, 1, 0]])
    C = companion_from_product(Hstar, 2, q, z)
    A0, A1, A2 = flat_system_from_companion(C, 2, 4, q, z, Q(1, 3))
    exponent_classes(A0, A1, A2, "cubic threefold via cyclic companion basis (expect {1/6,5/6}, delta 4/9)")

    # V14 from its quantum period, index 1
    N = 40
    G = period_V14(N)
    for degree in range(1, 6):
        p, k = guess_operator(G, 4, degree)
        if p is not None:
            break
    print(f"V14: operator order 4 degree {degree} found ({k} relation); leading coefficients",
          [str(x) for x in p[4]])
    C = companion_from_operator(p, 4, degree, 1, q, z)
    A0, A1, A2 = flat_system_from_companion(C, 1, 4, q, z, Q(1))
    print("V14 c1* at z=0, charpoly:", sp.factor(A0.charpoly().as_expr()))
    exponent_classes(A0, A1, A2, "V14 (prediction: class {1/6,5/6})")
    # regularized-series checks against CCGK
    assert [fa(d) * period_V12(9)[d] for d in range(4)] == [1, 0, 48, 600]
    assert [fa(d) * period_V10(9)[d] for d in range(4)] == [1, 0, 78, 1320]
    assert [fa(d) * period_V2(5)[d] for d in range(4)] == [1, 0, 68760, 55200000]
    run_rank_one("V12", period_V12(N), 1, "class {1/2,1/2}, Ku = D^b(C_7)")
    run_rank_one("V10", period_V10(N), 1, "Gushel-Mukai; Ku Enriques-type")
    run_rank_one("V2", period_V2(N), 1, "index-one sextic double solid", Q(1, 10**4))
