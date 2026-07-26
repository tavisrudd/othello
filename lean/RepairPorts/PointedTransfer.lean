import RepairPorts.FunctionalCost
import RepairPorts.CoefficientPort
import RepairCodes.WeightedStrictExample

/-!
# Exact pointed confinement and weighted transfer

A concatenated dual word determines one inner functional in each outer block.  The obstruction to
confinement in a distinguished block has three disjoint strata: every block functional is zero,
exactly one is nonzero, or at least two are nonzero.  The zero stratum consists of a pointed
inner-dual word in the target block and a nonzero inner-dual word in another block.  In the other
two strata, independent minimization in the functional fibers gives the exact cost.

The paper-facing theorems below collect the existing exact stratum formulas and identify their
minimum with the first nonembedded pointed witness.  If this cost is at least `r + 2`, every
pointed dual witness using at most `r` helpers is the zero-extension of an inner repair word, so
the complete radius-`r` support port transfers exactly.  No fiber enumerator or finite computation
occurs in these proofs.
-/

namespace RepairPorts

open Finset FiniteGeom RepairCodes

variable {ι κ V 𝔽 : Type*}
variable [Fintype ι] [DecidableEq ι] [Fintype κ] [DecidableEq κ]
variable [Field 𝔽] [DecidableEq 𝔽]
variable [AddCommGroup V] [Module 𝔽 V] [DecidableEq V]

/-- The paper's pointed zero-functional cost: one pointed inner-dual word at the target plus one
minimum nonzero inner-dual word in another block, with value `⊤` for a trivial inner dual. -/
noncomputable def pointedZeroFunctionalCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) (x : κ) : WithTop ℕ :=
  if dualCode I ≠ ⊥ then
    pointedFunctionalFiberCost I e x 0 + (dualDist I : WithTop ℕ)
  else ⊤

omit [DecidableEq κ] [DecidableEq V] in
/-- Once an off-target block exists, the general zero-sector closed form is exactly the
block-independent pointed zero-functional cost. -/
theorem zeroFunctionalPointedClosedCost_eq_pointedZeroFunctionalCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (j : ι) (x : κ) (hother : ∃ l, l ≠ j) :
    zeroFunctionalPointedClosedCost I e j x =
      pointedZeroFunctionalCost I e x := by
  simp [zeroFunctionalPointedClosedCost, pointedZeroFunctionalCost, hother]

omit [DecidableEq κ] [DecidableEq V] in
/-- Every pointed representative of the zero functional is a nonzero inner-dual word, so its
minimum cost is bounded below by the inner dual distance. -/
theorem dualDist_le_pointedFunctionalFiberCost_zero
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) (x : κ) :
    (dualDist I : WithTop ℕ) ≤ pointedFunctionalFiberCost I e x 0 := by
  by_cases hex : ∃ z, IsPointedFunctionalRepresentative I e x 0 z
  · obtain ⟨z, hz, hcost⟩ :=
      exists_pointedFunctionalFiberCost_realizer I e x 0 hex
    rw [← hcost]
    exact_mod_cast dualDist_le_hammingNorm
      ((blockFunctional_eq_zero_iff I e z).mp hz.1)
      (fun hz0 => hz.2 (congrFun hz0 x))
  · rw [(pointedFunctionalFiberCost_eq_top_iff I e x 0).2 hex]
    exact le_top

/-- The pointed zero-functional obstruction costs at least two inner dual distances whenever the
inner dual is nontrivial. -/
theorem two_mul_dualDist_le_pointedZeroFunctionalCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) (x : κ)
    (hdual : dualCode I ≠ ⊥) :
    ((2 * dualDist I : ℕ) : WithTop ℕ) ≤ pointedZeroFunctionalCost I e x := by
  have hpoint := dualDist_le_pointedFunctionalFiberCost_zero I e x
  rw [pointedZeroFunctionalCost, if_pos hdual, Nat.cast_mul]
  norm_num only [Nat.cast_ofNat]
  rw [two_mul]
  exact add_le_add hpoint le_rfl

omit [DecidableEq V] in
/-- Zero-extending a normalized inner coefficient witness produces the corresponding normalized
coefficient witness in every concatenation using that inner encoder. -/
theorem singleBlockWord_mem_coefficientPort
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) (r : ℕ)
    {z : κ → 𝔽} (hz : z ∈ coefficientPort I x r) :
    singleBlockWord j z ∈
      coefficientPort (concatenatedCode I e O) (j, x) r := by
  refine ⟨singleBlockWord_mem_dualCode_concatenatedCode I e O hz.1, ?_, ?_⟩
  · simpa [singleBlockWord] using hz.2.1
  · rw [wordSupport_singleBlockWord]
    change (((wordSupport z).map (blockEmbedding j)).erase
      (blockEmbedding j x)).card ≤ r
    rw [← Finset.map_erase, Finset.card_map]
    exact hz.2.2

/-- **Exact coefficient-port transfer.**  Under pointed confinement, zero-extension is a
bijection from the inner normalized coefficient port to the concatenated normalized coefficient
port at the selected block and coordinate. -/
theorem coefficientPort_concatenatedCode_eq_image_pointed
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) (r : ℕ)
    (hd : HasPointedNonembeddedDualDistanceAtLeast I e O j x (r + 2)) :
    coefficientPort (concatenatedCode I e O) (j, x) r =
      (fun z => singleBlockWord j z) '' coefficientPort I x r := by
  classical
  ext y
  constructor
  · intro hy
    have hyx : wordBlock y j x ≠ 0 := by
      change y (j, x) ≠ 0
      rw [hy.2.1]
      exact one_ne_zero
    have htarget : (j, x) ∈ wordSupport y :=
      mem_wordSupport.mpr (by simp [hy.2.1])
    have hweight : hammingNorm y ≤ r + 1 := by
      calc
        hammingNorm y = (wordSupport y).card := (card_wordSupport y).symm
        _ = ((wordSupport y).erase (j, x)).card + 1 :=
          (Finset.card_erase_add_one htarget).symm
        _ ≤ r + 1 := Nat.add_le_add_right hy.2.2 1
    have hsum : (∑ l, hammingNorm (wordBlock y l)) < r + 2 := by
      rw [← hammingNorm_eq_sum_hammingNorm_wordBlock]
      omega
    have hembedded : IsEmbeddedInnerDualBlockAt I j (wordBlock y) :=
      (hasPointedNonembeddedDualDistanceAtLeast_iff I e O j x (r + 2)).mp hd
        (wordBlock y) (by simpa [wordBlock] using hy.1) hyx hsum
    let z : κ → 𝔽 := wordBlock y j
    have hsingle : y = singleBlockWord j z := by
      funext p
      rcases p with ⟨l, a⟩
      by_cases hlj : l = j
      · subst l
        simp [z, wordBlock, singleBlockWord]
      · have hz : wordBlock y l a = 0 := by
          simpa only [Pi.zero_apply] using congrFun (hembedded.2 l hlj) a
        simpa [wordBlock, singleBlockWord, hlj] using hz
    have hzport : z ∈ coefficientPort I x r := by
      refine ⟨hembedded.1, ?_, ?_⟩
      · simpa [z, wordBlock] using hy.2.1
      · have hcard := hy.2.2
        rw [hsingle, wordSupport_singleBlockWord] at hcard
        change (((wordSupport z).map (blockEmbedding j)).erase
          (blockEmbedding j x)).card ≤ r at hcard
        rw [← Finset.map_erase, Finset.card_map] at hcard
        exact hcard
    change ∃ z ∈ coefficientPort I x r, singleBlockWord j z = y
    exact ⟨z, hzport, hsingle.symm⟩
  · change (∃ z ∈ coefficientPort I x r, singleBlockWord j z = y) →
      y ∈ coefficientPort (concatenatedCode I e O) (j, x) r
    rintro ⟨z, hz, rfl⟩
    exact singleBlockWord_mem_coefficientPort I e O j x r hz

/-- **Exact functional-stratum formulas.**  With at least two outer blocks and a nontrivial
inner dual, the zero-, singleton-, and multisupport-functional lower-bound profiles are exactly
their closed terms. -/
theorem exactFunctionalStrata
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (hcard : 2 ≤ Fintype.card ι)
    (hdual : dualCode I ≠ ⊥) (d : ℕ) :
    (HasZeroFunctionalMultiblockAtLeast I e O d ↔ d ≤ 2 * dualDist I) ∧
      (HasSingletonFunctionalMultiblockAtLeast I e O d ↔
        HasSingletonFunctionalTermAtLeast I e O d) ∧
      (HasMultisupportFunctionalMultiblockAtLeast I e O d ↔
        HasMultisupportFunctionalTermAtLeast I e O d) := by
  exact ⟨hasZeroFunctionalMultiblockAtLeast_iff_le_two_dualDist
      I e O hcard hdual d,
    hasSingletonFunctionalMultiblockAtLeast_iff_term I e O hcard hdual d,
    hasMultisupportFunctionalMultiblockAtLeast_iff_term I e O d⟩

/-- **Exact pointed confinement and transfer.**  The first pointed dual witness not confined to
the target block has the minimum of the zero-functional closed cost and the nonzero
functional-tuple cost.  A lower bound of `r + 2` on this exact obstruction gives literal equality
of the complete radius-`r` support ports. -/
theorem exactPointedConfinementAndTransfer
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) (r : ℕ) :
    pointedNonembeddedCost I e O j x =
        min (zeroFunctionalPointedClosedCost I e j x)
          (nonzeroOuterPointedFiberCost I e O j x) ∧
      (((r + 2 : ℕ) : WithTop ℕ) ≤ pointedNonembeddedCost I e O j x →
        repairHypergraph (concatenatedCode I e O) (j, x) r =
            embedHypergraph (blockEmbedding j) (repairHypergraph I x r) ∧
          coefficientPort (concatenatedCode I e O) (j, x) r =
            (fun z => singleBlockWord j z) '' coefficientPort I x r) := by
  refine ⟨pointedNonembeddedCost_eq_min_closed_nonzero I e O j x, ?_⟩
  intro hcost
  have hd := (hasPointedNonembeddedDualDistanceAtLeast_iff_le_pointedCost
    I e O j x (r + 2)).2 hcost
  exact ⟨repairHypergraph_concatenatedCode_eq_embed_pointed I e O r j x hd,
    coefficientPort_concatenatedCode_eq_image_pointed I e O j x r hd⟩

#print axioms RepairPorts.singleBlockWord_mem_coefficientPort
#print axioms RepairPorts.coefficientPort_concatenatedCode_eq_image_pointed
#print axioms RepairPorts.zeroFunctionalPointedClosedCost_eq_pointedZeroFunctionalCost
#print axioms RepairPorts.dualDist_le_pointedFunctionalFiberCost_zero
#print axioms RepairPorts.two_mul_dualDist_le_pointedZeroFunctionalCost
#print axioms RepairPorts.exactFunctionalStrata
#print axioms RepairPorts.exactPointedConfinementAndTransfer

end RepairPorts
