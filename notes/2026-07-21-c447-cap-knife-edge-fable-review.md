# C447 Fable review — cap knife edge

**Lane:** `crowns`

**Date:** 2026-07-21

**Reviewed commits:** initial bundle `66d87e37`; class-equivalence strengthening `16b33902`;
gate-fix HEAD `e345e2d1`

**Final gate:** **GREEN — `SHARP_NEGATIVE` and the narrowed X3 consequence are warranted.**

## Checks and judgment

At HEAD, canonical regeneration agrees with the tracked JSON, the independent replay passes, and
every checksum verifies. Direct inspection confirms exactly two knife-edge classes, 4 and 7, each
with seven on-conic children, a `2P+5N` orbit split, and the reported hyperbola. Both
cap-to-standard matrices carry all ten affine points and both points at infinity to
`XZ-Y^2=0`; composing with the frozen C406 matrix gives the recorded H3 projectivities.

The equivariance obstruction is exact. Each cap frame stabilizer has order 10, determinant-square
split `5+5`, and element-order distribution `1^1 2^5 5^4`, deriving `D10`. Each singleton
matching has an order-60 stabilizer inside `PSL_2(11)` with distribution
`1^1 2^15 3^20 5^24`, deriving `A5`. The unordered singleton-pair stabilizer has order 24 and
distribution `1^1 2^9 3^8 4^6`, deriving `S4`. Thus conjugacy-invariance of the determinant
character excludes the cap `D10` from either singleton `A5`, while the factor 5 excludes it from
the unordered-pair `S4`. Exhaustion of all 1,320 projectivities independently returns zero
compatible maps. The 120 unframed maps to an edge of either singleton correctly show that bare
incidence is coordinate choice rather than a weaker correspondence.

The strengthening also checks: exactly ten projectivities carry class 4's frame, P pair, and N
orbit to class 7's, including `g=(0,1;4,10)`. Hence the two cap knife-edge configurations are one
`PGL_2(11)` orbit and provide no intrinsic binary labeling.

## Resolution of the AMBER findings

1. **Resolved.** The primary certificate now computes and records the exact element-order
   distributions for `D10`, both `A5` stabilizers, and `S4`; the independent replay recomputes and
   checks all four distributions. The abstract-type labels are no longer recalled assertions.

2. **Resolved.** The report, JSON, and replay now give the warranted X3 consequence: X3 retains
   its abstract selector obstruction and C460's exact orbit-valued positive geometry, while the
   cap-lane comparison is consistency only, not causation.

There are no remaining gate findings. Register row 35 may close **sharp negative in the explicitly
equivariant sense**. This does not claim arbitrary unframed incidence is impossible, re-solve the
cap game, infer P/N values from symmetry, or identify either cap class with a golden sheet.
