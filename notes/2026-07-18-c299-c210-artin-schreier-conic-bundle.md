# C299: characteristic-two gauge and Artin--Schreier exposition for the bounded layered-arc manuscript

**Lane:** `relconic`

**Date:** 2026-07-18

**Status:** complete drafting support. This report supplies a manuscript-ready formulation of the
characteristic-two gauge and the two Artin--Schreier reductions used in the C210 mechanism
obstruction. It introduces no new theorem or computation. In the bounded Paper II scope, C329's
fresh-field family is a family of collision-free four-layer arcs, not a family of `C`-complete
arcs: C330 leaves at least `Q^2-7Q+2` required points at infinity uncovered.

## Recommended manuscript formulation

Work over `k=GF(2^n)` with `n` odd. The quadratic extension may be written
`E=k(omega)`, where `omega^2+omega+1=0`; replacing `omega` by `omega+1` is an equation gauge, not
an additional projective symmetry. For the standard conic, the projectivities preserving the
marked parallel-layer presentation are

    [X:Y:Z] -> [X, lambda*Y+mu*X, lambda^2*Z+mu^2*X],
    lambda in k^*, mu in k.                                      (1)

Thus horizontal quantities have weight one and height quantities have weight two. Weighted
normalizations such as `p=1` are genuine projective equivalences only when the seed data move with
the configuration. With a fixed seed pair they are merely lossless collision charts. Changes of
coset representative, multiplication of a resultant by a unit, and `omega -> omega+1` belong to
the equation/parameterization gauge; seed or repair interchange is relabeling; Frobenius gives a
semilinear, generally not projective, equivalence. Keeping these operations separate prevents a
collision-resultant symmetry from being promoted incorrectly to a moduli quotient.

On the generic C210 chart put

    theta = w^2+w+1,                     N = a^2+a+1,
    Q = u^2+u*delta+delta^2,
    G1 = u^2+u*p+p^2*theta,
    G2a = u^3+u^2*delta+u*p^2*theta+delta*p^2*theta
          +delta^2*p+delta*a*G1.                              (2)

The collision cover has `t`-degree four. After the weighted depression
`tau=a*Q*t`, define

    psi = tau^2+b*Q*tau,
    sigma = a*delta*N*G1*G2a,
    R1 = a^2*Q^2*B0.                                         (3)

The entire quartic is then

    F = psi^2+sigma*psi+R1.                                  (4)

This identity is the useful characteristic-two normal form. The cubic resolvent factors as

    (X+b*Q)*(X^2+b*Q*X+sigma),                               (5)

and the second factor has no rational root on `a*delta*N*b!=0`: its putative
Artin--Schreier class has an odd-degree polynomial part. A linear factor of `F` likewise pairs
with one of the same slope `bQ`. Consequently every generic factorization is governed by the
single class

    [R1/sigma^2] in k(params)(u) / {g^2+g}.                  (6)

This replaces a case split among quartic factorization types by one Artin--Schreier residue
calculation.

## Residue lemma in the form needed by the proof

Assume

    a*delta*N*b*p != 0.                                     (7)

At the roots of `G1` the residues of (6) vanish identically. Reduction at the roots of `G2a`
leaves three conditions

    c_i=h0*A_i+B_i=0,    i=0,1,2,                           (8)

which are independent of `h1`. Over every odd-degree extension of `GF(2)`, their solution set is
exactly the following union:

1. `e=0`, `h0=0`;
2. `e=delta`,
   `h0=p^2*theta+e^2+e*b+e*a*p`;
3. `delta=p`, `w in {0,1}`,
   `h0=e^2*a^2+e*a^2*p+e*a*p+e^2+e*b+e*p`.

For a short proof of completeness, form the three cross-determinants of (8), remove the already
displayed nonzero factors, and normalize by `p=1`, writing `d=delta/p`. If `I` is the residual
ideal in `GF(2)[a,d,w]`, the exact memberships

    (N*theta*(d+1))^6 in I,
    (N*theta*w*(w+1))^6 in I                               (9)

show that every solution away from `e=0,e=delta` has `d=1` and `w(w+1)=0`. Indeed, `N` and
`theta` split over `GF(4)` and have no root over an odd-degree extension of `GF(2)`. The possible
all-`A_i` loophole is excluded on the first two branches by

    (d*N*theta)^7 in I_A,                                  (10)

where `I_A` is the normalized coefficient ideal; on the third branch one has directly
`A0=p^14*N^5`. Hence (8) also forces the displayed values of `h0`. This radical implication is
all that the manuscript needs; no primary decomposition or finite-field census enters the
infinite-family proof.

On each branch there is a polynomial `A=a*Q^2*L` such that

    F=(psi+A)*(psi+A+sigma).                               (11)

The corresponding `L` is

| branch | `L` |
|---|---|
| 1 | `h1` |
| 2 | `a*p^2*theta+delta*a*p+delta^2+delta*b+delta*p+h1` |
| 3 | `h1+e*b+e*N*(u+p+(a+1)*e)` |

These are polynomial identities over `GF(2)`, including separate direct checks at `w=0` and
`w=1`; no pole denominator is being suppressed. In the original cover they read, with
`T=a*t^2+b*t+L`,

    R=T*(Q^2*T+delta*N*G1*G2a).                            (12)

## Why factorization is not yet a collision

Equation (11) produces two second-layer equations

    tau^2+b*Q*tau+A=0,
    tau^2+b*Q*tau+A+sigma=0.                               (13)

Because `Q` has no `k`-rational root when `[k:GF(2)]` is odd, division by `(bQ)^2` converts these
to `x^2+x=chi_i`. On branches 1 and 2 one class is constant and the other is a rational function
with a nonzero simple pole at infinity; after Artin--Schreier reduction its normalization has
genus zero or two. Hasse--Weil supplies an affine point for every odd-tower field of size at
least `512`, and the remaining field `GF(8)` is covered by the committed exact census. On branch
3 the classes reduce directly to affine-linear functions of `u`, so one component is rational
over every field in the tower. Reconstruction and deletion estimates then turn these roots into
genuine collisions: branches 1 and 2 retain at least `q-4*sqrt(q)-6` genuine points, and branch 3
at least `q-2`.

This order of argument should be preserved in the manuscript:

    quartic normal form -> residue completeness -> exact split
        -> second-layer rational points -> reconstruction/genuineness.       (14)

Factorization alone proves neither a rational point nor a genuine projective collision.

## Manuscript boundary

The C210 conclusion is a bounded obstruction for its two-repair-coset mechanism, not a global
nonexistence theorem for `C`-complete `O(sqrt(q))` arcs. The later constant-height `E4` family does
produce, with fresh coefficients in each field, collision-free arcs of size `4Q` in
`PG(2,Q^2)` for odd `Q>=2^45`. But its finite directions number at most `7Q-2`, so at least
`Q^2-7Q+2` required nonconic points at infinity are uncovered. It must therefore be described as
a collision-free layered family that fails relative coverage, never as the sought square-root
`C`-complete construction.

## Provenance and evidence boundary

This is an expository synthesis of previously closed results. The load-bearing exact identities,
ideal memberships, finite check, and replay commands remain in:

- `2026-07-17-c210-a-nonzero-artin-schreier-form.md`;
- `2026-07-17-c210-a-nonzero-dAS-arithmetic-completeness.md`;
- `2026-07-17-c210-a-nonzero-exact-splits.md`;
- `2026-07-17-c210-a-nonzero-second-layer.md`;
- `2026-07-18-c210-a-nonzero-genuineness.md`;
- `2026-07-18-c297-c210-normal-form-moduli.md`;
- `2026-07-18-c329-fresh-field-four-layer-arc-existence.md`; and
- `2026-07-18-c330-relative-coverage-of-fresh-four-layer-arcs.md`.

No new computational claim is made here, so C299 has no separate generator or certificate. The
trusted boundary is exactly that of the cited atomic evidence bundles and the classical
Artin--Schreier and Hasse--Weil results cited there.
