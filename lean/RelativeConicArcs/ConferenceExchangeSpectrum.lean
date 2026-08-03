import Mathlib.Data.Matrix.Block
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.LinearAlgebra.Matrix.Charpoly.Eigs
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic.LinearCombination
import Mathlib.RingTheory.MvPolynomial.Symmetric.Defs
import Mathlib.Tactic.NormNum

/-!
# Cross Gram blocks and balanced exchange spectra of conference matrices

A symmetric conference matrix of order `n` is a symmetric matrix with zero
diagonal, off-diagonal entries of square one, and `C * C = q • 1` for the
scalar `q`; the classical case is `q = n - 1`.  Splitting the index set into a
subset and its complement writes `C` in block form with principal block `A`,
cross block `S`, and complementary principal block `E`.

This module works at matrix level.  It proves that the conference equation
forces the cross Gram identity `S * Sᵀ = q • 1 - A * A`, computes the square of
a signed triangle block, and derives the spectrum and degree-three symmetric
functions of the normalized exchange operator `q⁻¹ • (S * Sᵀ)` for a balanced
three-element cut of an order-six real conference matrix.

Conventions and scope:

* `signedTriangle a b c` is the symmetric zero-diagonal three-by-three matrix
  with off-diagonal entries `a`, `b`, `c` in positions `(0,1)`, `(0,2)`,
  `(1,2)`; the hypotheses `a * a = 1`, `b * b = 1`, `c * c = 1` express that
  these are signs, and `a * b * c` is the triangle product.
* `normalizedExchange q S` is `q⁻¹ • (S * Sᵀ)`.  Its eigenvalues are recorded
  through `Matrix.charpoly`, its multiset of roots, and `spectrum`, so that
  multiplicities are part of the statement.
* Elementary symmetric functions of an eigenvalue multiset are `Multiset.esymm`
  and power sums are `powerSum`.  The third complete homogeneous symmetric
  function and the Schur function of the partition `(2,1)` are defined by their
  monomial expansions in three variables and related to `Multiset.esymm` by
  proved identities, since the library has no Schur-polynomial API.

Trust boundary: every result below is a symbolic kernel proof over a
commutative ring or over the real numbers.  Nothing here identifies the
normalized exchange operator with a compression `Q₋ᵀ D Q₊` of a diagonal
control between orthonormal eigenframes of `C`; that identification is a
separate statement, and the results below apply to it only through the equality
of the two spectra.
-/

namespace RelativeConicArcs
namespace ConferenceExchange

open Matrix

section Blocks

variable {R : Type*} [CommRing R] {m n : Type*}
variable [Fintype m] [DecidableEq m] [Fintype n] [DecidableEq n]

/-- The conference equation, read on the principal block of a two-block
splitting: if the block matrix with principal blocks `A` and `E` and cross
block `S` squares to `q • 1`, then `A * A + S * Sᵀ = q • 1`.  This is the exact
sense in which the cross Gram matrix `S * Sᵀ` is determined by the principal
block. -/
theorem principal_sq_add_crossGram (q : R) (A : Matrix m m R) (S : Matrix m n R)
    (E : Matrix n n R)
    (h : (fromBlocks A S Sᵀ E) * (fromBlocks A S Sᵀ E)
        = q • (1 : Matrix (m ⊕ n) (m ⊕ n) R)) :
    A * A + S * Sᵀ = q • (1 : Matrix m m R) := by
  ext i j
  have h' := congrFun (congrFun h (Sum.inl i)) (Sum.inl j)
  simpa [Matrix.mul_apply, Fintype.sum_sum_type, Matrix.one_apply, Matrix.add_apply,
    Matrix.smul_apply, Matrix.transpose_apply, mul_comm] using h'

/-- The cross Gram matrix of a two-block splitting of a conference matrix. -/
theorem crossGram_eq (q : R) (A : Matrix m m R) (S : Matrix m n R) (E : Matrix n n R)
    (h : (fromBlocks A S Sᵀ E) * (fromBlocks A S Sᵀ E)
        = q • (1 : Matrix (m ⊕ n) (m ⊕ n) R)) :
    S * Sᵀ = q • (1 : Matrix m m R) - A * A := by
  have := principal_sq_add_crossGram q A S E h
  linear_combination (norm := module) this

end Blocks

section Triangle

variable {R : Type*} [CommRing R]

/-- The symmetric zero-diagonal three-by-three matrix with off-diagonal entries
`a`, `b`, and `c`.  A three-element subset of a symmetric conference matrix has
this principal block, with `a`, `b`, `c` the three edge signs. -/
def signedTriangle (a b c : R) : Matrix (Fin 3) (Fin 3) R :=
  !![0, a, b; a, 0, c; b, c, 0]

@[simp]
theorem signedTriangle_transpose (a b c : R) :
    (signedTriangle a b c)ᵀ = signedTriangle a b c := by
  ext i j
  fin_cases i <;> fin_cases j <;> rfl

/-- The square of a signed triangle block is `2 • 1 + (a * b * c) • A`.  The
triangle product `a * b * c` is the only invariant of the three signs that
survives squaring. -/
theorem signedTriangle_sq (a b c : R) (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1) :
    signedTriangle a b c * signedTriangle a b c
      = (2 : R) • (1 : Matrix (Fin 3) (Fin 3) R) + (a * b * c) • signedTriangle a b c := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [signedTriangle, Matrix.mul_apply, Fin.sum_univ_three]
  · linear_combination ha + hb
  · linear_combination (-(b * c)) * ha
  · linear_combination (-(a * c)) * hb
  · linear_combination (-(b * c)) * ha
  · linear_combination ha + hc
  · linear_combination (-(a * b)) * hc
  · linear_combination (-(a * c)) * hb
  · linear_combination (-(a * b)) * hc
  · linear_combination hb + hc

end Triangle

section Exchange

/-- The normalized exchange operator of a cut with cross block `S`: the cross
Gram matrix `S * Sᵀ` divided by the conference scalar `q`. -/
noncomputable def normalizedExchange {m n : Type*} [Fintype n] (q : ℝ) (S : Matrix m n ℝ) :
    Matrix m m ℝ :=
  q⁻¹ • (S * Sᵀ)

/-- For an order-six symmetric conference matrix split at a three-element
subset, the normalized exchange operator is determined by the triangle product
of the principal block. -/
theorem normalizedExchange_eq_of_triangle (a b c : ℝ) (S : Matrix (Fin 3) (Fin 3) ℝ)
    (E : Matrix (Fin 3) (Fin 3) ℝ)
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1)
    (h : (fromBlocks (signedTriangle a b c) S Sᵀ E)
          * (fromBlocks (signedTriangle a b c) S Sᵀ E)
        = (5 : ℝ) • (1 : Matrix (Fin 3 ⊕ Fin 3) (Fin 3 ⊕ Fin 3) ℝ)) :
    normalizedExchange 5 S
      = (3 / 5 : ℝ) • (1 : Matrix (Fin 3) (Fin 3) ℝ)
        - (a * b * c / 5) • signedTriangle a b c := by
  have hcross := crossGram_eq (5 : ℝ) (signedTriangle a b c) S E h
  have hsq := signedTriangle_sq a b c ha hb hc
  rw [normalizedExchange, hcross, hsq]
  ext i j
  simp [Matrix.smul_apply, Matrix.sub_apply, Matrix.add_apply, Matrix.one_apply]
  split_ifs <;> ring

end Exchange

section SymmetricFunctions

/-- The `k`-th power sum of a multiset of scalars.  Elementary symmetric
functions of a multiset are `Multiset.esymm`. -/
def powerSum (s : Multiset ℝ) (k : ℕ) : ℝ := (s.map (· ^ k)).sum

/-- The third complete homogeneous symmetric function of a triple: the sum of
all ten monomials of degree three in three variables. -/
def completeHomogeneous₃ (x y z : ℝ) : ℝ :=
  x ^ 3 + y ^ 3 + z ^ 3
    + x ^ 2 * y + x ^ 2 * z + y ^ 2 * x + y ^ 2 * z + z ^ 2 * x + z ^ 2 * y
    + x * y * z

/-- The Schur function of the partition `(2,1)` in three variables: the sum
over its eight semistandard tableaux, that is, the six monomials of shape
`x ^ 2 * y` together with twice the product of all three variables. -/
def schur₂₁ (x y z : ℝ) : ℝ :=
  x ^ 2 * y + x ^ 2 * z + y ^ 2 * x + y ^ 2 * z + z ^ 2 * x + z ^ 2 * y
    + 2 * (x * y * z)

/-- The third complete homogeneous symmetric function in terms of the
elementary symmetric functions of the same triple. -/
theorem completeHomogeneous₃_eq_esymm (x y z : ℝ) :
    completeHomogeneous₃ x y z
      = ({x, y, z} : Multiset ℝ).esymm 1 ^ 3
        - 2 * ({x, y, z} : Multiset ℝ).esymm 1 * ({x, y, z} : Multiset ℝ).esymm 2
        + ({x, y, z} : Multiset ℝ).esymm 3 := by
  simp [completeHomogeneous₃, Multiset.esymm, Multiset.powersetCard_cons,
    Multiset.powersetCard_one]
  ring

/-- The Schur function of the partition `(2,1)` in terms of the elementary
symmetric functions of the same triple. -/
theorem schur₂₁_eq_esymm (x y z : ℝ) :
    schur₂₁ x y z
      = ({x, y, z} : Multiset ℝ).esymm 1 * ({x, y, z} : Multiset ℝ).esymm 2
        - ({x, y, z} : Multiset ℝ).esymm 3 := by
  simp [schur₂₁, Multiset.esymm, Multiset.powersetCard_cons, Multiset.powersetCard_one]
  ring

/-- The degree-three Schur–Weyl decomposition of a triple: the symmetric sector,
the twice-counted mixed sector, and the exterior sector sum to the cube of the
first power sum. -/
theorem schurWeyl_checksum (x y z : ℝ) :
    completeHomogeneous₃ x y z + 2 * schur₂₁ x y z + ({x, y, z} : Multiset ℝ).esymm 3
      = powerSum {x, y, z} 1 ^ 3 := by
  simp [completeHomogeneous₃, schur₂₁, powerSum, Multiset.esymm,
    Multiset.powersetCard_cons, Multiset.powersetCard_one]
  ring

end SymmetricFunctions

section BalancedBenchmark

variable (a b c : ℝ) (S E : Matrix (Fin 3) (Fin 3) ℝ)

/-- The three sign hypotheses, packaged for the balanced-cut results below. -/
private theorem triangleProduct_sq (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1) :
    (a * b * c) * (a * b * c) = 1 := by
  linear_combination (b * b * c * c) * ha + (c * c) * hb + hc

/-- Determinant of the shifted normalized exchange operator at a real point.
The value is the same for every choice of the three edge signs. -/
theorem det_smul_one_sub_normalizedExchange
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1)
    (h : (fromBlocks (signedTriangle a b c) S Sᵀ E)
          * (fromBlocks (signedTriangle a b c) S Sᵀ E)
        = (5 : ℝ) • (1 : Matrix (Fin 3 ⊕ Fin 3) (Fin 3 ⊕ Fin 3) ℝ))
    (lam : ℝ) :
    ((lam • (1 : Matrix (Fin 3) (Fin 3) ℝ) - normalizedExchange 5 S :
        Matrix (Fin 3) (Fin 3) ℝ)).det
      = (lam - 1 / 5) * (lam - 4 / 5) ^ 2 := by
  have hprod := triangleProduct_sq a b c ha hb hc
  have ea : (a * b * c * a) * (a * b * c * a) = 1 := by
    linear_combination (a * a) * hprod + ha
  have eb : (a * b * c * b) * (a * b * c * b) = 1 := by
    linear_combination (b * b) * hprod + hb
  have ec : (a * b * c * c) * (a * b * c * c) = 1 := by
    linear_combination (c * c) * hprod + hc
  have eabc : (a * b * c * a) * (a * b * c * b) * (a * b * c * c) = 1 := by
    linear_combination ((a * b * c) * (a * b * c) + 1) * hprod
  rw [normalizedExchange_eq_of_triangle a b c S E ha hb hc h, Matrix.det_fin_three]
  simp [signedTriangle, Matrix.smul_apply, Matrix.sub_apply]
  linear_combination (-(lam - 3 / 5) / 25) * ea + (-(lam - 3 / 5) / 25) * eb
    + (-(lam - 3 / 5) / 25) * ec + (2 / 125) * eabc

open Polynomial in
/-- Characteristic polynomial of the normalized exchange operator at a
three-element cut of an order-six real symmetric conference matrix.  It factors
into linear factors with a simple root `1/5` and a double root `4/5`,
independently of the three edge signs of the principal block. -/
theorem charpoly_normalizedExchange
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1)
    (h : (fromBlocks (signedTriangle a b c) S Sᵀ E)
          * (fromBlocks (signedTriangle a b c) S Sᵀ E)
        = (5 : ℝ) • (1 : Matrix (Fin 3 ⊕ Fin 3) (Fin 3 ⊕ Fin 3) ℝ)) :
    (normalizedExchange 5 S).charpoly = (X - C (1 / 5)) * (X - C (4 / 5)) ^ 2 := by
  refine Polynomial.funext fun r => ?_
  rw [Matrix.eval_charpoly]
  have hscalar : (Matrix.scalar (Fin 3) r - normalizedExchange 5 S)
      = (r • (1 : Matrix (Fin 3) (Fin 3) ℝ) - normalizedExchange 5 S) := by
    simp [Matrix.scalar, Matrix.smul_one_eq_diagonal]
  rw [hscalar, det_smul_one_sub_normalizedExchange a b c S E ha hb hc h r]
  simp

open Polynomial in
/-- The exchange spectrum with multiplicity: the roots of the characteristic
polynomial are `1/5`, `4/5`, and `4/5`. -/
theorem roots_charpoly_normalizedExchange
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1)
    (h : (fromBlocks (signedTriangle a b c) S Sᵀ E)
          * (fromBlocks (signedTriangle a b c) S Sᵀ E)
        = (5 : ℝ) • (1 : Matrix (Fin 3 ⊕ Fin 3) (Fin 3 ⊕ Fin 3) ℝ)) :
    (normalizedExchange 5 S).charpoly.roots = {1 / 5, 4 / 5, 4 / 5} := by
  rw [charpoly_normalizedExchange a b c S E ha hb hc h,
    Polynomial.roots_mul (by
      refine mul_ne_zero (Polynomial.X_sub_C_ne_zero _) (pow_ne_zero _ ?_)
      exact Polynomial.X_sub_C_ne_zero _),
    Polynomial.roots_pow, Polynomial.roots_X_sub_C, Polynomial.roots_X_sub_C]
  simp only [two_smul, Multiset.singleton_add]
  rfl

open Polynomial in
/-- The exchange spectrum as a set of eigenvalues. -/
theorem spectrum_normalizedExchange
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1)
    (h : (fromBlocks (signedTriangle a b c) S Sᵀ E)
          * (fromBlocks (signedTriangle a b c) S Sᵀ E)
        = (5 : ℝ) • (1 : Matrix (Fin 3 ⊕ Fin 3) (Fin 3 ⊕ Fin 3) ℝ)) :
    spectrum ℝ (normalizedExchange 5 S) = {1 / 5, 4 / 5} := by
  ext r
  rw [Matrix.mem_spectrum_iff_isRoot_charpoly,
    charpoly_normalizedExchange a b c S E ha hb hc h]
  simp [Polynomial.IsRoot, sub_eq_zero, or_comm]

/-- The first power sum of the balanced exchange spectrum. -/
theorem trace_normalizedExchange
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1)
    (h : (fromBlocks (signedTriangle a b c) S Sᵀ E)
          * (fromBlocks (signedTriangle a b c) S Sᵀ E)
        = (5 : ℝ) • (1 : Matrix (Fin 3 ⊕ Fin 3) (Fin 3 ⊕ Fin 3) ℝ)) :
    (normalizedExchange 5 S).trace = 9 / 5 := by
  rw [normalizedExchange_eq_of_triangle a b c S E ha hb hc h, Matrix.trace_fin_three]
  simp [signedTriangle, Matrix.smul_apply, Matrix.sub_apply]
  ring

/-- The second power sum of the balanced exchange spectrum. -/
theorem trace_sq_normalizedExchange
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1)
    (h : (fromBlocks (signedTriangle a b c) S Sᵀ E)
          * (fromBlocks (signedTriangle a b c) S Sᵀ E)
        = (5 : ℝ) • (1 : Matrix (Fin 3 ⊕ Fin 3) (Fin 3 ⊕ Fin 3) ℝ)) :
    (normalizedExchange 5 S * normalizedExchange 5 S).trace = 33 / 25 := by
  have hprod := triangleProduct_sq a b c ha hb hc
  have ea : (a * b * c * a) * (a * b * c * a) = 1 := by
    linear_combination (a * a) * hprod + ha
  have eb : (a * b * c * b) * (a * b * c * b) = 1 := by
    linear_combination (b * b) * hprod + hb
  have ec : (a * b * c * c) * (a * b * c * c) = 1 := by
    linear_combination (c * c) * hprod + hc
  rw [normalizedExchange_eq_of_triangle a b c S E ha hb hc h, Matrix.trace_fin_three]
  simp [signedTriangle, Matrix.mul_apply, Fin.sum_univ_three, Matrix.smul_apply,
    Matrix.sub_apply]
  linear_combination (2 / 25) * ea + (2 / 25) * eb + (2 / 25) * ec

/-- The exterior exchange sector, that is, the filled three-fermion transfer
probability. -/
theorem det_normalizedExchange
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1)
    (h : (fromBlocks (signedTriangle a b c) S Sᵀ E)
          * (fromBlocks (signedTriangle a b c) S Sᵀ E)
        = (5 : ℝ) • (1 : Matrix (Fin 3 ⊕ Fin 3) (Fin 3 ⊕ Fin 3) ℝ)) :
    (normalizedExchange 5 S).det = 16 / 125 := by
  have hprod := triangleProduct_sq a b c ha hb hc
  have ea : (a * b * c * a) * (a * b * c * a) = 1 := by
    linear_combination (a * a) * hprod + ha
  have eb : (a * b * c * b) * (a * b * c * b) = 1 := by
    linear_combination (b * b) * hprod + hb
  have ec : (a * b * c * c) * (a * b * c * c) = 1 := by
    linear_combination (c * c) * hprod + hc
  have eabc : (a * b * c * a) * (a * b * c * b) * (a * b * c * c) = 1 := by
    linear_combination ((a * b * c) * (a * b * c) + 1) * hprod
  rw [normalizedExchange_eq_of_triangle a b c S E ha hb hc h, Matrix.det_fin_three]
  simp [signedTriangle, Matrix.smul_apply, Matrix.sub_apply]
  linear_combination (-3 / 125) * ea + (-3 / 125) * eb + (-3 / 125) * ec + (-2 / 125) * eabc

/-- The degree-three exchange sectors of the eigenvalue triple
`(1/5, 4/5, 4/5)`, including the Schur-Weyl checksum. -/
theorem balancedSpectrum_sectors :
    powerSum {1 / 5, 4 / 5, 4 / 5} 1 = 9 / 5
      ∧ powerSum {1 / 5, 4 / 5, 4 / 5} 2 = 33 / 25
      ∧ ({1 / 5, 4 / 5, 4 / 5} : Multiset ℝ).esymm 2 = 24 / 25
      ∧ ({1 / 5, 4 / 5, 4 / 5} : Multiset ℝ).esymm 3 = 16 / 125
      ∧ completeHomogeneous₃ (1 / 5) (4 / 5) (4 / 5) = 313 / 125
      ∧ schur₂₁ (1 / 5) (4 / 5) (4 / 5) = 8 / 5
      ∧ completeHomogeneous₃ (1 / 5) (4 / 5) (4 / 5)
          - ({1 / 5, 4 / 5, 4 / 5} : Multiset ℝ).esymm 3 = 297 / 125
      ∧ completeHomogeneous₃ (1 / 5) (4 / 5) (4 / 5)
          + 2 * schur₂₁ (1 / 5) (4 / 5) (4 / 5)
          + ({1 / 5, 4 / 5, 4 / 5} : Multiset ℝ).esymm 3 = 729 / 125 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    norm_num [powerSum, completeHomogeneous₃, schur₂₁, Multiset.esymm,
      Multiset.powersetCard_cons, Multiset.powersetCard_one]

/-- Balanced exchange benchmark for order-six symmetric conference matrices.

Let `C` be a symmetric matrix of order six, written in block form at a
three-element subset with principal block `signedTriangle a b c` for signs
`a`, `b`, `c`, cross block `S`, and complementary principal block `E`, and
assume the conference equation `C * C = 5 • 1`.  Then the normalized exchange
operator `5⁻¹ • (S * Sᵀ)` has characteristic polynomial
`(X - C (1/5)) * (X - C (4/5)) ^ 2`; its eigenvalues with multiplicity are
`1/5`, `4/5`, `4/5`; its trace, squared trace, and determinant are the first
two power sums and the product of that triple; and its degree-three exchange
sectors are `313/125`, `8/5`, and `16/125`.  The conclusion does not depend on
the three edge signs, hence is the same for every three-element cut of every
order-six symmetric conference matrix. -/
theorem balancedExchange_benchmark
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1)
    (h : (fromBlocks (signedTriangle a b c) S Sᵀ E)
          * (fromBlocks (signedTriangle a b c) S Sᵀ E)
        = (5 : ℝ) • (1 : Matrix (Fin 3 ⊕ Fin 3) (Fin 3 ⊕ Fin 3) ℝ)) :
    (normalizedExchange 5 S).charpoly
        = (Polynomial.X - Polynomial.C (1 / 5)) * (Polynomial.X - Polynomial.C (4 / 5)) ^ 2
      ∧ (normalizedExchange 5 S).charpoly.roots = {1 / 5, 4 / 5, 4 / 5}
      ∧ spectrum ℝ (normalizedExchange 5 S) = {1 / 5, 4 / 5}
      ∧ (normalizedExchange 5 S).trace = powerSum {1 / 5, 4 / 5, 4 / 5} 1
      ∧ (normalizedExchange 5 S * normalizedExchange 5 S).trace
          = powerSum {1 / 5, 4 / 5, 4 / 5} 2
      ∧ (normalizedExchange 5 S).det = ({1 / 5, 4 / 5, 4 / 5} : Multiset ℝ).esymm 3
      ∧ completeHomogeneous₃ (1 / 5) (4 / 5) (4 / 5) = 313 / 125
      ∧ schur₂₁ (1 / 5) (4 / 5) (4 / 5) = 8 / 5
      ∧ ({1 / 5, 4 / 5, 4 / 5} : Multiset ℝ).esymm 3 = 16 / 125 := by
  obtain ⟨hp₁, hp₂, -, he₃, hh₃, hs₂₁, -, -⟩ := balancedSpectrum_sectors
  refine ⟨charpoly_normalizedExchange a b c S E ha hb hc h,
    roots_charpoly_normalizedExchange a b c S E ha hb hc h,
    spectrum_normalizedExchange a b c S E ha hb hc h, ?_, ?_, ?_, hh₃, hs₂₁, he₃⟩
  · rw [trace_normalizedExchange a b c S E ha hb hc h, hp₁]
  · rw [trace_sq_normalizedExchange a b c S E ha hb hc h, hp₂]
  · rw [det_normalizedExchange a b c S E ha hb hc h, he₃]

end BalancedBenchmark

end ConferenceExchange
end RelativeConicArcs
