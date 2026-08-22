import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorDecomposition

/-!
# Projectors from coprime operator factors

Let an endomorphism be annihilated by the product of two polynomial factors.
An explicit Bezout identity for the factors gives an idempotent polynomial in
the endomorphism.  It acts as the identity on the kernel of the first factor
and as zero on the kernel of the second factor.  Consequently every
intertwiner of the endomorphisms transports this projector automatically.

The construction records the factorization, Bezout coefficients, and product
annihilation as data.  It does not infer these facts from a characteristic
polynomial, a spectral decomposition, or an external geometric comparison.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.CoprimeFactorProjector

open RowedProjectorDecomposition

universe uR uM

/-- Polynomial factor data which define the projector onto the part killed by
`markedFactor`.  The Bezout identity is ordered so that
`unmarkedCoefficient * unmarkedFactor` is one modulo `markedFactor` and zero
modulo `unmarkedFactor`. -/
structure Data
    (R : Type uR) [CommRing R]
    (M : Type uM) [AddCommGroup M] [Module R M] where
  operator : Module.End R M
  markedFactor : Polynomial R
  unmarkedFactor : Polynomial R
  markedCoefficient : Polynomial R
  unmarkedCoefficient : Polynomial R
  bezout : markedCoefficient * markedFactor +
    unmarkedCoefficient * unmarkedFactor = 1
  productAnnihilates : Polynomial.aeval operator
    (markedFactor * unmarkedFactor) = 0

namespace Data

variable
    {R : Type uR} [CommRing R]
    {M : Type uM} [AddCommGroup M] [Module R M]

/-- The Bezout polynomial which is one on the marked factor and zero on the
unmarked factor. -/
noncomputable def projectorPolynomial (data : Data R M) : Polynomial R :=
  data.unmarkedCoefficient * data.unmarkedFactor

/-- The projector polynomial is idempotent modulo the product of the two
factors. -/
theorem projectorPolynomial_sq_sub_self
    (data : Data R M) :
    data.projectorPolynomial * data.projectorPolynomial -
        data.projectorPolynomial =
      -(data.markedCoefficient * data.unmarkedCoefficient) *
        (data.markedFactor * data.unmarkedFactor) := by
  dsimp [projectorPolynomial]
  linear_combination
    (data.unmarkedCoefficient * data.unmarkedFactor) * data.bezout

/-- Evaluation of the Bezout polynomial gives an idempotent endomorphism. -/
theorem evaluatedProjector_idempotent
    (data : Data R M) (x : M) :
    Polynomial.aeval data.operator data.projectorPolynomial
        (Polynomial.aeval data.operator data.projectorPolynomial x) =
      Polynomial.aeval data.operator data.projectorPolynomial x := by
  have evaluatedDifference : Polynomial.aeval data.operator
      (data.projectorPolynomial * data.projectorPolynomial -
        data.projectorPolynomial) = 0 := by
    rw [data.projectorPolynomial_sq_sub_self]
    simp [data.productAnnihilates]
  have evaluatedIdempotence :
      Polynomial.aeval data.operator data.projectorPolynomial *
          Polynomial.aeval data.operator data.projectorPolynomial =
        Polynomial.aeval data.operator data.projectorPolynomial := by
    apply sub_eq_zero.mp
    simpa only [map_sub, map_mul] using evaluatedDifference
  simpa [Module.End.mul_apply] using
    LinearMap.congr_fun evaluatedIdempotence x

/-- The idempotent endomorphism selected by the two factors. -/
noncomputable def projector (data : Data R M) : Projector R M where
  map := Polynomial.aeval data.operator data.projectorPolynomial
  idempotent := data.evaluatedProjector_idempotent

/-- The factor projector acts as the identity on every vector killed by the
marked factor. -/
theorem projector_eq_self_of_markedFactor_eq_zero
    (data : Data R M) (x : M)
    (killed : Polynomial.aeval data.operator data.markedFactor x = 0) :
    data.projector.map x = x := by
  have evaluatedBezout := congrArg
    (fun polynomial : Polynomial R => Polynomial.aeval data.operator polynomial x)
    data.bezout
  simpa [projector, projectorPolynomial, Module.End.mul_apply, killed] using
    evaluatedBezout

/-- The factor projector vanishes on every vector killed by the unmarked
factor. -/
theorem projector_eq_zero_of_unmarkedFactor_eq_zero
    (data : Data R M) (x : M)
    (killed : Polynomial.aeval data.operator data.unmarkedFactor x = 0) :
    data.projector.map x = 0 := by
  simp [projector, projectorPolynomial, Module.End.mul_apply, killed]

/-- An operator intertwiner transports factor projectors constructed from the
same Bezout polynomial. -/
theorem projector_naturality
    {N : Type*} [AddCommGroup N] [Module R N]
    (source : Data R M) (target : Data R N)
    (comparison : M →ₗ[R] N)
    (operatorComparison : ∀ x,
      comparison (source.operator x) = target.operator (comparison x))
    (samePolynomial : source.projectorPolynomial = target.projectorPolynomial)
    (x : M) :
    comparison (source.projector.map x) =
      target.projector.map (comparison x) := by
  apply polynomialProjector_naturality R comparison source.operator
    target.operator operatorComparison source.projectorPolynomial
    source.projector target.projector rfl
  simpa [projector] using congrArg (Polynomial.aeval target.operator)
    samePolynomial.symm

end Data

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.CoprimeFactorProjector
