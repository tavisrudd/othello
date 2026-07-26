import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Chord-direction mechanism of a nine-point Heisenberg pair

The four directions in `C₃ × C₃` partition the 36 chords of the explicit uncovered orbit.
Kernel reduction checks all nine chords in each direction, their selected-orbit incidences, the
asymmetric secant multiplicities, and failure of the eighteen-point union to be an arc.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergChordProfile

open NinePointHeisenbergPair NinePointHeisenbergIncidence

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/--
The four uncovered-orbit chord directions have the exact `9+9+9+0` selected-point incidence
profile.  In the three hitting directions, the selected label is the third affine group-line
label plus the displayed offset.
-/
theorem four_chord_direction_profile :
    directionProfile (0, 1) (1, 1) = true ∧
    directionProfile (1, 0) (1, 0) = true ∧
    directionProfile (1, 1) (0, 0) = true ∧
    missedDirection (1, 2) = true := by
  decide

/-- Every selected point lies on three uncovered secants, while no uncovered point lies on a
selected secant. -/
theorem asymmetric_secant_incidence :
    NinePointHeisenbergPair.selected.all
        (fun p => secantMultiplicity NinePointHeisenbergPair.uncovered p = 3) = true ∧
    NinePointHeisenbergPair.uncovered.all
        (fun p => secantMultiplicity NinePointHeisenbergPair.selected p = 0) = true := by
  decide

/-- The union of the two nine-point sets is not an arc. -/
theorem union_is_not_arc :
    isCoordinateArc
      (NinePointHeisenbergPair.selected ++ NinePointHeisenbergPair.uncovered) = false := by
  decide

end NinePointHeisenbergChordProfile
end RelativeConicArcs
