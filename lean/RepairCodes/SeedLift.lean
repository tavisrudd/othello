import RepairCodes.OuterDual
import FiniteGeom.Repair

/-!
# Ordinary concatenation and exact bounded-repair transfer

This file closes the representation gap between the abstract counting theorem in
`RepairCodes.Transfer` and the paper's seed-and-lift corollary.  We define the ordinary
concatenated linear code itself, prove its elementary dimension and distance bounds, and identify
its complete radius-`r` repair hypergraph at every coordinate with the corresponding inner-code
hypergraph under the outer functional-dual distance gate.

The outer analytic family remains an explicit hypothesis: this file proves the finite reduction
used at every block length and introduces no existence axiom.
-/

namespace RepairCodes

open Finset Matrix FiniteGeom
open scoped BigOperators

noncomputable section

variable {ι κ V 𝔽 : Type*}
variable [Fintype ι] [DecidableEq ι] [Fintype κ] [DecidableEq κ]
variable [Field 𝔽] [DecidableEq 𝔽]
variable [AddCommGroup V] [Module 𝔽 V] [DecidableEq V]

/-- Minimum nonzero Hamming weight for a linear code over an arbitrary finite-dimensional symbol
space.  This is the outer-symbol analogue of `FiniteGeom.minDist`. -/
def symbolMinDist (O : Submodule 𝔽 (ι → V)) : ℕ :=
  sInf {d | ∃ u ∈ O, u ≠ 0 ∧ hammingNorm u = d}

omit [DecidableEq ι] [DecidableEq 𝔽] in
/-- `symbolMinDist` lower-bounds every nonzero outer word. -/
theorem symbolMinDist_le_hammingNorm {O : Submodule 𝔽 (ι → V)} {u : ι → V}
    (hu : u ∈ O) (hu0 : u ≠ 0) : symbolMinDist O ≤ hammingNorm u :=
  Nat.sInf_le ⟨u, hu, hu0, rfl⟩

/-- Encode each outer symbol independently into its inner block. -/
def concatenationLinearMap (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) :
    (ι → V) →ₗ[𝔽] (ι × κ → 𝔽) where
  toFun u p := (e (u p.1) : κ → 𝔽) p.2
  map_add' u v := by ext p; simp
  map_smul' c u := by ext p; simp

/-- The ordinary concatenation of an outer code with an inner encoder. -/
def concatenatedCode (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) : Submodule 𝔽 (ι × κ → 𝔽) :=
  O.map (concatenationLinearMap I e)

/-- View a flat word as a family of inner-coordinate blocks. -/
def wordBlock (w : ι × κ → 𝔽) (j : ι) : κ → 𝔽 := fun x => w (j, x)

/-- Insert an inner word into one block and put zero in every other block. -/
def singleBlockWord (j : ι) (z : κ → 𝔽) : ι × κ → 𝔽 :=
  fun p => if p.1 = j then z p.2 else 0

/-- Embed inner coordinates as the coordinates of block `j`. -/
def blockEmbedding (j : ι) : κ ↪ ι × κ where
  toFun x := (j, x)
  inj' := fun _ _ h => congrArg Prod.snd h

omit [Fintype ι] [DecidableEq ι] [Fintype κ] [DecidableEq κ] [DecidableEq 𝔽]
  [DecidableEq V] in
@[simp] theorem concatenationLinearMap_apply
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) (u : ι → V) (p : ι × κ) :
    concatenationLinearMap I e u p = (e (u p.1) : κ → 𝔽) p.2 := rfl

omit [Fintype ι] [DecidableEq ι] [Fintype κ] [DecidableEq κ] [DecidableEq 𝔽]
  [DecidableEq V] in
@[simp] theorem wordBlock_concatenationLinearMap
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) (u : ι → V) (j : ι) :
    wordBlock (concatenationLinearMap I e u) j = (e (u j) : κ → 𝔽) := rfl

omit [Fintype ι] [Fintype κ] [DecidableEq κ] [DecidableEq 𝔽] in
@[simp] theorem wordBlock_singleBlockWord_same (j : ι) (z : κ → 𝔽) :
    wordBlock (singleBlockWord j z) j = z := by
  funext x
  simp [wordBlock, singleBlockWord]

omit [Fintype ι] [Fintype κ] [DecidableEq κ] [DecidableEq 𝔽] in
theorem wordBlock_singleBlockWord_of_ne {j l : ι} (hjl : l ≠ j) (z : κ → 𝔽) :
    wordBlock (singleBlockWord j z) l = 0 := by
  funext x
  simp [wordBlock, singleBlockWord, hjl]

omit [DecidableEq ι] [DecidableEq κ] in
/-- Flattening preserves the sum of the block Hamming weights exactly. -/
theorem hammingNorm_eq_sum_hammingNorm_wordBlock (w : ι × κ → 𝔽) :
    hammingNorm w = ∑ j, hammingNorm (wordBlock w j) := by
  classical
  simp only [hammingNorm, Finset.card_eq_sum_ones, Finset.sum_filter]
  change (∑ p ∈ (univ : Finset ι) ×ˢ (univ : Finset κ), if w p ≠ 0 then 1 else 0) =
    ∑ j ∈ (univ : Finset ι), ∑ x ∈ (univ : Finset κ),
      if w (j, x) ≠ 0 then 1 else 0
  exact Finset.sum_product (univ : Finset ι) (univ : Finset κ)
    (fun p => if w p ≠ 0 then 1 else 0)

omit [Fintype ι] [DecidableEq ι] [Fintype κ] [DecidableEq κ] [DecidableEq 𝔽]
  [DecidableEq V] in
/-- The concatenation encoder is injective because the inner encoder is an equivalence. -/
theorem concatenationLinearMap_injective
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) :
    Function.Injective (concatenationLinearMap (ι := ι) I e) := by
  intro u v huv
  funext j
  apply e.injective
  apply Subtype.ext
  funext x
  exact congrFun huv (j, x)

omit [Fintype ι] [DecidableEq ι] [Fintype κ] [DecidableEq κ] [DecidableEq 𝔽]
  [DecidableEq V] in
/-- Concatenation preserves the outer code's base-field dimension. -/
theorem concatenatedCode_finrank
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) :
    Module.finrank 𝔽 (concatenatedCode I e O) = Module.finrank 𝔽 O := by
  change Module.finrank 𝔽 (O.map (concatenationLinearMap I e)) = _
  rw [show O.map (concatenationLinearMap I e) =
      LinearMap.range ((concatenationLinearMap I e).comp O.subtype) by
    ext w
    simp]
  apply LinearMap.finrank_range_of_inj
  exact (concatenationLinearMap_injective I e).comp O.injective_subtype

omit [DecidableEq ι] [DecidableEq κ] in
/-- The usual multiplicative lower bound for concatenated-code distance. -/
theorem concatenatedCode_minDist_lower
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (hO : O ≠ ⊥) :
    minDist I * symbolMinDist O ≤ minDist (concatenatedCode I e O) := by
  have hconcat : concatenatedCode I e O ≠ ⊥ := by
    obtain ⟨u, huO, hu0⟩ := (Submodule.ne_bot_iff O).mp hO
    apply (Submodule.ne_bot_iff (concatenatedCode I e O)).mpr
    refine ⟨concatenationLinearMap I e u, Submodule.mem_map_of_mem huO, ?_⟩
    intro hz
    apply hu0
    apply concatenationLinearMap_injective I e
    simpa using hz
  apply le_minDist hconcat
  intro c hc hcz
  obtain ⟨u, huO, huc⟩ := Submodule.mem_map.mp hc
  have hu0 : u ≠ 0 := by
    intro hz
    subst u
    exact hcz (by simpa using huc.symm)
  have houter := symbolMinDist_le_hammingNorm huO hu0
  have hblock : ∀ j, u j ≠ 0 → minDist I ≤ hammingNorm (wordBlock c j) := by
    intro j huj
    have henc0 : (e (u j) : κ → 𝔽) ≠ 0 := by
      intro hz
      apply huj
      apply e.injective
      apply Subtype.ext
      simpa using hz
    have hblockEq : wordBlock c j = (e (u j) : κ → 𝔽) := by
      rw [← huc]
      rfl
    rw [hblockEq]
    exact minDist_le_hammingNorm (e (u j)).property henc0
  have hmul : minDist I * hammingNorm u ≤ ∑ j, hammingNorm (wordBlock c j) := by
    apply FiniteGeom.mul_card_filter_le_sum (fun j => hammingNorm (wordBlock c j))
      (fun j => u j ≠ 0) (minDist I)
    exact hblock
  calc
    minDist I * symbolMinDist O ≤ minDist I * hammingNorm u := Nat.mul_le_mul_left _ houter
    _ ≤ ∑ j, hammingNorm (wordBlock c j) := hmul
    _ = hammingNorm c := (hammingNorm_eq_sum_hammingNorm_wordBlock c).symm

omit [DecidableEq ι] [DecidableEq κ] [DecidableEq 𝔽] [DecidableEq V] in
/-- A flat dual word is orthogonal to the ordinary concatenation in block form. -/
theorem dualWord_isOrthogonalToConcatenation
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) {w : ι × κ → 𝔽}
    (hw : w ∈ dualCode (concatenatedCode I e O)) :
    IsOrthogonalToConcatenation I e O (wordBlock w) := by
  intro u hu
  have henc : concatenationLinearMap I e u ∈ concatenatedCode I e O :=
    Submodule.mem_map_of_mem hu
  have hdot := hw _ henc
  simpa only [dotProduct, Fintype.sum_prod_type, wordBlock, concatenationLinearMap_apply] using hdot

omit [DecidableEq ι] [DecidableEq κ] [DecidableEq V] in
/-- Under the two dual-distance gates, every bounded-weight concatenated dual word is an
inner-dual word supported in at most one block. -/
theorem concatenatedDualWord_transfer
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) {w : ι × κ → 𝔽} (dO s : ℕ)
    (hw : w ∈ dualCode (concatenatedCode I e O))
    (hdO : HasFunctionalDualDistanceAtLeast O dO)
    (hwt : hammingNorm w ≤ s) (hsO : s < dO) (hsI : s < 2 * dualDist I) :
    (∀ j, wordBlock w j ∈ dualCode I) ∧
      (univ.filter (fun j => wordBlock w j ≠ 0)).card ≤ 1 := by
  have horth := dualWord_isOrthogonalToConcatenation I e O hw
  have halt := blockFunctional_outerAlternative I e O (wordBlock w) dO horth hdO
  apply transfer_ofInnerCodeFunctional I e (wordBlock w) dO s halt
  · simpa only [← hammingNorm_eq_sum_hammingNorm_wordBlock] using hwt
  · exact hsO
  · exact hsI

omit [DecidableEq ι] [DecidableEq κ] in
/-- The support of a word confined to block `j` is the embedded support of that block. -/
theorem wordSupport_eq_map_wordSupport_wordBlock_of_single
    {w : ι × κ → 𝔽} {j : ι}
    (hsingle : ∀ l, wordBlock w l ≠ 0 → l = j) :
    wordSupport w = (wordSupport (wordBlock w j)).map (blockEmbedding j) := by
  ext p
  constructor
  · intro hp
    have hwp : w p ≠ 0 := mem_wordSupport.mp hp
    have hblock : wordBlock w p.1 ≠ 0 := by
      intro hz
      exact hwp (congrFun hz p.2)
    have hpj := hsingle p.1 hblock
    subst hpj
    simp only [Finset.mem_map]
    exact ⟨p.2, mem_wordSupport.mpr hwp, rfl⟩
  · intro hp
    obtain ⟨x, hx, hxp⟩ := Finset.mem_map.mp hp
    have hxne : wordBlock w j x ≠ 0 := (mem_wordSupport (ι := κ)).mp hx
    apply mem_wordSupport.mpr
    rw [← hxp]
    exact hxne

omit [DecidableEq κ] [DecidableEq 𝔽] [DecidableEq V] in
/-- Extending an inner-dual word by zero outside one block gives a dual word of every ordinary
concatenation using that inner code. -/
theorem singleBlockWord_mem_dualCode_concatenatedCode
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) {j : ι} {z : κ → 𝔽}
    (hz : z ∈ dualCode I) :
    singleBlockWord j z ∈ dualCode (concatenatedCode I e O) := by
  rw [mem_dualCode]
  intro c hc
  obtain ⟨u, hu, rfl⟩ := Submodule.mem_map.mp hc
  simp only [dotProduct, Fintype.sum_prod_type, concatenationLinearMap_apply]
  apply Finset.sum_eq_zero
  intro l _
  by_cases hlj : l = j
  · subst l
    simpa only [singleBlockWord, if_pos, dotProduct] using hz (e (u j)) (e (u j)).property
  · simp [singleBlockWord, hlj]

omit [DecidableEq κ] in
/-- A one-block extension has exactly the embedded inner support. -/
theorem wordSupport_singleBlockWord (j : ι) (z : κ → 𝔽) :
    wordSupport (singleBlockWord j z) = (wordSupport z).map (blockEmbedding j) := by
  rw [wordSupport_eq_map_wordSupport_wordBlock_of_single (j := j) (w := singleBlockWord j z) (by
    intro l hl
    by_contra hlj
    exact hl (wordBlock_singleBlockWord_of_ne hlj z)),
    wordBlock_singleBlockWord_same]

omit [DecidableEq V] in
/-- **Exact complete-repair transfer.** If `r+1 < 2d(I⊥)` and the outer functional dual distance
is at least `r+2`, then the complete radius-`r` repair hypergraph at a
coordinate of block `j` is exactly the embedded inner repair hypergraph.  Both directions are
proved from dual-word supports; no selected recovery groups are substituted for the complete
hypergraph. -/
theorem repairHypergraph_concatenatedCode_eq_embed
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (r : ℕ)
    (hsI : r + 1 < 2 * dualDist I)
    (hdO : HasFunctionalDualDistanceAtLeast O (r + 2))
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
    have htransfer := concatenatedDualWord_transfer I e O (r + 2) (r + 1)
      hwdual hdO hwt (by omega) hsI
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

omit [DecidableEq V] in
/-- Matching number is preserved coordinate-by-coordinate by the exact repair transfer. -/
theorem matchingNumber_repairHypergraph_concatenatedCode
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (r : ℕ)
    (hsI : r + 1 < 2 * dualDist I)
    (hdO : HasFunctionalDualDistanceAtLeast O (r + 2))
    (j : ι) (x : κ) :
    matchingNumber (repairHypergraph (concatenatedCode I e O) (j, x) r) =
      matchingNumber (repairHypergraph I x r) := by
  rw [repairHypergraph_concatenatedCode_eq_embed I e O r hsI hdO j x,
    matchingNumber_embedHypergraph]

omit [DecidableEq V] in
/-- Transversal number is preserved coordinate-by-coordinate by the exact repair transfer. -/
theorem transversalNumber_repairHypergraph_concatenatedCode
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (r : ℕ)
    (hsI : r + 1 < 2 * dualDist I)
    (hdO : HasFunctionalDualDistanceAtLeast O (r + 2))
    (j : ι) (x : κ)
    (hne : ∀ E ∈ repairHypergraph I x r, E.Nonempty) :
    transversalNumber (repairHypergraph (concatenatedCode I e O) (j, x) r) =
      transversalNumber (repairHypergraph I x r) := by
  rw [repairHypergraph_concatenatedCode_eq_embed I e O r hsI hdO j x]
  exact transversalNumber_embedHypergraph (blockEmbedding j) (repairHypergraph I x r) hne

end
end RepairCodes
