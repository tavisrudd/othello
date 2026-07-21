# C449 / T2 — split Coxeter torus

**Context:** test a mechanism for the already-certified law `q=h+1`; failure does not damage that
law or C444.

## Inputs

- C440/C441 frozen generator and reduction bundles
- `notes/2026-07-20-c399-coxeter-number-conic-phase.{md,json,py,sha256}`

## Task

For A3/B3/H3, compute whether the Coxeter element's rotation part maps to a split-torus generator
of `PSL_2(q)` and exhibit the `2+(q-1)` action on the conic. Derive conjugacy/order data from the
frozen groups rather than recalling a character table.

Deliver canonical generator images, orders, fixed points, orbit partitions, and a pass/fail verdict.
If any image is nonsplit, close the mechanism claim sharply without altering `q=h+1`.

