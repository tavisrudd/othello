import RelativeConicArcs.Q25ResidualCoverBridge

namespace RelativeConicArcs
namespace Q25ResidualCoverPrototype

open Q25ResidualCoverData FiniteFields

def prototypeBad : BadRowPayload :=
  { c := ⟨7, by decide⟩, i := ⟨0, by decide⟩, j := ⟨2, by decide⟩,
    k := ⟨4, by decide⟩ }

def prototypeValid : ValidRowPayload :=
  { c := ⟨196, by decide⟩
    classIndex := ⟨267, by decide⟩
    canonicalB := ⟨61, by decide⟩
    canonicalC := ⟨81, by decide⟩
    y := GF25.ofNat 13
    z := GF25.ofNat 21
    legalCount := 32
    orbitSize := 400 }

end Q25ResidualCoverPrototype
end RelativeConicArcs
