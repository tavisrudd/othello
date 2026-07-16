import RelativeConicArcs.Q25ResidualCoverPrototype.Data

namespace RelativeConicArcs
namespace Q25ResidualCoverPrototype

open Q25Coordinates Q25PairCertificate Q25Normalization Q25ResidualAction
  Q25ResidualCoverData FiniteFields

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

theorem prototypeValid_transport : prototypeValid.TransportValid ⟨40, by decide⟩ := by
  unfold ValidRowPayload.TransportValid prototypeValid
  refine ⟨by decide, by decide, ?_⟩
  let sourceA := orbitCodeOfNumber ⟨5, by decide⟩
  let sourceB := orbitCodeOfNumber ⟨40, by decide⟩
  let sourceC := orbitCodeOfNumber ⟨196, by decide⟩
  let targetA := orbitCodeOfNumber ⟨5, by decide⟩
  let targetB := orbitCodeOfNumber ⟨61, by decide⟩
  let targetC := orbitCodeOfNumber ⟨81, by decide⟩
  let forwardIndex : Fin 8 → Fin 8 := ![0, 1, 7, 6, 4, 5, 2, 3]
  let inverseIndex : Fin 8 → Fin 8 := ![0, 1, 6, 7, 4, 5, 3, 2]
  have point_transport (i : Fin 8) :
      residualApply (GF25.ofNat 13) (GF25.ofNat 21)
          (configPoint sourceA sourceB sourceC i) =
        configPoint targetA targetB targetC (forwardIndex i) := by
    fin_cases i <;>
      simp [sourceA, sourceB, sourceC, targetA, targetB, targetC, forwardIndex,
        configPoint, orbitCodeOfNumber, codeFin5, codeFin2, smallNonfixed, orbitIdx,
        Q25Coordinates.conjIdx, Q25Coordinates.conj, residualApply,
        Q25Normalization.shift, Q25Normalization.scale, Q25Normalization.realPart,
        Q25Normalization.imagPart, GF25.ofNat, GF25.encode] <;> decide
  have index_roundtrip (i : Fin 8) : forwardIndex (inverseIndex i) = i := by
    fin_cases i <;> rfl
  apply Finset.Subset.antisymm
  · intro q hq
    rcases Finset.mem_image.mp hq with ⟨p, hp, rfl⟩
    rcases exists_configPoint_of_mem_rowConfig _ _ hp with ⟨i, rfl⟩
    rw [point_transport]
    exact configPoint_mem targetA targetB targetC (forwardIndex i)
  · intro q hq
    change q ∈ rowConfig ⟨61, by decide⟩ ⟨81, by decide⟩ at hq
    rcases exists_configPoint_of_mem_rowConfig _ _ hq with ⟨i, rfl⟩
    apply Finset.mem_image.mpr
    refine ⟨configPoint sourceA sourceB sourceC (inverseIndex i),
      configPoint_mem sourceA sourceB sourceC (inverseIndex i), ?_⟩
    rw [point_transport, index_roundtrip]

end Q25ResidualCoverPrototype
end RelativeConicArcs
