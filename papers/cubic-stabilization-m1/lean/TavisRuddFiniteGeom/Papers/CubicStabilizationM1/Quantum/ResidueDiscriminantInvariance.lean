import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankTwoResidueRigidity
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PowerSeriesLogarithmicVanishing
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.BlockDiagonalHorizontalPairing

/-!
# Invariance of the residue discriminant under frame change and along the base

The residue discriminant of a two-by-two residue matrix is
`(trace R) ^ 2 - 4 * det R`.  Two invariance properties are needed before it can
be read as an invariant of an ordinary Hodge atom rather than of a presentation.

The first is invariance under a change of frame.  Conjugating the residue by an
invertible matrix leaves both the trace and the determinant unchanged, so it
leaves the residue discriminant unchanged; combined with insensitivity to adding
a scalar multiple of the identity, this is the algebra behind the two
normalizations the manuscript performs, namely an isomorphism of atomic
`F`-bundles acting on the residue by conjugation and the trace centering applied
on both sides of such an isomorphism.

The second is constancy along the base.  Modified flatness makes each derivative
of the residue a commutator with a regular matrix, and a derivation annihilates
the residue discriminant of such a family.  In a formal power-series model of
the germ, over a characteristic-zero domain, that annihilation forces the
residue discriminant to be a constant series: a series all of whose formal
partial derivatives vanish has no coefficient outside the constant term, because
the coefficient of the derivative at one multi-index is a positive integer
multiple of the coefficient of the series one step higher in that variable.

To connect the two this module also proves the derivation calculus of the formal
partial derivative on multivariate formal power series: additivity, and the
Leibniz rule.  The Leibniz rule is the coefficient identity obtained by writing
the weight of a monomial of the product as the sum of the weights of its two
factors and reindexing each half of the resulting sum along the shift by one in
the differentiated variable.

Lean models the germ by a formal power-series ring and represents the residue by
a matrix over it.  It constructs no atomic `F`-bundle, spectral cover, or
elementary modification, and does not prove that a geometric isomorphism acts on
the residue by conjugation, that the modified flatness equation holds, or that
the formal model computes an analytic or rigid-analytic germ.  In particular the
gluing of local factors over a connected component of the spectral cover, and
the meromorphic extension across the locus where the leading operator
degenerates, are not represented.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

open Matrix MvPowerSeries

section FrameChange

variable {K : Type*} [CommRing K]

/-- The residue discriminant is unchanged by conjugation.  Here `P` and `Q` are
mutually inverse matrices, so `P * R * Q` is the residue written in a new frame;
conjugation preserves the trace and the determinant, hence the discriminant of
the characteristic polynomial. -/
theorem residueDiscriminant_conjugate (R P Q : Matrix (Fin 2) (Fin 2) K)
    (leftInverse : P * Q = 1) (rightInverse : Q * P = 1) :
    residueDiscriminant (P * R * Q) = residueDiscriminant R := by
  have traceEquality : Matrix.trace (P * R * Q) = Matrix.trace R := by
    rw [Matrix.trace_mul_comm (P * R) Q, ← Matrix.mul_assoc, rightInverse, Matrix.one_mul]
  have determinantUnit : P.det * Q.det = 1 := by
    rw [← Matrix.det_mul, leftInverse, Matrix.det_one]
  have determinantEquality : (P * R * Q).det = R.det := by
    rw [Matrix.det_mul, Matrix.det_mul]
    calc P.det * R.det * Q.det = P.det * Q.det * R.det := by ring
      _ = R.det := by rw [determinantUnit, one_mul]
  rw [residueDiscriminant, residueDiscriminant, traceEquality, determinantEquality]

/-- The residue discriminant is unchanged by a change of frame followed by a
scalar recentering of the residue.  These are exactly the two operations an
isomorphism of even rank-two atomic `F`-bundles performs on the residue of the
canonical elementary modification: conjugation by the value of the isomorphism,
and the trace centering applied on both sides. -/
theorem residueDiscriminant_conjugate_add_scalar (R P Q : Matrix (Fin 2) (Fin 2) K)
    (leftInverse : P * Q = 1) (rightInverse : Q * P = 1) (shift : K) :
    residueDiscriminant (P * R * Q + shift • (1 : Matrix (Fin 2) (Fin 2) K)) =
      residueDiscriminant R := by
  rw [residueDiscriminant_add_scalar, residueDiscriminant_conjugate R P Q leftInverse rightInverse]

end FrameChange

section FactorGluing

variable {K : Type*} [Field K]

/-- A change of frame that is block diagonal for a labelled splitting acts on
each factor by conjugation with the diagonal blocks, and those blocks are
mutually inverse.  This is what makes a conjugation-invariant expression formed
from one factor independent of the frame in which the factor is presented. -/
theorem labelBlock_conjugate_of_blockDiagonal {coordinate : Type*} [Fintype coordinate]
    [DecidableEq coordinate] {factorIndex : Type*} [DecidableEq factorIndex]
    {label : coordinate → factorIndex} (R P Q : Matrix coordinate coordinate K)
    (blockDiagonalFirst : ∀ row column, label row ≠ label column → P row column = 0)
    (blockDiagonalSecond : ∀ row column, label row ≠ label column → Q row column = 0)
    (leftInverse : P * Q = 1) (rightInverse : Q * P = 1) (value : factorIndex) :
    labelBlock (P * R * Q) label value value
        = labelBlock P label value value * labelBlock R label value value
          * labelBlock Q label value value ∧
      labelBlock P label value value * labelBlock Q label value value = 1 ∧
      labelBlock Q label value value * labelBlock P label value value = 1 := by
  have unitBlock : labelBlock (1 : Matrix coordinate coordinate K) label value value = 1 := by
    ext row column
    by_cases equal : row = column
    · subst equal; simp [labelBlock]
    · have distinct : (row : coordinate) ≠ (column : coordinate) := fun same =>
        equal (Subtype.ext same)
      simp [labelBlock, distinct, equal]
  refine ⟨?_, ?_, ?_⟩
  · rw [labelBlock_mul_of_blockDiagonal_right blockDiagonalSecond,
      labelBlock_mul_of_blockDiagonal_left blockDiagonalFirst]
  · rw [← labelBlock_mul_of_blockDiagonal_right blockDiagonalSecond, leftInverse, unitBlock]
  · rw [← labelBlock_mul_of_blockDiagonal_right blockDiagonalFirst, rightInverse, unitBlock]

/-- The residue discriminant of an even rank-two factor is unchanged by a
block-diagonal change of frame.  The factor is presented by a frame, a bijection
between a two-element index and the coordinates carrying the label; the change of
frame conjugates the factor block by mutually inverse blocks, and the residue
discriminant is conjugation invariant. -/
theorem residueDiscriminant_labelBlock_conjugate {coordinate : Type*} [Fintype coordinate]
    [DecidableEq coordinate] {factorIndex : Type*} [DecidableEq factorIndex]
    {label : coordinate → factorIndex} (R P Q : Matrix coordinate coordinate K)
    (blockDiagonalFirst : ∀ row column, label row ≠ label column → P row column = 0)
    (blockDiagonalSecond : ∀ row column, label row ≠ label column → Q row column = 0)
    (leftInverse : P * Q = 1) (rightInverse : Q * P = 1) (value : factorIndex)
    (frame : Fin 2 ≃ {index // label index = value}) :
    residueDiscriminant ((labelBlock (P * R * Q) label value value).submatrix frame frame)
      = residueDiscriminant ((labelBlock R label value value).submatrix frame frame) := by
  obtain ⟨conjugated, leftBlock, rightBlock⟩ :=
    labelBlock_conjugate_of_blockDiagonal R P Q blockDiagonalFirst blockDiagonalSecond
      leftInverse rightInverse value
  have unitFrame : Matrix.submatrix
      (1 : Matrix {index // label index = value} {index // label index = value} K)
      frame frame = 1 := by
    ext row column
    by_cases equal : row = column
    · subst equal; simp
    · have distinct : frame row ≠ frame column := fun same => equal (frame.injective same)
      simp [distinct, equal]
  rw [conjugated, ← Matrix.submatrix_mul_equiv _ _ frame frame frame,
    ← Matrix.submatrix_mul_equiv _ _ frame frame frame]
  refine residueDiscriminant_conjugate _ _ _ ?_ ?_
  · rw [Matrix.submatrix_mul_equiv _ _ frame frame frame, leftBlock, unitFrame]
  · rw [Matrix.submatrix_mul_equiv _ _ frame frame frame, rightBlock, unitFrame]

end FactorGluing

section FormalDerivationCalculus

variable {σ : Type*} {R : Type*} [CommRing R] [DecidableEq σ]

omit [DecidableEq σ] in
/-- The formal partial derivative is additive. -/
theorem formalPartialDerivative_add (i : σ) (F G : MvPowerSeries σ R) :
    formalPartialDerivative i (F + G)
      = formalPartialDerivative i F + formalPartialDerivative i G := by
  ext d
  simp [coeff_formalPartialDerivative, mul_add]

/-- Reindexing a weighted antidiagonal sum along the shift by one in the
variable `i` in the first component.  Summands whose first component has no
occurrence of `i` carry the weight zero, so the sum over the larger
antidiagonal is the shifted sum over the smaller one. -/
theorem sum_antidiagonal_firstWeight_shift (i : σ) (d : σ →₀ ℕ)
    (weight : (σ →₀ ℕ) × (σ →₀ ℕ) → R) :
    ∑ p ∈ (Finset.antidiagonal (d + Finsupp.single i 1) :
        Finset ((σ →₀ ℕ) × (σ →₀ ℕ))), ((p.1 i : ℕ) : R) * weight p
      = ∑ p ∈ (Finset.antidiagonal d : Finset ((σ →₀ ℕ) × (σ →₀ ℕ))),
        ((p.1 i + 1 : ℕ) : R) * weight (p.1 + Finsupp.single i 1, p.2) := by
  classical
  set shift : (σ →₀ ℕ) × (σ →₀ ℕ) → (σ →₀ ℕ) × (σ →₀ ℕ) :=
    fun p => (p.1 + Finsupp.single i 1, p.2) with shiftDefinition
  have imageSubset : (Finset.antidiagonal d).image shift ⊆
      Finset.antidiagonal (d + Finsupp.single i 1) := by
    intro p member
    simp only [Finset.mem_image] at member
    obtain ⟨q, memberQ, rfl⟩ := member
    rw [Finset.mem_antidiagonal] at memberQ ⊢
    simp [shiftDefinition, add_right_comm, memberQ]
  have vanishing : ∀ p ∈ Finset.antidiagonal (d + Finsupp.single i 1),
      p ∉ (Finset.antidiagonal d).image shift → ((p.1 i : ℕ) : R) * weight p = 0 := by
    intro p member notImage
    have firstZero : p.1 i = 0 := by
      by_contra nonzero
      refine notImage ?_
      rw [Finset.mem_antidiagonal] at member
      have singleLe : Finsupp.single i 1 ≤ p.1 := by
        intro j
        by_cases equal : j = i
        · subst equal; simpa using Nat.one_le_iff_ne_zero.mpr nonzero
        · simp [equal]
      refine Finset.mem_image.mpr ⟨(p.1 - Finsupp.single i 1, p.2), ?_, ?_⟩
      · rw [Finset.mem_antidiagonal]
        ext j
        have coordinate := congrArg (fun f => f j) member
        simp only [Finsupp.add_apply] at coordinate
        by_cases equal : j = i
        · subst equal
          have oneLe : Finsupp.single j 1 j ≤ p.1 j := singleLe j
          simp [Finsupp.add_apply, Finsupp.tsub_apply] at coordinate oneLe ⊢
          omega
        · have singleZero : (Finsupp.single i 1 : σ →₀ ℕ) j = 0 := by simp [equal]
          simp [Finsupp.add_apply, Finsupp.tsub_apply, singleZero] at coordinate ⊢
          omega
      · simp only [shiftDefinition]
        rw [tsub_add_cancel_of_le singleLe]
    rw [firstZero]
    simp
  rw [← Finset.sum_subset imageSubset vanishing,
    Finset.sum_image (fun p _ q _ equal => by simpa [shiftDefinition, Prod.ext_iff] using equal)]
  refine Finset.sum_congr rfl fun p _ => ?_
  simp [shiftDefinition]

/-- The same reindexing in the second component, obtained from the first by the
symmetry of the antidiagonal. -/
theorem sum_antidiagonal_secondWeight_shift (i : σ) (d : σ →₀ ℕ)
    (weight : (σ →₀ ℕ) × (σ →₀ ℕ) → R) :
    ∑ p ∈ (Finset.antidiagonal (d + Finsupp.single i 1) :
        Finset ((σ →₀ ℕ) × (σ →₀ ℕ))), ((p.2 i : ℕ) : R) * weight p
      = ∑ p ∈ (Finset.antidiagonal d : Finset ((σ →₀ ℕ) × (σ →₀ ℕ))),
        ((p.2 i + 1 : ℕ) : R) * weight (p.1, p.2 + Finsupp.single i 1) := by
  have larger := Finsupp.sum_antidiagonal_swap (d + Finsupp.single i 1)
    (fun first second => ((second i : ℕ) : R) * weight (first, second))
  have smaller := Finsupp.sum_antidiagonal_swap d
    (fun first second => ((second i + 1 : ℕ) : R) * weight (first, second + Finsupp.single i 1))
  rw [larger, smaller]
  exact sum_antidiagonal_firstWeight_shift i d (fun p => weight (p.2, p.1))

/-- The Leibniz rule for the formal partial derivative.  At each multi-index the
weight of the differentiated variable in a monomial of the product is the sum of
its weights in the two factors, and each half of the resulting sum reindexes
along the shift by one in that variable. -/
theorem formalPartialDerivative_mul (i : σ) (F G : MvPowerSeries σ R) :
    formalPartialDerivative i (F * G)
      = formalPartialDerivative i F * G + F * formalPartialDerivative i G := by
  ext d
  rw [coeff_formalPartialDerivative, MvPowerSeries.coeff_mul, map_add,
    MvPowerSeries.coeff_mul, MvPowerSeries.coeff_mul, Finset.mul_sum]
  have split : ∀ p ∈ (Finset.antidiagonal (d + Finsupp.single i 1) :
      Finset ((σ →₀ ℕ) × (σ →₀ ℕ))),
      ((d i + 1 : ℕ) : R) * (coeff p.1 F * coeff p.2 G)
        = ((p.1 i : ℕ) : R) * (coeff p.1 F * coeff p.2 G)
          + ((p.2 i : ℕ) : R) * (coeff p.1 F * coeff p.2 G) := by
    intro p member
    rw [Finset.mem_antidiagonal] at member
    have coordinate : p.1 i + p.2 i = d i + 1 := by
      have := congrArg (fun f => f i) member
      simpa using this
    rw [← add_mul, ← Nat.cast_add, coordinate]
  rw [Finset.sum_congr rfl split, Finset.sum_add_distrib,
    sum_antidiagonal_firstWeight_shift i d (fun p => coeff p.1 F * coeff p.2 G),
    sum_antidiagonal_secondWeight_shift i d (fun p => coeff p.1 F * coeff p.2 G)]
  refine congrArg₂ (· + ·) (Finset.sum_congr rfl fun p _ => ?_)
    (Finset.sum_congr rfl fun p _ => ?_)
  · rw [coeff_formalPartialDerivative]
    ring
  · rw [coeff_formalPartialDerivative]
    ring

end FormalDerivationCalculus

section Constancy

variable {σ : Type*} [DecidableEq σ] {K : Type*} [CommRing K] [IsDomain K] [CharZero K]

/-- A formal power series over a characteristic-zero domain all of whose formal
partial derivatives vanish has no coefficient outside the constant term.  At a
nonzero multi-index some variable occurs; the coefficient of the derivative in
that variable, one step lower, is a positive integer multiple of the coefficient
in question. -/
theorem coeff_eq_zero_of_formalPartialDerivative_eq_zero {F : MvPowerSeries σ K}
    (vanishing : ∀ i, formalPartialDerivative i F = 0) {d : σ →₀ ℕ} (nonzero : d ≠ 0) :
    coeff d F = 0 := by
  obtain ⟨i, occurs⟩ : ∃ i, d i ≠ 0 := by
    by_contra absent
    push Not at absent
    exact nonzero (Finsupp.ext absent)
  have singleLe : Finsupp.single i 1 ≤ d := by
    intro j
    by_cases equal : j = i
    · subst equal; simpa using Nat.one_le_iff_ne_zero.mpr occurs
    · simp [equal]
  have lowered : (d - Finsupp.single i 1) + Finsupp.single i 1 = d :=
    tsub_add_cancel_of_le singleLe
  have derivativeCoefficient := congrArg (fun G => coeff (d - Finsupp.single i 1) G) (vanishing i)
  rw [coeff_formalPartialDerivative, lowered] at derivativeCoefficient
  simp only [map_zero] at derivativeCoefficient
  have positive : (((d - Finsupp.single i 1 : σ →₀ ℕ) i + 1 : ℕ) : K) ≠ 0 :=
    Nat.cast_ne_zero.mpr (Nat.succ_ne_zero _)
  exact (mul_eq_zero.mp derivativeCoefficient).resolve_left positive

/-- Such a series is the constant series with its own constant coefficient. -/
theorem eq_constant_of_formalPartialDerivative_eq_zero {F : MvPowerSeries σ K}
    (vanishing : ∀ i, formalPartialDerivative i F = 0) :
    F = MvPowerSeries.C (MvPowerSeries.constantCoeff F) := by
  ext d
  by_cases zero : d = 0
  · subst zero
    simp
  · rw [coeff_eq_zero_of_formalPartialDerivative_eq_zero vanishing zero, coeff_C, if_neg zero]

/-- The residue discriminant of a residue family over a formal germ that
satisfies the modified flatness equation is a constant series.  The hypothesis is
that each formal partial derivative of the residue is its commutator with a
matrix regular in the germ, which is what modified flatness asserts in each base
direction; the conclusion is that the residue discriminant does not vary over the
germ. -/
theorem residueDiscriminant_eq_constant_of_commutatorDerivative
    (residue : Matrix (Fin 2) (Fin 2) (MvPowerSeries σ K))
    (regular : σ → Matrix (Fin 2) (Fin 2) (MvPowerSeries σ K))
    (flatness : ∀ i, residue.map (formalPartialDerivative i)
      = regular i * residue - residue * regular i) :
    residueDiscriminant residue
      = MvPowerSeries.C (MvPowerSeries.constantCoeff (residueDiscriminant residue)) := by
  refine eq_constant_of_formalPartialDerivative_eq_zero fun i => ?_
  exact lax_residueDiscriminant_map_eq_zero (formalPartialDerivative_add i)
    (formalPartialDerivative_mul i) residue (regular i) (flatness i)

end Constancy

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
