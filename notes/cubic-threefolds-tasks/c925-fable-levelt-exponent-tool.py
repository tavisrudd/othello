#!/usr/bin/env python3
"""Levelt exponent classes of the rank-two nilpotent blocks of a quantum
connection at z = 0.

Input: the matrix U of c_1 * (Euler multiplication at the small point) and the
grading matrix g = (n - deg)/2 in a fixed basis, both exact.  The z-connection
is z^2 Y' = (U + z g) Y in the sign convention of c924-finite-cubic-check.py.

Method (the audit script's, made general):
  1. put U in Jordan form J = c^{-1} U c, A1 = c^{-1} g c;
  2. first gauge G1 with zero diagonal blocks, B1 = A1 + [J, G1] block
     diagonal; second-order diagonal block B2 = (A1 G1 - G1 B1 - G1)_ii;
  3. for a rank-two block with nilpotent part N = [[0,1],[0,0]] and B1 block
     [[b11, b12],[0, b22]] (the (2,1) entry must vanish, which is checked),
     the elementary modification diag(1, z) gives a regular singularity with
     residue R = [[b11, 1],[c21, b22 - 1]], c21 = (B2)_21.
  4. the Levelt exponents are the eigenvalues of R; the class is their
     multiset modulo Z, and delta^sharp is (difference)^2.

Usage: python3 c925-fable-levelt-exponent-tool.py   (runs the built-in cases)
"""
import sympy as sp
from sympy import Rational as Q


def sylvester_solve(Ji, Jj, C):
    """Solve Ji X - X Jj = C for X (spectra of Ji, Jj disjoint)."""
    n, m = Ji.shape[0], Jj.shape[0]
    xs = sp.symbols(f"x0:{n*m}")
    X = sp.Matrix(n, m, xs)
    eqs = list(Ji * X - X * Jj - C)
    sol = sp.solve(eqs, xs, dict=True)
    assert len(sol) == 1, "Sylvester equation not uniquely solvable"
    return X.subs(sol[0])


def exponent_classes(U, g, label=""):
    P, J = U.jordan_form()
    n = U.shape[0]
    # block structure of J by eigenvalue (Jordan blocks grouped)
    blocks = []
    i = 0
    while i < n:
        j = i + 1
        while j < n and (J[j, j] == J[i, i]) and (j == i + 1 and J[i, j] != 0 or J[j - 1, j] != 0):
            j += 1
        blocks.append((i, j))
        i = j
    # merge blocks with equal eigenvalue into one generalized eigenspace
    merged = []
    for (a, b) in blocks:
        if merged and J[merged[-1][0], merged[-1][0]] == J[a, a]:
            merged[-1] = (merged[-1][0], b)
        else:
            merged.append((a, b))
    blocks = merged
    A1 = sp.simplify(P.inv() * g * P)
    G1 = sp.zeros(n, n)
    for (a, b) in blocks:
        for (c, d) in blocks:
            if (a, b) == (c, d):
                continue
            X = sylvester_solve(J[a:b, a:b], J[c:d, c:d], -A1[a:b, c:d])
            G1[a:b, c:d] = X
    B1 = sp.simplify(A1 + J * G1 - G1 * J)
    B2 = sp.simplify(A1 * G1 - G1 * B1 - G1)
    out = []
    for (a, b) in blocks:
        u = J[a, a]
        if b - a == 2 and J[a, a + 1] != 0:
            b1 = B1[a:b, a:b]
            assert b1[1, 0] == 0, f"(2,1) entry of first-order block is {b1[1,0]}"
            R = sp.Matrix([[b1[0, 0], J[a, a + 1]], [B2[a + 1, a], b1[1, 1] - 1]])
            ev = list(R.eigenvals().keys())
            lam = sp.symbols("lam")
            cp = sp.factor(R.charpoly(lam).as_expr())
            diff2 = sp.simplify((R.trace()) ** 2 - 4 * R.det())
            out.append((u, "J2", ev, cp, diff2))
        else:
            out.append((u, f"dim {b-a}", None, None, None))
    print(f"== {label}")
    for u, kind, ev, cp, d2 in out:
        if ev is None:
            print(f"  eigenvalue {u}: {kind} (not a J2 block)")
        else:
            print(f"  eigenvalue {u}: J2 block, residue exponents {ev}, charpoly {cp}, delta^sharp {d2}")
    return out


def cubic_threefold(r=1):
    q = Q(r * r, 3)
    Hstar = sp.Matrix([[0, 6 * q, 0, 36 * q**2], [1, 0, 15 * q, 0], [0, 1, 0, 6 * q], [0, 0, 1, 0]])
    U = 2 * Hstar
    g = sp.diag(Q(3, 2), Q(1, 2), Q(-1, 2), Q(-3, 2))
    return U, g


def p2_times_curve(genus, q=1):
    # basis (1, x, x^2) (x) (1, e): x^3 = q, e^2 = 0; deg x = deg e = 2
    # multiplication by x and by e
    def mult(poly):  # poly: dict (i, j) -> coeff meaning x^i e^j
        M = sp.zeros(6, 6)
        for col in range(6):
            i, j = col // 2, col % 2
            for (a, b), c in poly.items():
                ii, jj = i + a, j + b
                if jj >= 2:
                    continue
                coeff = c
                while ii >= 3:
                    ii -= 3
                    coeff *= q
                M[2 * ii + jj, col] += coeff
        return M
    c1 = {(1, 0): 3, (0, 1): 2 - 2 * genus}
    U = mult(c1)
    degs = [0, 2, 2, 4, 4, 6]
    g = sp.diag(*[Q(3 - d, 2) for d in degs])
    return U, g


def p2_bundle_over_curve(genus, d, q=1):
    # P(E) -> C, deg E = d: basis (1, xi, xi^2) (x) (1, e); xi^3 = -d xi^2 e + q, e^2 = 0
    # c_1 = 3 xi + (2 - 2 genus + d) e
    def reduce(i, j, coeff, out):
        # write xi^i e^j in the basis, using xi^3 = -d xi^2 e + q
        if j >= 2 or coeff == 0:
            return
        if i <= 2:
            out[2 * i + j] += coeff
            return
        # xi^i = xi^(i-3) * (-d xi^2 e + q)
        reduce(i - 1, j + 1, -d * coeff, out)
        reduce(i - 3, j, q * coeff, out)
    def mult(poly):
        M = sp.zeros(6, 6)
        for col in range(6):
            i, j = col // 2, col % 2
            out = [0] * 6
            for (a, b), c in poly.items():
                reduce(i + a, j + b, c, out)
            for row in range(6):
                M[row, col] += out[row]
        return M
    U = mult({(1, 0): 3, (0, 1): 2 - 2 * genus + d})
    g = sp.diag(*[Q(3 - dg, 2) for dg in [0, 2, 2, 4, 4, 6]])
    return U, g


def curve_summand(genus):
    # even cohomology of a curve, (1, e), e^2 = 0, c_1 = (2 - 2g) e, n = 1
    U = sp.Matrix([[0, 0], [2 - 2 * genus, 0]])
    g = sp.diag(Q(1, 2), Q(-1, 2))
    return U, g


if __name__ == "__main__":
    U, g = cubic_threefold()
    exponent_classes(U, g, "cubic threefold (expect exponents -1/6, -5/6, delta 4/9)")
    for genus in (2, 3):
        U, g = p2_times_curve(genus)
        exponent_classes(U, g, f"P^2 x C_{genus} (blocks at x = 1 with q = 1)")
    for genus, d in ((2, 1), (3, 5)):
        U, g = p2_bundle_over_curve(genus, d)
        exponent_classes(U, g, f"P(E) over C_{genus}, deg E = {d}")
    for genus in (0, 2):
        U, g = curve_summand(genus)
        exponent_classes(U, g, f"curve summand C_{genus} (blow-up centre block)")
