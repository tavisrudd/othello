# C533 — C525 threshold and deletion sharpening

**Lane:** `reed-solomon` · **Status:** queued independently after C525

## Objective

Sharpen the characteristic-two ordered-Hessian containment theorem without changing its carrier
classification.  Improve one or both of
\[
q\ge\min\left\{\frac{(n-4)(n+3)}2+1,\ 5(n-4)\right\},
\qquad
\delta_n^{(2)}\le3n-4
\]
by exploiting the exact pulled-back Pluecker covariants, deterministic hitting slices smaller
than five points per root, and scheme-theoretic overlaps among branch, diagonal, infinity, and
fixed-root deletion divisors.

Eventual report:
`notes/2026-07-23-c533-c525-threshold-deletion-sharpening.md`.

## Entry gate

Use C525's frozen universal equations, generator, certificate, and replay.  Do not regenerate its
`PG(3,4)` line census unless a concrete algebraic inconsistency is found.

## Execution order

1. Substitute the root-compatible Hankel line into the exact Veronese/ruling ideals.
2. Determine the true separate degree and sparsity of the surviving nonzero covariants.
3. Construct and prove the smallest uniform deterministic hitting slice available from that
   structure.
4. Compute divisor gcds/intersections before summing deletion degrees.
5. Re-solve the exact Hasse inequality and report the first valid prime powers.

## Acceptance gates

- A uniform proved threshold or deletion improvement, or a sharp obstruction to the proposed
  improvement method.
- Exact collision semantics and no loss of C525's geometrically integral slice.
- Before/after prime-power threshold table for representative degrees, clearly marked as a
  consequence rather than the proof.
- Atomic evidence bundle for every computational claim.

## Stop rules

- Do not weaken the carrier theorem or enlarge its exceptional locus to improve constants.
- Do not replace a uniform argument by fixed-redundancy interpolation tables.
- Do not open C500.

## Owned paths

- `notes/2026-07-23-c533-c525-threshold-deletion-sharpening*`
- `notes/reed-solomon-tasks/c533-c525-threshold-deletion-sharpening.md`
- the `reed-solomon` handoff, archive, discovery track, and task lifecycle rows
