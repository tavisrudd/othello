import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.HirzebruchEulerSpectrum
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ProjectiveSpaceEulerSpectrum
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SimpleEulerBlock

/-!
# Direct vanishing of the specialized primitive-sixth count for a Hirzebruch surface

A Hirzebruch surface is the projective bundle of a split rank-two bundle over
the projective line; these are exactly the rational geometrically ruled surfaces.
This module assembles the manuscript's two routes to the vanishing of the
specialized primitive-sixth count of such a surface.

The first route is the product decomposition, and it applies to the quadric
surface, the product of two projective lines.  The Gromov--Witten product
formula makes the specialized small quantum connection of a product the tensor
product of the two specialized factors, and the specialization restricts to each
factor.  Each factor is a projective line whose specialized quantum relation is
`H ^ 2 = a` with `a` nonzero, so its Euler spectrum is simple and its framed
regular monodromy is unipotent; the framed monodromy of the product is then
unipotent too, so the count of the product vanishes.  No relation
between the two specialized values is required, which is what makes this route
the one that settles the quadric surface: its two ruling classes may well have
the same specialized value.

The second route is the discriminant of the rank-four Euler spectrum, and it
applies to every Hirzebruch surface at a specialization with both values nonzero
that avoids the degeneracy locus of the discriminant.  The characteristic
polynomial of Euler
multiplication is one of the two quartics of
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.HirzebruchEulerSpectrum`,
and off the degeneracy locus of its discriminant every spectral block has rank
one, so the multiplicity-one Euler block lemma makes the framed regular monodromy
unipotent and the count vanishes.

Lean constructs no target variety, product, quantum connection, Novikov
specialization, or Levelt--Turrittin decomposition.  The specialized quantum
relations, the conclusion of the multiplicity-one Euler block lemma, and the
tensor compatibility of the formal decomposition enter as hypotheses; what Lean
proves is that the Euler spectra are simple and that the resulting framed
characteristic polynomial contributes nothing to the count.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Applications

open Polynomial

/-- Vanishing of the specialized primitive-sixth count for the quadric surface,
the product of two projective lines.  The hypotheses are the specialized small
quantum relations of the two factors, nonvanishing of the two specialized values,
and the conclusion drawn by the manuscript from the Gromov--Witten product
formula together with the multiplicity-one Euler block lemma: if both factors
have simple Euler spectrum, the framed monodromy of the specialized product is
unipotent, that is, its characteristic polynomial is the `rank`-th power of
`X - 1`.  Lean proves that both spectra are simple.  No relation between the
two specialized values is assumed, so the conclusion also covers the
specializations that identify the two rulings. -/
theorem quadricSurface_specialized_sixthMultiplicity_eq_zero
    (firstEuler secondEuler : Matrix (Fin 2) (Fin 2) ℂ) (firstValue secondValue : ℂ)
    (firstNonzero : firstValue ≠ 0) (secondNonzero : secondValue ≠ 0)
    (firstRelation : firstEuler.charpoly = X ^ 2 - C firstValue)
    (secondRelation : secondEuler.charpoly = X ^ 2 - C secondValue)
    (product : Quantum.FramedMonodromyMatrix)
    (tensorTriviality :
      (∀ value : ℂ,
          Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' firstEuler) value) ≤ 1) →
        (∀ value : ℂ,
          Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' secondEuler) value) ≤ 1) →
          product.operator.charpoly = (X - C (1 : ℂ)) ^ product.rank) :
    product.sixthMultiplicity = 0 := by
  have firstSimple : ∀ value : ℂ,
      Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' firstEuler) value) ≤ 1 :=
    fun value => Quantum.projectiveSpaceEuler_finrank_maxGenEigenspace_le_one (dimension := 1)
      firstEuler firstValue firstNonzero firstRelation value
  have secondSimple : ∀ value : ℂ,
      Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' secondEuler) value) ≤ 1 :=
    fun value => Quantum.projectiveSpaceEuler_finrank_maxGenEigenspace_le_one (dimension := 1)
      secondEuler secondValue secondNonzero secondRelation value
  have unitCharacteristic := tensorTriviality firstSimple secondSimple
  have contribution := Quantum.sixthMultiplicityPolynomial_unitPower_eq_zero product.rank
  simpa [Quantum.FramedMonodromyMatrix.sixthMultiplicity, Quantum.sixthMultiplicityPolynomial,
    unitCharacteristic] using contribution

/-- Vanishing of the specialized primitive-sixth count for a Hirzebruch
surface of even index.  The hypotheses are the specialized quantum
relation, in the form of the characteristic polynomial of Euler multiplication on
the rank-four even cohomology, nonvanishing of the two specialized values,
separation of those values, and the conclusion of the multiplicity-one Euler
block lemma.  Lean proves that the discriminant of the quartic does not vanish,
hence that every spectral block has rank one. -/
theorem hirzebruchEven_specialized_sixthMultiplicity_eq_zero
    (euler : Matrix (Fin 4) (Fin 4) ℂ) (fibreValue sectionValue : ℂ)
    (fibreNonzero : fibreValue ≠ 0) (sectionNonzero : sectionValue ≠ 0)
    (separated : fibreValue ≠ sectionValue)
    (quantumRelation : euler.charpoly = Quantum.hirzebruchEvenEulerCharpoly fibreValue sectionValue)
    (monodromy : Quantum.FramedMonodromyMatrix)
    (simpleBlockMonodromy :
      (∀ value : ℂ,
          Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler) value) ≤ 1) →
        monodromy.operator.charpoly = (X - C (1 : ℂ)) ^ monodromy.rank) :
    monodromy.sixthMultiplicity = 0 := by
  have blocks := Quantum.hirzebruchEvenEuler_finrank_maxGenEigenspace_le_one euler fibreValue
    sectionValue quantumRelation fibreNonzero sectionNonzero separated
  have unitCharacteristic := simpleBlockMonodromy blocks
  have contribution := Quantum.sixthMultiplicityPolynomial_unitPower_eq_zero monodromy.rank
  simpa [Quantum.FramedMonodromyMatrix.sixthMultiplicity, Quantum.sixthMultiplicityPolynomial,
    unitCharacteristic] using contribution

/-- Vanishing of the specialized primitive-sixth count for a Hirzebruch
surface of odd index.  The hypotheses are the same, with the separation
condition replaced by nonvanishing of the quadratic expression cutting out the
degeneracy locus of the odd quartic. -/
theorem hirzebruchOdd_specialized_sixthMultiplicity_eq_zero
    (euler : Matrix (Fin 4) (Fin 4) ℂ) (fibreValue sectionValue : ℂ)
    (fibreNonzero : fibreValue ≠ 0) (sectionNonzero : sectionValue ≠ 0)
    (separated : 256 * fibreValue + 27 * sectionValue ^ 2 ≠ 0)
    (quantumRelation : euler.charpoly = Quantum.hirzebruchOddEulerCharpoly fibreValue sectionValue)
    (monodromy : Quantum.FramedMonodromyMatrix)
    (simpleBlockMonodromy :
      (∀ value : ℂ,
          Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' euler) value) ≤ 1) →
        monodromy.operator.charpoly = (X - C (1 : ℂ)) ^ monodromy.rank) :
    monodromy.sixthMultiplicity = 0 := by
  have blocks := Quantum.hirzebruchOddEuler_finrank_maxGenEigenspace_le_one euler fibreValue
    sectionValue quantumRelation fibreNonzero sectionNonzero separated
  have unitCharacteristic := simpleBlockMonodromy blocks
  have contribution := Quantum.sixthMultiplicityPolynomial_unitPower_eq_zero monodromy.rank
  simpa [Quantum.FramedMonodromyMatrix.sixthMultiplicity, Quantum.sixthMultiplicityPolynomial,
    unitCharacteristic] using contribution

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
