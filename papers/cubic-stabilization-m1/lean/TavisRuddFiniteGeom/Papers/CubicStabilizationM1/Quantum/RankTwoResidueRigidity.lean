import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.AtomicResidueDiscriminant

/-!
# Rank-two rigidity of the modified residue

This module proves the matrix algebra behind the rank-two step of the atomic
argument.  Throughout, `N` is the nilpotent part of the centered leading Euler
operator of an even rank-two atomic factor, `P₀` and `P₁` are the first two
coefficients of the horizontal Poincare pairing in the chosen frame, `A₀` is the
regular coefficient of the connection in the loop direction, and `R` is the
residue of the canonical elementary modification.

Three statements are proved here, over an arbitrary field for the first two and
over an arbitrary commutative ring for the third.

The regular coefficient preserves the nilpotent line.  Writing that line as the
image of `N`, the statement is the matrix identity `N * A₀ * N = 0`.  It follows
from self-adjointness of `N` for the leading pairing coefficient and the
constant coefficient of horizontality, because sandwiching a rank-two matrix
between two copies of a square-zero matrix multiplies the latter by a trace, and
the resulting scalar is both self-adjoint and anti-self-adjoint for a
nondegenerate pairing.

The base connection has no pole after the modification.  In the adapted frame
the only possible pole is a multiple of the lower-left matrix unit, and the
order `u ^ (-1)` coefficient of flatness in the modified lattice forces that
multiple to vanish whenever the upper-right entry of the residue is invertible,
which it is, being the unit coming from `N`.

The residue discriminant is constant along the base.  If a derivation of the
coefficient ring carries the residue to a commutator with a regular matrix, then
it annihilates both the trace of the residue and the trace of its square, hence
the discriminant `(trace R) ^ 2 - 4 * det R`.

Lean does not construct the `A`-model `F`-bundle, the spectral cover, the
atomic factor, the Poincare pairing, or the elementary modification, and does
not prove that any displayed matrix arises from one of them.  The connection
between the residue eigenvalues and the formal exponent classes of the centered
module, which the manuscript takes from the formal classification of
regular-singular differential modules, is not formalized; only the discriminant
identity for the eigenvalues is.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

open Matrix

variable {K : Type*} [Field K]

/-- The Cayley-Hamilton identity in rank two. -/
theorem rankTwo_cayleyHamilton (M : Matrix (Fin 2) (Fin 2) K) :
    M * M - (trace M) • M + (M.det) • (1 : Matrix (Fin 2) (Fin 2) K) = 0 := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.trace_fin_two,
      Matrix.det_fin_two] <;> ring

/-- A square-zero rank-two matrix over a field has vanishing trace and
determinant. -/
theorem rankTwo_trace_det_eq_zero_of_sq_eq_zero {N : Matrix (Fin 2) (Fin 2) K}
    (squareZero : N * N = 0) : trace N = 0 ∧ N.det = 0 := by
  have identity := rankTwo_cayleyHamilton N
  rw [squareZero] at identity
  have key : (trace N) • N = (N.det) • (1 : Matrix (Fin 2) (Fin 2) K) := by
    ext row column
    have entry := congrFun (congrFun identity row) column
    simp only [Matrix.sub_apply, Matrix.add_apply, Matrix.smul_apply, Matrix.zero_apply,
      smul_eq_mul] at entry ⊢
    linear_combination -entry
  have traceEquation : trace N * trace N = 2 * N.det := by
    have := congrArg trace key
    simpa [Matrix.trace_smul, Matrix.trace_one, smul_eq_mul, two_mul, mul_comm] using this
  have detEquation : trace N * trace N * N.det = N.det * N.det := by
    have := congrArg Matrix.det key
    simpa [Matrix.det_smul, Matrix.det_one, pow_two] using this
  have detZero : N.det = 0 :=
    mul_self_eq_zero.mp (by linear_combination (-N.det) * traceEquation + detEquation)
  refine ⟨?_, detZero⟩
  exact mul_self_eq_zero.mp (by rw [traceEquation, detZero]; ring)

/-- Sandwiching a rank-two matrix between two copies of a square-zero matrix
multiplies the latter by the trace of the product. -/
theorem rankTwo_squareZero_sandwich (N A : Matrix (Fin 2) (Fin 2) K)
    (squareZero : N * N = 0) :
    N * A * N = (trace (A * N)) • N := by
  obtain ⟨_, detZero⟩ := rankTwo_trace_det_eq_zero_of_sq_eq_zero squareZero
  rw [Matrix.det_fin_two] at detZero
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.trace_fin_two]
  · linear_combination (-(A 1 1)) * detZero
  · linear_combination (A 0 1) * detZero
  · linear_combination (A 1 0) * detZero
  · linear_combination (-(A 0 0)) * detZero

/-- The regular coefficient of the loop direction carries the nilpotent line
into itself.  Writing that line as the image of the square-zero matrix `N`, the
conclusion is the identity `N * A₀ * N = 0`.  The hypotheses are the ones the
manuscript derives from horizontality of the Poincare pairing: `N` is
self-adjoint for the leading pairing coefficient `P₀`, which is invertible, and
the constant coefficient of horizontality relates `A₀`, `P₀`, `P₁`, and `N`. -/
theorem regularCoefficient_preserves_nilpotentLine
    {N P₀ P₁ A₀ : Matrix (Fin 2) (Fin 2) K}
    (twoNeZero : (2 : K) ≠ 0)
    (squareZero : N * N = 0) (nonzero : N ≠ 0)
    (nondegenerate : P₀.det ≠ 0)
    (selfAdjoint : Nᵀ * P₀ = P₀ * N)
    (constantCoefficient : A₀ᵀ * P₀ + P₀ * A₀ + Nᵀ * P₁ - P₁ * N = 0) :
    N * A₀ * N = 0 := by
  have sandwich : N * A₀ * N = (trace (A₀ * N)) • N :=
    rankTwo_squareZero_sandwich N A₀ squareZero
  have transposeSquareZero : Nᵀ * Nᵀ = 0 := by
    rw [← Matrix.transpose_mul, squareZero, Matrix.transpose_zero]
  have termOne : Nᵀ * (A₀ᵀ * P₀) * N = (N * A₀ * N)ᵀ * P₀ := by
    calc Nᵀ * (A₀ᵀ * P₀) * N = Nᵀ * A₀ᵀ * (P₀ * N) := by
          simp [Matrix.mul_assoc]
      _ = Nᵀ * A₀ᵀ * (Nᵀ * P₀) := by rw [selfAdjoint]
      _ = (N * A₀ * N)ᵀ * P₀ := by
          simp [Matrix.transpose_mul, Matrix.mul_assoc]
  have termTwo : Nᵀ * (P₀ * A₀) * N = P₀ * (N * A₀ * N) := by
    calc Nᵀ * (P₀ * A₀) * N = (Nᵀ * P₀) * (A₀ * N) := by
          simp [Matrix.mul_assoc]
      _ = (P₀ * N) * (A₀ * N) := by rw [selfAdjoint]
      _ = P₀ * (N * A₀ * N) := by simp [Matrix.mul_assoc]
  have termThree : Nᵀ * (Nᵀ * P₁) * N = 0 := by
    rw [← Matrix.mul_assoc, transposeSquareZero, Matrix.zero_mul, Matrix.zero_mul]
  have termFour : Nᵀ * (P₁ * N) * N = 0 := by
    rw [Matrix.mul_assoc, Matrix.mul_assoc, squareZero, Matrix.mul_zero,
      Matrix.mul_zero]
  have vanishing : Nᵀ * (A₀ᵀ * P₀ + P₀ * A₀ + Nᵀ * P₁ - P₁ * N) * N = 0 := by
    rw [constantCoefficient, Matrix.mul_zero, Matrix.zero_mul]
  have expand : Nᵀ * (A₀ᵀ * P₀ + P₀ * A₀ + Nᵀ * P₁ - P₁ * N) * N =
      Nᵀ * (A₀ᵀ * P₀) * N + Nᵀ * (P₀ * A₀) * N + Nᵀ * (Nᵀ * P₁) * N -
        Nᵀ * (P₁ * N) * N := by
    noncomm_ring
  rw [expand, termOne, termTwo, termThree, termFour, sandwich] at vanishing
  rw [Matrix.transpose_smul, Matrix.smul_mul, Matrix.mul_smul, selfAdjoint] at vanishing
  have doubled : (2 * trace (A₀ * N)) • (P₀ * N) = 0 := by
    rw [two_mul, add_smul]
    simpa using vanishing
  have productNonzero : P₀ * N ≠ 0 := by
    intro productZero
    apply nonzero
    have unitDet : IsUnit P₀.det := isUnit_iff_ne_zero.mpr nondegenerate
    calc N = 1 * N := (Matrix.one_mul N).symm
      _ = (P₀⁻¹ * P₀) * N := by rw [Matrix.nonsing_inv_mul P₀ unitDet]
      _ = P₀⁻¹ * (P₀ * N) := by rw [Matrix.mul_assoc]
      _ = 0 := by rw [productZero, Matrix.mul_zero]
  have traceZero : trace (A₀ * N) = 0 := by
    rcases smul_eq_zero.mp doubled with scalarZero | matrixZero
    · exact by
        rcases mul_eq_zero.mp scalarZero with two | value
        · exact absurd two twoNeZero
        · exact value
    · exact absurd matrixZero productNonzero
  rw [sandwich, traceZero, zero_smul]

/-- The vector form of the preceding identity: the regular coefficient carries
every vector in the image of the square-zero leading operator back into its
kernel.  For a nonzero square-zero rank-two matrix that image and that kernel
are the same line, which is the nilpotent line of the manuscript. -/
theorem regularCoefficient_image_subset_kernel
    {N A₀ : Matrix (Fin 2) (Fin 2) K} (identity : N * A₀ * N = 0)
    (vector : Fin 2 → K) :
    N.mulVec (A₀.mulVec (N.mulVec vector)) = 0 := by
  rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, identity, Matrix.zero_mulVec]

/-- The residual pole of the base connection after the elementary modification.
In the adapted frame the only possible pole is a multiple of the lower-left
matrix unit. -/
def modifiedBasePole (value : K) : Matrix (Fin 2) (Fin 2) K :=
  !![0, 0; value, 0]

/-- The base connection is regular after the modification.  The order
`u ^ (-1)` coefficient of flatness in the modified lattice forces the residual
pole to vanish, because the upper-right entry of the residue is the unit coming
from the square-zero leading operator. -/
theorem modifiedBasePole_eq_zero {R : Matrix (Fin 2) (Fin 2) K} {value : K}
    (upperRightUnit : R 0 1 ≠ 0)
    (flatness : modifiedBasePole value +
      (R * modifiedBasePole value - modifiedBasePole value * R) = 0) :
    value = 0 := by
  have entry : R 0 1 * value = 0 := by
    have coefficient := congrFun (congrFun flatness 0) 0
    simpa [modifiedBasePole, Matrix.mul_apply, Fin.sum_univ_two, Matrix.add_apply,
      Matrix.sub_apply, Matrix.vecMul, dotProduct] using coefficient
  rcases mul_eq_zero.mp entry with first | second
  · exact absurd first upperRightUnit
  · exact second

section BaseVariation

variable {A : Type*} [CommRing A]

/-- The residue discriminant of a rank-two matrix in terms of traces alone:
`(trace R) ^ 2 - 4 * det R = 2 * trace (R * R) - (trace R) ^ 2`. -/
theorem residueDiscriminant_eq_trace_form (R : Matrix (Fin 2) (Fin 2) A) :
    residueDiscriminant R = 2 * trace (R * R) - (trace R) ^ 2 := by
  simp [residueDiscriminant, Matrix.trace_fin_two, Matrix.det_fin_two,
    Matrix.mul_apply, Fin.sum_univ_two]
  ring

/-- An additive map annihilates zero. -/
theorem map_zero_of_additive {derivation : A → A}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y) :
    derivation 0 = 0 := by
  have := additive 0 0
  simpa using this.symm

/-- An additive map commutes with subtraction. -/
theorem map_sub_of_additive {derivation : A → A}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y) (x y : A) :
    derivation (x - y) = derivation x - derivation y := by
  have expansion := additive (x - y) y
  rw [sub_add_cancel] at expansion
  linear_combination -expansion

/-- An additive map applied entrywise commutes with the trace in rank two. -/
theorem trace_map_of_additive {derivation : A → A}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (M : Matrix (Fin 2) (Fin 2) A) :
    derivation (trace M) = trace (M.map derivation) := by
  simp [Matrix.trace_fin_two, additive]

/-- The Leibniz rule for an entrywise derivation of a rank-two matrix
product. -/
theorem map_mul_of_derivation {derivation : A → A}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (leibniz : ∀ x y, derivation (x * y) = derivation x * y + x * derivation y)
    (M N : Matrix (Fin 2) (Fin 2) A) :
    (M * N).map derivation = M.map derivation * N + M * N.map derivation := by
  ext row column
  simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.add_apply, additive, leibniz]
  ring

/-- The residue discriminant is constant along the base.  If an entrywise
derivation of the coefficient ring carries the residue to its commutator with a
regular matrix, as the modified flatness equation asserts, then it annihilates
the residue discriminant. -/
theorem lax_residueDiscriminant_map_eq_zero {derivation : A → A}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (leibniz : ∀ x y, derivation (x * y) = derivation x * y + x * derivation y)
    (R G : Matrix (Fin 2) (Fin 2) A)
    (lax : R.map derivation = G * R - R * G) :
    derivation (residueDiscriminant R) = 0 := by
  have traceZero : derivation (trace R) = 0 := by
    rw [trace_map_of_additive additive R, lax, Matrix.trace_sub,
      Matrix.trace_mul_comm G R, sub_self]
  have squareTraceZero : derivation (trace (R * R)) = 0 := by
    rw [trace_map_of_additive additive (R * R),
      map_mul_of_derivation additive leibniz R R, lax, Matrix.trace_add]
    have first : trace ((G * R - R * G) * R) = 0 := by
      rw [Matrix.sub_mul, Matrix.trace_sub, sub_eq_zero, Matrix.mul_assoc,
        Matrix.trace_mul_comm G (R * R), Matrix.mul_assoc,
        Matrix.trace_mul_comm R (R * G)]
    have second : trace (R * (G * R - R * G)) = 0 := by
      rw [Matrix.mul_sub, Matrix.trace_sub, sub_eq_zero,
        Matrix.trace_mul_comm R (G * R), Matrix.mul_assoc,
        Matrix.trace_mul_comm G (R * R), Matrix.mul_assoc]
    rw [first, second, add_zero]
  rw [residueDiscriminant_eq_trace_form, map_sub_of_additive additive,
    show (2 : A) * trace (R * R) = trace (R * R) + trace (R * R) by ring,
    show (trace R) ^ 2 = trace R * trace R by ring, additive, leibniz,
    squareTraceZero, traceZero]
  ring

end BaseVariation

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
