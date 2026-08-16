#!/usr/bin/env python3
"""The discriminant identity behind the cubic zero-atom non-splitting lemma.

Replay:
    uv run --with sympy python3 notes/scripts/c912_fmanifold_discriminant_identity.py

Context (C912, cubic-threefolds lane).  On a regular F-manifold with Euler field
`E`, put `U = C_E`, let `X_s = E^{o s}` be the canonical frame (`X_0 = e`), and
let `P(z) = z^n + sum_k lam_k z^k` be the characteristic polynomial of `U`.
David-Hertling (arXiv:1411.4553, (19), (20), (24), (25)) derive `X_s(lam_k)`
from the Witt identities `[X_i, X_j] = (j-i) X_{i+j-1}` and Cayley-Hamilton.

This script checks two things.

(a) Those four formulas are exactly the statement that `X_s` acts on the
    eigenvalues by `mu_i |-> mu_i^s`, i.e. that `X_s` induces the derivation
    `D_s = sum_i mu_i^s d/d mu_i` on the coefficients.  Checked by substituting
    the generic root parametrisation, which proves the polynomial identity in
    the `lam_k` because `lam <-> elementary symmetric functions of mu` is an
    isomorphism.

(b) The discriminant `Delta` of `P` satisfies `X_s(Delta) = c_s Delta` for every
    `s < n`, with `c_s` a polynomial in the `lam_k`:

        c_0 = 0,   c_1 = n(n-1),   c_2 = -2(n-1) lam_{n-1},
        c_3 = 2(n-1) lam_{n-1}^2 - (4n-6) lam_{n-2}.

    Consequently `dDelta = Delta . omega` for an analytic one-form `omega`, and a
    regular point where `U` has a repeated eigenvalue forces `Delta = 0` on the
    whole germ: if `Delta_m` is the lowest nonzero homogeneous part of `Delta` in
    the completed local ring, comparing lowest degrees gives `dDelta_m = 0`,
    hence `m Delta_m = 0` by Euler's relation, hence `Delta_m = 0` in
    characteristic zero.

`n = 4` is the case the cubic threefold needs -- the Hodge-invariant sector
`H^0 + H^2 + H^4 + H^6` -- and `s <= 3` is exactly the range David-Hertling
publish, so no unpublished extension of their computation is required.
"""

import itertools

import sympy as sp


def check(n, verbose=True):
    mu = sp.symbols(f"mu0:{n}")
    lam_sym = sp.symbols(f"lam0:{n}")
    z = sp.Symbol("z")
    P = sp.expand(sp.prod([z - m for m in mu]))
    lam = [sp.expand(P.coeff(z, k)) for k in range(n)]  # P = z^n + sum lam_k z^k

    def L(k):  # lam_n = 1; lam_k = 0 for k < 0
        if k < 0 or k > n:
            return sp.Integer(0)
        return sp.Integer(1) if k == n else lam[k]

    def D(s, f):
        return sp.expand(sum(m ** s * sp.diff(f, m) for m in mu))

    dh = {
        0: lambda k: -(k + 1) * L(k + 1),
        1: lambda k: (n - k) * L(k),
        2: lambda k: -L(n - 1) * L(k) + (n - k + 1) * L(k - 1),
        3: lambda k: ((L(n - 1) ** 2 - 2 * L(n - 2)) * L(k)
                      + (n - k + 2) * L(k - 2) - L(n - 1) * L(k - 1)),
    }
    for s in range(min(4, n)):
        for k in range(n):
            assert sp.expand(D(s, lam[k]) - dh[s](k)) == 0, \
                f"David-Hertling formula fails at n={n}, s={s}, k={k}"

    Delta = sp.expand(sp.prod([(mu[i] - mu[j]) ** 2
                               for i, j in itertools.combinations(range(n), 2)]))
    closed = {
        0: sp.Integer(0),
        1: sp.Integer(n * (n - 1)),
        2: -2 * (n - 1) * L(n - 1),
        3: 2 * (n - 1) * L(n - 1) ** 2 - (4 * n - 6) * L(n - 2),
    }
    for s in range(n):
        assert s < 4, "closed form only recorded for s <= 3"
        assert sp.expand(D(s, Delta) - closed[s] * Delta) == 0, \
            f"discriminant identity fails at n={n}, s={s}"

    if verbose:
        shown = {s: closed[s].subs(dict(zip(lam, lam_sym))) for s in range(n)}
        print(f"n = {n}:  David-Hertling (19),(20),(24),(25) = the derivation "
              f"mu_i -> mu_i^s.  OK")
        print(f"          X_s(Delta) = c_s . Delta for all s < n, with "
              f"c_s = { {s: sp.simplify(v) for s, v in shown.items()} }")


for n in (2, 3, 4):
    check(n)

# The cubic threefold at the small quantum point: the quartic really is degenerate.
q, T = sp.symbols("q T", positive=True)
chi = sp.expand(T ** 2 * (T ** 2 - 108 * q))
assert sp.discriminant(sp.Poly(chi, T)) == 0
assert len(sp.roots(sp.Poly(chi, T))) == 3
print("\ncubic threefold at the small point: chi = T^2 (T^2 - 108 q), "
      "discriminant 0, three distinct eigenvalues.  OK")
