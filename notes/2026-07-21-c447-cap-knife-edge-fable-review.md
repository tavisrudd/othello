# C447 Fable review — cap knife edge

**Lane:** `crowns`

**Date:** 2026-07-21

**Reviewed commits:** initial bundle `66d87e37`; class-equivalence strengthening `16b33902`;
gate fix `e345e2d1`; shared-edge repair HEAD `33c775b0`

**Final gate:** **GREEN — the original `SHARP_NEGATIVE`, the type-correct shared-edge repair, and
the revised X3 consequence are warranted.**

## Checks and judgment

At reviewed addendum HEAD `33c775b0`, canonical regeneration agrees with the tracked JSON, the
independent replay passes, and every checksum verifies. Direct inspection confirms exactly two knife-edge classes, 4 and 7, each
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

## Shared-edge repair addendum

The new primary and independent replay reconstruct all 22 frozen marker matchings, split them into
the two 11-element `PSL_2(11)` sheets, and examine all 121 cross-sheet pairs. Exactly 66 pairs
share exactly one conic edge, every one of the 66 edges occurs once, and intersection with the
shared edge is manifestly `PGL_2(11)`-equivariant. Exhaustive uniqueness therefore makes the
inverse edge-to-pair map canonical and equivariant as well.

For every edge/pair object, the two setwise stabilizers are equal of order 20, with element-order
distribution `1^1 2^11 5^4 10^4`, deriving `D20`. For both cap classes, the frame `D10` is contained
in this stabilizer. Its determinant-square `C5` fixes the two endpoints individually and fixes
each matching as an element of the selected two-set; its nonsquare coset swaps both endpoint and
matching pairs. Thus the two unordered two-sets carry the same determinant torsor. There are still
two equivariant orientations and no canonical endpoint-to-matching bijection, exactly as the
report states.

This is a type-correct repair rather than a resurrection of the rejected singleton claim: the
target is the unique cross-sheet pair sharing the cap P edge, not the fixed base/J-mate singleton
pair. Its canonicity is relative to the frozen C379/C406 22-matching geometry; it is not asserted
to arise from a bare unmarked conic. The report also correctly treats the underlying shared-edge
relation as classical and makes no novelty claim.

The revised X3 wording is sound. C460 remains the independent positive orbit-valued geometry; the
failed base/J comparison remains consistency-only; and the shared-edge bijection is a separate
exact positive cap input for the orbit-valued-selector lemma. It does not orient either two-set or
select a pointwise child.

There are no remaining gate findings. Register row 35's named singleton claim closes **sharp
negative in the explicitly equivariant sense**, while the shared-edge addendum is **GREEN**. This
does not claim arbitrary unframed incidence is impossible, re-solve the cap game, infer P/N values
from symmetry, recover the frozen matching orbit from the bare conic, or identify either cap class
with a golden sheet.
