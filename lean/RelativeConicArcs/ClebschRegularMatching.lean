import Mathlib.Tactic

/-!
# Matchings invariant under a regular group action

Let a group `K` act on itself by left multiplication.  A partner map
`m : K → K` is equivariant for this action precisely when it is right
multiplication by `m 1`.  Such a map is an involution exactly when this
distinguished element squares to the identity, and it has no fixed point
exactly when the element is not the identity.  Thus the invariant perfect
matchings are parametrized by the nonidentity involutions of `K`.
-/

namespace RelativeConicArcs.ClebschRegularMatching

variable {K : Type*} [Group K]

/-- A map from a group to itself is left-regular equivariant when it commutes
with every left multiplication. -/
def LeftRegularEquivariant (m : K → K) : Prop :=
  ∀ g x, m (g * x) = g * m x

/-- Right multiplication by `c`, regarded as a self-map of the group. -/
def rightMultiplication (c : K) : K → K :=
  fun x ↦ x * c

/-- A self-map has no fixed point when it moves every element of its domain. -/
def FixedPointFree (m : K → K) : Prop :=
  ∀ x, m x ≠ x

/-- A perfect matching on a set is represented by a fixed-point-free
involutive partner map. -/
def IsPerfectMatching (m : K → K) : Prop :=
  Function.Involutive m ∧ FixedPointFree m

/-- A left-regular equivariant map is right multiplication by its value at
the identity, and every such right multiplication is equivariant. -/
theorem leftRegularEquivariant_iff_eq_rightMultiplication (m : K → K) :
    LeftRegularEquivariant m ↔ m = rightMultiplication (m 1) := by
  constructor
  · intro hm
    funext x
    simpa [rightMultiplication] using hm x 1
  · intro hm g x
    calc
      m (g * x) = (g * x) * m 1 := by
        simpa [rightMultiplication] using congrFun hm (g * x)
      _ = g * (x * m 1) := mul_assoc g x (m 1)
      _ = g * m x := by
        have hx : m x = x * m 1 := by
          simpa [rightMultiplication] using congrFun hm x
        exact congrArg (fun y ↦ g * y) hx.symm

/-- Right multiplication by `c` is involutive exactly when `c` squares to
the identity. -/
theorem rightMultiplication_involutive_iff (c : K) :
    Function.Involutive (rightMultiplication c) ↔ c * c = 1 := by
  constructor
  · intro hc
    simpa [rightMultiplication] using hc 1
  · intro hc x
    simp [rightMultiplication, mul_assoc, hc]

/-- Right multiplication by `c` is fixed-point-free exactly when `c` is not
the identity. -/
theorem rightMultiplication_fixedPointFree_iff (c : K) :
    FixedPointFree (rightMultiplication c) ↔ c ≠ 1 := by
  constructor
  · intro hfree hc
    apply hfree 1
    simp [rightMultiplication, hc]
  · intro hc x hfixed
    apply hc
    have hcancel := congrArg (fun y ↦ x⁻¹ * y) hfixed
    simpa [rightMultiplication, mul_assoc] using hcancel

/-- A left-regular equivariant map is a perfect matching exactly when it is
right multiplication by a nonidentity involution.  The preceding
equivariance theorem identifies the witnessing element with `m 1`. -/
theorem leftRegularEquivariant_perfectMatching_iff (m : K → K) :
    LeftRegularEquivariant m ∧ IsPerfectMatching m ↔
      ∃ c : K, m = rightMultiplication c ∧ c * c = 1 ∧ c ≠ 1 := by
  constructor
  · rintro ⟨hequiv, hinvolutive, hfree⟩
    have hm := (leftRegularEquivariant_iff_eq_rightMultiplication m).mp hequiv
    let c := m 1
    have hm' : m = rightMultiplication c := by simpa [c] using hm
    refine ⟨c, hm', ?_, ?_⟩
    · have hinvolutive' : Function.Involutive (rightMultiplication c) :=
        hm' ▸ hinvolutive
      exact (rightMultiplication_involutive_iff c).mp hinvolutive'
    · have hfree' : FixedPointFree (rightMultiplication c) := hm' ▸ hfree
      exact (rightMultiplication_fixedPointFree_iff c).mp hfree'
  · rintro ⟨c, rfl, hsquare, hne⟩
    refine ⟨?_, ?_, ?_⟩
    · intro g x
      simp [rightMultiplication, mul_assoc]
    · exact (rightMultiplication_involutive_iff c).mpr hsquare
    · exact (rightMultiplication_fixedPointFree_iff c).mpr hne

end RelativeConicArcs.ClebschRegularMatching
