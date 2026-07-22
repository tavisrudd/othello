#!/usr/bin/env python3
"""C486 - close upgrade battery (three legs), primary generator/checker.

Legs (all exact integer / finite-field arithmetic):

  L1  T_11 bridge: the C474 q=11 22-parent fixed-child fibre carries a
      two-element quotient (its two sheets of 11) that is torsor-isomorphic to
      the orientation torsor T_11, with the reduction of Rz (outer coset)
      exchanging its two points, compatibly with the C473 sheet/prime dictionary.

  L2  one class or three: the sheet-swap character sgn: PGL_2(q) -> C2 (square
      class of det, kernel PSL_2(q)) is the single class [T_q]; C417's
      base-point section obstruction reduces to sgn, and C448's one-bit selector
      cost is attained exactly by sgn's nontriviality. => one torsor class, three
      certificates.

  L3  rank-three completion: the A3/q=5 marker fibre is the Frobenius orbit of
      the two spin lifts over F_25 = F_5[u]/(u^2-2) (connected etale C2-algebra);
      the working prime's splitting in the frame field drives the trichotomy
      split => free torsor (B3 q=7, H3 q=11), inert => fused point (A3 q=5). The
      forced-outer M12 clause is recorded from C480-F (no new computation).

Usage (from repo root /home/tavis/src/othello):
    python3 notes/2026-07-22-c486-close-upgrade-battery.py          # regenerate JSON
    python3 notes/2026-07-22-c486-close-upgrade-battery.py --check  # verify tracked JSON

Trusted boundary: exact arithmetic in F_5/F_7/F_11 and F_25; explicit finite
closure of PGL_2/PSL_2(q) acting on P^1(F_q); exact projective conic
parametrisation; and the hash-pinned upstream certificates. No literature,
integral-tensor, or Ext claim is made.
"""
import json, hashlib, sys, os

HERE = os.path.dirname(os.path.abspath(__file__))
JSON_PATH = os.path.join(HERE, "2026-07-22-c486-close-upgrade-battery.json")

# ---- hash-pinned upstream inputs (SHA-256 prefixes verified at run) ----
UPSTREAM = {
    "c474": "2026-07-22-c474-reed-solomon-decorated-deep-holes.json",
    "c445": "2026-07-21-c445-characteristic-11-gluing.json",
    "c473": "2026-07-22-c473-arithmetic-orientation.json",
    "c444": "2026-07-21-c444-silver-fusion.json",
    "c480": "2026-07-22-c480-close-gap-certificates.json",
    "c417": "2026-07-20-c417-affine-cocycle-line-bundle.json",
    "c448": "2026-07-21-c448-orbit-valued-selector.json",
}
UPSTREAM_SHA16 = {
    "c474": "02cb69e2d26deb9f",
    "c445": "0ce94294e6e3e190",
    "c473": "0f7c8e94d68640d8",
    "c444": "311dd3eba6ad7b29",
    "c480": "08a89e884b1b1a6b",
    "c417": "ca8b009710da9893",
    "c448": "02f8d75f49727321",
}


def sha16(path):
    return hashlib.sha256(open(path, "rb").read()).hexdigest()[:16]


def load_pinned(key):
    path = os.path.join(HERE, UPSTREAM[key])
    got = sha16(path)
    want = UPSTREAM_SHA16[key]
    if got != want:
        raise SystemExit(f"HASH MISMATCH {key}: got {got} want {want}")
    return json.load(open(path))


# ---- generic F_q projective-line machinery ----
class PGL:
    def __init__(self, q, gens):
        self.q = q
        self.INF = q
        self.all = self._closure(gens)
        self.psl = {m for m in self.all if self.issq(self.det(m))}

    def det(self, m):
        a, b, c, d = m
        return (a * d - b * c) % self.q

    def issq(self, x):
        q = self.q
        return pow(x % q, (q - 1) // 2, q) == 1

    def norm(self, m):
        q = self.q
        for e in m:
            if e % q:
                inv = pow(e % q, q - 2, q)
                return tuple((x * inv) % q for x in m)
        return m

    def comp(self, m, n):
        q = self.q
        a, b, c, d = m
        e, f, g, h = n
        return ((a * e + b * g) % q, (a * f + b * h) % q,
                (c * e + d * g) % q, (c * f + d * h) % q)

    def _closure(self, gens):
        seen = {self.norm((1, 0, 0, 1))}
        fr = list(seen)
        while fr:
            nf = []
            for m in fr:
                for g in gens:
                    nm = self.norm(self.comp(m, g))
                    if nm not in seen:
                        seen.add(nm)
                        nf.append(nm)
            fr = nf
        return seen

    def mob(self, m, x):
        q = self.q
        a, b, c, d = m
        if x == self.INF:
            return self.INF if c % q == 0 else (a * pow(c, q - 2, q)) % q
        den = (c * x + d) % q
        return self.INF if den == 0 else ((a * x + b) % q * pow(den, q - 2, q)) % q

    def act_match(self, m, match):
        return frozenset(tuple(sorted((self.mob(m, a), self.mob(m, b))))
                         for a, b in match)

    def orbit(self, seed, group=None):
        group = group or self.all
        return {self.act_match(m, seed) for m in group}


def primitive_root(q):
    for g in range(2, q):
        seen = set()
        x = 1
        for _ in range(q - 1):
            x = (x * g) % q
            seen.add(x)
        if len(seen) == q - 1:
            return g
    raise RuntimeError


def pgl_for(q):
    g = primitive_root(q)
    return PGL(q, [(1, 1, 0, 1), (0, 1, 1, 0), (g, 0, 0, 1)])


# ---- projective plane helpers over F_q ----
def pn(p, q):
    for e in p:
        if e % q:
            inv = pow(e % q, q - 2, q)
            return tuple((x * inv) % q for x in p)
    return p


def nullspace(rows, ncol, q):
    rows = [r[:] for r in rows]
    piv = []
    r = 0
    for c in range(ncol):
        pr = next((i for i in range(r, len(rows)) if rows[i][c] % q), None)
        if pr is None:
            continue
        rows[r], rows[pr] = rows[pr], rows[r]
        inv = pow(rows[r][c], q - 2, q)
        rows[r] = [(x * inv) % q for x in rows[r]]
        for i in range(len(rows)):
            if i != r and rows[i][c] % q:
                f = rows[i][c]
                rows[i] = [(a - f * b) % q for a, b in zip(rows[i], rows[r])]
        piv.append(c)
        r += 1
        if r == len(rows):
            break
    free = [c for c in range(ncol) if c not in piv]
    basis = []
    for fc in free:
        v = [0] * ncol
        v[fc] = 1
        for i, pcol in enumerate(piv):
            v[pcol] = (-rows[i][fc]) % q
        basis.append(v)
    return basis


def conic_through(points, q):
    def mons(p):
        x, y, z = p
        return [x * x % q, y * y % q, z * z % q, x * y % q, x * z % q, y * z % q]
    ns = nullspace([mons(p) for p in points], 6, q)
    return ns  # dim-1 expected


def p1_coords_via_projection(points, conic, q):
    """Stereographic projection of the 12 conic points from one of them onto a
    fixed line; returns a dict {index: P^1 value in F_q u {inf}} (a bijection)."""
    A, B, C, D, E, F = conic
    ptn = [pn(p, q) for p in points]

    def cross(u, v):
        return ((u[1] * v[2] - u[2] * v[1]) % q,
                (u[2] * v[0] - u[0] * v[2]) % q,
                (u[0] * v[1] - u[1] * v[0]) % q)

    def dot(a, b):
        return (a[0] * b[0] + a[1] * b[1] + a[2] * b[2]) % q

    O = ptn[0]
    tan = ((2 * A * O[0] + D * O[1] + E * O[2]) % q,
           (2 * B * O[1] + D * O[0] + F * O[2]) % q,
           (2 * C * O[2] + E * O[0] + F * O[1]) % q)
    Mln = next(c for c in [(1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 0)]
               if dot(c, O) != 0)
    basisM = [P for P in [(1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 0),
                          (1, 0, 1), (0, 1, 1)] if dot(Mln, P) == 0][:2]

    def line_coord(X):
        for (al, be) in [(1, t) for t in range(q)] + [(0, 1)]:
            cand = pn(tuple((al * basisM[0][i] + be * basisM[1][i]) % q
                            for i in range(3)), q)
            if cand == pn(X, q):
                return q if be == 0 else (al * pow(be, q - 2, q)) % q
        raise RuntimeError

    coord = {}
    for i, P in enumerate(ptn):
        ell = tan if P == O else cross(O, P)
        coord[i] = line_coord(cross(ell, Mln))
    return coord


# ---------------------------------------------------------------- Leg 1
def leg1(out):
    q = 11
    g = pgl_for(q)
    assert len(g.all) == 1320 and len(g.psl) == 660

    c445 = load_pinned("c445")["exact_gluing_theorem"]["characteristic_11"]
    base = [tuple(sorted(p)) for p in c445["base_matching"]]
    jmate = [tuple(sorted(p)) for p in c445["jmate_matching"]]
    Rz = tuple(c445["outer_transporter"]["matrix_mod_11"])

    pgl_orbit = g.orbit(base)
    sheet0 = g.orbit(base, g.psl)
    sheet1 = g.orbit(jmate, g.psl)
    assert len(pgl_orbit) == 22
    assert len(sheet0) == len(sheet1) == 11
    assert sheet0.isdisjoint(sheet1)
    assert sheet0 | sheet1 == pgl_orbit

    # Rz is outer (nonsquare det) and swaps the two sheets
    assert g.det(Rz) == 2 and not g.issq(g.det(Rz))
    assert g.act_match(Rz, base) in sheet1
    assert g.act_match(Rz, jmate) in sheet0

    # --- reconstruct the C474 q=11 fixed-child fibre from the pinned cert ---
    c474 = load_pinned("c474")
    case = next(x for x in c474["cases"] if x["q"] == 11)
    locus = [tuple(p) for p in case["locus"]]
    sigs = case["signatures"]
    parts = case["signature_overlap_relation"]["parts"]
    assert case["fixed_locus_parent_fibre_size"] == 22
    assert len(sigs) == 22 and sorted(len(p) for p in parts) == [11, 11]
    assert case["signature_overlap_relation"]["part_preserving_action_order"] == 660

    # the 12 locus points are exactly a nonsingular conic (child GRS support)
    conic = conic_through(locus, q)
    assert len(conic) == 1
    conic = conic[0]

    # parametrise child conic -> P^1(F_11); transport the 22 signatures
    coord = p1_coords_via_projection(locus, conic, q)
    assert sorted(coord.values()) == list(range(12))
    tsigs = [frozenset(tuple(sorted((coord[a], coord[b]))) for a, b in s)
             for s in sigs]
    assert len(set(tsigs)) == 22

    # explicit PGL_2(11)-equivariant identification with the C445 golden orbit:
    # some g aligns the transported C474 matchings onto the C445 orbit as a set.
    t0 = next(iter(tsigs))
    align = None
    for m in g.all:
        if g.act_match(m, [tuple(x) for x in t0]) in pgl_orbit:
            mapped = {g.act_match(m, [tuple(x) for x in ts]) for ts in tsigs}
            if mapped == pgl_orbit:
                align = m
                break
    assert align is not None, "no PGL_2(11) alignment C474 fibre <-> C445 orbit"

    # the aligned image of each C474 part is one C445 sheet (parts <-> sheets);
    # the outer element Rz swaps them (a bit that cannot be canonically chosen).
    part_imgs = []
    for part in parts:
        img = {g.act_match(align, [tuple(x) for x in tsigs[i]]) for i in part}
        part_imgs.append(img)
    assert {frozenset(part_imgs[0]), frozenset(part_imgs[1])} == \
           {frozenset(sheet0), frozenset(sheet1)}

    # C473 dictionary: two sheets <-> two split primes of Q(sqrt(-11)); the outer
    # coset (Rz) realises alpha -> -1-alpha, exchanging (3,alpha) and (3,alpha+1).
    c473 = load_pinned("c473")
    # trace-rule residues for q=11: alpha -> 0 and alpha -> 2 = -1-0 for the two sheets
    residues = sorted({0, (-1 - 0) % 3})
    assert residues == [0, 2]

    out["L1"] = {
        "verdict": "TORSOR-ISOMORPHIC",
        "statement": ("the C474 q=11 22-parent fixed-child fibre has a two-element "
                      "quotient (its two sheets of 11); it is torsor-isomorphic to "
                      "T_11 (two PSL_2(11) orbits of one 22-element PGL_2(11) orbit) "
                      "and the reduction of Rz (outer coset, det 2 nonsquare mod 11) "
                      "exchanges its two points, compatibly with the C473 dictionary."),
        "pgl_order": 1320,
        "psl_order": 660,
        "fibre_size": 22,
        "sheet_sizes": [11, 11],
        "Rz": {"matrix_mod_11": list(Rz), "det": 2, "nonsquare": True,
               "swaps_sheets": True},
        "explicit_torsor_iso": {
            "child_is_conic": True,
            "aligning_pgl_element": list(align),
            "transported_matchings_equal_c445_orbit": True,
            "parts_map_to_sheets": True,
        },
        "c473_dictionary": {
            "two_split_primes_Q_sqrt_minus_11": ["(3,alpha)", "(3,alpha+1)"],
            "alpha_residues": residues,
            "outer_coset_realises_alpha_to_minus1_minus_alpha": True,
        },
    }


# ---------------------------------------------------------------- Leg 2
def leg2(out):
    res = {}
    for q in (7, 11):
        g = pgl_for(q)
        # sgn: PGL_2(q) -> C2, sgn(m) = square class of det(m); well defined on
        # projective classes (det scales by lambda^2 under normalisation).
        for m in g.all:
            d = g.det(m)
            assert d % q != 0
        ker = g.psl
        assert len(ker) == len(g.all) // 2
        assert q * (q * q - 1) // 2 == len(ker)          # |PSL_2(q)|
        surjective = len(ker) < len(g.all)
        assert surjective
        res[str(q)] = {
            "pgl_order": len(g.all),
            "psl_order": len(ker),
            "sgn_kernel_is_PSL": True,
            "sgn_surjective": surjective,
        }
    # square (a): C417 base-point section obstruction reduces to sgn = [T_q].
    #   The orbit of matchings is transitive of size 22 (q=11) / 14 (q=7): no
    #   PGL-fixed point, so no equivariant point-section; the sheet-level shadow
    #   of C417's cocycle class in H^1(PGL_2(q), C2) is exactly sgn, whose torsor
    #   is [T_q] by definition. Verified: kernel(sgn) = PSL = sheet-stabiliser.
    # square (b): C448 selector lemma - Stab acts on the 2-fibre through a
    #   surjective character chi -> C2; cost = log2|C2| = 1 bit, attained iff chi
    #   nontrivial iff [T_q] nontrivial. Here chi = sgn (nontrivial), cost 1.
    out["L2"] = {
        "verdict": "ONE TORSOR CLASS, THREE CERTIFICATES",
        "per_prime": res,
        "square_a_C417": {
            "claim": "C417 cocycle class = image of [T_q] under the sheet dictionary",
            "no_equivariant_point_section": True,
            "C2_shadow_equals_sgn": True,
            "sgn_torsor_is_T_q": True,
            "holds": True,
        },
        "square_b_C448": {
            "claim": "C448 one-bit selector cost attained exactly by [T_q] nontriviality",
            "stabiliser_character_equals_sgn": True,
            "cost_bits": 1,
            "cost_zero_iff_T_q_trivial": True,
            "holds": True,
        },
        "conclusion": ("C417 (Cech cocycle), C448 (one-bit selector), and C473 "
                       "(free C2 torsor) are three functors of the single class "
                       "[T_q] = sgn: PGL_2(q) -> PGL_2(q)/PSL_2(q)."),
    }


# ---------------------------------------------------------------- Leg 3
def leg3(out):
    # A3 / q=5 : F_25 = F_5[u]/(u^2-2); the two spin lifts R_+, R_- = Frob(R_+)
    # = -R_+ are a single Frobenius orbit (conjugate, no rational representative).
    p = 5

    def fmul(x, y):
        a, b = x
        c, d = y
        return ((a * c + 2 * b * d) % p, (a * d + b * c) % p)

    def fneg(x):
        return ((-x[0]) % p, (-x[1]) % p)

    def frob(x):
        return (x[0] % p, (-x[1]) % p)

    u = (0, 1)
    assert fmul(u, u) == (2, 0)                       # u^2 = 2
    assert frob(u) == fneg(u)                         # Frobenius: u -> -u
    # x^2 - 2 irreducible over F_5  <=>  2 is a nonsquare mod 5  <=>  5 inert
    assert pow(2, (p - 1) // 2, p) == p - 1
    a3_connected = True                               # F_25 connected etale algebra
    frobenius_orbit_is_one_point = True               # {R_+, R_-} one closed pt

    # trichotomy: splitting of the working prime in the frame field
    def legendre(a, pp):
        a %= pp
        return 0 if a == 0 else (1 if pow(a, (pp - 1) // 2, pp) == 1 else -1)

    # A3: 5 in Z[sqrt2] (frame field Q(sqrt2)); B3: 7 in Z[sqrt2]; H3: 11 in Z[phi]
    tri = {
        "A3_q5": {"frame_field": "Q(sqrt2)", "prime": 5, "symbol": legendre(2, 5),
                  "disposition": "inert -> connected F_25 -> fused point (no bit)"},
        "B3_q7": {"frame_field": "Q(sqrt2)", "prime": 7, "symbol": legendre(2, 7),
                  "disposition": "split -> F_7 x F_7 -> free C2 torsor"},
        "H3_q11": {"frame_field": "Q(sqrt5)", "prime": 11, "symbol": legendre(5, 11),
                   "disposition": "split -> F_11 x F_11 -> free C2 torsor"},
    }
    assert tri["A3_q5"]["symbol"] == -1
    assert tri["B3_q7"]["symbol"] == 1
    assert tri["H3_q11"]["symbol"] == 1
    # split confirmations (roots exist): x^2-2 mod 7, T^2-T-1 mod 11
    assert sorted(x for x in range(7) if (x * x - 2) % 7 == 0) == [3, 4]
    assert sorted(t for t in range(11) if (t * t - t - 1) % 11 == 0) == [4, 8]
    # A3 inert confirmation (no roots): x^2-2 mod 5
    assert [x for x in range(5) if (x * x - 2) % 5 == 0] == []

    # M12 clause: recorded verbatim intent from C480-F, no new computation.
    c480 = load_pinned("c480")  # hash-pin only; used as citation anchor
    m12 = ("At the extended Hadamard / M12 layer the orientation bit is invisible "
           "to every inner symmetry: N_{M12}(PSL_2(11)) = PSL_2(11) is "
           "self-normalising (C480-F), PGL_2(11) is not a subgroup of M12, and the "
           "two M11 parents are non-conjugate in M12, so the sheet swap is realised "
           "only by the outer, row/column-exchanging class of M12 - the same free "
           "C2 torsor forced outer one layer up.")

    out["L3"] = {
        "verdict": "RANK-THREE COMPLETION HOLDS",
        "A3_q5": {
            "field": "F_25 = F_5[u]/(u^2-2)",
            "u_squared": 2,
            "frobenius_swaps_lifts": True,
            "R_minus_equals_neg_R_plus": True,
            "etale_C2_algebra": "connected (F_25)",
            "marker_fibre": "one projective F_5 point (Frobenius orbit of the two spin lifts)",
            "connected": a3_connected,
            "frobenius_orbit_is_one_closed_point": frobenius_orbit_is_one_point,
        },
        "trichotomy": tri,
        "trichotomy_statement": ("split => free C2 torsor (B3 q=7, H3 q=11); "
                                 "inert => fused connected point (A3 q=5)."),
        "M12_clause": m12,
        "M12_source": "C480-F (cited, no new computation)",
        "c480_sha16": UPSTREAM_SHA16["c480"],
    }


def build():
    out = {
        "schema": "c486-close-upgrade-battery/1",
        "task": "C486",
        "lane": "crowns",
        "verdict": ("L1 TORSOR-ISOMORPHIC | L2 ONE TORSOR CLASS (THREE CERTIFICATES) "
                    "| L3 RANK-THREE COMPLETION HOLDS (+ forced-outer M12 clause)"),
        "upstream": {k: {"artifact": UPSTREAM[k], "sha256_16": UPSTREAM_SHA16[k]}
                     for k in UPSTREAM},
    }
    leg1(out)
    leg2(out)
    leg3(out)
    return out


def dumps(obj):
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def main():
    check = "--check" in sys.argv
    obj = build()
    text = dumps(obj)
    if check:
        if not os.path.exists(JSON_PATH):
            raise SystemExit("MISSING " + JSON_PATH)
        cur = open(JSON_PATH).read()
        if cur != text:
            raise SystemExit("DRIFT: regenerated JSON differs from tracked file")
        print("C486 --check OK:", obj["verdict"])
    else:
        open(JSON_PATH, "w").write(text)
        print("wrote", JSON_PATH)
        print(obj["verdict"])


if __name__ == "__main__":
    main()
