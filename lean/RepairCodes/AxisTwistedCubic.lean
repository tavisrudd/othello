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

omit [Fintype 𝔽] [DecidableEq 𝔽] in
@[simp] theorem axisTwistedCubicGenerator_col (j : AxisTwistedCubicIndex 𝔽) :
    (axisTwistedCubicGenerator (𝔽 := 𝔽)).col j = axisTwistedCubicPoints 𝔽 j := rfl

/-- The uniform code presented as a row code, for the dual/repair API. -/
def axisTwistedCubicCode : Submodule 𝔽 (AxisTwistedCubicIndex 𝔽 → 𝔽) :=
  rowCode (axisTwistedCubicGenerator (𝔽 := 𝔽))

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- The row-code and projective-system presentations are definitionally the same linear code. -/
theorem axisTwistedCubicCode_eq_columnCode :
    axisTwistedCubicCode (𝔽 := 𝔽) = columnCode (axisTwistedCubicPoints 𝔽) := by
  rw [axisTwistedCubicCode, rowCode, columnCode, Matrix.range_mulVecLin]
  rfl

/-- Natural coordinate enumeration of the circuit attached to a cubic triple. -/
noncomputable def cubicTripleIndexFamily (v : Fin 3 → 𝔽) :
    Fin 4 → AxisTwistedCubicIndex 𝔽 :=
  ![.inl (v 0), .inl (v 1), .inl (v 2), .inr (twistedCubicTripleAxisIndex v)]

omit [Fintype 𝔽] in
@[simp] theorem axisTwistedCubicPoints_cubicTripleIndexFamily (v : Fin 3 → 𝔽)
    (j : Fin 4) :
    axisTwistedCubicPoints 𝔽 (cubicTripleIndexFamily v j) =
      twistedCubicTripleFamily v j := by
  fin_cases j
  · exact (twistedCubicTripleFamily_zero v).symm
  · exact (twistedCubicTripleFamily_one v).symm
  · exact (twistedCubicTripleFamily_two v).symm
  · exact (twistedCubicTripleFamily_three v).symm

/-- The three helpers repairing the first cubic coordinate of a distinct cubic triple. -/
noncomputable def cubicTripleRepairHelpers (v : Fin 3 → 𝔽) :
    Finset (AxisTwistedCubicIndex 𝔽) :=
  { .inl (v 1), .inl (v 2), .inr (twistedCubicTripleAxisIndex v) }

/-- The two helpers repairing the first coordinate of a distinct axis triple. -/
def axisTripleRepairHelpers (w : Fin 3 → 𝔽 ⊕ Unit) :
    Finset (AxisTwistedCubicIndex 𝔽) :=
  { .inr (w 1), .inr (w 2) }

/-- A canonical distinct cubic triple beginning at `x`. -/
def cubicCoordinateTriple [CharP 𝔽 3] (x : 𝔽) : Fin 3 → 𝔽 :=
  ![x, x + 1, x + 2]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
theorem cubicCoordinateTriple_injective [CharP 𝔽 3] (x : 𝔽) :
    Function.Injective (cubicCoordinateTriple x) := by
  have hthree : (3 : 𝔽) = 0 := CharP.cast_eq_zero 𝔽 3
  have htwo : (2 : 𝔽) ≠ 0 := by
    intro h
    apply (one_ne_zero : (1 : 𝔽) ≠ 0)
    linear_combination hthree - h
  have hone_two : (1 : 𝔽) ≠ 2 := by
    intro h
    apply (one_ne_zero : (1 : 𝔽) ≠ 0)
    linear_combination -h
  intro i j hij
  fin_cases i <;> fin_cases j <;> simp_all [cubicCoordinateTriple]

/-- A canonical distinct axis triple beginning at `y`. -/
def axisCoordinateTriple (y : 𝔽 ⊕ Unit) : Fin 3 → 𝔽 ⊕ Unit :=
  match y with
  | .inl x => ![.inl x, .inr Unit.unit, .inl (x + 1)]
  | .inr _ => ![.inr Unit.unit, .inl 0, .inl 1]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
@[simp] theorem axisCoordinateTriple_zero (y : 𝔽 ⊕ Unit) :
    axisCoordinateTriple y 0 = y := by cases y <;> rfl

omit [Fintype 𝔽] [DecidableEq 𝔽] in
theorem axisCoordinateTriple_injective (y : 𝔽 ⊕ Unit) :
    Function.Injective (axisCoordinateTriple y) := by
  cases y <;> intro i j hij <;> fin_cases i <;> fin_cases j <;>
    simp_all [axisCoordinateTriple]

/-- The order-preserving enumeration of a finite type with one `Fin` index deleted. -/
private noncomputable def finEraseEquiv {n : ℕ} (j : Fin (n + 1)) :
    Fin n ≃ {i : Fin (n + 1) // i ≠ j} := by
  let f : Fin n → {i : Fin (n + 1) // i ≠ j} := fun i => ⟨j.succAbove i, j.succAbove_ne i⟩
  apply Equiv.ofBijective f
  rw [Fintype.bijective_iff_injective_and_card]
  refine ⟨?_, ?_⟩
  · intro a b hab
    exact Fin.succAbove_right_injective (congrArg Subtype.val hab)
  · rw [Fintype.card_subtype_compl (fun i : Fin (n + 1) => i = j)]
    simp

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
  have hefamily :
      (fun i : Fin 4 => (axisTwistedCubicGenerator (𝔽 := 𝔽)).col (e i)) =
        twistedCubicTripleFamily v := by
    funext i
    simp [e, f]
  have htransport (j : Fin 4)
      (hli : LinearIndependent 𝔽 (fun a : Fin 3 => twistedCubicTripleFamily v (j.succAbove a))) :
      LinearIndependent 𝔽
        (fun i : {i : Fin 4 // i ≠ j} => twistedCubicTripleFamily v i) := by
    let ej := finEraseEquiv j
    have hli' := hli.comp ej.symm ej.symm.injective
    have heq :
        ((fun a : Fin 3 => twistedCubicTripleFamily v (j.succAbove a)) ∘ ej.symm) =
          (fun i : {i : Fin 4 // i ≠ j} => twistedCubicTripleFamily v i) := by
      funext i
      apply congrArg (twistedCubicTripleFamily v)
      exact congrArg Subtype.val (ej.apply_symm_apply i)
    rw [← heq]
    exact hli'
  have hdelete : ∀ j : Fin 4,
      LinearIndependent 𝔽 (fun i : {i : Fin 4 // i ≠ j} =>
        (axisTwistedCubicGenerator (𝔽 := 𝔽)).col (e i)) := by
    intro j
    rw [show (fun i : {i : Fin 4 // i ≠ j} =>
        (axisTwistedCubicGenerator (𝔽 := 𝔽)).col (e i)) =
        (fun i : {i : Fin 4 // i ≠ j} => twistedCubicTripleFamily v i) by
          funext i
          exact congrFun hefamily i]
    apply htransport
    have hs12 : (1 : Fin 4).succAbove (2 : Fin 3) = 3 := by decide
    have hs21 : (2 : Fin 4).succAbove (1 : Fin 3) = 1 := by decide
    have hs22 : (2 : Fin 4).succAbove (2 : Fin 3) = 3 := by decide
    have hs31 : (3 : Fin 4).succAbove (1 : Fin 3) = 1 := by decide
    have hs32 : (3 : Fin 4).succAbove (2 : Fin 3) = 2 := by decide
    fin_cases j
    · convert twistedCubicTriple_omitCubic0_linearIndependent hv using 1
      funext a
      fin_cases a <;> simp
    · convert twistedCubicTriple_omitCubic1_linearIndependent hv using 1
      funext a
      fin_cases a <;> simp [hs12]
    · convert twistedCubicTriple_omitCubic2_linearIndependent hv using 1
      funext a
      fin_cases a <;> simp [hs21, hs22]
    · convert twistedCubicTriple_omitAxis_linearIndependent hv using 1
      funext a
      fin_cases a <;> simp [hs31, hs32]
  apply mem_repairHypergraph_of_reindexed_circuit
    (G := axisTwistedCubicGenerator) hsub hcard e
  · rw [hefamily]
    exact twistedCubicTripleFamily_dependent v
  · exact hdelete

/-- Three distinct axis parameters give an actual locality-two repair edge for the first axis
coordinate. -/
theorem axisTripleRepairHelpers_mem {w : Fin 3 → 𝔽 ⊕ Unit}
    (hw : Function.Injective w) :
    axisTripleRepairHelpers w ∈
      axisTwistedCubicRepairHypergraph (.inr (w 0)) 2 := by
  classical
  let f : Fin 3 → ↥(insert (.inr (w 0)) (axisTripleRepairHelpers w)) := fun i =>
    ⟨.inr (w i), by fin_cases i <;> simp [axisTripleRepairHelpers]⟩
  have h01 : w 0 ≠ w 1 := hw.ne (by decide)
  have h02 : w 0 ≠ w 2 := hw.ne (by decide)
  have h12 : w 1 ≠ w 2 := hw.ne (by decide)
  have hf : Function.Injective f := by
    intro i j hij
    apply hw
    exact Sum.inr.inj (congrArg Subtype.val hij)
  have hfsurj : Function.Surjective f := by
    intro y
    rcases y with ⟨y, hy⟩
    have hy' : y = .inr (w 0) ∨ y = .inr (w 1) ∨ y = .inr (w 2) := by
      simpa [axisTripleRepairHelpers] using hy
    rcases hy' with hy' | hy' | hy' <;> subst y
    · exact ⟨0, by ext; simp [f]⟩
    · exact ⟨1, by ext; simp [f]⟩
    · exact ⟨2, by ext; simp [f]⟩
  let e : Fin 3 ≃ ↥(insert (.inr (w 0)) (axisTripleRepairHelpers w)) :=
    Equiv.ofBijective f ⟨hf, hfsurj⟩
  have hsub : axisTripleRepairHelpers w ⊆ univ.erase (.inr (w 0)) := by
    intro y hy
    rw [Finset.mem_erase]
    refine ⟨?_, Finset.mem_univ y⟩
    intro hy0
    subst y
    simp [axisTripleRepairHelpers, h01, h02] at hy
  have hcard : (axisTripleRepairHelpers w).card = 2 := by
    simp [axisTripleRepairHelpers, h12]
  have hefamily :
      (fun i : Fin 3 => (axisTwistedCubicGenerator (𝔽 := 𝔽)).col (e i)) =
        (fun i => axisTwistedCubicPoints 𝔽 (.inr (w i))) := by
    funext i
    simp [e, f]
  have htransport (j : Fin 3)
      (hli : LinearIndependent 𝔽
        (fun a : Fin 2 => axisTwistedCubicPoints 𝔽 (.inr (w (j.succAbove a))))) :
      LinearIndependent 𝔽
        (fun i : {i : Fin 3 // i ≠ j} => axisTwistedCubicPoints 𝔽 (.inr (w i))) := by
    let ej := finEraseEquiv j
    have hli' := hli.comp ej.symm ej.symm.injective
    have heq :
        ((fun a : Fin 2 => axisTwistedCubicPoints 𝔽 (.inr (w (j.succAbove a)))) ∘ ej.symm) =
          (fun i : {i : Fin 3 // i ≠ j} => axisTwistedCubicPoints 𝔽 (.inr (w i))) := by
      funext i
      apply congrArg (fun a => axisTwistedCubicPoints 𝔽 (.inr (w a)))
      exact congrArg Subtype.val (ej.apply_symm_apply i)
    rw [← heq]
    exact hli'
  have hcirc := twistedCubicAxis_triple_isCircuit (w := w) hw
  have hdelete : ∀ j : Fin 3,
      LinearIndependent 𝔽 (fun i : {i : Fin 3 // i ≠ j} =>
        (axisTwistedCubicGenerator (𝔽 := 𝔽)).col (e i)) := by
    intro j
    rw [show (fun i : {i : Fin 3 // i ≠ j} =>
        (axisTwistedCubicGenerator (𝔽 := 𝔽)).col (e i)) =
        (fun i : {i : Fin 3 // i ≠ j} => axisTwistedCubicPoints 𝔽 (.inr (w i))) by
          funext i
          exact congrFun hefamily i]
    apply htransport
    have hs11 : (1 : Fin 3).succAbove (1 : Fin 2) = 2 := by decide
    have hs21 : (2 : Fin 3).succAbove (1 : Fin 2) = 1 := by decide
    fin_cases j
    · convert hcirc.2.1 using 1
      funext a
      fin_cases a <;> simp
    · convert hcirc.2.2.1 using 1
      funext a
      fin_cases a <;> simp [hs11]
    · convert hcirc.2.2.2 using 1
      funext a
      fin_cases a <;> simp [hs21]
  apply mem_repairHypergraph_of_reindexed_circuit
    (G := axisTwistedCubicGenerator) hsub hcard e
  · rw [hefamily]
    exact hcirc.1
  · exact hdelete

/-- Every cubic coordinate has a concrete repair edge with three helpers. -/
theorem cubicCoordinate_has_repairEdge [CharP 𝔽 3] (x : 𝔽) :
    ∃ R, R ∈ axisTwistedCubicRepairHypergraph (.inl x) 3 := by
  let v := cubicCoordinateTriple x
  refine ⟨cubicTripleRepairHelpers v, ?_⟩
  simpa [v, cubicCoordinateTriple] using
    cubicTripleRepairHelpers_mem (cubicCoordinateTriple_injective x)

/-- Every axis coordinate has a concrete repair edge with two helpers. -/
theorem axisCoordinate_has_repairEdge (y : 𝔽 ⊕ Unit) :
    ∃ R, R ∈ axisTwistedCubicRepairHypergraph (.inr y) 2 := by
  let w := axisCoordinateTriple y
  refine ⟨axisTripleRepairHelpers w, ?_⟩
  simpa [w] using axisTripleRepairHelpers_mem (axisCoordinateTriple_injective y)

/-- The uniform twisted-cubic–axis code has all-symbol locality at most three.  Cubic coordinates
use the preceding four-circuits; axis coordinates already have locality two. -/
theorem axisTwistedCubic_allSymbol_locality_three [CharP 𝔽 3]
    (x : AxisTwistedCubicIndex 𝔽) :
    ∃ R, R ∈ axisTwistedCubicRepairHypergraph x 3 := by
  cases x with
  | inl x => exact cubicCoordinate_has_repairEdge x
  | inr y =>
      obtain ⟨R, hR⟩ := axisCoordinate_has_repairEdge y
      exact ⟨R, repairHypergraph_mono_radius (by omega) hR⟩

#print axioms axisTwistedCubicCode_eq_columnCode
#print axioms axisTwistedCubic_circuit_mem_repair
#print axioms cubicTripleRepairHelpers_mem
#print axioms axisTripleRepairHelpers_mem
#print axioms axisTwistedCubic_allSymbol_locality_three

end RepairCodes
