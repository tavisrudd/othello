import Mathlib.Tactic

/-!
# Binary-polyhedral invariant averages for the prime-field detectors

For a semisimple element of a two-dimensional special-linear group with
eigenvalues `ζ, ζ⁻¹`, the character of the restricted simple `L(s)` is the
classical symmetric-power sum

`ζ^s + ζ^(s-2) + ⋯ + ζ^(-s)`.

At the lift orders occurring in the binary tetrahedral, octahedral, and
icosahedral groups, the detector weights `s = 6, 8, 12` give the character
rows encoded below.  The theorems check the complete class-size averages.
For the two icosahedral order-five channels the values are `φ` and `1-φ`;
their golden parts cancel before division.  Thus the calculation is valid in
every coefficient field in which the relevant group order is nonzero.

The identification of these rows with the named subgroup conjugacy classes is
classical character theory.  This module proves the paper-specific weighted
average and its characteristic boundary, rather than importing a numerical
invariant-dimension assertion.
-/

namespace RelativeConicArcs.ClebschPolyhedralInvariantAverages

/-- The `L(6)` tetrahedral character row has average one. -/
theorem tetrahedral_character_sum :
    1 * 7 + 3 * (-1) + 8 * 1 = (12 : ℤ) := by
  norm_num

/-- The `L(8)` octahedral character row has average one. -/
theorem octahedral_character_sum :
    1 * 9 + 9 * 1 + 8 * 0 + 6 * 1 = (24 : ℤ) := by
  norm_num

/-- The two golden character values in the `L(12)` icosahedral row cancel in
the full weighted sum. -/
theorem icosahedral_character_sum {K : Type*} [CommRing K] (φ : K) :
    1 * (13 : K) + 15 * 1 + 20 * 1 + 12 * φ + 12 * (1 - φ) = 60 := by
  ring

/-- Dividing the tetrahedral character sum by the group order gives one away
from characteristics two and three. -/
theorem tetrahedral_average_eq_one {K : Type*} [Field K]
    (horder : (12 : K) ≠ 0) :
    ((7 : K) + 3 * (-1) + 8) / 12 = 1 := by
  field_simp
  ring

/-- Dividing the octahedral character sum by the group order gives one away
from characteristics two and three. -/
theorem octahedral_average_eq_one {K : Type*} [Field K]
    (horder : (24 : K) ≠ 0) :
    ((9 : K) + 9 + 8 * 0 + 6) / 24 = 1 := by
  field_simp
  ring

/-- Dividing the icosahedral character sum by the group order gives one once
the golden pair has been combined, away from characteristics two, three, and
five. -/
theorem icosahedral_average_eq_one {K : Type*} [Field K]
    (φ : K) (horder : (60 : K) ≠ 0) :
    ((13 : K) + 15 + 20 + 12 * φ + 12 * (1 - φ)) / 60 = 1 := by
  field_simp
  ring

end RelativeConicArcs.ClebschPolyhedralInvariantAverages
