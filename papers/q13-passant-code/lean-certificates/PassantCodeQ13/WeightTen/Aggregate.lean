import PassantCodeQ13.WeightTen.IsolatedProfile.Fibre0
import PassantCodeQ13.WeightTen.IsolatedProfile.Fibre1
import PassantCodeQ13.WeightTen.IsolatedProfile.Fibre2
import PassantCodeQ13.WeightTen.IsolatedProfile.Fibre3
import PassantCodeQ13.WeightTen.IsolatedProfile.Fibre4
import PassantCodeQ13.WeightTen.IsolatedProfile.Fibre5
import PassantCodeQ13.WeightTen.IsolatedProfile.Fibre6
import PassantCodeQ13.WeightTen.CycleProfile.Residue0
import PassantCodeQ13.WeightTen.CycleProfile.Residue1
import PassantCodeQ13.WeightTen.CycleProfile.Residue2
import PassantCodeQ13.WeightTen.CycleProfile.Residue3
import PassantCodeQ13.WeightTen.CycleProfile.Residue4
import PassantCodeQ13.WeightTen.CycleProfile.Residue5
import PassantCodeQ13.WeightTen.CycleProfile.Residue6

/-!
# Aggregate q=13 weight-ten certificate

The local partition is checked from the normalized conic incidence relation.  The isolated-profile
leaves cover each possible distinguished passant fibre.  The cycle-profile leaves partition all
unordered pairs of the thirty-five secant neighbors by the first endpoint's coordinate index
modulo seven.  The aggregate joins the fourteen independently elaborated native terminals.
-/

namespace PassantCodeQ13.WeightTen

/-- The fixed-base incidence partition consists of seven six-point passant fibres and thirty-five
secant neighbors. -/
theorem local_partition : localPartitionCheck = true := by
  native_decide

/-- Every isolated-profile shard has disjoint left and right syndrome images. -/
theorem all_isolated_profiles_disjoint :
    (List.range 7).all isolatedProfileCheck = true := by
  native_decide

/-- Every cycle-profile residue shard has disjoint left and right syndrome images. -/
theorem all_cycle_profiles_disjoint :
    (List.range 7).all cycleProfileCheck = true := by
  native_decide

/-- The seven residue shards contain each unordered pair of secant neighbors exactly once. -/
theorem cycle_pair_partition :
    ((List.range 7).flatMap cyclePairs).eraseDups.length =
      secantNeighbors.sublistsLen 2 |>.length := by
  native_decide

end PassantCodeQ13.WeightTen
