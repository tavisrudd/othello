import Mathlib.LinearAlgebra.Dimension.Finite

/-!
# The nested code pair associated with a target set

Let `target : A →ₗ[𝔽] V` and `helper : H →ₗ[𝔽] V` be the target and helper
parts of a generator map. The target-message space is `range target`. The
recoverable target-message space is its intersection with `range helper`.
The helper vectors mapping into the target-message space form a submodule
containing `ker helper`; restriction of `helper` maps this submodule onto the
recoverable target-message space.

These statements are the exact-sequence part of the recovery construction.
They make no finiteness, coding-distance, or concatenation assumption.
-/

namespace TavisRuddFiniteGeom.Papers.RecoveryStructures

noncomputable section

variable {𝔽 A H V : Type*}
variable [Field 𝔽]
variable [AddCommGroup A] [Module 𝔽 A]
variable [AddCommGroup H] [Module 𝔽 H]
variable [AddCommGroup V] [Module 𝔽 V]

/-- The subspace of messages represented by the target coordinates. -/
def targetMessageSpace (target : A →ₗ[𝔽] V) : Submodule 𝔽 V :=
  LinearMap.range target

/-- The target messages that can also be represented using helpers. -/
def recoverableTargetMessageSpace
    (target : A →ₗ[𝔽] V) (helper : H →ₗ[𝔽] V) : Submodule 𝔽 V :=
  targetMessageSpace target ⊓ LinearMap.range helper

/-- Helper coefficient vectors whose image is a target message. -/
def helperCodeForTargetSpace
    (target : A →ₗ[𝔽] V) (helper : H →ₗ[𝔽] V) : Submodule 𝔽 H :=
  (targetMessageSpace target).comap helper

/-- Helper relations are contained in the helper code for every target space. -/
theorem helper_ker_le_helperCodeForTargetSpace
    (target : A →ₗ[𝔽] V) (helper : H →ₗ[𝔽] V) :
    LinearMap.ker helper ≤ helperCodeForTargetSpace target helper := by
  intro h hh
  change helper h ∈ targetMessageSpace target
  rw [LinearMap.mem_ker.mp hh]
  exact Submodule.zero_mem _

/-- The helper image of the associated helper code is exactly the recoverable
target-message space. -/
theorem map_helperCodeForTargetSpace_eq_recoverableTargetMessageSpace
    (target : A →ₗ[𝔽] V) (helper : H →ₗ[𝔽] V) :
    (helperCodeForTargetSpace target helper).map helper =
      recoverableTargetMessageSpace target helper := by
  ext v
  constructor
  · rintro ⟨h, hh, rfl⟩
    exact ⟨hh, ⟨h, rfl⟩⟩
  · rintro ⟨hvTarget, h, rfl⟩
    exact ⟨h, hvTarget, rfl⟩

/-- The restriction of the helper map to helper vectors representing target
messages, with codomain restricted to recoverable target messages. -/
def recoverableTargetMap
    (target : A →ₗ[𝔽] V) (helper : H →ₗ[𝔽] V) :
    helperCodeForTargetSpace target helper →ₗ[𝔽]
      recoverableTargetMessageSpace target helper where
  toFun h := ⟨helper h.1, h.2, ⟨h.1, rfl⟩⟩
  map_add' x y := by ext; exact helper.map_add x.1 y.1
  map_smul' c x := by ext; exact helper.map_smul c x.1

/-- Every recoverable target message has a helper representative. -/
theorem recoverableTargetMap_surjective
    (target : A →ₗ[𝔽] V) (helper : H →ₗ[𝔽] V) :
    Function.Surjective (recoverableTargetMap target helper) := by
  intro v
  obtain ⟨h, hh⟩ := v.2.2
  refine ⟨⟨h, ?_⟩, ?_⟩
  · change helper h ∈ targetMessageSpace target
    rw [hh]
    exact v.2.1
  · apply Subtype.ext
    exact hh

/-- The kernel of the restricted helper map consists exactly of helper
relations, viewed inside the associated helper code. -/
theorem mem_ker_recoverableTargetMap_iff
    (target : A →ₗ[𝔽] V) (helper : H →ₗ[𝔽] V)
    (h : helperCodeForTargetSpace target helper) :
    h ∈ LinearMap.ker (recoverableTargetMap target helper) ↔
      h.1 ∈ LinearMap.ker helper := by
  simp only [LinearMap.mem_ker]
  constructor
  · intro hh
    exact congrArg Subtype.val hh
  · intro hh
    apply Subtype.ext
    exact hh

end

end TavisRuddFiniteGeom.Papers.RecoveryStructures
