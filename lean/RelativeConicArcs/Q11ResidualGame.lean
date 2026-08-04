import RelativeConicArcs.Q11Residual
import RelativeConicArcs.CapGameHoleLocalization

/-!
# The residual game of the `q = 11` relative-conic witness

The conflict graph of the twelve standard-conic points left available by the six-point witness
`Examples.q11Witness`, its identification with the icosahedral graph, and the dictionary between
legal projective continuations and independent sets are in `RelativeConicArcs.Q11Residual`.  This
file adds the normal-play game values built on that dictionary, for the achievement game of
`ProjectiveCap.ProjectiveCapGame` in which the players alternately adjoin a point keeping the
position a cap and a player unable to move loses.

`isP` states that the residual independent-set building game on the icosahedral graph, started
from the empty position, is a previous-player win; `seed_isP` states the same of the actual
six-point projective cap position in `PG(2, ZMod 11)`.

Neither conclusion is an exhaustive game-tree computation.  The first is an application of the
generic fixed-point-free conflict-graph mirror theorem to the antipodal involution, and the second
transports it along the exact hole localization of `RelativeConicArcs.CapGameHoleLocalization`,
which is available because the witness is relatively complete outside the standard conic and the
twelve displayed parameters exhaust that conic.
-/

namespace RelativeConicArcs
namespace Examples
namespace Q11ResidualGame

open Certificate ConflictGraph Q11Residual

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

noncomputable local instance : Fintype (Conic.Point (ZMod 11)) := Fintype.ofFinite _
noncomputable local instance : DecidableEq (Conic.Point (ZMod 11)) := Classical.decEq _

/-- The residual independent-set building game is P by antipodal reply. -/
theorem isP :
    FiniteBuildGame.IsP (IndepValid Adj) (∅ : Finset (Fin 12)) := by
  exact initialIndepP_of_fpf_adjPreserving_involution Adj adj_symmetric antipode
    antipode_involutive antipode_fixedPointFree adj_antipode_iff antipodal_chord_nonedge

/-- The actual six-point projective cap position is P.  Static relative completeness confines
every continuation to the conic, the determinant table identifies those continuations with the
icosahedral independent-set game, and the antipodal mirror supplies the replies. -/
theorem seed_isP :
    FiniteBuildGame.IsP
      (ProjectiveCap.Projective.Cap (ZMod 11) (Fin 3 → ZMod 11))
      (pointSet q11Witness) := by
  have hcomplete : CompleteOutside (L := Conic.Point (ZMod 11))
      (pointSet q11Witness) (Conic.standardConic (K := ZMod 11)) :=
    check_sound q11_check
  have hlocal := ProjectiveBridge.isP_parametrizedHoles_iff
    (K := ZMod 11) conicEmbedding hcomplete conicEmbedding_range (∅ : Finset (Fin 12))
  have hpred : FiniteBuildGame.IsP
      (ProjectiveBridge.ParametrizedHoleValid
        (K := ZMod 11) (pointSet q11Witness) conicEmbedding) (∅ : Finset (Fin 12)) := by
    have htransport := FiniteBuildGame.isP_equiv (Equiv.refl (Fin 12))
      (Validα := IndepValid Adj)
      (Validβ := ProjectiveBridge.ParametrizedHoleValid
        (K := ZMod 11) (pointSet q11Witness) conicEmbedding)
      (fun S => by simpa using parametrizedHoleValid_iff S) (∅ : Finset (Fin 12))
    exact htransport.mpr isP
  simpa using hlocal.mpr hpred

end Q11ResidualGame
end Examples
end RelativeConicArcs
