import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.PacketInvariant

/-!
# Birational deductions from operation formulas

Weak factorization reduces a birational map to blow-ups and blow-downs.  If the
packet contribution of every allowed center vanishes, each step preserves the
packet multiplicity.  The theorem below formalizes the resulting telescope.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

variable {Variety : Type*}

/-- A composable chain of transformations that preserve the packet
multiplicity.  The indices encode adjacency, so no separate endpoint or
composability certificate is required. -/
inductive PreservingChain (packet : PacketData Variety) : Variety → Variety → Prop
  | refl (object : Variety) : PreservingChain packet object object
  | step {source middle target : Variety}
      (preserves : packet.multiplicity source = packet.multiplicity middle)
      (tail : PreservingChain packet middle target) :
      PreservingChain packet source target

/-- A chain of packet-preserving factorization steps has equal multiplicity at
its endpoints. -/
theorem PreservingChain.multiplicity_eq
    (packet : PacketData Variety) {source target : Variety}
    (chain : PreservingChain packet source target) :
    packet.multiplicity source = packet.multiplicity target := by
  induction chain with
  | refl => rfl
  | step preserves _ inductionHypothesis => exact preserves.trans inductionHypothesis

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
