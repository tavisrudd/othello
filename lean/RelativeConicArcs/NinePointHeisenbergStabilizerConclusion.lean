import RelativeConicArcs.NinePointHeisenbergStabilizerFirstIndex0
import RelativeConicArcs.NinePointHeisenbergStabilizerFirstIndex1
import RelativeConicArcs.NinePointHeisenbergStabilizerFirstIndex2
import RelativeConicArcs.NinePointHeisenbergStabilizerFirstIndex3
import RelativeConicArcs.NinePointHeisenbergStabilizerFirstIndex4
import RelativeConicArcs.NinePointHeisenbergStabilizerFirstIndex5
import RelativeConicArcs.NinePointHeisenbergStabilizerFirstIndex6
import RelativeConicArcs.NinePointHeisenbergStabilizerFirstIndex7
import RelativeConicArcs.NinePointHeisenbergStabilizerFirstIndex8

/-!
# Exact stabilizer census of a nine-point Heisenberg pair

The 81 kernel-checked frame-prefix blocks are assembled without recomputing their finite searches.
They cover all 3024 ordered images of the fixed projective frame.  The resulting theorem gives
stabilizer order nine for each orbit and the ordered pair, identifies every accepted transporter
with one of the nine displayed Heisenberg projectivities, and rules out an interchange of the two
orbits.  Projective-frame uniqueness is supplied by
`NinePointHeisenbergStabilizer.matrix_eq_smul_of_coordinate_frame_rays`.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergStabilizerConclusion

open NinePointHeisenbergStabilizer

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- Every one of the 81 first-two-image blocks has its exact transporter profile. -/
theorem all_stabilizer_prefix_profiles (first second : Fin 9) :
    stabilizerPrefixProfile first second = true := by
  rcases NinePointHeisenbergStabilizerFirstIndex0.transporter_profile with
    ⟨h00, h01, h02, h03, h04, h05, h06, h07, h08⟩
  rcases NinePointHeisenbergStabilizerFirstIndex1.transporter_profile with
    ⟨h10, h11, h12, h13, h14, h15, h16, h17, h18⟩
  rcases NinePointHeisenbergStabilizerFirstIndex2.transporter_profile with
    ⟨h20, h21, h22, h23, h24, h25, h26, h27, h28⟩
  rcases NinePointHeisenbergStabilizerFirstIndex3.transporter_profile with
    ⟨h30, h31, h32, h33, h34, h35, h36, h37, h38⟩
  rcases NinePointHeisenbergStabilizerFirstIndex4.transporter_profile with
    ⟨h40, h41, h42, h43, h44, h45, h46, h47, h48⟩
  rcases NinePointHeisenbergStabilizerFirstIndex5.transporter_profile with
    ⟨h50, h51, h52, h53, h54, h55, h56, h57, h58⟩
  rcases NinePointHeisenbergStabilizerFirstIndex6.transporter_profile with
    ⟨h60, h61, h62, h63, h64, h65, h66, h67, h68⟩
  rcases NinePointHeisenbergStabilizerFirstIndex7.transporter_profile with
    ⟨h70, h71, h72, h73, h74, h75, h76, h77, h78⟩
  rcases NinePointHeisenbergStabilizerFirstIndex8.transporter_profile with
    ⟨h80, h81, h82, h83, h84, h85, h86, h87, h88⟩
  fin_cases first
  · fin_cases second
    · exact h00
    · exact h01
    · exact h02
    · exact h03
    · exact h04
    · exact h05
    · exact h06
    · exact h07
    · exact h08
  · fin_cases second
    · exact h10
    · exact h11
    · exact h12
    · exact h13
    · exact h14
    · exact h15
    · exact h16
    · exact h17
    · exact h18
  · fin_cases second
    · exact h20
    · exact h21
    · exact h22
    · exact h23
    · exact h24
    · exact h25
    · exact h26
    · exact h27
    · exact h28
  · fin_cases second
    · exact h30
    · exact h31
    · exact h32
    · exact h33
    · exact h34
    · exact h35
    · exact h36
    · exact h37
    · exact h38
  · fin_cases second
    · exact h40
    · exact h41
    · exact h42
    · exact h43
    · exact h44
    · exact h45
    · exact h46
    · exact h47
    · exact h48
  · fin_cases second
    · exact h50
    · exact h51
    · exact h52
    · exact h53
    · exact h54
    · exact h55
    · exact h56
    · exact h57
    · exact h58
  · fin_cases second
    · exact h60
    · exact h61
    · exact h62
    · exact h63
    · exact h64
    · exact h65
    · exact h66
    · exact h67
    · exact h68
  · fin_cases second
    · exact h70
    · exact h71
    · exact h72
    · exact h73
    · exact h74
    · exact h75
    · exact h76
    · exact h77
    · exact h78
  · fin_cases second
    · exact h80
    · exact h81
    · exact h82
    · exact h83
    · exact h84
    · exact h85
    · exact h86
    · exact h87
    · exact h88

/--
The exhaustive frame census has stabilizer counts `(9,9,9)` for the selected orbit, uncovered
orbit, and ordered pair, and has zero transporters in either direction between the two orbits.
-/
theorem exact_frame_normalized_stabilizer_counts :
    frameNormalizedSelectedStabilizerCount = 9 ∧
    frameNormalizedUncoveredStabilizerCount = 9 ∧
    frameNormalizedPairStabilizerCount = 9 ∧
    frameNormalizedSelectedToUncoveredCount = 0 ∧
    frameNormalizedUncoveredToSelectedCount = 0 :=
  exact_frame_normalized_stabilizer_counts_of_profiles all_stabilizer_prefix_profiles

end NinePointHeisenbergStabilizerConclusion
end RelativeConicArcs
