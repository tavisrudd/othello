import RelativeConicArcs.Q16Reduction
import RelativeConicArcs.Q16LeafData

/-!
# The stronger quadratic obstruction at q=16

The generated leaves were originally consumed through their nonsingular-conic consequence.  This
module records exactly what their linear algebra proves before that specialization: a quadratic
vanishing on the ordinary-uncovered locus is zero or also hits the selected eight-arc.  Keeping
this downstream of the generated aggregate avoids making any certificate depend on the stronger
presentation theorem.
-/

namespace RelativeConicArcs
namespace Q16Classification

open Finset
open FiniteFields
open Q16CertificateData

/-- The ordinary-uncovered locus of `S` is not contained in the zero set of a nonzero
homogeneous quadratic that avoids `S`.  This statement includes singular quadratics. -/
def QuadraticAvoidance (S : Finset Idx) : Prop :=
  ∀ q : Fin 6 → GF16,
    (∀ i, OrdinaryUncovered S i → dotProduct (monomial (vec i)) q = 0) →
      q = 0 ∨ ∃ i ∈ S, dotProduct (monomial (vec i)) q = 0

theorem FullRankReject.quadraticAvoidance {S : Finset Idx} {r : FullRankReject}
    (hr : r.ValidFor S) : QuadraticAvoidance S := by
  intro q hvanish
  left
  apply r.quadratic_eq_zero hr.2.2
  intro i
  exact hvanish _ (ordinaryUncovered_of_by hr.1 (hr.2.1 i))

theorem ForcedHitReject.quadraticAvoidance {S : Finset Idx} {r : ForcedHitReject}
    (hr : r.ValidFor S) : QuadraticAvoidance S := by
  intro q hvanish
  right
  refine ⟨r.hit, hr.2.1, r.quadratic_vanishes_at_hit hr.2.2.2 ?_⟩
  intro i
  exact hvanish _ (ordinaryUncovered_of_by hr.1 (hr.2.2.1 i))

theorem LeafReject.quadraticAvoidance {S : Finset Idx} {r : LeafReject} (hr : r.ValidFor S) :
    QuadraticAvoidance S := by
  cases r with
  | fullRank r => exact r.quadraticAvoidance hr
  | forcedHit r => exact r.quadraticAvoidance hr

theorem RejectsLevel.quadraticAvoidance {level : List (Finset Idx)}
    {leaves : List RejectedLeaf} (h : RejectsLevel level leaves)
    {S : Finset Idx} (hS : S ∈ level) : QuadraticAvoidance S := by
  have hSm : S ∈ leaves.map RejectedLeaf.leaf := by simpa [h.1] using hS
  obtain ⟨x, hx, hleaf⟩ := List.mem_map.mp hSm
  subst S
  exact x.reject.quadraticAvoidance (h.2 x hx)

/-- Every one of the 2633 canonical eight-arc representatives has the quadratic-avoidance
property. -/
theorem level8_quadraticAvoidance {S : Finset Idx} (hS : S ∈ level8) :
    QuadraticAvoidance S :=
  rejectedLeaves_valid.quadraticAvoidance hS

#print axioms level8_quadraticAvoidance

end Q16Classification
end RelativeConicArcs
