import Mathlib.LinearAlgebra.Charpoly.ToMatrix
import Mathlib.RingTheory.Derivation.Basic
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.HorizontalMonodromyBaseChange

/-!
# Formal differential modules under coefficientwise adic base change

A formal differential module over a differential coefficient ring consists of
a module with a connection satisfying the scalar Leibniz rule.  A solution
presentation supplies a differential solution algebra, the induced connection
on the scalar-extended module, a framed horizontal solution space identified
with its kernel, and a continuation automorphism commuting with that
connection.  It also records that the differential constants of the solution
algebra are exactly the ground field.

For a finite-dimensional horizontal space and a commutative ground-field
algebra with an ideal-adic filtration, Lean proves the coefficientwise part of
formal-monodromy base change.  If the adic filtration is complete in the
explicit compatible-quotient-family sense and has zero ideal intersection,
base horizontal tensors are in bijection with compatible horizontal families
over all quotients.  At each quotient, the framed-monodromy characteristic
polynomial is the coefficientwise image of the original polynomial.  Conjugacy
by any linear gauge over that quotient preserves the same polynomial.

The differential module and its solution presentation are supplied data.  In
particular, this module does not construct a Levelt--Turrittin solution algebra,
prove existence of a fundamental solution, prove that a formal Laurent gauge
is single-valued analytically, or identify the supplied coefficient algebra and
ideal with geometric quantum-cohomology data.  Completeness here is only the
stated coefficientwise lifting property; no topology or categorical inverse
limit is constructed.  All proofs are symbolic and kernel checked, with no
external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

open TensorProduct

/-- A differential module over a commutative differential coefficient ring.
The connection is linear over the ground ring and satisfies the scalar
Leibniz rule for the supplied derivation of the coefficient ring. -/
structure FormalDifferentialModule
    (k K M : Type*) [Field k] [CommRing K] [Algebra k K]
    [AddCommGroup M] [Module k M] [Module K M] [IsScalarTower k K M] where
  scalarDerivative : Derivation k K K
  connection : M →ₗ[k] M
  connection_smul : ∀ scalar vector,
    connection (scalar • vector) =
      scalarDerivative scalar • vector + scalar • connection vector

/-- A solution-algebra presentation of a formal differential module.  The
extended connection and its pure-tensor formula are supplied explicitly.  The
continuation automorphism commutes with that connection, and the differential
constants of the solution algebra are exactly the image of the ground field. -/
structure FormalDifferentialSolutionPresentation
    {k K M H : Type*} [Field k] [CommRing K] [Algebra k K]
    [AddCommGroup M] [Module k M] [Module K M] [IsScalarTower k K M]
    [AddCommGroup H] [Module k H]
    (differentialModule : FormalDifferentialModule k K M)
    (R : Type*) [CommRing R] [Algebra k R] [Algebra K R]
    [IsScalarTower k K R] where
  solutionDerivative : Derivation k R R
  solutionDerivative_algebraMap : ∀ scalar,
    solutionDerivative (algebraMap K R scalar) =
      algebraMap K R (differentialModule.scalarDerivative scalar)
  extendedConnection : (R ⊗[K] M) →ₗ[k] (R ⊗[K] M)
  extendedConnection_tmul : ∀ coefficient vector,
    extendedConnection (coefficient ⊗ₜ[K] vector) =
      solutionDerivative coefficient ⊗ₜ[K] vector +
        coefficient ⊗ₜ[K] differentialModule.connection vector
  horizontalEquiv : H ≃ₗ[k] LinearMap.ker extendedConnection
  continuation : (R ⊗[K] M) ≃ₗ[k] (R ⊗[K] M)
  continuation_commutes :
    extendedConnection.comp continuation.toLinearMap =
      continuation.toLinearMap.comp extendedConnection
  constants_eq_groundField : ∀ value,
    solutionDerivative value = 0 ↔
      ∃ scalar : k, algebraMap k R scalar = value

namespace FormalDifferentialSolutionPresentation

variable {k K M H R : Type*} [Field k] [CommRing K] [Algebra k K]
  [AddCommGroup M] [Module k M] [Module K M] [IsScalarTower k K M]
  [AddCommGroup H] [Module k H]
  [CommRing R] [Algebra k R] [Algebra K R] [IsScalarTower k K R]
  {differentialModule : FormalDifferentialModule k K M}

/-- Framed formal monodromy on the horizontal space of a supplied solution
presentation is the restriction of continuation to the kernel of the extended
connection. -/
noncomputable def framedMonodromy
    (presentation :
      FormalDifferentialSolutionPresentation differentialModule R (H := H)) :
    H →ₗ[k] H :=
  presentation.horizontalEquiv.symm.conj <|
    horizontalEndomorphism presentation.extendedConnection
      presentation.continuation.toLinearMap presentation.continuation_commutes

/-- Coefficient extension maps every coefficient of framed formal monodromy's
characteristic polynomial along the ground-field algebra map. -/
theorem framedMonodromy_charpoly_baseChange
    (presentation :
      FormalDifferentialSolutionPresentation differentialModule R (H := H))
    [Module.Free k H] [Module.Finite k H]
    {B : Type*} [CommRing B] [Algebra k B] :
    (presentation.framedMonodromy.baseChange B).charpoly =
      presentation.framedMonodromy.charpoly.map (algebraMap k B) :=
  LinearMap.charpoly_baseChange presentation.framedMonodromy B

/-- A linear gauge over the extended coefficient algebra conjugates framed
formal monodromy without changing its coefficientwise base-changed
characteristic polynomial. -/
theorem framedMonodromy_charpoly_baseChange_and_gauge
    (presentation :
      FormalDifferentialSolutionPresentation differentialModule R (H := H))
    [Module.Free k H] [Module.Finite k H]
    {B : Type*} [CommRing B] [Algebra k B]
    (gauge : (B ⊗[k] H) ≃ₗ[B] (B ⊗[k] H)) :
    (gauge.conj (presentation.framedMonodromy.baseChange B)).charpoly =
      presentation.framedMonodromy.charpoly.map (algebraMap k B) := by
  rw [gauge.charpoly_conj]
  exact presentation.framedMonodromy_charpoly_baseChange

/-- Scalar extension of the supplied framed-horizontal identification. -/
noncomputable def horizontalTensorEquiv
    (presentation :
      FormalDifferentialSolutionPresentation differentialModule R (H := H))
    (B : Type*) [CommRing B] [Algebra k B] :
    (B ⊗[k] H) ≃ₗ[B]
      (B ⊗[k] LinearMap.ker presentation.extendedConnection) :=
  TensorProduct.AlgebraTensorModule.congr
    (LinearEquiv.refl B B) presentation.horizontalEquiv

/-- A framed horizontal tensor determines its coefficientwise compatible
family in all quotients of an adic coefficient algebra. -/
noncomputable def adicHorizontalFamilyOfSolutionTensor
    (presentation :
      FormalDifferentialSolutionPresentation differentialModule R (H := H))
    {B : Type*} [CommRing B] [Algebra k B]
    (ideal : Ideal B) (tensor : B ⊗[k] H) :=
  HorizontalMonodromyCoefficientTower.horizontalKernelFamilyOfBaseTensor
    (adicFiltration ideal) presentation.extendedConnection
      presentation.continuation.toLinearMap presentation.continuation_commutes
        (presentation.horizontalTensorEquiv B tensor)

/-- For a coefficientwise complete and zero-intersection ideal-adic
filtration, framed horizontal tensors are exactly the compatible horizontal
families over all quotient levels. -/
theorem adicHorizontalFamilyOfSolutionTensor_bijective
    (presentation :
      FormalDifferentialSolutionPresentation differentialModule R (H := H))
    [Module.Free k H] [Module.Finite k H]
    {B : Type*} [CommRing B] [Algebra k B]
    (ideal : Ideal B) (complete : (adicFiltration ideal).IsComplete)
    (separated : iInf (adicFiltration ideal).ideal = ⊥) :
    Function.Bijective
      (presentation.adicHorizontalFamilyOfSolutionTensor ideal) := by
  letI : FiniteDimensional k (LinearMap.ker presentation.extendedConnection) :=
    presentation.horizontalEquiv.finiteDimensional
  exact
    (HorizontalMonodromyCoefficientTower.horizontalKernelFamilyOfBaseTensor_bijective
      (adicFiltration ideal) presentation.extendedConnection
        presentation.continuation.toLinearMap presentation.continuation_commutes
          complete separated).comp
      (presentation.horizontalTensorEquiv B).bijective

/-- At every adic quotient, framed formal monodromy has the coefficientwise
image of the original characteristic polynomial; conjugacy by any quotient
linear gauge preserves that equality. -/
theorem adicFramedMonodromy_charpoly_and_gauge
    (presentation :
      FormalDifferentialSolutionPresentation differentialModule R (H := H))
    [Module.Free k H] [Module.Finite k H]
    {B : Type*} [CommRing B] [Algebra k B]
    (ideal : Ideal B) :
    (∀ level,
      (presentation.framedMonodromy.baseChange
        ((adicFiltration ideal).QuotientRing level)).charpoly =
          presentation.framedMonodromy.charpoly.map
            (algebraMap k ((adicFiltration ideal).QuotientRing level))) ∧
    (∀ level
        (gauge :
          ((adicFiltration ideal).QuotientRing level ⊗[k]
              H) ≃ₗ[
                (adicFiltration ideal).QuotientRing level]
            ((adicFiltration ideal).QuotientRing level ⊗[k]
              H)),
      (gauge.conj (presentation.framedMonodromy.baseChange
        ((adicFiltration ideal).QuotientRing level))).charpoly =
          presentation.framedMonodromy.charpoly.map
            (algebraMap k ((adicFiltration ideal).QuotientRing level))) := by
  constructor
  · intro level
    exact presentation.framedMonodromy_charpoly_baseChange
  · intro level gauge
    exact presentation.framedMonodromy_charpoly_baseChange_and_gauge gauge

end FormalDifferentialSolutionPresentation

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
