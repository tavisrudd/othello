import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisLocalChart
import Mathlib.Tactic

/-!
# Where the six-axis coefficient discriminant is supported

For a symmetric coefficient matrix `gram` on a free module written in a fixed
basis, multiplication by `gram` is the map to the dual lattice in the same
coordinates, and the quotient of the module by its image is the discriminant
group.  This module locates that quotient for the five-axis matrix `6I₅-J₅`,
using the integral reduction `L (6I₅-J₅) R = diag(1,6,6,6,6)` by matrices `L` and
`R` invertible over the integers.

Two general facts do the work.  If a coordinate direction is hit by the reduced
matrix — that is, if the reduced matrix carries some vector to the coordinate
vector `Pi.single index 1` — then the corresponding vector `L⁻¹ Pi.single index 1`
of the reduced basis already lies in the image of `gram`, so it contributes
nothing to the discriminant group; and every vector is then congruent, modulo
that image, to a combination of the remaining reduced basis vectors.  Separately,
if the reduced matrix carries some vector to a fixed multiple of an arbitrary
vector, that multiple annihilates the discriminant group.

For `6I₅-J₅` the first reduced entry is one and the other four are six.  The
first reduced basis vector is the constant vector, whose value under the form is
five, a unit at both two and three; it lies in the image of the form, and the
discriminant group is carried by the remaining four coordinates and annihilated
by six.  At either prime dividing six, the primary part of the discriminant group
is therefore supported on the four coordinates of exact depth one.

The module works with matrices and coordinate vectors over a commutative ring.
It constructs no abelian scheme, polarization, or isogeny kernel, and it does not
identify the discriminant group of the form with a geometric kernel.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

open Matrix

section Reduction

variable {R Index : Type*} [CommRing R] [Fintype Index] [DecidableEq Index]

/-- A coordinate direction hit by the reduced matrix contributes nothing to the
discriminant group: its reduced basis vector `leftInverse *ᵥ Pi.single index 1`
lies in the image of the coefficient matrix. -/
theorem gram_mulVec_eq_of_reduced_preimage
    {gram left leftInverse right reduced : Matrix Index Index R}
    {preimage : Index → R} {index : Index}
    (reduction : left * gram * right = reduced)
    (inverse : leftInverse * left = 1)
    (hit : reduced *ᵥ preimage = Pi.single index 1) :
    gram *ᵥ (right *ᵥ preimage) = leftInverse *ᵥ Pi.single index (1 : R) := by
  have factor : gram * right = leftInverse * reduced := by
    rw [← reduction, ← Matrix.mul_assoc, ← Matrix.mul_assoc, inverse, Matrix.one_mul]
  calc gram *ᵥ (right *ᵥ preimage) = (gram * right) *ᵥ preimage := by
        rw [Matrix.mulVec_mulVec]
    _ = (leftInverse * reduced) *ᵥ preimage := by rw [factor]
    _ = leftInverse *ᵥ (reduced *ᵥ preimage) := by rw [Matrix.mulVec_mulVec]
    _ = leftInverse *ᵥ Pi.single index (1 : R) := by rw [hit]

/-- Every vector is congruent, modulo the image of the coefficient matrix, to a
combination of the reduced basis vectors other than one hit by the reduced
matrix. -/
theorem exists_gramImage_decomposition_off_hit_coordinate
    {gram left leftInverse right reduced : Matrix Index Index R}
    {preimage : Index → R} {index : Index}
    (reduction : left * gram * right = reduced)
    (inverse : leftInverse * left = 1)
    (hit : reduced *ᵥ preimage = Pi.single index 1)
    (value : Index → R) :
    ∃ source coordinates : Index → R,
      coordinates index = 0 ∧
        value = gram *ᵥ source + leftInverse *ᵥ coordinates := by
  classical
  set reducedValue := left *ᵥ value with reducedValueDefinition
  refine ⟨reducedValue index • (right *ᵥ preimage),
    reducedValue - Pi.single index (reducedValue index), ?_, ?_⟩
  · simp
  · have image : gram *ᵥ (reducedValue index • (right *ᵥ preimage)) =
        leftInverse *ᵥ Pi.single index (reducedValue index) := by
      rw [Matrix.mulVec_smul, gram_mulVec_eq_of_reduced_preimage reduction inverse hit,
        ← Matrix.mulVec_smul]
      congr 1
      ext coordinate
      by_cases equality : coordinate = index
      · subst equality; simp
      · simp [equality]
    have recover : leftInverse *ᵥ reducedValue = value := by
      rw [reducedValueDefinition, Matrix.mulVec_mulVec, inverse, Matrix.one_mulVec]
    rw [image, Matrix.mulVec_sub, recover]
    abel

/-- A multiple carried by the reduced matrix onto every vector annihilates the
discriminant group: it maps every vector into the image of the coefficient
matrix. -/
theorem smul_mem_gramImage_of_reduced_smul
    {gram left leftInverse right reduced : Matrix Index Index R} {multiple : R}
    (reduction : left * gram * right = reduced)
    (inverse : leftInverse * left = 1)
    (divisible : ∀ vector : Index → R, ∃ source : Index → R,
      reduced *ᵥ source = multiple • vector)
    (value : Index → R) :
    ∃ source : Index → R, multiple • value = gram *ᵥ source := by
  obtain ⟨source, sourceEquation⟩ := divisible (left *ᵥ value)
  have factor : gram * right = leftInverse * reduced := by
    rw [← reduction, ← Matrix.mul_assoc, ← Matrix.mul_assoc, inverse, Matrix.one_mul]
  refine ⟨right *ᵥ source, ?_⟩
  calc multiple • value
      = multiple • (leftInverse *ᵥ (left *ᵥ value)) := by
        rw [Matrix.mulVec_mulVec, inverse, Matrix.one_mulVec]
    _ = leftInverse *ᵥ (multiple • (left *ᵥ value)) := by rw [Matrix.mulVec_smul]
    _ = leftInverse *ᵥ (reduced *ᵥ source) := by rw [sourceEquation]
    _ = (leftInverse * reduced) *ᵥ source := by rw [Matrix.mulVec_mulVec]
    _ = (gram * right) *ᵥ source := by rw [factor]
    _ = gram *ᵥ (right *ᵥ source) := by rw [Matrix.mulVec_mulVec]

/-- A diagonal reduced matrix whose every entry divides a multiple carries some
vector onto that multiple of any prescribed vector. -/
theorem diagonal_mulVec_smul_of_entries_dvd
    {entries : Index → R} {multiple : R}
    (divides : ∀ index, entries index ∣ multiple) (vector : Index → R) :
    ∃ source : Index → R, Matrix.diagonal entries *ᵥ source = multiple • vector := by
  choose cofactor cofactorEquation using divides
  refine ⟨fun index ↦ cofactor index * vector index, ?_⟩
  ext index
  rw [Matrix.mulVec_diagonal]
  simp [← mul_assoc, ← cofactorEquation index]

end Reduction

/-- The Smith diagonal of the five-axis coefficient matrix as a diagonal
matrix: its first entry is one and its remaining entries are six. -/
theorem sixAxisSmithDiagonal_eq_diagonal :
    sixAxisSmithDiagonal =
      Matrix.diagonal (fun index : Fin 5 ↦ if index = 0 then (1 : ℤ) else 6) := by
  ext row column
  by_cases equality : row = column
  · subst equality; simp [sixAxisSmithDiagonal, Matrix.diagonal]
  · simp [sixAxisSmithDiagonal, Matrix.diagonal, equality]

/-- The reduced basis vector of the unit Smith coordinate is the constant
vector. -/
theorem sixAxisSmithLeftInverse_mulVec_single_zero :
    sixAxisSmithLeftInverse *ᵥ Pi.single 0 (1 : ℤ) = fun _ ↦ (1 : ℤ) := by
  ext row
  rw [Matrix.mulVec_single]
  fin_cases row <;> simp [sixAxisSmithLeftInverse]

/-- The constant vector has value five under the five-axis coefficient form,
the same value as the first coordinate line of the local chart.  Five is a unit
at both two and three, so the constant vector spans a unimodular summand
there. -/
theorem sixAxisGram_constantVector_pairing :
    sixAxisGramPairing (R := ℤ) (fun _ ↦ 1) (fun _ ↦ 1) = 5 := by
  rw [sixAxisGramPairing_eq]
  norm_num [dotProduct, Fin.sum_univ_succ]

/-- The unimodular Smith line of the five-axis coefficient matrix lies in the
image of that matrix, so it contributes nothing to the discriminant group. -/
theorem sixAxisGram_unitLine_mem_image :
    sixAxisGram ℤ *ᵥ (sixAxisSmithRight *ᵥ Pi.single 0 1) = fun _ ↦ (1 : ℤ) := by
  have hit : sixAxisSmithDiagonal *ᵥ Pi.single 0 (1 : ℤ) = Pi.single 0 (1 : ℤ) := by
    rw [sixAxisSmithDiagonal_eq_diagonal, Matrix.diagonal_mulVec_single]
    simp
  have image := gram_mulVec_eq_of_reduced_preimage sixAxisGram_smith_reduction
    sixAxisSmithLeft_inverse_mul hit
  rw [image, sixAxisSmithLeftInverse_mulVec_single_zero]

/-- Every integral vector is congruent, modulo the image of the five-axis
coefficient matrix, to a combination of the four Smith basis vectors of exact
depth one at two and three.  The unimodular Smith coordinate carries no class. -/
theorem sixAxisGram_discriminant_supported_off_unitLine (value : Fin 5 → ℤ) :
    ∃ source coordinates : Fin 5 → ℤ,
      coordinates 0 = 0 ∧
        value = sixAxisGram ℤ *ᵥ source + sixAxisSmithLeftInverse *ᵥ coordinates := by
  have hit : sixAxisSmithDiagonal *ᵥ Pi.single 0 (1 : ℤ) = Pi.single 0 (1 : ℤ) := by
    rw [sixAxisSmithDiagonal_eq_diagonal, Matrix.diagonal_mulVec_single]
    simp
  exact exists_gramImage_decomposition_off_hit_coordinate sixAxisGram_smith_reduction
    sixAxisSmithLeft_inverse_mul hit value

/-- Six annihilates the discriminant group of the five-axis coefficient matrix:
six times every integral vector lies in the image of the matrix.  With the
previous statement, the primary part at either prime dividing six is supported on
the four Smith coordinates of exact depth one. -/
theorem sixAxisGram_six_smul_mem_image (value : Fin 5 → ℤ) :
    ∃ source : Fin 5 → ℤ, (6 : ℤ) • value = sixAxisGram ℤ *ᵥ source := by
  have divides : ∀ index : Fin 5,
      (if index = 0 then (1 : ℤ) else 6) ∣ 6 := by
    intro index
    by_cases zero : index = 0 <;> simp [zero]
  have divisible : ∀ vector : Fin 5 → ℤ, ∃ source : Fin 5 → ℤ,
      sixAxisSmithDiagonal *ᵥ source = (6 : ℤ) • vector := by
    intro vector
    rw [sixAxisSmithDiagonal_eq_diagonal]
    exact diagonal_mulVec_smul_of_entries_dvd divides vector
  exact smul_mem_gramImage_of_reduced_smul sixAxisGram_smith_reduction
    sixAxisSmithLeft_inverse_mul divisible value

section Chart

variable {R : Type*} [CommRing R]

/-- In the chart basis the coefficient form sends the multiple `1/5` of the
first coordinate to the first dual coordinate. -/
theorem sixAxisChartGram_mulVec_single_zero
    (inverseFive : R) (inverse : 5 * inverseFive = 1) :
    sixAxisChartGram inverseFive *ᵥ Pi.single 0 inverseFive =
      Pi.single 0 (1 : R) := by
  ext row
  rw [Matrix.mulVec_single]
  by_cases zero : row = 0
  · subst zero
    simpa [sixAxisChartGram] using inverse
  · simp [sixAxisChartGram, zero]

/-- The transposed inverse chart basis is a left inverse of the transposed chart
basis. -/
theorem sixAxisChartBasisInverse_transpose_mul (inverseFive : R) :
    (sixAxisChartBasisInverse inverseFive)ᵀ * (sixAxisChartBasis inverseFive)ᵀ = 1 := by
  rw [← Matrix.transpose_mul, (sixAxisChartBasis_mul_inverse inverseFive).1,
    Matrix.transpose_one]

/-- The unit line of the local chart carries no discriminant: over any
coefficient ring in which five is invertible, the first chart dual vector lies in
the image of the five-axis coefficient matrix.  At the primes two and three, five
is a unit, so this is the manuscript's unimodular summand `U₀`. -/
theorem sixAxisChart_unitLine_mem_image
    (inverseFive : R) (inverse : 5 * inverseFive = 1) :
    sixAxisGram R *ᵥ (sixAxisChartBasis inverseFive *ᵥ Pi.single 0 inverseFive) =
      (sixAxisChartBasisInverse inverseFive)ᵀ *ᵥ Pi.single 0 (1 : R) :=
  gram_mulVec_eq_of_reduced_preimage (sixAxisChartBasis_congruence inverseFive inverse)
    (sixAxisChartBasisInverse_transpose_mul inverseFive)
    (sixAxisChartGram_mulVec_single_zero inverseFive inverse)

/-- Every vector is congruent, modulo the image of the five-axis coefficient
matrix, to a combination of the four chart dual vectors orthogonal to the unit
line.  Over the two-adic or three-adic integers this is the manuscript's
statement that the principal quotient is trivial on the unimodular summand and
the primary kernel is supported on the depth-one block. -/
theorem sixAxisChart_discriminant_supported_off_unitLine
    (inverseFive : R) (inverse : 5 * inverseFive = 1) (value : Fin 5 → R) :
    ∃ source coordinates : Fin 5 → R,
      coordinates 0 = 0 ∧
        value = sixAxisGram R *ᵥ source +
          (sixAxisChartBasisInverse inverseFive)ᵀ *ᵥ coordinates :=
  exists_gramImage_decomposition_off_hit_coordinate
    (sixAxisChartBasis_congruence inverseFive inverse)
    (sixAxisChartBasisInverse_transpose_mul inverseFive)
    (sixAxisChartGram_mulVec_single_zero inverseFive inverse) value

end Chart

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
