import FiniteGeom.Hypergraph

/-!
# Complete graphs augmented by a proper edge coloring

For every ordered pair of distinct vertices `a,b`, add the three-set consisting of the two
vertices and its color.  When each color row is injective away from the diagonal, this hypergraph
has transversal number exactly `|α|-1`; its matching number is at most `⌊|α|/2⌋` because every
edge consumes two graph vertices.  This is the abstract combinatorial core of cubic-coordinate
repair in the characteristic-three twisted-cubic–axis code.
-/

namespace FiniteGeom

open Finset

variable {α β : Type*} [Fintype α] [DecidableEq α] [Fintype β] [DecidableEq β]

/-- Row-properness: at a fixed graph vertex, distinct other endpoints have distinct colors. -/
def IsProperAwayDiagonal (color : α → α → β) : Prop :=
  ∀ a b c, b ≠ a → c ≠ a → color a b = color a c → b = c

/-- The complete graph on `α`, with each edge augmented by a color vertex in the disjoint
type `β`.  Symmetry of `color` is not needed for the extremal bounds. -/
def augmentedColorHypergraph (color : α → α → β) : Finset (Finset (α ⊕ β)) :=
  ((univ.product univ).filter fun p => p.1 ≠ p.2).image fun p =>
    {Sum.inl p.1, Sum.inl p.2, Sum.inr (color p.1 p.2)}

omit [Fintype β] in
theorem mem_augmentedColorHypergraph {color : α → α → β} {E : Finset (α ⊕ β)} :
    E ∈ augmentedColorHypergraph color ↔
      ∃ a b, a ≠ b ∧ E = {Sum.inl a, Sum.inl b, Sum.inr (color a b)} := by
  simp only [augmentedColorHypergraph, Finset.mem_image, Finset.mem_filter]
  constructor
  · rintro ⟨⟨a, b⟩, ⟨-, hab⟩, hEq⟩
    exact ⟨a, b, hab, hEq.symm⟩
  · rintro ⟨a, b, hab, rfl⟩
    exact ⟨(a, b), ⟨by simp, hab⟩, rfl⟩

omit [Fintype β] in
/-- Selecting all but one graph vertex hits every augmented edge. -/
theorem augmentedColorHypergraph_transversal_of_erase (color : α → α → β) (a₀ : α) :
    IsTransversal (augmentedColorHypergraph color)
      ((univ.erase a₀).map Function.Embedding.inl) := by
  intro E hE
  obtain ⟨a, b, hab, rfl⟩ := mem_augmentedColorHypergraph.mp hE
  by_cases ha : a = a₀
  · subst a
    exact ⟨Sum.inl b, by simp [hab.symm]⟩
  · exact ⟨Sum.inl a, by simp [ha]⟩

omit [Fintype β] in
/-- Every matching consumes two distinct graph vertices per edge. -/
theorem augmentedColorHypergraph_matching_card_le (color : α → α → β)
    {M : Finset (Finset (α ⊕ β))} (hM : IsMatching (augmentedColorHypergraph color) M) :
    2 * M.card ≤ Fintype.card α := by
  classical
  let graphPart : Finset (α ⊕ β) → Finset (α ⊕ β) := fun E =>
    E.filter fun x => x.isLeft
  have hpart (E) (hE : E ∈ M) : (graphPart E).card = 2 := by
    obtain ⟨a, b, hab, rfl⟩ := mem_augmentedColorHypergraph.mp (hM.1 hE)
    rw [show graphPart {Sum.inl a, Sum.inl b, Sum.inr (color a b)} =
        {Sum.inl a, Sum.inl b} by
      ext x
      cases x <;> simp [graphPart]]
    simp [hab]
  have hpairwise : (M : Set (Finset (α ⊕ β))).PairwiseDisjoint graphPart := by
    intro A hA B hB hAB
    exact (hM.2 hA hB hAB).mono (Finset.filter_subset _ _) (Finset.filter_subset _ _)
  have hsub : M.biUnion graphPart ⊆ univ.map Function.Embedding.inl := by
    intro x hx
    obtain ⟨E, hEM, hxE⟩ := Finset.mem_biUnion.mp hx
    have hxleft : x.isLeft := (Finset.mem_filter.mp hxE).2
    cases x with
    | inl a => simp
    | inr b => simp at hxleft
  calc
    2 * M.card = ∑ E ∈ M, 2 := by simp [Nat.mul_comm]
    _ = ∑ E ∈ M, (graphPart E).card := by
      apply Finset.sum_congr rfl
      intro E hE
      exact (hpart E hE).symm
    _ = (M.biUnion graphPart).card := (Finset.card_biUnion hpairwise).symm
    _ ≤ (univ.map Function.Embedding.inl).card := Finset.card_le_card hsub
    _ = Fintype.card α := by simp

omit [Fintype β] in
/-- Consequently `ν ≤ ⌊|α|/2⌋`. -/
theorem matchingNumber_augmentedColorHypergraph_le (color : α → α → β) :
    matchingNumber (augmentedColorHypergraph color) ≤ Fintype.card α / 2 := by
  apply matchingNumber_le_of_forall
  intro M hM
  have h := augmentedColorHypergraph_matching_card_le color hM
  omega

/-- A maximal-rainbow-matching count.  In a row-proper coloring, a maximum augmented matching
has size at least `⌈(|α|-1)/3⌉`: after deleting its two graph endpoints per edge, fix one
uncovered vertex.  Every other uncovered vertex must give a color already used by the matching,
and row-properness makes those colors distinct. -/
theorem matchingNumber_augmentedColorHypergraph_lower (color : α → α → β)
    (hproper : IsProperAwayDiagonal color) :
    (Fintype.card α + 1) / 3 ≤ matchingNumber (augmentedColorHypergraph color) := by
  classical
  let H := augmentedColorHypergraph color
  obtain ⟨M, hM, hMcard⟩ := exists_matching_card_eq_matchingNumber H
  let used : Finset (α ⊕ β) := M.biUnion id
  let graphUsed : Finset α := univ.filter fun a => Sum.inl a ∈ used
  let colorUsed : Finset β := univ.filter fun c => Sum.inr c ∈ used
  let uncovered : Finset α := univ \ graphUsed
  have hgraphCard : graphUsed.card = 2 * M.card := by
    have hpairwise : (M : Set (Finset (α ⊕ β))).PairwiseDisjoint id := by
      intro A hA B hB hAB
      change Disjoint A B
      exact hM.2 hA hB hAB
    have husedCard : used.card = 3 * M.card := by
      rw [show used = M.biUnion id by rfl, Finset.card_biUnion hpairwise]
      calc
        (∑ E ∈ M, E.card) = ∑ _E ∈ M, 3 := by
          apply Finset.sum_congr rfl
          intro E hEM
          obtain ⟨a, b, hab, rfl⟩ := mem_augmentedColorHypergraph.mp (hM.1 hEM)
          simp [hab]
        _ = 3 * M.card := by simp [Nat.mul_comm]
    have hsplit : graphUsed.card + colorUsed.card = used.card := by
      have hpartition : used =
          (graphUsed.map Function.Embedding.inl) ∪
            (colorUsed.map Function.Embedding.inr) := by
        ext z
        cases z <;> simp [graphUsed, colorUsed]
      rw [hpartition, Finset.card_union_of_disjoint (by simp [Finset.disjoint_left])]
      simp
    have hcolorCard : colorUsed.card = M.card := by
      have hcolorPairwise :
          (M : Set (Finset (α ⊕ β))).PairwiseDisjoint
            (fun E => E.filter fun z => z.isRight) := by
        intro A hA B hB hAB
        exact (hM.2 hA hB hAB).mono (Finset.filter_subset _ _) (Finset.filter_subset _ _)
      have hcolorUnion : colorUsed.map Function.Embedding.inr =
          M.biUnion (fun E => E.filter fun z => z.isRight) := by
        ext z
        cases z with
        | inl a => simp
        | inr c => simp [colorUsed, used]
      calc
        colorUsed.card = (colorUsed.map Function.Embedding.inr).card :=
          (Finset.card_map Function.Embedding.inr).symm
        _ = (M.biUnion (fun E => E.filter fun z => z.isRight)).card :=
          congrArg Finset.card hcolorUnion
        _ = ∑ E ∈ M, (E.filter fun z => z.isRight).card :=
          Finset.card_biUnion hcolorPairwise
        _ = ∑ _E ∈ M, 1 := by
          apply Finset.sum_congr rfl
          intro E hEM
          obtain ⟨a, b, hab, rfl⟩ := mem_augmentedColorHypergraph.mp (hM.1 hEM)
          rw [show (({Sum.inl a, Sum.inl b, Sum.inr (color a b)} : Finset (α ⊕ β)).filter
              fun z => z.isRight) = {Sum.inr (color a b)} by
            ext z
            cases z <;> simp]
          simp
        _ = M.card := by simp
    omega
  have hsplit : graphUsed.card + uncovered.card = Fintype.card α := by
    rw [show uncovered = univ \ graphUsed by rfl, Finset.card_sdiff]
    rw [Finset.inter_eq_left.mpr (Finset.filter_subset _ _), Finset.card_univ]
    have hle : graphUsed.card ≤ Fintype.card α := by
      simpa [graphUsed] using
        Finset.card_le_card (Finset.filter_subset (fun a => Sum.inl a ∈ used) univ)
    exact Nat.add_sub_of_le hle
  by_cases hU : uncovered = ∅
  · have hq : Fintype.card α = 2 * M.card := by
      rw [hU] at hsplit
      simpa [hgraphCard] using hsplit.symm
    rw [← hMcard]
    omega
  · obtain ⟨a₀, ha₀⟩ := Finset.nonempty_iff_ne_empty.mpr hU
    let colors : Finset β := (uncovered.erase a₀).image (color a₀)
    have hcolorsCard : colors.card = uncovered.card - 1 := by
      rw [Finset.card_image_iff.mpr]
      · rw [Finset.card_erase_of_mem ha₀]
      · intro b hb c hc hEq
        exact hproper a₀ b c (Finset.mem_erase.mp hb).1 (Finset.mem_erase.mp hc).1 hEq
    have hcolorsSub : colors ⊆ colorUsed := by
      intro c hc
      obtain ⟨b, hb, rfl⟩ := Finset.mem_image.mp hc
      have hba : b ≠ a₀ := (Finset.mem_erase.mp hb).1
      have hbU : b ∈ uncovered := (Finset.mem_erase.mp hb).2
      by_contra hnot
      have haNot : Sum.inl a₀ ∉ used := by
        intro ha
        have : a₀ ∈ graphUsed := by simp [graphUsed, ha]
        exact (Finset.mem_sdiff.mp ha₀).2 this
      have hbNot : Sum.inl b ∉ used := by
        intro hbin
        have : b ∈ graphUsed := by simp [graphUsed, hbin]
        exact (Finset.mem_sdiff.mp hbU).2 this
      have hcNot : Sum.inr (color a₀ b) ∉ used := by
        intro hcin
        exact hnot (by simp [colorUsed, hcin])
      let E : Finset (α ⊕ β) :=
        {Sum.inl a₀, Sum.inl b, Sum.inr (color a₀ b)}
      have hEH : E ∈ H := by
        exact mem_augmentedColorHypergraph.mpr ⟨a₀, b, hba.symm, rfl⟩
      have hEM : E ∉ M := by
        intro h
        exact haNot (Finset.subset_biUnion_of_mem id h (by simp [E]))
      have hdisj : Disjoint E used := by
        simp only [Finset.disjoint_left, E, Finset.mem_insert, Finset.mem_singleton]
        intro z hzE hzU
        rcases hzE with rfl | rfl | rfl
        · exact haNot hzU
        · exact hbNot hzU
        · exact hcNot hzU
      have hM' : IsMatching H (insert E M) := by
        refine ⟨Finset.insert_subset hEH hM.1, ?_⟩
        intro A hA B hB hAB
        rw [Finset.mem_insert] at hA hB
        rcases hA with rfl | hA <;> rcases hB with rfl | hB
        · exact absurd rfl hAB
        · exact hdisj.mono_right (Finset.subset_biUnion_of_mem id hB)
        · exact (hdisj.mono_right (Finset.subset_biUnion_of_mem id hA)).symm
        · exact hM.2 hA hB hAB
      have hle := card_le_matchingNumber hM'
      rw [Finset.card_insert_of_notMem hEM, ← hMcard] at hle
      omega
    have hcolorBound : colors.card ≤ M.card := by
      exact (Finset.card_le_card hcolorsSub).trans_eq (by
        have hcolorPairwise :
            (M : Set (Finset (α ⊕ β))).PairwiseDisjoint
              (fun E => E.filter fun z => z.isRight) := by
          intro A hA B hB hAB
          exact (hM.2 hA hB hAB).mono (Finset.filter_subset _ _) (Finset.filter_subset _ _)
        have hcolorUnion : colorUsed.map Function.Embedding.inr =
            M.biUnion (fun E => E.filter fun z => z.isRight) := by
          ext z
          cases z with
          | inl a => simp
          | inr c => simp [colorUsed, used]
        calc
          colorUsed.card = (colorUsed.map Function.Embedding.inr).card :=
            (Finset.card_map Function.Embedding.inr).symm
          _ = (M.biUnion (fun E => E.filter fun z => z.isRight)).card :=
            congrArg Finset.card hcolorUnion
          _ = ∑ E ∈ M, (E.filter fun z => z.isRight).card :=
            Finset.card_biUnion hcolorPairwise
          _ = ∑ _E ∈ M, 1 := by
            apply Finset.sum_congr rfl
            intro E hEM
            obtain ⟨a, b, hab, rfl⟩ := mem_augmentedColorHypergraph.mp (hM.1 hEM)
            rw [show (({Sum.inl a, Sum.inl b, Sum.inr (color a b)} : Finset (α ⊕ β)).filter
                fun z => z.isRight) = {Sum.inr (color a b)} by
              ext z
              cases z <;> simp]
            simp
          _ = M.card := by simp)
    rw [hcolorsCard] at hcolorBound
    rw [← hMcard]
    omega

omit [Fintype β] in
/-- Under row-properness, every transversal has at least `|α|-1` vertices. -/
theorem card_transversal_augmentedColorHypergraph_ge (color : α → α → β)
    (hproper : IsProperAwayDiagonal color) {T : Finset (α ⊕ β)}
    (hT : IsTransversal (augmentedColorHypergraph color) T) :
    Fintype.card α - 1 ≤ T.card := by
  classical
  let covered : Finset α := univ.filter fun a => Sum.inl a ∈ T
  let uncovered : Finset α := univ \ covered
  by_cases hU : uncovered = ∅
  · have hsub : univ.map Function.Embedding.inl ⊆ T := by
      intro x hx
      obtain ⟨a, -, rfl⟩ := Finset.mem_map.mp hx
      have ha : a ∈ covered := by
        by_contra ha
        have : a ∈ uncovered := by simp [uncovered, ha]
        simp [hU] at this
      exact (Finset.mem_filter.mp ha).2
    have hcard : Fintype.card α ≤ T.card := by
      simpa using Finset.card_le_card hsub
    omega
  · obtain ⟨a₀, ha₀⟩ := Finset.nonempty_iff_ne_empty.mpr hU
    let colors : Finset β := (uncovered.erase a₀).image (color a₀)
    have hcolorSub : colors.map Function.Embedding.inr ⊆ T := by
      intro x hx
      obtain ⟨c, hc, rfl⟩ := Finset.mem_map.mp hx
      obtain ⟨b, hb, rfl⟩ := Finset.mem_image.mp hc
      have hba : b ≠ a₀ := (Finset.mem_erase.mp hb).1
      have hbU : b ∈ uncovered := (Finset.mem_erase.mp hb).2
      have haT : Sum.inl a₀ ∉ T := by
        intro haT
        have : a₀ ∈ covered := by simp [covered, haT]
        exact (Finset.mem_sdiff.mp ha₀).2 this
      have hbT : Sum.inl b ∉ T := by
        intro hbT
        have : b ∈ covered := by simp [covered, hbT]
        exact (Finset.mem_sdiff.mp hbU).2 this
      have hedge : {Sum.inl a₀, Sum.inl b, Sum.inr (color a₀ b)} ∈
          augmentedColorHypergraph color :=
        mem_augmentedColorHypergraph.mpr ⟨a₀, b, hba.symm, rfl⟩
      obtain ⟨v, hv⟩ := hT hedge
      simp only [Finset.mem_inter, Finset.mem_insert, Finset.mem_singleton] at hv
      rcases hv.2 with hv0 | hvb | hvc
      · exact (haT (hv0 ▸ hv.1)).elim
      · exact (hbT (hvb ▸ hv.1)).elim
      · simpa [hvc] using hv.1
    have hcoveredSub : covered.map Function.Embedding.inl ⊆ T := by
      intro x hx
      obtain ⟨a, ha, rfl⟩ := Finset.mem_map.mp hx
      exact (Finset.mem_filter.mp ha).2
    have hcolorsCard : colors.card = uncovered.card - 1 := by
      rw [Finset.card_image_iff.mpr]
      · rw [Finset.card_erase_of_mem ha₀]
      · intro b hb c hc hEq
        exact hproper a₀ b c (Finset.mem_erase.mp hb).1 (Finset.mem_erase.mp hc).1 hEq
    have hdisj : Disjoint (covered.map Function.Embedding.inl)
        (colors.map Function.Embedding.inr) := by
      simp [Finset.disjoint_left]
    have hunionSub : covered.map Function.Embedding.inl ∪
        colors.map Function.Embedding.inr ⊆ T := Finset.union_subset hcoveredSub hcolorSub
    have hcardCU : covered.card + uncovered.card = Fintype.card α := by
      rw [show uncovered = univ \ covered by rfl, Finset.card_sdiff]
      have hcsub : covered ⊆ univ := Finset.subset_univ _
      rw [Finset.inter_eq_left.mpr hcsub, Finset.card_univ]
      have hcovle : covered.card ≤ Fintype.card α := by
        simpa using Finset.card_le_card hcsub
      omega
    have hle := Finset.card_le_card hunionSub
    rw [Finset.card_union_of_disjoint hdisj, Finset.card_map, Finset.card_map,
      hcolorsCard] at hle
    omega

omit [Fintype β] in
/-- The augmented properly colored complete graph has exact transversal number `|α|-1`. -/
theorem transversalNumber_augmentedColorHypergraph (color : α → α → β)
    (hproper : IsProperAwayDiagonal color) [Nonempty α] :
    transversalNumber (augmentedColorHypergraph color) = Fintype.card α - 1 := by
  apply le_antisymm
  · let a₀ : α := Classical.choice inferInstance
    simpa using transversalNumber_le_card
      (augmentedColorHypergraph_transversal_of_erase color a₀)
  · let a₀ : α := Classical.choice inferInstance
    apply le_transversalNumber_of_forall
    · exact ⟨_, augmentedColorHypergraph_transversal_of_erase color a₀⟩
    · intro T hT
      exact
      card_transversal_augmentedColorHypergraph_ge color hproper hT

end FiniteGeom
