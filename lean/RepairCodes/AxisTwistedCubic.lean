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

/-- Explicit enumeration of a four-element support. -/
private noncomputable def fin4InsertTripleEquiv {α : Type*} [DecidableEq α]
    (a b c d : α) (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d) :
    Fin 4 ≃ ↥({a, b, c, d} : Finset α) := by
  let f : Fin 4 → ↥({a, b, c, d} : Finset α) := fun i =>
    ⟨![a, b, c, d] i, by fin_cases i <;> simp⟩
  apply Equiv.ofBijective f
  constructor
  · intro i j hij
    apply Fin.ext
    fin_cases i <;> fin_cases j <;> simp_all [f]
  · intro x
    rcases x with ⟨x, hx⟩
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl | rfl | rfl
    · exact ⟨0, by ext; simp [f]⟩
    · exact ⟨1, by ext; simp [f]⟩
    · exact ⟨2, by ext; simp [f]⟩
    · exact ⟨3, by ext; simp [f]⟩

private def fin3Cycle : Equiv.Perm (Fin 3) where
  toFun := ![1, 2, 0]
  invFun := ![2, 0, 1]
  left_inv i := by fin_cases i <;> rfl
  right_inv i := by fin_cases i <;> rfl

omit [Fintype 𝔽] [DecidableEq 𝔽] in
theorem twoCubicNormalizedAxis_linearIndependent [CharP 𝔽 3]
    {s t : 𝔽} (y : 𝔽 ⊕ Unit) (hst : s ≠ t) :
    LinearIndependent 𝔽 ![
      axisTwistedCubicPoints 𝔽 (.inl s), axisTwistedCubicPoints 𝔽 (.inl t),
      axisTwistedCubicPoints 𝔽 (.inr y)] := by
  cases y with
  | inl y =>
      convert twoCubicAxis_linearIndependent (𝔽 := 𝔽) (s := s) (t := t)
        (e₁ := 1) (e₂ := y) hst (Or.inl one_ne_zero) using 1
      funext i
      fin_cases i <;> simp [twoCubicAxisFamily, twistedCubicAxisVector]
  | inr y =>
      convert twoCubicAxis_linearIndependent (𝔽 := 𝔽) (s := s) (t := t)
        (e₁ := 0) (e₂ := 1) hst (Or.inr one_ne_zero) using 1
      funext i
      fin_cases i <;> simp [twoCubicAxisFamily, twistedCubicAxisVector]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
theorem axisTwistedCubicPoints_ne_zero (x : AxisTwistedCubicIndex 𝔽) :
    axisTwistedCubicPoints 𝔽 x ≠ 0 := by
  cases x with
  | inl t =>
      intro h
      have h0 := congrFun h 0
      simp at h0
  | inr y =>
      cases y with
      | inl y =>
          intro h
          have h1 := congrFun h 1
          simp at h1
      | inr y =>
          intro h
          have h2 := congrFun h 2
          simp at h2

omit [Fintype 𝔽] [DecidableEq 𝔽] in
theorem cubicAxis_pair_linearIndependent (s : 𝔽) (y : 𝔽 ⊕ Unit) :
    LinearIndependent 𝔽 ![
      axisTwistedCubicPoints 𝔽 (.inl s), axisTwistedCubicPoints 𝔽 (.inr y)] := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  have h0 := congrFun hrel 0
  simp [Fin.sum_univ_two] at h0
  have hg0 : g 0 = 0 := h0
  cases y with
  | inl y =>
      have h1 := congrFun hrel 1
      simp [Fin.sum_univ_two, hg0] at h1
      intro i
      fin_cases i <;> assumption
  | inr y =>
      have h2 := congrFun hrel 2
      simp [Fin.sum_univ_two, hg0] at h2
      intro i
      fin_cases i <;> assumption

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Every two distinct columns of `S_q` are independent. -/
theorem axisTwistedCubic_pair_linearIndependent
    {u : Fin 2 → AxisTwistedCubicIndex 𝔽} (hu : Function.Injective u) :
    LinearIndependent 𝔽 (fun i => axisTwistedCubicPoints 𝔽 (u i)) := by
  have h01 : u 0 ≠ u 1 := hu.ne (by decide)
  rcases h0 : u 0 with s | y <;> rcases h1 : u 1 with t | z
  · have hst : s ≠ t := by
      intro h
      apply h01
      rw [h0, h1, h]
    convert (momentCurve_linearIndependent_of_card_le (n := 4) (v := ![s, t])
        (by intro i j hij; fin_cases i <;> fin_cases j <;> simp_all)
        (by decide)) using 1
    funext i
    fin_cases i <;> simp [h0, h1]
  · convert cubicAxis_pair_linearIndependent s z using 1
    funext i
    fin_cases i <;> simp [h0, h1]
  · have hli := cubicAxis_pair_linearIndependent t y
    have hs0 : Equiv.swap (0 : Fin 2) 1 0 = 1 := by decide
    have hs1 : Equiv.swap (0 : Fin 2) 1 1 = 0 := by decide
    exact (linearIndependent_equiv' (Equiv.swap 0 1) (by
      funext i
      fin_cases i <;> simp [hs0, hs1, h0, h1])).2 hli
  · have hyz : y ≠ z := by
      intro h
      apply h01
      rw [h0, h1, h]
    convert twistedCubicAxis_pair_linearIndependent hyz using 1
    funext i
    fin_cases i <;> simp [h0, h1]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Any three distinct columns containing a cubic column are independent.  Thus the only
three-circuits of `S_q` are the all-axis triples. -/
theorem axisTwistedCubic_triple_linearIndependent_of_containsCubic [CharP 𝔽 3]
    {u : Fin 3 → AxisTwistedCubicIndex 𝔽} (hu : Function.Injective u)
    (hcubic : ∃ i t, u i = .inl t) :
    LinearIndependent 𝔽 (fun i => axisTwistedCubicPoints 𝔽 (u i)) := by
  have h01 : u 0 ≠ u 1 := hu.ne (by decide)
  have h02 : u 0 ≠ u 2 := hu.ne (by decide)
  have h12 : u 1 ≠ u 2 := hu.ne (by decide)
  rcases h0 : u 0 with s | y <;> rcases h1 : u 1 with t | z <;>
    rcases h2 : u 2 with r | w
  · let v : Fin 3 → 𝔽 := ![s, t, r]
    have hv : Function.Injective v := by
      intro i j hij
      apply hu
      fin_cases i <;> fin_cases j <;> simp_all [v]
    convert twistedCubicTriple_omitAxis_linearIndependent hv using 1
    funext i
    fin_cases i <;> simp [v, h0, h1, h2]
  · have hst : s ≠ t := by
      intro h
      apply h01
      rw [h0, h1, h]
    have hli := twoCubicNormalizedAxis_linearIndependent w hst
    convert hli using 1
    funext i
    fin_cases i <;> simp [h0, h1, h2]
  · have hsr : s ≠ r := by
      intro h
      apply h02
      rw [h0, h2, h]
    have hli := twoCubicNormalizedAxis_linearIndependent z hsr
    have hs0 : Equiv.swap (1 : Fin 3) 2 0 = 0 := by decide
    have hs1 : Equiv.swap (1 : Fin 3) 2 1 = 2 := by decide
    have hs2 : Equiv.swap (1 : Fin 3) 2 2 = 1 := by decide
    exact (linearIndependent_equiv' (Equiv.swap 1 2) (by
      funext i
      fin_cases i <;> simp [hs0, hs1, hs2, h0, h1, h2])).2 hli
  · have hzw : z ≠ w := by
      intro h
      apply h12
      rw [h1, h2, h]
    have hli := oneCubicTwoAxis_linearIndependent (𝔽 := 𝔽)
      (s := s) (y := z) (z := w) hzw
    convert hli using 1
    funext i
    fin_cases i <;> simp [oneCubicTwoAxisFamily, h0, h1, h2]
  · have htr : t ≠ r := by
      intro h
      apply h12
      rw [h1, h2, h]
    have hli := twoCubicNormalizedAxis_linearIndependent y htr
    exact (linearIndependent_equiv' fin3Cycle.symm (by
      funext i
      fin_cases i <;> simp [fin3Cycle, h0, h1, h2])).2 hli
  · have hyw : y ≠ w := by
      intro h
      apply h02
      rw [h0, h2, h]
    have hli := oneCubicTwoAxis_linearIndependent (𝔽 := 𝔽)
      (s := t) (y := y) (z := w) hyw
    have hs0 : Equiv.swap (0 : Fin 3) 1 0 = 1 := by decide
    have hs1 : Equiv.swap (0 : Fin 3) 1 1 = 0 := by decide
    have hs2 : Equiv.swap (0 : Fin 3) 1 2 = 2 := by decide
    exact (linearIndependent_equiv' (Equiv.swap 0 1) (by
      funext i
      fin_cases i <;> simp [hs0, hs1, hs2, oneCubicTwoAxisFamily, h0, h1, h2])).2 hli
  · have hyz : y ≠ z := by
      intro h
      apply h01
      rw [h0, h1, h]
    have hli := oneCubicTwoAxis_linearIndependent (𝔽 := 𝔽)
      (s := r) (y := y) (z := z) hyz
    exact (linearIndependent_equiv' fin3Cycle (by
      funext i
      fin_cases i <;> simp [fin3Cycle, oneCubicTwoAxisFamily, h0, h1, h2])).2 hli
  · obtain ⟨i, t, hi⟩ := hcubic
    fin_cases i <;> simp_all

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Every nonempty selected family of at most two columns is independent. -/
theorem axisTwistedCubic_selected_linearIndependent_of_card_le_two
    {S : Finset (AxisTwistedCubicIndex 𝔽)} (hne : S.Nonempty) (hcard : S.card ≤ 2) :
    LinearIndependent 𝔽 (fun j : S => axisTwistedCubicPoints 𝔽 j) := by
  classical
  have hcases : S.card = 1 ∨ S.card = 2 := by
    have := Finset.card_pos.mpr hne
    omega
  rcases hcases with h1 | h2
  · let e : Fin 1 ≃ S := (Finset.equivFinOfCardEq h1).symm
    apply (linearIndependent_equiv e).mp
    rw [linearIndependent_unique_iff]
    exact axisTwistedCubicPoints_ne_zero ((e 0 : S) : AxisTwistedCubicIndex 𝔽)
  · let e : Fin 2 ≃ S := (Finset.equivFinOfCardEq h2).symm
    have hemb : Function.Injective (fun i : Fin 2 => ((e i : S) : AxisTwistedCubicIndex 𝔽)) := by
      intro i j hij
      exact e.injective (Subtype.ext hij)
    apply (linearIndependent_equiv e).mp
    exact axisTwistedCubic_pair_linearIndependent hemb

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Every selected family of at most three columns containing a cubic coordinate is independent. -/
theorem axisTwistedCubic_selected_linearIndependent_of_card_le_three_of_containsCubic
    [CharP 𝔽 3] {S : Finset (AxisTwistedCubicIndex 𝔽)} (hcard : S.card ≤ 3)
    (hcubic : ∃ t, (.inl t : AxisTwistedCubicIndex 𝔽) ∈ S) :
    LinearIndependent 𝔽 (fun j : S => axisTwistedCubicPoints 𝔽 j) := by
  classical
  obtain ⟨t, ht⟩ := hcubic
  by_cases hle : S.card ≤ 2
  · exact axisTwistedCubic_selected_linearIndependent_of_card_le_two ⟨.inl t, ht⟩ hle
  · have h3 : S.card = 3 := by omega
    let e : Fin 3 ≃ S := (Finset.equivFinOfCardEq h3).symm
    have hemb : Function.Injective (fun i : Fin 3 => ((e i : S) : AxisTwistedCubicIndex 𝔽)) := by
      intro i j hij
      exact e.injective (Subtype.ext hij)
    have hecubic : ∃ i t, ((e i : S) : AxisTwistedCubicIndex 𝔽) = .inl t := by
      let p : S := ⟨.inl t, ht⟩
      exact ⟨e.symm p, t, congrArg Subtype.val (e.apply_symm_apply p)⟩
    apply (linearIndependent_equiv e).mp
    exact axisTwistedCubic_triple_linearIndependent_of_containsCubic hemb hecubic

/-- Complete bounded-radius repair hypergraph at a coordinate of `S_q`. -/
noncomputable def axisTwistedCubicRepairHypergraph
    (x : AxisTwistedCubicIndex 𝔽) (r : ℕ) :
    Finset (Finset (AxisTwistedCubicIndex 𝔽)) :=
  repairHypergraph (axisTwistedCubicCode (𝔽 := 𝔽)) x r

/-- Paper-facing inclusion-minimal repair clutter for `S_q`. -/
noncomputable def minimalAxisTwistedCubicRepairHypergraph
    (x : AxisTwistedCubicIndex 𝔽) (r : ℕ) :
    Finset (Finset (AxisTwistedCubicIndex 𝔽)) :=
  minimalRepairHypergraph (axisTwistedCubicCode (𝔽 := 𝔽)) x r

/-- Every actual repair edge gives a dependent target-plus-helper point family. -/
theorem axisTwistedCubicRepair_edge_dependent {x : AxisTwistedCubicIndex 𝔽} {r : ℕ}
    {R : Finset (AxisTwistedCubicIndex 𝔽)}
    (hR : R ∈ axisTwistedCubicRepairHypergraph x r) :
    ¬ LinearIndependent 𝔽
      (fun j : ↥(insert x R) => axisTwistedCubicPoints 𝔽 j) := by
  exact repair_edge_columns_dependent (G := axisTwistedCubicGenerator) hR

/-- Every repair edge of `S_q` is nonempty.  Unlike the generic dual-distance criterion, this
remains applicable at radius three even though the axis triples make the global dual distance
equal to three. -/
theorem axisTwistedCubicRepair_edge_nonempty {x : AxisTwistedCubicIndex 𝔽} {r : ℕ}
    {R : Finset (AxisTwistedCubicIndex 𝔽)}
    (hR : R ∈ axisTwistedCubicRepairHypergraph x r) : R.Nonempty := by
  rw [Finset.nonempty_iff_ne_empty]
  intro hR0
  apply axisTwistedCubicRepair_edge_dependent hR
  subst R
  simpa using
    (axisTwistedCubic_selected_linearIndependent_of_card_le_two
      (S := {x}) (Finset.singleton_nonempty x) (by simp))

/-- Clutter reduction preserves the matching number of the complete `S_q` repair hypergraph. -/
theorem matchingNumber_minimalAxisTwistedCubicRepairHypergraph
    (x : AxisTwistedCubicIndex 𝔽) (r : ℕ) :
    matchingNumber (minimalAxisTwistedCubicRepairHypergraph x r) =
      matchingNumber (axisTwistedCubicRepairHypergraph x r) := by
  apply matchingNumber_minimalHyperedges
  exact fun _ hR => axisTwistedCubicRepair_edge_nonempty hR

/-- Clutter reduction preserves the transversal number of the complete `S_q` repair
hypergraph. -/
theorem transversalNumber_minimalAxisTwistedCubicRepairHypergraph
    (x : AxisTwistedCubicIndex 𝔽) (r : ℕ) :
    transversalNumber (minimalAxisTwistedCubicRepairHypergraph x r) =
      transversalNumber (axisTwistedCubicRepairHypergraph x r) :=
  transversalNumber_minimalHyperedges _

/-- A radius-three cubic repair with two cubic helpers has the uniquely determined axis helper. -/
theorem cubicRepair_axis_eq_of_mem [CharP 𝔽 3] {x s t : 𝔽} {y : 𝔽 ⊕ Unit}
    (hxs : x ≠ s) (hxt : x ≠ t) (hst : s ≠ t)
    (hR : ({(.inl s : AxisTwistedCubicIndex 𝔽), .inl t, .inr y} :
      Finset (AxisTwistedCubicIndex 𝔽)) ∈
        axisTwistedCubicRepairHypergraph (.inl x) 3) :
    y = twistedCubicTripleAxisIndex ![x, s, t] := by
  classical
  let v : Fin 3 → 𝔽 := ![x, s, t]
  have hv : Function.Injective v := by
    intro i j hij
    fin_cases i <;> fin_cases j <;> simp_all [v]
  let e0 := fin4InsertTripleEquiv
    (.inl x : AxisTwistedCubicIndex 𝔽) (.inl s) (.inl t) (.inr y)
    (by simpa using hxs) (by simpa using hxt) (by simp)
    (by simpa using hst) (by simp) (by simp)
  let e : Fin 4 ≃ ↥(insert (.inl x)
      ({(.inl s : AxisTwistedCubicIndex 𝔽), .inl t, .inr y} :
        Finset (AxisTwistedCubicIndex 𝔽))) := by
    simpa only [Finset.insert_eq] using e0
  have hdet := repair_edge_reindexed_det_eq_zero
    (G := axisTwistedCubicGenerator) hR e
  cases y with
  | inl z =>
      have hmatrix :
          (fun i j => axisTwistedCubicGenerator i (e j)) =
            twistedCubicAxisCircuitMatrix v 1 z := by
        ext i j
        fin_cases j <;> fin_cases i <;>
          simp [e, e0, fin4InsertTripleEquiv, axisTwistedCubicGenerator,
            axisTwistedCubicPoints, twistedCubicAxisCircuitMatrix, v,
            momentCurve]
      rw [hmatrix] at hdet
      have hcross := (twistedCubicAxisCircuitMatrix_det_eq_zero_iff hv 1 z).mp hdet
      simp [v] at hcross
      have hsum : x + s + t ≠ 0 := by
        intro hsum0
        have hpair : x * s + x * t + s * t = 0 := by
          rw [hsum0, mul_zero] at hcross
          exact hcross
        exact (twistedCubicTripleAxis_coordinates_ne_zero hv).elim
          (fun h => h (by simpa [v] using hsum0))
          (fun h => h (by simpa [v] using hpair))
      rw [twistedCubicTripleAxisIndex, if_neg (by simpa [v] using hsum)]
      simp only [Sum.inl.injEq]
      exact (eq_div_iff hsum).2 hcross.symm
  | inr u =>
      have hmatrix :
          (fun i j => axisTwistedCubicGenerator i (e j)) =
            twistedCubicAxisCircuitMatrix v 0 1 := by
        ext i j
        fin_cases j <;> fin_cases i <;>
          simp [e, e0, fin4InsertTripleEquiv, axisTwistedCubicGenerator,
            axisTwistedCubicPoints, twistedCubicAxisCircuitMatrix, v,
            momentCurve]
      rw [hmatrix] at hdet
      have hcross := (twistedCubicAxisCircuitMatrix_det_eq_zero_iff hv 0 1).mp hdet
      simp [v] at hcross
      have hsum : x + s + t = 0 := hcross.symm
      rw [twistedCubicTripleAxisIndex, if_pos (by simpa [v] using hsum)]

/-- A convenient exclusion principle for a proposed three-helper repair whose four displayed
columns are independent. -/
theorem repairTriple_not_mem_of_linearIndependent
    {x a b c : AxisTwistedCubicIndex 𝔽}
    (hxa : x ≠ a) (hxb : x ≠ b) (hxc : x ≠ c)
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hli : LinearIndependent 𝔽 (fun i : Fin 4 =>
      axisTwistedCubicPoints 𝔽 (![x, a, b, c] i))) :
    ({a, b, c} : Finset (AxisTwistedCubicIndex 𝔽)) ∉
      axisTwistedCubicRepairHypergraph x 3 := by
  intro hR
  apply axisTwistedCubicRepair_edge_dependent hR
  let e0 := fin4InsertTripleEquiv x a b c hxa hxb hxc hab hac hbc
  let e : Fin 4 ≃ ↥(insert x ({a, b, c} :
      Finset (AxisTwistedCubicIndex 𝔽))) := by
    simpa only [Finset.insert_eq] using e0
  apply (linearIndependent_equiv e).mp
  convert hli using 1
  funext i
  fin_cases i <;> simp [e, e0, fin4InsertTripleEquiv]

/-- Four distinct cubic columns cannot supply a radius-three repair. -/
theorem cubicRepair_threeCubic_not_mem [CharP 𝔽 3] {x s t u : 𝔽}
    (hxs : x ≠ s) (hxt : x ≠ t) (hxu : x ≠ u)
    (hst : s ≠ t) (hsu : s ≠ u) (htu : t ≠ u) :
    ({(.inl s : AxisTwistedCubicIndex 𝔽), .inl t, .inl u} :
      Finset (AxisTwistedCubicIndex 𝔽)) ∉
        axisTwistedCubicRepairHypergraph (.inl x) 3 := by
  apply repairTriple_not_mem_of_linearIndependent
    (by simpa using hxs) (by simpa using hxt) (by simpa using hxu)
    (by simpa using hst) (by simpa using hsu) (by simpa using htu)
  let v : Fin 4 → 𝔽 := ![x, s, t, u]
  have hv : Function.Injective v := by
    intro i j hij
    fin_cases i <;> fin_cases j <;> simp_all [v]
  convert momentCurve_linearIndependent_of_card_le (n := 4) hv (by decide) using 1
  funext i
  fin_cases i <;> simp [v]

/-- Two cubic and two distinct axis columns cannot supply a cubic repair. -/
theorem cubicRepair_oneCubic_twoAxis_not_mem [CharP 𝔽 3]
    {x s : 𝔽} {y z : 𝔽 ⊕ Unit} (hxs : x ≠ s) (hyz : y ≠ z) :
    ({(.inl s : AxisTwistedCubicIndex 𝔽), .inr y, .inr z} :
      Finset (AxisTwistedCubicIndex 𝔽)) ∉
        axisTwistedCubicRepairHypergraph (.inl x) 3 := by
  apply repairTriple_not_mem_of_linearIndependent
    (by simpa using hxs) (by simp) (by simp) (by simp) (by simp) (by simpa using hyz)
  convert twoCubicTwoAxis_linearIndependent (𝔽 := 𝔽) hxs hyz using 1
  funext i
  fin_cases i <;> simp [twoCubicTwoAxisFamily]

/-- No cubic coordinate has a repair edge with at most two helpers. -/
theorem cubicCoordinate_no_repairEdge_radius_two [CharP 𝔽 3] (x : 𝔽)
    (R : Finset (AxisTwistedCubicIndex 𝔽)) :
    R ∉ axisTwistedCubicRepairHypergraph (.inl x) 2 := by
  intro hR
  apply axisTwistedCubicRepair_edge_dependent hR
  obtain ⟨hsub, hcard, -⟩ := mem_repairHypergraph.mp hR
  have hxR : (.inl x : AxisTwistedCubicIndex 𝔽) ∉ R := by
    intro hx
    exact (Finset.mem_erase.mp (hsub hx)).1 rfl
  apply axisTwistedCubic_selected_linearIndependent_of_card_le_three_of_containsCubic
  · rw [Finset.card_insert_of_notMem hxR]
    omega
  · exact ⟨x, Finset.mem_insert_self _ _⟩

/-- No axis coordinate has a repair edge with at most one helper. -/
theorem axisCoordinate_no_repairEdge_radius_one (y : 𝔽 ⊕ Unit)
    (R : Finset (AxisTwistedCubicIndex 𝔽)) :
    R ∉ axisTwistedCubicRepairHypergraph (.inr y) 1 := by
  intro hR
  apply axisTwistedCubicRepair_edge_dependent hR
  obtain ⟨hsub, hcard, -⟩ := mem_repairHypergraph.mp hR
  have hyR : (.inr y : AxisTwistedCubicIndex 𝔽) ∉ R := by
    intro hy
    exact (Finset.mem_erase.mp (hsub hy)).1 rfl
  apply axisTwistedCubic_selected_linearIndependent_of_card_le_two
  · exact ⟨.inr y, Finset.mem_insert_self _ _⟩
  · rw [Finset.card_insert_of_notMem hyR]
    omega

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

/-- Cubic coordinates have exact locality three. -/
theorem cubicCoordinate_exact_locality_three [CharP 𝔽 3] (x : 𝔽) :
    (∃ R, R ∈ axisTwistedCubicRepairHypergraph (.inl x) 3) ∧
      (∀ R, R ∉ axisTwistedCubicRepairHypergraph (.inl x) 2) :=
  ⟨cubicCoordinate_has_repairEdge x, cubicCoordinate_no_repairEdge_radius_two x⟩

/-- Axis coordinates have exact locality two. -/
theorem axisCoordinate_exact_locality_two (y : 𝔽 ⊕ Unit) :
    (∃ R, R ∈ axisTwistedCubicRepairHypergraph (.inr y) 2) ∧
      (∀ R, R ∉ axisTwistedCubicRepairHypergraph (.inr y) 1) :=
  ⟨axisCoordinate_has_repairEdge y, axisCoordinate_no_repairEdge_radius_one y⟩

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
#print axioms cubicCoordinate_exact_locality_three
#print axioms axisCoordinate_exact_locality_two
#print axioms matchingNumber_minimalAxisTwistedCubicRepairHypergraph
#print axioms transversalNumber_minimalAxisTwistedCubicRepairHypergraph
#print axioms cubicRepair_axis_eq_of_mem
#print axioms cubicRepair_threeCubic_not_mem
#print axioms cubicRepair_oneCubic_twoAxis_not_mem

end RepairCodes
