import RelativeConicArcs.CompletionDistance
import FiniteGeom.BaerCompletion.BaerPlane

/-!
# Involutions of abstract projective planes

This module instantiates the generic Baer secant lemmas in Mathlib's abstract projective-plane
incidence API. The intended involution is quadratic Frobenius.
-/

namespace RelativeConicArcs

open Configuration Finset
open FiniteGeom.BaerCompletion

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

/-- An incidence-preserving involution of a projective plane. -/
structure ProjectivePlaneInvolution (P L : Type*) [Membership P L] where
  pointConj : P ≃ P
  lineConj : L ≃ L
  point_involutive : ∀ p, pointConj (pointConj p) = p
  line_involutive : ∀ l, lineConj (lineConj l) = l
  mem_conj_iff : ∀ p l, pointConj p ∈ lineConj l ↔ p ∈ l

/-- Forget the projective-plane axioms and retain the involutive incidence data. -/
def ProjectivePlaneInvolution.toInvolutiveIncidence
    (τ : ProjectivePlaneInvolution P L) : InvolutiveIncidence P L where
  incident p l := p ∈ l
  pointConj := τ.pointConj
  lineConj := τ.lineConj
  point_involutive := τ.point_involutive
  line_involutive := τ.line_involutive
  incident_conj_iff := τ.mem_conj_iff

variable (τ : ProjectivePlaneInvolution P L)

noncomputable local instance instDecidableBaerIncident :
    DecidableRel τ.toInvolutiveIncidence.incident :=
  fun _ _ => Classical.propDecidable _

omit [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L] in
/-- In a projective plane, conjugate nonfixed lines through an external common point have disjoint
traces on the selected set. -/
theorem projective_conjugate_lineTraces_disjoint {C : Finset P} {x : P} {l : L}
    (hl : l ≠ τ.lineConj l) (hxl : x ∈ l) (hxcl : x ∈ τ.lineConj l) (hxC : x ∉ C) :
    Disjoint (lineTrace τ.toInvolutiveIncidence C l)
      (lineTrace τ.toInvolutiveIncidence C (τ.lineConj l)) := by
  apply conjugate_lineTraces_disjoint τ.toInvolutiveIncidence hxC
  intro q hql hqcl
  exact ((Configuration.Nondegenerate.eq_or_eq hxl hql hxcl hqcl).resolve_right hl).symm

omit [Fintype P] [Fintype L] [DecidableEq L] [Configuration.ProjectivePlane P L] in
/-- A fixed secant of an invariant arc contains either two fixed selected points or one conjugate
pair. -/
theorem projective_fixed_secant_fixed_or_conjugate {C : Finset P} {l : L}
    (hC : IsInvariant τ.toInvolutiveIncidence C)
    (hl : IsFixedLine τ.toInvolutiveIncidence l)
    (hcard : (lineTrace τ.toInvolutiveIncidence C l).card = 2) :
    (∀ p ∈ lineTrace τ.toInvolutiveIncidence C l,
        IsFixedPoint τ.toInvolutiveIncidence p) ∨
      ∃ p, p ∈ lineTrace τ.toInvolutiveIncidence C l ∧
        ¬ IsFixedPoint τ.toInvolutiveIncidence p ∧
        lineTrace τ.toInvolutiveIncidence C l = {p, τ.pointConj p} := by
  apply invariant_pair_fixed_or_conjugate τ.toInvolutiveIncidence
  · exact lineTrace_invariant_of_fixed τ.toInvolutiveIncidence hC hl
  · exact hcard

end RelativeConicArcs
