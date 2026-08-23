#!/usr/bin/env python3
"""C925: ambient probe of the weak-Fano minimal conic bundle
X in |2 xi + 3 h| inside F = P(O + O + O(-3)) over P^2 (companion note
2026-08-23-c925-fable-weak-fano-conic-bundle.md).

X is the first explicit member of carrier class (a): smooth, relatively
minimal, b_3 = 0, not Fano; X . l = -3 on the K-trivial lines l of the
forced section, so the class 2 xi + 3 h is not nef.

Two exact findings, both certified below:

(1) NEGATIVE (the convexity obstruction, located).  The twisted
    hypergeometric coefficients for the pair (F, 2 xi + 3 h) do NOT
    satisfy the naive GKZ shift identity in the K-trivial direction: the
    twist factor's negative-degree convention (Euler class of -H^1,
    excluding the m = 0 factor) breaks the uniform product ratio exactly
    when the twist degree 2b - 3a crosses zero.  The identity fails
    already at (a, b) = (1, 0), and the script certifies that failure.
    So the twisted D-module is genuinely not GKZ along the K-trivial
    Novikov direction — the precise technical face of "non-Fano carriers
    need new technology".

(2) POSITIVE (a valid probe).  The UNTWISTED toric ambient F has uniform
    doubly-infinite divisor conventions, its shift identities hold at all
    degrees including the negative-xi-degree region, and its z -> 0
    symbols are
        R2 = xi^2 (xi + 3 h) - w        (fibre direction, deg w = 2)
        R1 = h^3 - x xi^6               (K-trivial direction, deg x = 0)
    F contains the same P^2-section with the same 1/3(1,1,1)
    K-trivial contraction as X, and R1 exhibits the h ~ x^{1/3} sheets:
    the K-trivial Novikov loop genuinely permutes three sheets — the
    exact structure the three-cycle gate is about, now in a rigorously
    computable ambient model.  The script computes the spectral scheme
    of (R1, R2) at w = 1 for several x: its dimension, the eigenvalue
    profile of a Kaehler direction, and whether the three-cycle sheets
    are SIMPLE (reduced) — simple sheets in a three-cycle are unmarked.

Caveat: F is not Fano, so the z -> 0 GKZ symbols may differ from the
honest small quantum relations of F by a mirror transformation; the
D-module and its sheet/monodromy structure are the invariant content
used here.  Nothing in this file computes QH(X) itself.

Replay:
    uv run --with sympy python3 \
      notes/cubic-threefolds-tasks/c925-fable-weak-fano-ambient-probe.py
"""
import itertools

import sympy as sp

h, xi, z, lam = sp.symbols("h xi z lam")


def nf(expr):
    """Normal form in H*(F) = Q[h,xi]/(h^3, xi^3 + 3 h xi^2);
    coefficients may be rational in z."""
    expr = sp.together(sp.expand(expr))
    num, den = sp.fraction(expr)
    p = sp.Poly(sp.expand(num), h, xi, domain="EX")
    out = sp.S(0)
    for (i, j), c in p.terms():
        if j > 2:
            k = j - 2
            i, j, c = i + k, 2, c * (-3) ** k
        if i > 2:
            continue
        out += c * h**i * xi**j
    return sp.expand(out / den)


def quotient_basis(ideal, gens, bound):
    G = sp.groebner(ideal, *gens, order="grevlex")
    lms = [sp.Poly(sp.LM(g, order="grevlex"), *gens).monoms()[0]
           for g in G.exprs]
    basis = []
    for exps in itertools.product(range(bound), repeat=len(gens)):
        if any(all(e >= l for e, l in zip(exps, lm)) for lm in lms):
            continue
        basis.append(sp.prod([g**e for g, e in zip(gens, exps)]))
    return G, basis


_, amb = quotient_basis([h**3, sp.expand(xi**2 * (xi + 3 * h))],
                        (h, xi), 6)
assert len(amb) == 9
print("part 1: ambient ring rank 9 = chi(P(E))")

# ---- exact divisor factors, doubly-infinite convention -------------------


def inv_lin(D, m):
    acc = sp.S(0)
    for j in range(5):
        acc += (-1)**j * D**j / (m * z)**(j + 1)
    return nf(acc)


def div_factor(D, k):
    """prod_{m=-inf}^{0}(D+mz) / prod_{m=-inf}^{k}(D+mz), exactly:
    k >= 0 -> 1/prod_{m=1..k}(D+mz);  k < 0 -> prod_{m=0..-k-1}(D-mz)."""
    acc = sp.S(1)
    if k >= 0:
        for m in range(1, k + 1):
            acc = nf(acc * inv_lin(D, m))
    else:
        for m in range(0, -k):
            acc = nf(acc * (D - m * z))
    return acc


def twist_factor(K, k):
    """Euler-class twist factor for the class K at degree k:
    k >= 0 -> prod_{m=1..k}(K+mz);  k < 0 -> 1/prod_{m=1..-k-1}(K-mz)."""
    acc = sp.S(1)
    if k >= 0:
        for m in range(1, k + 1):
            acc = nf(acc * (K + m * z))
    else:
        for m in range(1, -k):
            acc = nf(acc * inv_lin(K, -m))
    return acc


X = 2 * xi + 3 * h


def cF(a, b):
    """Untwisted ambient I-coefficient of F at class a*l + b*f."""
    if a < 0 or b < 0:
        return sp.S(0)
    val = div_factor(h, a)
    for _ in range(2):
        val = nf(val * div_factor(h, a))
    val = nf(val * div_factor(xi, b - 3 * a))
    val = nf(val * div_factor(xi, b - 3 * a))
    val = nf(val * div_factor(xi + 3 * h, b))
    return val


def cTw(a, b):
    return nf(cF(a, b) * twist_factor(X, 2 * b - 3 * a))


# ---- part 2: the twist obstruction, certified ----------------------------
lhs = nf((h + z) ** 3 * (X - 2 * z) * (X - z) * (X + 0 * z) * cTw(1, 0))
rhs = nf((xi - 2 * z) ** 2 * (xi - z) ** 2 * (xi + 0 * z) ** 2 * cTw(0, 0))
assert sp.simplify(lhs - rhs) != 0
print("part 2: twisted K-trivial shift identity FAILS at (a,b)=(1,0):")
print("        the non-convex twist is not GKZ along the K-trivial ray")

# ---- part 3: untwisted ambient identities hold everywhere ----------------
GRID = 2
for a in range(GRID + 1):
    for b in range(GRID + 1):
        L = nf((xi + (b - 3 * a) * z) ** 2
               * ((xi + 3 * h) + b * z) * cF(a, b))
        R = nf(cF(a, b - 1))
        assert sp.simplify(L - R) == 0, ("Q2", a, b)
        L = nf((h + a * z) ** 3 * cF(a, b))
        R = nf((xi + (b - 3 * a + 1) * z) ** 2
               * (xi + (b - 3 * a + 2) * z) ** 2
               * (xi + (b - 3 * a + 3) * z) ** 2 * cF(a - 1, b))
        assert sp.simplify(L - R) == 0, ("Q1", a, b)
print(f"part 3: ambient shift identities verified on the grid a,b <= {GRID}")
print("        (negative xi-degree region included); z->0 symbols:")
print("        R2 = xi^2(xi+3h) - w,  R1 = h^3 - x xi^6")

# ---- part 4: spectral scheme at w = 1, several x -------------------------
R2s = sp.expand(xi**2 * (xi + 3 * h) - 1)
for x0 in (sp.S(1), sp.S(-1), sp.S(2), sp.Rational(1, 5)):
    R1s = sp.expand(h**3 - x0 * xi**6)
    Gx, bx = quotient_basis([R1s, R2s], (h, xi), 30)
    dim = len(bx)
    M = sp.zeros(dim, dim)
    probe = xi + 3 * h                       # a Kaehler-direction operator
    for k, bmon in enumerate(bx):
        red = Gx.reduce(sp.expand(probe * bmon))[1]
        pr = sp.Poly(red, h, xi, domain="QQ")
        for (e1, e2), cc in pr.terms():
            M[bx.index(h**e1 * xi**e2), k] = cc
    chi_poly = sp.Poly(M.charpoly(lam).as_expr(), lam)
    facs = [(f.as_expr(), m) for f, m in chi_poly.factor_list()[1]]
    sqfree = all(m == 1 and sp.gcd(sp.Poly(f, lam),
                                   sp.Poly(f, lam).diff(lam)
                                   ).total_degree() == 0
                 for f, m in facs)
    print(f"x = {x0}: dim {dim}; (xi+3h)-charpoly factor degrees "
          f"{sorted(sp.Poly(f, lam).degree() for f, _ in facs)}; "
          f"all simple: {sqfree}")
print("part 4: the h ~ x^(1/3) three-cycle sheets of R1 = h^3 - x xi^6 are")
print("        read off the factor/simplicity profile above")
