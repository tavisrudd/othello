import FiniteGeom.AxisTwistedCubicCircuits
import FiniteGeom.Repair

/-!
# Repair layer for the uniform twisted-cubic–axis code

This module instantiates the now coordinate-type-generic `FiniteGeom.Repair` API directly on the
natural index `𝔽 ⊕ 𝔽 ⊕ Unit`.  No `Fin (2q+1)` reindexing is needed.
-/

namespace RepairCodes

open Finset Matrix FiniteGeom

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- Generator matrix whose columns are the points of `S_q`. -/
def axisTwistedCubicGenerator : Matrix (Fin 4) (AxisTwistedCubicIndex 𝔽) 𝔽 :=
  fun i j => axisTwistedCubicPoints 𝔽 j i

@[simp] theorem axisTwistedCubicGenerator_col (j : AxisTwistedCubicIndex 𝔽) :
    (axisTwistedCubicGenerator (𝔽 := 𝔽)).col j = axisTwistedCubicPoints 𝔽 j := rfl

/-- The uniform code presented as a row code, for the dual/repair API. -/
def axisTwistedCubicCode : Submodule 𝔽 (AxisTwistedCubicIndex 𝔽 → 𝔽) :=
  rowCode (axisTwistedCubicGenerator (𝔽 := 𝔽))

/-- The row-code and projective-system presentations are definitionally the same linear code. -/
theorem axisTwistedCubicCode_eq_columnCode :
    axisTwistedCubicCode (𝔽 := 𝔽) = columnCode (axisTwistedCubicPoints 𝔽) := by
  rw [axisTwistedCubicCode, rowCode, columnCode, Matrix.range_mulVecLin]
  rfl

/-- Natural coordinate enumeration of the circuit attached to a cubic triple. -/
noncomputable def cubicTripleIndexFamily (v : Fin 3 → 𝔽) :
    Fin 4 → AxisTwistedCubicIndex 𝔽 :=
  ![.inl (v 0), .inl (v 1), .inl (v 2), .inr (twistedCubicTripleAxisIndex v)]

@[simp] theorem axisTwistedCubicPoints_cubicTripleIndexFamily (v : Fin 3 → 𝔽)
    (j : Fin 4) :
    axisTwistedCubicPoints 𝔽 (cubicTripleIndexFamily v j) =
      twistedCubicTripleFamily v j := by
  cases j using Fin.lastCases with
  | last => simp [cubicTripleIndexFamily, twistedCubicTripleFamily]
  | cast j =>
      fin_cases j <;> simp [cubicTripleIndexFamily, twistedCubicTripleFamily]

/-- The three helpers repairing the first cubic coordinate of a distinct cubic triple. -/
noncomputable def cubicTripleRepairHelpers (v : Fin 3 → 𝔽) :
    Finset (AxisTwistedCubicIndex 𝔽) :=
  { .inl (v 1), .inl (v 2), .inr (twistedCubicTripleAxisIndex v) }

/-- Complete bounded-radius repair hypergraph at a coordinate of `S_q`. -/
noncomputable def axisTwistedCubicRepairHypergraph
    (x : AxisTwistedCubicIndex 𝔽) (r : ℕ) :
    Finset (Finset (AxisTwistedCubicIndex 𝔽)) :=
  repairHypergraph (axisTwistedCubicCode (𝔽 := 𝔽)) x r

/-- Every actual repair edge gives a dependent target-plus-helper point family. -/
theorem axisTwistedCubicRepair_edge_dependent {x : AxisTwistedCubicIndex 𝔽} {r : ℕ}
    {R : Finset (AxisTwistedCubicIndex 𝔽)}
    (hR : R ∈ axisTwistedCubicRepairHypergraph x r) :
    ¬ LinearIndependent 𝔽
      (fun j : ↥(insert x R) => axisTwistedCubicPoints 𝔽 j) := by
  exact repair_edge_columns_dependent (G := axisTwistedCubicGenerator) hR

/-- Every target-plus-helper circuit is an actual repair edge, without a false global
`d(C⊥)≥r+1` requirement.  This is the bridge needed for cubic four-circuits even though the same
code also has axis three-circuits. -/
theorem axisTwistedCubic_circuit_mem_repair {x : AxisTwistedCubicIndex 𝔽} {r : ℕ}
    {R : Finset (AxisTwistedCubicIndex 𝔽)} (hsub : R ⊆ univ.erase x) (hcard : R.card = r)
    (hdep : ¬ LinearIndependent 𝔽
      (fun j : ↥(insert x R) => axisTwistedCubicPoints 𝔽 j))
    (hdelete : ∀ j : ↥(insert x R),
      LinearIndependent 𝔽
        (fun i : {i : ↥(insert x R) // i ≠ j} => axisTwistedCubicPoints 𝔽 i)) :
    R ∈ axisTwistedCubicRepairHypergraph x r := by
  exact mem_repairHypergraph_of_circuit (G := axisTwistedCubicGenerator)
    hsub hcard hdep hdelete

/-- Three distinct cubic parameters give an actual locality-three repair edge for the first cubic
coordinate: the other two cubic points and their unique completing axis point. -/
theorem cubicTripleRepairHelpers_mem [CharP 𝔽 3] {v : Fin 3 → 𝔽}
    (hv : Function.Injective v) :
    cubicTripleRepairHelpers v ∈
      axisTwistedCubicRepairHypergraph (.inl (v 0)) 3 := by
  classical
  let f : Fin 4 → ↥(insert (.inl (v 0)) (cubicTripleRepairHelpers v)) := fun i =>
    ⟨cubicTripleIndexFamily v i, by
      fin_cases i <;> simp [cubicTripleIndexFamily, cubicTripleRepairHelpers]⟩
  have h01 : v 0 ≠ v 1 := hv.ne (by decide)
  have h02 : v 0 ≠ v 2 := hv.ne (by decide)
  have h12 : v 1 ≠ v 2 := hv.ne (by decide)
  have hf : Function.Injective f := by
    intro i j hij
    apply Fin.ext
    fin_cases i <;> fin_cases j <;>
      simp_all [f, cubicTripleIndexFamily]
  have hfsurj : Function.Surjective f := by
    intro y
    rcases y with ⟨y, hy⟩
    have hy' : y = .inl (v 0) ∨ y = .inl (v 1) ∨ y = .inl (v 2) ∨
        y = .inr (twistedCubicTripleAxisIndex v) := by
      simpa [cubicTripleRepairHelpers] using hy
    rcases hy' with hy' | hy' | hy' | hy' <;> subst y
    · exact ⟨0, by ext; simp [f, cubicTripleIndexFamily]⟩
    · exact ⟨1, by ext; simp [f, cubicTripleIndexFamily]⟩
    · exact ⟨2, by ext; simp [f, cubicTripleIndexFamily]⟩
    · exact ⟨3, by ext; simp [f, cubicTripleIndexFamily]⟩
  let e : Fin 4 ≃ ↥(insert (.inl (v 0)) (cubicTripleRepairHelpers v)) :=
    Equiv.ofBijective f ⟨hf, hfsurj⟩
  have hsub : cubicTripleRepairHelpers v ⊆ univ.erase (.inl (v 0)) := by
    intro y hy
    rw [Finset.mem_erase]
    refine ⟨?_, Finset.mem_univ y⟩
    intro hy0
    subst y
    simp [cubicTripleRepairHelpers, h01, h02] at hy
  have hcard : (cubicTripleRepairHelpers v).card = 3 := by
    simp [cubicTripleRepairHelpers, h12]
  have hdep := twistedCubicTripleFamily_dependent (v := v)
  rw [Fintype.not_linearIndependent_iff] at hdep
  obtain ⟨c, hrel, ⟨j, hcj⟩⟩ := hdep
  have hc : c ≠ 0 := by
    intro hzero
    exact hcj (congrFun hzero j)
  apply mem_repairHypergraph_of_reindexed_fullSupport_relation
    (G := axisTwistedCubicGenerator) hsub hcard e c
  · simpa [e, f] using hrel
  · exact twistedCubicTriple_relation_fullSupport hv hrel hc

#print axioms axisTwistedCubicCode_eq_columnCode
#print axioms axisTwistedCubic_circuit_mem_repair
#print axioms cubicTripleRepairHelpers_mem

end RepairCodes
