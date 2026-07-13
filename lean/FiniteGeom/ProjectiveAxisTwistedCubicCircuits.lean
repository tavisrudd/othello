import FiniteGeom.AxisTwistedCubicCircuits
import FiniteGeom.ProjectiveAxisTwistedCubic

/-!
# Circuits through projective twisted-cubic infinity

The affine circuit module classifies three finite cubic points and their unique axis completion.
This module supplies the missing projective boundary case: two distinct finite cubic points at
parameters `s,t`, cubic infinity, and the finite axis point at `s+t` form a four-circuit.  No other
axis point completes that cubic triple.
-/

namespace FiniteGeom

open Matrix

variable {𝔽 : Type*} [Field 𝔽]

/-- Two finite cubic columns, cubic infinity, and one normalized axis column. -/
def twoFiniteCubicInfinityAxisFamily (s t : 𝔽) (y : 𝔽 ⊕ Unit) :
    Fin 4 → (Fin 4 → 𝔽) :=
  ![projectiveTwistedCubicPoints 𝔽 (.inl s),
    projectiveTwistedCubicPoints 𝔽 (.inl t),
    projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit),
    axisTwistedCubicPoints 𝔽 (.inr y)]

/-- Two distinct finite cubic points together with cubic infinity are independent. -/
theorem twoFiniteCubicInfinity_linearIndependent {s t : 𝔽} (hst : s ≠ t) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 (.inl s),
      projectiveTwistedCubicPoints 𝔽 (.inl t),
      projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit)] := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  have h₀ := congrFun hrel (0 : Fin 4)
  have h₁ := congrFun hrel (1 : Fin 4)
  have h₃ := congrFun hrel (3 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₀ h₁ h₃
  simp [Fin.sum_univ_three, projectiveTwistedCubicPoints, momentCurve] at h₀ h₁ h₃
  have hprod : g 0 * (s - t) = 0 := by linear_combination h₁ - t * h₀
  have hg₀ : g 0 = 0 := (mul_eq_zero.mp hprod).resolve_right (sub_ne_zero.mpr hst)
  have hg₁ : g 1 = 0 := by linear_combination h₀ - hg₀
  have hg₂ : g 2 = 0 := by linear_combination h₃ - s ^ 3 * hg₀ - t ^ 3 * hg₁
  intro i
  fin_cases i <;> assumption

/-- A finite cubic point, cubic infinity, and any axis point are independent. -/
theorem finiteCubicInfinityAxis_linearIndependent (s : 𝔽) (y : 𝔽 ⊕ Unit) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 (.inl s),
      projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit),
      axisTwistedCubicPoints 𝔽 (.inr y)] := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  have h₀ := congrFun hrel (0 : Fin 4)
  have h₃ := congrFun hrel (3 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₀ h₃
  simp [Fin.sum_univ_three, projectiveTwistedCubicPoints, momentCurve] at h₀ h₃
  have hg₀ : g 0 = 0 := h₀
  have hg₁ : g 1 = 0 := by linear_combination h₃ - s ^ 3 * hg₀
  cases y with
  | inl y =>
      have h₁ := congrFun hrel (1 : Fin 4)
      simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₁
      simp [Fin.sum_univ_three, projectiveTwistedCubicPoints, momentCurve, hg₀, hg₁] at h₁
      intro i
      fin_cases i <;> assumption
  | inr y =>
      have h₂ := congrFun hrel (2 : Fin 4)
      simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₂
      simp [Fin.sum_univ_three, projectiveTwistedCubicPoints, momentCurve, hg₀, hg₁] at h₂
      intro i
      fin_cases i <;> assumption

/-- Cubic infinity followed by two distinct finite cubic points is independent. -/
theorem cubicInfinityTwoFinite_linearIndependent {s t : 𝔽} (hst : s ≠ t) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit),
      projectiveTwistedCubicPoints 𝔽 (.inl s),
      projectiveTwistedCubicPoints 𝔽 (.inl t)] := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  have h₀ := congrFun hrel (0 : Fin 4)
  have h₁ := congrFun hrel (1 : Fin 4)
  have h₃ := congrFun hrel (3 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₀ h₁ h₃
  simp [Fin.sum_univ_three, projectiveTwistedCubicPoints, momentCurve] at h₀ h₁ h₃
  have hprod : g 1 * (s - t) = 0 := by linear_combination h₁ - t * h₀
  have hg₁ : g 1 = 0 := (mul_eq_zero.mp hprod).resolve_right (sub_ne_zero.mpr hst)
  have hg₂ : g 2 = 0 := by linear_combination h₀ - hg₁
  have hg₀ : g 0 = 0 := by linear_combination h₃ - s ^ 3 * hg₁ - t ^ 3 * hg₂
  intro i
  fin_cases i <;> assumption

/-- A finite cubic point, cubic infinity, and a second distinct finite cubic point are
independent. -/
theorem finiteInfinityFinite_linearIndependent {s t : 𝔽} (hst : s ≠ t) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 (.inl s),
      projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit),
      projectiveTwistedCubicPoints 𝔽 (.inl t)] := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  have h₀ := congrFun hrel (0 : Fin 4)
  have h₁ := congrFun hrel (1 : Fin 4)
  have h₃ := congrFun hrel (3 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₀ h₁ h₃
  simp [Fin.sum_univ_three, projectiveTwistedCubicPoints, momentCurve] at h₀ h₁ h₃
  have hprod : g 0 * (s - t) = 0 := by linear_combination h₁ - t * h₀
  have hg₀ : g 0 = 0 := (mul_eq_zero.mp hprod).resolve_right (sub_ne_zero.mpr hst)
  have hg₂ : g 2 = 0 := by linear_combination h₀ - hg₀
  have hg₁ : g 1 = 0 := by linear_combination h₃ - s ^ 3 * hg₀ - t ^ 3 * hg₂
  intro i
  fin_cases i <;> assumption

/-- Every three distinctly indexed points of the full projective cubic are independent. -/
theorem projectiveTwistedCubic_triple_linearIndependent
    {v : Fin 3 → ProjectiveTwistedCubicIndex 𝔽} (hv : Function.Injective v) :
    LinearIndependent 𝔽 (fun i => projectiveTwistedCubicPoints 𝔽 (v i)) := by
  rcases h₀ : v 0 with s | u <;> rcases h₁ : v 1 with t | w <;>
    rcases h₂ : v 2 with r | z
  · let p : Fin 3 → 𝔽 := ![s, t, r]
    have hp : Function.Injective p := by
      intro i j hij
      apply hv
      fin_cases i <;> fin_cases j <;> simp_all [p]
    convert twistedCubicTriple_omitAxis_linearIndependent hp using 1
    funext i
    fin_cases i <;> simp [h₀, h₁, h₂, p]
  · have hst : s ≠ t := by
      intro h
      apply hv.ne (show (0 : Fin 3) ≠ 1 by decide)
      rw [h₀, h₁, h]
    convert twoFiniteCubicInfinity_linearIndependent hst using 1
    funext i
    fin_cases i <;> simp [h₀, h₁, h₂]
  · have hsr : s ≠ r := by
      intro h
      apply hv.ne (show (0 : Fin 3) ≠ 2 by decide)
      rw [h₀, h₂, h]
    convert finiteInfinityFinite_linearIndependent hsr using 1
    funext i
    fin_cases i <;> simp [h₀, h₁, h₂]
  · exfalso
    apply hv.ne (show (1 : Fin 3) ≠ 2 by decide)
    rw [h₁, h₂]
  · have htr : t ≠ r := by
      intro h
      apply hv.ne (show (1 : Fin 3) ≠ 2 by decide)
      rw [h₁, h₂, h]
    convert cubicInfinityTwoFinite_linearIndependent htr using 1
    funext i
    fin_cases i <;> simp [h₀, h₁, h₂]
  · exfalso
    apply hv.ne (show (0 : Fin 3) ≠ 2 by decide)
    rw [h₀, h₂]
  · exfalso
    apply hv.ne (show (0 : Fin 3) ≠ 1 by decide)
    rw [h₀, h₁]
  · exfalso
    apply hv.ne (show (0 : Fin 3) ≠ 1 by decide)
    rw [h₀, h₁]

/-- Cubic infinity together with two distinct axis points is independent. -/
theorem cubicInfinityTwoAxis_linearIndependent {y z : 𝔽 ⊕ Unit} (hyz : y ≠ z) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit),
      axisTwistedCubicPoints 𝔽 (.inr y),
      axisTwistedCubicPoints 𝔽 (.inr z)] := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  have h₃ := congrFun hrel (3 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₃
  simp [Fin.sum_univ_three, projectiveTwistedCubicPoints] at h₃
  have hg₀ : g 0 = 0 := h₃
  have haxisrel :
      ∑ i : Fin 2, (![g 1, g 2] : Fin 2 → 𝔽) i •
        (![axisTwistedCubicPoints 𝔽 (.inr y), axisTwistedCubicPoints 𝔽 (.inr z)] :
          Fin 2 → (Fin 4 → 𝔽)) i = 0 := by
    simpa [Fin.sum_univ_three, Fin.sum_univ_two, projectiveTwistedCubicPoints, hg₀] using hrel
  have hcoeff := (Fintype.linearIndependent_iff.mp
    (twistedCubicAxis_pair_linearIndependent (𝔽 := 𝔽) hyz)) ![g 1, g 2] haxisrel
  have hg₁ : g 1 = 0 := hcoeff 0
  have hg₂ : g 2 = 0 := hcoeff 1
  intro i
  fin_cases i <;> assumption

/-- Two distinct full-projective cubic points and any axis point are independent in
characteristic three. -/
theorem projectiveTwoCubicAxis_linearIndependent [CharP 𝔽 3]
    {x y : ProjectiveTwistedCubicIndex 𝔽} (hxy : x ≠ y) (z : 𝔽 ⊕ Unit) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 x,
      projectiveTwistedCubicPoints 𝔽 y,
      axisTwistedCubicPoints 𝔽 (.inr z)] := by
  rcases x with s | u <;> rcases y with t | w
  · have hst : s ≠ t := fun h => hxy (congrArg Sum.inl h)
    cases z with
    | inl z =>
        convert twoCubicAxis_linearIndependent (𝔽 := 𝔽) (e₁ := 1) (e₂ := z) hst
          (Or.inl one_ne_zero) using 1
        funext i
        fin_cases i <;>
          simp [projectiveTwistedCubicPoints, twoCubicAxisFamily, twistedCubicAxisVector]
    | inr z =>
        convert twoCubicAxis_linearIndependent (𝔽 := 𝔽) (e₁ := 0) (e₂ := 1) hst
          (Or.inr one_ne_zero) using 1
        funext i
        fin_cases i <;>
          simp [projectiveTwistedCubicPoints, twoCubicAxisFamily, twistedCubicAxisVector]
  · simpa using finiteCubicInfinityAxis_linearIndependent s z
  · have hli := finiteCubicInfinityAxis_linearIndependent t z
    have hs₀ : Equiv.swap (0 : Fin 3) 1 0 = 1 := by decide
    have hs₁ : Equiv.swap (0 : Fin 3) 1 1 = 0 := by decide
    have hs₂ : Equiv.swap (0 : Fin 3) 1 2 = 2 := by decide
    exact (linearIndependent_equiv' (Equiv.swap 0 1) (by
      funext i
      fin_cases i <;> simp [hs₀, hs₁, hs₂])).2 hli
  · exact (hxy (by congr)).elim

/-- One full-projective cubic point and two distinct axis points are independent. -/
theorem projectiveOneCubicTwoAxis_linearIndependent
    (x : ProjectiveTwistedCubicIndex 𝔽) {y z : 𝔽 ⊕ Unit} (hyz : y ≠ z) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 x,
      axisTwistedCubicPoints 𝔽 (.inr y),
      axisTwistedCubicPoints 𝔽 (.inr z)] := by
  cases x with
  | inl s =>
      convert (oneCubicTwoAxis_linearIndependent (𝔽 := 𝔽) (s := s) hyz) using 1
      funext i
      fin_cases i <;>
        simp [projectiveTwistedCubicPoints, oneCubicTwoAxisFamily]
  | inr u => simpa using cubicInfinityTwoAxis_linearIndependent (𝔽 := 𝔽) hyz

/-- A finite cubic point, cubic infinity, and two distinct axis points are independent. -/
theorem finiteCubicInfinityTwoAxis_linearIndependent (s : 𝔽)
    {z w : 𝔽 ⊕ Unit} (hzw : z ≠ w) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 (.inl s),
      projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit),
      axisTwistedCubicPoints 𝔽 (.inr z),
      axisTwistedCubicPoints 𝔽 (.inr w)] := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  have h₀ := congrFun hrel (0 : Fin 4)
  have h₃ := congrFun hrel (3 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₀ h₃
  simp [Fin.sum_univ_four, projectiveTwistedCubicPoints, momentCurve] at h₀ h₃
  have hg₀ : g 0 = 0 := h₀
  have hg₁ : g 1 = 0 := by linear_combination h₃ - s ^ 3 * hg₀
  have haxisrel :
      ∑ i : Fin 2, (![g 2, g 3] : Fin 2 → 𝔽) i •
        (![axisTwistedCubicPoints 𝔽 (.inr z), axisTwistedCubicPoints 𝔽 (.inr w)] :
          Fin 2 → (Fin 4 → 𝔽)) i = 0 := by
    simpa [Fin.sum_univ_four, Fin.sum_univ_two, projectiveTwistedCubicPoints,
      momentCurve, hg₀, hg₁] using hrel
  have hcoeff := (Fintype.linearIndependent_iff.mp
    (twistedCubicAxis_pair_linearIndependent (𝔽 := 𝔽) hzw)) ![g 2, g 3] haxisrel
  have hg₂ : g 2 = 0 := hcoeff 0
  have hg₃ : g 3 = 0 := hcoeff 1
  intro i
  fin_cases i <;> assumption

/-- Two distinct full-projective cubic points and two distinct axis points are independent in
characteristic three. -/
theorem projectiveTwoCubicTwoAxis_linearIndependent [CharP 𝔽 3]
    {x y : ProjectiveTwistedCubicIndex 𝔽} (hxy : x ≠ y)
    {z w : 𝔽 ⊕ Unit} (hzw : z ≠ w) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 x,
      projectiveTwistedCubicPoints 𝔽 y,
      axisTwistedCubicPoints 𝔽 (.inr z),
      axisTwistedCubicPoints 𝔽 (.inr w)] := by
  rcases x with s | u <;> rcases y with t | v
  · have hst : s ≠ t := fun h => hxy (congrArg Sum.inl h)
    convert twoCubicTwoAxis_linearIndependent (𝔽 := 𝔽) hst hzw using 1
    funext i
    fin_cases i <;>
      simp [projectiveTwistedCubicPoints, twoCubicTwoAxisFamily]
  · simpa using finiteCubicInfinityTwoAxis_linearIndependent (𝔽 := 𝔽) s hzw
  · have hli := finiteCubicInfinityTwoAxis_linearIndependent (𝔽 := 𝔽) t hzw
    have hs₀ : Equiv.swap (0 : Fin 4) 1 0 = 1 := by decide
    have hs₁ : Equiv.swap (0 : Fin 4) 1 1 = 0 := by decide
    have hs₂ : Equiv.swap (0 : Fin 4) 1 2 = 2 := by decide
    have hs₃ : Equiv.swap (0 : Fin 4) 1 3 = 3 := by decide
    exact (linearIndependent_equiv' (Equiv.swap 0 1) (by
      funext i
      fin_cases i <;> simp [hs₀, hs₁, hs₂, hs₃])).2 hli
  · exact (hxy (by congr)).elim

set_option maxHeartbeats 800000 in
/-- Cubic infinity together with three distinct finite cubic points is linearly independent. -/
theorem cubicInfinityThreeFinite_linearIndependent {s t u : 𝔽}
    (hst : s ≠ t) (hsu : s ≠ u) (htu : t ≠ u) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit),
      projectiveTwistedCubicPoints 𝔽 (.inl s),
      projectiveTwistedCubicPoints 𝔽 (.inl t),
      projectiveTwistedCubicPoints 𝔽 (.inl u)] := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  let v : Fin 3 → 𝔽 := ![s, t, u]
  have hv : Function.Injective v := by
    intro i j hij
    fin_cases i <;> fin_cases j <;> simp_all [v]
  let c : Fin 3 → 𝔽 := ![g 1, g 2, g 3]
  have hrel3 : ∑ i : Fin 3, c i • momentCurve 3 (v i) = 0 := by
    funext j
    have hj := congrFun hrel j.castSucc
    simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at hj ⊢
    fin_cases j <;>
      simpa [Fin.sum_univ_four, Fin.sum_univ_three, c, v,
        projectiveTwistedCubicPoints, momentCurve] using hj
  have hc := (Fintype.linearIndependent_iff.mp
    (momentCurve_linearIndependent_of_card_le hv (by decide))) c hrel3
  have hg₁ : g 1 = 0 := hc 0
  have hg₂ : g 2 = 0 := hc 1
  have hg₃ : g 3 = 0 := hc 2
  have h₃ := congrFun hrel (3 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₃
  simp [Fin.sum_univ_four, projectiveTwistedCubicPoints, momentCurve, hg₁, hg₂, hg₃]
    at h₃
  have hg₀ : g 0 = 0 := h₃
  intro i
  fin_cases i <;> assumption

/-- The axis point `s+t` gives a dependent four-family with `s,t`, and cubic infinity. -/
theorem twoFiniteCubicInfinityAxis_dependent (s t : 𝔽) :
    ¬ LinearIndependent 𝔽
      (twoFiniteCubicInfinityAxisFamily s t (.inl (s + t))) := by
  intro hli
  let g : Fin 4 → 𝔽 := ![1, -1, -(s ^ 3 - t ^ 3), -(s - t)]
  have hrel : ∑ i, g i • twoFiniteCubicInfinityAxisFamily s t (.inl (s + t)) i = 0 := by
    funext j
    fin_cases j <;>
      simp [g, twoFiniteCubicInfinityAxisFamily, projectiveTwistedCubicPoints,
        axisTwistedCubicPoints, momentCurve, Fin.sum_univ_four] <;> ring
  have hg := (Fintype.linearIndependent_iff.mp hli) g hrel 0
  simp [g] at hg

/-- Any normalized axis completion of the two-finite-plus-infinity cubic triple is the finite
axis point `s+t`. -/
theorem twoFiniteCubicInfinityAxis_dependent_iff {s t : 𝔽} (hst : s ≠ t) (y : 𝔽 ⊕ Unit) :
    ¬ LinearIndependent 𝔽 (twoFiniteCubicInfinityAxisFamily s t y) ↔ y = .inl (s + t) := by
  constructor
  · intro hdep
    cases y with
    | inl u =>
        by_contra hu
        have hu' : u ≠ s + t := fun h => hu (congrArg Sum.inl h)
        apply hdep
        rw [Fintype.linearIndependent_iff]
        intro g hrel
        have h₀ := congrFun hrel (0 : Fin 4)
        have h₁ := congrFun hrel (1 : Fin 4)
        have h₂ := congrFun hrel (2 : Fin 4)
        have h₃ := congrFun hrel (3 : Fin 4)
        simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₀ h₁ h₂ h₃
        simp [twoFiniteCubicInfinityAxisFamily, projectiveTwistedCubicPoints,
          axisTwistedCubicPoints, momentCurve, Fin.sum_univ_four] at h₀ h₁ h₂ h₃
        have hprod : g 0 * ((s - t) * (s + t - u)) = 0 := by
          linear_combination h₂ - u * h₁ + (u * t - t ^ 2) * h₀
        have hst0 : s - t ≠ 0 := sub_ne_zero.mpr hst
        have hsum0 : s + t - u ≠ 0 := sub_ne_zero.mpr (Ne.symm hu')
        have hg₀ : g 0 = 0 :=
          (mul_eq_zero.mp hprod).resolve_right (mul_ne_zero hst0 hsum0)
        have hg₁ : g 1 = 0 := by linear_combination h₀ - hg₀
        have hg₃ : g 3 = 0 := by linear_combination h₁ - s * hg₀ - t * hg₁
        have hg₂ : g 2 = 0 := by
          linear_combination h₃ - s ^ 3 * hg₀ - t ^ 3 * hg₁
        intro i
        fin_cases i <;> assumption
    | inr u =>
        exfalso
        apply hdep
        rw [Fintype.linearIndependent_iff]
        intro g hrel
        have h₀ := congrFun hrel (0 : Fin 4)
        have h₁ := congrFun hrel (1 : Fin 4)
        have h₂ := congrFun hrel (2 : Fin 4)
        have h₃ := congrFun hrel (3 : Fin 4)
        simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₀ h₁ h₂ h₃
        simp [twoFiniteCubicInfinityAxisFamily, projectiveTwistedCubicPoints,
          axisTwistedCubicPoints, momentCurve, Fin.sum_univ_four] at h₀ h₁ h₂ h₃
        have hprod : g 0 * (s - t) = 0 := by linear_combination h₁ - t * h₀
        have hg₀ : g 0 = 0 :=
          (mul_eq_zero.mp hprod).resolve_right (sub_ne_zero.mpr hst)
        have hg₁ : g 1 = 0 := by linear_combination h₀ - hg₀
        have hg₃ : g 3 = 0 := by linear_combination h₂ - s ^ 2 * hg₀ - t ^ 2 * hg₁
        have hg₂ : g 2 = 0 := by
          linear_combination h₃ - s ^ 3 * hg₀ - t ^ 3 * hg₁
        intro i
        fin_cases i <;> assumption
  · rintro rfl
    exact twoFiniteCubicInfinityAxis_dependent s t

/-- The projective-boundary completion is a genuine four-circuit. -/
theorem twoFiniteCubicInfinityAxis_isFourCircuit [CharP 𝔽 3] {s t : 𝔽} (hst : s ≠ t) :
    ¬ LinearIndependent 𝔽 (twoFiniteCubicInfinityAxisFamily s t (.inl (s + t))) ∧
      LinearIndependent 𝔽 ![
        projectiveTwistedCubicPoints 𝔽 (.inl t),
        projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit),
        axisTwistedCubicPoints 𝔽 (.inr (.inl (s + t)))] ∧
      LinearIndependent 𝔽 ![
        projectiveTwistedCubicPoints 𝔽 (.inl s),
        projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit),
        axisTwistedCubicPoints 𝔽 (.inr (.inl (s + t)))] ∧
      LinearIndependent 𝔽 ![
        projectiveTwistedCubicPoints 𝔽 (.inl s),
        projectiveTwistedCubicPoints 𝔽 (.inl t),
        axisTwistedCubicPoints 𝔽 (.inr (.inl (s + t)))] ∧
      LinearIndependent 𝔽 ![
        projectiveTwistedCubicPoints 𝔽 (.inl s),
        projectiveTwistedCubicPoints 𝔽 (.inl t),
        projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit)] := by
  refine ⟨twoFiniteCubicInfinityAxis_dependent s t,
    finiteCubicInfinityAxis_linearIndependent t (.inl (s + t)),
    finiteCubicInfinityAxis_linearIndependent s (.inl (s + t)), ?_,
    twoFiniteCubicInfinity_linearIndependent hst⟩
  convert (twoCubicAxis_linearIndependent (𝔽 := 𝔽) (e₁ := 1) (e₂ := s + t) hst
    (Or.inl one_ne_zero)) using 1
  funext i
  fin_cases i <;>
    simp [projectiveTwistedCubicPoints, twoCubicAxisFamily, twistedCubicAxisVector]

#print axioms twoFiniteCubicInfinityAxis_dependent_iff
#print axioms twoFiniteCubicInfinityAxis_isFourCircuit
#print axioms projectiveTwistedCubic_triple_linearIndependent
#print axioms projectiveTwoCubicAxis_linearIndependent
#print axioms projectiveOneCubicTwoAxis_linearIndependent
#print axioms projectiveTwoCubicTwoAxis_linearIndependent
#print axioms cubicInfinityThreeFinite_linearIndependent

end FiniteGeom
