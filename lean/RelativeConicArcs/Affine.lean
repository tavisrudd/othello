import RelativeConicArcs.Conic
import RelativeConicArcs.OddSixArcLineBound

/-!
# Complete affine arcs as a line-hole specialization

Deleting a projective line produces an affine plane.  An arc is complete in that affine plane
exactly when it is complete outside the deleted line.  This file specializes the prescribed-hole
defect package and records the exact line-incidence correction used in the manuscript.
-/

namespace RelativeConicArcs

open Configuration Finset

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

/-- Incidence formulation of completeness in the affine plane obtained by deleting `linfty`. -/
def CompleteAffine (A : Finset P) (linfty : L) : Prop :=
  Arc (L := L) A ∧ Disjoint A (pointsOnLine (P := P) linfty) ∧
    ∀ x, x ∉ A → x ∉ pointsOnLine (P := P) linfty → Covered (L := L) A x

omit [DecidableEq P] [DecidableEq L] [Configuration.ProjectivePlane P L] in
/-- Affine completeness is definitionally the line-hole instance of prescribed-hole
completeness. -/
theorem completeAffine_iff_completeOutside {A : Finset P} {linfty : L} :
    CompleteAffine (L := L) A linfty ↔
      CompleteOutside (L := L) A (pointsOnLine (P := P) linfty) := by
  rfl

/-- Every secant of an arc disjoint from a line contributes exactly one incidence on that line. -/
theorem holeIncidence_pointsOnLine {A : Finset P} (hA : Arc (L := L) A)
    (linfty : L) (hdisj : Disjoint A (pointsOnLine (P := P) linfty)) :
    holeIncidence (L := L) A (pointsOnLine (P := P) linfty) =
      Nat.choose A.card 2 := by
  rw [holeIncidence]
  apply OddSixArcLineBound.sum_pointIndex_on_nonsecant_line hA
  apply OddSixArcLineBound.nonsecant_of_disjoint
  exact hdisj.symm

/-- Integral form of the manuscript's corrected capacity bound for a complete affine arc. -/
theorem completeAffine_bound {A : Finset P} {linfty : L}
    (hcomplete : CompleteAffine (L := L) A linfty) :
    (A.card / 2) * (PlaneOrder P L ^ 2 - A.card)
        + Nat.choose A.card 2 + 6 * Nat.choose A.card 4 ≤
      (A.card / 2) * (Nat.choose A.card 2 * (PlaneOrder P L - 1)) := by
  have h := Conic.completeOutside_bound_of_card_holes
    (L := L) (completeAffine_iff_completeOutside.mp hcomplete)
    (card_pointsOnLine (P := P) linfty)
  rw [holeIncidence_pointsOnLine hcomplete.1 linfty hcomplete.2.1] at h
  exact h

/-- Equality in the affine corrected capacity bound has exactly the two extremal secant-index
patterns from the general defect identity, both at affine points and at ideal points. -/
theorem completeAffine_bound_eq_iff {A : Finset P} {linfty : L}
    (hcomplete : CompleteAffine (L := L) A linfty) :
    ((A.card / 2) * (PlaneOrder P L ^ 2 - A.card)
          + Nat.choose A.card 2 + 6 * Nat.choose A.card 4 =
        (A.card / 2) * (Nat.choose A.card 2 * (PlaneOrder P L - 1))) ↔
      (∀ x ∈ requiredLocus A (pointsOnLine (P := P) linfty),
        pointIndex (L := L) A x = 1 ∨ pointIndex (L := L) A x = A.card / 2) ∧
      (∀ y ∈ pointsOnLine (P := P) linfty,
        pointIndex (L := L) A y = 0 ∨ pointIndex (L := L) A y = A.card / 2) := by
  let H := pointsOnLine (P := P) linfty
  have hc : CompleteOutside (L := L) A H :=
    completeAffine_iff_completeOutside.mp hcomplete
  have hempty : uncovered (L := L) A H = ∅ :=
    (completeOutside_iff_uncovered_eq_empty (L := L)).mp hc |>.2.2
  have hcovered : coveredRequired (L := L) A H = requiredLocus A H := by
    rw [← covered_union_uncovered (L := L) A H, hempty, Finset.union_empty]
  have hcard : (coveredRequired (L := L) A H).card =
      PlaneOrder P L ^ 2 - A.card := by
    rw [hcovered]
    exact Conic.card_requiredLocus_of_card_holes hc.2.1
      (card_pointsOnLine (P := P) linfty)
  have hinc : holeIncidence (L := L) A H = Nat.choose A.card 2 :=
    holeIncidence_pointsOnLine hcomplete.1 linfty hcomplete.2.1
  have heqzero :
      ((A.card / 2) * (PlaneOrder P L ^ 2 - A.card)
            + Nat.choose A.card 2 + 6 * Nat.choose A.card 4 =
          (A.card / 2) * (Nat.choose A.card 2 * (PlaneOrder P L - 1))) ↔
        scaledDefect (L := L) A H = 0 := by
    rw [scaledDefect, hinc, hcard]
    omega
  rw [heqzero, scaledDefect_eq_zero_iff hc.1 hc.2.1, hcovered]

#print axioms holeIncidence_pointsOnLine
#print axioms completeAffine_bound
#print axioms completeAffine_bound_eq_iff

end RelativeConicArcs
