import Mathlib

/-!
# Signed equiangular Gram determinants

A three-vector equiangular Gram matrix is determined by its common squared
norm `n`, common absolute inner product `r`, and the product of its three
edge signs.  Its determinant is

`n³ - 3*n*r² + 2*ε*r³`.

For the golden relation `t²=t+1`, with `n=t+2` and `r=t`, the two triangle
signs give determinants `4*t⁴` and `4*t²`.  Thus all twenty three-vector
checks in the six-axis configuration reduce to one formula and the triangle
sign; over a field only characteristic two can make either determinant
vanish.
-/

namespace RelativeConicArcs.SignedEquiangularGram

variable {R : Type*} [CommRing R]

/-- The symmetric Gram matrix with common diagonal `n`, common inner-product
magnitude `r`, and edge signs `s₀₁,s₀₂,s₁₂`. -/
def signedGram (n r s01 s02 s12 : R) : Matrix (Fin 3) (Fin 3) R :=
  !![n, s01 * r, s02 * r;
     s01 * r, n, s12 * r;
     s02 * r, s12 * r, n]

/-- The determinant depends on the three edge signs only through their
product. -/
theorem det_signedGram {n r s01 s02 s12 : R}
    (h01 : s01 ^ 2 = 1) (h02 : s02 ^ 2 = 1) (h12 : s12 ^ 2 = 1) :
    (signedGram n r s01 s02 s12).det =
      n ^ 3 - 3 * n * r ^ 2 + 2 * (s01 * s02 * s12) * r ^ 3 := by
  rw [Matrix.det_fin_three]
  simp only [signedGram, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
    Matrix.head_cons, Matrix.tail_cons]
  rw [show s01 * r * (s01 * r) = s01 ^ 2 * r ^ 2 by ring,
    show s02 * r * (s02 * r) = s02 ^ 2 * r ^ 2 by ring,
    show s12 * r * (s12 * r) = s12 ^ 2 * r ^ 2 by ring,
    h01, h02, h12]
  ring

/-- The positive-triangle determinant under the golden relation. -/
theorem golden_det_positive {t : R} (ht : t ^ 2 = t + 1) :
    (t + 2) ^ 3 - 3 * (t + 2) * t ^ 2 + 2 * t ^ 3 = 4 * t ^ 4 := by
  have ht3 : t ^ 3 = 2 * t + 1 := by
    calc
      t ^ 3 = t * t ^ 2 := by ring
      _ = t * (t + 1) := by rw [ht]
      _ = 2 * t + 1 := by rw [← ht]; ring
  have ht4 : t ^ 4 = 3 * t + 2 := by
    calc
      t ^ 4 = (t ^ 2) ^ 2 := by ring
      _ = (t + 1) ^ 2 := by rw [ht]
      _ = 3 * t + 2 := by rw [← ht]; ring
  rw [ht3, ht4]
  ring

/-- The negative-triangle determinant under the golden relation. -/
theorem golden_det_negative {t : R} (ht : t ^ 2 = t + 1) :
    (t + 2) ^ 3 - 3 * (t + 2) * t ^ 2 - 2 * t ^ 3 = 4 * t ^ 2 := by
  have ht3 : t ^ 3 = 2 * t + 1 := by
    calc
      t ^ 3 = t * t ^ 2 := by ring
      _ = t * (t + 1) := by rw [ht]
      _ = 2 * t + 1 := by rw [← ht]; ring
  rw [ht3, ht]
  ring

/-- A root of `t²-t-1` in a nontrivial ring is nonzero. -/
theorem golden_ne_zero [Nontrivial R] {t : R} (ht : t ^ 2 = t + 1) : t ≠ 0 := by
  intro h
  rw [h] at ht
  simpa using ht

section Field

variable {K : Type*} [Field K]

/-- In characteristic different from two, the positive-triangle golden Gram
determinant is nonzero. -/
theorem golden_det_positive_ne_zero {t : K} (ht : t ^ 2 = t + 1)
    (h2 : (2 : K) ≠ 0) : 4 * t ^ 4 ≠ 0 := by
  have h4 : (4 : K) ≠ 0 := by
    norm_num [show (4 : K) = 2 * 2 by norm_num, h2]
  exact mul_ne_zero h4 (pow_ne_zero 4 (golden_ne_zero ht))

/-- In characteristic different from two, the negative-triangle golden Gram
determinant is nonzero. -/
theorem golden_det_negative_ne_zero {t : K} (ht : t ^ 2 = t + 1)
    (h2 : (2 : K) ≠ 0) : 4 * t ^ 2 ≠ 0 := by
  have h4 : (4 : K) ≠ 0 := by
    norm_num [show (4 : K) = 2 * 2 by norm_num, h2]
  exact mul_ne_zero h4 (pow_ne_zero 2 (golden_ne_zero ht))

end Field

end RelativeConicArcs.SignedEquiangularGram
