import RepairCodes.AxisTwistedCubic
import FiniteGeom.ProjectiveAxisTwistedCubic
import FiniteGeom.ProjectiveAxisTwistedCubicCircuits

/-!
# Code and dual-distance layer for the projectively completed cubic–axis seed

This module packages the completed point system as a row code, proves that distinct columns are
projectively distinct via pairwise linear independence, and proves exact global dual distance
three.  The upper bound is witnessed by the explicit relation among axis points at `0`, `1`, and
infinity.
-/

namespace RepairCodes

open Finset Matrix FiniteGeom

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- Generator matrix whose columns are the completed cubic–axis points. -/
def projectiveAxisTwistedCubicGenerator :
    Matrix (Fin 4) (ProjectiveAxisTwistedCubicIndex 𝔽) 𝔽 :=
  fun i j => projectiveAxisTwistedCubicPoints 𝔽 j i

omit [Fintype 𝔽] [DecidableEq 𝔽] in
@[simp] theorem projectiveAxisTwistedCubicGenerator_col
    (j : ProjectiveAxisTwistedCubicIndex 𝔽) :
    (projectiveAxisTwistedCubicGenerator (𝔽 := 𝔽)).col j =
      projectiveAxisTwistedCubicPoints 𝔽 j := rfl

/-- The completed seed as a row code. -/
def projectiveAxisTwistedCubicCode :
    Submodule 𝔽 (ProjectiveAxisTwistedCubicIndex 𝔽 → 𝔽) :=
  rowCode (projectiveAxisTwistedCubicGenerator (𝔽 := 𝔽))

omit [Fintype 𝔽] [DecidableEq 𝔽] in
theorem projectiveAxisTwistedCubicCode_eq_columnCode :
    projectiveAxisTwistedCubicCode (𝔽 := 𝔽) =
      columnCode (projectiveAxisTwistedCubicPoints 𝔽) := by
  rw [projectiveAxisTwistedCubicCode, rowCode, columnCode, Matrix.range_mulVecLin]
  rfl

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Every completed-system column is nonzero. -/
theorem projectiveAxisTwistedCubicPoints_ne_zero
    (x : ProjectiveAxisTwistedCubicIndex 𝔽) :
    projectiveAxisTwistedCubicPoints 𝔽 x ≠ 0 := by
  cases x with
  | inl x =>
      cases x with
      | inl t =>
          intro h
          have h0 := congrFun h 0
          simp at h0
      | inr u =>
          intro h
          have h3 := congrFun h 3
          simp at h3
  | inr y =>
      simpa only [projectiveAxisTwistedCubicPoints_axis] using
        axisTwistedCubicPoints_ne_zero (𝔽 := 𝔽) (.inr y)

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem finiteCubic_infinity_pair_linearIndependent (s : 𝔽) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 (.inl s),
      projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit)] := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  have h0 := congrFun hrel (0 : Fin 4)
  have h3 := congrFun hrel (3 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h0 h3
  simp [Fin.sum_univ_two, projectiveTwistedCubicPoints, momentCurve] at h0 h3
  have hg0 : g 0 = 0 := h0
  have hg1 : g 1 = 0 := by simpa [hg0] using h3
  intro i
  fin_cases i <;> assumption

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem projectiveCubic_pair_linearIndependent
    {x y : ProjectiveTwistedCubicIndex 𝔽} (hxy : x ≠ y) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 x,
      projectiveTwistedCubicPoints 𝔽 y] := by
  cases x with
  | inl s =>
      cases y with
      | inl t =>
          have hst : s ≠ t := fun h => hxy (congrArg Sum.inl h)
          convert (momentCurve_linearIndependent_of_card_le (n := 4) (v := ![s, t])
            (by intro i j hij; fin_cases i <;> fin_cases j <;> simp_all)
            (by decide)) using 1
          funext i
          fin_cases i <;> simp
      | inr u =>
          simpa using finiteCubic_infinity_pair_linearIndependent (𝔽 := 𝔽) s
  | inr u =>
      cases y with
      | inl t =>
          have hli := finiteCubic_infinity_pair_linearIndependent (𝔽 := 𝔽) t
          have hs0 : Equiv.swap (0 : Fin 2) 1 0 = 1 := by decide
          have hs1 : Equiv.swap (0 : Fin 2) 1 1 = 0 := by decide
          exact (linearIndependent_equiv' (Equiv.swap 0 1) (by
            funext i
            fin_cases i <;> simp [hs0, hs1])).2 hli
      | inr v => exact (hxy (by congr)).elim

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem cubicInfinity_axis_pair_linearIndependent (y : 𝔽 ⊕ Unit) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit),
      axisTwistedCubicPoints 𝔽 (.inr y)] := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  have h3 := congrFun hrel (3 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h3
  simp [Fin.sum_univ_two, projectiveTwistedCubicPoints] at h3
  have hg0 : g 0 = 0 := h3
  cases y with
  | inl y =>
      have h1 := congrFun hrel (1 : Fin 4)
      simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h1
      simp [Fin.sum_univ_two, projectiveTwistedCubicPoints, hg0] at h1
      intro i
      fin_cases i <;> assumption
  | inr y =>
      have h2 := congrFun hrel (2 : Fin 4)
      simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h2
      simp [Fin.sum_univ_two, projectiveTwistedCubicPoints, hg0] at h2
      intro i
      fin_cases i <;> assumption

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem projectiveCubic_axis_pair_linearIndependent
    (x : ProjectiveTwistedCubicIndex 𝔽) (y : 𝔽 ⊕ Unit) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 x,
      axisTwistedCubicPoints 𝔽 (.inr y)] := by
  cases x with
  | inl s => simpa using cubicAxis_pair_linearIndependent (𝔽 := 𝔽) s y
  | inr u => simpa using cubicInfinity_axis_pair_linearIndependent (𝔽 := 𝔽) y

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Any two distinctly indexed completed-system columns are linearly independent.  In particular,
the columns are nonzero and represent distinct projective points. -/
theorem projectiveAxisTwistedCubic_pair_linearIndependent
    {u : Fin 2 → ProjectiveAxisTwistedCubicIndex 𝔽} (hu : Function.Injective u) :
    LinearIndependent 𝔽 (fun i => projectiveAxisTwistedCubicPoints 𝔽 (u i)) := by
  have h01 : u 0 ≠ u 1 := hu.ne (by decide)
  rcases h0 : u 0 with x | y <;> rcases h1 : u 1 with z | w
  · have hxz : x ≠ z := fun h => h01 (by rw [h0, h1, h])
    convert projectiveCubic_pair_linearIndependent (𝔽 := 𝔽) hxz using 1
    funext i
    fin_cases i <;> simp [h0, h1]
  · convert projectiveCubic_axis_pair_linearIndependent (𝔽 := 𝔽) x w using 1
    funext i
    fin_cases i <;> simp [h0, h1]
  · have hli := projectiveCubic_axis_pair_linearIndependent (𝔽 := 𝔽) z y
    have hs0 : Equiv.swap (0 : Fin 2) 1 0 = 1 := by decide
    have hs1 : Equiv.swap (0 : Fin 2) 1 1 = 0 := by decide
    exact (linearIndependent_equiv' (Equiv.swap 0 1) (by
      funext i
      fin_cases i <;> simp [hs0, hs1, h0, h1])).2 hli
  · have hyw : y ≠ w := fun h => h01 (by rw [h0, h1, h])
    convert twistedCubicAxis_pair_linearIndependent (𝔽 := 𝔽) hyw using 1
    funext i
    fin_cases i <;> simp [h0, h1]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Every nonempty selected family of at most two completed columns is independent. -/
theorem projectiveAxisTwistedCubic_selected_linearIndependent_of_card_le_two
    {S : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)} (hne : S.Nonempty)
    (hcard : S.card ≤ 2) :
    LinearIndependent 𝔽 (fun j : S => projectiveAxisTwistedCubicPoints 𝔽 j) := by
  classical
  have hcases : S.card = 1 ∨ S.card = 2 := by
    have := Finset.card_pos.mpr hne
    omega
  rcases hcases with h1 | h2
  · let e : Fin 1 ≃ S := (Finset.equivFinOfCardEq h1).symm
    apply (linearIndependent_equiv e).mp
    rw [linearIndependent_unique_iff]
    exact projectiveAxisTwistedCubicPoints_ne_zero
      (((e 0 : S) : ProjectiveAxisTwistedCubicIndex 𝔽))
  · let e : Fin 2 ≃ S := (Finset.equivFinOfCardEq h2).symm
    have hemb : Function.Injective
        (fun i : Fin 2 => ((e i : S) : ProjectiveAxisTwistedCubicIndex 𝔽)) := by
      intro i j hij
      exact e.injective (Subtype.ext hij)
    apply (linearIndependent_equiv e).mp
    exact projectiveAxisTwistedCubic_pair_linearIndependent hemb

/-- The explicit weight-three dual word supported on the axis points `0`, `1`, and infinity. -/
def projectiveAxisTripleDualWord : ProjectiveAxisTwistedCubicIndex 𝔽 → 𝔽 :=
  Pi.single (.inr (.inl 0)) 1 +
    Pi.single (.inr (.inl 1)) (-1) +
    Pi.single (.inr (.inr Unit.unit)) 1

private theorem projectiveAxisTripleDualWord_axis_coord_one_sum :
    (∑ x : 𝔽, ((if x = 0 then (1 : 𝔽) else 0) + if x = 1 then -1 else 0)) = 0 := by
  rw [Finset.sum_add_distrib, Fintype.sum_ite_eq', Fintype.sum_ite_eq']
  simp

private theorem projectiveAxisTripleDualWord_axis_coord_two_sum :
    (∑ x : 𝔽, x * ((if x = 0 then 1 else 0) + if x = 1 then -1 else 0)) + 1 = 0 := by
  simp_rw [mul_add, mul_ite, mul_zero]
  rw [Finset.sum_add_distrib, Fintype.sum_ite_eq', Fintype.sum_ite_eq']
  simp

theorem projectiveAxisTripleDualWord_mem :
    projectiveAxisTripleDualWord (𝔽 := 𝔽) ∈
      dualCode (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) := by
  rw [projectiveAxisTwistedCubicCode, mem_dualCode_rowCode]
  intro i
  fin_cases i
  · simp [projectiveAxisTripleDualWord, projectiveAxisTwistedCubicGenerator,
      dotProduct, Fintype.sum_sum_type, projectiveAxisTwistedCubicPoints,
      projectiveTwistedCubicPoints, axisTwistedCubicPoints, Pi.single_apply]
  · simpa [projectiveAxisTripleDualWord, projectiveAxisTwistedCubicGenerator,
      dotProduct, Fintype.sum_sum_type, projectiveAxisTwistedCubicPoints,
      projectiveTwistedCubicPoints, axisTwistedCubicPoints, Pi.single_apply] using
        (projectiveAxisTripleDualWord_axis_coord_one_sum (𝔽 := 𝔽))
  · simpa [projectiveAxisTripleDualWord, projectiveAxisTwistedCubicGenerator,
      dotProduct, Fintype.sum_sum_type, projectiveAxisTwistedCubicPoints,
      projectiveTwistedCubicPoints, axisTwistedCubicPoints, Pi.single_apply] using
        (projectiveAxisTripleDualWord_axis_coord_two_sum (𝔽 := 𝔽))
  · simp [projectiveAxisTripleDualWord, projectiveAxisTwistedCubicGenerator,
      dotProduct, Fintype.sum_sum_type, projectiveAxisTwistedCubicPoints,
      projectiveTwistedCubicPoints, axisTwistedCubicPoints, Pi.single_apply]

theorem projectiveAxisTripleDualWord_support :
    wordSupport (projectiveAxisTripleDualWord (𝔽 := 𝔽)) =
      {(.inr (.inl 0) : ProjectiveAxisTwistedCubicIndex 𝔽),
        .inr (.inl 1), .inr (.inr Unit.unit)} := by
  ext x
  rcases x with (x | y)
  · rcases x with (x | u) <;> simp [wordSupport, projectiveAxisTripleDualWord]
  · rcases y with (y | u)
    · by_cases hy0 : y = 0
      · subst y
        simp [wordSupport, projectiveAxisTripleDualWord]
      · by_cases hy1 : y = 1
        · subst y
          simp [wordSupport, projectiveAxisTripleDualWord]
        · simp [wordSupport, projectiveAxisTripleDualWord, hy0, hy1]
    · simp [wordSupport, projectiveAxisTripleDualWord]

theorem projectiveAxisTripleDualWord_hammingNorm :
    hammingNorm (projectiveAxisTripleDualWord (𝔽 := 𝔽)) = 3 := by
  rw [← card_wordSupport, projectiveAxisTripleDualWord_support]
  simp

/-- The completed seed has exact global dual distance three. -/
theorem projectiveAxisTwistedCubicCode_dualDist [CharP 𝔽 3] :
    dualDist (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) = 3 := by
  have hy := projectiveAxisTripleDualWord_mem (𝔽 := 𝔽)
  have hy0 : projectiveAxisTripleDualWord (𝔽 := 𝔽) ≠ 0 := by
    intro h
    have h0 := congrFun h (.inr (.inl 0))
    simp [projectiveAxisTripleDualWord] at h0
  have hdual : dualCode (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) ≠ ⊥ :=
    (Submodule.ne_bot_iff _).mpr ⟨projectiveAxisTripleDualWord, hy, hy0⟩
  have hlower : 3 ≤ dualDist (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) := by
    apply le_dualDist_rowCode_of_column_independent projectiveAxisTwistedCubicGenerator 3
    · simpa only [projectiveAxisTwistedCubicCode] using hdual
    · intro S hScard
      by_cases hS : S.Nonempty
      · simpa only [projectiveAxisTwistedCubicGenerator_col] using
          projectiveAxisTwistedCubic_selected_linearIndependent_of_card_le_two hS (by omega)
      · rw [Finset.not_nonempty_iff_eq_empty.mp hS]
        exact linearIndependent_empty_type
  have hupper := dualDist_le_hammingNorm hy hy0
  rw [projectiveAxisTripleDualWord_hammingNorm] at hupper
  omega

/-- Complete bounded-radius repair hypergraph of the projectively completed seed. -/
noncomputable def projectiveAxisTwistedCubicRepairHypergraph
    (x : ProjectiveAxisTwistedCubicIndex 𝔽) (r : ℕ) :
    Finset (Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) :=
  repairHypergraph (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) x r

/-- Inclusion-minimal bounded repair clutter of the projectively completed seed. -/
noncomputable def minimalProjectiveAxisTwistedCubicRepairHypergraph
    (x : ProjectiveAxisTwistedCubicIndex 𝔽) (r : ℕ) :
    Finset (Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) :=
  minimalRepairHypergraph (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) x r

theorem projectiveAxisTwistedCubicRepair_edge_dependent
    {x : ProjectiveAxisTwistedCubicIndex 𝔽} {r : ℕ}
    {R : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)}
    (hR : R ∈ projectiveAxisTwistedCubicRepairHypergraph x r) :
    ¬ LinearIndependent 𝔽
      (fun j : ↥(insert x R) => projectiveAxisTwistedCubicPoints 𝔽 j) := by
  exact repair_edge_columns_dependent (G := projectiveAxisTwistedCubicGenerator) hR

theorem projectiveAxisTwistedCubicRepair_edge_nonempty
    {x : ProjectiveAxisTwistedCubicIndex 𝔽} {r : ℕ}
    {R : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)}
    (hR : R ∈ projectiveAxisTwistedCubicRepairHypergraph x r) : R.Nonempty := by
  rw [Finset.nonempty_iff_ne_empty]
  intro hR0
  apply projectiveAxisTwistedCubicRepair_edge_dependent hR
  subst R
  simpa using projectiveAxisTwistedCubic_selected_linearIndependent_of_card_le_two
    (S := {x}) (Finset.singleton_nonempty x) (by simp)

theorem matchingNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph
    (x : ProjectiveAxisTwistedCubicIndex 𝔽) (r : ℕ) :
    matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph x r) =
      matchingNumber (projectiveAxisTwistedCubicRepairHypergraph x r) := by
  apply matchingNumber_minimalHyperedges
  exact fun _ hR => projectiveAxisTwistedCubicRepair_edge_nonempty hR

theorem transversalNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph
    (x : ProjectiveAxisTwistedCubicIndex 𝔽) (r : ℕ) :
    transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph x r) =
      transversalNumber (projectiveAxisTwistedCubicRepairHypergraph x r) :=
  transversalNumber_minimalHyperedges _

/-- Every target-plus-helper circuit is an actual completed-seed repair edge. -/
theorem projectiveAxisTwistedCubic_circuit_mem_repair
    {x : ProjectiveAxisTwistedCubicIndex 𝔽} {r : ℕ}
    {R : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)}
    (hsub : R ⊆ univ.erase x) (hcard : R.card = r)
    (hdep : ¬ LinearIndependent 𝔽
      (fun j : ↥(insert x R) => projectiveAxisTwistedCubicPoints 𝔽 j))
    (hdelete : ∀ j : ↥(insert x R),
      LinearIndependent 𝔽
        (fun i : {i : ↥(insert x R) // i ≠ j} => projectiveAxisTwistedCubicPoints 𝔽 i)) :
    R ∈ projectiveAxisTwistedCubicRepairHypergraph x r := by
  exact mem_repairHypergraph_of_circuit (G := projectiveAxisTwistedCubicGenerator)
    hsub hcard hdep hdelete

#print axioms projectiveAxisTwistedCubicCode_eq_columnCode
#print axioms projectiveAxisTwistedCubic_pair_linearIndependent
#print axioms projectiveAxisTripleDualWord_mem
#print axioms projectiveAxisTwistedCubicCode_dualDist
#print axioms projectiveAxisTwistedCubic_circuit_mem_repair

end RepairCodes
