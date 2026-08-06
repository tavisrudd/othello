import RelativeConicArcs.SixArcDegenerateConicExclusion

/-!
# Causal rigidity spine for six-arcs over the field of order eleven

This module composes the geometric upper bound for a containing plane
quadratic with the exact six-arc defect identity and the two order-eleven
Brianchon statements.  The order is essential: the containing locus first gives
at most twelve uncovered points; the Brianchon bound gives at least twelve;
equality then invokes the classification of the Clebsch hexagon.

The bound and the equality classification are proved in
`Q11BrianchonClassification`, so the terminal theorem below depends on no
nonlogical axiom.  Dye 1991 states both and is cited there as their antecedent.
-/

namespace RelativeConicArcs.ClebschDye

open Configuration

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

noncomputable local instance : Fintype Point11 := Fintype.ofFinite _
noncomputable local instance : DecidableEq Point11 := Classical.decEq _

/-- A six-arc whose ordinary uncovered locus lies on a nonzero plane quadratic
is projectively equivalent to the displayed Clebsch hexagon. -/
theorem isClebschHexagon_of_uncovered_subset_planeConic
    {A : Finset Point11}
    (hA : Arc (L := Point11) A)
    (hcard : A.card = 6)
    (Q : PlaneQuadraticLocus)
    (hsubset : uncovered (L := Point11) A ∅ ⊆ Q.points) :
    IsClebschHexagon A := by
  have hupper : (uncovered (L := Point11) A ∅).card ≤ 12 :=
    sixArc_uncovered_card_le_twelve_of_subset_planeQuadraticLocus
      hA hcard Q hsubset
  have hlower : 12 ≤ (uncovered (L := Point11) A ∅).card :=
    sixArc_twelve_le_uncovered_card hA hcard
  have hdefect := sixArc_uncovered_add_brianchon_card hA hcard
  have heq : (brianchonPoints A).card = 10 := by omega
  exact dye1991_equality_classification hA hcard heq

#print axioms isClebschHexagon_of_uncovered_subset_planeConic

end RelativeConicArcs.ClebschDye
