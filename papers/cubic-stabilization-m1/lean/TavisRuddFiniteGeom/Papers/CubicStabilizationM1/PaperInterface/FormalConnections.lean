import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.ProjectiveProductMultiplicity
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.RelativeSixAxis
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisPrimaryDiscriminantSplitting
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.AssociatedGradedTagging
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompatibleConstantFlatGauge
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompatibleVaryingFlatGauge
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompletedNovikovConvolution
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ConstantFlatGauge
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FilteredCoefficientQuotients
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FilteredMultivariableFlatGauge
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FilteredMultivariableLaurentFlatGauge
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FilteredVaryingFlatGauge
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.HirzebruchEulerSpectrum
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.MultivariableFlatGaugeUniqueness
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.MultivariableLaurentBounds
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PositiveFiltrationBulkTruncation
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.VaryingFlatGauge

/-!
# Formal-connection machinery

Existence and uniqueness of normalized flat gauges over constant, one-variable, and multivariable coefficient algebras.  Geometric and literature inputs remain explicit in the declaration types.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

open TensorProduct

open scoped MatrixGroups

/-- Algebraic core of faithful center base change with target-only divisor
coordinates.  The source is a completed Novikov coefficient family and has no
formal tag variables among its coefficients.  The target and its initial-form
detectors are supplied by `AssociatedGradedTaggingInput`; the compatibility
field says that the first nonzero filtered part is the finite sum of distinct
exponential characters.  Lean proves that the resulting additive pullback is
injective.

The declaration deliberately has no tag variable in the source type.  It does
not construct Iritani's reduced QDM coefficient ring, the external direct-sum
target, or their geometric identification. -/
theorem faithfulCenterBaseChange_targetOnly_injective
    {Curve K Target : Type*} [Field K] [CharZero K] [AddCommGroup Target]
    {length : Curve → ℕ} {rank : ℕ}
    (input : Quantum.AssociatedGradedTaggingInput
      Curve K Target length rank) :
    Function.Injective input.taggedImage :=
  input.taggedImage_injective

/-- For a constant finite square connection matrix over a commutative
`ℚ`-algebra, Lean constructs the normalized exponential coefficients and
proves `G₀=1`, the flat recursion `(n+1)Gₙ₊₁ = -A Gₙ` in every degree,
assembles the entrywise formal power-series matrix and proves its exact
constant-coefficient differential equation, proves that the series for the
negated matrix is its two-sided inverse, and proves coefficient compatibility
under every rational-algebra homomorphism.  No varying
quantum product, filtered quotient, Laurent loop
coordinate, truncation, uniqueness, convergence, or analytic
gauge is constructed. -/
theorem constantFlatGauge_normalized_and_recursion
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connection : Matrix Index Index R) :
    Quantum.constantFlatGaugeCoefficient connection 0 = 1 ∧
      (∀ degree : ℕ,
        (degree + 1 : R) •
            Quantum.constantFlatGaugeCoefficient connection (degree + 1) =
          -connection * Quantum.constantFlatGaugeCoefficient connection degree) ∧
      (∀ degree : ℕ,
        (Quantum.constantFlatGaugeSeries connection).map
            (PowerSeries.coeff degree) =
          Quantum.constantFlatGaugeCoefficient connection degree) ∧
      (Quantum.constantFlatGaugeSeries connection).map
          PowerSeries.derivativeFun =
        connection.map (fun value => PowerSeries.C (-value)) *
          Quantum.constantFlatGaugeSeries connection ∧
      (Quantum.constantFlatGaugeSeries connection *
            Quantum.constantFlatGaugeSeries (-connection) = 1 ∧
        Quantum.constantFlatGaugeSeries (-connection) *
            Quantum.constantFlatGaugeSeries connection = 1) ∧
      ∀ (S : Type*) [CommRing S] [Algebra ℚ S]
          (homomorphism : R →ₐ[ℚ] S) (degree : ℕ),
        (Quantum.constantFlatGaugeCoefficient connection degree).map
            homomorphism.toRingHom =
          Quantum.constantFlatGaugeCoefficient
            (connection.map homomorphism.toRingHom) degree :=
  ⟨Quantum.constantFlatGaugeCoefficient_zero connection,
    Quantum.constantFlatGaugeCoefficient_succ connection,
    Quantum.constantFlatGaugeSeries_coefficient connection,
    Quantum.constantFlatGaugeSeries_derivative connection,
    ⟨Quantum.constantFlatGaugeSeries_mul_neg_eq_one connection,
      Quantum.constantFlatGaugeSeries_neg_mul_eq_one connection⟩,
    fun _ _ _ homomorphism mappedDegree =>
      Quantum.constantFlatGaugeCoefficient_map
        homomorphism connection mappedDegree⟩
/-- For a supplied natural-number-indexed family of constant connection
matrices over commutative `ℚ`-algebras, compatible under adjacent
`ℚ`-algebra reductions, Lean proves compatibility of every normalized
exponential coefficient and of the assembled formal power-series matrices.
The negated-connection series is a compatible two-sided inverse, and at each
level the series satisfies `dG/dt = -AG`.  The coefficient system and
connection matrices are supplied abstractly; no ideal filtration, varying or
multivariable quantum connection, Laurent coordinate,
convergence, or analytic gauge is constructed. -/
theorem compatibleConstantFlatGauge_reduction_and_derivative
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : Quantum.CompatibleConstantConnectionSystem Index) :
    (∀ level degree,
      letI := system.coefficientRing level
      letI := system.coefficientRing (level + 1)
      letI := system.coefficientAlgebra level
      letI := system.coefficientAlgebra (level + 1)
      (system.gaugeCoefficient (level + 1) degree).map
          (system.reduction level).toRingHom =
        system.gaugeCoefficient level degree) ∧
    (∀ level,
      letI := system.coefficientRing level
      letI := system.coefficientRing (level + 1)
      letI := system.coefficientAlgebra level
      letI := system.coefficientAlgebra (level + 1)
      (system.gaugeSeries (level + 1)).map
          (PowerSeries.map (system.reduction level).toRingHom) =
        system.gaugeSeries level) ∧
    (∀ level,
      letI := system.coefficientRing level
      letI := system.coefficientRing (level + 1)
      letI := system.coefficientAlgebra level
      letI := system.coefficientAlgebra (level + 1)
      (system.inverseSeries (level + 1)).map
          (PowerSeries.map (system.reduction level).toRingHom) =
        system.inverseSeries level) ∧
    (∀ level,
      letI := system.coefficientRing level
      letI := system.coefficientAlgebra level
      system.gaugeSeries level * system.inverseSeries level = 1 ∧
        system.inverseSeries level * system.gaugeSeries level = 1) ∧
    ∀ level,
      letI := system.coefficientRing level
      letI := system.coefficientAlgebra level
      (system.gaugeSeries level).map PowerSeries.derivativeFun =
        (system.connection level).map
            (fun value ↦ PowerSeries.C (-value)) *
          system.gaugeSeries level :=
  ⟨system.gaugeCoefficient_compatible,
    system.gaugeSeries_compatible,
    system.inverseSeries_compatible,
    system.gaugeSeries_inverse,
    system.gaugeSeries_derivative⟩
/-- For a supplied one-variable matrix connection `A(t)` over a commutative
`ℚ`-algebra, Lean constructs the normalized series `G(t)`, proves its exact
coefficient recursion and the formal equation `dG/dt=-A(t)G(t)`, proves
uniqueness among normalized solutions, and proves that `G(t)` is an invertible
matrix over the formal power-series ring.  Both the connection series and its
normalized solution commute with rational-algebra homomorphisms.  This is a
one-variable formal result; no multivariable quantum product, filtered quotient
tower, Laurent loop coordinate, convergence, or analytic gauge is represented. -/
theorem varyingFlatGauge_normalized_unique_and_invertible
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (connectionCoefficient : ℕ → Matrix Index Index R) :
    Quantum.varyingFlatGaugeCoefficient connectionCoefficient 0 = 1 ∧
      (∀ degree : ℕ,
        (degree + 1 : R) • Quantum.varyingFlatGaugeCoefficient
            connectionCoefficient (degree + 1) =
          -∑ k ∈ Finset.range (degree + 1),
            connectionCoefficient k *
              Quantum.varyingFlatGaugeCoefficient
                connectionCoefficient (degree - k)) ∧
      (Quantum.varyingFlatGaugeSeries connectionCoefficient).map
          PowerSeries.derivativeFun =
        -(Quantum.varyingConnectionSeries connectionCoefficient) *
          Quantum.varyingFlatGaugeSeries connectionCoefficient ∧
      (∀ candidate : Matrix Index Index (PowerSeries R),
        candidate.map (PowerSeries.coeff 0) = 1 →
        candidate.map PowerSeries.derivativeFun =
          -(Quantum.varyingConnectionSeries connectionCoefficient) * candidate →
        candidate = Quantum.varyingFlatGaugeSeries connectionCoefficient) ∧
      IsUnit (Quantum.varyingFlatGaugeSeries connectionCoefficient) ∧
      ∀ (S : Type*) [CommRing S] [Algebra ℚ S]
          (homomorphism : R →ₐ[ℚ] S),
        (Quantum.varyingConnectionSeries connectionCoefficient).map
            (PowerSeries.map homomorphism.toRingHom) =
          Quantum.varyingConnectionSeries
            (fun degree ↦ (connectionCoefficient degree).map
              homomorphism.toRingHom) ∧
        (Quantum.varyingFlatGaugeSeries connectionCoefficient).map
            (PowerSeries.map homomorphism.toRingHom) =
          Quantum.varyingFlatGaugeSeries
            (fun degree ↦ (connectionCoefficient degree).map
              homomorphism.toRingHom) :=
  ⟨Quantum.varyingFlatGaugeCoefficient_zero connectionCoefficient,
    Quantum.varyingFlatGaugeCoefficient_succ connectionCoefficient,
    Quantum.varyingFlatGaugeSeries_derivative connectionCoefficient,
    fun candidate normalized flatEquation ↦
      Quantum.varyingFlatGaugeSeries_unique connectionCoefficient candidate
        normalized flatEquation,
    Quantum.varyingFlatGaugeSeries_isUnit connectionCoefficient,
    fun _ _ _ homomorphism ↦
      ⟨Quantum.varyingConnectionSeries_map homomorphism.toRingHom
          connectionCoefficient,
        Quantum.varyingFlatGaugeSeries_map homomorphism
          connectionCoefficient⟩⟩
/-- For a supplied tower of compatible one-variable connection coefficients
over commutative `ℚ`-algebras, Lean proves adjacent compatibility of every
normalized coefficient, the whole connection series, and the whole gauge
series.  At each level the constructed gauge satisfies `dG/dt=-A(t)G(t)`,
every normalized solution equals it, and it is an invertible power-series
matrix.  The tower and its
connections are supplied abstractly and are not identified with the
manuscript's filtered quotient tower or quantum connection; no multivariable,
Laurent, convergent, or analytic gauge is represented. -/
theorem compatibleVaryingFlatGauge_reduction_unique_and_invertible
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : Quantum.CompatibleVaryingConnectionSystem Index) :
    (∀ level degree,
      letI := system.coefficientRing level
      letI := system.coefficientRing (level + 1)
      letI := system.coefficientAlgebra level
      letI := system.coefficientAlgebra (level + 1)
      (system.gaugeCoefficient (level + 1) degree).map
          (system.reduction level).toRingHom =
        system.gaugeCoefficient level degree) ∧
    (∀ level,
      letI := system.coefficientRing level
      letI := system.coefficientRing (level + 1)
      letI := system.coefficientAlgebra level
      letI := system.coefficientAlgebra (level + 1)
      (system.connectionSeries (level + 1)).map
          (PowerSeries.map (system.reduction level).toRingHom) =
        system.connectionSeries level) ∧
    (∀ level,
      letI := system.coefficientRing level
      letI := system.coefficientRing (level + 1)
      letI := system.coefficientAlgebra level
      letI := system.coefficientAlgebra (level + 1)
      (system.gaugeSeries (level + 1)).map
          (PowerSeries.map (system.reduction level).toRingHom) =
        system.gaugeSeries level) ∧
    (∀ level,
      letI := system.coefficientRing level
      letI := system.coefficientAlgebra level
      (system.gaugeSeries level).map PowerSeries.derivativeFun =
        -(system.connectionSeries level) * system.gaugeSeries level) ∧
    (∀ level
        (candidate :
          letI := system.coefficientRing level
          Matrix Index Index (PowerSeries (system.Coefficient level))),
      letI := system.coefficientRing level
      letI := system.coefficientAlgebra level
      candidate.map (PowerSeries.coeff 0) = 1 →
      candidate.map PowerSeries.derivativeFun =
        -(system.connectionSeries level) * candidate →
      candidate = system.gaugeSeries level) ∧
    ∀ level,
      letI := system.coefficientRing level
      letI := system.coefficientAlgebra level
      IsUnit (system.gaugeSeries level) :=
  ⟨system.gaugeCoefficient_compatible,
    system.connectionSeries_compatible,
    system.gaugeSeries_compatible,
    system.gaugeSeries_derivative,
    fun level candidate normalized flatEquation ↦
      system.gaugeSeries_unique level candidate normalized flatEquation,
    system.gaugeSeries_isUnit⟩
/-- From a supplied commutative `ℚ`-algebra, decreasing ideal filtration, and
one-variable matrix connection over the base ring, Lean constructs the
connection and normalized gauge series over every actual quotient `R/F^n`.
Both series commute with the canonical adjacent quotient reductions; at every
level the gauge satisfies `dG/dt=-A(t)G(t)`, every normalized solution equals
it, and it is an invertible power-series matrix.  The supplied filtration and
connection are not identified with the manuscript's geometric coefficient
filtration or quantum product, and no multivariable, Laurent, convergent, or
analytic gauge is represented. -/
theorem filteredVaryingFlatGauge_quotient_reduction_unique_and_invertible
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R]
    (input : Quantum.FilteredVaryingFlatGaugeInput Index R) :
    (∀ level,
      (input.connectionSeries (level + 1)).map
          (PowerSeries.map (input.filtration.reduction level)) =
        input.connectionSeries level ∧
      (input.gaugeSeries (level + 1)).map
          (PowerSeries.map (input.filtration.reduction level)) =
        input.gaugeSeries level) ∧
    ∀ level,
      (input.gaugeSeries level).map (PowerSeries.coeff 0) = 1 ∧
        (input.gaugeSeries level).map PowerSeries.derivativeFun =
          -(input.connectionSeries level) * input.gaugeSeries level ∧
        (∀ candidate : Matrix Index Index
            (PowerSeries (input.filtration.QuotientRing level)),
          candidate.map (PowerSeries.coeff 0) = 1 →
          candidate.map PowerSeries.derivativeFun =
            -(input.connectionSeries level) * candidate →
          candidate = input.gaugeSeries level) ∧
        IsUnit (input.gaugeSeries level) :=
  ⟨input.series_compatible, input.gaugeSeries_unique_and_isUnit⟩
/-- Let one matrix-valued multivariate Laurent-coefficient connection be
supplied for each coordinate.  Any two matrix series over the multivariate
formal power-series ring that have identity constant coefficient and satisfy
the same equations `partial_i G = -A_i G` for every coordinate are equal.
Lean proves this by induction on total monomial degree.  The theorem does not
construct a solution, prove integrability of the supplied connection, give a
Laurent lower bound uniform in the monomial or a quotient level, or identify
the data with the manuscript's filtered quantum connection. -/
theorem multivariableLaurentFlatGauge_normalizedSolution_unique
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate (LaurentSeries R)))
    (left right :
      Matrix Index Index (MvPowerSeries Coordinate (LaurentSeries R)))
    (leftNormalized : left.map (MvPowerSeries.coeff 0) = 1)
    (rightNormalized : right.map (MvPowerSeries.coeff 0) = 1)
    (leftEquation : ∀ coordinate,
      left.map (Quantum.multivariablePartialDerivative coordinate) =
        -(connection coordinate) * left)
    (rightEquation : ∀ coordinate,
      right.map (Quantum.multivariablePartialDerivative coordinate) =
        -(connection coordinate) * right) :
    left = right :=
  Quantum.laurentMultivariableFlatGaugeSeries_unique connection left right
    leftNormalized rightNormalized leftEquation rightEquation
/-- Let a coordinate-indexed matrix connection over a commutative
`\mathbb{Q}`-algebra satisfy the displayed zero-curvature equation for the
coefficientwise multivariate formal partial derivatives.  Lean recursively
constructs the unique matrix-valued multivariate formal series with identity
constant coefficient satisfying every equation `partial_i G=-A_iG`, and proves
that this matrix is a unit.  The construction commutes with every
rational-algebra coefficient homomorphism.  This applies in particular to ordinary
Laurent-series coefficients.  It does not identify the connection with the
manuscript's filtered quantum connection, construct or identify the manuscript's
quotient tower and its level connections, or establish a Laurent lower bound
uniform in all bulk monomials and levels. -/
theorem multivariableFormalFlatGauge_existsUnique_of_zeroCurvature
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R))
    (curvature : ∀ first second,
      (connection second).map
            (Quantum.multivariablePartialDerivative first) -
          (connection first).map
            (Quantum.multivariablePartialDerivative second) +
          connection first * connection second -
          connection second * connection first = 0) :
    (∃! solution : Matrix Index Index (MvPowerSeries Coordinate R),
        solution.map (MvPowerSeries.coeff 0) = 1 ∧
        IsUnit solution ∧
        ∀ coordinate,
          solution.map (Quantum.multivariablePartialDerivative coordinate) =
            -(connection coordinate) * solution) ∧
      ∀ (S : Type*) [CommRing S] [Algebra ℚ S]
        (homomorphism : R →ₐ[ℚ] S),
        (Quantum.multivariableFlatGaugeSeries connection).map
            (MvPowerSeries.map homomorphism.toRingHom) =
          Quantum.multivariableFlatGaugeSeries
            (fun coordinate ↦ (connection coordinate).map
              (MvPowerSeries.map homomorphism.toRingHom)) :=
  ⟨Quantum.multivariableFlatGaugeSeries_existsUnique_of_curvature
      connection curvature,
    fun _ _ _ homomorphism ↦
      Quantum.multivariableFlatGaugeSeries_map homomorphism connection curvature⟩
/-- Let a multivariate matrix connection over a commutative rational algebra
with a decreasing ideal filtration satisfy the exact coefficientwise
zero-curvature equations.  Lean constructs its image and the unique normalized
invertible formal gauge over every actual quotient `R/F^n`.  Both the
connection and gauge commute with canonical adjacent reductions, and the
normalization, unit property, coordinate equations, and uniqueness hold at
every level.  Every matrix-entry and bulk-monomial gauge coefficient is also
packaged as an adjacent-compatible quotient family and identified with the
family represented by the corresponding base-gauge coefficient.  The supplied
filtration and connection are not identified with
the manuscript's geometric coefficient tower or quantum connection; no
uniform Laurent-order bound, inverse-limit Laurent gauge, or analytic
specialization is represented. -/
theorem filteredMultivariableFormalFlatGauge_quotient_compatible
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R] [Algebra ℚ R]
    (input : Quantum.FilteredMultivariableFlatGaugeInput Coordinate Index R)
    (level : ℕ) :
    (∀ coordinate,
      (input.connectionAt (level + 1) coordinate).map
          (MvPowerSeries.map (input.filtration.reduction level)) =
        input.connectionAt level coordinate) ∧
      (input.gaugeAt (level + 1)).map
          (MvPowerSeries.map (input.filtration.reduction level)) =
        input.gaugeAt level ∧
      (∃! solution : Matrix Index Index
          (MvPowerSeries Coordinate (input.filtration.QuotientRing level)),
        solution.map (MvPowerSeries.coeff 0) = 1 ∧
        IsUnit solution ∧
        ∀ coordinate,
          solution.map (Quantum.multivariablePartialDerivative coordinate) =
            -(input.connectionAt level coordinate) * solution) ∧
      ∀ row column degree,
        input.gaugeCoefficientFamily row column degree =
          input.filtration.ofRingElement
            (MvPowerSeries.coeff degree
              (Quantum.multivariableFlatGaugeSeries
                input.connection row column)) := by
  exact ⟨(input.connectionAt_gaugeAt_compatible level).1,
    (input.connectionAt_gaugeAt_compatible level).2,
    input.gaugeAt_existsUnique level,
    input.gaugeCoefficientFamily_eq_ofRingElement⟩
/-- Let the bulk coefficients of a zero-curvature multivariable connection be
ordinary Laurent series over a filtered commutative rational algebra.  Lean
maps the Laurent coefficients into every actual quotient, constructs the
unique normalized invertible gauge there, and proves canonical adjacent
compatibility of both connection and gauge.  At every level and bulk monomial,
the matrix entries are ordinary Laurent series and hence use integral loop
exponents with an individual lower bound.  No lower bound uniform in bulk
monomials or levels, Laurent-valued inverse-limit gauge, geometric
identification, or analytic specialization is asserted. -/
theorem filteredMultivariableLaurentFlatGauge_quotient_compatible
    {Coordinate Index B : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (input : Quantum.FilteredMultivariableLaurentFlatGaugeInput
      Coordinate Index B)
    (level : ℕ) :
    (∀ coordinate,
      (input.connectionAt (level + 1) coordinate).map
          (MvPowerSeries.map (input.laurentReduction level).toRingHom) =
        input.connectionAt level coordinate) ∧
      (input.gaugeAt (level + 1)).map
          (MvPowerSeries.map (input.laurentReduction level).toRingHom) =
        input.gaugeAt level ∧
      (∃! solution : Matrix Index Index
          (MvPowerSeries Coordinate
            (LaurentSeries (input.filtration.QuotientRing level))),
        solution.map (MvPowerSeries.coeff 0) = 1 ∧
        IsUnit solution ∧
        ∀ coordinate,
          solution.map (Quantum.multivariablePartialDerivative coordinate) =
            -(input.connectionAt level coordinate) * solution) := by
  exact ⟨(input.connectionAt_gaugeAt_compatible level).1,
    (input.connectionAt_gaugeAt_compatible level).2,
    input.gaugeAt_existsUnique level⟩
/-- At one quotient level, suppose the constructed Laurent-valued gauge has
only finitely many nonzero bulk-monomial coefficient matrices.  Lean chooses
one integer below every loop exponent occurring in every matrix entry and
bulk monomial of that gauge.  This proves the algebraic finite-support bridge
to bounded Laurent order; it does not derive finite support from the
manuscript's positive filtration or produce a bound uniform across quotient
levels. -/
theorem filteredMultivariableLaurentFlatGauge_uniformBound_of_finiteBulkSupport
    {Coordinate Index B : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (input : Quantum.FilteredMultivariableLaurentFlatGaugeInput
      Coordinate Index B)
    (level : ℕ)
    (finiteSupport : Quantum.HasFiniteBulkSupport Coordinate Index
      (input.filtration.QuotientRing level) (input.gaugeAt level)) :
    Quantum.HasMatrixBulkUniformLaurentLowerBound Coordinate Index
      (input.filtration.QuotientRing level) (input.gaugeAt level) :=
  Quantum.hasUniformLaurentLowerBound_of_finiteBulkSupport
    (input.gaugeAt level) finiteSupport
/-- Let the coordinate type be finite.  If every coefficient matrix of a
Laurent-valued multivariate series vanishes in total bulk degree at or above a
fixed cutoff, Lean constructs a finite bulk support and obtains one Laurent
lower bound for all entries and bulk monomials.  The vanishing premise is
explicit; this terminal does not derive it from the manuscript's positive
filtration or nilpotence argument. -/
theorem multivariableLaurentSeries_uniformBound_of_totalDegreeCutoff
    {Coordinate Index R : Type*} [Fintype Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R]
    (series : Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries R)))
    (cutoff : ℕ)
    (vanishes : ∀ row column degree,
      cutoff ≤ Quantum.multivariableTotalDegree degree →
        MvPowerSeries.coeff degree (series row column) = 0) :
    Quantum.HasFiniteBulkSupport Coordinate Index R series ∧
      Quantum.HasMatrixBulkUniformLaurentLowerBound Coordinate Index R series :=
  ⟨Quantum.hasFiniteBulkSupport_of_coefficients_eq_zero_of_cutoff_le_totalDegree
      series cutoff vanishes,
    Quantum.hasUniformLaurentLowerBound_of_coefficients_eq_zero_of_cutoff_le_totalDegree
      series cutoff vanishes⟩
/-- For commuting coordinate derivations on a commutative coefficient
algebra, an invertible matrix solving every equation `partial_i G=-A_iG`
forces
`partial_i A_j-partial_j A_i+A_iA_j-A_jA_i=0`.
This is a necessary integrability theorem for a supplied solution.  It neither
constructs a solution from the curvature identity nor identifies the
derivations and connection with multivariate Laurent quantum data. -/
theorem multivariableFlatGauge_invertibleSolution_curvature
    {Coordinate Index Base Coefficient : Type*}
    [Fintype Index] [DecidableEq Index]
    [CommRing Base] [CommRing Coefficient] [Algebra Base Coefficient]
    (directions : Quantum.CommutingCoordinateDerivations
      Coordinate Base Coefficient)
    (connection : Coordinate → Matrix Index Index Coefficient)
    (solution : Matrix Index Index Coefficient)
    (solutionUnit : IsUnit solution)
    (flatEquation : ∀ coordinate,
      solution.map (directions.derivation coordinate) =
        -(connection coordinate) * solution)
    (first second : Coordinate) :
    (connection second).map (directions.derivation first) -
        (connection first).map (directions.derivation second) +
        connection first * connection second -
        connection second * connection first = 0 :=
  Quantum.multivariableFlatGauge_curvature_eq_zero directions connection
    solution solutionUnit flatEquation first second
/-- On the actual multivariate formal power-series ring, the coefficientwise
partial derivatives satisfy the Leibniz rule and commute.  Consequently, an
invertible matrix solution of `partial_i G=-A_iG` forces the displayed
zero-curvature identity for those partial derivatives.  This theorem proves
necessity only; it does not construct a solution from zero curvature. -/
theorem multivariableFormalPartialDerivations_and_curvature
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R))
    (solution : Matrix Index Index (MvPowerSeries Coordinate R))
    (solutionUnit : IsUnit solution)
    (flatEquation : ∀ coordinate,
      solution.map (Quantum.multivariablePartialDerivative coordinate) =
        -(connection coordinate) * solution)
    (first second : Coordinate) :
    (∀ (coordinate : Coordinate)
        (left right : MvPowerSeries Coordinate R),
        Quantum.multivariablePartialDerivative coordinate (left * right) =
          Quantum.multivariablePartialDerivative coordinate left * right +
            left * Quantum.multivariablePartialDerivative coordinate right) ∧
      (∀ (first second : Coordinate)
          (series : MvPowerSeries Coordinate R),
        Quantum.multivariablePartialDerivative first
            (Quantum.multivariablePartialDerivative second series) =
          Quantum.multivariablePartialDerivative second
            (Quantum.multivariablePartialDerivative first series)) ∧
      ((connection second).map
            (Quantum.multivariablePartialDerivative first) -
          (connection first).map
            (Quantum.multivariablePartialDerivative second) +
          connection first * connection second -
          connection second * connection first = 0) :=
  ⟨Quantum.multivariablePartialDerivative_mul,
    Quantum.multivariablePartialDerivative_comm,
    Quantum.multivariableFlatGaugeSeries_curvature_eq_zero connection solution
      solutionUnit flatEquation first second⟩
/-- On a multivariate formal power-series coefficient ring, symmetric mixed
derivatives of the connection matrices and pairwise commutativity of those
matrices imply the exact zero-curvature identity.  These are the abstract
potentiality and commutative-associative product identities used for a
Frobenius-type quantum product.  The theorem assumes those identities explicitly; it does not
construct or identify a geometric quantum product. -/
theorem multivariableFormalConnection_curvature_of_potential_and_commutingProduct
    {Coordinate Index R : Type*} [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R]
    (connection : Coordinate →
      Matrix Index Index (MvPowerSeries Coordinate R))
    (mixedDerivative : ∀ first second,
      (connection second).map
          (Quantum.multivariablePartialDerivative first) =
        (connection first).map
          (Quantum.multivariablePartialDerivative second))
    (connectionCommutes : ∀ first second,
      connection first * connection second =
        connection second * connection first)
    (first second : Coordinate) :
    (connection second).map
          (Quantum.multivariablePartialDerivative first) -
        (connection first).map
          (Quantum.multivariablePartialDerivative second) +
        connection first * connection second -
        connection second * connection first = 0 :=
  Quantum.connection_curvature_eq_zero_of_mixedDerivative_eq_and_mul_comm
    (Quantum.multivariablePartialDerivationSystem
      (Coordinate := Coordinate) (R := R))
    connection mixedDerivative connectionCommutes first second

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
