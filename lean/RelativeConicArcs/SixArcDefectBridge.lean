import RelativeConicArcs.ClebschChordDefect
import RelativeConicArcs.Defect
import RelativeConicArcs.Q11DyeAxioms

/-!
# The geometric six-arc defect bridge in `PG(2,11)`

The abstract chord-defect arithmetic is useful only after its variables have been identified with
the actual secant-index fibers of a projective six-arc.  This file supplies that bridge directly in
the coordinate projective plane over `ZMod 11`.

For an off-arc point of a six-arc the secant index is at most three.  On the four possible indices
`r = 0, 1, 2, 3`, the elementary identity

`1_[r=0] + 1_[r=3] = 1 - r + choose(r,2)`

turns the two classical secant moments into the exact equality `u + c = 22`.  Here `u` is the
ordinary uncovered cardinality and `c` is the actual triple-concurrence (Brianchon-point)
cardinality.  The proof uses no clause of Dye's theorem; `Q11DyeAxioms` is imported only for the
definition of `brianchonPoints`.
-/

namespace RelativeConicArcs.ClebschDye

open Configuration Finset
open scoped LinearAlgebra.Projectivization

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

noncomputable local instance : Fintype Point11 := Fintype.ofFinite _
noncomputable local instance : DecidableEq Point11 := Classical.decEq _

/-- The projective plane over `ZMod 11` has 133 points. -/
private theorem card_point11 : Fintype.card Point11 = 133 := by
  rw [← Nat.card_eq_fintype_card,
    Projectivization.card_of_finrank K11 (Fin 3 → K11) (n := 3) (by simp)]
  norm_num [Finset.sum_range_succ]

/-- The secant-index-zero fiber off `A` is the ordinary uncovered locus. -/
private theorem uncovered_eq_indexZero (A : Finset Point11) :
    uncovered (L := Point11) A ∅ =
      (Finset.univ \ A).filter fun x => pointIndex (L := Point11) A x = 0 := by
  classical
  ext x
  simp [uncovered, requiredLocus, Covered]

/-- **Actual six-arc defect identity in `PG(2,11)`.**  The ordinary uncovered points and the
off-arc points on three secants have total cardinality 22. -/
theorem sixArc_uncovered_add_brianchon_card
    {A : Finset Point11}
    (hA : Arc (L := Point11) A)
    (hcard : A.card = 6) :
    (uncovered (L := Point11) A ∅).card + (brianchonPoints A).card = 22 := by
  classical
  let E : Finset Point11 := Finset.univ \ A

  have hEcard : E.card = 127 := by
    dsimp [E]
    rw [Finset.card_sdiff_of_subset (Finset.subset_univ A), Finset.card_univ,
      card_point11, hcard]

  have horder : PlaneOrder Point11 Point11 = 11 := by
    rw [ProjectiveBridge.planeOrder_eq_card]
    norm_num [K11]

  have hfirstNat := first_secant_moment (L := Point11) hA
  change (∑ x ∈ E, pointIndex (L := Point11) A x) = _ at hfirstNat
  rw [hcard, horder] at hfirstNat
  norm_num at hfirstNat
  have hfirst :
      (∑ x ∈ E, (pointIndex (L := Point11) A x : ℤ)) = 150 := by
    exact_mod_cast hfirstNat

  have hsecondNat := second_secant_moment (L := Point11) hA
  change (∑ x ∈ E, Nat.choose (pointIndex (L := Point11) A x) 2) = _ at hsecondNat
  rw [hcard] at hsecondNat
  have hsecond :
      (∑ x ∈ E, (Nat.choose (pointIndex (L := Point11) A x) 2 : ℤ)) = 45 := by
    exact_mod_cast hsecondNat

  have hindex_le_three (x : Point11) (hx : x ∈ E) :
      pointIndex (L := Point11) A x ≤ 3 := by
    have hxA : x ∉ A := (Finset.mem_sdiff.mp hx).2
    simpa [hcard] using pointIndex_le_half_card (L := Point11) hA hxA

  have hindicator (x : Point11) (hx : x ∈ E) :
      (if pointIndex (L := Point11) A x = 0 then (1 : ℤ) else 0) +
          (if pointIndex (L := Point11) A x = 3 then (1 : ℤ) else 0) =
        1 - (pointIndex (L := Point11) A x : ℤ) +
          (Nat.choose (pointIndex (L := Point11) A x) 2 : ℤ) := by
    have hle := hindex_le_three x hx
    interval_cases hidx : pointIndex (L := Point11) A x <;>
      norm_num [hidx, Nat.choose]

  have hsum :
      (((E.filter fun x => pointIndex (L := Point11) A x = 0).card : ℕ) : ℤ) +
          (((E.filter fun x => pointIndex (L := Point11) A x = 3).card : ℕ) : ℤ) =
        22 := by
    calc
      (((E.filter fun x => pointIndex (L := Point11) A x = 0).card : ℕ) : ℤ) +
            (((E.filter fun x => pointIndex (L := Point11) A x = 3).card : ℕ) : ℤ) =
          ∑ x ∈ E,
            ((if pointIndex (L := Point11) A x = 0 then (1 : ℤ) else 0) +
              (if pointIndex (L := Point11) A x = 3 then (1 : ℤ) else 0)) := by
              simp_rw [Finset.card_eq_sum_ones, Finset.sum_filter]
              push_cast
              rw [Finset.sum_add_distrib]
      _ = ∑ x ∈ E,
            (1 - (pointIndex (L := Point11) A x : ℤ) +
              (Nat.choose (pointIndex (L := Point11) A x) 2 : ℤ)) := by
              apply Finset.sum_congr rfl
              intro x hx
              exact hindicator x hx
      _ = (E.card : ℤ) -
            (∑ x ∈ E, (pointIndex (L := Point11) A x : ℤ)) +
            (∑ x ∈ E,
              (Nat.choose (pointIndex (L := Point11) A x) 2 : ℤ)) := by
              simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib,
                Finset.sum_const, nsmul_eq_mul]
              ring
      _ = 22 := by rw [hEcard, hfirst, hsecond]; norm_num

  have hu : uncovered (L := Point11) A ∅ =
      E.filter fun x => pointIndex (L := Point11) A x = 0 := by
    simpa [E] using uncovered_eq_indexZero A
  have hc : brianchonPoints A =
      E.filter fun x => pointIndex (L := Point11) A x = 3 := by
    simp [brianchonPoints, E]
  rw [hu, hc]
  exact_mod_cast hsum

#print axioms sixArc_uncovered_add_brianchon_card

end RelativeConicArcs.ClebschDye
