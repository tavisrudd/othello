import RepairCodes.WeightedTransfer
import RepairCodes.WeightedTransferExact

/-!
# Functional-fiber costs for repair ports

This module packages the minimum Hamming cost of realizing an outer-symbol functional through a
fixed inner encoder.  The definition is coordinate-free and independent of a search procedure;
finite enumeration algorithms can later be proved correct against this API.
-/

namespace RepairPorts

open Finset FiniteGeom RepairCodes
open scoped BigOperators

noncomputable section

variable {ι κ V 𝔽 : Type*}
variable [Fintype ι] [DecidableEq ι] [Fintype κ] [DecidableEq κ]
variable [Field 𝔽] [DecidableEq 𝔽]
variable [AddCommGroup V] [Module 𝔽 V] [DecidableEq V]

/-- The minimum Hamming weight of an ambient block representing `beta` through the inner
encoder.  Surjectivity of `blockFunctional` makes the set of candidate weights nonempty. -/
def functionalFiberCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (beta : Module.Dual 𝔽 V) : ℕ :=
  sInf {n | ∃ w : κ → 𝔽,
    blockFunctional I e w = beta ∧ hammingNorm w = n}

omit [DecidableEq κ] [DecidableEq V] in
/-- Every representative of a functional has weight at least its functional-fiber cost. -/
theorem functionalFiberCost_le
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (beta : Module.Dual 𝔽 V) (w : κ → 𝔽)
    (hw : blockFunctional I e w = beta) :
    functionalFiberCost I e beta ≤ hammingNorm w := by
  change sInf {n | ∃ u : κ → 𝔽,
    blockFunctional I e u = beta ∧ hammingNorm u = n} ≤ hammingNorm w
  apply Nat.sInf_le
  exact ⟨w, hw, rfl⟩

/-- The functional-fiber cost is attained by an ambient block. -/
theorem exists_functionalFiberCost_realizer
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (beta : Module.Dual 𝔽 V) :
    ∃ w : κ → 𝔽,
      blockFunctional I e w = beta ∧ hammingNorm w = functionalFiberCost I e beta := by
  obtain ⟨w₀, hw₀⟩ := blockFunctional_surjective I e beta
  let weights : Set ℕ := {n | ∃ w : κ → 𝔽,
    blockFunctional I e w = beta ∧ hammingNorm w = n}
  have hnonempty : weights.Nonempty := ⟨hammingNorm w₀, w₀, hw₀, rfl⟩
  have hmem := Nat.sInf_mem hnonempty
  change ∃ w : κ → 𝔽,
    blockFunctional I e w = beta ∧ hammingNorm w = sInf weights at hmem
  simpa only [functionalFiberCost, weights] using hmem

/-- Total cost is the sum of the independent minimum costs of the coordinate functionals. -/
def functionalTupleCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (beta : ι → Module.Dual 𝔽 V) : ℕ :=
  ∑ j, functionalFiberCost I e (beta j)

omit [DecidableEq ι] in
/-- Coordinatewise minimum representatives simultaneously attain the tuple cost. -/
theorem exists_functionalTupleCost_realizer
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (beta : ι → Module.Dual 𝔽 V) :
    ∃ w : ι → (κ → 𝔽),
      (∀ j, blockFunctional I e (w j) = beta j) ∧
      (∑ j, hammingNorm (w j)) = functionalTupleCost I e beta := by
  classical
  choose w hw hcost using fun j => exists_functionalFiberCost_realizer I e (beta j)
  refine ⟨w, hw, ?_⟩
  simp only [functionalTupleCost]
  apply Finset.sum_congr rfl
  intro j _
  exact hcost j

omit [DecidableEq ι] [DecidableEq κ] [DecidableEq V] in
/-- Any simultaneous realization has total weight at least the tuple cost. -/
theorem functionalTupleCost_le
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (beta : ι → Module.Dual 𝔽 V) (w : ι → (κ → 𝔽))
    (hw : ∀ j, blockFunctional I e (w j) = beta j) :
    functionalTupleCost I e beta ≤ ∑ j, hammingNorm (w j) := by
  classical
  simp only [functionalTupleCost]
  apply Finset.sum_le_sum
  intro j _
  exact functionalFiberCost_le I e (beta j) (w j) (hw j)

omit [DecidableEq ι] in
/-- The existing weighted functional-dual lower-bound gate is exactly a lower bound on the
canonical tuple cost. -/
theorem hasWeightedFunctionalDualDistanceAtLeast_iff_functionalTupleCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (d : ℕ) :
    HasWeightedFunctionalDualDistanceAtLeast I e O d ↔
      ∀ beta, beta ∈ functionalDual O → beta ≠ 0 →
        d ≤ functionalTupleCost I e beta := by
  constructor
  · intro h beta hbeta hbeta0
    obtain ⟨w, hw, hcost⟩ := exists_functionalTupleCost_realizer I e beta
    have hlower := h beta hbeta hbeta0 w hw
    rwa [hcost] at hlower
  · intro h beta hbeta hbeta0 w hw
    exact (h beta hbeta hbeta0).trans (functionalTupleCost_le I e beta w hw)

section FiniteSearch

variable [Fintype 𝔽] [Fintype V]

/-- The finite set of ambient blocks representing `beta`.  The pointwise formulation makes the
membership test directly executable over finite `V` and `𝔽`. -/
def functionalFiberCandidates
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (beta : Module.Dual 𝔽 V) : Finset (κ → 𝔽) :=
  Finset.univ.filter fun w => ∀ v, blockFunctional I e w v = beta v

omit [DecidableEq V] in
/-- Membership in the candidate set is equality of the represented functional. -/
theorem mem_functionalFiberCandidates_iff
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (beta : Module.Dual 𝔽 V) (w : κ → 𝔽) :
    w ∈ functionalFiberCandidates I e beta ↔ blockFunctional I e w = beta := by
  simp only [functionalFiberCandidates, Finset.mem_filter, Finset.mem_univ, true_and]
  constructor
  · intro h
    ext v
    exact h v
  · intro h v
    exact LinearMap.congr_fun h v

theorem functionalFiberCandidates_nonempty
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (beta : Module.Dual 𝔽 V) :
    (functionalFiberCandidates I e beta).Nonempty := by
  obtain ⟨w, hw⟩ := blockFunctional_surjective I e beta
  exact ⟨w, (mem_functionalFiberCandidates_iff I e beta w).2 hw⟩

/-- Exhaustive finite-field search for the least Hamming weight in a functional fiber. -/
def functionalFiberCostSearch
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (beta : Module.Dual 𝔽 V) : ℕ :=
  let weights := (functionalFiberCandidates I e beta).image hammingNorm
  weights.min' (Finset.image_nonempty.mpr (functionalFiberCandidates_nonempty I e beta))

/-- The exhaustive finite-field search computes the canonical functional-fiber cost. -/
theorem functionalFiberCostSearch_eq
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (beta : Module.Dual 𝔽 V) :
    functionalFiberCostSearch I e beta = functionalFiberCost I e beta := by
  apply le_antisymm
  · obtain ⟨w, hw, hcost⟩ := exists_functionalFiberCost_realizer I e beta
    apply Finset.min'_le
    apply Finset.mem_image.mpr
    exact ⟨w, (mem_functionalFiberCandidates_iff I e beta w).2 hw, hcost⟩
  · have hmem := Finset.min'_mem
      ((functionalFiberCandidates I e beta).image hammingNorm)
      (Finset.image_nonempty.mpr (functionalFiberCandidates_nonempty I e beta))
    obtain ⟨w, hw, hnorm⟩ := Finset.mem_image.mp hmem
    change functionalFiberCost I e beta ≤
      ((functionalFiberCandidates I e beta).image hammingNorm).min' _
    rw [← hnorm]
    exact functionalFiberCost_le I e beta w
      ((mem_functionalFiberCandidates_iff I e beta w).1 hw)

end FiniteSearch

/-- An ambient block represents `beta` and is nonzero at the distinguished inner coordinate. -/
def IsPointedFunctionalRepresentative
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) (x : κ)
    (beta : Module.Dual 𝔽 V) (w : κ → 𝔽) : Prop :=
  blockFunctional I e w = beta ∧ w x ≠ 0

/-- Minimum cost of representing `beta` nontrivially at `x`.  The value is `⊤` when the
constrained functional fiber is empty. -/
def pointedFunctionalFiberCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) (x : κ)
    (beta : Module.Dual 𝔽 V) : WithTop ℕ := by
  classical
  exact if ∃ w, IsPointedFunctionalRepresentative I e x beta w then
      ((sInf {n | ∃ w, IsPointedFunctionalRepresentative I e x beta w ∧
        hammingNorm w = n} : ℕ) : WithTop ℕ)
    else ⊤

omit [DecidableEq κ] [DecidableEq V] in
/-- A constrained fiber has infinite cost exactly when it is empty. -/
theorem pointedFunctionalFiberCost_eq_top_iff
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) (x : κ)
    (beta : Module.Dual 𝔽 V) :
    pointedFunctionalFiberCost I e x beta = ⊤ ↔
      ¬ ∃ w, IsPointedFunctionalRepresentative I e x beta w := by
  classical
  simp [pointedFunctionalFiberCost]

omit [DecidableEq κ] [DecidableEq V] in
/-- Every constrained representative is bounded below by the pointed fiber cost. -/
theorem pointedFunctionalFiberCost_le
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) (x : κ)
    (beta : Module.Dual 𝔽 V) (w : κ → 𝔽)
    (hw : IsPointedFunctionalRepresentative I e x beta w) :
    pointedFunctionalFiberCost I e x beta ≤ (hammingNorm w : WithTop ℕ) := by
  classical
  have hex : ∃ u, IsPointedFunctionalRepresentative I e x beta u := ⟨w, hw⟩
  simp only [pointedFunctionalFiberCost, if_pos hex]
  exact WithTop.coe_le_coe.mpr (Nat.sInf_le ⟨w, hw, rfl⟩)

omit [DecidableEq κ] [DecidableEq V] in
/-- A nonempty constrained fiber has a representative attaining its pointed cost. -/
theorem exists_pointedFunctionalFiberCost_realizer
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) (x : κ)
    (beta : Module.Dual 𝔽 V)
    (hex : ∃ w, IsPointedFunctionalRepresentative I e x beta w) :
    ∃ w, IsPointedFunctionalRepresentative I e x beta w ∧
      (hammingNorm w : WithTop ℕ) = pointedFunctionalFiberCost I e x beta := by
  let weights : Set ℕ := {n | ∃ w, IsPointedFunctionalRepresentative I e x beta w ∧
    hammingNorm w = n}
  obtain ⟨w₀, hw₀⟩ := hex
  have hnonempty : weights.Nonempty := ⟨hammingNorm w₀, w₀, hw₀, rfl⟩
  have hmem := Nat.sInf_mem hnonempty
  change ∃ w, IsPointedFunctionalRepresentative I e x beta w ∧
    hammingNorm w = sInf weights at hmem
  obtain ⟨w, hw, hnorm⟩ := hmem
  refine ⟨w, hw, ?_⟩
  have hexw : ∃ u, IsPointedFunctionalRepresentative I e x beta u := ⟨w, hw⟩
  simp only [pointedFunctionalFiberCost, if_pos hexw]
  exact_mod_cast hnorm

/-- Fiberwise cost of a functional tuple constrained to be nonzero at `(j,x)`: one pointed
fiber cost plus the ordinary minimum costs of all other blocks. -/
def pointedFunctionalTupleCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (j : ι) (x : κ) (beta : ι → Module.Dual 𝔽 V) : WithTop ℕ :=
  pointedFunctionalFiberCost I e x (beta j) +
    ((∑ l ∈ Finset.univ.erase j, functionalFiberCost I e (beta l) : ℕ) : WithTop ℕ)

omit [DecidableEq κ] [DecidableEq V] in
/-- Every pointed simultaneous realization is bounded below by the fiberwise tuple formula. -/
theorem pointedFunctionalTupleCost_le
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (j : ι) (x : κ) (beta : ι → Module.Dual 𝔽 V)
    (w : ι → (κ → 𝔽))
    (hw : ∀ l, blockFunctional I e (w l) = beta l) (hwx : w j x ≠ 0) :
    pointedFunctionalTupleCost I e j x beta ≤
      ((∑ l, hammingNorm (w l) : ℕ) : WithTop ℕ) := by
  classical
  have hj := pointedFunctionalFiberCost_le I e x (beta j) (w j) ⟨hw j, hwx⟩
  have herase : (∑ l ∈ Finset.univ.erase j, functionalFiberCost I e (beta l)) ≤
      ∑ l ∈ Finset.univ.erase j, hammingNorm (w l) := by
    apply Finset.sum_le_sum
    intro l _
    exact functionalFiberCost_le I e (beta l) (w l) (hw l)
  have hsum : (∑ l, hammingNorm (w l)) =
      hammingNorm (w j) + ∑ l ∈ Finset.univ.erase j, hammingNorm (w l) := by
    rw [add_comm]
    exact (Finset.sum_erase_add _ _ (Finset.mem_univ j)).symm
  rw [pointedFunctionalTupleCost, hsum]
  exact add_le_add hj (WithTop.coe_le_coe.mpr herase)

/-- When the distinguished functional fiber is nonempty, the fiberwise tuple cost is attained. -/
theorem exists_pointedFunctionalTupleCost_realizer
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (j : ι) (x : κ) (beta : ι → Module.Dual 𝔽 V)
    (hex : ∃ z, IsPointedFunctionalRepresentative I e x (beta j) z) :
    ∃ w : ι → (κ → 𝔽),
      (∀ l, blockFunctional I e (w l) = beta l) ∧ w j x ≠ 0 ∧
      ((∑ l, hammingNorm (w l) : ℕ) : WithTop ℕ) =
        pointedFunctionalTupleCost I e j x beta := by
  classical
  obtain ⟨z, hz, hzcost⟩ := exists_pointedFunctionalFiberCost_realizer I e x (beta j) hex
  choose u hu hucost using fun l => exists_functionalFiberCost_realizer I e (beta l)
  let w : ι → (κ → 𝔽) := fun l => if l = j then z else u l
  have hw : ∀ l, blockFunctional I e (w l) = beta l := by
    intro l
    by_cases hlj : l = j
    · subst l
      simpa [w] using hz.1
    · simp [w, hlj, hu l]
  have hwx : w j x ≠ 0 := by simpa [w] using hz.2
  refine ⟨w, hw, hwx, ?_⟩
  have herase : (∑ l ∈ Finset.univ.erase j, hammingNorm (w l)) =
      ∑ l ∈ Finset.univ.erase j, functionalFiberCost I e (beta l) := by
    apply Finset.sum_congr rfl
    intro l hl
    have hlj : l ≠ j := (Finset.mem_erase.mp hl).1
    simp [w, hlj, hucost l]
  have hsum : (∑ l, hammingNorm (w l)) =
      hammingNorm z + ∑ l ∈ Finset.univ.erase j, functionalFiberCost I e (beta l) := by
    calc
      (∑ l, hammingNorm (w l)) =
          (∑ l ∈ Finset.univ.erase j, hammingNorm (w l)) + hammingNorm (w j) :=
        (Finset.sum_erase_add _ _ (Finset.mem_univ j)).symm
      _ = (∑ l ∈ Finset.univ.erase j, functionalFiberCost I e (beta l)) +
          hammingNorm z := by rw [herase]; simp [w]
      _ = hammingNorm z +
          ∑ l ∈ Finset.univ.erase j, functionalFiberCost I e (beta l) := by omega
  rw [hsum, pointedFunctionalTupleCost, Nat.cast_add, hzcost]

/-- The direct infimum over pointed realizations of a fixed functional tuple. -/
def pointedFunctionalTupleRealizationCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (j : ι) (x : κ) (beta : ι → Module.Dual 𝔽 V) : WithTop ℕ :=
  sInf {n | ∃ w : ι → (κ → 𝔽),
    (∀ l, blockFunctional I e (w l) = beta l) ∧ w j x ≠ 0 ∧
      ((∑ l, hammingNorm (w l) : ℕ) : WithTop ℕ) = n}

/-- **Fiberwise pointed formula.**  The minimum pointed realization cost of a functional tuple is
the constrained target-fiber cost plus the ordinary minimum costs of all other fibers. -/
theorem pointedFunctionalTupleRealizationCost_eq
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (j : ι) (x : κ) (beta : ι → Module.Dual 𝔽 V) :
    pointedFunctionalTupleRealizationCost I e j x beta =
      pointedFunctionalTupleCost I e j x beta := by
  apply le_antisymm
  · by_cases hex : ∃ z, IsPointedFunctionalRepresentative I e x (beta j) z
    · obtain ⟨w, hw, hwx, hcost⟩ :=
        exists_pointedFunctionalTupleCost_realizer I e j x beta hex
      apply sInf_le
      exact ⟨w, hw, hwx, hcost⟩
    · have hpoint : pointedFunctionalFiberCost I e x (beta j) = ⊤ :=
        (pointedFunctionalFiberCost_eq_top_iff I e x (beta j)).2 hex
      have htuple : pointedFunctionalTupleCost I e j x beta = ⊤ := by
        simp [pointedFunctionalTupleCost, hpoint]
      simp [pointedFunctionalTupleRealizationCost, htuple]
  · apply le_sInf
    intro n hn
    obtain ⟨w, hw, hwx, rfl⟩ := hn
    exact pointedFunctionalTupleCost_le I e j x beta w hw hwx

/-- Minimum pointed realization cost over nonzero outer functional-dual tuples. -/
def nonzeroOuterPointedRealizationCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) : WithTop ℕ :=
  sInf {n | ∃ beta, beta ∈ functionalDual O ∧ beta ≠ 0 ∧
    pointedFunctionalTupleRealizationCost I e j x beta = n}

/-- The fiberwise version of the nonzero outer pointed cost. -/
def nonzeroOuterPointedFiberCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) : WithTop ℕ :=
  sInf {n | ∃ beta, beta ∈ functionalDual O ∧ beta ≠ 0 ∧
    pointedFunctionalTupleCost I e j x beta = n}

/-- The entire nonzero outer-functional pointed obstruction is computed fiberwise. -/
theorem nonzeroOuterPointedRealizationCost_eq_fiberCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) :
    nonzeroOuterPointedRealizationCost I e O j x =
      nonzeroOuterPointedFiberCost I e O j x := by
  apply congrArg sInf
  ext n
  constructor
  · rintro ⟨beta, hbeta, hbeta0, hcost⟩
    exact ⟨beta, hbeta, hbeta0,
      (pointedFunctionalTupleRealizationCost_eq I e j x beta).symm.trans hcost⟩
  · rintro ⟨beta, hbeta, hbeta0, hcost⟩
    exact ⟨beta, hbeta, hbeta0,
      (pointedFunctionalTupleRealizationCost_eq I e j x beta).trans hcost⟩

omit [DecidableEq ι] [DecidableEq κ] [DecidableEq 𝔽] [DecidableEq V] in
/-- A flattened concatenated-dual word induces an outer functional-dual tuple. -/
theorem blockFunctionalTuple_mem_functionalDual_of_flatten_mem
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (w : ι → (κ → 𝔽))
    (hwdual : (fun p => w p.1 p.2) ∈ dualCode (concatenatedCode I e O)) :
    (fun l => blockFunctional I e (w l)) ∈ functionalDual O := by
  have horth := dualWord_isOrthogonalToConcatenation I e O hwdual
  have hwblock : wordBlock (fun p => w p.1 p.2) = w := by
    funext l y
    rfl
  rw [hwblock] at horth
  exact blockFunctional_mem_functionalDual I e O w horth

omit [Fintype ι] [DecidableEq κ] [DecidableEq 𝔽] [DecidableEq V] in
/-- A realization of a nonzero functional tuple cannot be an embedded inner-dual word at the
distinguished block. -/
theorem not_isEmbeddedInnerDualBlockAt_of_functionalTuple_ne_zero
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (j : ι) (beta : ι → Module.Dual 𝔽 V) (hbeta0 : beta ≠ 0)
    (w : ι → (κ → 𝔽)) (hw : ∀ l, blockFunctional I e (w l) = beta l) :
    ¬ IsEmbeddedInnerDualBlockAt I j w := by
  rintro ⟨hjdual, hother⟩
  apply hbeta0
  funext l
  change beta l = 0
  by_cases hlj : l = j
  · subst l
    rw [← hw j, blockFunctional_eq_zero_iff I e]
    exact hjdual
  · rw [← hw l, hother l hlj]
    apply LinearMap.ext
    intro v
    simp [blockFunctional]

/-- A nonembedded concatenated-dual witness through the pointed coordinate `(j,x)`. -/
def IsPointedNonembeddedWitness
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ)
    (w : ι → (κ → 𝔽)) : Prop :=
  (fun p => w p.1 p.2) ∈ dualCode (concatenatedCode I e O) ∧
    w j x ≠ 0 ∧ ¬ IsEmbeddedInnerDualBlockAt I j w

/-- The exact pointed obstruction cost.  Empty constrained witness sets have cost `⊤`, not
natural-number cost zero. -/
def pointedNonembeddedCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) : WithTop ℕ :=
  sInf {n | ∃ w : ι → (κ → 𝔽),
    IsPointedNonembeddedWitness I e O j x w ∧
      ((∑ l, hammingNorm (w l) : ℕ) : WithTop ℕ) = n}

/-- The zero-functional pointed obstruction sector.  The nonembedded condition explicitly removes
the one-block inner-dual word at the target. -/
def zeroFunctionalPointedNonembeddedCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) : WithTop ℕ :=
  sInf {n | ∃ w : ι → (κ → 𝔽),
    IsPointedNonembeddedWitness I e O j x w ∧
      (fun l => blockFunctional I e (w l)) = 0 ∧
      ((∑ l, hammingNorm (w l) : ℕ) : WithTop ℕ) = n}

/-- Closed-form candidate for the zero-functional sector.  A second block and a nontrivial inner
dual are necessary; the pointed target-fiber cost itself records whether the target constraint is
attainable. -/
def zeroFunctionalPointedClosedCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) (j : ι) (x : κ) : WithTop ℕ := by
  classical
  exact if (∃ l, l ≠ j) ∧ dualCode I ≠ ⊥ then
      pointedFunctionalFiberCost I e x 0 + (dualDist I : WithTop ℕ)
    else ⊤

omit [DecidableEq ι] [DecidableEq κ] [DecidableEq V] in
/-- The zero-functional sector is infinite exactly when it has no pointed nonembedded witness. -/
theorem zeroFunctionalPointedNonembeddedCost_eq_top_iff
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) :
    zeroFunctionalPointedNonembeddedCost I e O j x = ⊤ ↔
      ¬ ∃ w, IsPointedNonembeddedWitness I e O j x w ∧
        (fun l => blockFunctional I e (w l)) = 0 := by
  constructor
  · intro htop ⟨w, hw, hzero⟩
    have hle : zeroFunctionalPointedNonembeddedCost I e O j x ≤
        ((∑ l, hammingNorm (w l) : ℕ) : WithTop ℕ) := by
      apply sInf_le
      exact ⟨w, hw, hzero, rfl⟩
    rw [htop] at hle
    simp at hle
  · intro hempty
    have hset : {n | ∃ w : ι → (κ → 𝔽),
        IsPointedNonembeddedWitness I e O j x w ∧
          (fun l => blockFunctional I e (w l)) = 0 ∧
          ((∑ l, hammingNorm (w l) : ℕ) : WithTop ℕ) = n} = ∅ := by
      ext n
      simp only [Set.mem_setOf_eq, Set.mem_empty_iff_false, iff_false]
      rintro ⟨w, hw, hzero, -⟩
      exact hempty ⟨w, hw, hzero⟩
    simp only [zeroFunctionalPointedNonembeddedCost, hset, WithTop.sInf_empty]

/-- **Zero-sector closed form.**  The exact pointed zero-functional obstruction is the pointed
target inner-dual cost plus one minimum nonzero off-target inner-dual word, with `⊤` in every
impossible edge case. -/
theorem zeroFunctionalPointedNonembeddedCost_eq_closed
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) :
    zeroFunctionalPointedNonembeddedCost I e O j x =
      zeroFunctionalPointedClosedCost I e j x := by
  classical
  by_cases hother : ∃ l, l ≠ j
  · by_cases hdual : dualCode I ≠ ⊥
    · by_cases hpoint : ∃ z, IsPointedFunctionalRepresentative I e x 0 z
      · have hclosed : zeroFunctionalPointedClosedCost I e j x =
            pointedFunctionalFiberCost I e x 0 + (dualDist I : WithTop ℕ) := by
          simp [zeroFunctionalPointedClosedCost, hother, hdual]
        rw [hclosed]
        apply le_antisymm
        · obtain ⟨l, hlj⟩ := hother
          obtain ⟨z, hz, hzcost⟩ :=
            exists_pointedFunctionalFiberCost_realizer I e x 0 hpoint
          obtain ⟨u, hudual, hu0, hunorm⟩ :=
            exists_dualWord_hammingNorm_eq_dualDist I hdual
          let w : ι → (κ → 𝔽) := fun a => if a = j then z else if a = l then u else 0
          have hzero : (fun a => blockFunctional I e (w a)) = 0 := by
            funext a
            change blockFunctional I e (w a) = 0
            by_cases haj : a = j
            · subst a
              simpa [w] using hz.1
            · by_cases hal : a = l
              · subst a
                simp only [w, hlj, ↓reduceIte]
                rw [blockFunctional_eq_zero_iff I e]
                exact hudual
              · simp only [w, haj, hal, if_false]
                apply LinearMap.ext
                intro v
                simp [blockFunctional]
          have hwdual : (fun p => w p.1 p.2) ∈ dualCode (concatenatedCode I e O) := by
            apply flatten_mem_dualCode_concatenatedCode_of_functionalDual I e O w
            rw [hzero]
            exact Submodule.zero_mem _
          have hwx : w j x ≠ 0 := by simpa [w] using hz.2
          have hnembedded : ¬ IsEmbeddedInnerDualBlockAt I j w := by
            intro hembedded
            apply hu0
            simpa [w, hlj] using hembedded.2 l hlj
          have herase : (∑ a ∈ Finset.univ.erase j, hammingNorm (w a)) =
              hammingNorm u := by
            calc
              (∑ a ∈ Finset.univ.erase j, hammingNorm (w a)) = hammingNorm (w l) := by
                apply Finset.sum_eq_single l
                · intro a ha hal
                  have haj : a ≠ j := (Finset.mem_erase.mp ha).1
                  simp [w, haj, hal]
                · intro hl
                  exact (hl (Finset.mem_erase.mpr ⟨hlj, Finset.mem_univ l⟩)).elim
              _ = hammingNorm u := by simp [w, hlj]
          have hsum : (∑ a, hammingNorm (w a)) = hammingNorm z + hammingNorm u := by
            calc
              (∑ a, hammingNorm (w a)) =
                  (∑ a ∈ Finset.univ.erase j, hammingNorm (w a)) + hammingNorm (w j) :=
                (Finset.sum_erase_add _ _ (Finset.mem_univ j)).symm
              _ = hammingNorm u + hammingNorm z := by rw [herase]; simp [w]
              _ = hammingNorm z + hammingNorm u := by omega
          apply sInf_le
          refine ⟨w, ⟨hwdual, hwx, hnembedded⟩, hzero, ?_⟩
          rw [hsum, Nat.cast_add, hunorm, hzcost]
        · apply le_sInf
          intro n hn
          obtain ⟨w, ⟨-, hwx, hnembedded⟩, hzero, rfl⟩ := hn
          have hjzero : blockFunctional I e (w j) = 0 := by
            exact congrFun hzero j
          have hjdual : w j ∈ dualCode I :=
            (blockFunctional_eq_zero_iff I e (w j)).mp hjzero
          have htarget := pointedFunctionalFiberCost_le I e x 0 (w j) ⟨hjzero, hwx⟩
          obtain ⟨l, hlj, hwl0⟩ : ∃ l, l ≠ j ∧ w l ≠ 0 := by
            by_contra hnone
            push Not at hnone
            exact hnembedded ⟨hjdual, hnone⟩
          have hlzero : blockFunctional I e (w l) = 0 := congrFun hzero l
          have hldual : w l ∈ dualCode I :=
            (blockFunctional_eq_zero_iff I e (w l)).mp hlzero
          have hldist := dualDist_le_hammingNorm hldual hwl0
          have hpair : hammingNorm (w j) + hammingNorm (w l) ≤
              ∑ a, hammingNorm (w a) := by
            have hsub : ({j, l} : Finset ι) ⊆ Finset.univ := by simp
            have hp := Finset.sum_le_sum_of_subset hsub
              (f := fun a => hammingNorm (w a))
            simpa [hlj, Ne.symm hlj, add_comm] using hp
          exact (add_le_add htarget (WithTop.coe_le_coe.mpr hldist)).trans
            (WithTop.coe_le_coe.mpr hpair)
      · have hzeroTop : zeroFunctionalPointedNonembeddedCost I e O j x = ⊤ :=
          (zeroFunctionalPointedNonembeddedCost_eq_top_iff I e O j x).2 (by
            rintro ⟨w, ⟨-, hwx, -⟩, hzero⟩
            apply hpoint
            exact ⟨w j, congrFun hzero j, hwx⟩)
        have hpointTop : pointedFunctionalFiberCost I e x 0 = ⊤ :=
          (pointedFunctionalFiberCost_eq_top_iff I e x 0).2 hpoint
        simp [zeroFunctionalPointedClosedCost, hother, hdual, hzeroTop, hpointTop]
    · have hzeroTop : zeroFunctionalPointedNonembeddedCost I e O j x = ⊤ :=
        (zeroFunctionalPointedNonembeddedCost_eq_top_iff I e O j x).2 (by
          rintro ⟨w, ⟨-, hwx, -⟩, hzero⟩
          have hjdual : w j ∈ dualCode I :=
            (blockFunctional_eq_zero_iff I e (w j)).mp (congrFun hzero j)
          rw [not_ne_iff.mp hdual] at hjdual
          have hwj0 : w j = 0 := by simpa using hjdual
          exact hwx (congrFun hwj0 x))
      simp [zeroFunctionalPointedClosedCost, hother, hdual, hzeroTop]
  · have hzeroTop : zeroFunctionalPointedNonembeddedCost I e O j x = ⊤ :=
      (zeroFunctionalPointedNonembeddedCost_eq_top_iff I e O j x).2 (by
        rintro ⟨w, ⟨-, -, hnembedded⟩, hzero⟩
        apply hnembedded
        refine ⟨(blockFunctional_eq_zero_iff I e (w j)).mp (congrFun hzero j), ?_⟩
        intro l hlj
        exact (hother ⟨l, hlj⟩).elim)
    simp [zeroFunctionalPointedClosedCost, hother, hzeroTop]

/-- **Exact pointed first-obstruction split.**  The full pointed nonembedded cost is the minimum
of the exceptional zero-functional sector and the fiberwise nonzero outer-functional sector. -/
theorem pointedNonembeddedCost_eq_min_zero_nonzero
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) :
    pointedNonembeddedCost I e O j x =
      min (zeroFunctionalPointedNonembeddedCost I e O j x)
        (nonzeroOuterPointedFiberCost I e O j x) := by
  apply le_antisymm
  · apply le_min
    · apply le_sInf
      intro n hn
      obtain ⟨w, hw, -, rfl⟩ := hn
      apply sInf_le
      exact ⟨w, hw, rfl⟩
    · apply le_sInf
      intro n hn
      obtain ⟨beta, hbeta, hbeta0, rfl⟩ := hn
      by_cases hex : ∃ z, IsPointedFunctionalRepresentative I e x (beta j) z
      · obtain ⟨w, hw, hwx, hcost⟩ :=
          exists_pointedFunctionalTupleCost_realizer I e j x beta hex
        have hwfun : (fun l => blockFunctional I e (w l)) = beta := funext hw
        have hwdual := flatten_mem_dualCode_concatenatedCode_of_functionalDual I e O w (by
          rw [hwfun]
          exact hbeta)
        have hnembedded :=
          not_isEmbeddedInnerDualBlockAt_of_functionalTuple_ne_zero I e j beta hbeta0 w hw
        rw [← hcost]
        apply sInf_le
        exact ⟨w, ⟨hwdual, hwx, hnembedded⟩, rfl⟩
      · have hpoint : pointedFunctionalFiberCost I e x (beta j) = ⊤ :=
          (pointedFunctionalFiberCost_eq_top_iff I e x (beta j)).2 hex
        simp [pointedFunctionalTupleCost, hpoint]
  · apply le_sInf
    intro n hn
    obtain ⟨w, ⟨hwdual, hwx, hnembedded⟩, rfl⟩ := hn
    let beta : ι → Module.Dual 𝔽 V := fun l => blockFunctional I e (w l)
    have hbeta : beta ∈ functionalDual O :=
      blockFunctionalTuple_mem_functionalDual_of_flatten_mem I e O w hwdual
    by_cases hbeta0 : beta = 0
    · calc
        min (zeroFunctionalPointedNonembeddedCost I e O j x)
            (nonzeroOuterPointedFiberCost I e O j x) ≤
            zeroFunctionalPointedNonembeddedCost I e O j x := min_le_left _ _
        _ ≤ ((∑ l, hammingNorm (w l) : ℕ) : WithTop ℕ) := by
          apply sInf_le
          exact ⟨w, ⟨hwdual, hwx, hnembedded⟩, hbeta0, rfl⟩
    · calc
        min (zeroFunctionalPointedNonembeddedCost I e O j x)
            (nonzeroOuterPointedFiberCost I e O j x) ≤
            nonzeroOuterPointedFiberCost I e O j x := min_le_right _ _
        _ ≤ pointedFunctionalTupleCost I e j x beta := by
          apply sInf_le
          exact ⟨beta, hbeta, hbeta0, rfl⟩
        _ ≤ ((∑ l, hammingNorm (w l) : ℕ) : WithTop ℕ) := by
          apply pointedFunctionalTupleCost_le I e j x beta w
          · intro l
            rfl
          · exact hwx

/-- The full pointed obstruction with both sectors in closed fiberwise form. -/
theorem pointedNonembeddedCost_eq_min_closed_nonzero
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) :
    pointedNonembeddedCost I e O j x =
      min (zeroFunctionalPointedClosedCost I e j x)
        (nonzeroOuterPointedFiberCost I e O j x) := by
  rw [pointedNonembeddedCost_eq_min_zero_nonzero,
    zeroFunctionalPointedNonembeddedCost_eq_closed]

omit [DecidableEq ι] [DecidableEq κ] [DecidableEq V] in
/-- The pointed cost is infinite exactly when there is no constrained nonembedded witness. -/
theorem pointedNonembeddedCost_eq_top_iff
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) :
    pointedNonembeddedCost I e O j x = ⊤ ↔
      ¬ ∃ w, IsPointedNonembeddedWitness I e O j x w := by
  constructor
  · intro htop ⟨w, hw⟩
    have hle : pointedNonembeddedCost I e O j x ≤
        ((∑ l, hammingNorm (w l) : ℕ) : WithTop ℕ) := by
      apply sInf_le
      exact ⟨w, hw, rfl⟩
    rw [htop] at hle
    simp at hle
  · intro hempty
    have hset : {n | ∃ w : ι → (κ → 𝔽),
        IsPointedNonembeddedWitness I e O j x w ∧
          ((∑ l, hammingNorm (w l) : ℕ) : WithTop ℕ) = n} = ∅ := by
      ext n
      simp only [Set.mem_setOf_eq, Set.mem_empty_iff_false, iff_false]
      rintro ⟨w, hw, -⟩
      exact hempty ⟨w, hw⟩
    simp only [pointedNonembeddedCost, hset, WithTop.sInf_empty]

omit [DecidableEq ι] [DecidableEq κ] [DecidableEq V] in
/-- The existing pointed lower-bound predicate is comparison with the exact infinity-valued
pointed obstruction cost. -/
theorem hasPointedNonembeddedDualDistanceAtLeast_iff_le_pointedCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) (d : ℕ) :
    HasPointedNonembeddedDualDistanceAtLeast I e O j x d ↔
      (d : WithTop ℕ) ≤ pointedNonembeddedCost I e O j x := by
  constructor
  · intro h
    apply le_sInf
    intro n hn
    obtain ⟨w, ⟨hwdual, hwx, hnembedded⟩, rfl⟩ := hn
    exact_mod_cast h w hwdual hwx hnembedded
  · intro h w hwdual hwx hnembedded
    have hcost : pointedNonembeddedCost I e O j x ≤
        ((∑ l, hammingNorm (w l) : ℕ) : WithTop ℕ) := by
      apply sInf_le
      exact ⟨w, ⟨hwdual, hwx, hnembedded⟩, rfl⟩
    exact_mod_cast h.trans hcost

section PointedFiniteSearch

variable [Fintype 𝔽]

/-- The finite set of all constrained nonembedded witnesses through `(j,x)`. -/
def pointedNonembeddedCandidates
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) :
    Finset (ι → (κ → 𝔽)) := by
  classical
  exact Finset.univ.filter (IsPointedNonembeddedWitness I e O j x)

/-- Exhaustive finite-field search for the pointed obstruction cost, with `⊤` returned when the
constrained witness set is empty. -/
def pointedNonembeddedCostSearch
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) : WithTop ℕ :=
  sInf (((pointedNonembeddedCandidates I e O j x).image fun w =>
    ((∑ l, hammingNorm (w l) : ℕ) : WithTop ℕ)) : Set (WithTop ℕ))

omit [DecidableEq V] in
/-- The exhaustive finite-field search computes the abstract pointed obstruction cost. -/
theorem pointedNonembeddedCostSearch_eq
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) :
    pointedNonembeddedCostSearch I e O j x = pointedNonembeddedCost I e O j x := by
  apply congrArg sInf
  ext n
  simp only [pointedNonembeddedCandidates, Finset.mem_coe, Finset.mem_image, Finset.mem_filter,
    Finset.mem_univ, true_and, Set.mem_setOf_eq]

end PointedFiniteSearch

#print axioms RepairPorts.exists_functionalFiberCost_realizer
#print axioms RepairPorts.exists_functionalTupleCost_realizer
#print axioms RepairPorts.hasWeightedFunctionalDualDistanceAtLeast_iff_functionalTupleCost
#print axioms RepairPorts.functionalFiberCostSearch_eq
#print axioms RepairPorts.pointedFunctionalFiberCost_eq_top_iff
#print axioms RepairPorts.exists_pointedFunctionalFiberCost_realizer
#print axioms RepairPorts.pointedFunctionalTupleRealizationCost_eq
#print axioms RepairPorts.nonzeroOuterPointedRealizationCost_eq_fiberCost
#print axioms RepairPorts.pointedNonembeddedCost_eq_min_zero_nonzero
#print axioms RepairPorts.zeroFunctionalPointedNonembeddedCost_eq_closed
#print axioms RepairPorts.pointedNonembeddedCost_eq_min_closed_nonzero
#print axioms RepairPorts.pointedNonembeddedCost_eq_top_iff
#print axioms RepairPorts.hasPointedNonembeddedDualDistanceAtLeast_iff_le_pointedCost
#print axioms RepairPorts.pointedNonembeddedCostSearch_eq

end

end RepairPorts
