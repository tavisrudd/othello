import Mathlib.Tactic
import Mathlib.LinearAlgebra.FiniteDimensional.Basic

/-!
# Transfer of the spectrum of an algebra element to a unital module over it

Let `k` be a field, let `A` be a commutative `k`-algebra of finite dimension,
and let `M` be an `A`-module carrying a compatible `k`-structure.  Fix `E : A`
and call `lam : k` an eigenvalue of `E` on `M` when `E • m = lam • m` for some
nonzero `m : M`, and an eigenvalue of `E` on `A` when `E * a = lam • a` for some
nonzero `a : A`.

The two eigenvalue sets coincide as soon as one element `unit : M` generates a
copy of `A` inside `M`, that is, as soon as `b ↦ b • unit` is injective:

* an eigenvalue on `M` is an eigenvalue on `A` because `E - lam` then fails to be
  a unit of `A`, and in a finite-dimensional algebra a non-unit is a zero
  divisor;
* an eigenvalue on `A` is an eigenvalue on `M` because the eigenvector may be
  pushed into `M` along the injection `b ↦ b • unit`.

The intended reading is that `A` is even quantum cohomology at an even point of
the Hodge base, `M` is the full cohomology of the same variety, which is a
module over `A` because the bulk point is even, `E` is Euler multiplication, and
`unit` is the unit of the cohomology ring, for which `b ↦ b • unit` is injective
because the module structure restricts to the ring multiplication of `A`.  The
conclusion is that computing eigenvalues of Euler multiplication on the even
part loses no eigenvalue of the full cohomology and creates none.

Lean constructs no quantum cohomology, no `F`-bundle, and no Euler field: the
algebra, the module, the element, and the generating vector are arbitrary data
satisfying the hypotheses above.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

variable {k A M : Type*} [Field k] [CommRing A] [Algebra k A]
  [AddCommGroup M] [Module A M] [Module k M] [IsScalarTower k A M]

/-- An eigenvalue of `E` on a module over a finite-dimensional commutative
algebra is an eigenvalue of `E` on the algebra itself: the element `E - lam`
annihilates a nonzero module element, hence is not a unit, hence is a zero
divisor because multiplication by it is a non-injective endomorphism of a
finite-dimensional space. -/
theorem exists_algebra_eigenvector_of_module_eigenvector [FiniteDimensional k A]
    {E : A} {lam : k} {m : M} (hm : m ≠ 0) (heigen : E • m = lam • m) :
    ∃ a : A, a ≠ 0 ∧ E * a = lam • a := by
  set u : A := E - lam • (1 : A) with hu_def
  have hscalar : (lam • (1 : A)) • m = lam • m := by
    rw [smul_assoc, one_smul]
  have hu : u • m = 0 := by
    rw [hu_def, sub_smul, heigen, hscalar, sub_self]
  have hnotunit : ¬ IsUnit u := by
    intro hunit
    obtain ⟨v, hv⟩ := hunit.exists_right_inv
    refine hm ?_
    calc m = ((1 : A)) • m := (one_smul A m).symm
      _ = (v * u) • m := by rw [mul_comm, hv]
      _ = v • (u • m) := mul_smul v u m
      _ = 0 := by rw [hu, smul_zero]
  have hnotinj : ¬ Function.Injective (LinearMap.mulLeft k u) := by
    intro hinj
    obtain ⟨v, hv⟩ := LinearMap.injective_iff_surjective.mp hinj 1
    have huv : u * v = 1 := by simpa using hv
    exact hnotunit (isUnit_iff_exists.mpr ⟨v, huv, by rw [mul_comm]; exact huv⟩)
  obtain ⟨a, b, hab, hne⟩ := Function.not_injective_iff.mp hnotinj
  have hzero : u * (a - b) = 0 := by
    have : u * a = u * b := by simpa using hab
    rw [mul_sub, this, sub_self]
  refine ⟨a - b, sub_ne_zero.mpr hne, ?_⟩
  rw [hu_def, sub_mul, sub_eq_zero] at hzero
  simpa [smul_mul_assoc] using hzero

/-- An eigenvalue of `E` on a commutative algebra is an eigenvalue of `E` on
every module in which some element generates an injective copy of the algebra:
the eigenvector is carried into the module by `b ↦ b • unit`. -/
theorem exists_module_eigenvector_of_algebra_eigenvector
    {E : A} {lam : k} {a : A} (ha : a ≠ 0) (heigen : E * a = lam • a)
    (unit : M) (hunit : Function.Injective fun b : A => b • unit) :
    ∃ m : M, m ≠ 0 ∧ E • m = lam • m := by
  refine ⟨a • unit, ?_, ?_⟩
  · intro h
    exact ha (hunit (by simpa using h))
  · rw [← mul_smul, heigen, smul_assoc]

/-- The eigenvalues of `E` on a unital module over a finite-dimensional
commutative algebra are exactly its eigenvalues on the algebra, provided some
module element generates an injective copy of the algebra. -/
theorem eigenvalues_module_eq_eigenvalues_algebra [FiniteDimensional k A] (E : A)
    (unit : M) (hunit : Function.Injective fun b : A => b • unit) :
    {lam : k | ∃ m : M, m ≠ 0 ∧ E • m = lam • m} =
      {lam : k | ∃ a : A, a ≠ 0 ∧ E * a = lam • a} := by
  ext lam
  constructor
  · rintro ⟨m, hm, h⟩
    exact exists_algebra_eigenvector_of_module_eigenvector hm h
  · rintro ⟨a, ha, h⟩
    exact exists_module_eigenvector_of_algebra_eigenvector ha h unit hunit

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
