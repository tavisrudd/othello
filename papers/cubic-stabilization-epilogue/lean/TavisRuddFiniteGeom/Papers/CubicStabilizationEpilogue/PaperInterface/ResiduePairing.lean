import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Applications.CubicZeroAtomRanks
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Applications.ProjectiveProductMultiplicity
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Applications.RelativeSixAxis
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.IntegralDiscriminantGroup
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisDiscriminantGroup
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisMarkedPresentation
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisPrimaryDiscriminantSplitting
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisSourcePolarization
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixPointAxisTransport
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.AssociatedGradedTagging
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.AtomicResidueDiscriminant
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.BlockDiagonalHorizontalPairing
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.BlockSylvesterSolvability
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.CompletedNovikovConvolution
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.EffectiveBlockLedger
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FilteredCoefficientQuotients
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.HirzebruchEulerSpectrum
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.HodgeFixedSubalgebra
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.ModuleSpectrumTransfer
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.NormalizedSylvesterGauge
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.OrthogonalRestrictionNondegeneracy
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.PairingHorizontality
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.PowerSeriesLogarithmicVanishing
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.QuarticDiscriminantDerivations
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.RankTwoResidueMarker
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.ResidueDiscriminantInvariance
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.SeparatedSpectralPairing
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.SpectralSignReversal
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.SylvesterOperator

/-!
# Residue and pairing machinery

Auxiliary residue-discriminant, spectral-pairing, atomic-model, and six-axis pairing calculations.  Geometric and literature inputs remain explicit in the declaration types.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

open TensorProduct

open scoped MatrixGroups

/-- The discriminant pairing of the six-axis source polarization on integral
representatives, and its nondegeneracy.  On the classes of two integral
vectors the pairing is the class modulo one of the rational number
`(1/6⁸)·xᵀ adj(A) y`, where `A` is the integral source polarization, so it
vanishes exactly when `6⁸` divides that integral numerator; and a class pairing
to zero with every class is zero.  This is the discriminant pairing of the
lattice, not the commutator pairing of a polarized abelian scheme, which is not
constructed. -/
theorem sixAxisSourceDiscriminantPairing_values_and_nondegeneracy :
    (∀ left right : Fin 5 × Fin 2 → ℤ,
        GraphLattices.sixAxisSourceDiscriminantPairing (Submodule.Quotient.mk left)
            (Submodule.Quotient.mk right) =
          Submodule.Quotient.mk
            (GraphLattices.discriminantValue (GraphLattices.sixAxisSourcePolarization ℤ)
              left right)) ∧
      (∀ left right : Fin 5 × Fin 2 → ℤ,
        GraphLattices.sixAxisSourceDiscriminantPairing (Submodule.Quotient.mk left)
              (Submodule.Quotient.mk right) = 0 ↔
          (6 : ℤ) ^ 8 ∣
            dotProduct left
              ((GraphLattices.sixAxisSourcePolarization ℤ).adjugate.mulVec right)) ∧
      ∀ element : GraphLattices.sixAxisSourceDiscriminantGroup,
        (∀ other : GraphLattices.sixAxisSourceDiscriminantGroup,
            GraphLattices.sixAxisSourceDiscriminantPairing element other = 0) →
          element = 0 :=
  ⟨fun left right ↦
      GraphLattices.discriminantPairing_mk (GraphLattices.sixAxisSourcePolarization_transpose ℤ)
        GraphLattices.sixAxisSourcePolarization_det_ne_zero left right,
    fun left right ↦ by
      rw [← GraphLattices.sixAxisSourcePolarization_det]
      exact GraphLattices.discriminantPairing_mk_eq_zero_iff
        (GraphLattices.sixAxisSourcePolarization_transpose ℤ)
        GraphLattices.sixAxisSourcePolarization_det_ne_zero left right,
    fun _ orthogonal ↦
      GraphLattices.sixAxisSourceDiscriminantPairing_eq_zero_of_forall orthogonal⟩
/-- Reviewer-facing invariance of the residue discriminant under a change of
frame and a scalar recentering of the residue.  Conjugating a residue by
mutually inverse matrices preserves its trace and its determinant, hence its
residue discriminant, and adding any scalar multiple of the identity afterwards
changes nothing further.  These are the two operations an isomorphism of even
rank-two atomic `F`-bundles performs on the residue of the canonical elementary
modification: conjugation by the value of the isomorphism, and the trace
centering applied on both sides.

Lean constructs no atomic `F`-bundle, no isomorphism of such, and no elementary
modification, and does not prove that an isomorphism acts on the residue by
conjugation; the statement is matrix algebra over an arbitrary commutative
ring. -/
theorem atomicResidueDiscriminant_invariant_under_frame_change
    {K : Type*} [CommRing K] (R P Q : Matrix (Fin 2) (Fin 2) K)
    (leftInverse : P * Q = 1) (rightInverse : Q * P = 1) (shift : K) :
    Quantum.residueDiscriminant (P * R * Q) = Quantum.residueDiscriminant R ∧
      Quantum.residueDiscriminant (P * R * Q + shift • (1 : Matrix (Fin 2) (Fin 2) K)) =
        Quantum.residueDiscriminant R :=
  ⟨Quantum.residueDiscriminant_conjugate R P Q leftInverse rightInverse,
    Quantum.residueDiscriminant_conjugate_add_scalar R P Q leftInverse rightInverse shift⟩
/-- Reviewer-facing independence of a factor's residue discriminant from the
frame in which the factor is presented.  A change of frame that is block diagonal
for a labelled splitting restricts on each factor to conjugation by the diagonal
blocks of the two mutually inverse matrices, and those blocks are again mutually
inverse; for an even factor of rank two, presented by a bijection between a
two-element index and the coordinates carrying the label, the residue
discriminant of the factor is therefore unchanged.  This is why a
conjugation-invariant expression formed from one factor is well defined
independently of the block-diagonal frame chosen for it.

Lean does not construct the local factors of an `F`-bundle over a component of a
spectral cover, and does not prove that they glue; the transition data enter as a
block-diagonal pair of mutually inverse matrices. -/
theorem atomicFactor_residueDiscriminant_invariant_under_blockDiagonal_frame_change
    {K : Type*} [Field K] {coordinate : Type*} [Fintype coordinate] [DecidableEq coordinate]
    {factorIndex : Type*} [DecidableEq factorIndex] {label : coordinate → factorIndex}
    (R P Q : Matrix coordinate coordinate K)
    (blockDiagonalFirst : ∀ row column, label row ≠ label column → P row column = 0)
    (blockDiagonalSecond : ∀ row column, label row ≠ label column → Q row column = 0)
    (leftInverse : P * Q = 1) (rightInverse : Q * P = 1) (value : factorIndex) :
    (Quantum.labelBlock (P * R * Q) label value value
        = Quantum.labelBlock P label value value * Quantum.labelBlock R label value value
          * Quantum.labelBlock Q label value value ∧
      Quantum.labelBlock P label value value * Quantum.labelBlock Q label value value = 1 ∧
      Quantum.labelBlock Q label value value * Quantum.labelBlock P label value value = 1) ∧
      ∀ frame : Fin 2 ≃ {index // label index = value},
        Quantum.residueDiscriminant
            ((Quantum.labelBlock (P * R * Q) label value value).submatrix frame frame)
          = Quantum.residueDiscriminant
            ((Quantum.labelBlock R label value value).submatrix frame frame) :=
  ⟨Quantum.labelBlock_conjugate_of_blockDiagonal R P Q blockDiagonalFirst blockDiagonalSecond
      leftInverse rightInverse value,
    fun frame => Quantum.residueDiscriminant_labelBlock_conjugate R P Q blockDiagonalFirst
      blockDiagonalSecond leftInverse rightInverse value frame⟩
/-- Reviewer-facing constancy of the residue discriminant over a formal germ of
the base.  The residue is a two-by-two matrix over a multivariate formal
power-series ring over a characteristic-zero domain, and modified flatness enters
as the hypothesis that each formal partial derivative of the residue is its
commutator with a matrix regular in the germ.  Then the residue discriminant is
the constant series with its own constant coefficient: a derivation annihilates
the residue discriminant of a family satisfying that commutator equation, and a
series all of whose formal partial derivatives vanish has no coefficient outside
the constant term, because the coefficient of a derivative is a positive integer
multiple of a coefficient of the series.

Lean models the germ by a formal power-series ring.  It constructs no analytic or
rigid-analytic germ, no spectral cover and no connected component of one, and
proves neither the meromorphic extension across the locus where the leading
operator degenerates nor the identification of the formal model with a geometric
germ. -/
theorem atomicResidueDiscriminant_constant_on_formal_germ
    {σ : Type*} [DecidableEq σ] {K : Type*} [CommRing K] [IsDomain K] [CharZero K]
    (residue : Matrix (Fin 2) (Fin 2) (MvPowerSeries σ K))
    (regular : σ → Matrix (Fin 2) (Fin 2) (MvPowerSeries σ K))
    (flatness : ∀ i, residue.map (Quantum.formalPartialDerivative i)
      = regular i * residue - residue * regular i) :
    Quantum.residueDiscriminant residue
        = MvPowerSeries.C (MvPowerSeries.constantCoeff (Quantum.residueDiscriminant residue)) ∧
      ∀ d : σ →₀ ℕ, d ≠ 0 →
        MvPowerSeries.coeff d (Quantum.residueDiscriminant residue) = 0 := by
  have constant := Quantum.residueDiscriminant_eq_constant_of_commutatorDerivative residue regular
    flatness
  refine ⟨constant, fun d nonzero => ?_⟩
  rw [constant, MvPowerSeries.coeff_C, if_neg nonzero]
/-- Reviewer-facing block diagonality of a horizontal pairing on two spectral
factors with distinct leading eigenvalues.  The first clause is the Sylvester
step: the equation satisfied by an off-diagonal pairing coefficient at the
leading order has only the zero solution when the two leading operators differ
by a unit scalar and are otherwise nilpotent.  The second is the induction over
the remaining orders, whose right-hand sides vanish once all strictly earlier
coefficients do.  The third is the nondegeneracy consequence: a pairing with
vanishing off-diagonal blocks is invertible exactly when both diagonal
restrictions are.

Lean does not construct the `F`-bundle, the spectral splitting, the connection,
or the pairing, and does not derive the order-by-order equations from
horizontality.  The refinement to the even part of a factor, which uses that the
Poincare pairing pairs only equal parities, is not part of this statement. -/
theorem separatedSpectralFactors_pairing_blockDiagonal
    {K : Type*} [Field K] {leftRank rightRank : ℕ}
    {leftOperator : Matrix (Fin leftRank) (Fin leftRank) K}
    {rightOperator : Matrix (Fin rightRank) (Fin rightRank) K}
    {leftEigenvalue rightEigenvalue : K}
    (separated : leftEigenvalue ≠ rightEigenvalue)
    (leftNilpotent : IsNilpotent (leftOperator - leftEigenvalue • 1))
    (rightNilpotent : IsNilpotent (rightOperator - rightEigenvalue • 1)) :
    (∀ block : Matrix (Fin leftRank) (Fin rightRank) K,
        leftOperator.transpose * block = block * rightOperator → block = 0) ∧
      (∀ coefficient rightHandSide : ℕ → Matrix (Fin leftRank) (Fin rightRank) K,
        (∀ order, leftOperator.transpose * coefficient order -
            coefficient order * rightOperator = rightHandSide order) →
          (∀ order, (∀ smaller, smaller < order → coefficient smaller = 0) →
            rightHandSide order = 0) →
            ∀ order, coefficient order = 0) ∧
      (∀ (leftBlock : Matrix (Fin leftRank) (Fin leftRank) K)
          (rightBlock : Matrix (Fin rightRank) (Fin rightRank) K),
        (Matrix.fromBlocks leftBlock 0 0 rightBlock).det ≠ 0 ↔
          leftBlock.det ≠ 0 ∧ rightBlock.det ≠ 0) :=
  ⟨fun _ sylvester =>
      Quantum.sylvester_eq_zero_of_separated_eigenvalues separated leftNilpotent
        rightNilpotent sylvester,
    fun coefficient rightHandSide system earlierOrders =>
      Quantum.offDiagonalCoefficients_eq_zero separated leftNilpotent rightNilpotent
        coefficient rightHandSide system earlierOrders,
    Quantum.blockDiagonal_det_ne_zero_iff⟩
/-- Reviewer-facing horizontality of a constant pairing for a connection with a
simple pole.  In the standard cohomology frame the inverse Gram matrix of the
Poincare form is constant, quantum multiplication operators are self-adjoint for
that form by the Frobenius property, and the grading operator is
anti-self-adjoint because Poincare duality pairs complementary cohomological
degrees.  Substituting those two identities into the connection matrix, whose
residue is a quantum multiplication operator and whose regular part is the
grading operator in degree zero and vanishes in higher degrees, makes every
coefficient of the sesquilinear horizontality identity vanish.  The first clause
is the loop direction `u ∂_u`; the second is any base direction, whose
derivation annihilates the constant pairing, and in particular the case in which
the connection matrix has no regular part.

Lean constructs neither the quantum product, the Poincare pairing, nor the
grading operator, and proves neither the Frobenius property nor the
degree-pairing property: self-adjointness of the residue and anti-self-adjointness
of the regular part are hypotheses about matrices.  No convergence and no
analytic structure are represented; the statement is an identity of formal
coefficients. -/
theorem quantumPairing_horizontality_of_selfAdjoint_multiplication
    {R : Type*} [CommRing R] {rank : ℕ}
    {multiplication grading pairingValue : Matrix (Fin rank) (Fin rank) R}
    {regular pairing : ℕ → Matrix (Fin rank) (Fin rank) R}
    (regularLeading : regular 0 = grading)
    (regularHigher : ∀ order, regular (order + 1) = 0)
    (pairingLeading : pairing 0 = pairingValue)
    (pairingHigher : ∀ order, pairing (order + 1) = 0)
    (selfAdjointMultiplication :
      multiplication.transpose * pairingValue = pairingValue * multiplication)
    (antiSelfAdjointGrading :
      grading.transpose * pairingValue = -(pairingValue * grading)) :
    (∀ order, Quantum.loopPairingHorizontalityCoefficient multiplication regular
        multiplication regular pairing order = 0) ∧
      ∀ derivative : ℕ → Matrix (Fin rank) (Fin rank) R,
        (∀ order, derivative order = 0) →
          ∀ order, Quantum.pairingHorizontalityCoefficient multiplication regular
            multiplication regular pairing derivative order = 0 :=
  ⟨Quantum.constantPairing_loopHorizontality_of_selfAdjoint regularLeading regularHigher
      pairingLeading pairingHigher selfAdjointMultiplication antiSelfAdjointGrading,
    fun _ derivativeVanishing =>
      Quantum.constantPairing_horizontality_of_selfAdjoint regularLeading regularHigher
        pairingLeading pairingHigher derivativeVanishing selfAdjointMultiplication
        antiSelfAdjointGrading⟩
/-- Reviewer-facing vanishing of the pairing between two spectral factors with
separated leading eigenvalues, derived from horizontality.  Each residue is a
scalar multiple of the identity plus a nilpotent matrix, and the two scalars are
distinct.  Under vanishing of every coefficient of the sesquilinear
horizontality identity between the two factors, every coefficient of the pairing
between them vanishes: the coefficient of `u ^ (-1)` is a Sylvester equation
whose operator is invertible because the difference of the scalars is a unit and
the remaining parts are nilpotent, and the coefficient of each later power is
the same Sylvester equation with a remainder built from strictly earlier pairing
coefficients.  The direction's derivation is assumed only to annihilate a
vanishing pairing coefficient, which holds for the loop direction `u ∂_u` and
for a derivation in a base direction.

Lean constructs neither the `F`-bundle, the spectral splitting, the connection,
nor the pairing.  The refinement to the even part of a factor, which uses that
the Poincare pairing pairs only equal parities, is not part of this
statement. -/
theorem separatedSpectralFactors_pairing_eq_zero_of_horizontality
    {K : Type*} [Field K] {leftRank rightRank : ℕ}
    {leftResidue : Matrix (Fin leftRank) (Fin leftRank) K}
    {leftRegular : ℕ → Matrix (Fin leftRank) (Fin leftRank) K}
    {rightResidue : Matrix (Fin rightRank) (Fin rightRank) K}
    {rightRegular : ℕ → Matrix (Fin rightRank) (Fin rightRank) K}
    {pairing derivative : ℕ → Matrix (Fin leftRank) (Fin rightRank) K}
    {leftEigenvalue rightEigenvalue : K}
    (separated : leftEigenvalue ≠ rightEigenvalue)
    (leftNilpotent : IsNilpotent (leftResidue - leftEigenvalue • 1))
    (rightNilpotent : IsNilpotent (rightResidue - rightEigenvalue • 1))
    (derivativeVanishing : ∀ order, pairing order = 0 → derivative order = 0)
    (horizontal : ∀ order, Quantum.pairingHorizontalityCoefficient leftResidue leftRegular
      rightResidue rightRegular pairing derivative order = 0) :
    ∀ order, pairing order = 0 :=
  Quantum.offDiagonalPairing_eq_zero_of_horizontality separated leftNilpotent rightNilpotent
    derivativeVanishing horizontal
/-- Reviewer-facing block diagonality of a horizontal pairing for a labelled
spectral splitting with pairwise distinct leading eigenvalues, together with the
nondegeneracy statements it produces.  A splitting into local factors is
recorded by a label on the coordinates; a block-diagonalizing frame is the
hypothesis that the residue and every regular coefficient of the connection
vanish on entries whose row and column carry different labels; and the residue
restricted to the coordinates of one label is that label's eigenvalue plus a
nilpotent matrix.

The first conclusion is that every coefficient of the pairing vanishes on every
entry whose row and column carry different labels: the block of the
horizontality identity between two labels is the two-factor horizontality
identity of the corresponding blocks, whose Sylvester induction forces the
off-diagonal block to vanish order by order.  The second is that, when the
leading pairing coefficient is nondegenerate and pairs only coordinates of equal
parity, its restriction to the coordinates of one label, and its restriction to
those of one label and even parity, are again nondegenerate.

Lean constructs neither the `F`-bundle, the spectral splitting, the connection,
the cohomological grading, nor the Poincare pairing.  Horizontality is vanishing
of the coefficients of a formal identity between matrix families, the parity of a
coordinate is an arbitrary function to `ZMod 2` with `0` naming the even
coordinates, and nondegeneracy is nonvanishing of a determinant. -/
theorem separatedSpectralFactors_labelledPairing_blockDiagonal_of_horizontality
    {K : Type*} [Field K] {coordinate : Type*} [Fintype coordinate] [DecidableEq coordinate]
    {factorIndex : Type*} [DecidableEq factorIndex] {label : coordinate → factorIndex}
    {residue : Matrix coordinate coordinate K}
    {regular pairing derivative : ℕ → Matrix coordinate coordinate K}
    {eigenvalue : factorIndex → K} {parity : coordinate → ZMod 2}
    (separated : Function.Injective eigenvalue)
    (residueBlockDiagonal : ∀ row column, label row ≠ label column → residue row column = 0)
    (regularBlockDiagonal : ∀ order row column,
      label row ≠ label column → regular order row column = 0)
    (nilpotent : ∀ value : factorIndex,
      IsNilpotent (Quantum.labelBlock residue label value value - eigenvalue value • 1))
    (derivativeVanishing : ∀ order row column,
      pairing order row column = 0 → derivative order row column = 0)
    (horizontal : ∀ order, Quantum.pairingHorizontalityCoefficient residue regular residue
      regular pairing derivative order = 0)
    (parityOrthogonal : ∀ row column, parity row ≠ parity column → pairing 0 row column = 0)
    (leadingNondegenerate : (pairing 0).det ≠ 0) :
    (∀ order row column, label row ≠ label column → pairing order row column = 0) ∧
      ∀ value : factorIndex,
        (Quantum.restrictToCoordinates (pairing 0) fun index => label index = value).det ≠ 0 ∧
          (Quantum.restrictToCoordinates (pairing 0)
            fun index => label index = value ∧ parity index = 0).det ≠ 0 := by
  have blockDiagonal : ∀ order row column,
      label row ≠ label column → pairing order row column = 0 :=
    fun order row column different =>
      Quantum.labelledPairing_eq_zero_of_horizontality separated residueBlockDiagonal
        regularBlockDiagonal nilpotent derivativeVanishing horizontal order row column different
  exact ⟨blockDiagonal, fun value =>
    ⟨Quantum.det_restrictToLabelFiber_ne_zero (blockDiagonal 0) leadingNondegenerate value,
      Quantum.det_restrictToEvenPartOfFactor_ne_zero (blockDiagonal 0) parityOrthogonal
        leadingNondegenerate value⟩⟩
/-- Reviewer-facing nondegeneracy of a block-diagonal pairing on one spectral
factor and on the even part of that factor.  The pairing vanishes on entries
whose row and column carry different factor labels, which is block diagonality
for the splitting, and on entries whose row and column carry different
cohomological parities, which is the statement that the Poincare form pairs only
classes of equal parity.  A nondegenerate such pairing restricts nondegenerately
to the coordinates of one factor, and to the coordinates of one factor and even
parity: a nonzero vector in the kernel of a restriction extends by zero to a
nonzero kernel vector of the whole pairing.  Reindexing along any bijection
between `Fin rank` and the even coordinates of the factor preserves the
determinant, which supplies the invertibility hypothesis of the rank-two residue
rigidity argument for an even factor of rank two.

Lean constructs no `F`-bundle, spectral splitting, cohomological grading, or
Poincare pairing; block diagonality and the parity behaviour are hypotheses
about a matrix, the label and the parity are arbitrary functions with `0` naming
the even coordinates, and nondegeneracy is nonvanishing of a determinant. -/
theorem separatedSpectralFactors_evenPart_pairing_nondegenerate
    {K : Type*} [Field K] {coordinate : Type*} [Fintype coordinate] [DecidableEq coordinate]
    {factorIndex : Type*} [DecidableEq factorIndex] {label : coordinate → factorIndex}
    {parity : coordinate → ZMod 2} {pairing : Matrix coordinate coordinate K}
    (blockDiagonal : ∀ row column, label row ≠ label column → pairing row column = 0)
    (parityOrthogonal : ∀ row column, parity row ≠ parity column → pairing row column = 0)
    (nondegenerate : pairing.det ≠ 0) (value : factorIndex) :
    (Quantum.restrictToCoordinates pairing fun index => label index = value).det ≠ 0 ∧
      (Quantum.restrictToCoordinates pairing
        fun index => label index = value ∧ parity index = 0).det ≠ 0 ∧
      (Quantum.restrictToCoordinates pairing
        fun index => label index = value ∧ parity index = 0).Nondegenerate ∧
      ∀ (rank : ℕ) (frame : Fin rank ≃ {index // label index = value ∧ parity index = 0}),
        (pairing.submatrix (fun position => (frame position).val)
          (fun position => (frame position).val)).det ≠ 0 := by
  have evenPart : (Quantum.restrictToCoordinates pairing
      fun index => label index = value ∧ parity index = 0).det ≠ 0 :=
    Quantum.det_restrictToEvenPartOfFactor_ne_zero blockDiagonal parityOrthogonal
      nondegenerate value
  exact ⟨Quantum.det_restrictToLabelFiber_ne_zero blockDiagonal nondegenerate value, evenPart,
    Matrix.nondegenerate_iff_det_ne_zero.mpr evenPart,
    fun _ frame => Quantum.det_frameSubmatrix_ne_zero frame evenPart⟩
/-- Reviewer-facing witness that distinctness of the leading eigenvalues cannot
be dropped from block diagonality of a horizontal pairing.  For any scalar there
are two one-dimensional factors whose connections have that same scalar residue
and vanishing regular part, and a pairing between them, constant with invertible
leading coefficient, satisfying every coefficient of the sesquilinear
horizontality identity while being nonzero.  The two residue terms cancel
because the residues are equal scalars, and every remaining term contains a
vanishing regular or pairing coefficient.

This exhibits the failure of the conclusion, not of the manuscript proof: the
Sylvester operator of the leading order is invertible precisely because the
difference of the two scalars is a unit. -/
theorem separatedSpectralFactors_equalEigenvalues_admit_nonzero_horizontalPairing
    {K : Type*} [Field K] (eigenvalue : K) :
    ∃ (residue : Matrix (Fin 1) (Fin 1) K)
      (regular pairing derivative : ℕ → Matrix (Fin 1) (Fin 1) K),
      IsNilpotent (residue - eigenvalue • 1) ∧
        (∀ order, pairing order = 0 → derivative order = 0) ∧
        (∀ order, Quantum.pairingHorizontalityCoefficient residue regular residue regular
          pairing derivative order = 0) ∧
        pairing 0 ≠ 0 :=
  Quantum.equalEigenvalues_admit_nonzero_horizontalPairing eigenvalue
/-- Reviewer-facing identification of the discriminant of a monic quartic with
the squared product of the pairwise differences of its roots.  The coefficients
are the signed elementary symmetric functions of `r₀, r₁, r₂, r₃`, so the
identity says that the universal discriminant polynomial of
`T ^ 4 + l₃ T ^ 3 + l₂ T ^ 2 + l₁ T + l₀` computes the squared separation of the
four roots whenever the quartic splits.  This holds over an arbitrary
commutative ring. -/
theorem quarticDiscriminant_eq_squared_root_differences {A : Type*} [CommRing A]
    (r₀ r₁ r₂ r₃ : A) :
    Quantum.quarticDiscriminant (r₀ * r₁ * r₂ * r₃)
        (-(r₀ * r₁ * r₂ + r₀ * r₁ * r₃ + r₀ * r₂ * r₃ + r₁ * r₂ * r₃))
        (r₀ * r₁ + r₀ * r₂ + r₀ * r₃ + r₁ * r₂ + r₁ * r₃ + r₂ * r₃)
        (-(r₀ + r₁ + r₂ + r₃)) =
      ((r₀ - r₁) * (r₀ - r₂) * (r₀ - r₃) * (r₁ - r₂) * (r₁ - r₃) * (r₂ - r₃)) ^ 2 :=
  Quantum.quarticDiscriminant_eq_squared_root_differences r₀ r₁ r₂ r₃
/-- Reviewer-facing logarithmic derivatives of the discriminant of the
characteristic polynomial of Euler multiplication along the canonical frame of a
regular four-dimensional `F`-manifold.  The unit field annihilates the
discriminant, the Euler field multiplies it by twelve, and the second and third
powers of the Euler field multiply it by `-6 l₃` and by `6 l₃ ^ 2 - 10 l₂`.

The hypotheses are carried by `Quantum.EulerCoefficientFrame`: four elements of a
commutative ring, playing the role of the characteristic coefficients, four
derivations of that ring, playing the role of the canonical frame, and the
sixteen coefficient identities forced by Cayley--Hamilton and the Witt relations
of a regular `F`-manifold.  Lean constructs no `F`-manifold, tangent sheaf, or
Euler field, and derives none of those sixteen identities from geometry. -/
theorem eulerFrame_discriminant_logarithmicDerivatives {A : Type*} [CommRing A]
    (S : Quantum.EulerCoefficientFrame A) :
    S.frameField 0 S.discriminant = 0 ∧
      S.frameField 1 S.discriminant = 12 * S.discriminant ∧
        S.frameField 2 S.discriminant = -6 * S.lam3 * S.discriminant ∧
          S.frameField 3 S.discriminant =
            (6 * S.lam3 ^ 2 - 10 * S.lam2) * S.discriminant :=
  S.frameField_discriminant
/-- Reviewer-facing form of the statement that the differential of the
discriminant is the discriminant times a regular one-form.  Any operator written
as a ring-coefficient combination of the canonical frame multiplies the
discriminant by the corresponding combination of the four logarithmic factors,
so on a manifold where the canonical frame is a frame every coordinate
derivative of the discriminant is a multiple of the discriminant. -/
theorem eulerFrame_discriminant_differential {A : Type*} [CommRing A]
    (S : Quantum.EulerCoefficientFrame A) (D : A → A) (c : Fin 4 → A)
    (frame : ∀ x, D x = ∑ s, c s * S.frameField s x) :
    D S.discriminant =
      (12 * c 1 - 6 * S.lam3 * c 2 + (6 * S.lam3 ^ 2 - 10 * S.lam2) * c 3) * S.discriminant :=
  S.logarithmic_of_frame_combination D c frame
/-- Reviewer-facing vanishing of the discriminant on a formal germ.  The germ is
modelled by the ring of formal power series in the variables `σ` over a
commutative domain of characteristic zero; the canonical frame is assumed to
express every formal partial derivative with power-series coefficients, which is
the regularity of Euler multiplication at the base point; and the discriminant
is assumed to vanish at the base point, that is, to have zero constant
coefficient.  Then the discriminant is the zero power series.

Lean does not construct an analytic or rigid-analytic germ, the isomorphism of a
completed local ring with a power-series ring, or the injection of a Noetherian
local ring into its completion. -/
theorem eulerFrame_discriminant_eq_zero_of_vanishing_at_base_point {K σ : Type*}
    [CommRing K] [NoZeroDivisors K] [CharZero K]
    (S : Quantum.EulerCoefficientFrame (MvPowerSeries σ K))
    (c : σ → Fin 4 → MvPowerSeries σ K)
    (frame : ∀ (i : σ) (F : MvPowerSeries σ K),
      Quantum.formalPartialDerivative i F = ∑ s, c i s * S.frameField s F)
    (vanishing : MvPowerSeries.coeff 0 S.discriminant = 0) :
    S.discriminant = 0 :=
  Quantum.EulerCoefficientFrame.discriminant_eq_zero_of_constantCoeff_eq_zero S c frame vanishing
/-- Reviewer-facing transfer of the spectrum of Euler multiplication from the
even part to the whole of cohomology.  For a finite-dimensional commutative
algebra `A` over a field, an element `E` of it, and a module `M` over `A` in
which some vector generates an injective copy of `A`, the eigenvalues of `E` on
`M` and on `A` are the same set.

In the application `A` is even quantum cohomology at an even point of the Hodge
base, `M` is the full cohomology of the same variety, which is a module over `A`
because the bulk point is even, and the generating vector is the unit of the
cohomology ring.  Lean constructs no quantum cohomology and no Euler field. -/
theorem eulerMultiplication_eigenvalues_module_eq_algebra {k A M : Type*} [Field k]
    [CommRing A] [Algebra k A] [FiniteDimensional k A] [AddCommGroup M] [Module A M]
    [Module k M] [IsScalarTower k A M] (E : A) (unit : M)
    (generating : Function.Injective fun b : A => b • unit) :
    {lam : k | ∃ m : M, m ≠ 0 ∧ E • m = lam • m} =
      {lam : k | ∃ a : A, a ≠ 0 ∧ E * a = lam • a} :=
  Quantum.eigenvalues_module_eq_eigenvalues_algebra E unit generating
/-- Reviewer-facing consistency witness for the frame data of the discriminant
lemma.  The sixteen coefficient identities collected in
`Quantum.EulerCoefficientFrame` are satisfied by the universal root model: the
polynomial ring in four root variables over the rationals, with characteristic
coefficients the signed elementary symmetric functions of those variables and
with the `s`-th frame field acting by the derivation `∑ᵢ μᵢ ^ s ∂/∂μᵢ`.  Each
result deduced from that frame data therefore has content. -/
theorem eulerFrame_data_nonempty :
    Nonempty (Quantum.EulerCoefficientFrame (MvPolynomial (Fin 4) ℚ)) :=
  ⟨Quantum.rootEulerFrame⟩
/-- Reviewer-facing correspondence of generalized eigenspaces under sign
reversal.  For an endomorphism `f` of a module over a commutative ring, a scalar
`lam`, and an exponent `k`, the kernel of the `k`-th power of `-f - (-lam)` is
the kernel of the `k`-th power of `f - lam`.

In the application `f` is Euler multiplication on the maximal `A`-model
`F`-bundle and `-f` is the residual endomorphism of the connection in the loop
coordinate.  The generalized eigenspace decompositions of the two operators
therefore correspond under negation of the eigenvalue, with the same summands and
the same filtration by the exponent, hence the same Jordan block sizes.  Lean
constructs no `F`-bundle and does not prove that the residual endomorphism is the
negative of Euler multiplication. -/
theorem eulerOperator_generalizedEigenspaces_under_sign_reversal {K V : Type*} [CommRing K]
    [AddCommGroup V] [Module K V] (f : Module.End K V) (lam : K) (k : ℕ) :
    LinearMap.ker ((-f - (-lam) • (1 : Module.End K V)) ^ k) =
      LinearMap.ker ((f - lam • (1 : Module.End K V)) ^ k) :=
  Quantum.generalizedEigenspace_neg f lam k
/-- Reviewer-facing count of eigenvalues under sign reversal.  The eigenvalue set
of the negated endomorphism is the image under negation of the eigenvalue set of
the original one, and the two sets have the same cardinality.  This is the
statement that the residual endomorphism and Euler multiplication have the same
number of distinct eigenvalues, with reduced spectral covers identified by
negation. -/
theorem eulerOperator_eigenvalue_count_under_sign_reversal {K V : Type*} [CommRing K]
    [AddCommGroup V] [Module K V] (f : Module.End K V) :
    {mu : K | ∃ v : V, v ≠ 0 ∧ (-f) v = mu • v} =
        Neg.neg '' {lam : K | ∃ v : V, v ≠ 0 ∧ f v = lam • v} ∧
      {mu : K | ∃ v : V, v ≠ 0 ∧ (-f) v = mu • v}.ncard =
        {lam : K | ∃ v : V, v ≠ 0 ∧ f v = lam • v}.ncard :=
  ⟨Quantum.eigenvalues_neg f, Quantum.eigenvalues_neg_ncard f⟩
/-- Reviewer-facing invariance of regularity under sign reversal.  The submodule
generated by the orbit of a vector is the same for an endomorphism and for its
negative, so a vector is cyclic for one exactly when it is cyclic for the other
and the two endomorphisms are regular together. -/
theorem eulerOperator_cyclic_span_under_sign_reversal {K V : Type*} [CommRing K]
    [AddCommGroup V] [Module K V] (f : Module.End K V) (v : V) :
    Submodule.span K (Set.range fun k : ℕ => ((-f) ^ k) v) =
      Submodule.span K (Set.range fun k : ℕ => (f ^ k) v) :=
  Quantum.span_orbit_neg f v
/-- Reviewer-facing invariance of the characteristic discriminant under sign
reversal.  Negating the four roots of a split monic quartic leaves the
discriminant of that quartic unchanged, so the residual endomorphism and Euler
multiplication have the same discriminant vanishing locus in rank four. -/
theorem characteristicDiscriminant_under_root_sign_reversal {A : Type*} [CommRing A]
    (r₀ r₁ r₂ r₃ : A) :
    Quantum.quarticDiscriminant ((-r₀) * (-r₁) * (-r₂) * (-r₃))
        (-((-r₀) * (-r₁) * (-r₂) + (-r₀) * (-r₁) * (-r₃) + (-r₀) * (-r₂) * (-r₃) +
          (-r₁) * (-r₂) * (-r₃)))
        ((-r₀) * (-r₁) + (-r₀) * (-r₂) + (-r₀) * (-r₃) + (-r₁) * (-r₂) + (-r₁) * (-r₃) +
          (-r₂) * (-r₃))
        (-((-r₀) + (-r₁) + (-r₂) + (-r₃))) =
      Quantum.quarticDiscriminant (r₀ * r₁ * r₂ * r₃)
        (-(r₀ * r₁ * r₂ + r₀ * r₁ * r₃ + r₀ * r₂ * r₃ + r₁ * r₂ * r₃))
        (r₀ * r₁ + r₀ * r₂ + r₀ * r₃ + r₁ * r₂ + r₁ * r₃ + r₂ * r₃)
        (-(r₀ + r₁ + r₂ + r₃)) :=
  Quantum.quarticDiscriminant_neg_roots r₀ r₁ r₂ r₃
/-- Reviewer-facing statement that the fixed locus of an equivariant
multiplication is closed under multiplication by a fixed element, and that the
restricted multiplication is the multiplication of the fixed subalgebra.

In the application the family of automorphisms is the Hodge action on the maximal
`A`-model `F`-bundle and the fixed element is the Euler element, so the Euler
endomorphism of the fixed locus is the restriction of the ambient one.  Lean
constructs no `F`-bundle, no Hodge structure, and no quantum product; the
equivariance of the multiplication appears as the hypothesis that the family acts
by algebra automorphisms. -/
theorem hodgeFixedSubalgebra_closed_under_eulerMultiplication {G K A : Type*} [CommRing K]
    [CommRing A] [Algebra K A] (action : G → (A ≃ₐ[K] A)) {E a : A}
    (fixedEuler : E ∈ Quantum.fixedSubalgebra action)
    (fixedElement : a ∈ Quantum.fixedSubalgebra action) :
    E * a ∈ Quantum.fixedSubalgebra action ∧
      (((⟨E, fixedEuler⟩ : Quantum.fixedSubalgebra action) *
        ⟨a, fixedElement⟩ : Quantum.fixedSubalgebra action) : A) = E * a :=
  ⟨Quantum.mul_mem_fixedSubalgebra fixedEuler fixedElement,
    Quantum.coe_mul_fixedSubalgebra fixedEuler ⟨a, fixedElement⟩⟩
/-- Reviewer-facing transfer of an eigenvector from the fixed subalgebra to the
ambient algebra.  An eigenvector of multiplication by a fixed element inside the
fixed subalgebra is an eigenvector of the ambient multiplication with the same
eigenvalue, which is the sense in which the eigenvalues of the restricted Euler
endomorphism are eigenvalues of the ambient one. -/
theorem hodgeFixedSubalgebra_eigenvector_transfers {G K A : Type*} [CommRing K] [CommRing A]
    [Algebra K A] (action : G → (A ≃ₐ[K] A)) {E : A}
    (fixedEuler : E ∈ Quantum.fixedSubalgebra action) {lam : K}
    {a : Quantum.fixedSubalgebra action} (nonzero : a ≠ 0)
    (eigen : (⟨E, fixedEuler⟩ : Quantum.fixedSubalgebra action) * a = lam • a) :
    (a : A) ≠ 0 ∧ E * (a : A) = lam • (a : A) :=
  Quantum.eigenvector_of_fixedSubalgebra fixedEuler nonzero eigen
/-- Reviewer-facing statement that the powers of a fixed element are fixed, so
the span of the first four powers of the hyperplane class lies in the fixed
subalgebra, and that four linearly independent powers span a four-dimensional
subspace.  For a smooth cubic threefold the manuscript identifies the Hodge-fixed
tangent space with that span; the identification is a geometric input and is not
proved here. -/
theorem hodgeFixedTangentSpace_span_and_finrank {G K A : Type*} [Field K] [CommRing A]
    [Algebra K A] (action : G → (A ≃ₐ[K] A)) {P : A}
    (fixedClass : P ∈ Quantum.fixedSubalgebra action)
    (independent : LinearIndependent K fun i : Fin 4 => P ^ (i : ℕ)) :
    Submodule.span K (Set.range fun i : Fin 4 => P ^ (i : ℕ)) ≤
        Subalgebra.toSubmodule (Quantum.fixedSubalgebra action) ∧
      Module.finrank K (Submodule.span K (Set.range fun i : Fin 4 => P ^ (i : ℕ))) = 4 :=
  ⟨Quantum.span_powers_le_fixedSubalgebra fixedClass,
    Quantum.finrank_span_powers_eq_four independent⟩
/-- Reviewer-facing model of the algebra the manuscript obtains on the Hodge-fixed
tangent space of a smooth cubic threefold: the truncated polynomial algebra of
exponent four over a field.  Its distinguished element has vanishing fourth power
and it is four-dimensional, so the configuration used above is realized and the
dimension count is not vacuous. -/
theorem truncatedHyperplaneAlgebra_model (K : Type*) [Field K] :
    (AdjoinRoot.root (Polynomial.X ^ 4 : Polynomial K)) ^ 4 = 0 ∧
      Module.finrank K (AdjoinRoot (Polynomial.X ^ 4 : Polynomial K)) = 4 :=
  ⟨Quantum.adjoinRoot_root_pow_four_eq_zero K, Quantum.finrank_adjoinRoot_pow_four K⟩
/-- Reviewer-facing total Chern class of a smooth cubic threefold.  In a
commutative ring where the fourth power of the hyperplane class vanishes, the
class `1 + 2 * P + 4 * P ^ 2 - 2 * P ^ 3` is the adjunction quotient of the fifth
power of `1 + P` by `1 + 3 * P`, so the third Chern class is `-2 * P ^ 3`.  Lean
constructs no variety and no Chern class; the identity is the truncated
arithmetic the manuscript performs. -/
theorem cubicThreefold_totalChernClass_identity {A : Type*} [CommRing A] (P : A)
    (vanishing : P ^ 4 = 0) :
    (1 + 3 * P) * (1 + 2 * P + 4 * P ^ 2 - 2 * P ^ 3) = (1 + P) ^ 5 :=
  Applications.cubicThreefold_totalChernClass P vanishing
/-- Reviewer-facing third Betti number of a smooth cubic threefold.  From the
Lefschetz Betti numbers in the other degrees, the top Chern number `-2 * 3`
supplied by the Chern class identity and the degree of the hyperplane class
cubed, and the equality of the alternating sum of the Betti numbers with that
Chern number, the third Betti number is ten. -/
theorem cubicThreefold_bettiThree_eq_ten (betti : ℕ → ℤ) (topChernNumber : ℤ)
    (degreeZero : betti 0 = 1) (degreeOne : betti 1 = 0) (degreeTwo : betti 2 = 1)
    (degreeFour : betti 4 = 1) (degreeFive : betti 5 = 0) (degreeSix : betti 6 = 1)
    (chernNumber : topChernNumber = -2 * 3)
    (eulerCharacteristic :
      betti 0 - betti 1 + betti 2 - betti 3 + betti 4 - betti 5 + betti 6 = topChernNumber) :
    betti 3 = 10 :=
  Applications.cubicThreefold_bettiThree_eq_ten betti topChernNumber degreeZero degreeOne
    degreeTwo degreeFour degreeFive degreeSix chernNumber eulerCharacteristic
/-- Reviewer-facing degree count placing the whole degree-three cohomology of a
smooth cubic threefold in the zero packet.  Euler multiplication sends a class of
cohomological degree three in Novikov degree `d` to cohomological degree
`5 - 4 * d`, and the cohomology vanishes in that degree for every nonnegative `d`
because it vanishes in degrees one and five and in negative degrees. -/
theorem cubicThreefold_eulerMultiplication_annihilates_degreeThree (betti : ℤ → ℕ)
    (belowZero : ∀ degree : ℤ, degree < 0 → betti degree = 0)
    (degreeOne : betti 1 = 0) (degreeFive : betti 5 = 0) (novikovDegree : ℕ) :
    betti (5 - 4 * (novikovDegree : ℤ)) = 0 :=
  Applications.cubicThreefold_eulerShift_target_vanishes betti belowZero degreeOne degreeFive
    novikovDegree
/-- Reviewer-facing separation of the branch carrying the zero packet from the two
rank-one branches.  The rank of the generalized eigenbundle is locally constant on
the unramified spectral cover, and a locally constant function is constant on a
connected component, so a branch of rank twelve lies in a component containing no
branch of rank one.  Lean constructs no spectral cover; the cover appears as a
topological space and the ranks as the values of a locally constant function. -/
theorem cubicZeroPacket_component_excludes_rankOne_branches {Cover : Type*}
    [TopologicalSpace Cover] {rank : Cover → ℕ} (locallyConstant : IsLocallyConstant rank)
    {zeroBranch positiveBranch negativeBranch : Cover} (zeroRank : rank zeroBranch = 12)
    (positiveRank : rank positiveBranch = 1) (negativeRank : rank negativeBranch = 1) :
    positiveBranch ∉ connectedComponent zeroBranch ∧
      negativeBranch ∉ connectedComponent zeroBranch :=
  Applications.cubicZeroPacket_component_excludes_rankOne_branches locallyConstant zeroRank
    positiveRank negativeRank
/-- Reviewer-facing parity ranks of the zero packet of a smooth cubic threefold:
even rank two, odd rank ten, total rank twelve.  The even rank is supplied by the
block reduction of the small even connection, and the odd rank is the third Betti
number, since the whole degree-three cohomology lies in the zero packet. -/
theorem cubicZeroPacket_parityRanks_eq_two_and_ten (betti : ℕ → ℤ) (topChernNumber : ℤ)
    (evenRank oddRank : ℕ)
    (degreeZero : betti 0 = 1) (degreeOne : betti 1 = 0) (degreeTwo : betti 2 = 1)
    (degreeFour : betti 4 = 1) (degreeFive : betti 5 = 0) (degreeSix : betti 6 = 1)
    (chernNumber : topChernNumber = -2 * 3)
    (eulerCharacteristic :
      betti 0 - betti 1 + betti 2 - betti 3 + betti 4 - betti 5 + betti 6 = topChernNumber)
    (evenBlock : evenRank = 2) (oddPart : (oddRank : ℤ) = betti 3) :
    evenRank = 2 ∧ oddRank = 10 ∧ evenRank + oddRank = 12 :=
  Applications.cubicZeroPacket_parityRanks betti topChernNumber evenRank oddRank degreeZero
    degreeOne degreeTwo degreeFour degreeFive degreeSix chernNumber eulerCharacteristic evenBlock
    oddPart
/-- Reviewer-facing invariance of the rank-two residue discriminant under sign
reversal.  Sign reversal negates the trace of a two-by-two matrix and fixes its
determinant, so `(trace R) ^ 2 - 4 * det R` is unchanged and the atomic invariant
may be read from either of the two operators that differ by the sign. -/
theorem residueDiscriminant_under_sign_reversal {K : Type*} [CommRing K]
    (R : Matrix (Fin 2) (Fin 2) K) :
    Quantum.residueDiscriminant (-R) = Quantum.residueDiscriminant R :=
  Quantum.residueDiscriminant_neg R
/-- Reviewer-facing parity of the universal quartic discriminant in its odd
characteristic coefficients.  Negating the coefficients of the linear and cubic
terms of a monic quartic leaves its discriminant unchanged; this is the split-free
form of the invariance used for the rank-four characteristic polynomial. -/
theorem characteristicDiscriminant_under_odd_coefficient_sign_reversal {A : Type*} [CommRing A]
    (l₀ l₁ l₂ l₃ : A) :
    Quantum.quarticDiscriminant l₀ (-l₁) l₂ (-l₃) = Quantum.quarticDiscriminant l₀ l₁ l₂ l₃ :=
  Quantum.quarticDiscriminant_neg_odd_coefficients l₀ l₁ l₂ l₃
/-- Reviewer-facing uniqueness of the total Chern class of a smooth cubic
threefold.  The adjunction factor `1 + 3 * P` is a unit in the truncated ring
because the hyperplane class is nilpotent of exponent four, so the class solving
the adjunction equation is exactly `1 + 2 * P + 4 * P ^ 2 - 2 * P ^ 3` and its
degree-three component is `-2 * P ^ 3`. -/
theorem cubicThreefold_totalChernClass_uniqueness {A : Type*} [CommRing A] (P chernClass : A)
    (vanishing : P ^ 4 = 0) (adjunction : (1 + 3 * P) * chernClass = (1 + P) ^ 5) :
    (1 + 3 * P) * (1 - 3 * P + 9 * P ^ 2 - 27 * P ^ 3) = 1 ∧
      chernClass = 1 + 2 * P + 4 * P ^ 2 - 2 * P ^ 3 :=
  ⟨Applications.cubicThreefold_adjunctionFactor_isUnit P vanishing,
    Applications.cubicThreefold_totalChernClass_unique P chernClass vanishing adjunction⟩
/-- The exotic depth-one slope of the local chart at two has no model over an
ordered coefficient ring.  The depth-one block `5I₄-J₄` pairs a vector to the sum
of the squares of its coordinates and of their pairwise differences, and the dual
form `(1/5)(I₄+J₄)` pairs it to the inverse of five times the sum of the squares
of the coordinates and the square of their sum; both are therefore positive
semidefinite over a linearly ordered commutative ring and positive on the first
coordinate vector.  No matrix satisfying the relation of a primitive cube root of
unity is self-adjoint for either form, by the discriminant inequality on the
three pairings of a vector and its image.  A slope of the manuscript's exotic
type therefore exists only over a coefficient ring carrying no compatible order,
which is where the manuscript places it. -/
theorem sixAxisLocalChart_exoticSlope_not_selfAdjoint_over_orderedRing
    {R : Type*} [CommRing R] [LinearOrder R] [IsStrictOrderedRing R]
    (slope : Matrix (Fin 4) (Fin 4) R)
    (cubeRootRelation : slope * slope + slope + 1 = 0) :
    (∀ vector : Fin 4 → R,
        0 ≤ dotProduct vector
          (Matrix.mulVec (GraphLattices.sixAxisComplementBlock R) vector)) ∧
      Matrix.transpose slope * GraphLattices.sixAxisComplementBlock R ≠
          GraphLattices.sixAxisComplementBlock R * slope ∧
        ∀ inverseFive : R, 0 < inverseFive →
          (∀ vector : Fin 4 → R,
              0 ≤ dotProduct vector
                (Matrix.mulVec
                  (GraphLattices.sixAxisComplementBlockInverse inverseFive) vector)) ∧
            Matrix.transpose slope *
                GraphLattices.sixAxisComplementBlockInverse inverseFive ≠
              GraphLattices.sixAxisComplementBlockInverse inverseFive * slope :=
  ⟨GraphLattices.sixAxisComplementBlock_semidefinite,
    (GraphLattices.no_cubeRootRelation_selfAdjoint_slope slope cubeRootRelation).1,
    fun inverseFive positive ↦
      ⟨GraphLattices.sixAxisComplementBlockInverse_semidefinite positive.le,
        (GraphLattices.no_cubeRootRelation_selfAdjoint_slope slope
          cubeRootRelation).2 inverseFive positive⟩⟩
/-- Reviewer-facing invertibility of the Sylvester operator of two leading
operators with separated spectra.  Over a commutative ring, if two square
matrices are each a scalar multiple of the identity plus a nilpotent matrix, and
the two scalars differ by a unit, then the equation `U * X - X * V = Y` between
rectangular matrices has exactly one solution for every right-hand side.  This is
the step the manuscript invokes at each order of a normalizing gauge and at each
order of the pairing between two spectral factors. -/
theorem sylvesterEquation_unique_solution_of_separated_spectra
    {R : Type*} [CommRing R] {rowIndex columnIndex : Type*} [Fintype rowIndex]
    [DecidableEq rowIndex] [Fintype columnIndex] [DecidableEq columnIndex]
    {leftOperator : Matrix rowIndex rowIndex R} {rightOperator : Matrix columnIndex columnIndex R}
    {leftScalar rightScalar : R} (separated : IsUnit (leftScalar - rightScalar))
    (leftNilpotent : IsNilpotent (leftOperator - leftScalar • 1))
    (rightNilpotent : IsNilpotent (rightOperator - rightScalar • 1))
    (target : Matrix rowIndex columnIndex R) :
    ∃! solution : Matrix rowIndex columnIndex R,
      leftOperator * solution - solution * rightOperator = target :=
  Quantum.existsUnique_sylvester_solution separated leftNilpotent rightNilpotent target
/-- Reviewer-facing unique solvability of the block Sylvester equation.  A
splitting of the coordinates into blocks is a labelling; a matrix is block
diagonal when it vanishes on entries whose row and column carry different labels,
and block off-diagonal when it vanishes on entries whose row and column carry the
same label.  For a block-diagonal leading operator whose blocks have separated
spectra — the scalars attached to two distinct labels differ by a unit, and the
operator differs from the diagonal matrix of those scalars by a nilpotent matrix
— every block off-diagonal matrix is the commutator of the leading operator with
exactly one block off-diagonal matrix. -/
theorem blockSylvesterEquation_unique_blockOffDiagonal_solution
    {R : Type*} [CommRing R] {coordinate : Type*} [Fintype coordinate] [DecidableEq coordinate]
    {factorIndex : Type*} [DecidableEq factorIndex] {label : coordinate → factorIndex}
    {scalar : factorIndex → R} {leadingOperator : Matrix coordinate coordinate R}
    (separated : ∀ first second, first ≠ second → IsUnit (scalar first - scalar second))
    (blockDiagonal : Quantum.IsBlockDiagonal label leadingOperator)
    (nilpotent : IsNilpotent
      (leadingOperator - Matrix.diagonal fun index => scalar (label index)))
    {target : Matrix coordinate coordinate R}
    (targetOffDiagonal : Quantum.IsBlockOffDiagonal label target) :
    ∃! solution : Matrix coordinate coordinate R,
      Quantum.IsBlockOffDiagonal label solution ∧
        leadingOperator * solution - solution * leadingOperator = target :=
  Quantum.existsUnique_blockOffDiagonal_sylvester_solution separated blockDiagonal nilpotent
    targetOffDiagonal
/-- Reviewer-facing existence of the normalized gauge of a block-separated
system.  A system with a second-order pole in the loop coordinate is given by the
family of coefficients of the matrix `M(z)` of `z ^ 2 * ∂_z S = M(z) * S`; a gauge
`A(z)` acts by `S = A(z) * S̃`, and the transformed system's matrix `M̃(z)`
satisfies the inverse-free identity `A(z) * M̃(z) + z ^ 2 * A'(z) = M(z) * A(z)`,
recorded coefficient by coefficient.  The gauge is normalized when it starts at
the identity and every positive coefficient is block off-diagonal, and the
transformed system is reduced when every coefficient is block diagonal.  If the
leading coefficient of the system is block diagonal with separated blocks, such a
gauge exists.  Lean constructs no connection, `F`-bundle, or analytic gauge: the
system is a family of matrices and the identity is the displayed family of
coefficient identities. -/
theorem exists_normalizedBlockGauge_of_separated_blocks
    {R : Type*} [CommRing R] {coordinate : Type*} [Fintype coordinate] [DecidableEq coordinate]
    {factorIndex : Type*} [DecidableEq factorIndex] {label : coordinate → factorIndex}
    {scalar : factorIndex → R} {system : ℕ → Matrix coordinate coordinate R}
    (separated : ∀ first second, first ≠ second → IsUnit (scalar first - scalar second))
    (blockDiagonal : Quantum.IsBlockDiagonal label (system 0))
    (nilpotent : IsNilpotent (system 0 - Matrix.diagonal fun index => scalar (label index))) :
    ∃ gauge reduced : ℕ → Matrix coordinate coordinate R,
      Quantum.IsNormalizedGauge label system gauge reduced :=
  Quantum.exists_normalizedGauge separated blockDiagonal nilpotent
/-- Reviewer-facing uniqueness of the normalized gauge of a block-separated
system.  Two normalized gauges reducing the same system to block-diagonal form
agree at every order, and so do the two reduced systems.  This is the
normalization the manuscript imposes to make the splitting of a connection into
spectral factors unique. -/
theorem normalizedBlockGauge_unique_of_separated_blocks
    {R : Type*} [CommRing R] {coordinate : Type*} [Fintype coordinate] [DecidableEq coordinate]
    {factorIndex : Type*} [DecidableEq factorIndex] {label : coordinate → factorIndex}
    {scalar : factorIndex → R} {system gauge reduced gaugeOther reducedOther :
      ℕ → Matrix coordinate coordinate R}
    (separated : ∀ first second, first ≠ second → IsUnit (scalar first - scalar second))
    (blockDiagonal : Quantum.IsBlockDiagonal label (system 0))
    (nilpotent : IsNilpotent (system 0 - Matrix.diagonal fun index => scalar (label index)))
    (first : Quantum.IsNormalizedGauge label system gauge reduced)
    (second : Quantum.IsNormalizedGauge label system gaugeOther reducedOther) :
    ∀ order, gauge order = gaugeOther order ∧ reduced order = reducedOther order :=
  Quantum.normalizedGauge_unique separated blockDiagonal nilpotent first second

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
