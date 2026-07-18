# C315: constant-`p` seed legality has one exact survivor chart

**Lane**: `relconic`

**Date:** 2026-07-18

**Status:** complete; exports the `E4` survivor base and every arithmetic/open boundary to C316.

## Result

Let `F=GF(2^n)` with `n` odd and `|F|=Q>=32`, let

    E=F(omega),                 omega^2+omega+1=0,

and take the marked constant-`p` family and quotient atlas of C314.  Then all eight C312
seed--repair safety conditions hold if and only if

    c=1,              K=1,              B=0,             (1)

and the four constant pair-sum trace conditions in (17) below hold.  Thus the unequal-curvature
chart `U` and the equal-curvature charts `E0`--`E3` have no survivor.  The entire survivor is the
explicit arithmetic open inside `E4`; in particular it is nonempty and has coarse marked-moduli
dimension nine.

Condition (1) says

    K_1=K_2=1,        A_1=A_2=0,        B_1=B_2=0.        (2)

It is not the old C210 slice: it is the zero-quadratic, zero-linear boundary of that slice.  The
repair graphs have constant heights, but their affine supports remain the two distinct cosets
`omega+F` and `rho*omega+F`.

This is a seed-legality theorem only.  It makes no collision, height-image, relative-coverage, or
`C`-completeness claim.

## Packet notation

For one repair layer put `v=e*omega`, with `e in F^*`, and write

    K=k_0+k_1*omega,    B=b_0+b_1*omega.

For a seed height `gamma`, set

    Z_gamma=C+gamma+v^2=q_gamma+e*r_gamma*omega,

so that `r_gamma=lambda_v(Z_gamma)` and `q_gamma=mu_v(Z_gamma)` in C312's notation.  The `SR`
pair-sum polynomial is

    p_SR(X)=(k_1/e)*X^2+(b_1/e)*X+r_gamma.               (3)

The `RS` packet is defined because internal repair legality gives `K!=0`.  Safety always means
C312's exact condition: at every `z in F`, either `p(z)=0`, or the forced same-layer quadratic is
nonsplit.

## Nonconstant trace classes are obstructed

The following small lemma is the only point-supply input.

**Lemma 1.**  Suppose a C312 packet has nonconstant reduced Artin--Schreier class.  If `Q>=32`,
then it is not safe.

Indeed, C312's pole classification gives genus at most one: a squarefree quadratic denominator
has at most two reduced simple poles, an inseparable quadratic has at most one pole of order three,
and a linear denominator has at most one simple pole.  An odd reduced pole makes the cover
geometrically integral with constant field `F`.  Its normalization therefore has at least

    Q+1-2*sqrt(Q)

`F`-points.  At most two rational points lie above roots of `p`, and at most two lie above
infinity.  Since `Q+1-2*sqrt(Q)>4` for `Q>=32`, an affine point remains over some `z` with
`p(z)!=0`; it gives trace zero and hence an illegal distinct pair.

If a quadratic `p` has all finite poles cancelled, its reduced class is zero: for a squarefree
quadratic the cancelling partial fractions tend to zero at infinity, and for an inseparable
quadratic this is C312 (14).  It is again obstructed.  Consequently a safe packet must have

    k_1=0,                                                (4)

so `K in F`.  This conclusion applies separately to every one of the eight packets.

The bound is deliberately stated as `Q>=32`.  It includes the infinite tail `Q>=512` used by the
relconic program.  This report does not classify the isolated bounded field `Q=8`.

## The linear pair-sum stratum cannot satisfy both orientations

Assume now `K in F`, put `K=s^2`, and write

    B=b_0+m*e*omega,          m=lambda_v(B).

Suppose `m!=0`.  For the `SR` packet, cancellation of the unique finite pole is necessary by
Lemma 1.  Direct substitution into C312's linear-denominator formula gives

    (K+1)*r^2+m*b_0*r+m^2*q+b_0^2=0,                    (5)

where `(r,q)=(r_gamma,q_gamma)`.  Its reduced constant is

    h_SR=(K+m)/m^2.                                     (6)

For the reverse packet, the pair-sum slope is `m/K`, its root is
`(r+b_0+m*e)/m`, and the same calculation gives a second cancellation equation.  Adding that
equation to (5) leaves

    b_0^2+m*e*b_0+m*e^2*(1+K+m)=0.                      (7)

The reverse reduced constant is

    h_RS=K*(1+m)/m^2.                                   (8)

Put `t=b_0/(m*e)`.  Equation (7) is

    t^2+t=(1+K+m)/m,

and hence, because `n` is odd,

    Tr((1+K)/m)=1.                                      (9)

But simultaneous safety of the two cancelled packets requires
`Tr(h_SR)=Tr(h_RS)=1`.  Adding these two trace equations gives

    Tr((1+K)/m)=0,                                      (10)

contradicting (9).  Therefore `m=0`, so

    B in F.                                              (11)

This argument is packetwise and does not use the second seed.  It also explains the minimal
orientation obstruction on the only potentially safe nonconstant pair-sum stratum: pole
cancellation forces (9), while the two constant trace-one classes force (10).

## Two seed heights force `K=1` and `B=0`

With `K=s^2 in F` and `B in F`, both pair-sum polynomials are constant.  For a fixed seed height
write `(r,q)=(r_gamma,q_gamma)`.  C312's constant-denominator formula gives the exact joint
`SR`/`RS` criterion

    B=r*(s+1),
    and either r=0 or Tr(q/r^2)=1.                       (12)

When `r=0`, the reverse orientation is safe only when `B=0`; this is also (12).  When `r!=0`, the
reverse pair sum is `r/s`, and its constant trace class is the same `q/r^2`, so (12) is sufficient
as well as necessary.

For the two seed heights, `r_alpha+r_beta=lambda_v(alpha+beta)!=0`, because
`alpha+beta notin F`.  Applying the first equation of (12) twice gives

    (r_alpha+r_beta)*(s+1)=0.

Thus `s=1`, hence `K=1`, and then (12) gives `B=0`.  Applying this conclusion to both repair
layers and using C314 reconstruction gives exactly (1): from `K_1=1` and `B_1=0` one gets
`K=1,B=0`, while `K_2=c*K=1` forces `c=1` (and then `ell=0`).

This closes every coefficient stratum.  There is no unexamined pole-cancellation divisor.

## Explicit `E4` survivor base

Retain C314's normalized parameters

    rho in F^*\{1},     d=1+rho,       P0 in F^*,
    theta=w^2+w+1,      Tr(theta)=1,   w~w+1,             (13)

and write `C=C_0+C_1*omega`.  On (1), reconstruction is

    C_1^rep=C,
    C_2^rep=C+d^2*omega^2+P0^2*theta+d*P0*omega.         (14)

For a prospective seed height `gamma=gamma_0+gamma_1*omega`, define

    X_gamma=(C_1+gamma_1+1)/P0,
    Y_gamma=(C_0+gamma_0+1)/P0^2.                        (15)

The layer-one pair-sum/product constants are `P0*X_gamma` and `P0^2*Y_gamma`; those for layer two
are

    P0*(X_gamma+d)/rho,       P0^2*(Y_gamma+theta).       (16)

Therefore `gamma` is safe against both repair layers and both orientations if and only if

    X_gamma=0
      or Tr(Y_gamma/X_gamma^2)=1,

    X_gamma=d
      or Tr(rho^2*(Y_gamma+theta)/(X_gamma+d)^2)=1.       (17)

The alternatives with zero denominator mean repeated root, exactly as in C312; no quotient by
zero is intended.

Let `T_rho,theta` be the subset of `F^2` defined by (17).  It has the exact fiber description

| `X` | condition on `Y` | number of `Y` |
|---|---|---:|
| `0` | `Tr(rho^2*(Y+theta)/d^2)=1` | `Q/2` |
| `d` | `Tr(Y/d^2)=1` | `Q/2` |
| `1` | incompatible trace equations | `0` |
| `F\{0,d,1}` | two independent affine trace equations | `Q/4` |

At `X=1`, the two trace functionals have the same linear part, while their constants differ by
`Tr(theta)=1`; this is the minimal constant-p seed obstruction.  Away from `X=1`, the two linear
parts coincide only if `(X+d)=rho*X`, which again forces `X=1`.  Hence

    |T_rho,theta|=Q*(Q+1)/4.                             (18)

The actual ordered two-seed survivor is obtained by choosing

    (X_alpha,Y_alpha),(X_beta,Y_beta) in T_rho,theta,
    X_alpha!=X_beta,                                    (19)

using (15) to reconstruct `alpha,beta`, and deleting `alpha=0` and `beta=0`.  The inequality in
(19) is exactly `alpha+beta notin F`.  Since every permitted `X` has at least `Q/4` choices of
`Y`, this set is nonempty for `Q>=32`, even after the two zero-height deletions.

If pointwise avoidance of the prescribed conic is required, one must additionally delete

    C=0,          C+d^2*omega^2+P0^2*theta+d*P0*omega=0. (20)

These are exactly `C_1^rep=0` and `C_2^rep=0`, because both repair graphs are constant.  No other
conic-avoidance resultant remains.

## Component, dimension, and degeneracy table

| Atlas stratum | Internal repair | both orientations | both seeds | distinctness | prescribed-conic avoidance | verdict |
|---|---|---|---|---|---|---|
| `U`, `c!=1` | open `K*c!=0` | forces `K_i in F`, `B_i in F` | forces `K_1=K_2=1`, impossible with `c!=1` | C314 opens | separate | empty |
| `E0` | open | same | forces `K=1,B=0`, contradicting `Delta!=0` | C314 opens | separate | empty |
| `E1` | open | same | forces `K=1`, contradicting `A!=0` | C314 opens | separate | empty |
| `E2` | open | same | forces `K=1`, contradicting `A!=0` | C314 opens | separate | empty |
| `E3` | `K=1` | forces `B in F` | forces `B=0`, contradicting `B!=0` | C314 opens | separate | empty |
| `E4` | automatic | constant classes (12) | exactly (17)--(19) | `rho*(rho+1)*P0!=0`, `alpha*beta!=0`, `X_alpha!=X_beta` | exactly (20) | nonempty |

Before quotienting translation, the normalized constant-`p` family has dimension fourteen.
Equations `c=1`, `K=1`, and `B=0` have codimension `1+2+2=5`, so the survivor stratum has
dimension nine.  Translation acts trivially on `E4`, giving stabilizer dimension one.  Thus its
coarse marked orbit locus still has dimension nine, while its quotient-stack dimension is eight.
The generic coarse quotient has dimension thirteen, so the `E4` image has coarse codimension four.
The finite-index absolute-trace conditions (17) do not change this asymptotic parameter dimension:
(18) gives `Theta(Q^2)` choices per seed and hence `Theta(Q^9)` marked survivor tuples before the
listed finite quotients and deletions.

The allowed conic coincidences and packet repeated-root loci must be retained as marked
degeneracies for C316 rather than silently deleted:

- the repair conics coincide exactly when `P0=d` and `w in {0,1}`;
- repair conic 1 equals seed conic `gamma` exactly when `Gamma_gamma=0`, and repair conic 2 equals
  it exactly when `Gamma_gamma=Delta_R`, where `Gamma_gamma=gamma+C` and
  `Delta_R=C_2+C`;
- the layer-one packet is identically repeated-root at `(X_gamma,Y_gamma)=(0,0)`, equivalently
  `Gamma_gamma=omega^2`, while the layer-two packet is identically repeated-root at
  `(X_gamma,Y_gamma)=(d,theta)`, equivalently
  `Gamma_gamma=Delta_R+rho^2*omega^2`.

The last two loci are compatible with (17) precisely because the displayed repeated-root
alternative applies.  They are packet degeneracies, not conic coincidences.

## Quotient and overlap audit

C314's six atlas rows are disjoint, so the component table has no missing chart overlap.  Its
residual `w~w+1` gauge fixes `theta` and hence (14)--(20).  Seed interchange swaps the two points
in (19).  Repair interchange sends `rho` to `rho^-1`, re-sections `C` by C314 (24), and exchanges
the two lines of (17); it therefore preserves the survivor base.  Relative conjugation and every
allowed semilinear automorphism preserve zero, absolute trace, and the reconstruction equations.

The additive projective stabilizer of `E4` acts trivially on `C`, as C314 already proves.  It is a
stabilizer, not an omitted orbit identification.  Hence the dimension statement above and the
finite relabeling quotient neither duplicate nor omit a component.

## C316 interface

C316 should use exactly the following base, without re-solving seed legality:

1. the `E4` reconstruction (13)--(14), with coefficients (2);
2. two ordered points of `T_rho,theta` satisfying (19), reconstructed by (15);
3. the opens `rho*(rho+1)*P0*alpha*beta!=0` and `X_alpha!=X_beta`;
4. the two prescribed-conic deletions (20), when that avoidance is imposed;
5. the conic-coincidence and packet repeated-root loci listed above as explicit, allowed rank
   boundaries; and
6. the `w` gauge, seed/repair relabelings, semilinear action, and additive `E4` stabilizer kept as
   four distinct quotient data.

There is no constant-`p` incidence base on `U` or `E0`--`E3`.  C316 must audit its collision and
height map directly on this constant-height survivor; C305's two-height generic presentation is
not inherited automatically.

## Evidence boundary

This is a proof-only result.  The coefficient reductions (3)--(12) are direct applications of
C312's packet formulas and pole classification; (13)--(20) are substitutions into C314's exact
reconstruction.  The only curve estimate is the displayed genus-at-most-one Hasse--Weil bound.
No CAS decomposition, coefficient sample, or finite-field census is used.

## Bounded remainder and vibe check

The theorem closes every C314 chart uniformly for the odd-degree tail `Q>=32`, including the
program's `Q>=512` range.  The isolated `Q=8` packet system remains outside this theorem; it is a
bounded arithmetic question and is not evidence against the positive-dimensional tail survivor.

Vibe check: good and clarifying.  The thirteen-dimensional omitted family does not survive
generically, but seed legality is not empty: it collapses cleanly to a nine-dimensional
constant-height boundary with an exact quarter-density arithmetic seed fiber.  C316 now has a
small genuine base instead of an uncontrolled coefficient atlas.
