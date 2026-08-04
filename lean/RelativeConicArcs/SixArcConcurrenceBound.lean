import RelativeConicArcs.SixArcConcurrence
import RelativeConicArcs.QuadrangleDiagonal

/-!
# The ten-point bound for triple-concurrence points of a six-arc

In the projective plane over a field in which two is invertible, a six-arc has at most ten
triple-concurrence points, that is, at most ten points off the arc lying on three of its secants.

The proof combines two ingredients.  The incidence count of `SixArcConcurrence` reduces the bound
to the statement that a single secant carries at most two triple-concurrence points.  That
statement holds because a triple-concurrence point on a secant is a diagonal point of the complete
quadrangle formed by the four arc points off the secant: its remaining two chords pair those four
points, distinct triple-concurrence points on the secant pair them differently, and a quadrangle
admits only three pairings, whose three diagonal points are not collinear when two is invertible.

Classically the bound is Dye's inequality for the number of Brianchon points of a hexagon, and it
is sharp: the six-arcs attaining it are the Clebsch hexagons.
-/

namespace RelativeConicArcs
namespace SixArcConcurrence

open Finset Configuration

section Coordinate

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

noncomputable local instance instFintypePoint : Fintype (ProjectiveBridge.Point K) :=
  Fintype.ofFinite _

noncomputable local instance instDecidableEqPoint : DecidableEq (ProjectiveBridge.Point K) :=
  Classical.decEq _

/-- A secant of a six-arc carries at most two triple-concurrence points. -/
theorem card_filter_line_le_two (h2 : (2 : K) ≠ 0)
    {A : Finset (ProjectiveBridge.Point K)}
    (hA : Arc (L := ProjectiveBridge.Point K) A) (hcard : A.card = 6)
    (e : ArcPair A) :
    ((triplePoints (L := ProjectiveBridge.Point K) A).filter
      fun x => x ∈ e.line (L := ProjectiveBridge.Point K)).card ≤ 2 := by
  classical
  by_contra hgt
  push_neg at hgt
  obtain ⟨x, hx, y, hy, z, hz, hxy, hxz, hyz⟩ := Finset.two_lt_card_iff.mp hgt
  simp only [Finset.mem_filter] at hx hy hz
  obtain ⟨hxT, hxe⟩ := hx
  obtain ⟨hyT, hye⟩ := hy
  obtain ⟨hzT, hze⟩ := hz
  have hQcard : (A \ e.1).card = 4 := by
    rw [Finset.card_sdiff_of_subset e.subset, hcard, e.card]
  obtain ⟨a, ha⟩ : (A \ e.1).Nonempty := Finset.card_pos.mp (by rw [hQcard]; norm_num)
  obtain ⟨b, hb, hba, hxab⟩ := exists_partner_off_secant hA hcard hxT hxe ha
  obtain ⟨c, hc, hca, hyac⟩ := exists_partner_off_secant hA hcard hyT hye ha
  obtain ⟨d, hd, hda, hzad⟩ := exists_partner_off_secant hA hcard hzT hze ha
  have hab : a ≠ b := Ne.symm hba
  have hac : a ≠ c := Ne.symm hca
  have had : a ≠ d := Ne.symm hda
  have hbc : b ≠ c := by
    intro h
    exact not_collinear_common_chord hA hxe hye hxy ha hab hxab (by rw [h]; exact hyac)
  have hbd : b ≠ d := by
    intro h
    exact not_collinear_common_chord hA hxe hze hxz ha hab hxab (by rw [h]; exact hzad)
  have hcd : c ≠ d := by
    intro h
    exact not_collinear_common_chord hA hye hze hyz ha hac hyac (by rw [h]; exact hzad)
  -- the second chord of each triple-concurrence point joins the two remaining quadrangle points
  have hxcd := collinear_complement hA hcard hxT hxe ha hb hc hd hab hac had hbc hbd hcd hxab
  have hybd := collinear_complement hA hcard hyT hye ha hc hb hd hac hab had
    (Ne.symm hbc) hcd hbd hyac
  have hzbc := collinear_complement hA hcard hzT hze ha hd hb hc had hab hac
    (Ne.symm hbd) (Ne.symm hcd) hbc hzad
  -- the four quadrangle points are an arc, and the three points are its diagonal points
  have haA : a ∈ A := (Finset.mem_sdiff.mp ha).1
  have hbA : b ∈ A := (Finset.mem_sdiff.mp hb).1
  have hcA : c ∈ A := (Finset.mem_sdiff.mp hc).1
  have hdA : d ∈ A := (Finset.mem_sdiff.mp hd).1
  have hncol : ∀ {p q r : ProjectiveBridge.Point K}, p ∈ A → q ∈ A → r ∈ A →
      p ≠ q → p ≠ r → q ≠ r →
      ¬ ProjectiveCap.Projective.Collinear K (Fin 3 → K) p q r := by
    intro p q r hp hq hr hpq hpr hqr hcol
    exact hA hp hq hr hpq hpr hqr
      (ProjectiveBridge.collinear_iff_projective_collinear.mpr hcol)
  have hrank : Module.finrank K (Fin 3 → K) = 3 := by simp
  have hnc := QuadrangleDiagonal.not_collinear_diagonalPoints hrank h2
    (hncol haA hbA hcA hab hac hbc) (hncol haA hbA hdA hab had hbd)
    (hncol haA hcA hdA hac had hcd) (hncol hbA hcA hdA hbc hbd hcd)
    (ProjectiveBridge.collinear_iff_projective_collinear.mp hxab)
    (ProjectiveBridge.collinear_iff_projective_collinear.mp hxcd)
    (ProjectiveBridge.collinear_iff_projective_collinear.mp hyac)
    (ProjectiveBridge.collinear_iff_projective_collinear.mp hybd)
    (ProjectiveBridge.collinear_iff_projective_collinear.mp hzad)
    (ProjectiveBridge.collinear_iff_projective_collinear.mp hzbc)
  exact hnc (ProjectiveBridge.collinear_iff_projective_collinear.mp
    ⟨e.line (L := ProjectiveBridge.Point K), hxe, hye, hze⟩)

/-- **A six-arc has at most ten triple-concurrence points** in the projective plane over a field in
which two is invertible.  Classically this is Dye's bound on the number of Brianchon points of a
hexagon, here proved for every such field rather than for one order. -/
theorem card_triplePoints_le_ten (h2 : (2 : K) ≠ 0)
    {A : Finset (ProjectiveBridge.Point K)}
    (hA : Arc (L := ProjectiveBridge.Point K) A) (hcard : A.card = 6) :
    (triplePoints (L := ProjectiveBridge.Point K) A).card ≤ 10 :=
  card_triplePoints_le_ten_of_secant_bound hA hcard fun e =>
    card_filter_line_le_two h2 hA hcard e

end Coordinate

#print axioms card_triplePoints_le_ten

end SixArcConcurrence
end RelativeConicArcs
