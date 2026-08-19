import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.ParityCorrectedUnipotentMonodromy
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.ProjectiveSpaceEulerSpectrum
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.SimpleEulerBlock

/-!
# Direct vanishing of the specialized primitive-sixth count in low dimensions

This module assembles the three cases of the manuscript's direct argument, which
computes the primitive-sixth count of a specialized small even connection without
the divisor-tagging comparison.

For a target with nef canonical class the argument is spectral.  After the
half-parity correction, the gauge by the power of the loop coordinate given by
the grading operator makes the connection regular singular, and its residue is
the sum of the coefficients of Euler multiplication in the effective classes of
vanishing first Chern number, each of which raises the integral weight
filtration of the grading operator by one.  A weight-raising operator on a
finite-dimensional space is nilpotent, so the parity-corrected regular monodromy
is unipotent; undoing the correction multiplies it by an operator of square one,
and the resulting framed monodromy has only the characteristic roots `1` and
`-1`.  That case is proved in the module on parity-corrected unipotent
monodromy and is used here for the base curve of a ruled surface.

For the projective line and the projective plane the argument is a separability
calculation.  The specialized small quantum relation `H ^ (m + 1) = a` has
nonzero right-hand side, so its characteristic polynomial is separable, every
generalized eigenspace of Euler multiplication has dimension at most one, and the
multiplicity-one Euler block lemma makes the framed regular monodromy the
identity on every block.

For a geometrically ruled surface over a curve of positive genus every genus-zero
stable map to the base is constant, so the small module is a scalar extension of
a one-variable module over the base curve; the specialized and intrinsic
connections then have the same framed characteristic polynomial, the
projective-bundle formula doubles the count of the base, and the base has nef
canonical class.

Lean constructs no target variety, quantum connection, Novikov specialization, or
Levelt--Turrittin decomposition.  Strict Novikov admissibility is used in the
manuscript only to make the specialized connection well defined and, for the
projective cases, to keep the image of the line monomial nonzero; the latter
appears below as an explicit hypothesis and the former has no formal counterpart
here.  The conclusion of the multiplicity-one Euler block lemma and the
comparison identifying the specialized module of a ruled surface with the
intrinsic one likewise appear as hypotheses.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

open Polynomial

/-- Vanishing of the specialized primitive-sixth count for the projective line
and the projective plane.  The hypotheses are the specialized small quantum
relation, in the form of the characteristic polynomial of Euler multiplication,
nonvanishing of the image of the line monomial, and the conclusion of the
multiplicity-one Euler block lemma: if every generalized eigenspace of Euler
multiplication has dimension at most one, the framed regular monodromy is the
identity.  Lean proves that the eigenspaces are indeed at most one-dimensional
and concludes that the count vanishes. -/
theorem projectiveSpace_specialized_sixthMultiplicity_eq_zero {dimension : ℕ}
    (euler : Matrix (Fin (dimension + 1)) (Fin (dimension + 1)) ℂ)
    (lineCoefficient : ℂ) (lineCoefficientNonzero : lineCoefficient ≠ 0)
    (quantumRelation : euler.charpoly = X ^ (dimension + 1) - C lineCoefficient)
    (monodromy : Quantum.FramedMonodromyMatrix)
    (simpleBlockMonodromy :
      (∀ value : ℂ,
          Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler) value) ≤ 1) →
        monodromy.operator.charpoly = (X - C (1 : ℂ)) ^ monodromy.rank) :
    monodromy.sixthMultiplicity = 0 := by
  have blocks : ∀ value : ℂ,
      Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler) value) ≤ 1 :=
    fun value => Quantum.projectiveSpaceEuler_finrank_maxGenEigenspace_le_one euler
      lineCoefficient lineCoefficientNonzero quantumRelation value
  have unitCharacteristic := simpleBlockMonodromy blocks
  have contribution := Quantum.sixthMultiplicityPolynomial_unitPower_eq_zero monodromy.rank
  simpa [Quantum.FramedMonodromyMatrix.sixthMultiplicity, Quantum.sixthMultiplicityPolynomial,
    unitCharacteristic] using contribution

/-- Vanishing of the specialized primitive-sixth count for a geometrically ruled
surface over a curve of positive genus.  The hypotheses are the intrinsic
projective-bundle formula for a bundle of rank two, vanishing of the count of the
base curve, and equality of the specialized and intrinsic framed characteristic
polynomials, which is the manuscript's identification of the two modules after
scalar extension to a common algebraically closed overfield. -/
theorem ruledSurface_specialized_sixthMultiplicity_eq_zero
    (base total specialized : Quantum.FramedMonodromyMatrix)
    (baseVanishing : base.sixthMultiplicity = 0)
    (projectiveBundleFormula : total.sixthMultiplicity = 2 * base.sixthMultiplicity)
    (specializationComparison : specialized.operator.charpoly = total.operator.charpoly) :
    specialized.sixthMultiplicity = 0 := by
  have transported : specialized.sixthMultiplicity = total.sixthMultiplicity := by
    simp [Quantum.FramedMonodromyMatrix.sixthMultiplicity, specializationComparison]
  rw [transported, projectiveBundleFormula, baseVanishing, Nat.mul_zero]

/-- The same conclusion with the vanishing of the base curve's count replaced by
its proof: the canonical class of a curve of positive genus is nef, so the
spectral argument applies to the base, and its framed monodromy factors as a
parity correction times the exponential of `2πi` times a weight-raising
residue. -/
theorem ruledSurface_specialized_sixthMultiplicity_eq_zero_of_nefCanonical_base
    (base total specialized : Quantum.FramedMonodromyMatrix)
    (weight : Fin base.rank → ℤ)
    (parity residue : Matrix (Fin base.rank) (Fin base.rank) ℂ)
    (residueRaisesWeight : Quantum.RaisesWeight weight residue)
    (parityInvolution : parity * parity = 1)
    (parityCommutes : Commute parity residue)
    (baseFactorization : base.operator
      = parity * NormedSpace.exp ((2 * Real.pi * Complex.I) • residue))
    (projectiveBundleFormula : total.sixthMultiplicity = 2 * base.sixthMultiplicity)
    (specializationComparison : specialized.operator.charpoly = total.operator.charpoly) :
    specialized.sixthMultiplicity = 0 :=
  ruledSurface_specialized_sixthMultiplicity_eq_zero base total specialized
    (Quantum.sixthMultiplicity_eq_zero_of_weightRaising_residue base weight parity residue
      residueRaisesWeight parityInvolution parityCommutes baseFactorization)
    projectiveBundleFormula specializationComparison

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
