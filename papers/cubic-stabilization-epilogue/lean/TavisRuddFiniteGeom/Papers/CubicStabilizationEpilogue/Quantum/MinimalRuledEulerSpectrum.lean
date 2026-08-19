import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.QuarticSpectralSeparation
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.RankTwoResidueRigidity

/-!
# Euler spectrum of a specialized minimal rational ruled surface

A minimal rational ruled surface is a Hirzebruch surface `F_a`, the projective
bundle of `O + O(a)` over the projective line.  Its even cohomology has rank
four, and after a specialization of the Novikov variables the characteristic
polynomial of Euler multiplication on that rank-four space is one of two monic
quartics in the two specialized values

  `u`, the specialized value of the fibre class, and
  `w`, the specialized value of the section class shifted by `a / 2` fibres:

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
`X ^ 2 (X ^ 2 - 16 u)`, whose double root is `0` and whose two simple roots are
the square roots of `16 u`.  For the odd quartic the locus is parametrized by
writing the section value as `16 s`, so that the fibre value is `-27 s ^ 2`; the
quartic then has double root `-18 s` and simple roots `10 s ± 16 e` for a square
root `e` of `-2 s ^ 2`.  In both cases exactly one root has multiplicity two and
the other two are simple, so no spectral block of rank three or four occurs; and
a rank-two block over the complex numbers has square-zero nilpotent part, by
Cayley--Hamilton in rank two.  That is the complete trichotomy of block shapes
for a specialization with `u` and `w` nonzero.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Polynomial

/-- Characteristic polynomial of Euler multiplication on the rank-four even
cohomology of a minimal rational ruled surface of even index, after a Novikov
specialization sending the fibre class to `u` and the shifted section class to
`w`. -/
noncomputable def evenRuledEulerCharpoly (u w : ℂ) : Polynomial ℂ :=
  monicQuartic (16 * (u - w) ^ 2) 0 (-(8 * (u + w))) 0

/-- Characteristic polynomial of Euler multiplication on the rank-four even
cohomology of a minimal rational ruled surface of odd index, after a Novikov
specialization sending the fibre class to `u` and the shifted section class to
`w`. -/
noncomputable def oddRuledEulerCharpoly (u w : ℂ) : Polynomial ℂ :=
  monicQuartic (16 * u ^ 2 - 27 * u * w ^ 2) (-(36 * u * w)) (-(8 * u)) w

section Discriminants

variable (u w : ℂ)

/-- Discriminant of the even quartic. -/
theorem evenRuledEuler_discriminant :
    quarticDiscriminant (16 * (u - w) ^ 2) 0 (-(8 * (u + w))) 0
      = 16777216 * (u ^ 2 * w ^ 2 * (u - w) ^ 2) := by
  unfold quarticDiscriminant
  ring

/-- Discriminant of the odd quartic. -/
theorem oddRuledEuler_discriminant :
    quarticDiscriminant (16 * u ^ 2 - 27 * u * w ^ 2) (-(36 * u * w)) (-(8 * u)) w
      = -(u ^ 2 * w ^ 2 * (256 * u + 27 * w ^ 2) ^ 3) := by
  unfold quarticDiscriminant
  ring

/-- For a specialization with both values nonzero the even quartic is degenerate
exactly when the two values agree. -/
theorem evenRuledEuler_discriminant_eq_zero_iff (nonzeroFibre : u ≠ 0) (nonzeroSection : w ≠ 0) :
    quarticDiscriminant (16 * (u - w) ^ 2) 0 (-(8 * (u + w))) 0 = 0 ↔ u = w := by
  rw [evenRuledEuler_discriminant]
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
theorem oddRuledEuler_discriminant_eq_zero_iff (nonzeroFibre : u ≠ 0) (nonzeroSection : w ≠ 0) :
    quarticDiscriminant (16 * u ^ 2 - 27 * u * w ^ 2) (-(36 * u * w)) (-(8 * u)) w = 0
      ↔ 256 * u + 27 * w ^ 2 = 0 := by
  rw [oddRuledEuler_discriminant]
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
minimal rational ruled surface of even index has rank one. -/
theorem evenRuledEuler_finrank_maxGenEigenspace_le_one
    (operator : Matrix (Fin 4) (Fin 4) ℂ) (u w : ℂ)
    (characteristic : operator.charpoly = evenRuledEulerCharpoly u w)
    (nonzeroFibre : u ≠ 0) (nonzeroSection : w ≠ 0) (separated : u ≠ w) (value : ℂ) :
    Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' operator) value) ≤ 1 := by
  refine finrank_maxGenEigenspace_le_one_of_quarticDiscriminant_ne_zero operator _ _ _ _
    characteristic ?_ value
  exact fun vanishing => separated
    ((evenRuledEuler_discriminant_eq_zero_iff u w nonzeroFibre nonzeroSection).mp vanishing)

/-- Off the degeneracy locus every spectral block of Euler multiplication on a
minimal rational ruled surface of odd index has rank one. -/
theorem oddRuledEuler_finrank_maxGenEigenspace_le_one
    (operator : Matrix (Fin 4) (Fin 4) ℂ) (u w : ℂ)
    (characteristic : operator.charpoly = oddRuledEulerCharpoly u w)
    (nonzeroFibre : u ≠ 0) (nonzeroSection : w ≠ 0)
    (separated : 256 * u + 27 * w ^ 2 ≠ 0) (value : ℂ) :
    Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' operator) value) ≤ 1 := by
  refine finrank_maxGenEigenspace_le_one_of_quarticDiscriminant_ne_zero operator _ _ _ _
    characteristic ?_ value
  exact fun vanishing => separated
    ((oddRuledEuler_discriminant_eq_zero_iff u w nonzeroFibre nonzeroSection).mp vanishing)

end SimpleBlocks

section Splittings

/-- The four eigenvalues of Euler multiplication in the even case are
`2 (± a ± b)` for square roots `a` of `u` and `b` of `w`. -/
theorem evenRuledEuler_splitting (a b : ℂ) :
    evenRuledEulerCharpoly (a ^ 2) (b ^ 2)
      = (X - C (2 * (a + b))) * (X - C (2 * (a - b))) * (X - C (-(2 * (a - b))))
        * (X - C (-(2 * (a + b)))) := by
  rw [prod_four_linear_eq_monicQuartic, evenRuledEulerCharpoly]
  congr 1 <;> ring

/-- On the even degeneracy locus the quartic is a squared linear factor times a
quadratic: the double eigenvalue is `0` and the two simple eigenvalues are the
square roots of `16 u`. -/
theorem evenRuledEuler_degenerate_splitting (a : ℂ) :
    evenRuledEulerCharpoly (a ^ 2) (a ^ 2)
      = (X - C 0) ^ 2 * ((X - C (4 * a)) * (X - C (-(4 * a)))) := by
  have expand : ((X - C 0) ^ 2 * ((X - C (4 * a)) * (X - C (-(4 * a)))) : Polynomial ℂ)
      = (X - C 0) * (X - C 0) * (X - C (4 * a)) * (X - C (-(4 * a))) := by
    ring
  rw [expand, prod_four_linear_eq_monicQuartic, evenRuledEulerCharpoly]
  congr 1 <;> ring

/-- On the odd degeneracy locus the quartic is a squared linear factor times a
quadratic.  Writing the section value as `16 s`, the locus `256 u + 27 w ^ 2 = 0`
reads `u = -27 s ^ 2`; the double eigenvalue is then `-18 s` and the two simple
eigenvalues are `10 s ± 16 e` for a square root `e` of `-2 s ^ 2`.  Every point of
the locus with nonzero section value is of this form, since `s` is a sixteenth of
that value. -/
theorem oddRuledEuler_degenerate_splitting (s e : ℂ) (root : e ^ 2 = -(2 * s ^ 2)) :
    oddRuledEulerCharpoly (-(27 * s ^ 2)) (16 * s)
      = (X - C (-(18 * s))) ^ 2
        * ((X - C (10 * s + 16 * e)) * (X - C (10 * s - 16 * e))) := by
  have expand : ((X - C (-(18 * s))) ^ 2
        * ((X - C (10 * s + 16 * e)) * (X - C (10 * s - 16 * e))) : Polynomial ℂ)
      = (X - C (-(18 * s))) * (X - C (-(18 * s))) * (X - C (10 * s + 16 * e))
        * (X - C (10 * s - 16 * e)) := by
    ring
  rw [expand, prod_four_linear_eq_monicQuartic, oddRuledEulerCharpoly]
  congr 1 <;>
    first
      | linear_combination (82944 * s ^ 2) * root
      | linear_combination (9216 * s) * root
      | linear_combination (256 : ℂ) * root
      | ring

/-- The two simple eigenvalues on the odd degeneracy locus differ from the double
one whenever the section value is nonzero. -/
theorem oddRuledEuler_degenerate_simple_ne (s e : ℂ) (root : e ^ 2 = -(2 * s ^ 2))
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

section RankTwoBlock

/-- The nilpotent part of a rank-two block is square-zero.  A two-by-two complex
matrix with a single eigenvalue has trace twice and determinant the square of
that eigenvalue, and Cayley--Hamilton in rank two then says that the centred
matrix squares to zero.  Together with the exclusion of blocks of rank three and
four, this completes the trichotomy of block shapes for a degenerate
specialization. -/
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
