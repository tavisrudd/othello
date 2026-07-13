import RelativeConicArcs.QuadraticLineCounting
import FiniteGeom.BaerCompletion.PairExtension

/-!
# Coordinate quadratic pair-extension data

The coordinate Frobenius fixed-locus and mate-orbit theorems automatically discharge the
candidate-count field in the abstract quadratic pair-extension wrapper.
-/

namespace RelativeConicArcs
namespace QuadraticPairExtension

noncomputable section

open FiniteGeom.BaerCompletion QuadraticFrobenius QuadraticLineCounting

variable (F E : Type) [Field F] [Fintype F] [Field E] [Finite E] [Algebra F E]
  [Algebra.IsAlgebraic F E]

abbrev FixedLine := FixedProjectivePoint F E
abbrev CandidatePair := Sym2 (ProjectiveConjugation.Point E)

local instance : DecidableEq (FixedLine F E) := Classical.decEq _
local instance : DecidableEq (CandidatePair E) := Classical.decEq _

/-- Coordinate pair-extension data from a chosen collection of empty fixed lines and local
forbidden sets. Candidate pairs are constructed canonically from quadratic Frobenius. -/
noncomputable def coordinatePairExtensionData (hdeg : Module.finrank F E = 2)
    (emptyLines : Finset (FixedLine F E))
    (forbidden : FixedLine F E → Finset (CandidatePair E)) :
    PairExtensionData (FixedLine F E) (CandidatePair E) := by
  classical
  exact
    { emptyLines := emptyLines
      candidates := conjugateCandidatesOnFixedLine F E hdeg
      forbidden := forbidden }

/-- The coordinate construction has the required uniform candidate count on every selected fixed
line. -/
theorem coordinate_candidate_count (hdeg : Module.finrank F E = 2)
    (emptyLines : Finset (FixedLine F E))
    (forbidden : FixedLine F E → Finset (CandidatePair E))
    (l : FixedLine F E) (_hl : l ∈ emptyLines) :
    ((coordinatePairExtensionData F E hdeg emptyLines forbidden).candidates l).card =
      (Nat.card F * Nat.card F - Nat.card F) / 2 := by
  exact card_conjugateCandidatesOnFixedLine F E hdeg l

/-- Build the exact quadratic wrapper from only the remaining empty-line count and forbidden-orbit
bound. The candidate-count obligation is discharged by the coordinate fixed-locus theorem. -/
noncomputable def coordinateQuadraticBaerPairExtensionData
    (hdeg : Module.finrank F E = 2) (k f e : ℕ)
    (emptyLines : Finset (FixedLine F E))
    (forbidden : FixedLine F E → Finset (CandidatePair E))
    (hempty : emptyLines.card = baerEmptyLineCount (Nat.card F) f e)
    (hbad : ∀ l ∈ emptyLines,
      (forbidden l).card ≤ baerNonInvariantSecantOrbits k f e) :
    QuadraticBaerPairExtensionData (FixedLine F E) (CandidatePair E)
      (Nat.card F) k f e := by
  classical
  exact
    { toPairExtensionData := coordinatePairExtensionData F E hdeg emptyLines forbidden
      emptyLine_count := hempty
      candidate_count := fun l hl => coordinate_candidate_count F E hdeg emptyLines forbidden l hl
      forbidden_bound := hbad }

/-- Build the quadratic wrapper directly from an invariant coordinate arc.  The fixed-locus,
candidate-count, and occupied/empty-line formalizations discharge both exact cardinality fields;
only the local forbidden-orbit estimate remains. -/
noncomputable def coordinateQuadraticBaerPairExtensionDataOfArc
    (hdeg : Module.finrank F E = 2)
    (C : Finset (ProjectiveConjugation.Point E))
    (hArc : Arc (L := ProjectiveConjugation.Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (k f e : ℕ) (hkcard : C.card = k) (hf : (fixedArcPoints F E C).card = f)
    (horbit : k = f + 2 * e)
    (forbidden : FixedLine F E → Finset (CandidatePair E))
    (hbad : ∀ l ∈ emptyFixedLines F E C,
      (forbidden l).card ≤ baerNonInvariantSecantOrbits k f e) :
    QuadraticBaerPairExtensionData (FixedLine F E) (CandidatePair E)
      (Nat.card F) k f e := by
  apply coordinateQuadraticBaerPairExtensionData F E hdeg k f e
    (emptyFixedLines F E C) forbidden
  · apply card_emptyFixedLines F E hdeg C hArc hC f e hf
    omega
  · exact hbad

end
end QuadraticPairExtension
end RelativeConicArcs
