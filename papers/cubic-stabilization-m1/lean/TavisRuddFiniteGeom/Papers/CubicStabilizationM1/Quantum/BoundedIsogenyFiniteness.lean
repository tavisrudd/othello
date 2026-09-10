import Mathlib.Tactic
import Mathlib.GroupTheory.OrderOfElement
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Data.Set.Finite.Powerset

/-!
# Finite kernels and geometric isogeny classes

A finite subgroup of order at most a fixed natural number lies in the torsion
annihilated by the factorial of that number. If this torsion is finite, there
are finitely many such kernels. Quotient objects determined by these kernels
then form a finite set. Passing through finite polarization fibers and an
injective geometric reconstruction preserves finiteness.

The arithmetic bound on isogeny degrees, finiteness of torsion, geometric
quotient classification, finite polarization fibers, and geometric Torelli
reconstruction are explicit hypotheses. No statement about twists over the
base field or effective numerical bounds is asserted.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- A subgroup of bounded finite order is annihilated by the factorial bound. -/
theorem finiteSubgroup_mem_factorialTorsion
    {A : Type*} [AddCommGroup A] (kernel : AddSubgroup A) [Finite kernel]
    (bound : ℕ) (bounded : Nat.card kernel ≤ bound) {x : A} (member : x ∈ kernel) :
    bound.factorial • x=0 := by
  have positive : 0 < Nat.card kernel := Nat.card_pos
  obtain ⟨multiple, equation⟩ := Nat.dvd_factorial positive bounded
  have killed : Nat.card kernel • x=0 := by
    have h : Nat.card kernel • (⟨x,member⟩ : kernel)=0 := card_nsmul_eq_zero'
    exact congrArg Subtype.val h
  rw [equation, mul_nsmul, killed, smul_zero]

/-- Finite factorial torsion gives finitely many underlying kernel sets of
subgroups whose orders satisfy the fixed bound. -/
theorem finite_boundedKernelSets
    {A : Type*} [AddCommGroup A] (bound : ℕ)
    (finiteTorsion : Set.Finite {x : A | bound.factorial • x=0}) :
    Set.Finite {s : Set A | ∃ kernel : AddSubgroup A,
      (kernel : Set A)=s ∧ Finite kernel ∧ Nat.card kernel ≤ bound} := by
  apply finiteTorsion.finite_subsets.subset
  rintro s ⟨kernel,rfl,finiteKernel,bounded⟩ x member
  letI : Finite kernel := finiteKernel
  exact finiteSubgroup_mem_factorialTorsion kernel bound bounded member

/-- A map with finite fibers pulls finite sets back to finite sets. This
retains all polarization classes above each unpolarized quotient class. -/
theorem finite_preimage_of_finite_fibers
    {Source Target : Type*} (map : Source → Target)
    (fibers : ∀ target, Set.Finite {source | map source=target})
    {targets : Set Target} (finiteTargets : targets.Finite) :
    (map ⁻¹' targets).Finite := by
  have h := finiteTargets.biUnion (fun target _ => fibers target)
  apply h.subset
  intro source member
  exact Set.mem_iUnion₂.mpr ⟨map source,member,rfl⟩

/-- Kernel determination, finite polarization fibers, and injective geometric
reconstruction imply finiteness of the represented geometric classes. The
class types are geometric isomorphism classes, so this does not count forms
or twists over a chosen ground field. -/
theorem finite_geometricClasses_of_bounded_kernels
    {A Unpolarized Polarized Geometric : Type*} [AddCommGroup A]
    (bound : ℕ) (finiteTorsion : Set.Finite {x : A | bound.factorial • x=0})
    (quotientClass : Set A → Unpolarized)
    (forgetPolarization : Polarized → Unpolarized)
    (finitePolarizations : ∀ target, Set.Finite {p | forgetPolarization p=target})
    (invariant : Geometric → Polarized) (torelli : Function.Injective invariant)
    (represented : Set Geometric)
    (kernelRealization : ∀ object ∈ represented, ∃ kernel : AddSubgroup A,
      Finite kernel ∧ Nat.card kernel ≤ bound ∧
      forgetPolarization (invariant object)=quotientClass (kernel : Set A)) :
    represented.Finite := by
  let kernels : Set (Set A) := {s | ∃ kernel : AddSubgroup A,
    (kernel : Set A)=s ∧ Finite kernel ∧ Nat.card kernel ≤ bound}
  have finiteQuotients : (quotientClass '' kernels).Finite :=
    (finite_boundedKernelSets bound finiteTorsion).image quotientClass
  have finitePolarized := finite_preimage_of_finite_fibers
    forgetPolarization finitePolarizations finiteQuotients
  apply (finitePolarized.preimage torelli.injOn).subset
  intro object member
  obtain ⟨kernel,finiteKernel,bounded,equation⟩ := kernelRealization object member
  exact ⟨(kernel : Set A),⟨kernel,rfl,finiteKernel,bounded⟩,equation.symm⟩

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
