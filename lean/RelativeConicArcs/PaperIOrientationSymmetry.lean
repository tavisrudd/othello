import RelativeConicArcs.PaperIOrientationSymmetryGenerators

/-!
# Recovered `S5/A5` symmetry

The five-matching normalizer on the complete six-point frame is exactly the
projective stabilizer of the support cubic line.  Its faithful action on the
five distinguished matchings identifies it with `S₅`; the matching-action
sign is the orientation character, so the oriented stabilizer is `A₅` of
index two.

Two explicit even normalizer elements induce a three-cycle and a five-cycle
on the matchings.  Their orders, Lagrange's theorem, and simplicity of `A₅`
show structurally that they generate the full oriented subgroup.  One odd
element reverses every support sign.  Six distinct cubic-line cosets then
bound the line stabilizer by order `120`, proving equality with the matching
normalizer without enumerating frame permutations.
-/

namespace RelativeConicArcs.PaperIOrientationSymmetry

open Equiv Equiv.Perm
open PaperIOrientationCover
open PaperIOrientationHolonomy

/-- The intrinsic matching normalizer is exactly the group preserving the
support cubic line. -/
theorem mem_supportCubicProjectiveStabilizer_iff_cubicLine
    (sigma : Equiv.Perm SixPointFrame) :
    sigma ∈ SupportCubicProjectiveStabilizer ↔
      PreservesSupportCubicLine sigma := by
  change sigma ∈ SupportCubicProjectiveStabilizer ↔
    sigma ∈ SupportCubicLineStabilizer
  rw [supportCubicProjectiveStabilizer_eq_lineStabilizer]

/-- The sign character recovered from the two complementary triple orbits. -/
def recoveredOrientationSign : SupportCubicProjectiveStabilizer →* ℤˣ :=
  Equiv.Perm.sign.comp matchingAction

/-- Preserving the oriented support cubic is the sign kernel. -/
def OrientedSupportCubicStabilizer :
    Subgroup SupportCubicProjectiveStabilizer :=
  recoveredOrientationSign.ker

noncomputable instance : Fintype OrientedSupportCubicStabilizer :=
  Fintype.ofFinite _

/-- The sign kernel is exactly the subgroup preserving every oriented
triangle coefficient. -/
theorem mem_orientedSupportCubicStabilizer_iff
    (sigma : SupportCubicProjectiveStabilizer) :
    sigma ∈ OrientedSupportCubicStabilizer ↔
      PreservesOrientedSupportCubic sigma.1 := by
  change Equiv.Perm.sign (matchingAction sigma) = 1 ↔ _
  constructor
  · intro h
    exact preservesSupportSign_of_matchingSign_eq_one sigma h
  · intro horiented
    rcases Int.units_eq_one_or (Equiv.Perm.sign (matchingAction sigma)) with h | h
    · exact h
    · have hreverse := reversesSupportSign_of_matchingSign_eq_neg_one sigma h
      have hp := horiented 0 1 2
      have hr := hreverse 0 1 2
      have hz : supportSign 0 1 2 = -supportSign 0 1 2 := hp.symm.trans hr
      have hs : supportSign 0 1 2 ≠ 0 := by decide
      omega

/-- The stabilizer of the oriented support cubic is `A₅`. -/
noncomputable def orientedSupportCubic_stabilizer_equiv_A5 :
    OrientedSupportCubicStabilizer ≃* A5 := by
  let e5 : SupportCubicProjectiveStabilizer ≃* Equiv.Perm (Fin 5) :=
    MulEquiv.ofBijective matchingAction matchingAction_bijective
  have hmap : OrientedSupportCubicStabilizer.map e5.toMonoidHom =
      alternatingGroup (Fin 5) := by
    rw [alternatingGroup_eq_sign_ker]
    ext g
    constructor
    · rintro ⟨a, ha, rfl⟩
      exact ha
    · intro hg
      obtain ⟨a, ha⟩ := matchingAction_bijective.2 g
      refine ⟨a, ?_, ha⟩
      change Equiv.Perm.sign (matchingAction a) = 1
      rw [ha]
      exact hg
  exact ((e5.subgroupMap OrientedSupportCubicStabilizer).trans
    (MulEquiv.subgroupCongr hmap)).trans
      (ZMod.finEquiv 5).toEquiv.altCongrHom

/-- The oriented subgroup has index two in the recovered projective
stabilizer, exactly the sign character kernel. -/
theorem orientedSupportCubic_index_two :
    Fintype.card SupportCubicProjectiveStabilizer =
      2 * Fintype.card OrientedSupportCubicStabilizer := by
  classical
  rw [Fintype.card_congr supportCubic_projectiveStabilizer_equiv_S5.toEquiv,
    Fintype.card_congr orientedSupportCubic_stabilizer_equiv_A5.toEquiv]
  simpa [S5, A5] using
    (two_mul_card_alternatingGroup (α := Letter)).symm

#print axioms mem_supportCubicProjectiveStabilizer_iff_cubicLine
#print axioms supportCubic_projectiveStabilizer_equiv_S5
#print axioms mem_orientedSupportCubicStabilizer_iff
#print axioms orientedSupportCubic_stabilizer_equiv_A5
#print axioms orientedSupportCubic_index_two

end RelativeConicArcs.PaperIOrientationSymmetry
