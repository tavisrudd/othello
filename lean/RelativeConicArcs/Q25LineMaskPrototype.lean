import RelativeConicArcs.Q25LineMaskChecker

/-!
# C151 prototype: one complete canonical line mask

This gate checks all `310` selected orbit representatives against the fixed line through the two
normalized base points.  It measures the cost of reusing a single line-incidence mask before the
full `651`-line table is generated.
-/

namespace RelativeConicArcs
namespace Q25LineMaskPrototype

open Q25Coordinates Q25PairCertificate Q25MinimumMask Q25LineMaskChecker FiniteFields

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

/-- Incidence mask of the line `x = 0`, indexed by the stable `310` nonfixed orbit numbers. -/
def fixedPairLineMask : OrbitMask := ![0, 0, 0, 0, 17996806323437568]

theorem fixedPairLineMask_exact :
    ∀ n : Fin 310,
      maskBit fixedPairLineMask n = true ↔
        lineDot (vec (.affine 0 0)) (vec (orbitIdx (orbitCodeOfNumber n))) = 0 := by
  decide

theorem fixedPairLineMask_certificate :
    LineMaskCertificate (.affine 0 0) fixedPairLineMask :=
  ⟨fixedPairLineMask_exact⟩

theorem fixedPair_line_witness :
    LineWitnessValid (.vertical) (.infinity 0) (.affine 0 0) (GF25.ofNat 4) := by
  decide

end Q25LineMaskPrototype
end RelativeConicArcs
