#!/usr/bin/env python3
"""First-order splitting test for the cubic threefold's marked J2 block.

The even big quantum product of the cubic B along the bulk directions
t2 (dual to H^2) and t3 (dual to H^3) is determined at first order by the
four-point Gromov-Witten invariants; Kontsevich-Manin reconstruction (H
generates the even cohomology) leaves exactly three irreducible numbers

    A = <H^2,H^2,H^2,H^2>_2, B4 = <H^2,H^2,H^3,H^3>_3, C4 = <H^3,H^3,H^3,H^3>_4,

which WDVV determines from the small product.  The marked J2 sits at the
zero eigenvalue of E* = 2 H*; it splits at first order along t_k iff the
lower-left entry of the deformed Euler operator in the Jordan frame of the
block is nonzero.  Hertling-Manin-Teleman forces both entries to vanish
(b_3(B) = 10, rank four, two simple sheets); this run verifies that
prediction and validates the four-point machinery for later telescope
vertices, where the same test is genuinely open.

Conventions: basis (1, H, H^2, H^3); pairing g(H^a,H^b) = 3 for a+b = 3;
Novikov q of the line class; small product from c924-finite-cubic-check.py:
H*H = H^2 + 6q, H*H^2 = H^3 + 15qH, H*H^3 = 6qH^2 + 36q^2.
String: four-point invariants with a unit insertion vanish.
Divisor: <H, x, y, z>_d = d <x, y, z>_d for d > 0 (n = 4).
"""
import itertools
import sympy as sp
from sympy import Rational as Q

q, t2, t3 = sp.symbols("q t2 t3")
A, B4, C4 = sp.symbols("A B4 C4")

Hm = sp.Matrix([[0, 6 * q, 0, 36 * q**2],
                [1, 0, 15 * q, 0],
                [0, 1, 0, 6 * q],
                [0, 0, 1, 0]])
gmat = sp.Matrix(4, 4, lambda i, j: 3 if i + j == 3 else 0)
ginv = gmat.inv()

def class_mult_matrix(a):
    """Quantum multiplication by the CLASSICAL class H^a, as a polynomial in
    Hm: H^2 = H*H - 6q, H^3 = H*H*H - 21 q H (from the small relations)."""
    if a == 0:
        return sp.eye(4)
    if a == 1:
        return Hm
    if a == 2:
        return Hm * Hm - 6 * q * sp.eye(4)
    return Hm ** 3 - 21 * q * Hm

def small_product_vec(a, b):
    e = sp.zeros(4, 1); e[b, 0] = 1
    return sp.expand(class_mult_matrix(a) * e)

def three_point(a, b, c):
    """Full small three-point series <H^a,H^b,H^c> in q (classical included)."""
    v = small_product_vec(a, b)
    return sp.expand(3 * v[3 - c, 0])

def four_point(exps, d):
    """<H^{a_1},..,H^{a_4}>_d for a_i in {0,1,2,3}."""
    exps = sorted(exps)
    if d <= 0 or exps[0] == 0:
        return 0  # string; and d=0 four-point quantum vanishes
    if exps[0] == 1:
        rest = exps[1:]
        if len(set(rest)) >= 1 and min(rest) >= 1 and len(rest) == 3:
            if min(rest) == 1 or True:
                pass
        # divisor axiom, then read the three-point number of that degree
        if min(rest) == 0:
            return 0
        if min(rest) == 1:
            return d * four_point_as_three(rest, d) if False else d * three_from_divisor(rest, d)
        return d * sp.expand(three_point(*rest)).coeff(q, d)
    if sum(exps) != 4 + 2 * d:
        return 0
    table = {(2, 2, 2, 2): A, (2, 2, 3, 3): B4, (3, 3, 3, 3): C4}
    return table.get(tuple(exps), 0)

def three_from_divisor(rest, d):
    # rest has a further divisor entry: <H, x, y>_d with x,y arbitrary:
    # divisor on three-point: <H, x, y>_d = d <x, y>_d (two-point) -- but the
    # three-point series already encodes everything; just use it directly.
    return sp.expand(three_point(*rest)).coeff(q, d)

def F3_first_order(a, b, c):
    out = three_point(a, b, c)
    for (t, k) in ((t2, 2), (t3, 3)):
        val = 0
        for d in range(1, 8):
            coeff = four_point([a, b, c, k], d)
            if coeff != 0:
                val += coeff * q ** d
        out = out + t * val
    return sp.expand(out)

basis = [0, 1, 2, 3]
F3 = {(a, b, c): F3_first_order(a, b, c)
      for a in basis for b in basis for c in basis}

rels = set()
for a, b, c, d in itertools.product(basis, repeat=4):
    diff = sp.expand(
        sum(F3[(a, b, e)] * ginv[e, f] * F3[(f, c, d)] -
            F3[(a, c, e)] * ginv[e, f] * F3[(f, b, d)]
            for e in basis for f in basis))
    for t in (t2, t3):
        other = t3 if t is t2 else t2
        expr = sp.expand(diff.coeff(t, 1)).subs(other, 0)
        for dd in range(0, 9):
            r = sp.simplify(expr.coeff(q, dd))
            if r != 0:
                rels.add(r)

sol = sp.solve(list(rels), [A, B4, C4], dict=True)
assert len(sol) == 1, (len(sol), sorted(map(str, rels))[:6])
sol = sol[0]
print("four-point invariants of the cubic threefold:")
print("  <H2,H2,H2,H2>_2 =", sol[A])
print("  <H2,H2,H3,H3>_3 =", sol[B4])
print("  <H3,H3,H3,H3>_4 =", sol[C4])

def mult_matrix(a):
    M = sp.zeros(4, 4)
    for b in range(4):
        for cc in range(4):
            M[cc, b] = sp.expand(sum(F3[(a, b, e)] * ginv[e, cc] for e in basis))
    return M.subs(sol)

Hbig = mult_matrix(1)
assert sp.expand(Hbig.subs({t2: 0, t3: 0}) - Hm).is_zero_matrix

# E*_tau = 2 (H *_tau) + (1 - 2) t2 (H^2 *_tau) + (1 - 3) t3 (H^3 *_tau); keep O(t)
U = 2 * Hbig - t2 * mult_matrix(2) - 2 * t3 * mult_matrix(3)
U0 = (2 * Hm).subs(q, Q(1, 3))
P, J = U0.jordan_form()
print("Jordan form of E* at q=1/3:", J.tolist())
for k, t in ((2, t2), (3, t3)):
    Uk = U.applyfunc(lambda e: sp.expand(e).coeff(t, 1)).subs({q: Q(1, 3), t2: 0, t3: 0})
    Ukj = sp.simplify(P.inv() * Uk * P)
    idx = [i for i in range(4) if J[i, i] == 0]
    blk = Ukj[idx[0]:idx[-1] + 1, idx[0]:idx[-1] + 1]
    print(f"direction t{k}: first-order Euler deformation on the J2 block:",
          blk.tolist(), "-> splitting entry:", sp.simplify(blk[1, 0]))
