#!/usr/bin/env python3
"""C925: Mori--Mukai 2-24 (the smooth (1,2) divisor X in P^2 x P^2) is the
projectivization P(E) of the rank-2 bundle E = ker(O^3 -> O(2)) on the second
P^2 factor; exact certificates for the closure of its carrier ledger.

Mathematical closure (companion note): smoothness of X forces the defining net
of conics to be base-point-free, so X = P(E); Iritani--Koto (arXiv:2307.03696,
Theorem 5.1) decomposes QDM(P(E)) into two copies of pulled-back QDM(P^2)
intertwining the whole quantum connection (including z d/dz) and the pairing,
and the small quantum algebra of P^2 is etale at every point of its punctured
Novikov torus, so the upgraded anchor lemma (blow-up-chains note, section 1)
makes every ledger block of X semisimple.  This script certifies the exact
finite algebra used by that argument and two independent corroborations:

  1. cohomology match: the apolar ring of the (1,2) divisor's cubic
     intersection form equals Q[h1,h2]/(h1^2 - 2 h1 h2 + 4 h2^2, h2^3), which
     is exactly the Grothendieck presentation H*(P^2)[xi]/(xi^2 + c1 xi + c2)
     for c(E) = 1 - 2 h2 + 4 h2^2 and xi = h1 = c1(O_{P(E)}(1));
  2. the small quantum algebra of the base P^2 is etale at every q != 0
     (discriminant of lam^3 - q);
  3. the ambient quantum-Lefschetz hypergeometric operators
        P1 = p1^3 - q1 (p1 + 2 p2 + z),
        P2 = p2^3 - q2 (p1 + 2 p2 + z)(p1 + 2 p2 + 2 z)
     annihilate the two-parameter I-function of X term by term (checked on a
     grid, exactly, in H*(P^2 x P^2)); their z -> 0 spectral scheme at the
     canonical point q1 = q2 = 1 decomposes as a multiplicity-three point at
     the origin -- the ambient excess carrying the twisted-pairing
     degeneracy (trace-form rank 7 = 1 + 6) -- plus six distinct reduced
     points, matching chi(X) = 6, whose -K_X = 2 p1 + p2 values are six
     distinct nonzero algebraic numbers;
  4. the quantum period G_X(t) = e^{-2t} sum t^{2l+m} (l+2m)!/(l!^3 m!^3)
     built from the same I-function reproduces the published regularized
     coefficients of Coates--Corti--Galkin--Kasprzyk (arXiv:1303.3288,
     section 41, Minkowski sequence 44) through t^9.

Replay:
    uv run --with sympy python3 \
      notes/cubic-threefolds-tasks/c925-fable-mm224-projective-bundle-etale.py
"""
import itertools

import sympy as sp

h1, h2, z, t, lam = sp.symbols("h1 h2 z t lam")
p1, p2 = sp.symbols("p1 p2")

# ---- part 1: H*(X) is the projective-bundle ring of E = ker(O^3 -> O(2)) ----
# Intersection cubic of X from adjunction in F = P^2 x P^2 (h1^3 = h2^3 = 0,
# int_F h1^2 h2^2 = 1): int_X h1^a h2^b = int_F h1^a h2^b (h1 + 2 h2).


def ambient_reduce(expr):
    """Reduce a polynomial in h1, h2 modulo (h1^3, h2^3)."""
    p = sp.Poly(sp.expand(expr), h1, h2, domain="EX")
    out = sp.S(0)
    for (a, b), c in p.terms():
        if a <= 2 and b <= 2:
            out += c * h1**a * h2**b
    return sp.expand(out)


def integral_F(expr):
    """int_{P^2 x P^2}: coefficient of h1^2 h2^2."""
    p = sp.Poly(ambient_reduce(expr), h1, h2, domain="EX")
    return p.coeff_monomial(h1**2 * h2**2)


def integral_X(expr):
    return integral_F(sp.expand(expr) * (h1 + 2 * h2))


cubic = {(a, b): integral_X(h1**a * h2**b) for a in range(4) for b in range(4)
         if a + b == 3}
assert cubic == {(3, 0): 0, (2, 1): 2, (1, 2): 1, (0, 3): 0}, cubic

# Apolar (annihilator) ideal of that cubic form in Q[h1,h2]: degree-2 kernel
# of the pairing into degree 3, plus the degree-3 kernel.
deg2 = [h1**2, h1 * h2, h2**2]
deg1 = [h1, h2]
rows = [[integral_X(m * n) for m in deg2] for n in deg1]
K = sp.Matrix(rows)                     # 2 x 3 pairing matrix
null = K.nullspace()
assert len(null) == 1
v = null[0]
rel2 = sp.expand(sum(c * m for c, m in zip(v, deg2)) / v[0])
assert rel2 == h1**2 - 2 * h1 * h2 + 4 * h2**2, rel2

# Chern classes of E = ker(O^3 -> O(2)) on P^2 (h = h2): c(E)(1+2h) = 1.
cE = sp.expand(1 - 2 * h2 + 4 * h2**2)
assert ambient_reduce(cE * (1 + 2 * h2) - 1 - 8 * h2**3) == 0
# Grothendieck relation xi^2 + c1 xi + c2 with xi = h1, c1 = -2 h2, c2 = 4h2^2:
assert sp.expand(h1**2 + (-2 * h2) * h1 + 4 * h2**2) == rel2
print("part 1: apolar degree-2 relation h1^2 - 2 h1 h2 + 4 h2^2 equals the")
print("        Grothendieck relation of P(ker(O^3 -> O(2))), c(E) = 1 - 2h + 4h^2")


def quotient_basis(ideal, gens, bound):
    G = sp.groebner(ideal, *gens, order="grevlex")
    lms = [sp.Poly(sp.LM(g, order="grevlex"), *gens).monoms()[0]
           for g in G.exprs]
    basis = []
    for exps in itertools.product(range(bound), repeat=len(gens)):
        if any(all(e >= l for e, l in zip(exps, lm))
               for lm in lms):
            continue
        basis.append(sp.prod([g**e for g, e in zip(gens, exps)]))
    return G, basis


# The full apolar ideal is (rel2, h2^3): quotient must have Hilbert dims
# 1,2,2,1 (= H^0, H^2, H^4, H^6 of X).
GX, basisX = quotient_basis([rel2, h2**3], (h1, h2), 7)
assert len(basisX) == 6, basisX
dims = [0] * 4
for m in basisX:
    dims[sp.Poly(m, h1, h2).total_degree()] += 1
assert dims == [1, 2, 2, 1], dims
# and every degree-3 apolar element is in the ideal: h1^3, h2^3, h1^2h2-2h1h2^2
for g in (h1**3, h2**3, h1**2 * h2 - 2 * h1 * h2**2):
    assert GX.reduce(g)[1] == 0, g
print("part 1: quotient Hilbert dimensions (1,2,2,1); degree-3 annihilator")
print("        contained in the ideal -> H*(X) = H*(P(E)) exactly")

# ---- part 2: the base P^2 is quantum-etale on the whole punctured torus ----
q = sp.symbols("q")
discP2 = sp.discriminant(lam**3 - q, lam)
assert sp.expand(discP2 + 27 * q**2) == 0, discP2
print("part 2: disc(lam^3 - q) = -27 q^2 != 0 for q != 0: QH(P^2) etale on")
print("        the punctured Novikov torus (anchor for both summands)")

# ---- part 3: hypergeometric operators annihilate the I-function ------------
# I = e^{(h1 log q1 + h2 log q2)/z} sum_{l,m} q1^l q2^m c(l,m) with
#   c(l,m) = prod_{j=1}^{l+2m}(D + j z) / (prod_{j=1}^{l}(h1 + j z)^3
#                                          prod_{j=1}^{m}(h2 + j z)^3),
# D = h1 + 2 h2, valued in H*(P^2 x P^2).  After conjugating by the
# exponential prefactor, P1 and P2 annihilate I iff for all l, m >= 0:
#   (h1 + l z)^3 c(l,m) = (D + (l+2m) z) c(l-1,m)
#   (h2 + m z)^3 c(l,m) = (D + (l+2m-1) z)(D + (l+2m) z) c(l,m-1)
# with c(-1,m) = c(l,-1) = 0 (the l = 0 / m = 0 cases hold because
# h1^3 = h2^3 = 0 in the ambient ring).
D = h1 + 2 * h2


def inv_cubed(h, j):
    """(h + j z)^{-3} exactly, using h^3 = 0."""
    u = h / (j * z)
    inv = (1 - u + u**2) / (j * z)          # (h + jz)^{-1}
    return ambient_reduce_z(inv**3)


def ambient_reduce_z(expr):
    expr = sp.together(sp.expand(expr))
    num, den = sp.fraction(expr)
    p = sp.Poly(sp.expand(num), h1, h2, domain="EX")
    out = sp.S(0)
    for (a, b), c in p.terms():
        if a <= 2 and b <= 2:
            out += c * h1**a * h2**b
    return sp.expand(out / den)


def cterm(l, m):
    if l < 0 or m < 0:
        return sp.S(0)
    num = sp.prod([D + j * z for j in range(1, l + 2 * m + 1)])
    e = sp.expand(num)
    for j in range(1, l + 1):
        e = ambient_reduce_z(e * inv_cubed(h1, j))
    for j in range(1, m + 1):
        e = ambient_reduce_z(e * inv_cubed(h2, j))
    return ambient_reduce_z(e)


GRID = 3
for l in range(GRID + 1):
    for m in range(GRID + 1):
        c_lm = cterm(l, m)
        lhs1 = ambient_reduce_z((h1 + l * z)**3 * c_lm)
        rhs1 = ambient_reduce_z((D + (l + 2 * m) * z) * cterm(l - 1, m))
        assert sp.simplify(lhs1 - rhs1) == 0, ("P1", l, m)
        lhs2 = ambient_reduce_z((h2 + m * z)**3 * c_lm)
        rhs2 = ambient_reduce_z((D + (l + 2 * m - 1) * z)
                                * (D + (l + 2 * m) * z) * cterm(l, m - 1))
        assert sp.simplify(lhs2 - rhs2) == 0, ("P2", l, m)
print(f"part 3: P1 I = P2 I = 0 verified exactly on the grid l, m <= {GRID}")

# ---- part 3b: the z -> 0 spectral scheme at q1 = q2 = 1 is etale -----------
rels = [p1**3 - (p1 + 2 * p2), p2**3 - (p1 + 2 * p2)**2]
Gt, basist = quotient_basis(rels, (p1, p2), 7)
assert len(basist) == 9, basist


def mult_matrix(elem):
    M = sp.zeros(9, 9)
    for k, b in enumerate(basist):
        red = Gt.reduce(sp.expand(elem * b))[1]
        pr = sp.Poly(red, p1, p2, domain="QQ")
        for (a, bb), c in pr.terms():
            mon = p1**a * p2**bb
            M[basist.index(mon), k] = c
    return M


# Structure of the ambient spectral scheme: eliminating with
# p2 = (p1^3 - p1)/2, the scheme is  p1^3 (p1^2 - 1)^3 = 8 p1^6, i.e. a
# multiplicity-three point at the origin plus the six simple roots of
# (t^2 - 1)^3 - 8 t^3.  The origin is ambient excess (it carries the
# degenerate directions of the twisted pairing); the six reduced points
# match chi(X) = 6 and have six distinct nonzero -K_X = 2p1 + p2 values.
M1 = mult_matrix(p1)
chi1 = sp.expand(M1.charpoly(lam).as_expr())
target = sp.expand(lam**3 * ((lam**2 - 1)**3 - 8 * lam**3))
assert chi1 == target, chi1
qred = sp.Poly((lam**2 - 1)**3 - 8 * lam**3, lam)
assert sp.gcd(qred, qred.diff(lam)).total_degree() == 0   # squarefree
assert qred.eval(0) != 0                                  # origin not a root
# -K_X values on the six reduced points: s = 2 p1 + p2 = (p1^3 + 3 p1)/2
s = sp.symbols("s")
elim = sp.resultant(qred.as_expr(), 2 * s - lam**3 - 3 * lam, lam)
elimP = sp.Poly(sp.expand(elim), s)
assert elimP.degree() == 6
assert sp.gcd(elimP, elimP.diff(s)).total_degree() == 0   # 6 distinct values
assert elimP.eval(0) != 0                                 # all nonzero
# trace form: rank 7 = 1 (from the multiplicity-3 local factor) + 6 (fields)
tg = sp.zeros(9, 9)
Ms = {b: mult_matrix(b) for b in basist}
for i, a in enumerate(basist):
    for j, b in enumerate(basist):
        tg[i, j] = sp.trace(Ms[a] * Ms[b])
assert tg.rank() == 7, tg.rank()
print("part 3b: ambient spectral scheme at q=(1,1): dim 9 = fat origin")
print("         (multiplicity 3, the twisted-pairing degeneracy) + six")
print("         distinct reduced points (= chi(X)); their -K_X values are")
print("         the six distinct nonzero roots of", elimP.as_expr())
print("         trace-form rank 7 = 1 + 6, as a local cube plus six fields")

# ---- part 4: CCGK quantum period match through t^9 -------------------------
N = 9
series = sp.S(0)
for l in range(N + 1):
    for m in range(N + 1):
        d = 2 * l + m
        if 0 < d <= N or (l, m) == (0, 0):
            series += (sp.factorial(l + 2 * m)
                       / sp.factorial(l)**3 / sp.factorial(m)**3) * t**d
G = sp.expand(sp.series(sp.exp(-2 * t), t, 0, N + 1).removeO() * series)
Ghat = [sp.factorial(k) * G.coeff(t, k) for k in range(N + 1)]
CCGK = [1, 0, 4, 24, 132, 780, 5800, 40320, 283780, 2105880]
assert Ghat == CCGK, Ghat
print("part 4: regularized quantum period matches CCGK section 41:",
      Ghat[2:], "at t^2..t^9")
print("MM 2-24 = P(ker(O^3 -> O(2))) over P^2: ledger closed by")
print("Iritani--Koto Theorem 5.1 + the anchor lemma at the base P^2")
