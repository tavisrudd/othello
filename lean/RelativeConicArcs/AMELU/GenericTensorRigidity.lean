import RelativeConicArcs.AMELU.GenericMarginalCovariance
import RelativeConicArcs.AMELU.GenericDiagonalTensor
import Mathlib.Data.Fintype.EquivFin

/-!
# Axis recovery for full diagonal tensors of arbitrary arity

An array on a finite family of factors is pure when it is a nonzero product
of one-factor functions.  Independent invertible maps preserve and reflect
this locus.  Contracting one factor of a full diagonal array is pure exactly
on a coordinate covector, provided at least two factors remain.  It follows
that every factor map in a product equivalence between full diagonal arrays
is monomial.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset

variable {ι κ : Type*} [Fintype ι] [DecidableEq ι]
  [Fintype κ] [DecidableEq κ]

/-- A complex array with one `κ`-coordinate for each factor in `ι`. -/
abbrev FamilyArray (ι κ : Type*) := (ι → κ) → ℂ

/-- A nonzero pure family array is a product of nonzero one-factor
functions. -/
def IsNonzeroPureFamilyArray (T : FamilyArray ι κ) : Prop :=
  ∃ f : ι → (κ → ℂ),
    (∀ i, f i ≠ 0) ∧ ∀ x, T x = ∏ i, f i (x i)

/-- Independent action of a linear equivalence on every factor. -/
noncomputable def mapFamilyArray
    (A : ι → ((κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)))
    (T : FamilyArray ι κ) : FamilyArray ι κ :=
  fun x =>
    ∑ y, T y *
      ∏ i, A i (coordinateVector (y i) 1) (x i)

/-- The full diagonal family array with the displayed coefficients. -/
def diagonalFamilyArray (coeff : κ → ℂ) : FamilyArray ι κ :=
  fun x =>
    ∑ t, coeff t * coordinateVector (fun _ : ι => t) 1 x

private theorem family_function_eq_sum_coordinateVector
    (T : FamilyArray ι κ) :
    T = ∑ y, T y • coordinateVector y 1 := by
  classical
  funext x
  simp [coordinateVector]

private theorem oneFactor_function_eq_sum_coordinateVector
    (f : κ → ℂ) :
    f = ∑ t, f t • coordinateVector t 1 := by
  classical
  funext x
  simp [coordinateVector]

set_option maxHeartbeats 800000 in
private theorem mapFamilyArray_pure_formula
    (A : ι → ((κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)))
    (f : ι → (κ → ℂ)) :
    mapFamilyArray A (fun x => ∏ i, f i (x i)) =
      fun x => ∏ i, A i (f i) (x i) := by
  classical
  funext x
  unfold mapFamilyArray
  have hlocal (i : ι) :
      A i (f i) (x i) =
        ∑ t, f i t * A i (coordinateVector t 1) (x i) := by
    conv_lhs =>
      rw [oneFactor_function_eq_sum_coordinateVector (f i)]
    simp [map_sum, map_smul]
  simp_rw [hlocal]
  calc
    (∑ y : ι → κ, (∏ i : ι, f i (y i)) *
        ∏ i : ι, A i (coordinateVector (y i) 1) (x i)) =
        ∑ y : ι → κ, ∏ i : ι,
          (f i (y i) *
            A i (coordinateVector (y i) 1) (x i)) := by
          apply Finset.sum_congr rfl
          intro y _
          rw [Finset.prod_mul_distrib]
    _ = ∏ i : ι, ∑ t : κ,
        f i t * A i (coordinateVector t 1) (x i) := by
      exact (Fintype.prod_sum
        (fun i t =>
          f i t * A i (coordinateVector t 1) (x i))).symm

/-- Independent invertible factor maps preserve nonzero pure arrays. -/
theorem mapFamilyArray_pure
    (A : ι → ((κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)))
    {T : FamilyArray ι κ} (hT : IsNonzeroPureFamilyArray T) :
    IsNonzeroPureFamilyArray (mapFamilyArray A T) := by
  obtain ⟨f, hf, hTf⟩ := hT
  have hT' : T = fun x => ∏ i, f i (x i) := by
    funext x
    exact hTf x
  rw [hT']
  refine ⟨fun i => A i (f i), ?_, ?_⟩
  · intro i hzero
    exact hf i ((A i).injective (by simpa using hzero))
  · exact congrFun (mapFamilyArray_pure_formula A f)

private theorem mapFamilyArray_coordinateVector
    (A : ι → ((κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)))
    (v : ι → κ) :
    mapFamilyArray A (coordinateVector v 1) =
      fun x => ∏ i, A i (coordinateVector (v i) 1) (x i) := by
  classical
  funext x
  unfold mapFamilyArray
  rw [Fintype.sum_eq_single v]
  · simp [coordinateVector]
  · intro y hyv
    simp [coordinateVector, hyv]

private theorem mapFamilyArray_add
    (A : ι → ((κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)))
    (T R : FamilyArray ι κ) :
    mapFamilyArray A (T + R) =
      mapFamilyArray A T + mapFamilyArray A R := by
  funext x
  simp [mapFamilyArray, add_mul, Finset.sum_add_distrib]

private theorem mapFamilyArray_smul
    (A : ι → ((κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)))
    (z : ℂ) (T : FamilyArray ι κ) :
    mapFamilyArray A (z • T) = z • mapFamilyArray A T := by
  funext x
  simp only [mapFamilyArray, Pi.smul_apply, smul_eq_mul, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro y _
  ring

private theorem mapFamilyArray_sum
    (A : ι → ((κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)))
    {α : Type*} [Fintype α] (T : α → FamilyArray ι κ) :
    mapFamilyArray A (∑ a, T a) = ∑ a, mapFamilyArray A (T a) := by
  classical
  funext x
  simp only [mapFamilyArray, Finset.sum_apply, Finset.sum_mul]
  rw [Finset.sum_comm]

private theorem mapFamilyArray_symm_map
    (A : ι → ((κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)))
    (T : FamilyArray ι κ) :
    mapFamilyArray (fun i => (A i).symm) (mapFamilyArray A T) = T := by
  classical
  conv_rhs =>
    rw [family_function_eq_sum_coordinateVector T]
  rw [show mapFamilyArray A T =
      ∑ v, T v • mapFamilyArray A (coordinateVector v 1) by
    conv_lhs =>
      rw [family_function_eq_sum_coordinateVector T]
    rw [mapFamilyArray_sum]
    apply Finset.sum_congr rfl
    intro v _
    rw [mapFamilyArray_smul]]
  rw [mapFamilyArray_sum]
  apply Finset.sum_congr rfl
  intro v _
  rw [mapFamilyArray_smul, mapFamilyArray_coordinateVector]
  rw [mapFamilyArray_pure_formula]
  congr 1
  funext x
  simp_rw [(A _).symm_apply_apply]
  by_cases hvx : v = x
  · subst x
    simp [coordinateVector]
  · obtain ⟨i, hi⟩ : ∃ i, v i ≠ x i := by
      by_contra hpoint
      push Not at hpoint
      exact hvx (funext hpoint)
    rw [Finset.prod_eq_zero (Finset.mem_univ i)]
    · have hxv : x ≠ v := Ne.symm hvx
      simp [coordinateVector, hxv]
    · have hxivi : x i ≠ v i := Ne.symm hi
      simp [coordinateVector, hxivi]

/-- Independent invertible factor maps preserve and reflect the nonzero
pure-array locus. -/
theorem mapFamilyArray_pure_iff
    (A : ι → ((κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)))
    (T : FamilyArray ι κ) :
    IsNonzeroPureFamilyArray (mapFamilyArray A T) ↔
      IsNonzeroPureFamilyArray T := by
  constructor
  · intro h
    have := mapFamilyArray_pure (fun i => (A i).symm) h
    rwa [mapFamilyArray_symm_map] at this
  · exact mapFamilyArray_pure A

/-- Successive independent factor maps compose factor by factor. -/
theorem mapFamilyArray_comp
    (A B : ι → ((κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)))
    (T : FamilyArray ι κ) :
    mapFamilyArray A (mapFamilyArray B T) =
      mapFamilyArray (fun i => B i ≪≫ₗ A i) T := by
  classical
  conv_lhs =>
    rw [show T = ∑ v, T v • coordinateVector v 1 by
      exact family_function_eq_sum_coordinateVector T]
  rw [mapFamilyArray_sum, mapFamilyArray_sum]
  conv_rhs =>
    rw [show T = ∑ v, T v • coordinateVector v 1 by
      exact family_function_eq_sum_coordinateVector T]
  rw [mapFamilyArray_sum]
  apply Finset.sum_congr rfl
  intro v _
  rw [mapFamilyArray_smul, mapFamilyArray_smul,
    mapFamilyArray_smul, mapFamilyArray_coordinateVector,
    mapFamilyArray_pure_formula, mapFamilyArray_coordinateVector]
  rfl

/-- A family obtained by deleting one distinguished factor. -/
abbrev RemainingFactor (i : ι) := {j : ι // j ≠ i}

/-- Insert one coordinate into an assignment on the remaining factors. -/
def insertFamilyCoordinate (i : ι) (a : κ)
    (y : RemainingFactor i → κ) : ι → κ :=
  fun j => if h : j = i then a else y ⟨j, h⟩

/-- Restrict an assignment to all factors except the distinguished one. -/
def restrictFamilyCoordinate (i : ι) (v : ι → κ) :
    RemainingFactor i → κ :=
  fun j => v j.1

omit [Fintype ι] [Fintype κ] [DecidableEq κ] in
private theorem insert_restrictFamilyCoordinate
    (i : ι) (v : ι → κ) :
    insertFamilyCoordinate i (v i) (restrictFamilyCoordinate i v) = v := by
  funext j
  by_cases h : j = i
  · subst j
    simp [insertFamilyCoordinate]
  · simp [insertFamilyCoordinate, restrictFamilyCoordinate, h]

/-- Contract one factor of a family array against a coordinate covector. -/
def contractFamilyFactor (i : ι) (x : κ → ℂ)
    (T : FamilyArray ι κ) : FamilyArray (RemainingFactor i) κ :=
  fun y => ∑ a, x a * T (insertFamilyCoordinate i a y)

private theorem contractFamilyFactor_coordinateVector
    (i : ι) (x : κ → ℂ) (v : ι → κ) :
    contractFamilyFactor i x (coordinateVector v 1) =
      x (v i) • coordinateVector (restrictFamilyCoordinate i v) 1 := by
  classical
  funext y
  unfold contractFamilyFactor
  rw [Fintype.sum_eq_single (v i)]
  · by_cases hy :
        y = restrictFamilyCoordinate i v
    · subst y
      simp [insert_restrictFamilyCoordinate, coordinateVector]
    · have hins :
          insertFamilyCoordinate i (v i) y ≠ v := by
        intro h
        apply hy
        funext j
        have hj := congrFun h j.1
        simpa [insertFamilyCoordinate, restrictFamilyCoordinate, j.2] using hj
      simp [coordinateVector, hy, hins]
  · intro a ha
    have hins :
        insertFamilyCoordinate i a y ≠ v := by
      intro h
      have hi := congrFun h i
      simp [insertFamilyCoordinate] at hi
      exact ha hi
    simp [coordinateVector, hins]

omit [Fintype ι] [DecidableEq κ] in
private theorem contractFamilyFactor_add
    (i : ι) (x : κ → ℂ) (T R : FamilyArray ι κ) :
    contractFamilyFactor i x (T + R) =
      contractFamilyFactor i x T + contractFamilyFactor i x R := by
  funext y
  simp [contractFamilyFactor, mul_add, Finset.sum_add_distrib]

omit [Fintype ι] [DecidableEq κ] in
private theorem contractFamilyFactor_smul
    (i : ι) (x : κ → ℂ) (z : ℂ) (T : FamilyArray ι κ) :
    contractFamilyFactor i x (z • T) =
      z • contractFamilyFactor i x T := by
  funext y
  simp only [contractFamilyFactor, Pi.smul_apply, smul_eq_mul,
    Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro a _
  ring

omit [Fintype ι] [DecidableEq κ] in
private theorem contractFamilyFactor_sum
    (i : ι) (x : κ → ℂ)
    {α : Type*} [Fintype α] (T : α → FamilyArray ι κ) :
    contractFamilyFactor i x (∑ a, T a) =
      ∑ a, contractFamilyFactor i x (T a) := by
  classical
  funext y
  simp only [contractFamilyFactor, Finset.sum_apply, Finset.mul_sum]
  rw [Finset.sum_comm]

private theorem diagonalFamilyArray_eq_sum
    {ρ : Type*} [Fintype ρ]
    (coeff : κ → ℂ) :
    diagonalFamilyArray (ι := ρ) coeff =
      ∑ t, coeff t • coordinateVector (fun _ : ρ => t) 1 := by
  unfold diagonalFamilyArray
  funext y
  simp [Pi.smul_apply, smul_eq_mul]

/-- Contracting a full diagonal family array gives the full diagonal array
on the remaining factors with coefficient multiplied by the covector. -/
theorem contractFamilyFactor_diagonal
    (i : ι) (x coeff : κ → ℂ) :
    contractFamilyFactor i x
        (diagonalFamilyArray (ι := ι) coeff) =
      diagonalFamilyArray (ι := RemainingFactor i)
        (fun t => coeff t * x t) := by
  classical
  rw [diagonalFamilyArray_eq_sum,
    diagonalFamilyArray_eq_sum]
  rw [contractFamilyFactor_sum]
  apply Finset.sum_congr rfl
  intro t _
  rw [contractFamilyFactor_smul,
    contractFamilyFactor_coordinateVector]
  ext y
  have hrest :
      restrictFamilyCoordinate i (fun _ : ι => t) =
        (fun _ : RemainingFactor i => t) := rfl
  rw [hrest]
  simp only [Pi.smul_apply, smul_eq_mul]
  ring

omit [Fintype ι] [DecidableEq ι] [DecidableEq κ] in
private theorem function_exists_apply_ne_zero
    {f : κ → ℂ} (hf : f ≠ 0) :
    ∃ t, f t ≠ 0 := by
  by_contra h
  apply hf
  funext t
  exact not_ne_iff.mp (not_exists.mp h t)

omit [Fintype ι] [DecidableEq ι] [Fintype κ] in
private theorem family_coordinateVector_ne_zero
    {t : κ} {z : ℂ} (hz : z ≠ 0) :
    coordinateVector t z ≠ 0 := by
  intro h
  have ht := congrFun h t
  simp [coordinateVector, hz] at ht

private theorem diagonalFamilyArray_constant
    {ρ : Type*} [Fintype ρ] [DecidableEq ρ] [Nonempty ρ]
    (coeff : κ → ℂ) (t : κ) :
    diagonalFamilyArray (ι := ρ) coeff (fun _ => t) = coeff t := by
  classical
  unfold diagonalFamilyArray
  rw [Fintype.sum_eq_single t]
  · simp [coordinateVector]
  · intro s hst
    have hfun : (fun _ : ρ => s) ≠ fun _ => t := by
      intro h
      have := congrFun h (Classical.choice inferInstance)
      exact hst this
    have hfun' : (fun _ : ρ => t) ≠ fun _ => s := Ne.symm hfun
    simp [coordinateVector, hfun']

private theorem diagonalFamilyArray_zero_of_not_constant
    {ρ : Type*} [Fintype ρ] [DecidableEq ρ]
    (coeff : κ → ℂ) (y : ρ → κ)
    (hy : ¬ ∃ t, y = fun _ => t) :
    diagonalFamilyArray (ι := ρ) coeff y = 0 := by
  classical
  unfold diagonalFamilyArray
  apply Finset.sum_eq_zero
  intro t _
  have hfun : y ≠ fun _ : ρ => t := by
    intro h
    exact hy ⟨t, h⟩
  simp [coordinateVector, hfun]

/-- A full diagonal array on at least two factors is nonzero pure exactly
when its displayed diagonal coefficient function lies on one coordinate
axis. -/
theorem diagonalFamilyArray_pure_iff_coordinateAxis
    {ρ : Type*} [Fintype ρ] [DecidableEq ρ]
    (hρ : 2 ≤ Fintype.card ρ)
    {coeff x : κ → ℂ} (hcoeff : ∀ t, coeff t ≠ 0)
    (hx : x ≠ 0) :
    IsNonzeroPureFamilyArray
        (diagonalFamilyArray (ι := ρ) (fun t => coeff t * x t)) ↔
      IsNonzeroCoordinateAxis x := by
  classical
  letI : Nonempty ρ :=
    Fintype.card_pos_iff.mp (by omega)
  constructor
  · rintro ⟨f, hf, hpure⟩
    obtain ⟨t, hxt⟩ := function_exists_apply_ne_zero hx
    have hprod_t :
        (∏ j : ρ, f j t) = coeff t * x t := by
      rw [← hpure (fun _ => t),
        diagonalFamilyArray_constant]
    have hft : ∀ j : ρ, f j t ≠ 0 := by
      intro j
      have hp : (∏ j : ρ, f j t) ≠ 0 := by
        rw [hprod_t]
        exact mul_ne_zero (hcoeff t) hxt
      exact (Finset.prod_ne_zero_iff.mp hp) j (Finset.mem_univ j)
    refine ⟨t, x t, hxt, ?_⟩
    funext s
    by_cases hst : s = t
    · subst s
      simp [coordinateVector]
    · have hxs : x s = 0 := by
        by_contra hxs
        have hprod_s :
            (∏ j : ρ, f j s) = coeff s * x s := by
          rw [← hpure (fun _ => s),
            diagonalFamilyArray_constant]
        have hfs : ∀ j : ρ, f j s ≠ 0 := by
          intro j
          have hp : (∏ j : ρ, f j s) ≠ 0 := by
            rw [hprod_s]
            exact mul_ne_zero (hcoeff s) hxs
          exact (Finset.prod_ne_zero_iff.mp hp) j (Finset.mem_univ j)
        let p : ρ := Classical.choice (inferInstance : Nonempty ρ)
        obtain ⟨q, hqp⟩ :=
          Fintype.exists_ne_of_one_lt_card
            (by omega : 1 < Fintype.card ρ) p
        have hpq : p ≠ q := Ne.symm hqp
        let y : ρ → κ := fun j => if j = p then s else t
        have hynot : ¬ ∃ a, y = fun _ => a := by
          rintro ⟨a, ha⟩
          have hap := congrFun ha p
          have haq := congrFun ha q
          simp [y] at hap
          have hqp : q ≠ p := Ne.symm hpq
          simp [y, hqp] at haq
          exact hst (hap.trans haq.symm)
        have hzero :
            diagonalFamilyArray (ι := ρ)
                (fun r => coeff r * x r) y = 0 :=
          diagonalFamilyArray_zero_of_not_constant _ y hynot
        rw [hpure] at hzero
        have hnonzero : (∏ j : ρ, f j (y j)) ≠ 0 := by
          apply Finset.prod_ne_zero_iff.mpr
          intro j _
          by_cases hjp : j = p
          · subst j
            simpa [y] using hfs p
          · simpa [y, hjp] using hft j
        exact hnonzero hzero
      simp [coordinateVector, hst, hxs]
  · rintro ⟨t, z, hz, rfl⟩
    let p : ρ := Classical.choice (inferInstance : Nonempty ρ)
    let f : ρ → (κ → ℂ) :=
      fun j =>
        if j = p then coordinateVector t (coeff t * z)
        else coordinateVector t 1
    refine ⟨f, ?_, ?_⟩
    · intro j
      by_cases hj : j = p
      · subst j
        simpa [f] using
          family_coordinateVector_ne_zero
            (mul_ne_zero (hcoeff t) hz)
      · simpa [f, hj] using
          family_coordinateVector_ne_zero (t := t) one_ne_zero
    · intro y
      by_cases hy : y = fun _ : ρ => t
      · subst y
        rw [diagonalFamilyArray_constant]
        rw [← Finset.mul_prod_erase Finset.univ
          (fun j => f j t) (Finset.mem_univ p)]
        have hone :
            (∏ j ∈ Finset.univ.erase p, f j t) = 1 := by
          apply Finset.prod_eq_one
          intro j hj
          have hjp : j ≠ p := (Finset.mem_erase.mp hj).1
          simp [f, hjp, coordinateVector]
        rw [hone, mul_one]
        simp [f, coordinateVector]
      · have hleft :
            diagonalFamilyArray (ι := ρ)
                (fun r => coeff r * coordinateVector t z r) y = 0 := by
          unfold diagonalFamilyArray
          rw [Fintype.sum_eq_single t]
          · simp [coordinateVector, hy]
          · intro s hst
            simp [coordinateVector, hst]
        have hpoint : ∃ j, y j ≠ t := by
          by_contra hpoint
          push Not at hpoint
          exact hy (funext hpoint)
        obtain ⟨j, hj⟩ := hpoint
        rw [hleft]
        symm
        rw [Finset.prod_eq_zero (Finset.mem_univ j)]
        by_cases hjp : j = p
        · subst j
          simp [f, coordinateVector, hj]
        · simp [f, hjp, coordinateVector, hj]

private theorem contractFamilyFactor_map_coordinateVector
    (A : ι → ((κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)))
    (i : ι) (x : κ → ℂ) (v : ι → κ) :
    contractFamilyFactor i x
        (mapFamilyArray A (coordinateVector v 1)) =
      mapFamilyArray (fun j : RemainingFactor i => A j.1)
        (contractFamilyFactor i
          (transposeCoordinateAction (A i) x)
          (coordinateVector v 1)) := by
  classical
  rw [mapFamilyArray_coordinateVector,
    contractFamilyFactor_coordinateVector,
    mapFamilyArray_smul,
    mapFamilyArray_coordinateVector]
  funext y
  unfold contractFamilyFactor transposeCoordinateAction
  have hprod (a : κ) :
      (∏ j : ι,
        A j (coordinateVector (v j) 1)
          (insertFamilyCoordinate i a y j)) =
        A i (coordinateVector (v i) 1) a *
          ∏ j : RemainingFactor i,
            A j.1 (coordinateVector (v j.1) 1) (y j) := by
    rw [← Finset.mul_prod_erase Finset.univ
      (fun j =>
        A j (coordinateVector (v j) 1)
          (insertFamilyCoordinate i a y j))
      (Finset.mem_univ i)]
    congr 1
    · simp [insertFamilyCoordinate]
    · rw [Finset.prod_subtype
        (p := fun j : ι => j ≠ i) (Finset.univ.erase i) (by
          intro j
          simp)]
      apply Finset.prod_congr rfl
      intro j _
      simp [insertFamilyCoordinate, j.2]
  simp_rw [hprod]
  let P : ℂ :=
    ∏ j : RemainingFactor i,
      A j.1 (coordinateVector (v j.1) 1) (y j)
  change
    (∑ a, x a *
      (A i (coordinateVector (v i) 1) a * P)) =
      (∑ a, x a * A i (coordinateVector (v i) 1) a) * P
  rw [Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro a _
  ring

/-- Contracting a product-transformed family array transports the
contracting covector by the transpose of that factor and applies the
remaining factor maps to the contraction. -/
theorem contractFamilyFactor_mapFamilyArray
    (A : ι → ((κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)))
    (i : ι) (x : κ → ℂ) (T : FamilyArray ι κ) :
    contractFamilyFactor i x (mapFamilyArray A T) =
      mapFamilyArray (fun j : RemainingFactor i => A j.1)
        (contractFamilyFactor i
          (transposeCoordinateAction (A i) x) T) := by
  classical
  conv_lhs =>
    rw [show T = ∑ v, T v • coordinateVector v 1 by
      exact family_function_eq_sum_coordinateVector T]
  rw [mapFamilyArray_sum, contractFamilyFactor_sum]
  conv_rhs =>
    rw [show T = ∑ v, T v • coordinateVector v 1 by
      exact family_function_eq_sum_coordinateVector T]
  rw [contractFamilyFactor_sum, mapFamilyArray_sum]
  apply Finset.sum_congr rfl
  intro v _
  rw [mapFamilyArray_smul, contractFamilyFactor_smul,
    contractFamilyFactor_smul, mapFamilyArray_smul,
    contractFamilyFactor_map_coordinateVector]

private theorem transposeCoordinateAction_coordinateVector_ne_zero
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)) (u : κ) :
    transposeCoordinateAction A (coordinateVector u 1) ≠ 0 := by
  classical
  intro hzero
  let f := A.symm (coordinateVector u 1)
  have hAu : A f u = 1 := by
    rw [A.apply_symm_apply]
    simp [coordinateVector]
  have hexpand :
      A f u =
        ∑ t, f t * A (coordinateVector t 1) u := by
    conv_lhs =>
      rw [oneFactor_function_eq_sum_coordinateVector f]
    simp [map_sum, map_smul]
  have hrow (t : κ) :
      A (coordinateVector t 1) u = 0 := by
    have ht := congrFun hzero t
    simpa [transposeCoordinateAction, coordinateVector] using ht
  simp_rw [hrow, mul_zero, Finset.sum_const_zero] at hexpand
  exact one_ne_zero (hAu ▸ hexpand)

/-- In a product equivalence between full diagonal arrays on at least three
factors, every factor equivalence carries coordinate axes to coordinate
axes. -/
theorem familyFactor_coordinateAxes_of_diagonal_equivalent
    (hι : 3 ≤ Fintype.card ι)
    (A : ι → ((κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)))
    {coeff target : κ → ℂ}
    (hcoeff : ∀ t, coeff t ≠ 0)
    (htarget : ∀ t, target t ≠ 0)
    (hmap :
      mapFamilyArray A (diagonalFamilyArray (ι := ι) coeff) =
        diagonalFamilyArray (ι := ι) target) :
    ∀ i t, IsNonzeroCoordinateAxis
      (A i (coordinateVector t 1)) := by
  classical
  intro i
  apply coordinate_axes_of_transposeCoordinate_axes (A i)
  intro u
  have hcard :
      2 ≤ Fintype.card (RemainingFactor i) := by
    simp [RemainingFactor]
    omega
  let row :=
    transposeCoordinateAction (A i) (coordinateVector u 1)
  have hrow0 : row ≠ 0 :=
    transposeCoordinateAction_coordinateVector_ne_zero (A i) u
  have hpureTarget :
      IsNonzeroPureFamilyArray
        (contractFamilyFactor i (coordinateVector u 1)
          (diagonalFamilyArray (ι := ι) target)) := by
    rw [contractFamilyFactor_diagonal]
    apply
      (diagonalFamilyArray_pure_iff_coordinateAxis
        hcard htarget
          (family_coordinateVector_ne_zero (t := u) one_ne_zero)).2
    exact ⟨u, 1, one_ne_zero, rfl⟩
  have hpureMapped :
      IsNonzeroPureFamilyArray
        (contractFamilyFactor i (coordinateVector u 1)
          (mapFamilyArray A
            (diagonalFamilyArray (ι := ι) coeff))) := by
    rw [hmap]
    exact hpureTarget
  rw [contractFamilyFactor_mapFamilyArray,
    mapFamilyArray_pure_iff,
    contractFamilyFactor_diagonal] at hpureMapped
  exact
    (diagonalFamilyArray_pure_iff_coordinateAxis
      hcard hcoeff hrow0).1 hpureMapped

end RelativeConicArcs.AMELU
