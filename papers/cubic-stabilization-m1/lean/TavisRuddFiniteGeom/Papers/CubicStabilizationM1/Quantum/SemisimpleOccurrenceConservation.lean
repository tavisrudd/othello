import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SemisimplePrimaryLedger
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ExactPrimaryOccurrenceDescent

/-!
# Conservation of full semisimple odd objects

Actual low-dimensional occurrence ledgers are realized by full primary
blocks whose even-block multisets are point, curve or surface models. Their
numerical weights vanish by the seed calculations, and positivity and odd
parity force the entire semisimple-object weight to vanish. Weak factorization
then produces an isomorphism of the reconstructed safe objects. Endpoint
isomorphisms with doubled whole odd objects permit categorical cancellation.
Geometric block realizations, operation comparisons and the realization of
rational Hodge structures in the semisimple coordinate category are explicit
inputs. Neither conservation nor center-weight vanishing is an input.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

universe u v

/-- Folding the numerical coordinates of a full-object block multiset equals
folding its actual even-block multiset. -/
theorem SemisimplePrimaryPresentation.numericFold_blockMultiset
    {K : Type*} [Field K] [CharZero K] {ι : Type u} {division : ι → Type v}
    [∀ i, DivisionRing (division i)] (presentation : SemisimplePrimaryPresentation K ι division)
    (blocks : Multiset (SemisimplePrimaryBlock K ι division)) :
    presentation.numericFold (blocks.map presentation.toBlockPresentation.component)=
      primaryBlockMultisetWeight (blocks.map SemisimplePrimaryBlock.evenBlock) := by
  let component : SemisimplePrimaryBlock K ι division → presentation.toBlockPresentation.Component :=
    presentation.toBlockPresentation.component
  change presentation.numericFold (blocks.map component)=_
  induction blocks using Multiset.induction_on with
  | empty => simp [primaryBlockMultisetWeight]
  | @cons block blocks ih =>
    rw [Multiset.map_cons, ← Multiset.singleton_add, map_add]
    have singleton : presentation.numericFold {component block}=block.evenBlock.weight := by
      unfold numericFold
      exact presentation.toBlockPresentation.foldBlocks_singleton _ (by
        intro left right related
        obtain ⟨comparison⟩ := presentation.comparisons related
        exact comparison.evenComparison.weight_eq) block
    rw [singleton, ih]
    simp [primaryBlockMultisetWeight]

/-- Actual full-object occurrence realizations imply low-dimensional
nullity for the full semisimple-object fold, including every odd summand. -/
theorem semisimple_lowDimensionalOccurrenceNullity
    {K Variety Center Occurrence : Type*} [Field K] [CharZero K]
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (presentation : SemisimplePrimaryPresentation K ι division)
    (data : OccurrenceIndexedLedger Variety Center Occurrence presentation.toBlockPresentation)
    (realizations : ∀ occurrence,
      data.smoothCenter (data.occurrenceSource occurrence) →
      data.centerDimension (data.occurrenceSource occurrence) ≤ 2 →
      ∃ blocks : Multiset (SemisimplePrimaryBlock K ι division),
        ∃ model : LowDimensionalPrimaryModel K,
          data.occurrenceLedger occurrence=blocks.map presentation.toBlockPresentation.component ∧
          blocks.map SemisimplePrimaryBlock.evenBlock=model.blocks)
    (dimension : ℕ) (atMostFour : dimension ≤ 4) :
    LowDimensionalOccurrenceNullity data presentation.fold dimension := by
  intro occurrence smooth small
  obtain ⟨blocks,model,ledgerEq,blocksEq⟩ := realizations occurrence smooth (by omega)
  apply presentation.fold_zero_of_numericFold_zero
  rw [ledgerEq, presentation.numericFold_blockMultiset, blocksEq]
  exact model.weight_zero

/-- Weak factorization and actual low-dimensional full-block realizations
produce an isomorphism of safe objects for birational smooth projective
objects of dimension three or four. -/
noncomputable def semisimple_safeObjectIso_of_birational
    {K Variety Center Occurrence : Type*} [Field K] [CharZero K]
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (presentation : SemisimplePrimaryPresentation K ι division)
    (data : OccurrenceIndexedLedger Variety Center Occurrence presentation.toBlockPresentation)
    (realizations : ∀ occurrence,
      data.smoothCenter (data.occurrenceSource occurrence) →
      data.centerDimension (data.occurrenceSource occurrence) ≤ 2 →
      ∃ blocks : Multiset (SemisimplePrimaryBlock K ι division),
        ∃ model : LowDimensionalPrimaryModel K,
          data.occurrenceLedger occurrence=blocks.map presentation.toBlockPresentation.component ∧
          blocks.map SemisimplePrimaryBlock.evenBlock=model.blocks)
    (dimension : ℕ) (threeOrFour : dimension=3 ∨ dimension=4)
    (birational : Setoid Variety)
    (provider : BirationalFactorizationProvider data presentation.fold dimension birational)
    {left right : Variety} (leftSmooth : data.smoothProjective left)
    (rightSmooth : data.smoothProjective right)
    (leftDimension : data.dimension left=dimension) (rightDimension : data.dimension right=dimension)
    (related : birational.r left right) :
    CategoryTheory.Iso (presentation.safeObject (data.varietyLedger left))
      (presentation.safeObject (data.varietyLedger right)) :=
  SemisimpleCoordinateObject.categoryIso (presentation.safeObjectIso _ _
    (BirationalFactorizationProvider.marker_eq_of_related data presentation.fold dimension birational provider
      (semisimple_lowDimensionalOccurrenceNullity presentation data realizations dimension (by omega))
      leftSmooth rightSmooth leftDimension rightDimension related))

/-- An isomorphism of safe objects and actual endpoint identifications with
doubled whole odd objects recover an isomorphism of the undoubled objects.
The endpoint maps are isomorphisms of objects, not dimension equalities. -/
noncomputable def wholeOddObjectIso_of_doubled_safeObjectIso
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (left right safeLeft safeRight : SemisimpleCoordinateObject ι division)
    (conserved : CategoryTheory.Iso safeLeft safeRight)
    (leftEndpoint : CategoryTheory.Iso safeLeft (left.sum left))
    (rightEndpoint : CategoryTheory.Iso safeRight (right.sum right)) :
    CategoryTheory.Iso left right :=
  SemisimpleCoordinateObject.cancelDoubleCategoryIso left right
    (leftEndpoint.symm.trans (conserved.trans rightEndpoint))

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
