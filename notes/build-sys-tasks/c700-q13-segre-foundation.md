# C700 — q13 Segre foundation

**Lane:** `build-sys`
**Opened:** 2026-07-29
**Status:** queued after C699; may be developed independently of C698.

## Objective

Put the reusable human proof of Segre's Lemma of Tangents and the q13
tangent-code reduction/checker interfaces in `finitegeom`.

## Acceptance

- Formalize a reusable coordinate-free Lemma of Tangents or the exact
  planar specialization consumed by q13, with Ball--Lavrauw Lemma 27
  provenance.
- Define the q13 conic, internal points, passant lines, incidence code, and
  tangent/holonomy graph through existing finite-geometry APIs.
- Prove the mathematical reduction from a hypothetical weight-eight word
  to the forbidden tangent-graph clique.
- Expose narrow predicates for rank, clique, weight-ten, minimum-word,
  reconstruction, and automorphism certificates.
- Add human terminals, trust declarations, exact axiom audit, and
  clean-checkout replay.

## Boundaries

No exhaustive q13 catalogue belongs in `finitegeom`.  Do not replace
Segre's lemma by a finite q13 truth table.

## Plan

`notes/2026-07-29-c698-c702-paper-i-v2-lean-audit-plan.md`
