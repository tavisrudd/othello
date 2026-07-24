# C592: six-point Gale common-concurrency falsifier

**Lane:** `relconic`

**Date:** 2026-07-24

**Status:** active.

## Question and gate

C555 proves that raw secant moments and the conic chord graph are subordinate
to the prescribed-hole defect.  C402 supplies, for a six-arc \(S\) with Gale
dual \(S^*\), the common-concurrency count
\[
 b(S,S^*)=
 \#\{M:\text{\(M\) is a perfect matching whose three chords concur in both
 \(S\) and \(S^*\)}\}.
\]
This task tests whether aggregating that count over six-subsets of an arc
produces information not determined by the C554--C555 concurrence-index data.

The task passes only if the paired original/Gale equations impose a
rank-three compatibility condition coupling distinct concurrence matching
cliques and not determined by the distribution of the indices \(r(x)\).
It fails if the statistic reduces to the existing moment hierarchy or varies
freely among realizations with the same matching-clique data.

## Bounded plan

1. Normalize a generic six-arc as \(P=[I_3\mid X]\) and use the canonical
   Gale matrix \(P^*=[-X^T\mid I_3]\).
2. Derive the concurrence determinant for each of the fifteen perfect
   matchings on both \(P\) and \(P^*\).
3. Determine the algebraic relation between the two sets of determinants and
   identify what information the common-zero count retains.
4. Test independence from the C554--C555 data on exact finite-field
   realizations only if the symbolic relation does not already decide the
   gate.  Any computation will be committed as a deterministic report,
   checker, canonical certificate, and checksum manifest.
5. Calibrate against the committed \(\F_4\) six-hyperoval and the regular
   \(\F_8\) hyperoval realization without turning the calibration into a
   field census.

## Inputs and boundary

- `notes/2026-07-23-c402-h3-ame-uniform-lu-separation.md` proves the portable
  formula \(60+b(S,S^*)\).
- `notes/2026-07-24-c555-small-defect-third-moment.md` proves the subordinate
  raw-moment boundary and states the missing mixed rank-three compatibility
  layer.
- C556 remains gated unless this task exposes the required invariant.

No manuscript claim or asymptotic improvement is assumed.
