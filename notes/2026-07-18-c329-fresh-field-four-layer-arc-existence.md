# C329: fresh-field four-layer arc existence

**Lane:** `relconic`

**Date:** 2026-07-18

**Status:** queued; construction-facing successor to C327 before the C299 Paper-II drafting gate.

## Objective

Decide whether, for every sufficiently large odd-tower field `F=GF(Q)`, C315's trace-defined `E4`
survivor contains fresh coefficients for which all four C316 finite collision fibers have no
`F`-point.  C327 has proved simultaneous avoidance of the two seed--seed--repair degree-five gates
for `Q>=2^41`; C329 owns the two remaining repair--repair--seed gates.

The desired positive theorem constructs a collision-free four-layer arc and exports its explicit
parameter family to relative coverage.  It does not claim `C`-completeness until that separate
coverage gate is proved.

## First route: repair-conic coincidence

Begin on the allowed C317 stratum

    Delta_R=0,              equivalently P0=d and w in {0,1}.

Here both generic degree-six fibers specialize to exact quadratics.  On C327's common seed
translation line:

1. derive their two Artin--Schreier trace classes and slopes;
2. classify every dependence divisor jointly with the four legality classes;
3. determine the resulting cover's components, constant field, genus, rational-point count, and
   exact deletions;
4. re-audit the two quintic splitting fields on this restricted skeleton, because C327's generic
   sign-divisor separation used a free `theta` parameter; and
5. prove an effective simultaneous four-gate no-root count, or an exact incompatibility.

If the coincidence locus is obstructed, identify whether the obstruction is intrinsic to
`Delta_R=0` and pass to the generic degree-six pair without enlarging into a coefficient census.

## Exit gates

C329 closes with one of:

1. an explicit existence or positive-density theorem for collision-free four-layer arcs over an
   odd-tower tail, with threshold and exact exceptional deletions;
2. an exact structural obstruction on the coincidence locus plus a completed generic degree-six
   alternative; or
3. a bounded negative theorem showing that both routes fail for a stated algebraic reason.

Generic monodromy, a conditional Chebotarev main term, or a tiny-field probe is not an exit.  No raw
coefficient census or `Q=512` run is authorized.

## Closed inputs and paper interface

- C315 supplies the `E4` survivor, legality traces, and deletions.
- C316 supplies the two repair--repair--seed maps, degree-six eliminants, exact quadratic
  specialization, alternate `S=0` chart, and branch ideals.
- C317 proves that avoiding all four finite fibers is exactly collision-freeness.
- C327 supplies a nonempty quantitative base avoiding both quintic gates and the effective
  joint-cover method.

For the Paper-II bundle, the narrative question is whether C327's fresh-field quintic survival
extends to an actual four-layer arc.  Relative coverage is the next and final construction-facing
consumer if C329 is positive.
