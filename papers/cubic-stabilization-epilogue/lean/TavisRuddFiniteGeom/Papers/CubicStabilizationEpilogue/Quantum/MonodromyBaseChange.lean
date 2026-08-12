import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic

/-!
# Characteristic polynomials under coefficient extension and conjugacy

This module proves the finite-matrix algebra used after the framed monodromy
operator has been constructed.  It does not construct horizontal solutions or
identify differential constants after adic base change.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

/-- Mapping the coefficients of a finite framed-monodromy matrix maps its
characteristic polynomial coefficientwise. -/
theorem framedCharacteristicPolynomial_map
    {Index R S : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [CommRing S]
    (monodromy : Matrix Index Index R) (extension : R →+* S) :
    (monodromy.map extension).charpoly = monodromy.charpoly.map extension :=
  Matrix.charpoly_map monodromy extension

/-- After coefficient extension, conjugating by an invertible matrix preserves
the mapped characteristic polynomial.  In the manuscript this is applied only
after proving that an integral-`z` gauge is single-valued on the original
disc. -/
theorem framedCharacteristicPolynomial_map_and_conjugate
    {Index R S : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R] [CommRing S]
    (monodromy : Matrix Index Index R) (extension : R →+* S)
    (gauge : (Matrix Index Index S)ˣ) :
    (gauge.val * monodromy.map extension * gauge.val⁻¹).charpoly =
      monodromy.charpoly.map extension := by
  rw [Matrix.charpoly_units_conj]
  exact Matrix.charpoly_map monodromy extension

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
