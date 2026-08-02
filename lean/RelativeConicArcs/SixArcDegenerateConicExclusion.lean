import RelativeConicArcs.OddSixArcPrismExtraction
import RelativeConicArcs.Q11DyeConsequences
import Mathlib.LinearAlgebra.QuadraticForm.IsometryEquiv

/-!
# Degenerate containing conics for six-arcs over the field of order eleven

A nonzero ternary quadratic over a field of odd characteristic has one of two
point-set types relevant here.  Its rational zero locus is either a nonsingular
conic, or it is contained in the union of two rational projective lines.  The
latter alternative includes a repeated line and the nonsplit rank-two case,
whose only rational zero is the singular point.

`PlaneQuadraticLocus` records a nonzero quadratic form, its exact rational
projective zero locus, and this classical conic-type conclusion, without
choosing coordinates or a factorization.  Starting from that interface, this
module proves the complete incidence-theoretic consequence needed for
rigidity: a six-arc over `ZMod 11` has at most twelve uncovered points on any
such locus.  The degenerate branch uses the odd six-arc line bound, while the
nonsingular branch uses the cardinality of a projective conic.
-/

namespace RelativeConicArcs.ClebschDye

open Configuration

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

noncomputable local instance : Fintype Point11 := Fintype.ofFinite _
noncomputable local instance : DecidableEq Point11 := Classical.decEq _

/-- A nonzero ternary quadratic over `ZMod 11`, together with the exact
point-set conclusion of its classical conic-type classification.  In the
degenerate branch the rational zero locus is contained in two projective lines;
taking the lines equal covers a repeated line, and taking any two lines through
the singular point covers the nonsplit rank-two case. -/
structure PlaneQuadraticLocus where
  /-- The nonzero homogeneous quadratic form. -/
  form : QuadraticForm K11 Space11
  /-- The defining quadratic is not the zero form. -/
  form_ne_zero : form ≠ 0
  /-- The conic is nonsingular, or its rational points lie on at most two lines. -/
  conicType :
    (∃ C : Conic.NonsingularConic (K := K11),
      Finset.univ.filter (fun p : Point11 ↦ form p.rep = 0) = C.points) ∨
      (∃ l m : Point11,
        Finset.univ.filter (fun p : Point11 ↦ form p.rep = 0) ⊆
          pointsOnLine (P := Point11) l ∪ pointsOnLine (P := Point11) m)

/-- The rational projective zero locus of a nonzero ternary quadratic. -/
noncomputable def PlaneQuadraticLocus.points (Q : PlaneQuadraticLocus) : Finset Point11 :=
  Finset.univ.filter fun p ↦ Q.form p.rep = 0

/-- The projective plane over `ZMod 11` has order eleven. -/
private theorem planeOrder_point11 : PlaneOrder Point11 Point11 = 11 := by
  rw [RelativeConicArcs.ProjectiveBridge.planeOrder_eq_card]
  norm_num [K11]

/-- Each projective line contains at most six ordinary uncovered points of a
six-arc over `ZMod 11`. -/
theorem sixArc_uncoveredOnLine_card_le_six
    {A : Finset Point11} (hA : Arc (L := Point11) A) (hcard : A.card = 6)
    (l : Point11) :
    (OddSixArcLineBound.uncoveredOnLine (P := Point11) A l).card ≤ 6 := by
  have h := OddSixArcPrismExtraction.sixArc_uncoveredOnLine_card_le_order_sub_five
    (K := K11) hA hcard (by decide) l
  rw [planeOrder_point11] at h
  exact h

/-- If the uncovered locus of a six-arc is contained in two projective lines,
then it has at most twelve points. -/
theorem sixArc_uncovered_card_le_twelve_of_subset_two_lines
    {A : Finset Point11} (hA : Arc (L := Point11) A) (hcard : A.card = 6)
    {l m : Point11}
    (hsubset : uncovered (L := Point11) A ∅ ⊆
      pointsOnLine (P := Point11) l ∪ pointsOnLine (P := Point11) m) :
    (uncovered (L := Point11) A ∅).card ≤ 12 := by
  classical
  let Ul := OddSixArcLineBound.uncoveredOnLine (P := Point11) A l
  let Um := OddSixArcLineBound.uncoveredOnLine (P := Point11) A m
  have hU : uncovered (L := Point11) A ∅ ⊆ Ul ∪ Um := by
    intro x hx
    have hxLines := hsubset hx
    simp only [Finset.mem_union] at hxLines ⊢
    rcases hxLines with hxl | hxm
    · left
      exact Finset.mem_inter.mpr ⟨hxl, hx⟩
    · right
      exact Finset.mem_inter.mpr ⟨hxm, hx⟩
  have hl : Ul.card ≤ 6 := sixArc_uncoveredOnLine_card_le_six hA hcard l
  have hm : Um.card ≤ 6 := sixArc_uncoveredOnLine_card_le_six hA hcard m
  calc
    (uncovered (L := Point11) A ∅).card ≤ (Ul ∪ Um).card :=
      Finset.card_le_card hU
    _ ≤ Ul.card + Um.card := Finset.card_union_le Ul Um
    _ ≤ 12 := by omega

/-- Containment in the rational zero locus of a nonzero plane quadratic gives
the upper bound needed by the rigidity argument, independently of whether the
quadratic is nonsingular or degenerate. -/
theorem sixArc_uncovered_card_le_twelve_of_subset_planeQuadraticLocus
    {A : Finset Point11} (hA : Arc (L := Point11) A) (hcard : A.card = 6)
    (Q : PlaneQuadraticLocus)
    (hsubset : uncovered (L := Point11) A ∅ ⊆ Q.points) :
    (uncovered (L := Point11) A ∅).card ≤ 12 := by
  rcases Q.conicType with ⟨C, hC⟩ | ⟨l, m, hlm⟩
  · have hpoints : (uncovered (L := Point11) A ∅).card ≤ C.points.card :=
      Finset.card_le_card (hsubset.trans (by
        intro p hp
        rw [PlaneQuadraticLocus.points] at hp
        exact hC ▸ hp))
    rw [C.card_points] at hpoints
    norm_num [K11] at hpoints
    exact hpoints
  · exact sixArc_uncovered_card_le_twelve_of_subset_two_lines hA hcard
      (hsubset.trans hlm)

#print axioms sixArc_uncoveredOnLine_card_le_six
#print axioms sixArc_uncovered_card_le_twelve_of_subset_two_lines
#print axioms sixArc_uncovered_card_le_twelve_of_subset_planeQuadraticLocus

end RelativeConicArcs.ClebschDye
