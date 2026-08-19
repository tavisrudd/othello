import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.PrimaryDiscriminantSplitting
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisDiscriminantGroup

/-!
# The two- and three-primary parts of the six-axis source discriminant

The six-axis source polarization is the Kronecker product of the five-axis
coefficient matrix `6I₅-J₅` with the standard alternating rank-two pairing of
an elliptic homology factor.  Its discriminant group is the cokernel of that
matrix on the standard lattice, of order `6⁸`.  Because `6I₅-J₅` times `I₅+J₅`
is six times the identity, and because the rank-two pairing is unimodular, the
whole discriminant group is annihilated by six.  Six factors as two times
three, so the general coprime splitting applies with the two factors being the
primes themselves: the discriminant group is the sum of its two- and
three-torsion parts, those parts meet only in zero, and they are orthogonal for
the `ℚ/ℤ`-valued discriminant pairing.  Each part therefore also consists
exactly of the classes annihilated by a power of the respective prime, which is
the primary part in the usual sense.

Results.  For any integral comparison matrix pulling a unimodular alternating
form back to the source polarization, the lattice model of the isogeny kernel
splits along the same decomposition, and each primary part of that kernel
equals its own orthogonal complement inside the corresponding primary part of
the discriminant group, hence is maximal among the isotropic subgroups of that
part.  No cardinality argument is used: the statement comes from the pullback
identity through the adjugate and from Bezout's identity.

Trust boundary.  As in the modules this one builds on, every statement is about
explicit integral matrices and finite abelian groups.  No abelian scheme,
elliptic scheme, isogeny, Weil pairing, torsion local system, or geometric
commutator pairing is constructed here, and the identification of these
lattice-level objects with geometric ones is supplied elsewhere.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open scoped Kronecker
open scoped Matrix

/-- The five-by-five matrix `I₅+J₅`: diagonal entries are two and off-diagonal
entries are one.  It is the integral cofactor that carries `6I₅-J₅` to six
times the identity. -/
def sixAxisGramCofactor : Matrix (Fin 5) (Fin 5) ℤ :=
  fun row column ↦ if row = column then 2 else 1

/-- The five-axis coefficient matrix times its cofactor is six times the
identity, so six annihilates the cokernel of the coefficient matrix. -/
theorem sixAxisGram_mul_cofactor :
    sixAxisGram ℤ * sixAxisGramCofactor = (6 : ℤ) • (1 : Matrix (Fin 5) (Fin 5) ℤ) := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    norm_num [sixAxisGram, sixAxisGramCofactor, Matrix.mul_apply, Fin.sum_univ_succ,
      Matrix.smul_apply, Matrix.one_apply] <;> decide

/-- The elliptic homology pairing times its negative is the identity: the
pairing is unimodular with inverse its own negative. -/
theorem ellipticWeilPairing_mul_neg :
    ellipticWeilPairing ℤ * (- ellipticWeilPairing ℤ) = 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    norm_num [ellipticWeilPairing, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply]

/-- The integral cofactor of the six-axis source polarization: the Kronecker
product of the coefficient cofactor with the inverse of the elliptic homology
pairing. -/
def sixAxisSourcePolarizationCofactor : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ :=
  sixAxisGramCofactor ⊗ₖ (- ellipticWeilPairing ℤ)

/-- The six-axis source polarization times its integral cofactor is six times
the identity. -/
theorem sixAxisSourcePolarization_mul_cofactor :
    sixAxisSourcePolarization ℤ * sixAxisSourcePolarizationCofactor =
      (6 : ℤ) • (1 : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ) := by
  rw [sixAxisSourcePolarization, sixAxisSourcePolarizationCofactor,
    ← Matrix.mul_kronecker_mul, sixAxisGram_mul_cofactor, ellipticWeilPairing_mul_neg,
    Matrix.smul_kronecker, Matrix.one_kronecker_one]

/-- Six annihilates the discriminant group of the six-axis source
polarization. -/
theorem sixAxisSourceDiscriminantGroup_six_smul_eq_zero
    (element : sixAxisSourceDiscriminantGroup) : (6 : ℤ) • element = 0 := by
  obtain ⟨representative, rfl⟩ := Submodule.Quotient.mk_surjective _ element
  have inLattice : (6 : ℤ) • representative ∈ latticeImage (sixAxisSourcePolarization ℤ) :=
    mem_latticeImage_iff.mpr
      ⟨sixAxisSourcePolarizationCofactor *ᵥ representative, by
        rw [Matrix.mulVec_mulVec, sixAxisSourcePolarization_mul_cofactor, Matrix.smul_mulVec,
          Matrix.one_mulVec]⟩
  exact (Submodule.Quotient.mk_eq_zero _).mpr inLattice

/-- Two and three are coprime: this is the factorization of the annihilator six
that the primary splitting uses. -/
theorem sixAxisSourceDiscriminant_two_three_isCoprime : IsCoprime (2 : ℤ) 3 :=
  ⟨-1, 1, by norm_num⟩

/-- The product of two and three annihilates the discriminant group. -/
theorem sixAxisSourceDiscriminantGroup_two_mul_three_smul_eq_zero
    (element : sixAxisSourceDiscriminantGroup) : ((2 : ℤ) * 3) • element = 0 := by
  rw [show (2 : ℤ) * 3 = 6 by norm_num]
  exact sixAxisSourceDiscriminantGroup_six_smul_eq_zero element

/-- The product of three and two annihilates the discriminant group. -/
theorem sixAxisSourceDiscriminantGroup_three_mul_two_smul_eq_zero
    (element : sixAxisSourceDiscriminantGroup) : ((3 : ℤ) * 2) • element = 0 := by
  rw [show (3 : ℤ) * 2 = 6 by norm_num]
  exact sixAxisSourceDiscriminantGroup_six_smul_eq_zero element

/-- The `p`-primary part of the discriminant group of the six-axis source
polarization, for `p` two or three: the classes annihilated by `p`.  Since the
whole group is annihilated by six, this is exactly the set of classes
annihilated by some power of `p`, by
`mem_sixAxisSourceDiscriminantPrimaryPart_iff_exists_pow`. -/
def sixAxisSourceDiscriminantPrimaryPart (prime : ℤ) :
    Submodule ℤ sixAxisSourceDiscriminantGroup :=
  Submodule.torsionBy ℤ sixAxisSourceDiscriminantGroup prime

/-- A class lies in the two-primary part exactly when a power of two
annihilates it, and in the three-primary part exactly when a power of three
does. -/
theorem mem_sixAxisSourceDiscriminantPrimaryPart_iff_exists_pow
    (element : sixAxisSourceDiscriminantGroup) :
    (element ∈ sixAxisSourceDiscriminantPrimaryPart 2 ↔
        ∃ exponent : ℕ, ((2 : ℤ) ^ exponent) • element = 0) ∧
      (element ∈ sixAxisSourceDiscriminantPrimaryPart 3 ↔
        ∃ exponent : ℕ, ((3 : ℤ) ^ exponent) • element = 0) :=
  ⟨mem_torsionBy_iff_exists_pow_smul_eq_zero sixAxisSourceDiscriminant_two_three_isCoprime
      sixAxisSourceDiscriminantGroup_two_mul_three_smul_eq_zero element,
    mem_torsionBy_iff_exists_pow_smul_eq_zero
      sixAxisSourceDiscriminant_two_three_isCoprime.symm
      sixAxisSourceDiscriminantGroup_three_mul_two_smul_eq_zero element⟩

/-- The discriminant group of the six-axis source polarization is the direct
sum of its two- and three-primary parts, and those parts are orthogonal for the
discriminant pairing. -/
theorem sixAxisSourceDiscriminant_primaryDecomposition :
    sixAxisSourceDiscriminantPrimaryPart 2 ⊔ sixAxisSourceDiscriminantPrimaryPart 3 = ⊤ ∧
      sixAxisSourceDiscriminantPrimaryPart 2 ⊓ sixAxisSourceDiscriminantPrimaryPart 3 = ⊥ ∧
        ∀ left ∈ sixAxisSourceDiscriminantPrimaryPart 2,
          ∀ right ∈ sixAxisSourceDiscriminantPrimaryPart 3,
            sixAxisSourceDiscriminantPairing left right = 0 :=
  ⟨sup_torsionBy_eq_top_of_isCoprime sixAxisSourceDiscriminant_two_three_isCoprime
      sixAxisSourceDiscriminantGroup_two_mul_three_smul_eq_zero,
    inf_torsionBy_eq_bot_of_isCoprime sixAxisSourceDiscriminant_two_three_isCoprime,
    fun _ leftMembership _ rightMembership ↦
      discriminantPairing_eq_zero_of_torsionBy_isCoprime (sixAxisSourcePolarization_transpose ℤ)
        sixAxisSourcePolarization_det_ne_zero sixAxisSourceDiscriminant_two_three_isCoprime
        leftMembership rightMembership⟩

/-- The discriminant pairing remains nondegenerate on each primary part: a
class of one part orthogonal to that whole part is zero. -/
theorem sixAxisSourceDiscriminantPrimaryPart_nondegenerate
    {element : sixAxisSourceDiscriminantGroup}
    (twoPrimary : element ∈ sixAxisSourceDiscriminantPrimaryPart 2)
    (orthogonal : ∀ other ∈ sixAxisSourceDiscriminantPrimaryPart 2,
      sixAxisSourceDiscriminantPairing element other = 0) :
    element = 0 :=
  eq_zero_of_forall_torsionBy (sixAxisSourcePolarization_transpose ℤ)
    sixAxisSourcePolarization_det_ne_zero sixAxisSourceDiscriminant_two_three_isCoprime
    sixAxisSourceDiscriminantGroup_two_mul_three_smul_eq_zero twoPrimary orthogonal

section Comparison

variable {comparison target : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ}

/-- The `p`-primary part of the lattice model of the kernel of a relative
isogeny: its intersection with the `p`-primary part of the discriminant group
of the six-axis source polarization. -/
def sixAxisSourcePrimaryKernelSubgroup
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ)
    (prime : ℤ) : Submodule ℤ sixAxisSourceDiscriminantGroup :=
  comparisonKernelSubgroup pullback ⊓ sixAxisSourceDiscriminantPrimaryPart prime

/-- The lattice model of the isogeny kernel is the direct sum of its two- and
three-primary parts. -/
theorem sixAxisSourceKernelSubgroup_primaryDecomposition
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    comparisonKernelSubgroup pullback =
        sixAxisSourcePrimaryKernelSubgroup pullback 2 ⊔
          sixAxisSourcePrimaryKernelSubgroup pullback 3 ∧
      sixAxisSourcePrimaryKernelSubgroup pullback 2 ⊓
          sixAxisSourcePrimaryKernelSubgroup pullback 3 = ⊥ := by
  refine ⟨eq_sup_inf_torsionBy_of_isCoprime sixAxisSourceDiscriminant_two_three_isCoprime
      sixAxisSourceDiscriminantGroup_two_mul_three_smul_eq_zero _, le_antisymm ?_ bot_le⟩
  calc sixAxisSourcePrimaryKernelSubgroup pullback 2 ⊓
        sixAxisSourcePrimaryKernelSubgroup pullback 3
      ≤ sixAxisSourceDiscriminantPrimaryPart 2 ⊓ sixAxisSourceDiscriminantPrimaryPart 3 :=
        inf_le_inf inf_le_right inf_le_right
    _ = ⊥ := inf_torsionBy_eq_bot_of_isCoprime sixAxisSourceDiscriminant_two_three_isCoprime

/-- Each primary part of the lattice model of the isogeny kernel equals its own
orthogonal complement inside the corresponding primary part of the discriminant
group. -/
theorem sixAxisSourcePrimaryKernelSubgroup_eq_perpWithin (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    sixAxisSourcePrimaryKernelSubgroup pullback 2 =
        discriminantPerpWithin (sixAxisSourcePolarization_transpose ℤ)
          sixAxisSourcePolarization_det_ne_zero (sixAxisSourceDiscriminantPrimaryPart 2)
          (sixAxisSourcePrimaryKernelSubgroup pullback 2) ∧
      sixAxisSourcePrimaryKernelSubgroup pullback 3 =
        discriminantPerpWithin (sixAxisSourcePolarization_transpose ℤ)
          sixAxisSourcePolarization_det_ne_zero (sixAxisSourceDiscriminantPrimaryPart 3)
          (sixAxisSourcePrimaryKernelSubgroup pullback 3) :=
  ⟨inf_torsionBy_eq_perpWithin (sixAxisSourcePolarization_transpose ℤ)
      sixAxisSourcePolarization_det_ne_zero sixAxisSourceDiscriminant_two_three_isCoprime
      sixAxisSourceDiscriminantGroup_two_mul_three_smul_eq_zero
      (sixAxisSourceKernelSubgroup_eq_perp principal pullback),
    inf_torsionBy_eq_perpWithin (sixAxisSourcePolarization_transpose ℤ)
      sixAxisSourcePolarization_det_ne_zero
      sixAxisSourceDiscriminant_two_three_isCoprime.symm
      sixAxisSourceDiscriminantGroup_three_mul_two_smul_eq_zero
      (sixAxisSourceKernelSubgroup_eq_perp principal pullback)⟩

/-- Each primary part of the lattice model of the isogeny kernel is maximal
among the isotropic subgroups of the corresponding primary part of the
discriminant group.  This is the lattice-level form of the assertion that the
`p`-primary part of the kernel of the relative isogeny is a relative maximal
isotropic subgroup of the `p`-primary discriminant. -/
theorem sixAxisSourcePrimaryKernelSubgroup_isRelativeMaximalIsotropic
    (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    IsRelativeMaximalIsotropicSubgroup (sixAxisSourcePolarization_transpose ℤ)
        sixAxisSourcePolarization_det_ne_zero (sixAxisSourceDiscriminantPrimaryPart 2)
        (sixAxisSourcePrimaryKernelSubgroup pullback 2) ∧
      IsRelativeMaximalIsotropicSubgroup (sixAxisSourcePolarization_transpose ℤ)
        sixAxisSourcePolarization_det_ne_zero (sixAxisSourceDiscriminantPrimaryPart 3)
        (sixAxisSourcePrimaryKernelSubgroup pullback 3) :=
  ⟨isRelativeMaximalIsotropicSubgroup_of_eq_perpWithin
      (sixAxisSourcePrimaryKernelSubgroup_eq_perpWithin principal pullback).1,
    isRelativeMaximalIsotropicSubgroup_of_eq_perpWithin
      (sixAxisSourcePrimaryKernelSubgroup_eq_perpWithin principal pullback).2⟩

end Comparison

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
