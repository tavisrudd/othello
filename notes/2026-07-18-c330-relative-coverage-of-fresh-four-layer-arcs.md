# C330: constant-height four-layer arcs have an infinity-direction obstruction

**Lane:** `relconic`

**Date:** 2026-07-18

**Status:** complete. C329's collision-free four-layer family is not
`C`-complete: at least `Q^2-7Q+2` required points on the line at infinity are
uncovered. The obstruction holds on the entire constant-height `E4` family,
including the generic `Delta_R!=0` fallback, before imposing C329's six trace
conditions or pentic derangement conditions.

## Theorem

Let `F=GF(Q)`, let `E/F` be the quadratic extension, and put

    P(x,k)=[1:x:x^2+k] in PG(2,E).

Consider any four-layer member of C315's constant-height `E4` survivor. Thus,
with `omega^2+omega+1=0`, its layers are

    R_1={P(omega+r,H):r in F},
    R_2={P(rho*omega+r,H+Delta_R):r in F},
    S_alpha={P(r,H+Gamma_alpha):r in F},
    S_beta ={P(r,H+Gamma_beta ):r in F},                 (1)

where `rho notin {0,1}` and `Gamma_alpha+Gamma_beta notin F`.
Let `A` be their union.  If `D_fin(A) subset E` denotes the set of finite
directions `m` for which the point `[0:1:m]` lies on a secant of `A`, then

    D_fin(A) = F^*
      union {p+Delta_R/p : p in d*omega+F}
      union {p+Gamma_alpha/p : p in omega+F}
      union {p+Gamma_beta /p : p in omega+F}
      union {p+(Delta_R+Gamma_alpha)/p : p in rho*omega+F}
      union {p+(Delta_R+Gamma_beta )/p : p in rho*omega+F}
      union {p+(Gamma_alpha+Gamma_beta)/p : p in F^*},   (2)

where `d=1+rho`.  In particular,

    |D_fin(A)| <= (Q-1)+Q+4Q+(Q-1)=7Q-2.               (3)

The line at infinity has the `Q^2` nonconic points `[0:1:m]`, `m in E`.
Consequently the exact uncovered infinity carrier is

    U_infinity(A)={[0:1:m] : m in E\D_fin(A)},           (4)

and

    |U_infinity(A)|=Q^2-|D_fin(A)| >= Q^2-7Q+2.         (5)

This is positive for every `Q>=8`, hence in particular throughout C329's
odd-tower range `Q>=2^45`.  Therefore no member supplied by C329 is
`C`-complete, despite being an arc of size `4Q=4*sqrt(q)` in the plane of
order `q=Q^2`.

## Secant-direction calculation

For two affine points from (1), write

    x=e_i*omega+r,       y=e_j*omega+s,
    k_i,k_j for their constant heights,
    p=x+y=(e_i+e_j)*omega+(r+s).

Their difference vector is

    [0:p:p^2+k_i+k_j].                                  (6)

If `p!=0`, the secant therefore meets the line at infinity at

    [0:1:p+(k_i+k_j)/p].                                (7)

For a fixed unordered pair of layers, `p` ranges over one affine `F`-line,
so that pair produces at most `Q` directions.  Within any one layer the two
heights agree and distinctness gives `p in F^*`; all four within-layer pair
types therefore have the same direction set `F^*`, of size `Q-1`.

For `R_1,R_2`, equation (7) gives the `Delta_R` reciprocal image of
`d*omega+F`. The four repair--seed pairs give the next four reciprocal images
in (2). For `S_alpha,S_beta`, nonzero
`p in F` gives the last image in (2).  When their parameters agree, `p=0`
and `Gamma_alpha+Gamma_beta!=0`, so their secant has direction

    C_infinity=[0:0:1].                                 (8)

This is the unique point of the prescribed conic

    C={P(c,0):c in E} union {C_infinity}

on the line at infinity.  Thus (2) is an equality, not merely a list of
possible finite directions, and subtracting the conic direction gives (3)--(5).
The common height `H` cancels from every height difference, so the obstruction
is independent of C329's final choice of `H`. On C329's `Delta_R=0` slice,
the second image in (2) reduces to `d*omega+F` and the two repair-layer images
reduce to the displayed C329 forms. The same count for arbitrary `Delta_R`
closes the generic fallback named in the original C330 exit gate.

## Relative-coverage convention and task boundary

For the relative-conic problem, `C`-completeness means that every point of

    PG(2,E) \ (A union C)

lies on an `A`-secant; points of the prescribed conic are the allowed holes.
The C330 queue wording asked for secants through the prescribed-conic points,
but that is not the coverage gate in the paper's definition.  Equation (8)
does show that the conic's point at infinity is covered, while (4) exhibits an
entire required carrier outside the conic that is not.  No calculation on the
remaining conic points can repair this failure.

The negative conclusion is architecture-specific. It applies to four full
constant-height `F`-carrier layers (and hence to C329's exact
six-trace/pentic-derangement survivor); it is not a lower bound for arbitrary
`C`-complete arcs and not a global obstruction to `O(sqrt(q))` constructions
using more carriers or nonconstant layer heights.

## Evidence boundary

This is a proof-only result.  Equations (6)--(8) are direct projective
coordinate identities, and (2) is the exhaustive ten pair-type audit reduced
to seven direction images.  No symbolic computation, field census, random
sample, or generated artifact supports the theorem.

The trusted inputs are C315's exact `E4` layer form, C316's `Delta_R=0`
specialization, C329's simultaneous collision-free existence theorem, and the
relative-completeness definition in
`papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`.

## Vibe check

Decisive negative for this architecture.  The collision problem was solved,
but constant-height one-dimensional carriers compress all secants into only
`O(Q)` directions at infinity, leaving `Theta(Q^2)` required points uncovered.
The route cannot yield a `C`-complete construction without changing the layer
geometry.
