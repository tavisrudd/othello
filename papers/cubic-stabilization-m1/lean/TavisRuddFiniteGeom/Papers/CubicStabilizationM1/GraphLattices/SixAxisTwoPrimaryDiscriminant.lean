import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisGram
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointCoefficientHeart
import Mathlib.LinearAlgebra.BilinearForm.Properties
import Mathlib.LinearAlgebra.BilinearForm.Orthogonal

/-!
# The two-primary coefficient discriminant of the six-axis form

Let `T` be any module over `F₂`.  This module computes the kernel of the
five-axis coefficient form `6I₅-J₅` after tensoring with `T`.  The form
reduces to the coordinate-sum map, so its kernel is explicitly equivalent to
four freely chosen elements of `T`.  For a two-dimensional `T`, as furnished
by the two-torsion of an elliptic curve after choosing a basis, the kernel has
`2⁸` elements.

For `T = F₂`, the explicit equivalence agrees with the normalized coordinates
for the six-point coefficient heart
`Aug(F₂⁶)/⟨1⟩`.  Thus the calculation proves the coefficient-module
part of the relative identification `D₂ ≃ H₂ ⊗ E[2]`; the normalized
heart dot product is also proved bilinear, alternating, nondegenerate, and
invariant under every word in the generated six-point action.  After choosing
a symplectic basis of a two-dimensional tensor factor, the resulting
rank-eight tensor-product form is likewise alternating and nondegenerate;
every isotropic four-dimensional subspace is therefore maximal isotropic.  It does not
construct an elliptic scheme, its two-torsion local system, the Weil pairing,
or the relative isogeny kernel.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

open scoped BigOperators

/-- Every element of a module over `F₂` is its own additive inverse. -/
theorem sixAxisF2Module_add_self_eq_zero
    {T : Type*} [AddCommGroup T] [Module F2 T] (value : T) :
    value + value = 0 := by
  have characteristicTwo : (1 + 1 : F2) = 0 := by decide
  have scalarEquality := congrArg (fun scalar : F2 ↦ scalar • value)
    characteristicTwo
  simpa [add_smul] using scalarEquality

/-- The five-axis Gram map after tensoring its coefficient entries with an
arbitrary `F₂`-module. -/
def sixAxisGramTensorMap
    {T : Type*} [AddCommGroup T] [Module F2 T]
    (vector : Fin 5 → T) : Fin 5 → T :=
  fun row ↦ ∑ column, (sixAxisGram F2 row column) • vector column

/-- Modulo two, every row of `6I₅-J₅` acts by the coordinate sum. -/
theorem sixAxisGramTensorMap_apply
    {T : Type*} [AddCommGroup T] [Module F2 T]
    (vector : Fin 5 → T) (row : Fin 5) :
    sixAxisGramTensorMap vector row = ∑ column, vector column := by
  simp [sixAxisGramTensorMap, sixAxisGram,
    show (6 : F2) = 0 by decide, show (-1 : F2) = 1 by decide]

/-- A tensor-valued five-axis vector belongs to the two-primary discriminant
exactly when its coordinate sum vanishes. -/
theorem sixAxisGramTensorMap_eq_zero_iff_sum_zero
    {T : Type*} [AddCommGroup T] [Module F2 T]
    (vector : Fin 5 → T) :
    sixAxisGramTensorMap vector = 0 ↔ ∑ column, vector column = 0 := by
  constructor
  · intro vanishing
    have atRowZero := congrFun vanishing 0
    simpa [sixAxisGramTensorMap_apply] using atRowZero
  · intro sumZero
    funext row
    rw [sixAxisGramTensorMap_apply, sumZero]
    rfl

/-- The tensor-extended five-axis Gram map as an `F₂`-linear map. -/
def sixAxisGramTensorLinearMap
    (T : Type*) [AddCommGroup T] [Module F2 T] :
    (Fin 5 → T) →ₗ[F2] (Fin 5 → T) where
  toFun := sixAxisGramTensorMap
  map_add' left right := by
    funext row
    simp [sixAxisGramTensorMap, Finset.sum_add_distrib, smul_add]
  map_smul' scalar vector := by
    funext row
    simp [sixAxisGramTensorMap, Finset.smul_sum, smul_smul, mul_comm]

/-- The two-primary coefficient discriminant after tensoring with `T`. -/
def SixAxisTwoPrimaryDiscriminant
    (T : Type*) [AddCommGroup T] [Module F2 T] :=
  LinearMap.ker (sixAxisGramTensorLinearMap T)

/-- Four tensor coordinates determine a discriminant vector; the fifth
coordinate is their sum. -/
def sixAxisTwoPrimaryDiscriminantRepresentative
    {T : Type*} [AddCommGroup T] [Module F2 T]
    (coordinates : Fin 4 → T) : Fin 5 → T :=
  ![coordinates 0, coordinates 1, coordinates 2, coordinates 3,
    ∑ index, coordinates index]

/-- The displayed representative has coordinate sum zero. -/
theorem sixAxisTwoPrimaryDiscriminantRepresentative_sum_zero
    {T : Type*} [AddCommGroup T] [Module F2 T]
    (coordinates : Fin 4 → T) :
    ∑ index, sixAxisTwoPrimaryDiscriminantRepresentative coordinates index = 0 := by
  calc
    (∑ index, sixAxisTwoPrimaryDiscriminantRepresentative coordinates index) =
        (∑ index, coordinates index) + (∑ index, coordinates index) := by
      simp [sixAxisTwoPrimaryDiscriminantRepresentative, Fin.sum_univ_succ]
      abel
    _ = 0 := sixAxisF2Module_add_self_eq_zero _

/-- The displayed representative lies in the kernel of the tensor-extended
five-axis Gram map. -/
theorem sixAxisTwoPrimaryDiscriminantRepresentative_mem
    {T : Type*} [AddCommGroup T] [Module F2 T]
    (coordinates : Fin 4 → T) :
    sixAxisGramTensorMap
      (sixAxisTwoPrimaryDiscriminantRepresentative coordinates) = 0 :=
  (sixAxisGramTensorMap_eq_zero_iff_sum_zero _).2
    (sixAxisTwoPrimaryDiscriminantRepresentative_sum_zero coordinates)

/-- Explicit coefficient equivalence between the two-primary discriminant
and four copies of the tensor factor. -/
def sixAxisTwoPrimaryDiscriminantEquiv
    (T : Type*) [AddCommGroup T] [Module F2 T] :
    (Fin 4 → T) ≃ SixAxisTwoPrimaryDiscriminant T where
  toFun coordinates :=
    ⟨sixAxisTwoPrimaryDiscriminantRepresentative coordinates,
      sixAxisTwoPrimaryDiscriminantRepresentative_mem coordinates⟩
  invFun vector := fun index ↦ vector.1 ⟨index, by omega⟩
  left_inv coordinates := by
    funext index
    fin_cases index <;>
      rfl
  right_inv vector := by
    apply Subtype.ext
    funext index
    fin_cases index
    · rfl
    · rfl
    · rfl
    · rfl
    · change (∑ coordinate : Fin 4,
          vector.1 ⟨coordinate, by omega⟩) = vector.1 4
      have sumZero :=
        (sixAxisGramTensorMap_eq_zero_iff_sum_zero vector.1).1 vector.2
      have splitSum :
          (∑ coordinate : Fin 4, vector.1 ⟨coordinate, by omega⟩) +
              vector.1 4 = 0 := by
        calc
          (∑ coordinate : Fin 4,
                vector.1 ⟨coordinate, by omega⟩) + vector.1 4 =
              ∑ coordinate : Fin 5, vector.1 coordinate := by
            simp [Fin.sum_univ_succ]
            abel
          _ = 0 := sumZero
      have selfCancellation := sixAxisF2Module_add_self_eq_zero (vector.1 4)
      calc
        (∑ coordinate : Fin 4, vector.1 ⟨coordinate, by omega⟩) =
            (∑ coordinate : Fin 4, vector.1 ⟨coordinate, by omega⟩) +
                (vector.1 4 + vector.1 4) := by
              rw [selfCancellation, add_zero]
        _ = ((∑ coordinate : Fin 4,
              vector.1 ⟨coordinate, by omega⟩) + vector.1 4) +
              vector.1 4 := by abel
        _ = vector.1 4 := by rw [splitSum, zero_add]

/-- The four-coordinate description is linear over `F₂`, not merely a
bijection of the underlying finite sets. -/
def sixAxisTwoPrimaryDiscriminantLinearEquiv
    (T : Type*) [AddCommGroup T] [Module F2 T] :
    (Fin 4 → T) ≃ₗ[F2] SixAxisTwoPrimaryDiscriminant T where
  toEquiv := sixAxisTwoPrimaryDiscriminantEquiv T
  map_add' left right := by
    apply Subtype.ext
    funext index
    fin_cases index <;>
      simp [sixAxisTwoPrimaryDiscriminantEquiv,
        sixAxisTwoPrimaryDiscriminantRepresentative,
        Finset.sum_add_distrib]
  map_smul' scalar vector := by
    apply Subtype.ext
    funext index
    fin_cases index <;>
      simp [sixAxisTwoPrimaryDiscriminantEquiv,
        sixAxisTwoPrimaryDiscriminantRepresentative,
        Finset.smul_sum]

/-- The explicit four-coordinate equivalence supplies the finite structure of
the discriminant whenever the tensor factor is finite. -/
noncomputable instance sixAxisTwoPrimaryDiscriminantFintype
    (T : Type*) [AddCommGroup T] [Module F2 T] [Fintype T] :
    Fintype (SixAxisTwoPrimaryDiscriminant T) :=
  Fintype.ofEquiv (Fin 4 → T) (sixAxisTwoPrimaryDiscriminantEquiv T)

/-- The discriminant has the fourth power of the cardinality of its tensor
factor. -/
theorem sixAxisTwoPrimaryDiscriminant_card
    (T : Type*) [AddCommGroup T] [Module F2 T] [Fintype T] :
    Fintype.card (SixAxisTwoPrimaryDiscriminant T) = Fintype.card T ^ 4 := by
  calc
    Fintype.card (SixAxisTwoPrimaryDiscriminant T) =
        Fintype.card (Fin 4 → T) :=
      Fintype.card_congr (sixAxisTwoPrimaryDiscriminantEquiv T).symm
    _ = Fintype.card T ^ 4 := by simp

/-- For a two-dimensional `F₂` tensor factor, the discriminant has `2⁸`
elements. -/
theorem sixAxisTwoPrimaryDiscriminant_rankEight_card :
    Fintype.card
      (SixAxisTwoPrimaryDiscriminant (Fin 2 → F2)) = 256 := by
  rw [sixAxisTwoPrimaryDiscriminant_card]
  decide

/-- For scalar coefficients, the five-axis discriminant representative is
the first five coordinates of the normalized six-point heart
representative. -/
theorem sixAxisTwoPrimaryDiscriminantRepresentative_eq_heart
    (heart : Fin 4 → F2) (index : Fin 5) :
    sixAxisTwoPrimaryDiscriminantRepresentative heart index =
      sixPointHeartRepresentative heart ⟨index, by omega⟩ := by
  fin_cases index <;>
    rfl

/-- The coefficient pairing on the six-point heart, obtained by restricting
the ordinary dot product to normalized augmentation representatives. -/
def sixPointHeartCoefficientForm
    (left right : Fin 4 → F2) : F2 :=
  ∑ point : Fin 6,
    sixPointHeartRepresentative left point *
      sixPointHeartRepresentative right point

/-- Coordinate formula for the coefficient pairing: the ordinary dot product
on four coordinates plus the product of their coordinate sums. -/
theorem sixPointHeartCoefficientForm_formula
    (left right : Fin 4 → F2) :
    sixPointHeartCoefficientForm left right =
      (∑ index, left index * right index) +
        (∑ index, left index) * (∑ index, right index) := by
  simp [sixPointHeartCoefficientForm, sixPointHeartRepresentative,
    Fin.sum_univ_succ]
  ring

/-- The coefficient pairing is additive in its first argument. -/
theorem sixPointHeartCoefficientForm_add_left
    (left₁ left₂ right : Fin 4 → F2) :
    sixPointHeartCoefficientForm (left₁ + left₂) right =
      sixPointHeartCoefficientForm left₁ right +
        sixPointHeartCoefficientForm left₂ right := by
  simp [sixPointHeartCoefficientForm_formula, Finset.sum_add_distrib,
    add_mul]
  ring

/-- Normalized heart representatives respect scalar multiplication. -/
theorem sixPointHeartRepresentative_smul
    (scalar : F2) (heart : Fin 4 → F2) (point : Fin 6) :
    sixPointHeartRepresentative (scalar • heart) point =
      scalar * sixPointHeartRepresentative heart point := by
  fin_cases point <;>
    simp [sixPointHeartRepresentative, Finset.mul_sum]

/-- The coefficient pairing respects scalar multiplication in its first
argument. -/
theorem sixPointHeartCoefficientForm_smul_left
    (scalar : F2) (left right : Fin 4 → F2) :
    sixPointHeartCoefficientForm (scalar • left) right =
      scalar * sixPointHeartCoefficientForm left right := by
  simp only [sixPointHeartCoefficientForm]
  simp_rw [sixPointHeartRepresentative_smul]
  rw [Finset.mul_sum]
  simp [mul_assoc]

/-- The coefficient pairing is symmetric. -/
theorem sixPointHeartCoefficientForm_comm
    (left right : Fin 4 → F2) :
    sixPointHeartCoefficientForm left right =
      sixPointHeartCoefficientForm right left := by
  simp [sixPointHeartCoefficientForm_formula, mul_comm]

/-- The coefficient pairing is additive in its second argument. -/
theorem sixPointHeartCoefficientForm_add_right
    (left right₁ right₂ : Fin 4 → F2) :
    sixPointHeartCoefficientForm left (right₁ + right₂) =
      sixPointHeartCoefficientForm left right₁ +
        sixPointHeartCoefficientForm left right₂ := by
  rw [sixPointHeartCoefficientForm_comm]
  simp only [sixPointHeartCoefficientForm_add_left]
  rw [sixPointHeartCoefficientForm_comm left right₁,
    sixPointHeartCoefficientForm_comm left right₂]

/-- Zero in the first variable pairs trivially. -/
@[simp]
theorem sixPointHeartCoefficientForm_zero_left (right : Fin 4 → F2) :
    sixPointHeartCoefficientForm 0 right = 0 := by
  simp [sixPointHeartCoefficientForm,
    sixPointHeartRepresentative, Fin.sum_univ_succ]

/-- Zero in the second variable pairs trivially. -/
@[simp]
theorem sixPointHeartCoefficientForm_zero_right (left : Fin 4 → F2) :
    sixPointHeartCoefficientForm left 0 = 0 := by
  rw [sixPointHeartCoefficientForm_comm]
  exact sixPointHeartCoefficientForm_zero_left left

/-- The coefficient pairing respects scalar multiplication in its second
argument. -/
theorem sixPointHeartCoefficientForm_smul_right
    (scalar : F2) (left right : Fin 4 → F2) :
    sixPointHeartCoefficientForm left (scalar • right) =
      scalar * sixPointHeartCoefficientForm left right := by
  rw [sixPointHeartCoefficientForm_comm]
  simp only [sixPointHeartCoefficientForm_smul_left]
  rw [sixPointHeartCoefficientForm_comm left right]

/-- The coefficient pairing is alternating. -/
theorem sixPointHeartCoefficientForm_self
    (heart : Fin 4 → F2) :
    sixPointHeartCoefficientForm heart heart = 0 := by
  have square (value : F2) : value * value = value := by
    fin_cases value <;>
      decide
  rw [sixPointHeartCoefficientForm_formula]
  simp_rw [square]
  exact sixAxisF2Module_add_self_eq_zero _

/-- The alternating coefficient pairing is nondegenerate. -/
theorem sixPointHeartCoefficientForm_nondegenerate
    (heart : Fin 4 → F2)
    (annihilates : ∀ test, sixPointHeartCoefficientForm heart test = 0) :
    heart = 0 := by
  have sumZero : ∑ index, heart index = 0 := by
    have againstOne := annihilates (fun _ ↦ 1)
    rw [sixPointHeartCoefficientForm_formula] at againstOne
    simpa [show (4 : F2) = 0 by decide] using againstOne
  funext index
  have againstBasis := annihilates (fun test ↦ if test = index then 1 else 0)
  rw [sixPointHeartCoefficientForm_formula] at againstBasis
  simpa [sumZero] using againstBasis

/-- The coefficient pairing bundled as an `F₂`-bilinear form. -/
def sixPointHeartCoefficientBilinForm :
    LinearMap.BilinForm F2 (Fin 4 → F2) :=
  LinearMap.mk₂ F2 sixPointHeartCoefficientForm
    sixPointHeartCoefficientForm_add_left
    (by
      intro scalar left right
      simpa only [smul_eq_mul] using
        sixPointHeartCoefficientForm_smul_left scalar left right)
    sixPointHeartCoefficientForm_add_right
    (by
      intro scalar left right
      simpa only [smul_eq_mul] using
        sixPointHeartCoefficientForm_smul_right scalar left right)

/-- Evaluation of the bundled form is the explicit coefficient pairing. -/
@[simp]
theorem sixPointHeartCoefficientBilinForm_apply
    (left right : Fin 4 → F2) :
    sixPointHeartCoefficientBilinForm left right =
      sixPointHeartCoefficientForm left right :=
  rfl

/-- The bundled coefficient form is alternating. -/
theorem sixPointHeartCoefficientBilinForm_isAlt :
    sixPointHeartCoefficientBilinForm.IsAlt :=
  sixPointHeartCoefficientForm_self

/-- The bundled coefficient form is nondegenerate on both sides. -/
theorem sixPointHeartCoefficientBilinForm_nondegenerate :
    sixPointHeartCoefficientBilinForm.Nondegenerate := by
  constructor
  · exact sixPointHeartCoefficientForm_nondegenerate
  · intro heart annihilates
    apply sixPointHeartCoefficientForm_nondegenerate heart
    intro test
    rw [sixPointHeartCoefficientForm_comm]
    exact annihilates test

/-- The translation generator preserves the coefficient form.  Kernel
reduction checks all `16²` ordered pairs of heart vectors. -/
theorem sixPointHeartTranslation_preserves_coefficientForm
    (left right : Fin 4 → F2) :
    sixPointHeartCoefficientForm
        (Matrix.mulVec sixPointHeartTranslation left)
        (Matrix.mulVec sixPointHeartTranslation right) =
      sixPointHeartCoefficientForm left right := by
  revert left right
  decide

/-- The inversion generator preserves the coefficient form.  Kernel
reduction checks all `16²` ordered pairs of heart vectors. -/
theorem sixPointHeartInversion_preserves_coefficientForm
    (left right : Fin 4 → F2) :
    sixPointHeartCoefficientForm
        (Matrix.mulVec sixPointHeartInversion left)
        (Matrix.mulVec sixPointHeartInversion right) =
      sixPointHeartCoefficientForm left right := by
  revert left right
  decide

/-- Every word in the full generated six-point action preserves the
nondegenerate alternating coefficient form. -/
theorem sixPointHeartWordAction_preserves_coefficientForm
    (word : List Bool) (left right : Fin 4 → F2) :
    sixPointHeartCoefficientForm (sixPointHeartWordAction word left)
        (sixPointHeartWordAction word right) =
      sixPointHeartCoefficientForm left right := by
  induction word generalizing left right with
  | nil => rfl
  | cons generator word induction =>
      simp only [sixPointHeartWordAction]
      rw [induction]
      cases generator
      · exact sixPointHeartTranslation_preserves_coefficientForm left right
      · exact sixPointHeartInversion_preserves_coefficientForm left right

/-- Coordinates for `H₂ ⊗ V` after choosing a symplectic basis of the
two-dimensional factor `V`. -/
abbrev SixAxisStandardDiscriminantCoordinates := Fin 4 → Fin 2 → F2

/-- First coordinate layer of the chosen two-dimensional tensor factor. -/
def sixAxisStandardDiscriminantFirst
    (vector : SixAxisStandardDiscriminantCoordinates) : Fin 4 → F2 :=
  fun index ↦ vector index 0

/-- Second coordinate layer of the chosen two-dimensional tensor factor. -/
def sixAxisStandardDiscriminantSecond
    (vector : SixAxisStandardDiscriminantCoordinates) : Fin 4 → F2 :=
  fun index ↦ vector index 1

/-- Embed a heart vector in the first tensor-coordinate layer. -/
def sixAxisStandardDiscriminantOfFirst
    (heart : Fin 4 → F2) : SixAxisStandardDiscriminantCoordinates :=
  fun index ↦ ![heart index, 0]

/-- Embed a heart vector in the second tensor-coordinate layer. -/
def sixAxisStandardDiscriminantOfSecond
    (heart : Fin 4 → F2) : SixAxisStandardDiscriminantCoordinates :=
  fun index ↦ ![0, heart index]

/-- The first tensor layer is additive. -/
@[simp]
theorem sixAxisStandardDiscriminantFirst_add
    (left right : SixAxisStandardDiscriminantCoordinates) :
    sixAxisStandardDiscriminantFirst (left + right) =
      sixAxisStandardDiscriminantFirst left +
        sixAxisStandardDiscriminantFirst right :=
  rfl

/-- The second tensor layer is additive. -/
@[simp]
theorem sixAxisStandardDiscriminantSecond_add
    (left right : SixAxisStandardDiscriminantCoordinates) :
    sixAxisStandardDiscriminantSecond (left + right) =
      sixAxisStandardDiscriminantSecond left +
        sixAxisStandardDiscriminantSecond right :=
  rfl

/-- The first tensor layer respects scalar multiplication. -/
@[simp]
theorem sixAxisStandardDiscriminantFirst_smul
    (scalar : F2) (vector : SixAxisStandardDiscriminantCoordinates) :
    sixAxisStandardDiscriminantFirst (scalar • vector) =
      scalar • sixAxisStandardDiscriminantFirst vector :=
  rfl

/-- The second tensor layer respects scalar multiplication. -/
@[simp]
theorem sixAxisStandardDiscriminantSecond_smul
    (scalar : F2) (vector : SixAxisStandardDiscriminantCoordinates) :
    sixAxisStandardDiscriminantSecond (scalar • vector) =
      scalar • sixAxisStandardDiscriminantSecond vector :=
  rfl

/-- Projection to the first layer recovers a first-layer embedding. -/
@[simp]
theorem sixAxisStandardDiscriminantFirst_ofFirst
    (heart : Fin 4 → F2) :
    sixAxisStandardDiscriminantFirst
      (sixAxisStandardDiscriminantOfFirst heart) = heart := by
  funext index
  rfl

/-- Projection to the second layer of a first-layer embedding is zero. -/
@[simp]
theorem sixAxisStandardDiscriminantSecond_ofFirst
    (heart : Fin 4 → F2) :
    sixAxisStandardDiscriminantSecond
      (sixAxisStandardDiscriminantOfFirst heart) = 0 := by
  funext index
  rfl

/-- Projection to the first layer of a second-layer embedding is zero. -/
@[simp]
theorem sixAxisStandardDiscriminantFirst_ofSecond
    (heart : Fin 4 → F2) :
    sixAxisStandardDiscriminantFirst
      (sixAxisStandardDiscriminantOfSecond heart) = 0 := by
  funext index
  rfl

/-- Projection to the second layer recovers a second-layer embedding. -/
@[simp]
theorem sixAxisStandardDiscriminantSecond_ofSecond
    (heart : Fin 4 → F2) :
    sixAxisStandardDiscriminantSecond
      (sixAxisStandardDiscriminantOfSecond heart) = heart := by
  funext index
  rfl

/-- Tensor-product alternating form obtained from the coefficient-heart form
and the standard symplectic form on `F₂²`. -/
def sixAxisStandardDiscriminantForm
    (left right : SixAxisStandardDiscriminantCoordinates) : F2 :=
  sixPointHeartCoefficientForm
      (sixAxisStandardDiscriminantFirst left)
      (sixAxisStandardDiscriminantSecond right) +
    sixPointHeartCoefficientForm
      (sixAxisStandardDiscriminantSecond left)
      (sixAxisStandardDiscriminantFirst right)

/-- The standard discriminant form is additive in its first variable. -/
theorem sixAxisStandardDiscriminantForm_add_left
    (left₁ left₂ right : SixAxisStandardDiscriminantCoordinates) :
    sixAxisStandardDiscriminantForm (left₁ + left₂) right =
      sixAxisStandardDiscriminantForm left₁ right +
        sixAxisStandardDiscriminantForm left₂ right := by
  simp [sixAxisStandardDiscriminantForm,
    sixPointHeartCoefficientForm_add_left]
  abel

/-- The standard discriminant form respects scalar multiplication in its
first variable. -/
theorem sixAxisStandardDiscriminantForm_smul_left
    (scalar : F2) (left right : SixAxisStandardDiscriminantCoordinates) :
    sixAxisStandardDiscriminantForm (scalar • left) right =
      scalar * sixAxisStandardDiscriminantForm left right := by
  simp [sixAxisStandardDiscriminantForm,
    sixPointHeartCoefficientForm_smul_left, mul_add]

/-- The standard discriminant form is symmetric in characteristic two. -/
theorem sixAxisStandardDiscriminantForm_comm
    (left right : SixAxisStandardDiscriminantCoordinates) :
    sixAxisStandardDiscriminantForm left right =
      sixAxisStandardDiscriminantForm right left := by
  simp only [sixAxisStandardDiscriminantForm]
  rw [sixPointHeartCoefficientForm_comm
      (sixAxisStandardDiscriminantFirst left)
      (sixAxisStandardDiscriminantSecond right),
    sixPointHeartCoefficientForm_comm
      (sixAxisStandardDiscriminantSecond left)
      (sixAxisStandardDiscriminantFirst right)]
  abel

/-- The standard discriminant form is additive in its second variable. -/
theorem sixAxisStandardDiscriminantForm_add_right
    (left right₁ right₂ : SixAxisStandardDiscriminantCoordinates) :
    sixAxisStandardDiscriminantForm left (right₁ + right₂) =
      sixAxisStandardDiscriminantForm left right₁ +
        sixAxisStandardDiscriminantForm left right₂ := by
  rw [sixAxisStandardDiscriminantForm_comm]
  simp only [sixAxisStandardDiscriminantForm_add_left]
  rw [sixAxisStandardDiscriminantForm_comm left right₁,
    sixAxisStandardDiscriminantForm_comm left right₂]

/-- The standard discriminant form respects scalar multiplication in its
second variable. -/
theorem sixAxisStandardDiscriminantForm_smul_right
    (scalar : F2) (left right : SixAxisStandardDiscriminantCoordinates) :
    sixAxisStandardDiscriminantForm left (scalar • right) =
      scalar * sixAxisStandardDiscriminantForm left right := by
  rw [sixAxisStandardDiscriminantForm_comm]
  simp only [sixAxisStandardDiscriminantForm_smul_left]
  rw [sixAxisStandardDiscriminantForm_comm left right]

/-- The standard tensor-product discriminant form is alternating. -/
theorem sixAxisStandardDiscriminantForm_self
    (vector : SixAxisStandardDiscriminantCoordinates) :
    sixAxisStandardDiscriminantForm vector vector = 0 := by
  rw [sixAxisStandardDiscriminantForm]
  rw [sixPointHeartCoefficientForm_comm
    (sixAxisStandardDiscriminantSecond vector)
    (sixAxisStandardDiscriminantFirst vector)]
  exact sixAxisF2Module_add_self_eq_zero _

/-- The standard tensor-product discriminant form is nondegenerate. -/
theorem sixAxisStandardDiscriminantForm_nondegenerate
    (vector : SixAxisStandardDiscriminantCoordinates)
    (annihilates : ∀ test, sixAxisStandardDiscriminantForm vector test = 0) :
    vector = 0 := by
  have firstZero : sixAxisStandardDiscriminantFirst vector = 0 := by
    apply sixPointHeartCoefficientForm_nondegenerate
    intro test
    have evaluated := annihilates (sixAxisStandardDiscriminantOfSecond test)
    simpa [sixAxisStandardDiscriminantForm,
      sixAxisStandardDiscriminantFirst,
      sixAxisStandardDiscriminantSecond,
      sixAxisStandardDiscriminantOfSecond] using evaluated
  have secondZero : sixAxisStandardDiscriminantSecond vector = 0 := by
    apply sixPointHeartCoefficientForm_nondegenerate
    intro test
    have evaluated := annihilates (sixAxisStandardDiscriminantOfFirst test)
    simpa [sixAxisStandardDiscriminantForm,
      sixAxisStandardDiscriminantFirst,
      sixAxisStandardDiscriminantSecond,
      sixAxisStandardDiscriminantOfFirst] using evaluated
  funext index coordinate
  fin_cases coordinate
  · exact congrFun firstZero index
  · exact congrFun secondZero index

/-- The standard tensor-product pairing bundled as a Mathlib bilinear form. -/
def sixAxisStandardDiscriminantBilinForm :
    LinearMap.BilinForm F2 SixAxisStandardDiscriminantCoordinates :=
  LinearMap.mk₂ F2 sixAxisStandardDiscriminantForm
    sixAxisStandardDiscriminantForm_add_left
    (by
      intro scalar left right
      simpa only [smul_eq_mul] using
        sixAxisStandardDiscriminantForm_smul_left scalar left right)
    sixAxisStandardDiscriminantForm_add_right
    (by
      intro scalar left right
      simpa only [smul_eq_mul] using
        sixAxisStandardDiscriminantForm_smul_right scalar left right)

/-- The bundled standard discriminant form is alternating. -/
theorem sixAxisStandardDiscriminantBilinForm_isAlt :
    sixAxisStandardDiscriminantBilinForm.IsAlt :=
  sixAxisStandardDiscriminantForm_self

/-- The bundled standard discriminant form is nondegenerate. -/
theorem sixAxisStandardDiscriminantBilinForm_nondegenerate :
    sixAxisStandardDiscriminantBilinForm.Nondegenerate := by
  constructor
  · exact sixAxisStandardDiscriminantForm_nondegenerate
  · intro vector annihilates
    apply sixAxisStandardDiscriminantForm_nondegenerate vector
    intro test
    rw [sixAxisStandardDiscriminantForm_comm]
    exact annihilates test

/-- Maximal isotropy among linear subspaces for a bilinear form. -/
def IsMaximalIsotropic
    {K V : Type*} [Field K] [AddCommGroup V] [Module K V]
    (form : LinearMap.BilinForm K V) (subspace : Submodule K V) : Prop :=
  subspace ≤ form.orthogonal subspace ∧
    ∀ larger : Submodule K V,
      subspace ≤ larger →
      larger ≤ form.orthogonal larger →
      larger = subspace

/-- In a finite-dimensional nondegenerate bilinear space, an isotropic
subspace of half the ambient dimension is maximal isotropic. -/
theorem isMaximalIsotropic_of_isotropic_of_twice_finrank_eq
    {K V : Type*} [Field K] [AddCommGroup V] [Module K V]
    [FiniteDimensional K V]
    (form : LinearMap.BilinForm K V) (nondegenerate : form.Nondegenerate)
    (subspace : Submodule K V)
    (isotropic : subspace ≤ form.orthogonal subspace)
    (halfDimension :
      2 * Module.finrank K subspace = Module.finrank K V) :
    IsMaximalIsotropic form subspace := by
  refine ⟨isotropic, ?_⟩
  intro larger contains largerIsotropic
  have rankMonotone :
      Module.finrank K subspace ≤ Module.finrank K larger :=
    Submodule.finrank_mono contains
  have rankOrthogonal :
      Module.finrank K larger ≤
        Module.finrank K (form.orthogonal larger) :=
    Submodule.finrank_mono largerIsotropic
  rw [form.finrank_orthogonal nondegenerate larger] at rankOrthogonal
  have rankUpper :
      Module.finrank K larger ≤ Module.finrank K subspace := by
    omega
  exact (Submodule.eq_of_le_of_finrank_le contains rankUpper).symm

/-- In the explicit rank-eight six-axis discriminant, every isotropic
four-dimensional subspace is maximal isotropic. -/
theorem sixAxisStandardDiscriminant_maximalIsotropic_of_finrank_four
    (subspace : Submodule F2 SixAxisStandardDiscriminantCoordinates)
    (isotropic : subspace ≤
      sixAxisStandardDiscriminantBilinForm.orthogonal subspace)
    (finrankFour : Module.finrank F2 subspace = 4) :
    IsMaximalIsotropic sixAxisStandardDiscriminantBilinForm subspace := by
  apply isMaximalIsotropic_of_isotropic_of_twice_finrank_eq
    sixAxisStandardDiscriminantBilinForm
    sixAxisStandardDiscriminantBilinForm_nondegenerate subspace isotropic
  rw [finrankFour]
  rw [Module.finrank_pi_fintype]
  simp

/-- The exact bilinear, alternating, and nondegenerate properties of the
six-point heart coefficient form. -/
structure SixPointHeartCoefficientFormProperties : Prop where
  /-- Additivity in the first variable. -/
  addLeft : ∀ left₁ left₂ right,
    sixPointHeartCoefficientForm (left₁ + left₂) right =
      sixPointHeartCoefficientForm left₁ right +
        sixPointHeartCoefficientForm left₂ right
  /-- Scalar compatibility in the first variable. -/
  smulLeft : ∀ scalar left right,
    sixPointHeartCoefficientForm (scalar • left) right =
      scalar * sixPointHeartCoefficientForm left right
  /-- Symmetry. -/
  symmetric : ∀ left right,
    sixPointHeartCoefficientForm left right =
      sixPointHeartCoefficientForm right left
  /-- Additivity in the second variable. -/
  addRight : ∀ left right₁ right₂,
    sixPointHeartCoefficientForm left (right₁ + right₂) =
      sixPointHeartCoefficientForm left right₁ +
        sixPointHeartCoefficientForm left right₂
  /-- Scalar compatibility in the second variable. -/
  smulRight : ∀ scalar left right,
    sixPointHeartCoefficientForm left (scalar • right) =
      scalar * sixPointHeartCoefficientForm left right
  /-- Alternation. -/
  alternating : ∀ heart, sixPointHeartCoefficientForm heart heart = 0
  /-- Nondegeneracy. -/
  nondegenerate : ∀ heart,
    (∀ test, sixPointHeartCoefficientForm heart test = 0) → heart = 0

/-- The normalized dot product gives the six-point coefficient heart a
nondegenerate alternating bilinear form. -/
theorem sixPointHeartCoefficientForm_properties :
    SixPointHeartCoefficientFormProperties :=
  ⟨sixPointHeartCoefficientForm_add_left,
    sixPointHeartCoefficientForm_smul_left,
    sixPointHeartCoefficientForm_comm,
    sixPointHeartCoefficientForm_add_right,
    sixPointHeartCoefficientForm_smul_right,
    sixPointHeartCoefficientForm_self,
    sixPointHeartCoefficientForm_nondegenerate⟩

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
