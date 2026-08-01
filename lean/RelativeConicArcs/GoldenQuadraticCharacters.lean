import Mathlib

/-!
# The discriminant and spinor characters of the golden exchanger

The equation `t²=t+1` has discriminant five.  Over a field in which two is
invertible, choosing a root `t` is equivalent to choosing a square root
`s=2t-1` of five; the deck involution sends `t` to `1-t` and `s` to `-s`.

The rational exchanger is the quarter-turn on the last two coordinates.  It
is the product of reflection in `e₂` and reflection in `e₂-e₃`; the product
of their quadratic norms is `1*2=2`.  This is the reflection witness for its
spinor square class.  The final `𝔽₁₁` theorem checks only that the resulting
class is nonsquare; it is not used to discover the class.
-/

namespace RelativeConicArcs.GoldenQuadraticCharacters

variable {R : Type*} [CommRing R]

/-- The nontrivial deck transformation of the golden quadratic equation. -/
def goldenConjugate (t : R) : R := 1 - t

@[simp]
theorem goldenConjugate_involutive (t : R) :
    goldenConjugate (goldenConjugate t) = t := by
  simp [goldenConjugate]

/-- The deck transformation preserves the equation `t²=t+1`. -/
theorem goldenConjugate_relation {t : R} (ht : t ^ 2 = t + 1) :
    goldenConjugate t ^ 2 = goldenConjugate t + 1 := by
  rw [goldenConjugate]
  rw [show (1 - t) ^ 2 = t ^ 2 - 2 * t + 1 by ring, ht]
  ring

/-- The two golden roots have product `-1`. -/
theorem golden_mul_conjugate {t : R} (ht : t ^ 2 = t + 1) :
    t * goldenConjugate t = -1 := by
  rw [goldenConjugate]
  rw [show t * (1 - t) = t - t ^ 2 by ring, ht]
  ring

/-- A golden root produces the discriminant square root `2t-1`. -/
theorem golden_discriminant_square {t : R} (ht : t ^ 2 = t + 1) :
    (2 * t - 1) ^ 2 = 5 := by
  rw [show (2 * t - 1) ^ 2 = 4 * t ^ 2 - 4 * t + 1 by ring, ht]
  ring

section Field

variable {K : Type*} [Field K]

/-- Over a field of characteristic different from two, a square root of five
produces a root of the golden quadratic. -/
theorem goldenRoot_of_sqrtFive (h2 : (2 : K) ≠ 0) {s : K} (hs : s ^ 2 = 5) :
    ((1 + s) / 2) ^ 2 = (1 + s) / 2 + 1 := by
  field_simp [h2]
  rw [show (1 + s) ^ 2 = 1 + 2 * s + s ^ 2 by ring]
  rw [hs]
  ring

/-- Over a field of characteristic different from two, the golden quadratic
splits exactly when five is a square. -/
theorem exists_goldenRoot_iff_exists_sqrtFive (h2 : (2 : K) ≠ 0) :
    (∃ t : K, t ^ 2 = t + 1) ↔ ∃ s : K, s ^ 2 = 5 := by
  constructor
  · rintro ⟨t, ht⟩
    exact ⟨2 * t - 1, golden_discriminant_square ht⟩
  · rintro ⟨s, hs⟩
    exact ⟨(1 + s) / 2, goldenRoot_of_sqrtFive h2 hs⟩

/-- Under the root/square-root correspondence, deck exchange negates the
chosen square root of five. -/
theorem discriminant_deck_neg {t : K} :
    2 * goldenConjugate t - 1 = -(2 * t - 1) := by
  simp [goldenConjugate]
  ring

end Field

/-! ## The rational quarter-turn and its reflection witness -/

/-- The exchanger fixing the first coordinate and rotating the last two by a
quarter-turn. -/
def exchangerMatrix : Matrix (Fin 3) (Fin 3) ℤ :=
  !![1, 0, 0; 0, 0, -1; 0, 1, 0]

/-- Reflection in the second coordinate vector. -/
def reflectionE2 : Matrix (Fin 3) (Fin 3) ℤ :=
  !![1, 0, 0; 0, -1, 0; 0, 0, 1]

/-- Reflection in the vector `e₂-e₃`; it exchanges the last two coordinates. -/
def reflectionE2SubE3 : Matrix (Fin 3) (Fin 3) ℤ :=
  !![1, 0, 0; 0, 0, 1; 0, 1, 0]

/-- The exchanger is the product of the two displayed reflections. -/
theorem exchanger_eq_reflection_mul :
    exchangerMatrix = reflectionE2 * reflectionE2SubE3 := by
  native_decide

/-- The exchanger preserves the standard quadratic form. -/
theorem exchanger_orthogonal :
    exchangerMatrix.transpose * exchangerMatrix = 1 := by
  native_decide

/-- The exchanger has determinant one. -/
theorem exchanger_det : exchangerMatrix.det = 1 := by
  native_decide

/-- The two reflecting vectors have quadratic norms one and two, so their
spinor-norm witness is exactly two. -/
theorem reflection_norm_product : (1 : ℤ) * 2 = 2 := by
  norm_num

/-! ## Reflection formula and the spinor witness -/

/-- The standard quadratic norm on the rational three-space. -/
def standardNormSq (v : Fin 3 → ℚ) : ℚ :=
  ∑ i, v i ^ 2

/-- Reflection in a nonisotropic vector for the standard quadratic form.
The formula is retained even when the displayed denominator vanishes; the
paper uses it only for the two nonisotropic vectors below. -/
def standardReflection (v : Fin 3 → ℚ) : Matrix (Fin 3) (Fin 3) ℚ :=
  1 - (2 / standardNormSq v) • Matrix.vecMulVec v v

/-- The first reflecting vector in the rational exchanger factorization. -/
def exchangerReflectionVector : Fin 3 → ℚ := ![0, 1, 0]

/-- The second reflecting vector in the rational exchanger factorization. -/
def swapReflectionVector : Fin 3 → ℚ := ![0, 1, -1]

/-- The reflection vectors have norms one and two. -/
theorem exchanger_reflection_norms :
    standardNormSq exchangerReflectionVector = 1 ∧
      standardNormSq swapReflectionVector = 2 := by
  native_decide

/-- The first displayed integral matrix is the standard reflection formula. -/
theorem reflectionE2_is_standardReflection :
    reflectionE2.map (Int.castRingHom ℚ) =
      standardReflection exchangerReflectionVector := by
  native_decide

/-- The second displayed integral matrix is the standard reflection formula. -/
theorem reflectionE2SubE3_is_standardReflection :
    reflectionE2SubE3.map (Int.castRingHom ℚ) =
      standardReflection swapReflectionVector := by
  native_decide

/-- The exchanger is therefore a product of honest rational reflections,
with spinor witness equal to the product of their derived norms. -/
theorem exchanger_reflection_factorization :
    exchangerMatrix.map (Int.castRingHom ℚ) =
      standardReflection exchangerReflectionVector *
        standardReflection swapReflectionVector ∧
      standardNormSq exchangerReflectionVector *
        standardNormSq swapReflectionVector = 2 := by
  constructor
  · rw [exchanger_eq_reflection_mul, Matrix.map_mul,
      reflectionE2_is_standardReflection,
      reflectionE2SubE3_is_standardReflection]
  · rw [exchanger_reflection_norms.1, exchanger_reflection_norms.2]
    norm_num

instance : Fact (Nat.Prime 11) := ⟨by norm_num⟩

/-- The spinor witness `2` is nonsquare in `𝔽₁₁`. -/
theorem two_not_square_zmod11 : ¬ ∃ x : ZMod 11, x ^ 2 = 2 := by
  native_decide

end RelativeConicArcs.GoldenQuadraticCharacters
