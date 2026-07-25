import RelativeConicArcs.AMELU.DiagonalTensor
import Mathlib.LinearAlgebra.Basis.Basic

/-!
# Product equivalences of full diagonal four-tensors

This module supplies the product-map consequence of the intrinsic
contraction lemma.  A complex linear equivalence acts independently in
each factor of a four-array.  If four such equivalences carry one full
diagonal tensor, with every diagonal coefficient nonzero, to another,
then each factor equivalence permutes the displayed coordinate axes.

The proof contracts one factor, transports the contraction through the
other three equivalences, and applies
`diagonalTensorContraction_pure_iff_coordinateAxis`.  The resulting
statement first identifies the rows of a factor map as coordinate
vectors.  Invertibility makes their supports distinct, hence also makes
every column a coordinate vector.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset

variable {κ : Type*} [Fintype κ] [DecidableEq κ]

/-- Action of a linear equivalence on the first factor of a three-array. -/
def mapThreeFirst (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (T : ThreeArray κ) : ThreeArray κ :=
  fun i j k => A (fun p => T p j k) i

/-- Action of a linear equivalence on the second factor of a three-array. -/
def mapThreeSecond (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (T : ThreeArray κ) : ThreeArray κ :=
  fun i j k => A (fun p => T i p k) j

/-- Action of a linear equivalence on the third factor of a three-array. -/
def mapThreeThird (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (T : ThreeArray κ) : ThreeArray κ :=
  fun i j k => A (fun p => T i j p) k

/-- Independent action on all factors of a three-array. -/
def mapThreeArray (A B C : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (T : ThreeArray κ) : ThreeArray κ :=
  mapThreeFirst A (mapThreeSecond B (mapThreeThird C T))

omit [Fintype κ] [DecidableEq κ] in
private theorem linearEquiv_apply_ne_zero
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)) {x : κ → ℂ} (hx : x ≠ 0) :
    A x ≠ 0 := by
  exact fun h => hx (A.injective (h.trans (map_zero A).symm))

omit [Fintype κ] [DecidableEq κ] in
private theorem mapThreeFirst_pure
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)) {T : ThreeArray κ}
    (hT : IsNonzeroPureThreeArray T) :
    IsNonzeroPureThreeArray (mapThreeFirst A T) := by
  obtain ⟨a, b, c, ha, hb, hc, hfactor⟩ := hT
  refine ⟨A a, b, c, linearEquiv_apply_ne_zero A ha, hb, hc, ?_⟩
  intro i j k
  have hs :
      (fun p => T p j k) = (b j * c k) • a := by
    funext p
    simp [hfactor]
    ring
  rw [mapThreeFirst, hs, map_smul]
  simp [mul_assoc, mul_left_comm, mul_comm]

omit [Fintype κ] [DecidableEq κ] in
private theorem mapThreeSecond_pure
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)) {T : ThreeArray κ}
    (hT : IsNonzeroPureThreeArray T) :
    IsNonzeroPureThreeArray (mapThreeSecond A T) := by
  obtain ⟨a, b, c, ha, hb, hc, hfactor⟩ := hT
  refine ⟨a, A b, c, ha, linearEquiv_apply_ne_zero A hb, hc, ?_⟩
  intro i j k
  have hs :
      (fun p => T i p k) = (a i * c k) • b := by
    funext p
    simp [hfactor]
    ring
  rw [mapThreeSecond, hs, map_smul]
  simp
  ring

omit [Fintype κ] [DecidableEq κ] in
private theorem mapThreeThird_pure
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)) {T : ThreeArray κ}
    (hT : IsNonzeroPureThreeArray T) :
    IsNonzeroPureThreeArray (mapThreeThird A T) := by
  obtain ⟨a, b, c, ha, hb, hc, hfactor⟩ := hT
  refine ⟨a, b, A c, ha, hb, linearEquiv_apply_ne_zero A hc, ?_⟩
  intro i j k
  have hs :
      (fun p => T i j p) = (a i * b j) • c := by
    funext p
    simp [hfactor]
  rw [mapThreeThird, hs, map_smul]
  simp [mul_assoc]

omit [Fintype κ] [DecidableEq κ] in
private theorem mapThreeFirst_symm_mapThreeFirst
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)) (T : ThreeArray κ) :
    mapThreeFirst A.symm (mapThreeFirst A T) = T := by
  funext i j k
  exact congrFun (A.symm_apply_apply (fun p => T p j k)) i

omit [Fintype κ] [DecidableEq κ] in
private theorem mapThreeSecond_symm_mapThreeSecond
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)) (T : ThreeArray κ) :
    mapThreeSecond A.symm (mapThreeSecond A T) = T := by
  funext i j k
  exact congrFun (A.symm_apply_apply (fun p => T i p k)) j

omit [Fintype κ] [DecidableEq κ] in
private theorem mapThreeThird_symm_mapThreeThird
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)) (T : ThreeArray κ) :
    mapThreeThird A.symm (mapThreeThird A T) = T := by
  funext i j k
  exact congrFun (A.symm_apply_apply (fun p => T i j p)) k

omit [Fintype κ] [DecidableEq κ] in
/-- Independent invertible factor maps preserve and reflect the property
of being a nonzero pure three-array. -/
theorem mapThreeArray_pure_iff
    (A B C : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)) (T : ThreeArray κ) :
    IsNonzeroPureThreeArray (mapThreeArray A B C T) ↔
      IsNonzeroPureThreeArray T := by
  constructor
  · intro h
    have h₁ := mapThreeFirst_pure A.symm h
    rw [mapThreeArray, mapThreeFirst_symm_mapThreeFirst] at h₁
    have h₂ := mapThreeSecond_pure B.symm h₁
    rw [mapThreeSecond_symm_mapThreeSecond] at h₂
    have h₃ := mapThreeThird_pure C.symm h₂
    rwa [mapThreeThird_symm_mapThreeThird] at h₃
  · intro h
    exact mapThreeFirst_pure A
      (mapThreeSecond_pure B (mapThreeThird_pure C h))

/-- A four-factor array. -/
abbrev FourArray (κ : Type*) := κ → κ → κ → κ → ℂ

/-- The full diagonal four-array with displayed diagonal coefficients. -/
def diagonalFourArray (coeff : κ → ℂ) : FourArray κ :=
  fun i j k l =>
    if i = j ∧ j = k ∧ k = l then coeff i else 0

/-- Action on the first factor of a four-array. -/
def mapFourFirst (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (T : FourArray κ) : FourArray κ :=
  fun i j k l => A (fun p => T p j k l) i

/-- Action on the second factor of a four-array. -/
def mapFourSecond (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (T : FourArray κ) : FourArray κ :=
  fun i j k l => A (fun p => T i p k l) j

/-- Action on the third factor of a four-array. -/
def mapFourThird (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (T : FourArray κ) : FourArray κ :=
  fun i j k l => A (fun p => T i j p l) k

/-- Action on the fourth factor of a four-array. -/
def mapFourFourth (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (T : FourArray κ) : FourArray κ :=
  fun i j k l => A (fun p => T i j k p) l

/-- Independent action on all four factors of a four-array. -/
def mapFourArray
    (A B C D : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (T : FourArray κ) : FourArray κ :=
  mapFourFirst A
    (mapFourSecond B (mapFourThird C (mapFourFourth D T)))

/-- Contraction of the first factor of a four-array. -/
def contractFourFirst (x : κ → ℂ) (T : FourArray κ) : ThreeArray κ :=
  fun j k l => ∑ i, x i * T i j k l

/-- The transpose action on coordinate covectors. -/
def transposeCoordinateAction
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ)) (x : κ → ℂ) : κ → ℂ :=
  fun p => ∑ i, x i * A (coordinateVector p 1) i

private theorem function_eq_sum_coordinateVector (x : κ → ℂ) :
    x = ∑ p, x p • coordinateVector p 1 := by
  classical
  funext i
  simp [coordinateVector]

private theorem contractFourFirst_mapFourFirst
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (x : κ → ℂ) (T : FourArray κ) :
    contractFourFirst x (mapFourFirst A T) =
      contractFourFirst (transposeCoordinateAction A x) T := by
  classical
  funext j k l
  simp only [contractFourFirst, mapFourFirst, transposeCoordinateAction]
  have hexpand (i : κ) :
      A (fun p => T p j k l) i =
        ∑ p, T p j k l * A (coordinateVector p 1) i := by
    conv_lhs =>
      rw [function_eq_sum_coordinateVector (fun p => T p j k l)]
    simp [map_sum, map_smul]
  simp_rw [hexpand, Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro p _
  calc
    (∑ i, x i * (T p j k l * A (coordinateVector p 1) i)) =
        ∑ i, (x i * A (coordinateVector p 1) i) * T p j k l := by
          apply Finset.sum_congr rfl
          intro i _
          ring
    _ = (∑ i, x i * A (coordinateVector p 1) i) * T p j k l :=
      by rw [Finset.sum_mul]

omit [DecidableEq κ] in
private theorem contractFourFirst_mapFourSecond
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (x : κ → ℂ) (T : FourArray κ) :
    contractFourFirst x (mapFourSecond A T) =
      mapThreeFirst A (contractFourFirst x T) := by
  funext j k l
  simp only [contractFourFirst, mapFourSecond, mapThreeFirst]
  have hfun :
      (fun p => ∑ i, x i * T i p k l) =
        ∑ i, x i • (fun p => T i p k l) := by
    funext p
    simp
  rw [hfun, map_sum]
  simp [map_smul]

omit [DecidableEq κ] in
private theorem contractFourFirst_mapFourThird
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (x : κ → ℂ) (T : FourArray κ) :
    contractFourFirst x (mapFourThird A T) =
      mapThreeSecond A (contractFourFirst x T) := by
  funext j k l
  simp only [contractFourFirst, mapFourThird, mapThreeSecond]
  have hfun :
      (fun p => ∑ i, x i * T i j p l) =
        ∑ i, x i • (fun p => T i j p l) := by
    funext p
    simp
  rw [hfun, map_sum]
  simp [map_smul]

omit [DecidableEq κ] in
private theorem contractFourFirst_mapFourFourth
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (x : κ → ℂ) (T : FourArray κ) :
    contractFourFirst x (mapFourFourth A T) =
      mapThreeThird A (contractFourFirst x T) := by
  funext j k l
  simp only [contractFourFirst, mapFourFourth, mapThreeThird]
  have hfun :
      (fun p => ∑ i, x i * T i j k p) =
        ∑ i, x i • (fun p => T i j k p) := by
    funext p
    simp
  rw [hfun, map_sum]
  simp [map_smul]

/-- Contracting a product-transformed four-array transports the
covector by the transpose of the first factor and applies the remaining
three factor maps to the contraction. -/
theorem contractFourFirst_mapFourArray
    (A B C D : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (x : κ → ℂ) (T : FourArray κ) :
    contractFourFirst x (mapFourArray A B C D T) =
      mapThreeArray B C D
        (contractFourFirst (transposeCoordinateAction A x) T) := by
  rw [mapFourArray, contractFourFirst_mapFourFirst,
    contractFourFirst_mapFourSecond, contractFourFirst_mapFourThird,
    contractFourFirst_mapFourFourth]
  rfl

/-- Contracting a full diagonal four-array gives the corresponding
diagonal three-array. -/
theorem contractFourFirst_diagonalFourArray
    (coeff x : κ → ℂ) :
    contractFourFirst x (diagonalFourArray coeff) =
      diagonalTensorContraction coeff x := by
  classical
  funext j k l
  by_cases hjk : j = k
  · subst k
    by_cases hjl : j = l
    · subst l
      rw [contractFourFirst, Fintype.sum_eq_single j]
      · simp [diagonalFourArray, diagonalTensorContraction, mul_comm]
      · intro i hij
        simp [diagonalFourArray, hij]
    · simp [contractFourFirst, diagonalFourArray,
        diagonalTensorContraction, hjl]
  · simp [contractFourFirst, diagonalFourArray,
      diagonalTensorContraction, hjk]

/-- If a product equivalence carries one full diagonal four-array to
another, every row of its first factor lies on a coordinate axis. -/
theorem transposeCoordinate_axes_of_mapFourArray_diagonal
    [Nontrivial κ]
    (A B C D : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    {coeff target : κ → ℂ}
    (hcoeff : ∀ i, coeff i ≠ 0)
    (htarget : ∀ i, target i ≠ 0)
    (hmap :
      mapFourArray A B C D (diagonalFourArray coeff) =
        diagonalFourArray target) :
    ∀ u,
      IsNonzeroCoordinateAxis
        (transposeCoordinateAction A (coordinateVector u 1)) := by
  intro u
  have hpureTarget :
      IsNonzeroPureThreeArray
        (contractFourFirst (coordinateVector u 1)
          (diagonalFourArray target)) := by
    rw [contractFourFirst_diagonalFourArray]
    exact diagonalTensorContraction_pure_of_coordinateAxis htarget
      ⟨u, 1, one_ne_zero, rfl⟩
  have hpureMapped :
      IsNonzeroPureThreeArray
        (contractFourFirst (coordinateVector u 1)
          (mapFourArray A B C D (diagonalFourArray coeff))) := by
    rw [hmap]
    exact hpureTarget
  rw [contractFourFirst_mapFourArray, mapThreeArray_pure_iff,
    contractFourFirst_diagonalFourArray] at hpureMapped
  exact coordinateAxis_of_diagonalTensorContraction_pure hcoeff hpureMapped

/-- Row-monomiality of an invertible linear map forces
column-monomiality: the map itself carries every coordinate axis to a
coordinate axis. -/
theorem coordinate_axes_of_transposeCoordinate_axes
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (hrows :
      ∀ u,
        IsNonzeroCoordinateAxis
          (transposeCoordinateAction A (coordinateVector u 1))) :
    ∀ t, IsNonzeroCoordinateAxis (A (coordinateVector t 1)) := by
  classical
  let σ : κ → κ := fun u => (hrows u).choose
  let α : κ → ℂ := fun u => (hrows u).choose_spec.choose
  have hα (u : κ) : α u ≠ 0 :=
    (hrows u).choose_spec.choose_spec.1
  have hrow (u : κ) :
      transposeCoordinateAction A (coordinateVector u 1) =
        coordinateVector (σ u) (α u) :=
    (hrows u).choose_spec.choose_spec.2
  have hrow_apply (u t : κ) :
      A (coordinateVector t 1) u =
        coordinateVector (σ u) (α u) t := by
    have h := congrFun (hrow u) t
    simpa [transposeCoordinateAction, coordinateVector] using h
  have hσinj : Function.Injective σ := by
    intro u v huv
    by_contra huv'
    let y := coordinateVector u 1
    let x := A.symm y
    have hyu : A x u = 1 := by
      rw [A.apply_symm_apply]
      simp [y, coordinateVector]
    have hyv : A x v = 0 := by
      rw [A.apply_symm_apply]
      have hvu : v ≠ u := Ne.symm huv'
      simp [y, coordinateVector, hvu]
    have hxu :
        A x u = α u * x (σ u) := by
      conv_lhs =>
        rw [function_eq_sum_coordinateVector x]
      simp_rw [map_sum, map_smul]
      simp [hrow_apply, coordinateVector, mul_comm]
    have hxv :
        A x v = α v * x (σ v) := by
      conv_lhs =>
        rw [function_eq_sum_coordinateVector x]
      simp_rw [map_sum, map_smul]
      simp [hrow_apply, coordinateVector, mul_comm]
    rw [← huv] at hxv
    have hxne : x (σ u) ≠ 0 := by
      intro hx
      rw [hxu, hx, mul_zero] at hyu
      exact one_ne_zero hyu.symm
    rw [hxv] at hyv
    exact (mul_ne_zero (hα v) hxne) hyv
  have hσbij : Function.Bijective σ :=
    (Fintype.bijective_iff_injective_and_card σ).2 ⟨hσinj, rfl⟩
  have hσsurj : Function.Surjective σ := hσbij.2
  intro t
  obtain ⟨u, hu⟩ := hσsurj t
  refine ⟨u, α u, hα u, ?_⟩
  funext v
  rw [hrow_apply]
  by_cases hvu : v = u
  · subst v
    simp [coordinateVector, hu]
  · have hσv : σ v ≠ t := by
      intro h
      apply hvu
      apply hσinj
      rw [h, hu]
    have htσv : t ≠ σ v := Ne.symm hσv
    simp [coordinateVector, htσv, hvu]

/-- The first factor of a product equivalence between full diagonal
four-arrays permutes coordinate axes. -/
theorem firstFactor_coordinate_axes_of_mapFourArray_diagonal
    [Nontrivial κ]
    (A B C D : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    {coeff target : κ → ℂ}
    (hcoeff : ∀ i, coeff i ≠ 0)
    (htarget : ∀ i, target i ≠ 0)
    (hmap :
      mapFourArray A B C D (diagonalFourArray coeff) =
        diagonalFourArray target) :
    ∀ t, IsNonzeroCoordinateAxis (A (coordinateVector t 1)) :=
  coordinate_axes_of_transposeCoordinate_axes A
    (transposeCoordinate_axes_of_mapFourArray_diagonal
      A B C D hcoeff htarget hmap)

end RelativeConicArcs.AMELU
