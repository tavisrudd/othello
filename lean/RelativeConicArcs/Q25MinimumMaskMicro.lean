import RelativeConicArcs.Q25MinimumMask

/-!
# C151 micro-prototype: one literal minimum mask

The external generator proposes these five words.  The count theorem below is deliberately
independent of the determinant computation; soundness is split into one candidate theorem per set
bit so no declaration normalizes all `310` reflected predicates.
-/

namespace RelativeConicArcs
namespace Q25MinimumMaskMicro

open Q25Coordinates Q25PairCertificate Q25MinimumChecker Q25MinimumMask

set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000

def equalityRepresentative : Finset Idx25 :=
  normalizedConfig (orbitCodeOfNumber ⟨5, by decide⟩)
    (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩)

/-- Legal-orbit bits for the row `(5,58,169)`, little-endian by stable orbit number. -/
def equalityMask : OrbitMask := ![
  79529909420032,
  1155454788065951744,
  14699749183737857088,
  18309071988326403,
  0]

theorem card_equalityMask : (maskOrbitSet equalityMask).card = 32 := by decide

theorem bit_032 : maskBit equalityMask ⟨32, by decide⟩ = true := by decide

/-- First split soundness leaf; the full prototype will generate one such theorem per set bit. -/
theorem reflected_032 :
    ReflectedLegal equalityRepresentative (orbitCodeOfNumber ⟨32, by decide⟩) := by decide

end Q25MinimumMaskMicro
end RelativeConicArcs
