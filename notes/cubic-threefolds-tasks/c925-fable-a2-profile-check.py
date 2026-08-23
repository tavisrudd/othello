#!/usr/bin/env python3
"""C925: the A2-quiver category carries the exact numerical danger profile of
the b3=0 tail, so no Hochschild-parity argument can close it.

Exact checks (sympy / rational arithmetic):
  1. Hochschild homology of the path algebra kA2 (upper-triangular 2x2
     matrices), from the normalized bar complex: HH_0 = k^2 and HH_i = 0 for
     i = 1, 2, 3.  So D^b(A2) is a smooth proper category with Hochschild
     homology of dimension two concentrated in degree zero.
  2. Its Euler Gram matrix on K_0 is [[1,1],[0,1]]; the pairing-determined
     monodromy T = G^{-T} G has trace 1, satisfies T^3 = -1, and has order 6:
     the marked class {1/6, 5/6}.  The Bernardara--Macri--Mehrotra--Stellari
     Gram matrix of Ku(Y_3), [[-1,-1],[0,-1]], is the negative of the A2 Gram
     and yields the *identical* T: the marker cannot distinguish Ku(Y_3) from
     D^b(A2).
  3. Riemann--Roch arithmetic for the geometric embedding: on a del Pezzo
     surface S with (-1)-curve E, chi(O_S, O_S(E)) = 1, so (O_S, O_S(E)) is
     an exceptional pair with a single Hom and its admissible hull in
     D^b(S x P^1) (a threefold with b_3 = 0) is equivalent to D^b(A2).

Replay:
    uv run --with sympy python3 \
      notes/cubic-threefolds-tasks/c925-fable-a2-profile-check.py
"""
import itertools

import sympy as sp

# ---- 1. Hochschild homology of kA2 from the normalized bar complex --------
# A = span(1, u, x), u = e_11, x = e_12 in upper-triangular 2x2 matrices.
# Structure constants: u*u = u, u*x = x, x*u = 0, x*x = 0, 1 central.
# Abar = A / k.1 with basis (u, x).
BASIS = ["1", "u", "x"]


def mult(a, b):
    """Product of basis elements as a dict over BASIS."""
    if a == "1":
        return {b: 1}
    if b == "1":
        return {a: 1}
    if a == "u" and b == "u":
        return {"u": 1}
    if a == "u" and b == "x":
        return {"x": 1}
    return {}          # x*u = x*x = 0


ABAR = ["u", "x"]


def chains(n):
    """Basis of C_n = A (x) Abar^{(x) n}."""
    return [(a,) + t for a in BASIS for t in itertools.product(ABAR, repeat=n)]


def project_abar(d):
    """Project a dict over BASIS to Abar coordinates: 1 -> 0."""
    return {k: v for k, v in d.items() if k != "1"}


def boundary(n):
    """Matrix of b: C_n -> C_{n-1} on the normalized bar complex."""
    dom, cod = chains(n), chains(n - 1)
    idx = {t: i for i, t in enumerate(cod)}
    M = sp.zeros(len(cod), len(dom))
    for j, t in enumerate(dom):
        # sum_{i=0}^{n-1} (-1)^i (..., t_i t_{i+1}, ...) + (-1)^n t_n t_0 (...)
        for i in range(n):
            prod = mult(t[i], t[i + 1])
            if i == 0:
                for k, v in prod.items():
                    M[idx[(k,) + t[2:]], j] += (-1) ** i * v
            else:
                for k, v in project_abar(prod).items():
                    M[idx[t[:i] + (k,) + t[i + 2:]], j] += (-1) ** i * v
        prod = mult(t[n], t[0])
        for k, v in prod.items():
            M[idx[(k,) + t[1:n]], j] += (-1) ** n * v
    return M


dims = {0: len(chains(0))}
ranks = {}
for n in range(1, 5):
    dims[n] = len(chains(n))
    ranks[n] = boundary(n).rank()
hh = {0: dims[0] - ranks[1]}
for n in range(1, 4):
    hh[n] = (dims[n] - ranks[n]) - ranks[n + 1]
assert hh == {0: 2, 1: 0, 2: 0, 3: 0}, hh
print("HH_*(kA2) dimensions (normalized bar complex):", hh,
      "-> dimension two, concentrated in degree zero")

# ---- 2. numerical Serre data --------------------------------------------
lam = sp.symbols("lam")
for label, G in [("A2 Gram [[1,1],[0,1]]", sp.Matrix([[1, 1], [0, 1]])),
                 ("BMMS Ku(Y3) Gram [[-1,-1],[0,-1]]",
                  sp.Matrix([[-1, -1], [0, -1]]))]:
    T = G.T.inv() * G
    assert sp.trace(T) == 1 and sp.det(T) == 1
    assert sp.simplify(T ** 3 + sp.eye(2)) == sp.zeros(2)
    assert sp.simplify(T ** 6 - sp.eye(2)) == sp.zeros(2)
    ev = sorted(sp.Matrix(T).eigenvals().keys(), key=str)
    print(f"{label}: T = G^-T G has trace 1, T^3 = -1, order 6,"
          f" eigenvalues {ev} (the marked class)")
T_a2 = sp.Matrix([[1, 1], [0, 1]]).T.inv() * sp.Matrix([[1, 1], [0, 1]])
T_ku = sp.Matrix([[-1, -1], [0, -1]]).T.inv() * sp.Matrix([[-1, -1], [0, -1]])
assert T_a2 == T_ku
print("the two T's are literally equal: the marker sees no difference"
      " between Ku(Y3) and D^b(A2)")

# ---- 3. Riemann--Roch for the embedding ---------------------------------
# On a del Pezzo S, E a (-1)-curve: chi(O, O(E)) = chi(O_S) + (E^2 - E.K)/2
# = 1 + (-1 + 1)/2 = 1.
E2, EK, chiO = -1, -1, 1          # E.K = -1 since E is a (-1)-curve
chi_pair = chiO + sp.Rational(E2 - EK, 2)
assert chi_pair == 1
print("del Pezzo (-1)-curve pair (O, O(E)): chi(O, O(E)) =", chi_pair,
      " -> exceptional pair with a single Hom; its hull in D^b(S x P^1)"
      " is D^b(A2) inside a b3 = 0 threefold")
print("all checks passed")
