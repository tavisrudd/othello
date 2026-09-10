import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SemisimpleOccurrenceConservation

/-!
# Whole odd-object conservation and generic reconstruction

This interface assembles actual full-primary occurrence realizations, weak
factorizations in dimension four, and endpoint isomorphisms for products with
the projective line. Birational stabilized endpoints have isomorphic whole
odd objects by low-dimensional nullity and doubled categorical cancellation.
A reconstruction hypothesis restricted to very general sources then gives
geometric isomorphism for such a source and any smooth target in the family.

The family may be chosen to be smooth cubic or smooth quartic threefolds.
Its geometric realization, semisimplicity, quantum comparison theorems, and
source-restricted Torelli statement are external inputs, separately visible
in the types. This module does not construct Hodge structures or assert a
Torelli theorem for arbitrary sources.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

universe u v

/-- Geometric realization data for whole odd objects and their stabilized
safe objects. All center realizations are given as actual block multisets. -/
structure StabilizedWholeOddData
    (K Variety Center Occurrence Family : Type*) [Field K] [CharZero K]
    (ι : Type u) (division : ι → Type v) [∀ i, DivisionRing (division i)] where
  presentation : SemisimplePrimaryPresentation K ι division
  occurrences : OccurrenceIndexedLedger Variety Center Occurrence presentation.toBlockPresentation
  lowDimensionalRealizations : ∀ occurrence,
    occurrences.smoothCenter (occurrences.occurrenceSource occurrence) →
    occurrences.centerDimension (occurrences.occurrenceSource occurrence) ≤ 2 →
    ∃ blocks : Multiset (SemisimplePrimaryBlock K ι division),
      ∃ model : LowDimensionalPrimaryModel K,
        occurrences.occurrenceLedger occurrence=blocks.map presentation.toBlockPresentation.component ∧
        blocks.map SemisimplePrimaryBlock.evenBlock=model.blocks
  birational : Setoid Variety
  factorization : BirationalFactorizationProvider occurrences presentation.fold 4 birational
  smooth : Family → Prop
  stabilized : Family → Variety
  stabilizedSmooth : ∀ object, smooth object → occurrences.smoothProjective (stabilized object)
  stabilizedDimension : ∀ object, smooth object → occurrences.dimension (stabilized object)=4
  wholeOdd : Family → SemisimpleCoordinateObject ι division
  endpoint : ∀ object, smooth object → CategoryTheory.Iso
    (presentation.safeObject (occurrences.varietyLedger (stabilized object)))
    ((wholeOdd object).sum (wholeOdd object))

/-- Stabilized birationality conserves the whole odd object, using the actual
low-dimensional block computations and cancellation in the semisimple category. -/
noncomputable def StabilizedWholeOddData.wholeOddIso
    {K Variety Center Occurrence Family : Type*} [Field K] [CharZero K]
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (data : StabilizedWholeOddData K Variety Center Occurrence Family ι division)
    {left right : Family} (leftSmooth : data.smooth left) (rightSmooth : data.smooth right)
    (related : data.birational.r (data.stabilized left) (data.stabilized right)) :
    CategoryTheory.Iso (data.wholeOdd left) (data.wholeOdd right) :=
  wholeOddObjectIso_of_doubled_safeObjectIso _ _ _ _
    (semisimple_safeObjectIso_of_birational data.presentation data.occurrences
      data.lowDimensionalRealizations 4 (Or.inr rfl) data.birational data.factorization
      (data.stabilizedSmooth left leftSmooth) (data.stabilizedSmooth right rightSmooth)
      (data.stabilizedDimension left leftSmooth) (data.stabilizedDimension right rightSmooth) related)
    (data.endpoint left leftSmooth) (data.endpoint right rightSmooth)

/-- A source-restricted Torelli implication gives geometric reconstruction
for a very general source and an arbitrary smooth target in the same family.
The target has no very-generality hypothesis. -/
theorem StabilizedWholeOddData.geometricIso_of_veryGeneral_source
    {K Variety Center Occurrence Family : Type*} [Field K] [CharZero K]
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (data : StabilizedWholeOddData K Variety Center Occurrence Family ι division)
    (veryGeneral : Family → Prop) (geometricIso : Family → Family → Prop)
    (sourceTorelli : ∀ left right, data.smooth left → data.smooth right → veryGeneral left →
      Nonempty (CategoryTheory.Iso (data.wholeOdd left) (data.wholeOdd right)) → geometricIso left right)
    {left right : Family} (leftSmooth : data.smooth left) (rightSmooth : data.smooth right)
    (generalSource : veryGeneral left)
    (related : data.birational.r (data.stabilized left) (data.stabilized right)) :
    geometricIso left right :=
  sourceTorelli left right leftSmooth rightSmooth generalSource
    ⟨data.wholeOddIso leftSmooth rightSmooth related⟩

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
