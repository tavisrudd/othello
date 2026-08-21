import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.SemilinearVariation

/-!
# Endpoint-indexed marked monodromy diagrams

A directed comparison uses two named loops on one nearby-cycle module: the
incoming loop and the target loop. A marked monodromy diagram stores both
operators and the rank row under one endpoint-indexed object. A semilinear
morphism is natural for every named loop and preserves the row. Selecting the
two constructors therefore produces the semilinear specialization consumed by
directed projected variation; the two intertwining equations are consequences
of one naturality field.

The endpoint indices are mathematical parameters. Their interpretation as
geometric occurrences and fixed-phase paths remains part of the supplied
reader environment.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedMonodromyDiagram

open MonodromyImage
open ProjectedVariation
open SemilinearVariation

universe uI uR uk uV uW uV' uW'

/-- The two loop roles used by a directed projected-variation comparison.
The source and target endpoint values are retained in the type. -/
inductive DirectedLoop {Index : Type uI} (source target : Index) : Type
  | incoming
  | target

/-- A nearby-cycle module with endpoint-indexed incoming and target
monodromies and one marked scalar row. -/
structure Diagram
    (K : Type uR) [CommRing K]
    {Index : Type uI} (source target : Index)
    (V : Type uV) [AddCommGroup V] [Module K V] where
  monodromy : DirectedLoop source target → V ≃ₗ[K] V
  row : V →ₗ[K] K

namespace Diagram

variable
    {K : Type uR} [CommRing K]
    {Index : Type uI} {source target : Index}
    {V : Type uV} [AddCommGroup V] [Module K V]

/-- The incoming monodromy selected from a directed diagram. -/
def incoming (diagram : Diagram K source target V) : V ≃ₗ[K] V :=
  diagram.monodromy .incoming

/-- The target monodromy selected from a directed diagram. -/
def targetMonodromy (diagram : Diagram K source target V) : V ≃ₗ[K] V :=
  diagram.monodromy .target

/-- Construct a directed diagram from its two monodromies and marked row. -/
def ofOperators
    (incoming targetMonodromy : V ≃ₗ[K] V) (row : V →ₗ[K] K) :
    Diagram K source target V where
  monodromy
    | .incoming => incoming
    | .target => targetMonodromy
  row := row

/-- The incoming monodromy of a diagram built from named operators is the
prescribed incoming operator. -/
@[simp]
theorem ofOperators_incoming
    (incoming targetMonodromy : V ≃ₗ[K] V) (row : V →ₗ[K] K) :
    (ofOperators (source := source) (target := target)
      incoming targetMonodromy row).incoming = incoming :=
  rfl

/-- The target monodromy of a diagram built from named operators is the
prescribed target operator. -/
@[simp]
theorem ofOperators_targetMonodromy
    (incoming targetMonodromy : V ≃ₗ[K] V) (row : V →ₗ[K] K) :
    (ofOperators (source := source) (target := target)
      incoming targetMonodromy row).targetMonodromy = targetMonodromy :=
  rfl

/-- The marked row of a diagram built from named data is the prescribed row. -/
@[simp]
theorem ofOperators_row
    (incoming targetMonodromy : V ≃ₗ[K] V) (row : V →ₗ[K] K) :
    (ofOperators (source := source) (target := target)
      incoming targetMonodromy row).row = row :=
  rfl

end Diagram

/-- A marked gauge equivalence between two endpoint-indexed monodromy
diagrams. It conjugates both selected monodromies and transports the scalar
row. -/
structure DiagramEquivalence
    (K : Type uR) [CommRing K]
    {Index : Type uI} {source target : Index}
    {V : Type uV} {W : Type uW}
    [AddCommGroup V] [Module K V]
    [AddCommGroup W] [Module K W]
    (domain : Diagram K source target V)
    (codomain : Diagram K source target W) where
  map : V ≃ₗ[K] W
  naturality : ∀ loop x,
    map (domain.monodromy loop x) = codomain.monodromy loop (map x)
  rowNaturality : ∀ x, codomain.row (map x) = domain.row x

namespace DiagramEquivalence

variable
    {K : Type uR} [CommRing K]
    {Index : Type uI} {source target : Index}
    {V : Type uV} {W : Type uW}
    [AddCommGroup V] [Module K V]
    [AddCommGroup W] [Module K W]
    {domain : Diagram K source target V}
    {codomain : Diagram K source target W}

/-- Reverse a marked gauge equivalence. -/
def symm
    (equivalence : DiagramEquivalence K domain codomain) :
    DiagramEquivalence K codomain domain where
  map := equivalence.map.symm
  naturality := by
    intro loop y
    obtain ⟨x, rfl⟩ := equivalence.map.surjective y
    apply equivalence.map.injective
    simpa only [LinearEquiv.apply_symm_apply, LinearEquiv.symm_apply_apply] using
      (equivalence.naturality loop x).symm
  rowNaturality := by
    intro y
    obtain ⟨x, rfl⟩ := equivalence.map.surjective y
    rw [LinearEquiv.symm_apply_apply]
    exact (equivalence.rowNaturality x).symm

end DiagramEquivalence

/-- An equivalence of the two operator diagrams together with a one-way scalar
factor law for the marked rows. The row factor is not required to be a unit,
so this need not be an equivalence of marked rows. -/
structure OperatorDiagramEquivalenceWithRowFactor
    (K : Type uR) [CommRing K]
    {Index : Type uI} {source target : Index}
    {V : Type uV} {W : Type uW}
    [AddCommGroup V] [Module K V]
    [AddCommGroup W] [Module K W]
    (domain : Diagram K source target V)
    (codomain : Diagram K source target W) where
  map : V ≃ₗ[K] W
  naturality : ∀ loop x,
    map (domain.monodromy loop x) = codomain.monodromy loop (map x)
  rowScale : K
  rowNaturality : ∀ x, codomain.row (map x) = rowScale * domain.row x

/-- A semilinear horizontal morphism between endpoint-indexed marked
monodromy diagrams. One naturality law covers both named loops. -/
structure SemilinearMorphism
    {R : Type uR} {k : Type uk} [CommRing R] [CommRing k]
    (specialize : R →+* k)
    {Index : Type uI} {source target : Index}
    {V : Type uV} {W : Type uW}
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module k W]
    (domain : Diagram R source target V)
    (codomain : Diagram k source target W) where
  map : V →ₛₗ[specialize] W
  naturality : ∀ loop x,
    map (domain.monodromy loop x) = codomain.monodromy loop (map x)
  rowNaturality : ∀ x, codomain.row (map x) = specialize (domain.row x)

namespace SemilinearMorphism

variable
    {R : Type uR} {k : Type uk} [CommRing R] [CommRing k]
    {specialize : R →+* k}
    {Index : Type uI} {source target : Index}
    {V : Type uV} {W : Type uW}
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module k W]
    {domain : Diagram R source target V}
    {codomain : Diagram k source target W}

/-- Transport a semilinear diagram morphism through marked gauge
equivalences on its domain and codomain. -/
def transport
    {V' : Type uV'} {W' : Type uW'}
    [AddCommGroup V'] [Module R V']
    [AddCommGroup W'] [Module k W']
    {domain' : Diagram R source target V'}
    {codomain' : Diagram k source target W'}
    (domainEquivalence : DiagramEquivalence R domain domain')
    (codomainEquivalence : DiagramEquivalence k codomain codomain')
    (morphism : SemilinearMorphism specialize domain codomain) :
    SemilinearMorphism specialize domain' codomain' where
  map :=
    { toFun := fun x => codomainEquivalence.map (morphism.map (domainEquivalence.map.symm x))
      map_add' := by
        intro x y
        rw [domainEquivalence.map.symm.map_add, morphism.map.map_add,
          codomainEquivalence.map.map_add]
      map_smul' := by
        intro c x
        rw [domainEquivalence.map.symm.map_smul, morphism.map.map_smulₛₗ,
          codomainEquivalence.map.map_smul] }
  naturality := by
    intro loop x
    have domainNaturality :
        domainEquivalence.map.symm (domain'.monodromy loop x) =
          domain.monodromy loop (domainEquivalence.map.symm x) := by
      apply domainEquivalence.map.injective
      simpa only [LinearEquiv.apply_symm_apply] using
        (domainEquivalence.naturality loop (domainEquivalence.map.symm x)).symm
    change codomainEquivalence.map
        (morphism.map (domainEquivalence.map.symm (domain'.monodromy loop x))) =
      codomain'.monodromy loop
        (codomainEquivalence.map (morphism.map (domainEquivalence.map.symm x)))
    rw [domainNaturality, morphism.naturality, codomainEquivalence.naturality]
  rowNaturality := by
    intro x
    change codomain'.row
        (codomainEquivalence.map (morphism.map (domainEquivalence.map.symm x))) =
      specialize (domain'.row x)
    rw [codomainEquivalence.rowNaturality, morphism.rowNaturality]
    have rowNaturality :=
      domainEquivalence.rowNaturality (domainEquivalence.map.symm x)
    rw [LinearEquiv.apply_symm_apply] at rowNaturality
    exact congrArg specialize rowNaturality.symm

/-- Transported semilinear comparison evaluates by applying the inverse
domain gauge, the original comparison, and then the codomain gauge. -/
@[simp]
theorem transport_map_apply
    {V' : Type uV'} {W' : Type uW'}
    [AddCommGroup V'] [Module R V']
    [AddCommGroup W'] [Module k W']
    {domain' : Diagram R source target V'}
    {codomain' : Diagram k source target W'}
    (domainEquivalence : DiagramEquivalence R domain domain')
    (codomainEquivalence : DiagramEquivalence k codomain codomain')
    (morphism : SemilinearMorphism specialize domain codomain)
    (x : V') :
    (morphism.transport domainEquivalence codomainEquivalence).map x =
      codomainEquivalence.map (morphism.map (domainEquivalence.map.symm x)) :=
  rfl

/-- Surjectivity of the underlying semilinear map is invariant under marked
gauge transport. -/
theorem transport_map_surjective
    {V' : Type uV'} {W' : Type uW'}
    [AddCommGroup V'] [Module R V']
    [AddCommGroup W'] [Module k W']
    {domain' : Diagram R source target V'}
    {codomain' : Diagram k source target W'}
    (domainEquivalence : DiagramEquivalence R domain domain')
    (codomainEquivalence : DiagramEquivalence k codomain codomain')
    (morphism : SemilinearMorphism specialize domain codomain)
    (surjective : Function.Surjective morphism.map) :
    Function.Surjective (morphism.transport domainEquivalence codomainEquivalence).map := by
  intro y
  obtain ⟨x, hx⟩ := surjective (codomainEquivalence.map.symm y)
  refine ⟨domainEquivalence.map x, ?_⟩
  simp only [transport_map_apply, LinearEquiv.symm_apply_apply, hx,
    LinearEquiv.apply_symm_apply]

/-- Forget the diagram packaging and expose the specialization of the two
selected monodromies and the marked row. -/
def toSpecialization
    (morphism : SemilinearMorphism specialize domain codomain) :
    Specialization specialize
      domain.incoming.toLinearMap domain.targetMonodromy.toLinearMap
      codomain.incoming.toLinearMap codomain.targetMonodromy.toLinearMap
      domain.row codomain.row where
  map := morphism.map
  incomingCommutes := morphism.naturality .incoming
  targetCommutes := morphism.naturality .target
  rowSpecializes := morphism.rowNaturality

/-- Forgetting the diagram packaging preserves the underlying semilinear map. -/
@[simp]
theorem toSpecialization_map
    (morphism : SemilinearMorphism specialize domain codomain) :
    morphism.toSpecialization.map = morphism.map :=
  rfl

/-- Directed projected variation is natural under one marked morphism of the
two-loop diagram. -/
theorem projectedVariation_specializes
    (morphism : SemilinearMorphism specialize domain codomain)
    (x : LinearMap.range (defectOperator domain.incoming.toLinearMap)) :
    projectedVariation codomain.incoming.toLinearMap
        codomain.targetMonodromy.toLinearMap codomain.row
        (morphism.toSpecialization.incomingImageMap x) =
      specialize
        (projectedVariation domain.incoming.toLinearMap
          domain.targetMonodromy.toLinearMap domain.row x) :=
  morphism.toSpecialization.projectedVariation_specializes x

end SemilinearMorphism

/-- A semilinear morphism of marked diagrams whose scalar row is preserved up
to one target-ring factor. -/
structure ScaledSemilinearMorphism
    {R : Type uR} {k : Type uk} [CommRing R] [CommRing k]
    (specialize : R →+* k)
    {Index : Type uI} {source target : Index}
    {V : Type uV} {W : Type uW}
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module k W]
    (domain : Diagram R source target V)
    (codomain : Diagram k source target W) where
  map : V →ₛₗ[specialize] W
  naturality : ∀ loop x,
    map (domain.monodromy loop x) = codomain.monodromy loop (map x)
  rowScale : k
  rowNaturality : ∀ x,
    codomain.row (map x) = rowScale * specialize (domain.row x)

namespace ScaledSemilinearMorphism

variable
    {R : Type uR} {k : Type uk} [CommRing R] [CommRing k]
    {specialize : R →+* k}
    {Index : Type uI} {source target : Index}
    {V : Type uV} {W : Type uW}
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module k W]
    {domain : Diagram R source target V}
    {codomain : Diagram k source target W}

/-- Transport an exactly row-preserving semilinear morphism through two
row-scaled gauges. The residual row scale is specified by the compatibility
equation between the two gauge scales; no scalar is inverted. -/
def transportRowScaled
    {V' : Type uV'} {W' : Type uW'}
    [AddCommGroup V'] [Module R V']
    [AddCommGroup W'] [Module k W']
    {domain' : Diagram R source target V'}
    {codomain' : Diagram k source target W'}
    (domainEquivalence : OperatorDiagramEquivalenceWithRowFactor R domain domain')
    (codomainEquivalence : OperatorDiagramEquivalenceWithRowFactor k codomain codomain')
    (morphism : SemilinearMorphism specialize domain codomain)
    (rowScale : k)
    (scaleCompatibility :
      codomainEquivalence.rowScale = rowScale * specialize domainEquivalence.rowScale) :
    ScaledSemilinearMorphism specialize domain' codomain' where
  map :=
    { toFun := fun x => codomainEquivalence.map (morphism.map (domainEquivalence.map.symm x))
      map_add' := by
        intro x y
        rw [domainEquivalence.map.symm.map_add, morphism.map.map_add,
          codomainEquivalence.map.map_add]
      map_smul' := by
        intro c x
        rw [domainEquivalence.map.symm.map_smul, morphism.map.map_smulₛₗ,
          codomainEquivalence.map.map_smul] }
  naturality := by
    intro loop x
    have domainNaturality :
        domainEquivalence.map.symm (domain'.monodromy loop x) =
          domain.monodromy loop (domainEquivalence.map.symm x) := by
      apply domainEquivalence.map.injective
      simpa only [LinearEquiv.apply_symm_apply] using
        (domainEquivalence.naturality loop (domainEquivalence.map.symm x)).symm
    change codomainEquivalence.map
        (morphism.map (domainEquivalence.map.symm (domain'.monodromy loop x))) =
      codomain'.monodromy loop
        (codomainEquivalence.map (morphism.map (domainEquivalence.map.symm x)))
    rw [domainNaturality, morphism.naturality, codomainEquivalence.naturality]
  rowScale := rowScale
  rowNaturality := by
    intro x
    change codomain'.row
        (codomainEquivalence.map (morphism.map (domainEquivalence.map.symm x))) =
      rowScale * specialize (domain'.row x)
    rw [codomainEquivalence.rowNaturality, morphism.rowNaturality]
    have domainRow := domainEquivalence.rowNaturality (domainEquivalence.map.symm x)
    rw [LinearEquiv.apply_symm_apply] at domainRow
    rw [scaleCompatibility, domainRow, map_mul]
    exact mul_assoc _ _ _

/-- Row-scaled transport has the same pointwise precomparison/postcomparison
formula as exact-row transport. -/
@[simp]
theorem transportRowScaled_map_apply
    {V' : Type uV'} {W' : Type uW'}
    [AddCommGroup V'] [Module R V']
    [AddCommGroup W'] [Module k W']
    {domain' : Diagram R source target V'}
    {codomain' : Diagram k source target W'}
    (domainEquivalence : OperatorDiagramEquivalenceWithRowFactor R domain domain')
    (codomainEquivalence : OperatorDiagramEquivalenceWithRowFactor k codomain codomain')
    (morphism : SemilinearMorphism specialize domain codomain)
    (rowScale : k)
    (scaleCompatibility :
      codomainEquivalence.rowScale = rowScale * specialize domainEquivalence.rowScale)
    (x : V') :
    (transportRowScaled domainEquivalence codomainEquivalence morphism rowScale
      scaleCompatibility).map x =
      codomainEquivalence.map (morphism.map (domainEquivalence.map.symm x)) :=
  rfl

/-- Surjectivity of the selected horizontal map survives row-scaled gauge
transport. -/
theorem transportRowScaled_map_surjective
    {V' : Type uV'} {W' : Type uW'}
    [AddCommGroup V'] [Module R V']
    [AddCommGroup W'] [Module k W']
    {domain' : Diagram R source target V'}
    {codomain' : Diagram k source target W'}
    (domainEquivalence : OperatorDiagramEquivalenceWithRowFactor R domain domain')
    (codomainEquivalence : OperatorDiagramEquivalenceWithRowFactor k codomain codomain')
    (morphism : SemilinearMorphism specialize domain codomain)
    (rowScale : k)
    (scaleCompatibility :
      codomainEquivalence.rowScale = rowScale * specialize domainEquivalence.rowScale)
    (surjective : Function.Surjective morphism.map) :
    Function.Surjective
      (transportRowScaled domainEquivalence codomainEquivalence morphism rowScale
        scaleCompatibility).map := by
  intro y
  obtain ⟨x, hx⟩ := surjective (codomainEquivalence.map.symm y)
  refine ⟨domainEquivalence.map x, ?_⟩
  simp only [transportRowScaled_map_apply, LinearEquiv.symm_apply_apply, hx,
    LinearEquiv.apply_symm_apply]

/-- Expose the scaled semilinear specialization of the two selected
monodromies and row. -/
def toScaledSpecialization
    (morphism : ScaledSemilinearMorphism specialize domain codomain) :
    ScaledSpecialization specialize
      domain.incoming.toLinearMap domain.targetMonodromy.toLinearMap
      codomain.incoming.toLinearMap codomain.targetMonodromy.toLinearMap
      domain.row codomain.row where
  map := morphism.map
  incomingCommutes := morphism.naturality .incoming
  targetCommutes := morphism.naturality .target
  rowScale := morphism.rowScale
  rowSpecializes := morphism.rowNaturality

end ScaledSemilinearMorphism

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedMonodromyDiagram
