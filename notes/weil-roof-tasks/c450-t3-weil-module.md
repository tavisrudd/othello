# C450 / T3 — Weil decomposition of cross-sheet modules

**Context:** this is the sharpest Weil-roof test. A negative leaves the certified sheet theory
intact and weakens only the roof conjecture.

## Inputs

- C406 matching-module bundle and Gate-1 scout
- C460 Frégier-cloud bundle as a secondary, non-gating control
- C399 frozen conic/group conventions
- C449 split-Coxeter-torus report and JSON: consume its exact restriction
  `2*trivial + 2*regular(C_e)`, invariant dimension four, and multiplicity-two nontrivial torus
  characters as a mandatory baseline; also test whether C445's specific `Rz` realizes C449's
  certified generic nonsquare-determinant swap of the two Legendre-coset orbits
- X-chain juice memo `../2026-07-21-weil-roof-juice-x-chain.md`, hypotheses only, two candidates to
  settle while testing the outer exchange: D1 (the cross-sheet incidence is the module of the one
  66-edge shared-edge graph, identical to C460's overlap-5 graph) and B's deferred link (exhibit a
  det-nonsquare `g` in `PGL_2(11)` realizing the sheet swap and matching the shared-edge endpoint
  swap, using C445's certified `Rz` boundary as the comparison convention; recompute, do not cite)

## Task and acceptance

Derive `PSL_2(11)`/`SL_2(11)` character data computationally; decompose both relations of the
`11x11` cross-sheet incidence module and the q=7 analogue; test the `(q-1)/2,(q+1)/2` Weil-component
identification, character field `Q(sqrt(-11))`, and outer exchange.

Canonical JSON must contain characters, idempotents, constituent dimensions/fields, outer action,
and the verdict. It must reproduce C449's torus-restriction multiplicities before any Weil naming.
Resolve and cache the Weil reference before naming the constituents. Separately
test whether C460's `22x55` kernel and mod-2/mod-3 rank drops have the same constituent explanation;
do not promote a numerical coincidence. The module-identification wording requires the program's
judgment gate.
