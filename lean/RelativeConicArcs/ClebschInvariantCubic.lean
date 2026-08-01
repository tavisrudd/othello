import Mathlib

/-!
# The marked fixed line and Clebsch cubic normalization

On the standard five-coordinate module, the vector
`(4,-1,-1,-1,-1)` spans the line fixed by the stabilizer of the first
label.  The proof uses only equality of the other four coordinates and the
sum-zero relation.  This makes it the smallest marked test vector for a cubic
known to lie on the Clebsch invariant line.

The normalized cubic is `σ₃(y)=(1/3)∑ᵢ yᵢ³`.  Its value on the primitive
fixed vector is `20`.  Consequently one exact value of any cubic on the
`σ₃` line fixes its scalar.  The final declarations separate the universal
degree-six Wigner factor from the marked Petersen restriction factor and
verify their product; they do not replace the hypothesis that the cubic lies
on the invariant line.
-/

namespace RelativeConicArcs.ClebschInvariantCubic

/-- The primitive vector on the line fixed by the stabilizer of label zero. -/
def markedFixedVector : Fin 5 → ℚ := ![4, -1, -1, -1, -1]

/-- The normalized Clebsch cubic on five coordinates. -/
def sigmaThree (y : Fin 5 → ℚ) : ℚ :=
  (1 / 3 : ℚ) * ∑ i, y i ^ 3

/-- The Clebsch cubic is homogeneous of degree three. -/
theorem sigmaThree_smul (c : ℚ) (y : Fin 5 → ℚ) :
    sigmaThree (c • y) = c ^ 3 * sigmaThree y := by
  simp only [sigmaThree, Pi.smul_apply, smul_eq_mul, mul_pow]
  rw [← Finset.mul_sum]
  ring

/-- The primitive marked vector lies in the standard sum-zero module. -/
theorem markedFixedVector_sum : ∑ i, markedFixedVector i = 0 := by
  native_decide

/-- The normalized Clebsch cubic takes value twenty on the primitive marked
fixed vector. -/
theorem sigmaThree_markedFixedVector : sigmaThree markedFixedVector = 20 := by
  native_decide

/-- The sum-zero parameter of the normalized chart point `xyz`. -/
def normalizedMarkedVector : Fin 5 → ℚ :=
  (1 / 5 : ℚ) • markedFixedVector

/-- The chart point has Clebsch cubic value `4/25`; the denominator is forced
by passing from the primitive marked vector to its sum-zero affine
representative. -/
theorem sigmaThree_normalizedMarkedVector :
    sigmaThree normalizedMarkedVector = 4 / 25 := by
  rw [normalizedMarkedVector, sigmaThree_smul,
    sigmaThree_markedFixedVector]
  norm_num

/-- Hitchin's chart factor `16` converts the value `4/25` into the displayed
branch value `(16/25)²`. -/
theorem chartFactor_at_normalizedMarkedVector :
    (16 : ℚ) * sigmaThree normalizedMarkedVector ^ 2 = (16 / 25) ^ 2 := by
  rw [sigmaThree_normalizedMarkedVector]
  norm_num

/-- A coordinate vector is fixed by the stabilizer of label zero when its
four remaining coordinates agree. -/
def IsMarkedStabilizerFixed (y : Fin 5 → ℚ) : Prop :=
  ∀ i j, i ≠ 0 → j ≠ 0 → y i = y j

/-- The sum-zero vectors fixed by the marked point stabilizer form the line
spanned by `(4,-1,-1,-1,-1)`. -/
theorem exists_smul_markedFixedVector {y : Fin 5 → ℚ}
    (hy : ∑ i, y i = 0) (hfixed : IsMarkedStabilizerFixed y) :
    ∃ c : ℚ, y = c • markedFixedVector := by
  have h21 : y 2 = y 1 := hfixed 2 1 (by decide) (by decide)
  have h31 : y 3 = y 1 := hfixed 3 1 (by decide) (by decide)
  have h41 : y 4 = y 1 := hfixed 4 1 (by decide) (by decide)
  have hy0 : y 0 = -4 * y 1 := by
    norm_num [Fin.sum_univ_succ] at hy
    change y 0 + (y 1 + (y 2 + (y 3 + y 4))) = 0 at hy
    rw [h21, h31, h41] at hy
    linear_combination hy
  refine ⟨-y 1, ?_⟩
  funext i
  fin_cases i
  · simp [markedFixedVector, hy0]
    ring
  · simp [markedFixedVector]
  · simp [markedFixedVector, h21]
  · simp [markedFixedVector, h31]
  · simp [markedFixedVector, h41]

/-- The scalar multiplying the primitive marked fixed vector is unique. -/
theorem smul_markedFixedVector_injective :
    Function.Injective (fun c : ℚ => c • markedFixedVector) := by
  intro c d h
  have h1 := congrFun h 1
  simpa [markedFixedVector] using h1

/-- A cubic functional lies on the Clebsch invariant line when it is a scalar
multiple of `σ₃` on the sum-zero module. -/
def LiesOnSigmaThreeLine (F : (Fin 5 → ℚ) → ℚ) : Prop :=
  ∃ c : ℚ, ∀ y, (∑ i, y i = 0) → F y = c * sigmaThree y

/-- The scalar of a functional on the Clebsch cubic line is unique. -/
theorem sigmaThreeLine_coefficient_unique {F : (Fin 5 → ℚ) → ℚ}
    {c d : ℚ}
    (hc : ∀ y, (∑ i, y i = 0) → F y = c * sigmaThree y)
    (hd : ∀ y, (∑ i, y i = 0) → F y = d * sigmaThree y) : c = d := by
  have h := (hc markedFixedVector markedFixedVector_sum).symm.trans
    (hd markedFixedVector markedFixedVector_sum)
  rw [sigmaThree_markedFixedVector] at h
  linarith

/-- One exact value on the primitive marked fixed vector determines every
value of a cubic already known to lie on the Clebsch invariant line. -/
theorem eq_gauntCoefficient_mul_sigmaThree
    {F : (Fin 5 → ℚ) → ℚ}
    (hline : LiesOnSigmaThreeLine F)
    (hmarked : F markedFixedVector = -15680000 / 1247103) :
    ∀ y, (∑ i, y i = 0) →
      F y = (-784000 / 1247103 : ℚ) * sigmaThree y := by
  obtain ⟨c, hc⟩ := hline
  have hcvalue := hc markedFixedVector markedFixedVector_sum
  rw [hmarked, sigmaThree_markedFixedVector] at hcvalue
  have hceq : c = (-784000 / 1247103 : ℚ) := by
    linarith
  simpa [hceq] using hc

/-- The universal `(6,6,6)` Wigner square in the paper's normalization. -/
def wignerSixFactor : ℚ := 400 / 46189

/-- The marked Petersen fixed-line restriction scalar. -/
def petersenRestrictionFactor : ℚ := 1960 / 27

/-- The exact Gaunt coefficient is the negative product of the universal
Wigner factor and the marked Petersen restriction factor. -/
theorem gauntCoefficient_factorization :
    (-784000 / 1247103 : ℚ) =
      -wignerSixFactor * petersenRestrictionFactor := by
  norm_num [wignerSixFactor, petersenRestrictionFactor]

/-- The apparently new denominators in the Condon--Shortley conversion are
the reductions `46189/13` and `27*13²`. -/
theorem condonShortley_denominators :
    (3553 : ℕ) = 46189 / 13 ∧ (4563 : ℕ) = 27 * 13 ^ 2 := by
  norm_num

end RelativeConicArcs.ClebschInvariantCubic
