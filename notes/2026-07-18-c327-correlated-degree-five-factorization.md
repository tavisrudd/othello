# C327: correlated degree-five factorization before C299

**Lane:** `relconic`

**Date:** 2026-07-18

**Status:** active; theorem-led analysis of C316's two seed--seed--repair eliminants, with no large
field or coefficient census.

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

## Evidence boundary

The task begins from proof-only closed reports.  No new theorem is claimed here yet.  The strategic
motivation and cross-program possibilities are recorded separately in
[`2026-07-18-post-C312–C317-codex-brainstorm.md`](2026-07-18-post-C312–C317-codex-brainstorm.md).
