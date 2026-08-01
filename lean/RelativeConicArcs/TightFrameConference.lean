import Mathlib

/-!
# Tight frames and conference Gram matrices

If the frame operator of a matrix `A` is scalar, then its Gram matrix
`AᵀA` satisfies the corresponding quadratic equation.  When the Gram matrix
has the equiangular form `nI+rC`, the frame scalar is `2n`, `r` is a unit,
and `n²=5r²`, this quadratic equation forces `C²=5I`.

This is the structural tight-frame mechanism behind the order-six golden
conference equation.  It avoids summing six displayed rank-one matrices.
-/

namespace RelativeConicArcs.TightFrameConference

open Matrix

variable {R : Type*} [CommRing R]
variable {ι κ : Type*} [Fintype ι] [Fintype κ] [DecidableEq ι] [DecidableEq κ]

/-- A scalar frame operator forces the same scalar quadratic equation for
the Gram matrix. -/
theorem gram_sq_of_frameOperator
    (A : Matrix ι κ R) (λ : R)
    (hframe : A * A.transpose = λ • (1 : Matrix ι ι R)) :
    (A.transpose * A) * (A.transpose * A) = λ • (A.transpose * A) := by
  calc
    (A.transpose * A) * (A.transpose * A) =
        A.transpose * (A * A.transpose) * A := by
      simp only [Matrix.mul_assoc]
    _ = A.transpose * (λ • (1 : Matrix ι ι R)) * A := by rw [hframe]
    _ = λ • (A.transpose * A) := by
      ext i j
      simp [Matrix.mul_apply, Finset.mul_sum]

/-- An equiangular tight-frame Gram equation forces the normalized
conference square. -/
theorem conference_sq_of_gram
    (G C : Matrix κ κ R) (n r : R)
    (hG : G = n • (1 : Matrix κ κ R) + r • C)
    (hquad : G * G = (2 * n) • G)
    (hnr : n ^ 2 = 5 * r ^ 2)
    (hr : IsUnit r) :
    C * C = (5 : R) • (1 : Matrix κ κ R) := by
  rw [hG] at hquad
  have hscaled : r ^ 2 • (C * C) = r ^ 2 • ((5 : R) • (1 : Matrix κ κ R)) := by
    calc
      r ^ 2 • (C * C) =
          (n • (1 : Matrix κ κ R) + r • C) *
              (n • (1 : Matrix κ κ R) + r • C)
            - (2 * n) • (n • (1 : Matrix κ κ R) + r • C)
            + n ^ 2 • (1 : Matrix κ κ R) := by
              noncomm_ring
      _ = n ^ 2 • (1 : Matrix κ κ R) := by rw [hquad, sub_self, zero_add]
      _ = r ^ 2 • ((5 : R) • (1 : Matrix κ κ R)) := by
        rw [hnr]
        module
  ext i j
  have hij := congrArg (fun M : Matrix κ κ R => M i j) hscaled
  simp only [smul_apply, smul_eq_mul] at hij
  exact (hr.pow 2).mul_left_cancel hij

end RelativeConicArcs.TightFrameConference
