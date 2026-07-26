import Mathlib

/-!
# A full-support quadratic relation forces cubic fullness

This module formalizes the elementary dual argument used for the Clebsch
matching evaluation algebra.  If the annihilator of all quadratic products
is a full-support line, then no nonzero functional can annihilate all cubic
products unless every function in the original unital space is constant.

The theorem is stated through annihilators, so it does not depend on a
particular implementation of Schur-power subspaces.
-/

namespace RelativeConicArcs.HyperplaneSquare

open scoped BigOperators

/-- If every quadratic annihilator is a multiple of a full-support vector,
then the annihilator of the cubic products is zero, provided the unital
function space contains a nonconstant function. -/
theorem cubicAnnihilator_eq_zero
    {k Ω : Type*} [Field k] [Fintype Ω]
    (L : Submodule k (Ω → k))
    (ε η : Ω → k)
    (hone : (1 : Ω → k) ∈ L)
    (hnonconstant : ∃ f ∈ L, ∃ i j, f i ≠ f j)
    (hε : ∀ i, ε i ≠ 0)
    (hquadratic :
      ∀ ξ : Ω → k,
        (∀ f ∈ L, ∀ g ∈ L, ∑ i, ξ i * f i * g i = 0) →
        ∃ a : k, ξ = a • ε)
    (hcubic :
      ∀ f ∈ L, ∀ g ∈ L, ∀ h ∈ L,
        ∑ i, η i * f i * g i * h i = 0) :
    η = 0 := by
  have hηquadratic :
      ∀ f ∈ L, ∀ g ∈ L, ∑ i, η i * f i * g i = 0 := by
    intro f hf g hg
    simpa [mul_assoc] using hcubic f hf g hg 1 hone
  obtain ⟨a, ha⟩ := hquadratic η hηquadratic
  subst η
  by_contra hη
  have ha0 : a ≠ 0 := by
    intro ha_zero
    subst a
    simp at hη
  obtain ⟨f, hf, i, j, hij⟩ := hnonconstant
  have htwisted :
      ∀ g ∈ L, ∀ h ∈ L,
        ∑ x, ((a • ε) x * f x) * g x * h x = 0 := by
    intro g hg h hh
    simpa [mul_assoc] using hcubic f hf g hg h hh
  obtain ⟨b, hb⟩ :=
    hquadratic (fun x => (a • ε) x * f x) htwisted
  have hbi := congrFun hb i
  have hbj := congrFun hb j
  simp only [Pi.smul_apply, smul_eq_mul] at hbi hbj
  have hi : a * f i = b := by
    apply mul_right_cancel₀ (hε i)
    simpa [mul_assoc, mul_comm, mul_left_comm] using hbi
  have hj : a * f j = b := by
    apply mul_right_cancel₀ (hε j)
    simpa [mul_assoc, mul_comm, mul_left_comm] using hbj
  apply hij
  apply mul_left_cancel₀ ha0
  exact hi.trans hj.symm

end RelativeConicArcs.HyperplaneSquare
