import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_113_207 : RowResult ⟨113, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_113_208 : RowResult ⟨113, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_113_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_113_209 : RowResult ⟨113, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_113_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_113_210 : RowResult ⟨113, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_113_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_113_211 : RowResult ⟨113, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_113_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 2 5 7)

theorem row_113_212 : RowResult ⟨113, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_113_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 4 5 6)

theorem row_113_213 : RowResult ⟨113, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_113_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
