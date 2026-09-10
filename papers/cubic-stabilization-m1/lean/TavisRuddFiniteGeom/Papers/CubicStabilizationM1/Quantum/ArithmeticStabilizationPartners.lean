import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.StabilizedWholeOddConservation
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.BoundedIsogenyFiniteness

/-!
# Geometric partners over extensions of bounded degree

Whole odd-object conservation supplies the cohomological premise for a
geometric-isogeny theorem. A separately supplied uniform degree bound gives
bounded kernels for partners admitting models over any extension of the
prescribed degree. Finite torsion, finite polarization fibers and injective
geometric reconstruction then imply finiteness of the union of geometric
partner classes over all those extensions.

The cohomology-to-isogeny implication and uniform isogeny-degree bound are
separate source hypotheses. The latter bounds the degree of an isogeny over
an algebraic closure; it does not bound its field of definition. Family labels
in this interface are geometric isomorphism classes. No finiteness of twists,
effective bound, or Torelli assertion without a supplied hypothesis is claimed.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

universe u v

/-- Finiteness of stabilized geometric partner classes with models over any
extension of bounded degree. Conservation, isogeny existence, degree bounds,
finite torsion, polarization finiteness and Torelli are composed explicitly. -/
theorem finite_arithmetic_stabilizationPartners
    {K Variety Center Occurrence Family Extension A Unpolarized Polarized : Type*}
    [Field K] [CharZero K] [AddCommGroup A]
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (data : StabilizedWholeOddData K Variety Center Occurrence Family ι division)
    (base : Family) (baseSmooth : data.smooth base)
    (extensionDegree : Extension → ℕ) (degreeBound : ℕ)
    (hasModel : Extension → Family → Prop)
    (modelSmooth : ∀ extension object, hasModel extension object → data.smooth object)
    (geometricallyIsogenous : Family → Prop)
    (hodgeToIsogeny : ∀ object, data.smooth object →
      Nonempty (CategoryTheory.Iso (data.wholeOdd base) (data.wholeOdd object)) →
      geometricallyIsogenous object)
    (quotientClass : Set A → Unpolarized)
    (forgetPolarization : Polarized → Unpolarized)
    (invariant : Family → Polarized)
    (uniformKernelBound : ∃ bound : ℕ, ∀ extension object,
      extensionDegree extension ≤ degreeBound → hasModel extension object →
      geometricallyIsogenous object → ∃ kernel : AddSubgroup A,
        Finite kernel ∧ Nat.card kernel ≤ bound ∧
        forgetPolarization (invariant object)=quotientClass (kernel : Set A))
    (finiteTorsion : ∀ n : ℕ, Set.Finite {x : A | n • x=0})
    (finitePolarizations : ∀ target, Set.Finite {p | forgetPolarization p=target})
    (geometricTorelli : Function.Injective invariant) :
    Set.Finite {object : Family | ∃ extension : Extension,
      extensionDegree extension ≤ degreeBound ∧ hasModel extension object ∧
      data.birational.r (data.stabilized base) (data.stabilized object)} := by
  obtain ⟨bound,bounded⟩ := uniformKernelBound
  apply finite_geometricClasses_of_bounded_kernels bound (finiteTorsion bound.factorial)
    quotientClass forgetPolarization finitePolarizations invariant geometricTorelli
  intro object represented
  obtain ⟨extension,degree,model,related⟩ := represented
  have smooth := modelSmooth extension object model
  exact bounded extension object degree model
    (hodgeToIsogeny object smooth ⟨data.wholeOddIso baseSmooth smooth related⟩)

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
