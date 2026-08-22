#!/usr/bin/env python3
"""Characteristic polynomial of Euler multiplication on the even quantum cohomology
of a smooth cubic threefold, for the two matrices that appear in the literature.

Replay:
    uv run --with sympy python3 notes/scripts/c912_kkpy_cubic_charpoly.py

Context (C912, cubic-threefolds lane). Katzarkov-Kontsevich-Pantev-Yu,
arXiv:2508.05105v2, Example 6.6(ii), display the matrix A below with K = 2A as
the Euler multiplication on the even part, and later, in Example 6.21, assert
that the spectrum is {lambda_+, lambda_-, 0, 0}. The two statements are
incompatible: the displayed A omits the quantum term in the corner slot (1,4).
Cai (arXiv:2608.01577v1, section 3) displays the same matrix with that entry
present, and the manuscript's own block reduction
(papers/cubic-stabilization-m1/sections/04-one-step.tex, (4.9a)-(4.9e))
agrees with Cai.

This script computes both characteristic polynomials and the eigenvalues, and
checks the corner entry against the value 36 q^2 forced by Cai's matrix.
"""

import sympy as sp

lam, q = sp.symbols("lam q", positive=True)

# KKPY Example 6.6(ii) as displayed: no (1,4) entry.
A_kkpy = sp.Matrix([[0, 6 * q, 0, 0],
                    [1, 0, 15 * q, 0],
                    [0, 1, 0, 6 * q],
                    [0, 0, 1, 0]])

# Cai's matrix: same, with the corner quantum term restored.
A_cai = A_kkpy.copy()
A_cai[0, 3] = 36 * q ** 2


def report(name, A):
    K = 2 * A
    # det(lam I - K) directly: charpoly() returns a PurePoly in a dummy generator.
    chi = sp.expand((lam * sp.eye(4) - K).det())
    eigs = sp.roots(sp.Poly(chi, lam))
    print(f"{name}:")
    print(f"  chi_K(lam) = {sp.factor(chi)}")
    print("  eigenvalues (with multiplicity) = "
          + ", ".join(f"{sp.radsimp(e)} (x{m})" for e, m in sorted(eigs.items(), key=str)))
    print(f"  distinct eigenvalues = {len(eigs)}")
    print(f"  0 is an eigenvalue: {sp.expand(chi.subs(lam, 0)) == 0}")
    return chi


chi_kkpy = report("KKPY Example 6.6(ii), as displayed", A_kkpy)
chi_cai = report("Cai / manuscript (corner entry 36 q^2)", A_cai)

# The manuscript's independently derived spectrum is {6r, -6r, 0, 0}, r = sqrt(3q).
r = sp.sqrt(3 * q)
expected = sp.expand((lam - 6 * r) * (lam + 6 * r) * lam ** 2)
assert sp.expand(chi_cai - expected) == 0, "Cai matrix disagrees with {+-6r, 0, 0}"
assert sp.expand(chi_kkpy.subs(lam, 0)) != 0, "KKPY matrix unexpectedly has eigenvalue 0"
print("\nCheck: Cai/manuscript spectrum equals {6r, -6r, 0, 0} with r = sqrt(3q).  OK")
print("Check: KKPY's displayed matrix has no zero eigenvalue for q != 0.        OK")
