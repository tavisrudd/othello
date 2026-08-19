import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.LowDimensionalVanishingCore
import Mathlib.Analysis.Normed.Algebra.MatrixExponential
import Mathlib.RingTheory.Nilpotent.Basic

/-!
# Weight-raising residues and parity-corrected unipotent monodromy

This module proves the linear-algebra core of the regular-singular argument for a
target whose canonical class is nef, in the form used after a coefficient
specialization.  Three steps are formalized, all about complex matrices.

First, an integral weight filtration is recorded by a function `weight` on the
index type of a matrix, thought of as the eigenvalue of the grading operator on a
basis vector.  A matrix *raises the weight* when every nonzero entry moves the
weight of its column up by at least one.  Such matrices are closed under sums and
scalar multiples, and a product of `k` of them moves the weight up by at least
`k`, so a weight-raising matrix on a finite index type is nilpotent: the weights
of finitely many basis vectors have bounded spread.  In the intended reading the
grading operator is the sum of the parity-corrected grading of cohomological
degree, the weight-raising matrices are the coefficients of Euler multiplication
in the effective classes with vanishing first Chern number, and their sum is the
residue of the gauged connection.

Second, the exponential of a nilpotent complex matrix is unipotent: if `N ^ k = 0`
then the exponential series is the finite sum of its first `k` terms, that sum is
`1 + N * S` with `S` a polynomial in `N`, and a product of commuting factors one
of which is nilpotent is nilpotent.  This is the passage from a nilpotent residue
to a unipotent regular monodromy.

Third, undoing the half-parity correction multiplies the regular monodromy by an
operator whose square is the identity, because the parity operator has integral
eigenvalues.  If that operator commutes with the regular monodromy, the square of
the product differs from the identity by a nilpotent matrix, and then every
characteristic root of the product has square one.  Combined with the fact that
neither primitive sixth root has square one, the primitive-sixth count of such a
framed monodromy vanishes.

Lean constructs no quantum connection, Euler multiplication, grading operator, or
gauge transformation, and does not prove that a geometric framed monodromy has
the displayed factorization: the factorization, the involution property of the
parity factor, and its commutation with the regular monodromy are hypotheses of
the statements below.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Matrix

section WeightFiltration

variable {index : Type*} {R : Type*}

/-- An operator raises the integral weight filtration given by `weight` when each
of its nonzero entries lies in a row whose weight exceeds the weight of its
column by at least one.  Equivalently, the operator maps the span of the basis
vectors of weight at most `w` into the span of those of weight at least `w + 1`
in each coordinate. -/
def RaisesWeight [Zero R] (weight : index → ℤ) (operator : Matrix index index R) : Prop :=
  ∀ row column : index, operator row column ≠ 0 → weight column + 1 ≤ weight row

/-- A sum of two weight-raising operators raises the weight. -/
theorem RaisesWeight.add [AddZeroClass R] {weight : index → ℤ}
    {left right : Matrix index index R} (leftRaises : RaisesWeight weight left)
    (rightRaises : RaisesWeight weight right) :
    RaisesWeight weight (left + right) := by
  intro row column nonzero
  by_cases leftEntry : left row column = 0
  · refine rightRaises row column fun rightEntry => nonzero ?_
    simp [Matrix.add_apply, leftEntry, rightEntry]
  · exact leftRaises row column leftEntry

/-- A scalar multiple of a weight-raising operator raises the weight. -/
theorem RaisesWeight.smul {M : Type*} [Monoid M] [AddMonoid R] [DistribMulAction M R]
    {weight : index → ℤ} {operator : Matrix index index R}
    (raises : RaisesWeight weight operator) (scalar : M) :
    RaisesWeight weight (scalar • operator) := by
  intro row column nonzero
  refine raises row column fun entry => nonzero ?_
  simp [Matrix.smul_apply, entry]

/-- A finite sum of weight-raising operators raises the weight.  This is the step
that makes the residue of the gauged connection weight-raising: it is the sum of
the coefficients of Euler multiplication in the effective classes of vanishing
first Chern number. -/
theorem RaisesWeight.sum [AddCommMonoid R] {weight : index → ℤ} {ι : Type*}
    {support : Finset ι} {family : ι → Matrix index index R}
    (raises : ∀ i ∈ support, RaisesWeight weight (family i)) :
    RaisesWeight weight (∑ i ∈ support, family i) := by
  intro row column nonzero
  rw [Matrix.sum_apply] at nonzero
  obtain ⟨i, membership, entryNonzero⟩ := Finset.exists_ne_zero_of_sum_ne_zero nonzero
  exact raises i membership row column entryNonzero

/-- The `k`-th power of a weight-raising operator moves the weight up by at least
`k` in every nonzero entry. -/
theorem RaisesWeight.pow_entry [Fintype index] [DecidableEq index] [Semiring R]
    {weight : index → ℤ} {operator : Matrix index index R}
    (raises : RaisesWeight weight operator) :
    ∀ (exponent : ℕ) (row column : index),
      (operator ^ exponent) row column ≠ 0 → weight column + exponent ≤ weight row := by
  intro exponent
  induction exponent with
  | zero =>
      intro row column nonzero
      have diagonal : row = column := by
        by_contra different
        exact nonzero (by rw [pow_zero, Matrix.one_apply_ne different])
      subst diagonal
      simp
  | succ exponent inductionHypothesis =>
      intro row column nonzero
      rw [pow_succ, Matrix.mul_apply] at nonzero
      obtain ⟨middle, _, product⟩ := Finset.exists_ne_zero_of_sum_ne_zero nonzero
      have earlier : weight middle + exponent ≤ weight row :=
        inductionHypothesis row middle fun entry => product (by rw [entry, zero_mul])
      have last : weight column + 1 ≤ weight middle :=
        raises middle column fun entry => product (by rw [entry, mul_zero])
      push_cast
      omega

/-- A weight-raising operator on a finite index type is nilpotent: the weights of
the finitely many basis vectors have bounded spread, so a high enough power
raises the weight beyond that spread and must vanish. -/
theorem RaisesWeight.isNilpotent [Fintype index] [DecidableEq index] [Semiring R]
    {weight : index → ℤ} {operator : Matrix index index R}
    (raises : RaisesWeight weight operator) : IsNilpotent operator := by
  classical
  set spread : ℕ :=
    Finset.univ.sup fun pair : index × index => (weight pair.1 - weight pair.2).toNat
    with spreadDefinition
  refine ⟨spread + 1, ?_⟩
  ext row column
  simp only [Matrix.zero_apply]
  by_contra nonzero
  have raised := raises.pow_entry (spread + 1) row column nonzero
  have bounded : ((weight row - weight column).toNat : ℤ) ≤ (spread : ℤ) := by
    have := Finset.le_sup (f := fun pair : index × index => (weight pair.1 - weight pair.2).toNat)
      (Finset.mem_univ (row, column))
    exact_mod_cast this.trans_eq spreadDefinition.symm
  have self : weight row - weight column ≤ ((weight row - weight column).toNat : ℤ) :=
    Int.self_le_toNat _
  push_cast at raised
  omega

end WeightFiltration

section NilpotentExponential

open NormedSpace

variable {rank : ℕ}

/-- The exponential of a nilpotent complex matrix differs from the identity by a
nilpotent matrix.  If `N ^ k = 0`, the exponential series has only its first `k`
terms, and the terms of positive order factor as `N` times a polynomial in `N`. -/
theorem isNilpotent_exp_sub_one {nilpotentPart : Matrix (Fin rank) (Fin rank) ℂ}
    (nilpotent : IsNilpotent nilpotentPart) :
    IsNilpotent (exp nilpotentPart - 1) := by
  obtain ⟨order, vanishing⟩ := nilpotent
  have vanishingAbove : ∀ exponent : ℕ, order ≤ exponent → nilpotentPart ^ exponent = 0 :=
    fun exponent bound => pow_eq_zero_of_le bound vanishing
  have expansion : exp nilpotentPart
      = ∑ term ∈ Finset.range (order + 1), ((Nat.factorial term : ℂ)⁻¹) • nilpotentPart ^ term := by
    rw [NormedSpace.exp_eq_tsum (𝕂 := ℂ)]
    refine tsum_eq_sum ?_
    intro term notMember
    rw [Finset.mem_range, not_lt] at notMember
    rw [vanishingAbove term (Nat.le_of_succ_le notMember), smul_zero]
  have termwise : ∀ term : ℕ,
      ((Nat.factorial (term + 1) : ℂ)⁻¹) • nilpotentPart ^ (term + 1)
        = nilpotentPart * (((Nat.factorial (term + 1) : ℂ)⁻¹) • nilpotentPart ^ term) := by
    intro term
    rw [mul_smul_comm, pow_succ']
  have factored : exp nilpotentPart - 1
      = nilpotentPart *
        ∑ term ∈ Finset.range order, (((Nat.factorial (term + 1) : ℂ)⁻¹) • nilpotentPart ^ term) := by
    rw [expansion, Finset.sum_range_succ', Finset.mul_sum]
    simp only [Nat.factorial_zero, Nat.cast_one, inv_one, one_smul, pow_zero,
      add_sub_cancel_right]
    exact Finset.sum_congr rfl fun term _ => termwise term
  have commutes : Commute nilpotentPart
      (∑ term ∈ Finset.range order, (((Nat.factorial (term + 1) : ℂ)⁻¹) • nilpotentPart ^ term)) :=
    Commute.sum_right _ _ _ fun term _ =>
      ((Commute.refl nilpotentPart).pow_right term).smul_right _
  rw [factored]
  exact commutes.isNilpotent_mul_right ⟨order, vanishing⟩

end NilpotentExponential

section ParityCorrection

variable {rank : ℕ}

/-- Every characteristic root of a complex matrix whose square differs from the
identity by a nilpotent matrix has square one.  An eigenvector of the matrix for
the root is an eigenvector of that nilpotent difference for the eigenvalue
`value ^ 2 - 1`, and an eigenvalue of a nilpotent operator vanishes. -/
theorem charpoly_isRoot_sq_eq_one_of_isNilpotent_sq_sub_one
    (operator : Matrix (Fin rank) (Fin rank) ℂ)
    (nilpotent : IsNilpotent (operator * operator - 1)) {value : ℂ}
    (root : operator.charpoly.IsRoot value) : value ^ 2 = 1 := by
  classical
  obtain ⟨order, vanishing⟩ := nilpotent
  set endomorphism : Module.End ℂ (Fin rank → ℂ) := Matrix.toLin' operator with
    endomorphismDefinition
  have eigenvalue : Module.End.HasEigenvalue endomorphism value := by
    rw [Module.End.hasEigenvalue_iff_isRoot_charpoly]
    simpa [endomorphismDefinition, Matrix.charpoly_toLin'] using root
  obtain ⟨vector, eigenvector⟩ := eigenvalue.exists_hasEigenvector
  have squareAction : (endomorphism ^ 2) vector = value ^ 2 • vector :=
    eigenvector.pow_apply 2
  have transferred : (endomorphism ^ 2 - 1 : Module.End ℂ (Fin rank → ℂ))
      = Matrix.toLin' (operator * operator - 1) := by
    rw [map_sub, Matrix.toLin'_mul, Matrix.toLin'_one, pow_two]
    rfl
  have nilpotentPower : (endomorphism ^ 2 - 1 : Module.End ℂ (Fin rank → ℂ)) ^ order = 0 := by
    rw [transferred, ← Matrix.toLin'_pow, vanishing, map_zero]
  have action : (endomorphism ^ 2 - 1 : Module.End ℂ (Fin rank → ℂ)) vector
      = (value ^ 2 - 1) • vector := by
    simp [squareAction, sub_smul]
  have iterate : ∀ exponent : ℕ,
      ((endomorphism ^ 2 - 1 : Module.End ℂ (Fin rank → ℂ)) ^ exponent) vector
        = (value ^ 2 - 1) ^ exponent • vector := by
    intro exponent
    induction exponent with
    | zero => simp
    | succ exponent inductionHypothesis =>
        rw [pow_succ, Module.End.mul_apply, action, map_smul, inductionHypothesis, smul_smul,
          ← pow_succ']
  have scalarVanishing : (value ^ 2 - 1) ^ order • vector = 0 := by
    rw [← iterate order, nilpotentPower]
    simp
  have scalarZero : (value ^ 2 - 1) ^ order = 0 :=
    (smul_eq_zero.mp scalarVanishing).resolve_right eigenvector.2
  have difference : value ^ 2 - 1 = 0 := pow_eq_zero_iff'.mp scalarZero |>.1
  exact sub_eq_zero.mp difference

/-- Primitive-sixth vanishing for a framed monodromy that factors as a parity
correction times a unipotent regular monodromy.  The square of such a product is
the square of the unipotent factor, which differs from the identity by a
nilpotent matrix, so every characteristic root has square one; neither primitive
sixth root does. -/
theorem sixthMultiplicity_eq_zero_of_parity_corrected_unipotent
    (monodromy : FramedMonodromyMatrix)
    (parity regular : Matrix (Fin monodromy.rank) (Fin monodromy.rank) ℂ)
    (factorization : monodromy.operator = parity * regular)
    (involution : parity * parity = 1)
    (commutes : Commute parity regular)
    (unipotent : IsNilpotent (regular - 1)) :
    monodromy.sixthMultiplicity = 0 := by
  refine monodromy.sixthMultiplicity_eq_zero_of_roots_sq_eq_one fun value root => ?_
  refine charpoly_isRoot_sq_eq_one_of_isNilpotent_sq_sub_one monodromy.operator ?_ root
  have square : monodromy.operator * monodromy.operator = regular * regular := by
    rw [factorization]
    calc parity * regular * (parity * regular)
        = parity * (regular * parity) * regular := by
          simp [Matrix.mul_assoc]
      _ = parity * (parity * regular) * regular := by rw [commutes.eq]
      _ = parity * parity * (regular * regular) := by
          simp [Matrix.mul_assoc]
      _ = regular * regular := by rw [involution, Matrix.one_mul]
  have difference : regular * regular - 1 = (regular - 1) * (regular + 1) := by
    noncomm_ring
  have commuteFactors : Commute (regular - 1) (regular + 1) :=
    Commute.sub_left ((Commute.refl regular).add_right (Commute.one_right regular))
      (Commute.one_left (regular + 1))
  rw [square, difference]
  exact commuteFactors.isNilpotent_mul_right unipotent

/-- Primitive-sixth vanishing from a weight-raising residue.  The regular
monodromy of the parity-corrected connection is the exponential of `2πi` times
the residue; the residue raises the integral weight filtration of the grading
operator, hence is nilpotent, hence that exponential is unipotent.  Undoing the
half-parity correction multiplies by an operator of square one commuting with it,
and the resulting framed monodromy has only the characteristic roots `1` and
`-1`. -/
theorem sixthMultiplicity_eq_zero_of_weightRaising_residue
    (monodromy : FramedMonodromyMatrix) (weight : Fin monodromy.rank → ℤ)
    (parity residue : Matrix (Fin monodromy.rank) (Fin monodromy.rank) ℂ)
    (residueRaisesWeight : RaisesWeight weight residue)
    (involution : parity * parity = 1)
    (parityCommutes : Commute parity residue)
    (factorization : monodromy.operator
      = parity * NormedSpace.exp ((2 * Real.pi * Complex.I) • residue)) :
    monodromy.sixthMultiplicity = 0 := by
  have nilpotentResidue : IsNilpotent ((2 * Real.pi * Complex.I) • residue) :=
    (residueRaisesWeight.smul (2 * Real.pi * Complex.I)).isNilpotent
  exact sixthMultiplicity_eq_zero_of_parity_corrected_unipotent monodromy parity _
    factorization involution (parityCommutes.smul_right _).exp_right
    (isNilpotent_exp_sub_one nilpotentResidue)

end ParityCorrection

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
