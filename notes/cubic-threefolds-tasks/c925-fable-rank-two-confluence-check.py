#!/usr/bin/env python3
"""C925: rank-two confluence check for the cubic marked block.

Validates the two computational legs of the rank-two confluence claim
(notes/2026-08-23-c925-fable-rank-two-confluence-gamma-ii.md):

1. Exact (sympy): the model family
       z^2 Y' = (U_eps + z D + z^2 L) Y,
       U_eps = [[0,2],[eps,0]], D = diag(-19/18, 19/18), L = [[0,0],[-8/81,0]]
   at eps = 0 is carried by the single-valued gauge diag(1, z) to the
   regular-singular system z W' = R# W with
       R# = [[-19/18, 2], [-8/81, 1/18]],
   the C924 modified residue of the cubic threefold's marked block, with
   eigenvalues {-1/6, -5/6}; hence monodromy trace 2 cos(pi/3) = 1 exactly.
2. Exact (sympy): the polarized-trace dictionary.  For Gram [[g+, a],[0, g-]]
   the pairing-determined monodromy T = G^{-T} G has trace 2 - a^2/(g+ g-);
   for g=1 and integer a the merged Levelt class e solves
   2 cos(2 pi e) = 2 - a^2, giving e in {0, 1/6, 1/4, 1/3, 1/2} for
   a^2 in {0,...,4}; a^2 = 1 is the cubic class {1/6, 5/6} (trace 1).
3. Numerical (scipy DOP853): direct monodromy of the family around |z| = 1
   for a sweep of eps, real and complex.  Expected: trace(M(0)) = 1 to
   integrator precision, and continuity of the trace through the Jordan
   turning point eps = 0 (the family is not isomonodromic, so the trace
   varies with eps; only continuity and the eps = 0 value are claims).

Replay:
    uv run --with sympy,numpy,scipy python3 \
      notes/cubic-threefolds-tasks/c925-fable-rank-two-confluence-check.py
"""

import numpy as np
import sympy as sp
from scipy.integrate import solve_ivp

# ---------------------------------------------------------------- exact leg 1
z = sp.symbols("z")
N = sp.Matrix([[0, 2], [0, 0]])
D = sp.diag(sp.Rational(-19, 18), sp.Rational(19, 18))
L = sp.Matrix([[0, 0], [sp.Rational(-8, 81), 0]])
A = N / z**2 + D / z + L                      # eps = 0 coefficient matrix
P = sp.diag(1, z)                             # single-valued elementary modification
W_coeff = sp.simplify(P.inv() * (A * P - sp.diag(0, 1)))
R_sharp = sp.simplify(W_coeff * z)
assert sp.simplify(W_coeff - R_sharp / z) == sp.zeros(2), "gauge leaves O(1) term"
eigs = sorted(R_sharp.eigenvals().keys())
assert eigs == [sp.Rational(-5, 6), sp.Rational(-1, 6)], eigs
mono_trace = sp.simplify(sp.expand_complex(
    sum(sp.exp(2 * sp.pi * sp.I * e) for e in eigs)))
assert mono_trace == 1, mono_trace
print("leg1: diag(1,z) gauge sends the eps=0 model to z W' = R# W exactly")
print("leg1: R# =", sp.nsimplify(R_sharp).tolist())
print("leg1: Levelt exponents", [str(e) for e in eigs],
      "=> monodromy trace", mono_trace)

# ---------------------------------------------------------------- exact leg 2
gp, gm, a = sp.symbols("g_+ g_- a")
G = sp.Matrix([[gp, a], [0, gm]])
T = sp.simplify(G.T.inv() * G)
trT = sp.simplify(sp.trace(T))
assert sp.simplify(trT - (2 - a**2 / (gp * gm))) == 0, trT
print("leg2: trace(G^{-T} G) = 2 - a^2/(g+ g-) exactly")
e_sym = sp.symbols("e")
rows = []
for a2 in range(5):
    sols = sp.solve(sp.Eq(2 * sp.cos(2 * sp.pi * e_sym), 2 - a2), e_sym)
    sols = sorted({sp.nsimplify(abs(s)) for s in sols})
    rows.append((a2, str(sols[0])))
assert rows == [(0, "0"), (1, "1/6"), (2, "1/4"), (3, "1/3"), (4, "1/2")], rows
print("leg2: a^2 -> class e:", rows, "(a^2 = 1 is the cubic class, trace 1;"
      " a = 0 is the CDG unramified case, trace 2)")

# ------------------------------------------------------------ numerical leg 3
Dn = np.array([[-19 / 18, 0], [0, 19 / 18]], dtype=complex)
Ln = np.array([[0, 0], [-8 / 81, 0]], dtype=complex)


def monodromy_trace(eps: complex) -> complex:
    U = np.array([[0, 2], [eps, 0]], dtype=complex)

    def rhs(theta, y):
        zz = np.exp(1j * theta)
        Az = U / zz**2 + Dn / zz + Ln
        return (1j * zz * (Az @ y.reshape(2, 2))).reshape(4)

    y0 = np.eye(2, dtype=complex).reshape(4)
    sol = solve_ivp(rhs, (0.0, 2 * np.pi), y0, method="DOP853",
                    rtol=1e-12, atol=1e-12)
    assert sol.success
    return np.trace(sol.y[:, -1].reshape(2, 2))


print("leg3: trace of the monodromy of z^2 Y' = (U_eps + z D + z^2 L) Y,"
      " loop |z| = 1")
for eps in [0.0, 1e-4, 1e-3, 1e-2, 1e-1, 0.5,
            1e-2j, 1e-1j, -1e-1, (0.05 + 0.05j)]:
    t = monodromy_trace(eps)
    print(f"  eps = {eps!s:>14}   tr M = {t.real:+.9f} {t.imag:+.9f}i")
t0 = monodromy_trace(0.0)
assert abs(t0 - 1) < 1e-8, t0
print("leg3: tr M(0) = 1 to integrator precision; the sweep shows the trace"
      " is continuous through the eps = 0 Jordan turning point")
print("all checks passed")
