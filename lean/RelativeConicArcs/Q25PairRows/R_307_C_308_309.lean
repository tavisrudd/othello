import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_307_308 : RowResult ⟨307, by decide⟩ ⟨308, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨307, by decide⟩) (orbitCodeOfNumber ⟨308, by decide⟩) 0 1 4)

theorem row_307_309 : RowResult ⟨307, by decide⟩ ⟨309, by decide⟩ := by
  have _previous := row_307_308
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨307, by decide⟩) (orbitCodeOfNumber ⟨309, by decide⟩) 0 1 4)

end RelativeConicArcs.Q25PairCertificate
