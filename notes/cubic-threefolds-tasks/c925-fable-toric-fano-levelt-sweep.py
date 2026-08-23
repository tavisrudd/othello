#!/usr/bin/env python3
"""C925 / cubic-threefolds lane.

Jordan structure of the small quantum multiplication operator c_1 * on H^even, at the
canonical small point (all Novikov variables = 1), for every smooth toric Fano threefold,
plus the Levelt exponent class of every nontrivial Jordan block.

These 18 varieties are b_3 = 0 carriers.  The claim under test predicts that the marked
("cubic") Levelt class {1/6, 5/6}, delta^sharp = 4/9, never occurs on such a carrier.

Replay:
    uv run --with sympy python3 c925-fable-toric-fano-levelt-sweep.py

Everything is derived inside the script; no external fan data is trusted.

Contents
--------
1.  Enumeration of the smooth Fano 3-fans up to GL(3,Z), from scratch, by completing the
    fan one wall at a time.  A smooth complete fan is Fano exactly when every maximal cone
    is the cone over a facet of conv(rays); that is imposed as a pruning invariant and
    re-verified on each completed fan.  Casagrande's bound (a smooth Fano d-polytope has at
    most 3d vertices, 3d-1 for d odd) caps the ray count at 8.
2.  Structural identification (products, projective bundles with their twist, equivariant
    blow-down chains) so each fan carries a readable name.
3.  Batyrev's presentation of QH^*(X) (a theorem for smooth toric Fano, via Givental's
    mirror theorem):  C[x_rho] / (linear relations + quantum Stanley-Reisner relations),
    with the Novikov variables set to 1.  The linear relations are sum_rho <m, v_rho> x_rho
    for m in M; for each primitive collection P = {rho_1..rho_k} with primitive relation
    sum_i v_{rho_i} = sum_j c_j v_{sigma_j}, the quantum relation is
    x_{rho_1}...x_{rho_k} = q^{beta(P)} prod_j x_{sigma_j}^{c_j}, and beta(P) is Fano-positive.
4.  Exact Jordan type of c_1 *, decided over Q by factoring the characteristic polynomial
    into Q-irreducibles and taking ranks of f(U)^k.  No floating point is used anywhere in
    the Jordan decision; the whole Galois orbit of each irreducible factor is handled at once.
5.  An independent cross-check of the spectrum through the mirror Landau-Ginzburg potential
    W = sum_rho z^{v_rho} on (C^*)^3: the critical values of W are computed in the Jacobian
    ring built directly from z_i dW/dz_i, a code path that shares no step with the Batyrev
    construction, and the two characteristic polynomials are required to agree.
6.  Levelt exponents of a rank-two block, following
    notes/cubic-threefolds-tasks/c925-fable-levelt-exponent-tool.py, with the cubic threefold
    as a positive control: the tool must return the marked class on it.
"""
import sys
from math import gcd
from itertools import combinations, product

import sympy as sp
from sympy import Rational as Q


# ---------------------------------------------------------------- lattice helpers

def det3(a, b, c):
    return (a[0] * (b[1] * c[2] - b[2] * c[1])
            - a[1] * (b[0] * c[2] - b[2] * c[0])
            + a[2] * (b[0] * c[1] - b[1] * c[0]))


def inv3_int(a, b, c):
    """Rows of the inverse of the matrix with columns a, b, c (determinant +-1)."""
    d = det3(a, b, c)
    assert d in (1, -1), "cone is not unimodular"
    m = [[a[0], b[0], c[0]], [a[1], b[1], c[1]], [a[2], b[2], c[2]]]

    def cof(i, j):
        rr = [r for r in range(3) if r != i]
        cc = [k for k in range(3) if k != j]
        sub = m[rr[0]][cc[0]] * m[rr[1]][cc[1]] - m[rr[0]][cc[1]] * m[rr[1]][cc[0]]
        return ((-1) ** (i + j)) * sub
    adj = [[cof(j, i) for j in range(3)] for i in range(3)]
    return [[adj[i][j] * d for j in range(3)] for i in range(3)]


def normal_of(rays, tri):
    """The integral m with <m, v> = 1 on the three generators of the unimodular cone tri."""
    Minv = inv3_int(*[rays[i] for i in tri])
    return tuple(Minv[0][j] + Minv[1][j] + Minv[2][j] for j in range(3))


def dot(m, v):
    return m[0] * v[0] + m[1] * v[1] + m[2] * v[2]


# ------------------------------------------------------- 1. enumeration of the fans

MAXRAYS = 8     # Casagrande's bound for d = 3
COORD = 4       # coordinate box used for pruning
AB = 5          # range of the wall-crossing coefficients


def enumerate_fans():
    """All smooth Fano 3-fans containing the cone(e1,e2,e3), as (rays, maximal cones)."""
    results, seen = [], set()

    def wall_counts(cones):
        wc = {}
        for c in cones:
            for w in ((c[0], c[1]), (c[0], c[2]), (c[1], c[2])):
                wc[w] = wc.get(w, 0) + 1
        return wc

    def convex(rays, cones):
        """Every maximal cone is the cone over a facet of conv(rays)."""
        for c in cones:
            m = normal_of(rays, c)
            for idx, r in enumerate(rays):
                d = dot(m, r)
                if idx in c:
                    if d != 1:
                        return False
                elif d >= 1:
                    return False
        return True

    def rec(rays, cones):
        wc = wall_counts(cones)
        openw = [w for w, k in wc.items() if k == 1]
        if not openw:
            if convex(rays, cones):
                results.append((list(rays), list(cones)))
            return
        wall = min(openw)
        host = next(c for c in cones if wall[0] in c and wall[1] in c)
        u = next(i for i in host if i not in wall)
        vi, wi = wall
        uv, vv, wv = rays[u], rays[vi], rays[wi]
        for a in range(-AB, AB + 1):
            for b in range(-AB, AB + 1):
                # smoothness of both cones forces x = -u + a v + b w; convexity of the
                # anticanonical polytope across the wall forces a + b <= 1.
                if a + b > 1:
                    continue
                x = tuple(-uv[k] + a * vv[k] + b * wv[k] for k in range(3))
                if max(abs(t) for t in x) > COORD:
                    continue
                if x in rays:
                    xi = rays.index(x)
                    if xi in (u, vi, wi):
                        continue
                    newrays = rays
                else:
                    if len(rays) >= MAXRAYS:
                        continue
                    xi = len(rays)
                    newrays = rays + [x]
                nc = tuple(sorted((vi, wi, xi)))
                if nc in cones:
                    continue
                newcones = cones + [nc]
                if any(k > 2 for k in wall_counts(newcones).values()):
                    continue
                if not convex(newrays, newcones):
                    continue
                key = (tuple(newrays), tuple(sorted(newcones)))
                if key in seen:
                    continue
                seen.add(key)
                rec(newrays, newcones)

    rec([(1, 0, 0), (0, 1, 0), (0, 0, 1)], [(0, 1, 2)])
    return results


def isomorphic(f1, f2):
    """Is there a GL(3,Z) map carrying one ray set onto the other?"""
    r1, c1 = f1
    r2, c2 = f2
    if len(r1) != len(r2) or len(c1) != len(c2):
        return False
    target = set(r2)
    Ainv = inv3_int(*[r1[i] for i in c1[0]])
    from itertools import permutations
    for cone in c2:
        for perm in permutations(cone):
            p, q, s = (r2[i] for i in perm)
            B = [[p[0], q[0], s[0]], [p[1], q[1], s[1]], [p[2], q[2], s[2]]]
            M = [[sum(B[i][k] * Ainv[k][j] for k in range(3)) for j in range(3)]
                 for i in range(3)]
            img = set(tuple(sum(M[i][j] * v[j] for j in range(3)) for i in range(3))
                      for v in r1)
            if img == target:
                return True
    return False


def classify():
    reps = []
    for f in enumerate_fans():
        if not any(isomorphic(f, g) for g in reps):
            reps.append(f)
    reps.sort(key=lambda f: (len(f[0]), sorted(f[0])))
    return reps


# ------------------------------------------------- 2. structural names for the fans

def complete_basis(v):
    box = [x for x in product(range(-1, 2), repeat=3) if x != (0, 0, 0)]
    for w1 in box:
        for w2 in box:
            if det3(v, w1, w2) == 1:
                return w1, w2
    raise RuntimeError("no basis completion inside the small box")


def surface_name(rays2):
    n = len(rays2)
    rs = set(rays2)
    opp = sum(1 for r in rays2 if tuple(-x for x in r) in rs) // 2
    return {3: "P^2",
            4: "P^1xP^1" if opp == 2 else "F_1",
            5: "dP7",
            6: "dP6"}.get(n, f"S({n} rays)")


def minors2_gcd(vs):
    g = 0
    for a, b in combinations(vs, 2):
        for i, j in combinations(range(3), 2):
            g = gcd(g, a[i] * b[j] - a[j] * b[i])
    return g


def bundle_twist(base, lifts):
    """Reduce the lift vector modulo c_i -> c_i + <m, u_i>; returns None if trivial."""
    for i, j in combinations(range(len(base)), 2):
        d = base[i][0] * base[j][1] - base[i][1] * base[j][0]
        if d == 0:
            continue
        # solve <m, u_i> = c_i, <m, u_j> = c_j over Q
        m0 = Q(lifts[i] * base[j][1] - lifts[j] * base[i][1], d)
        m1 = Q(base[i][0] * lifts[j] - base[j][0] * lifts[i], d)
        if m0.q != 1 or m1.q != 1:
            continue
        red = [lifts[k] - (m0 * base[k][0] + m1 * base[k][1]) for k in range(len(base))]
        return None if all(r == 0 for r in red) else [int(r) for r in red]
    return [int(c) for c in lifts]


def faces_of(cones):
    f = set()
    for c in cones:
        for k in range(1, 4):
            for s in combinations(sorted(c), k):
                f.add(s)
    return f


def describe(rays, cones, depth=0):
    n = len(rays)
    rs = set(rays)
    if depth > 6:
        return f"toric 3-fold, {n} rays"
    bundles = []
    for v in rays:
        nv = tuple(-x for x in v)
        if nv not in rs:
            continue
        others = [r for r in rays if r != v and r != nv]
        w1, w2 = complete_basis(v)
        img = [(det3(v, r, w2), det3(v, w1, r)) for r in others]
        if len(set(img)) != len(img):
            continue
        lifts = [det3(r, w1, w2) for r in others]
        S = surface_name(img)
        tw = bundle_twist(img, lifts)
        if tw is None:
            return "P^1 x P^1 x P^1" if S == "P^1xP^1" else f"{S} x P^1"
        if S == "P^2":
            bundles.append(f"P(O+O({abs(sum(tw))})) -> P^2")
            continue
        if S == "P^1xP^1":
            pairs, used = [], set()
            for i, u in enumerate(img):
                if i in used:
                    continue
                j = img.index(tuple(-t for t in u))
                used |= {i, j}
                pairs.append(tw[i] + tw[j])
            a, b = pairs
            if a < 0 or (a == 0 and b < 0):
                a, b = -a, -b
            bundles.append(f"P(O+O({a},{b})) -> P^1xP^1")
            continue
        bundles.append(f"P^1-bundle over {S}, twist {tw}")
    if bundles:
        return bundles[0]
    for tri in combinations(range(n), 3):
        sub = [rays[i] for i in tri]
        if tuple(sum(x[k] for x in sub) for k in range(3)) != (0, 0, 0):
            continue
        if det3(*sub) != 0 or minors2_gcd(sub) != 1:
            continue
        a, b = sub[0], sub[1]
        cr = (a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0])
        g = gcd(gcd(abs(cr[0]), abs(cr[1])), abs(cr[2]))
        cr = tuple(x // g for x in cr)
        vals = sorted(dot(cr, r) for i, r in enumerate(rays) if i not in tri)
        if vals == [-1, 1]:
            return "P^2-bundle over P^1"
    F = faces_of(cones)
    for i in range(n):
        star = [c for c in cones if i in c]
        rest = [j for j in range(n) if j != i]
        rem = {j: (j if j < i else j - 1) for j in rest}
        nr = [r for j, r in enumerate(rays) if j != i]
        if len(star) == 3:
            for tri in combinations(rest, 3):
                if tuple(sorted(tri)) in F:
                    continue
                if not all(tuple(sorted(p)) in F for p in combinations(tri, 2)):
                    continue
                if tuple(sum(rays[j][k] for j in tri) for k in range(3)) != rays[i]:
                    continue
                nc = [c for c in cones if i not in c] + [tuple(sorted(tri))]
                nc = [tuple(sorted(rem[j] for j in c)) for c in nc]
                return f"Bl_pt({describe(nr, nc, depth + 1)})"
        if len(star) == 4:
            for pair in combinations(rest, 2):
                if tuple(sorted(pair)) in F:
                    continue
                if tuple(rays[pair[0]][k] + rays[pair[1]][k] for k in range(3)) != rays[i]:
                    continue
                apex = set(j for c in star for j in c if j != i and j not in pair)
                if len(apex) != 2:
                    continue
                nc = [c for c in cones if i not in c]
                nc += [tuple(sorted(list(pair) + [a])) for a in apex]
                nc = [tuple(sorted(rem[j] for j in c)) for c in nc]
                return f"Bl_curve({describe(nr, nc, depth + 1)})"
    if n == 4:
        return "P^3"
    return f"toric 3-fold, {n} rays"


# ------------------------------------------------- 3. Batyrev presentation of QH^*

def primitive_collections(n, cones):
    F = faces_of(cones)
    pcs = []
    for k in range(2, n + 1):
        for s in combinations(range(n), k):
            if s in F:
                continue
            if all(tuple(x for x in s if x != i) in F for i in s):
                pcs.append(s)
    return pcs


def cone_coords(rays, cones, v):
    for c in cones:
        Minv = inv3_int(*[rays[i] for i in c])
        co = [sum(Minv[i][j] * v[j] for j in range(3)) for i in range(3)]
        if all(x >= 0 for x in co):
            return {c[i]: co[i] for i in range(3) if co[i] != 0}
    raise RuntimeError("point outside the support of a complete fan")


def presentation(rays, cones):
    """x-variables in terms of rho free y-variables, plus classical and quantum ideals."""
    n = len(rays)
    rho = n - 3
    c0 = cones[0]
    Sinv = inv3_int(*[rays[i] for i in c0])
    free = [i for i in range(n) if i not in c0]
    ys = sp.symbols(f"y0:{rho}")
    xs = [None] * n
    for j, i in enumerate(free):
        xs[i] = ys[j]
    for a in range(3):
        xs[c0[a]] = sp.expand(sum(-sum(Sinv[a][b] * rays[i][b] for b in range(3)) * ys[j]
                                  for j, i in enumerate(free)))
    quantum, classical, betas = [], [], []
    for P in primitive_collections(n, cones):
        vP = tuple(sum(rays[i][k] for i in P) for k in range(3))
        cc = {} if vP == (0, 0, 0) else cone_coords(rays, cones, vP)
        beta = len(P) - sum(cc.values())
        assert beta > 0, "primitive relation of non-positive degree: fan is not Fano"
        betas.append((P, cc, beta))
        lhs = sp.prod([xs[i] for i in P])
        rhs = sp.prod([xs[i] ** e for i, e in cc.items()])
        classical.append(sp.expand(lhs))
        quantum.append(sp.expand(lhs - rhs))
    return list(ys), xs, classical, quantum, betas


def std_monomials(G, gens):
    lm = [tuple(sp.Poly(g, *gens).monoms(order='grevlex')[0]) for g in G.exprs]
    ranges = []
    for i in range(len(gens)):
        b = None
        for e in lm:
            if e[i] > 0 and all(e[j] == 0 for j in range(len(gens)) if j != i):
                b = e[i] if b is None else min(b, e[i])
        assert b is not None, "quotient is not Artinian"
        ranges.append(range(b))
    out = []
    for exps in product(*ranges):
        if any(all(exps[j] >= e[j] for j in range(len(gens))) for e in lm):
            continue
        out.append(exps)
    return sorted(out, key=lambda e: (sum(e), e))


def mono(gens, e):
    return sp.prod([g ** k for g, k in zip(gens, e)])


def quantum_data(rays, cones):
    """U = matrix of c_1 * at q = 1 in the monomial basis, plus checks and (-K)^3."""
    chi = len(cones)
    ys, xs, classical, quantum, betas = presentation(rays, cones)
    Gc = sp.groebner(classical, *ys, order='grevlex')
    Bc = std_monomials(Gc, ys)
    assert len(Bc) == chi, f"classical dim {len(Bc)} != number of maximal cones {chi}"
    degs = [sum(e) for e in Bc]
    assert max(degs) == 3 and degs.count(3) == 1 and degs.count(0) == 1
    top = Bc[degs.index(3)]

    def cdeg(expr):
        p = sp.Poly(Gc.reduce(sp.expand(expr))[1], *ys)
        return dict(zip([tuple(m) for m in p.monoms()], p.coeffs())).get(top, 0)
    norm = cdeg(sp.prod([xs[i] for i in cones[0]]))
    assert norm != 0
    for c in cones:
        assert cdeg(sp.prod([xs[i] for i in c])) == norm, "point classes disagree"

    Gq = sp.groebner(quantum, *ys, order='grevlex')
    Bq = std_monomials(Gq, ys)
    assert len(Bq) == chi, f"quantum dim {len(Bq)} != number of maximal cones {chi}"
    idx = {e: i for i, e in enumerate(Bq)}

    def nf(expr):
        p = sp.Poly(Gq.reduce(sp.expand(expr))[1], *ys)
        v = [0] * chi
        for m, c in zip(p.monoms(), p.coeffs()):
            v[idx[tuple(m)]] = c
        return v
    T = sp.Matrix([nf(mono(ys, e)) for e in Bc]).T
    assert T.det() != 0, "classical monomials do not lift to a basis of the quantum ring"
    c1 = sp.expand(sum(xs))
    Uq = sp.Matrix([nf(sp.expand(c1 * mono(ys, e))) for e in Bq]).T
    U = sp.expand(T.inv() * Uq * T)
    for i in range(chi):
        for j in range(chi):
            if U[i, j] != 0:
                assert degs[i] <= degs[j] + 1, "c_1 * violates the quantum degree bound"
    kdeg = Q(cdeg(sp.expand(c1 ** 3)), norm)
    # trace form of the algebra: nondegenerate exactly when QH|_{q=1} is etale
    mult = []
    for e in Bq:
        mult.append(sp.Matrix([nf(sp.expand(mono(ys, e) * mono(ys, f))) for f in Bq]).T)
    tr = sp.Matrix(chi, chi, lambda i, j: (mult[i] * mult[j]).trace())
    return U, degs, kdeg, tr.det() != 0, betas


def lg_charpoly(rays, chi, L):
    """Independent spectrum: critical values of W = sum_rho z^{v_rho} on (C^*)^3."""
    z1, z2, z3, u = sp.symbols('z1 z2 z3 u')
    gens = (z1, z2, z3, u)

    def term(v):
        k = max(0, -v[0], -v[1], -v[2])
        return u ** k * z1 ** (v[0] + k) * z2 ** (v[1] + k) * z3 ** (v[2] + k)
    W = sp.expand(sum(term(v) for v in rays))
    eqs = [sp.expand(sum(v[i] * term(v) for v in rays)) for i in range(3)]
    eqs.append(sp.expand(u * z1 * z2 * z3 - 1))
    G = sp.groebner(eqs, *gens, order='grevlex')
    B = std_monomials(G, gens)
    assert len(B) == chi, f"LG Jacobian ring has dimension {len(B)}, expected {chi}"
    idx = {e: i for i, e in enumerate(B)}

    def nf(expr):
        p = sp.Poly(G.reduce(sp.expand(expr))[1], *gens)
        v = [0] * chi
        for m, c in zip(p.monoms(), p.coeffs()):
            v[idx[tuple(m)]] = c
        return v
    M = sp.Matrix([nf(sp.expand(W * mono(gens, e))) for e in B]).T
    return sp.expand(M.charpoly(L).as_expr())


# --------------------------------------------------------- 4. exact Jordan structure

def jordan_type(U, L):
    """[(irreducible factor, multiplicity, degree, block sizes)], decided exactly over Q."""
    n = U.shape[0]
    out = []
    for f, m in sp.factor_list(sp.expand(U.charpoly(L).as_expr()), L)[1]:
        fp = sp.Poly(f, L)
        FU = sp.zeros(n, n)
        Upow = sp.eye(n)
        for c in fp.all_coeffs()[::-1]:
            FU += c * Upow
            Upow = sp.expand(Upow * U)
        d = fp.degree()
        counts, P = [], sp.eye(n)
        while True:
            P = sp.expand(P * FU)
            k = n - P.rank()
            assert k % d == 0
            counts.append(k // d)
            if len(counts) >= 2 and counts[-1] == counts[-2]:
                break
        atleast = [counts[0]] + [counts[k] - counts[k - 1] for k in range(1, len(counts))]
        sizes = []
        for k in range(len(atleast), 0, -1):
            nk = atleast[k - 1] - (atleast[k] if k < len(atleast) else 0)
            sizes += [k] * nk
        sizes.sort(reverse=True)
        assert sum(sizes) == m, "block sizes inconsistent with the algebraic multiplicity"
        out.append((sp.factor(f), m, d, sizes))
    return out


# ---------------------------------- 5. Levelt exponents of a rank-two block (the tool)

def sylvester_solve(Ji, Jj, C):
    n, m = Ji.shape[0], Jj.shape[0]
    xs = sp.symbols(f"s0:{n*m}")
    X = sp.Matrix(n, m, xs)
    sol = sp.solve(list(Ji * X - X * Jj - C), xs, dict=True)
    assert len(sol) == 1, "Sylvester equation not uniquely solvable"
    return X.subs(sol[0])


def exponent_classes(U, g, label=""):
    """Levelt exponents of every rank-two block of z^2 Y' = (U + z g) Y at z = 0."""
    P, J = U.jordan_form()
    n = U.shape[0]
    blocks, i = [], 0
    while i < n:
        j = i + 1
        while j < n and J[j, j] == J[i, i] and (J[j - 1, j] != 0 if j > i + 1 else J[i, j] != 0):
            j += 1
        blocks.append((i, j))
        i = j
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
            G1[a:b, c:d] = sylvester_solve(J[a:b, a:b], J[c:d, c:d], -A1[a:b, c:d])
    B1 = sp.simplify(A1 + J * G1 - G1 * J)
    B2 = sp.simplify(A1 * G1 - G1 * B1 - G1)
    out = []
    for (a, b) in blocks:
        if b - a == 2 and J[a, a + 1] != 0:
            b1 = B1[a:b, a:b]
            assert b1[1, 0] == 0, f"(2,1) entry of the first-order block is {b1[1, 0]}"
            R = sp.Matrix([[b1[0, 0], J[a, a + 1]], [B2[a + 1, a], b1[1, 1] - 1]])
            ev = sorted(R.eigenvals().keys(), key=str)
            d2 = sp.simplify(R.trace() ** 2 - 4 * R.det())
            out.append((J[a, a], ev, d2))
    if label:
        print(f"  [{label}]")
        for u, ev, d2 in out:
            print(f"    eigenvalue {u}: rank-two block, exponents {ev}, delta^sharp = {d2}")
    return out


def cubic_threefold_control():
    """Positive control: the smooth cubic threefold must return the marked class."""
    q = Q(1, 3)
    Hstar = sp.Matrix([[0, 6 * q, 0, 36 * q ** 2], [1, 0, 15 * q, 0],
                       [0, 1, 0, 6 * q], [0, 0, 1, 0]])
    U = 2 * Hstar
    g = sp.diag(Q(3, 2), Q(1, 2), Q(-1, 2), Q(-3, 2))
    return U, g


# ------------------------------------------------------------------------- 6. driver

def main():
    L = sp.Symbol('L')
    print("=" * 92)
    print("C925: Jordan type of c_1 * and Levelt exponent classes")
    print("      for every smooth toric Fano threefold, at the canonical point q = 1")
    print("=" * 92)

    print("\n-- validation: Levelt tool on known rank-two blocks -------------------------")
    U, g = cubic_threefold_control()
    ctrl = exponent_classes(U, g, "cubic threefold (b_3 = 10), expect exponents -1/6, -5/6")
    assert len(ctrl) == 1, "control did not produce exactly one rank-two block"
    for _, ev, d2 in ctrl:
        assert d2 == Q(4, 9), f"control delta^sharp is {d2}, expected 4/9"
        assert set(ev) == {Q(-1, 6), Q(-5, 6)}, f"control exponents are {ev}"
    print("    control passes: the marked class {1/6, 5/6} is detected when present.")

    Ucurve = sp.Matrix([[0, 0], [2, 0]])
    gcurve = sp.diag(Q(1, 2), Q(-1, 2))
    ctrl2 = exponent_classes(Ucurve, gcurve, "rational curve summand, expect {1/2, 1/2}")
    assert len(ctrl2) == 1 and ctrl2[0][2] == 0, "second control failed"
    print("    control passes: an unmarked class {1/2, 1/2} is reported with delta^sharp 0.")

    print("\n-- enumeration of the smooth toric Fano threefolds --------------------------")
    reps = classify()
    print(f"    smooth Fano 3-fans up to GL(3,Z): {len(reps)}")
    assert len(reps) == 18, f"expected 18 smooth toric Fano threefolds, found {len(reps)}"
    dist = {}
    for rays, cones in reps:
        dist[len(rays) - 3] = dist.get(len(rays) - 3, 0) + 1
    print(f"    Picard rank distribution: {dict(sorted(dist.items()))}")
    assert dist == {1: 1, 2: 4, 3: 7, 4: 4, 5: 2}, "Picard rank distribution is wrong"
    for rays, cones in reps:
        assert len(cones) == 2 * len(rays) - 4, "not a simplicial 3-sphere"

    print("\n-- per-variety sweep --------------------------------------------------------")
    marked, nonss, nonetale, degrees, named = [], [], [], [], {}
    for k, (rays, cones) in enumerate(reps, 1):
        name = describe(rays, cones)
        chi = len(cones)
        U, degs, kdeg, etale, betas = quantum_data(rays, cones)
        degrees.append(kdeg)
        named[name] = kdeg
        assert lg_charpoly(rays, chi, L) == sp.expand(U.charpoly(L).as_expr()), \
            "Landau-Ginzburg cross-check failed"
        jt = jordan_type(U, L)
        # one copy of the block list per root of each Q-irreducible factor
        blocks = [s for _, _, d, sizes in jt for s in sizes for _ in range(d)]
        assert sum(blocks) == chi
        semisimple = max(blocks) == 1
        mults = sorted((m for _, m, d, _ in jt for _ in range(d)), reverse=True)
        ndist = sum(d for _, _, d, _ in jt)
        print(f"X{k:02d}  {name:<34s} b2={len(rays)-3}  chi={chi}  (-K)^3={kdeg}")
        print(f"      rays {rays}")
        print(f"      spectrum: {ndist} distinct eigenvalues, multiplicities {mults}; "
              f"charpoly {sp.factor(U.charpoly(L).as_expr())}")
        shape = ", ".join(f"{blocks.count(s)} of size {s}"
                          for s in sorted(set(blocks), reverse=True))
        print(f"      Jordan blocks of c_1 *: {shape}   "
              f"semisimple: {'yes' if semisimple else 'NO'}   "
              f"algebra etale: {'yes' if etale else 'NO'}")
        if not semisimple:
            nonss.append(name)
            # mu = (3 - deg)/2 on the monomial basis.  This is the correct grading only
            # if the monomial basis coincides with the classical cohomology basis; see
            # the caveat printed in the summary.  Reached only if a block exists.
            g = sp.diag(*[Q(3 - 2 * d, 2) for d in degs])
            for u, ev, d2 in exponent_classes(U, g, f"{name}: nontrivial blocks"):
                if d2 == Q(4, 9):
                    marked.append((name, u, ev))
        if not etale:
            nonetale.append(name)

    print("\n-- validation: closed forms -------------------------------------------------")
    assert degrees[0] == 64, "P^3 must have (-K)^3 = 64"
    assert sorted(degrees) == [36, 36, 40, 42, 44, 44, 46, 46, 48, 48,
                               50, 50, 52, 54, 54, 56, 62, 64], \
        f"anticanonical degrees {sorted(degrees)} do not match the classification"
    Up3, _, _, _, _ = quantum_data(*reps[0])
    assert sp.expand(Up3.charpoly(L).as_expr()) == L ** 4 - 256, \
        "P^3 spectrum is not {4, -4, 4i, -4i}"
    print("    P^3: charpoly L^4 - 256, spectrum 4 i^k, four simple eigenvalues.")
    print("    anticanonical degrees match the standard classification multiset.")
    # products S x P^1 satisfy (-K)^3 = 6 K_S^2, and K_S^2 = 12 - #rays for a smooth
    # complete toric surface; Bl_pt P^3 satisfies (-K)^3 = 64 - 8.
    closed = {"P^2 x P^1": 6 * 9, "P^1 x P^1 x P^1": 6 * 8, "F_1 x P^1": 6 * 8,
              "dP7 x P^1": 6 * 7, "dP6 x P^1": 6 * 6, "P(O+O(1)) -> P^2": 64 - 8}
    for nm, val in closed.items():
        assert named.get(nm) == val, f"{nm}: (-K)^3 = {named.get(nm)}, expected {val}"
    print("    products S x P^1 and Bl_pt P^3 match their closed-form degrees.")

    print("\n" + "=" * 92)
    print(f"SUMMARY: {len(reps)} smooth toric Fano threefolds (all b_3 = 0).")
    print(f"  non-semisimple c_1 * at q = 1: {len(nonss)}"
          + (f" -> {nonss}" if nonss else " (every one is diagonalizable)"))
    print(f"  QH^*|_{{q=1}} not etale: {len(nonetale)}"
          + (f" -> {nonetale}" if nonetale else " (every one is a product of fields)"))
    if marked:
        print("  *** MARKED BLOCKS OF CLASS {1/6, 5/6} FOUND: " + str(marked))
    else:
        print("  marked blocks of Levelt class {1/6, 5/6} (delta^sharp 4/9): NONE.")
    print("")
    print("  Scope note.  The Jordan type of c_1 * is an invariant of the operator and is")
    print("  independent of the basis, so the verdict above is basis-free.  The grading")
    print("  operator mu is diagonal only in the classical cohomology basis; the monomial")
    print("  basis of Batyrev's presentation differs from it by degree-lowering Novikov")
    print("  corrections (visible as a failure of the classical Poincare pairing to be")
    print("  graded on monomials).  A Levelt computation on a block would first have to fix")
    print("  that splitting.  No block occurs, so the exponent question never arises here.")
    print("=" * 92)


if __name__ == "__main__":
    sys.setrecursionlimit(10000)
    main()
