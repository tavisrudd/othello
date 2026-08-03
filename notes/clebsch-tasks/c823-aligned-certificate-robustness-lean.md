# C823 — Lean closure for aligned-certificate robustness

**Lane:** `clebsch`  
**Status:** third task for `go clebsch paper III`; begin after C815's
declaration handoff, now available in
`RelativeConicArcs.FourShadowRecognition`; C799 and C822 statements frozen;
C800 owns the later manifest reconciliation

## Objective

Formalize the reusable structural content of C810, C812, and C822: certificate
disagreement under a fixed two-graph difference, edge-toggle parity and local
distance, the exact seven-point distance-two obstruction, conference pair
balance, factorial-moment conversion, and the minimal local-count interface
selected by C822.

## Ownership and dependencies

- Reuse C799's two-graph, aligned-four-set, faithfulness, anchor, and decoder
  declarations. Do not create a second aligned-design API.
- Wait for C822 to freeze the honest human statement controlling the
  order-26 compression.
- Reuse the now-frozen C815 declarations where the branches meet; avoid
  duplicating its four-shadow API.  Hand the combined source closure to C800
  for the single manifest reconciliation.
- Finite order-26 values may enter through small generated certificates only
  after the human/formal correspondence is explicit.

## Frozen declaration handoff

Reuse these C815 declarations rather than reopening the cubic-recognition
layer:

- `FourShadowRecognition.CubicsProportional`;
- `FourShadowRecognition.pairTriangleSum_eq_zero_of_cubicsProportional`;
- `FourShadowRecognition.exists_mul_self_eq_scalar_of_cubicsProportional`;
- `FourShadowRecognition.PentagonGauge` and
  `FourShadowRecognition.pentagonGauge_of_firstRowBalanced`;
- `FourShadowRecognition.normalizedSignMatrix_sq_of_firstRowBalanced`;
- `FourShadowRecognition.cubicsProportional_four_of_sixTests` and its
  negative-orientation companion; and
- `FourShadowRecognition.exists_nonzero_cubicsProportional_smul_iff_conferenceSquare`.

The separately gated module reuses
`ClebschGoldenConference.pairTriangleSum_eq_mul_mulApply`; its pair-balance
surface is the intended meeting point with this task's conference moment and
departure-distance arguments.  C800, not this task, merges the focused gate
into the final shared Paper III manifest.

## Work package

1. Formalize the quadratic aligned indicator on the even four-bit space and
   its affine polarization at fixed difference.
2. Prove the exact single-edge disagreement formula
   \(\binom{k}{2}+\binom{n-2-k}{2}\) and the certificate-weight parity theorem
   for \(n\equiv3\pmod4\).
3. Formalize the seven-point lower bound and the explicit bowtie equality
   witness, yielding distance two and correction radius zero.
4. Derive conference pair balance from row orthogonality and its local
   departure distance.
5. Formalize factorial moments from block-union counts and the
   \(3\)-design intersection recurrence used by C812.
6. Formalize C822's final one- or two-parameter compression theorem. Keep
   construction-specific classification or orbit data behind an explicit
   finite boundary.
7. Extend the Paper III structural gate, axiom audit, correspondence map, and
   source-hash manifest without weakening existing terminals.

## Acceptance

The reusable structural theorems are kernel-checked; the exact finite boundary
is explicit; every paper-facing terminal has an axiom report; C799/C800/C815
declarations remain nonduplicated; and the guarded Paper III aggregate replay
passes.

## Promotion boundary

This task owns formalization and trust integration, not manuscript prose.
C824 owns any Paper III exposition or positioning.
