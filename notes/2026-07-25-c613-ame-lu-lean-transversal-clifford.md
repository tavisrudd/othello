# C613 — one-leg encoders and transversal Clifford actions

**Lane:** `ame-lu`

**Date:** 2026-07-25

**Status:** complete

## Result

`RelativeConicArcs.AMELU.EncoderTransversal` now formalizes the one-leg
encoder consequences of the length-generic MDS--CSS rigidity theorem.

- `oneLegQuantumMDSParameters` fixes the associated
  `[[2m-1,1,m]]` parameters and proves the one-logical-qudit quantum
  Singleton equality.
- `encoderConversion_inverseTranspose_chosenLeg` derives the exact
  `((Lᵀ)⁻¹ ⊗ U_phys)` orientation from
  `(I ⊗ U_phys) Ψ_C = (Lᵀ ⊗ I) Ψ_D`.
- `inverseTransposeWitness_of_isUnitaryMatrix` constructs the inverse
  transpose canonically from logical unitarity.
- `IsCliffordMatrix.conjTranspose`, `IsCliffordMatrix.conjugate`, and
  `IsCliffordMatrix.transpose` prove inverse, entrywise-conjugate, and
  transpose closure for the repository's finite-field Weyl normalizer.
- `encoderConversion_logical_and_physical_isClifford` proves that every
  logical and physical factor in a conversion between two associated
  encoders is Clifford.
- `GenericDiagonalDuality`, the two CSS shear-preservation theorems, and
  the parameter-surjectivity theorems formalize the algebra of the GRS
  upper and lower unipotent construction.
- `grs_projectiveTransversal_eq_affineSpecialLinear` identifies the exact
  projective carrier with `𝔽² ⋊ SL₂(𝔽)` from explicit construction,
  elementary-generation, and converse inputs.
- `affineSpecialLinearOrder_seven` checks the `AME(8,7)` /
  `[[7,1,4]]₇` order `16464`.

The aggregate import and declaration-level axiom audit include all new
paper-facing terminals.  The formal-statement, formalization, verification,
and manuscript trust-boundary ledgers now state the same coverage.

## Formal boundary

The encoder no-go is unconditional from `EncoderConversionInputs`: exact MDS
parameters, physical and logical unitarity, and the displayed forward
normalized Choi equation.  The inverse-transpose witness and all Clifford
closure steps are proved, not assumed.

The exact GRS carrier theorem is a conditional interface.
`GRSTransversalInputs` keeps the actual generalized or extended GRS
diagonal-duality instance, phase-corrected Clifford lifts, logical Pauli
representatives, elementary generation, and the no-go containment explicit.
The repository has no length-generic GRS code definition from which those
fields could presently be constructed.  Lean checks the duality-shear
algebra, arbitrary unipotent coefficients, equality from the two
containments, and the order-seven arithmetic.

## Validation

- Warning-free guarded elaboration of
  `RelativeConicArcs.AMELU.EncoderTransversal`.
- Measured single-thread build of `EncoderTransversal`,
  `AMELUAggregate`, and `AMELUAggregateAxioms`, followed by the trace-only
  aggregate gate:
  `/home/tavis/.cache/othello-lean-build/run-20260725-215729-9939c8ba`.
- The declaration-level audit reports only `propext`,
  `Classical.choice`, and `Quot.sound` for the new conceptual terminals;
  the closed arithmetic terminal uses only `propext`.
- Warning-free 18-page manuscript build.
- PDF SHA-256:
  `507d85e38c61b513b1017073e5d6228d3880aa5e147559030934ae1f419d8b27`.

Implementation commit: `94ba154e`.

## `ej` and Tao closeout

The first free strengthening removed a hidden inverse assumption.  Logical
unitarity now constructs `(Lᵀ)⁻¹=(Lᵀ)ᴴ` internally, so the conversion input
contains no chosen inverse data.

The second strengthening isolated
`coordinateAxes_reflected_by_linearEquiv`: over a finite coordinate space,
an invertible linear map that sends every coordinate axis to an axis also
does so in reverse.  This is the reusable mechanism behind Clifford inverse
closure and avoids a separate finite permutation choice in later proofs.

The stress test separated three claims that should not be conflated:
the unconditional encoder no-go, the checked GRS duality-shear algebra, and
the conditional instantiation of the exact GRS group.  The ledgers expose
that boundary directly.

## Mystery ledger

| Feature | Closeout status | Remaining gap or owner |
|---|---|---|
| Exact inverse-transpose orientation | **Settled:** derived from the forward normalized Choi equation | none |
| Clifford inverse and transpose closure | **Settled:** adjoint-axis reflection and explicit Weyl conjugation | none |
| Logical unitarity versus a chosen inverse | **Settled:** the inverse-transpose witness is canonical | none |
| Upper and lower GRS shears | **Settled algebraically:** both preserve `C × Cᗮ` under diagonal duality and realize every coefficient | concrete GRS and phase-correction instantiation remains an explicit `GRSTransversalInputs` field |
| Exact `𝔽² ⋊ SL₂(𝔽)` group | **Settled as a conditional carrier equality** | a future length-generic GRS library could discharge the named construction and generation fields |
| Order-16464 specialization | **Settled:** kernel-checked arithmetic | none |

No unexplained feature remains inside the unconditional encoder theorem.
The only open formal boundary is the explicitly named GRS instantiation,
not a hidden assumption in the no-go.

**Vibe check:** the operational theorem is now fully kernel checked, including
the transpose orientation that was easiest to get subtly wrong.  The exact
GRS result has a clean formal landing point, but its concrete code-family
construction remains interface-level rather than an end-to-end GRS
formalization.

