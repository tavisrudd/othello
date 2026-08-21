import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.PaperInterface.Imports

/-!
# Reusable reviewer machinery

Reusable algebraic terminals for coefficient towers, formal base change, and
auxiliary residue and pairing calculations.  Geometric and literature inputs
remain explicit in the declaration types.
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
