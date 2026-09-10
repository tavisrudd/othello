import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RationalWholeHodgeConservation
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.BoundedIsogenyFiniteness

/-!
# Reconstruction and arithmetic finiteness from rational Hodge conservation

Endpoint realization specifies actual pure weight-three rational Hodge
projectors, a finite family of rational Hodge morphisms for each pair, and
realization of each whole conserved comparison in their complex span. The
rational Hodge isomorphism is constructed by descent; it is not a field of
the realization data. Source-restricted Torelli and the cohomology-to-isogeny
hypothesis therefore receive actual rational Hodge isomorphisms.

The geometric realization and scalar-extension fullness, the source Torelli
statement, the isogeny implication and uniform kernel bound, finite torsion,
polarization finiteness and geometric Torelli remain separate inputs. The
arithmetic result counts geometric classes over all model extensions of the
specified bounded degree, with no restriction on the isogeny's field of
definition and no claim about twists or effective numerical bounds.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

universe u v

/-- Whole endpoint realization into rational Hodge matrices. Fullness is
required only for the whole comparison, not for separately labelled branches. -/
structure RationalHodgeEndpointRealization
    {K Variety Center Occurrence Family : Type*} [Field K] [CharZero K]
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (data : StabilizedWholeOddData K Variety Center Occurrence Family ι division)
    (rank : ℕ) (Index : Type*) [Fintype Index] where
  hodge : Family → RationalWeightThreeHodgeMatrices rank
  morphisms : Family → Family → Index → Matrix (Fin rank) (Fin rank) ℚ
  members : ∀ left right i, morphisms left right i ∈ rationalHodgeMorphismSubspace (hodge left) (hodge right)
  complexComparison : ∀ {left right}, CategoryTheory.Iso (data.wholeOdd left) (data.wholeOdd right) →
    (Matrix (Fin rank) (Fin rank) ℂ)ˣ
  scalarExtensionFull : ∀ {left right}
    (comparison : CategoryTheory.Iso (data.wholeOdd left) (data.wholeOdd right)), ∃ coefficient : Index → ℂ,
    ∑ i, coefficient i • (morphisms left right i).map (algebraMap ℚ ℂ)=
      (complexComparison (left := left) (right := right) comparison : Matrix (Fin rank) (Fin rank) ℂ)

/-- An actual rational Hodge isomorphism of the whole endpoint objects is
derived from stabilized birationality and the specified whole realization. -/
noncomputable def RationalHodgeEndpointRealization.conservedIso
    {K Variety Center Occurrence Family : Type*} [Field K] [CharZero K]
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    {data : StabilizedWholeOddData K Variety Center Occurrence Family ι division}
    {rank : ℕ} {Index : Type*} [Fintype Index]
    (realization : RationalHodgeEndpointRealization data rank Index)
    {left right : Family} (leftSmooth : data.smooth left) (rightSmooth : data.smooth right)
    (related : data.birational.r (data.stabilized left) (data.stabilized right)) :
    RationalWeightThreeHodgeMatrixIso (realization.hodge left) (realization.hodge right) :=
  rationalWholeHodgeIso_of_stabilizedBirationality data leftSmooth rightSmooth related
    (realization.hodge left) (realization.hodge right) (realization.morphisms left right)
    (realization.members left right) (realization.complexComparison (left := left) (right := right))
    (realization.scalarExtensionFull (left := left) (right := right))

/-- Reconstruction for a very general source and arbitrary smooth target,
using an actual rational Hodge isomorphism as the Torelli premise. -/
theorem RationalHodgeEndpointRealization.genericCancellation
    {K Variety Center Occurrence Family : Type*} [Field K] [CharZero K]
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    {data : StabilizedWholeOddData K Variety Center Occurrence Family ι division}
    {rank : ℕ} {Index : Type*} [Fintype Index]
    (realization : RationalHodgeEndpointRealization data rank Index)
    (veryGeneral : Family → Prop) (geometricIso : Family → Family → Prop)
    (sourceTorelli : ∀ left right, data.smooth left → data.smooth right → veryGeneral left →
      Nonempty (RationalWeightThreeHodgeMatrixIso (realization.hodge left) (realization.hodge right)) →
      geometricIso left right)
    {left right : Family} (leftSmooth : data.smooth left) (rightSmooth : data.smooth right)
    (generalSource : veryGeneral left)
    (related : data.birational.r (data.stabilized left) (data.stabilized right)) :
    geometricIso left right :=
  sourceTorelli left right leftSmooth rightSmooth generalSource
    ⟨realization.conservedIso leftSmooth rightSmooth related⟩

/-- Bounded-degree arithmetic partner finiteness with an actual rational
Hodge-isomorphism premise for geometric isogeny existence. All eligible model
extensions are included in the same finite set of geometric classes. -/
theorem RationalHodgeEndpointRealization.finiteArithmeticPartners
    {K Variety Center Occurrence Family Extension A Unpolarized Polarized : Type*}
    [Field K] [CharZero K] [AddCommGroup A]
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    {data : StabilizedWholeOddData K Variety Center Occurrence Family ι division}
    {rank : ℕ} {Index : Type*} [Fintype Index]
    (realization : RationalHodgeEndpointRealization data rank Index)
    (base : Family) (baseSmooth : data.smooth base)
    (extensionDegree : Extension → ℕ) (degreeBound : ℕ)
    (hasModel : Extension → Family → Prop)
    (modelSmooth : ∀ extension object, hasModel extension object → data.smooth object)
    (geometricallyIsogenous : Family → Prop)
    (hodgeToIsogeny : ∀ object, data.smooth object →
      Nonempty (RationalWeightThreeHodgeMatrixIso (realization.hodge base) (realization.hodge object)) →
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
    (hodgeToIsogeny object smooth ⟨realization.conservedIso baseSmooth smooth related⟩)

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
