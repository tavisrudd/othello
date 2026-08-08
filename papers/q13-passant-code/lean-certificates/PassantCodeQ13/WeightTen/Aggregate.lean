import PassantCodeQ13.WeightTen.IsolatedReachability.Aggregate
import PassantCodeQ13.WeightTen.CycleExclusion.Aggregate

/-!
# Aggregate q=13 weight-ten certificate

At the normalized internal point `(1,0,2)` the remaining internal points split into seven six-point
passant fibres and thirty-five secant-join neighbours.  A ten-point support of a codeword all of
whose points have secant degree two, and one with a distinguished point of secant degree zero, are
the two shapes an arbitrary weight-ten support takes at one of its points.

This module joins the local partition, which is decided here by kernel reduction, with the two
imported exclusions.  The isolated shape is excluded by
`PassantCodeQ13.WeightTen.IsolatedReachability.all_profiles_excluded`, which states that the two
halves of the meet-in-the-middle decomposition never carry equal syndromes, for every member of the
complete Cartesian domain of choices rather than for the members an enumeration happens to visit.
The two-regular shape is excluded by
`PassantCodeQ13.WeightTen.CycleExclusion.obstructed_of_base_pair_and_fibres`, which states that
every configuration of the base point, an unordered secant pair, and one point in each passant fibre
carries three points on a passant or a point of secant degree three.  Neither exclusion is checked
by compiled evaluation.

The reduction of an arbitrary weight-ten codeword to these two shapes, and the transport of the
fixed base point to an arbitrary internal point, are established outside this module.
-/

namespace PassantCodeQ13.WeightTen

/-- The fixed-base incidence partition consists of seven six-point passant fibres and thirty-five
secant neighbors. -/
theorem local_partition : localPartitionCheck = true := by
  decide +kernel

end PassantCodeQ13.WeightTen
