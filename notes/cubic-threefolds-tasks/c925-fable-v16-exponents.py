#!/usr/bin/env python3
"""C925: Levelt exponent class of V16 from Theorem F.1 of Coates--Corti--
Galkin--Kasprzyk (arXiv:1303.3288, Appendix F, read from the cached PDF).

V16 (index one, genus nine) is cut out of Gr(3,6) by a generic section of
(det S^*)^{+3} + Lambda^2 S^*, i.e. F.1 parameters r=3, n=6, a=3, e=1,
b=c=d=0, so k = a + (r-1)e - n = -1 and the Novikov weight of (l1,l2,l3)
is t^{|l|}.  The abelianized I-function lives in Q[p1,p2,p3]/(p_i^6); its
Weyl-anti-invariant part is Omega * Itw + higher, Omega = prod_{i<j}(p_j-p_i),
and the H^0 component of the quotient is the coefficient of p2 p3^2 in the
total-degree-3 part of the sum.  We therefore work in the ring truncated at
total degree 3 throughout.

Validation: e^{alpha t} Itw(t) must reproduce the nine regularized period
coefficients printed by CCGK for V16:
  1, 0, 24, 192, 2904, 40320, 611520, 9515520, 152412120, 2491104000.
The operator-guessing, companion, and block-reduction stages are imported
from c925-fable-rank-one-exponents.py (same directory), so the exponent
extraction is byte-identical to the one validated on the cubic and V14.

Prediction under the Serre-trace dictionary: Ku(V16) = D^b(C_3), class
{1/2, 1/2}, delta^sharp = 0.

Replay:
    uv run --with sympy python3 \
      notes/cubic-threefolds-tasks/c925-fable-v16-exponents.py
"""
import importlib.util
import itertools
import sys
from fractions import Fraction as F
from math import factorial as fa

import sympy as sp
from sympy import Rational as Q

_dir = __file__.rsplit("/", 1)[0]
spec = importlib.util.spec_from_file_location(
    "rank_one", _dir + "/c925-fable-rank-one-exponents.py")
rank_one = importlib.util.module_from_spec(spec)
sys.modules["rank_one"] = rank_one
spec.loader.exec_module(rank_one)   # __main__ guard keeps its battery off

# ---- truncated polynomial ring Q[p1,p2,p3] / (total degree > 3) ----------
MONS = [m for m in sorted(itertools.product(range(4), repeat=3))
        if sum(m) <= 3]
IDX = {m: i for i, m in enumerate(MONS)}
DIM = len(MONS)


def unit():
    v = [F(0)] * DIM
    v[IDX[(0, 0, 0)]] = F(1)
    return v


def mul_linear(v, const, coeffs):
    """v * (const + coeffs.p), truncated at total degree 3."""
    w = [x * const for x in v]
    for m, x in zip(MONS, v):
        if x == 0 or sum(m) == 3:
            continue
        for j in range(3):
            if coeffs[j]:
                mm = list(m)
                mm[j] += 1
                w[IDX[tuple(mm)]] += x * coeffs[j]
    return w


def mul(v, w):
    out = [F(0)] * DIM
    for m1, x in zip(MONS, v):
        if x == 0:
            continue
        for m2, y in zip(MONS, w):
            if y == 0:
                continue
            m = (m1[0] + m2[0], m1[1] + m2[1], m1[2] + m2[2])
            if sum(m) <= 3:
                out[IDX[m]] += x * y
    return out


def inv_linear(const, coeffs):
    """(const + coeffs.p)^{-1} truncated: geometric series in -coeffs.p/const."""
    assert const != 0
    c = F(const)
    out = [F(0)] * DIM
    term = unit()
    for _ in range(4):
        for i in range(DIM):
            out[i] += term[i] / c
        term = mul_linear(term, 0, [-x / c for x in coeffs])
    return out


N_TERMS = 40
E1, E2, E3 = (1, 0, 0), (0, 1, 0), (0, 0, 1)
P_ALL = [F(1), F(1), F(1)]
PAIRS = [(0, 1), (0, 2), (1, 2)]

# precompute a-part: prod_{k=1..D} (p1+p2+p3 + k)^3, per D
a_part = {0: unit()}
acc = unit()
for D in range(1, N_TERMS + 1):
    acc = mul_linear(acc, D, P_ALL)
    cube = mul(mul(acc, acc), acc)
    a_part[D] = cube

# precompute pair e-part: prod_{k=1..m} (p_i+p_j+k), per (pair, m)
pair_part = {}
for (i, j) in PAIRS:
    coeffs = [F(1) if t in (i, j) else F(0) for t in range(3)]
    acc = unit()
    pair_part[(i, j, 0)] = acc
    for m in range(1, 2 * N_TERMS + 1):
        acc = mul_linear(acc, m, coeffs)
        pair_part[(i, j, m)] = acc

# precompute denominator inverses: prod_{k=1..m} (p_j+k)^{-6}, per (axis, m)
den_part = {}
for j in range(3):
    coeffs = [F(1) if t == j else F(0) for t in range(3)]
    acc = unit()
    den_part[(j, 0)] = acc
    for m in range(1, N_TERMS + 1):
        inv6 = inv_linear(m, coeffs)
        p6 = unit()
        for _ in range(6):
            p6 = mul(p6, inv6)
        acc = mul(acc, p6)
        den_part[(j, m)] = acc

# assemble Itw coefficients: coefficient of p2 p3^2 (monomial (0,1,2))
target = IDX[(0, 1, 2)]
itw = [F(0)] * (N_TERMS + 1)
for l1 in range(N_TERMS + 1):
    for l2 in range(N_TERMS + 1 - l1):
        for l3 in range(N_TERMS + 1 - l1 - l2):
            D = l1 + l2 + l3
            l = (l1, l2, l3)
            v = a_part[D]
            for (i, j) in PAIRS:
                v = mul(v, pair_part[(i, j, l[i] + l[j])])
            for j in range(3):
                if l[j]:
                    v = mul(v, den_part[(j, l[j])])
            # Vandermonde-shift factor prod_{i<j} (p_j - p_i + (l_j - l_i))
            for (i, j) in PAIRS:
                coeffs = [F(0)] * 3
                coeffs[j], coeffs[i] = F(1), F(-1)
                v = mul_linear(v, l[j] - l[i], coeffs)
            itw[D] += v[target]

assert itw[0] == 1
alpha = -itw[1]
# G = e^{alpha t} Itw
Gv16 = [sum(F(alpha) ** k / fa(k) * itw[d - k] for k in range(d + 1))
        for d in range(N_TERMS + 1)]
reg = [fa(d) * Gv16[d] for d in range(10)]
expected = [1, 0, 24, 192, 2904, 40320, 611520, 9515520, 152412120,
            2491104000]
assert reg == expected, reg
print("V16 period from Theorem F.1 (r=3, n=6, a=3, e=1): alpha =", alpha)
print("first ten regularized coefficients match CCGK:",
      [int(x) for x in reg])

rank_one.run_rank_one("V16", Gv16, 1,
                      "class {1/2,1/2}, Ku = D^b(C_3), delta^sharp 0")
print("done")
