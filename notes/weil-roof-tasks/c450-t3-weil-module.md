# C450 / T3 — Weil decomposition of cross-sheet modules

**Context:** this is the sharpest Weil-roof test. A negative leaves the certified sheet theory
intact and weakens only the roof conjecture.

## Inputs

- C406 matching-module bundle and Gate-1 scout
- C460 Frégier-cloud bundle as a secondary, non-gating control
- C399 frozen conic/group conventions

## Task and acceptance

Derive `PSL_2(11)`/`SL_2(11)` character data computationally; decompose both relations of the
`11x11` cross-sheet incidence module and the q=7 analogue; test the `(q-1)/2,(q+1)/2` Weil-component
identification, character field `Q(sqrt(-11))`, and outer exchange.

Canonical JSON must contain characters, idempotents, constituent dimensions/fields, outer action,
and the verdict. Resolve and cache the Weil reference before naming the constituents. Separately
test whether C460's `22x55` kernel and mod-2/mod-3 rank drops have the same constituent explanation;
do not promote a numerical coincidence. The module-identification wording requires the program's
judgment gate.

