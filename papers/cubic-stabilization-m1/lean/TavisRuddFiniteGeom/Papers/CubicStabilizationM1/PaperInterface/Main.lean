import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FaithfulCompletedExponentialRingMap
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.IndependentOccurrenceSeparation
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompletedMultivariatePushforward
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FixedBaseCoordinateEquivalences
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ExactPrimaryLedger
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.NineRankTwoResidues
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ExactResidueSelectors
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PrimaryOddAllocation
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SuperPrimaryPairing
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PrimarySummandDecomposition
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankThreeCountingSplits
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PrimaryScalarEvenVanishing
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


/-- The full odd trace pairing is nondegenerate, and its dimension is even.
The spanning and parity assumptions derive restricted nondegeneracy from the
whole-algebra trace pairing; no restricted nondegeneracy is a premise. -/
theorem superPrimary_oddPairing_nondegenerate_and_even
    {K A : Type*} [Field K] [CharZero K] [Ring A] [Algebra K A]
    [FiniteDimensional K A]
    (even odd : Submodule K A)
    (spanning : ∀ y : A, ∃ u ∈ even, ∃ v ∈ odd, y=u+v)
    (oddEven : ∀ x ∈ odd, ∀ y ∈ even, x*y ∈ odd)
    (anticommute : ∀ x ∈ odd, ∀ y ∈ odd, x*y=-(y*x))
    (trace : A →ₗ[K] K) (traceOdd : ∀ x ∈ odd, trace x=0)
    (nondegenerate : ∀ x : A, (∀ y : A, trace (x*y)=0) → x=0) :
    (Quantum.submoduleTracePairing odd trace).Nondegenerate ∧ Even (Module.finrank K odd) :=
  Quantum.oddTracePairing_nondegenerate_and_even even odd spanning oddEven anticommute trace traceOdd nondegenerate

/-- Polynomial multiplication in the Euler element preserves every submodule
stable under multiplication by that element. This derives parity preservation
for polynomial primary projectors from the parity of Euler multiplication. -/
theorem superPrimary_polynomialProjection_preserves_submodule
    {K A : Type*} [Field K] [Ring A] [Algebra K A]
    (euler : A) (sub : Submodule K A)
    (stable : ∀ x ∈ sub, euler*x ∈ sub)
    (p : Polynomial K) {x : A} (hx : x ∈ sub) :
    Polynomial.aeval euler p*x ∈ sub :=
  Quantum.polynomial_projector_preserves_submodule euler sub stable p hx

/-- Complementary orthogonal primary idempotents give a linear equivalence
of the entire algebra with their full multiplication images. The forward map
is exactly multiplication by the two idempotents on every vector. -/
theorem superPrimary_fullSummandDecomposition
    {K A : Type*} [Field K] [Ring A] [Algebra K A]
    (p q : A) (sum : p+q=1) (pp : p*p=p) (qq : q*q=q)
    (pq : p*q=0) (qp : q*p=0) :
    ∃ equiv : A ≃ₗ[K] LinearMap.range (Algebra.lmul K A p) ×
        LinearMap.range (Algebra.lmul K A q),
      ∀ x : A, ((equiv x).1 : A)=p*x ∧ ((equiv x).2 : A)=q*x :=
  ⟨Quantum.complementaryIdempotents_linearEquiv p q sum pp qq pq qp, fun _ => ⟨rfl,rfl⟩⟩

/-- Each of the four explicit rank-three counting cases has an invertible
basis intertwining its matrix with a size-three nilpotent block plus a nonzero
scalar. Every formal system with that split leading term has a normalized
all-orders two-block gauge. No geometric or Hodge-number identification is made. -/
theorem rankThreeCountingMatrices_split_and_formalGauge
    (label : Quantum.RankThreeCountingLabel) :
    (Quantum.rankThreeCountingBasis label).det = label.complement^3 ∧
      label.complement ≠ 0 ∧
      Quantum.labeledCountingMatrix label.toCountingLabel * Quantum.rankThreeCountingBasis label =
        Quantum.rankThreeCountingBasis label * Quantum.rankThreeCountingBlocks label.complement ∧
      ∀ system : ℕ → Matrix (Fin 4) (Fin 4) ℚ,
        system 0 = Quantum.rankThreeCountingBlocks label.complement →
        ∃ gauge reduced, Quantum.IsNormalizedGauge Quantum.rankThreeCountingBlockLabel
          system gauge reduced :=
  ⟨(Quantum.rankThreeCountingBasis_det label).1, (Quantum.rankThreeCountingBasis_det label).2,
    Quantum.rankThreeCountingBasis_intertwines label,
    Quantum.rankThreeCounting_exists_normalizedGauge label⟩

/-- A primary image with one-dimensional even part has zero odd subspace.
All vectors and products belong to the original algebra; the identity of the
primary image is the supplied nonzero central idempotent. -/
theorem superPrimary_evenRankOne_forces_odd_zero
    {K A : Type*} [Field K] [CharZero K] [Ring A] [Algebra K A]
    [FiniteDimensional K A]
    (e : A) (idempotent : e*e=e) (central : ∀ x : A, Commute e x) (nonzero : e ≠ 0)
    (even odd : Submodule K A) (unitEven : e ∈ even) (rankOne : Module.finrank K even = 1)
    (oddImage : ∀ x ∈ odd, x ∈ LinearMap.range (Algebra.lmul K A e))
    (spanning : ∀ y ∈ LinearMap.range (Algebra.lmul K A e),
      ∃ u ∈ even, ∃ v ∈ odd, y=u+v)
    (oddProductEven : ∀ x ∈ odd, ∀ y ∈ odd, x*y ∈ even)
    (anticommute : ∀ x ∈ odd, ∀ y ∈ odd, x*y=-(y*x))
    (trace : A →ₗ[K] K) (traceOdd : ∀ x ∈ odd, trace x=0)
    (nondegenerate : ∀ x : A, (∀ y : A, trace (x*y)=0) → x=0) :
    odd=⊥ :=
  Quantum.primary_odd_eq_bot_of_even_finrank_one e idempotent central nonzero even odd
    unitEven rankOne oddImage spanning oddProductEven anticommute trace traceOdd nondegenerate

/-- If all other even primary summands have dimension one, the full odd
subspace equals its intersection with the distinguished primary image. This
covers both a `2+1+1` and a `3+1` even-rank pattern, without fixing the number
of summands or assuming any odd allocation. -/
theorem superPrimary_fullOdd_allocates_to_distinguished_factor
    {K A ι : Type*} [Field K] [CharZero K] [Ring A] [Algebra K A]
    [FiniteDimensional K A] [Fintype ι]
    (even odd : Submodule K A) (e : ι → A) (selected : ι)
    (sum : ∑ i, e i = 1)
    (idempotent : ∀ i, e i*e i=e i)
    (central : ∀ i x, Commute (e i) x) (nonzero : ∀ i, e i ≠ 0)
    (unitEven : ∀ i, e i ∈ even)
    (evenStable : ∀ i x, x ∈ even → e i*x ∈ even)
    (oddStable : ∀ i x, x ∈ odd → e i*x ∈ odd)
    (rankOne : ∀ i, i ≠ selected →
      Module.finrank K ↥(even ⊓ LinearMap.range (Algebra.lmul K A (e i))) = 1)
    (spanning : ∀ y : A, ∃ u ∈ even, ∃ v ∈ odd, y=u+v)
    (oddProductEven : ∀ x ∈ odd, ∀ y ∈ odd, x*y ∈ even)
    (anticommute : ∀ x ∈ odd, ∀ y ∈ odd, x*y=-(y*x))
    (trace : A →ₗ[K] K) (traceOdd : ∀ x ∈ odd, trace x=0)
    (nondegenerate : ∀ x : A, (∀ y : A, trace (x*y)=0) → x=0) :
    odd = odd ⊓ LinearMap.range (Algebra.lmul K A (e selected)) :=
  Quantum.odd_eq_distinguished_primary_intersection even odd e selected sum idempotent central nonzero
    unitEven evenStable oddStable rankOne spanning oddProductEven anticommute
    trace traceOdd nondegenerate


/-- All nine rational rank-two cases have actual invertible splitting bases,
intertwining Euler and grading coefficients, and complete normalized formal
gauges with regularly modifiable zero blocks and their computed exact
residue discriminants. The finite label domain has exactly nine elements;
no geometric quantum-product identification is asserted. -/
theorem nineRankTwoConnections_exactResidue_certificates :
    Fintype.card Quantum.RankTwoCountingLabel=9 ∧ ∀ label : Quantum.RankTwoCountingLabel,
      (Quantum.rankTwoCountingBasis label * Quantum.rankTwoCountingBasisInverse label=1 ∧
        Quantum.rankTwoCountingBasisInverse label * Quantum.rankTwoCountingBasis label=1) ∧
      Quantum.labeledCountingMatrix label.toCountingLabel * Quantum.rankTwoCountingBasis label =
        Quantum.rankTwoCountingBasis label *
          Quantum.invertibleComplementBlocks label.complementTrace label.complementParameter ∧
      Quantum.parameterizedGradingMatrix * Quantum.rankTwoCountingBasis label =
        Quantum.rankTwoCountingBasis label * Quantum.rankTwoCountingRegular label ∧
      ∃ gauge reduced, Quantum.IsNormalizedGauge Quantum.twoByTwoBlockLabel
        (Quantum.invertibleComplementSystem label.complementTrace label.complementParameter
          (Quantum.rankTwoCountingRegular label)) gauge reduced ∧
        PowerSeries.coeff 0 (Quantum.lastRankTwoBlockSeries reduced) = Quantum.adaptedLeadingOperator 1 ∧
        (PowerSeries.coeff 1 (Quantum.lastRankTwoBlockSeries reduced)) 1 0=0 ∧
        Quantum.residueDiscriminant (Quantum.modifiedResidue (Quantum.lastRankTwoBlockSeries reduced)) =
          Quantum.rankTwoCountingDiscriminant label :=
  ⟨Quantum.rankTwoCountingLabel_card, fun label =>
    ⟨Quantum.rankTwoCountingBasis_inverse label, Quantum.rankTwoCountingBasis_intertwines label,
      Quantum.rankTwoCountingRegular_intertwines label,
      Quantum.rankTwoCounting_exists_gauge_with_exact_discriminant label⟩⟩

/-- The effective exact-spectrum target detects discriminant one and transports
its actual labels and multiplicities along injective coefficient extension. -/
theorem exactResidueSpectrum_detects_one_and_extends_coefficients
    {B C : Type*} [CommRing B] [CommRing C]
    (f : B →+* C) (injective : Function.Injective f) (δ : B) :
    Quantum.exactSpectrumAugmentation (Quantum.exactDiscriminantAtom (1 : ℚ))=1 ∧
      Finsupp.mapDomain f (Quantum.exactDiscriminantAtom δ) = Quantum.exactDiscriminantAtom (f δ) :=
  ⟨Quantum.exactDiscriminantAtom_one_detected,
    Quantum.exactDiscriminantAtom_coefficientExtension f injective δ⟩

/-- Regular horizontal comparisons with regular inverses preserve the exact
rank-two spectrum. The discriminant equality is derived from the comparison,
its adapted leading terms, and horizontal nondegenerate pairings. -/
theorem exactResidueSpectrum_invariant_under_regularComparison
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
    (leftInverse : comparison * inverse = 1) (rightInverse : inverse * comparison = 1) :
    Quantum.rankTwoExactSpectrumAtom target = Quantum.rankTwoExactSpectrumAtom source :=
  Quantum.rankTwoExactSpectrumAtom_regularComparison twoUnit horizontal inverseHorizontal sourceAdapted targetAdapted sourceInvertible targetInvertible sourceNondegenerate targetNondegenerate sourceHorizontal targetHorizontal leftInverse rightInverse

/-- Isomorphisms of the full even and odd subspaces preserve the odd selector. -/
theorem rankThreeOddSelector_invariant_under_fullFiberEquivalence
    {K A B : Type*} [Field K] [AddCommGroup A] [Module K A]
    [AddCommGroup B] [Module K B]
    (evenA oddA : Submodule K A) (evenB oddB : Submodule K B)
    (evenEquiv : evenA ≃ₗ[K] evenB) (oddEquiv : oddA ≃ₗ[K] oddB) :
    Quantum.rankThreeFullOddWeight evenA oddA = Quantum.rankThreeFullOddWeight evenB oddB :=
  Quantum.rankThreeFullOddWeight_linearEquiv evenA oddA evenB oddB evenEquiv oddEquiv


/-- Concrete regular matrix comparisons and full even/odd coordinate
isomorphisms produce an additive exact-primary ledger fold. Its singleton
values are the computed weights; invariance of these weights is derived
from the comparison evidence rather than supplied as a premise. -/
theorem exactPrimaryLedger_fold_from_regularComparisons
    {K : Type*} [Field K] [CharZero K] (presentation : Quantum.ExactPrimaryPresentation K) :
    (∀ block : Quantum.ExactPrimaryBlock K,
      presentation.fold {presentation.toBlockPresentation.component block} = block.weight) ∧
      ∀ left right : presentation.toBlockPresentation.EffectiveLedger,
        presentation.fold (left+right)=presentation.fold left+presentation.fold right :=
  ⟨presentation.fold_singleton, presentation.fold.map_add⟩

/-- The actual multivariate exponential pushforward on completed coefficient
families is injective when the integral divisor pairing separates effective
classes and every scalar weight is nonzero. Finite fibers are derived from
the supplied degree-compatible quotient. No geometric base identification,
initial-form compatibility, or injectivity premise for this map is supplied. -/
theorem completedMultivariateExponentialPushforward_injective
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : Quantum.NumericallyFiniteEffectiveQuotient
      (Homology := Curve) (Numerical := TargetCurve))
    (vector : Curve → Fin rank → ℤ) (injective : Function.Injective vector)
    (weight : Curve → K) (nonzero : ∀ curve, weight curve ≠ 0) :
    Function.Injective (Quantum.completedMultivariateTaggedPushforward data vector weight) :=
  Quantum.completedMultivariateTaggedPushforward_injective data vector injective weight nonzero

/-- Equivariance of a coordinate equivalence yields an actual equivalence of
fixed coordinate loci; inverse equivariance follows from the forward map.
The statement concerns base coordinates and performs no invariant-vector
operation on a cohomology fiber. -/
def equivariantCoordinateChange_fixedLoci
    {G X Y : Type*} [Monoid G] [MulAction G X] [MulAction G Y]
    (equiv : X ≃ Y) (equivariant : ∀ (g : G) (x : X), equiv (g • x)=g • equiv x) :
    Quantum.FixedCoordinateLocus G X ≃ Quantum.FixedCoordinateLocus G Y :=
  Quantum.coordinateEquiv_fixedLoci equiv equivariant

/-- Injective coefficient extension followed by independent polynomial
coordinate translation remains injective, with the variables polynomial. -/
theorem polynomialCoordinateExtension_and_translation_injective
    {R S σ : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (injective : Function.Injective f) (shift : σ → S) :
    Function.Injective (fun p : MvPolynomial σ R =>
      Quantum.polynomialCoordinateTranslation shift (MvPolynomial.map f p)) :=
  Quantum.polynomialCoefficientExtension_translation_injective f injective shift

/-- The constructed completed exponential ring homomorphism is faithful,
and stays faithful after adding and translating polynomial coordinates.
The effective-class quotient has finite degree fibers; the additive integral
pairing is injective and the multiplicative scalar weights are nonzero. -/
theorem faithfulCompletedExponentialRingMap_with_polynomialCoordinates
    {Curve TargetCurve K σ : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : Quantum.CompletedNumericalQuotient Curve TargetCurve)
    (pairing : Curve →+ (Fin rank → ℤ)) (injective : Function.Injective pairing)
    (weight : Multiplicative Curve →* K) (nonzero : ∀ curve, weight (.ofAdd curve) ≠ 0)
    (shift : σ → data.numericalGrading.CompletedNovikovRing (MvPowerSeries (Fin rank) K)) :
    Function.Injective (Quantum.completedExponentialRingHom data pairing weight) ∧
    Function.Injective (fun p : MvPolynomial σ (data.homologicalGrading.CompletedNovikovRing K) =>
      Quantum.polynomialCoordinateTranslation shift
        (MvPolynomial.map (Quantum.completedExponentialRingHom data pairing weight) p)) :=
  ⟨Quantum.completedExponentialRingHom_injective data pairing injective weight nonzero,
    Quantum.completedExponentialRingHom_polynomialTranslation_injective data pairing injective weight nonzero shift⟩

/-- Independent occurrence parameters give an actually nonzero shifted-operator
determinant. An injective extension preserves the same obstruction; no
spectral separation or resultant nonvanishing is assumed. -/
theorem independentOccurrenceShifts_separate_finiteOperator
    {R S ι : Type*} [CommRing R] [Nontrivial R] [CommRing S]
    [Fintype ι] [DecidableEq ι]
    (operator : Matrix ι ι R) (extension : MvPolynomial (Fin 2) R →+* S)
    (injective : Function.Injective extension) :
    (Matrix.scalar ι (MvPolynomial.X 0 - MvPolynomial.X 1) -
      operator.map (MvPolynomial.C : R →+* MvPolynomial (Fin 2) R)).det ≠ 0 ∧
    extension (Quantum.independentParameterDifference operator.charpoly) ≠ 0 :=
  ⟨Quantum.independentOccurrence_shiftedOperator_det_ne_zero operator,
    Quantum.independentOccurrence_obstruction_faithfulExtension operator extension injective⟩

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
