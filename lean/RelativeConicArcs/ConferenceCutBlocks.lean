import Mathlib.Data.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-!
# Cut blocks of a symmetric conference matrix

Order the coordinates of a symmetric matrix `C` by a subset and its
complement, so that

```
C = fromBlocks A B Bᵀ E
```

with `A` the principal block on the subset and `B` the cross block between the
subset and its complement.  This module records the symbolic content of the
exchange-spectrum calculation for such a cut, over an arbitrary commutative
ring and for an arbitrary index type.

The first theorem is the cross-block identity: if `C * C = q • 1`, then
`B * Bᵀ = q • 1 - A * A`.  Over the reals this is what makes the squared
singular values of `B / √q` the numbers `q - α²` for `α` an eigenvalue of `A`,
but no eigenvalue, singular value, or spectral statement is formalized here;
the identity itself is a polynomial consequence of the block product.

The second theorem is the trace of the square of a zero-diagonal matrix whose
off-diagonal entries square to one: it is `d(d-1)` for `d` the cardinality of
the index type, which is the first exchange moment's only input.

The third is the dichotomy for a four-set: the sum of the three signed
Hamilton-cycle products of a zero-diagonal symmetric sign matrix on four
labels is `3` or `-1`, because each edge occurs twice in the product of the
three cycles, so that product is one.  A four-set is aligned exactly when the
sum is `3`.

The organization of the fourth trace by the support of a closed four-walk,
which converts these weights into the second exchange moment, is not
formalized, and neither is the inclusion-matrix rank argument or the exclusion
of higher orders.
-/

namespace RelativeConicArcs.ConferenceCutBlocks

open Matrix

/-- The cross-block identity of a cut: if the blocked matrix squares to a
scalar, the cross block times its transpose is that scalar minus the square of
the principal block.  This is the principal block of the equation `C * C =
q • 1` on the chosen subset. -/
theorem mul_transpose_eq_of_sq_smul {R : Type*} [CommRing R]
    {n m : Type*} [Fintype n] [Fintype m] [DecidableEq n] [DecidableEq m]
    (A : Matrix n n R) (B : Matrix n m R) (E : Matrix m m R) (q : R)
    (h : fromBlocks A B Bᵀ E * fromBlocks A B Bᵀ E = q • 1) :
    B * Bᵀ = q • (1 : Matrix n n R) - A * A := by
  have h₁ := congrArg Matrix.toBlocks₁₁ h
  rw [fromBlocks_multiply, ← fromBlocks_one (l := n) (m := m), fromBlocks_smul,
    toBlocks_fromBlocks₁₁, toBlocks_fromBlocks₁₁] at h₁
  rw [eq_sub_iff_add_eq, add_comm]
  exact h₁

/-- The trace of the square of a zero-diagonal matrix whose off-diagonal
entries multiply pairwise to one is the number of ordered pairs of distinct
indices. -/
theorem trace_mul_self {R : Type*} [CommRing R] {n : Type*} [Fintype n]
    [DecidableEq n] (A : Matrix n n R) (hdiag : ∀ i, A i i = 0)
    (hoff : ∀ i j, i ≠ j → A i j * A j i = 1) :
    Matrix.trace (A * A) =
      (Fintype.card n : R) * ((Fintype.card n : R) - 1) := by
  have key : ∀ i : n, ∑ j, A i j * A j i = (Fintype.card n : R) - 1 := by
    intro i
    rw [← Finset.sum_erase_add _ _ (Finset.mem_univ i), hdiag i, mul_zero,
      add_zero,
      Finset.sum_congr rfl fun j hj => hoff i j (Ne.symm (Finset.ne_of_mem_erase hj))]
    rw [Finset.sum_const, Finset.card_erase_of_mem (Finset.mem_univ i)]
    have hpos : 1 ≤ Fintype.card n := Fintype.card_pos_iff.mpr ⟨i⟩
    simp [Finset.card_univ, Nat.cast_sub hpos]
  simp only [Matrix.trace, Matrix.diag_apply, Matrix.mul_apply, key]
  simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]

/-- The three signed Hamilton-cycle products of a matrix on four labels, in
the cyclic orders `0123`, `0132` and `0213`. -/
def fourSetWeight {R : Type*} [CommRing R] (M : Matrix (Fin 4) (Fin 4) R) : R :=
  M 0 1 * M 1 2 * M 2 3 * M 3 0 +
  M 0 1 * M 1 3 * M 3 2 * M 2 0 +
  M 0 2 * M 2 1 * M 1 3 * M 3 0

/-- Three ring elements that square to one and multiply to one have sum `3` or
`-1`. -/
private theorem sum_eq_three_or_neg_one {R : Type*} [CommRing R] (p q r : R)
    (hp : p * p = 1) (hq : q * q = 1) (hr : r * r = 1) (hpqr : p * q * r = 1) :
    (p + q + r - 3) * (p + q + r + 1) = 0 := by
  have hpq : p * q = r :=
    calc p * q = p * q * (r * r) := by rw [hr]; ring
      _ = p * q * r * r := by ring
      _ = r := by rw [hpqr]; ring
  have hpr : p * r = q :=
    calc p * r = p * r * (q * q) := by rw [hq]; ring
      _ = p * q * r * q := by ring
      _ = q := by rw [hpqr]; ring
  have hqr : q * r = p :=
    calc q * r = q * r * (p * p) := by rw [hp]; ring
      _ = p * q * r * p := by ring
      _ = p := by rw [hpqr]; ring
  linear_combination hp + hq + hr + 2 * hpq + 2 * hpr + 2 * hqr

/-- The dichotomy in the six edge signs of a four-set: the three Hamilton-cycle
products of signs squaring to one sum to `3` or to `-1`, because every edge
occurs twice in their product. -/
private theorem sum_hamiltonCycles_eq_three_or_neg_one {R : Type*} [CommRing R]
    (a b c d e f : R) (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1)
    (hd : d * d = 1) (he : e * e = 1) (hf : f * f = 1) :
    (a * d * f * c + a * e * f * b + b * d * e * c - 3) *
      (a * d * f * c + a * e * f * b + b * d * e * c + 1) = 0 := by
  refine sum_eq_three_or_neg_one _ _ _ ?_ ?_ ?_ ?_
  · calc a * d * f * c * (a * d * f * c)
        = a * a * (d * d) * (f * f) * (c * c) := by ring
      _ = 1 := by rw [ha, hd, hf, hc]; ring
  · calc a * e * f * b * (a * e * f * b)
        = a * a * (e * e) * (f * f) * (b * b) := by ring
      _ = 1 := by rw [ha, he, hf, hb]; ring
  · calc b * d * e * c * (b * d * e * c)
        = b * b * (d * d) * (e * e) * (c * c) := by ring
      _ = 1 := by rw [hb, hd, he, hc]; ring
  · calc a * d * f * c * (a * e * f * b) * (b * d * e * c)
        = a * a * (b * b) * (c * c) * (d * d) * (e * e) * (f * f) := by ring
      _ = 1 := by rw [ha, hb, hc, hd, he, hf]; ring

/-- A four-set of a zero-diagonal symmetric sign matrix has Hamilton-cycle
weight `3` or `-1`.  A four-set is aligned exactly when the weight is `3`. -/
theorem fourSetWeight_eq_three_or_neg_one {R : Type*} [CommRing R]
    (M : Matrix (Fin 4) (Fin 4) R) (hsym : ∀ i j, M j i = M i j)
    (hsq : ∀ i j, i ≠ j → M i j * M i j = 1) :
    (fourSetWeight M - 3) * (fourSetWeight M + 1) = 0 := by
  simp only [fourSetWeight, hsym 0 2, hsym 0 3, hsym 1 2, hsym 2 3]
  exact sum_hamiltonCycles_eq_three_or_neg_one (M 0 1) (M 0 2) (M 0 3) (M 1 2)
    (M 1 3) (M 2 3) (hsq 0 1 (by decide)) (hsq 0 2 (by decide))
    (hsq 0 3 (by decide)) (hsq 1 2 (by decide)) (hsq 1 3 (by decide))
    (hsq 2 3 (by decide))

end RelativeConicArcs.ConferenceCutBlocks
