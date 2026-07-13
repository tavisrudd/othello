import RepairCodes.SeedLift
import Mathlib.Algebra.Field.ZMod

/-!
# Boundary examples for complete repair-hypergraph transfer

Small nondegenerate codes over `ZMod 3` witness that neither numerical gate in
`repairHypergraph_concatenatedCode_eq_embed` can be weakened uniformly.  The conclusions are
literal inequalities of complete repair hypergraphs, not merely low-weight dual-word witnesses.
-/

namespace RepairCodes

open Finset Matrix FiniteGeom
open scoped BigOperators

noncomputable section

abbrev BoundaryField := ZMod 3

/-- The length-two repetition code over `GF(3)`. -/
def boundaryInnerCode : Submodule BoundaryField (Fin 2 → BoundaryField) where
  carrier := {w | w 0 = w 1}
  zero_mem' := rfl
  add_mem' := fun ha hb => by simp only [Set.mem_setOf_eq, Pi.add_apply]; rw [ha, hb]
  smul_mem' := fun c w hw => by simp only [Set.mem_setOf_eq, Pi.smul_apply]; rw [hw]

@[simp]
theorem mem_boundaryInnerCode {w : Fin 2 → BoundaryField} :
    w ∈ boundaryInnerCode ↔ w 0 = w 1 := Iff.rfl

theorem boundaryInnerCode_ne_bot : boundaryInnerCode ≠ ⊥ := by
  apply (Submodule.ne_bot_iff boundaryInnerCode).mpr
  refine ⟨fun _ => 1, rfl, ?_⟩
  · intro h
    have h0 := congrFun h 0
    norm_num at h0

/-- Encode one outer symbol as a constant length-two inner word. -/
def boundaryInnerEncoder : BoundaryField ≃ₗ[BoundaryField] boundaryInnerCode where
  toFun a := ⟨fun _ => a, rfl⟩
  invFun w := w.1 0
  left_inv _ := rfl
  right_inv w := by
    apply Subtype.ext
    funext i
    fin_cases i
    · rfl
    · exact w.2
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- The standard minimum dual word of the repetition code. -/
def boundaryInnerDualWord : Fin 2 → BoundaryField := ![1, -1]

theorem mem_dualCode_boundaryInnerCode_iff {y : Fin 2 → BoundaryField} :
    y ∈ dualCode boundaryInnerCode ↔ y 0 + y 1 = 0 := by
  constructor
  · intro hy
    have h := hy (fun _ => 1) (by simp [boundaryInnerCode])
    simpa [dotProduct, Fin.sum_univ_two] using h
  · intro hy
    rw [mem_dualCode]
    intro x hx
    simp only [dotProduct, Fin.sum_univ_two]
    have hxeq : x 0 = x 1 := hx
    rw [hxeq, ← mul_add, hy, mul_zero]

theorem boundaryInnerDualWord_mem :
    boundaryInnerDualWord ∈ dualCode boundaryInnerCode := by
  rw [mem_dualCode_boundaryInnerCode_iff]
  norm_num [boundaryInnerDualWord]

@[simp]
theorem boundaryInnerDualWord_ne_zero : boundaryInnerDualWord ≠ 0 := by
  intro h
  have := congrFun h 0
  norm_num [boundaryInnerDualWord] at this

@[simp]
theorem boundaryInnerDualWord_hammingNorm : hammingNorm boundaryInnerDualWord = 2 := by
  decide

/-- The repetition code has exact dual distance two. -/
theorem boundaryInnerCode_dualDist : dualDist boundaryInnerCode = 2 := by
  apply le_antisymm
  · simpa using dualDist_le_hammingNorm boundaryInnerDualWord_mem boundaryInnerDualWord_ne_zero
  · apply le_minDist
    · exact (Submodule.ne_bot_iff _).mpr
        ⟨boundaryInnerDualWord, boundaryInnerDualWord_mem, boundaryInnerDualWord_ne_zero⟩
    · intro y hy hy0
      rw [mem_dualCode_boundaryInnerCode_iff] at hy
      have hy0ne : y 0 ≠ 0 := by
        intro h0
        have h1 : y 1 = 0 := by linear_combination hy - h0
        apply hy0
        funext i
        fin_cases i <;> assumption
      have hy1ne : y 1 ≠ 0 := by
        intro h1
        have h0 : y 0 = 0 := by linear_combination hy - h1
        apply hy0
        funext i
        fin_cases i <;> assumption
      norm_num [hammingNorm, Finset.card_filter, hy0ne, hy1ne]

/-- The three-symbol single-parity-check outer code. -/
def boundaryOuterCode : Submodule BoundaryField (Fin 3 → BoundaryField) where
  carrier := {u | u 0 + u 1 + u 2 = 0}
  zero_mem' := by simp
  add_mem' := fun hu hv => by
    simp only [Set.mem_setOf_eq, Pi.add_apply] at hu hv ⊢
    linear_combination hu + hv
  smul_mem' := fun c u hu => by
    simp only [Set.mem_setOf_eq, Pi.smul_apply, smul_eq_mul] at hu ⊢
    linear_combination c * hu

@[simp]
theorem mem_boundaryOuterCode {u : Fin 3 → BoundaryField} :
    u ∈ boundaryOuterCode ↔ u 0 + u 1 + u 2 = 0 := Iff.rfl

theorem boundaryOuterCode_ne_bot : boundaryOuterCode ≠ ⊥ := by
  apply (Submodule.ne_bot_iff boundaryOuterCode).mpr
  refine ⟨![1, -1, 0], ?_, ?_⟩
  · rw [mem_boundaryOuterCode]
    change (1 : BoundaryField) + (-1) + 0 = 0
    norm_num
  · intro h
    have h0 := congrFun h 0
    norm_num at h0

theorem boundaryFullOuterCode_ne_bot :
    (⊤ : Submodule BoundaryField (Fin 2 → BoundaryField)) ≠ ⊥ := by
  exact top_ne_bot

/-- The single-parity-check outer code has functional-dual distance at least three. -/
theorem boundaryOuterCode_functionalDualDistance_three :
    HasFunctionalDualDistanceAtLeast boundaryOuterCode 3 := by
  classical
  intro beta hbeta hbeta0
  have h01 : beta 0 = beta 1 := by
    apply LinearMap.ext
    intro v
    have h := hbeta ![v, -v, 0] (by simp [boundaryOuterCode])
    simp [Fin.sum_univ_three] at h
    linear_combination h
  have h12 : beta 1 = beta 2 := by
    apply LinearMap.ext
    intro v
    have h := hbeta ![0, v, -v] (by simp [boundaryOuterCode])
    simp [Fin.sum_univ_three] at h
    linear_combination h
  have hall : ∀ j, beta j = beta 0 := by
    intro j
    fin_cases j
    · rfl
    · exact h01.symm
    · exact h12.symm.trans h01.symm
  have hb0 : beta 0 ≠ 0 := by
    intro hb0
    apply hbeta0
    funext j
    rw [hall j, hb0]
    rfl
  have hbj : ∀ j, beta j ≠ 0 := fun j => (hall j).symm ▸ hb0
  have hfilter : (univ.filter fun j => beta j ≠ 0) = (univ : Finset (Fin 3)) := by
    exact Finset.filter_eq_self.mpr fun j _ => hbj j
  rw [functionalWeight, hfilter]
  simp

/-- The preceding bound is exact: the constant identity functional has weight three. -/
theorem boundaryOuterCode_not_functionalDualDistance_four :
    ¬ HasFunctionalDualDistanceAtLeast boundaryOuterCode 4 := by
  let beta : Fin 3 → Module.Dual BoundaryField BoundaryField := fun _ => LinearMap.id
  have hbeta : beta ∈ functionalDual boundaryOuterCode := by
    intro u hu
    simpa [beta, Fin.sum_univ_three] using hu
  have hid : (LinearMap.id : Module.Dual BoundaryField BoundaryField) ≠ 0 := by
    intro h
    have h1 := LinearMap.congr_fun h 1
    norm_num at h1
  have hbeta0 : beta ≠ 0 := by
    intro h
    exact hid (congrFun h 0)
  have hweight : functionalWeight beta = 3 := by
    norm_num [functionalWeight, Finset.card_filter, beta, hid]
  intro hfour
  have := hfour beta hbeta hbeta0
  omega

/-! ## The inner-distance boundary: two minimum inner-dual blocks -/

/-- At the inner boundary, put one minimum inner-dual word in each of two blocks. -/
def innerBoundaryWord : Fin 2 × Fin 2 → BoundaryField :=
  singleBlockWord 0 boundaryInnerDualWord + singleBlockWord 1 boundaryInnerDualWord

/-- The three helpers of `innerBoundaryWord` when the target is `(0,0)`. -/
def innerBoundaryRepair : Finset (Fin 2 × Fin 2) := univ.erase (0, 0)

theorem innerBoundaryWord_mem_dual :
    innerBoundaryWord ∈ dualCode
      (concatenatedCode boundaryInnerCode boundaryInnerEncoder
        (⊤ : Submodule BoundaryField (Fin 2 → BoundaryField))) := by
  apply (dualCode _).add_mem
  · exact singleBlockWord_mem_dualCode_concatenatedCode
      boundaryInnerCode boundaryInnerEncoder ⊤ boundaryInnerDualWord_mem
  · exact singleBlockWord_mem_dualCode_concatenatedCode
      boundaryInnerCode boundaryInnerEncoder ⊤ boundaryInnerDualWord_mem

@[simp]
theorem innerBoundaryWord_support : wordSupport innerBoundaryWord = univ := by
  ext p
  rcases p with ⟨j, x⟩
  fin_cases j <;> fin_cases x <;>
    norm_num [wordSupport, innerBoundaryWord, singleBlockWord, boundaryInnerDualWord]

theorem innerBoundaryRepair_mem :
    innerBoundaryRepair ∈ repairHypergraph
      (concatenatedCode boundaryInnerCode boundaryInnerEncoder
        (⊤ : Submodule BoundaryField (Fin 2 → BoundaryField))) (0, 0) 3 := by
  apply mem_repairHypergraph.mpr
  refine ⟨by simp [innerBoundaryRepair], by decide, innerBoundaryWord,
    innerBoundaryWord_mem_dual, ?_, ?_⟩
  · norm_num [innerBoundaryWord, singleBlockWord, boundaryInnerDualWord]
  · rw [innerBoundaryWord_support]
    simp [innerBoundaryRepair]

theorem innerBoundaryRepair_not_embedded :
    innerBoundaryRepair ∉
      embedHypergraph (blockEmbedding (κ := Fin 2) (0 : Fin 2))
        (repairHypergraph boundaryInnerCode 0 3) := by
  intro h
  obtain ⟨S, hS, hmap⟩ := Finset.mem_image.mp h
  have hp : ((1, 0) : Fin 2 × Fin 2) ∈ innerBoundaryRepair := by
    decide
  rw [← hmap] at hp
  obtain ⟨x, hx, hpair⟩ := Finset.mem_map.mp hp
  have := congrArg Prod.fst hpair
  norm_num [blockEmbedding] at this

/-- **The inner gate is uniformly strict.** At equality
`r+1 = 2 d(I⊥)`, even a full outer code produces a genuinely cross-block repair edge, so the
complete repair hypergraph is not the embedded inner hypergraph. -/
theorem innerDualDistanceGate_boundary_counterexample :
    3 + 1 = 2 * dualDist boundaryInnerCode ∧
      HasFunctionalDualDistanceAtLeast
        (⊤ : Submodule BoundaryField (Fin 2 → BoundaryField)) 5 ∧
      repairHypergraph
          (concatenatedCode boundaryInnerCode boundaryInnerEncoder
            (⊤ : Submodule BoundaryField (Fin 2 → BoundaryField))) (0, 0) 3 ≠
        embedHypergraph (blockEmbedding (κ := Fin 2) (0 : Fin 2))
          (repairHypergraph boundaryInnerCode 0 3) := by
  refine ⟨by rw [boundaryInnerCode_dualDist],
    hasFunctionalDualDistanceAtLeast_top 5, ?_⟩
  intro heq
  exact innerBoundaryRepair_not_embedded (heq ▸ innerBoundaryRepair_mem)

/-! ## The outer-distance boundary: one coordinate from each of three blocks -/

/-- A weight-three word selecting inner coordinate zero in every one of three blocks. -/
def outerBoundaryWord : Fin 3 × Fin 2 → BoundaryField := fun p => if p.2 = 0 then 1 else 0

/-- The two helpers of `outerBoundaryWord` when the target is `(0,0)`. -/
def outerBoundaryRepair : Finset (Fin 3 × Fin 2) := {(1, 0), (2, 0)}

theorem outerBoundaryWord_mem_dual :
    outerBoundaryWord ∈ dualCode
      (concatenatedCode boundaryInnerCode boundaryInnerEncoder boundaryOuterCode) := by
  rw [mem_dualCode]
  intro c hc
  obtain ⟨u, hu, rfl⟩ := Submodule.mem_map.mp hc
  simpa [dotProduct, Fintype.sum_prod_type, Fin.sum_univ_two, Fin.sum_univ_three,
    concatenationLinearMap_apply, boundaryInnerEncoder, outerBoundaryWord] using hu

@[simp]
theorem outerBoundaryWord_support :
    wordSupport outerBoundaryWord = insert (0, 0) outerBoundaryRepair := by
  decide

theorem outerBoundaryRepair_mem :
    outerBoundaryRepair ∈ repairHypergraph
      (concatenatedCode boundaryInnerCode boundaryInnerEncoder boundaryOuterCode) (0, 0) 2 := by
  apply mem_repairHypergraph.mpr
  refine ⟨by decide, by decide, outerBoundaryWord, outerBoundaryWord_mem_dual, ?_, ?_⟩
  · norm_num [outerBoundaryWord]
  · exact outerBoundaryWord_support

theorem outerBoundaryRepair_not_embedded :
    outerBoundaryRepair ∉
      embedHypergraph (blockEmbedding (κ := Fin 2) (0 : Fin 3))
        (repairHypergraph boundaryInnerCode 0 2) := by
  intro h
  obtain ⟨S, hS, hmap⟩ := Finset.mem_image.mp h
  have hp : ((1, 0) : Fin 3 × Fin 2) ∈ outerBoundaryRepair := by decide
  rw [← hmap] at hp
  obtain ⟨x, hx, hpair⟩ := Finset.mem_map.mp hp
  have := congrArg Prod.fst hpair
  norm_num [blockEmbedding] at this

/-- **The outer gate is uniformly strict.** With the inner gate strict at radius two, an outer
functional-dual word of boundary weight `r+1 = 3` still produces a genuinely cross-block repair
edge.  Thus functional-dual distance three cannot replace the required distance four. -/
theorem outerFunctionalDualDistanceGate_boundary_counterexample :
    2 + 1 < 2 * dualDist boundaryInnerCode ∧
      HasFunctionalDualDistanceAtLeast boundaryOuterCode 3 ∧
      ¬ HasFunctionalDualDistanceAtLeast boundaryOuterCode 4 ∧
      repairHypergraph
          (concatenatedCode boundaryInnerCode boundaryInnerEncoder boundaryOuterCode) (0, 0) 2 ≠
        embedHypergraph (blockEmbedding (κ := Fin 2) (0 : Fin 3))
          (repairHypergraph boundaryInnerCode 0 2) := by
  refine ⟨by rw [boundaryInnerCode_dualDist]; norm_num,
    boundaryOuterCode_functionalDualDistance_three,
    boundaryOuterCode_not_functionalDualDistance_four, ?_⟩
  intro heq
  exact outerBoundaryRepair_not_embedded (heq ▸ outerBoundaryRepair_mem)

#print axioms innerDualDistanceGate_boundary_counterexample
#print axioms outerFunctionalDualDistanceGate_boundary_counterexample

end
end RepairCodes
