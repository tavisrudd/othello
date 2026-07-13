import RepairCodes.AxisTwistedCubic

/-!
# Extremal invariants of twisted-cubic–axis repair hypergraphs

This module starts from the exact code-derived repair classification in
`RepairCodes.AxisTwistedCubic` and proves the matching/transversal formulas.  It does not replace
the repair hypergraph by a selected family.
-/

namespace RepairCodes

open Finset Matrix FiniteGeom

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

private def cubicPart (E : Finset (AxisTwistedCubicIndex 𝔽)) :
    Finset (AxisTwistedCubicIndex 𝔽) :=
  E.filter fun z => z.isLeft

/-- Every matching of cubic-coordinate repairs consumes two distinct cubic helpers per edge. -/
theorem cubicRepair_matching_card_bound [CharP 𝔽 3] (x : 𝔽)
    {M : Finset (Finset (AxisTwistedCubicIndex 𝔽))}
    (hM : IsMatching (axisTwistedCubicRepairHypergraph (.inl x) 3) M) :
    2 * M.card ≤ Fintype.card 𝔽 - 1 := by
  classical
  have hpart (E) (hE : E ∈ M) : (cubicPart E).card = 2 := by
    obtain ⟨s, t, -, -, hst, rfl⟩ := mem_cubicRepairHypergraph_iff.mp (hM.1 hE)
    rw [show cubicPart
        {(.inl s : AxisTwistedCubicIndex 𝔽), .inl t,
          .inr (twistedCubicTripleAxisIndex ![x, s, t])} = {Sum.inl s, Sum.inl t} by
      ext z
      cases z <;> simp [cubicPart]]
    simp [hst]
  have hpairwise : (M : Set (Finset (AxisTwistedCubicIndex 𝔽))).PairwiseDisjoint cubicPart := by
    intro A hA B hB hAB
    exact (hM.2 hA hB hAB).mono (Finset.filter_subset _ _) (Finset.filter_subset _ _)
  have hsub : M.biUnion cubicPart ⊆
      (univ.erase x).map Function.Embedding.inl := by
    intro z hz
    obtain ⟨E, hEM, hzE⟩ := Finset.mem_biUnion.mp hz
    obtain ⟨s, t, hxs, hxt, -, rfl⟩ := mem_cubicRepairHypergraph_iff.mp (hM.1 hEM)
    have hzleft := (Finset.mem_filter.mp hzE).2
    cases z with
    | inr y => simp at hzleft
    | inl u =>
      have hzu := (Finset.mem_filter.mp hzE).1
      simp only [Finset.mem_insert, Finset.mem_singleton, Sum.inl.injEq,
        Sum.inl_ne_inr, or_false] at hzu
      rcases hzu with rfl | rfl
      · simp [hxs.symm]
      · simp [hxt.symm]
  calc
    2 * M.card = ∑ E ∈ M, 2 := by simp [Nat.mul_comm]
    _ = ∑ E ∈ M, (cubicPart E).card := by
      apply Finset.sum_congr rfl
      intro E hE
      exact (hpart E hE).symm
    _ = (M.biUnion cubicPart).card := (Finset.card_biUnion hpairwise).symm
    _ ≤ ((univ.erase x).map Function.Embedding.inl).card := Finset.card_le_card hsub
    _ = Fintype.card 𝔽 - 1 := by simp

/-- Cubic-coordinate disjoint availability is at most `(q-1)/2`. -/
theorem cubicRepair_matchingNumber_le [CharP 𝔽 3] (x : 𝔽) :
    matchingNumber (axisTwistedCubicRepairHypergraph (.inl x) 3) ≤
      (Fintype.card 𝔽 - 1) / 2 := by
  apply matchingNumber_le_of_forall
  intro M hM
  have h := cubicRepair_matching_card_bound x hM
  omega

/-- All cubic helpers except one form a transversal. -/
theorem cubicRepair_transversal_of_erase [CharP 𝔽 3] (x a₀ : 𝔽) :
    IsTransversal (axisTwistedCubicRepairHypergraph (.inl x) 3)
      (((univ.erase x).erase a₀).map Function.Embedding.inl) := by
  intro E hE
  obtain ⟨s, t, hxs, hxt, hst, rfl⟩ := mem_cubicRepairHypergraph_iff.mp hE
  by_cases hs : s = a₀
  · subst s
    exact ⟨Sum.inl t, by simp [hxt, hst.symm]⟩
  · exact ⟨Sum.inl s, by simp [hxs.symm, hs]⟩

/-- Every cubic-coordinate repair transversal has at least `q-2` vertices. -/
theorem cubicRepair_transversal_card_ge [CharP 𝔽 3] (x : 𝔽)
    {T : Finset (AxisTwistedCubicIndex 𝔽)}
    (hT : IsTransversal (axisTwistedCubicRepairHypergraph (.inl x) 3) T) :
    Fintype.card 𝔽 - 2 ≤ T.card := by
  classical
  let ground : Finset 𝔽 := univ.erase x
  let covered : Finset 𝔽 := ground.filter fun s => Sum.inl s ∈ T
  let uncovered : Finset 𝔽 := ground \ covered
  by_cases hU : uncovered = ∅
  · have hsub : ground.map Function.Embedding.inl ⊆ T := by
      intro z hz
      obtain ⟨s, hs, rfl⟩ := Finset.mem_map.mp hz
      have hsC : s ∈ covered := by
        by_contra hsC
        have : s ∈ uncovered := by simp [uncovered, hs, hsC]
        simp [hU] at this
      exact (Finset.mem_filter.mp hsC).2
    have hcard : Fintype.card 𝔽 - 1 ≤ T.card := by
      have := Finset.card_le_card hsub
      simpa [ground] using this
    omega
  · obtain ⟨a₀, ha₀⟩ := Finset.nonempty_iff_ne_empty.mpr hU
    have hxa₀ : x ≠ a₀ := by
      exact Ne.symm (Finset.mem_erase.mp (Finset.mem_sdiff.mp ha₀).1).1
    let color : 𝔽 → 𝔽 ⊕ Unit := fun b => twistedCubicTripleAxisIndex ![x, a₀, b]
    let colors : Finset (𝔽 ⊕ Unit) := (uncovered.erase a₀).image color
    have hcolorSub : colors.map Function.Embedding.inr ⊆ T := by
      intro z hz
      obtain ⟨c, hc, rfl⟩ := Finset.mem_map.mp hz
      obtain ⟨b, hb, rfl⟩ := Finset.mem_image.mp hc
      have hba : b ≠ a₀ := (Finset.mem_erase.mp hb).1
      have hbU : b ∈ uncovered := (Finset.mem_erase.mp hb).2
      have haGround := (Finset.mem_sdiff.mp ha₀).1
      have hbGround := (Finset.mem_sdiff.mp hbU).1
      have hxb : x ≠ b := Ne.symm (Finset.mem_erase.mp hbGround).1
      have haT : Sum.inl a₀ ∉ T := by
        intro haT
        have : a₀ ∈ covered := by simp [covered, haGround, haT]
        exact (Finset.mem_sdiff.mp ha₀).2 this
      have hbT : Sum.inl b ∉ T := by
        intro hbT
        have : b ∈ covered := by simp [covered, hbGround, hbT]
        exact (Finset.mem_sdiff.mp hbU).2 this
      have hedge : {(.inl a₀ : AxisTwistedCubicIndex 𝔽), .inl b,
          .inr (color b)} ∈ axisTwistedCubicRepairHypergraph (.inl x) 3 := by
        apply mem_cubicRepairHypergraph_iff.mpr
        exact ⟨a₀, b, hxa₀, hxb, hba.symm, rfl⟩
      obtain ⟨v, hv⟩ := hT hedge
      simp only [Finset.mem_inter, Finset.mem_insert, Finset.mem_singleton] at hv
      rcases hv.2 with hv0 | hvb | hvc
      · exact (haT (hv0 ▸ hv.1)).elim
      · exact (hbT (hvb ▸ hv.1)).elim
      · simpa [hvc] using hv.1
    have hcoveredSub : covered.map Function.Embedding.inl ⊆ T := by
      intro z hz
      obtain ⟨s, hs, rfl⟩ := Finset.mem_map.mp hz
      exact (Finset.mem_filter.mp hs).2
    have hcolorsCard : colors.card = uncovered.card - 1 := by
      rw [Finset.card_image_iff.mpr]
      · rw [Finset.card_erase_of_mem ha₀]
      · intro b hb c hc hEq
        exact twistedCubicTripleAxisIndex_injective_third hxa₀ hEq
    have hdisj : Disjoint (covered.map Function.Embedding.inl)
        (colors.map Function.Embedding.inr) := by
      simp [Finset.disjoint_left]
    have hunionSub : covered.map Function.Embedding.inl ∪
        colors.map Function.Embedding.inr ⊆ T := Finset.union_subset hcoveredSub hcolorSub
    have hcardCU : covered.card + uncovered.card = Fintype.card 𝔽 - 1 := by
      rw [show uncovered = ground \ covered by rfl, Finset.card_sdiff]
      have hcsub : covered ⊆ ground := Finset.filter_subset _ _
      rw [Finset.inter_eq_left.mpr hcsub]
      have hcovle := Finset.card_le_card hcsub
      simp [ground] at hcovle ⊢
      omega
    have hle := Finset.card_le_card hunionSub
    rw [Finset.card_union_of_disjoint hdisj, Finset.card_map, Finset.card_map,
      hcolorsCard] at hle
    omega

/-- Cubic-coordinate transversal number is exactly `q-2`. -/
theorem cubicRepair_transversalNumber [CharP 𝔽 3] (x : 𝔽) :
    transversalNumber (axisTwistedCubicRepairHypergraph (.inl x) 3) =
      Fintype.card 𝔽 - 2 := by
  apply le_antisymm
  · have hT := cubicRepair_transversal_of_erase x (x + 1)
    have hle := transversalNumber_le_card hT
    have hq2 : 2 ≤ Fintype.card 𝔽 := by
      let f : Fin 2 → 𝔽 := ![x, x + 1]
      apply Fintype.card_le_of_injective f
      intro i j hij
      fin_cases i <;> fin_cases j <;> simp_all [f]
    simp at hle
    omega
  · apply le_transversalNumber_of_forall
    · exact ⟨_, cubicRepair_transversal_of_erase x (x + 1)⟩
    · exact fun _ hT => cubicRepair_transversal_card_ge x hT

/-- Cubic coordinates already have the strict repair gap for every finite characteristic-three
field of order at least nine. -/
theorem cubicRepair_tau_gt_nu [CharP 𝔽 3] (hq : 9 ≤ Fintype.card 𝔽) (x : 𝔽) :
    matchingNumber (axisTwistedCubicRepairHypergraph (.inl x) 3) <
      transversalNumber (axisTwistedCubicRepairHypergraph (.inl x) 3) := by
  rw [cubicRepair_transversalNumber]
  have hν := cubicRepair_matchingNumber_le x
  omega

#print axioms cubicRepair_matchingNumber_le
#print axioms cubicRepair_transversalNumber
#print axioms cubicRepair_tau_gt_nu

end RepairCodes
