import Mathlib.Tactic

/-!
# A point-stabilizer criterion for invariant matchings

Let a selected family of transformations act on a set of endpoints.  Suppose that,
for every endpoint `x`, the only point other than `x` fixed by every
transformation stabilizing `x` is a prescribed partner `mate x`.  Then every
fixed-point-free partner map equivariant for all the transformations equals
`mate`.

No group structure, transitivity, or finiteness is required for the argument.
Those features enter only when the point-stabilizer condition is verified in
a concrete permutation action.
-/

namespace RelativeConicArcs.ClebschInvariantMatchingCriterion

variable {G Ω S : Type*}

/-- Each point stabilizer in `transformations` forces the displayed nontrivial
partner of that point. -/
def PointStabilizersForcePartner (transform : S → G)
    (act : G → Ω → Ω) (mate : Ω → Ω) : Prop :=
  ∀ x y, y ≠ x →
    (∀ s : S, act (transform s) x = x → act (transform s) y = y) →
    y = mate x

/-- A fixed-point-free map equivariant for the selected transformations is
the partner map forced by their point stabilizers. -/
theorem equivariant_fixedPointFree_eq_of_pointStabilizersForcePartner
    {transform : S → G} {act : G → Ω → Ω} {mate m : Ω → Ω}
    (hforce : PointStabilizersForcePartner transform act mate)
    (hfree : ∀ x, m x ≠ x)
    (hequivariant : ∀ s : S, ∀ x,
      act (transform s) (m x) = m (act (transform s) x)) :
    m = mate := by
  funext x
  apply hforce x (m x) (hfree x)
  intro s hfix
  rw [hequivariant s x, hfix]

end RelativeConicArcs.ClebschInvariantMatchingCriterion
