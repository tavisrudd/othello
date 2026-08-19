import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.QuarticSpectralSeparation
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.RankTwoResidueRigidity

/-!
# Euler spectrum of a specialized Hirzebruch surface

A Hirzebruch surface `F_a` is the projective bundle of `O + O(a)` over the
projective line; `a` is called its index.  These are exactly the rational
geometrically ruled surfaces, and they are the minimal ones apart from `F_1`,
which is the projective plane blown up at a point.  Its even
cohomology has rank four, and after a specialization of the Novikov variables the
characteristic polynomial of Euler multiplication on that rank-four space is one
of two monic quartics in the two specialized values

  `u`, the specialized value of the fibre class `f`, and
  `w`, the specialized value of `s + k f`, where `s` is the negative-section
  class and `k` is the integer part of `a / 2`:

  even `a`:  `X ^ 4 - 8 (u + w) X ^ 2 + 16 (u - w) ^ 2`,
  odd  `a`:  `X ^ 4 + w X ^ 3 - 8 u X ^ 2 - 36 u w X + 16 u ^ 2 - 27 u w ^ 2`.

This module takes those two quartics as given — the mathematical derivation from
the presented quantum cohomology of the surface is not formalized — and proves
what the manuscript needs about them.

Their discriminants are `2 ^ 24 u ^ 2 w ^ 2 (u - w) ^ 2` and
`- u ^ 2 w ^ 2 (256 u + 27 w ^ 2) ^ 3`.  With `u` and `w` nonzero, which is what
strict Novikov admissibility supplies, the discriminant vanishes exactly on
`u = w` in the even case and exactly on `256 u + 27 w ^ 2 = 0` in the odd case.
Off those loci every maximal generalized eigenspace of Euler multiplication has
dimension at most one, so every spectral block has rank one.

On them the spectrum is described completely.  The even quartic becomes
`X ^ 2 (X ^ 2 - 16 u)`, whose double root is `0` and whose two remaining roots
are the square roots of `16 u`; these differ from `0` exactly when `u` does.  The
odd locus is parametrized by writing the section value as `16 s`, so that the
fibre value is `-27 s ^ 2`; the quartic then has double root `-18 s` and
remaining roots `10 s ± 16 e` for a square root `e` of `-2 s ^ 2`, and those
differ from `-18 s` exactly when `s` does.  Composing the splittings with those
distinctness statements gives, on each locus, root multiplicities two, one and
one, and hence maximal generalized eigenspaces of dimension at most two with the
one at the double root of dimension exactly two: one spectral block of rank two
and two of rank one, and no block of rank three or four.  A rank-two block over
the complex numbers has square-zero nilpotent part, by Cayley--Hamilton in rank
two.  Whether such a block is in fact semisimple is not proved here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Polynomial

/-- The monic quartic that the manuscript derives as the characteristic
polynomial of Euler multiplication on the rank-four even cohomology of a
Hirzebruch surface of even index, after a Novikov specialization sending the
fibre class to `u` and the section class shifted by half the index in fibres to
`w`.  Lean takes the polynomial as given and proves nothing about its geometric
origin. -/
noncomputable def hirzebruchEvenEulerCharpoly (u w : ℂ) : Polynomial ℂ :=
  monicQuartic (16 * (u - w) ^ 2) 0 (-(8 * (u + w))) 0

/-- The monic quartic that the manuscript derives as the characteristic
polynomial of Euler multiplication on the rank-four even cohomology of a
Hirzebruch surface of odd index, after a Novikov specialization sending the fibre
class to `u` and the section class shifted by the integer part of half the index
in fibres to `w`.  Lean takes the polynomial as given and proves nothing about
its geometric origin. -/
noncomputable def hirzebruchOddEulerCharpoly (u w : ℂ) : Polynomial ℂ :=
  monicQuartic (16 * u ^ 2 - 27 * u * w ^ 2) (-(36 * u * w)) (-(8 * u)) w

section Discriminants

variable (u w : ℂ)

/-- Discriminant of the even quartic. -/
theorem hirzebruchEvenEuler_discriminant :
    quarticDiscriminant (16 * (u - w) ^ 2) 0 (-(8 * (u + w))) 0
      = 16777216 * (u ^ 2 * w ^ 2 * (u - w) ^ 2) := by
  unfold quarticDiscriminant
  ring

/-- Discriminant of the odd quartic. -/
theorem hirzebruchOddEuler_discriminant :
    quarticDiscriminant (16 * u ^ 2 - 27 * u * w ^ 2) (-(36 * u * w)) (-(8 * u)) w
      = -(u ^ 2 * w ^ 2 * (256 * u + 27 * w ^ 2) ^ 3) := by
  unfold quarticDiscriminant
  ring

/-- For a specialization with both values nonzero the even quartic is degenerate
exactly when the two values agree. -/
theorem hirzebruchEvenEuler_discriminant_eq_zero_iff (nonzeroFibre : u ≠ 0) (nonzeroSection : w ≠ 0) :
    quarticDiscriminant (16 * (u - w) ^ 2) 0 (-(8 * (u + w))) 0 = 0 ↔ u = w := by
  rw [hirzebruchEvenEuler_discriminant]
  constructor
  · intro vanishing
    have factors : u ^ 2 * w ^ 2 * (u - w) ^ 2 = 0 := by
      have : (16777216 : ℂ) ≠ 0 := by norm_num
      exact (mul_eq_zero.mp vanishing).resolve_left this
    rcases mul_eq_zero.mp factors with head | tail
    · rcases mul_eq_zero.mp head with square | other
      · exact absurd (pow_eq_zero_iff (n := 2) (by norm_num) |>.mp square) nonzeroFibre
      · exact absurd (pow_eq_zero_iff (n := 2) (by norm_num) |>.mp other) nonzeroSection
    · exact sub_eq_zero.mp (pow_eq_zero_iff (n := 2) (by norm_num) |>.mp tail)
  · intro equal
    rw [equal]
    ring

/-- For a specialization with both values nonzero the odd quartic is degenerate
exactly on the displayed quadratic locus. -/
theorem hirzebruchOddEuler_discriminant_eq_zero_iff (nonzeroFibre : u ≠ 0) (nonzeroSection : w ≠ 0) :
    quarticDiscriminant (16 * u ^ 2 - 27 * u * w ^ 2) (-(36 * u * w)) (-(8 * u)) w = 0
      ↔ 256 * u + 27 * w ^ 2 = 0 := by
  rw [hirzebruchOddEuler_discriminant]
  constructor
  · intro vanishing
    have factors : u ^ 2 * w ^ 2 * (256 * u + 27 * w ^ 2) ^ 3 = 0 := by
      simpa using neg_eq_zero.mp vanishing
    rcases mul_eq_zero.mp factors with head | tail
    · rcases mul_eq_zero.mp head with square | other
      · exact absurd (pow_eq_zero_iff (n := 2) (by norm_num) |>.mp square) nonzeroFibre
      · exact absurd (pow_eq_zero_iff (n := 2) (by norm_num) |>.mp other) nonzeroSection
    · exact pow_eq_zero_iff (n := 3) (by norm_num) |>.mp tail
  · intro locus
    rw [locus]
    ring

end Discriminants

section SimpleBlocks

/-- Off the degeneracy locus every spectral block of Euler multiplication on a
Hirzebruch surface of even index has rank one. -/
theorem hirzebruchEvenEuler_finrank_maxGenEigenspace_le_one
    (operator : Matrix (Fin 4) (Fin 4) ℂ) (u w : ℂ)
    (characteristic : operator.charpoly = hirzebruchEvenEulerCharpoly u w)
    (nonzeroFibre : u ≠ 0) (nonzeroSection : w ≠ 0) (separated : u ≠ w) (value : ℂ) :
    Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' operator) value) ≤ 1 := by
  refine finrank_maxGenEigenspace_le_one_of_quarticDiscriminant_ne_zero operator _ _ _ _
    characteristic ?_ value
  exact fun vanishing => separated
    ((hirzebruchEvenEuler_discriminant_eq_zero_iff u w nonzeroFibre nonzeroSection).mp vanishing)

/-- Off the degeneracy locus every spectral block of Euler multiplication on a
Hirzebruch surface of odd index has rank one. -/
theorem hirzebruchOddEuler_finrank_maxGenEigenspace_le_one
    (operator : Matrix (Fin 4) (Fin 4) ℂ) (u w : ℂ)
    (characteristic : operator.charpoly = hirzebruchOddEulerCharpoly u w)
    (nonzeroFibre : u ≠ 0) (nonzeroSection : w ≠ 0)
    (separated : 256 * u + 27 * w ^ 2 ≠ 0) (value : ℂ) :
    Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' operator) value) ≤ 1 := by
  refine finrank_maxGenEigenspace_le_one_of_quarticDiscriminant_ne_zero operator _ _ _ _
    characteristic ?_ value
  exact fun vanishing => separated
    ((hirzebruchOddEuler_discriminant_eq_zero_iff u w nonzeroFibre nonzeroSection).mp vanishing)

end SimpleBlocks

section Splittings

/-- At `u = a ^ 2` and `w = b ^ 2` the even quartic is the product of the four
linear factors with roots `2 (± a ± b)`; these are the eigenvalues of Euler
multiplication in the even case, and they need not be distinct. -/
theorem hirzebruchEvenEuler_splitting (a b : ℂ) :
    hirzebruchEvenEulerCharpoly (a ^ 2) (b ^ 2)
      = (X - C (2 * (a + b))) * (X - C (2 * (a - b))) * (X - C (-(2 * (a - b))))
        * (X - C (-(2 * (a + b)))) := by
  rw [prod_four_linear_eq_monicQuartic, hirzebruchEvenEulerCharpoly]
  congr 1 <;> ring

/-- On the even degeneracy locus the quartic is a squared linear factor times a
quadratic: the repeated root is `0` and the two remaining roots are `± 4 a`,
which differ from the repeated one exactly when `a` is nonzero. -/
theorem hirzebruchEvenEuler_degenerate_splitting (a : ℂ) :
    hirzebruchEvenEulerCharpoly (a ^ 2) (a ^ 2)
      = (X - C 0) ^ 2 * ((X - C (4 * a)) * (X - C (-(4 * a)))) := by
  have expand : ((X - C 0) ^ 2 * ((X - C (4 * a)) * (X - C (-(4 * a)))) : Polynomial ℂ)
      = (X - C 0) * (X - C 0) * (X - C (4 * a)) * (X - C (-(4 * a))) := by
    ring
  rw [expand, prod_four_linear_eq_monicQuartic, hirzebruchEvenEulerCharpoly]
  congr 1 <;> ring

/-- On the odd degeneracy locus the quartic is a squared linear factor times a
quadratic.  Writing the section value as `16 s`, the locus `256 u + 27 w ^ 2 = 0`
reads `u = -27 s ^ 2`; the double eigenvalue is then `-18 s` and the two simple
eigenvalues are `10 s ± 16 e` for a square root `e` of `-2 s ^ 2`.  Every point of
the locus with nonzero section value is of this form, since `s` is a sixteenth of
that value. -/
theorem hirzebruchOddEuler_degenerate_splitting (s e : ℂ) (root : e ^ 2 = -(2 * s ^ 2)) :
    hirzebruchOddEulerCharpoly (-(27 * s ^ 2)) (16 * s)
      = (X - C (-(18 * s))) ^ 2
        * ((X - C (10 * s + 16 * e)) * (X - C (10 * s - 16 * e))) := by
  have expand : ((X - C (-(18 * s))) ^ 2
        * ((X - C (10 * s + 16 * e)) * (X - C (10 * s - 16 * e))) : Polynomial ℂ)
      = (X - C (-(18 * s))) * (X - C (-(18 * s))) * (X - C (10 * s + 16 * e))
        * (X - C (10 * s - 16 * e)) := by
    ring
  rw [expand, prod_four_linear_eq_monicQuartic, hirzebruchOddEulerCharpoly]
  congr 1 <;>
    first
      | linear_combination (82944 * s ^ 2) * root
      | linear_combination (9216 * s) * root
      | linear_combination (256 : ℂ) * root
      | ring

/-- The parametrization of the odd degeneracy locus is surjective: a pair of
specialized values on that locus, with the section value nonzero, is
`(-(27 s ^ 2), 16 s)` for `s` a sixteenth of the section value. -/
theorem hirzebruchOddEuler_degeneracyLocus_parametrized (u w : ℂ)
    (locus : 256 * u + 27 * w ^ 2 = 0) :
    u = -(27 * (w / 16) ^ 2) ∧ w = 16 * (w / 16) := by
  constructor
  · linear_combination locus / 256
  · ring

/-- The two remaining roots on the odd degeneracy locus differ from the repeated
one whenever the scale parameter, equivalently the specialized section value, is
nonzero. -/
theorem hirzebruchOddEuler_degenerate_simple_ne (s e : ℂ) (root : e ^ 2 = -(2 * s ^ 2))
    (nonzeroSection : s ≠ 0) :
    10 * s + 16 * e ≠ -(18 * s) ∧ 10 * s - 16 * e ≠ -(18 * s) := by
  have fromSquare : ∀ {value : ℂ}, 16 * value ^ 2 = 49 * s ^ 2 → value ^ 2 = -(2 * s ^ 2) →
      s = 0 := by
    intro value expanded valueRoot
    have square : s ^ 2 = 0 := by
      linear_combination (-(1 : ℂ) / 81) * expanded + ((16 : ℂ) / 81) * valueRoot
    exact pow_eq_zero_iff (n := 2) (by norm_num) |>.mp square
  constructor
  · intro equality
    refine nonzeroSection (fromSquare ?_ root)
    have scaled : 4 * e = -(7 * s) := by linear_combination equality / 4
    linear_combination (4 * e - 7 * s) * scaled
  · intro equality
    refine nonzeroSection (fromSquare ?_ root)
    have scaled : 4 * e = 7 * s := by linear_combination -equality / 4
    linear_combination (4 * e + 7 * s) * scaled

end Splittings

section DegenerateBlocks

/-- Every root of the even quartic on its degeneracy locus has multiplicity at
most two, so no spectral block of rank three or four occurs there.  The
hypothesis is that the specialized fibre value is nonzero, which is what makes
the two remaining roots differ from the double root `0`. -/
theorem hirzebruchEvenEuler_degenerate_rootMultiplicity_le_two (a : ℂ) (nonzero : a ≠ 0) (value : ℂ) :
    (hirzebruchEvenEulerCharpoly (a ^ 2) (a ^ 2)).rootMultiplicity value ≤ 2 := by
  rw [hirzebruchEvenEuler_degenerate_splitting]
  exact rootMultiplicity_le_two_of_squared_linear_mul_quadratic
    (by simpa using mul_ne_zero (by norm_num : (4 : ℂ) ≠ 0) nonzero)
    (by simpa using mul_ne_zero (by norm_num : (4 : ℂ) ≠ 0) nonzero) value

/-- The double root of the even quartic on its degeneracy locus has multiplicity
exactly two. -/
theorem hirzebruchEvenEuler_degenerate_rootMultiplicity_eq_two (a : ℂ) (nonzero : a ≠ 0) :
    (hirzebruchEvenEulerCharpoly (a ^ 2) (a ^ 2)).rootMultiplicity 0 = 2 := by
  rw [hirzebruchEvenEuler_degenerate_splitting]
  exact rootMultiplicity_eq_two_of_squared_linear_mul_quadratic
    (by simpa using mul_ne_zero (by norm_num : (4 : ℂ) ≠ 0) nonzero)
    (by simpa using mul_ne_zero (by norm_num : (4 : ℂ) ≠ 0) nonzero)

/-- Every root of the odd quartic on its degeneracy locus has multiplicity at
most two.  The hypothesis is that the scale parameter is nonzero, equivalently
that the specialized section value is. -/
theorem hirzebruchOddEuler_degenerate_rootMultiplicity_le_two (s e : ℂ)
    (root : e ^ 2 = -(2 * s ^ 2)) (nonzero : s ≠ 0) (value : ℂ) :
    (hirzebruchOddEulerCharpoly (-(27 * s ^ 2)) (16 * s)).rootMultiplicity value ≤ 2 := by
  obtain ⟨firstNe, secondNe⟩ := hirzebruchOddEuler_degenerate_simple_ne s e root nonzero
  rw [hirzebruchOddEuler_degenerate_splitting s e root]
  exact rootMultiplicity_le_two_of_squared_linear_mul_quadratic firstNe secondNe value

/-- The double root of the odd quartic on its degeneracy locus has multiplicity
exactly two. -/
theorem hirzebruchOddEuler_degenerate_rootMultiplicity_eq_two (s e : ℂ)
    (root : e ^ 2 = -(2 * s ^ 2)) (nonzero : s ≠ 0) :
    (hirzebruchOddEulerCharpoly (-(27 * s ^ 2)) (16 * s)).rootMultiplicity (-(18 * s)) = 2 := by
  obtain ⟨firstNe, secondNe⟩ := hirzebruchOddEuler_degenerate_simple_ne s e root nonzero
  rw [hirzebruchOddEuler_degenerate_splitting s e root]
  exact rootMultiplicity_eq_two_of_squared_linear_mul_quadratic firstNe secondNe

/-- On the even degeneracy locus no maximal generalized eigenspace of Euler
multiplication has dimension more than two, and the one at the double root has
dimension exactly two: the degenerate spectrum is one block of rank two and two
blocks of rank one. -/
theorem hirzebruchEvenEuler_degenerate_finrank_maxGenEigenspace
    (operator : Matrix (Fin 4) (Fin 4) ℂ) (a : ℂ) (nonzero : a ≠ 0)
    (characteristic : operator.charpoly = hirzebruchEvenEulerCharpoly (a ^ 2) (a ^ 2)) :
    (∀ value : ℂ,
        Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' operator) value) ≤ 2) ∧
      Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' operator) 0) = 2 := by
  constructor
  · intro value
    rw [LinearMap.finrank_maxGenEigenspace_eq, Matrix.charpoly_toLin', characteristic]
    exact hirzebruchEvenEuler_degenerate_rootMultiplicity_le_two a nonzero value
  · rw [LinearMap.finrank_maxGenEigenspace_eq, Matrix.charpoly_toLin', characteristic]
    exact hirzebruchEvenEuler_degenerate_rootMultiplicity_eq_two a nonzero

/-- On the odd degeneracy locus no maximal generalized eigenspace of Euler
multiplication has dimension more than two, and the one at the double root
`-18 s` has dimension exactly two. -/
theorem hirzebruchOddEuler_degenerate_finrank_maxGenEigenspace
    (operator : Matrix (Fin 4) (Fin 4) ℂ) (s e : ℂ) (root : e ^ 2 = -(2 * s ^ 2))
    (nonzero : s ≠ 0)
    (characteristic :
      operator.charpoly = hirzebruchOddEulerCharpoly (-(27 * s ^ 2)) (16 * s)) :
    (∀ value : ℂ,
        Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' operator) value) ≤ 2) ∧
      Module.finrank ℂ
        (Module.End.maxGenEigenspace (Matrix.toLin' operator) (-(18 * s))) = 2 := by
  constructor
  · intro value
    rw [LinearMap.finrank_maxGenEigenspace_eq, Matrix.charpoly_toLin', characteristic]
    exact hirzebruchOddEuler_degenerate_rootMultiplicity_le_two s e root nonzero value
  · rw [LinearMap.finrank_maxGenEigenspace_eq, Matrix.charpoly_toLin', characteristic]
    exact hirzebruchOddEuler_degenerate_rootMultiplicity_eq_two s e root nonzero

end DegenerateBlocks

section RankTwoBlock

/-- The nilpotent part of a rank-two block is square-zero.  A two-by-two complex
matrix with a single eigenvalue has trace twice and determinant the square of
that eigenvalue, and Cayley--Hamilton in rank two then says that the centerd
matrix squares to zero. -/
theorem rankTwo_centered_sq_eq_zero (block : Matrix (Fin 2) (Fin 2) ℂ) (eigenvalue : ℂ)
    (traceValue : Matrix.trace block = 2 * eigenvalue)
    (determinantValue : block.det = eigenvalue ^ 2) :
    (block - eigenvalue • (1 : Matrix (Fin 2) (Fin 2) ℂ))
        * (block - eigenvalue • (1 : Matrix (Fin 2) (Fin 2) ℂ)) = 0 := by
  have cayley := rankTwo_cayleyHamilton block
  rw [traceValue, determinantValue] at cayley
  have expand : (block - eigenvalue • (1 : Matrix (Fin 2) (Fin 2) ℂ))
        * (block - eigenvalue • (1 : Matrix (Fin 2) (Fin 2) ℂ))
      = block * block - (2 * eigenvalue) • block
        + eigenvalue ^ 2 • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
    simp only [sub_mul, mul_sub, Matrix.smul_mul, Matrix.mul_smul, Matrix.one_mul,
      Matrix.mul_one, smul_smul, two_mul, add_smul, sq]
    abel
  rw [expand]
  exact cayley

end RankTwoBlock

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
