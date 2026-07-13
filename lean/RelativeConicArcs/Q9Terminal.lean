import RelativeConicArcs.ExampleChecks.Q9
import CapGame.BuildGame

/-!
# The terminal `q = 9` relative-conic witness

The frozen six-point `q = 9` witness covers not only every point outside the standard conic but
also every point of the conic itself. Thus it is an ordinary complete arc. The projective cap game
has no legal move from this seed, so normal play makes it a P-position.
-/

namespace RelativeConicArcs
namespace Examples
namespace Q9Terminal

open Certificate Conic FiniteFields ProjectiveBridge

noncomputable local instance : Fintype (Conic.Point GF9) := Fintype.ofFinite _
noncomputable local instance : DecidableEq (Conic.Point GF9) := Classical.decEq _

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

/-- Every canonical projective representative is selected or covered by a witness secant. -/
theorem ordinaryCoverage : RawOrdinaryCoverage q9Witness := by decide

/-- The `q = 9` witness is an ordinary complete arc, not merely complete outside the conic. -/
theorem complete :
    CompleteOutside (L := Conic.Point GF9) (pointSet q9Witness) ∅ :=
  check_sound_empty q9_check ordinaryCoverage

/-- There is no legal projective cap-game extension of the witness. -/
theorem no_legal_move (x : Conic.Point GF9) :
    ¬ FiniteBuildGame.Move
      (ProjectiveCap.Projective.Cap GF9 (Fin 3 → GF9)) (pointSet q9Witness) x := by
  intro hx
  have hxEmpty : x ∈ (∅ : Finset (Conic.Point GF9)) :=
    move_mem_holes_of_completeOutside complete Finset.Subset.rfl hx
  simp at hxEmpty

theorem legalExtensions_eq_empty :
    ProjectiveCap.Projective.LegalExtensions
      (K := GF9) (V := Fin 3 → GF9) (pointSet q9Witness) = ∅ := by
  apply Finset.eq_empty_iff_forall_notMem.mpr
  intro x hx
  exact no_legal_move x (ProjectiveCap.Projective.mem_legalExtensions.mp hx)

/-- Terminal positions are P under the repository's normal-play convention. -/
theorem isP :
    FiniteBuildGame.IsP
      (ProjectiveCap.Projective.Cap GF9 (Fin 3 → GF9)) (pointSet q9Witness) :=
  FiniteBuildGame.isP_of_no_moves no_legal_move

end Q9Terminal
end Examples
end RelativeConicArcs
