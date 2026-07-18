import RelativeConicArcs.Q25ResidualComposition
import Mathlib.GroupTheory.GroupAction.Quotient
import Mathlib.Algebra.Group.Action.Pointwise.Finset
import Mathlib.Data.Set.Card

/-!
# The residual parameter group and its orbit–stabilizer bridge

`Q25ResidualComposition` proves the composition law for the recovered-parameter multiplication.
This module completes it to a `Group` on `AdmissibleCoordinate`, transports the group to the
`400`-element parameter pair, and installs the `MulAction` on `Idx25` and — through Mathlib's
pointwise instance — on `Finset Idx25`.

The point of the whole construction is `card_residualOrbit_mul_card_residualStabilizer`: an orbit
cardinality is obtained from a *stabilizer* cardinality by arithmetic, so no orbit is ever
materialized.  Deduplicating a `400`-element multiset of eight-point `Finset`s is quadratic
membership testing and blocks the kernel; a stabilizer is one `Finset.filter` over `400`
parameters.

Group axioms are decided on the `25`-element coordinate type rather than on the `400`-element
product: associativity is `15,625` cases here against `6.4 · 10⁷` there.
-/

namespace RelativeConicArcs
namespace Q25ResidualGroup

open Q25Coordinates Q25Normalization Q25ResidualAction Q25ResidualFast Q25ResidualComposition
open scoped Pointwise

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- The inverse parameter is the image of `omega` under the map itself: `φ g` sends `g` to
`omega`, so the parameter of `(φ g)⁻¹` is `φ g omega`. -/
def invCoord (g : K25) : K25 := shiftFast g + scaleFast g * omega

theorem imagPart_invCoord (g : K25) (hg : imagPart g ≠ 0) : imagPart (invCoord g) ≠ 0 := by
  revert g
  decide

theorem invCoord_mulCoord (g : K25) (hg : imagPart g ≠ 0) :
    mulCoord (invCoord g) g = omega := by
  revert g
  decide

instance : One AdmissibleCoordinate := ⟨⟨omega, by decide⟩⟩

instance : Inv AdmissibleCoordinate := ⟨fun g => ⟨invCoord g.1, imagPart_invCoord g.1 g.2⟩⟩

@[simp] theorem val_one : (1 : AdmissibleCoordinate).1 = omega := rfl

@[simp] theorem val_inv (g : AdmissibleCoordinate) : (g⁻¹).1 = invCoord g.1 := rfl

instance : Group AdmissibleCoordinate where
  mul_assoc a b c := Subtype.ext (mulCoord_assoc a.1 b.1 c.1)
  one_mul a := Subtype.ext (omega_mulCoord a.1)
  mul_one a := Subtype.ext (mulCoord_omega a.1)
  inv_mul_cancel a := Subtype.ext (invCoord_mulCoord a.1 a.2)

/-- `ResidualParameter` inherits the product group; the action is the fast evaluator. -/
instance : SMul ResidualParameter Idx25 := ⟨fun g i => residualApplyFast g.1.1 g.2.1 i⟩

theorem smul_idx_def (g : ResidualParameter) (i : Idx25) :
    g • i = residualApplyFast g.1.1 g.2.1 i := rfl

instance : MulAction ResidualParameter Idx25 where
  one_smul i := by
    show residualApplyFast omega omega i = i
    revert i
    decide
  mul_smul g h i := residualApplyFast_mul g h i

theorem smul_finset_def (g : ResidualParameter) (S : Finset Idx25) :
    g • S = S.image (residualApplyFast g.1.1 g.2.1) := rfl

/-- The orbit as a `Finset`.  Never `decide` its cardinality directly: `Finset.image` deduplicates
quadratically.  Use the stabilizer identity below. -/
def residualOrbit (S : Finset Idx25) : Finset (Finset Idx25) :=
  Finset.univ.image fun g : ResidualParameter => S.image (residualApplyFast g.1.1 g.2.1)

/-- The stabilizer as a `Finset`.  This is the object a leaf module decides: one filter over the
`400` parameters, with no deduplication. -/
def residualStabilizer (S : Finset Idx25) : Finset ResidualParameter :=
  Finset.univ.filter fun g => S.image (residualApplyFast g.1.1 g.2.1) = S

/-- The fast action agrees with the embedding form used by the generated cover certificates.
Statements may use either; only the fast form is ever decided. -/
theorem smul_eq_map (g : ResidualParameter) (S : Finset Idx25) :
    g • S = S.map (parameterEmbedding g) := by
  rw [Finset.map_eq_image, smul_finset_def]
  exact Finset.image_congr fun i _ => (residualApply_eq_fast _ _ i).symm

theorem mem_residualOrbit_iff (S T : Finset Idx25) :
    T ∈ residualOrbit S ↔ ∃ g : ResidualParameter, g • S = T := by
  constructor
  · intro h
    obtain ⟨g, -, hg⟩ := Finset.mem_image.mp h
    exact ⟨g, hg⟩
  · rintro ⟨g, hg⟩
    exact Finset.mem_image.mpr ⟨g, Finset.mem_univ g, hg⟩

theorem self_mem_residualOrbit (S : Finset Idx25) : S ∈ residualOrbit S :=
  (mem_residualOrbit_iff S S).mpr ⟨1, one_smul _ _⟩

/-- Reachability is symmetric, because the parameters form a group. -/
theorem mem_residualOrbit_comm {S T : Finset Idx25} (h : T ∈ residualOrbit S) :
    S ∈ residualOrbit T := by
  obtain ⟨g, hg⟩ := (mem_residualOrbit_iff S T).mp h
  exact (mem_residualOrbit_iff T S).mpr ⟨g⁻¹, by rw [← hg, inv_smul_smul]⟩

theorem coe_residualOrbit (S : Finset Idx25) :
    (residualOrbit S : Set (Finset Idx25)) = MulAction.orbit ResidualParameter S := by
  ext T
  constructor
  · intro hT
    obtain ⟨g, -, hg⟩ := Finset.mem_image.mp (Finset.mem_coe.mp hT)
    exact ⟨g, hg⟩
  · rintro ⟨g, hg⟩
    exact Finset.mem_coe.mpr (Finset.mem_image.mpr ⟨g, Finset.mem_univ g, hg⟩)

theorem coe_residualStabilizer (S : Finset Idx25) :
    (residualStabilizer S : Set ResidualParameter) = MulAction.stabilizer ResidualParameter S := by
  ext g
  simp [residualStabilizer, MulAction.mem_stabilizer_iff, smul_finset_def]

theorem card_orbit_eq (S : Finset Idx25)
    [Fintype (MulAction.orbit ResidualParameter S)] :
    Fintype.card (MulAction.orbit ResidualParameter S) = (residualOrbit S).card := by
  rw [← Nat.card_eq_fintype_card, Nat.card_coe_set_eq, ← coe_residualOrbit,
    Set.ncard_coe_finset]

theorem card_stabilizer_eq (S : Finset Idx25)
    [Fintype (MulAction.stabilizer ResidualParameter S)] :
    Fintype.card (MulAction.stabilizer ResidualParameter S) = (residualStabilizer S).card := by
  have e : (MulAction.stabilizer ResidualParameter S) ≃
      {g : ResidualParameter // g ∈ residualStabilizer S} :=
    Equiv.subtypeEquivRight fun g => by
      simp [residualStabilizer, MulAction.mem_stabilizer_iff, smul_finset_def]
  rw [Fintype.card_congr e, Fintype.card_coe]

/-- Orbit–stabilizer for the residual action, in the two `Finset` cardinalities. -/
theorem card_residualOrbit_mul_card_residualStabilizer (S : Finset Idx25) :
    (residualOrbit S).card * (residualStabilizer S).card = 400 := by
  letI : Fintype (MulAction.orbit ResidualParameter S) := Fintype.ofFinite _
  letI : Fintype (MulAction.stabilizer ResidualParameter S) := Fintype.ofFinite _
  have h :
      Fintype.card (MulAction.orbit ResidualParameter S) *
          Fintype.card (MulAction.stabilizer ResidualParameter S) =
        Fintype.card ResidualParameter :=
    MulAction.card_orbit_mul_card_stabilizer_eq_card_group ResidualParameter S
  rw [card_orbit_eq, card_stabilizer_eq, card_residualParameter] at h
  exact h

/-- Two representatives with disjoint orbits: the `Finset` orbits are disjoint as soon as neither
representative is reachable from the other.  The hypothesis is one `400`-case `decide`. -/
theorem disjoint_residualOrbit (S T : Finset Idx25)
    (h : ∀ g : ResidualParameter, S.image (residualApplyFast g.1.1 g.2.1) ≠ T) :
    Disjoint (residualOrbit S) (residualOrbit T) := by
  rw [Finset.disjoint_left]
  rintro U hU hU'
  obtain ⟨g, -, hg⟩ := Finset.mem_image.mp hU
  obtain ⟨k, -, hk⟩ := Finset.mem_image.mp hU'
  refine h (k⁻¹ * g) ?_
  have hgk : (g : ResidualParameter) • S = k • T := by
    rw [smul_finset_def, smul_finset_def, hg, hk]
  have : (k⁻¹ * g) • S = T := by
    rw [mul_smul, hgk, inv_smul_smul]
  rw [← smul_finset_def]
  exact this

end Q25ResidualGroup
end RelativeConicArcs
