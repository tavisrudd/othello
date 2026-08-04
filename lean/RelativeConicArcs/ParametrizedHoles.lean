import RelativeConicArcs.ProjectiveBridge

/-!
# Cap positions parametrized by a finite point set

Work in the coordinate projective plane `PG(2, K)` over a finite field `K`, with points
`RelativeConicArcs.ProjectiveBridge.Point K = Projectivization K (Fin 3 → K)`.

Given a fixed finite set of points `A` and an injective parametrization `e : I ↪ Point K` of a
further finite set of points by an index type `I`, `ParametrizedHoleValid A e` is the induced
validity predicate on `Finset I`: a parameter position `T` is valid exactly when `A` together
with the points `T` names is a projective cap.  It is the predicate used to state a cap problem
in the coordinates of the points that remain available rather than in the whole plane.

The predicate mentions no game, and this file states nothing else; it extends the namespace of
`RelativeConicArcs.ProjectiveBridge`, whose incidence content it does not use beyond the point
type.  The normal-play cap game played on this predicate, and its exact agreement with the plane
game started from a relatively complete seed whose uncovered points are the range of `e`, are in
`RelativeConicArcs.CapGameHoleLocalization`.
-/

namespace RelativeConicArcs
namespace ProjectiveBridge

variable {K : Type*} [Field K] [DecidableEq K]

noncomputable section HoleParametrization

variable [Fintype K]

local instance : Fintype (Point K) := Fintype.ofFinite (Point K)
local instance : DecidableEq (Point K) := Classical.decEq (Point K)

variable {I : Type*} [Fintype I] [DecidableEq I]

/-- Validity of a hole-parameter position after adjoining it to a fixed projective seed. -/
noncomputable def ParametrizedHoleValid (A : Finset (Point K))
    (e : I ↪ Point K) (T : Finset I) : Prop :=
  ProjectiveCap.Projective.Cap K (Fin 3 → K) (A ∪ T.map e)

end HoleParametrization

end ProjectiveBridge
end RelativeConicArcs
