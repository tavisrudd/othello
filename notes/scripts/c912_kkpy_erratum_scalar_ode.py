#!/usr/bin/env python3
"""Elimination of the Givental system (6.5) to a scalar ODE, for the cubic and the quadric.

Replay:
    uv run --with sympy python3 notes/scripts/c912_kkpy_erratum_scalar_ode.py

Context (C912, cubic-threefolds lane).  Backs the follow-up calculation offered to the authors
of arXiv:2508.05105v2 in the erratum message of 2026-08-16; see
notes/2026-08-16-c912-kkpy-erratum-scalar-ode.md.

With delta = u q d_q, the system (6.5) reads delta psi = -A psi.  Eliminating upward from
phi = psi_4 gives a fourth-order scalar ODE, which their (6.4) then pins down.  For the cubic
this forces the upper-right entry of the matrix of Example 6.6(ii) to be 36 q^2, which is
absent from the display.  The same elimination applied to the quadric of Example 6.6(i)
reproduces the ODE displayed there, which checks the method against their own worked answer.
"""

import sympy as sp

q, u, b, a1, a2 = sp.symbols("q u b a1 a2")
f = sp.Function("f")(q)


def delta(g):
    return sp.expand(u * q * sp.diff(g, q))


def d4(g):
    return delta(delta(delta(delta(g))))


# --- cubic: N = 5, k = 1, d = 3, with an unknown corner entry b q^2 -------------------------
psi4 = f
psi3 = -delta(psi4)
psi2 = sp.expand(delta(-psi3) - 6 * q * psi4)
psi1 = sp.expand(delta(-psi2) - 15 * q * psi3)
row1 = sp.expand(delta(psi1) + 6 * q * psi2 + b * q ** 2 * psi4)

cubic_ode = sp.expand(-d4(f) + q * (27 * delta(delta(f)) + 27 * u * delta(f) + 6 * u ** 2 * f)
                      - (36 - b) * q ** 2 * f)
assert sp.simplify(row1 - cubic_ode) == 0
print("cubic:   delta^4 phi = q(27 delta^2 + 27 u delta + 6 u^2) phi - (36 - b) q^2 phi   OK")

# Givental (6.4) at N = 5, k = 1, d_1 = 3, d_tot = 3, applied to a monomial q^s (delta -> u s).
s = sp.Symbol("s")
lhs = (u * s) ** 4
rhs = sp.expand(3 * (3 * u * s + u) * (3 * u * s + 2 * u))
assert sp.expand(rhs - (27 * (u * s) ** 2 + 27 * u * (u * s) + 6 * u ** 2)) == 0
print("(6.4):   3q(3delta + u)(3delta + 2u) = q(27 delta^2 + 27 u delta + 6 u^2), no q^2 term  OK")
print("         => b = 36, and chi_K(lam) = lam^2 (lam^2 - 108 q).")

# --- the comparison determines every entry, not only the corner ----------------------------
al, be, ga = sp.symbols("alpha beta gamma")
g4 = f
g3 = -delta(g4)
g2 = sp.expand(delta(-g3) - ga * q * g4)
g1 = sp.expand(delta(-g2) - be * q * g3)
general = sp.expand(delta(g1) + al * q * g2 + b * q ** 2 * g4)
closed = sp.expand(-d4(f)
                   + q * ((al + be + ga) * delta(delta(f))
                          + (be + 2 * ga) * u * delta(f) + ga * u ** 2 * f)
                   + (b - al * ga) * q ** 2 * f)
assert sp.simplify(general - closed) == 0
sol = sp.solve([al + be + ga - 27, be + 2 * ga - 27, ga - 6], [al, be, ga], dict=True)[0]
assert sol == {al: 6, be: 15, ga: 6}
print("general: delta^4 phi = q[(a+b+c) delta^2 + (b+2c) u delta + c u^2] phi + (B - a c) q^2 phi")
print("         matching (6.4) is triangular: c = 6, b = 15, a = 6, hence B = a c = 36.   OK")

# --- quadric: N = 5, k = 1, d = 2, reproducing their Example 6.6(i) -------------------------
p4 = f
p3 = -delta(p4)
p2 = sp.expand(delta(-p3))
p1 = sp.expand(delta(-p2) - a2 * q * p4)
row1q = sp.expand(delta(p1) + a1 * q * p3)
their_ode = sp.expand(-d4(f) - q * ((a1 + a2) * delta(f) + a2 * u * f))
assert sp.simplify(row1q - their_ode) == 0
print("quadric: delta^4 phi = -q((a1 + a2) delta + a2 u) phi, as displayed in Ex 6.6(i)   OK")
print("         comparison with (6.4) at d = 2 gives a1 + a2 = 4, a2 = 2, their answer.")
