import RelativeConicArcs.PassantCodeQ13.Geometry

/-!
# Rank semantics for the q=13 passant incidence code

The incidence map sends a binary word on the 78 internal points to its 78 passant-row parities.
This module isolates the exact finite leaf needed for the dimension theorem: the range of that map
has dimension 42.  The theorem below proves, without further computation, that any proof of this
rank statement gives code dimension 36.

No rank value is assumed or asserted in this module.  A finite certificate package may establish
`IncidenceMapHasRankFortyTwo` by checking row operations against the concrete incidence relation.
-/

namespace RelativeConicArcs.PassantCodeQ13

/-- The concrete binary passant-incidence linear map. -/
def incidenceMap :
    (InternalPoint → ZMod 2) →ₗ[ZMod 2] (PassantLine → ZMod 2) :=
  CodingBridge.parityCheckMap (ConicPassantCode.incidenceColumn Incident)

/-- The exact rank statement required from a q=13 incidence-matrix certificate. -/
def IncidenceMapHasRankFortyTwo : Prop :=
  Module.finrank (ZMod 2) (LinearMap.range incidenceMap) = 42

/-- Rank 42 of the incidence map implies dimension 36 of its binary kernel. -/
theorem passantCode_finrank_eq_thirtySix
    (rankCertificate : IncidenceMapHasRankFortyTwo) :
    Module.finrank (ZMod 2) passantCode = 36 := by
  have rankNullity := incidenceMap.finrank_range_add_finrank_ker
  have domainDimension :
      Module.finrank (ZMod 2) (InternalPoint → ZMod 2) = 78 := by
    rw [Module.finrank_pi, internalPoint_card]
  rw [rankCertificate, domainDimension] at rankNullity
  change Module.finrank (ZMod 2) (LinearMap.ker incidenceMap) = 36
  omega

end RelativeConicArcs.PassantCodeQ13
