import RelativeConicArcs.ClebschOperatorShadows
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring

/-!
# Recognition from the triangle and commutator-Pfaffian cubics

For a symmetric zero-diagonal matrix on six labels, the triangle cubic records
the products around triples, while the commutator Pfaffian is the signed
perfect-matching evaluation of the bracket matrix.  If the latter is a
nonzero scalar multiple of the former and every edge is nonzero, translation
invariance forces all pair moments to vanish.  The matrix square is then
diagonal, and associativity forces its diagonal entries to agree.

The argument is symbolic over an integral domain.  No finite classification
or generated certificate is used in the weighted converse.
-/

namespace RelativeConicArcs.FourShadowRecognition

open Matrix
open ClebschGoldenConference
open GoldenCommutatorPfaffian

variable {R : Type*} [CommRing R] [IsDomain R]

/-- Proportionality between the commutator-Pfaffian cubic and the triangle
cubic, with the proportionality scalar displayed explicitly. -/
def CubicsProportional
    (C : Matrix (Fin 6) (Fin 6) R) (mu : R) : Prop :=
  ∀ x, matchingEvaluation C x = mu * triangleCubic C x

/-- Nonzero proportionality transfers affine translation invariance from the
commutator-Pfaffian cubic to the triangle cubic. -/
theorem triangleCubic_translate_of_proportional
    (C : Matrix (Fin 6) (Fin 6) R) (mu : R)
    (hmu : mu ≠ 0) (hprop : CubicsProportional C mu)
    (x : Fin 6 → R) (t : R) :
    triangleCubic C (fun i => x i + t) = triangleCubic C x := by
  apply mul_left_cancel₀ hmu
  rw [← hprop, matchingEvaluation_translate, hprop]

private def singleBump (i : Fin 6) : Fin 6 → R :=
  fun k => if k = i then 1 else 0

private def doubleBump (i j : Fin 6) : Fin 6 → R :=
  fun k => singleBump i k + singleBump j k

/-- Translation invariance of the triangle cubic makes every pair moment
vanish.  The four translated sparse vectors implement the mixed finite
difference which extracts the coefficient through the chosen pair. -/
theorem pairTriangleSum_eq_zero_of_triangleCubic_translate
    (C : Matrix (Fin 6) (Fin 6) R)
    (hdiag : ∀ i, C i i = 0)
    (htranslate : ∀ (x : Fin 6 → R) (t : R),
      triangleCubic C (fun i => x i + t) = triangleCubic C x)
    (i j : Fin 6) (hij : i ≠ j) :
    pairTriangleSum C i j = 0 := by
  have hij' := hij
  fin_cases i <;> fin_cases j <;> simp_all only [Fin.isValue, Fin.zero_eta,
    Fin.mk.injEq, OfNat.ofNat, ne_eq, not_false_eq_true]
  all_goals
    have hboth := htranslate (doubleBump i j) 1
    have hleft := htranslate (singleBump i) 1
    have hright := htranslate (singleBump j) 1
    have hzero := htranslate (fun _ => 0) 1
    simp [triangleCubic, cubicTerm, pairTriangleSum, triangleSign,
      doubleBump, singleBump, hdiag] at hboth hleft hright hzero ⊢
    ring_nf at hboth hleft hright hzero ⊢
    linear_combination hboth - hleft - hright + hzero

/-- Nonzero proportionality of the two cubic shadows forces all pair moments
of a zero-diagonal matrix to vanish. -/
theorem pairTriangleSum_eq_zero_of_cubicsProportional
    (C : Matrix (Fin 6) (Fin 6) R) (mu : R)
    (hdiag : ∀ i, C i i = 0)
    (hmu : mu ≠ 0) (hprop : CubicsProportional C mu)
    (i j : Fin 6) (hij : i ≠ j) :
    pairTriangleSum C i j = 0 := by
  apply pairTriangleSum_eq_zero_of_triangleCubic_translate C hdiag _ i j hij
  exact triangleCubic_translate_of_proportional C mu hmu hprop

/-- Pair balance and nonzero edges make the square of a symmetric matrix
diagonal. -/
theorem mul_self_apply_eq_zero_of_pairBalance
    (C : Matrix (Fin 6) (Fin 6) R)
    (hsymm : C.transpose = C)
    (hedge : ∀ i j, i ≠ j → C i j ≠ 0)
    (hbalance : ∀ i j, i ≠ j → pairTriangleSum C i j = 0)
    (i j : Fin 6) (hij : i ≠ j) :
    (C * C) i j = 0 := by
  have hmoment := pairTriangleSum_eq_mul_mulApply C hsymm i j
  rw [hbalance i j hij] at hmoment
  exact (mul_eq_zero.mp hmoment.symm).resolve_left (hedge i j hij)

private theorem matrix_eq_diagonal_of_offDiagonal_zero
    (D : Matrix (Fin 6) (Fin 6) R)
    (hoff : ∀ i j, i ≠ j → D i j = 0) :
    D = Matrix.diagonal (fun i => D i i) := by
  ext i j
  by_cases hij : i = j
  · subst j
    simp
  · simp [Matrix.diagonal_apply, hij, hoff i j hij]

/-- A symmetric matrix with nonzero off-diagonal entries and diagonal square
has scalar square.  The equality of diagonal entries follows from
`C * C² = C² * C`. -/
theorem exists_scalar_mul_self_of_offDiagonal_zero
    (C : Matrix (Fin 6) (Fin 6) R)
    (hedge : ∀ i j, i ≠ j → C i j ≠ 0)
    (hoff : ∀ i j, i ≠ j → (C * C) i j = 0) :
    ∃ lambda : R, C * C = lambda • (1 : Matrix (Fin 6) (Fin 6) R) := by
  let D := C * C
  have hdiagD : D = Matrix.diagonal (fun i => D i i) :=
    matrix_eq_diagonal_of_offDiagonal_zero D hoff
  have hcomm : C * D = D * C := by
    simp only [D, Matrix.mul_assoc]
  have hdiag_eq : ∀ i, D i i = D 0 0 := by
    intro i
    by_cases hi : i = 0
    · simpa [hi]
    · have hentry := congrArg (fun M : Matrix (Fin 6) (Fin 6) R => M 0 i) hcomm
      rw [hdiagD] at hentry
      simp [Matrix.mul_apply] at hentry
      exact (mul_left_cancel₀ (hedge 0 i (Ne.symm hi)) hentry).symm
  refine ⟨D 0 0, ?_⟩
  rw [hdiagD]
  ext i j
  by_cases hij : i = j
  · subst j
    simp [hdiag_eq]
  · simp [Matrix.diagonal_apply, hij]

/-- For a symmetric zero-diagonal order-six matrix with nonzero edges,
nonzero proportionality between the commutator-Pfaffian cubic and the
triangle cubic forces a scalar quadratic equation. -/
theorem exists_mul_self_eq_scalar_of_cubicsProportional
    (C : Matrix (Fin 6) (Fin 6) R) (mu : R)
    (hsymm : C.transpose = C)
    (hdiag : ∀ i, C i i = 0)
    (hedge : ∀ i j, i ≠ j → C i j ≠ 0)
    (hmu : mu ≠ 0) (hprop : CubicsProportional C mu) :
    ∃ lambda : R, C * C = lambda • (1 : Matrix (Fin 6) (Fin 6) R) := by
  have hbalance : ∀ i j, i ≠ j → pairTriangleSum C i j = 0 :=
    pairTriangleSum_eq_zero_of_cubicsProportional C mu hdiag hmu hprop
  apply exists_scalar_mul_self_of_offDiagonal_zero C hedge
  exact mul_self_apply_eq_zero_of_pairBalance C hsymm hedge hbalance

end RelativeConicArcs.FourShadowRecognition
