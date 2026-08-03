# C852 — PRS carrier and M9 proof-bottleneck exposition

**Lane:** `reed-solomon`

**Status:** Exposition implemented and local gates green; fresh-reader and
clean-export gates remain.

## Objective

Make the two deepest existing proofs independently auditable without changing
their statements or moving computational detail into the mathematical body:

1. explain how the saturated terminal ordered-root incidence yields the
   rank-two prime, residual characteristic-dependent prime, and collision
   alternative, then how irreducible marker row spaces select exactly the
   persistent or maximal Lucas carrier;
2. give a four-step synopsis of degree-nine Lucas-carrier shallowness,
   separating invariant-block arithmetic, rank-three/rank-four
   Artin--Schreier integrality, rational base selection, and bounded-field
   certificates.

## Acceptance gates

- No theorem, field range, hypothesis, or formal/computational trust boundary
  changes.
- Every new terminal-carrier sentence reconciles with Certificate SC; every
  M9 sentence reconciles with the C578/C620 proof and evidence boundary.
- Both manuscript builds, the 75-label/69-artifact verifier, rendered-page
  inspection, and clean standalone export pass.
- A fresh reader not shown the earlier reviews can reconstruct both bottlenecks
  and returns no major issue.
- A genuinely external-machine replay remains an explicit publication-stage
  gate unless performed outside this workspace; a second local export is not
  described as external validation.

## Implemented revision

The recursive-carrier proof now prints the universal symmetric ordered-root
equation on the cubic-pencil Grassmannian and explains how symmetric,
exchanged, and anti-invariant factorization alternatives yield the residual
prime, persistent determinant, and characteristic-three collision.  A compact
four-row table exposes how each bottom component constrains a contained marker
row space and why only the persistent or maximal Lucas carrier survives.

The degree-nine Lucas section now begins its complete-carrier argument with a
four-step synopsis: invariant-block arithmetic, rank-three/rank-four
Artin--Schreier integrality, rational good-base selection, and the exact finite
boundary.  It states that q16 and q32 are full-carrier certificate closures,
whereas at q64 only the invariant block is certificate-backed and the
complement is mathematical.  The verification table uses the same boundary.
Appendices A, B, and D now state their input, bottleneck, and closing theorem at
entry.  A second mechanism figure was rejected as redundant with the reading
map; the characteristic table transfers the missing information more directly.

The warning-free builds are currently 55 canonical pages and 40/50 TIT pages.
