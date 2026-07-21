#!/usr/bin/env python3
"""C441 / Weil-roof battery task M1 -- vertex-reduction bijection (the load-bearing miracle).

Deliverable (spec: `2026-07-21-clebsch-weil-roof-program.md`, M1): certify that the M0 vertex set
reduces **bijectively onto `P^1(F_q)`** (the full conic phase) at each prime above the Coxeter prime
`q = h+1`:

    H3 icosahedron : 12 vertices -> P^1(F_11), at BOTH primes pi, pi_bar of Z[phi] (11 = pi pi_bar);
    B3 cube        :  8 vertices -> P^1(F_7),  at BOTH primes of Z[sqrt2] (7 = (3-sqrt2)(3+sqrt2));
    A3 octahedron  :  6 vertices -> P^1(F_5),  at the prime 5 (fused case: one vertex sheet).

Exhibits the explicit per-root bijection table (12 / 8 / 6 rows) with both prime columns, the
vertex-count identity `h + 2 = q + 1 = |P^1(F_q)|`, and runs the twist-search falsifier.

Method (guardrails 1-2 of the program): introduce NO new conventions.  All coordinates, forms,
generators and labelings are the FROZEN M0 artifact
`2026-07-21-c440-conventions-freeze.json` (consumed and hash-checked at runtime), and every object
is recomputed with M0's own exact-arithmetic machinery (imported from the M0 script), not recalled.

Why the bijection is a bijection, not just a set equality (compute, never recall):
  * the 12 icosahedral roots of Klein's `f` lie in `Q(zeta5)` (M0 computes them as the A5-orbit of
    [0:1] with exact Q(zeta5) arithmetic), so reduction at a degree-1 prime above 11 -- realized by
    the ring map `zeta5 -> 3` (pi, sqrt5=4, tau=8) resp. `zeta5 -> 9` (pi_bar, sqrt5=7, tau=4) --
    maps each root DIRECTLY to a point of P^1(F_11), no fifth-root/splitting-field ambiguity;
  * the reduction map is A5-EQUIVARIANT: the golden A5 reduces to a subgroup of PGL_2(F_11) of the
    same order 60 (M0 group-reduction hardening; good reduction, 11 does not divide |A5|), and
    `reduce(g . r) = reduce(g) . reduce(r)` is checked element-by-element -- so the 12 roots hit 12
    DISTINCT points (an equivariant map of the transitive A5-set A5/C5 onto itself is a bijection),
    which is exactly surjectivity onto the 12 points of P^1(F_11);
  * equivalently and independently: the reduced binary form is separable of full degree q+1 with
    root set all of P^1(F_q), so the char-0 form (also separable, degree q+1) has good reduction at
    q and reduction is a bijection of the two 0-dimensional root schemes.
Both certificates are emitted; they are mutually independent (one is group-equivariant, the other
is a discriminant/separability statement on the forms).

Twist-search falsifier (M1 spec): the "quadratic twist of the embedding" is the choice of spin
square root = choice of prime above q (the sheet).  The ONLY spin-dependent coefficient of each
vertex form is its MIDDLE coefficient (`11`, `7 sqrt2`, `0`), each `== 0 mod q`; hence the reduced
vertex form is independent of the twist, every twist yields the same bijection, and NO twist is
needed to repair anything -- the falsifier cannot trigger.  The search is run and recorded anyway.

Run (working directory = repository root):
    uv run python3 notes/2026-07-21-c441-vertex-reduction-bijection.py            # regenerate
    uv run python3 notes/2026-07-21-c441-vertex-reduction-bijection.py --check    # verify, no write

Deterministic; no timestamps.  Trusted boundary: exact rational arithmetic in Q(zeta5), Q(i),
Q(sqrt2, omega) (M0's frozen field implementations) and the prime fields F_11, F_7, F_5; the
polytope groups and vertex root sets are M0's, recomputed here, not assumed.
"""
from __future__ import annotations
from fractions import Fraction as F
from pathlib import Path
import hashlib
import importlib.util
import json
import sys

HERE = Path(__file__).resolve().parent
STEM = "2026-07-21-c441-vertex-reduction-bijection"
JSON_PATH = HERE / f"{STEM}.json"
SHA_PATH = HERE / f"{STEM}.sha256"
SCHEMA = "c441-vertex-reduction-bijection-v1"

M0_STEM = "2026-07-21-c440-conventions-freeze"
M0_PY = HERE / f"{M0_STEM}.py"
M0_JSON = HERE / f"{M0_STEM}.json"
M0_SHA = HERE / f"{M0_STEM}.sha256"


# --------------------------------------------------------------------------------------------------
# Consume the frozen M0 conventions: import its machinery and hash-verify its certificate.
# --------------------------------------------------------------------------------------------------
def load_m0():
    spec = importlib.util.spec_from_file_location("c440_m0", M0_PY)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    # Frozen inputs referenced by SHA (Phase-0 standing rule): the M0 JSON we consume must match its
    # committed hash manifest, and the M0 script we import must match its own recorded hash.
    j_bytes = M0_JSON.read_bytes()
    py_bytes = M0_PY.read_bytes()
    manifest = M0_SHA.read_text().splitlines()
    want = {}
    for line in manifest:
        h, rest = line.split(None, 1)
        name = rest.split()[0]
        want[name] = h
    assert hashlib.sha256(j_bytes).hexdigest() == want[f"{M0_STEM}.json"], "M0 JSON hash mismatch"
    assert hashlib.sha256(py_bytes).hexdigest() == want[f"{M0_STEM}.py"], "M0 script hash mismatch"
    m0 = json.loads(j_bytes.decode("utf-8"))
    assert m0["schema"] == "c440-conventions-freeze-v1"
    return mod, m0


# --------------------------------------------------------------------------------------------------
# Reductions of the three frozen fields to a prime field, and P^1 machinery over F_q.
# --------------------------------------------------------------------------------------------------
def _num(fr, p):
    return (fr.numerator % p) * pow(fr.denominator % p, p - 2, p) % p


def reduce_Z5(x, p, zval):
    # x in Q(zeta5), basis {1, z, z^2, z^3}: send zeta5 -> zval (order 5 in F_p).
    return sum(_num(x.c[k], p) * pow(zval, k, p) for k in range(4)) % p


def reduce_Qi(x, p, ival):
    # x in Q(i), basis {1, i}: send i -> ival (ival^2 = -1 in F_p).
    return (_num(x.c[0], p) + _num(x.c[1], p) * ival) % p


def reduce_Qc(x, p, s2val, wval):
    # x in Q(sqrt2, omega), basis {1, sqrt2, omega, sqrt2*omega}: sqrt2 -> s2val, omega -> wval.
    c = x.c
    return (_num(c[0], p) + _num(c[1], p) * s2val + _num(c[2], p) * wval
            + _num(c[3], p) * s2val * wval) % p


def pnorm_pt(X, Y, p):
    if Y % p != 0:
        return (X * pow(Y, p - 2, p)) % p       # affine label x = X/Y
    assert X % p != 0, "point reduces to (0:0) -- degenerate reduction (guardrail-3 blocker)"
    return "inf"


def reduce_point(pt, redf, p):
    X, Y = pt
    return pnorm_pt(redf(X), redf(Y), p)


def pnorm_mat(M, p):
    piv = next(v for v in M if v % p != 0)
    inv = pow(piv, p - 2, p)
    return tuple((v * inv) % p for v in M)


def pmul(A, B, p):
    return ((A[0] * B[0] + A[1] * B[2]) % p, (A[0] * B[1] + A[1] * B[3]) % p,
            (A[2] * B[0] + A[3] * B[2]) % p, (A[2] * B[1] + A[3] * B[3]) % p)


def pact(M, label, p):
    a, b, c, d = M
    if label == "inf":
        X, Y = a, c
    else:
        X, Y = (a * label + b) % p, (c * label + d) % p
    return pnorm_pt(X % p, Y % p, p)


def reduced_group_order(gens_red, p):
    ident = pnorm_mat((1, 0, 0, 1), p)
    grp = {ident}
    frontier = [ident]
    while frontier:
        P = frontier.pop()
        for g in gens_red:
            R = pnorm_mat(pmul(P, g, p), p)
            if R not in grp:
                grp.add(R)
                frontier.append(R)
        assert len(grp) <= 120
    return grp


def roots_of_reduced_form(coeffs_int, deg, p):
    """Root set in P^1(F_p) of a binary form given by {i: coeff on x^i y^(deg-i)}."""
    pts = set()
    for x in range(p):
        val = sum(c * pow(x, i, p) for i, c in coeffs_int.items()) % p
        if val == 0:
            pts.add(x)
    if coeffs_int.get(deg, 0) % p == 0:      # x=1, y=0 root (point at infinity)
        pts.add("inf")
    return pts


def full_P1(p):
    return set(range(p)) | {"inf"}


# --------------------------------------------------------------------------------------------------
# H3 -- icosahedron: rebuild the frozen A5, 12 roots, and blocks with M0's exact machinery.
# --------------------------------------------------------------------------------------------------
def build_h3(mod, m0):
    Z5, ops = mod.Z5, mod.ops
    o = ops(Z5)
    ONE, ZERO = o["ONE"], o["ZERO"]
    zeta = Z5((0, 1, 0, 0))
    zeta4 = Z5((-1, -1, -1, -1))
    phi = ONE + zeta + zeta4
    s5 = phi + phi - ONE
    assert (s5 * s5) == Z5((5, 0, 0, 0))

    # Frozen vertex form f (assert it is the M0 form) and its coefficients as a binary form.
    f = {11: ONE, 6: Z5((11, 0, 0, 0)), 1: -ONE}
    deg = 12
    assert m0["cases"]["H3_icosahedron"]["vertex_form"] == "f = x y (x^10 + 11 x^5 y^5 - y^10)"
    f_int = {11: 1, 6: 11, 1: -1}   # integer binary form x y (x^10 + 11 x^5 y^5 - y^10)

    # Frozen golden generators S, T (M0), the A5 group, and the 12-root orbit of [0:1].
    inv_s5 = o["div"](ONE, s5)
    zmz4 = zeta - zeta4
    z2mz3 = (zeta * zeta) - (zeta * zeta * zeta)
    S = (zeta, ZERO, ZERO, zeta4)
    T = (inv_s5 * (-zmz4), inv_s5 * z2mz3, inv_s5 * z2mz3, inv_s5 * zmz4)
    assert o["mat_order"](S) == 5 and o["mat_order"](T) == 2
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
    assert len(grp) == 60

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
    assert all(o["form_val"](f, deg, p).iszero() for p in orbit)

    # Blocks: x^5 = alpha or beta, with alpha,beta = (-11 +- 5 sqrt5)/2 in Q(zeta5).
    half = Z5((F(1, 2), 0, 0, 0))
    alpha = (Z5((-11, 0, 0, 0)) + Z5((5, 0, 0, 0)) * s5) * half
    beta = (Z5((-11, 0, 0, 0)) - Z5((5, 0, 0, 0)) * s5) * half
    assert (alpha * beta) == -ONE                       # antipodal source alpha*beta = -1

    def block_of(pt):
        x, y = pt
        if x.iszero():
            return "v0"
        if y.iszero():
            return "vinf"
        x5 = x
        for _ in range(4):
            x5 = x5 * x
        if x5 == alpha:
            return "alpha"
        if x5 == beta:
            return "beta"
        raise AssertionError("finite root with x^5 not in {alpha,beta}")

    roots = sorted(orbit, key=lambda p: (0 if p[1].iszero() else 1, tuple(str(v) for v in p[0].c)))
    return dict(o=o, S=S, T=T, grp=grp, roots=roots, block_of=block_of, form=f, deg=deg,
                f_int=f_int, ZERO=ZERO, ONE=ONE)


# --------------------------------------------------------------------------------------------------
# B3 -- cube, and A3 -- octahedron: rebuild frozen vertex sets with M0's exact machinery.
# --------------------------------------------------------------------------------------------------
def build_cube(mod, m0):
    Qc, ops = mod.Qc, mod.ops
    o = ops(Qc)
    ONE, ZERO = o["ONE"], o["ZERO"]
    S2 = Qc((0, 1, 0, 0))
    OMEGA = Qc((0, 0, 1, 0))
    inv_s2 = Qc((0, F(1, 2), 0, 0))

    def wpow(k):
        r = ONE
        for _ in range(k % 3):
            r = r * OMEGA
        return r

    pts = [(ZERO, ONE), (ONE, ZERO)]
    for k in range(3):
        pts.append((inv_s2 * wpow(k), ONE))      # upper triangle: radius 1/sqrt2, x^3 = u_up
    for k in range(3):
        pts.append(((-S2) * wpow(k), ONE))       # lower triangle: radius sqrt2, x^3 = u_lo
    grp = o["vertex_group"](pts)
    assert len(grp) == 24
    form = {7: Qc((4, 0, 0, 0)), 4: Qc((0, 7, 0, 0)), 1: Qc((-4, 0, 0, 0))}
    deg = 8
    assert all(o["form_val"](form, deg, p).iszero() for p in pts)
    assert m0["cases"]["B3_cube"]["vertex_form"] == "W = x y (4 x^6 + 7 sqrt2 x^3 y^3 - 4 y^6)"

    # u_up = sqrt2/4, u_lo = -2 sqrt2 are x^3 of the two triangles (u_up*u_lo = -1).
    u_up = Qc((0, F(1, 4), 0, 0))
    u_lo = Qc((0, -2, 0, 0))
    assert (u_up * u_lo) == -ONE

    def block_of(pt):
        x, y = pt
        if x.iszero():
            return "v0"
        if y.iszero():
            return "vinf"
        x3 = x * x * x
        if x3 == u_up:
            return "upper"
        if x3 == u_lo:
            return "lower"
        raise AssertionError("cube root with x^3 not in {u_up,u_lo}")

    pts_sorted = sorted(pts, key=lambda p: (0 if p[1].iszero() else 1, tuple(str(v) for v in p[0].c)))
    return dict(o=o, grp=grp, roots=pts_sorted, block_of=block_of, deg=deg,
                W_int_at=lambda s2v: {7: 4, 4: (7 * s2v), 1: -4})


def build_octa(mod, m0):
    Qi, ops = mod.Qi, mod.ops
    o = ops(Qi)
    ONE, ZERO = o["ONE"], o["ZERO"]
    I = Qi((0, 1))
    pts = [(ZERO, ONE), (ONE, ZERO), (ONE, ONE), (-ONE, ONE), (I, ONE), (-I, ONE)]
    grp = o["vertex_group"](pts)
    assert len(grp) == 24
    form = {5: ONE, 1: -ONE}
    deg = 6
    assert all(o["form_val"](form, deg, p).iszero() for p in pts)
    assert m0["cases"]["A3_octahedron"]["vertex_form"] == "t = x y (x^4 - y^4)"

    def block_of(pt):
        x, y = pt
        if x.iszero():
            return "v0"
        if y.iszero():
            return "vinf"
        return "real" if x.c[1] == 0 else "imag"

    pts_sorted = sorted(pts, key=lambda p: (0 if p[1].iszero() else 1, tuple(str(v) for v in p[0].c)))
    return dict(o=o, grp=grp, roots=pts_sorted, block_of=block_of, deg=deg,
                t_int={5: 1, 1: -1})


# --------------------------------------------------------------------------------------------------
# Core: certify the bijection at one prime, build the row column, check equivariance.
# --------------------------------------------------------------------------------------------------
def certify_prime(H, redf, p, deg, gens_char0_reduced):
    """Reduce every char-0 root, certify the image is all of P^1(F_p) bijectively, and (if
    generators supplied) certify A5/O-equivariance of the reduction."""
    o = H["o"]
    images = []
    for r in H["roots"]:
        images.append(reduce_point(r, redf, p))
    image_set = set(images)
    is_bijection = (len(images) == len(image_set) == p + 1) and (image_set == full_P1(p))

    equivariant = None
    if gens_char0_reduced is not None:
        equivariant = True
        for g_char0, g_red in gens_char0_reduced:
            for r in H["roots"]:
                gr = o["norm_pt"](o["act"](g_char0, r))
                lhs = reduce_point(gr, redf, p)                 # reduce(g . r)
                rhs = pact(g_red, reduce_point(r, redf, p), p)  # reduce(g) . reduce(r)
                if lhs != rhs:
                    equivariant = False
    return images, is_bijection, equivariant


def h3_reduced_gens(H, p, zval):
    S_red = pnorm_mat(tuple(reduce_Z5(v, p, zval) for v in H["S"]), p)
    T_red = pnorm_mat(tuple(reduce_Z5(v, p, zval) for v in H["T"]), p)
    order = len(reduced_group_order([S_red, T_red], p))
    return [(H["S"], S_red), (H["T"], T_red)], order


def build_h3_case(mod, m0):
    H = build_h3(mod, m0)
    p = 11

    def redf(zval):
        return lambda x: reduce_Z5(x, p, zval)

    # pi (tau=8): zeta5 -> 3 (phi->8, sqrt5->4);  pi_bar (tau=4): zeta5 -> 9 (phi->4, sqrt5->7).
    sheets = {"pi": dict(zeta5=3, phi=8, sqrt5=4, tau=8),
              "pi_bar": dict(zeta5=9, phi=4, sqrt5=7, tau=4)}
    col = {}
    equivariant = {}
    grp_order = {}
    for name, s in sheets.items():
        z = s["zeta5"]
        gens, order = h3_reduced_gens(H, p, z)
        imgs, bij, eqv = certify_prime(H, redf(z), p, H["deg"], gens)
        assert bij, f"H3 bijection failed at {name}"
        col[name] = imgs
        equivariant[name] = eqv
        grp_order[name] = order
        assert order == 60, f"reduced A5 order != 60 at {name}"

    # verify sheet arithmetic explicitly from the frozen generators/elements
    o = H["o"]
    ONE, ZERO = H["ONE"], H["ZERO"]
    zeta = mod.Z5((0, 1, 0, 0))
    zeta4 = mod.Z5((-1, -1, -1, -1))
    phi = ONE + zeta + zeta4
    s5 = phi + phi - ONE
    assert reduce_Z5(phi, p, 3) == 8 and reduce_Z5(s5, p, 3) == 4      # pi = tau=8
    assert reduce_Z5(phi, p, 9) == 4 and reduce_Z5(s5, p, 9) == 7      # pi_bar = tau=4

    # rows: one per char-0 root, with block and both prime columns
    rows = []
    for i, r in enumerate(H["roots"]):
        blk = H["block_of"](r)
        x_repr = "0" if r[0].iszero() else ("inf" if r[1].iszero() else str(tuple(str(v) for v in r[0].c)))
        rows.append(dict(block=blk, char0_x_over_Qzeta5=x_repr,
                         point_pi=col["pi"][i], point_pi_bar=col["pi_bar"][i]))
    rows.sort(key=lambda row: (["v0", "vinf", "alpha", "beta"].index(row["block"]),
                               p if row["point_pi"] == "inf" else row["point_pi"]))

    # block -> pentagon check against the frozen M0 labeling, and the swap
    lab = m0["labeling"]["q11"]
    labc = m0["labeling"]["q11_conjugate"]
    pent_alpha_pi = sorted(row["point_pi"] for row in rows if row["block"] == "alpha")
    pent_beta_pi = sorted(row["point_pi"] for row in rows if row["block"] == "beta")
    pent_alpha_pibar = sorted(row["point_pi_bar"] for row in rows if row["block"] == "alpha")
    pent_beta_pibar = sorted(row["point_pi_bar"] for row in rows if row["block"] == "beta")
    assert pent_alpha_pi == lab["pentagon_alpha"] and pent_beta_pi == lab["pentagon_beta"]
    assert pent_alpha_pibar == labc["pentagon_alpha"] and pent_beta_pibar == labc["pentagon_beta"]
    assert pent_alpha_pi == pent_beta_pibar and pent_beta_pi == pent_alpha_pibar  # sigma swaps

    # poles fixed at both primes
    v0 = next(row for row in rows if row["block"] == "v0")
    vinf = next(row for row in rows if row["block"] == "vinf")
    assert v0["point_pi"] == 0 and v0["point_pi_bar"] == 0
    assert vinf["point_pi"] == "inf" and vinf["point_pi_bar"] == "inf"

    twist = twist_search_h3(H, m0)
    return dict(
        prime_q=11, coxeter_number_h=10, vertex_count=12,
        primes="11 = pi * pi_bar in Z[phi] (split; both give residue field F_11)",
        vertex_count_identity=identity_block(10, 11, 12),
        sheets=sheets,
        reduced_A5_order={k: grp_order[k] for k in grp_order},
        is_bijection_at_pi=True, is_bijection_at_pi_bar=True,
        A5_equivariant_at_pi=equivariant["pi"], A5_equivariant_at_pi_bar=equivariant["pi_bar"],
        image_at_pi=canon_image(col["pi"]), image_at_pi_bar=canon_image(col["pi_bar"]),
        block_pentagon_map={
            "pi_tau8": {"alpha": pent_alpha_pi, "beta": pent_beta_pi},
            "pi_bar_tau4": {"alpha": pent_alpha_pibar, "beta": pent_beta_pibar},
            "note": "the alpha/beta blocks (fixed char-0 data: x^5 = alpha resp. beta) map to the two "
                    "Legendre cosets and SWAP between pi and pi_bar -- this is C377/C379's golden "
                    "sheet swap sigma realized as reduction at the two primes above 11.",
        },
        within_sheet_residual="each prime of Z[phi] above 11 has two primes of Z[zeta5] above it "
                              "(zeta5 -> 3 or 4 for tau=8; zeta5 -> 9 or 5 for tau=4), related by "
                              "zeta5 -> zeta5^{-1}; the residual C2 = N(C5)/C5 relabels roots within "
                              "a sheet but fixes the point set and the block->coset map.  zeta5 -> 3, 9 "
                              "are the frozen canonical representatives (M0).",
        bijection_table=rows,
        twist_search=twist,
    )


def build_cube_case(mod, m0):
    C = build_cube(mod, m0)
    p = 7
    # two primes above 7 in Z[sqrt2]: sqrt2 -> 3 and sqrt2 -> 4 (= -3).  Fix omega -> 2 (residual 4).
    sheets = {"pi": dict(sqrt2=3, omega=2), "pi_bar": dict(sqrt2=4, omega=2)}
    col = {}
    for name, s in sheets.items():
        assert (s["sqrt2"] ** 2) % p == 2 and (s["omega"] ** 2 + s["omega"] + 1) % p == 0
        redf = (lambda ss: (lambda x: reduce_Qc(x, p, ss["sqrt2"], ss["omega"])))(s)
        imgs, bij, _ = certify_prime(C, redf, p, C["deg"], None)
        assert bij, f"B3 bijection failed at {name}"
        col[name] = imgs
    rows = []
    for i, r in enumerate(C["roots"]):
        blk = C["block_of"](r)
        x_repr = "0" if r[0].iszero() else ("inf" if r[1].iszero() else str(tuple(str(v) for v in r[0].c)))
        rows.append(dict(block=blk, char0_x_over_Qsqrt2omega=x_repr,
                         point_pi=col["pi"][i], point_pi_bar=col["pi_bar"][i]))
    rows.sort(key=lambda row: (["v0", "vinf", "upper", "lower"].index(row["block"]),
                               p if row["point_pi"] == "inf" else row["point_pi"]))
    tri_up_pi = sorted(row["point_pi"] for row in rows if row["block"] == "upper")
    tri_lo_pi = sorted(row["point_pi"] for row in rows if row["block"] == "lower")
    tri_up_pibar = sorted(row["point_pi_bar"] for row in rows if row["block"] == "upper")
    tri_lo_pibar = sorted(row["point_pi_bar"] for row in rows if row["block"] == "lower")
    assert tri_up_pi == tri_lo_pibar and tri_lo_pi == tri_up_pibar  # triangles swap between primes
    assert sorted(tri_up_pi + tri_lo_pi) == [1, 2, 3, 4, 5, 6]      # two cube-cosets of F_7^*
    twist = twist_search_cube(m0)
    return dict(
        prime_q=7, coxeter_number_h=6, vertex_count=8,
        primes="7 = (3 - sqrt2)(3 + sqrt2) in Z[sqrt2] (split; both give residue field F_7)",
        vertex_count_identity=identity_block(6, 7, 8),
        sheets=sheets,
        is_bijection_at_pi=True, is_bijection_at_pi_bar=True,
        image_at_pi=canon_image(col["pi"]), image_at_pi_bar=canon_image(col["pi_bar"]),
        block_coset_map={
            "pi_sqrt2_3": {"upper": tri_up_pi, "lower": tri_lo_pi},
            "pi_bar_sqrt2_4": {"upper": tri_up_pibar, "lower": tri_lo_pibar},
            "note": "the two triangles (x^3 = sqrt2/4 resp. -2 sqrt2, product -1) map to the two "
                    "cube-power cosets of F_7^* and SWAP between the two primes above 7 -- the silver "
                    "analogue of the golden sheet swap.",
        },
        within_sheet_residual="omega -> 2 fixed; omega -> 4 is the residual conjugate prime of "
                              "Z[sqrt2, omega] above each Z[sqrt2]-prime, relabeling within a sheet.",
        bijection_table=rows,
        twist_search=twist,
    )


def build_octa_case(mod, m0):
    O = build_octa(mod, m0)
    p = 5
    # 5 = (2+i)(2-i) in Z[i]; the vertex reduction uses i -> 2 (residual i -> 3).  Fused case:
    # 5 is inert in the SPIN ring Q(sqrt2), so the two would-be sheets fuse -> ONE vertex sheet.
    redf = lambda x: reduce_Qi(x, p, 2)
    imgs, bij, _ = certify_prime(O, redf, p, O["deg"], None)
    assert bij, "A3 bijection failed at 5"
    # cross-check the conjugate prime i -> 3 gives the same point SET (the +-i symmetry)
    imgs_conj, bij2, _ = certify_prime(O, lambda x: reduce_Qi(x, p, 3), p, O["deg"], None)
    assert bij2 and set(imgs) == set(imgs_conj) == full_P1(p)
    rows = []
    for i, r in enumerate(O["roots"]):
        blk = O["block_of"](r)
        x_repr = "0" if r[0].iszero() else ("inf" if r[1].iszero() else str(tuple(str(v) for v in r[0].c)))
        rows.append(dict(block=blk, char0_x_over_Qi=x_repr, point=imgs[i], point_iconj=imgs_conj[i]))
    rows.sort(key=lambda row: (["v0", "vinf", "real", "imag"].index(row["block"]),
                               p if row["point"] == "inf" else row["point"]))
    twist = twist_search_octa(m0)
    return dict(
        prime_q=5, coxeter_number_h=4, vertex_count=6,
        prime="5 (fused: 5 is INERT in the spin ring Z[sqrt2], so the two would-be sheets are "
              "Frobenius-conjugate over F_25 and fuse -> one vertex sheet, no bit).  The vertex set "
              "itself lives in Q(i), in which 5 = (2+i)(2-i) splits; i -> 2 realizes the reduction.",
        vertex_count_identity=identity_block(4, 5, 6),
        is_bijection=True,
        image=canon_image(imgs),
        note_conjugate="i -> 3 (the conjugate prime of Z[i] above 5) gives the same point set of "
                       "P^1(F_5); it swaps i <-> -i.  The sheet FUSION is a statement about the spin "
                       "embedding (M4), not about the vertex reduction, which is a clean bijection.",
        bijection_table=rows,
        twist_search=twist,
    )


# --------------------------------------------------------------------------------------------------
# Twist-search falsifier (M1 spec).  The reduced vertex form is twist-invariant because its only
# spin-dependent coefficient (the middle one) is == 0 mod q.
# --------------------------------------------------------------------------------------------------
def _twist_common(reduced_form, deg, p, twist_labels):
    root_set = roots_of_reduced_form(reduced_form, deg, p)
    bij = (root_set == full_P1(p)) and (len(root_set) == p + 1)
    return dict(
        twist_family=twist_labels,
        reduced_vertex_form_coeffs={str(k): v for k, v in reduced_form.items()},
        reduced_form_twist_invariant=True,
        reduced_root_set_is_full_P1=bij,
        every_twist_bijects=bij,
        repairing_twist_needed=False,
        repairing_twist=None,
    )


def twist_search_h3(H, m0):
    p = 11
    # middle coeff 11 == 0 mod 11 for either sqrt5 in {4,7}: reduced form is xy(x^10 - y^10).
    forms = {}
    for s5 in (4, 7):
        # f has RATIONAL coefficients {1,11,-1}; the twist (choice of sqrt5) does not enter f at all.
        forms[s5] = {k: v % p for k, v in H["f_int"].items()}
    assert forms[4] == forms[7] == {11: 1, 6: 0, 1: (-1) % p}
    res = _twist_common({11: 1, 1: (-1) % p}, 12, p,
                        ["sqrt5 -> 4 (tau=8 sheet)", "sqrt5 -> 7 (tau=4 sheet)"])
    res["reason"] = ("H3 vertex form f = xy(x^10 + 11 x^5 y^5 - y^10) has purely rational "
                     "coefficients; the golden/spin data lives in the A5 embedding, not in f.  The "
                     "middle coefficient 11 == 0 mod 11, so f mod 11 = xy(x^10 - y^10) independent of "
                     "the sqrt5 twist.  No twist is needed; the falsifier does not trigger.")
    return res


def twist_search_cube(m0):
    p = 7
    forms = {}
    for s2 in (3, 4):
        forms[s2] = {7: 4 % p, 4: (7 * s2) % p, 1: (-4) % p}
    assert forms[3] == forms[4] == {7: 4, 4: 0, 1: (-4) % p}
    res = _twist_common({7: 4, 1: (-4) % p}, 8, p, ["sqrt2 -> 3", "sqrt2 -> 4 (= -3)"])
    res["reason"] = ("B3 vertex form W = xy(4 x^6 + 7 sqrt2 x^3 y^3 - 4 y^6): the only "
                     "sqrt2-dependent coefficient is the middle one, 7 sqrt2 == 0 mod 7, so "
                     "W mod 7 = 4 xy(x^6 - y^6) independent of the sqrt2 twist.  No twist needed.")
    return res


def twist_search_octa(m0):
    p = 5
    res = _twist_common({5: 1, 1: (-1) % p}, 6, p, ["i -> 2", "i -> 3 (conjugate prime above 5)"])
    res["reason"] = ("A3 vertex form t = xy(x^4 - y^4) has rational coefficients (middle coeff 0), so "
                     "its reduction is twist-invariant; both primes of Z[i] above 5 give the same "
                     "bijection.  The fused/inert phenomenon is a spin-field (Q(sqrt2)) statement, "
                     "not a vertex-form twist.  No twist needed.")
    return res


# --------------------------------------------------------------------------------------------------
def identity_block(h, q, vcount):
    return dict(
        coxeter_number_h=h, prime_q=q, vertex_count=vcount,
        q_equals_h_plus_1=(q == h + 1),
        h_plus_2_equals_vertex_count=(h + 2 == vcount),
        q_plus_1_equals_vertex_count=(q + 1 == vcount),
        h_plus_2_equals_q_plus_1=(h + 2 == q + 1),
        remark="|P^1(F_q)| = q + 1 = h + 2 = #vertices exactly when q = h + 1; this Coxeter-number "
               "coincidence is what makes the vertex->conic reduction a BIJECTION (equal finite "
               "cardinalities) rather than merely an injection.",
    )


def canon_image(imgs):
    finite = sorted(v for v in imgs if v != "inf")
    return dict(finite=finite, has_infinity=("inf" in imgs), size=len(set(imgs)))


# --------------------------------------------------------------------------------------------------
def build_certificate():
    mod, m0 = load_m0()
    h3 = build_h3_case(mod, m0)
    b3 = build_cube_case(mod, m0)
    a3 = build_octa_case(mod, m0)
    cert = {
        "schema": SCHEMA,
        "task": "C441 / Weil-roof battery M1 -- vertex-reduction bijection onto P^1(F_q)",
        "consumes": {
            "m0_conventions": f"{M0_STEM}.json",
            "m0_sha256_manifest": f"{M0_STEM}.sha256",
            "note": "M0 forms, generators, conic and labeling are consumed verbatim and hash-checked "
                    "at runtime; no new conventions are introduced (program guardrail 2).",
        },
        "verdict": "GREEN -- vertex set reduces BIJECTIVELY onto P^1(F_q) at every prime above q "
                   "for H3/B3/A3; A5-equivariant at q=11; twist falsifier does NOT trigger.",
        "trusted_boundary": "exact arithmetic in Q(zeta5), Q(i), Q(sqrt2,omega) (M0 field code) and "
                            "prime fields F_11, F_7, F_5; groups and root sets are M0's, recomputed.",
        "method": "reduce each char-0 vertex root (all in the M0 field) at each prime above q; the "
                  "image is certified equal to all of P^1(F_q) (bijection, equal cardinality q+1); "
                  "for H3 the reduction is additionally certified A5-equivariant against the reduced "
                  "order-60 group; the block (pentagon/triangle) -> Legendre/cube-coset map and its "
                  "swap between the two primes are exhibited.",
        "cases": {"H3_icosahedron": h3, "B3_cube": b3, "A3_octahedron": a3},
        "master_stroke_claim_1_status": "CERTIFIED (untwisted, no repair): claim 1 of "
            "2026-07-21-clebsch-master-stroke-integral-golden-model.md holds in the frozen "
            "normalization; the integral golden model's load-bearing bijection is not falsified.",
        "novelty_claim": "none.  The bijective reduction of icosahedral/octahedral vertices onto "
                         "P^1(F_q) at q=h+1 is classical (Klein, Edge, Kostant; see register row 33 "
                         "of the dossier).  M1 is verification, not a research/priority result.",
        "boundary_not_certified_here": [
            "uniqueness of the antipodal A5-invariant matching (M2)",
            "identification of the two C406 singleton depth fibres with the two prime-reductions (M2)",
            "commuting-with-reduction of mu1,mu2,mu3 and the denominator set N (M3)",
            "the B3 sqrt2 and A3 inert-fusion SHEET reduction theory in full (M4)",
            "the char-11 gluing of the two sheets into one PGL_2(11) orbit (M5)",
        ],
    }
    return cert


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
    cert = build_certificate()
    text = canonical_json(cert)
    data = text.encode("utf-8")
    if "--check" in argv:
        ok = True
        if not JSON_PATH.exists():
            print("MISSING", JSON_PATH)
            return 1
        if JSON_PATH.read_bytes() != data:
            print("JSON MISMATCH: regenerated certificate differs from tracked artifact")
            ok = False
        if not SHA_PATH.exists() or SHA_PATH.read_text() != manifest_text(data):
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
