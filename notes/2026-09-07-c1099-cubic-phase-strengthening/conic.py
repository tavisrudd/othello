"""Shared exact machinery for the conic-matching reconstruction recipe (memo section 1.1)
and the trade-to-code dictionary, in pure Python integers mod p.

Conic Q = XZ - Y^2, points a -> (1:a:a^2), infinity -> (0:0:1).
Secant forms L_ab = ab X - (a+b) Y + Z, L_{a inf} = a X - Y.
For a perfect matching M of P^1(F_p) (encoded as a partner list, index p = infinity),
P_M = prod of its secant forms, x_M = (P_M - P_{M_0}) / Q, a form of degree (p-3)/2.
"""
import itertools
import random


# ---------------------------------------------------------------- forms
def form_mul_linear(f, l, p):
    """f: dict {(a,b,c): coeff}; l = (l0,l1,l2) for l0 X + l1 Y + l2 Z."""
    g = {}
    for (a, b, c), v in f.items():
        for (da, db, dc), lv in (((1, 0, 0), l[0]), ((0, 1, 0), l[1]), ((0, 0, 1), l[2])):
            if lv % p == 0:
                continue
            key = (a + da, b + db, c + dc)
            g[key] = (g.get(key, 0) + v * lv) % p
    return {k: v for k, v in g.items() if v}


def secant(a, b, p):
    if a == p:
        a, b = b, a
    if b == p:
        return (a % p, (-1) % p, 0)
    return ((a * b) % p, (-(a + b)) % p, 1)


def product_form(m, p):
    f = {(0, 0, 0): 1}
    for x in range(len(m)):
        y = m[x]
        if x < y:
            f = form_mul_linear(f, secant(x, y, p), p)
    return f


def div_q(g, p):
    """Exact division of a form by Q = XZ - Y^2 (asserts zero remainder)."""
    g = dict(g)
    h = {}
    while True:
        cand = [k for k, v in g.items() if v and k[1] >= 2]
        if not cand:
            break
        a, b, c = max(cand, key=lambda k: k[1])
        v = g[(a, b, c)]
        t = (-v) % p  # term of H: t X^a Y^(b-2) Z^c ;  G -= t (XZ - Y^2)
        h[(a, b - 2, c)] = (h.get((a, b - 2, c), 0) + t) % p
        g[(a, b, c)] = 0
        k2 = (a + 1, b - 2, c + 1)
        g[k2] = (g.get(k2, 0) - t) % p
    assert all(v % p == 0 for v in g.values()), "nonzero remainder"
    return {k: v for k, v in h.items() if v}


def monomials(d):
    return [(a, b, d - a - b) for a in range(d + 1) for b in range(d + 1 - a)]


def point_x(m, base, p):
    d = (p - 3) // 2
    pm = product_form(m, p)
    diff = dict(pm)
    for k, v in base.items():
        diff[k] = (diff.get(k, 0) - v) % p
    h = div_q(diff, p)
    return [h.get(mon, 0) % p for mon in monomials(d)]


def first_matching(p):
    n = p + 1
    return [x ^ 1 for x in range(n)]  # pairs (0,1),(2,3),...


def translate(m, p):
    n = p + 1
    t = [0] * n
    sh = lambda x: p if x == p else (x + 1) % p
    for x in range(n):
        t[sh(x)] = sh(m[x])
    return t


def mobius(e, x, p):
    a, b, c, d = e
    if x == p:
        return p if c % p == 0 else (a * pow(c, p - 2, p)) % p
    num, den = (a * x + b) % p, (c * x + d) % p
    return p if den == 0 else (num * pow(den, p - 2, p)) % p


def act(e, m, p):
    n = p + 1
    t = [0] * n
    for x in range(n):
        t[mobius(e, x, p)] = mobius(e, m[x], p)
    return t


def pgl2(p):
    els = []
    for a, b, c, d in itertools.product(range(p), repeat=4):
        if (a * d - b * c) % p == 0:
            continue
        first = next(v for v in (a, b, c, d) if v)
        if first != 1:
            continue
        els.append((a, b, c, d))
    return els


def is_square(x, p):
    return any(y * y % p == x % p for y in range(1, p))


def translation_class(m, p):
    out = [m]
    t = m
    for _ in range(p - 1):
        t = translate(t, p)
        out.append(t)
    return out


# ---------------------------------------------------------------- linear algebra mod p
def rref(rows, p):
    m = [r[:] for r in rows]
    nr = len(m)
    nc = len(m[0]) if nr else 0
    r = 0
    piv = []
    for c in range(nc):
        pv = next((i for i in range(r, nr) if m[i][c] % p), None)
        if pv is None:
            continue
        m[r], m[pv] = m[pv], m[r]
        iv = pow(m[r][c], p - 2, p)
        m[r] = [x * iv % p for x in m[r]]
        for i in range(nr):
            if i != r and m[i][c] % p:
                f = m[i][c]
                m[i] = [(m[i][j] - f * m[r][j]) % p for j in range(nc)]
        piv.append(c)
        r += 1
        if r == nr:
            break
    return m[:r], piv


def rank(rows, p):
    return len(rref(rows, p)[0])


def span_products(basis, p, deg):
    """Basis of L^{o deg}: all coordinatewise products of deg basis vectors, row-reduced."""
    n = len(basis[0])
    rows = []
    for combo in itertools.combinations_with_replacement(range(len(basis)), deg):
        v = [1] * n
        for i in combo:
            v = [(x * y) % p for x, y in zip(v, basis[i])]
        rows.append(v)
    return rref(rows, p)[0]


def dot(u, v, p):
    return sum(x * y for x, y in zip(u, v)) % p


def code_data(points, sheet_sign, p):
    """points: list of coordinate vectors (the 2p configuration), sheet_sign: +-1 per point.
    Returns a dict of the trade-to-code invariants."""
    n = len(points)
    k_amb = len(points[0])
    ones = [1] * n
    cols = [[pt[j] for pt in points] for j in range(k_amb)]
    L_rows = rref([ones] + cols, p)[0]
    dimL = len(L_rows)
    eps = [s % p for s in sheet_sign]
    # signed isotropy: eps . (v o w) = 0 for all v,w in L
    L2 = span_products(L_rows, p, 2)
    L3 = span_products(L_rows, p, 3)
    iso = all(dot(eps, v, p) == 0 for v in L2)
    cubic_nonzero = any(dot(eps, v, p) != 0 for v in L3)
    distinct = len(set(map(tuple, points))) == n
    ann2 = rank(L2 + [eps], p) == len(L2)  # eps in span(L2)? we want eps ⊥ L2, computed by iso
    return dict(n=n, dimL=dimL, isotropic=iso, cubic_nonzero=cubic_nonzero, dimL2=len(L2),
                dimL3=len(L3), distinct=distinct, L=L_rows, eps=eps)


def min_weight_affine(L_rows, p, exact_limit=2_000_000, samples=200_000):
    """min wt(L \\ <1>).  Exact when p^dim is small; otherwise a sampled upper bound."""
    dim = len(L_rows)
    n = len(L_rows[0])
    ones = [1] * n
    # find the index of 1 in the basis: express 1 in terms of rows (L contains 1 by construction)
    best = n
    if p ** dim <= exact_limit:
        exact = True
        it = itertools.product(range(p), repeat=dim)
    else:
        exact = False
        it = (tuple(random.randrange(p) for _ in range(dim)) for _ in range(samples))
    for coef in it:
        if not any(coef):
            continue
        v = [0] * n
        for c, row in zip(coef, L_rows):
            if c:
                v = [(x + c * y) % p for x, y in zip(v, row)]
        # skip multiples of 1
        if all(x == v[0] for x in v):
            continue
        w = sum(1 for x in v if x)
        if w < best:
            best = w
    return best, exact


def logical_cubic_tensor(points, sheet_sign, p, basis_cols=None):
    """Hessian tensor A[m][j][l] = sum_i eps_i x_i[m] x_i[j] x_i[l] in the ambient coordinates
    restricted to a chosen coordinate basis of the direction space (list of column indices)."""
    k = len(points[0]) if basis_cols is None else len(basis_cols)
    A = [[[0] * k for _ in range(k)] for _ in range(k)]
    for pt, s in zip(points, sheet_sign):
        x = pt if basis_cols is None else [pt[c] for c in basis_cols]
        for m in range(k):
            if x[m] % p == 0:
                continue
            for j in range(k):
                if x[j] % p == 0:
                    continue
                for l in range(k):
                    A[m][j][l] = (A[m][j][l] + s * x[m] * x[j] * x[l]) % p
    return A


def reduce_to_direction_basis(points, p):
    """Choose affine coordinates: translate so point 0 is the origin, then pick a basis of the
    direction space and express every point in it (coordinates u in F_p^k, k = affine dim)."""
    o = points[0]
    diffs = [[(x - y) % p for x, y in zip(pt, o)] for pt in points]
    B, piv = rref(diffs, p)
    k = len(B)
    # coordinates: since B is in RREF with pivots piv, the coordinates of a vector v in span(B)
    # are v[piv[j]].
    coords = [[d[c] for c in piv] for d in diffs]
    # sanity: v == sum coords_j B_j
    for d, cf in zip(diffs, coords):
        rec = [0] * len(d)
        for c, row in zip(cf, B):
            rec = [(x + c * y) % p for x, y in zip(rec, row)]
        assert rec == d
    return coords, k


def hessian_rank_census_sampled(A, p, k, samples, seed=1):
    rng = random.Random(seed)
    counts = {}
    for _ in range(samples):
        v = [rng.randrange(p) for _ in range(k)]
        if not any(v):
            continue
        H = [[sum(v[m] * A[m][j][l] for m in range(k)) % p for l in range(k)] for j in range(k)]
        r = rank(H, p)
        counts[r] = counts.get(r, 0) + 1
    return counts


def write_tensor(path, p, k, A):
    with open(path, "w") as fh:
        fh.write(f"{p} {k}\n")
        for m in range(k):
            for j in range(k):
                fh.write(" ".join(str(A[m][j][l] % p) for l in range(k)) + "\n")
