import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisSlopeModels
import Mathlib.Topology.Connected.TotallyDisconnected

/-!
# Persistence of a finite gluing packet over a connected base

A continuous family valued in a finite discrete packet is constant on a
connected base.  Consequently, membership in any distinguished part of the
packet propagates from one fibre to every fibre.  This is the topological
argument used to pass a classified gluing type through a connected smooth
component once continuity of the classifying map is supplied.
The final theorem specializes the deduction to the transported marked
quadratic pair in the affine chart of the concrete five-point `F4` packet.

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

/-- A continuous classifier into the affine chart of the concrete `F4`
projective packet preserves the marked quadratic Frobenius pair throughout a
connected base.  The classifier and its topology remain supplied data. -/
theorem connectedBase_f4MarkedProjectivePair_constant_and_persists
    {Base : Type*} [TopologicalSpace Base] [ConnectedSpace Base]
    [TopologicalSpace (Option F4)] [DiscreteTopology (Option F4)]
    (packetClass : Base → Option F4) (continuous : Continuous packetClass)
    (basePoint : Base)
    (atBasePoint :
      packetClass basePoint = some sixAxisQuadraticSlopeRootInF4 ∨
        packetClass basePoint =
          some (sixAxisQuadraticSlopeRootInF4 + 1)) :
    (∀ first second, packetClass first = packetClass second) ∧
      ∀ point,
        packetClass point = some sixAxisQuadraticSlopeRootInF4 ∨
          packetClass point =
            some (sixAxisQuadraticSlopeRootInF4 + 1) := by
  refine ⟨connectedBase_finiteDiscretePacket_constant packetClass continuous,
    ?_⟩
  intro point
  rw [connectedBase_finiteDiscretePacket_constant packetClass continuous
    point basePoint]
  exact atBasePoint

/-- A continuous classifier into the actual projective line over `F4`
preserves the two scalar graphs of the transported marked quadratic pair
throughout a connected base.  The classifier and its topology remain supplied
data. -/
theorem connectedBase_f4MarkedProjectiveLinePair_constant_and_persists
    {Base : Type*} [TopologicalSpace Base] [ConnectedSpace Base]
    [TopologicalSpace (Projectivization F4 (F4 × F4))]
    [DiscreteTopology (Projectivization F4 (F4 × F4))]
    (packetClass : Base → Projectivization F4 (F4 × F4))
    (continuous : Continuous packetClass) (basePoint : Base)
    (atBasePoint :
      packetClass basePoint =
          scalarGraphPoint F4 sixAxisQuadraticSlopeRootInF4 ∨
        packetClass basePoint = scalarGraphPoint F4
          (sixAxisQuadraticSlopeRootInF4 + 1)) :
    (∀ first second, packetClass first = packetClass second) ∧
      ∀ point,
        packetClass point =
            scalarGraphPoint F4 sixAxisQuadraticSlopeRootInF4 ∨
          packetClass point = scalarGraphPoint F4
            (sixAxisQuadraticSlopeRootInF4 + 1) := by
  refine ⟨connectedBase_finiteDiscretePacket_constant packetClass continuous,
    ?_⟩
  intro point
  rw [connectedBase_finiteDiscretePacket_constant packetClass continuous
    point basePoint]
  exact atBasePoint

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
