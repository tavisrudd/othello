import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisGram
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixPointCoefficientHeart

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
part of the relative identification `D₂ ≃ H₂ ⊗ E[2]`.  It does not
construct an elliptic scheme, its two-torsion local system, the Weil pairing,
or the relative isogeny kernel.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

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

/-- The two-primary coefficient discriminant after tensoring with `T`. -/
def SixAxisTwoPrimaryDiscriminant
    (T : Type*) [AddCommGroup T] [Module F2 T] :=
  {vector : Fin 5 → T // sixAxisGramTensorMap vector = 0}

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

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
