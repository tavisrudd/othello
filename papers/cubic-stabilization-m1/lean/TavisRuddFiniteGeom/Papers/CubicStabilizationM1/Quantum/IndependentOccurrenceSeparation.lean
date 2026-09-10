import Mathlib.Tactic
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.Algebra.MvPolynomial.Equiv

/-!
# Separation by independent occurrence parameters

The difference of two independent polynomial parameters is transcendental
over the coefficient ring: specializing the second parameter to zero and
the first to a polynomial indeterminate is a left inverse to substitution.
Thus a nonzero characteristic polynomial stays nonzero at that difference.
For a finite spectral-difference operator this is the determinant obstruction
to failure of Sylvester invertibility after occurrence shifts. Faithful scalar
extension preserves the obstruction. No numerical root sampling is used.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- Substitute the difference of two independent polynomial parameters. -/
noncomputable def independentParameterDifference
    {R : Type*} [CommRing R] : Polynomial R →ₐ[R] MvPolynomial (Fin 2) R :=
  Polynomial.aeval (MvPolynomial.X 0 - MvPolynomial.X 1)

/-- Specializing the parameters to the polynomial indeterminate and zero. -/
noncomputable def independentParameterRetraction
    {R : Type*} [CommRing R] : MvPolynomial (Fin 2) R →ₐ[R] Polynomial R :=
  MvPolynomial.aeval ![Polynomial.X,0]

/-- The two-parameter substitution has an actual algebraic left inverse. -/
theorem independentParameterDifference_leftInverse
    {R : Type*} [CommRing R] :
    Function.LeftInverse (independentParameterRetraction (R := R)) independentParameterDifference := by
  have composition : (independentParameterRetraction (R := R)).comp independentParameterDifference =
      AlgHom.id R (Polynomial R) := by
    ext
    simp [independentParameterRetraction, independentParameterDifference]
  intro p
  exact DFunLike.congr_fun composition p

/-- Every nonzero polynomial stays nonzero at the difference of independent
occurrence parameters. -/
theorem independentParameterDifference_ne_zero
    {R : Type*} [CommRing R] (p : Polynomial R) (nonzero : p ≠ 0) :
    independentParameterDifference p ≠ 0 := by
  intro zero
  apply nonzero
  exact independentParameterDifference_leftInverse.injective (zero.trans (map_zero _).symm)

/-- The characteristic polynomial of any finite operator remains nonzero at
the difference of two independent occurrence parameters. -/
theorem independentOccurrence_characteristicObstruction_ne_zero
    {R ι : Type*} [CommRing R] [Nontrivial R] [Fintype ι] [DecidableEq ι]
    (operator : Matrix ι ι R) :
    independentParameterDifference operator.charpoly ≠ 0 :=
  independentParameterDifference_ne_zero operator.charpoly operator.charpoly_monic.ne_zero

/-- Faithful scalar extension preserves the nonzero occurrence-separation
obstruction, so extension cannot create an identically coinciding pair. -/
theorem independentOccurrence_obstruction_faithfulExtension
    {R S ι : Type*} [CommRing R] [Nontrivial R] [CommRing S]
    [Fintype ι] [DecidableEq ι]
    (operator : Matrix ι ι R) (extension : MvPolynomial (Fin 2) R →+* S)
    (injective : Function.Injective extension) :
    extension (independentParameterDifference operator.charpoly) ≠ 0 := by
  intro zero
  exact independentOccurrence_characteristicObstruction_ne_zero operator
    (injective (zero.trans (map_zero extension).symm))

/-- The occurrence obstruction is the determinant of the actual shifted
operator over the two-variable polynomial ring. -/
theorem independentOccurrence_obstruction_eq_det
    {R ι : Type*} [CommRing R] [Fintype ι] [DecidableEq ι]
    (operator : Matrix ι ι R) :
    independentParameterDifference operator.charpoly =
      (Matrix.scalar ι (MvPolynomial.X 0 - MvPolynomial.X 1) -
        operator.map (MvPolynomial.C : R →+* MvPolynomial (Fin 2) R)).det := by
  rw [← Matrix.eval_charpoly, Matrix.charpoly_map, Polynomial.eval_map]
  rfl

/-- Independent shifts give a nonzero determinant for every finite operator,
including the matrix of a Sylvester difference on a finite Hom space. -/
theorem independentOccurrence_shiftedOperator_det_ne_zero
    {R ι : Type*} [CommRing R] [Nontrivial R] [Fintype ι] [DecidableEq ι]
    (operator : Matrix ι ι R) :
    (Matrix.scalar ι (MvPolynomial.X 0 - MvPolynomial.X 1) -
      operator.map (MvPolynomial.C : R →+* MvPolynomial (Fin 2) R)).det ≠ 0 := by
  rw [← independentOccurrence_obstruction_eq_det]
  exact independentOccurrence_characteristicObstruction_ne_zero operator

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
