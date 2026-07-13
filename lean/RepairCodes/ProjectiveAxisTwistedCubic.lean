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

/-- The three helpers supplied by a finite cubic triple in the completed seed. -/
noncomputable def projectiveFiniteCubicTripleRepairHelpers (v : Fin 3 → 𝔽) :
    Finset (ProjectiveAxisTwistedCubicIndex 𝔽) :=
  { .inl (.inl (v 1)), .inl (.inl (v 2)), .inr (twistedCubicTripleAxisIndex v) }

/-- Ordered target-plus-helper family for a finite cubic triple in the completed seed. -/
noncomputable def projectiveFiniteCubicTripleIndexFamily (v : Fin 3 → 𝔽) :
    Fin 4 → ProjectiveAxisTwistedCubicIndex 𝔽 :=
  ![.inl (.inl (v 0)), .inl (.inl (v 1)), .inl (.inl (v 2)),
    .inr (twistedCubicTripleAxisIndex v)]

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

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem linearIndependent_vec3_swap01
    {a b c : Fin 4 → 𝔽} (h : LinearIndependent 𝔽 ![a, b, c]) :
    LinearIndependent 𝔽 ![b, a, c] := by
  have hs₀ : Equiv.swap (0 : Fin 3) 1 0 = 1 := by decide
  have hs₁ : Equiv.swap (0 : Fin 3) 1 1 = 0 := by decide
  have hs₂ : Equiv.swap (0 : Fin 3) 1 2 = 2 := by decide
  convert h.comp (Equiv.swap 0 1) (Equiv.swap 0 1).injective using 1
  funext i
  fin_cases i <;> simp [hs₀, hs₁, hs₂]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem linearIndependent_vec3_swap12
    {a b c : Fin 4 → 𝔽} (h : LinearIndependent 𝔽 ![a, b, c]) :
    LinearIndependent 𝔽 ![a, c, b] := by
  have hs₀ : Equiv.swap (1 : Fin 3) 2 0 = 0 := by decide
  have hs₁ : Equiv.swap (1 : Fin 3) 2 1 = 2 := by decide
  have hs₂ : Equiv.swap (1 : Fin 3) 2 2 = 1 := by decide
  convert h.comp (Equiv.swap 1 2) (Equiv.swap 1 2).injective using 1
  funext i
  fin_cases i <;> simp [hs₀, hs₁, hs₂]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem linearIndependent_vec4_swap01
    {a b c d : Fin 4 → 𝔽} (h : LinearIndependent 𝔽 ![a, b, c, d]) :
    LinearIndependent 𝔽 ![b, a, c, d] := by
  have hs₀ : Equiv.swap (0 : Fin 4) 1 0 = 1 := by decide
  have hs₁ : Equiv.swap (0 : Fin 4) 1 1 = 0 := by decide
  have hs₂ : Equiv.swap (0 : Fin 4) 1 2 = 2 := by decide
  have hs₃ : Equiv.swap (0 : Fin 4) 1 3 = 3 := by decide
  convert h.comp (Equiv.swap (0 : Fin 4) 1) (Equiv.swap 0 1).injective using 1
  funext i
  fin_cases i <;> simp [hs₀, hs₁, hs₂, hs₃]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem linearIndependent_vec4_swap12
    {a b c d : Fin 4 → 𝔽} (h : LinearIndependent 𝔽 ![a, b, c, d]) :
    LinearIndependent 𝔽 ![a, c, b, d] := by
  have hs₀ : Equiv.swap (1 : Fin 4) 2 0 = 0 := by decide
  have hs₁ : Equiv.swap (1 : Fin 4) 2 1 = 2 := by decide
  have hs₂ : Equiv.swap (1 : Fin 4) 2 2 = 1 := by decide
  have hs₃ : Equiv.swap (1 : Fin 4) 2 3 = 3 := by decide
  convert h.comp (Equiv.swap (1 : Fin 4) 2) (Equiv.swap 1 2).injective using 1
  funext i
  fin_cases i <;> simp [hs₀, hs₁, hs₂, hs₃]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
private theorem linearIndependent_vec4_swap23
    {a b c d : Fin 4 → 𝔽} (h : LinearIndependent 𝔽 ![a, b, c, d]) :
    LinearIndependent 𝔽 ![a, b, d, c] := by
  have hs₀ : Equiv.swap (2 : Fin 4) 3 0 = 0 := by decide
  have hs₁ : Equiv.swap (2 : Fin 4) 3 1 = 1 := by decide
  have hs₂ : Equiv.swap (2 : Fin 4) 3 2 = 3 := by decide
  have hs₃ : Equiv.swap (2 : Fin 4) 3 3 = 2 := by decide
  convert h.comp (Equiv.swap (2 : Fin 4) 3) (Equiv.swap 2 3).injective using 1
  funext i
  fin_cases i <;> simp [hs₀, hs₁, hs₂, hs₃]

/-- Explicit enumeration of a four-element support. -/
private noncomputable def projectiveFin4Equiv {a b c d :
    ProjectiveAxisTwistedCubicIndex 𝔽}
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d) :
    Fin 4 ≃ ↥({a, b, c, d} : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) := by
  let f : Fin 4 → ↥({a, b, c, d} : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) :=
    fun i => ⟨![a, b, c, d] i, by fin_cases i <;> simp⟩
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

/-- The order-preserving enumeration of a finite type with one `Fin` index deleted. -/
private noncomputable def projectiveFinEraseEquiv {n : ℕ} (j : Fin (n + 1)) :
    Fin n ≃ {i : Fin (n + 1) // i ≠ j} := by
  let f : Fin n → {i : Fin (n + 1) // i ≠ j} :=
    fun i => ⟨j.succAbove i, j.succAbove_ne i⟩
  apply Equiv.ofBijective f
  rw [Fintype.bijective_iff_injective_and_card]
  refine ⟨?_, ?_⟩
  · intro a b hab
    exact Fin.succAbove_right_injective (congrArg Subtype.val hab)
  · rw [Fintype.card_subtype_compl (fun i : Fin (n + 1) => i = j)]
    simp

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Every injectively indexed completed triple containing a cubic coordinate is independent. -/
theorem projectiveAxisTwistedCubic_triple_linearIndependent_of_containsCubic [CharP 𝔽 3]
    {u : Fin 3 → ProjectiveAxisTwistedCubicIndex 𝔽} (hu : Function.Injective u)
    (hcubic : ∃ i x, u i = .inl x) :
    LinearIndependent 𝔽 (fun i => projectiveAxisTwistedCubicPoints 𝔽 (u i)) := by
  rcases h₀ : u 0 with x | a <;> rcases h₁ : u 1 with y | b <;>
    rcases h₂ : u 2 with z | c
  · let v : Fin 3 → ProjectiveTwistedCubicIndex 𝔽 := ![x, y, z]
    have hv : Function.Injective v := by
      intro i j hij
      apply hu
      fin_cases i <;> fin_cases j <;> simp_all [v]
    convert projectiveTwistedCubic_triple_linearIndependent hv using 1
    funext i
    fin_cases i <;> simp [h₀, h₁, h₂, v]
  · have hxy : x ≠ y := by
      intro h
      apply hu.ne (show (0 : Fin 3) ≠ 1 by decide)
      rw [h₀, h₁, h]
    convert projectiveTwoCubicAxis_linearIndependent hxy c using 1
    funext i
    fin_cases i <;> simp [h₀, h₁, h₂]
  · have hxz : x ≠ z := by
      intro h
      apply hu.ne (show (0 : Fin 3) ≠ 2 by decide)
      rw [h₀, h₂, h]
    have hli := projectiveTwoCubicAxis_linearIndependent hxz b
    convert linearIndependent_vec3_swap12 hli using 1
    funext i
    fin_cases i <;> simp [h₀, h₁, h₂]
  · have hbc : b ≠ c := by
      intro h
      apply hu.ne (show (1 : Fin 3) ≠ 2 by decide)
      rw [h₁, h₂, h]
    convert projectiveOneCubicTwoAxis_linearIndependent x hbc using 1
    funext i
    fin_cases i <;> simp [h₀, h₁, h₂]
  · have hyz : y ≠ z := by
      intro h
      apply hu.ne (show (1 : Fin 3) ≠ 2 by decide)
      rw [h₁, h₂, h]
    have hli := projectiveTwoCubicAxis_linearIndependent hyz a
    have hli' := linearIndependent_vec3_swap12 hli
    convert linearIndependent_vec3_swap01 hli' using 1
    funext i
    fin_cases i <;> simp [h₀, h₁, h₂]
  · have hac : a ≠ c := by
      intro h
      apply hu.ne (show (0 : Fin 3) ≠ 2 by decide)
      rw [h₀, h₂, h]
    have hli := projectiveOneCubicTwoAxis_linearIndependent y hac
    convert linearIndependent_vec3_swap01 hli using 1
    funext i
    fin_cases i <;> simp [h₀, h₁, h₂]
  · have hab : a ≠ b := by
      intro h
      apply hu.ne (show (0 : Fin 3) ≠ 1 by decide)
      rw [h₀, h₁, h]
    have hli := projectiveOneCubicTwoAxis_linearIndependent z hab
    have hli' := linearIndependent_vec3_swap01 hli
    convert linearIndependent_vec3_swap12 hli' using 1
    funext i
    fin_cases i <;> simp [h₀, h₁, h₂]
  · obtain ⟨i, x, hx⟩ := hcubic
    fin_cases i <;> simp [h₀, h₁, h₂] at hx

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Every selected family of at most three completed columns that contains a cubic coordinate is
independent. -/
theorem projectiveAxisTwistedCubic_selected_linearIndependent_of_card_le_three_of_containsCubic
    [CharP 𝔽 3] {S : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)} (hcard : S.card ≤ 3)
    (hcubic : ∃ x, (.inl x : ProjectiveAxisTwistedCubicIndex 𝔽) ∈ S) :
    LinearIndependent 𝔽 (fun j : S => projectiveAxisTwistedCubicPoints 𝔽 j) := by
  classical
  obtain ⟨x, hx⟩ := hcubic
  by_cases hle : S.card ≤ 2
  · exact projectiveAxisTwistedCubic_selected_linearIndependent_of_card_le_two ⟨.inl x, hx⟩ hle
  · have h₃ : S.card = 3 := by omega
    let e : Fin 3 ≃ S := (Finset.equivFinOfCardEq h₃).symm
    have hemb : Function.Injective
        (fun i : Fin 3 => ((e i : S) : ProjectiveAxisTwistedCubicIndex 𝔽)) := by
      intro i j hij
      exact e.injective (Subtype.ext hij)
    have hecubic : ∃ i y,
        ((e i : S) : ProjectiveAxisTwistedCubicIndex 𝔽) = .inl y := by
      let p : S := ⟨.inl x, hx⟩
      exact ⟨e.symm p, x, congrArg Subtype.val (e.apply_symm_apply p)⟩
    apply (linearIndependent_equiv e).mp
    exact projectiveAxisTwistedCubic_triple_linearIndependent_of_containsCubic hemb hecubic

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

/-- Three distinct finite cubic parameters give an actual locality-three repair edge in the
completed seed: the other two cubic points and their normalized axis completion. -/
theorem projectiveFiniteCubicTripleRepairHelpers_mem [CharP 𝔽 3]
    {v : Fin 3 → 𝔽} (hv : Function.Injective v) :
    projectiveFiniteCubicTripleRepairHelpers v ∈
      projectiveAxisTwistedCubicRepairHypergraph (.inl (.inl (v 0))) 3 := by
  classical
  let f : Fin 4 → ↥(insert (.inl (.inl (v 0)))
      (projectiveFiniteCubicTripleRepairHelpers v)) := fun i =>
    ⟨projectiveFiniteCubicTripleIndexFamily v i, by
      fin_cases i <;>
        simp [projectiveFiniteCubicTripleIndexFamily,
          projectiveFiniteCubicTripleRepairHelpers]⟩
  have h01 : v 0 ≠ v 1 := hv.ne (by decide)
  have h02 : v 0 ≠ v 2 := hv.ne (by decide)
  have h12 : v 1 ≠ v 2 := hv.ne (by decide)
  have hf : Function.Injective f := by
    intro i j hij
    apply Fin.ext
    fin_cases i <;> fin_cases j <;>
      simp_all [f, projectiveFiniteCubicTripleIndexFamily]
  have hfsurj : Function.Surjective f := by
    intro y
    rcases y with ⟨y, hy⟩
    have hy' : y = .inl (.inl (v 0)) ∨ y = .inl (.inl (v 1)) ∨
        y = .inl (.inl (v 2)) ∨ y = .inr (twistedCubicTripleAxisIndex v) := by
      simpa [projectiveFiniteCubicTripleRepairHelpers] using hy
    rcases hy' with hy' | hy' | hy' | hy' <;> subst y
    · exact ⟨0, by ext; simp [f, projectiveFiniteCubicTripleIndexFamily]⟩
    · exact ⟨1, by ext; simp [f, projectiveFiniteCubicTripleIndexFamily]⟩
    · exact ⟨2, by ext; simp [f, projectiveFiniteCubicTripleIndexFamily]⟩
    · exact ⟨3, by ext; simp [f, projectiveFiniteCubicTripleIndexFamily]⟩
  let e : Fin 4 ≃ ↥(insert (.inl (.inl (v 0)))
      (projectiveFiniteCubicTripleRepairHelpers v)) :=
    Equiv.ofBijective f ⟨hf, hfsurj⟩
  have hsub : projectiveFiniteCubicTripleRepairHelpers v ⊆
      univ.erase (.inl (.inl (v 0))) := by
    intro y hy
    rw [Finset.mem_erase]
    refine ⟨?_, Finset.mem_univ y⟩
    intro hy0
    subst y
    simp [projectiveFiniteCubicTripleRepairHelpers, h01, h02] at hy
  have hcard : (projectiveFiniteCubicTripleRepairHelpers v).card = 3 := by
    simp [projectiveFiniteCubicTripleRepairHelpers, h12]
  have hefamily :
      (fun i : Fin 4 => (projectiveAxisTwistedCubicGenerator (𝔽 := 𝔽)).col (e i)) =
        twistedCubicTripleFamily v := by
    funext i
    fin_cases i <;>
      simp [e, f, projectiveFiniteCubicTripleIndexFamily,
        projectiveAxisTwistedCubicPoints, projectiveTwistedCubicPoints]
  have htransport (j : Fin 4)
      (hli : LinearIndependent 𝔽 (fun a : Fin 3 =>
        twistedCubicTripleFamily v (j.succAbove a))) :
      LinearIndependent 𝔽
        (fun i : {i : Fin 4 // i ≠ j} => twistedCubicTripleFamily v i) := by
    let ej := projectiveFinEraseEquiv j
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
        (projectiveAxisTwistedCubicGenerator (𝔽 := 𝔽)).col (e i)) := by
    intro j
    rw [show (fun i : {i : Fin 4 // i ≠ j} =>
        (projectiveAxisTwistedCubicGenerator (𝔽 := 𝔽)).col (e i)) =
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
    (G := projectiveAxisTwistedCubicGenerator) hsub hcard e
  · rw [hefamily]
    exact twistedCubicTripleFamily_dependent v
  · exact hdelete

/-- The projective-boundary four-circuit gives an actual repair of cubic infinity from two
distinct finite cubic points and the finite axis point `s+t`. -/
theorem projectiveCubicInfinityRepairHelpers_mem [CharP 𝔽 3]
    {s t : 𝔽} (hst : s ≠ t) :
    ({(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽), .inl (.inl t),
        .inr (.inl (s + t))} : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) ∈
      projectiveAxisTwistedCubicRepairHypergraph (.inl (.inr Unit.unit)) 3 := by
  classical
  let R : Finset (ProjectiveAxisTwistedCubicIndex 𝔽) :=
    { .inl (.inl s), .inl (.inl t), .inr (.inl (s + t)) }
  let f : Fin 4 → ↥(insert (.inl (.inr Unit.unit)) R) := fun i =>
    ⟨![.inl (.inl s), .inl (.inl t), .inl (.inr Unit.unit),
      .inr (.inl (s + t))] i, by fin_cases i <;> simp [R]⟩
  have hf : Function.Injective f := by
    intro i j hij
    apply Fin.ext
    fin_cases i <;> fin_cases j <;> simp_all [f]
  have hfsurj : Function.Surjective f := by
    intro x
    rcases x with ⟨x, hx⟩
    simp only [R, Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl | rfl | rfl
    · exact ⟨2, by ext; simp [f]⟩
    · exact ⟨0, by ext; simp [f]⟩
    · exact ⟨1, by ext; simp [f]⟩
    · exact ⟨3, by ext; simp [f]⟩
  let e : Fin 4 ≃ ↥(insert (.inl (.inr Unit.unit)) R) :=
    Equiv.ofBijective f ⟨hf, hfsurj⟩
  have hsub : R ⊆ univ.erase (.inl (.inr Unit.unit)) := by
    intro x hx
    rw [Finset.mem_erase]
    refine ⟨?_, Finset.mem_univ x⟩
    intro h
    subst x
    simp [R] at hx
  have hcard : R.card = 3 := by simp [R, hst]
  have hefamily :
      (fun i : Fin 4 => (projectiveAxisTwistedCubicGenerator (𝔽 := 𝔽)).col (e i)) =
        twoFiniteCubicInfinityAxisFamily s t (.inl (s + t)) := by
    funext i
    fin_cases i <;>
      simp [e, f, projectiveAxisTwistedCubicPoints,
        twoFiniteCubicInfinityAxisFamily]
  have htransport (j : Fin 4)
      (hli : LinearIndependent 𝔽 (fun a : Fin 3 =>
        twoFiniteCubicInfinityAxisFamily s t (.inl (s + t)) (j.succAbove a))) :
      LinearIndependent 𝔽 (fun i : {i : Fin 4 // i ≠ j} =>
        twoFiniteCubicInfinityAxisFamily s t (.inl (s + t)) i) := by
    let ej := projectiveFinEraseEquiv j
    have hli' := hli.comp ej.symm ej.symm.injective
    have heq :
        ((fun a : Fin 3 => twoFiniteCubicInfinityAxisFamily s t (.inl (s + t))
          (j.succAbove a)) ∘ ej.symm) =
          (fun i : {i : Fin 4 // i ≠ j} =>
            twoFiniteCubicInfinityAxisFamily s t (.inl (s + t)) i) := by
      funext i
      apply congrArg (twoFiniteCubicInfinityAxisFamily s t (.inl (s + t)))
      exact congrArg Subtype.val (ej.apply_symm_apply i)
    rw [← heq]
    exact hli'
  have hcirc := twoFiniteCubicInfinityAxis_isFourCircuit (𝔽 := 𝔽) hst
  have hdelete : ∀ j : Fin 4,
      LinearIndependent 𝔽 (fun i : {i : Fin 4 // i ≠ j} =>
        (projectiveAxisTwistedCubicGenerator (𝔽 := 𝔽)).col (e i)) := by
    intro j
    rw [show (fun i : {i : Fin 4 // i ≠ j} =>
        (projectiveAxisTwistedCubicGenerator (𝔽 := 𝔽)).col (e i)) =
        (fun i : {i : Fin 4 // i ≠ j} =>
          twoFiniteCubicInfinityAxisFamily s t (.inl (s + t)) i) by
          funext i
          exact congrFun hefamily i]
    apply htransport
    have hs12 : (1 : Fin 4).succAbove (2 : Fin 3) = 3 := by decide
    have hs21 : (2 : Fin 4).succAbove (1 : Fin 3) = 1 := by decide
    have hs22 : (2 : Fin 4).succAbove (2 : Fin 3) = 3 := by decide
    have hs31 : (3 : Fin 4).succAbove (1 : Fin 3) = 1 := by decide
    have hs32 : (3 : Fin 4).succAbove (2 : Fin 3) = 2 := by decide
    fin_cases j
    · convert hcirc.2.1 using 1
      funext a
      fin_cases a <;>
        simp [twoFiniteCubicInfinityAxisFamily, projectiveTwistedCubicPoints]
    · convert hcirc.2.2.1 using 1
      funext a
      fin_cases a <;>
        simp [twoFiniteCubicInfinityAxisFamily, projectiveTwistedCubicPoints, hs12]
    · convert hcirc.2.2.2.1 using 1
      funext a
      fin_cases a <;>
        simp [twoFiniteCubicInfinityAxisFamily, projectiveTwistedCubicPoints, hs21, hs22]
    · convert hcirc.2.2.2.2 using 1
      funext a
      fin_cases a <;>
        simp [twoFiniteCubicInfinityAxisFamily, projectiveTwistedCubicPoints, hs31, hs32]
  apply mem_repairHypergraph_of_reindexed_circuit
    (G := projectiveAxisTwistedCubicGenerator) hsub hcard e
  · rw [hefamily]
    exact hcirc.1
  · exact hdelete

/-- A convenient exclusion principle for a proposed three-helper completed-seed repair whose
four displayed columns are independent. -/
theorem projectiveRepairTriple_not_mem_of_linearIndependent
    {x a b c : ProjectiveAxisTwistedCubicIndex 𝔽}
    (hxa : x ≠ a) (hxb : x ≠ b) (hxc : x ≠ c)
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hli : LinearIndependent 𝔽 (fun i : Fin 4 =>
      projectiveAxisTwistedCubicPoints 𝔽 (![x, a, b, c] i))) :
    ({a, b, c} : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) ∉
      projectiveAxisTwistedCubicRepairHypergraph x 3 := by
  intro hR
  apply projectiveAxisTwistedCubicRepair_edge_dependent hR
  let e0 := projectiveFin4Equiv hxa hxb hxc hab hac hbc
  let e : Fin 4 ≃ ↥(insert x ({a, b, c} :
      Finset (ProjectiveAxisTwistedCubicIndex 𝔽))) := by
    simpa only [Finset.insert_eq] using e0
  apply (linearIndependent_equiv e).mp
  convert hli using 1
  funext i
  fin_cases i <;> simp [e, e0, projectiveFin4Equiv]

/-- Three distinct finite cubic helpers cannot repair cubic infinity. -/
theorem projectiveCubicInfinityRepair_threeFinite_not_mem
    {s t u : 𝔽} (hst : s ≠ t) (hsu : s ≠ u) (htu : t ≠ u) :
    ({(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽), .inl (.inl t),
        .inl (.inl u)} : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) ∉
      projectiveAxisTwistedCubicRepairHypergraph (.inl (.inr Unit.unit)) 3 := by
  apply projectiveRepairTriple_not_mem_of_linearIndependent
    (by simp) (by simp) (by simp)
    (by simpa using hst) (by simpa using hsu) (by simpa using htu)
  convert cubicInfinityThreeFinite_linearIndependent hst hsu htu using 1
  funext i
  fin_cases i <;> simp [projectiveAxisTwistedCubicPoints]

/-- One finite cubic helper and two distinct axis helpers cannot repair cubic infinity. -/
theorem projectiveCubicInfinityRepair_oneFinite_twoAxis_not_mem
    (s : 𝔽) {y z : 𝔽 ⊕ Unit} (hyz : y ≠ z) :
    ({(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽), .inr y, .inr z} :
      Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) ∉
        projectiveAxisTwistedCubicRepairHypergraph (.inl (.inr Unit.unit)) 3 := by
  apply projectiveRepairTriple_not_mem_of_linearIndependent
    (by simp) (by simp) (by simp) (by simp) (by simp) (by simpa using hyz)
  have hli := finiteCubicInfinityTwoAxis_linearIndependent (𝔽 := 𝔽) s hyz
  convert linearIndependent_vec4_swap01 hli using 1
  funext i
  fin_cases i <;> simp [projectiveAxisTwistedCubicPoints]

/-- Three axis helpers cannot repair cubic infinity: the last coordinate forces the target
coefficient of every relation on that support to vanish. -/
theorem projectiveCubicInfinityRepair_threeAxis_not_mem
    (y z w : 𝔽 ⊕ Unit) :
    ({(.inr y : ProjectiveAxisTwistedCubicIndex 𝔽), .inr z, .inr w} :
      Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) ∉
        projectiveAxisTwistedCubicRepairHypergraph (.inl (.inr Unit.unit)) 3 := by
  intro hR
  obtain ⟨-, -, c, hc, hcx, hsupp⟩ := mem_repairHypergraph.mp hR
  have hrel := dual_word_column_relation
    (G := projectiveAxisTwistedCubicGenerator) hc
  have h3 := congrFun hrel (3 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h3
  change (∑ j, c j * projectiveAxisTwistedCubicGenerator 3 j) = 0 at h3
  have hsum :
      (∑ j, c j * projectiveAxisTwistedCubicGenerator 3 j) =
        c (.inl (.inr Unit.unit)) := by
    rw [Finset.sum_eq_single (.inl (.inr Unit.unit))]
    · simp [projectiveAxisTwistedCubicGenerator, projectiveAxisTwistedCubicPoints,
        projectiveTwistedCubicPoints]
    · intro j _ hjx
      by_cases hcj : c j = 0
      · simp [hcj]
      · have hj : j ∈ wordSupport c := mem_wordSupport.mpr hcj
        rw [hsupp] at hj
        simp only [Finset.mem_insert, Finset.mem_singleton] at hj
        rcases hj with hj | hj | hj | hj
        · exact (hjx hj).elim
        · subst j
          cases y <;> simp [projectiveAxisTwistedCubicGenerator,
            projectiveAxisTwistedCubicPoints]
        · subst j
          cases z <;> simp [projectiveAxisTwistedCubicGenerator,
            projectiveAxisTwistedCubicPoints]
        · subst j
          cases w <;> simp [projectiveAxisTwistedCubicGenerator,
            projectiveAxisTwistedCubicPoints]
    · simp
  rw [hsum] at h3
  exact hcx h3

/-- In a cubic-infinity repair with two finite cubic helpers, the axis helper is forced to be
the finite point with parameter `s+t`. -/
theorem projectiveCubicInfinityRepair_axis_eq_of_mem [CharP 𝔽 3]
    {s t : 𝔽} {y : 𝔽 ⊕ Unit} (hst : s ≠ t)
    (hR : ({(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽), .inl (.inl t),
        .inr y} : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) ∈
      projectiveAxisTwistedCubicRepairHypergraph (.inl (.inr Unit.unit)) 3) :
    y = .inl (s + t) := by
  by_contra hne
  have hli : LinearIndependent 𝔽 (twoFiniteCubicInfinityAxisFamily s t y) := by
    by_contra hdep
    exact hne ((twoFiniteCubicInfinityAxis_dependent_iff hst y).mp hdep)
  have hli' := linearIndependent_vec4_swap01 (linearIndependent_vec4_swap12 hli)
  have hnot := projectiveRepairTriple_not_mem_of_linearIndependent
    (x := (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽))
    (a := .inl (.inl s)) (b := .inl (.inl t)) (c := .inr y)
    (by simp) (by simp) (by simp) (by simpa using hst) (by simp) (by simp) (by
      convert hli' using 1
      funext i
      fin_cases i <;> simp [projectiveAxisTwistedCubicPoints])
  exact hnot hR

/-- Cubic infinity has no repair edge with at most two helpers. -/
theorem projectiveCubicInfinity_no_repairEdge_radius_two [CharP 𝔽 3]
    (R : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) :
    R ∉ projectiveAxisTwistedCubicRepairHypergraph (.inl (.inr Unit.unit)) 2 := by
  intro hR
  apply projectiveAxisTwistedCubicRepair_edge_dependent hR
  obtain ⟨hsub, hcard, -⟩ := mem_repairHypergraph.mp hR
  have hxR : (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) ∉ R := by
    intro hx
    exact (Finset.mem_erase.mp (hsub hx)).1 rfl
  apply projectiveAxisTwistedCubic_selected_linearIndependent_of_card_le_three_of_containsCubic
  · rw [Finset.card_insert_of_notMem hxR]
    omega
  · exact ⟨.inr Unit.unit, Finset.mem_insert_self _ _⟩

/-- Every radius-three repair of cubic infinity has exactly three helpers. -/
theorem projectiveCubicInfinityRepair_edge_card_eq_three [CharP 𝔽 3]
    {R : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)}
    (hR : R ∈ projectiveAxisTwistedCubicRepairHypergraph (.inl (.inr Unit.unit)) 3) :
    R.card = 3 := by
  obtain ⟨hsub, hcard, c, hc, hcx, hsupp⟩ := mem_repairHypergraph.mp hR
  by_contra hne
  have hle : R.card ≤ 2 := by omega
  apply projectiveCubicInfinity_no_repairEdge_radius_two R
  exact mem_repairHypergraph.mpr ⟨hsub, hle, c, hc, hcx, hsupp⟩

/-- Every radius-three repair of cubic infinity consists of two distinct finite cubic points
and their uniquely forced finite axis point. -/
theorem projectiveCubicInfinityRepairHypergraph_shape [CharP 𝔽 3]
    {R : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)}
    (hR : R ∈ projectiveAxisTwistedCubicRepairHypergraph (.inl (.inr Unit.unit)) 3) :
    ∃ s t : 𝔽, s ≠ t ∧
      R = {(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽), .inl (.inl t),
        .inr (.inl (s + t))} := by
  obtain ⟨a, b, c, hab, hac, hbc, hReq⟩ := Finset.card_eq_three.mp
    (projectiveCubicInfinityRepair_edge_card_eq_three hR)
  have hsub := (mem_repairHypergraph.mp hR).1
  have hxR : (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) ∉ R := by
    intro hx
    exact (Finset.mem_erase.mp (hsub hx)).1 rfl
  subst R
  cases a with
  | inl x =>
      cases x with
      | inr u => exact (hxR (by simp)).elim
      | inl s =>
          cases b with
          | inl y =>
              cases y with
              | inr u => exact (hxR (by simp)).elim
              | inl t =>
                  cases c with
                  | inl z =>
                      cases z with
                      | inr u => exact (hxR (by simp)).elim
                      | inl u =>
                          have hst : s ≠ t := by simpa using hab
                          have hsu : s ≠ u := by simpa using hac
                          have htu : t ≠ u := by simpa using hbc
                          exact (projectiveCubicInfinityRepair_threeFinite_not_mem
                            hst hsu htu hR).elim
                  | inr y =>
                      have hst : s ≠ t := by simpa using hab
                      have hy := projectiveCubicInfinityRepair_axis_eq_of_mem hst hR
                      exact ⟨s, t, hst, by simp [hy]⟩
          | inr y =>
              cases c with
              | inl z =>
                  cases z with
                  | inr u => exact (hxR (by simp)).elim
                  | inl t =>
                      have hst : s ≠ t := by simpa using hac
                      have hR' :
                          {(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽),
                            .inl (.inl t), .inr y} ∈
                            projectiveAxisTwistedCubicRepairHypergraph
                              (.inl (.inr Unit.unit)) 3 := by
                        convert hR using 1
                        ext q
                        simp only [Finset.mem_insert, Finset.mem_singleton]
                        tauto
                      have hy := projectiveCubicInfinityRepair_axis_eq_of_mem hst hR'
                      refine ⟨s, t, hst, ?_⟩
                      rw [hy]
                      ext q
                      simp only [Finset.mem_insert, Finset.mem_singleton]
                      tauto
              | inr z =>
                  have hyz : y ≠ z := by simpa using hbc
                  exact (projectiveCubicInfinityRepair_oneFinite_twoAxis_not_mem
                    s hyz hR).elim
  | inr y =>
      cases b with
      | inl x =>
          cases x with
          | inr u => exact (hxR (by simp)).elim
          | inl s =>
              cases c with
              | inl z =>
                  cases z with
                  | inr u => exact (hxR (by simp)).elim
                  | inl t =>
                      have hst : s ≠ t := by simpa using hbc
                      have hR' :
                          {(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽),
                            .inl (.inl t), .inr y} ∈
                            projectiveAxisTwistedCubicRepairHypergraph
                              (.inl (.inr Unit.unit)) 3 := by
                        convert hR using 1
                        ext q
                        simp only [Finset.mem_insert, Finset.mem_singleton]
                        tauto
                      have hy := projectiveCubicInfinityRepair_axis_eq_of_mem hst hR'
                      refine ⟨s, t, hst, ?_⟩
                      rw [hy]
                      ext q
                      simp only [Finset.mem_insert, Finset.mem_singleton]
                      tauto
              | inr z =>
                  have hyz : y ≠ z := by
                    intro h
                    exact hac (congrArg Sum.inr h)
                  have hR' :
                      {(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽),
                        .inr y, .inr z} ∈
                        projectiveAxisTwistedCubicRepairHypergraph
                          (.inl (.inr Unit.unit)) 3 := by
                    convert hR using 1
                    ext q
                    simp only [Finset.mem_insert, Finset.mem_singleton]
                    tauto
                  exact (projectiveCubicInfinityRepair_oneFinite_twoAxis_not_mem
                    s hyz hR').elim
      | inr z =>
          cases c with
          | inl x =>
              cases x with
              | inr u => exact (hxR (by simp)).elim
              | inl s =>
                  have hyz : y ≠ z := by
                    intro h
                    exact hab (congrArg Sum.inr h)
                  have hR' :
                      {(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽),
                        .inr y, .inr z} ∈
                        projectiveAxisTwistedCubicRepairHypergraph
                          (.inl (.inr Unit.unit)) 3 := by
                    convert hR using 1
                    ext q
                    simp only [Finset.mem_insert, Finset.mem_singleton]
                    tauto
                  exact (projectiveCubicInfinityRepair_oneFinite_twoAxis_not_mem
                    s hyz hR').elim
          | inr w =>
              exact (projectiveCubicInfinityRepair_threeAxis_not_mem y z w hR).elim

/-- Exact radius-three repair hypergraph at cubic infinity. -/
theorem mem_projectiveCubicInfinityRepairHypergraph_iff [CharP 𝔽 3]
    {R : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)} :
    R ∈ projectiveAxisTwistedCubicRepairHypergraph (.inl (.inr Unit.unit)) 3 ↔
      ∃ s t : 𝔽, s ≠ t ∧
        R = {(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽), .inl (.inl t),
          .inr (.inl (s + t))} := by
  constructor
  · exact projectiveCubicInfinityRepairHypergraph_shape
  · rintro ⟨s, t, hst, rfl⟩
    exact projectiveCubicInfinityRepairHelpers_mem hst

/-- Two cubic helpers and one additional axis helper cannot repair an axis target in the
completed seed. -/
theorem projectiveAxisRepair_twoCubic_oneAxis_not_mem [CharP 𝔽 3]
    {y z : 𝔽 ⊕ Unit} {x w : ProjectiveTwistedCubicIndex 𝔽}
    (hxw : x ≠ w) (hyz : y ≠ z) :
    ({(.inl x : ProjectiveAxisTwistedCubicIndex 𝔽), .inl w, .inr z} :
      Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) ∉
        projectiveAxisTwistedCubicRepairHypergraph (.inr y) 3 := by
  apply projectiveRepairTriple_not_mem_of_linearIndependent
    (by simp) (by simp) (by simpa using hyz)
    (by simpa using hxw) (by simp) (by simp)
  have hli := projectiveTwoCubicTwoAxis_linearIndependent (𝔽 := 𝔽) hxw hyz
  convert linearIndependent_vec4_swap01 (linearIndependent_vec4_swap12 hli) using 1
  funext i
  fin_cases i <;> simp [projectiveAxisTwistedCubicPoints]

/-- A cubic-helper triple containing projective cubic infinity cannot repair the axis point at
infinity. Its unique axis completion is the finite point `s+t`. -/
theorem projectiveAxisInfinityRepair_twoFiniteCubicInfinity_not_mem
    {s t : 𝔽} (hst : s ≠ t) :
    ({(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽), .inl (.inl t),
        .inl (.inr Unit.unit)} : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) ∉
      projectiveAxisTwistedCubicRepairHypergraph (.inr (.inr Unit.unit)) 3 := by
  apply projectiveRepairTriple_not_mem_of_linearIndependent
    (by simp) (by simp) (by simp)
    (by simpa using hst) (by simp) (by simp)
  have hli : LinearIndependent 𝔽
      (twoFiniteCubicInfinityAxisFamily s t (.inr Unit.unit)) := by
    by_contra hdep
    have hcompletion :=
      (twoFiniteCubicInfinityAxis_dependent_iff hst (.inr Unit.unit)).mp hdep
    simp at hcompletion
  have hli' := linearIndependent_vec4_swap01
    (linearIndependent_vec4_swap12 (linearIndependent_vec4_swap23 hli))
  convert hli' using 1
  funext i
  fin_cases i <;>
    simp [projectiveAxisTwistedCubicPoints]

/-- Three distinct finite cubic helpers can repair the projective axis point at infinity only
when their parameters sum to zero. -/
theorem projectiveAxisInfinityRepair_threeFinite_sum_eq_zero [CharP 𝔽 3]
    {s t u : 𝔽} (hst : s ≠ t) (hsu : s ≠ u) (htu : t ≠ u)
    (hR : ({(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽), .inl (.inl t),
        .inl (.inl u)} : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) ∈
      projectiveAxisTwistedCubicRepairHypergraph (.inr (.inr Unit.unit)) 3) :
    s + t + u = 0 := by
  let v : Fin 3 → 𝔽 := ![s, t, u]
  have hv : Function.Injective v := by
    intro i j hij
    fin_cases i <;> fin_cases j <;> simp_all [v]
  let f : Fin 4 → ↥(insert (.inr (.inr Unit.unit))
      ({(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽), .inl (.inl t),
        .inl (.inl u)} : Finset (ProjectiveAxisTwistedCubicIndex 𝔽))) := fun i =>
    ⟨![.inl (.inl s), .inl (.inl t), .inl (.inl u), .inr (.inr Unit.unit)] i,
      by fin_cases i <;> simp⟩
  have hf : Function.Injective f := by
    intro i j hij
    apply Fin.ext
    fin_cases i <;> fin_cases j <;> simp_all [f]
  have hfsurj : Function.Surjective f := by
    intro x
    rcases x with ⟨x, hx⟩
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl | rfl | rfl
    · exact ⟨3, by ext; simp [f]⟩
    · exact ⟨0, by ext; simp [f]⟩
    · exact ⟨1, by ext; simp [f]⟩
    · exact ⟨2, by ext; simp [f]⟩
  let e : Fin 4 ≃ ↥(insert (.inr (.inr Unit.unit))
      ({(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽), .inl (.inl t),
        .inl (.inl u)} : Finset (ProjectiveAxisTwistedCubicIndex 𝔽))) :=
    Equiv.ofBijective f ⟨hf, hfsurj⟩
  have hdet := repair_edge_reindexed_det_eq_zero
    (G := projectiveAxisTwistedCubicGenerator) hR e
  have hmatrix :
      (fun i j => projectiveAxisTwistedCubicGenerator i (e j)) =
        twistedCubicAxisCircuitMatrix v 0 1 := by
    ext i j
    fin_cases j <;> fin_cases i <;>
      simp [e, f, projectiveAxisTwistedCubicGenerator,
        projectiveAxisTwistedCubicPoints, projectiveTwistedCubicPoints,
        twistedCubicAxisCircuitMatrix, v]
  rw [hmatrix] at hdet
  have hcross := (twistedCubicAxisCircuitMatrix_det_eq_zero_iff hv 0 1).mp hdet
  simpa [v] using hcross.symm

/-- Exact cubic component at the projective axis point at infinity: three distinct finite cubic
helpers repair it exactly when their parameters sum to zero. -/
theorem mem_projectiveAxisInfinityRepair_threeFinite_iff [CharP 𝔽 3]
    {s t u : 𝔽} (hst : s ≠ t) (hsu : s ≠ u) (htu : t ≠ u) :
    ({(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽), .inl (.inl t),
        .inl (.inl u)} : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) ∈
      projectiveAxisTwistedCubicRepairHypergraph (.inr (.inr Unit.unit)) 3 ↔
        s + t + u = 0 := by
  constructor
  · exact projectiveAxisInfinityRepair_threeFinite_sum_eq_zero hst hsu htu
  · intro hsum
    let v : Fin 3 → 𝔽 := ![s, t, u]
    have hv : Function.Injective v := by
      intro i j hij
      fin_cases i <;> fin_cases j <;> simp_all [v]
    have haxis : twistedCubicTripleAxisIndex v = .inr Unit.unit := by
      simp [twistedCubicTripleAxisIndex, v, hsum]
    have hbase := projectiveFiniteCubicTripleRepairHelpers_mem hv
    have haxisMem : (.inr (twistedCubicTripleAxisIndex v) :
        ProjectiveAxisTwistedCubicIndex 𝔽) ∈
          projectiveFiniteCubicTripleRepairHelpers v := by
      simp [projectiveFiniteCubicTripleRepairHelpers]
    have hretarget := repairHypergraph_retarget hbase haxisMem
    change ({(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽), .inl (.inl t),
        .inl (.inl u)} : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) ∈
      repairHypergraph (projectiveAxisTwistedCubicCode (𝔽 := 𝔽))
        (.inr (.inr Unit.unit)) 3
    rw [← haxis]
    convert hretarget using 1
    ext x
    simp only [projectiveFiniteCubicTripleRepairHelpers, v, Fin.isValue,
      Matrix.cons_val_zero, Matrix.cons_val_one, Finset.mem_insert, Finset.mem_erase,
      Finset.mem_singleton]
    aesop

/-- Every radius-two repair of an axis coordinate uses exactly two helpers. -/
theorem projectiveAxisRepair_edge_card_eq_two [CharP 𝔽 3] {y : 𝔽 ⊕ Unit}
    {R : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)}
    (hR : R ∈ projectiveAxisTwistedCubicRepairHypergraph (.inr y) 2) : R.card = 2 := by
  have hle : R.card ≤ 2 := (mem_repairHypergraph.mp hR).2.1
  have hpos : 0 < R.card := Finset.card_pos.mpr
    (projectiveAxisTwistedCubicRepair_edge_nonempty hR)
  by_contra hne
  have h₁ : R.card = 1 := by omega
  apply projectiveAxisTwistedCubicRepair_edge_dependent hR
  apply projectiveAxisTwistedCubic_selected_linearIndependent_of_card_le_two
  · exact Finset.insert_nonempty _ _
  · have hyR : (.inr y : ProjectiveAxisTwistedCubicIndex 𝔽) ∉ R := by
      intro hy
      exact (Finset.mem_erase.mp ((mem_repairHypergraph.mp hR).1 hy)).1 rfl
    rw [Finset.card_insert_of_notMem hyR, h₁]

/-- Complete radius-two axis-repair shape: the helpers are precisely two other axis points. -/
theorem projectiveAxisRepairPair_shape [CharP 𝔽 3] {y : 𝔽 ⊕ Unit}
    {R : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)}
    (hR : R ∈ projectiveAxisTwistedCubicRepairHypergraph (.inr y) 2) :
    ∃ z w : 𝔽 ⊕ Unit, y ≠ z ∧ y ≠ w ∧ z ≠ w ∧
      R = {(.inr z : ProjectiveAxisTwistedCubicIndex 𝔽), .inr w} := by
  obtain ⟨p, q, hpq, rfl⟩ := Finset.card_eq_two.mp (projectiveAxisRepair_edge_card_eq_two hR)
  have hsub := (mem_repairHypergraph.mp hR).1
  have hyp : (.inr y : ProjectiveAxisTwistedCubicIndex 𝔽) ≠ p := by
    intro h
    exact (Finset.mem_erase.mp (hsub (by simp [h]))).1 rfl
  have hyq : (.inr y : ProjectiveAxisTwistedCubicIndex 𝔽) ≠ q := by
    intro h
    exact (Finset.mem_erase.mp (hsub (by simp [h]))).1 rfl
  rcases p with x | z <;> rcases q with t | w
  · exfalso
    apply projectiveAxisTwistedCubicRepair_edge_dependent hR
    apply projectiveAxisTwistedCubic_selected_linearIndependent_of_card_le_three_of_containsCubic
    · simp [hpq]
    · exact ⟨x, by simp⟩
  · exfalso
    apply projectiveAxisTwistedCubicRepair_edge_dependent hR
    apply projectiveAxisTwistedCubic_selected_linearIndependent_of_card_le_three_of_containsCubic
    · calc
        ({(.inr y : ProjectiveAxisTwistedCubicIndex 𝔽), .inl x, .inr w} :
            Finset (ProjectiveAxisTwistedCubicIndex 𝔽)).card ≤
            ({(.inl x : ProjectiveAxisTwistedCubicIndex 𝔽), .inr w} :
              Finset (ProjectiveAxisTwistedCubicIndex 𝔽)).card + 1 :=
          Finset.card_insert_le _ _
        _ ≤ 3 := by simp
    · exact ⟨x, by simp⟩
  · exfalso
    apply projectiveAxisTwistedCubicRepair_edge_dependent hR
    apply projectiveAxisTwistedCubic_selected_linearIndependent_of_card_le_three_of_containsCubic
    · calc
        ({(.inr y : ProjectiveAxisTwistedCubicIndex 𝔽), .inr z, .inl t} :
            Finset (ProjectiveAxisTwistedCubicIndex 𝔽)).card ≤
            ({(.inr z : ProjectiveAxisTwistedCubicIndex 𝔽), .inl t} :
              Finset (ProjectiveAxisTwistedCubicIndex 𝔽)).card + 1 :=
          Finset.card_insert_le _ _
        _ ≤ 3 := by simp
    · exact ⟨t, by simp⟩
  · have hyz : y ≠ z := fun h => hyp (by rw [h])
    have hyw : y ≠ w := fun h => hyq (by rw [h])
    have hzw : z ≠ w := fun h => hpq (by rw [h])
    exact ⟨z, w, hyz, hyw, hzw, rfl⟩

/-- Exact radius-two completed-axis repair classification. -/
theorem mem_projectiveAxisRepairHypergraph_two_iff [CharP 𝔽 3] {y : 𝔽 ⊕ Unit}
    {R : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)} :
    R ∈ projectiveAxisTwistedCubicRepairHypergraph (.inr y) 2 ↔
      ∃ z w : 𝔽 ⊕ Unit, y ≠ z ∧ y ≠ w ∧ z ≠ w ∧
        R = {(.inr z : ProjectiveAxisTwistedCubicIndex 𝔽), .inr w} := by
  constructor
  · exact projectiveAxisRepairPair_shape
  · rintro ⟨z, w, hyz, hyw, hzw, rfl⟩
    let v : Fin 3 → 𝔽 ⊕ Unit := ![y, z, w]
    have hv : Function.Injective v := by
      intro i j hij
      fin_cases i <;> fin_cases j <;> simp_all [v]
    let f : Fin 3 → ↥(insert (.inr y)
        ({(.inr z : ProjectiveAxisTwistedCubicIndex 𝔽), .inr w} :
          Finset (ProjectiveAxisTwistedCubicIndex 𝔽))) := fun i =>
      ⟨.inr (v i), by fin_cases i <;> simp [v]⟩
    have hf : Function.Injective f := by
      intro i j hij
      apply hv
      exact Sum.inr.inj (congrArg Subtype.val hij)
    have hfsurj : Function.Surjective f := by
      intro q
      rcases q with ⟨q, hq⟩
      simp only [Finset.mem_insert, Finset.mem_singleton] at hq
      rcases hq with rfl | rfl | rfl
      · exact ⟨0, by ext; simp [f, v]⟩
      · exact ⟨1, by ext; simp [f, v]⟩
      · exact ⟨2, by ext; simp [f, v]⟩
    let e : Fin 3 ≃ ↥(insert (.inr y)
        ({(.inr z : ProjectiveAxisTwistedCubicIndex 𝔽), .inr w} :
          Finset (ProjectiveAxisTwistedCubicIndex 𝔽))) :=
      Equiv.ofBijective f ⟨hf, hfsurj⟩
    have hsub : ({(.inr z : ProjectiveAxisTwistedCubicIndex 𝔽), .inr w} :
        Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) ⊆ univ.erase (.inr y) := by
      intro q hq
      rw [Finset.mem_erase]
      refine ⟨?_, Finset.mem_univ q⟩
      simp only [Finset.mem_insert, Finset.mem_singleton] at hq
      rcases hq with rfl | rfl
      · exact fun h => hyz (Sum.inr.inj h.symm)
      · exact fun h => hyw (Sum.inr.inj h.symm)
    have hcard : ({(.inr z : ProjectiveAxisTwistedCubicIndex 𝔽), .inr w} :
        Finset (ProjectiveAxisTwistedCubicIndex 𝔽)).card = 2 := by simp [hzw]
    have hefamily :
        (fun i : Fin 3 => (projectiveAxisTwistedCubicGenerator (𝔽 := 𝔽)).col (e i)) =
          (fun i => axisTwistedCubicPoints 𝔽 (.inr (v i))) := by
      funext i
      fin_cases i <;>
        simp [e, f, v, projectiveAxisTwistedCubicPoints]
    have htransport (j : Fin 3)
        (hli : LinearIndependent 𝔽 (fun a : Fin 2 =>
          axisTwistedCubicPoints 𝔽 (.inr (v (j.succAbove a))))) :
        LinearIndependent 𝔽 (fun i : {i : Fin 3 // i ≠ j} =>
          axisTwistedCubicPoints 𝔽 (.inr (v i))) := by
      let ej := projectiveFinEraseEquiv j
      have hli' := hli.comp ej.symm ej.symm.injective
      have heq :
          ((fun a : Fin 2 => axisTwistedCubicPoints 𝔽 (.inr (v (j.succAbove a)))) ∘
            ej.symm) =
            (fun i : {i : Fin 3 // i ≠ j} => axisTwistedCubicPoints 𝔽 (.inr (v i))) := by
        funext i
        apply congrArg (fun a => axisTwistedCubicPoints 𝔽 (.inr (v a)))
        exact congrArg Subtype.val (ej.apply_symm_apply i)
      rw [← heq]
      exact hli'
    have hcirc := twistedCubicAxis_triple_isCircuit (w := v) hv
    have hdelete : ∀ j : Fin 3,
        LinearIndependent 𝔽 (fun i : {i : Fin 3 // i ≠ j} =>
          (projectiveAxisTwistedCubicGenerator (𝔽 := 𝔽)).col (e i)) := by
      intro j
      rw [show (fun i : {i : Fin 3 // i ≠ j} =>
          (projectiveAxisTwistedCubicGenerator (𝔽 := 𝔽)).col (e i)) =
          (fun i : {i : Fin 3 // i ≠ j} => axisTwistedCubicPoints 𝔽 (.inr (v i))) by
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
      (G := projectiveAxisTwistedCubicGenerator) hsub hcard e
    · rw [hefamily]
      exact hcirc.1
    · exact hdelete

/-- Every radius-three repair of the projective axis point at infinity either contains a
canonical pair of other axis points or is exactly a finite zero-sum cubic triple. -/
theorem projectiveAxisInfinityRepair_contains_canonical [CharP 𝔽 3]
    {R : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)}
    (hR : R ∈ projectiveAxisTwistedCubicRepairHypergraph (.inr (.inr Unit.unit)) 3) :
    (∃ z w : 𝔽 ⊕ Unit, (.inr Unit.unit : 𝔽 ⊕ Unit) ≠ z ∧
      (.inr Unit.unit : 𝔽 ⊕ Unit) ≠ w ∧ z ≠ w ∧
      ({(.inr z : ProjectiveAxisTwistedCubicIndex 𝔽), .inr w} :
        Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) ⊆ R) ∨
    (∃ s t u : 𝔽, s ≠ t ∧ s ≠ u ∧ t ≠ u ∧ s + t + u = 0 ∧
      R = {(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽),
        .inl (.inl t), .inl (.inl u)}) := by
  have hcardle : R.card ≤ 3 := (mem_repairHypergraph.mp hR).2.1
  have hcardge : 2 ≤ R.card := by
    by_contra h
    have hle : R.card ≤ 1 := by omega
    have hR2 : R ∈ projectiveAxisTwistedCubicRepairHypergraph
        (.inr (.inr Unit.unit)) 2 :=
      mem_repairHypergraph_of_mem_of_card_le hR (hle.trans (by omega))
    have htwo := projectiveAxisRepair_edge_card_eq_two hR2
    omega
  have hcard : R.card = 2 ∨ R.card = 3 := by omega
  rcases hcard with h2 | h3
  · have hR2 : R ∈ projectiveAxisTwistedCubicRepairHypergraph
        (.inr (.inr Unit.unit)) 2 :=
      mem_repairHypergraph_of_mem_of_card_le hR h2.le
    obtain ⟨z, w, hyz, hyw, hzw, rfl⟩ := projectiveAxisRepairPair_shape hR2
    exact Or.inl ⟨z, w, hyz, hyw, hzw, Finset.Subset.rfl⟩
  · obtain ⟨a, b, c, hab, hac, hbc, hReq⟩ := Finset.card_eq_three.mp h3
    have hsub := (mem_repairHypergraph.mp hR).1
    have hyR : (.inr (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) ∉ R := by
      intro hy
      exact (Finset.mem_erase.mp (hsub hy)).1 rfl
    subst R
    cases a with
    | inl x =>
      cases b with
      | inl y =>
        cases c with
        | inl z =>
          rcases x with s | sx <;> rcases y with t | ty <;> rcases z with u | uz
          · have hst : s ≠ t := by simpa using hab
            have hsu : s ≠ u := by simpa using hac
            have htu : t ≠ u := by simpa using hbc
            have hsum := projectiveAxisInfinityRepair_threeFinite_sum_eq_zero
              hst hsu htu hR
            exact Or.inr ⟨s, t, u, hst, hsu, htu, hsum, rfl⟩
          · have hst : s ≠ t := by simpa using hab
            exact (projectiveAxisInfinityRepair_twoFiniteCubicInfinity_not_mem hst hR).elim
          · have hsu : s ≠ u := by simpa using hac
            have hR' : {(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽),
                (Sum.inl (Sum.inl u) : ProjectiveAxisTwistedCubicIndex 𝔽),
                (Sum.inl (Sum.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽)} ∈
                projectiveAxisTwistedCubicRepairHypergraph (.inr (.inr Unit.unit)) 3 := by
              convert hR using 1
              ext q
              simp only [Finset.mem_insert, Finset.mem_singleton]
              tauto
            exact (projectiveAxisInfinityRepair_twoFiniteCubicInfinity_not_mem hsu hR').elim
          · exact (hbc (by congr)).elim
          · have htu : t ≠ u := by simpa using hbc
            have hR' : {(.inl (.inl t) : ProjectiveAxisTwistedCubicIndex 𝔽),
                (Sum.inl (Sum.inl u) : ProjectiveAxisTwistedCubicIndex 𝔽),
                (Sum.inl (Sum.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽)} ∈
                projectiveAxisTwistedCubicRepairHypergraph (.inr (.inr Unit.unit)) 3 := by
              convert hR using 1
              ext q
              simp only [Finset.mem_insert, Finset.mem_singleton]
              tauto
            exact (projectiveAxisInfinityRepair_twoFiniteCubicInfinity_not_mem htu hR').elim
          · exact (hac (by congr)).elim
          · exact (hab (by congr)).elim
          · exact (hab (by congr)).elim
        | inr z =>
          have hxy : x ≠ y := by simpa using hab
          have hyz : (.inr Unit.unit : 𝔽 ⊕ Unit) ≠ z := by
            intro h
            apply hyR
            simp [h]
          exact (projectiveAxisRepair_twoCubic_oneAxis_not_mem hxy hyz hR).elim
      | inr z =>
        cases c with
        | inl y =>
          have hxy : x ≠ y := by simpa using hac
          have hyz : (.inr Unit.unit : 𝔽 ⊕ Unit) ≠ z := by
            intro h
            apply hyR
            simp [h]
          have hR' : {(.inl x : ProjectiveAxisTwistedCubicIndex 𝔽), .inl y,
              .inr z} ∈ projectiveAxisTwistedCubicRepairHypergraph
                (.inr (.inr Unit.unit)) 3 := by
            convert hR using 1
            ext q
            simp only [Finset.mem_insert, Finset.mem_singleton]
            tauto
          exact (projectiveAxisRepair_twoCubic_oneAxis_not_mem hxy hyz hR').elim
        | inr w =>
          have hyz : (.inr Unit.unit : 𝔽 ⊕ Unit) ≠ z := by
            intro h
            apply hyR
            simp [h]
          have hyw : (.inr Unit.unit : 𝔽 ⊕ Unit) ≠ w := by
            intro h
            apply hyR
            simp [h]
          have hzw : z ≠ w := by simpa using hbc
          exact Or.inl ⟨z, w, hyz, hyw, hzw, by simp⟩
    | inr z =>
      cases b with
      | inl x =>
        cases c with
        | inl y =>
          have hxy : x ≠ y := by simpa using hbc
          have hyz : (.inr Unit.unit : 𝔽 ⊕ Unit) ≠ z := by
            intro h
            apply hyR
            simp [h]
          have hR' : {(.inl x : ProjectiveAxisTwistedCubicIndex 𝔽), .inl y,
              .inr z} ∈ projectiveAxisTwistedCubicRepairHypergraph
                (.inr (.inr Unit.unit)) 3 := by
            convert hR using 1
            ext q
            simp only [Finset.mem_insert, Finset.mem_singleton]
            tauto
          exact (projectiveAxisRepair_twoCubic_oneAxis_not_mem hxy hyz hR').elim
        | inr w =>
          have hyz : (.inr Unit.unit : 𝔽 ⊕ Unit) ≠ z := by
            intro h
            apply hyR
            simp [h]
          have hyw : (.inr Unit.unit : 𝔽 ⊕ Unit) ≠ w := by
            intro h
            apply hyR
            simp [h]
          have hzw : z ≠ w := by simpa using hac
          exact Or.inl ⟨z, w, hyz, hyw, hzw, by simp⟩
      | inr w =>
        have hyz : (.inr Unit.unit : 𝔽 ⊕ Unit) ≠ z := by
          intro h
          apply hyR
          simp [h]
        have hyw : (.inr Unit.unit : 𝔽 ⊕ Unit) ≠ w := by
          intro h
          apply hyR
          simp [h]
        have hzw : z ≠ w := by simpa using hab
        exact Or.inl ⟨z, w, hyz, hyw, hzw, by simp⟩

/-- Exact minimal radius-three repair clutter at the projective axis point at infinity. -/
theorem mem_minimalProjectiveAxisInfinityRepair_iff [CharP 𝔽 3]
    {R : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)} :
    R ∈ minimalProjectiveAxisTwistedCubicRepairHypergraph
        (.inr (.inr Unit.unit)) 3 ↔
      (∃ z w : 𝔽 ⊕ Unit, (.inr Unit.unit : 𝔽 ⊕ Unit) ≠ z ∧
        (.inr Unit.unit : 𝔽 ⊕ Unit) ≠ w ∧ z ≠ w ∧
        R = {(.inr z : ProjectiveAxisTwistedCubicIndex 𝔽), .inr w}) ∨
      (∃ s t u : 𝔽, s ≠ t ∧ s ≠ u ∧ t ≠ u ∧ s + t + u = 0 ∧
        R = {(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽),
          .inl (.inl t), .inl (.inl u)}) := by
  rw [minimalProjectiveAxisTwistedCubicRepairHypergraph, minimalRepairHypergraph,
    mem_minimalHyperedges]
  constructor
  · rintro ⟨hR, hminimal⟩
    rcases projectiveAxisInfinityRepair_contains_canonical hR with hpair | hcubic
    · obtain ⟨z, w, hyz, hyw, hzw, hsub⟩ := hpair
      let B : Finset (ProjectiveAxisTwistedCubicIndex 𝔽) := {.inr z, .inr w}
      have hB2 : B ∈ projectiveAxisTwistedCubicRepairHypergraph
          (.inr (.inr Unit.unit)) 2 :=
        mem_projectiveAxisRepairHypergraph_two_iff.mpr
          ⟨z, w, hyz, hyw, hzw, rfl⟩
      have hB3 : B ∈ projectiveAxisTwistedCubicRepairHypergraph
          (.inr (.inr Unit.unit)) 3 := repairHypergraph_mono_radius (by omega) hB2
      have hRB := hminimal B hB3 hsub
      exact Or.inl ⟨z, w, hyz, hyw, hzw, Finset.Subset.antisymm hRB hsub⟩
    · exact Or.inr hcubic
  · intro hshape
    refine ⟨?_, ?_⟩
    · rcases hshape with hpair | hcubic
      · obtain ⟨z, w, hyz, hyw, hzw, rfl⟩ := hpair
        exact repairHypergraph_mono_radius (by omega)
          (mem_projectiveAxisRepairHypergraph_two_iff.mpr
            ⟨z, w, hyz, hyw, hzw, rfl⟩)
      · obtain ⟨s, t, u, hst, hsu, htu, hsum, rfl⟩ := hcubic
        exact (mem_projectiveAxisInfinityRepair_threeFinite_iff hst hsu htu).mpr hsum
    · intro B hB hBR
      rcases hshape with hpair | hcubic
      · obtain ⟨z, w, -, -, hzw, rfl⟩ := hpair
        have hBge : 2 ≤ B.card := by
          by_contra h
          have hle : B.card ≤ 1 := by omega
          have hB2 : B ∈ projectiveAxisTwistedCubicRepairHypergraph
              (.inr (.inr Unit.unit)) 2 :=
            mem_repairHypergraph_of_mem_of_card_le hB (hle.trans (by omega))
          have := projectiveAxisRepair_edge_card_eq_two hB2
          omega
        have hRcard : ({(.inr z : ProjectiveAxisTwistedCubicIndex 𝔽), .inr w} :
            Finset (ProjectiveAxisTwistedCubicIndex 𝔽)).card = 2 := by simp [hzw]
        have hBle := Finset.card_le_card hBR
        have hEq : B = {(.inr z : ProjectiveAxisTwistedCubicIndex 𝔽), .inr w} := by
          apply Finset.eq_of_subset_of_card_le hBR
          omega
        simp [hEq]
      · obtain ⟨s, t, u, hst, hsu, htu, -, rfl⟩ := hcubic
        have hBge : 2 ≤ B.card := by
          by_contra h
          have hle : B.card ≤ 1 := by omega
          have hB2 : B ∈ projectiveAxisTwistedCubicRepairHypergraph
              (.inr (.inr Unit.unit)) 2 :=
            mem_repairHypergraph_of_mem_of_card_le hB (hle.trans (by omega))
          have := projectiveAxisRepair_edge_card_eq_two hB2
          omega
        by_cases hB2card : B.card ≤ 2
        · have hBtwo : B ∈ projectiveAxisTwistedCubicRepairHypergraph
              (.inr (.inr Unit.unit)) 2 :=
            mem_repairHypergraph_of_mem_of_card_le hB hB2card
          obtain ⟨z, w, -, -, -, hBeq⟩ := projectiveAxisRepairPair_shape hBtwo
          have hzB : (.inr z : ProjectiveAxisTwistedCubicIndex 𝔽) ∈ B := by
            simp [hBeq]
          have hzR := hBR hzB
          simp at hzR
        · have hBcardle : B.card ≤ 3 :=
            (Finset.card_le_card hBR).trans_eq (by simp [hst, hsu, htu])
          have hBcard : B.card = 3 := by omega
          have hEq : B = {(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽),
              .inl (.inl t), .inl (.inl u)} := by
            apply Finset.eq_of_subset_of_card_le hBR
            simp [hst, hsu, htu, hBcard]
          simp [hEq]

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
#print axioms projectiveAxisRepairPair_shape
#print axioms projectiveAxisTwistedCubic_selected_linearIndependent_of_card_le_three_of_containsCubic
#print axioms projectiveFiniteCubicTripleRepairHelpers_mem
#print axioms mem_projectiveAxisInfinityRepair_threeFinite_iff
#print axioms mem_projectiveAxisRepairHypergraph_two_iff
#print axioms projectiveAxisInfinityRepair_contains_canonical
#print axioms mem_minimalProjectiveAxisInfinityRepair_iff

end RepairCodes
