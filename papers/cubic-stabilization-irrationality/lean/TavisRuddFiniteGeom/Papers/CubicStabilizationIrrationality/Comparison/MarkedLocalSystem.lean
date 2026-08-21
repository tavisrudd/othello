import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedMonodromyDiagram
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.FixedPhaseReader

/-!
# Marked monodromy representations and directed selection

A monodromy representation assigns an invertible operator to every based-loop
class and carries one marked scalar row. A semilinear horizontal morphism is
natural for the whole loop group. Selecting the incoming and target loop
classes of a directed comparison produces the two-loop diagram used by the
projected-variation consumer.

Thus one horizontal naturality theorem supplies every directed comparison
drawn from the same loop representation. The construction does not identify a
geometric quantum connection with such a representation; that identification
is an external mathematical input. The representation is covariant for the
multiplication convention on `LinearEquiv`; a continuation convention with the
opposite product must use the opposite loop group. The map from endpoint path
labels to loop-group elements is also external to this module.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedLocalSystem

open MarkedMonodromyDiagram
open MonodromyImage
open ProjectedVariation
open FixedPhaseReader

universe uI uLoop uLoop' uR uk uV uW

/-- A linear monodromy representation of a based-loop group with one marked
scalar row. -/
structure Representation
    (K : Type uR) [CommRing K]
    (Loop : Type uLoop) [Group Loop]
    (V : Type uV) [AddCommGroup V] [Module K V] where
  monodromy : Loop →* (V ≃ₗ[K] V)
  row : V →ₗ[K] K

namespace Representation

variable
    {K : Type uR} [CommRing K]
    {Loop : Type uLoop} [Group Loop]
    {V : Type uV} [AddCommGroup V] [Module K V]

/-- Select two loop classes as the incoming and target monodromies of an
endpoint-indexed directed diagram. -/
def select
    (representation : Representation K Loop V)
    {Index : Type uI} (source target : Index)
    (incomingLoop targetLoop : Loop) :
    Diagram K source target V :=
  Diagram.ofOperators (representation.monodromy incomingLoop)
    (representation.monodromy targetLoop) representation.row

@[simp]
theorem select_incoming
    (representation : Representation K Loop V)
    {Index : Type uI} (source target : Index)
    (incomingLoop targetLoop : Loop) :
    (representation.select source target incomingLoop targetLoop).incoming =
      representation.monodromy incomingLoop :=
  rfl

@[simp]
theorem select_targetMonodromy
    (representation : Representation K Loop V)
    {Index : Type uI} (source target : Index)
    (incomingLoop targetLoop : Loop) :
    (representation.select source target incomingLoop targetLoop).targetMonodromy =
      representation.monodromy targetLoop :=
  rfl

end Representation

/-- A fixed assignment of endpoint indices to elements of a loop group. -/
structure LoopAssignment (Index : Type uI) (Loop : Type uLoop) where
  loop : Index → Loop

namespace LoopAssignment

/-- Build an endpoint-loop assignment from the endpoint's QDM/deck path field
and one supplied interpretation of path labels as loop-group elements. -/
def ofQdmPath
    {Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uI}
    {Loop : Type uLoop}
    (qdmPathToLoop : QdmPath → Loop) :
    LoopAssignment
      (ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction)
      Loop where
  loop index := qdmPathToLoop index.qdmPath.value

end LoopAssignment

/-- A marked semilinear horizontal morphism natural for every based-loop
class, along a homomorphism between the two loop groups. -/
structure SemilinearHorizontal
    {R : Type uR} {k : Type uk} [CommRing R] [CommRing k]
    (specialize : R →+* k)
    {Loop : Type uLoop} {Loop' : Type uLoop'} [Group Loop] [Group Loop']
    (loopMap : Loop →* Loop')
    {V : Type uV} {W : Type uW}
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module k W]
    (domain : Representation R Loop V)
    (codomain : Representation k Loop' W) where
  map : V →ₛₗ[specialize] W
  naturality : ∀ loop x,
    map (domain.monodromy loop x) = codomain.monodromy (loopMap loop) (map x)
  rowNaturality : ∀ x, codomain.row (map x) = specialize (domain.row x)

namespace SemilinearHorizontal

variable
    {R : Type uR} {k : Type uk} [CommRing R] [CommRing k]
    {specialize : R →+* k}
    {Loop : Type uLoop} {Loop' : Type uLoop'} [Group Loop] [Group Loop']
    {loopMap : Loop →* Loop'}
    {V : Type uV} {W : Type uW}
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module k W]
    {domain : Representation R Loop V}
    {codomain : Representation k Loop' W}

/-- Select two loop classes from a horizontal morphism to obtain the directed
two-loop morphism consumed by projected variation. -/
def select
    (horizontal : SemilinearHorizontal specialize loopMap domain codomain)
    {Index : Type uI} (source target : Index)
    (incomingLoop targetLoop : Loop) :
    SemilinearMorphism specialize
      (domain.select source target incomingLoop targetLoop)
      (codomain.select source target (loopMap incomingLoop) (loopMap targetLoop)) where
  map := horizontal.map
  naturality := by
    intro loop x
    cases loop with
    | incoming => exact horizontal.naturality incomingLoop x
    | target => exact horizontal.naturality targetLoop x
  rowNaturality := horizontal.rowNaturality

@[simp]
theorem select_map
    (horizontal : SemilinearHorizontal specialize loopMap domain codomain)
    {Index : Type uI} (source target : Index)
    (incomingLoop targetLoop : Loop) :
    (horizontal.select source target incomingLoop targetLoop).map = horizontal.map :=
  rfl

/-- Select the two loop classes computed from one endpoint-loop assignment.
This removes per-edge freedom to choose loop elements after the endpoints are
fixed, relative to the supplied path interpretation. -/
def selectAssigned
    (horizontal : SemilinearHorizontal specialize loopMap domain codomain)
    {Index : Type uI} (assignment : LoopAssignment Index Loop)
    (source target : Index) :
    SemilinearMorphism specialize
      (domain.select source target (assignment.loop source) (assignment.loop target))
      (codomain.select source target (loopMap (assignment.loop source))
        (loopMap (assignment.loop target))) :=
  horizontal.select source target (assignment.loop source) (assignment.loop target)

/-- Projected variation at any selected loop pair specializes by naturality of
one marked monodromy representation morphism. -/
theorem projectedVariation_specializes
    (horizontal : SemilinearHorizontal specialize loopMap domain codomain)
    {Index : Type uI} (source target : Index)
    (incomingLoop targetLoop : Loop)
    (x : LinearMap.range
      (defectOperator (domain.monodromy incomingLoop).toLinearMap)) :
    projectedVariation (codomain.monodromy (loopMap incomingLoop)).toLinearMap
        (codomain.monodromy (loopMap targetLoop)).toLinearMap codomain.row
        ((horizontal.select source target incomingLoop targetLoop).toSpecialization.incomingImageMap
          x) =
      specialize
        (projectedVariation (domain.monodromy incomingLoop).toLinearMap
          (domain.monodromy targetLoop).toLinearMap domain.row x) :=
  (horizontal.select source target incomingLoop targetLoop).projectedVariation_specializes x

/-- A normal-factor reading at any selected loop pair kills the corresponding
specialized variation when the induced incoming image spans. -/
theorem projectedVariation_eq_zero_of_normalFactor
    (horizontal : SemilinearHorizontal specialize loopMap domain codomain)
    {Index : Type uI} (source target : Index)
    (incomingLoop targetLoop : Loop)
    (imageSpans : Submodule.span k
      (Set.range
        (horizontal.select source target incomingLoop targetLoop).toSpecialization.incomingImageMap) =
      ⊤)
    (normal : R)
    (referenceRow :
      LinearMap.range (defectOperator (domain.monodromy incomingLoop).toLinearMap) →ₗ[R] R)
    (variationReading :
      projectedVariation (domain.monodromy incomingLoop).toLinearMap
          (domain.monodromy targetLoop).toLinearMap domain.row =
        normal • referenceRow)
    (normalVanishes : specialize normal = 0) :
    projectedVariation (codomain.monodromy (loopMap incomingLoop)).toLinearMap
      (codomain.monodromy (loopMap targetLoop)).toLinearMap codomain.row = 0 :=
  (horizontal.select source target incomingLoop targetLoop).toSpecialization.projectedVariation_eq_zero_of_normalFactor
    imageSpans normal referenceRow
      variationReading normalVanishes

end SemilinearHorizontal

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedLocalSystem
