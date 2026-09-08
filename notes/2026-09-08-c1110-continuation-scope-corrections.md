# C1110 — small-order scope and resolution action

**Lane**: `continuation`
**Date**: 2026-09-08

Applied the author's remaining local corrections:

1. `prop:size` now assumes q>=4. At q=4 its two vertices have degree zero;
   q=2,3 are excluded from the degree assertion. Reviewed the absent-coverage
   claim row, added the field-order hypothesis, and refreshed only its digest.
2. The r(k) extremal graph now has tangent lines with nonempty traces as its
   vertices. Line identities and centres are retained even for coincident
   traces. Edges mean disjointness and the maximized cliques use two or more
   centres. The existing zero convention for an empty defining class remains.
3. After the exceptional-group proof, stated the action on two resolutions:
   projection onto C2 for q=5 and sign of the S3 factor for q=8, with kernels
   S4 x {1} and S4 x A3. This is a deduction from the existing direct products
   and the established geometric-resolution stabilizers, not new computation.

The publication-stage joint archive remains recorded in the lane handoff and
owned by the author. No release or DOI operation is included in these edits.

Validation: 25-claim source/evidence/checksum gate passes. Deterministic PDF
build passes; changed pages 13, 15 and 16 were visually inspected without
clipping. Replay from the paper root:

```sh
nix develop --command make check
nix develop --command python3 verification/check_manuscript_build.py
```

PDF bytes: 406130; SHA-256: `4c786bacd48390c51ffbaf84b2c83f7d31b22bc9d5f2e852567ad3c581641ace`.

## Closeout / Mystery ledger

The local scope conventions are now explicit. The group-action deduction uses
that frame permutations (and Frobenius at q=8) preserve the geometric resolution;
their subgroup has the full index-two stabilizer order. Its quotient is C2,
giving precisely projection/sign in the stated decompositions. No additional
finite evidence or mystery is introduced. The conceptual q=7,8 boundary problem
remains the already recorded future research direction; no new allocation or
incidental discovery entry is needed. C1110 remains open for external review.
