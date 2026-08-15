#!/usr/bin/env python3
"""C912: spectral data of the small even quantum connection of X x P^1.

X is a smooth cubic threefold.  Inputs, both external to this script:

  * small even quantum cohomology of X, as the Beauville presentation for a
    degree-d hypersurface in P^{n+1},  QH_even(X) = L[x]/(x^{n+1} - d^d q1 x^{d-1}),
    which for (n,d) = (3,3) is  L[x]/(x^4 - 27 q1 x^2),  x = H\\star,  q1 the
    Novikov variable of the line class;
  * QH_even(P^1) = L[y]/(y^2 - q2),  y = h\\star.

Small quantum cohomology of a product is the tensor product, and the Euler
field adds, so U = E\\star = 2(x + y)\\star on the eight-dimensional tensor
product.  This script computes, over the Novikov field:

  1. the characteristic polynomial and the six eigenvalue sheets;
  2. the Jordan type at the doubled sheets +-2s, s^2 = q2;
  3. the connected components of the spectral cover, as the primary
     decomposition of the algebra;
  4. the caustic locus, i.e. every specialization at which two sheets collide.

Replay:  uv run --with sympy python notes/2026-08-15-c912-xp1-spectral-check.py
"""

import sympy as sp

q1, q2 = sp.symbols('q1 q2', positive=True)
lam = sp.Symbol('lam')
r = sp.sqrt(3 * q1)   # eigenvalues of x are 0, 0, +-3r
s = sp.sqrt(q2)       # eigenvalues of y are +-s

# ---------------------------------------------------------------- the algebra
basis = [(i, j) for i in range(4) for j in range(2)]   # x^i y^j
idx = {b: k for k, b in enumerate(basis)}
n = len(basis)


def mul_x(i, j):
    return {(i + 1, j): sp.Integer(1)} if i + 1 <= 3 else {(2, j): 27 * q1}


def mul_y(i, j):
    return {(i, j + 1): sp.Integer(1)} if j + 1 <= 1 else {(i, 0): q2}


U = sp.zeros(n, n)
for b in basis:
    col = idx[b]
    for tgt, c in mul_x(*b).items():
        U[idx[tgt], col] += 2 * c
    for tgt, c in mul_y(*b).items():
        U[idx[tgt], col] += 2 * c

# ------------------------------------------------------------- 1. the sheets
cp = sp.factor(sp.expand(U.charpoly(lam).as_expr()))
print("1. char poly of U = E-star on QH_even(X x P^1):")
print("   ", cp)
print("   sheets, with algebraic multiplicity:")
for ev, m in sp.roots(sp.Poly(U.charpoly(lam).as_expr(), lam)).items():
    print("     ", sp.simplify(sp.radsimp(ev)), "  mult", m)
print("   expected: +-2s doubled, and the four simple 6r+-2s, -6r+-2s")
for name, val in (("6r+2s", 6 * r + 2 * s), ("6r-2s", 6 * r - 2 * s)):
    print(f"     check {name}: quartic factor vanishes ->",
          sp.simplify(sp.expand(
              (lam**4 - 216 * lam**2 * q1 - 8 * lam**2 * q2
               + 11664 * q1**2 - 864 * q1 * q2 + 16 * q2**2).subs(lam, val))) == 0)

# --------------------------------------------------- 2. Jordan type at +-2s
print("\n2. Jordan type at the doubled sheets:")
I = sp.eye(n)
for name, ev in (("+2s", 2 * s), ("-2s", -2 * s)):
    M = sp.simplify(U - ev * I)
    k1 = n - sp.Matrix(M).rank()
    k2 = n - sp.Matrix(sp.simplify(M * M)).rank()
    print(f"   {name}: dim ker = {k1}, dim ker^2 = {k2}"
          f"  -> {'single J_2 block, nilpotent part nonzero' if (k2, k1) == (2, 1) else 'OTHER'}")

# ------------------------------------------- 3. components of the spectral cover
print("\n3. connected components of the spectral cover over L0 = C((q1,q2)):")
x = sp.Symbol('x')
y = sp.Symbol('y')
fx = sp.factor(x**4 - 27 * q1 * x**2)
print("    x-factor:", fx, " ->  L0[x]/(x^2)  x  L0[x]/(x^2 - 27 q1)")
print("    x^2 - 27 q1 irreducible over L0:",
      sp.Poly(x**2 - 27 * q1, x).is_irreducible)
print("    y^2 - q2   irreducible over L0:",
      sp.Poly(y**2 - q2, y).is_irreducible)
print("    => two components: A_nilp = K2[x]/(x^2) with K2 = L0(sqrt q2), rank 4,")
print("       geometric points +-2s exchanged by Gal(K2/L0) = Z/2;")
print("       A_reg  = L0(sqrt q1, sqrt q2), rank 4, four simple sheets.")

# ------------------------------------------------------------ 4. the caustic
print("\n4. caustic locus (sheet collisions):")
sheets = {'+2s': 2 * s, '-2s': -2 * s, '6r+2s': 6 * r + 2 * s, '6r-2s': 6 * r - 2 * s,
          '-6r+2s': -6 * r + 2 * s, '-6r-2s': -6 * r - 2 * s}
keys = list(sheets)
for i in range(len(keys)):
    for j in range(i + 1, len(keys)):
        d = sp.simplify(sheets[keys[i]] - sheets[keys[j]])
        sol = sp.solve(sp.Eq(d, 0), q2, dict=True)
        if sol:
            print(f"   {keys[i]:>7} = {keys[j]:<7} at {sol}")
print("   the doubled sheets meet a simple sheet only at 4 q2 = 27 q1;")
print("   the two simple sheets 6r-2s and -6r+2s meet each other (at value 0)")
print("   only at q2 = 27 q1.")
