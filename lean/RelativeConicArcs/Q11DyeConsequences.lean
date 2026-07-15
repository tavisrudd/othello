import RelativeConicArcs.SixArcDefectBridge

/-!
# Precisely axiomatized Dye consequences for the Clebsch hexagon

The geometric identity `|U(A)| + c(A) = 22` is proved in `SixArcDefectBridge` without Dye.
This file begins at the explicit two-axiom boundary in `Q11DyeAxioms`: Dye's bound gives the
universal lower bound `|U(A)| ≥ 12`, and equality inside a nonsingular conic invokes only Dye's
equality classification.  The `#print axioms` output therefore records the exact classical input
used by each result.
-/

namespace RelativeConicArcs.ClebschDye

noncomputable local instance : Fintype Point11 := Fintype.ofFinite _
noncomputable local instance : DecidableEq Point11 := Classical.decEq _

/-- Dye's Brianchon bound and the proved defect identity force at least twelve uncovered points. -/
theorem sixArc_twelve_le_uncovered_card
    {A : Finset Point11}
    (hA : Arc (L := Point11) A)
    (hcard : A.card = 6) :
    12 ≤ (uncovered (L := Point11) A ∅).card := by
  have hsum := sixArc_uncovered_add_brianchon_card hA hcard
  have hbound := dye1991_brianchon_bound hA hcard
  omega

/-- If the uncovered locus of a six-arc is contained in a nonsingular conic, it has all twelve
points of that conic and the Brianchon bound is sharp. -/
theorem sixArc_cards_of_uncovered_subset_conic
    {A : Finset Point11}
    (hA : Arc (L := Point11) A)
    (hcard : A.card = 6)
    (C : Conic.NonsingularConic (K := K11))
    (hsubset : uncovered (L := Point11) A ∅ ⊆ C.points) :
    (uncovered (L := Point11) A ∅).card = 12 ∧
      (brianchonPoints A).card = 10 := by
  have hsum := sixArc_uncovered_add_brianchon_card hA hcard
  have hlower := sixArc_twelve_le_uncovered_card hA hcard
  have hupper := Finset.card_le_card hsubset
  rw [C.card_points] at hupper
  norm_num [K11] at hupper
  omega

/-- **Conditional Clebsch rigidity at the exact Dye seam.**  A six-arc whose uncovered locus is
contained in a nonsingular conic is projectively equivalent to the certified Clebsch witness. -/
theorem isClebschHexagon_of_uncovered_subset_conic
    {A : Finset Point11}
    (hA : Arc (L := Point11) A)
    (hcard : A.card = 6)
    (C : Conic.NonsingularConic (K := K11))
    (hsubset : uncovered (L := Point11) A ∅ ⊆ C.points) :
    IsClebschHexagon A := by
  have hcards := sixArc_cards_of_uncovered_subset_conic hA hcard C hsubset
  exact dye1991_equality_classification hA hcard hcards.2

#print axioms sixArc_twelve_le_uncovered_card
#print axioms sixArc_cards_of_uncovered_subset_conic
#print axioms isClebschHexagon_of_uncovered_subset_conic

end RelativeConicArcs.ClebschDye
