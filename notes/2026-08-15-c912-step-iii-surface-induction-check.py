#!/usr/bin/env python3
"""C912 -- computational inputs to the induction proving step (iii) for surfaces.

Step (iii): no atom of a smooth projective surface has a primitive sixth root of
unity as a Serre eigenvalue.  The proof runs by the surface minimal model
program: blow down to a minimal model, and treat the minimal cases separately.
Two of its cases rest on computations, done here.

(1) Minimal rational, not a projective bundle: the projective plane.  Its small
    quantum cohomology is semisimple, so every block of the quantum connection is
    rank one, so every atom is rank one, so every atom's Serre operator is the
    identity.  The same computation is shown for the quadric surface.
(2) Minimal ruled: a projective bundle over a curve, where the projective-bundle
    formula reduces the atoms to those of the base curve.  For a curve of any
    genus the Serre operator on the numerical Grothendieck group has
    characteristic polynomial (lam+1)^2, so no primitive sixth eigenvalue; and
    for the rational curve the category splits further into rank-one atoms whose
    Serre operators are the identity.

Rank-one atoms need no computation: a 1x1 Euler form is symmetric, so
S = E^{-1}E^T = 1.
"""

from sympy import Matrix, Poly, Rational, symbols, factor_list, discriminant

lam, q, q1, q2, g = symbols('lam q q1 q2 g')


def spectrum(mult_matrix, name, params):
    cp = Poly(mult_matrix.charpoly(lam).as_expr().expand(), lam)
    disc = discriminant(cp.as_expr(), lam)
    print(f"  {name}: char poly of c_1 * = {cp.as_expr()}")
    print(f"    discriminant in {params} = {disc}  -> distinct roots for generic "
          f"Novikov parameters: {disc != 0}")


print("Small quantum spectra of the minimal rational surfaces that are not")
print("projective bundles over a curve of positive genus:")

# Projective plane: QH = Q[H,q]/(H^3 - q), basis (1, H, H^2), c_1 = 3H.
H = Matrix([[0, 0, q], [1, 0, 0], [0, 1, 0]])
spectrum(3 * H, "projective plane", "q")

# Quadric surface: H1^2 = q1, H2^2 = q2, basis (1, H1, H2, H1H2), c_1 = 2H1 + 2H2.
H1 = Matrix([[0, q1, 0, 0], [1, 0, 0, 0], [0, 0, 0, q1], [0, 0, 1, 0]])
H2 = Matrix([[0, 0, q2, 0], [0, 0, 0, q2], [1, 0, 0, 0], [0, 1, 0, 0]])
spectrum(2 * H1 + 2 * H2, "quadric surface", "q1, q2")
print("  Semisimple small quantum cohomology means every block of the quantum")
print("  connection is rank one, hence every atom is rank one, hence every atom's")
print("  Serre operator is the identity: no primitive sixth eigenvalue.")
print()

print("Curves, the base case of the projective-bundle reduction:")
E_curve = Matrix([[1 - g, 1], [-1, 0]])
S_curve = (E_curve.inv() * E_curve.T).applyfunc(lambda t: t.simplify())
cp_curve = Poly((S_curve.charpoly(lam).as_expr()).expand(), lam)
print(f"  genus g: Euler form {E_curve.tolist()}, Serre {S_curve.tolist()}")
print(f"  char poly = {cp_curve.as_expr()} = (lam+1)^2 for every g, "
      f"factored {factor_list(cp_curve.as_expr(), lam)[1]}")
print("  Eigenvalue -1 with multiplicity two: never a primitive sixth root.")
print("  For the rational curve the category splits further, into the two rank-one")
print("  atoms of its exceptional collection, whose Serre operators are the")
print("  identity -- the ambient (lam+1)^2 is not the atomic answer, which is the")
print("  same decomposition-dependence recorded in the step-(iii) restatement.")
print()

print("Rank-one atoms: E = [[n]] is symmetric, so S = E^-1 E^T = 1 for every n.")
print(f"  check n = 1, 2, 5: "
      f"{[ (Matrix([[n]]).inv() * Matrix([[n]]).T)[0, 0] for n in (1, 2, 5) ]}")
