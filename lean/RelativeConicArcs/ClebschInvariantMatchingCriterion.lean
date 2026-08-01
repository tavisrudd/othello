import Mathlib.Tactic

/-!
# A point-stabilizer criterion for invariant matchings

Let a finite set of transformations act on a set of endpoints.  Suppose that,
for every endpoint `x`, the only point other than `x` fixed by every
transformation stabilizing `x` is a prescribed partner `mate x`.  Then every
fixed-point-free partner map equivariant for all the transformations equals
`mate`.

No group structure, transitivity, or finiteness is required for the argument.
Those features enter only when the point-stabilizer condition is verified in
a concrete permutation action.
-/

namespace RelativeConicArcs.ClebschInvariantMatchingCriterion

variable {G Ω : Type*}

/-- Each point stabilizer in `transformations` forces the displayed nontrivial
partner of that point. -/
def PointStabilizersForcePartner (transformations : Set G)
    (act : G → Ω → Ω) (mate : Ω → Ω) : Prop :=
  ∀ x y, y ≠ x →
    (∀ g ∈ transformations, act g x = x → act g y = y) →
    y = mate x

/-- A fixed-point-free map equivariant for the selected transformations is
the partner map forced by their point stabilizers. -/
theorem equivariant_fixedPointFree_eq_of_pointStabilizersForcePartner
    {transformations : Set G} {act : G → Ω → Ω} {mate m : Ω → Ω}
    (hforce : PointStabilizersForcePartner transformations act mate)
    (hfree : ∀ x, m x ≠ x)
    (hequivariant : ∀ g ∈ transformations, ∀ x, act g (m x) = m (act g x)) :
    m = mate := by
  funext x
  apply hforce x (m x) (hfree x)
  intro g hg hfix
  rw [hequivariant g hg x, hfix]

end RelativeConicArcs.ClebschInvariantMatchingCriterion
