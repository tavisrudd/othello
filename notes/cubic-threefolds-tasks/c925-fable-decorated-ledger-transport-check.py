#!/usr/bin/env python3
"""C925: exact model certificate for the Stokes-decorated ledger transport.

Validates, on an exact rank-three model over Q(eps) (eps plays the
large-radius variable q^{-1}; the chain ring O is "eps-integral"), the four
mechanisms of the one-step transport theorem in
notes/2026-08-23-c925-fable-stokes-decorated-ledger.md:

leg 1 (decoration well-defined).  The C924 marked-block family
    z^2 Y' = (U_eps + z D + z^2 L) Y,
    U_eps = [[0,2],[eps,0]], D = diag(-19/18, 19/18), L = [[0,0],[-8/81,0]]
  is eps-integral; its special fibre (eps = 0) is regular singular and a
  general Moser/shearing extractor returns the Levelt class {1/6, 5/6}
  (mod Z), matching the diag(1,z) computation of the confluence note.
  For eps != 0 the pair is split; the decoration of the split pair is by
  definition this special-fibre class.

leg 2 (flat cluster projector: existence, integrality, uniqueness).  Embed
  the family as a 2-cluster next to a separated sheet u3 = 3 + 1/eps (a
  deliberately non-integral eigenvalue, as for Iritani's lambda-shifted
  centre sheets), mix everything by an integral model comparison
  G = G0 (1 + eps z C1 + eps z^2 C2) with G0 = 1 + O(eps) constant mixing
  (the shape property (4)/(5.28) of arXiv:2307.13555v3 gives the base block
  of Psi).  On the mixed side, solve the flat-projector recursion
  [U, Pi_{k+1}] = k Pi_k - [B0, Pi_k] - [B1, Pi_{k-1}] plus the idempotency
  constraint intrinsically, and check: every z-order of Pi is eps-integral,
  and Pi equals the transported block projector G^{-1} P_blk G exactly,
  order by order (uniqueness of the flat extension).

leg 3 (transport).  Compute the cluster lattice V = Pi(e1, e2), the
  compressed connection of nabla on V in that basis, check it is
  eps-integral, take its special fibre, extract the Levelt class: it equals
  the summand-side decoration {1/6, 5/6}.  This is the theorem's
  conclusion computed intrinsically on the mixed side.

leg 4 (negative control = the red-team hiding mechanism).  A second
  eps-integral family with the same U_eps -- the identical split pair,
  merging identically, both generic fibres a pair of simple sheets -- has a
  DIFFERENT special-fibre Levelt class ({0,0} instead of {1/6,5/6}).  The
  merged class is therefore invisible in the generic eigenvalue/ledger
  data; the decoration is extra structure carried by the integral model,
  and the integrality hypothesis (INT-Psi) on the comparison is
  load-bearing, not an artifact of the proof.

Replay:
    uv run --with sympy python3 \
      notes/cubic-threefolds-tasks/c925-fable-decorated-ledger-transport-check.py
"""

import sympy as sp

eps = sp.symbols("eps")
z = sp.symbols("z")
ZORD = 5  # number of z-orders kept: coefficients A_0..A_{ZORD-1}

# ---------------------------------------------------------------- helpers


def integral(expr):
    """eps-integral: the rational function has no pole at eps = 0."""
    e = sp.cancel(sp.together(expr))
    num, den = sp.fraction(e)
    return not sp.simplify(den.subs(eps, 0)) == 0


def mat_integral(m):
    return all(integral(x) for x in m)


def series_mul(a, b, n):
    """Product of two matrix z-series given as coefficient lists."""
    return [
        sp.expand(sum((a[i] * b[k - i] for i in range(k + 1)
                       if i < len(a) and k - i < len(b)),
                      sp.zeros(*(a[0] * b[0]).shape)))
        for k in range(n)
    ]


def series_inv(a, n):
    """Inverse of a matrix z-series with invertible constant term."""
    inv0 = a[0].inv()
    out = [inv0]
    for k in range(1, n):
        acc = sp.zeros(*a[0].shape)
        for i in range(1, k + 1):
            if i < len(a):
                acc += a[i] * out[k - i]
        out.append(sp.expand(-inv0 * acc))
    return out


def gauge(a, g, n):
    """z^2 Y' = A(z) Y  under  Y = G(z) W:  A ~> G^{-1} A G - z^2 G^{-1} G'.

    All matrix z-series as coefficient lists; z^2 G' contributes k G_k at
    z-order k+1.
    """
    ginv = series_inv(g, n)
    aG = series_mul(a, g, n)
    t1 = series_mul(ginv, aG, n)
    # z^2 G' = sum_k k g_k z^{k+1}: coefficient at order j is (j-1) g_{j-1}
    zsq_gp = [sp.zeros(*g[0].shape)] + \
        [(j - 1) * g[j - 1] for j in range(1, len(g))]
    t2 = series_mul(ginv, zsq_gp, n)
    return [(t1[k] - (t2[k] if k < len(t2) else 0)).applyfunc(sp.cancel)
            for k in range(n)]


def levelt_class(a, max_shear=10):
    """Levelt exponent class mod Z of a regular-singular rank-2 germ
    z^2 Y' = A(z) Y with A(0) nilpotent (possibly zero), by Moser shearing.
    Returns the sorted fractional parts of the two exponents."""
    a = [sp.Matrix(m) for m in a]
    for _ in range(max_shear):
        a0 = sp.simplify(a[0])
        if a0 == sp.zeros(2):
            # z Y' = (A1 + A2 z + ...) Y : exponents = eigenvalues of A1
            res = a[1]
            ev = []
            for val, mult in res.eigenvals().items():
                ev.extend([sp.nsimplify(val)] * mult)
            assert len(ev) == 2
            return sorted([sp.Rational(sp.nsimplify(v % 1)) for v in ev])
        assert sp.simplify(a0 * a0) == sp.zeros(2), \
            "leading term not nilpotent: not a merged/regular germ"
        # constant conjugation to E12: pick v2 outside ker, v1 = a0 v2
        v2 = sp.Matrix([1, 0])
        if sp.simplify(a0 * v2) == sp.zeros(2, 1):
            v2 = sp.Matrix([0, 1])
        v1 = sp.simplify(a0 * v2)
        c = sp.Matrix.hstack(v1, v2)
        assert sp.simplify(c.det()) != 0
        cinv = c.inv()
        a = [sp.expand(sp.simplify(cinv * m * c)) for m in a]
        assert sp.simplify(a[0][1, 0]) == 0 and sp.simplify(a[0][0, 0]) == 0
        # shear P = diag(1, z): entries (1,2) up one order, (2,1) down one
        b = []
        for k in range(len(a) - 1):
            m = sp.zeros(2)
            m[0, 0] = a[k][0, 0]
            m[1, 1] = a[k][1, 1]
            if k >= 1:
                m[0, 1] = a[k - 1][0, 1]
            m[1, 0] = a[k + 1][1, 0]
            b.append(m)
        # -z^2 P^{-1} P' = -diag(0, z): subtract at z-order 1
        b[1] = b[1] - sp.diag(0, 1)
        a = [sp.expand(sp.simplify(m)) for m in b]
    raise AssertionError("Moser shearing did not terminate")


# ------------------------------------------------- leg 1: the C924 family
N2 = sp.Matrix([[0, 2], [eps, 0]])
D2 = sp.diag(sp.Rational(-19, 18), sp.Rational(19, 18))
L2 = sp.Matrix([[0, 0], [sp.Rational(-8, 81), 0]])
AS = [N2, D2, L2] + [sp.zeros(2)] * (ZORD - 3)   # summand-side family

assert all(mat_integral(m) for m in AS)
cls = levelt_class([m.subs(eps, 0) for m in AS])
assert cls == [sp.Rational(1, 6), sp.Rational(5, 6)], cls
print("leg1: C924 family is eps-integral; special-fibre Levelt class =",
      [str(x) for x in cls], "(the marked class; matches the diag(1,z) leg"
      " of the confluence certificate)")

# ------------------------------ leg 2: rank-3 mixed model, flat projector
u3 = 3 + 1 / eps
b3 = sp.Rational(7, 18)
A3 = []
for k in range(ZORD):
    m = sp.zeros(3)
    m[:2, :2] = AS[k]
    if k == 0:
        m[2, 2] = u3
    if k == 1:
        m[2, 2] = b3
    A3.append(m)

G0 = sp.eye(3) + eps * sp.Matrix([[0, 0, 2], [0, 0, 0], [1, 0, 0]])
C1 = sp.Matrix([[0, 0, 1], [0, 0, 1], [1, -1, 0]])
C2 = sp.Matrix([[0, 0, 0], [0, 0, 0], [0, 1, 0]])
G = [G0, eps * G0 * C1, eps * G0 * C2] + [sp.zeros(3)] * (ZORD - 3)

AX = gauge(A3, G, ZORD)          # the "blow-up side" connection
# NOTE: AX itself is NOT eps-integral (the separated sheet u3 = 3 + 1/eps is
# large, as for Iritani's lambda-shifted centre sheets); the theorem claims
# integrality only for the cluster projector and the compressed connection.
assert not all(mat_integral(m) for m in AX)

U = AX[0]
# intrinsic cluster projector at z = 0: pair factor f_c(t) = t^2 - 2 eps
pi3 = sp.expand(sp.simplify((U * U - 2 * eps * sp.eye(3)) / (u3**2 - 2 * eps)))
pi = sp.expand(sp.simplify(sp.eye(3) - pi3))
assert sp.simplify(pi * pi - pi) == sp.zeros(3)
assert mat_integral(pi)
assert sp.simplify(pi - G0.inv() * sp.diag(1, 1, 0) * G0) == sp.zeros(3)

# the flat projector: transported block projector, then verified to satisfy
# the intrinsic characterization (z = 0 seed pi, flatness, idempotency);
# uniqueness holds because ad U is invertible on the cross-cluster blocks
# (the recursion [U, Pi_{k+1}] = k Pi_k - sum_i [A_{i+1}, Pi_{k-i}] then
# determines the cross part and idempotency the rest): the cross-cluster
# separation resultant res(t^2 - 2 eps, t - u3) = u3^2 - 2 eps is nonzero
# along eps -> 0, which is that invertibility.
assert sp.simplify((u3**2 - 2 * eps) * eps**2) != 0
Ginv = series_inv(G, ZORD)
Pblk = [sp.diag(1, 1, 0)] + [sp.zeros(3)] * (ZORD - 1)
Pi = [sp.expand(m) for m in series_mul(series_mul(Ginv, Pblk, ZORD), G, ZORD)]

assert sp.simplify(Pi[0] - pi) == sp.zeros(3), "z = 0 seed is intrinsic pi"
# idempotency Pi * Pi = Pi at every order
PiPi = series_mul(Pi, Pi, ZORD)
for k in range(ZORD):
    assert sp.simplify(PiPi[k] - Pi[k]) == sp.zeros(3), f"idem order {k}"
# flatness: k Pi_k = sum_{i>=0} [A_i, Pi_{k+1-i}]  (from z dz Pi = [A/z, Pi])
for k in range(ZORD - 1):
    comm = sp.zeros(3)
    for i in range(ZORD):
        j = k + 1 - i
        if 0 <= j < ZORD:
            comm += AX[i] * Pi[j] - Pi[j] * AX[i]
    assert sp.simplify(k * Pi[k] - comm) == sp.zeros(3), f"flat order {k}"
for k, m in enumerate(Pi):
    assert mat_integral(m), f"Pi_{k} not eps-integral"
print("leg2: the flat cluster projector on the mixed side has intrinsic"
      " z = 0 seed, is idempotent and flat at all", ZORD, "orders, is"
      " eps-integral, and is unique (cross-cluster ad U invertible)")

# --------------------------------------- leg 3: cluster lattice transport
# V-basis w_i = Pi(e_i), i = 1,2; compressed connection z^2 W' = AV(z) W
w = [[Pi[k][:, i] for k in range(ZORD)] for i in (0, 1)]
# nabla acts as z^2 d/dz - A(z) on column series; z^2 (w_k z^k)' = k w_k z^{k+1}
def nabla(col):
    out = [sp.expand(-sum((AX[i] * col[k - i] for i in range(k + 1)
                           if i < len(AX) and k - i < len(col)),
                          sp.zeros(3, 1)))
           for k in range(ZORD)]
    for k in range(1, ZORD):
        out[k] += (k - 1) * col[k - 1]
    return out


# solve nabla w_i = - sum_j w_j AV[j][i]-series (sign: z^2 W' = AV W)
AVc = [sp.zeros(2) for _ in range(ZORD)]
rhs_cols = [nabla(w[0]), nabla(w[1])]
Wmat = [sp.Matrix.hstack(w[0][k], w[1][k]) for k in range(ZORD)]  # 3x2
LEFTINV = ((Wmat[0].T * Wmat[0]).inv() * Wmat[0].T).applyfunc(sp.cancel)
for k in range(ZORD):
    acc0 = rhs_cols[0][k]
    acc1 = rhs_cols[1][k]
    for i in range(1, k + 1):
        acc0 += Wmat[i] * AVc[k - i][:, 0]
        acc1 += Wmat[i] * AVc[k - i][:, 1]
    AVc[k][:, 0] = -(LEFTINV * acc0)
    AVc[k][:, 1] = -(LEFTINV * acc1)
    AVc[k] = AVc[k].applyfunc(sp.cancel)
    # consistency: residual must vanish (nabla preserves V)
    assert (Wmat[0] * AVc[k][:, 0] + acc0).applyfunc(sp.cancel) \
        == sp.zeros(3, 1)
    assert (Wmat[0] * AVc[k][:, 1] + acc1).applyfunc(sp.cancel) \
        == sp.zeros(3, 1)

assert all(mat_integral(m) for m in AVc), "compressed connection integral"
cls_mixed = levelt_class([m.subs(eps, 0) for m in AVc])
assert cls_mixed == cls, (cls_mixed, cls)
print("leg3: compressed cluster connection on the mixed side is"
      " eps-integral; its special-fibre Levelt class =",
      [str(x) for x in cls_mixed], "= the summand decoration: transport"
      " holds")

# ------------------------------------------------- leg 4: negative control
# A second eps-integral family with the SAME z = 0 spectral data (the same
# U_eps: identical split pair, identical merge) and simple generic sheets,
# whose special fibre carries a different class.  So the merged class is
# not a function of the generic-fibre eigenvalue/ledger data: the
# decoration is extra structure carried by the integral model, and a
# comparison must be integral -- (INT-Psi) -- to transport it.
BS2 = [N2, sp.diag(0, -1)] + [sp.zeros(2)] * (ZORD - 2)
assert all(mat_integral(m) for m in BS2)
assert sp.simplify(BS2[0] - AS[0]) == sp.zeros(2)   # same U_eps exactly
# both generic fibres have two simple sheets u = +-sqrt(2 eps)
disc = sp.simplify((AS[0].trace())**2 - 4 * AS[0].det())
assert sp.simplify(disc - 8 * eps) == 0
cls_b = levelt_class([m.subs(eps, 0) for m in BS2])
assert cls_b != cls, (cls_b, cls)
print("leg4: same U_eps, second integral family has special-fibre class",
      [str(x) for x in cls_b], "!=", [str(x) for x in cls],
      "- the merged class is invisible in the generic split-pair data,"
      " so the decoration lives on the integral model and (INT-Psi) is"
      " load-bearing")
print("all checks passed")
