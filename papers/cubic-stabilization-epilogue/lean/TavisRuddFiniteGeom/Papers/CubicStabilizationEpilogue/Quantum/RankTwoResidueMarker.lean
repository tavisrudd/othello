import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.AtomicResidueDiscriminant
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.OccurrenceIndexedMarker

/-!
# The rank-two residue marker as an effective-ledger fold

The unframed marker distinguishes rank-two blocks whose leading nilpotent is
nonzero and square-zero and whose modified residue has nonzero discriminant.
All other even blocks receive weight zero.  A supplied regular-isomorphism
relation may identify different matrix presentations only when this weight is
unchanged.  The resulting natural-valued marker is therefore an instance of
the effective-ledger fold.

A context packages block ledgers, actual center occurrences, weak
factorization, and low-dimensional nullity in ambient dimension four.  Its
birational-invariance theorem is a direct specialization of the generic
occurrence-indexed descent theorem.  The module does not construct QDM blocks
or any comparison isomorphism.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

universe u v w x

/-- An even block, retaining exact matrix data in the rank-two case and a
certified non-two rank otherwise. -/
inductive RankTwoResidueBlock (K : Type x) [CommRing K]
  | rankTwo (leadingNilpotent modifiedResidue : Matrix (Fin 2) (Fin 2) K)
  | other (rank : ℕ) (notRankTwo : rank ≠ 2)

namespace RankTwoResidueBlock

/-- The rank of an unframed even block. -/
def rank {K : Type x} [CommRing K] : RankTwoResidueBlock K → ℕ
  | .rankTwo _ _ => 2
  | .other value _ => value

/-- The residue-marker weight is one precisely for a nonzero square-zero
rank-two leading term with nonzero modified-residue discriminant. -/
noncomputable def weight {K : Type x} [CommRing K] : RankTwoResidueBlock K → ℕ
  | .rankTwo leadingNilpotent modifiedResidue => by
      classical
      exact if leadingNilpotent ≠ 0 ∧ leadingNilpotent * leadingNilpotent = 0 ∧
        residueDiscriminant modifiedResidue ≠ 0 then 1 else 0
  | .other _ _ => 0

/-- The marker weight vanishes on every block not presented as rank two. -/
@[simp]
theorem weight_other {K : Type x} [CommRing K] (rank : ℕ) (notRankTwo : rank ≠ 2) :
    weight (K := K) (.other rank notRankTwo) = 0 :=
  rfl

/-- A rank-two presentation satisfying the three marker conditions has weight
one. -/
theorem weight_rankTwo_of_conditions
    {K : Type x} [CommRing K]
    (leadingNilpotent modifiedResidue : Matrix (Fin 2) (Fin 2) K)
    (conditions : leadingNilpotent ≠ 0 ∧ leadingNilpotent * leadingNilpotent = 0 ∧
      residueDiscriminant modifiedResidue ≠ 0) :
    weight (.rankTwo leadingNilpotent modifiedResidue) = 1 := by
  classical
  simp [weight, conditions]

/-- A rank-two presentation failing at least one marker condition has weight
zero. -/
theorem weight_rankTwo_of_not_conditions
    {K : Type x} [CommRing K]
    (leadingNilpotent modifiedResidue : Matrix (Fin 2) (Fin 2) K)
    (failure : ¬ (leadingNilpotent ≠ 0 ∧ leadingNilpotent * leadingNilpotent = 0 ∧
      residueDiscriminant modifiedResidue ≠ 0)) :
    weight (.rankTwo leadingNilpotent modifiedResidue) = 0 := by
  classical
  simp [weight, failure]

end RankTwoResidueBlock

/-- A regular-isomorphism presentation of unframed residue blocks, including
the exact premise that the residue-marker weight is invariant. -/
structure RankTwoResiduePresentation (K : Type x) [CommRing K] where
  regularIsomorphism : Setoid (RankTwoResidueBlock K)
  weight_invariant : ∀ {left right}, regularIsomorphism.r left right →
    left.weight = right.weight

namespace RankTwoResiduePresentation

/-- The effective-ledger block presentation underlying the residue marker. -/
def toBlockPresentation {K : Type x} [CommRing K]
    (presentation : RankTwoResiduePresentation K) : BlockPresentation where
  Block := RankTwoResidueBlock K
  regularIsomorphism := presentation.regularIsomorphism

/-- The natural-valued fold counting marked rank-two residue components with
occurrence multiplicity. -/
noncomputable def fold {K : Type x} [CommRing K]
    (presentation : RankTwoResiduePresentation K) :
    presentation.toBlockPresentation.EffectiveLedger →+ ℕ :=
  presentation.toBlockPresentation.foldBlocks RankTwoResidueBlock.weight
    presentation.weight_invariant

end RankTwoResiduePresentation

/-- The direct-QDM residue-marker inputs needed for categorical descent in
ambient dimension four.  The comparison provider and center nullity are
explicit mathematical premises. -/
structure RankTwoResidueMarkerContext
    (K : Type x) [CommRing K]
    (Variety : Type u) (Center : Type v) (Occurrence : Type w) where
  presentation : RankTwoResiduePresentation K
  data : OccurrenceIndexedLedger Variety Center Occurrence
    presentation.toBlockPresentation
  birational : Setoid Variety
  provider : BirationalFactorizationProvider data presentation.fold 4 birational
  centerNullity : LowDimensionalOccurrenceNullity data presentation.fold 4

namespace RankTwoResidueMarkerContext

variable {K : Type x} [CommRing K]
variable {Variety : Type u} {Center : Type v} {Occurrence : Type w}

/-- The direct residue marker of a variety. -/
noncomputable def marker
    (context : RankTwoResidueMarkerContext K Variety Center Occurrence)
    (variety : Variety) : ℕ :=
  context.data.varietyMarker context.presentation.fold variety

/-- The rank-two residue marker is birationally invariant in dimension four
under the supplied occurrence-indexed QDM formulas and center nullity. -/
theorem marker_eq_of_birational
    (context : RankTwoResidueMarkerContext K Variety Center Occurrence)
    {left right : Variety}
    (leftSmooth : context.data.smoothProjective left)
    (rightSmooth : context.data.smoothProjective right)
    (leftDimension : context.data.dimension left = 4)
    (rightDimension : context.data.dimension right = 4)
    (related : context.birational.r left right) :
    context.marker left = context.marker right :=
  by
    have _ := leftSmooth
    have _ := rightSmooth
    have _ := leftDimension
    have _ := rightDimension
    exact context.provider.marker_eq_of_related context.data context.presentation.fold 4
      context.birational context.centerNullity related

end RankTwoResidueMarkerContext

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
