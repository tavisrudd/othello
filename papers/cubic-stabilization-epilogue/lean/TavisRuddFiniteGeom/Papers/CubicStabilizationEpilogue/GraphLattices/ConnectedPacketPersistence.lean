import Mathlib.Topology.Connected.TotallyDisconnected

/-!
# Persistence of a finite gluing packet over a connected base

A continuous family valued in a finite discrete packet is constant on a
connected base.  Consequently, membership in any distinguished part of the
packet propagates from one fibre to every fibre.  This is the topological
argument used to pass a classified gluing type through a connected smooth
component once continuity of the classifying map is supplied.

Lean proves the connectedness deduction itself.  It does not construct a
geometric local system, its finite packet of principal kernels, or the
continuous classifying map from a family of abelian varieties.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

/-- A continuous map from a connected space to a finite discrete packet has
the same value at every two base points. -/
theorem connectedBase_finiteDiscretePacket_constant
    {Base Packet : Type*} [TopologicalSpace Base] [ConnectedSpace Base]
    [TopologicalSpace Packet] [DiscreteTopology Packet] [Finite Packet]
    (packetClass : Base → Packet) (continuous : Continuous packetClass)
    (first second : Base) :
    packetClass first = packetClass second := by
  exact TotallyDisconnectedSpace.eq_of_continuous packetClass continuous
    first second

/-- If one fibre of a continuous finite-packet family lies in a distinguished
subset, every fibre lies in that subset. -/
theorem connectedBase_finiteDiscretePacket_membership_persists
    {Base Packet : Type*} [TopologicalSpace Base] [ConnectedSpace Base]
    [TopologicalSpace Packet] [DiscreteTopology Packet] [Finite Packet]
    (packetClass : Base → Packet) (continuous : Continuous packetClass)
    (distinguished : Set Packet) (basePoint : Base)
    (atBasePoint : packetClass basePoint ∈ distinguished) :
    ∀ point, packetClass point ∈ distinguished := by
  intro point
  rw [connectedBase_finiteDiscretePacket_constant packetClass continuous
    point basePoint]
  exact atBasePoint

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
