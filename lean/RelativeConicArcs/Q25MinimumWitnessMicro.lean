import RelativeConicArcs.Q25PairCertificate

/-!
# C151 micro-prototype: split legality witnesses

The monolithic reflected subset decision OOMed even for one row.  This leaf measures the C143-style
alternative: reduce one legality claim at a time, then compose those small theorems without asking
the kernel to normalize a universal 310-orbit proposition.
-/

namespace RelativeConicArcs
namespace Q25MinimumWitnessMicro

open Q25Coordinates Q25PairCertificate

set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000

def equalityRepresentative : Finset Idx25 :=
  normalizedConfig (orbitCodeOfNumber ⟨5, by decide⟩)
    (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩)

/-- The first of the representative's 32 independently generated legal orbit codes. -/
theorem legal_032 :
    LegalPair equalityRepresentative (orbitCodeOfNumber ⟨32, by decide⟩) := by decide

end Q25MinimumWitnessMicro
end RelativeConicArcs
