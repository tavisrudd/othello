import RelativeConicArcs.NinePointHeisenbergCanonicalDomain
import RelativeConicArcs.NinePointHeisenbergSelectedArc
import RelativeConicArcs.NinePointHeisenbergUncoveredArc
import RelativeConicArcs.NinePointHeisenbergUncoveredLocusY0To4
import RelativeConicArcs.NinePointHeisenbergUncoveredLocusY5To9
import RelativeConicArcs.NinePointHeisenbergUncoveredLocusY10To14
import RelativeConicArcs.NinePointHeisenbergUncoveredLocusY15To18AndInfinity

/-!
# Arc and uncovered-locus checks for a nine-point Heisenberg pair

The closed propositions assembled here cover every triple of both explicit nine-point sets and all
381 canonical projective points over `ZMod 19`.  The finite reductions occur in separate
coordinate-block modules; this module combines their kernel theorems without recomputation.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergUncoveredLocus

open NinePointHeisenbergIncidence

private theorem uncoveredLocusAgreementOn_append (left right : List NinePointHeisenbergPair.V) :
    uncoveredLocusAgreementOn (left ++ right) =
      (uncoveredLocusAgreementOn left && uncoveredLocusAgreementOn right) := by
  simp [uncoveredLocusAgreementOn]

/-- The coordinate domain consists of 381 distinct nonzero representatives. -/
theorem canonical_projective_point_domain :
    canonicalPoints.length = 381 ∧
    canonicalPoints.Nodup ∧
    canonicalPoints.all (fun p => decide (p ≠ 0)) = true :=
  NinePointHeisenbergCanonicalDomain.canonical_projective_point_domain

/-- Both displayed nine-point sets are projective arcs. -/
theorem both_sets_are_arcs :
    isCoordinateArc NinePointHeisenbergPair.selected = true ∧
    isCoordinateArc NinePointHeisenbergPair.uncovered = true :=
  ⟨NinePointHeisenbergSelectedArc.selected_set_is_arc,
    NinePointHeisenbergUncoveredArc.uncovered_set_is_arc⟩

/-- The displayed second set is exactly the ordinary uncovered locus of the first set. -/
theorem uncovered_is_exact_ordinary_uncovered_locus :
    uncoveredLocusAgreementOn canonicalPoints = true := by
  change uncoveredLocusAgreementOn
    (canonicalPointsY0To4 ++ canonicalPointsY5To9 ++ canonicalPointsY10To14 ++
      canonicalPointsY15To18AndInfinity) = true
  rw [uncoveredLocusAgreementOn_append, uncoveredLocusAgreementOn_append,
    uncoveredLocusAgreementOn_append,
    NinePointHeisenbergUncoveredLocusY0To4.uncovered_locus_agreement,
    NinePointHeisenbergUncoveredLocusY5To9.uncovered_locus_agreement,
    NinePointHeisenbergUncoveredLocusY10To14.uncovered_locus_agreement,
    NinePointHeisenbergUncoveredLocusY15To18AndInfinity.uncovered_locus_agreement]
  decide

end NinePointHeisenbergUncoveredLocus
end RelativeConicArcs
