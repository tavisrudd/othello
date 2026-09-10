# C1133 — first full-super algebra lemmas

**Date:** 2026-09-09. **Status:** algebra kernel-checked, geometric realization open.
The new `Quantum/SuperRankOneVanishing.lean` implements two prerequisites of L3.
It does not construct the primary decomposition, projectors or quantum product.

## Actual algebra and hypotheses

Let A be a nontrivial associative algebra over a characteristic-zero field K,
with an odd submodule O. Assume odd elements anticommute, their products are
scalar multiples of the unit, and every element of A is scalar plus odd.
An even linear trace vanishes on O and has a nondegenerate multiplication
pairing on **all of A**. Lean proves O=0.

The proof derives x²=0 from odd anticommutativity and characteristic zero.
Then (xy)²=0 by associativity and anticommutativity; since xy is scalar and
K embeds in A, xy=0. Pairing an odd x with any scalar-plus-odd element now
gives zero, so full nondegeneracy forces x=0. Vanishing of odd products and
nondegeneracy of the restricted odd pairing are not assumed.

The second lemma uses the actual regular representation
`Algebra.lmul K A : A →ₐ[K] Module.End K A` and polynomial evaluation.
If a polynomial in left Euler multiplication annihilates a submodule
containing 1, evaluation on 1 gives the algebra polynomial value zero;
the regular representation then gives the zero operator on the whole algebra.
No odd-part annihilation is a premise. Characteristic zero is unnecessary
for this second result.

Public declarations:

- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.superPrimary_scalarEven_odd_eq_bot`;
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.superPrimary_eulerPolynomial_transfers_from_even`.

## Verification

The complete new module was elaborated without warnings with the guarded
Lean wrapper, then built through the guarded queue. The updated Main interface
and AxiomAudit subsequently built, and the final aggregate trace gate passed.

```sh
lean/scripts/lean-build-queue.py build \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SuperRankOneVanishing \
  --lean-root /home/tavis/src/othello/papers/cubic-stabilization-m1/lean --cores 20-23
lean/scripts/lean-build-queue.py build \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface.Main \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Verification.AxiomAudit \
  --lean-root /home/tavis/src/othello/papers/cubic-stabilization-m1/lean --cores 20-23
```

Successful runs:
`/home/tavis/.cache/othello-lean-build/run-20260910-012400-38eb5539` (leaf,
1,808,448 kB peak) and
`/home/tavis/.cache/othello-lean-build/run-20260910-012451-40e06d0d` (interface/audit,
at most 2,080,924 kB peak). Both terminals report exactly
`propext`, `Classical.choice`, `Quot.sound`.
The captured-log correspondence gate passes with **189 sources, 324 terminals,
67 claims, 88 machinery entries, 22 imports and 5 evidence bundles**.
Existing manuscript coverage remains 14 absent / 26 fragment / 26 conditional /
1 complete. Only the new machinery digests were refreshed. No manuscript
coverage promotion, PDF build or export was performed.

## EJ+TT and Mystery ledger

- **Settled:** the rank-one exclusion need not assume the odd pairing is
  separately nondegenerate. The full Frobenius pairing and scalar-plus-odd
  spanning suffice; both are explicit hypotheses of the proved theorem.
- **Settled:** even polynomial identities transfer to the whole algebra through
  its unit. This prevents silently dropping odd cohomology in later projectors.
- **Open:** construct the actual super-primary ideals, prove their pairing
  restrictions and apply these lemmas to them. Scalar-even presentation of a
  rank-one factor is still to be supplied by that construction.
- **Open:** evenness of odd rank, exact rank-two and rank-three odd selectors,
  odd allocation for the Fano tables, and rank-three cluster persistence remain.
  None follows merely from registering the two algebraic lemmas.
