import FiniteGeom.Code
import FiniteGeom.Hypergraph

/-!
# Repair hypergraphs derived from bounded dual-word supports

For a linear code `C ≤ 𝔽ⁿ`, a helper set `R` repairs coordinate `x` when a dual word is nonzero at
`x` and has support exactly `{x} ∪ R`.  `repairHypergraph C x r` collects every such support with
at most `r` helpers, excluding `x` itself.  This is the complete bounded-radius repair hypergraph,
not a selected family of declared recovery groups.

The first structural theorem, `repair_edge_card_eq_of_dualDist`, says that if
`r+1 ≤ d(C⊥)`, every edge in the radius-`r` hypergraph has exactly `r` helpers.  For the q=9 seed,
`d(C₀⊥)=4` therefore makes every radius-three repair a minimum four-support dual circuit.
-/

namespace FiniteGeom

open Finset

variable {ι : Type*} [Fintype ι] [DecidableEq ι]
  {𝔽 : Type*} [Field 𝔽] [DecidableEq 𝔽]

/-- Hamming support of a word as a `Finset`. -/
def wordSupport (y : ι → 𝔽) : Finset ι :=
  univ.filter fun j => y j ≠ 0

omit [DecidableEq ι] in
@[simp]
theorem mem_wordSupport {y : ι → 𝔽} {j : ι} : j ∈ wordSupport y ↔ y j ≠ 0 := by
  simp [wordSupport]

omit [DecidableEq ι] in
/-- Support cardinality is Hamming weight. -/
theorem card_wordSupport (y : ι → 𝔽) : (wordSupport y).card = hammingNorm y := rfl

/-- The complete radius-`r` repair hypergraph at coordinate `x`. An edge is the helper part of a
dual-word support through `x`, with at most `r` helpers and with `x` excluded. -/
noncomputable def repairHypergraph (C : Submodule 𝔽 (ι → 𝔽)) (x : ι) (r : ℕ) :
    Finset (Finset ι) := by
  classical
  exact (univ.erase x).powerset.filter fun R =>
    R.card ≤ r ∧ ∃ y ∈ dualCode C, y x ≠ 0 ∧ wordSupport y = insert x R

/-- The complete inclusion-minimal radius-`r` repair clutter.  This is the paper-facing
hypergraph: bounded dual supports that properly contain another repair are discarded. -/
noncomputable def minimalRepairHypergraph (C : Submodule 𝔽 (ι → 𝔽)) (x : ι) (r : ℕ) :
    Finset (Finset ι) :=
  minimalHyperedges (repairHypergraph C x r)

theorem mem_repairHypergraph {C : Submodule 𝔽 (ι → 𝔽)} {x : ι} {r : ℕ}
    {R : Finset ι} :
    R ∈ repairHypergraph C x r ↔
      R ⊆ univ.erase x ∧ R.card ≤ r ∧
        ∃ y ∈ dualCode C, y x ≠ 0 ∧ wordSupport y = insert x R := by
  classical
  simp only [repairHypergraph, mem_filter, mem_powerset]

/-- Enlarging the allowed repair radius can only add repair edges. -/
theorem repairHypergraph_mono_radius {C : Submodule 𝔽 (ι → 𝔽)} {x : ι}
    {r s : ℕ} (hrs : r ≤ s) : repairHypergraph C x r ⊆ repairHypergraph C x s := by
  intro R hR
  obtain ⟨hsub, hcard, y, hy, hyx, hsupp⟩ := mem_repairHypergraph.mp hR
  exact mem_repairHypergraph.mpr ⟨hsub, hcard.trans hrs, y, hy, hyx, hsupp⟩

/-- A coordinate has exact locality `r` when a radius-`r` repair exists and no repair exists at
any smaller radius.  This definition is phrased using the complete code-derived repair
hypergraphs, not a selected recovery family. -/
def HasExactLocalityAt (C : Submodule 𝔽 (ι → 𝔽)) (x : ι) (r : ℕ) : Prop :=
  (repairHypergraph C x r).Nonempty ∧
    ∀ s < r, ¬(repairHypergraph C x s).Nonempty

/-- An edge already known to have at most `s` helpers belongs at radius `s`, independently of
the larger radius at which it was found. -/
theorem mem_repairHypergraph_of_mem_of_card_le {C : Submodule 𝔽 (ι → 𝔽)} {x : ι}
    {r s : ℕ} {R : Finset ι} (hR : R ∈ repairHypergraph C x r) (hcard : R.card ≤ s) :
    R ∈ repairHypergraph C x s := by
  obtain ⟨hsub, -, y, hy, hyx, hsupp⟩ := mem_repairHypergraph.mp hR
  exact mem_repairHypergraph.mpr ⟨hsub, hcard, y, hy, hyx, hsupp⟩

/-- A full-support repair relation can be retargeted to any helper in its support.  The old target
becomes a helper and the new target is removed from the helper set. -/
theorem repairHypergraph_retarget {C : Submodule 𝔽 (ι → 𝔽)} {x z : ι} {r : ℕ}
    {R : Finset ι} (hR : R ∈ repairHypergraph C x r) (hz : z ∈ R) :
    insert x (R.erase z) ∈ repairHypergraph C z r := by
  classical
  obtain ⟨hsub, hcard, y, hy, hyx, hsupp⟩ := mem_repairHypergraph.mp hR
  have hxR : x ∉ R := by
    intro hx
    exact (Finset.mem_erase.mp (hsub hx)).1 rfl
  have hxz : x ≠ z := by
    intro hxz
    exact hxR (hxz ▸ hz)
  have hnewSub : insert x (R.erase z) ⊆ univ.erase z := by
    intro a ha
    rw [Finset.mem_insert] at ha
    rcases ha with rfl | ha
    · simp [hxz]
    · have haR := (Finset.mem_erase.mp ha).2
      exact Finset.mem_erase.mpr ⟨(Finset.mem_erase.mp ha).1, Finset.mem_univ _⟩
  have hnewCard : (insert x (R.erase z)).card ≤ r := by
    have hRpos : 0 < R.card := Finset.card_pos.mpr ⟨z, hz⟩
    rw [Finset.card_insert_of_notMem (fun hx => hxR (Finset.mem_of_mem_erase hx)),
      Finset.card_erase_of_mem hz]
    omega
  have hyz : y z ≠ 0 := by
    apply mem_wordSupport.mp
    rw [hsupp]
    exact Finset.mem_insert_of_mem hz
  have hnewSupp : wordSupport y = insert z (insert x (R.erase z)) := by
    rw [hsupp]
    ext a
    simp only [Finset.mem_insert, Finset.mem_erase]
    constructor
    · rintro (rfl | ha)
      · exact Or.inr (Or.inl rfl)
      · by_cases haz : a = z
        · exact Or.inl haz
        · exact Or.inr (Or.inr ⟨haz, ha⟩)
    · rintro (rfl | rfl | ⟨-, ha⟩)
      · exact Or.inr hz
      · exact Or.inl rfl
      · exact Or.inr ha
  exact mem_repairHypergraph.mpr ⟨hnewSub, hnewCard, y, hy, hyz, hnewSupp⟩

/-- If the dual distance is at least `r+1`, every radius-`r` repair edge has exactly `r` helpers.
The witnessing dual word has support `insert x R`, hence weight `R.card+1`; dual distance supplies
the lower bound while membership supplies `R.card≤r`. -/
theorem repair_edge_card_eq_of_dualDist {C : Submodule 𝔽 (ι → 𝔽)} {x : ι} {r : ℕ}
    (hd : r + 1 ≤ dualDist C) {R : Finset ι} (hR : R ∈ repairHypergraph C x r) :
    R.card = r := by
  obtain ⟨hsub, hcard, y, hy, hyx, hsupp⟩ := mem_repairHypergraph.mp hR
  have hxR : x ∉ R := by
    intro hx
    exact (Finset.mem_erase.mp (hsub hx)).1 rfl
  have hy0 : y ≠ 0 := by
    intro h
    exact hyx (congrFun h x)
  have hdist := dualDist_le_hammingNorm hy hy0
  rw [← card_wordSupport, hsupp, Finset.card_insert_of_notMem hxR] at hdist
  omega

/-- Under the same distance gate and positive radius, every repair edge is nonempty. -/
theorem repair_edge_nonempty_of_dualDist {C : Submodule 𝔽 (ι → 𝔽)} {x : ι} {r : ℕ}
    (hr : 0 < r) (hd : r + 1 ≤ dualDist C) {R : Finset ι}
    (hR : R ∈ repairHypergraph C x r) : R.Nonempty := by
  rw [Finset.nonempty_iff_ne_empty]
  intro h
  have hc := repair_edge_card_eq_of_dualDist hd hR
  rw [h, Finset.card_empty] at hc
  omega

/-- At positive radius below dual distance, passing to inclusion-minimal repairs preserves
matching number. -/
theorem matchingNumber_minimalRepairHypergraph_of_dualDist
    {C : Submodule 𝔽 (ι → 𝔽)} {x : ι} {r : ℕ}
    (hr : 0 < r) (hd : r + 1 ≤ dualDist C) :
    matchingNumber (minimalRepairHypergraph C x r) =
      matchingNumber (repairHypergraph C x r) := by
  apply matchingNumber_minimalHyperedges
  exact fun _ hR => repair_edge_nonempty_of_dualDist hr hd hR

/-- Passing to inclusion-minimal repairs always preserves transversal number. -/
theorem transversalNumber_minimalRepairHypergraph
    (C : Submodule 𝔽 (ι → 𝔽)) (x : ι) (r : ℕ) :
    transversalNumber (minimalRepairHypergraph C x r) =
      transversalNumber (repairHypergraph C x r) :=
  transversalNumber_minimalHyperedges _

/-- A repair edge of a row code gives a genuinely dependent family consisting of the target
column and its helpers. The coefficients are the witnessing dual word restricted to its support. -/
theorem repair_edge_columns_dependent {k : ℕ} {G : Matrix (Fin k) ι 𝔽}
    {x : ι} {r : ℕ} {R : Finset ι}
    (hR : R ∈ repairHypergraph (rowCode G) x r) :
    ¬ LinearIndependent 𝔽 (fun j : ↥(insert x R) => G.col j) := by
  obtain ⟨-, -, y, hy, hyx, hsupp⟩ := mem_repairHypergraph.mp hR
  have hfull := dual_word_column_relation hy
  have hrel : ∑ j : ↥(insert x R), y j • G.col j = 0 := by
    calc
      (∑ j : ↥(insert x R), y j • G.col j) = ∑ j ∈ insert x R, y j • G.col j := by
        rw [← (insert x R).sum_attach]
        rfl
      _ = ∑ j, y j • G.col j := by
        apply Finset.sum_subset (Finset.subset_univ _)
        intro j _ hj
        have hj0 : y j = 0 := by
          have : j ∉ wordSupport y := by simpa only [hsupp] using hj
          simpa only [mem_wordSupport, not_not] using this
        simp [hj0]
      _ = 0 := hfull
  rw [Fintype.not_linearIndependent_iff]
  refine ⟨(fun j : ↥(insert x R) => y j), hrel, ?_⟩
  exact ⟨⟨x, Finset.mem_insert_self x R⟩, hyx⟩

/-- Reindexing the target-and-helper columns of a repair edge as a square matrix gives zero
determinant. This is the determinant form of `repair_edge_columns_dependent`. -/
theorem repair_edge_reindexed_det_eq_zero {k : ℕ} {G : Matrix (Fin k) ι 𝔽}
    {x : ι} {r : ℕ} {R : Finset ι}
    (hR : R ∈ repairHypergraph (rowCode G) x r) (e : Fin k ≃ ↥(insert x R)) :
    Matrix.det (fun i j => G i (e j)) = 0 := by
  let A : Matrix (Fin k) (Fin k) 𝔽 := fun i j => G i (e j)
  change A.det = 0
  apply Matrix.det_eq_zero_of_not_linearIndependent_cols
  intro hli
  apply repair_edge_columns_dependent hR
  have heq : (A.col ∘ e.symm) = fun j : ↥(insert x R) => G.col j := by
    funext j
    ext i
    simp [A, Matrix.col]
  rw [← heq]
  exact hli.comp e.symm e.symm.injective

/-- Conversely, a dependent target-and-helper column family of the minimum size allowed by dual
distance is an actual repair edge. The extended relation is a dual word; the distance lower bound
forces its support to use every selected column, including the target. -/
theorem mem_repairHypergraph_of_columns_dependent {k : ℕ} {G : Matrix (Fin k) ι 𝔽}
    {x : ι} {r : ℕ} {R : Finset ι} (hsub : R ⊆ univ.erase x)
    (hcard : R.card = r) (hd : r + 1 ≤ dualDist (rowCode G))
    (hdep : ¬ LinearIndependent 𝔽 (fun j : ↥(insert x R) => G.col j)) :
    R ∈ repairHypergraph (rowCode G) x r := by
  classical
  have hxR : x ∉ R := by
    intro hx
    exact (Finset.mem_erase.mp (hsub hx)).1 rfl
  rw [Fintype.not_linearIndependent_iff] at hdep
  obtain ⟨c, hrel, ⟨j, hcj⟩⟩ := hdep
  let y : ι → 𝔽 := fun i => if hi : i ∈ insert x R then c ⟨i, hi⟩ else 0
  have hyrel : ∑ i, y i • G.col i = 0 := by
    calc
      (∑ i, y i • G.col i) = ∑ i ∈ insert x R, y i • G.col i := by
        symm
        apply Finset.sum_subset (Finset.subset_univ _)
        intro i _ hi
        simp only [y, dif_neg hi, zero_smul]
      _ = ∑ i : ↥(insert x R), c i • G.col i := by
        rw [← (insert x R).sum_attach]
        apply Finset.sum_congr rfl
        intro i _
        simp only [y, dif_pos i.property]
      _ = 0 := hrel
  have hy : y ∈ dualCode (rowCode G) := mem_dualCode_rowCode_of_column_relation hyrel
  have hy0 : y ≠ 0 := by
    intro hzero
    have hj0 := congrFun hzero j
    simp only [y, dif_pos j.property, Pi.zero_apply] at hj0
    exact hcj hj0
  have hsupp : wordSupport y ⊆ insert x R := by
    intro i hi
    by_contra hnot
    have hyi : y i = 0 := by simp only [y, dif_neg hnot]
    exact (mem_wordSupport.mp hi) hyi
  have hselected : (insert x R).card = r + 1 := by
    rw [Finset.card_insert_of_notMem hxR, hcard]
  have hdist : r + 1 ≤ (wordSupport y).card := by
    simpa only [card_wordSupport] using (hd.trans (dualDist_le_hammingNorm hy hy0))
  have hsupp_eq : wordSupport y = insert x R := by
    apply Finset.eq_of_subset_of_card_le hsupp
    rw [hselected]
    exact hdist
  have hyx : y x ≠ 0 := by
    apply mem_wordSupport.mp
    rw [hsupp_eq]
    exact Finset.mem_insert_self x R
  apply mem_repairHypergraph.mpr
  exact ⟨hsub, hcard.le, y, hy, hyx, hsupp_eq⟩

/-- A full-support linear relation on the target and helper columns gives a repair edge directly,
without a global dual-distance hypothesis.  This is the correct converse for codes that have
smaller circuits elsewhere (the twisted-cubic–axis code has axis triples, but its cubic-coordinate
repairs are four-circuits). -/
theorem mem_repairHypergraph_of_fullSupport_relation {k : ℕ} {G : Matrix (Fin k) ι 𝔽}
    {x : ι} {r : ℕ} {R : Finset ι} (hsub : R ⊆ univ.erase x) (hcard : R.card = r)
    (c : ↥(insert x R) → 𝔽) (hrel : ∑ j, c j • G.col j = 0)
    (hfull : ∀ j, c j ≠ 0) :
    R ∈ repairHypergraph (rowCode G) x r := by
  classical
  have hxR : x ∉ R := by
    intro hx
    exact (Finset.mem_erase.mp (hsub hx)).1 rfl
  let y : ι → 𝔽 := fun i => if hi : i ∈ insert x R then c ⟨i, hi⟩ else 0
  have hyrel : ∑ i, y i • G.col i = 0 := by
    calc
      (∑ i, y i • G.col i) = ∑ i ∈ insert x R, y i • G.col i := by
        symm
        apply Finset.sum_subset (Finset.subset_univ _)
        intro i _ hi
        simp only [y, dif_neg hi, zero_smul]
      _ = ∑ i : ↥(insert x R), c i • G.col i := by
        rw [← (insert x R).sum_attach]
        apply Finset.sum_congr rfl
        intro i _
        simp only [y, dif_pos i.property]
      _ = 0 := hrel
  have hy : y ∈ dualCode (rowCode G) := mem_dualCode_rowCode_of_column_relation hyrel
  have hsupp : wordSupport y = insert x R := by
    ext i
    rw [mem_wordSupport]
    by_cases hi : i ∈ insert x R
    · simp only [hi, iff_true, y, dif_pos hi]
      exact hfull ⟨i, hi⟩
    · constructor
      · intro hyi
        apply (hyi (by
          change (if h : i ∈ insert x R then c ⟨i, h⟩ else 0) = 0
          rw [dif_neg hi])).elim
      · intro himem
        exact (hi himem).elim
  have hyx : y x ≠ 0 := by
    apply mem_wordSupport.mp
    rw [hsupp]
    exact Finset.mem_insert_self x R
  apply mem_repairHypergraph.mpr
  exact ⟨hsub, hcard.le, y, hy, hyx, hsupp⟩

/-- Reindexed full-support converse.  The relation may be supplied in any finite enumeration of
the selected target-and-helper coordinates. -/
theorem mem_repairHypergraph_of_reindexed_fullSupport_relation {k : ℕ}
    {G : Matrix (Fin k) ι 𝔽} {α : Type*} [Fintype α]
    {x : ι} {r : ℕ} {R : Finset ι} (hsub : R ⊆ univ.erase x) (hcard : R.card = r)
    (e : α ≃ ↥(insert x R)) (c : α → 𝔽)
    (hrel : ∑ j, c j • G.col (e j) = 0) (hfull : ∀ j, c j ≠ 0) :
    R ∈ repairHypergraph (rowCode G) x r := by
  let c' : ↥(insert x R) → 𝔽 := fun j => c (e.symm j)
  apply mem_repairHypergraph_of_fullSupport_relation hsub hcard c'
  · calc
      (∑ j, c' j • G.col j) = ∑ i, c' (e i) • G.col (e i) :=
        (e.sum_comp (fun j => c' j • G.col j)).symm
      _ = ∑ i, c i • G.col (e i) := by
        apply Finset.sum_congr rfl
        intro i _
        simp [c']
      _ = 0 := hrel
  · intro j
    simpa [c'] using hfull (e.symm j)

/-- A monomial automorphism of a generator's column configuration transports every bounded
repair edge. The ambient linear equivalence and nonzero column scales carry the full-support
relation witness, so the target coefficient remains nonzero. -/
theorem repairHypergraph_map_mem_of_monomial {k : ℕ} {G : Matrix (Fin k) ι 𝔽}
    (e : ι ≃ ι) (T : (Fin k → 𝔽) ≃ₗ[𝔽] (Fin k → 𝔽)) (scale : ι → 𝔽)
    (hscale : ∀ j, scale j ≠ 0) (hcol : ∀ j, T (G.col j) = scale j • G.col (e j))
    {x : ι} {r : ℕ} {R : Finset ι} (hR : R ∈ repairHypergraph (rowCode G) x r) :
    R.map e.toEmbedding ∈ repairHypergraph (rowCode G) (e x) r := by
  classical
  obtain ⟨hsub, hcard, y, hy, hyx, hsupp⟩ := mem_repairHypergraph.mp hR
  let S : Finset ι := insert x R
  let f0 : S → ↥(insert (e x) (R.map e.toEmbedding)) := fun j =>
    ⟨e j, by
      rw [Finset.mem_insert]
      by_cases hj : (j : ι) = x
      · exact Or.inl (congrArg e hj)
      · apply Or.inr
        apply Finset.mem_map.mpr
        refine ⟨j, ?_, rfl⟩
        have := j.property
        simp only [S, Finset.mem_insert] at this
        exact this.resolve_left hj⟩
  have hf0 : Function.Injective f0 := by
    intro i j hij
    exact Subtype.ext (e.injective (congrArg Subtype.val hij))
  have hf0surj : Function.Surjective f0 := by
    intro j
    rcases j with ⟨j, hj⟩
    simp only [Finset.mem_insert] at hj
    rcases hj with hj | hj
    · subst j
      exact ⟨⟨x, by simp [S]⟩, by ext; simp [f0]⟩
    · obtain ⟨q, hq, hqj⟩ := Finset.mem_map.mp hj
      subst j
      exact ⟨⟨q, by simp [S, hq]⟩, by ext; simp [f0]⟩
  let f : S ≃ ↥(insert (e x) (R.map e.toEmbedding)) :=
    Equiv.ofBijective f0 ⟨hf0, hf0surj⟩
  have hsubmap : R.map e.toEmbedding ⊆ Finset.univ.erase (e x) := by
    intro j hj
    obtain ⟨q, hq, rfl⟩ := Finset.mem_map.mp hj
    rw [Finset.mem_erase]
    refine ⟨?_, Finset.mem_univ _⟩
    intro heq
    exact (Finset.mem_erase.mp (hsub hq)).1 (e.injective heq)
  have hcardmap : (R.map e.toEmbedding).card = R.card := Finset.card_map _
  let c : S → 𝔽 := fun j => y j * scale j
  have hrestricted : ∑ j : S, y j • G.col j = 0 := by
    have hfull := dual_word_column_relation hy
    calc
      (∑ j : S, y j • G.col j) =
          Finset.sum (s := S) (fun j : ι => y j • G.col j) := by
        rw [← S.sum_attach]
        rfl
      _ = ∑ j, y j • G.col j := by
        apply Finset.sum_subset (Finset.subset_univ _)
        intro j _ hj
        have hj0 : y j = 0 := by
          have : j ∉ wordSupport y := by simpa only [S, hsupp] using hj
          simpa only [mem_wordSupport, not_not] using this
        simp [hj0]
      _ = 0 := hfull
  have hmapped : ∑ j : S, c j • G.col (e j) = 0 := by
    have hmap := congrArg (fun z => T z) hrestricted
    simp only [map_sum, map_smul, map_zero] at hmap
    simpa only [c, hcol, smul_smul, mul_comm] using hmap
  have hfull : ∀ j, c j ≠ 0 := by
    intro j
    apply mul_ne_zero
    · apply mem_wordSupport.mp
      rw [hsupp]
      exact j.property
    · exact hscale j
  have hedge : R.map e.toEmbedding ∈
      repairHypergraph (rowCode G) (e x) (R.map e.toEmbedding).card :=
    mem_repairHypergraph_of_reindexed_fullSupport_relation
      hsubmap rfl f c hmapped hfull
  exact repairHypergraph_mono_radius (hcardmap.trans_le hcard) hedge

/-- Exact repair-edge transport under a monomial automorphism of the generator columns. -/
theorem repairHypergraph_map_mem_iff_of_monomial {k : ℕ} {G : Matrix (Fin k) ι 𝔽}
    (e : ι ≃ ι) (T : (Fin k → 𝔽) ≃ₗ[𝔽] (Fin k → 𝔽)) (scale : ι → 𝔽)
    (hscale : ∀ j, scale j ≠ 0) (hcol : ∀ j, T (G.col j) = scale j • G.col (e j))
    {x : ι} {r : ℕ} {R : Finset ι} :
    R.map e.toEmbedding ∈ repairHypergraph (rowCode G) (e x) r ↔
      R ∈ repairHypergraph (rowCode G) x r := by
  let invScale : ι → 𝔽 := fun j => (scale (e.symm j))⁻¹
  have hinvScale : ∀ j, invScale j ≠ 0 := fun j => inv_ne_zero (hscale (e.symm j))
  have hinvCol : ∀ j, T.symm (G.col j) = invScale j • G.col (e.symm j) := by
    intro j
    apply T.injective
    simp [invScale, hcol, smul_smul, hscale]
  constructor
  · intro hR
    have hback := repairHypergraph_map_mem_of_monomial
      e.symm T.symm invScale hinvScale hinvCol hR
    have hmap : (R.map e.toEmbedding).map e.symm.toEmbedding = R := by
      apply Finset.ext
      intro j
      simp
    rw [hmap] at hback
    simpa using hback
  · exact repairHypergraph_map_mem_of_monomial e T scale hscale hcol

/-- A monomial column automorphism relabels the complete bounded repair hypergraph exactly. -/
theorem relabel_repairHypergraph_of_monomial {k : ℕ} {G : Matrix (Fin k) ι 𝔽}
    (e : ι ≃ ι) (T : (Fin k → 𝔽) ≃ₗ[𝔽] (Fin k → 𝔽)) (scale : ι → 𝔽)
    (hscale : ∀ j, scale j ≠ 0) (hcol : ∀ j, T (G.col j) = scale j • G.col (e j))
    (x : ι) (r : ℕ) :
    relabelHypergraph e (repairHypergraph (rowCode G) x r) =
      repairHypergraph (rowCode G) (e x) r := by
  classical
  ext A
  constructor
  · intro hA
    obtain ⟨R, hR, rfl⟩ := Finset.mem_image.mp hA
    exact repairHypergraph_map_mem_of_monomial e T scale hscale hcol hR
  · intro hA
    let R := A.map e.symm.toEmbedding
    have hmap : R.map e.toEmbedding = A := by
      apply Finset.ext
      intro j
      simp [R]
    have hR : R ∈ repairHypergraph (rowCode G) x r := by
      apply (repairHypergraph_map_mem_iff_of_monomial e T scale hscale hcol).mp
      simpa [hmap] using hA
    exact Finset.mem_image.mpr ⟨R, hR, hmap⟩

omit [Fintype ι] [DecidableEq 𝔽] in
/-- Minimal dependence forces every coefficient of every nonzero relation to be nonzero. -/
theorem relation_fullSupport_of_delete_linearIndependent {k : ℕ} {G : Matrix (Fin k) ι 𝔽}
    {S : Finset ι} (hdelete : ∀ j : S,
      LinearIndependent 𝔽 (fun i : {i : S // i ≠ j} => G.col i))
    {c : S → 𝔽} (hrel : ∑ j, c j • G.col j = 0) (hc : c ≠ 0) :
    ∀ j, c j ≠ 0 := by
  intro j hcj
  let c' : {i : S // i ≠ j} → 𝔽 := fun i => c i
  have hrel' : ∑ i, c' i • G.col i = 0 := by
    calc
      (∑ i, c' i • G.col i) = ∑ i : {i : S // i ≠ j}, c i • G.col i := rfl
      _ = ∑ i : S, c i • G.col i := by
        rw [Fintype.sum_eq_add_sum_subtype_ne _ j, hcj, zero_smul, zero_add]
      _ = 0 := hrel
  have hzero := (Fintype.linearIndependent_iff.mp (hdelete j)) c' hrel'
  apply hc
  funext i
  by_cases hij : i = j
  · simpa [hij] using hcj
  · exact hzero ⟨i, hij⟩

/-- Circuit-local converse: a dependent selected family whose every one-point deletion is
independent is an actual repair edge. -/
theorem mem_repairHypergraph_of_circuit {k : ℕ} {G : Matrix (Fin k) ι 𝔽}
    {x : ι} {r : ℕ} {R : Finset ι} (hsub : R ⊆ univ.erase x) (hcard : R.card = r)
    (hdep : ¬ LinearIndependent 𝔽 (fun j : ↥(insert x R) => G.col j))
    (hdelete : ∀ j : ↥(insert x R),
      LinearIndependent 𝔽 (fun i : {i : ↥(insert x R) // i ≠ j} => G.col i)) :
    R ∈ repairHypergraph (rowCode G) x r := by
  rw [Fintype.not_linearIndependent_iff] at hdep
  obtain ⟨c, hrel, ⟨j, hcj⟩⟩ := hdep
  have hc : c ≠ 0 := by
    intro hzero
    exact hcj (congrFun hzero j)
  exact mem_repairHypergraph_of_fullSupport_relation hsub hcard c hrel
    (relation_fullSupport_of_delete_linearIndependent hdelete hrel hc)

/-- Reindexed circuit-local converse.  A circuit may be proved in whatever finite enumeration is
convenient; an equivalence with the selected target-and-helper coordinates transports it to an
actual repair edge. -/
theorem mem_repairHypergraph_of_reindexed_circuit {k : ℕ} {G : Matrix (Fin k) ι 𝔽}
    {α : Type*} [Fintype α] [DecidableEq α]
    {x : ι} {r : ℕ} {R : Finset ι} (hsub : R ⊆ univ.erase x) (hcard : R.card = r)
    (e : α ≃ ↥(insert x R))
    (hdep : ¬ LinearIndependent 𝔽 (fun j : α => G.col (e j)))
    (hdelete : ∀ j : α,
      LinearIndependent 𝔽 (fun i : {i : α // i ≠ j} => G.col (e i))) :
    R ∈ repairHypergraph (rowCode G) x r := by
  apply mem_repairHypergraph_of_circuit hsub hcard
  · intro hli
    exact hdep (hli.comp e e.injective)
  · intro j
    let e' : {i : α // i ≠ e.symm j} ≃ {i : ↥(insert x R) // i ≠ j} :=
      e.subtypeEquiv (fun _ => (not_congr e.apply_eq_iff_eq_symm_apply).symm)
    have hli := (hdelete (e.symm j)).comp e'.symm e'.symm.injective
    have heq :
        ((fun i : {i : α // i ≠ e.symm j} => G.col (e i)) ∘ e'.symm) =
          (fun i : {i : ↥(insert x R) // i ≠ j} => G.col i) := by
      funext i
      change G.col (e (e.symm i.1)) = G.col i.1
      rw [e.apply_symm_apply]
    rw [← heq]
    exact hli

#print axioms repairHypergraph_map_mem_iff_of_monomial
#print axioms relabel_repairHypergraph_of_monomial

end FiniteGeom
