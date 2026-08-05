import RelativeConicArcs.Certificate
import RelativeConicArcs.Examples
import RelativeConicArcs.SixArcGoldenNormalForm

/-!
# The golden hexagon at order eleven is the displayed six-arc witness

A six-arc of the projective plane over a field in which two is invertible, having exactly ten
points off the arc on three of its secants, carries a projective frame `u₀, u₁, u₂` and a scalar
`φ` with `φ² = φ + 1` in which its six points are

`(1 : 0 : 0)`, `(φ : 1 : 1)`, `(0 : 1 : 0)`, `(1 : φ : 1)`, `(0 : 0 : 1)`, `(1 : 1 : 2 - φ)`.

Over the field of eleven elements the golden relation has exactly the two roots `4` and `8`, so
that normal form leaves exactly two coordinate configurations.  This file exhibits for each root an
explicit linear automorphism of `(ZMod 11)³` carrying the corresponding golden hexagon onto the
six-point set represented by the frozen coordinate list `RelativeConicArcs.Examples.q11Witness`,
namely

`(1 : 10 : 0)`, `(1 : 9 : 1)`, `(1 : 4 : 7)`, `(1 : 8 : 5)`, `(0 : 1 : 4)`, `(1 : 1 : 7)`.

The automorphism is the composite of the frame change sending `u₀, u₁, u₂` to the standard basis
with the matrix whose columns are listed below, acting on column vectors modulo eleven:

* for `φ = 4`, the columns `(2, 9, 0)`, `(0, 9, 3)`, `(10, 7, 4)`;
* for `φ = 8`, the columns `(1, 10, 0)`, `(7, 6, 5)`, `(9, 9, 8)`.

Both matrices have determinant `3`, so both are invertible.  In each case the six images agree with
the six listed points up to the nonzero scalars recorded in the proof, and the two orders in which
they arrive differ from the list order by a transposition and by a three-cycle respectively.

Every arithmetic step is checked by kernel reduction over `ZMod 11`; no native evaluation, external
certificate, or additional axiom is used.
-/

namespace RelativeConicArcs
namespace Q11GoldenHexagonWitness

open Projectivization

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

noncomputable local instance : Fintype (ProjectiveBridge.Point (ZMod 11)) := Fintype.ofFinite _

noncomputable local instance : DecidableEq (ProjectiveBridge.Point (ZMod 11)) := Classical.decEq _

/-- The golden relation `φ² = φ + 1` has exactly the roots `4` and `8` in the field of eleven
elements. -/
private theorem golden_root_eq : ∀ φ : ZMod 11, φ * φ = φ + 1 → φ = 4 ∨ φ = 8 := by decide

/-- A linear automorphism of `(ZMod 11)³` carrying a given basis to a given triple of vectors of
nonzero determinant, with the three images recorded pointwise. -/
private theorem exists_linearEquiv_frame_image
    {u : Fin 3 → (Fin 3 → ZMod 11)} (hu : LinearIndependent (ZMod 11) u)
    (a b c : Fin 3 → ZMod 11)
    (hdet : (Matrix.of ![a, b, c]).det ≠ 0) :
    ∃ g : (Fin 3 → ZMod 11) ≃ₗ[ZMod 11] (Fin 3 → ZMod 11),
      g (u 0) = a ∧ g (u 1) = b ∧ g (u 2) = c := by
  classical
  have hunit : IsUnit (Matrix.of ![a, b, c]) :=
    (Matrix.isUnit_iff_isUnit_det _).mpr (isUnit_iff_ne_zero.mpr hdet)
  have hrows : LinearIndependent (ZMod 11) (Matrix.of ![a, b, c]) := by
    simpa [Matrix.row] using
      (Matrix.linearIndependent_rows_iff_isUnit (A := Matrix.of ![a, b, c])).mpr hunit
  have hc : LinearIndependent (ZMod 11) ![a, b, c] := hrows
  have hcard3 : Fintype.card (Fin 3) = Module.finrank (ZMod 11) (Fin 3 → ZMod 11) := by simp
  let bu := basisOfLinearIndependentOfCardEqFinrank hu hcard3
  let bc := basisOfLinearIndependentOfCardEqFinrank hc hcard3
  have hbu : ⇑bu = u := coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hbc : ⇑bc = ![a, b, c] := coe_basisOfLinearIndependentOfCardEqFinrank _ _
  refine ⟨bu.equiv bc (Equiv.refl (Fin 3)), ?_, ?_, ?_⟩ <;>
    · rw [← hbu]
      simp [hbc]

/-- The point permutation induced by `g` sends the point of `v` to the point of `w` as soon as
`g v` is a scalar multiple of `w`. -/
private theorem mapEquiv_mk_eq_mk_of_smul
    {g : (Fin 3 → ZMod 11) ≃ₗ[ZMod 11] (Fin 3 → ZMod 11)} {v w : Fin 3 → ZMod 11}
    (hv : v ≠ 0) (hw : w ≠ 0) (a : ZMod 11) (h : a • w = g v) :
    ProjectiveCap.Projective.mapEquiv g (Projectivization.mk (ZMod 11) v hv)
      = Projectivization.mk (ZMod 11) w hw := by
  rw [ProjectiveCap.Projective.mapEquiv_mk]
  exact (Projectivization.mk_eq_mk_iff' (ZMod 11) _ _ _ hw).mpr ⟨a, h⟩

/-- Exchanging the third and fifth entries of a six-element listing does not change the set it
enumerates. -/
private theorem sextuple_swap_third_fifth {P : Type*} [DecidableEq P] {a b c d e f : P} :
    ({a, b, e, d, c, f} : Finset P) = {a, b, c, d, e, f} := by
  ext x
  simp only [Finset.mem_insert, Finset.mem_singleton]
  tauto

/-- Cycling the last three entries of a six-element listing does not change the set it
enumerates. -/
private theorem sextuple_cycle_last_three {P : Type*} [DecidableEq P] {a b c d e f : P} :
    ({a, b, c, e, f, d} : Finset P) = {a, b, c, d, e, f} := by
  ext x
  simp only [Finset.mem_insert, Finset.mem_singleton]
  tauto

/-- The six projective points represented by the frozen coordinate list of the order-eleven
six-arc witness. -/
private theorem pointSet_q11Witness :
    Certificate.pointSet Examples.q11Witness =
      ({Projectivization.mk (ZMod 11) ![1, 10, 0] (by decide),
        Projectivization.mk (ZMod 11) ![1, 9, 1] (by decide),
        Projectivization.mk (ZMod 11) ![1, 4, 7] (by decide),
        Projectivization.mk (ZMod 11) ![1, 8, 5] (by decide),
        Projectivization.mk (ZMod 11) ![0, 1, 4] (by decide),
        Projectivization.mk (ZMod 11) ![1, 1, 7] (by decide)} :
        Finset (ProjectiveBridge.Point (ZMod 11))) := by
  have hlist : Examples.q11Witness =
      [⟨![1, 10, 0], by decide⟩, ⟨![1, 9, 1], by decide⟩, ⟨![1, 4, 7], by decide⟩,
        ⟨![1, 8, 5], by decide⟩, ⟨![0, 1, 4], by decide⟩, ⟨![1, 1, 7], by decide⟩] := by
    decide
  ext x
  simp [Certificate.pointSet, hlist, Certificate.toPoint]

/-- **A six-arc of `PG(2,11)` with ten triple-concurrence points is projectively the displayed
witness.**  If `A` is a six-arc of the projective plane over the field of eleven elements and
exactly ten points off `A` lie on three of its secants, then some linear automorphism of
`(ZMod 11)³` carries `A` onto the six-point set represented by
`RelativeConicArcs.Examples.q11Witness`. -/
theorem exists_mapEquiv_toWitness
    {A : Finset (ProjectiveBridge.Point (ZMod 11))}
    (hA : Arc (L := ProjectiveBridge.Point (ZMod 11)) A) (hcard : A.card = 6)
    (hten : (SixArcConcurrence.triplePoints
      (L := ProjectiveBridge.Point (ZMod 11)) A).card = 10) :
    ∃ g : (Fin 3 → ZMod 11) ≃ₗ[ZMod 11] (Fin 3 → ZMod 11),
      A.map (ProjectiveCap.Projective.mapEquiv g).toEmbedding =
        Certificate.pointSet Examples.q11Witness := by
  classical
  obtain ⟨u, hu, φ, hφ, h₀, h₁, h₂, h₃, h₄, h₅, hAval⟩ :=
    SixArcGoldenNormalForm.exists_golden_frame (K := ZMod 11) (by decide) hA hcard hten
  rcases golden_root_eq φ hφ with rfl | rfl
  · obtain ⟨g, hga, hgb, hgc⟩ :=
      exists_linearEquiv_frame_image hu ![2, 9, 0] ![0, 9, 3] ![10, 7, 4] (by decide)
    refine ⟨g, ?_⟩
    have e₁ : ProjectiveCap.Projective.mapEquiv g (Projectivization.mk (ZMod 11) (u 0) h₀)
        = Projectivization.mk (ZMod 11) ![1, 10, 0] (by decide) :=
      mapEquiv_mk_eq_mk_of_smul h₀ (by decide) 2 (by rw [hga]; decide)
    have e₂ : ProjectiveCap.Projective.mapEquiv g
          (Projectivization.mk (ZMod 11) (4 • u 0 + u 1 + u 2) h₃)
        = Projectivization.mk (ZMod 11) ![1, 9, 1] (by decide) :=
      mapEquiv_mk_eq_mk_of_smul h₃ (by decide) 7
        (by rw [map_add, map_add, map_smul, hga, hgb, hgc]; decide)
    have e₃ : ProjectiveCap.Projective.mapEquiv g (Projectivization.mk (ZMod 11) (u 1) h₁)
        = Projectivization.mk (ZMod 11) ![0, 1, 4] (by decide) :=
      mapEquiv_mk_eq_mk_of_smul h₁ (by decide) 9 (by rw [hgb]; decide)
    have e₄ : ProjectiveCap.Projective.mapEquiv g
          (Projectivization.mk (ZMod 11) (u 0 + 4 • u 1 + u 2) h₄)
        = Projectivization.mk (ZMod 11) ![1, 8, 5] (by decide) :=
      mapEquiv_mk_eq_mk_of_smul h₄ (by decide) 1
        (by rw [map_add, map_add, map_smul, hga, hgb, hgc]; decide)
    have e₅ : ProjectiveCap.Projective.mapEquiv g (Projectivization.mk (ZMod 11) (u 2) h₂)
        = Projectivization.mk (ZMod 11) ![1, 4, 7] (by decide) :=
      mapEquiv_mk_eq_mk_of_smul h₂ (by decide) 10 (by rw [hgc]; decide)
    have e₆ : ProjectiveCap.Projective.mapEquiv g
          (Projectivization.mk (ZMod 11) (u 0 + u 1 + (2 - 4) • u 2) h₅)
        = Projectivization.mk (ZMod 11) ![1, 1, 7] (by decide) :=
      mapEquiv_mk_eq_mk_of_smul h₅ (by decide) 4
        (by rw [map_add, map_add, map_smul, hga, hgb, hgc]; decide)
    rw [hAval, pointSet_q11Witness]
    simp only [Finset.map_insert, Finset.map_singleton, Equiv.coe_toEmbedding,
      e₁, e₂, e₃, e₄, e₅, e₆]
    exact sextuple_swap_third_fifth
  · obtain ⟨g, hga, hgb, hgc⟩ :=
      exists_linearEquiv_frame_image hu ![1, 10, 0] ![7, 6, 5] ![9, 9, 8] (by decide)
    refine ⟨g, ?_⟩
    have e₁ : ProjectiveCap.Projective.mapEquiv g (Projectivization.mk (ZMod 11) (u 0) h₀)
        = Projectivization.mk (ZMod 11) ![1, 10, 0] (by decide) :=
      mapEquiv_mk_eq_mk_of_smul h₀ (by decide) 1 (by rw [hga]; decide)
    have e₂ : ProjectiveCap.Projective.mapEquiv g
          (Projectivization.mk (ZMod 11) (8 • u 0 + u 1 + u 2) h₃)
        = Projectivization.mk (ZMod 11) ![1, 9, 1] (by decide) :=
      mapEquiv_mk_eq_mk_of_smul h₃ (by decide) 2
        (by rw [map_add, map_add, map_smul, hga, hgb, hgc]; decide)
    have e₃ : ProjectiveCap.Projective.mapEquiv g (Projectivization.mk (ZMod 11) (u 1) h₁)
        = Projectivization.mk (ZMod 11) ![1, 4, 7] (by decide) :=
      mapEquiv_mk_eq_mk_of_smul h₁ (by decide) 7 (by rw [hgb]; decide)
    have e₄ : ProjectiveCap.Projective.mapEquiv g
          (Projectivization.mk (ZMod 11) (u 0 + 8 • u 1 + u 2) h₄)
        = Projectivization.mk (ZMod 11) ![0, 1, 4] (by decide) :=
      mapEquiv_mk_eq_mk_of_smul h₄ (by decide) 1
        (by rw [map_add, map_add, map_smul, hga, hgb, hgc]; decide)
    have e₅ : ProjectiveCap.Projective.mapEquiv g (Projectivization.mk (ZMod 11) (u 2) h₂)
        = Projectivization.mk (ZMod 11) ![1, 1, 7] (by decide) :=
      mapEquiv_mk_eq_mk_of_smul h₂ (by decide) 9 (by rw [hgc]; decide)
    have e₆ : ProjectiveCap.Projective.mapEquiv g
          (Projectivization.mk (ZMod 11) (u 0 + u 1 + (2 - 8) • u 2) h₅)
        = Projectivization.mk (ZMod 11) ![1, 8, 5] (by decide) :=
      mapEquiv_mk_eq_mk_of_smul h₅ (by decide) 9
        (by rw [map_add, map_add, map_smul, hga, hgb, hgc]; decide)
    rw [hAval, pointSet_q11Witness]
    simp only [Finset.map_insert, Finset.map_singleton, Equiv.coe_toEmbedding,
      e₁, e₂, e₃, e₄, e₅, e₆]
    exact sextuple_cycle_last_three

#print axioms exists_mapEquiv_toWitness

end Q11GoldenHexagonWitness
end RelativeConicArcs
