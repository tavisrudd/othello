#!/usr/bin/env python3
"""C855 — finite corroboration for notes/2026-08-03-c855-coding-dictionary-proofs.md.

Parts:
  1. five-point interpolation (Lemma 1.1--Corollary 1.3) and the orbit clause (Theorem 1.5)
  2. syndrome-weight trichotomy (Theorem 3.1) and the covering-radius layer (Lemmas 5.1, 5.2)
  3. uniqueness of the one-factorization of K6 (Theorem 4.4)
  4. GRS parity-check columns on the conic Y^2 = XZ (Lemma 6.1, Proposition 6.2, Theorem 6.3)

Replay:  python3 notes/2026-08-03-c855-coding-dictionary-checks.py
No dependencies beyond the standard library.
"""

from itertools import combinations, permutations, product

Q = 11

# Manuscript parity-check matrix (papers/clebsch-rigidity/clebsch_rigidity.tex, Section "The code").
H_COLS = [(1, 10, 0), (1, 9, 1), (1, 4, 7), (1, 8, 5), (0, 1, 4), (1, 1, 7)]

FAILS = []


def check(name, ok, detail=""):
    print(f"[{'ok ' if ok else 'FAIL'}] {name}{(' — ' + detail) if detail else ''}")
    if not ok:
        FAILS.append(name)


# ---------------------------------------------------------------- linear algebra over F_q

def norm(p):
    """Normalized representative of a projective point."""
    for c in p:
        if c % Q:
            inv = pow(c, Q - 2, Q)
            return tuple((x * inv) % Q for x in p)
    return None


def det3(a, b, c):
    return (a[0] * (b[1] * c[2] - b[2] * c[1])
            - a[1] * (b[0] * c[2] - b[2] * c[0])
            + a[2] * (b[0] * c[1] - b[1] * c[0])) % Q


def rank(rows, ncols):
    rows = [list(r) for r in rows]
    r = 0
    for col in range(ncols):
        piv = next((i for i in range(r, len(rows)) if rows[i][col] % Q), None)
        if piv is None:
            continue
        rows[r], rows[piv] = rows[piv], rows[r]
        inv = pow(rows[r][col], Q - 2, Q)
        rows[r] = [(x * inv) % Q for x in rows[r]]
        for i in range(len(rows)):
            if i != r and rows[i][col] % Q:
                f = rows[i][col]
                rows[i] = [(x - f * y) % Q for x, y in zip(rows[i], rows[r])]
        r += 1
    return r


PG2 = [norm(p) for p in product(range(Q), repeat=3) if any(p)]
PG2 = sorted(set(PG2))

QUAD_MONOMIALS = [(2, 0, 0), (1, 1, 0), (1, 0, 1), (0, 2, 0), (0, 1, 1), (0, 0, 2)]


def quad_row(p):
    return [(p[0] ** e[0] * p[1] ** e[1] * p[2] ** e[2]) % Q for e in QUAD_MONOMIALS]


def conic_space_dim(points):
    """Dimension of the space of quadratic forms vanishing at all given points."""
    return 6 - rank([quad_row(p) for p in points], 6)


def eval_quad(form, p):
    return sum(c * (p[0] ** e[0] * p[1] ** e[1] * p[2] ** e[2]) for c, e in zip(form, QUAD_MONOMIALS)) % Q


# ------------------------------------------------------------------ part 1

def part1():
    print("\n== Part 1: five-point interpolation and the conic-stabilizer orbit ==")
    # C : XZ = Y^2, i.e. form (0,0,1,-1,0,0).
    conic_form = (0, 0, 1, (Q - 1) % Q, 0, 0)
    conic_pts = [p for p in PG2 if eval_quad(conic_form, p) == 0]
    check("|C(F_11)| = 12", len(conic_pts) == 12, f"got {len(conic_pts)}")

    # Lemma 1.2: no three points of a nonsingular conic are collinear.
    collinear = [t for t in combinations(conic_pts, 3) if det3(*t) == 0]
    check("no three conic points collinear", not collinear)

    # Lemma 1.1: any five of them span a one-dimensional space of quadratic forms.
    dims = {conic_space_dim(list(f)) for f in combinations(conic_pts, 5)}
    check("five conic points determine a unique conic", dims == {1}, f"dims {sorted(dims)}")

    # Corollary 1.3: no two distinct nonsingular conics share five rational points.
    #   equivalent to the previous line, but checked directly against all nonsingular conics.
    nonsing = []
    for form in product(range(Q), repeat=6):
        if not any(form):
            continue
        a, b, c, d, e, f = form
        # symmetric matrix of the form  a X^2 + b XY + c XZ + d Y^2 + e YZ + f Z^2
        inv2 = pow(2, Q - 2, Q)
        M = [[a, b * inv2 % Q, c * inv2 % Q],
             [b * inv2 % Q, d, e * inv2 % Q],
             [c * inv2 % Q, e * inv2 % Q, f]]
        if det3(*M) % Q:
            nonsing.append(form)
    # normalize up to scalar
    classes = {}
    for form in nonsing:
        classes.setdefault(norm6(form), form)
    pointsets = {}
    dup = False
    for key, form in classes.items():
        ps = frozenset(p for p in PG2 if eval_quad(form, p) == 0)
        if ps in pointsets:
            dup = True
        pointsets[ps] = key
    check("distinct nonsingular conics have distinct rational point sets", not dup,
          f"{len(classes)} nonsingular conics up to scalar")

    # Theorem 1.5 at q=11: the projective stabilizer of the arc stabilizes the conic.
    arc = [norm(c) for c in H_COLS]
    unc = uncovered(arc)
    check("U(A) = C(F_11)", set(unc) == set(conic_pts), f"|U(A)| = {len(unc)}")
    stab = arc_stabilizer(arc)
    check("arc stabilizer has order 60", len(stab) == 60, f"got {len(stab)}")
    ok = True
    for g in stab:
        if {apply_mat(g, p) for p in conic_pts} != set(conic_pts):
            ok = False
    check("every arc projectivity stabilizes the conic (Theorem 1.5)", ok)


def norm6(form):
    for c in form:
        if c % Q:
            inv = pow(c, Q - 2, Q)
            return tuple((x * inv) % Q for x in form)
    return None


def apply_mat(g, p):
    return norm(tuple(sum(g[i][j] * p[j] for j in range(3)) % Q for i in range(3)))


def uncovered(arc):
    covered = set(arc)
    for a, b in combinations(arc, 2):
        for p in PG2:
            if det3(a, b, p) == 0:
                covered.add(p)
    return [p for p in PG2 if p not in covered]


def arc_stabilizer(arc):
    """Projectivities permuting the six arc points, found from frame images."""
    # A projectivity is determined by the images of four points in general position.
    base = arc[:4]
    assert all(det3(*t) for t in combinations(base, 3))
    out = []
    for images in permutations(arc, 4):
        if any(det3(*t) == 0 for t in combinations(images, 3)):
            continue
        g = frame_map(base, images)
        if g is None:
            continue
        if {apply_mat(g, p) for p in arc} == set(arc):
            out.append(g)
    return out


def solve(Mrows, rhs):
    n = len(Mrows)
    aug = [list(r) + [b] for r, b in zip(Mrows, rhs)]
    r = 0
    for col in range(n):
        piv = next((i for i in range(r, n) if aug[i][col] % Q), None)
        if piv is None:
            return None
        aug[r], aug[piv] = aug[piv], aug[r]
        inv = pow(aug[r][col], Q - 2, Q)
        aug[r] = [(x * inv) % Q for x in aug[r]]
        for i in range(n):
            if i != r and aug[i][col] % Q:
                f = aug[i][col]
                aug[i] = [(x - f * y) % Q for x, y in zip(aug[i], aug[r])]
        r += 1
    return [aug[i][n] for i in range(n)]


def frame_map(src, dst):
    """Unique projectivity sending the frame src (4 points, general position) to dst."""
    def scale(pts):
        cols = [list(pts[i]) for i in range(3)]
        M = [[cols[j][i] for j in range(3)] for i in range(3)]
        lam = solve(M, list(pts[3]))
        if lam is None or any(l % Q == 0 for l in lam):
            return None
        return [[(cols[j][i] * lam[j]) % Q for j in range(3)] for i in range(3)]

    A = scale(src)
    B = scale(dst)
    if A is None or B is None:
        return None
    # g = B * A^{-1}
    Ainv = inverse3(A)
    if Ainv is None:
        return None
    return [[sum(B[i][k] * Ainv[k][j] for k in range(3)) % Q for j in range(3)] for i in range(3)]


def inverse3(M):
    d = det3(*M)
    if d % Q == 0:
        return None
    di = pow(d, Q - 2, Q)
    cof = [[0] * 3 for _ in range(3)]
    for i in range(3):
        for j in range(3):
            sub = [[M[a][b] for b in range(3) if b != j] for a in range(3) if a != i]
            m = (sub[0][0] * sub[1][1] - sub[0][1] * sub[1][0]) % Q
            cof[j][i] = (m * (-1) ** (i + j) * di) % Q
    return cof


# ------------------------------------------------------------------ part 2

def part2():
    print("\n== Part 2: syndrome-weight trichotomy and the covering-radius layer ==")
    arc = [norm(c) for c in H_COLS]
    cols = H_COLS

    def weight(s):
        if all(x % Q == 0 for x in s):
            return 0
        for m in (1, 2, 3):
            for S in combinations(range(6), m):
                # does s lie in the span of these columns, with all coefficients nonzero?
                M = [[cols[j][i] for j in S] for i in range(3)]
                if in_span_full(M, s, m):
                    return m
        return None

    strata = {1: 0, 2: 0, 3: 0}
    ok = True
    for p in PG2:
        w = weight(p)
        on_arc = p in arc
        on_chord = any(det3(a, b, p) == 0 for a, b in combinations(arc, 2))
        expect = 1 if on_arc else (2 if on_chord else 3)
        if w != expect:
            ok = False
        strata[w] = strata.get(w, 0) + 1
    check("syndrome-weight trichotomy on all 133 directions", ok,
          f"weights {strata}")
    check("weight-3 directions number 12", strata[3] == 12)
    check("covering radius three", max(strata) == 3)

    # Lemma 5.1 on a sample of received words.
    codewords = [c for c in product(range(Q), repeat=6)
                 if all(sum(cols[j][i] * c[j] for j in range(6)) % Q == 0 for i in range(3))] \
        if False else None  # 11^3 = 1331 codewords; build them directly instead
    codewords = build_code(cols)
    check("code has 1331 codewords", len(codewords) == 1331)
    sample = [(1, 0, 0, 0, 0, 0), (7, 4, 1, 0, 0, 0), (3, 1, 4, 1, 5, 9), (0, 0, 0, 0, 0, 0)]
    ok = True
    for v in sample:
        s = tuple(sum(cols[j][i] * v[j] for j in range(6)) % Q for i in range(3))
        dist = min(sum(1 for a, b in zip(v, c) if (a - b) % Q) for c in codewords)
        if dist != (0 if all(x == 0 for x in s) else weight(s)):
            ok = False
    check("d(v, C) = w(sigma(v)) on the sample (Lemma 5.1)", ok)


def in_span_full(M, s, m):
    """Is s a combination of the m columns of M with every coefficient nonzero?"""
    for coeffs in product(range(1, Q), repeat=m):
        if all(sum(M[i][j] * coeffs[j] for j in range(m)) % Q == s[i] % Q for i in range(3)):
            return True
    return False


def build_code(cols):
    # kernel of the 3x6 matrix: solve for the first three coordinates from the last three.
    out = []
    for tail in product(range(Q), repeat=3):
        rhs = [(-sum(cols[3 + j][i] * tail[j] for j in range(3))) % Q for i in range(3)]
        M = [[cols[j][i] for j in range(3)] for i in range(3)]
        head = solve(M, rhs)
        out.append(tuple(head) + tail)
    return out


# ------------------------------------------------------------------ part 3

def part3():
    print("\n== Part 3: uniqueness of the one-factorization of K6 ==")
    verts = list(range(6))
    edges = [frozenset(e) for e in combinations(verts, 2)]
    matchings = []
    for trio in combinations(edges, 3):
        if len(set().union(*trio)) == 6:
            matchings.append(frozenset(trio))
    matchings = sorted(set(matchings), key=lambda m: sorted(sorted(e) for e in m))
    check("K6 has 15 perfect matchings", len(matchings) == 15)

    factorizations = set()
    for five in combinations(matchings, 5):
        if len(set().union(*five)) == 15:
            factorizations.add(frozenset(five))
    check("K6 has exactly 6 one-factorizations", len(factorizations) == 6)

    def relabel(m, sigma):
        return frozenset(frozenset(sigma[v] for v in e) for e in m)

    F0 = next(iter(factorizations))
    orbit, stab = set(), 0
    for sigma in permutations(verts):
        img = frozenset(relabel(m, sigma) for m in F0)
        orbit.add(img)
        if img == F0:
            stab += 1
    check("S6 is transitive on one-factorizations", orbit == factorizations)
    check("stabilizer of a one-factorization has order 120", stab == 120, f"got {stab}")

    F1 = frozenset({frozenset({0, 1}), frozenset({2, 3}), frozenset({4, 5})})
    containing = [f for f in factorizations if F1 in f]
    check("exactly two one-factorizations contain 01|23|45", len(containing) == 2)

    # parity-class parametrization  F'(i,j,k) = { a_i b_j, a_{i+1} c_k, b_{j+1} c_{k+1} }
    a, b, c = (0, 1), (2, 3), (4, 5)

    def Fp(i, j, k):
        return frozenset({frozenset({a[i], b[j]}),
                          frozenset({a[(i + 1) % 2], c[k]}),
                          frozenset({b[(j + 1) % 2], c[(k + 1) % 2]})})

    eight = {Fp(i, j, k) for i, j, k in product(range(2), repeat=3)}
    disjoint = {m for m in matchings if not (m & F1)}
    check("the eight matchings disjoint from 01|23|45 are the parametrized ones",
          eight == disjoint and len(eight) == 8)

    even = frozenset({Fp(*t) for t in product(range(2), repeat=3) if sum(t) % 2 == 0} | {F1})
    odd = frozenset({Fp(*t) for t in product(range(2), repeat=3) if sum(t) % 2 == 1} | {F1})
    check("the two parity classes are the two one-factorizations through 01|23|45",
          {even, odd} == set(containing))

    swap = {0: 1, 1: 0, 2: 2, 3: 3, 4: 4, 5: 5}
    check("the transposition (0 1) exchanges them",
          frozenset(relabel(m, swap) for m in even) == odd)

    displayed = frozenset({
        frozenset({0, 1}), frozenset({2, 3}), frozenset({4, 5})}), frozenset({
        frozenset({0, 2}), frozenset({1, 4}), frozenset({3, 5})}), frozenset({
        frozenset({0, 3}), frozenset({1, 5}), frozenset({2, 4})}), frozenset({
        frozenset({0, 4}), frozenset({1, 3}), frozenset({2, 5})}), frozenset({
        frozenset({0, 5}), frozenset({1, 2}), frozenset({3, 4})})
    check("the even class is the manuscript's displayed list",
          even == frozenset(displayed))


# ------------------------------------------------------------------ part 4

def part4():
    print("\n== Part 4: the GRS parity-check columns lie on Y^2 = XZ ==")
    import random
    random.seed(20260803)
    ok_lagrange, ok_conic, ok_dual = True, True, True
    for _ in range(20):
        a = random.sample(range(Q), 6)
        v = [random.randrange(1, Q) for _ in range(6)]
        w = []
        for j in range(6):
            prod = 1
            for i in range(6):
                if i != j:
                    prod = prod * ((a[j] - a[i]) % Q) % Q
            w.append(pow(prod, Q - 2, Q))
        for t in range(5):
            if sum(w[j] * pow(a[j], t, Q) for j in range(6)) % Q != 0:
                ok_lagrange = False
        if sum(w[j] * pow(a[j], 5, Q) for j in range(6)) % Q != 1:
            ok_lagrange = False
        G = [[v[j] * pow(a[j], m, Q) % Q for j in range(6)] for m in range(3)]
        u = [w[j] * pow(v[j], Q - 2, Q) % Q for j in range(6)]
        Hm = [[u[j] * pow(a[j], m, Q) % Q for j in range(6)] for m in range(3)]
        for m in range(3):
            for l in range(3):
                if sum(Hm[m][j] * G[l][j] for j in range(6)) % Q != 0:
                    ok_dual = False
        for j in range(6):
            col = (Hm[0][j], Hm[1][j], Hm[2][j])
            if (col[1] * col[1] - col[0] * col[2]) % Q != 0:
                ok_conic = False
    check("Lagrange vanishing identity (Lemma 6.1)", ok_lagrange)
    check("H G^T = 0 for the constructed H (Proposition 6.2)", ok_dual)
    check("GRS parity-check columns satisfy Y^2 = XZ", ok_conic)

    dim = conic_space_dim([norm(c) for c in H_COLS])
    check("the displayed six columns lie on no conic (Theorem 6.3)", dim == 0,
          f"space of vanishing quadratic forms has dimension {dim}")


if __name__ == "__main__":
    part1()
    part2()
    part3()
    part4()
    print()
    if FAILS:
        print(f"FAILED: {len(FAILS)} check(s): {FAILS}")
        raise SystemExit(1)
    print("all checks passed")
