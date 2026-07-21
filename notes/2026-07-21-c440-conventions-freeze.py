#!/usr/bin/env python3
"""C440 / Weil-roof battery task M0 — shared conventions freeze.

Deliverable: the frozen dictionary every M-/T-task of the Weil-roof battery consumes.

Freezes, and *verifies by direct computation* (no recalled formula is trusted; guardrail 1 of
`2026-07-21-clebsch-weil-roof-program.md`):

  (i)   the standard conic `Q = XZ - Y^2` (C406 Gate-1) and the `P^1 -> conic` projectivity
        `[s:t] |-> [s^2 : s t : t^2]` (the discriminant Veronese);
  (ii)  the integral vertex binary forms of the three rank-3 Coxeter polytopes, each verified to
        be invariant (up to scalar) under an explicit polytope symmetry group and to have its
        vertex set as its root set:
            H3 icosahedron (12): f = x y (x^10 + 11 x^5 y^5 - y^10)   over Z, group A5, |A5|=60;
            B3 cube        (8) : W = x y (4 x^6 + 7 sqrt2 x^3 y^3 - 4 y^6) over Z[sqrt2], |O|=24;
            A3 octahedron  (6) : t = x y (x^4 - y^4)                  over Z, group O, |O|=24;
  (iii) the frozen labeling of the char-0 vertex roots onto the conic points `P^1(F_q)` at each
        Coxeter prime q = h+1 (11, 7, 5), with the golden/spin square-root convention frozen and
        the golden-conjugate sheet swap made explicit.

Compatibility with C377's integral golden map J(x,y,z)=(x,-z,-y): the icosahedral A5 has trace
field Q(sqrt5)=Q(phi); golden conjugation sigma (sqrt5 -> -sqrt5, phi -> 1-phi) is C377's J at the
level of Galois theory; its mod-11 reduction with zeta5 -> 3 gives phi -> 8 == C377/C379 tau=8
(sqrt5 -> 4), and the conjugate reduction gives tau=4 (sqrt5 -> 7); sigma exchanges the two
pentagons == the two sheets.

Run:
    python3 notes/2026-07-21-c440-conventions-freeze.py            # regenerate JSON + sha256
    python3 notes/2026-07-21-c440-conventions-freeze.py --check    # verify tracked artifacts, no write

Working directory: repository root. No inputs beyond this file. Deterministic; no timestamps.
The trusted boundary is exact rational arithmetic in Q(zeta5), Q(i), Q(sqrt2, omega), and prime
fields F_q; the icosahedral/octahedral groups are built as the full sets of projectivities
permuting the vertex root sets, so form-invariance is exhibited element-by-element, not assumed.
"""
from __future__ import annotations
from fractions import Fraction as F
from itertools import permutations
from pathlib import Path
import hashlib
import json
import sys
import tempfile

HERE = Path(__file__).resolve().parent
STEM = "2026-07-21-c440-conventions-freeze"
JSON_PATH = HERE / f"{STEM}.json"
SHA_PATH = HERE / f"{STEM}.sha256"
SCHEMA = "c440-conventions-freeze-v1"


# --------------------------------------------------------------------------------------------------
# Exact number fields as Q-algebras with an explicit multiplication table on a rational basis.
# --------------------------------------------------------------------------------------------------
def make_field(dim, mult_table, name):
    class E:
        __slots__ = ("c",)
        DIM = dim
        NAME = name

        def __init__(self, c):
            self.c = tuple(F(x) for x in c)

        def __add__(self, o):
            return E(tuple(a + b for a, b in zip(self.c, o.c)))

        def __neg__(self):
            return E(tuple(-a for a in self.c))

        def __sub__(self, o):
            return self + (-o)

        def __mul__(self, o):
            r = [F(0)] * dim
            for i, a in enumerate(self.c):
                if a == 0:
                    continue
                for j, b in enumerate(o.c):
                    if b == 0:
                        continue
                    for k, coef in mult_table[i][j].items():
                        r[k] += a * b * coef
            return E(tuple(r))

        def __eq__(self, o):
            return isinstance(o, E) and self.c == o.c

        def __hash__(self):
            return hash(self.c)

        def iszero(self):
            return all(x == 0 for x in self.c)

    return E


def _table(dim, rule):
    return [[rule(i, j) for j in range(dim)] for i in range(dim)]


# Q(zeta5): basis {1, z, z^2, z^3}, z primitive 5th root, z^5 = 1, z^4 = -1-z-z^2-z^3.
def _zeta5_rule(i, j):
    s = i + j
    if s <= 3:
        return {s: F(1)}
    if s == 4:  # z^4 = -1 - z - z^2 - z^3
        return {0: F(-1), 1: F(-1), 2: F(-1), 3: F(-1)}
    if s == 5:  # z^5 = 1
        return {0: F(1)}
    if s == 6:  # z^6 = z
        return {1: F(1)}
    raise AssertionError(s)


Z5 = make_field(4, _table(4, _zeta5_rule), "Q(zeta5)")

# Q(i): basis {1, i}, i^2 = -1.
Qi = make_field(
    2,
    _table(2, lambda i, j: {0: F(1)} if (i, j) == (0, 0)
           else {1: F(1)} if (i, j) in [(0, 1), (1, 0)]
           else {0: F(-1)}),
    "Q(i)",
)

# Q(sqrt2, omega): basis {1, sqrt2, omega, sqrt2*omega}; sqrt2^2 = 2, omega^2 = -omega-1.
def _c_rule(i, j):
    exps = [(0, 0), (1, 0), (0, 1), (1, 1)]  # (power of sqrt2, power of omega)
    a1, b1 = exps[i]
    a2, b2 = exps[j]
    sa, sb = a1 + a2, b1 + b2
    coef = F(1)
    if sa >= 2:  # sqrt2^2 = 2
        coef *= 2
        sa -= 2
    res = {}

    def add(scoef, wp, s2p):
        if wp == 2:  # omega^2 = -1 - omega
            add(-scoef, 0, s2p)
            add(-scoef, 1, s2p)
            return
        idx = (1 if s2p == 1 else 0) + (2 if wp == 1 else 0)
        res[idx] = res.get(idx, F(0)) + scoef

    add(coef, sb, sa)
    return res


Qc = make_field(4, _table(4, _c_rule), "Q(sqrt2,omega)")


# --------------------------------------------------------------------------------------------------
# Generic P^1 / projective machinery over an arbitrary field E.
# --------------------------------------------------------------------------------------------------
def ops(E):
    ONE = E(tuple(1 if k == 0 else 0 for k in range(E.DIM)))
    ZERO = E(tuple(0 for _ in range(E.DIM)))

    def div(a, b):
        dim = E.DIM
        cols = [(b * E(tuple(1 if k == e else 0 for k in range(dim)))).c for e in range(dim)]
        M = [[cols[e][r] for e in range(dim)] + [a.c[r]] for r in range(dim)]
        for col in range(dim):
            piv = next(r for r in range(col, dim) if M[r][col] != 0)
            M[col], M[piv] = M[piv], M[col]
            inv = F(1) / M[col][col]
            M[col] = [v * inv for v in M[col]]
            for r in range(dim):
                if r != col and M[r][col] != 0:
                    f0 = M[r][col]
                    M[r] = [M[r][k] - f0 * M[col][k] for k in range(dim + 1)]
        return E(tuple(M[r][dim] for r in range(dim)))

    def norm_pt(pt):
        x, y = pt
        return (div(x, y), ONE) if not y.iszero() else (ONE, ZERO)

    def act(Mx, pt):
        a, b, c, d = Mx
        x, y = pt
        return (a * x + b * y, c * x + d * y)

    def mmul(P, Q):
        a1, b1, c1, d1 = P
        a2, b2, c2, d2 = Q
        return (a1 * a2 + b1 * c2, a1 * b2 + b1 * d2, c1 * a2 + d1 * c2, c1 * b2 + d1 * d2)

    def norm_mat(Mx):
        piv = next(x for x in Mx if not x.iszero())
        inv = div(ONE, piv)
        return tuple(x * inv for x in Mx)

    def frame_map(src, tgt):
        # projectivity carrying src[0..2] -> tgt[0..2] (three points fix a PGL2 element);
        # solve the 1-dim nullspace of the three cross-product incidence equations.
        rows = []
        for k in range(3):
            sx, sy = src[k]
            tx, ty = tgt[k]
            rows.append([(-ty) * sx, (-ty) * sy, tx * sx, tx * sy])
        m, n = len(rows), 4
        M = [row[:] for row in rows]
        piv_cols = []
        r = 0
        for col in range(n):
            piv = next((rr for rr in range(r, m) if not M[rr][col].iszero()), None)
            if piv is None:
                continue
            M[r], M[piv] = M[piv], M[r]
            inv = div(ONE, M[r][col])
            M[r] = [x * inv for x in M[r]]
            for rr in range(m):
                if rr != r and not M[rr][col].iszero():
                    f0 = M[rr][col]
                    M[rr] = [M[rr][k] - f0 * M[r][k] for k in range(n)]
            piv_cols.append(col)
            r += 1
        free = [c for c in range(n) if c not in piv_cols]
        if not free:
            return None
        fc = free[0]
        vec = [ZERO] * n
        vec[fc] = ONE
        for i, col in enumerate(piv_cols):
            vec[col] = -M[i][fc]
        return tuple(vec)

    def vertex_group(pts):
        npts = [norm_pt(p) for p in pts]
        n = len(npts)
        idx = {p: i for i, p in enumerate(npts)}
        grp = set()
        base = npts[:3]
        for tgt in permutations(range(n), 3):
            Mx = frame_map(base, [npts[tgt[k]] for k in range(3)])
            if Mx is None:
                continue
            images = []
            ok = True
            for p in npts:
                q = norm_pt(act(Mx, p))
                if q not in idx:
                    ok = False
                    break
                images.append(idx[q])
            if ok and len(set(images)) == n:
                grp.add(norm_mat(Mx))
        return grp

    def form_val(coeffs, deg, pt):
        x, y = pt
        tot = ZERO
        for i, c in coeffs.items():
            term = c
            for _ in range(i):
                term = term * x
            for _ in range(deg - i):
                term = term * y
            tot = tot + term
        return tot

    def subst_form(coeffs, Mx, deg):
        a, b, c, d = Mx

        def powf(base, k):
            r = {0: ONE}
            for _ in range(k):
                nr = {}
                for i, ci in r.items():
                    for j, cj in base.items():
                        nr[i + j] = nr.get(i + j, ZERO) + ci * cj
                r = nr
            return r

        Xf, Yf, res = {1: a, 0: b}, {1: c, 0: d}, {}
        for i, cf in coeffs.items():
            px, py = powf(Xf, i), powf(Yf, deg - i)
            for u, cu in px.items():
                for v, cv in py.items():
                    res[u + v] = res.get(u + v, ZERO) + cf * cu * cv
        return {k: v for k, v in res.items() if not v.iszero()}

    def prop_forms(p, q):
        if sorted(p) != sorted(q):
            return False
        k = sorted(p)[0]
        s = div(p[k], q[k])
        return all(p[i] == s * q[i] for i in p)

    def mat_order(Mx):
        cur = norm_mat(Mx)
        for k in range(1, 25):
            a, b, c, d = cur
            if b.iszero() and c.iszero() and a == d:
                return k
            cur = norm_mat(mmul(cur, norm_mat(Mx)))
        return None

    return dict(ONE=ONE, ZERO=ZERO, div=div, norm_pt=norm_pt, act=act, mmul=mmul,
                norm_mat=norm_mat, frame_map=frame_map, vertex_group=vertex_group,
                form_val=form_val, subst_form=subst_form, prop_forms=prop_forms,
                mat_order=mat_order)


# --------------------------------------------------------------------------------------------------
# H3 — icosahedron over Q(zeta5): Klein's f, the golden A5, roots, antipode, trace field.
# --------------------------------------------------------------------------------------------------
def build_h3():
    o = ops(Z5)
    ONE, ZERO = o["ONE"], o["ZERO"]
    zeta = Z5((0, 1, 0, 0))
    zeta4 = Z5((-1, -1, -1, -1))       # z^4 = z^-1
    assert (zeta * zeta4) == ONE
    phi = ONE + zeta + zeta4           # phi = 1 + z + z^4 = -z^2 - z^3
    assert (phi * phi - phi - ONE).iszero()
    s5 = phi + phi - ONE               # sqrt5 = 2 phi - 1
    assert (s5 * s5) == Z5((5, 0, 0, 0))

    # Klein's vertex form  f = x y (x^10 + 11 x^5 y^5 - y^10) = x^11 y + 11 x^6 y^6 - x y^11.
    f = {11: ONE, 6: Z5((11, 0, 0, 0)), 1: -ONE}
    deg = 12

    # Golden icosahedral generators (Klein): S = diag(z, z^4) order 5; T order 2.
    inv_s5 = o["div"](ONE, s5)
    zmz4 = zeta - zeta4                              # zeta - zeta^4
    z2mz3 = (zeta * zeta) - (zeta * zeta * zeta)     # zeta^2 - zeta^3
    S = (zeta, ZERO, ZERO, zeta4)
    T = (inv_s5 * (-zmz4), inv_s5 * z2mz3, inv_s5 * z2mz3, inv_s5 * zmz4)
    assert o["mat_order"](S) == 5
    assert o["mat_order"](T) == 2

    # Full group <S,T> in PGL2.
    grp = {o["norm_mat"]((ONE, ZERO, ZERO, ONE))}
    frontier = list(grp)
    gens = [o["norm_mat"](S), o["norm_mat"](T)]
    while frontier:
        P = frontier.pop()
        for g in gens:
            R = o["norm_mat"](o["mmul"](P, g))
            if R not in grp:
                grp.add(R)
                frontier.append(R)
        assert len(grp) <= 60
    assert len(grp) == 60  # A5

    # f invariant (up to scalar) under every group element.
    assert all(o["prop_forms"](o["subst_form"](f, g, deg), f) for g in grp)

    # 12 roots of f = the single A5-orbit of [0:1]; antipode z -> -1/z pairs them into 6.
    def fval(pt):
        return o["form_val"](f, deg, pt)

    r0 = o["norm_pt"]((ZERO, ONE))
    orbit = {r0}
    frontier = [r0]
    while frontier:
        p = frontier.pop()
        for g in grp:
            q = o["norm_pt"](o["act"](g, p))
            if q not in orbit:
                orbit.add(q)
                frontier.append(q)
    assert len(orbit) == 12
    assert all(fval(p).iszero() for p in orbit)
    A = (ZERO, -ONE, ONE, ZERO)  # antipodal involution z -> -1/z
    antipode_pairs = {frozenset([p, o["norm_pt"](o["act"](A, p))]) for p in orbit}
    assert len(antipode_pairs) == 6 and all(len(x) == 2 for x in antipode_pairs)
    assert o["prop_forms"](o["subst_form"](f, A, deg), f)  # antipode fixes f

    # Trace field: every projective trace invariant tr^2/det lies in Q(sqrt5)=Q(phi).
    def sigma2_fixed(x):  # x fixed by z -> z^4 (the order-2 subgroup fixing sqrt5)
        c0, c1, c2, c3 = x.c
        mapped = (Z5((c0, 0, 0, 0)) + Z5((c1, 0, 0, 0)) * zeta4
                  + Z5((c2, 0, 0, 0)) * (zeta * zeta * zeta)
                  + Z5((c3, 0, 0, 0)) * (zeta * zeta))
        return mapped == x

    trace_field_is_exactly_sqrt5 = False
    for M in grp:
        a, b, c, d = M
        tr2 = (a + d) * (a + d)
        det = a * d - b * c
        val = o["div"](tr2, det)
        assert sigma2_fixed(val)               # every tr^2/det lies in Q(sqrt5)
        if not (val.c[1] == 0 and val.c[2] == 0 and val.c[3] == 0):
            trace_field_is_exactly_sqrt5 = True  # some tr^2/det is NOT rational -> field is exactly Q(sqrt5)
    assert trace_field_is_exactly_sqrt5        # witness: S has tr^2/det = 2 - phi (not in Q)

    # Free hardening: the golden A5 itself (not merely phi/sqrt5) reduces mod 11 with zeta5 -> 3
    # (phi -> 8, sqrt5 -> 4) to a subgroup of PGL_2(F_11) of order exactly 60 -- good reduction.
    def reduce_z5(x, prime, z5val):
        def num(fr):
            return (fr.numerator % prime) * pow(fr.denominator % prime, prime - 2, prime) % prime
        c0, c1, c2, c3 = x.c
        return (num(c0) + num(c1) * z5val + num(c2) * pow(z5val, 2, prime)
                + num(c3) * pow(z5val, 3, prime)) % prime

    prime, z5val = 11, 3
    Sr = tuple(reduce_z5(v, prime, z5val) for v in S)
    Tr = tuple(reduce_z5(v, prime, z5val) for v in T)

    def pnorm(M):
        piv = next(x for x in M if x % prime)
        inv = pow(piv, prime - 2, prime)
        return tuple((x * inv) % prime for x in M)

    def pmul(A, B):
        return ((A[0] * B[0] + A[1] * B[2]) % prime, (A[0] * B[1] + A[1] * B[3]) % prime,
                (A[2] * B[0] + A[3] * B[2]) % prime, (A[2] * B[1] + A[3] * B[3]) % prime)

    ident = pnorm((1, 0, 0, 1))
    rgrp = {ident}
    frontier = [ident]
    rgens = [pnorm(Sr), pnorm(Tr)]
    while frontier:
        P = frontier.pop()
        for g in rgens:
            R = pnorm(pmul(P, g))
            if R not in rgrp:
                rgrp.add(R)
                frontier.append(R)
    assert len(rgrp) == 60

    return dict(phi=phi, s5=s5, zeta=zeta, form=f, group_order=len(grp),
                orbit_size=12, antipode_pairs=6,
                trace_field_exactly_sqrt5=trace_field_is_exactly_sqrt5,
                reduced_group_order_mod11=len(rgrp))


# --------------------------------------------------------------------------------------------------
# B3 cube (Q(sqrt2,omega)) and A3 octahedron (Q(i)).
# --------------------------------------------------------------------------------------------------
def build_octahedron():
    o = ops(Qi)
    ONE, ZERO = o["ONE"], o["ZERO"]
    I = Qi((0, 1))
    pts = [(ZERO, ONE), (ONE, ZERO), (ONE, ONE), (-ONE, ONE), (I, ONE), (-I, ONE)]
    grp = o["vertex_group"](pts)
    assert len(grp) == 24  # octahedral rotation group O ~ S4
    form = {5: ONE, 1: -ONE}  # t = x y (x^4 - y^4) = x^5 y - x y^5
    deg = 6
    assert all(o["form_val"](form, deg, p).iszero() for p in pts)
    assert all(o["prop_forms"](o["subst_form"](form, g, deg), form) for g in grp)
    return dict(group_order=24, vertices=6)


def build_cube():
    o = ops(Qc)
    ONE, ZERO = o["ONE"], o["ZERO"]
    S2 = Qc((0, 1, 0, 0))
    OMEGA = Qc((0, 0, 1, 0))
    inv_s2 = Qc((0, F(1, 2), 0, 0))  # 1/sqrt2

    def wpow(k):
        r = ONE
        for _ in range(k % 3):
            r = r * OMEGA
        return r

    pts = [(ZERO, ONE), (ONE, ZERO)]
    for k in range(3):
        pts.append((inv_s2 * wpow(k), ONE))     # upper triangle, radius 1/sqrt2
    for k in range(3):
        pts.append(((-S2) * wpow(k), ONE))      # lower triangle, radius sqrt2
    grp = o["vertex_group"](pts)
    assert len(grp) == 24  # octahedral rotation group O ~ S4
    # W = x y (4 x^6 + 7 sqrt2 x^3 y^3 - 4 y^6) = 4 x^7 y + 7 sqrt2 x^4 y^4 - 4 x y^7.
    form = {7: Qc((4, 0, 0, 0)), 4: Qc((0, 7, 0, 0)), 1: Qc((-4, 0, 0, 0))}
    deg = 8
    assert all(o["form_val"](form, deg, p).iszero() for p in pts)
    assert all(o["prop_forms"](o["subst_form"](form, g, deg), form) for g in grp)
    return dict(group_order=24, vertices=8)


# --------------------------------------------------------------------------------------------------
# Reductions to P^1(F_q) and the frozen per-prime labeling.
# --------------------------------------------------------------------------------------------------
def roots_mod(coeffs_int, deg, p):
    pts = set()
    for x in range(p):
        val = sum(c * pow(x, i, p) for i, c in coeffs_int.items()) % p
        if val == 0:
            pts.add(x)
    if coeffs_int.get(deg, 0) % p == 0:
        pts.add("inf")
    return pts


def fifth_power_class(target, p):
    return sorted(x for x in range(1, p) if pow(x, 5, p) == target % p)


def build_reductions():
    # icosa f mod 11 -> x^11 y - x y^11 ; cube W mod 7 (sqrt2->3) -> 4(x^7 y - x y^7);
    # octa t mod 5 -> x^5 y - x y^5.
    ico = roots_mod({11: 1, 6: 11, 1: -1}, 12, 11)
    cube = roots_mod({7: 4, 4: 7 * 3, 1: -4}, 8, 7)   # sqrt2 == 3 mod 7 (3^2 = 2)
    octa = roots_mod({5: 1, 1: -1}, 6, 5)
    assert ico == set(range(11)) | {"inf"}
    assert cube == set(range(7)) | {"inf"}
    assert octa == set(range(5)) | {"inf"}

    # H3 golden labeling at q=11.  alpha,beta = (-11 +- 5 sqrt5)/2 are the fifth powers of the two
    # pentagon radii (alpha*beta = -1, alpha+beta = -11).  With the frozen sqrt5 = 4 (tau=8):
    inv2 = pow(2, -1, 11)
    def alpha_beta(sqrt5):
        a = ((-11 + 5 * sqrt5) * inv2) % 11
        b = ((-11 - 5 * sqrt5) * inv2) % 11
        return a, b
    a8, b8 = alpha_beta(4)   # sheet tau=8 (sqrt5 -> 4, phi -> 8)
    a4, b4 = alpha_beta(7)   # sheet tau=4 (sqrt5 -> 7, phi -> 4) = golden conjugate
    assert (a8, b8) == (10, 1)
    assert (a4, b4) == (1, 10)          # sigma swaps the two pentagons == the sheet swap
    pent_a8 = fifth_power_class(a8, 11)  # {x : x^5 = alpha} at tau=8
    pent_b8 = fifth_power_class(b8, 11)
    assert pent_a8 == [2, 6, 7, 8, 10]
    assert pent_b8 == [1, 3, 4, 5, 9]
    # golden conjugate sheet: pentagons swap targets
    assert fifth_power_class(a4, 11) == pent_b8
    assert fifth_power_class(b4, 11) == pent_a8

    return dict(
        q11=dict(sqrt5_frozen=4, phi=8, alpha=a8, beta=b8,
                 pole_labels={"v0": 0, "vinf": "inf"},
                 pentagon_alpha=pent_a8, pentagon_beta=pent_b8),
        q11_conjugate=dict(sqrt5=7, phi=4, alpha=a4, beta=b4,
                           pentagon_alpha=fifth_power_class(a4, 11),
                           pentagon_beta=fifth_power_class(b4, 11)),
        q7=dict(sqrt2_frozen=3, pole_labels={"v0": 0, "vinf": "inf"},
                nonpole=sorted(set(range(1, 7)))),
        q5=dict(pole_labels={"v0": 0, "vinf": "inf"},
                nonpole=sorted(set(range(1, 5)))),
    )


# --------------------------------------------------------------------------------------------------
# Assemble the canonical certificate.
# --------------------------------------------------------------------------------------------------
def build_certificate():
    h3 = build_h3()
    octa = build_octahedron()
    cube = build_cube()
    red = build_reductions()

    cert = {
        "schema": SCHEMA,
        "task": "C440 / Weil-roof battery M0 — shared conventions freeze",
        "trusted_boundary": (
            "exact rational arithmetic in Q(zeta5), Q(i), Q(sqrt2,omega) and prime fields F_q; "
            "polytope groups are the full sets of projectivities permuting the vertex root sets"),
        "ring": {
            "definition": "Z[phi], phi^2 = phi + 1 (phi = golden ratio)",
            "golden_conjugation": "sigma(phi) = 1 - phi   (Gal(Q(sqrt5)/Q))",
            "sqrt5": "sqrt5 = 2 phi - 1",
            "silver_ring": "Z[sqrt2] for B3/A3 (spin field Q(sqrt2))",
        },
        "conic": {
            "standard_conic": "Q = X Z - Y^2   (C406 Gate-1 frozen conic coordinates)",
            "P1_to_conic": "[s:t] |-> [s^2 : s t : t^2]   (discriminant Veronese)",
            "note": (
                "the six-arc frame of C341/C377 carries the anisotropic invariant conic "
                "X^2+Y^2+Z^2=0 and is Q(phi)-rational as 3x3 matrices (its A5 has order 60 over "
                "Q(phi)); over Q(phi) that definite conic is inequivalent to the isotropic "
                "X Z - Y^2, so the two frames agree only after reduction mod q, and the standard "
                "conic X Z - Y^2 is the finite-field normalization used from q on.  The integral "
                "golden model is the binary-form frame: Klein's f a binary form over Z, the "
                "icosahedral A5 realized over Z[zeta5] (S in SL2(Z[zeta5]); T inverts only the "
                "spin prime sqrt5, never 11) with trace field Q(sqrt5)=Q(phi) -- that trace field "
                "is what 'golden' means and is the source of the split-prime sheet structure; the "
                "conic is the discriminant X Z - Y^2 with the Veronese above."),
        },
        "cases": {
            "H3_icosahedron": {
                "coxeter_number_h": 10, "prime_q": 11, "vertex_count": 12,
                "identity_h_plus_2_eq_q_plus_1": (10 + 2 == 11 + 1),
                "spin_field": "Q(sqrt5)", "split_at_q": True,
                "vertex_form": "f = x y (x^10 + 11 x^5 y^5 - y^10)",
                "form_field": "Z", "middle_coefficient": 11,
                "symmetry_group": "A5", "group_order": h3["group_order"],
                "group_generators": {
                    "S": "diag(zeta5, zeta5^{-1}), order 5, in SL2(Z[zeta5])",
                    "T": ("(1/sqrt5)[[-(zeta-zeta^4), zeta^2-zeta^3],[zeta^2-zeta^3, zeta-zeta^4]], "
                          "order 2; inverts only the spin prime sqrt5 (never 11)"),
                    "presentation": "<S, T> = A5, order 60",
                },
                "f_invariant_under_group": True,
                "roots_are_single_orbit_of_size_12": h3["orbit_size"] == 12,
                "antipodal_perfect_matching_pairs": h3["antipode_pairs"],
                "antipodal_pairing_source": "alpha*beta = (121-125)/4 = -1 in f's coefficients",
                "trace_field": "Q(sqrt5)",
                "trace_field_is_exactly_Q_sqrt5": h3["trace_field_exactly_sqrt5"],
                "trace_field_note": (
                    "H3 is the only case whose *projective* (PGL2) trace field is the spin field: "
                    "S has tr^2/det = 2-phi (not in Q).  For B3/A3 the projective trace field is Q "
                    "and Q(sqrt2) appears only in the SL2 spin cover 2.S4."),
                "reduces_mod_11_to": "x y (x^10 - y^10)  ->  P^1(F_11)",
            },
            "B3_cube": {
                "coxeter_number_h": 6, "prime_q": 7, "vertex_count": 8,
                "identity_h_plus_2_eq_q_plus_1": (6 + 2 == 7 + 1),
                "spin_field": "Q(sqrt2)", "split_at_q": True,
                "vertex_form": "W = x y (4 x^6 + 7 sqrt2 x^3 y^3 - 4 y^6)",
                "form_field": "Z[sqrt2]", "middle_coefficient": "7 sqrt2",
                "symmetry_group": "O = S4 (octahedral rotation group)",
                "group_order": cube["group_order"],
                "form_invariant_under_group": True,
                "vertices_are_root_set": True,
                "reduces_mod_7_to": "4 x y (x^6 - y^6)  ->  P^1(F_7)   (sqrt2 == 3 mod 7)",
            },
            "A3_octahedron": {
                "coxeter_number_h": 4, "prime_q": 5, "vertex_count": 6,
                "identity_h_plus_2_eq_q_plus_1": (4 + 2 == 5 + 1),
                "spin_field": "Q(sqrt2)", "split_at_q": False, "inert_fused": True,
                "vertex_form": "t = x y (x^4 - y^4)",
                "form_field": "Z", "middle_coefficient": 0,
                "symmetry_group": "O = S4 (octahedral rotation group)",
                "group_order": octa["group_order"],
                "form_invariant_under_group": True,
                "vertices_are_root_set": True,
                "reduces_mod_5_to": "x y (x^4 - y^4)  ->  P^1(F_5)",
            },
        },
        "labeling": red,
        "c377_compatibility": {
            "J_matrix": "J(x,y,z) = (x, -z, -y)   (C377 six-arc frame)",
            "identification": (
                "J is the six-arc-frame realization of golden conjugation sigma = Gal(Q(sqrt5)/Q); "
                "the icosahedral A5 trace field is Q(sqrt5), so the group is golden."),
            "reduction_zeta5_to_3_gives": {"phi": 8, "sqrt5": 4, "sheet": "tau=8 (C377/C379)"},
            "golden_conjugate_reduction_gives": {"phi": 4, "sqrt5": 7, "sheet": "tau=4"},
            "sigma_swaps_pentagons_equals_sheet_swap": True,
            "group_reduces_mod_11_to_order": h3["reduced_group_order_mod11"],
            "group_reduction_note": (
                "the golden A5 itself (S,T reduced with zeta5->3) is a subgroup of PGL_2(F_11) of "
                "order exactly 60 -- the group action reduces, not only phi/sqrt5.  Matching it to "
                "C379's specific tau=8 A5 up to PGL_2(11) conjugacy is deferred to M1/M4."),
            "sheet_independence_of_vertex_reduction": (
                "f in Z[x,y] => the vertex->conic reduction is identical for both sqrt5 choices; the "
                "sheet bit lives entirely in the A5 embedding, not in the vertex/root set (de-risks M1)."),
        },
        "boundary_not_certified_here": [
            "the bijectivity of the vertex->conic reduction and the explicit per-root table (M1)",
            "uniqueness of the antipodal A5-invariant matching (M2)",
            "commuting-with-reduction of the quotient constructions mu1,mu2,mu3 (M3)",
            "the B3 sqrt2 and A3 inert-fusion reduction theory in full (M4)",
            "the char-11 gluing of the two sheets into one PGL2(11) orbit (M5)",
        ],
    }
    return cert


# --------------------------------------------------------------------------------------------------
# Canonical serialization, hashing, and --check.
# --------------------------------------------------------------------------------------------------
def canonical_json(obj):
    return json.dumps(obj, sort_keys=True, indent=2, ensure_ascii=True) + "\n"


def sha256_bytes(b):
    return hashlib.sha256(b).hexdigest()


def manifest_text(json_bytes):
    script_bytes = Path(__file__).resolve().read_bytes()
    lines = [
        f"{sha256_bytes(script_bytes)}  {STEM}.py  ({len(script_bytes)} bytes)",
        f"{sha256_bytes(json_bytes)}  {STEM}.json  ({len(json_bytes)} bytes)",
    ]
    return "\n".join(lines) + "\n"


def main(argv):
    cert = build_certificate()  # all asserts above are the verification certificate
    text = canonical_json(cert)
    data = text.encode("utf-8")
    if "--check" in argv:
        ok = True
        if not JSON_PATH.exists():
            print("MISSING", JSON_PATH)
            return 1
        tracked = JSON_PATH.read_bytes()
        if tracked != data:
            print("JSON MISMATCH: regenerated certificate differs from tracked artifact")
            ok = False
        expected_manifest = manifest_text(data)
        if not SHA_PATH.exists() or SHA_PATH.read_text() != expected_manifest:
            print("SHA256 MANIFEST MISMATCH")
            ok = False
        print("CHECK OK" if ok else "CHECK FAILED")
        return 0 if ok else 1
    JSON_PATH.write_text(text)
    SHA_PATH.write_text(manifest_text(data))
    print(f"wrote {JSON_PATH.name} ({len(data)} bytes) and {SHA_PATH.name}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
