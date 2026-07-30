# C702 — Paper I v2 formal release

**Lane:** `build-sys`
**Opened:** 2026-07-29
**Status:** queued after C699 and C701.

## Objective

Assemble and validate the Paper I v2 formal trust surface without changing
the approved v1 surface.

## Acceptance

- Add a new aggregate gate, proposed
  `RelativeConicArcs.Gates.ClebschRigidityV2Trust`, composing C698 human,
  C699 q11, and C701 q13 terminals.
- Ensure q11 and q13 resolve one exact `finitegeom` revision.
- Freeze exact source/dependency commits, theorem maps, generated-data
  provenance, terminal axiom sets, and all trust declarations.
- Pass locked targeted builds, terminal `#print axioms` audits,
  reproducible regeneration checks, and clean-checkout replay.
- Update the standalone Paper I formal pins and claim map only after the
  aggregate passes.
- Hand the exact Cheltsov--Tschinkel--Zhang coordinate attribution to the
  `clebsch` lane for manuscript integration.

## Boundaries

Do not overwrite or weaken the v1 gate.  Do not edit the manuscript from
`build-sys` without explicit lane routing.  Do not create a portfolio-wide
certificate umbrella.

## Plan

`notes/2026-07-29-c698-c702-paper-i-v2-lean-audit-plan.md`
