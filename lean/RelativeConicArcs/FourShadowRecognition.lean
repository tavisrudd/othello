import RelativeConicArcs.ClebschOperatorShadows
import Mathlib

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

/-- Scaling every matrix entry gives the commutator-Pfaffian cubic weight
three in the matrix. -/
theorem matchingEvaluation_smul (s : R)
    (C : Matrix (Fin 6) (Fin 6) R) (x : Fin 6 → R) :
    matchingEvaluation (s • C) x = s ^ 3 * matchingEvaluation C x := by
  simp [matchingEvaluation]
  ring

/-- Scaling every matrix entry gives the triangle cubic weight three in the
matrix. -/
theorem triangleCubic_smul (s : R)
    (C : Matrix (Fin 6) (Fin 6) R) (x : Fin 6 → R) :
    triangleCubic (s • C) x = s ^ 3 * triangleCubic C x := by
  simp [triangleCubic, cubicTerm, triangleSign]
  ring

/-- A nonzero common edge scale does not change the proportionality scalar
between the two cubic shadows. -/
theorem cubicsProportional_smul_iff (s : R) (hs : s ≠ 0)
    (C : Matrix (Fin 6) (Fin 6) R) (mu : R) :
    CubicsProportional (s • C) mu ↔ CubicsProportional C mu := by
  constructor <;> intro h x
  · have hx := h x
    rw [matchingEvaluation_smul, triangleCubic_smul] at hx
    apply mul_left_cancel₀ (pow_ne_zero 3 hs)
    simpa [mul_assoc, mul_left_comm] using hx
  · rw [matchingEvaluation_smul, triangleCubic_smul, h x]
    ring

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

set_option maxHeartbeats 800000 in
private theorem pairTriangleSum_eq_translationMixedDifference
    (C : Matrix (Fin 6) (Fin 6) R)
    (hsymm : C.transpose = C)
    (hdiag : ∀ i, C i i = 0)
    (i j : Fin 6) (hij : i ≠ j) :
    pairTriangleSum C i j =
      triangleCubic C (fun k => doubleBump i j k + 1) -
      triangleCubic C (fun k => singleBump i k + 1) -
      triangleCubic C (fun k => singleBump j k + 1) +
      triangleCubic C (fun _ => 1) := by
  have hs : ∀ a b, C a b = C b a := by
    intro a b
    simpa [Matrix.transpose_apply] using
      congrArg (fun M : Matrix (Fin 6) (Fin 6) R => M b a) hsymm
  fin_cases i <;> fin_cases j <;>
    simp_all [triangleCubic, cubicTerm, pairTriangleSum, triangleSign,
      doubleBump, singleBump, hdiag, hs, Fin.sum_univ_succ] <;>
    ring

/-- Translation invariance of the triangle cubic makes every pair moment
vanish.  The four translated sparse vectors implement the mixed finite
difference which extracts the coefficient through the chosen pair. -/
theorem pairTriangleSum_eq_zero_of_triangleCubic_translate
    (C : Matrix (Fin 6) (Fin 6) R)
    (hsymm : C.transpose = C)
    (hdiag : ∀ i, C i i = 0)
    (htranslate : ∀ (x : Fin 6 → R) (t : R),
      triangleCubic C (fun i => x i + t) = triangleCubic C x)
    (i j : Fin 6) (hij : i ≠ j) :
    pairTriangleSum C i j = 0 := by
  rw [pairTriangleSum_eq_translationMixedDifference C hsymm hdiag i j hij,
    htranslate (doubleBump i j) 1, htranslate (singleBump i) 1,
    htranslate (singleBump j) 1, htranslate (fun _ => 0) 1]
  fin_cases i <;> fin_cases j <;>
    simp_all [triangleCubic, cubicTerm, doubleBump, singleBump]

/-- Nonzero proportionality of the two cubic shadows forces all pair moments
of a zero-diagonal matrix to vanish. -/
theorem pairTriangleSum_eq_zero_of_cubicsProportional
    (C : Matrix (Fin 6) (Fin 6) R) (mu : R)
    (hsymm : C.transpose = C)
    (hdiag : ∀ i, C i i = 0)
    (hmu : mu ≠ 0) (hprop : CubicsProportional C mu)
    (i j : Fin 6) (hij : i ≠ j) :
    pairTriangleSum C i j = 0 := by
  apply pairTriangleSum_eq_zero_of_triangleCubic_translate C hsymm hdiag _ i j hij
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
    pairTriangleSum_eq_zero_of_cubicsProportional C mu hsymm hdiag hmu hprop
  apply exists_scalar_mul_self_of_offDiagonal_zero C hedge
  exact mul_self_apply_eq_zero_of_pairBalance C hsymm hedge hbalance

private theorem five_sign_balances_force_inner_products
    (a b c d e f g h i j : ℤ)
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1)
    (hd : d * d = 1) (he : e * e = 1) (hf : f * f = 1)
    (hg : g * g = 1) (hh : h * h = 1) (hi : i * i = 1)
    (hj : j * j = 1)
    (r1 : a + b + c + d = 0)
    (r2 : a + e + f + g = 0)
    (r3 : b + e + h + i = 0)
    (r4 : c + f + h + j = 0)
    (r5 : d + g + i + j = 0) :
    1 + b * e + c * f + d * g = 0 ∧
    1 + a * e + c * h + d * i = 0 ∧
    1 + a * f + b * h + d * j = 0 ∧
    1 + a * g + b * i + c * j = 0 ∧
    1 + a * b + f * h + g * i = 0 ∧
    1 + a * c + e * h + g * j = 0 ∧
    1 + a * d + e * i + f * j = 0 ∧
    1 + b * c + e * f + i * j = 0 ∧
    1 + b * d + e * g + h * j = 0 ∧
    1 + c * d + f * g + h * i = 0 := by
  constructor
  · nlinarith [sq_nonneg (b + e), sq_nonneg (c + f), sq_nonneg (d + g),
      sq_nonneg (h + i + j)]
  constructor
  · nlinarith [sq_nonneg (a + e), sq_nonneg (c + h), sq_nonneg (d + i),
      sq_nonneg (f + g + j)]
  constructor
  · nlinarith [sq_nonneg (a + f), sq_nonneg (b + h), sq_nonneg (d + j),
      sq_nonneg (e + g + i)]
  constructor
  · nlinarith [sq_nonneg (a + g), sq_nonneg (b + i), sq_nonneg (c + j),
      sq_nonneg (e + f + h)]
  constructor
  · nlinarith [sq_nonneg (a + b), sq_nonneg (f + h), sq_nonneg (g + i),
      sq_nonneg (c + d + j)]
  constructor
  · nlinarith [sq_nonneg (a + c), sq_nonneg (e + h), sq_nonneg (g + j),
      sq_nonneg (b + d + i)]
  constructor
  · nlinarith [sq_nonneg (a + d), sq_nonneg (e + i), sq_nonneg (f + j),
      sq_nonneg (b + c + h)]
  constructor
  · nlinarith [sq_nonneg (b + c), sq_nonneg (e + f), sq_nonneg (i + j),
      sq_nonneg (a + d + g)]
  constructor
  · nlinarith [sq_nonneg (b + d), sq_nonneg (e + g), sq_nonneg (h + j),
      sq_nonneg (a + c + f)]
  · nlinarith [sq_nonneg (c + d), sq_nonneg (f + g), sq_nonneg (h + i),
      sq_nonneg (a + b + e)]

/-- The integral sign represented by a Boolean edge bit.  `false` denotes a
positive edge and `true` a negative edge. -/
def boolSign (b : Bool) : ℤ := if b then -1 else 1

/-- A root-normalized symmetric sign matrix.  The ten Boolean parameters are
the edges `12,13,14,15,23,24,25,34,35,45`, in that order. -/
def normalizedSignMatrix (bits : Fin 10 → Bool) : Matrix (Fin 6) (Fin 6) ℤ :=
  !![0, 1, 1, 1, 1, 1;
     1, 0, boolSign (bits 0), boolSign (bits 1), boolSign (bits 2), boolSign (bits 3);
     1, boolSign (bits 0), 0, boolSign (bits 4), boolSign (bits 5), boolSign (bits 6);
     1, boolSign (bits 1), boolSign (bits 4), 0, boolSign (bits 7), boolSign (bits 8);
     1, boolSign (bits 2), boolSign (bits 5), boolSign (bits 7), 0, boolSign (bits 9);
     1, boolSign (bits 3), boolSign (bits 6), boolSign (bits 8), boolSign (bits 9), 0]

/-- The five root-pair moments used by the normalized recognition packet. -/
def FirstRowBalanced (C : Matrix (Fin 6) (Fin 6) ℤ) : Prop :=
  ∀ i, i ≠ 0 → pairTriangleSum C 0 i = 0

/-- The positive graph away from the normalized root has degree two at every
vertex.  A simple two-regular graph on five vertices is a pentagon, so this is
the labelled gauge form of the pentagon classification. -/
def PentagonGauge (C : Matrix (Fin 6) (Fin 6) ℤ) : Prop :=
  (∀ i, i ≠ 0 → C 0 i = 1) ∧
  ∀ i, i ≠ 0 →
    ((Finset.univ.filter fun j : Fin 6 => j ≠ 0 ∧ j ≠ i ∧ C i j = 1).card = 2)

private theorem four_bool_signs_sum_zero_positive_count
    (a b c d : Bool)
    (hsum : boolSign a + boolSign b + boolSign c + boolSign d = 0) :
    [a, b, c, d].count false = 2 := by
  cases a <;> cases b <;> cases c <;> cases d <;>
    simp_all [boolSign]

/-- The five root-pair balances put every root-normalized signing in pentagon
gauge.  The proof uses the four incident signs in each row, rather than an
enumeration of the ten-edge parameter space. -/
theorem pentagonGauge_of_firstRowBalanced (bits : Fin 10 → Bool)
    (hbalance : FirstRowBalanced (normalizedSignMatrix bits)) :
    PentagonGauge (normalizedSignMatrix bits) := by
  constructor
  · intro i hi
    fin_cases i <;> simp_all [normalizedSignMatrix]
  · intro i hi
    have hb := hbalance i hi
    fin_cases i <;>
      simp_all [FirstRowBalanced, pairTriangleSum, triangleSign,
        normalizedSignMatrix, boolSign]
    all_goals
      first
      | exact four_bool_signs_sum_zero_positive_count _ _ _ _ (by omega)
      | omega

/-- The pentagon balance equations imply the conference square by ten
symbolic inner-product identities.  This is the structural converse; it does
not enumerate the `2^10` normalized signings. -/
theorem normalizedSignMatrix_sq_of_firstRowBalanced (bits : Fin 10 → Bool)
    (hbalance : FirstRowBalanced (normalizedSignMatrix bits)) :
    normalizedSignMatrix bits * normalizedSignMatrix bits =
      5 • (1 : Matrix (Fin 6) (Fin 6) ℤ) := by
  let a := boolSign (bits 0)
  let b := boolSign (bits 1)
  let c := boolSign (bits 2)
  let d := boolSign (bits 3)
  let e := boolSign (bits 4)
  let f := boolSign (bits 5)
  let g := boolSign (bits 6)
  let h := boolSign (bits 7)
  let i := boolSign (bits 8)
  let j := boolSign (bits 9)
  have hsquares : a * a = 1 ∧ b * b = 1 ∧ c * c = 1 ∧ d * d = 1 ∧
      e * e = 1 ∧ f * f = 1 ∧ g * g = 1 ∧ h * h = 1 ∧
      i * i = 1 ∧ j * j = 1 := by
    simp [a, b, c, d, e, f, g, h, i, j, boolSign]
  have hr1 : a + b + c + d = 0 := by
    have := hbalance 1 (by decide)
    simpa [FirstRowBalanced, pairTriangleSum, triangleSign,
      normalizedSignMatrix, a, b, c, d] using this
  have hr2 : a + e + f + g = 0 := by
    have := hbalance 2 (by decide)
    simpa [FirstRowBalanced, pairTriangleSum, triangleSign,
      normalizedSignMatrix, a, e, f, g] using this
  have hr3 : b + e + h + i = 0 := by
    have := hbalance 3 (by decide)
    simpa [FirstRowBalanced, pairTriangleSum, triangleSign,
      normalizedSignMatrix, b, e, h, i] using this
  have hr4 : c + f + h + j = 0 := by
    have := hbalance 4 (by decide)
    simpa [FirstRowBalanced, pairTriangleSum, triangleSign,
      normalizedSignMatrix, c, f, h, j] using this
  have hr5 : d + g + i + j = 0 := by
    have := hbalance 5 (by decide)
    simpa [FirstRowBalanced, pairTriangleSum, triangleSign,
      normalizedSignMatrix, d, g, i, j] using this
  rcases hsquares with ⟨ha, hb, hc, hd, he, hf, hg, hh, hi, hj⟩
  have hinner := five_sign_balances_force_inner_products a b c d e f g h i j
    ha hb hc hd he hf hg hh hi hj hr1 hr2 hr3 hr4 hr5
  rcases hinner with ⟨h12, h13, h14, h15, h23, h24, h25, h34, h35, h45⟩
  ext p q
  fin_cases p <;> fin_cases q <;>
    simp [Matrix.mul_apply, Fin.sum_univ_succ, normalizedSignMatrix,
      a, b, c, d, e, f, g, h, i, j] <;>
    nlinarith

/-- The coefficient of `x₀x₁x₂` in the commutator-Pfaffian cubic,
using the Hodge orientation fixed by the bracket expansion. -/
def shadowCoefficient012 (C : Matrix (Fin 6) (Fin 6) ℤ) : ℤ :=
  C 3 0 * (C 4 1 * C 5 2 - C 4 2 * C 5 1) -
  C 3 1 * (C 4 0 * C 5 2 - C 4 2 * C 5 0) +
  C 3 2 * (C 4 0 * C 5 1 - C 4 1 * C 5 0)

/-- One coefficient fixes the positive Hodge orientation in the normalized
six-test packet. -/
def PositiveOrientation012 (C : Matrix (Fin 6) (Fin 6) ℤ) : Prop :=
  shadowCoefficient012 C = 4 * triangleSign C 0 1 2

/-- One coefficient fixes the opposite Hodge orientation in the normalized
six-test packet. -/
def NegativeOrientation012 (C : Matrix (Fin 6) (Fin 6) ℤ) : Prop :=
  shadowCoefficient012 C = -4 * triangleSign C 0 1 2

private def normalizedCode (n : ℕ) : Fin 10 → Bool :=
  fun k => n.testBit k

private theorem positive_six_test_codes (bits : Fin 10 → Bool)
    (hbalance : FirstRowBalanced (normalizedSignMatrix bits))
    (horientation : PositiveOrientation012 (normalizedSignMatrix bits)) :
    bits = normalizedCode 234 ∨ bits = normalizedCode 316 ∨
    bits = normalizedCode 453 ∨ bits = normalizedCode 598 ∨
    bits = normalizedCode 665 ∨ bits = normalizedCode 803 := by
  native_decide

private theorem negative_six_test_codes (bits : Fin 10 → Bool)
    (hbalance : FirstRowBalanced (normalizedSignMatrix bits))
    (horientation : NegativeOrientation012 (normalizedSignMatrix bits)) :
    bits = normalizedCode 220 ∨ bits = normalizedCode 358 ∨
    bits = normalizedCode 425 ∨ bits = normalizedCode 570 ∨
    bits = normalizedCode 707 ∨ bits = normalizedCode 789 := by
  native_decide

private theorem orientation012_of_firstRowBalanced (bits : Fin 10 → Bool)
    (hbalance : FirstRowBalanced (normalizedSignMatrix bits)) :
    PositiveOrientation012 (normalizedSignMatrix bits) ∨
      NegativeOrientation012 (normalizedSignMatrix bits) := by
  native_decide

/-- Five root-pair balances and the `012` coefficient with positive Hodge
orientation force the complete cubic identity.  Finite evaluation selects the
six labelled positive pentagons; each surviving polynomial identity is then
proved symbolically. -/
theorem cubicsProportional_four_of_sixTests (bits : Fin 10 → Bool)
    (hbalance : FirstRowBalanced (normalizedSignMatrix bits))
    (horientation : PositiveOrientation012 (normalizedSignMatrix bits)) :
    CubicsProportional (normalizedSignMatrix bits) 4 := by
  rcases positive_six_test_codes bits hbalance horientation with
    h | h | h | h | h | h
  all_goals
    rw [h]
    intro x
    simp [matchingEvaluation, GoldenMatchingCubics.bracket, triangleCubic,
      cubicTerm, triangleSign, normalizedSignMatrix, normalizedCode, boolSign]
    ring

/-- The same six-test packet with the opposite coefficient orientation forces
the cubic proportionality scalar `-4`. -/
theorem cubicsProportional_neg_four_of_sixTests (bits : Fin 10 → Bool)
    (hbalance : FirstRowBalanced (normalizedSignMatrix bits))
    (horientation : NegativeOrientation012 (normalizedSignMatrix bits)) :
    CubicsProportional (normalizedSignMatrix bits) (-4) := by
  rcases negative_six_test_codes bits hbalance horientation with
    h | h | h | h | h | h
  all_goals
    rw [h]
    intro x
    simp [matchingEvaluation, GoldenMatchingCubics.bracket, triangleCubic,
      cubicTerm, triangleSign, normalizedSignMatrix, normalizedCode, boolSign]
    ring

/-- On normalized scalar sign matrices, nonzero proportionality of the two
cubic shadows is equivalent to the conference square.  The two possible
proportionality scalars are the two Hodge orientations. -/
theorem exists_nonzero_cubicsProportional_iff_conferenceSquare
    (bits : Fin 10 → Bool) :
    (∃ mu : ℤ, mu ≠ 0 ∧ CubicsProportional (normalizedSignMatrix bits) mu) ↔
      normalizedSignMatrix bits * normalizedSignMatrix bits =
        5 • (1 : Matrix (Fin 6) (Fin 6) ℤ) := by
  constructor
  · rintro ⟨mu, hmu, hprop⟩
    apply normalizedSignMatrix_sq_of_firstRowBalanced bits
    intro i hi
    exact pairTriangleSum_eq_zero_of_cubicsProportional
      (normalizedSignMatrix bits) mu (by
        ext p q
        fin_cases p <;> fin_cases q <;> rfl) (by
        intro k
        fin_cases k <;> rfl) hmu hprop 0 i hi
  · intro hsq
    have hsymm : (normalizedSignMatrix bits).transpose = normalizedSignMatrix bits := by
      ext i j
      fin_cases i <;> fin_cases j <;> rfl
    have hbalance : FirstRowBalanced (normalizedSignMatrix bits) := by
      intro i hi
      exact pairTriangleSum_eq_zero (normalizedSignMatrix bits) 5 hsymm hsq 0 i hi
    rcases orientation012_of_firstRowBalanced bits hbalance with hpos | hneg
    · exact ⟨4, by norm_num, cubicsProportional_four_of_sixTests bits hbalance hpos⟩
    · exact ⟨-4, by norm_num, cubicsProportional_neg_four_of_sixTests bits hbalance hneg⟩

/-- The normalized classification is unchanged after multiplying every edge
by one nonzero scalar.  This is the scalar-sign form of the recognition
theorem. -/
theorem exists_nonzero_cubicsProportional_smul_iff_conferenceSquare
    (bits : Fin 10 → Bool) (s : ℤ) (hs : s ≠ 0) :
    (∃ mu : ℤ, mu ≠ 0 ∧
      CubicsProportional (s • normalizedSignMatrix bits) mu) ↔
      normalizedSignMatrix bits * normalizedSignMatrix bits =
        5 • (1 : Matrix (Fin 6) (Fin 6) ℤ) := by
  rw [← exists_nonzero_cubicsProportional_iff_conferenceSquare bits]
  constructor
  · rintro ⟨mu, hmu, hprop⟩
    exact ⟨mu, hmu, (cubicsProportional_smul_iff s hs _ mu).mp hprop⟩
  · rintro ⟨mu, hmu, hprop⟩
    exact ⟨mu, hmu, (cubicsProportional_smul_iff s hs _ mu).mpr hprop⟩

end RelativeConicArcs.FourShadowRecognition
