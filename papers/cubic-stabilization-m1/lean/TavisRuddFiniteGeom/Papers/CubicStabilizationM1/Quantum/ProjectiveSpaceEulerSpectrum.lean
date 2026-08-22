import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FramedMultiplicity
import Mathlib.FieldTheory.Separable
import Mathlib.Analysis.Complex.Polynomial.Basic
import Mathlib.LinearAlgebra.Eigenspace.Zero

/-!
# The Euler spectrum of a specialized projective space

For projective `m`-space the small quantum relation is `H ^ (m + 1) = a`, where
`a` is the image of the Novikov monomial of the line class under the
specialization.  Quantum multiplication by `(m + 1)H` is then a matrix whose
characteristic polynomial is `X ^ (m + 1) - a` up to the scaling of the
eigenvalues by `m + 1`; this module works with the monic polynomial
`X ^ (m + 1) - C a` itself.

Over a field of characteristic zero and for `a ≠ 0` that polynomial is separable,
so each of its roots is simple.  Two consequences are recorded.  The algebraic
multiplicity of every eigenvalue of a matrix with this characteristic polynomial
is at most one, hence, by the identification of the algebraic multiplicity with
the dimension of the maximal generalized eigenspace, every spectral block of the
operator has rank at most one.  Over the complex numbers the polynomial also has
exactly `m + 1` distinct roots.

Lean constructs no quantum cohomology ring, Euler multiplication, or Novikov
specialization here; the characteristic polynomial of the operator is a
hypothesis.  Nonvanishing of the line coefficient is exactly what strict
Novikov admissibility supplies in the manuscript.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

open Polynomial

/-- The specialized small quantum relation of projective `m`-space gives a
separable polynomial when the image of the line monomial is nonzero. -/
theorem separable_projectiveSpaceRelation (dimension : ℕ) (lineCoefficient : ℂ)
    (nonzero : lineCoefficient ≠ 0) :
    (X ^ (dimension + 1) - C lineCoefficient).Separable := by
  refine Polynomial.separable_X_pow_sub_C lineCoefficient ?_ nonzero
  exact_mod_cast Nat.cast_add_one_ne_zero (R := ℂ) dimension

/-- Every root of the specialized quantum relation of projective `m`-space is
simple. -/
theorem projectiveSpaceRelation_rootMultiplicity_le_one (dimension : ℕ)
    (lineCoefficient : ℂ) (nonzero : lineCoefficient ≠ 0) (value : ℂ) :
    (X ^ (dimension + 1) - C lineCoefficient).rootMultiplicity value ≤ 1 :=
  Polynomial.rootMultiplicity_le_one_of_separable
    (separable_projectiveSpaceRelation dimension lineCoefficient nonzero) value

/-- The specialized quantum relation of projective `m`-space has exactly `m + 1`
distinct roots: over the complex numbers it has `m + 1` roots with multiplicity,
and separability makes them pairwise distinct.  These are the `m + 1` eigenvalues
of Euler multiplication displayed in the manuscript, up to the scaling that
multiplies each by `m + 1`. -/
theorem projectiveSpaceRelation_card_distinct_roots (dimension : ℕ)
    (lineCoefficient : ℂ) (nonzero : lineCoefficient ≠ 0) :
    (X ^ (dimension + 1) - C lineCoefficient).roots.toFinset.card = dimension + 1 := by
  classical
  have separable := separable_projectiveSpaceRelation dimension lineCoefficient nonzero
  have nodup : (X ^ (dimension + 1) - C lineCoefficient).roots.Nodup :=
    Polynomial.nodup_roots separable
  have degree : (X ^ (dimension + 1) - C lineCoefficient).natDegree = dimension + 1 :=
    Polynomial.natDegree_X_pow_sub_C
  have withMultiplicity : (X ^ (dimension + 1) - C lineCoefficient).roots.card = dimension + 1 := by
    rw [IsAlgClosed.card_roots_eq_natDegree (p := X ^ (dimension + 1) - C lineCoefficient), degree]
  rw [Multiset.toFinset_card_of_nodup nodup, withMultiplicity]

/-- Every spectral block of an operator whose characteristic polynomial is the
specialized quantum relation of projective `m`-space has rank at most one: the
dimension of a maximal generalized eigenspace is the algebraic multiplicity of
the eigenvalue, and separability makes every algebraic multiplicity at most
one. -/
theorem projectiveSpaceEuler_finrank_maxGenEigenspace_le_one {dimension : ℕ}
    (euler : Matrix (Fin (dimension + 1)) (Fin (dimension + 1)) ℂ)
    (lineCoefficient : ℂ) (nonzero : lineCoefficient ≠ 0)
    (quantumRelation : euler.charpoly = X ^ (dimension + 1) - C lineCoefficient)
    (value : ℂ) :
    Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler) value) ≤ 1 := by
  rw [LinearMap.finrank_maxGenEigenspace_eq, Matrix.charpoly_toLin', quantumRelation]
  exact projectiveSpaceRelation_rootMultiplicity_le_one dimension lineCoefficient nonzero value

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
