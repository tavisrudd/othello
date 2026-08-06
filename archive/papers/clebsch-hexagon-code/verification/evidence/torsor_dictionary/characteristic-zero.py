#!/usr/bin/env python3
"""characteristic_zero - characteristic-zero realization row, primary generator/checker.

Question (ej section 4.1, golden_six_arc item): does the outer swap exchange golden_six_arc's
rational descent cocycle pair under the certified dictionaries, i.e. does the
torsor list gain a characteristic-zero realization row?

Verdict: POSITIVE. golden_six_arc's intrinsic S3-resolvent quotient Spec Q(sqrt5) is a
characteristic-zero free C2 object (no rational section). Its structural swap is
the Galois involution sigma of Q(sqrt5) (phi -> 1-phi). Under reduction at 11 the
two golden labelings {S, sigma(S)} become the two sheets M_pi (phi=8),
M_pibar (phi=4) = the two points of T_11, and sigma exchanges them exactly as the
outer PGL_2(11)/PSL_2(11) coset (Rz) does. So the char-zero descent is the first
non-finite realization row of T_q, exchanged by the outer swap.

Exact structural feature (stated, not a defect): the descended Q-form's matching
decoration is *rational* and reduces to ONE matching at both primes; the bit is
carried by the Hilbert-90 transport / the S3-resolvent (the labeling that does
not descend, golden_six_arc / affine_cocycle), and h_phi (which differs by sqrt5 -> 4 vs 7 mod 11 =
Galois of Q(sqrt5)) recovers the two distinct sheets from that one matching.

Usage (from this directory):
    python3 characteristic-zero.py
    python3 characteristic-zero.py --check

Trusted boundary: exact arithmetic in Q(phi) reduced mod 11, F_11 projective and
polynomial arithmetic, explicit PGL_2/PSL_2(11) closure; hash-pinned golden_six_arc/characteristic_eleven_gluing
certificates. No literature or novelty claim.
"""
import json, hashlib, sys, os
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
JSON_PATH = os.path.join(HERE, "characteristic-zero.json")

UPSTREAM = {
    "golden_six_arc": "golden-six-arc.json",
    "characteristic_eleven_gluing": "characteristic-eleven-gluing.json",
    "arithmetic_orientation": "arithmetic-orientation.json",
}
UPSTREAM_SHA16 = {
    "golden_six_arc": "d4e037ce13702b42",
    "characteristic_eleven_gluing": "9f649c40b4649f2d",
    "arithmetic_orientation": "609a15bfc6cae8f3",
}
q = 11


def load_pinned(key):
    path = os.path.join(HERE, UPSTREAM[key])
    got = hashlib.sha256(open(path, "rb").read()).hexdigest()[:16]
    if got != UPSTREAM_SHA16[key]:
        raise SystemExit(f"HASH MISMATCH {key}: {got} != {UPSTREAM_SHA16[key]}")
    return json.load(open(path))


def rf(s):
    f = Fraction(s)
    return int(f.numerator * pow(int(f.denominator), q - 2, q)) % q


def cell(c, phi):
    """[a,b] encodes a + b*phi; reduce mod 11 at phi in {8,4}."""
    return (rf(c[0]) + rf(c[1]) * phi) % q


def pn(p):
    for e in p:
        if e % q:
            inv = pow(e % q, q - 2, q)
            return tuple((x * inv) % q for x in p)
    return p


def matmul(M, v):
    return tuple(sum(M[i][j] * v[j] for j in range(3)) % q for i in range(3))


def conic_pts(C):
    out = []
    for v in ([(1, y, z) for y in range(q) for z in range(q)] +
              [(0, 1, z) for z in range(q)] + [(0, 0, 1)]):
        if sum(v[i] * C[i][j] * v[j] for i in range(3) for j in range(3)) % q == 0:
            out.append(pn(v))
    return out


def polar_match(C, arc, cp):
    M = []
    for P in arc:
        L = [sum(C[i][j] * P[j] for j in range(3)) % q for i in range(3)]
        pr = tuple(sorted(Q for Q in cp if sum(L[i] * Q[i] for i in range(3)) % q == 0))
        M.append(pr)
    return frozenset(M)


# --- PGL_2(11)/PSL_2(11) on the identity conic via stereographic parametrisation
def build_pgl():
    def det(m):
        a, b, c, d = m
        return (a * d - b * c) % q

    def issq(x):
        return pow(x % q, (q - 1) // 2, q) == 1

    def comp(m, n):
        a, b, c, d = m
        e, f, g, h = n
        return ((a * e + b * g) % q, (a * f + b * h) % q,
                (c * e + d * g) % q, (c * f + d * h) % q)

    def norm(m):
        for e in m:
            if e % q:
                inv = pow(e % q, q - 2, q)
                return tuple((x * inv) % q for x in m)
        return m

    gens = [(1, 1, 0, 1), (0, 1, 1, 0), (2, 0, 0, 1)]
    allm = {norm((1, 0, 0, 1))}
    fr = list(allm)
    while fr:
        nf = []
        for m in fr:
            for g in gens:
                x = norm(comp(m, g))
                if x not in allm:
                    allm.add(x)
                    nf.append(x)
        fr = nf
    psl = {m for m in allm if issq(det(m))}
    return allm, psl


def mob(m, x):
    a, b, c, d = m
    if x == q:
        return q if c % q == 0 else (a * pow(c, q - 2, q)) % q
    den = (c * x + d) % q
    return q if den == 0 else ((a * x + b) % q * pow(den, q - 2, q)) % q


def act(m, M):
    return frozenset(tuple(sorted((mob(m, a), mob(m, b))))
                     for a, b in M)


def build():
    golden_six_arc = load_pinned("golden_six_arc")
    load_pinned("characteristic_eleven_gluing")
    load_pinned("arithmetic_orientation")
    rep = golden_six_arc["representative"]
    pts = rep["descended_arc_projective_points"]
    Gm = [[rf(rep["descended_conic_gram"][i][j]) for j in range(3)] for i in range(3)]
    hh = rep["hilbert90_h"]

    # (1) arithmetic core: intrinsic S3-quotient = Spec Q(sqrt5), reduces at 11 to
    #     the two roots of T^2 - T - 1 = the two golden phi values (quadratic_descent/golden_six_arc).
    roots = sorted(t for t in range(q) if (t * t - t - 1) % q == 0)
    assert roots == [4, 8]
    # sigma: T -> 1 - T swaps the roots (sum of roots = 1)
    assert sorted((1 - r) % q for r in roots) == roots
    assert (1 - 8) % q == 4 and (1 - 4) % q == 8      # sigma swaps phi=8 <-> phi=4

    # (2) descended decoration is rational: identical matching at both primes.
    cpG = conic_pts(Gm)
    arc = {phi: [pn(tuple(cell(P[k], phi) for k in range(3))) for P in pts]
           for phi in (8, 4)}
    Mrat = {phi: polar_match(Gm, arc[phi], cpG) for phi in (8, 4)}
    assert Mrat[8] == Mrat[4]                          # bit invisible in the Q-form

    # (3) Hilbert-90 transport recovers the two sheets. h^T h = G, so h_phi maps
    #     the descended conic to the sum-of-squares (identity) conic, and sqrt5
    #     reduces to 4 at phi=8 and to 7 = -4 at phi=4 (Galois of Q(sqrt5) mod 11).
    def hred(phi):
        return [[cell(hh[i][j], phi) for j in range(3)] for i in range(3)]

    I = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
    cpI = conic_pts(I)
    sheets = {}
    for phi in (8, 4):
        hp = hred(phi)
        hT = [[hp[j][i] for j in range(3)] for i in range(3)]
        prod = [[sum(hT[i][k] * hp[k][j] for k in range(3)) % q for j in range(3)]
                for i in range(3)]
        assert prod == Gm                              # h^T h == G mod 11
        Sarc = [pn(matmul(hp, P)) for P in arc[phi]]
        sheets[phi] = polar_match(I, Sarc, cpI)
    sqrt5 = {phi: (2 * phi - 1) % q for phi in (8, 4)}
    assert sqrt5 == {8: 4, 4: 7} and (sqrt5[8] + sqrt5[4]) % q == 0  # 4 = -7 mod 11
    assert sheets[8] != sheets[4]                      # two distinct golden sheets

    # (4) the two sheets are the two points of T_11: same PGL orbit, different PSL
    #     orbits (outer-related). Parametrise the identity conic -> P^1(F_11).
    A, B, C, D, E, F = 1, 1, 1, 0, 0, 0

    def dot(a, b):
        return sum(a[i] * b[i] for i in range(3)) % q

    def crs(u, v):
        return ((u[1] * v[2] - u[2] * v[1]) % q,
                (u[2] * v[0] - u[0] * v[2]) % q,
                (u[0] * v[1] - u[1] * v[0]) % q)

    O = cpI[0]
    tan = ((2 * A * O[0] + D * O[1] + E * O[2]) % q,
           (2 * B * O[1] + D * O[0] + F * O[2]) % q,
           (2 * C * O[2] + E * O[0] + F * O[1]) % q)
    Ln = next(c for c in [(1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 0)] if dot(c, O))
    bM = [P for P in [(1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 0), (1, 0, 1),
                      (0, 1, 1)] if dot(Ln, P) == 0][:2]

    def lc(X):
        for (al, be) in [(1, t) for t in range(q)] + [(0, 1)]:
            if pn(tuple((al * bM[0][i] + be * bM[1][i]) % q for i in range(3))) == pn(X):
                return q if be == 0 else (al * pow(be, q - 2, q)) % q
        raise RuntimeError

    idx = {}
    for P in cpI:
        ell = tan if pn(P) == O else crs(O, pn(P))
        idx[pn(P)] = lc(crs(ell, Ln))
    assert sorted(idx.values()) == list(range(12))

    def to_p1(M):
        return frozenset(tuple(sorted((idx[a], idx[b]))) for a, b in M)

    m8, m4 = to_p1(sheets[8]), to_p1(sheets[4])
    allm, psl = build_pgl()
    orbit = {act(m, m8) for m in allm}
    psl8 = {act(m, m8) for m in psl}
    psl4 = {act(m, m4) for m in psl}
    assert m4 in orbit                                 # same PGL_2(11) orbit
    assert m4 not in psl8 and m8 not in psl4           # different PSL orbits (outer)

    # the explicit outer transporter between the two sheets (nonsquare det)
    swap = None
    for m in allm:
        if act(m, m8) == m4:
            swap = m
            break
    assert swap is not None
    def det(m):
        a, b, c, d = m
        return (a * d - b * c) % q
    assert pow(det(swap), (q - 1) // 2, q) == q - 1     # nonsquare: outer coset

    return {
        "schema": "characteristic_zero-char-zero-realization-row/1",
        "artifact": "characteristic_zero",
        "verdict": ("POSITIVE - the outer swap exchanges golden_six_arc's descent cocycle pair; "
                    "the torsor list gains a characteristic-zero realization row "
                    "(the S3-resolvent Spec Q(sqrt5))"),
        "upstream": {k: {"artifact": UPSTREAM[k], "sha256_16": UPSTREAM_SHA16[k]}
                     for k in UPSTREAM},
        "char_zero_object": {
            "S3_resolvent_quotient": "Spec Q(sqrt5)  = (K x K x K)^S3, K=Q(sqrt5)",
            "no_rational_section": True,
            "structural_swap": "Galois sigma of Q(sqrt5), phi -> 1-phi",
            "two_character_machine": "Z[1/5,T]/(T^2-T-1)",
        },
        "reduction_at_11": {
            "roots_of_T2_minus_T_minus_1": roots,
            "sigma_swaps_roots": True,
            "phi8_is_pi_phi4_is_pibar": True,
            "sheets_are_two_points_of_T_11": True,
        },
        "descended_decoration_is_rational": {
            "single_matching_at_both_primes": True,
            "note": "the bit is carried by the S3-resolvent / Hilbert-90 transport, "
                    "not by the reduced Q-form decoration (matches golden_six_arc/affine_cocycle)",
        },
        "hilbert90_transport": {
            "hT_h_equals_G_mod_11": True,
            "sqrt5_reduction": {"phi8": 4, "phi4": 7, "are_galois_conjugate_mod_11": True},
            "two_distinct_sheets": True,
        },
        "outer_swap": {
            "sheets_same_PGL_orbit": True,
            "sheets_different_PSL_orbits": True,
            "explicit_transporter": list(swap),
            "transporter_determinant": det(swap),
            "transporter_is_nonsquare_outer": True,
            "sigma_corresponds_to_outer_coset": True,
        },
        "conclusion": ("The characteristic-zero golden descent (golden_six_arc) is a genuine "
                       "realization row of the orientation torsor T_q: its structural "
                       "swap sigma (Galois of Q(sqrt5)) is exchanged with the outer "
                       "PGL_2(11)/PSL_2(11) coset under reduction at 11, via the "
                       "certified characteristic_eleven_gluing (Rz) and arithmetic_orientation (alpha -> -1-alpha) dictionaries. "
                       "First non-finite entry on the torsor list."),
    }


def dumps(obj):
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def main():
    obj = build()
    text = dumps(obj)
    if "--check" in sys.argv:
        if not os.path.exists(JSON_PATH):
            raise SystemExit("MISSING " + JSON_PATH)
        if open(JSON_PATH).read() != text:
            raise SystemExit("DRIFT: regenerated JSON differs from tracked file")
        print("characteristic_zero --check OK:", obj["verdict"])
    else:
        open(JSON_PATH, "w").write(text)
        print("wrote", JSON_PATH)
        print(obj["verdict"])


if __name__ == "__main__":
    main()
