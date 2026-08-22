import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.ProjectiveProductMultiplicity
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.RelativeSixAxis
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisPrimaryDiscriminantSplitting
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.AssociatedGradedTagging
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompatibleMonodromySystem
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompletedDivisorSubstitution
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompletedNovikovConvolution
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.DifferentialConstantsBaseChange
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FilteredCoefficientQuotients
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FilteredFormalBaseShift
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FilteredMultivariableLaurentFlatGauge
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FormalBaseShift
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FormalBaseShiftSystem
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FormalDifferentialModuleBaseChange
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FormalStringGauge
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FramedSixthMarker
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.HirzebruchEulerSpectrum
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.HorizontalMonodromyBaseChange
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.MonodromyBaseChange
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.MultivariableFlatGaugeUniqueness
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PositiveEvaluatedFormalBaseShift
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PositiveFiltrationBulkTruncation
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PositiveFiltrationLaurentEvaluation
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ProLaurent
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ProLaurentGaugeConjugacy
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankTwoResidueMarker

/-!
# Coefficient-tower machinery

Coefficientwise base change, filtrations, completed Novikov evaluation, and pro-Laurent characteristic-polynomial towers.  Geometric and literature inputs remain explicit in the declaration types.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

open TensorProduct

open scoped MatrixGroups

/-- Reviewer-facing type of compatible invertible finite-level Laurent gauge
systems.  Every loop exponent is integral by the `LaurentSeries` coefficient
type, while no uniform lower bound across levels is imposed. -/
def proLaurentGaugeSystem
    (Index : Type*) [Fintype Index] [DecidableEq Index] : Type _ :=
  Quantum.ProLaurentGaugeSystem Index
/-- For any fixed tower of ordinary Laurent-series coefficient rings, the
levelwise invertible matrices satisfying every adjacent reduction equation
form a genuine subgroup of the product of the finite-level general linear
groups.  Thus the manuscript's pro-Laurent gauge-group notation is closed
under identity, multiplication, and inversion without imposing a Laurent
lower bound uniform across levels. -/
def proLaurentGaugeGroup
    (Index : Type*) [Fintype Index] [DecidableEq Index]
    (Coefficient : ℕ → Type*) [∀ level, CommRing (Coefficient level)]
    (reduction : ∀ level,
      LaurentSeries (Coefficient (level + 1)) →+*
        LaurentSeries (Coefficient level)) :
    Subgroup (∀ level, Matrix.GeneralLinearGroup Index
      (LaurentSeries (Coefficient level))) :=
  Quantum.proLaurentGaugeGroup Index Coefficient reduction
/-- Reviewer-facing type of finite-level characteristic polynomials compatible
under all coefficient reductions. -/
def proLaurentCharacteristicPolynomialSystem : Type _ :=
  Quantum.CompatibleCharacteristicPolynomialSystem
/-- Finite-matrix coefficientwise base change followed by conjugacy: the
resulting characteristic polynomial is exactly the coefficientwise image of
the original one. -/
theorem framedMonodromy_characteristicPolynomial_baseChange_and_gauge
    {Index R S : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [CommRing S]
    (monodromy : Matrix Index Index R) (extension : R →+* S)
    (gauge : (Matrix Index Index S)ˣ) :
    (gauge.val * monodromy.map extension * gauge.val⁻¹).charpoly =
      monodromy.charpoly.map extension :=
  Quantum.framedCharacteristicPolynomial_map_and_conjugate
    monodromy extension gauge
/-- The differential-constant step in coefficientwise base change.  Over a
field, tensoring a linear derivative with any commutative coefficient algebra
preserves its kernel: the extended constants are exactly the scalar extensions
of the original constants.  More generally, any exact presentation of the
original constants remains exact after extension.  This does not construct a
Levelt--Turrittin algebra, horizontal module, or framed-monodromy operator. -/
theorem differentialConstants_flatCoefficientBaseChange
    {k C R B : Type*} [Field k]
    [AddCommGroup C] [Module k C]
    [AddCommGroup R] [Module k R]
    [CommRing B] [Algebra k B]
    (constants : C →ₗ[k] R) (derivative : R →ₗ[k] R)
    (exact : Function.Exact constants derivative) :
    LinearMap.ker (derivative.lTensor B) =
        LinearMap.range ((LinearMap.ker derivative).subtype.lTensor B) ∧
      Function.Exact
        (constants.lTensor B) (derivative.lTensor B) :=
  ⟨Quantum.differentialConstants_baseChange derivative,
    Quantum.differentialConstants_exact_baseChange constants derivative exact⟩
/-- Derivation-level coefficientwise base change.  For a derivation of a
commutative algebra over a field, Lean constructs the coefficient-extended
derivation on `B ⊗[k] R`.  It differentiates the right tensor factor, obeys
the Leibniz rule, fixes the coefficient algebra `B`, and its constant
subalgebra is exactly the set-theoretic image of the scalar-extended original
kernel.  This is an algebraic differential-constant theorem; it does not
construct a Levelt--Turrittin solution algebra, fundamental solution,
horizontal module, inverse-limit differential algebra, or framed monodromy. -/
theorem differentialDerivation_flatCoefficientBaseChange
    {k R B : Type*} [Field k]
    [CommRing R] [Algebra k R]
    [CommRing B] [Algebra k B]
    (derivative : Derivation k R R) :
    (∀ (coefficient : B) (value : R),
      Quantum.differentialDerivationBaseChange derivative
          (coefficient ⊗ₜ[k] value) =
        coefficient ⊗ₜ[k] derivative value) ∧
    (∀ (left right : B ⊗[k] R),
      Quantum.differentialDerivationBaseChange derivative (left * right) =
        left * Quantum.differentialDerivationBaseChange derivative right +
          right * Quantum.differentialDerivationBaseChange derivative left) ∧
    (∀ coefficient : B,
      Quantum.differentialDerivationBaseChange derivative
          (algebraMap B (B ⊗[k] R) coefficient) = 0) ∧
    (Quantum.differentialDerivationConstantsSubalgebra
          (B := B) derivative : Set (B ⊗[k] R)) =
      LinearMap.range
        ((LinearMap.ker derivative.toLinearMap).subtype.lTensor B) := by
  refine ⟨Quantum.differentialDerivationBaseChange_tmul derivative,
    ?_, Quantum.differentialDerivationBaseChange_algebraMap derivative,
    Quantum.differentialDerivationConstantsSubalgebra_coe derivative⟩
  intro left right
  simpa only [smul_eq_mul] using
    Derivation.leibniz
      (Quantum.differentialDerivationBaseChange derivative) left right
/-- Horizontal-module coefficientwise base change.  A supplied linear
derivative and commuting monodromy operator restrict to the horizontal kernel.
For every commutative coefficient algebra over the ground field, the canonical
flat-base-change equivalence identifies the extended horizontal kernel with the
scalar extension of the original kernel, intertwines the two restricted
monodromy operators, and makes them conjugate.  For finite-dimensional source
space, the scalar-extended horizontal monodromy has the coefficientwise-mapped
characteristic polynomial.  This does not construct the formal differential
module, Levelt--Turrittin algebra, fundamental solution, inverse limit, or
analytic framed-monodromy operator supplying the linear data. -/
theorem horizontalMonodromy_flatCoefficientBaseChange
    {k V B : Type*} [Field k]
    [AddCommGroup V] [Module k V] [FiniteDimensional k V]
    [CommRing B] [Algebra k B]
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative) :
    (Quantum.extendedHorizontalEndomorphism derivative monodromy commutes).comp
        (Quantum.horizontalBaseChangeEquivOfField derivative).toLinearMap =
      (Quantum.horizontalBaseChangeEquivOfField derivative).toLinearMap.comp
        ((Quantum.horizontalEndomorphism derivative monodromy commutes).baseChange B) ∧
    Quantum.extendedHorizontalEndomorphism derivative monodromy commutes =
      (Quantum.horizontalBaseChangeEquivOfField derivative).conj
        ((Quantum.horizontalEndomorphism derivative monodromy commutes).baseChange B) ∧
    ((Quantum.horizontalEndomorphism derivative monodromy commutes).baseChange B).charpoly =
      (Quantum.horizontalEndomorphism derivative monodromy commutes).charpoly.map
        (algebraMap k B) :=
  ⟨Quantum.horizontalBaseChangeEquivOfField_intertwines
      derivative monodromy commutes,
    Quantum.extendedHorizontalEndomorphism_eq_conj_ofField
      derivative monodromy commutes,
    Quantum.horizontalEndomorphism_charpoly_baseChange
      derivative monodromy commutes⟩
/-- Compatible coefficient-algebra towers carry the horizontal-monodromy
characteristic polynomials as an explicit inverse system.  Every level is the
coefficientwise image of the original horizontal characteristic polynomial,
and every adjacent algebra reduction maps the higher polynomial to the lower
one.  The coefficient algebras, reductions, derivative, and commuting
monodromy are supplied; no adic realization, inverse-limit differential
module, or analytic monodromy construction is asserted. -/
theorem horizontalMonodromy_characteristicPolynomialTower
    {k V : Type*} [Field k]
    [AddCommGroup V] [Module k V] [FiniteDimensional k V]
    (tower : Quantum.HorizontalMonodromyCoefficientTower k V) :
    (∀ level,
      tower.characteristicPolynomialSystem.characteristicPolynomial level =
        (Quantum.horizontalEndomorphism tower.derivative tower.monodromy
          tower.commutes).charpoly.map
            (algebraMap k (tower.Coefficient level))) ∧
    (∀ level,
      Polynomial.map (tower.reduction level).toRingHom
          (tower.characteristicPolynomialSystem.characteristicPolynomial
            (level + 1)) =
        tower.characteristicPolynomialSystem.characteristicPolynomial level) :=
  ⟨tower.characteristicPolynomialSystem_level,
    tower.characteristicPolynomialSystem.compatible⟩
/-- Every supplied coefficient-algebra tower has canonical adjacent maps
between the scalar-extended horizontal kernels.  On pure tensors the map
applies the coefficient reduction and leaves the original horizontal vector
unchanged; for arbitrary horizontal vectors it intertwines the restricted
monodromy operators.  The derivative, monodromy, coefficient algebras, and
reductions are supplied.  No inverse-limit differential module, fundamental
solution, or analytic monodromy construction is asserted. -/
theorem horizontalMonodromy_coefficientTower_horizontalReduction
    {k V : Type*} [Field k]
    [AddCommGroup V] [Module k V]
    (tower : Quantum.HorizontalMonodromyCoefficientTower k V) :
    (∀ level (coefficient : tower.Coefficient (level + 1))
        (value : LinearMap.ker tower.derivative),
      tower.horizontalKernelReduction level
          (Quantum.horizontalBaseChangeEquivOfField tower.derivative
            (coefficient ⊗ₜ[k] value)) =
        Quantum.horizontalBaseChangeEquivOfField tower.derivative
          (tower.reduction level coefficient ⊗ₜ[k] value)) ∧
    (∀ level,
      (tower.horizontalKernelReduction level).comp
          ((Quantum.extendedHorizontalEndomorphism
            (B := tower.Coefficient (level + 1)) tower.derivative
            tower.monodromy tower.commutes).restrictScalars k) =
        ((Quantum.extendedHorizontalEndomorphism
          (B := tower.Coefficient level) tower.derivative tower.monodromy
          tower.commutes).restrictScalars k).comp
            (tower.horizontalKernelReduction level)) :=
  ⟨tower.horizontalKernelReduction_baseChange_tmul,
    tower.horizontalKernelReduction_intertwines⟩
/-- For the quotient tower of a supplied decreasing ideal filtration, every
tensor over the base coefficient algebra with an original horizontal vector
determines a compatible family of horizontal vectors.  Pure tensors reduce by
mapping only their coefficient, and extended horizontal monodromy acts on the
family by the original restricted monodromy on the horizontal tensor factor.
This constructs a map from base horizontal tensors to compatible quotient
families; it does not prove injectivity, surjectivity, coefficientwise
completeness, or an inverse-limit differential-module identification. -/
theorem horizontalMonodromy_idealFiltration_horizontalFamily
    {k V B : Type*} [Field k]
    [AddCommGroup V] [Module k V]
    [CommRing B] [Algebra k B]
    (filtration : Quantum.DecreasingIdealFiltration B)
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative) :
    let tower :=
      Quantum.HorizontalMonodromyCoefficientTower.ofIdealFiltration
        filtration derivative monodromy commutes
    let family := fun tensor : B ⊗[k] LinearMap.ker derivative =>
      Quantum.HorizontalMonodromyCoefficientTower.horizontalKernelFamilyOfBaseTensor
        filtration derivative monodromy commutes tensor
    (∀ tensor level,
      tower.horizontalKernelReduction level ((family tensor).value (level + 1)) =
        (family tensor).value level) ∧
    (∀ coefficient (horizontal : LinearMap.ker derivative) level,
      (family (coefficient ⊗ₜ[k] horizontal)).value level =
        Quantum.horizontalBaseChangeEquivOfField derivative
          (Ideal.Quotient.mk (filtration.ideal level) coefficient ⊗ₜ[k]
            horizontal)) ∧
    (∀ tensor level,
      Quantum.extendedHorizontalEndomorphism
          (B := filtration.QuotientRing level) derivative monodromy commutes
          ((family tensor).value level) =
        (family (TensorProduct.map LinearMap.id
          (Quantum.horizontalEndomorphism derivative monodromy commutes)
          tensor)).value level) := by
  dsimp only
  refine ⟨?_, ?_, ?_⟩
  · intro tensor level
    exact
      (Quantum.HorizontalMonodromyCoefficientTower.horizontalKernelFamilyOfBaseTensor
        filtration derivative monodromy commutes tensor).compatible level
  · exact
      Quantum.HorizontalMonodromyCoefficientTower.horizontalKernelFamilyOfBaseTensor_value_tmul
        filtration derivative monodromy commutes
  · exact
      Quantum.HorizontalMonodromyCoefficientTower.horizontalKernelFamilyOfBaseTensor_monodromy
        filtration derivative monodromy commutes
/-- Let the original vector space be finite dimensional and let a decreasing
ideal filtration be complete in the explicit compatible-quotient-family sense
and separated by zero ideal intersection.  Then the canonical map from tensors
over the base coefficient algebra with an original horizontal vector to
compatible horizontal vectors over every quotient level is bijective.  This is
a coefficientwise inverse-family theorem; it does not construct a topology,
categorical inverse limit, formal differential module, Levelt--Turrittin
solution algebra, or analytic monodromy operator. -/
theorem horizontalMonodromy_completeSeparatedFiltration_horizontalFamily_bijective
    {k V B : Type*} [Field k]
    [AddCommGroup V] [Module k V] [FiniteDimensional k V]
    [CommRing B] [Algebra k B]
    (filtration : Quantum.DecreasingIdealFiltration B)
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative)
    (complete : filtration.IsComplete)
    (separated : iInf filtration.ideal = ⊥) :
    Function.Bijective
      (Quantum.HorizontalMonodromyCoefficientTower.horizontalKernelFamilyOfBaseTensor
        filtration derivative monodromy commutes) :=
  Quantum.HorizontalMonodromyCoefficientTower.horizontalKernelFamilyOfBaseTensor_bijective
    filtration derivative monodromy commutes complete separated
/-- An actual adic coefficient tower carries the horizontal-monodromy
characteristic polynomials compatibly.  Let `B` be a commutative algebra over
the ground field and `I` an ideal.  Lean constructs level `n` as `B/I^n`, uses
the canonical quotient reduction from level `n+1` to level `n`, identifies
every level polynomial with the coefficientwise image of the original
horizontal characteristic polynomial, constructs that polynomial over `B`
and proves that it reduces to every level polynomial, proves adjacent
compatibility, and packages each fixed polynomial coefficient as the
compatible quotient family represented by its corresponding base-ring
coefficient.  The algebra, ideal, derivative, and commuting monodromy are
supplied; no
completeness, separatedness, formal differential module, inverse-limit
differential module, or analytic monodromy construction is asserted. -/
theorem horizontalMonodromy_adicCharacteristicPolynomialTower
    {k V B : Type*} [Field k]
    [AddCommGroup V] [Module k V] [FiniteDimensional k V]
    [CommRing B] [Algebra k B]
    (ideal : Ideal B)
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative) :
    let tower := Quantum.HorizontalMonodromyCoefficientTower.ofAdicIdeal
      ideal derivative monodromy commutes
    (∀ level,
      tower.characteristicPolynomialSystem.characteristicPolynomial level =
        (Quantum.horizontalEndomorphism derivative monodromy commutes).charpoly.map
          ((Ideal.Quotient.mk (ideal ^ level)).comp (algebraMap k B))) ∧
    (∀ level,
      Polynomial.map (Ideal.Quotient.mk (ideal ^ level))
          (Quantum.HorizontalMonodromyCoefficientTower.horizontalCharacteristicPolynomialOver
            (B := B) derivative monodromy commutes) =
        tower.characteristicPolynomialSystem.characteristicPolynomial level) ∧
    (∀ level,
      Polynomial.map ((Quantum.adicFiltration ideal).reduction level)
          (tower.characteristicPolynomialSystem.characteristicPolynomial
            (level + 1)) =
        tower.characteristicPolynomialSystem.characteristicPolynomial level) ∧
    (∀ degree,
      Quantum.HorizontalMonodromyCoefficientTower.adicCharacteristicPolynomialCoefficientFamily
          ideal derivative monodromy commutes degree =
        (Quantum.adicFiltration ideal).ofRingElement
          (algebraMap k B
            ((Quantum.horizontalEndomorphism derivative monodromy commutes).charpoly.coeff
              degree)) ∧
      (∀ level,
        (Quantum.HorizontalMonodromyCoefficientTower.adicCharacteristicPolynomialCoefficientFamily
            ideal derivative monodromy commutes degree).value level =
          ((Quantum.horizontalEndomorphism derivative monodromy commutes).charpoly.map
            ((Ideal.Quotient.mk (ideal ^ level)).comp (algebraMap k B))).coeff degree)) := by
  have adicSystem :=
    Quantum.HorizontalMonodromyCoefficientTower.ofAdicIdeal_characteristicPolynomialSystem_level_and_compatible
      ideal derivative monodromy commutes
  refine ⟨adicSystem.1, ?_, adicSystem.2, ?_⟩
  · exact
      Quantum.HorizontalMonodromyCoefficientTower.horizontalCharacteristicPolynomialOver_map_adicQuotient
        ideal derivative monodromy commutes
  intro degree
  exact ⟨Quantum.HorizontalMonodromyCoefficientTower.adicCharacteristicPolynomialCoefficientFamily_eq_ofRingElement
        ideal derivative monodromy commutes degree,
    Quantum.HorizontalMonodromyCoefficientTower.adicCharacteristicPolynomialCoefficientFamily_value
      ideal derivative monodromy commutes degree⟩
/-- Conditional formal-differential realization of the monodromy base-change
packet.  A supplied differential module and solution presentation include a
solution algebra, its extending derivation, the extended connection and
pure-tensor rule, a framed horizontal space identified with the connection
kernel, continuation commuting with the connection, and the assertion that
the solution-algebra constants are exactly the ground field.  Lean restricts
continuation to the framed horizontal space, proves coefficientwise
characteristic-polynomial base change and gauge-conjugacy invariance, and, for
a coefficientwise complete and zero-intersection adic filtration, identifies
base horizontal tensors bijectively with all compatible quotient-horizontal
families.  The same characteristic-polynomial and gauge identities hold at
every quotient level.

The differential module, solution algebra, fundamental horizontal
identification, continuation, and all differential identities are premises;
Lean does not construct the manuscript's Levelt--Turrittin algebra, formal
fundamental solution, geometric coefficient ring, or analytic continuation.
Completeness is only surjectivity onto explicit compatible quotient families,
not a topological or categorical limit theorem. -/
theorem formalDifferentialModule_solutionPresentation_baseChange
    {k K M H R B C : Type*}
    [Field k] [CommRing K] [Algebra k K]
    [AddCommGroup M] [Module k M] [Module K M] [IsScalarTower k K M]
    [AddCommGroup H] [Module k H] [Module.Free k H] [Module.Finite k H]
    [CommRing R] [Algebra k R] [Algebra K R] [IsScalarTower k K R]
    [CommRing B] [Algebra k B] [CommRing C] [Algebra k C]
    (differentialModule : Quantum.FormalDifferentialModule k K M)
    (presentation : Quantum.FormalDifferentialSolutionPresentation
      differentialModule R (H := H))
    (ideal : Ideal B) (complete : (Quantum.adicFiltration ideal).IsComplete)
    (separated : iInf (Quantum.adicFiltration ideal).ideal = ⊥)
    (gauge : (C ⊗[k] H) ≃ₗ[C] (C ⊗[k] H)) :
    presentation.framedMonodromy =
        presentation.horizontalEquiv.symm.conj
          (Quantum.horizontalEndomorphism presentation.extendedConnection
            presentation.continuation.toLinearMap
              presentation.continuation_commutes) ∧
    (presentation.framedMonodromy.baseChange C).charpoly =
      presentation.framedMonodromy.charpoly.map (algebraMap k C) ∧
    (gauge.conj (presentation.framedMonodromy.baseChange C)).charpoly =
      presentation.framedMonodromy.charpoly.map (algebraMap k C) ∧
    Function.Bijective
      (presentation.adicHorizontalFamilyOfSolutionTensor ideal) ∧
    (∀ level,
      (presentation.framedMonodromy.baseChange
        ((Quantum.adicFiltration ideal).QuotientRing level)).charpoly =
          presentation.framedMonodromy.charpoly.map
            (algebraMap k ((Quantum.adicFiltration ideal).QuotientRing level))) ∧
    (∀ level
        (levelGauge :
          ((Quantum.adicFiltration ideal).QuotientRing level ⊗[k] H) ≃ₗ[
            (Quantum.adicFiltration ideal).QuotientRing level]
              ((Quantum.adicFiltration ideal).QuotientRing level ⊗[k] H)),
      (levelGauge.conj (presentation.framedMonodromy.baseChange
        ((Quantum.adicFiltration ideal).QuotientRing level))).charpoly =
          presentation.framedMonodromy.charpoly.map
            (algebraMap k ((Quantum.adicFiltration ideal).QuotientRing level))) := by
  refine ⟨rfl, presentation.framedMonodromy_charpoly_baseChange,
    presentation.framedMonodromy_charpoly_baseChange_and_gauge gauge,
    presentation.adicHorizontalFamilyOfSolutionTensor_bijective
      ideal complete separated, ?_⟩
  exact presentation.adicFramedMonodromy_charpoly_and_gauge ideal
/-- Entrywise compatible finite-level monodromy matrices produce a compatible
inverse system of characteristic polynomials, and each derived level is the
literal characteristic polynomial of its monodromy matrix.  The differential
modules and analytic monodromy operators themselves remain supplied data.  The
formal results neither relate this matrix system to the represented pro-Laurent
gauges nor prove gauge invariance of the polynomial system. -/
theorem proLaurent_characteristicPolynomial_of_compatibleMonodromy
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : Quantum.CompatibleMonodromyMatrixSystem Index) :
    (∀ level,
      letI := system.coefficientRing level
      system.characteristicPolynomialSystem.characteristicPolynomial level =
        (system.monodromy level).charpoly) ∧
      (∀ level,
        letI := system.coefficientRing level
        letI := system.coefficientRing (level + 1)
        (system.characteristicPolynomialSystem.characteristicPolynomial
          (level + 1)).map (system.reduction level) =
            system.characteristicPolynomialSystem.characteristicPolynomial
              level) :=
  ⟨system.characteristicPolynomialSystem_level,
    system.characteristicPolynomialSystem.compatible⟩
/-- For supplied compatible Laurent-series monodromy matrices and supplied
compatible two-sided-invertible gauges, the conjugated matrices remain
compatible under reduction and have the same characteristic polynomial at
every level.  No differential or analytic origin for either family is proved. -/
theorem proLaurent_conjugatedMonodromy_compatible_and_charpoly
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : Quantum.ProLaurentMonodromyGaugeSystem Index) :
    (∀ level,
      letI := system.gaugeSystem.coefficientRing level
      letI := system.gaugeSystem.coefficientRing (level + 1)
      (system.conjugatedMonodromy (level + 1)).map
          (system.gaugeSystem.reduction level) =
        system.conjugatedMonodromy level) ∧
      (∀ level,
        letI := system.gaugeSystem.coefficientRing level
        (system.conjugatedMonodromy level).charpoly =
          (system.monodromy level).charpoly) :=
  ⟨system.conjugatedMonodromy_compatible,
    system.conjugatedMonodromy_charpoly⟩
/-- A multiplicative character of effective curve classes defines the exact
divisor substitution on a completed Novikov ring: the coefficient of `Q^d` is
multiplied by the character value at `d`.  Lean proves directly that this
coefficientwise operation preserves zero, one, addition, and completed
convolution, hence is a unital ring endomorphism.  This is the algebraic formula
`Q^d ↦ exp(⟨a₂,d⟩)Q^d` once the multiplicative exponential character is
supplied.  No geometric pairing, exponential, divisor equation, or
identification with the manuscript's completed Novikov ring is constructed. -/
theorem formalBaseShift_completedDivisorSubstitution
    {Curve Coefficient : Type*} [AddCommMonoid Curve] [CommRing Coefficient]
    (grading : Quantum.FiniteDegreeAddCommMonoid Curve)
    (weight : Multiplicative Curve →* Coefficient)
    (series : Quantum.FiniteDegreeAddCommMonoid.CompletedNovikovRing
      grading Coefficient) (curve : Curve) :
    let substitution :=
      Quantum.completedDivisorSubstitutionRingHom grading weight
    (substitution series).coefficient curve =
        weight (.ofAdd curve) * series.coefficient curve ∧
    substitution 0 = 0 ∧
    substitution 1 = 1 ∧
    (∀ left right, substitution (left + right) =
      substitution left + substitution right) ∧
    (∀ left right, substitution (left * right) =
      substitution left * substitution right) := by
  dsimp only
  exact ⟨Quantum.completedDivisorSubstitution_coefficient
      grading weight series curve,
    map_zero _, map_one _, map_add _, map_mul _⟩
/-- Over a commutative rational algebra, the scalar formal exponential
`exp(aX)` has coefficients `a^n/n!`; its scalar matrix and the matrix for
`exp(-aX)` are two-sided inverses.  The scalar gauge commutes with every square
formal-power-series matrix, so its conjugation is literally the original
matrix and its characteristic polynomial is unchanged.  This is the algebraic
string-gauge step.  Lean does not derive the scalar from a quantum string
equation, identify `X` with an inverse loop coordinate, or prove analytic
single-valuedness. -/
theorem formalBaseShift_formalStringGauge_trivial
    {Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [Algebra ℚ R] (scalar : R) (degree : ℕ)
    (monodromy : Matrix Index Index (PowerSeries R)) :
    PowerSeries.coeff degree (Quantum.formalStringExponential R scalar) =
        scalar ^ degree * algebraMap ℚ R (1 / degree.factorial) ∧
    Quantum.formalStringGauge Index R scalar *
        Quantum.formalStringGauge Index R (-scalar) = 1 ∧
    Quantum.formalStringGauge Index R (-scalar) *
        Quantum.formalStringGauge Index R scalar = 1 ∧
    Quantum.formalStringGauge Index R scalar * monodromy *
        Quantum.formalStringGauge Index R (-scalar) = monodromy ∧
    (Quantum.formalStringGauge Index R scalar * monodromy *
      Quantum.formalStringGauge Index R (-scalar)).charpoly =
        monodromy.charpoly :=
  ⟨Quantum.formalStringExponential_coefficient R scalar degree,
    Quantum.formalStringGauge_mul_inverse Index R scalar,
    Quantum.formalStringGauge_inverse_mul Index R scalar,
    Quantum.formalStringGauge_conjugation Index R scalar monodromy,
    Quantum.formalStringGauge_conjugation_charpoly Index R scalar monodromy⟩
/-- Once the finite-level string/divisor/bulk analysis supplies an explicit
integral-frame conjugacy, the bulk monodromy characteristic polynomial is the
small characteristic polynomial after the fixed divisor substitution. -/
theorem formalBaseShift_characteristicPolynomial_of_matrixInput
    {Index Coefficient : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing Coefficient]
    (input : Quantum.FormalBaseShiftMatrixInput Index Coefficient) :
    input.bulkMonodromy.charpoly =
      input.smallMonodromy.charpoly.map input.divisorSubstitution :=
  input.characteristicPolynomial_eq
/-- A decreasing ideal filtration and an endomorphism preserving every ideal
construct the finite-level quotient coefficient rings, their adjacent reductions,
and compatible quotient endomorphisms.  The three conclusions state their
action on ring classes and the reduction-substitution commuting square.  The
fourth identifies separatedness with injectivity of the canonical ring
homomorphism into the explicit compatible quotient-family ring.  The fifth
identifies bijectivity with completeness—surjectivity onto compatible
families—plus separatedness.  No proof that the supplied filtration is complete
or separated, geometric coefficient ring, monodromy matrix, or gauge is
constructed. -/
theorem filteredCoefficientQuotient_reduction_and_substitution
    {R : Type*} [CommRing R]
    (filtration : Quantum.DecreasingIdealFiltration R)
    (endomorphism : filtration.PreservingEndomorphism) (level : ℕ) :
    (∀ value : R,
      filtration.reduction level
          (Ideal.Quotient.mk (filtration.ideal (level + 1)) value) =
        Ideal.Quotient.mk (filtration.ideal level) value) ∧
      (∀ value : R,
        endomorphism.quotientEndomorphism level
            (Ideal.Quotient.mk (filtration.ideal level) value) =
          Ideal.Quotient.mk (filtration.ideal level)
            (endomorphism.toRingHom value)) ∧
      (∀ coefficient : filtration.QuotientRing (level + 1),
        filtration.reduction level
            (endomorphism.quotientEndomorphism (level + 1) coefficient) =
          endomorphism.quotientEndomorphism level
            (filtration.reduction level coefficient)) ∧
      (Function.Injective filtration.ofRingElement ↔
        iInf filtration.ideal = ⊥) ∧
      (Function.Bijective filtration.quotientFamilyRingHom ↔
        filtration.IsComplete ∧ iInf filtration.ideal = ⊥) :=
  ⟨filtration.reduction_mk level,
    endomorphism.quotientEndomorphism_mk level,
    endomorphism.reduction_quotientEndomorphism level,
    filtration.ofRingElement_injective_iff_iInf_eq_bot,
    filtration.quotientFamilyRingHom_bijective_iff_complete_and_iInf_eq_bot⟩
/-- Powers of any ideal form a decreasing filtration, and the product of an
element of order at least `m` with one of order at least `n` has order at least
`m + n`.  This constructs a multiplicative adic model; it does not identify
the manuscript's coefficient filtration with powers of a particular ideal. -/
theorem filteredCoefficientQuotient_adicFiltration_mul_mem_add
    {R : Type*} [CommRing R] (ideal : Ideal R)
    {left right : R} {leftOrder rightOrder : ℕ}
    (hleft : left ∈ (Quantum.adicFiltration ideal).ideal leftOrder)
    (hright : right ∈ (Quantum.adicFiltration ideal).ideal rightOrder) :
    left * right ∈
      (Quantum.adicFiltration ideal).ideal (leftOrder + rightOrder) :=
  Quantum.adicFiltration_mul_mem_add ideal hleft hright
/-- A ring endomorphism preserving one ideal preserves all powers of that
ideal, descends to every adic quotient, and its quotient endomorphisms commute
with adjacent reduction.  No particular ideal or endomorphism from the
manuscript is constructed. -/
theorem filteredCoefficientQuotient_adicEndomorphism_compatible
    {R : Type*} [CommRing R] (ideal : Ideal R) (endomorphism : R →+* R)
    (preserves : ∀ value, value ∈ ideal → endomorphism value ∈ ideal)
    (level : ℕ)
    (coefficient : (Quantum.adicFiltration ideal).QuotientRing (level + 1)) :
    let induced :=
      Quantum.DecreasingIdealFiltration.adicPreservingEndomorphism
        ideal endomorphism preserves
    (∀ order value,
      value ∈ (Quantum.adicFiltration ideal).ideal order →
        induced.toRingHom value ∈
          (Quantum.adicFiltration ideal).ideal order) ∧
      (∀ value : R,
        induced.quotientEndomorphism level
            (Ideal.Quotient.mk
              ((Quantum.adicFiltration ideal).ideal level) value) =
          Ideal.Quotient.mk
            ((Quantum.adicFiltration ideal).ideal level)
            (endomorphism value)) ∧
      ((Quantum.adicFiltration ideal).reduction level
          (induced.quotientEndomorphism (level + 1) coefficient) =
        induced.quotientEndomorphism level
            ((Quantum.adicFiltration ideal).reduction level coefficient)) :=
  ⟨(Quantum.DecreasingIdealFiltration.adicPreservingEndomorphism
      ideal endomorphism preserves).maps_mem,
    (Quantum.DecreasingIdealFiltration.adicPreservingEndomorphism
      ideal endomorphism preserves).quotientEndomorphism_mk level,
    (Quantum.DecreasingIdealFiltration.adicPreservingEndomorphism
      ideal endomorphism preserves).reduction_quotientEndomorphism
        level coefficient⟩
/-- Compatible finite-level small matrices, divisor substitutions, and
two-sided-invertible gauges determine compatible bulk matrices whose
characteristic polynomials are the substituted small characteristic
polynomials at every level and are themselves compatible under reduction.  Lean
also packages them as a compatible characteristic-polynomial system whose level
polynomial has both descriptions.  The filtered rings and bulk differential
equations that should produce these inputs remain unformalized. -/
theorem formalBaseShift_bulkSystem_compatible_and_charpoly
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : Quantum.FormalBaseShiftSystem Index) :
    (∀ level,
      letI := system.coefficientRing level
      letI := system.coefficientRing (level + 1)
      (system.bulkMonodromy (level + 1)).map (system.reduction level) =
        system.bulkMonodromy level) ∧
      (∀ level,
        letI := system.coefficientRing level
        (system.bulkMonodromy level).charpoly =
          (system.smallMonodromy level).charpoly.map
            (system.divisorSubstitution level)) ∧
      (∀ level,
        letI := system.coefficientRing level
        letI := system.coefficientRing (level + 1)
        ((system.bulkMonodromy (level + 1)).charpoly).map
            (system.reduction level) =
          (system.bulkMonodromy level).charpoly) ∧
      (∀ level,
        letI := system.coefficientRing level
        system.bulkCharacteristicPolynomialSystem.characteristicPolynomial level =
            (system.bulkMonodromy level).charpoly ∧
          system.bulkCharacteristicPolynomialSystem.characteristicPolynomial level =
            (system.smallMonodromy level).charpoly.map
              (system.divisorSubstitution level)) :=
  ⟨system.bulkMonodromy_compatible, system.bulkMonodromy_charpoly,
    system.bulkCharacteristicPolynomial_compatible,
    system.bulkCharacteristicPolynomialSystem_level⟩
/-- A decreasing ideal filtration and one filtration-preserving ring
endomorphism construct the coefficient rings, reductions, and divisor
substitutions of the formal base-shift packet.  Given compatible small matrices
and two-sided-invertible gauges over these actual quotients, Lean derives the
compatible bulk matrices and the compatible bulk characteristic-polynomial
system, with its substituted-small description at every level.  The filtered
base ring, endomorphism, matrices, gauges, and their compatibility identities
remain supplied; no differential equation or analytic specialization is
constructed. -/
theorem filteredFormalBaseShift_bulkSystem_compatible_and_charpoly
    {Index R : Type*} [Fintype Index] [DecidableEq Index] [CommRing R]
    {filtration : Quantum.DecreasingIdealFiltration R}
    {endomorphism : filtration.PreservingEndomorphism}
    (input : Quantum.FilteredFormalBaseShiftInput
      Index R filtration endomorphism) :
    (∀ level,
      letI := input.formalBaseShiftSystem.coefficientRing level
      letI := input.formalBaseShiftSystem.coefficientRing (level + 1)
      ((input.formalBaseShiftSystem.bulkMonodromy (level + 1)).map
        (filtration.reduction level)) =
          input.formalBaseShiftSystem.bulkMonodromy level) ∧
      (∀ level,
        letI := input.formalBaseShiftSystem.coefficientRing level
        (input.formalBaseShiftSystem.bulkMonodromy level).charpoly =
          (input.smallMonodromy level).charpoly.map
            (endomorphism.quotientEndomorphism level)) ∧
      (∀ level,
        letI := input.formalBaseShiftSystem.coefficientRing level
        letI := input.formalBaseShiftSystem.coefficientRing (level + 1)
        ((input.formalBaseShiftSystem.bulkMonodromy (level + 1)).charpoly).map
            (filtration.reduction level) =
          (input.formalBaseShiftSystem.bulkMonodromy level).charpoly) ∧
      (∀ level,
        letI := input.formalBaseShiftSystem.coefficientRing level
        (input.formalBaseShiftSystem.bulkCharacteristicPolynomialSystem).characteristicPolynomial
              level =
            (input.formalBaseShiftSystem.bulkMonodromy level).charpoly ∧
          (input.formalBaseShiftSystem.bulkCharacteristicPolynomialSystem).characteristicPolynomial
              level =
            (input.smallMonodromy level).charpoly.map
              (endomorphism.quotientEndomorphism level)) :=
  input.bulkSystem_compatible_and_characteristicPolynomial
/-- A supplied normalized multiplicative ideal filtration retains `F⁰R=R`
and `FᵐR·FⁿR⊆Fᵐ⁺ⁿR` while its actual quotient tower and a supplied preserving
endomorphism feed the compatible finite-level base-shift packet.  Small
matrices, gauges, inverses, and their compatibility laws remain supplied; no
particular geometric filtration or flat equation is constructed. -/
theorem multiplicativeFilteredFormalBaseShift_conclusion
    {Index R : Type*} [Fintype Index] [DecidableEq Index] [CommRing R]
    (filtration : Quantum.MultiplicativeIdealFiltration R)
    {endomorphism :
      filtration.toDecreasingIdealFiltration.PreservingEndomorphism}
    (input : Quantum.FilteredFormalBaseShiftInput Index R
      filtration.toDecreasingIdealFiltration endomorphism) :
    Quantum.MultiplicativeIdealFiltration.FormalBaseShiftConclusion
      filtration input :=
  filtration.formalBaseShiftConclusion input
/-- For a supplied normalized multiplicative filtration that is complete and
separated in the explicit compatible-quotient-family sense, the canonical ring
homomorphism to compatible families is bijective.  The same quotient tower and
supplied preserving endomorphism, matrices, and gauges yield the multiplicative
finite-level base-shift conclusion.  This does not prove completeness,
separatedness, multiplicativity, or geometric identification for the
manuscript's coefficient ring. -/
theorem completeSeparatedMultiplicativeFormalBaseShift_conclusion
    {Index R : Type*} [Fintype Index] [DecidableEq Index] [CommRing R]
    (filtration :
      Quantum.CompleteSeparatedMultiplicativeIdealFiltration R)
    {endomorphism : Quantum.DecreasingIdealFiltration.PreservingEndomorphism
      filtration.toMultiplicativeIdealFiltration.toDecreasingIdealFiltration}
    (input : Quantum.FilteredFormalBaseShiftInput Index R
      filtration.toMultiplicativeIdealFiltration.toDecreasingIdealFiltration
      endomorphism) :
    Function.Bijective
        (Quantum.DecreasingIdealFiltration.quotientFamilyRingHom
          filtration.toMultiplicativeIdealFiltration.toDecreasingIdealFiltration) ∧
      Quantum.MultiplicativeIdealFiltration.FormalBaseShiftConclusion
        filtration.toMultiplicativeIdealFiltration input :=
  filtration.formalBaseShiftConclusion input
/-- For the adic filtration of one ideal, preservation of the generating ideal
is enough to construct compatible quotient substitutions.  Together with
supplied compatible small matrices and invertible gauges, Lean proves the
adic multiplicative lower bound, preservation of every ideal power, and the
stated finite-level bulk matrix and characteristic-polynomial packet.  The
ideal, endomorphism, matrices, and gauges are supplied and are not identified
with the manuscript's geometric coefficient filtration or divisor shift. -/
theorem adicFormalBaseShift_bulkSystem_compatible_and_charpoly
    {Index R : Type*} [Fintype Index] [DecidableEq Index] [CommRing R]
    {ideal : Ideal R} {endomorphism : R →+* R}
    (input : Quantum.AdicFormalBaseShiftInput Index R ideal endomorphism) :
    Quantum.AdicFormalBaseShiftInput.BulkSystemConclusion input :=
  input.bulkSystem_compatible_and_characteristicPolynomial
/-- In a normalized multiplicative ideal filtration, if every supplied bulk
parameter lies in level one, the value of every bulk monomial lies in its
total-degree filtration level and vanishes in the quotient at any cutoff not
exceeding that degree.  This formalizes the positive-filtration monomial
estimate.  It does not identify the parameters with manuscript bulk
coordinates or prove that the constructed gauge is obtained by evaluating a
series in these parameters.  For every formal series it additionally exposes
the coefficientwise consequence: after multiplying each coefficient by its
parameter monomial and mapping to the cutoff quotient, this degree is zero.
No infinite evaluation sum is defined. -/
theorem multiplicativeFiltration_positiveBulkMonomial_vanishes_in_quotient
    {Coordinate R : Type*} [CommRing R]
    (filtration : Quantum.MultiplicativeIdealFiltration R)
    (parameter : Coordinate → R)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (cutoff : ℕ) (degree : Coordinate →₀ ℕ)
    (cutoff_le : cutoff ≤ Quantum.multivariableTotalDegree degree) :
    Quantum.bulkMonomialValue parameter degree ∈
        filtration.ideal (Quantum.multivariableTotalDegree degree) ∧
      Ideal.Quotient.mk (filtration.ideal cutoff)
        (Quantum.bulkMonomialValue parameter degree) = 0 ∧
      ∀ series : MvPowerSeries Coordinate R,
        MvPowerSeries.coeff degree
          (filtration.positiveSubstitutionTermsAtLevel parameter cutoff series) = 0 :=
  ⟨filtration.bulkMonomialValue_mem_totalDegree parameter positive degree,
    filtration.quotient_mk_bulkMonomialValue_eq_zero
      parameter positive cutoff degree cutoff_le,
    fun series ↦
      filtration.coeff_positiveSubstitutionTermsAtLevel_eq_zero
        parameter positive cutoff series degree cutoff_le⟩
/-- Let a zero-curvature multivariable connection have ordinary Laurent-series
coefficients over a commutative rational algebra with a normalized
multiplicative ideal filtration.  For finitely many filtration-positive bulk
parameters and one quotient cutoff, Lean constructs the normalized invertible
formal flat gauge and an actual finite quotient-level evaluation of it.  Every
term at or above the cutoff vanishes, and one integer bounds the loop exponents
of every entry of the evaluated matrix.  The finite evaluations commute with
canonical adjacent quotient reductions.  Evaluation is a ring homomorphism,
so the evaluated gauges are invertible; chosen two-sided inverses also commute
with reduction, giving an explicit pro-Laurent gauge system.  Every entrywise
loop coefficient is packaged as an explicit compatible quotient family.  This
finite sum is not an evaluation of an infinite series in a modeled topology,
and no Laurent bound uniform across levels, identification with the
manuscript's bulk gauge, or analytic specialization is proved. -/
theorem multiplicativeFiltration_positiveLaurentFlatGauge_finiteEvaluation
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : Quantum.MultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate, parameter coordinate ∈ filtration.ideal 1)
    (cutoff : ℕ)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B)))
    (curvature : ∀ first second,
      (connection second).map
          (Quantum.multivariablePartialDerivative first) -
          (connection first).map
            (Quantum.multivariablePartialDerivative second) +
          connection first * connection second -
          connection second * connection first = 0) :
    (Quantum.multivariableFlatGaugeSeries connection).map
        (MvPowerSeries.coeff 0) = 1 ∧
    IsUnit (Quantum.multivariableFlatGaugeSeries connection) ∧
    (∀ coordinate,
      (Quantum.multivariableFlatGaugeSeries connection).map
          (Quantum.multivariablePartialDerivative coordinate) =
        -(connection coordinate) *
          Quantum.multivariableFlatGaugeSeries connection) ∧
    (∀ series : MvPowerSeries Coordinate (LaurentSeries B),
      filtration.positiveLaurentEvaluationRingHomAtLevel
          parameter positive cutoff series =
        filtration.positiveLaurentEvaluationAtLevel
          parameter cutoff series) ∧
    (∀ row column degree,
      cutoff ≤ Quantum.multivariableTotalDegree degree →
        filtration.positiveLaurentEvaluationTermAtLevel parameter cutoff
          ((Quantum.multivariableFlatGaugeSeries connection) row column)
          degree = 0) ∧
    (∃ lowerBound : ℤ, ∀ row column exponent,
      exponent < lowerBound →
        (filtration.positiveEvaluatedFlatGaugeAtLevel
          parameter cutoff connection row column).coeff exponent = 0) ∧
    (filtration.positiveEvaluatedFlatGaugeAtLevel
        parameter (cutoff + 1) connection).map
        (filtration.positiveLaurentReduction cutoff) =
      filtration.positiveEvaluatedFlatGaugeAtLevel
        parameter cutoff connection ∧
    IsUnit (filtration.positiveEvaluatedFlatGaugeAtLevel
      parameter cutoff connection) ∧
    (filtration.positiveEvaluatedFlatGaugeAtLevel
        parameter cutoff connection *
          filtration.positiveEvaluatedFlatGaugeInverseAtLevel
            parameter positive cutoff connection = 1 ∧
      filtration.positiveEvaluatedFlatGaugeInverseAtLevel
          parameter positive cutoff connection *
        filtration.positiveEvaluatedFlatGaugeAtLevel
          parameter cutoff connection = 1) ∧
    (filtration.positiveEvaluatedFlatGaugeInverseAtLevel
        parameter positive (cutoff + 1) connection).map
        (filtration.positiveLaurentReduction cutoff) =
      filtration.positiveEvaluatedFlatGaugeInverseAtLevel
        parameter positive cutoff connection ∧
    (let system := filtration.positiveEvaluatedFlatGaugeSystem
        parameter positive connection;
      (∀ level, system.gauge level =
          filtration.positiveEvaluatedFlatGaugeAtLevel
            parameter level connection) ∧
        ∀ level, system.inverse level =
          filtration.positiveEvaluatedFlatGaugeInverseAtLevel
            parameter positive level connection) ∧
    ∀ row column exponent level,
      (filtration.positiveEvaluatedFlatGaugeCoefficientFamily
        parameter positive connection row column exponent).value level =
      (filtration.positiveEvaluatedFlatGaugeAtLevel
        parameter level connection row column).coeff exponent := by
  exact ⟨Quantum.multivariableFlatGaugeSeries_normalized connection,
    Quantum.multivariableFlatGaugeSeries_isUnit connection,
    Quantum.multivariableFlatGaugeSeries_equation_of_curvature
      connection curvature,
    filtration.positiveLaurentEvaluationRingHomAtLevel_apply
      parameter positive cutoff,
    fun row column degree cutoff_le ↦
      filtration.positiveEvaluatedFlatGaugeAtLevel_term_eq_zero
        parameter positive cutoff connection row column degree cutoff_le,
    filtration.positiveEvaluatedFlatGaugeAtLevel_hasUniformLowerBound
      parameter cutoff connection,
    filtration.positiveEvaluatedFlatGaugeAtLevel_compatible
      parameter positive cutoff connection,
    filtration.positiveEvaluatedFlatGaugeAtLevel_isUnit
      parameter positive cutoff connection,
    filtration.positiveEvaluatedFlatGaugeAtLevel_inverse
      parameter positive cutoff connection,
    filtration.positiveEvaluatedFlatGaugeInverseAtLevel_compatible
      parameter positive cutoff connection,
    ⟨fun _ ↦ rfl, fun _ ↦ rfl⟩,
    fun _ _ _ _ ↦ rfl⟩
/-- Let an ordinary-Laurent-series-valued multivariable connection satisfy the
exact coefficientwise zero-curvature equations, and let its normalized
multiplicative filtration additionally be complete and separated in the
explicit compatible-quotient-family sense.  If one Laurent
lower bound works at every level for the evaluated gauges and another works
at every level for their chosen inverses, Lean assembles both coefficientwise
families into Laurent-series matrices over the base ring.  They are two-sided
inverses, and their reductions are exactly the finite evaluated gauges and
chosen inverses.  The two uniform bounds are premises; Lean does not derive
them from the manuscript's filtration, identify this base ring or connection
geometrically, or prove convergence or analytic specialization. -/
theorem completeSeparatedFiltration_positiveLaurentFlatGauge_limit
    {Coordinate Index B : Type*} [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (filtration : Quantum.CompleteSeparatedMultiplicativeIdealFiltration B)
    (parameter : Coordinate → B)
    (positive : ∀ coordinate,
      parameter coordinate ∈
        filtration.toMultiplicativeIdealFiltration.ideal 1)
    (connection : Coordinate → Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries B)))
    (_curvature : ∀ first second,
      (connection second).map
          (Quantum.multivariablePartialDerivative first) -
          (connection first).map
            (Quantum.multivariablePartialDerivative second) +
          connection first * connection second -
          connection second * connection first = 0)
    (gaugeLowerBound inverseLowerBound : ℤ)
    (gaugeBounded : ∀ level row column exponent,
      exponent < gaugeLowerBound →
        (filtration.toMultiplicativeIdealFiltration
          |>.positiveEvaluatedFlatGaugeAtLevel
            parameter level connection row column).coeff exponent = 0)
    (inverseBounded : ∀ level row column exponent,
      exponent < inverseLowerBound →
        (filtration.toMultiplicativeIdealFiltration
          |>.positiveEvaluatedFlatGaugeInverseAtLevel
            parameter positive level connection row column).coeff exponent = 0) :
    let gauge := filtration.positiveEvaluatedFlatGaugeLimit
      parameter positive connection gaugeLowerBound gaugeBounded
    let inverse := filtration.positiveEvaluatedFlatGaugeInverseLimit
      parameter positive connection inverseLowerBound inverseBounded
    gauge * inverse = 1 ∧ inverse * gauge = 1 ∧
      (∀ level,
        gauge.map (Quantum.laurentSeriesMap (Ideal.Quotient.mk
          (filtration.toMultiplicativeIdealFiltration.ideal level))) =
          filtration.toMultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeAtLevel
            parameter level connection) ∧
      ∀ level,
        inverse.map (Quantum.laurentSeriesMap (Ideal.Quotient.mk
          (filtration.toMultiplicativeIdealFiltration.ideal level))) =
          filtration.toMultiplicativeIdealFiltration.positiveEvaluatedFlatGaugeInverseAtLevel
            parameter positive level connection := by
  refine ⟨(filtration.positiveEvaluatedFlatGaugeLimit_inverse
      parameter positive connection gaugeLowerBound inverseLowerBound
      gaugeBounded inverseBounded).1,
    (filtration.positiveEvaluatedFlatGaugeLimit_inverse
      parameter positive connection gaugeLowerBound inverseLowerBound
      gaugeBounded inverseBounded).2, ?_, ?_⟩
  · exact filtration.positiveEvaluatedFlatGaugeLimit_map
      parameter positive connection gaugeLowerBound gaugeBounded
  · exact filtration.positiveEvaluatedFlatGaugeInverseLimit_map
      parameter positive connection inverseLowerBound inverseBounded
/-- From a normalized multiplicative filtration, finitely many level-one bulk
parameters, and an ordinary-Laurent-valued zero-curvature connection, Lean
constructs the compatible quotient gauges used by the formal-base-shift
matrix packet.  Given compatible divisor substitutions and small monodromy
matrices, it derives the compatible bulk matrices, their levelwise substituted
characteristic-polynomial identity, and the compatible bulk-polynomial system.
The small monodromy and divisor substitution remain supplied.  No geometric
quantum connection, string/divisor equation, analytic monodromy, or comparison
result of geometric origin is constructed. -/
theorem positiveEvaluatedFormalBaseShift_bulkSystem
    {Coordinate Index B : Type*}
    [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (input : Quantum.PositiveEvaluatedFormalBaseShiftInput Coordinate Index B) :
    (∀ coordinate,
      (Quantum.multivariableFlatGaugeSeries input.connection).map
          (Quantum.multivariablePartialDerivative coordinate) =
        -(input.connection coordinate) *
          Quantum.multivariableFlatGaugeSeries input.connection) ∧
    (∀ level,
      input.formalBaseShiftSystem.gauge level =
          input.filtration.positiveEvaluatedFlatGaugeAtLevel
            input.parameter level input.connection ∧
        input.formalBaseShiftSystem.inverse level =
          input.filtration.positiveEvaluatedFlatGaugeInverseAtLevel
            input.parameter input.positive level input.connection) ∧
    (∀ level,
      letI := input.formalBaseShiftSystem.coefficientRing level
      letI := input.formalBaseShiftSystem.coefficientRing (level + 1)
      (input.formalBaseShiftSystem.bulkMonodromy (level + 1)).map
          (input.filtration.positiveLaurentReduction level) =
        input.formalBaseShiftSystem.bulkMonodromy level) ∧
    (∀ level,
      letI := input.formalBaseShiftSystem.coefficientRing level
      (input.formalBaseShiftSystem.bulkMonodromy level).charpoly =
        (input.smallMonodromy level).charpoly.map
          (input.divisorSubstitution level)) ∧
    (∀ level,
      letI := input.formalBaseShiftSystem.coefficientRing level
      letI := input.formalBaseShiftSystem.coefficientRing (level + 1)
      (input.formalBaseShiftSystem.bulkMonodromy (level + 1)).charpoly.map
          (input.filtration.positiveLaurentReduction level) =
        (input.formalBaseShiftSystem.bulkMonodromy level).charpoly) ∧
    ∀ level,
      letI := input.formalBaseShiftSystem.coefficientRing level
      input.formalBaseShiftSystem.bulkCharacteristicPolynomialSystem.characteristicPolynomial level =
          (input.formalBaseShiftSystem.bulkMonodromy level).charpoly ∧
        input.formalBaseShiftSystem.bulkCharacteristicPolynomialSystem.characteristicPolynomial level =
          (input.smallMonodromy level).charpoly.map
            (input.divisorSubstitution level) := by
  refine ⟨Quantum.multivariableFlatGaugeSeries_equation_of_curvature
      input.connection input.curvature, ?_, input.bulkSystemConclusion⟩
  exact input.formalBaseShiftSystem_gauge_inverse
/-- Strengthen the positive-evaluated formal-base-shift packet by supplying
one filtration-preserving endomorphism of the base coefficient ring instead of
separate divisor substitutions at every quotient level.  Lean constructs the
Laurent quotient substitutions, proves their canonical adjacent compatibility,
and derives the compatible bulk matrices and characteristic-polynomial
identities from the constructed evaluated gauges.  Compatible small monodromy
matrices remain supplied; no geometric identification of the endomorphism or
small monodromy is proved. -/
theorem positiveEvaluatedFilteredFormalBaseShift_substitution_and_bulkSystem
    {Coordinate Index B : Type*}
    [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (input : Quantum.PositiveEvaluatedFilteredFormalBaseShiftInput
      Coordinate Index B) :
    (∀ level,
      input.divisorSubstitution level =
        Quantum.laurentSeriesMap
          (input.divisorEndomorphism.quotientEndomorphism level)) ∧
    (∀ level coefficient,
      input.filtration.positiveLaurentReduction level
          (input.divisorSubstitution (level + 1) coefficient) =
        input.divisorSubstitution level
          (input.filtration.positiveLaurentReduction level coefficient)) ∧
    (let system := input.evaluatedInput.formalBaseShiftSystem;
      (∀ level,
        letI := system.coefficientRing level
        letI := system.coefficientRing (level + 1)
        (system.bulkMonodromy (level + 1)).map
            (input.filtration.positiveLaurentReduction level) =
          system.bulkMonodromy level) ∧
      (∀ level,
        letI := system.coefficientRing level
        (system.bulkMonodromy level).charpoly =
          (input.smallMonodromy level).charpoly.map
            (input.divisorSubstitution level)) ∧
      ∀ level,
        letI := system.coefficientRing level
        letI := system.coefficientRing (level + 1)
        (system.bulkMonodromy (level + 1)).charpoly.map
            (input.filtration.positiveLaurentReduction level) =
          (system.bulkMonodromy level).charpoly) ∧
    (let system := input.evaluatedInput.formalBaseShiftSystem;
      ∀ level,
        letI := system.coefficientRing level
        system.bulkCharacteristicPolynomialSystem.characteristicPolynomial level =
            (system.bulkMonodromy level).charpoly ∧
          system.bulkCharacteristicPolynomialSystem.characteristicPolynomial level =
            (input.smallMonodromy level).charpoly.map
              (input.divisorSubstitution level)) := by
  refine ⟨fun _ ↦ rfl, input.divisorSubstitution_compatible, ?_, ?_⟩
  · exact ⟨input.bulkSystemConclusion.1,
      input.bulkSystemConclusion.2.1,
      input.bulkSystemConclusion.2.2.1⟩
  · exact input.bulkSystemConclusion.2.2.2
/-- In the strongest algebraic branch, supply one base-ring Laurent small-
monodromy matrix as well as one filtration-preserving divisor endomorphism.
Lean constructs their compatible quotient-level small matrices and divisor
substitutions, constructs the compatible evaluated gauges from the
zero-curvature connection and positive parameters, and derives the bulk matrix
and characteristic-polynomial system.  The base small matrix, endomorphism,
connection, curvature, filtration, positive parameters, and their
filtration-one witnesses remain supplied abstract data and are not identified
with the manuscript's geometric quantum objects. -/
theorem positiveEvaluatedBaseFormalBaseShift_smallMonodromy_and_bulkSystem
    {Coordinate Index B : Type*}
    [Fintype Coordinate] [DecidableEq Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing B] [Algebra ℚ B]
    (input : Quantum.PositiveEvaluatedBaseFormalBaseShiftInput
      Coordinate Index B) :
    (∀ level,
      input.smallMonodromyAt level =
        input.baseSmallMonodromy.map
          (Quantum.laurentSeriesMap
            (Ideal.Quotient.mk (input.filtration.ideal level)))) ∧
    (∀ level,
      (input.smallMonodromyAt (level + 1)).map
          (input.filtration.positiveLaurentReduction level) =
        input.smallMonodromyAt level) ∧
    (∀ level,
      input.filteredInput.divisorSubstitution level =
        Quantum.laurentSeriesMap
          (input.divisorEndomorphism.quotientEndomorphism level)) ∧
    (∀ level coefficient,
      input.filtration.positiveLaurentReduction level
          (input.filteredInput.divisorSubstitution (level + 1) coefficient) =
        input.filteredInput.divisorSubstitution level
          (input.filtration.positiveLaurentReduction level coefficient)) ∧
    (∀ coordinate,
      (Quantum.multivariableFlatGaugeSeries input.connection).map
          (Quantum.multivariablePartialDerivative coordinate) =
        -(input.connection coordinate) *
          Quantum.multivariableFlatGaugeSeries input.connection) ∧
    (let system := input.filteredInput.evaluatedInput.formalBaseShiftSystem;
      ∀ level,
        system.gauge level =
            input.filtration.positiveEvaluatedFlatGaugeAtLevel
              input.parameter level input.connection ∧
          system.inverse level =
            input.filtration.positiveEvaluatedFlatGaugeInverseAtLevel
              input.parameter input.positive level input.connection) ∧
    (let system := input.filteredInput.evaluatedInput.formalBaseShiftSystem;
      (∀ level,
        (system.gauge (level + 1)).map
            (input.filtration.positiveLaurentReduction level) =
          system.gauge level) ∧
      ∀ level,
        (system.inverse (level + 1)).map
            (input.filtration.positiveLaurentReduction level) =
          system.inverse level) ∧
    (let system := input.filteredInput.evaluatedInput.formalBaseShiftSystem;
      (∀ level,
        letI := system.coefficientRing level
        letI := system.coefficientRing (level + 1)
        (system.bulkMonodromy (level + 1)).map
            (input.filtration.positiveLaurentReduction level) =
          system.bulkMonodromy level) ∧
      (∀ level,
        letI := system.coefficientRing level
        (system.bulkMonodromy level).charpoly =
          (input.smallMonodromyAt level).charpoly.map
            (input.filteredInput.divisorSubstitution level)) ∧
      (∀ level,
        letI := system.coefficientRing level
        letI := system.coefficientRing (level + 1)
        (system.bulkMonodromy (level + 1)).charpoly.map
            (input.filtration.positiveLaurentReduction level) =
          (system.bulkMonodromy level).charpoly) ∧
      ∀ level,
        letI := system.coefficientRing level
        system.bulkCharacteristicPolynomialSystem.characteristicPolynomial level =
            (system.bulkMonodromy level).charpoly ∧
          system.bulkCharacteristicPolynomialSystem.characteristicPolynomial level =
            (input.smallMonodromyAt level).charpoly.map
              (input.filteredInput.divisorSubstitution level)) := by
  refine ⟨fun _ ↦ rfl, input.smallMonodromyAt_compatible, fun _ ↦ rfl,
    input.filteredInput.divisorSubstitution_compatible,
    Quantum.multivariableFlatGaugeSeries_equation_of_curvature
      input.connection input.curvature,
    input.filteredInput.evaluatedInput.formalBaseShiftSystem_gauge_inverse, ?_,
    input.bulkSystemConclusion.2⟩
  exact ⟨fun level ↦ input.filtration.positiveEvaluatedFlatGaugeAtLevel_compatible
      input.parameter input.positive level input.connection,
    fun level ↦ input.filtration.positiveEvaluatedFlatGaugeInverseAtLevel_compatible
      input.parameter input.positive level input.connection⟩

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
