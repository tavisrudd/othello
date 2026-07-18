# C327: correlated degree-five factorization before C299

**Lane:** `relconic`

**Date:** 2026-07-18

**Status:** active; theorem-led analysis of C316's two seed--seed--repair eliminants, with no large
field or coefficient census.  The first common pentic normal form and shared branch identity are
proved below.

## Objective

Determine whether C315's trace-defined `E4` survivor contains a simultaneous no-linear-factor
locus for the two degree-five seed--seed--repair eliminants.  Prove the strongest structural
alternative available before C299:

1. a positive-density or explicit positive-dimensional simultaneous no-root locus;
2. an exact incompatibility or forced-linear-factor theorem; or
3. a bounded mixed result isolating the unresolved monodromy, trace-slice, or exceptional strata.

This task does not solve the two degree-six gates or relative coverage in full.  It must formulate
their first exact consumer interface if the degree-five pair survives.

## Closed inputs

- C315 supplies the survivor coordinates `(rho,P0,w,Gamma_alpha,Gamma_beta,H)`, the single-seed
  safe set `T_{rho,theta}` of size `Q(Q+1)/4`, the ordered-pair condition
  `X_alpha!=X_beta`, and every zero-height/conic deletion.
- C316 supplies, for repair layer `i`, the degree-five eliminant

      E_i(p)=N_i^2*p+e_i^2*delta_1^2*p
        +(p^2+delta_0)*N_i*delta_1+e_i*delta_1^3
        +Z_{i,0}*delta_1^2*p,

  where

      N_i=e_i*p^2+(Z_{i,1}+e_i^2)*p+e_i*(delta_0+delta_1),
      Delta_S=Gamma_alpha+Gamma_beta=delta_0+delta_1*omega,
      Z_i=Gamma_alpha+Delta_i,
      e_1=1,       e_2=rho,       Delta_1=0,       Delta_2=Delta_R.

  It proves `delta_1!=0`, `E_i(0)!=0`, leading coefficient `e_i^2`, and exact reconstruction
  `a=N_i/delta_1`.
- C317 proves that no-root factor types are exactly `(5)` and `(3,2)`, and separates the fixed
  scalar-tower obstruction from the fresh-per-field problem.

Do not re-solve C312's packets, C314's atlas, or C315's legality classification.

## Required theorem package

1. Put both `E_i` in a common invariant coefficient form over the generic survivor base.
2. Prove generic separability and irreducibility, or classify the exact factorization divisor.
3. Determine the generic arithmetic/geometric monodromy groups or a resolvent-level substitute
   sufficient to control the presence of linear factors.
4. Determine whether the two splitting fields share a nontrivial resolvent or forced Frobenius
   invariant.
5. Geometrize C315's absolute-trace conditions through explicit Artin--Schreier covers, with actual
   constant fields audited before any Chebotarev or density statement.
6. Close or isolate `Delta_R=0`, packet repeated-root targets, repair--seed conic coincidences,
   branch loci, and the ordered-seed deletion.
7. If simultaneous no-root survives, state the exact degree-six and relative-coverage consumer
   interface.  Do not infer coverage from collision-freeness.

## Guardrails and stop conditions

- No raw coefficient census, full-field enumeration, or `Q=512` run.
- Tiny-field probes may guide conjectures but are not theorem evidence.
- Any load-bearing symbolic calculation must be a compact, deterministic, git-visible identity,
  resolvent, factorization certificate, or independently checkable output.
- Generic monodromy alone is insufficient: the trace-defined arithmetic slice and correlations
  between `E_1,E_2` must be controlled.
- Stop with a bounded mixed theorem if the trace-slice step requires substantially new machinery;
  name the exact missing hypothesis rather than invoking Chebotarev heuristically.

## First attack

1. Expand `E_i` only far enough to expose its five invariant coefficients and the relation between
   the `e=1,Z=Gamma_alpha` and `e=rho,Z=Gamma_alpha+Delta_R` cases.
2. Compute derivative, discriminant/branch information, and low-degree resolvents symbolically.
3. Search for an exact coefficient transformation relating `E_1` and `E_2`; prove or reject each
   candidate directly.
4. Choose a minimal specialization over a rational function field that can certify a lower bound
   on generic monodromy without a field census.
5. Pull the trace conditions back only after the ambient algebraic relation is understood.

## First result: common pentic normal form

Put

    A_i=Z_{i,1}+e_i^2,
    M=Nm(Delta_S)=delta_0^2+delta_0*delta_1+delta_1^2.

Direct expansion of C316 (31) in characteristic two gives

    E_i(p)=e_i^2*p^5+e_i*delta_1*p^4
      +A_i*(A_i+delta_1)*p^3+e_i*delta_1^2*p^2
      +(e_i^2*delta_0^2+A_i*delta_0*delta_1
        +Z_{i,0}*delta_1^2)*p
      +e_i*delta_1*M.                                  (1)

Thus the target dependence is confined to the `p^3` and `p` coefficients after `(e_i,Delta_S)`
is fixed.  The source-branch quartic is common to the two repair orientations:

    B(p)=p^4+delta_1*p^2+M.                             (2)

Differentiating (1) and adding it back after multiplication by `p` gives the exact identity

    p*E_i'(p)+E_i(p)=e_i*delta_1*B(p).                  (3)

Since `e_i*delta_1*p!=0` on every collision fiber, a root of `E_i` is repeated exactly when it is
a root of `B`.  This recovers C316's Jacobian branch equation directly from the eliminant and shows
that both pentics share the same possible ramification parameters `p`, even though their branch
targets differ.

In C315's survivor coordinates, put

    x=X_alpha,      x'=X_beta,      y=Y_alpha,      y'=Y_beta,
    s=x+x',         t=y+y',         d=1+rho.

Then

    delta_0=P0^2*t,               delta_1=P0*s,
    A_1=P0*x,                     A_2=P0*(x+d),          (4)

and `s!=0` is exactly the ordered-seed open.  In particular the two `p^3` coefficients are

    P0^2*x*x',                   P0^2*(x+d)*(x'+d).      (5)

The `p` coefficients are respectively

    P0^4*(t^2+x*t*s+y*s^2)+P0^2*s^2,                   (6)

    P0^4*(rho^2*t^2+(x+d)*t*s+(y+theta)*s^2)
      +P0^2*rho^2*s^2.                                 (7)

Equations (4)--(7) are the first exact correlation interface.  They show that the two pentics are
not independent random degree-five polynomials: they share `(delta_0,delta_1,M,B)`, and their two
target-dependent coefficient pairs are related by the repair shift `x->x+d`,
`y->y+theta`, `e:1->rho`.  Whether this shared structure forces a common resolvent quotient or
still permits generic disjointness is the next theorem gate.

### Proof

Write

    N_i=e_i*p^2+A_i*p+e_i*(delta_0+delta_1).

In characteristic two, squaring has no cross terms.  Substitution into C316 (31) and collection by
degree gives (1); its constant term is
`e_i*delta_1*(delta_0^2+delta_0*delta_1+delta_1^2)`.  Equation (3) follows by direct
differentiation and cancellation of the odd-degree terms.  For (4)--(7), substitute C315's

    Gamma_gamma=(P0^2*Y_gamma+1)+(P0*X_gamma+1)*omega

and

    Delta_R=(d^2+P0^2*theta)+(d^2+d*P0)*omega

into the definitions of `Delta_S,Z_i,A_i`.  The identities
`rho^2=1+d^2` and characteristic-two cancellation give `A_2=P0*(x+d)` and (7).

This is a direct polynomial proof; no CAS or finite-field sample is evidence for (1)--(7).

## Evidence boundary

The task begins from proof-only closed reports.  No new theorem is claimed here yet.  The strategic
motivation and cross-program possibilities are recorded separately in
[`2026-07-18-post-C312–C317-codex-brainstorm.md`](2026-07-18-post-C312–C317-codex-brainstorm.md).
