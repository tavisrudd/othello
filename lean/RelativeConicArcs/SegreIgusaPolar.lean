import RelativeConicArcs.ClebschOuterSegreRelations
import RelativeConicArcs.GoldenCommutatorDeterminant
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-!
# The diagonal section and the polar map of the Segre cubic

A point of the Segre cubic threefold is a six-tuple `z` of ring elements with
`∑ z = 0` and `∑ z³ = 0`.  This module proves the two constructions the
manuscript performs on such a point.

The first is the hyperplane section.  If one coordinate of a point of the Segre
cubic vanishes, the remaining five coordinates again satisfy a vanishing linear
sum and a vanishing cube sum; the linear relation cuts the hyperplane down to a
three-dimensional projective space and the cubic relation is the equation of the
diagonal cubic surface on it.

The second is the polar map given by the centered squares.  Write `q` for the
sum of the squares of the six coordinates and attach to each coordinate the
element `6 z t ² - q`, which is six times the manuscript's centered square and
is used here in that denominator-free normalization so that the statements hold
over an arbitrary commutative ring.  These six elements always sum to zero, and
on the Segre cubic they satisfy the symmetric quartic relation
`(∑ V²)² = 4 ∑ V⁴`, which is the equation of the Igusa quartic; the relation is
invariant under rescaling all six entries by a common factor, so it holds for
the centered squares themselves in any ring where six is invertible.

The quartic relation is proved through the characteristic polynomial of the six
coordinates rather than by a certificate.  Each coordinate is a root of
`∏ (T - z u)`, so multiplying that vanishing by `z t ²` and summing over the six
coordinates expresses the eighth power sum in terms of the lower ones and the
elementary symmetric functions; Newton's identities in degrees two, three and
four then eliminate those symmetric functions in favour of the power sums, using
the two Segre relations exactly where the first and third power sums appear.
What remains is the power-sum identity
`48 p₈ = 12 p₄² - 12 p₂² p₄ + p₂⁴ + 32 p₂ p₆`, and the quartic relation is
`-108` times it.

The last theorem returns the polar map to the operator picture: the determinant
of the commutator bracket matrix of the fixed conference matrix, evaluated at
the reordered coordinates indexing the `t`-th outer cubic, is sixteen times the
square of that cubic, so sixteen times the centered square of the six outer
cubics is the centered family of those six determinants.
-/

namespace RelativeConicArcs.SegreIgusaPolar

open RelativeConicArcs.ClebschGoldenConference
open RelativeConicArcs.ClebschOuterSegreRelations
open RelativeConicArcs.GoldenCommutatorPfaffian

variable {R : Type*} [CommRing R]

/-- The `k`-th power sum of six ring elements. -/
def powerSum (z : Fin 6 → R) (k : ℕ) : R := ∑ t, z t ^ k

/-- The first elementary symmetric function of six ring elements. -/
private def esym1 (z : Fin 6 → R) : R := z 0 + z 1 + z 2 + z 3 + z 4 + z 5

/-- The second elementary symmetric function of six ring elements. -/
private def esym2 (z : Fin 6 → R) : R :=
  z 0 * z 1 + z 0 * z 2 + z 0 * z 3 +
  z 0 * z 4 + z 0 * z 5 + z 1 * z 2 +
  z 1 * z 3 + z 1 * z 4 + z 1 * z 5 +
  z 2 * z 3 + z 2 * z 4 + z 2 * z 5 +
  z 3 * z 4 + z 3 * z 5 + z 4 * z 5

/-- The third elementary symmetric function of six ring elements. -/
private def esym3 (z : Fin 6 → R) : R :=
  z 0 * z 1 * z 2 + z 0 * z 1 * z 3 + z 0 * z 1 * z 4 +
  z 0 * z 1 * z 5 + z 0 * z 2 * z 3 + z 0 * z 2 * z 4 +
  z 0 * z 2 * z 5 + z 0 * z 3 * z 4 + z 0 * z 3 * z 5 +
  z 0 * z 4 * z 5 + z 1 * z 2 * z 3 + z 1 * z 2 * z 4 +
  z 1 * z 2 * z 5 + z 1 * z 3 * z 4 + z 1 * z 3 * z 5 +
  z 1 * z 4 * z 5 + z 2 * z 3 * z 4 + z 2 * z 3 * z 5 +
  z 2 * z 4 * z 5 + z 3 * z 4 * z 5

/-- The fourth elementary symmetric function of six ring elements. -/
private def esym4 (z : Fin 6 → R) : R :=
  z 0 * z 1 * z 2 * z 3 + z 0 * z 1 * z 2 * z 4 + z 0 * z 1 * z 2 * z 5 +
  z 0 * z 1 * z 3 * z 4 + z 0 * z 1 * z 3 * z 5 + z 0 * z 1 * z 4 * z 5 +
  z 0 * z 2 * z 3 * z 4 + z 0 * z 2 * z 3 * z 5 + z 0 * z 2 * z 4 * z 5 +
  z 0 * z 3 * z 4 * z 5 + z 1 * z 2 * z 3 * z 4 + z 1 * z 2 * z 3 * z 5 +
  z 1 * z 2 * z 4 * z 5 + z 1 * z 3 * z 4 * z 5 + z 2 * z 3 * z 4 * z 5

/-- The fifth elementary symmetric function of six ring elements. -/
private def esym5 (z : Fin 6 → R) : R :=
  z 0 * z 1 * z 2 * z 3 * z 4 + z 0 * z 1 * z 2 * z 3 * z 5 +
  z 0 * z 1 * z 2 * z 4 * z 5 + z 0 * z 1 * z 3 * z 4 * z 5 +
  z 0 * z 2 * z 3 * z 4 * z 5 + z 1 * z 2 * z 3 * z 4 * z 5

/-- The sixth elementary symmetric function of six ring elements. -/
private def esym6 (z : Fin 6 → R) : R := z 0 * z 1 * z 2 * z 3 * z 4 * z 5

/-- Each of the six elements is a root of the monic degree-six polynomial whose
coefficients are their elementary symmetric functions with alternating signs. -/
private theorem esym_root (z : Fin 6 → R) (t : Fin 6) :
    z t ^ 6 - esym1 z * z t ^ 5 + esym2 z * z t ^ 4 - esym3 z * z t ^ 3 +
      esym4 z * z t ^ 2 - esym5 z * z t + esym6 z = 0 := by
  have ht : t = 0 ∨ t = 1 ∨ t = 2 ∨ t = 3 ∨ t = 4 ∨ t = 5 := by decide +revert
  rcases ht with rfl | rfl | rfl | rfl | rfl | rfl <;>
    simp only [esym1, esym2, esym3, esym4, esym5, esym6] <;> ring

/-- Summing the vanishing of the degree-six polynomial over the six roots. -/
private theorem sum_root (z : Fin 6 → R) (e1 e2 e3 e4 e5 e6 : R)
    (h : ∀ t, z t ^ 6 - e1 * z t ^ 5 + e2 * z t ^ 4 - e3 * z t ^ 3 +
      e4 * z t ^ 2 - e5 * z t + e6 = 0) :
    powerSum z 6 - e1 * powerSum z 5 + e2 * powerSum z 4 - e3 * powerSum z 3 +
      e4 * powerSum z 2 - e5 * powerSum z 1 + 6 * e6 = 0 := by
  simp only [powerSum, Fin.sum_univ_six]
  linear_combination h 0 + h 1 + h 2 + h 3 + h 4 + h 5

/-- Summing the vanishing of the degree-six polynomial, weighted by the square
of the root, over the six roots. -/
private theorem sum_sq_mul_root (z : Fin 6 → R) (e1 e2 e3 e4 e5 e6 : R)
    (h : ∀ t, z t ^ 6 - e1 * z t ^ 5 + e2 * z t ^ 4 - e3 * z t ^ 3 +
      e4 * z t ^ 2 - e5 * z t + e6 = 0) :
    powerSum z 8 - e1 * powerSum z 7 + e2 * powerSum z 6 - e3 * powerSum z 5 +
      e4 * powerSum z 4 - e5 * powerSum z 3 + e6 * powerSum z 2 = 0 := by
  simp only [powerSum, Fin.sum_univ_six]
  linear_combination z 0 ^ 2 * h 0 + z 1 ^ 2 * h 1 + z 2 ^ 2 * h 2 +
    z 3 ^ 2 * h 3 + z 4 ^ 2 * h 4 + z 5 ^ 2 * h 5

private theorem esym1_eq (z : Fin 6 → R) : esym1 z = powerSum z 1 := by
  simp only [esym1, powerSum, Fin.sum_univ_six]; ring

private theorem newton_two (z : Fin 6 → R) :
    2 * esym2 z + powerSum z 2 = powerSum z 1 ^ 2 := by
  simp only [esym2, powerSum, Fin.sum_univ_six]; ring

private theorem newton_three (z : Fin 6 → R) :
    3 * esym3 z = powerSum z 3 - esym1 z * powerSum z 2 + esym2 z * powerSum z 1 := by
  simp only [esym1, esym2, esym3, powerSum, Fin.sum_univ_six]; ring

private theorem newton_four (z : Fin 6 → R) :
    4 * esym4 z + esym2 z * powerSum z 2 + powerSum z 4 =
      esym1 z * powerSum z 3 + esym3 z * powerSum z 1 := by
  simp only [esym1, esym2, esym3, esym4, powerSum, Fin.sum_univ_six]; ring

/-- The purely formal core of the quartic relation: from the two summed root
identities and Newton's identities in degrees two, three and four, the eighth
power sum is determined by the second, fourth and sixth. -/
private theorem power_sum_relation (p2 p4 p5 p6 p8 u v w y : R)
    (hR2 : 2 * u + p2 = 0) (hR3 : 3 * y = 0) (hR4 : 4 * v + u * p2 + p4 = 0)
    (hS : p8 + u * p6 + v * p4 + w * p2 - y * p5 = 0)
    (hSS : p6 + u * p4 + v * p2 + 6 * w = 0) :
    48 * p8 - 32 * p2 * p6 + 12 * p2 ^ 2 * p4 - 12 * p4 ^ 2 - p2 ^ 4 = 0 := by
  linear_combination 48 * hS - 8 * p2 * hSS -
    (24 * p6 - 10 * p2 * p4 + p2 ^ 3) * hR2 + 16 * p5 * hR3 -
    (12 * p4 - 2 * p2 ^ 2) * hR4

/-- For a point of the Segre cubic the eighth power sum of the six coordinates
is determined by the second, fourth and sixth. -/
theorem powerSum_eight_of_segre (z : Fin 6 → R)
    (h1 : ∑ t, z t = 0) (h3 : ∑ t, z t ^ 3 = 0) :
    48 * powerSum z 8 - 32 * powerSum z 2 * powerSum z 6 +
      12 * powerSum z 2 ^ 2 * powerSum z 4 - 12 * powerSum z 4 ^ 2 -
      powerSum z 2 ^ 4 = 0 := by
  have hp1 : powerSum z 1 = 0 := by simpa [powerSum] using h1
  have hp3 : powerSum z 3 = 0 := by simpa [powerSum] using h3
  have he1 : esym1 z = 0 := by rw [esym1_eq, hp1]
  have hR2 : 2 * esym2 z + powerSum z 2 = 0 := by
    rw [newton_two, hp1]; ring
  have hR3 : 3 * esym3 z = 0 := by
    rw [newton_three, hp1, hp3, he1]; ring
  have hR4 : 4 * esym4 z + esym2 z * powerSum z 2 + powerSum z 4 = 0 := by
    rw [newton_four, hp1, hp3, he1]; ring
  have hS : powerSum z 8 + esym2 z * powerSum z 6 + esym4 z * powerSum z 4 +
      esym6 z * powerSum z 2 - esym3 z * powerSum z 5 = 0 := by
    have hsum := sum_sq_mul_root z _ _ _ _ _ _ (esym_root z)
    rw [he1, hp3] at hsum
    linear_combination hsum
  have hSS : powerSum z 6 + esym2 z * powerSum z 4 + esym4 z * powerSum z 2 +
      6 * esym6 z = 0 := by
    have hsum := sum_root z _ _ _ _ _ _ (esym_root z)
    rw [he1, hp3, hp1] at hsum
    linear_combination hsum
  exact power_sum_relation _ _ (powerSum z 5) _ _ _ _ _ _ hR2 hR3 hR4 hS hSS

/-- The centered square of a coordinate, cleared of denominators: six times the
difference between the square of that coordinate and the average of the six
squares. -/
def centeredSquare (z : Fin 6 → R) (t : Fin 6) : R := 6 * z t ^ 2 - powerSum z 2

/-- The six centered squares of any six ring elements sum to zero. -/
theorem sum_centeredSquare (z : Fin 6 → R) : ∑ t, centeredSquare z t = 0 := by
  simp only [centeredSquare, powerSum, Fin.sum_univ_six]; ring

private theorem sum_shifted_sq (z : Fin 6 → R) (q : R) :
    ∑ t, (6 * z t ^ 2 - q) ^ 2 =
      36 * powerSum z 4 - 12 * q * powerSum z 2 + 6 * q ^ 2 := by
  simp only [powerSum, Fin.sum_univ_six]; ring

private theorem sum_shifted_pow_four (z : Fin 6 → R) (q : R) :
    ∑ t, (6 * z t ^ 2 - q) ^ 4 =
      1296 * powerSum z 8 - 864 * q * powerSum z 6 +
        216 * q ^ 2 * powerSum z 4 - 24 * q ^ 3 * powerSum z 2 + 6 * q ^ 4 := by
  simp only [powerSum, Fin.sum_univ_six]; ring

/-- The Igusa quartic relation for the polar map of the Segre cubic: the six
centered squares of a point with vanishing coordinate sum and vanishing cube
sum satisfy `(∑ V²)² = 4 ∑ V⁴`.  Both sides are homogeneous of degree four in
the six centered squares, so the relation is unchanged by the common factor six
in this normalization. -/
theorem igusa_relation_of_segre (z : Fin 6 → R)
    (h1 : ∑ t, z t = 0) (h3 : ∑ t, z t ^ 3 = 0) :
    (∑ t, centeredSquare z t ^ 2) ^ 2 = 4 * ∑ t, centeredSquare z t ^ 4 := by
  have key := powerSum_eight_of_segre z h1 h3
  have h2 : ∑ t, centeredSquare z t ^ 2 =
      36 * powerSum z 4 - 6 * powerSum z 2 ^ 2 := by
    rw [show (∑ t, centeredSquare z t ^ 2) =
        ∑ t, (6 * z t ^ 2 - powerSum z 2) ^ 2 from rfl, sum_shifted_sq]
    ring
  have h4 : ∑ t, centeredSquare z t ^ 4 =
      1296 * powerSum z 8 - 864 * powerSum z 2 * powerSum z 6 +
        216 * powerSum z 2 ^ 2 * powerSum z 4 - 18 * powerSum z 2 ^ 4 := by
    rw [show (∑ t, centeredSquare z t ^ 4) =
        ∑ t, (6 * z t ^ 2 - powerSum z 2) ^ 4 from rfl, sum_shifted_pow_four]
    ring
  rw [h2, h4]
  linear_combination (-108 : R) * key

/-- The diagonal section, linear half: if a point of the Segre cubic has a
vanishing coordinate, the remaining five coordinates sum to zero. -/
theorem sum_erase_eq_zero_of_apply_eq_zero (z : Fin 6 → R) (t₀ : Fin 6)
    (h1 : ∑ t, z t = 0) (ht : z t₀ = 0) :
    ∑ t ∈ Finset.univ.erase t₀, z t = 0 := by
  rw [Finset.sum_erase_eq_sub (Finset.mem_univ t₀), h1, ht, sub_zero]

/-- The diagonal section, cubic half: if a point of the Segre cubic has a
vanishing coordinate, the cubes of the remaining five coordinates sum to zero.
Together with the linear relation this is the equation of the diagonal cubic
surface inside the three-dimensional projective space cut out by that
relation. -/
theorem sum_pow_three_erase_eq_zero_of_apply_eq_zero (z : Fin 6 → R) (t₀ : Fin 6)
    (h3 : ∑ t, z t ^ 3 = 0) (ht : z t₀ = 0) :
    ∑ t ∈ Finset.univ.erase t₀, z t ^ 3 = 0 := by
  rw [Finset.sum_erase_eq_sub (Finset.mem_univ t₀), h3, ht]
  ring

/-- The six outer cubics of the fixed conference matrix are a point of the
Segre cubic whose centered squares satisfy the Igusa quartic relation. -/
theorem igusa_relation_outerCubic (x : Fin 6 → R) :
    (∑ t, centeredSquare (outerCubic x) t ^ 2) ^ 2 =
      4 * ∑ t, centeredSquare (outerCubic x) t ^ 4 :=
  igusa_relation_of_segre _ (sum_outerCubic x) (sum_outerCubic_cube x)

/-- The diagonal section of the outer family: if one outer cubic vanishes at a
point, the other five sum to zero and their cubes sum to zero. -/
theorem outerCubic_diagonal_section (x : Fin 6 → R) (t₀ : Fin 6)
    (ht : outerCubic x t₀ = 0) :
    ∑ t ∈ Finset.univ.erase t₀, outerCubic x t = 0 ∧
      ∑ t ∈ Finset.univ.erase t₀, outerCubic x t ^ 3 = 0 :=
  ⟨sum_erase_eq_zero_of_apply_eq_zero _ t₀ (sum_outerCubic x) ht,
    sum_pow_three_erase_eq_zero_of_apply_eq_zero _ t₀ (sum_outerCubic_cube x) ht⟩

/-- The determinant of the commutator bracket matrix of the fixed conference
matrix, evaluated at the coordinates reordered by the `t`-th member of the
outer family, is sixteen times the square of the `t`-th outer cubic.  The sign
of the reordering is a square and therefore drops out. -/
theorem det_bracket_outerReindex (x : Fin 6 → R) (t : Fin 6) :
    Matrix.det (bracketMatrix (conferenceMatrixOver R)
        (fun i => x (outerReindex t i))) = 16 * outerCubic x t ^ 2 := by
  rw [GoldenCommutatorDeterminant.det_conferenceBracket_eq_sixteen_triangleCubic_sq]
  have hsign : outerSign R t * outerSign R t = 1 := by
    fin_cases t <;> simp [outerSign]
  calc
    16 * triangleCubic (conferenceMatrixOver R) (fun i => x (outerReindex t i)) ^ 2
        = 16 * ((outerSign R t * outerSign R t) *
            triangleCubic (conferenceMatrixOver R)
              (fun i => x (outerReindex t i)) ^ 2) := by rw [hsign]; ring
    _ = 16 * outerCubic x t ^ 2 := by simp only [outerCubic]; ring

/-- The polar map in operator form: sixteen times the centered square of the
six outer cubics is the centered family of the six commutator-bracket
determinants. -/
theorem sixteen_mul_centeredSquare_outerCubic (x : Fin 6 → R) (t : Fin 6) :
    16 * centeredSquare (outerCubic x) t =
      6 * Matrix.det (bracketMatrix (conferenceMatrixOver R)
          (fun i => x (outerReindex t i))) -
        ∑ u, Matrix.det (bracketMatrix (conferenceMatrixOver R)
          (fun i => x (outerReindex u i))) := by
  simp only [centeredSquare, powerSum, det_bracket_outerReindex, Fin.sum_univ_six]
  ring

end RelativeConicArcs.SegreIgusaPolar
