import RepairCodes.SeedLift

/-!
# Weighted functional-dual transfer

The ordinary transfer theorem lower-bounds a concatenated dual word by the number of nonzero
outer functionals.  This file records the sharper invariant: the actual Hamming weight of a block
representing each functional modulo the inner dual code.

`HasWeightedFunctionalDualDistanceAtLeast I e O d` is deliberately stated without choosing a
minimum representative.  Over a finite field it says exactly that every nonzero
`beta ∈ functionalDual O` has

`d ≤ ∑ j, min { hammingNorm w | blockFunctional I e w = beta j }`.

The quantifier form is also valid without a `Fintype` instance on the field and is the form needed
by the transfer proof.
-/

namespace RepairCodes

open Finset FiniteGeom

noncomputable section

variable {ι κ V 𝔽 : Type*}
variable [Fintype ι] [DecidableEq ι] [Fintype κ] [DecidableEq κ]
variable [Field 𝔽] [DecidableEq 𝔽]
variable [AddCommGroup V] [Module 𝔽 V] [DecidableEq V]

/-- Every realization of every nonzero outer functional-dual tuple has total inner Hamming
weight at least `d`.  This is the minimum-distance predicate for the functional dual equipped
with the inner coset-leader weight. -/
def HasWeightedFunctionalDualDistanceAtLeast
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ) : Prop :=
  ∀ beta, beta ∈ functionalDual O → beta ≠ 0 → ∀ w : ι → (κ → 𝔽),
    (∀ j, blockFunctional I e (w j) = beta j) →
      d ≤ ∑ j, hammingNorm (w j)

omit [DecidableEq ι] [DecidableEq κ] [DecidableEq V] in
/-- A weighted functional-dual gate decreases monotonically with its threshold. -/
theorem HasWeightedFunctionalDualDistanceAtLeast.mono
    {I : Submodule 𝔽 (κ → 𝔽)} {e : V ≃ₗ[𝔽] I}
    {O : Submodule 𝔽 (ι → V)} {d d' : ℕ}
    (h : HasWeightedFunctionalDualDistanceAtLeast I e O d) (hdd' : d' ≤ d) :
    HasWeightedFunctionalDualDistanceAtLeast I e O d' := by
  intro beta hbeta hbeta0 w hw
  exact hdd'.trans (h beta hbeta hbeta0 w hw)

omit [DecidableEq ι] [DecidableEq κ] [DecidableEq V] in
/-- The ordinary functional-support gate implies the weighted gate, since each block realizing a
nonzero functional is itself nonzero.  Thus the previous transfer theorem is a corollary of the
weighted theorem rather than a separate mechanism. -/
theorem hasWeightedFunctionalDualDistanceAtLeast_of_functionalDistance
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ)
    (h : HasFunctionalDualDistanceAtLeast O d) :
    HasWeightedFunctionalDualDistanceAtLeast I e O d := by
  classical
  intro beta hbeta hbeta0 w hw
  have hd := h beta hbeta hbeta0
  rw [functionalWeight] at hd
  apply hd.trans
  apply FiniteGeom.card_filter_le_sum (fun j => hammingNorm (w j))
    (fun j => beta j ≠ 0)
  intro j hj
  have hbj : beta j ≠ 0 := hj
  have hwj : w j ≠ 0 := by
    intro hw0
    apply hbj
    rw [← hw j, hw0]
    apply LinearMap.ext
    intro a
    simp [blockFunctional]
  have hnorm : hammingNorm (w j) ≠ 0 := fun hz => hwj (hammingNorm_eq_zero.mp hz)
  omega

omit [DecidableEq ι] [DecidableEq κ] [DecidableEq V] in
/-- Under the weighted outer gate and the unchanged zero-fiber gate, every bounded
concatenated dual word is supported in at most one inner block. -/
theorem concatenatedDualWord_transfer_weighted
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) {w : ι × κ → 𝔽} (d s : ℕ)
    (hw : w ∈ dualCode (concatenatedCode I e O))
    (hd : HasWeightedFunctionalDualDistanceAtLeast I e O d)
    (hwt : hammingNorm w ≤ s) (hsd : s < d) (hsI : s < 2 * dualDist I) :
    (∀ j, wordBlock w j ∈ dualCode I) ∧
      (univ.filter (fun j => wordBlock w j ≠ 0)).card ≤ 1 := by
  let beta : ι → Module.Dual 𝔽 V := fun j => blockFunctional I e (wordBlock w j)
  have horth := dualWord_isOrthogonalToConcatenation I e O hw
  have hbeta : beta ∈ functionalDual O :=
    blockFunctional_mem_functionalDual I e O (wordBlock w) horth
  have hbeta0 : beta = 0 := by
    by_contra hb0
    have hlower := hd beta hbeta hb0 (wordBlock w) (by intro j; rfl)
    have heq := hammingNorm_eq_sum_hammingNorm_wordBlock w
    omega
  have hzero : ∀ j, blockFunctional I e (wordBlock w j) = 0 := by
    intro j
    exact congrFun hbeta0 j
  apply transfer_ofInnerCodeFunctional I e (wordBlock w) (s + 1) s (Or.inl hzero)
  · simpa only [← hammingNorm_eq_sum_hammingNorm_wordBlock] using hwt
  · omega
  · exact hsI

omit [DecidableEq V] in
/-- **Weighted complete-repair transfer.**  The exact inner realization costs may certify bounded
block confinement even when the ordinary functional support distance is too small. -/
theorem repairHypergraph_concatenatedCode_eq_embed_weighted
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (r : ℕ)
    (hsI : r + 1 < 2 * dualDist I)
    (hd : HasWeightedFunctionalDualDistanceAtLeast I e O (r + 2))
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
    have htransfer := concatenatedDualWord_transfer_weighted I e O (r + 2) (r + 1)
      hwdual hd hwt (by omega) hsI
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

end
end RepairCodes

#print axioms RepairCodes.repairHypergraph_concatenatedCode_eq_embed_weighted
