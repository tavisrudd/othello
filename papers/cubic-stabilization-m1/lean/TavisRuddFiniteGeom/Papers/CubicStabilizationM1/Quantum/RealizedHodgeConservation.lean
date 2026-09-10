import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.StabilizedWholeOddConservation
import Mathlib.CategoryTheory.Equivalence

/-!
# Transport of conservation to a realized semisimple category

An explicit equivalence from the semisimple coordinate category to a target
category transports the proved whole-odd-object isomorphism to the target
objects. To apply this to polarizable rational Hodge structures, the target
category, its equivalence with the coordinate model, and the identifications
of the realized endpoint objects with whole rational third cohomology are
supplied. The conclusion is an actual isomorphism between those target
objects; integral lattices and polarizations are not part of this interface.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

universe u v w

/-- The conserved whole odd objects give an actual isomorphism of endpoint
objects in any supplied equivalent semisimple category. For a rational Hodge
realization the endpoints are the full third-cohomology objects. -/
noncomputable def StabilizedWholeOddData.realizedWholeOddIso
    {K Variety Center Occurrence Family : Type*} [Field K] [CharZero K]
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (data : StabilizedWholeOddData K Variety Center Occurrence Family ι division)
    {Hodge : Type w} [CategoryTheory.Category Hodge]
    (realization : CategoryTheory.Equivalence (SemisimpleCoordinateObject ι division) Hodge)
    {left right : Family} (leftSmooth : data.smooth left) (rightSmooth : data.smooth right)
    (related : data.birational.r (data.stabilized left) (data.stabilized right))
    (leftHodge rightHodge : Hodge)
    (leftIdentification : CategoryTheory.Iso (realization.functor.obj (data.wholeOdd left)) leftHodge)
    (rightIdentification : CategoryTheory.Iso (realization.functor.obj (data.wholeOdd right)) rightHodge) :
    CategoryTheory.Iso leftHodge rightHodge :=
  leftIdentification.symm.trans
    ((realization.functor.mapIso (data.wholeOddIso leftSmooth rightSmooth related)).trans rightIdentification)

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
