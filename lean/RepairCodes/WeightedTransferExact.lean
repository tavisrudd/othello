import RepairCodes.SeedLift

/-!
# Exact weighted multiblock threshold

This file separates the three cases in the exact obstruction to a dual word meeting two or more
inner blocks.  The formulation uses lower-bound predicates rather than a chosen minimum, so empty
functional-dual strata have the intended value `infinity` rather than `Nat.sInf ∅ = 0`.
-/

namespace RepairCodes

open Finset FiniteGeom
open scoped BigOperators

noncomputable section

variable {ι κ V 𝔽 : Type*}
variable [Fintype ι] [DecidableEq ι] [Fintype κ] [DecidableEq κ]
variable [Field 𝔽] [DecidableEq 𝔽]
variable [AddCommGroup V] [Module 𝔽 V] [DecidableEq V]

/-- The set of inner blocks met by a block family. -/
def blockSupport (w : ι → (κ → 𝔽)) : Finset ι :=
  univ.filter fun j => w j ≠ 0

/-- Every concatenated dual word meeting at least two blocks has weight at least `d`. -/
def HasMultiblockDualDistanceAtLeast
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ) : Prop :=
  ∀ w : ι → (κ → 𝔽),
    (fun p => w p.1 p.2) ∈ dualCode (concatenatedCode I e O) →
    2 ≤ (blockSupport w).card → d ≤ ∑ j, hammingNorm (w j)

/-- A concatenated dual word is an embedded inner-dual word when all but one block vanish and the
remaining block lies in the inner dual.  The zero word is included (choose any block), matching
the image of the one-block embedding. -/
def IsEmbeddedInnerDualBlock
    (I : Submodule 𝔽 (κ → 𝔽)) (w : ι → (κ → 𝔽)) : Prop :=
  ∃ j, w j ∈ dualCode I ∧ ∀ l, l ≠ j → w l = 0

/-- Every concatenated dual word which is not an embedded inner-dual block has weight at least
`d`.  This lower-bound predicate gives the corrected exact threshold without assigning the wrong
value to an empty obstruction set. -/
def HasNonembeddedDualDistanceAtLeast
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ) : Prop :=
  ∀ w : ι → (κ → 𝔽),
    (fun p => w p.1 p.2) ∈ dualCode (concatenatedCode I e O) →
    ¬ IsEmbeddedInnerDualBlock I w →
    d ≤ ∑ j, hammingNorm (w j)

/-- Every realization of every nonzero functional-dual tuple has total inner weight at least `d`.
This is the lower-bound semantics of the manuscript's weighted distance `d_lambda(O)`. -/
def HasNonzeroFunctionalRealizationAtLeast
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ) : Prop :=
  ∀ beta, beta ∈ functionalDual O → beta ≠ 0 → ∀ w : ι → (κ → 𝔽),
    (∀ j, blockFunctional I e (w j) = beta j) →
      d ≤ ∑ j, hammingNorm (w j)

/-- The zero-functional stratum of the multiblock threshold. -/
def HasZeroFunctionalMultiblockAtLeast
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ) : Prop :=
  ∀ w : ι → (κ → 𝔽),
    (fun p => w p.1 p.2) ∈ dualCode (concatenatedCode I e O) →
    2 ≤ (blockSupport w).card →
    (fun j => blockFunctional I e (w j)) = 0 →
    d ≤ ∑ j, hammingNorm (w j)

/-- The singleton-functional stratum of the multiblock threshold. -/
def HasSingletonFunctionalMultiblockAtLeast
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ) : Prop :=
  ∀ w : ι → (κ → 𝔽),
    (fun p => w p.1 p.2) ∈ dualCode (concatenatedCode I e O) →
    2 ≤ (blockSupport w).card →
    functionalWeight (fun j => blockFunctional I e (w j)) = 1 →
    d ≤ ∑ j, hammingNorm (w j)

/-- The multisupport-functional stratum of the multiblock threshold. -/
def HasMultisupportFunctionalMultiblockAtLeast
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ) : Prop :=
  ∀ w : ι → (κ → 𝔽),
    (fun p => w p.1 p.2) ∈ dualCode (concatenatedCode I e O) →
    2 ≤ (blockSupport w).card →
    2 ≤ functionalWeight (fun j => blockFunctional I e (w j)) →
    d ≤ ∑ j, hammingNorm (w j)

/-- An outer code is coordinate-surjective when every symbol occurs in every coordinate. -/
def IsCoordinateSurjective (O : Submodule 𝔽 (ι → V)) : Prop :=
  ∀ j v, ∃ u ∈ O, u j = v

/-- A representative uses no zero-functional blocks.  Such representatives are the product-fiber
choices appearing in the closed formula. -/
def IsSupportReducedRepresentative
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (beta : ι → Module.Dual 𝔽 V) (w : ι → (κ → 𝔽)) : Prop :=
  (∀ j, blockFunctional I e (w j) = beta j) ∧
    ∀ j, beta j = 0 → w j = 0

/-- The singleton-functional term: one functional fiber plus one nonzero inner-dual block. -/
def HasSingletonFunctionalTermAtLeast
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ) : Prop :=
  ∀ beta, beta ∈ functionalDual O → functionalWeight beta = 1 →
    ∀ w, IsSupportReducedRepresentative I e beta w →
      d ≤ dualDist I + ∑ j, hammingNorm (w j)

/-- The multisupport-functional term: independently realize every nonzero functional fiber. -/
def HasMultisupportFunctionalTermAtLeast
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ) : Prop :=
  ∀ beta, beta ∈ functionalDual O → 2 ≤ functionalWeight beta →
    ∀ w, IsSupportReducedRepresentative I e beta w →
      d ≤ ∑ j, hammingNorm (w j)

/-- Flattening a block family is dual exactly when its block functionals annihilate the outer
code.  `blockFunctional_mem_functionalDual` supplies the reverse implication used elsewhere. -/
theorem flatten_mem_dualCode_concatenatedCode_of_functionalDual
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (w : ι → (κ → 𝔽))
    (hbeta : (fun j => blockFunctional I e (w j)) ∈ functionalDual O) :
    (fun p => w p.1 p.2) ∈ dualCode (concatenatedCode I e O) := by
  rw [mem_dualCode]
  intro c hc
  obtain ⟨u, hu, rfl⟩ := Submodule.mem_map.mp hc
  simpa [dotProduct, Fintype.sum_prod_type, concatenationLinearMap_apply,
    blockFunctional] using hbeta u hu

/-- An embedded block family meets at most one block. -/
theorem blockSupport_card_le_one_of_isEmbeddedInnerDualBlock
    (I : Submodule 𝔽 (κ → 𝔽)) {w : ι → (κ → 𝔽)}
    (h : IsEmbeddedInnerDualBlock I w) : (blockSupport w).card ≤ 1 := by
  classical
  obtain ⟨j, _, hj⟩ := h
  apply Finset.card_le_one.mpr
  intro a ha b hb
  have ha' : w a ≠ 0 := (Finset.mem_filter.mp ha).2
  have hb' : w b ≠ 0 := (Finset.mem_filter.mp hb).2
  have haj : a = j := by
    by_contra hne
    exact ha' (hj a hne)
  have hbj : b = j := by
    by_contra hne
    exact hb' (hj b hne)
  exact haj.trans hbj.symm

/-- Conversely, an all-inner block family meeting at most one block is an embedded inner-dual
word. -/
theorem isEmbeddedInnerDualBlock_of_all_inner_of_card_le_one
    [Nonempty ι] (I : Submodule 𝔽 (κ → 𝔽)) {w : ι → (κ → 𝔽)}
    (hinner : ∀ j, w j ∈ dualCode I) (hcard : (blockSupport w).card ≤ 1) :
    IsEmbeddedInnerDualBlock I w := by
  classical
  by_cases hzero : blockSupport w = ∅
  · let j : ι := Classical.choice inferInstance
    refine ⟨j, hinner j, ?_⟩
    intro l _
    by_contra hl
    have : l ∈ blockSupport w := Finset.mem_filter.mpr ⟨Finset.mem_univ _, hl⟩
    simpa [hzero] using this
  · obtain ⟨j, hj⟩ := Finset.nonempty_iff_ne_empty.mpr hzero
    refine ⟨j, hinner j, ?_⟩
    intro l hlj
    by_contra hl
    have hljSupport : l ∈ blockSupport w :=
      Finset.mem_filter.mpr ⟨Finset.mem_univ _, hl⟩
    exact hlj (Finset.card_le_one.mp hcard l hljSupport j hj)

/-- **Corrected exact threshold.**  A nonembedded concatenated-dual obstruction has exactly two
possible forms: a zero-functional word meeting at least two inner blocks, or a realization of a
nonzero outer functional-dual word.  Stating the result for every lower bound is equivalent to
the extended minimum formula `delta_emb = min (2 d(I^perp)) d_lambda(O)` and remains correct when
one of the two strata is empty. -/
theorem hasNonembeddedDualDistanceAtLeast_iff_zero_and_weighted
    [Nonempty ι]
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ) :
    HasNonembeddedDualDistanceAtLeast I e O d ↔
      HasZeroFunctionalMultiblockAtLeast I e O d ∧
      HasNonzeroFunctionalRealizationAtLeast I e O d := by
  classical
  constructor
  · intro h
    constructor
    · intro w hw hblocks _
      apply h w hw
      intro hembedded
      have := blockSupport_card_le_one_of_isEmbeddedInnerDualBlock I hembedded
      omega
    · intro beta hbeta hbeta0 w hwrealize
      have hwdual := flatten_mem_dualCode_concatenatedCode_of_functionalDual I e O w (by
        simpa only [hwrealize] using hbeta)
      apply h w hwdual
      rintro ⟨j, hjinner, hjzero⟩
      apply hbeta0
      funext l
      by_cases hlj : l = j
      · subst l
        change beta j = (0 : Module.Dual 𝔽 V)
        rw [← hwrealize j, blockFunctional_eq_zero_iff I e]
        exact hjinner
      · change beta l = (0 : Module.Dual 𝔽 V)
        rw [← hwrealize l, hjzero l hlj]
        apply LinearMap.ext
        intro v
        simp [blockFunctional]
  · rintro ⟨hzero, hweighted⟩ w hwdual hnotembedded
    let beta : ι → Module.Dual 𝔽 V := fun j => blockFunctional I e (w j)
    have horth := dualWord_isOrthogonalToConcatenation I e O hwdual
    have hwblock : wordBlock (fun p => w p.1 p.2) = w := by
      funext j x
      rfl
    rw [hwblock] at horth
    have hbeta : beta ∈ functionalDual O :=
      blockFunctional_mem_functionalDual I e O w horth
    by_cases hbeta0 : beta = 0
    · apply hzero w hwdual
      · have hinner : ∀ j, w j ∈ dualCode I := by
          intro j
          rw [← blockFunctional_eq_zero_iff I e]
          exact congrFun hbeta0 j
        by_contra hblocks
        apply hnotembedded
        apply isEmbeddedInnerDualBlock_of_all_inner_of_card_le_one I hinner
        omega
      · exact hbeta0
    · exact hweighted beta hbeta hbeta0 w (fun _ => rfl)

omit [DecidableEq V] in
/-- Below the corrected exact threshold, every concatenated-dual word is an embedded inner-dual
word.  This is the precise confinement statement needed by the repair-hypergraph proof. -/
theorem concatenatedDualWord_transfer_nonembedded
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) {w : ι × κ → 𝔽} (d s : ℕ)
    (hw : w ∈ dualCode (concatenatedCode I e O))
    (hd : HasNonembeddedDualDistanceAtLeast I e O d)
    (hwt : hammingNorm w ≤ s) (hsd : s < d) :
    (∀ j, wordBlock w j ∈ dualCode I) ∧
      (univ.filter (fun j => wordBlock w j ≠ 0)).card ≤ 1 := by
  classical
  have hembedded : IsEmbeddedInnerDualBlock I (wordBlock w) := by
    by_contra hnot
    have hlower := hd (wordBlock w) (by simpa [wordBlock] using hw) hnot
    rw [← hammingNorm_eq_sum_hammingNorm_wordBlock] at hlower
    omega
  constructor
  · intro l
    obtain ⟨j, hjinner, hjzero⟩ := hembedded
    by_cases hlj : l = j
    · simpa [hlj] using hjinner
    · rw [hjzero l hlj]
      exact Submodule.zero_mem _
  · exact blockSupport_card_le_one_of_isEmbeddedInnerDualBlock I hembedded

omit [DecidableEq V] in
/-- **Corrected complete-repair transfer.**  If every nonembedded concatenated-dual word has
weight at least `r + 2`, then the complete radius-`r` repair hypergraph is exactly the embedded
inner repair hypergraph. -/
theorem repairHypergraph_concatenatedCode_eq_embed_nonembedded
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (r : ℕ)
    (hd : HasNonembeddedDualDistanceAtLeast I e O (r + 2))
    (j : ι) (x : κ) :
    repairHypergraph (concatenatedCode I e O) (j, x) r =
      embedHypergraph (blockEmbedding j) (repairHypergraph I x r) := by
  classical
  ext R
  constructor
  · intro hR
    obtain ⟨hRsub, hRcard, w, hwdual, hwx, hwsupp⟩ := mem_repairHypergraph.mp hR
    have hxR : (j, x) ∉ R := by
      intro hx
      exact (Finset.mem_erase.mp (hRsub hx)).1 rfl
    have hwt : hammingNorm w ≤ r + 1 := by
      rw [← card_wordSupport, hwsupp, Finset.card_insert_of_notMem hxR]
      omega
    have htransfer := concatenatedDualWord_transfer_nonembedded I e O (r + 2) (r + 1)
      hwdual hd hwt (by omega)
    have hjblock : wordBlock w j ≠ 0 := by
      intro hz
      exact hwx (congrFun hz x)
    have hsingle : ∀ l, wordBlock w l ≠ 0 → l = j := by
      intro l hl
      let B := univ.filter (fun a => wordBlock w a ≠ 0)
      have hjB : j ∈ B := by simp [B, hjblock]
      have hlB : l ∈ B := by simp [B, hl]
      exact (Finset.card_le_one.mp htransfer.2 l hlB j hjB)
    have hsuppMap := wordSupport_eq_map_wordSupport_wordBlock_of_single hsingle
    let S : Finset κ := (wordSupport (wordBlock w j)).erase x
    have hxSupp : x ∈ wordSupport (wordBlock w j) := mem_wordSupport.mpr hwx
    have hmapS : S.map (blockEmbedding j) = R := by
      dsimp [S]
      rw [Finset.map_erase, ← hsuppMap, hwsupp]
      exact Finset.erase_insert hxR
    have hScard : S.card ≤ r := by
      rw [← Finset.card_map (blockEmbedding j), hmapS]
      exact hRcard
    have hSsub : S ⊆ univ.erase x := by
      intro a ha
      exact Finset.mem_erase.mpr ⟨(Finset.mem_erase.mp ha).1, Finset.mem_univ _⟩
    have hinner : S ∈ repairHypergraph I x r := by
      apply mem_repairHypergraph.mpr
      refine ⟨hSsub, hScard, wordBlock w j, htransfer.1 j, hwx, ?_⟩
      exact (Finset.insert_erase hxSupp).symm
    exact Finset.mem_image.mpr ⟨S, hinner, hmapS⟩
  · intro hR
    obtain ⟨S, hS, rfl⟩ := Finset.mem_image.mp hR
    obtain ⟨hSsub, hScard, z, hzdual, hzx, hzsupp⟩ := mem_repairHypergraph.mp hS
    have hxS : x ∉ S := by
      intro hx
      exact (Finset.mem_erase.mp (hSsub hx)).1 rfl
    let w := singleBlockWord j z
    have hwdual : w ∈ dualCode (concatenatedCode I e O) :=
      singleBlockWord_mem_dualCode_concatenatedCode I e O hzdual
    have hwx : w (j, x) ≠ 0 := by simpa [w, singleBlockWord] using hzx
    have hsub : S.map (blockEmbedding j) ⊆ univ.erase (j, x) := by
      intro p hp
      obtain ⟨a, ha, rfl⟩ := Finset.mem_map.mp hp
      exact Finset.mem_erase.mpr ⟨by
        intro h
        have hax : a = x := congrArg Prod.snd h
        exact hxS (hax ▸ ha), Finset.mem_univ _⟩
    have hcard : (S.map (blockEmbedding j)).card ≤ r := by
      rw [Finset.card_map]
      exact hScard
    have hsupp : wordSupport w = insert (j, x) (S.map (blockEmbedding j)) := by
      change wordSupport (singleBlockWord j z) = _
      rw [wordSupport_singleBlockWord, hzsupp, Finset.map_insert]
      rfl
    exact mem_repairHypergraph.mpr ⟨hsub, hcard, w, hwdual, hwx, hsupp⟩

/-- Exact zero/singleton/multisupport partition.  This is an iff, so in contrast with a transfer
gate it also kernel-checks the converse: any failed global bound fails in one of the three stated
strata. -/
theorem hasMultiblockDualDistanceAtLeast_iff_three_strata
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ) :
    HasMultiblockDualDistanceAtLeast I e O d ↔
      HasZeroFunctionalMultiblockAtLeast I e O d ∧
      HasSingletonFunctionalMultiblockAtLeast I e O d ∧
      HasMultisupportFunctionalMultiblockAtLeast I e O d := by
  classical
  constructor
  · intro h
    exact ⟨fun w hw hm _ => h w hw hm,
      fun w hw hm _ => h w hw hm,
      fun w hw hm _ => h w hw hm⟩
  · rintro ⟨hzero, hsingle, hmulti⟩ w hw hm
    let beta : ι → Module.Dual 𝔽 V := fun j => blockFunctional I e (w j)
    by_cases hb0 : beta = 0
    · exact hzero w hw hm hb0
    have hpos0 : functionalWeight beta ≠ 0 := by
      intro hz
      apply hb0
      funext j
      change beta j = 0
      by_contra hj
      have hjmem : j ∈ univ.filter (fun l => beta l ≠ 0) :=
        Finset.mem_filter.mpr ⟨Finset.mem_univ _, hj⟩
      have hcard : 0 < (univ.filter fun l => beta l ≠ 0).card :=
        Finset.card_pos.mpr ⟨j, hjmem⟩
      rw [← functionalWeight] at hcard
      exact (Nat.ne_of_gt hcard) hz
    have hpos : 1 ≤ functionalWeight beta := Nat.one_le_iff_ne_zero.mpr hpos0
    by_cases hb1 : functionalWeight beta = 1
    · exact hsingle w hw hm hb1
    · apply hmulti w hw hm
      change 2 ≤ functionalWeight beta
      omega

omit [DecidableEq κ] [DecidableEq V] in
/-- Coordinate surjectivity excludes a nonzero functional-dual word supported at one coordinate. -/
theorem functionalWeight_ne_one_of_isCoordinateSurjective
    (O : Submodule 𝔽 (ι → V)) (hO : IsCoordinateSurjective O)
    {beta : ι → Module.Dual 𝔽 V} (hbeta : beta ∈ functionalDual O) :
    functionalWeight beta ≠ 1 := by
  classical
  intro hweight
  let S : Finset ι := univ.filter fun j => beta j ≠ 0
  have hScard : S.card = 1 := by simpa [functionalWeight, S] using hweight
  obtain ⟨j, hjS⟩ := Finset.card_eq_one.mp hScard
  have hjmem : j ∈ S := by rw [hjS]; simp
  have hbj : beta j ≠ 0 := (Finset.mem_filter.mp hjmem).2
  obtain ⟨v, hv⟩ : ∃ v, beta j v ≠ 0 := by
    by_contra h
    apply hbj
    apply LinearMap.ext
    intro v
    have hv : beta j v = 0 := by
      by_contra hv
      exact h ⟨v, hv⟩
    exact hv
  obtain ⟨u, huO, huj⟩ := hO j v
  have hann := hbeta u huO
  have hsum : (∑ l, beta l (u l)) = beta j (u j) := by
    apply Finset.sum_eq_single j
    · intro l _ hlj
      have hlS : l ∉ S := by simpa [hjS, hlj]
      have hbl : beta l = 0 := by simpa [S] using hlS
      simp [hbl]
    · simp
  rw [hsum, huj] at hann
  exact hv hann

omit [DecidableEq κ] [DecidableEq V] in
/-- Hence the singleton term is vacuous for coordinate-surjective outer codes. -/
theorem hasSingletonFunctionalTermAtLeast_of_isCoordinateSurjective
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (hO : IsCoordinateSurjective O) (d : ℕ) :
    HasSingletonFunctionalTermAtLeast I e O d := by
  intro beta hbeta hweight
  exact (functionalWeight_ne_one_of_isCoordinateSurjective O hO hbeta hweight).elim

omit [DecidableEq κ] [DecidableEq V] in
/-- At the exact multiblock level, coordinate surjectivity deletes the singleton stratum. -/
theorem hasSingletonFunctionalMultiblockAtLeast_of_isCoordinateSurjective
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (hO : IsCoordinateSurjective O) (d : ℕ) :
    HasSingletonFunctionalMultiblockAtLeast I e O d := by
  intro w hwdual _ hweight
  have horth := dualWord_isOrthogonalToConcatenation I e O hwdual
  have hwblock : wordBlock (fun p => w p.1 p.2) = w := by
    funext j x
    rfl
  rw [hwblock] at horth
  have hbeta : (fun j => blockFunctional I e (w j)) ∈ functionalDual O := by
    apply blockFunctional_mem_functionalDual I e O w
    exact horth
  exact (functionalWeight_ne_one_of_isCoordinateSurjective O hO hbeta hweight).elim

/-- For a coordinate-surjective outer code, a concatenated-dual word is nonembedded exactly when
it meets at least two inner blocks.  This is the missing hypothesis behind identifying the two
thresholds in the corrected theorem. -/
theorem not_isEmbeddedInnerDualBlock_iff_two_le_blockSupport_card_of_isCoordinateSurjective
    [Nonempty ι]
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (hO : IsCoordinateSurjective O)
    (w : ι → (κ → 𝔽))
    (hwdual : (fun p => w p.1 p.2) ∈ dualCode (concatenatedCode I e O)) :
    ¬ IsEmbeddedInnerDualBlock I w ↔ 2 ≤ (blockSupport w).card := by
  classical
  constructor
  · intro hnot
    by_contra hblocks
    apply hnot
    let beta : ι → Module.Dual 𝔽 V := fun j => blockFunctional I e (w j)
    have horth := dualWord_isOrthogonalToConcatenation I e O hwdual
    have hwblock : wordBlock (fun p => w p.1 p.2) = w := by
      funext j x
      rfl
    rw [hwblock] at horth
    have hbeta : beta ∈ functionalDual O :=
      blockFunctional_mem_functionalDual I e O w horth
    have hweight_le : functionalWeight beta ≤ (blockSupport w).card := by
      apply Finset.card_le_card
      intro j hj
      have hbj : beta j ≠ 0 := (Finset.mem_filter.mp hj).2
      apply Finset.mem_filter.mpr
      refine ⟨Finset.mem_univ _, ?_⟩
      intro hwj
      apply hbj
      change blockFunctional I e (w j) = 0
      rw [hwj]
      apply LinearMap.ext
      intro v
      simp [blockFunctional]
    have hbeta0 : beta = 0 := by
      by_contra hb0
      have hpos : 1 ≤ functionalWeight beta := by
        rw [functionalWeight]
        apply Finset.one_le_card.mpr
        obtain ⟨j, hj⟩ := Function.ne_iff.mp hb0
        exact ⟨j, Finset.mem_filter.mpr ⟨Finset.mem_univ _, hj⟩⟩
      have hone : functionalWeight beta = 1 := by omega
      exact functionalWeight_ne_one_of_isCoordinateSurjective O hO hbeta hone
    have hinner : ∀ j, w j ∈ dualCode I := by
      intro j
      rw [← blockFunctional_eq_zero_iff I e]
      exact congrFun hbeta0 j
    apply isEmbeddedInnerDualBlock_of_all_inner_of_card_le_one I hinner
    omega
  · intro htwo hembedded
    have hone := blockSupport_card_le_one_of_isEmbeddedInnerDualBlock I hembedded
    omega

/-- Under coordinate surjectivity, the multiblock and nonembedded exact thresholds coincide,
stated extensionally through all of their natural-number lower bounds. -/
theorem hasNonembeddedDualDistanceAtLeast_iff_multiblock_of_isCoordinateSurjective
    [Nonempty ι]
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (hO : IsCoordinateSurjective O) (d : ℕ) :
    HasNonembeddedDualDistanceAtLeast I e O d ↔
      HasMultiblockDualDistanceAtLeast I e O d := by
  constructor
  · intro h w hwdual hblocks
    exact h w hwdual
      ((not_isEmbeddedInnerDualBlock_iff_two_le_blockSupport_card_of_isCoordinateSurjective
        I e O hO w hwdual).mpr hblocks)
  · intro h w hwdual hnot
    exact h w hwdual
      ((not_isEmbeddedInnerDualBlock_iff_two_le_blockSupport_card_of_isCoordinateSurjective
        I e O hO w hwdual).mp hnot)

/-- The zero-functional stratum is bounded by two nonzero inner-dual blocks. -/
theorem hasZeroFunctionalMultiblockAtLeast_of_two_dualDist
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ) (hd : d ≤ 2 * dualDist I) :
    HasZeroFunctionalMultiblockAtLeast I e O d := by
  classical
  intro w _ hwblocks hzero
  have hinner : ∀ j, w j ∈ dualCode I := by
    intro j
    rw [← blockFunctional_eq_zero_iff I e]
    exact congrFun hzero j
  have hlower : dualDist I * (blockSupport w).card ≤ ∑ j, hammingNorm (w j) := by
    apply FiniteGeom.mul_card_filter_le_sum (fun j => hammingNorm (w j))
      (fun j => w j ≠ 0) (dualDist I)
    intro j hj
    exact dualDist_le_hammingNorm (hinner j) hj
  calc
    d ≤ 2 * dualDist I := hd
    _ = dualDist I * 2 := Nat.mul_comm _ _
    _ ≤ dualDist I * (blockSupport w).card := Nat.mul_le_mul_left _ hwblocks
    _ ≤ ∑ j, hammingNorm (w j) := hlower

/-- The singleton closed-form term bounds its exact multiblock stratum. -/
theorem hasSingletonFunctionalMultiblockAtLeast_of_term
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ)
    (hterm : HasSingletonFunctionalTermAtLeast I e O d) :
    HasSingletonFunctionalMultiblockAtLeast I e O d := by
  classical
  intro w hwdual hwblocks hweight
  let beta : ι → Module.Dual 𝔽 V := fun j => blockFunctional I e (w j)
  have horth := dualWord_isOrthogonalToConcatenation I e O hwdual
  have hwblock : wordBlock (fun p => w p.1 p.2) = w := by
    funext j x
    rfl
  rw [hwblock] at horth
  have hbeta : beta ∈ functionalDual O :=
    blockFunctional_mem_functionalDual I e O w horth
  let S : Finset ι := univ.filter fun j => beta j ≠ 0
  have hweight' : functionalWeight beta = 1 := by simpa only [beta] using hweight
  have hScard : S.card = 1 := by simpa [S, functionalWeight] using hweight'
  obtain ⟨j, hS⟩ := Finset.card_eq_one.mp hScard
  have hjS : j ∈ S := by rw [hS]; simp
  have hjbeta : beta j ≠ 0 := (Finset.mem_filter.mp hjS).2
  let w₀ : ι → (κ → 𝔽) := fun l => if beta l = 0 then 0 else w l
  have hw₀ : IsSupportReducedRepresentative I e beta w₀ := by
    constructor
    · intro l
      by_cases hbl : beta l = 0
      · rw [show w₀ l = 0 by simp [w₀, hbl], hbl]
        apply LinearMap.ext
        intro v
        simp [blockFunctional]
      · simp [w₀, hbl, beta]
    · intro l hbl
      simp [w₀, hbl]
  have hcore := hterm beta hbeta hweight' w₀ hw₀
  have hcoreSum : (∑ l, hammingNorm (w₀ l)) = hammingNorm (w j) := by
    calc
      (∑ l, hammingNorm (w₀ l)) = hammingNorm (w₀ j) := by
        apply Finset.sum_eq_single j
        · intro l _ hlj
          have hbl : beta l = 0 := by
            by_contra hbl
            have hlS : l ∈ S := Finset.mem_filter.mpr ⟨Finset.mem_univ _, hbl⟩
            rw [hS] at hlS
            exact hlj (Finset.mem_singleton.mp hlS)
          simp [w₀, hbl]
        · simp
      _ = hammingNorm (w j) := by simp [w₀, hjbeta]
  rw [hcoreSum] at hcore
  obtain ⟨l, hlw, hlj⟩ : ∃ l ∈ blockSupport w, l ≠ j := by
    by_contra hex
    push_neg at hex
    have hsub : blockSupport w ⊆ {j} := by
      intro l hl
      exact Finset.mem_singleton.mpr (hex l hl)
    have hcard := Finset.card_le_card hsub
    simp only [Finset.card_singleton] at hcard
    omega
  have hwl0 : w l ≠ 0 := (Finset.mem_filter.mp hlw).2
  have hbetal : beta l = 0 := by
    by_contra hbl
    have hlS : l ∈ S := Finset.mem_filter.mpr ⟨Finset.mem_univ _, hbl⟩
    rw [hS] at hlS
    exact hlj (Finset.mem_singleton.mp hlS)
  have hwldual : w l ∈ dualCode I := by
    rw [← blockFunctional_eq_zero_iff I e]
    exact hbetal
  have hldist := dualDist_le_hammingNorm hwldual hwl0
  have hpair : hammingNorm (w j) + hammingNorm (w l) ≤
      ∑ a, hammingNorm (w a) := by
    have hsub : ({j, l} : Finset ι) ⊆ univ := by simp
    have hp := Finset.sum_le_sum_of_subset hsub (f := fun a => hammingNorm (w a))
    simpa [hlj, Ne.symm hlj, add_comm] using hp
  omega

/-- A lower bound on reduced multisupport representatives bounds the full multisupport stratum;
extra zero-functional blocks can only increase weight. -/
theorem hasMultisupportFunctionalMultiblockAtLeast_of_term
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ)
    (hterm : HasMultisupportFunctionalTermAtLeast I e O d) :
    HasMultisupportFunctionalMultiblockAtLeast I e O d := by
  classical
  intro w hwdual _ hweight
  let beta : ι → Module.Dual 𝔽 V := fun j => blockFunctional I e (w j)
  have horth := dualWord_isOrthogonalToConcatenation I e O hwdual
  have hwblock : wordBlock (fun p => w p.1 p.2) = w := by
    funext j x
    rfl
  rw [hwblock] at horth
  have hbeta : beta ∈ functionalDual O :=
    blockFunctional_mem_functionalDual I e O w horth
  let w₀ : ι → (κ → 𝔽) := fun j => if beta j = 0 then 0 else w j
  have hw₀ : IsSupportReducedRepresentative I e beta w₀ := by
    constructor
    · intro j
      by_cases hbj : beta j = 0
      · rw [show w₀ j = 0 by simp [w₀, hbj], hbj]
        apply LinearMap.ext
        intro v
        simp [blockFunctional]
      · simp [w₀, hbj, beta]
    · intro j hbj
      simp [w₀, hbj]
  have hcore := hterm beta hbeta (by simpa [beta] using hweight) w₀ hw₀
  apply hcore.trans
  apply Finset.sum_le_sum
  intro j _
  by_cases hbj : beta j = 0 <;> simp [w₀, hbj]

/-- The closed zero/singleton/multisupport terms jointly imply the exact multiblock bound. -/
theorem hasMultiblockDualDistanceAtLeast_of_three_terms
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ)
    (hzero : d ≤ 2 * dualDist I)
    (hsingle : HasSingletonFunctionalTermAtLeast I e O d)
    (hmulti : HasMultisupportFunctionalTermAtLeast I e O d) :
    HasMultiblockDualDistanceAtLeast I e O d := by
  rw [hasMultiblockDualDistanceAtLeast_iff_three_strata]
  exact ⟨hasZeroFunctionalMultiblockAtLeast_of_two_dualDist I e O d hzero,
    hasSingletonFunctionalMultiblockAtLeast_of_term I e O d hsingle,
    hasMultisupportFunctionalMultiblockAtLeast_of_term I e O d hmulti⟩

/-- **Coordinate-surjective two-term corollary.**  Once singleton functional-dual words are
excluded, the exact partition reduces to the two bounds `2 * dualDist I` and the weighted
multisupport term. -/
theorem hasMultiblockDualDistanceAtLeast_of_isCoordinateSurjective
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (hO : IsCoordinateSurjective O) (d : ℕ)
    (hzero : d ≤ 2 * dualDist I)
    (hmulti : HasMultisupportFunctionalTermAtLeast I e O d) :
    HasMultiblockDualDistanceAtLeast I e O d := by
  rw [hasMultiblockDualDistanceAtLeast_iff_three_strata]
  exact ⟨hasZeroFunctionalMultiblockAtLeast_of_two_dualDist I e O d hzero,
    hasSingletonFunctionalMultiblockAtLeast_of_isCoordinateSurjective I e O hO d,
    hasMultisupportFunctionalMultiblockAtLeast_of_term I e O d hmulti⟩

/-- Averaging lemma used by the Singer example: if the total intersection count of a family of
translates is smaller than the number of translates, one translate is disjoint. -/
theorem exists_disjoint_translate_of_sum_inter_lt
    {G X : Type*} [Fintype G] [DecidableEq G] [Fintype X] [DecidableEq X]
    (S : Finset X) (translate : G → X ≃ X)
    (havg : (∑ g, (S ∩ S.map (translate g).toEmbedding).card) < Fintype.card G) :
    ∃ g, Disjoint S (S.map (translate g).toEmbedding) := by
  classical
  by_contra h
  push_neg at h
  have hone : ∀ g, 1 ≤ (S ∩ S.map (translate g).toEmbedding).card := by
    intro g
    apply Finset.one_le_card.mpr
    rw [Finset.nonempty_iff_ne_empty]
    intro hempty
    apply h g
    rw [Finset.disjoint_iff_inter_eq_empty]
    exact hempty
  have hsum : Fintype.card G ≤ ∑ g, (S ∩ S.map (translate g).toEmbedding).card := by
    calc
      Fintype.card G = ∑ _g : G, 1 := by simp
      _ ≤ ∑ g, (S ∩ S.map (translate g).toEmbedding).card :=
        Finset.sum_le_sum fun g _ => hone g
  omega

/-- The numerical endpoint of the completed-seed Singer average.  Keeping this as a named kernel
fact prevents the strict inequality in the averaging argument from living only in prose. -/
theorem completedQ9_singer_average_lt : 20 * 20 < 820 := by norm_num

/-- Five nonzero functional fibers cost at least six as soon as the Singer-disjoint pair cannot
both have cost one.  This is the arithmetic core of the generalized-SPC strict example. -/
theorem five_fiber_weight_at_least_six
    {a b c d e : ℕ} (ha : 1 ≤ a) (hb : 1 ≤ b) (hc : 1 ≤ c)
    (hd : 1 ≤ d) (he : 1 ≤ e) (hpair : 2 ≤ a ∨ 2 ≤ b) :
    6 ≤ a + b + c + d + e := by omega

end
end RepairCodes

#print axioms RepairCodes.functionalWeight_ne_one_of_isCoordinateSurjective
#print axioms RepairCodes.hasNonembeddedDualDistanceAtLeast_iff_zero_and_weighted
#print axioms RepairCodes.concatenatedDualWord_transfer_nonembedded
#print axioms RepairCodes.repairHypergraph_concatenatedCode_eq_embed_nonembedded
#print axioms RepairCodes.hasNonembeddedDualDistanceAtLeast_iff_multiblock_of_isCoordinateSurjective
#print axioms RepairCodes.hasMultiblockDualDistanceAtLeast_iff_three_strata
#print axioms RepairCodes.hasMultiblockDualDistanceAtLeast_of_three_terms
#print axioms RepairCodes.hasMultiblockDualDistanceAtLeast_of_isCoordinateSurjective
#print axioms RepairCodes.exists_disjoint_translate_of_sum_inter_lt
#print axioms RepairCodes.five_fiber_weight_at_least_six
