import RelativeConicArcs.Nucleus

/-!
# Small-field exclusions for the Clebsch conic-filling problem

The characteristic-two leaf is incidence-theoretic.  A `(q+2)`-arc is a hyperoval, every line
meets it in zero or two points, and therefore every point outside it lies on a secant.  In
particular a six-arc in a plane of order four has empty ordinary uncovered locus.
-/

namespace RelativeConicArcs
namespace ClebschSmallFields

open Configuration Finset
open Nucleus

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

/-- Every hyperoval is a complete arc: a line joining an external point to any hyperoval point
must contain a second hyperoval point. -/
theorem hyperoval_complete {A : Finset P} (hA : Arc (L := L) A)
    (hcard : A.card = PlaneOrder P L + 2) :
    CompleteOutside (L := L) A ∅ := by
  refine ⟨hA, by simp, ?_⟩
  intro x hxA _hxEmpty
  have hq := Configuration.ProjectivePlane.one_lt_order P L
  have hAne : A.Nonempty := by
    rw [Finset.nonempty_iff_ne_empty]
    intro hzero
    rw [hzero, Finset.card_empty] at hcard
    omega
  obtain ⟨a, haA⟩ := hAne
  have hxa : x ≠ a := fun h => hxA (h ▸ haA)
  let l : L := Configuration.HasLines.mkLine (P := P) (L := L) hxa
  have hxl : x ∈ l := (Configuration.HasLines.mkLine_ax (P := P) (L := L) hxa).1
  have hal : a ∈ l := (Configuration.HasLines.mkLine_ax (P := P) (L := L) hxa).2
  have haSlice : a ∈ lineSlice A l := mem_lineSlice.mpr ⟨hal, haA⟩
  have hslicePos : 0 < (lineSlice A l).card := Finset.card_pos.mpr ⟨a, haSlice⟩
  have hslice : (lineSlice A l).card = 2 := by
    rcases hyperoval_lineSlice_card hA hcard l with hzero | htwo
    · omega
    · exact htwo
  obtain ⟨b, hbSlice, hba⟩ : ∃ b ∈ lineSlice A l, b ≠ a := by
    by_contra h
    push Not at h
    have hsub : lineSlice A l ⊆ {a} := by
      intro b hb
      simpa [h b hb]
    have hle := Finset.card_le_card hsub
    simp [hslice] at hle
  exact covered_iff_exists_secant.mpr
    ⟨l, ⟨a, haA, b, (mem_lineSlice.mp hbSlice).2, hba.symm,
      hal, (mem_lineSlice.mp hbSlice).1⟩, hxl⟩

/-- A six-arc in a projective plane of order four is a complete hyperoval. -/
theorem six_arc_order_four_complete {A : Finset P} (hA : Arc (L := L) A)
    (hAcard : A.card = 6) (horder : PlaneOrder P L = 4) :
    CompleteOutside (L := L) A ∅ := by
  apply hyperoval_complete hA
  omega

/-- Consequently the ordinary uncovered locus of a six-arc at order four is empty. -/
theorem six_arc_order_four_uncovered_empty {A : Finset P} (hA : Arc (L := L) A)
    (hAcard : A.card = 6) (horder : PlaneOrder P L = 4) :
    uncovered (L := L) A ∅ = ∅ :=
  (completeOutside_iff_uncovered_eq_empty (L := L)).mp
    (six_arc_order_four_complete hA hAcard horder) |>.2.2

#print axioms hyperoval_complete
#print axioms six_arc_order_four_uncovered_empty

end ClebschSmallFields
end RelativeConicArcs
