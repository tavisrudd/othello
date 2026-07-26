import RelativeConicArcs.ConicSecantInvolution

/-!
# Zero-defect invariance under conic secant involutions

For an even arc, a point of maximum secant index supports a perfect matching of the arc:
every arc vertex has a unique partner on a secant through that point.  If the prescribed hole set
is the standard conic and the defect is zero, this perfect-matching property shows that the
secant involution associated with any arc point preserves the maximum-index conic parameters.

At the exceptional parameter pair with field order `4096` and arc size `92`, the maximum-index
parameter set has cardinality `91`.
-/

namespace RelativeConicArcs

open Conic Nucleus
open scoped LinearAlgebra.Projectivization

section PerfectMatching

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

omit [Fintype P] in
/-- If an external point has the maximum possible secant index and the arc has even cardinality,
then every arc point has a partner on a secant through the external point. -/
theorem exists_arc_partner_of_pointIndex_eq_half
    {A : Finset P} (hA : Arc (L := L) A) {x a : P}
    (hx : x ∉ A) (ha : a ∈ A) (heven : Even A.card)
    (hindex : pointIndex (L := L) A x = A.card / 2) :
    ∃ b ∈ A, b ≠ a ∧ Collinear (L := L) x a b := by
  classical
  let E := pairsThrough (L := L) A x
  let U := E.biUnion fun e => e.1
  have hUsub : U ⊆ A := by
    intro p hp
    obtain ⟨e, he, hpe⟩ := Finset.mem_biUnion.mp hp
    exact e.subset hpe
  have hUcard : U.card = 2 * E.card := by
    change (E.biUnion fun e => e.1).card = 2 * E.card
    have hdisj : ((E : Finset (ArcPair A)) : Set (ArcPair A)).PairwiseDisjoint
        fun e => e.1 := by
      simpa [E] using pairsThrough_pairwiseDisjoint (L := L) hA hx
    rw [Finset.card_biUnion hdisj]
    calc
      (∑ e ∈ E, e.1.card) = ∑ _e ∈ E, 2 := by
        apply Finset.sum_congr rfl
        intro e _he
        exact e.card
      _ = 2 * E.card := by simp [Nat.mul_comm]
  have hEcard : E.card = A.card / 2 := by
    change (pairsThrough (L := L) A x).card = A.card / 2
    rw [← pointIndex_eq_card_pairsThrough hA]
    exact hindex
  have hcard : U.card = A.card := by
    obtain ⟨n, hn⟩ := heven
    rw [hUcard, hEcard]
    omega
  have hUA : U = A := Finset.eq_of_subset_of_card_le hUsub (by omega)
  have haU : a ∈ U := hUA ▸ ha
  obtain ⟨e, heE, hae⟩ := Finset.mem_biUnion.mp haU
  obtain ⟨c, d, hcd, hedges⟩ := e.exists_eq_pair
  have hxe : x ∈ e.line (L := L) := mem_pairsThrough.mp (by simpa [E] using heE)
  have hce : c ∈ e.1 := by simp [hedges]
  have hde : d ∈ e.1 := by simp [hedges]
  have hcA : c ∈ A := e.subset hce
  have hdA : d ∈ A := e.subset hde
  have hca : a = c ∨ a = d := by
    simpa [hedges] using hae
  rcases hca with rfl | rfl
  · refine ⟨d, hdA, hcd.symm, ?_⟩
    exact ⟨e.line (L := L), hxe, e.mem_line hce, e.mem_line hde⟩
  · refine ⟨c, hcA, hcd, ?_⟩
    exact ⟨e.line (L := L), hxe, e.mem_line hde, e.mem_line hce⟩

end PerfectMatching

namespace ZeroDefectConicInvariance

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K] [CharP K 2]

noncomputable local instance : Fintype (Point K) := Fintype.ofFinite (Point K)
noncomputable local instance : DecidableEq (Point K) := Classical.decEq (Point K)

/-- Parameters of standard-conic points having maximum secant index with respect to `A`. -/
noncomputable def maximumIndexParameters (A : Finset (Point K)) :
    Finset (LinePoint K) := by
  classical
  letI : Fintype (LinePoint K) := Fintype.ofFinite (LinePoint K)
  exact Finset.univ.filter fun t =>
    pointIndex (L := Point K) A (ProjectiveCap.Sym2Bridge.veronesePoint t) = A.card / 2

omit [DecidableEq K] [CharP K 2] in
@[simp] theorem mem_maximumIndexParameters {A : Finset (Point K)} {t : LinePoint K} :
    t ∈ maximumIndexParameters A ↔
      pointIndex (L := Point K) A (ProjectiveCap.Sym2Bridge.veronesePoint t) =
        A.card / 2 := by
  classical
  letI : Fintype (LinePoint K) := Fintype.ofFinite (LinePoint K)
  simp [maximumIndexParameters]

omit [Fintype K] [CharP K 2] in
private theorem collinear_transfer
    {P Q Y Y' : Point K} (hPY : P ≠ Y)
    (h₁ : Collinear (L := Point K) Y P Q)
    (h₂ : Collinear (L := Point K) P Y Y') :
    Collinear (L := Point K) Y' P Q := by
  obtain ⟨l, hYl, hPl, hQl⟩ := h₁
  obtain ⟨m, hPm, hYm, hY'm⟩ := h₂
  have hlm : l = m :=
    (Configuration.HasLines.existsUnique_line
      (P := Point K) (L := Point K) P Y hPY).unique
      ⟨hPl, hYl⟩ ⟨hPm, hYm⟩
  exact ⟨l, hlm ▸ hY'm, hPl, hQl⟩

/-- Zero defect makes the maximum-index conic parameters invariant under the secant involution
associated with every arc point. -/
theorem pointIndex_equiv_eq_half
    {A : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hzero : scaledDefect (L := Point K) A (standardConic (K := K)) = 0)
    (heven : Even A.card) {P : Point K} (hPA : P ∈ A) {t : LinePoint K}
    (ht : pointIndex (L := Point K) A
      (ProjectiveCap.Sym2Bridge.veronesePoint t) = A.card / 2) :
    pointIndex (L := Point K) A
      (ProjectiveCap.Sym2Bridge.veronesePoint
        (ConicSecantInvolution.equiv P
          (fun hPC => Finset.disjoint_left.mp hcomplete.2.1 hPA hPC) t)) =
            A.card / 2 := by
  let Y := ProjectiveCap.Sym2Bridge.veronesePoint t
  have hYC : Y ∈ standardConic (K := K) := mem_standardConic.mpr ⟨t, rfl⟩
  have hYA : Y ∉ A := fun hYA =>
    Finset.disjoint_left.mp hcomplete.2.1 hYA hYC
  obtain ⟨Q, hQA, hQP, hcolY⟩ :=
    exists_arc_partner_of_pointIndex_eq_half hcomplete.1 hYA hPA heven ht
  have hPoff : P ∉ standardConic (K := K) :=
    Finset.disjoint_left.mp hcomplete.2.1 hPA
  let t' := ConicSecantInvolution.equiv P hPoff t
  let Y' := ProjectiveCap.Sym2Bridge.veronesePoint t'
  have hY'C : Y' ∈ standardConic (K := K) :=
    mem_standardConic.mpr ⟨t', rfl⟩
  have hY'A : Y' ∉ A := fun hY'A =>
    Finset.disjoint_left.mp hcomplete.2.1 hY'A hY'C
  have hPY : P ≠ Y := fun h => hYA (h ▸ hPA)
  have hchord : Collinear (L := Point K) P Y Y' := by
    exact ConicSecantInvolution.collinear_veronese_equiv P hPoff t
  have hcolY' : Collinear (L := Point K) Y' P Q :=
    collinear_transfer hPY hcolY hchord
  have hcovered : Covered (L := Point K) A Y' :=
    covered_of_collinear_pair hPA hQA hQP.symm hcolY'
  have hpositive : 0 < pointIndex (L := Point K) A Y' := hcovered
  have hpatterns :=
    (scaledDefect_eq_zero_iff (L := Point K) hcomplete.1 hcomplete.2.1).mp hzero
  rcases hpatterns.2 Y' hY'C with h0 | hhalf
  · omega
  · exact hhalf

/-- The secant involution restricts to an equivalence of the maximum-index parameter set. -/
noncomputable def restrictedEquiv
    {A : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hzero : scaledDefect (L := Point K) A (standardConic (K := K)) = 0)
    (heven : Even A.card) (P : Point K) (hPA : P ∈ A) :
    {t // t ∈ maximumIndexParameters A} ≃
      {t // t ∈ maximumIndexParameters A} := by
  let hPoff : P ∉ standardConic (K := K) :=
    Finset.disjoint_left.mp hcomplete.2.1 hPA
  let e := ConicSecantInvolution.equiv P hPoff
  apply e.subtypeEquiv
  intro t
  constructor
  · intro ht
    exact mem_maximumIndexParameters.mpr
      (pointIndex_equiv_eq_half hcomplete hzero heven hPA
        (mem_maximumIndexParameters.mp ht))
  · intro het
    have hback :=
      pointIndex_equiv_eq_half hcomplete hzero heven hPA
        (mem_maximumIndexParameters.mp het)
    rw [ConicSecantInvolution.equiv_apply_apply] at hback
    exact mem_maximumIndexParameters.mpr hback

omit [CharP K 2] in
/-- The maximum-index conic holes are the Veronese image of the maximum-index parameter set. -/
theorem maximumIndexHoles_eq_map_parameters (A : Finset (Point K)) :
    maximumIndexHoles (L := Point K) A (standardConic (K := K)) =
      (maximumIndexParameters A).map ProjectiveCap.Sym2Bridge.veronesePointEmb := by
  classical
  ext y
  constructor
  · intro hy
    rw [maximumIndexHoles, Finset.mem_filter] at hy
    obtain ⟨t, rfl⟩ := mem_standardConic.mp hy.1
    exact Finset.mem_map.mpr ⟨t, mem_maximumIndexParameters.mpr hy.2, rfl⟩
  · intro hy
    obtain ⟨t, ht, rfl⟩ := Finset.mem_map.mp hy
    exact Finset.mem_filter.mpr
      ⟨mem_standardConic.mpr ⟨t, rfl⟩, mem_maximumIndexParameters.mp ht⟩

omit [CharP K 2] in
/-- At field order `4096` and arc size `92`, zero defect forces exactly `91` maximum-index
standard-conic parameters. -/
theorem maximumIndexParameters_card_eq_ninety_one
    {A : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hq : Fintype.card K = 4096) (hcard : A.card = 92)
    (hzero : scaledDefect (L := Point K) A (standardConic (K := K)) = 0) :
    (maximumIndexParameters A).card = 91 := by
  have hinc := exceptional_candidate_holeIncidence hcomplete hq hcard hzero
  have hfactor :=
    holeIncidence_eq_half_mul_card_maximumIndexHoles
      (L := Point K) hcomplete.1 hcomplete.2.1 hzero
  rw [hinc, hcard] at hfactor
  have hholes :
      (maximumIndexHoles (L := Point K) A (standardConic (K := K))).card = 91 := by
    norm_num at hfactor ⊢
    omega
  rw [maximumIndexHoles_eq_map_parameters, Finset.card_map] at hholes
  exact hholes

end ZeroDefectConicInvariance
end RelativeConicArcs
