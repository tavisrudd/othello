#!/usr/bin/env python3
"""C912: the primitive-sixth count against the Kuznetsov-component Serre lattice.

Input, external: the numerical Grothendieck group of the Kuznetsov component of
a smooth cubic threefold is free of rank two with Euler form

    E = [[-1, -1], [0, -1]]           chi(e_i, e_j) = E_ij

(standard; see the Bayer--Lahoz--Macri--Nuer--Perry--Stellari circle).  Serre
duality chi(a,b) = chi(b, S a) reads on matrices as E S = E^T, so the Serre
operator on the numerical K-group is S = E^{-1} E^T.

This script checks three things:

  1. S has characteristic polynomial the sixth cyclotomic polynomial, so its
     eigenvalues are the two primitive sixth roots of unity;
  2. S^3 = -I, which is the K-theoretic shadow of the fractional Calabi--Yau
     relation S^3 = [5] (a shift by one acts by -1);
  3. the same conclusion follows from the relation and the rank alone, without
     the explicit Euler matrix: the eigenvalues solve lam^3 = -1, the operator
     is integral so nonreal eigenvalues are conjugate, and lam = -1 is excluded
     by tr S = 1.

It also records the contrasting ambient computation: the Serre functor of the
whole derived category of a cubic threefold is tensor by omega followed by a
shift, which acts on the numerical K-group as -1 times a unipotent, hence has
every eigenvalue -1 and no primitive sixth root.  So the primitive-sixth count
lives on the residual component, not on the ambient category.

Replay:  uv run --with sympy python notes/2026-08-15-c912-serre-lattice-check.py
"""

import sympy as sp

lam = sp.Symbol('lam')

E = sp.Matrix([[-1, -1], [0, -1]])
S = E.inv() * E.T
print("Euler form E =", E.tolist())
print("Serre operator S = E^-1 E^T =", S.tolist())

cp = sp.factor(S.charpoly(lam).as_expr())
print("char poly of S:", sp.expand(cp))
print("  equals the sixth cyclotomic polynomial:",
      sp.expand(cp - sp.cyclotomic_poly(6, lam)) == 0)
print("  eigenvalues:", [sp.simplify(e) for e in S.eigenvals()])
print("  in exponential form: exp(+- i pi/3), the two primitive sixth roots")

print("S^3 =", (S**3).tolist(), " -> equals -I:", (S**3) == -sp.eye(2))
print("S^6 =", (S**6).tolist(), " -> equals  I:", (S**6) == sp.eye(2))

print("\nbasis-free version: rank 2, integral, S^3 = -I, tr S =", sp.trace(S))
print("  roots of lam^3 + 1: ", sp.roots(lam**3 + 1))
print("  lam = -1 excluded by the trace, so the pair is exp(+- i pi/3);")
print("  hence the primitive-sixth multiplicity is 2, which is nu_6 of the")
print("  cubic threefold as computed in the manuscript from Cai's connection.")

print("\nambient contrast: S_X = (tensor omega)[3] acts on K_num as -1 times a")
print("unipotent (tensoring by a line bundle is unipotent on the Chern")
print("character), so every ambient eigenvalue is -1 and none is a primitive")
print("sixth root.  The count is a residual-component invariant.")
