#!/usr/bin/env python3
"""Exact K-algebra calculation for the C904 universal-Ext c3 gate.

Run with:
  uv run --with sympy python notes/2026-08-10-c904-universal-ext-bidegree.py

The script computes the algebraic numerical K-lattice of a cubic threefold,
the integral external-product matrix for the universal Ext complex, and the
codimension-(1,3) part of c4(-W).  Variables y{i}_{k} are the kth power-sum
classes k! ch_k(T_i) of the four tautological index classes on the right
factor; x{i} is c1(T_i) on the left factor.
"""

from fractions import Fraction as F

import sympy as sp
from sympy.matrices.normalforms import smith_normal_form
from sympy.polys.domains import ZZ


def mul(a, b):
    return tuple(sum(a[i] * b[k - i] for i in range(k + 1)) for k in range(4))


def dual(a):
    return (a[0], -a[1], a[2], -a[3])


# Coefficients in 1,H,H^2,H^3.  The basis is
# O_X, O_H, O_l, O_p; integration sends H^3 to 3.
basis = (
    (F(1), F(0), F(0), F(0)),
    (F(0), F(1), F(-1, 2), F(1, 6)),
    (F(0), F(0), F(1, 3), F(0)),
    (F(0), F(0), F(0), F(1, 3)),
)
td_x = (F(1), F(1), F(2, 3), F(1, 3))
v = (F(3), F(-1), F(-1, 2), F(1, 6))

tensor_euler = sp.Matrix(
    [[3 * mul(mul(a, b), td_x)[3] for b in basis] for a in basis]
)
ext_euler = sp.Matrix(
    [[3 * mul(mul(dual(a), b), td_x)[3] for b in basis] for a in basis]
)
ranks = sp.Matrix([3 * mul(mul(v, b), td_x)[3] for b in basis])

# If T_j = p_!(E tensor e_j), then the algebraic Kunneth coefficients of E
# are T H^{-1}.  Pairing E_1^vee with E_2 gives this external-product matrix.
ext_external = tensor_euler.inv() * ext_euler * tensor_euler.inv()

assert tensor_euler.det() == 1
assert ext_euler.det() == 1
assert ext_external.det() == 1
assert list(ranks) == [0, 0, 2, 3]

x = sp.symbols("x0:4")
y = {(i, k): sp.symbols(f"y{i}_{k}") for i in range(4) for k in range(1, 5)}


def ypow(i, k):
    return ranks[i] if k == 0 else y[i, k]


# P_k is the kth Chern-root power sum of -W.  Retain only left degrees zero
# and one: P_k = A_k + B_k, with B_k linear in the x_i.
A = {}
B = {}
for k in range(1, 5):
    A[k] = -sum(
        ext_external[i, j] * ranks[i] * ypow(j, k)
        for i in range(4)
        for j in range(4)
    )
    B[k] = k * sum(
        ext_external[i, j] * x[i] * ypow(j, k - 1)
        for i in range(4)
        for j in range(4)
    )

# Linear-left part of e4=(P1^4-6P1^2P2+3P2^2+8P1P3-6P4)/24.
linear_e4 = sp.expand(
    (
        4 * A[1] ** 3 * B[1]
        - 12 * A[1] * B[1] * A[2]
        - 6 * A[1] ** 2 * B[2]
        + 6 * A[2] * B[2]
        + 8 * B[1] * A[3]
        + 8 * A[1] * B[3]
        - 6 * B[4]
    )
    / 24
)

coefficients = [sp.factor(linear_e4.coeff(xi)) for xi in x]
assert sp.expand(linear_e4 - sum(x[i] * coefficients[i] for i in range(4))) == 0

c = {(i, k): sp.symbols(f"c{i}_{k}") for i in range(4) for k in range(1, 4)}
power_to_chern = {}
for i in range(4):
    c1, c2, c3 = (c[i, k] for k in range(1, 4))
    power_to_chern[y[i, 1]] = c1
    power_to_chern[y[i, 2]] = c1**2 - 2 * c2
    power_to_chern[y[i, 3]] = c1**3 - 3 * c1 * c2 + 3 * c3
chern_coefficients = [sp.factor(value.subs(power_to_chern)) for value in coefficients]
for value in chern_coefficients:
    assert sp.Poly(value, *[c[i, k] for i in range(4) for k in range(1, 4)]).domain == ZZ
q_class = sp.expand(chern_coefficients[2] / 3)
assert sp.expand(chern_coefficients[2] - 3 * q_class) == 0
assert sp.expand(chern_coefficients[3] + 2 * q_class) == 0

print("tensor Euler matrix H:")
print(tensor_euler)
print("SNF(H):")
print(smith_normal_form(tensor_euler, domain=ZZ))
print("Ext Euler matrix G:")
print(ext_euler)
print("SNF(G):")
print(smith_normal_form(ext_euler, domain=ZZ))
print("tautological ranks:", list(ranks))
print("external-product matrix C=H^-1 G H^-1:")
print(ext_external)
print("c4(-W)_(1,3) Chern-coefficient summaries (terms, content):")
chern_variables = [c[i, k] for i in range(4) for k in range(1, 4)]
for i, coefficient in enumerate(chern_coefficients):
    polynomial = sp.Poly(coefficient, *chern_variables)
    print(f"C{i}: terms={len(polynomial.terms())} content={polynomial.content()}")
print("exact relation: C2=3Q and C3=-2Q")
