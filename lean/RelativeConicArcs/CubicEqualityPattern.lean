import Mathlib

/-!
# Cubic sums determined by index-equality patterns

A symmetric trilinear coefficient with values `a`, `b`, and `c` according as
three indices are all equal, exactly two are equal, or all distinct has a
universal expression in the first three power sums.  On the sum-zero
hyperplane, its cubic contraction is `(a - 3*b + 2*c)` times the third power
sum.  The proof uses Kronecker indicators and does not enumerate the finite
index type.
-/

namespace RelativeConicArcs.CubicEqualityPattern

open scoped BigOperators

variable {ι R : Type*} [DecidableEq ι] [CommRing R]

/-- A coefficient selected by the equality pattern of three indices. -/
def coefficient (a b c : R) (i j k : ι) : R :=
  if i = j then
    if j = k then a else b
  else if i = k then b
  else if j = k then b
  else c

private theorem coefficient_eq_indicator (a b c : R) (i j k : ι) :
    coefficient a b c i j k =
      c + (b - c) * ((if i = j then 1 else 0) +
        (if i = k then 1 else 0) + (if j = k then 1 else 0)) +
      (a - 3 * b + 2 * c) * (if i = j ∧ j = k then 1 else 0) := by
  by_cases hij : i = j <;>
    (by_cases hik : i = k <;> by_cases hjk : j = k <;>
      simp_all [coefficient] <;> ring)

omit [CommRing R] in
private theorem coefficient_reverse (a b c : R) (i j k : ι) :
    coefficient a b c i j k = coefficient a b c k j i := by
  by_cases hij : i = j <;>
    (by_cases hik : i = k <;> by_cases hjk : j = k <;>
      simp_all [coefficient, eq_comm])

private theorem coefficient_mul_eq_indicator (a b c x y z : R) (i j k : ι) :
    coefficient a b c i j k * x * y * z =
      c * x * y * z +
      (if i = j then (b - c) * x * y * z else 0) +
      (if i = k then (b - c) * x * y * z else 0) +
      (if j = k then (b - c) * x * y * z else 0) +
      (if i = j then
        if j = k then (a - 3 * b + 2 * c) * x * y * z else 0
        else 0) := by
  by_cases hij : i = j <;>
    (by_cases hik : i = k <;> by_cases hjk : j = k <;>
      simp_all [coefficient] <;> ring)

omit [DecidableEq ι] in
private theorem sum_const_mul [Fintype ι] (r : R) (f : ι → R) :
    (∑ i, r * f i) = r * ∑ i, f i := by
  rw [Finset.mul_sum]

omit [DecidableEq ι] in
private theorem sum_product_two [Fintype ι] (f g : ι → R) :
    (∑ i, ∑ j, f i * g j) = (∑ i, f i) * ∑ j, g j := by
  rw [Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro i _
  rw [Finset.mul_sum]

omit [DecidableEq ι] in
private theorem sum_product_three [Fintype ι] (f g h : ι → R) :
    (∑ i, ∑ j, ∑ k, f i * g j * h k) =
      (∑ i, f i) * (∑ j, g j) * ∑ k, h k := by
  calc
    (∑ i, ∑ j, ∑ k, f i * g j * h k) =
        ∑ i, ∑ j, (f i * g j) * ∑ k, h k := by
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          rw [Finset.mul_sum]
    _ = (∑ i, ∑ j, f i * g j) * ∑ k, h k := by
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro i _
      rw [Finset.sum_mul]
    _ = (∑ i, f i) * (∑ j, g j) * ∑ k, h k := by rw [sum_product_two]

private theorem sum_first_second_equal [Fintype ι] (r : R) (y : ι → R) :
    (∑ i, ∑ j, ∑ k, if i = j then r * y i * y j * y k else 0) =
      r * (∑ i, y i) * ∑ i, y i ^ 2 := by
  simp
  calc
    (∑ i, ∑ k, r * y i * y i * y k) =
        ∑ i, ∑ k, (r * y i ^ 2) * y k := by
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro k _
          ring
    _ = (∑ i, r * y i ^ 2) * ∑ k, y k := sum_product_two _ _
    _ = r * (∑ i, y i) * ∑ i, y i ^ 2 := by rw [sum_const_mul]; ring

private theorem sum_first_third_equal [Fintype ι] (r : R) (y : ι → R) :
    (∑ i, ∑ j, ∑ k, if i = k then r * y i * y j * y k else 0) =
      r * (∑ i, y i) * ∑ i, y i ^ 2 := by
  simp
  calc
    (∑ i, ∑ j, r * y i * y j * y i) =
        ∑ i, ∑ j, (r * y i ^ 2) * y j := by
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          ring
    _ = (∑ i, r * y i ^ 2) * ∑ j, y j := sum_product_two _ _
    _ = r * (∑ i, y i) * ∑ i, y i ^ 2 := by rw [sum_const_mul]; ring

private theorem sum_second_third_equal [Fintype ι] (r : R) (y : ι → R) :
    (∑ i, ∑ j, ∑ k, if j = k then r * y i * y j * y k else 0) =
      r * (∑ i, y i) * ∑ i, y i ^ 2 := by
  simp
  calc
    (∑ i, ∑ j, r * y i * y j * y j) =
        ∑ i, ∑ j, y i * (r * y j ^ 2) := by
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          ring
    _ = (∑ i, y i) * ∑ j, r * y j ^ 2 := sum_product_two _ _
    _ = r * (∑ i, y i) * ∑ i, y i ^ 2 := by rw [sum_const_mul]; ring

private theorem sum_all_equal [Fintype ι] (r : R) (y : ι → R) :
    (∑ i, ∑ j, ∑ k,
      if i = j then if j = k then r * y i * y j * y k else 0 else 0) =
      r * ∑ i, y i ^ 3 := by
  simp
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  ring

/-- The contraction of an equality-pattern coefficient with a vector is a
linear combination of its first three power sums. -/
theorem sum_coefficient_mul [Fintype ι] (a b c : R) (y : ι → R) :
    (∑ i, ∑ j, ∑ k, coefficient a b c i j k * y i * y j * y k) =
      c * (∑ i, y i) ^ 3 +
        3 * (b - c) * (∑ i, y i) * (∑ i, y i ^ 2) +
        (a - 3 * b + 2 * c) * ∑ i, y i ^ 3 := by
  calc
    (∑ i, ∑ j, ∑ k, coefficient a b c i j k * y i * y j * y k) =
        ∑ i, ∑ j, ∑ k,
          (c * y i * y j * y k +
          (if i = j then (b - c) * y i * y j * y k else 0) +
          (if i = k then (b - c) * y i * y j * y k else 0) +
          (if j = k then (b - c) * y i * y j * y k else 0) +
          (if i = j then
            if j = k then (a - 3 * b + 2 * c) * y i * y j * y k else 0
            else 0)) := by
              apply Finset.sum_congr rfl
              intro i _
              apply Finset.sum_congr rfl
              intro j _
              apply Finset.sum_congr rfl
              intro k _
              exact coefficient_mul_eq_indicator a b c (y i) (y j) (y k) i j k
    _ = (∑ i, ∑ j, ∑ k, c * y i * y j * y k) +
          (∑ i, ∑ j, ∑ k, if i = j then (b - c) * y i * y j * y k else 0) +
          (∑ i, ∑ j, ∑ k, if i = k then (b - c) * y i * y j * y k else 0) +
          (∑ i, ∑ j, ∑ k, if j = k then (b - c) * y i * y j * y k else 0) +
          (∑ i, ∑ j, ∑ k, if i = j then
            if j = k then (a - 3 * b + 2 * c) * y i * y j * y k else 0
            else 0) := by simp only [Finset.sum_add_distrib]
    _ = _ := by
      rw [sum_product_three, sum_const_mul, sum_first_second_equal,
        sum_first_third_equal, sum_second_third_equal, sum_all_equal]
      ring

/-- On the sum-zero hyperplane, only the alternating combination of the three
coefficient values survives. -/
theorem sum_coefficient_mul_of_sum_eq_zero [Fintype ι] (a b c : R) (y : ι → R)
    (hy : ∑ i, y i = 0) :
    (∑ i, ∑ j, ∑ k, coefficient a b c i j k * y i * y j * y k) =
      (a - 3 * b + 2 * c) * ∑ i, y i ^ 3 := by
  rw [sum_coefficient_mul, hy]
  ring

/-- The sum-zero contraction has the same formula when the surrounding
expansion lists the three summation indices in reverse order. -/
theorem reversed_sum_coefficient_mul_of_sum_eq_zero [Fintype ι]
    (a b c : R) (y : ι → R) (hy : ∑ i, y i = 0) :
    (∑ k, ∑ j, ∑ i, y i * y j * y k * coefficient a b c i j k) =
      (a - 3 * b + 2 * c) * ∑ i, y i ^ 3 := by
  calc
    (∑ k, ∑ j, ∑ i, y i * y j * y k * coefficient a b c i j k) =
        ∑ k, ∑ j, ∑ i, coefficient a b c k j i * y k * y j * y i := by
          apply Finset.sum_congr rfl
          intro k _
          apply Finset.sum_congr rfl
          intro j _
          apply Finset.sum_congr rfl
          intro i _
          rw [coefficient_reverse]
          ring
    _ = _ := sum_coefficient_mul_of_sum_eq_zero a b c y hy

end RelativeConicArcs.CubicEqualityPattern
