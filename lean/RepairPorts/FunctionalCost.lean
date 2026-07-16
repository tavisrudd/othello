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
#print axioms RepairPorts.pointedNonembeddedCost_eq_top_iff
#print axioms RepairPorts.hasPointedNonembeddedDualDistanceAtLeast_iff_le_pointedCost
#print axioms RepairPorts.pointedNonembeddedCostSearch_eq

end

end RepairPorts
