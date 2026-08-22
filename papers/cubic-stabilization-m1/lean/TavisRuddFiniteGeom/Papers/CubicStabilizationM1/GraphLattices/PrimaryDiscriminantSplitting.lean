import Mathlib.Algebra.Module.Torsion.Basic
import Mathlib.RingTheory.Coprime.Lemmas
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.IntegralDiscriminantGroup

/-!
# Primary splitting of an integral discriminant group

An integral alternating form `F` of nonzero determinant on `Λ = ℤ^ι` has a
discriminant group `Λ^#/Λ`, presented as the cokernel of `F` on the standard
lattice, and a nondegenerate `ℚ/ℤ`-valued discriminant pairing on it.  That
group is annihilated by an integer — the determinant always works, and a
smaller annihilator is available whenever the form admits an integral matrix
carrying it to a multiple of the identity.  This module splits such a group
along a factorization of an annihilator into two coprime factors, and
transports self-duality of a subgroup to each factor.

Conventions.  For an integer `a`, the `a`-torsion submodule
`Submodule.torsionBy ℤ M a` is the set of elements annihilated by `a`.  When
`M` is annihilated by `a*b` with `a` and `b` coprime, this submodule is also
the set of elements annihilated by some power of `a`, by
`mem_torsionBy_iff_exists_pow_smul_eq_zero`, so for `a` a prime power it is the
primary part in the usual sense.  A subgroup
`𝒦` of the discriminant group is *isotropic* when the pairing vanishes on
`𝒦 × 𝒦`, and *maximal isotropic* when no larger subgroup is isotropic;
*relative* maximal isotropy is the same statement with all comparisons taken
inside an ambient subgroup, which is the form the primary parts require.

Results.  Every subgroup of a module annihilated by `a*b` with `a` and `b`
coprime is the sum of its `a`-torsion and `b`-torsion parts, and those two
parts intersect trivially; a bilinear map kills a pair drawn from the two
different parts; and consequently distinct primary parts of a discriminant
group are orthogonal and the discriminant pairing stays nondegenerate on each
of them.  If a subgroup `𝒦` equals its own orthogonal complement in the whole
discriminant group, then for each factor the part `𝒦 ⊓ D_a` equals its own
orthogonal complement inside `D_a` and is therefore maximal among the isotropic
subgroups of `D_a`.  The argument is Bezout's identity throughout; no
cardinality enters.

Trust boundary.  Every statement here is about integral matrices and finitely
generated abelian groups.  No abelian variety, isogeny, polarization, torsion
local system, or commutator pairing is constructed, and the identification of
these lattice-level objects with geometric ones is supplied elsewhere.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

open scoped Matrix

section CoprimeTorsion

variable {M : Type*} [AddCommGroup M]

/-- Membership in the torsion submodule belonging to an integer is
annihilation by that integer. -/
theorem mem_torsionBy_iff_smul_eq_zero {scalar : ℤ} {element : M} :
    element ∈ Submodule.torsionBy ℤ M scalar ↔ scalar • element = 0 :=
  Submodule.mem_torsionBy_iff scalar element

/-- Bezout splitting of an element annihilated by a product of two coprime
integers: it is the sum of two of its own integer multiples, the first
annihilated by the first factor and the second annihilated by the second.  The
components are multiples of the element itself, so they lie in every subgroup
that contains it. -/
theorem exists_coprime_torsion_decomposition {first second : ℤ}
    (coprime : IsCoprime first second) {element : M}
    (annihilated : (first * second) • element = 0) :
    ∃ leftCoefficient rightCoefficient : ℤ,
      leftCoefficient • element + rightCoefficient • element = element ∧
        first • (leftCoefficient • element) = 0 ∧
          second • (rightCoefficient • element) = 0 := by
  obtain ⟨leftBezout, rightBezout, bezout⟩ := coprime
  refine ⟨rightBezout * second, leftBezout * first, ?_, ?_, ?_⟩
  · rw [← add_smul]
    have sum : rightBezout * second + leftBezout * first = 1 := by
      rw [add_comm]; exact bezout
    rw [sum, one_smul]
  · rw [smul_smul]
    have regrouped : first * (rightBezout * second) = rightBezout * (first * second) := by ring
    rw [regrouped, mul_smul, annihilated, smul_zero]
  · rw [smul_smul]
    have regrouped : second * (leftBezout * first) = leftBezout * (first * second) := by ring
    rw [regrouped, mul_smul, annihilated, smul_zero]

/-- In a module annihilated by a product of two coprime integers, every
subgroup is the sum of its two torsion parts. -/
theorem eq_sup_inf_torsionBy_of_isCoprime {first second : ℤ}
    (coprime : IsCoprime first second)
    (annihilated : ∀ element : M, (first * second) • element = 0)
    (subgroup : Submodule ℤ M) :
    subgroup =
      (subgroup ⊓ Submodule.torsionBy ℤ M first) ⊔
        (subgroup ⊓ Submodule.torsionBy ℤ M second) := by
  refine le_antisymm (fun element membership ↦ ?_) (sup_le inf_le_left inf_le_left)
  obtain ⟨leftCoefficient, rightCoefficient, sum, leftTorsion, rightTorsion⟩ :=
    exists_coprime_torsion_decomposition coprime (annihilated element)
  rw [← sum]
  exact Submodule.add_mem_sup
    (Submodule.mem_inf.mpr
      ⟨Submodule.smul_mem _ _ membership, mem_torsionBy_iff_smul_eq_zero.mpr leftTorsion⟩)
    (Submodule.mem_inf.mpr
      ⟨Submodule.smul_mem _ _ membership, mem_torsionBy_iff_smul_eq_zero.mpr rightTorsion⟩)

/-- The torsion parts belonging to two coprime integers meet only in zero. -/
theorem inf_torsionBy_eq_bot_of_isCoprime {first second : ℤ}
    (coprime : IsCoprime first second) :
    Submodule.torsionBy ℤ M first ⊓ Submodule.torsionBy ℤ M second = ⊥ := by
  obtain ⟨leftBezout, rightBezout, bezout⟩ := coprime
  refine le_antisymm (fun element membership ↦ ?_) bot_le
  have leftTorsion : first • element = 0 :=
    mem_torsionBy_iff_smul_eq_zero.mp (Submodule.mem_inf.mp membership).1
  have rightTorsion : second • element = 0 :=
    mem_torsionBy_iff_smul_eq_zero.mp (Submodule.mem_inf.mp membership).2
  refine Submodule.mem_bot ℤ |>.mpr ?_
  calc element
      = (leftBezout * first + rightBezout * second) • element := by rw [bezout, one_smul]
    _ = leftBezout • (first • element) + rightBezout • (second • element) := by
        rw [add_smul, mul_smul, mul_smul]
    _ = 0 := by rw [leftTorsion, rightTorsion, smul_zero, smul_zero, add_zero]

/-- A module annihilated by a product of two coprime integers is the sum of its
two torsion parts. -/
theorem sup_torsionBy_eq_top_of_isCoprime {first second : ℤ}
    (coprime : IsCoprime first second)
    (annihilated : ∀ element : M, (first * second) • element = 0) :
    Submodule.torsionBy ℤ M first ⊔ Submodule.torsionBy ℤ M second = ⊤ := by
  have decomposition := eq_sup_inf_torsionBy_of_isCoprime coprime annihilated ⊤
  rw [top_inf_eq, top_inf_eq] at decomposition
  exact decomposition.symm

/-- In a module annihilated by a product of two coprime integers, an element
annihilated by a power of the first factor is annihilated by that factor
itself.  This is what makes the first torsion part the primary part belonging
to a prime power factorization. -/
theorem mem_torsionBy_iff_exists_pow_smul_eq_zero {first second : ℤ}
    (coprime : IsCoprime first second)
    (annihilated : ∀ element : M, (first * second) • element = 0) (element : M) :
    element ∈ Submodule.torsionBy ℤ M first ↔
      ∃ exponent : ℕ, (first ^ exponent) • element = 0 := by
  constructor
  · intro membership
    exact ⟨1, by rw [pow_one]; exact mem_torsionBy_iff_smul_eq_zero.mp membership⟩
  · rintro ⟨exponent, vanishing⟩
    refine mem_torsionBy_iff_smul_eq_zero.mpr ?_
    match exponent with
    | 0 =>
      rw [pow_zero, one_smul] at vanishing
      rw [vanishing, smul_zero]
    | lower + 1 =>
      obtain ⟨leftBezout, rightBezout, bezout⟩ :=
        IsCoprime.pow_left (m := lower) coprime
      have identity :
          leftBezout * first ^ (lower + 1) + rightBezout * (first * second) = first := by
        calc leftBezout * first ^ (lower + 1) + rightBezout * (first * second)
            = first * (leftBezout * first ^ lower + rightBezout * second) := by ring
          _ = first := by rw [bezout, mul_one]
      calc first • element
          = (leftBezout * first ^ (lower + 1) + rightBezout * (first * second)) • element := by
            rw [identity]
        _ = leftBezout • ((first ^ (lower + 1)) • element) +
              rightBezout • ((first * second) • element) := by
            rw [add_smul, mul_smul, mul_smul]
        _ = 0 := by
            rw [vanishing, annihilated element, smul_zero, smul_zero, add_zero]

/-- A bilinear map vanishes on a pair whose two entries are annihilated by
coprime integers. -/
theorem bilinear_eq_zero_of_isCoprime_torsion {N : Type*} [AddCommGroup N]
    (pairing : M →ₗ[ℤ] M →ₗ[ℤ] N) {first second : ℤ} (coprime : IsCoprime first second)
    {left right : M} (leftTorsion : first • left = 0) (rightTorsion : second • right = 0) :
    pairing left right = 0 := by
  obtain ⟨leftBezout, rightBezout, bezout⟩ := coprime
  have leftValue : first • pairing left right = 0 := by
    rw [← LinearMap.smul_apply, ← map_smul, leftTorsion, map_zero, LinearMap.zero_apply]
  have rightValue : second • pairing left right = 0 := by
    rw [← map_smul, rightTorsion, map_zero]
  calc pairing left right
      = (leftBezout * first + rightBezout * second) • pairing left right := by
        rw [bezout, one_smul]
    _ = leftBezout • (first • pairing left right) +
          rightBezout • (second • pairing left right) := by
        rw [add_smul, mul_smul, mul_smul]
    _ = 0 := by rw [leftValue, rightValue, smul_zero, smul_zero, add_zero]

end CoprimeTorsion

section RelativeIsotropy

variable {ι : Type*} [Fintype ι] [DecidableEq ι] {form : Matrix ι ι ℤ}

/-- The orthogonal complement of a subgroup of a discriminant group, taken
inside an ambient subgroup. -/
def discriminantPerpWithin (alternating : formᵀ = -form) (nondegenerate : form.det ≠ 0)
    (ambient subgroup : Submodule ℤ (discriminantGroup form)) :
    Submodule ℤ (discriminantGroup form) :=
  ambient ⊓ discriminantPerp alternating nondegenerate subgroup

/-- The relative orthogonal complement lies in the ambient subgroup. -/
theorem discriminantPerpWithin_le_ambient {alternating : formᵀ = -form}
    {nondegenerate : form.det ≠ 0} {ambient subgroup : Submodule ℤ (discriminantGroup form)} :
    discriminantPerpWithin alternating nondegenerate ambient subgroup ≤ ambient :=
  inf_le_left

/-- The relative orthogonal complement lies in the absolute one. -/
theorem discriminantPerpWithin_le_discriminantPerp {alternating : formᵀ = -form}
    {nondegenerate : form.det ≠ 0} {ambient subgroup : Submodule ℤ (discriminantGroup form)} :
    discriminantPerpWithin alternating nondegenerate ambient subgroup ≤
      discriminantPerp alternating nondegenerate subgroup :=
  inf_le_right

/-- A subgroup of the ambient one that is orthogonal to a given subgroup lies
in the relative orthogonal complement. -/
theorem le_discriminantPerpWithin {alternating : formᵀ = -form}
    {nondegenerate : form.det ≠ 0}
    {ambient subgroup candidate : Submodule ℤ (discriminantGroup form)}
    (inside : candidate ≤ ambient)
    (orthogonal : candidate ≤ discriminantPerp alternating nondegenerate subgroup) :
    candidate ≤ discriminantPerpWithin alternating nondegenerate ambient subgroup :=
  le_inf inside orthogonal

/-- Relative maximal isotropy: the subgroup lies in the ambient subgroup, pairs
trivially with itself, and no larger isotropic subgroup of the ambient one
contains it. -/
def IsRelativeMaximalIsotropicSubgroup (alternating : formᵀ = -form)
    (nondegenerate : form.det ≠ 0)
    (ambient subgroup : Submodule ℤ (discriminantGroup form)) : Prop :=
  subgroup ≤ ambient ∧
    subgroup ≤ discriminantPerp alternating nondegenerate subgroup ∧
      ∀ larger : Submodule ℤ (discriminantGroup form),
        subgroup ≤ larger → larger ≤ ambient →
          larger ≤ discriminantPerp alternating nondegenerate larger → larger = subgroup

/-- A subgroup equal to its own orthogonal complement inside an ambient
subgroup is maximal among the isotropic subgroups of that ambient subgroup. -/
theorem isRelativeMaximalIsotropicSubgroup_of_eq_perpWithin {alternating : formᵀ = -form}
    {nondegenerate : form.det ≠ 0} {ambient subgroup : Submodule ℤ (discriminantGroup form)}
    (selfOrthogonal :
      subgroup = discriminantPerpWithin alternating nondegenerate ambient subgroup) :
    IsRelativeMaximalIsotropicSubgroup alternating nondegenerate ambient subgroup := by
  refine ⟨selfOrthogonal.le.trans discriminantPerpWithin_le_ambient,
    selfOrthogonal.le.trans discriminantPerpWithin_le_discriminantPerp,
    fun larger contains inside isotropic ↦ le_antisymm ?_ contains⟩
  have orthogonal : larger ≤ discriminantPerp alternating nondegenerate subgroup :=
    isotropic.trans (discriminantPerp_antitone alternating nondegenerate contains)
  exact le_of_le_of_eq (le_discriminantPerpWithin inside orthogonal) selfOrthogonal.symm

end RelativeIsotropy

section PrimarySplitting

variable {ι : Type*} [Fintype ι] [DecidableEq ι] {form : Matrix ι ι ℤ}
  (alternating : formᵀ = -form) (nondegenerate : form.det ≠ 0)

/-- Torsion parts of a discriminant group belonging to coprime integers are
orthogonal for the discriminant pairing. -/
theorem discriminantPairing_eq_zero_of_torsionBy_isCoprime {first second : ℤ}
    (coprime : IsCoprime first second) {left right : discriminantGroup form}
    (leftTorsion : left ∈ Submodule.torsionBy ℤ (discriminantGroup form) first)
    (rightTorsion : right ∈ Submodule.torsionBy ℤ (discriminantGroup form) second) :
    discriminantPairing alternating nondegenerate left right = 0 :=
  bilinear_eq_zero_of_isCoprime_torsion (discriminantPairing alternating nondegenerate) coprime
    (mem_torsionBy_iff_smul_eq_zero.mp leftTorsion)
    (mem_torsionBy_iff_smul_eq_zero.mp rightTorsion)

/-- The discriminant pairing stays nondegenerate on each torsion part: an
element of one part orthogonal to that whole part is zero. -/
theorem eq_zero_of_forall_torsionBy {first second : ℤ} (coprime : IsCoprime first second)
    (annihilated : ∀ element : discriminantGroup form, (first * second) • element = 0)
    {element : discriminantGroup form}
    (torsion : element ∈ Submodule.torsionBy ℤ (discriminantGroup form) first)
    (orthogonal : ∀ other ∈ Submodule.torsionBy ℤ (discriminantGroup form) first,
      discriminantPairing alternating nondegenerate element other = 0) :
    element = 0 := by
  refine discriminantPairing_eq_zero_of_forall alternating nondegenerate (fun other ↦ ?_)
  have vanishing :
      Submodule.torsionBy ℤ (discriminantGroup form) first ⊔
          Submodule.torsionBy ℤ (discriminantGroup form) second ≤
        LinearMap.ker (discriminantPairing alternating nondegenerate element) :=
    sup_le (fun candidate membership ↦ LinearMap.mem_ker.mpr (orthogonal candidate membership))
      (fun candidate membership ↦
        LinearMap.mem_ker.mpr
          (discriminantPairing_eq_zero_of_torsionBy_isCoprime alternating nondegenerate coprime
            torsion membership))
  have total : other ∈
      Submodule.torsionBy ℤ (discriminantGroup form) first ⊔
        Submodule.torsionBy ℤ (discriminantGroup form) second := by
    rw [sup_torsionBy_eq_top_of_isCoprime coprime annihilated]
    exact Submodule.mem_top
  exact LinearMap.mem_ker.mp (vanishing total)

/-- Transport of self-duality to a torsion part.  If a subgroup of a
discriminant group annihilated by a product of two coprime integers equals its
own orthogonal complement, then its first torsion part equals its own
orthogonal complement inside the first torsion part of the whole group. -/
theorem inf_torsionBy_eq_perpWithin {first second : ℤ} (coprime : IsCoprime first second)
    (annihilated : ∀ element : discriminantGroup form, (first * second) • element = 0)
    {subgroup : Submodule ℤ (discriminantGroup form)}
    (selfOrthogonal : subgroup = discriminantPerp alternating nondegenerate subgroup) :
    subgroup ⊓ Submodule.torsionBy ℤ (discriminantGroup form) first =
      discriminantPerpWithin alternating nondegenerate
        (Submodule.torsionBy ℤ (discriminantGroup form) first)
        (subgroup ⊓ Submodule.torsionBy ℤ (discriminantGroup form) first) := by
  refine le_antisymm (le_discriminantPerpWithin inf_le_right (fun element membership ↦ ?_))
    (fun element membership ↦ ?_)
  · exact fun other otherMembership ↦
      selfOrthogonal.le (Submodule.mem_inf.mp membership).1 other
        (Submodule.mem_inf.mp otherMembership).1
  · obtain ⟨torsion, orthogonality⟩ := Submodule.mem_inf.mp membership
    refine Submodule.mem_inf.mpr ⟨?_, torsion⟩
    rw [selfOrthogonal]
    refine mem_discriminantPerp_iff.mpr (fun other otherMembership ↦ ?_)
    obtain ⟨leftCoefficient, rightCoefficient, sum, leftTorsion, rightTorsion⟩ :=
      exists_coprime_torsion_decomposition coprime (annihilated other)
    rw [← sum, map_add]
    have leftVanishing :
        discriminantPairing alternating nondegenerate element (leftCoefficient • other) = 0 :=
      orthogonality _
        (Submodule.mem_inf.mpr
          ⟨Submodule.smul_mem _ _ otherMembership,
            mem_torsionBy_iff_smul_eq_zero.mpr leftTorsion⟩)
    have rightVanishing :
        discriminantPairing alternating nondegenerate element (rightCoefficient • other) = 0 :=
      discriminantPairing_eq_zero_of_torsionBy_isCoprime alternating nondegenerate coprime torsion
        (mem_torsionBy_iff_smul_eq_zero.mpr rightTorsion)
    rw [leftVanishing, rightVanishing, add_zero]

/-- Transport of maximal isotropy to a torsion part: the part of a self-dual
subgroup belonging to one of two coprime annihilator factors is maximal among
the isotropic subgroups of the corresponding torsion part of the whole
discriminant group. -/
theorem isRelativeMaximalIsotropic_inf_torsionBy {first second : ℤ}
    (coprime : IsCoprime first second)
    (annihilated : ∀ element : discriminantGroup form, (first * second) • element = 0)
    {subgroup : Submodule ℤ (discriminantGroup form)}
    (selfOrthogonal : subgroup = discriminantPerp alternating nondegenerate subgroup) :
    IsRelativeMaximalIsotropicSubgroup alternating nondegenerate
      (Submodule.torsionBy ℤ (discriminantGroup form) first)
      (subgroup ⊓ Submodule.torsionBy ℤ (discriminantGroup form) first) :=
  isRelativeMaximalIsotropicSubgroup_of_eq_perpWithin
    (inf_torsionBy_eq_perpWithin alternating nondegenerate coprime annihilated selfOrthogonal)

end PrimarySplitting

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
