import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankTwoCanonicalLattice
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SeventeenCountingMatrices
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PrimaryPolynomialProjectors
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.TwoByTwoBlockGauge
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CyclicRankThreePersistence
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankTwoLatticeTransport
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ParameterizedRankTwoResidue
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SuperRankOneVanishing
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CyclicRankThreeCentralizer
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface.Introduction
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface.CategoricalOneStep
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface.FormalConnections
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface.ResiduePairing

/-!
# Reviewer interface for the primary one-stabilization paper

This is the public formal entry point for *Irrationality of Cubic Threefolds
after One Stabilization*.  It exports the generic-even-QDM ledger, the
formal-exponent marker, the cubic calculation, low-dimensional nullity, and
the primary paper's applications.  Geometric and literature inputs remain
explicit in the declaration types.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

/-- Exact residue-discriminant transport for formal rank-two connections over
a commutative ring in which two is invertible. Both connections are centered
and adapted, with unit upper-right leading entries and horizontal pairings
whose constant coefficients are invertible. A regular horizontal comparison
and a regular horizontal inverse induce mutually inverse comparisons on the
modified lattice and conjugate its residues. Thus the exact discriminant is
preserved, including when the residue eigenvalues differ by an integer.

The connections and pairings are actual formal matrix series. Lean constructs
neither geometric quantum connections nor their comparison isomorphisms;
identification of a geometric factor with these data is outside the statement.
The induced comparison depends on the first jet of the original comparison.
No modified-residue conjugacy or discriminant equality is supplied as a premise. -/
theorem rankTwo_modifiedResidueDiscriminant_invariant_under_regular_comparison
    {B : Type*} [CommRing B]
    {source target comparison inverse sourcePairing targetPairing :
      PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    {sourceUnit targetUnit : B} (twoUnit : IsUnit (2 : B))
    (horizontal : Quantum.IsHorizontalLoopComparison source target comparison)
    (inverseHorizontal : Quantum.IsHorizontalLoopComparison target source inverse)
    (sourceAdapted : PowerSeries.coeff 0 source = Quantum.adaptedLeadingOperator sourceUnit)
    (targetAdapted : PowerSeries.coeff 0 target = Quantum.adaptedLeadingOperator targetUnit)
    (sourceInvertible : IsUnit sourceUnit) (targetInvertible : IsUnit targetUnit)
    (sourceNondegenerate : IsUnit ((PowerSeries.coeff 0 sourcePairing).det))
    (targetNondegenerate : IsUnit ((PowerSeries.coeff 0 targetPairing).det))
    (sourceHorizontal : Quantum.IsHorizontalPairing source sourcePairing)
    (targetHorizontal : Quantum.IsHorizontalPairing target targetPairing)
    (leftInverse : comparison * inverse = 1)
    (rightInverse : inverse * comparison = 1) :
    Quantum.residueDiscriminant (Quantum.modifiedResidue target) =
      Quantum.residueDiscriminant (Quantum.modifiedResidue source) :=
  Quantum.residueDiscriminant_eq_of_horizontal_pairings_and_inverse twoUnit horizontal
    inverseHorizontal sourceAdapted targetAdapted sourceInvertible targetInvertible
    sourceNondegenerate targetNondegenerate sourceHorizontal targetHorizontal
    leftInverse rightInverse

/-- Exact finite-coefficient reduction of the parameterized four-dimensional
system. The leading matrix has a double zero root, the displayed rational basis
splits its leading blocks, and the first gauge solves the first-order equation.
The modified zero-block residue has the displayed characteristic polynomial
and exact discriminant. The nonvanishing hypotheses are precisely those needed
by the rational block basis. These are identities of explicit matrices over an
arbitrary characteristic-zero field; no geometric quantum product or complete
formal gauge is constructed by this statement. -/
theorem parameterizedRankTwo_finiteReduction
    {K : Type*} [Field K] [CharZero K] {a b q : K}
    (sumNonzero : 2*a+b ≠ 0) (qNonzero : q ≠ 0) :
    (Quantum.parameterizedEulerMatrix a b q).charpoly =
        Polynomial.X^2 * (Polynomial.X^2 - Polynomial.C ((2*a+b)*q)) ∧
    (Quantum.parameterizedBlockBasis a b q * Quantum.parameterizedBlockBasisInverse a b q = 1 ∧
      Quantum.parameterizedBlockBasisInverse a b q * Quantum.parameterizedBlockBasis a b q = 1) ∧
    Quantum.parameterizedEulerMatrix a b q * Quantum.parameterizedBlockBasis a b q =
      Quantum.parameterizedBlockBasis a b q * Quantum.parameterizedEulerBlocks a b q ∧
    Quantum.parameterizedGradingBlocks a b +
        Quantum.parameterizedEulerBlocks a b q * Quantum.parameterizedGaugeFirst a b q -
        Quantum.parameterizedGaugeFirst a b q * Quantum.parameterizedEulerBlocks a b q =
      Quantum.parameterizedReducedFirst a b ∧
    (Quantum.parameterizedModifiedResidue a b).charpoly =
      Polynomial.X^2 + Polynomial.X + Polynomial.C ((10*a-3*b)/(4*(2*a+b))) ∧
    Quantum.residueDiscriminant (Quantum.parameterizedModifiedResidue a b) =
      4*(b-2*a)/(2*a+b) :=
  ⟨Quantum.parameterizedEulerMatrix_charpoly a b q,
    Quantum.parameterizedBlockBasis_inverse sumNonzero qNonzero,
    Quantum.parameterizedEulerMatrix_mul_blockBasis a b q,
    Quantum.parameterizedReduction_first_order sumNonzero qNonzero,
    Quantum.parameterizedModifiedResidue_charpoly sumNonzero,
    Quantum.parameterizedModifiedResidue_discriminant sumNonzero⟩

/-- The four rational input pairs give exact modified-residue discriminants
16/9, 1, 4/9 and 0. In particular the discriminant-one case is retained without
reducing exponents modulo integers. This terminal evaluates explicit matrices;
it does not identify them with geometric Fano quantum products. -/
theorem parameterizedRankTwo_fourDiscriminants :
    Quantum.residueDiscriminant (Quantum.parameterizedModifiedResidue (240 : ℚ) 1248) = 16/9 ∧
      Quantum.residueDiscriminant (Quantum.parameterizedModifiedResidue (48 : ℚ) 160) = 1 ∧
      Quantum.residueDiscriminant (Quantum.parameterizedModifiedResidue (24 : ℚ) 60) = 4/9 ∧
      Quantum.residueDiscriminant (Quantum.parameterizedModifiedResidue (16 : ℚ) 32) = 0 :=
  Quantum.parameterizedModifiedResidue_fano_values

/-- In an associative algebra whose even part is scalar, supercommutativity
and a nondegenerate even Frobenius trace force the odd part to vanish. Scalar
even part means explicitly that odd products are scalar and that scalars
and odd elements span the entire algebra. The proof derives vanishing of odd
products; it does not assume nondegeneracy of a restricted odd pairing. These
are algebraic hypotheses, without a constructed geometric primary factor. -/
theorem superPrimary_scalarEven_odd_eq_bot
    {K A : Type*} [Field K] [CharZero K] [Ring A] [Algebra K A] [Nontrivial A]
    {odd : Submodule K A}
    (anticommute : ∀ x ∈ odd, ∀ y ∈ odd, x*y = -(y*x))
    (scalarProduct : ∀ x ∈ odd, ∀ y ∈ odd, ∃ c : K, x*y = algebraMap K A c)
    (spanning : ∀ y : A, ∃ (c : K) (v : A), v ∈ odd ∧ y = algebraMap K A c + v)
    (trace : A →ₗ[K] K) (traceOdd : ∀ x ∈ odd, trace x = 0)
    (nondegenerate : ∀ x : A, (∀ y : A, trace (x*y) = 0) → x = 0) :
    odd = ⊥ :=
  Quantum.odd_eq_bot_of_scalar_even_frobenius anticommute scalarProduct spanning
    trace traceOdd nondegenerate

/-- A polynomial identity for the actual left-multiplication operator that
annihilates a submodule containing the unit annihilates the whole algebra.
Applied to the even part of a superalgebra, this retains the full odd fiber.
No identity on the odd part is a premise. The statement constructs neither
primary projectors nor a geometric quantum multiplication. -/
theorem superPrimary_eulerPolynomial_transfers_from_even
    {K A : Type*} [Field K] [Ring A] [Algebra K A]
    (even : Submodule K A) (unitEven : (1 : A) ∈ even) (euler : A)
    (polynomial : Polynomial K)
    (annihilates : ∀ x ∈ even,
      (Polynomial.aeval (Algebra.lmul K A euler) polynomial) x = 0) :
    Polynomial.aeval (Algebra.lmul K A euler) polynomial = 0 :=
  Quantum.euler_polynomial_eq_zero_of_annihilates_unit_submodule even unitEven
    euler polynomial annihilates

/-- Exact cyclic rank-three commutant and trace formulas over a commutative
ring. The parameters are the centered characteristic coefficients and the
commutant coefficients are recovered from its first column. The last two
traces belong to the ideal generated by the parameters. This finite algebra
supports a persistence argument but does not prove differential stability of
that ideal or construct a flat formal quantum connection. -/
theorem rankThree_cyclicCentralizer_and_traceIdentities
    {K : Type*} [CommRing K] {b c : K}
    (comparison : Matrix (Fin 3) (Fin 3) K)
    (commutes : comparison * Quantum.centeredCyclicRankThree b c =
      Quantum.centeredCyclicRankThree b c * comparison) :
    (Quantum.centeredCyclicRankThree b c).charpoly =
        Polynomial.X^3 - Polynomial.C b * Polynomial.X - Polynomial.C c ∧
    comparison = comparison 0 0 • (1 : Matrix (Fin 3) (Fin 3) K) +
      comparison 1 0 • Quantum.centeredCyclicRankThree b c +
      comparison 2 0 • (Quantum.centeredCyclicRankThree b c)^2 ∧
    Matrix.trace comparison = 3*comparison 0 0 + 2*b*comparison 2 0 ∧
    Matrix.trace (Quantum.centeredCyclicRankThree b c * comparison) =
      2*b*comparison 1 0 + 3*c*comparison 2 0 ∧
    Matrix.trace ((Quantum.centeredCyclicRankThree b c)^2 * comparison) =
      2*b*comparison 0 0 + 3*c*comparison 1 0 + 2*b^2*comparison 2 0 :=
  ⟨Quantum.centeredCyclicRankThree_charpoly b c,
    Quantum.centeredCyclicRankThree_commutant comparison commutes,
    Quantum.centeredCyclicRankThree_commuting_traces comparison commutes⟩

/-- A centered cyclic rank-three block satisfying compressed flatness and
commutation in every coordinate direction remains a single nilpotent block
on a formal germ if its characteristic coefficients vanish at the origin.
The connection matrices and their identities are explicit hypotheses. -/
theorem rankThree_cyclicNilpotent_persists_on_formal_germ
    {σ K : Type*} [CommRing K] [NoZeroDivisors K] [CharZero K]
    (b c : MvPowerSeries σ K)
    (comparison a connection : σ → Matrix (Fin 3) (Fin 3) (MvPowerSeries σ K))
    (initialB : MvPowerSeries.coeff 0 b = 0)
    (initialC : MvPowerSeries.coeff 0 c = 0)
    (commutes : ∀ i, comparison i * Quantum.centeredCyclicRankThree b c =
      Quantum.centeredCyclicRankThree b c * comparison i)
    (flat : ∀ i,
      !![0,0,Quantum.formalPartialDerivative i c; 0,0,Quantum.formalPartialDerivative i b; 0,0,0] =
      -comparison i + (comparison i*a i-a i*comparison i) +
      (connection i*Quantum.centeredCyclicRankThree b c-Quantum.centeredCyclicRankThree b c*connection i)) :
    b = 0 ∧ c = 0 ∧ (Quantum.centeredCyclicRankThree b c)^3 = 0 ∧
      (Quantum.centeredCyclicRankThree b c)^2 ≠ 0 :=
  Quantum.centeredCyclicRankThree_nilpotent_persists b c comparison a connection
    initialB initialC commutes flat


/-- The parameterized four-dimensional formal system admits a unique normalized
split into its complementary rank-two block and its rank-two zero block over
the original field. The actual power-series zero block has exactly the
parameterized elementary-modification residue and its exact discriminant.
The system is given explicitly; its identification with a geometric quantum
connection is not a hypothesis or a conclusion of this algebraic statement. -/
theorem parameterizedRankTwo_normalizedGauge_and_modifiedResidue
    {K : Type*} [Field K] [CharZero K] {a b q : K}
    (sumNonzero : 2*a+b ≠ 0) (qNonzero : q ≠ 0) :
    ∃ gauge reduced : ℕ → Matrix (Fin 4) (Fin 4) K,
      Quantum.IsNormalizedGauge Quantum.twoByTwoBlockLabel
        (Quantum.parameterizedSeparatedSystem a b q) gauge reduced ∧
      (∀ otherGauge otherReduced,
        Quantum.IsNormalizedGauge Quantum.twoByTwoBlockLabel
          (Quantum.parameterizedSeparatedSystem a b q) otherGauge otherReduced →
        ∀ n, gauge n = otherGauge n ∧ reduced n = otherReduced n) ∧
      Quantum.modifiedResidue (Quantum.lastRankTwoBlockSeries reduced) =
        Quantum.parameterizedModifiedResidue a b ∧
      Quantum.residueDiscriminant
        (Quantum.modifiedResidue (Quantum.lastRankTwoBlockSeries reduced)) =
        4*(b-2*a)/(2*a+b) := by
  obtain ⟨gauge, reduced, normalized⟩ := Quantum.twoByTwo_exists_normalizedGauge
    (mul_ne_zero sumNonzero qNonzero) (Quantum.parameterizedSeparatedSystem a b q) rfl
  have residue := Quantum.parameterizedNormalizedGauge_modifiedResidue sumNonzero qNonzero normalized
  refine ⟨gauge, reduced, normalized, ?_, residue, ?_⟩
  · intro otherGauge otherReduced other
    exact Quantum.twoByTwo_normalizedGauge_unique (mul_ne_zero sumNonzero qNonzero)
      rfl normalized other
  · rw [residue]
    exact Quantum.parameterizedModifiedResidue_discriminant sumNonzero


/-- The actual preimage lattice equals the range of its injective elementary
modification and is preserved by a regular horizontal adapted comparison.
The leading nilpotent line is derived from the matrix horizontality identity. -/
theorem rankTwo_canonicalLattice_preserved_by_regularComparison
    {B : Type*} [CommRing B]
    {source target comparison : PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    {sourceUnit targetUnit : B}
    (horizontal : Quantum.IsHorizontalLoopComparison source target comparison)
    (sourceAdapted : PowerSeries.coeff 0 source = Quantum.adaptedLeadingOperator sourceUnit)
    (targetAdapted : PowerSeries.coeff 0 target = Quantum.adaptedLeadingOperator targetUnit)
    (targetInvertible : IsUnit targetUnit)
    (v : Fin 2 → PowerSeries B) (hv : v ∈ Quantum.adaptedCanonicalLattice) :
    Quantum.adaptedCanonicalLattice (B := B) = LinearMap.range Quantum.adaptedLatticeEmbedding ∧
      Function.Injective (Quantum.adaptedLatticeEmbedding (B := B)) ∧
      Quantum.formalRankTwoMatrixAction comparison v ∈ Quantum.adaptedCanonicalLattice :=
  ⟨Quantum.adaptedCanonicalLattice_eq_range, Quantum.adaptedLatticeEmbedding_injective,
    Quantum.horizontalComparison_preserves_adaptedCanonicalLattice horizontal sourceAdapted
      targetAdapted targetInvertible v hv⟩

/-- Injective coefficient extension preserves and reflects lattice membership;
the modified residue and its exact discriminant commute with coefficient maps. -/
theorem rankTwo_canonicalLattice_and_residue_coefficientExtension
    {B C : Type*} [CommRing B] [CommRing C]
    (f : B →+* C) (injective : Function.Injective f)
    (v : Fin 2 → PowerSeries B) (loop : PowerSeries (Matrix (Fin 2) (Fin 2) B)) :
    ((fun i => PowerSeries.map f (v i)) ∈ Quantum.adaptedCanonicalLattice ↔
      v ∈ Quantum.adaptedCanonicalLattice) ∧
      Quantum.modifiedResidue (PowerSeries.map (f.mapMatrix : Matrix (Fin 2) (Fin 2) B →+*
        Matrix (Fin 2) (Fin 2) C) loop) = (Quantum.modifiedResidue loop).map f ∧
      Quantum.residueDiscriminant ((Quantum.modifiedResidue loop).map f) =
        f (Quantum.residueDiscriminant (Quantum.modifiedResidue loop)) :=
  ⟨Quantum.adaptedCanonicalLattice_mem_map_iff f injective v,
    Quantum.modifiedResidue_coefficient_map f loop,
    Quantum.residueDiscriminant_coefficient_map f (Quantum.modifiedResidue loop)⟩

/-- Exhaustive characteristic-polynomial and determinant-one cyclic-basis
certificates for the seventeen explicit rational counting matrices. The labels
supply no geometric classification or quantum-product identification. -/
theorem seventeenCountingMatrices_charpoly_and_cyclicBasis :
    Fintype.card Quantum.CountingMatrixLabel = 17 ∧
      ∀ label : Quantum.CountingMatrixLabel,
      (Quantum.labeledCountingMatrix label).charpoly = Quantum.labeledCountingPolynomial label ∧
      (let p := Quantum.countingMatrixParameters label
       let basis := Quantum.countingMatrixCyclicBasis (p 0) (p 1) (p 2) (p 3) (p 4)
       basis.det = 1 ∧ ∀ column : Fin 4,
         (fun row => basis row column) =
           ((Quantum.labeledCountingMatrix label)^column.val).mulVec ![1,0,0,0]) :=
  ⟨Quantum.countingMatrixLabel_card, fun label =>
    ⟨Quantum.labeledCountingMatrix_charpoly label, Quantum.labeledCountingMatrix_cyclicBasis label⟩⟩

/-- A coprime annihilating factorization constructs complementary orthogonal
idempotents, with the first killed by the first polynomial and the second by
the second polynomial. No projectors are supplied as hypotheses. -/
theorem superPrimary_polynomialProjectors_exist {K A : Type*} [Field K] [Ring A] [Algebra K A]
    (euler : A) (f g : Polynomial K) (coprime : IsCoprime f g)
    (annihilates : Polynomial.aeval euler (f*g) = 0) :
    ∃ p q : A, p+q=1 ∧ p*q=0 ∧ q*p=0 ∧ p*p=p ∧ q*q=q ∧
      Polynomial.aeval euler f*p=0 ∧ Polynomial.aeval euler g*q=0 ∧
      (∃ r : Polynomial K, p=Polynomial.aeval euler r) ∧
      (∃ r : Polynomial K, q=Polynomial.aeval euler r) :=
  Quantum.exists_primaryPolynomial_idempotents euler f g coprime annihilates

/-- The Frobenius trace pairing restricted to a central idempotent's image is
nondegenerate if the original trace pairing is nondegenerate. The restricted
nondegeneracy is derived using projection of arbitrary test vectors. -/
theorem superPrimary_tracePairing_restricts_nondegenerately
    {K A : Type*} [Field K] [Ring A] [Algebra K A]
    (e : A) (idempotent : e*e=e) (central : ∀ x : A, Commute e x)
    (trace : A →ₗ[K] K)
    (nondegenerate : ∀ x : A, (∀ y : A, trace (x*y)=0) → x=0)
    {x : A} (member : x ∈ LinearMap.range (Algebra.lmul K A e))
    (orthogonal : ∀ y ∈ LinearMap.range (Algebra.lmul K A e), trace (x*y)=0) :
    x=0 :=
  Quantum.centralIdempotent_tracePairing_nondegenerate e idempotent central trace nondegenerate member orthogonal

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
