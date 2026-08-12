#!/usr/bin/env sage
"""C908 pass-9c: the lambda main-term certificate.

Computes the main-term contraction M(x, T) of
`notes/2026-08-12-c908-lambda-reduction-and-verdict.md` section 4 on
A = X x F x F (dim 7), for the ten pure antisymmetric lambda-tests T_{a_k}
of the compression certificate and the ten H^3(X,Z) basis classes x_j.

Model
-----
X-side H^*(X,Z): basis 1, H (deg 2), [line] (deg 4), [pt]_X (deg 6) with
H^2 = 3[line], H.[line] = [pt]_X, plus H^3(X,Z) = Z^10 with basis
omega^0..omega^9 normalised by phi^*(omega^k) = xi_k (Clemens-Griffiths
cylinder map).  The anti-isometry of EXT item E.4 gives

    omega^i . omega^j = - E_ij [pt]_X,       E = symplectic Gram of Lambda.

F-side: the pass-7 slot calculus, keys (w, c, p) with w a basis wedge of
Lambda (the a^*-part), c in {0,1} the C_s power, p the [pt]_F flag,
degree |w| + 2c + 4p <= 4, C_s^2 = 5[pt]_F.  Integration over F is defined
through a_* : int_F(key) = < a_*(key) >_{top}, which is well defined on the
free model even though the model does not impose a^*Theta = 2C_s.

Ambient ordering is X (x) F_1 (x) F_2 with the standard Koszul rule.

Classes
-------
  S  = H + G,  H = p_X^*H,  G = p_B^*(psi^*Theta) = 2C_s^(1) + 2C_s^(2) + cross
  [Z]  = h_1^*[P],  h_1 = (pr_{F_1}, pr_X)   (x in ell_1)
  [Z'] = h_2^*[P],  h_2 = (pr_{F_2}, pr_X)   (x in ell_2)
  [P] = 1 (x) [line] + Xi + C_s (x) H + 6[pt]_F (x) 1        (EXT E.6)
  D  = [Z']_S - [Z]_S + t iota^*G,  t symbolic
  m_k = iota_*[ e^D td(O(S))^{-1} ]_{k-1}
  c_4^main from the Newton expression (derived in-script)

The naive (off-T) calculus sets [Z]_S.[Z']_S = 0: Z cap Z' = T has dimension
three while two divisors of the six-fold S meet in dimension >= 4 when S is
smooth, so S is singular along T and the model is only valid on A \\ T.  Since
H^k(A) -> H^k(A \\ T) is injective for k <= 6, m_2 and m_3 are unambiguous;
m_4 is ambiguous by a T-supported codimension-four class, which enters c_4
with the even multiplier -6 and therefore cannot move the mod-two readout.
A control measures the (3,5)-pairing of the ambient product [Z].[Z'] (which
is the pullback of [P x_X P] = p_13^*[P] . p_23^*[P] under A = F x F x X) and
finds it even, the pass-8 section 3b claim verified rather than assumed.

No randomness; canonical lexicographic enumeration throughout.
"""

from contextlib import redirect_stdout
from io import StringIO
from itertools import combinations
import argparse
import hashlib
import json
import sys
import time

SCHEMA_VERSION = "c908-lambda-main-term/1"
DIM = 10
TOP = tuple(range(DIM))
CORPUS = "notes/2026-08-10-c904-minimal-class-divisor-lattice.sage"
COMPRESSION_JSON = "notes/2026-08-12-c908-h3-compression.json"
COMPRESSION_SAGE = "notes/2026-08-12-c908-h3-compression.sage"
EXTRACTION = "notes/2026-08-11-c908-fano-schubert-restriction-extraction.md"
REPLAY_COMMAND = (
    "cd /home/tavis/src/othello && nix shell nixpkgs#sage -c sage "
    "notes/2026-08-12-c908-lambda-main-term.sage "
    "--json notes/2026-08-12-c908-lambda-main-term.json "
    "--out notes/2026-08-12-c908-lambda-main-term.out"
)

# Sign of the Kunneth reordering on the (1,3) leg of [P] when [P] is pulled
# back from F x X to X x F_1 x F_2; derived, see the module docstring.
XI_SIGN = -1
# Anti-isometry of the cylinder map (EXT E.4): int_X w ^ w' = -E(phi^*w, phi^*w').
ANTI_ISOMETRY_SIGN = -1

_saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load(CORPUS)
sys.argv = _saved_argv


# --------------------------------------------------------- wedge utilities --

def add_forms(left, right):
    result = dict(left)
    for indices, value in right.items():
        total = result.get(indices, 0) + value
        if total:
            result[indices] = total
        elif indices in result:
            del result[indices]
    return result


def scale_form(scalar, form):
    if scalar == 0:
        return {}
    return {indices: scalar * value for indices, value in form.items()}


def divide_form(form, divisor):
    for value in form.values():
        assert value % divisor == 0, "divided power is not integral"
    return {indices: value // divisor for indices, value in form.items()}


def basis_form(indices):
    return {tuple(indices): ZZ.one()}


def sha256_of(path):
    with open(path, "rb") as stream:
        return hashlib.sha256(stream.read()).hexdigest()


def canonicalize(value):
    if value is None or isinstance(value, (bool, str)):
        return value
    if isinstance(value, dict):
        return {str(key): canonicalize(entry) for key, entry in value.items()}
    if isinstance(value, (list, tuple)):
        return [canonicalize(entry) for entry in value]
    if isinstance(value, int):
        return int(value)
    try:
        return int(value)
    except (TypeError, ValueError):
        return str(value)


# ------------------------------------------------------ F-slot calculus -----

ONE = ((), 0, 0)
CS = ((), 1, 0)
PT = ((), 0, 1)


def vec_key(index):
    return ((index,), 0, 0)


def slot_degree(key):
    w, c, p = key
    return len(w) + 2 * c + 4 * p


_ZERO = object()
_slot_mul_cache = {}


def slot_mul(left, right):
    cached = _slot_mul_cache.get((left, right), _ZERO)
    if cached is not _ZERO:
        return cached
    result = _slot_product(left, right)
    _slot_mul_cache[(left, right)] = result
    return result


def _slot_product(left, right):
    w1, c1, p1 = left
    w2, c2, p2 = right
    if p1 and p2:
        return None
    if p1:
        return (PT, 1) if slot_degree(right) == 0 else None
    if p2:
        return (PT, 1) if slot_degree(left) == 0 else None
    c = c1 + c2
    if c > 2:
        return None
    if set(w1) & set(w2):
        return None
    inversions = sum(1 for i in w1 for j in w2 if i > j)
    w = tuple(sorted(w1 + w2))
    sign = -1 if inversions % 2 else 1
    if len(w) + 2 * c > 4:
        return None
    if c == 2:
        return (PT, 5 * sign)              # C_s^2 = 5 [pt]_F
    return ((w, c, 0), sign)


# ------------------------------------------------------ X-slot calculus -----

XONE = ("one",)
XH = ("H",)
XL = ("L",)
XPT = ("pt",)


def XW(index):
    return ("w", index)


_XDEG = {"one": 0, "H": 2, "L": 4, "pt": 6, "w": 3}


def x_degree(key):
    return _XDEG[key[0]]


def make_x_mul(symplectic):
    cache = {}

    def x_mul(left, right):
        cached = cache.get((left, right), _ZERO)
        if cached is not _ZERO:
            return cached
        result = _x_product(left, right, symplectic)
        cache[(left, right)] = result
        return result

    return x_mul


def _x_product(left, right, symplectic):
    if left == XONE:
        return (right, ZZ(1))
    if right == XONE:
        return (left, ZZ(1))
    tags = (left[0], right[0])
    if tags == ("H", "H"):
        return (XL, ZZ(3))                       # H^2 = 3 [line]
    if tags in (("H", "L"), ("L", "H")):
        return (XPT, ZZ(1))                      # H . [line] = [pt]_X
    if tags == ("w", "w"):
        value = ZZ(ANTI_ISOMETRY_SIGN * symplectic[left[1], right[1]])
        return (XPT, value) if value else None
    return None                                   # everything else exceeds H^6


# -------------------------------------------- ambient (three-slot) algebra --

def keep(degrees):
    """Degree prune: the readout needs (3;1,4), (3;4,1) and (any;0,0)."""
    dx, d1, d2 = degrees
    return dx <= 6 and d1 <= 4 and d2 <= 4 and d1 + d2 <= 5


def tri_degrees(key):
    return (x_degree(key[0]), slot_degree(key[1]), slot_degree(key[2]))


def tri_add(*classes):
    result = {}
    for item in classes:
        for key, value in item.items():
            total = result.get(key, 0) + value
            if total:
                result[key] = total
            elif key in result:
                del result[key]
    return result


def tri_scale(scalar, item):
    if scalar == 0:
        return {}
    return {key: scalar * value for key, value in item.items()}


def make_tri_mul(x_mul):
    def bucket(item):
        buckets = {}
        for key, value in item.items():
            buckets.setdefault(tri_degrees(key), []).append((key, value))
        return buckets

    def tri_mul(left, right):
        result = {}
        left_buckets = bucket(left)
        right_buckets = bucket(right)
        for ldeg, lterms in left_buckets.items():
            for rdeg, rterms in right_buckets.items():
                total_deg = tuple(a + b for a, b in zip(ldeg, rdeg))
                if not keep(total_deg):
                    continue
                # Koszul sign depends only on the degree triples.
                tails = (ldeg[1] + ldeg[2], ldeg[2], 0)
                exponent = sum(rdeg[s] * tails[s] for s in range(3))
                global_sign = -1 if exponent % 2 else 1
                for lkey, lvalue in lterms:
                    for rkey, rvalue in rterms:
                        piece_x = x_mul(lkey[0], rkey[0])
                        if piece_x is None:
                            continue
                        piece_1 = slot_mul(lkey[1], rkey[1])
                        if piece_1 is None:
                            continue
                        piece_2 = slot_mul(lkey[2], rkey[2])
                        if piece_2 is None:
                            continue
                        coefficient = (global_sign * lvalue * rvalue
                                       * piece_x[1] * piece_1[1] * piece_2[1])
                        if not coefficient:
                            continue
                        key = (piece_x[0], piece_1[0], piece_2[0])
                        total = result.get(key, 0) + coefficient
                        if total:
                            result[key] = total
                        elif key in result:
                            del result[key]
        return result

    return tri_mul


def tri_power(tri_mul, item, exponent):
    result = {(XONE, ONE, ONE): ZZ(1)}
    for _ in range(exponent):
        result = tri_mul(result, item)
    return result


# ------------------------------------------------------------------ main ----

def main(json_path=None, out_path=None):
    started = time.time()
    field = GF(2)
    ring = PolynomialRing(QQ, "t")
    t = ring.gen()
    record = {"schema": SCHEMA_VERSION, "replay_command": REPLAY_COMMAND}
    controls = {}
    failures = []

    def note(name, value, detail=None):
        controls[name] = bool(value)
        if detail is not None:
            controls[name + "_detail"] = detail
        if not value:
            failures.append(name)

    # ---- lattice, theta, divided powers -----------------------------------
    _, _, _, symplectic = principal_lattice("omega", 1)
    assert abs(symplectic.det()) == 1
    theta = two_form(symplectic)
    powers = {1: theta}
    for degree in range(2, 6):
        powers[degree] = wedge(powers[degree - 1], theta)
    divided = {degree: divide_form(powers[degree], factorial(degree))
               for degree in powers}
    for degree in divided:
        assert scale_form(factorial(degree), divided[degree]) == powers[degree]
    orientation = ZZ(divided[5].get(TOP, 0))
    assert divided[5] == {TOP: orientation} and abs(orientation) == 1

    def integral_J(form):
        return ZZ(form.get(TOP, 0)) / orientation

    x_mul = make_x_mul(symplectic)
    tri_mul = make_tri_mul(x_mul)

    # ---- a_* on slot keys, psi_* controls ---------------------------------
    def slot_pushforward(key):
        w, c, p = key
        if p:
            return dict(divided[5])
        if c == 0:
            return wedge(basis_form(w), divided[3])
        return scale_form(2, wedge(basis_form(w), divided[4]))

    def poincare_dual(form):
        result = {}
        for indices, value in form.items():
            sign = wedge({tuple(indices): ZZ.one()},
                         {tuple(i for i in range(DIM) if i not in indices):
                          ZZ.one()}).get(TOP, 0)
            complement = tuple(i for i in range(DIM) if i not in indices)
            result[complement] = sign * value
        return {k: v for k, v in result.items() if v}

    def poincare_dual_inverse(form):
        result = {}
        for indices, value in form.items():
            complement = tuple(i for i in range(DIM) if i not in indices)
            sign = wedge({complement: ZZ.one()},
                         {tuple(indices): ZZ.one()}).get(TOP, 0)
            result[complement] = sign * value
        return {k: v for k, v in result.items() if v}

    def pontryagin(left, right):
        return poincare_dual_inverse(wedge(poincare_dual(left),
                                           poincare_dual(right)))

    unit_push = pontryagin(slot_pushforward(ONE), slot_pushforward(ONE))
    note("f_psi_push_of_unit_is_six_theta",
         unit_push == scale_form(6, theta))
    a_star_theta_push = {}
    for indices, value in theta.items():
        a_star_theta_push = add_forms(
            a_star_theta_push,
            scale_form(ZZ(value), slot_pushforward((indices, 0, 0))))
    note("f_a_star_theta_equals_two_Cs_under_pushforward",
         a_star_theta_push == scale_form(2, slot_pushforward(CS)))
    note("f_Cs_square_is_five_points",
         slot_mul(CS, CS) == (PT, 5))

    def integral_F(key):
        assert slot_degree(key) == 4
        return integral_J(slot_pushforward(key))

    def normalize(item):
        """Faithful image of a tri-class in honest cohomology.

        The free slot model does not impose a^*Theta = 2C_s, so two equal
        cohomology classes can have different key expansions.  Applying a_*
        slotwise resolves this: a_* is injective on H^d(F,Z) for every
        d <= 4 (isomorphism for d = 3, 4; hard Lefschetz for d <= 2), so two
        tri-classes are equal in H^*(A) exactly when their slotwise a_*
        images agree.
        """
        result = {}
        for key, value in item.items():
            first = slot_pushforward(key[1])
            second = slot_pushforward(key[2])
            for i1, v1 in first.items():
                for i2, v2 in second.items():
                    target = (key[0], i1, i2)
                    total = result.get(target, 0) + value * v1 * v2
                    if total:
                        result[target] = total
                    elif target in result:
                        del result[target]
        return result

    note("f_int_F_of_point_class_is_one", integral_F(PT) == 1)

    # int_F C_s^2 = 5 and int_F (a^*Theta)^2 = 4 C_s^2 = 20 -- both through a_*.
    theta_squared_push = {}
    for indices, value in powers[2].items():
        theta_squared_push = add_forms(
            theta_squared_push,
            scale_form(ZZ(value), slot_pushforward((indices, 0, 0))))
    note("f_int_F_Cs_square_is_five_and_a_star_theta_square_is_twenty",
         slot_mul(CS, CS)[1] * integral_F(PT) == 5
         and integral_J(theta_squared_push) == 20)

    # ---- psi^*Theta on the two F slots, derived ---------------------------
    def on_slot(slot, key, coefficient=1):
        keys = [XONE, ONE, ONE]
        keys[slot] = key
        return {tuple(keys): ring(coefficient)}

    def psi_pullback_h1(index):
        return tri_add(on_slot(1, vec_key(index), -1),
                       on_slot(2, vec_key(index), 1))

    psi_theta_raw = {}
    for (i, j), value in theta.items():
        psi_theta_raw = tri_add(psi_theta_raw, tri_scale(
            ring(value), tri_mul(psi_pullback_h1(i), psi_pullback_h1(j))))
    pure_1, pure_2, cross = {}, {}, {}
    for key, value in psi_theta_raw.items():
        d1, d2 = slot_degree(key[1]), slot_degree(key[2])
        if d1 and d2:
            cross[key] = value
        elif d1:
            pure_1[key] = value
        else:
            pure_2[key] = value
    theta_on_1 = {}
    theta_on_2 = {}
    for indices, value in theta.items():
        theta_on_1 = tri_add(theta_on_1, on_slot(1, (indices, 0, 0), value))
        theta_on_2 = tri_add(theta_on_2, on_slot(2, (indices, 0, 0), value))
    note("f_psi_pullback_pure_parts_are_a_star_theta",
         pure_1 == theta_on_1 and pure_2 == theta_on_2)
    gamma = zero_matrix(ZZ, DIM, DIM)
    for key, value in cross.items():
        gamma[key[1][0][0], key[2][0][0]] = ZZ(value)
    note("f_psi_cross_matrix_is_minus_symplectic", gamma == -symplectic)

    G = tri_add(on_slot(1, CS, 2), on_slot(2, CS, 2), cross)
    H = {(XH, ONE, ONE): ring(1)}
    S = tri_add(H, G)

    # ---- the universal-line class and the two cylinders -------------------
    Z = tri_add(
        {(XL, ONE, ONE): ring(1)},
        tri_add(*[{(XW(k), vec_key(k), ONE): ring(XI_SIGN)}
                  for k in range(DIM)]),
        {(XH, CS, ONE): ring(1)},
        {(XONE, PT, ONE): ring(6)})
    Zp = tri_add(
        {(XL, ONE, ONE): ring(1)},
        tri_add(*[{(XW(k), ONE, vec_key(k)): ring(XI_SIGN)}
                  for k in range(DIM)]),
        {(XH, ONE, CS): ring(1)},
        {(XONE, ONE, PT): ring(6)})

    # Chern data: c(T_F) = 1 - 3C_s + 27[pt], c(T_X) = 1 + 2H + 4H^2 - 2H^3.
    c1_TF_1 = on_slot(1, CS, -3)
    c1_TF_2 = on_slot(2, CS, -3)
    c1_TX = tri_scale(ring(2), H)
    xi_class = H                                     # xi = c_1(O_P(1)) = H|_P
    # relative Euler: c_1(T_{P/F}) = c_1(T_F) + 2 xi; c_1(T_P) = 2c_1(T_F)+2xi
    u_1 = tri_add(c1_TF_1, tri_scale(ring(2), xi_class))
    u_2 = tri_add(c1_TF_2, tri_scale(ring(2), xi_class))
    normal_c1_Z = tri_add(c1_TX, tri_scale(ring(-1), u_1))
    normal_c1_Zp = tri_add(c1_TX, tri_scale(ring(-1), u_2))
    note("z_c1_normal_bundle_is_three_Cs",
         normal_c1_Z == on_slot(1, CS, 3)
         and normal_c1_Zp == on_slot(2, CS, 3))

    # c_2(N) = [c(T_X) (1 - u + u^2 - ...)]_2 = 4H^2 - 2H u + u^2
    H2 = tri_mul(H, H)
    normal_c2_Z = tri_add(tri_scale(ring(4), H2),
                          tri_scale(ring(-2), tri_mul(H, u_1)),
                          tri_mul(u_1, u_1))
    self_intersection = tri_mul(normal_c2_Z, Z)
    # Compare in honest cohomology via slotwise a_* (normalize): the free
    # slot model does not impose a^*Theta = 2C_s, so raw key equality is
    # finer than equality of classes and gives false negatives.
    note("z_self_intersection_matches_c2_of_the_normal_bundle",
         normalize(tri_mul(Z, Z)) == normalize(self_intersection),
         "[Z]^2 = c_2(N_{Z/A}).[Z]; fails under the opposite anti-isometry "
         "sign or the opposite relative-Euler orientation")

    # explicit Kunneth value of [Z]^2, the EXT-E cross-check
    expected_zz = tri_add({(XPT, CS, ONE): ring(6)},
                          {(XL, PT, ONE): ring(27)})
    note("z_self_intersection_kunneth_value_is_6CsptX_plus_27ptFline",
         normalize(tri_mul(Z, Z)) == normalize(expected_zz))

    # ---- the naive (off-T) divisor calculus on S --------------------------
    nu_Z = tri_add(normal_c1_Z, tri_scale(ring(-1), S))
    nu_Zp = tri_add(normal_c1_Zp, tri_scale(ring(-1), S))

    def push_monomial(exponents):
        """iota_* of z^a z'^b g^c in the naive off-T calculus."""
        a, b, c = exponents
        if a > 0 and b > 0:
            return {}
        gpow = tri_power(tri_mul, G, c)
        if a == 0 and b == 0:
            return tri_mul(gpow, S)
        if a > 0:
            return tri_mul(gpow, tri_mul(tri_power(tri_mul, nu_Z, a - 1), Z))
        return tri_mul(gpow, tri_mul(tri_power(tri_mul, nu_Zp, b - 1), Zp))

    def sheaf_mul(left, right):
        result = {}
        for lkey, lvalue in left.items():
            for rkey, rvalue in right.items():
                key = tuple(a + b for a, b in zip(lkey, rkey))
                if key[0] > 0 and key[1] > 0:
                    continue
                total = result.get(key, 0) + lvalue * rvalue
                if total:
                    result[key] = total
                elif key in result:
                    del result[key]
        return result

    D = {(0, 1, 0): ring(1), (1, 0, 0): ring(-1), (0, 0, 1): t}
    D_powers = {0: {(0, 0, 0): ring(1)}}
    for degree in range(1, 4):
        D_powers[degree] = sheaf_mul(D_powers[degree - 1], D)
    push_D = {}
    for degree in range(0, 4):
        accumulated = {}
        for exponents, value in D_powers[degree].items():
            accumulated = tri_add(accumulated,
                                  tri_scale(value, push_monomial(exponents)))
        push_D[degree] = accumulated
    note("g_push_of_one_is_S", push_D[0] == S)
    note("g_push_of_D_is_Zp_minus_Z_plus_tGS",
         push_D[1] == tri_add(Zp, tri_scale(ring(-1), Z),
                              tri_scale(t, tri_mul(G, S))))
    note("g_push_of_D_squared_shape",
         push_D[2] == tri_add(
             tri_mul(nu_Zp, Zp), tri_mul(nu_Z, Z),
             tri_scale(t ** 2, tri_mul(tri_mul(G, G), S)),
             tri_scale(2 * t, tri_mul(G, tri_add(Zp, tri_scale(ring(-1), Z))))))

    # ---- td(O(S))^{-1} and the GRR terms ----------------------------------
    series_ring = PowerSeriesRing(QQ, "s", default_prec=6)
    s = series_ring.gen()
    td_inverse = ((1 - exp(-s)) / s).O(5)
    tau = [QQ(td_inverse[b]) for b in range(4)]
    note("g_td_inverse_coefficients",
         tau == [QQ(1), QQ(-1) / 2, QQ(1) / 6, QQ(-1) / 24],
         [str(value) for value in tau])

    S_powers = {0: {(XONE, ONE, ONE): ring(1)}}
    for degree in range(1, 5):
        S_powers[degree] = tri_mul(S_powers[degree - 1], S)

    m = {}
    for k in range(1, 5):
        accumulated = {}
        for a in range(0, k):
            b = k - 1 - a
            coefficient = ring(tau[b] / factorial(a))
            accumulated = tri_add(accumulated, tri_scale(
                coefficient, tri_mul(S_powers[b], push_D[a])))
        m[k] = accumulated

    note("g_m1_is_S", m[1] == S)
    note("g_m2_shape",
         m[2] == tri_add(push_D[1], tri_scale(ring(-1) / 2, S_powers[2])))
    note("g_m3_shape",
         m[3] == tri_add(tri_scale(ring(1) / 2, push_D[2]),
                         tri_scale(ring(-1) / 2, tri_mul(S, push_D[1])),
                         tri_scale(ring(1) / 6, S_powers[3])))
    note("g_m4_shape",
         m[4] == tri_add(tri_scale(ring(1) / 6, push_D[3]),
                         tri_scale(ring(-1) / 4, tri_mul(S, push_D[2])),
                         tri_scale(ring(1) / 6, tri_mul(S_powers[2], push_D[1])),
                         tri_scale(ring(-1) / 24, S_powers[4])))

    # ---- control (a): fiberwise ch --------------------------------------
    def fiber_restriction(item):
        return {key[0]: value for key, value in item.items()
                if slot_degree(key[1]) == 0 and slot_degree(key[2]) == 0
                and value}

    fiber = {k: fiber_restriction(m[k]) for k in range(1, 5)}
    expected_fiber = {
        1: {XH: ring(1)},
        2: {XL: ring(-3) / 2},                       # -H^2/2 = -(3/2)[line]
        3: {XPT: ring(-1) / 2},                      # -H^3/6 = -(1/2)[pt]_X
        4: {},
    }
    note("a_fiberwise_ch_is_0_H_minus_half_H2_minus_sixth_H3",
         all(fiber[k] == expected_fiber[k] for k in range(1, 5)),
         {str(k): {str(key): str(value) for key, value in fiber[k].items()}
          for k in range(1, 5)})

    # ---- Newton: c_4 from the Chern character, derived --------------------
    symmetric = SymmetricFunctions(QQ)
    elementary = symmetric.e()
    power_sums = symmetric.p()
    e4 = power_sums(elementary[4])
    newton_terms = []
    for partition, coefficient in e4:
        newton_terms.append((tuple(int(part) for part in partition),
                             QQ(coefficient)))
    expected_newton = {
        (4,): QQ(-1) / 4, (3, 1): QQ(1) / 3, (2, 2): QQ(1) / 8,
        (2, 1, 1): QQ(-1) / 4, (1, 1, 1, 1): QQ(1) / 24,
    }
    note("n_newton_e4_in_power_sums",
         dict(newton_terms) == expected_newton,
         {str(key): str(value) for key, value in newton_terms})

    def newton_c4(chern):
        """c_4 = e_4(roots) with p_k = k! ch_k, ch_0 = 0."""
        total = {}
        for partition, coefficient in newton_terms:
            product = {(XONE, ONE, ONE): ring(1)}
            scalar = QQ(coefficient)
            for part in partition:
                scalar *= factorial(part)
                product = tri_mul(product, chern[part])
            total = tri_add(total, tri_scale(ring(scalar), product))
        return total

    c4 = newton_c4(m)
    # cross-check against the reduction note's displayed Newton expression
    displayed = tri_scale(ring(1) / 24, tri_add(
        S_powers[4],
        tri_scale(ring(-12), tri_mul(S_powers[2], m[2])),
        tri_scale(ring(12), tri_mul(m[2], m[2])),
        tri_scale(ring(48), tri_mul(S, m[3])),
        tri_scale(ring(-144), m[4])))
    note("n_c4_matches_the_displayed_newton_expression", c4 == displayed)

    # ---- the readout ------------------------------------------------------
    nine_sets = list(combinations(range(DIM), 9))
    assert len(nine_sets) == DIM
    pairing_P = matrix(ZZ, DIM, DIM)
    for p in range(DIM):
        for mm in range(DIM):
            pairing_P[p, mm] = integral_J(
                wedge(basis_form((p,)), basis_form(nine_sets[mm])))
    note("r_beta_pairing_is_unimodular", abs(pairing_P.det()) == 1,
         int(pairing_P.det()))

    with open(COMPRESSION_JSON, encoding="utf-8") as stream:
        compression = json.load(stream)
    closed = compression["K3_pure_transfers_closed_form"]
    c_matrix = matrix(ZZ, closed["lambda_coefficient_matrix_rows"])
    note("r_lambda_coefficient_matrix_is_unimodular", abs(c_matrix.det()) == 1,
         int(c_matrix.det()))
    # re-derive c from the sparse transfer vectors and check they agree
    sparse_ok = True
    for entry in compression["K3_pure_transfers"]["lambda_test_transfers"]:
        row = [0] * (2 * DIM)
        for index, value in entry["coefficients"]:
            if index >= 2 * DIM:
                sparse_ok = False
                continue
            row[index] = value
        k = entry["direction"]
        if any(row[mm] != c_matrix[k, mm] for mm in range(DIM)):
            sparse_ok = False
        if any(row[DIM + mm] != -c_matrix[k, mm] for mm in range(DIM)):
            sparse_ok = False
    note("r_sparse_lambda_transfers_agree_with_the_coefficient_matrix",
         sparse_ok)

    degree_four_keys = set()
    for w_size in range(0, 5):
        for w in combinations(range(DIM), w_size):
            for c in (0, 1):
                key = (w, c, 0)
                if slot_degree(key) == 4:
                    degree_four_keys.add(key)
    degree_four_keys.add(PT)
    integral_of_key = {key: integral_F(key) for key in degree_four_keys}

    def readout(item):
        """The 10x10 matrix N_{jk} = int_A item . p_X^*x_j . p_B^*T_{a_k}."""
        left = matrix(ring, DIM, DIM)          # index (i, p)
        for key, value in item.items():
            xkey, f1, f2 = key
            if xkey[0] != "w":
                continue
            i = xkey[1]
            d1, d2 = slot_degree(f1), slot_degree(f2)
            if d1 == 1 and d2 == 4:
                left[i, f1[0][0]] += value * integral_of_key[f2]
            elif d1 == 4 and d2 == 1:
                left[i, f2[0][0]] -= value * integral_of_key[f1]
        return (symplectic.transpose().change_ring(ring) * left
                * (pairing_P * c_matrix.transpose()).change_ring(ring))

    N_poly = readout(c4)
    t_free = all(entry.degree() <= 0 for entry in N_poly.list())
    N_const = matrix(QQ, DIM, DIM,
                     [QQ(entry.constant_coefficient()) for entry in N_poly.list()])
    integral_N = all(value.denominator() == 1 for value in N_const.list())
    note("g_every_entry_of_N_is_an_integer", integral_N)
    N = N_const.change_ring(ZZ) if integral_N else None
    # report-only (the spec asserts mod-2 t-independence; integral
    # t-dependence is recorded, not a failure)
    controls["b_N_is_t_independent_integrally"] = bool(t_free)
    controls["b_N_t_degrees_detail"] = sorted(
        {int(entry.degree()) for entry in N_poly.list()})
    N_mod2_free = True
    if not t_free:
        for entry in N_poly.list():
            for coefficient in entry.coefficients(sparse=False)[1:]:
                if QQ(coefficient).denominator() != 1 or ZZ(coefficient) % 2:
                    N_mod2_free = False
    note("b_N_is_t_independent_mod_two", N_mod2_free)

    # ---- rigidity ---------------------------------------------------------
    S_pol = symplectic
    lambda_bit = None
    rigid = False
    if N is not None:
        reduced = N.change_ring(field)
        pol2 = S_pol.change_ring(field)
        if reduced == 0:
            lambda_bit, rigid = 0, True
        elif reduced == pol2:
            lambda_bit, rigid = 1, True
    note("c_rigidity_N_equals_lambda_times_S_mod_two", rigid,
         "lambda = " + str(lambda_bit) if rigid else "neither 0 nor S mod 2")

    # ---- ablation: Xi -> 0 -----------------------------------------------
    def strip_xi(item):
        return {key: value for key, value in item.items()
                if key[0][0] != "w"}

    Z_ablated = strip_xi(Z)
    Zp_ablated = strip_xi(Zp)
    ablated = None
    saved = (Z, Zp)
    # rebuild the whole tower with Xi removed
    def build_tower(z_class, zp_class):
        nz = tri_add(normal_c1_Z, tri_scale(ring(-1), S))
        nzp = tri_add(normal_c1_Zp, tri_scale(ring(-1), S))

        def push(exponents):
            a, b, c = exponents
            if a > 0 and b > 0:
                return {}
            gpow = tri_power(tri_mul, G, c)
            if a == 0 and b == 0:
                return tri_mul(gpow, S)
            if a > 0:
                return tri_mul(gpow, tri_mul(tri_power(tri_mul, nz, a - 1),
                                             z_class))
            return tri_mul(gpow, tri_mul(tri_power(tri_mul, nzp, b - 1),
                                         zp_class))

        pushes = {}
        for degree in range(0, 4):
            accumulated = {}
            for exponents, value in D_powers[degree].items():
                accumulated = tri_add(accumulated,
                                      tri_scale(value, push(exponents)))
            pushes[degree] = accumulated
        local = {}
        for k in range(1, 5):
            accumulated = {}
            for a in range(0, k):
                b = k - 1 - a
                accumulated = tri_add(accumulated, tri_scale(
                    ring(tau[b] / factorial(a)),
                    tri_mul(S_powers[b], pushes[a])))
            local[k] = accumulated
        return local, pushes

    m_ablated, _ = build_tower(Z_ablated, Zp_ablated)
    c4_ablated = newton_c4(m_ablated)
    N_ablated = readout(c4_ablated)
    note("d_ablation_Xi_zero_gives_identically_zero_N", N_ablated == 0)

    # ---- the conifold / incidence-cylinder parity control -----------------
    incidence_cylinder = tri_mul(Z, Zp)
    cylinder_readout = readout(incidence_cylinder)
    cylinder_const = matrix(QQ, DIM, DIM,
                            [QQ(entry.constant_coefficient())
                             for entry in cylinder_readout.list()])
    cylinder_even = (all(value.denominator() == 1
                         for value in cylinder_const.list())
                     and all(entry.degree() <= 0
                             for entry in cylinder_readout.list())
                     and cylinder_const.change_ring(ZZ).change_ring(field) == 0)
    note("z_incidence_cylinder_readout_is_even", cylinder_even,
         "leading conifold correction m_T.[Z].[Z'] is parity-dead "
         "(pass-8 3b), so the mixed-term convention cannot move lambda")

    # ---- control (e): the swap-duality divisibility identity --------------
    duality = tri_add(
        tri_scale(ring(37) / 12, S_powers[4]),
        tri_scale(ring(6), tri_mul(S_powers[2], m[2])),
        tri_mul(m[2], m[2]),
        tri_scale(ring(10), tri_mul(S, m[3])))
    L_poly = readout(duality)
    L_t_free = all(entry.degree() <= 0 for entry in L_poly.list())
    L_const = matrix(QQ, DIM, DIM,
                     [QQ(entry.constant_coefficient()) for entry in L_poly.list()])
    L_integral = all(value.denominator() == 1 for value in L_const.list())
    L = L_const.change_ring(ZZ) if L_integral else None
    note("e_duality_pairing_is_integral", L_integral)
    divisible = L is not None and all(value % 6 == 0 for value in L.list())
    note("e_duality_pairing_is_divisible_by_six", divisible)
    L_over_six = (L / 6).change_ring(ZZ) if divisible else None

    # ---- record -----------------------------------------------------------
    record["conventions"] = {
        "ambient_ordering": "X (x) F_1 (x) F_2, standard Koszul sign",
        "xi_reordering_sign": int(XI_SIGN),
        "anti_isometry_sign": int(ANTI_ISOMETRY_SIGN),
        "mixed_ZZp_convention": "[Z]_S.[Z']_S = 0 (naive GRR off the "
                                "non-Cartier locus T); ambiguity is a "
                                "T-supported codimension-four class entering "
                                "c_4 with the even multiplier -6",
        "a_k": "u_k = e_k, the corpus basis of Lambda",
        "x_j": "omega^j with phi^*(omega^j) = xi_j",
        "S_pol": "E(xi_j, u_k) = symplectic Gram",
    }
    record["controls"] = controls
    record["failures"] = failures
    record["lambda"] = None if lambda_bit is None else int(lambda_bit)
    record["N_matrix"] = ([[int(value) for value in row] for row in N.rows()]
                          if N is not None else None)
    record["N_mod_two"] = ([[int(value) for value in row]
                            for row in N.change_ring(field).rows()]
                           if N is not None else None)
    record["S_pol_matrix"] = [[int(value) for value in row]
                              for row in S_pol.rows()]
    record["N_t_dependence"] = {
        "integrally_t_independent": bool(t_free),
        "t_independent_mod_two": bool(N_mod2_free),
        "t_degrees_present": sorted({int(entry.degree())
                                     for entry in N_poly.list()}),
    }
    record["L_matrix"] = ([[int(value) for value in row] for row in L.rows()]
                          if L is not None else None)
    record["L_over_six"] = ([[int(value) for value in row]
                             for row in L_over_six.rows()]
                            if L_over_six is not None else None)
    record["L_t_independent"] = bool(L_t_free)
    record["chern_character_terms"] = {
        str(k): int(len(m[k])) for k in range(1, 5)}
    record["c4_terms"] = int(len(c4))
    record["inputs"] = {
        CORPUS: sha256_of(CORPUS),
        COMPRESSION_JSON: sha256_of(COMPRESSION_JSON),
        COMPRESSION_SAGE: sha256_of(COMPRESSION_SAGE),
        EXTRACTION: sha256_of(EXTRACTION),
    }
    record["wall_seconds"] = float(round(time.time() - started, 2))

    verdict = "PASS" if not failures else "FAIL"
    lines = [
        "C908 lambda main-term certificate",
        f"schema {SCHEMA_VERSION}",
        "",
        "controls:",
    ]
    for name in sorted(controls):
        if name.endswith("_detail"):
            continue
        lines.append(f"  {name:<62} {controls[name]}")
    lines.append("")
    lines.append(f"lambda = {record['lambda']}")
    lines.append(f"N integrally t-independent: {t_free}; mod two: {N_mod2_free}")
    lines.append("N (integral):")
    if N is not None:
        for row in N.rows():
            lines.append("  " + " ".join(f"{int(value):>6}" for value in row))
    lines.append("N mod 2 == S_pol mod 2: "
                 + str(N is not None
                       and N.change_ring(field) == S_pol.change_ring(field)))
    lines.append("L/6:")
    if L_over_six is not None:
        for row in L_over_six.rows():
            lines.append("  " + " ".join(f"{int(value):>8}" for value in row))
    lines.append("")
    lines.append(f"failures: {failures}")
    lines.append(f"wall seconds: {record['wall_seconds']}")
    lines.append(verdict)
    output = "\n".join(lines) + "\n"

    if json_path:
        with open(json_path, "w", encoding="utf-8") as stream:
            json.dump(canonicalize(record), stream, indent=2, sort_keys=True)
            stream.write("\n")
    if out_path:
        with open(out_path, "w", encoding="utf-8") as stream:
            stream.write(output)
    print(output, end="")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--json")
    parser.add_argument("--out")
    arguments = parser.parse_args()
    main(arguments.json, arguments.out)
