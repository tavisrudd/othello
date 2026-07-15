import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_148_207 : RowResult ⟨148, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_148_208 : RowResult ⟨148, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_148_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 1 4 7)

theorem row_148_209 : RowResult ⟨148, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_148_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_148_210 : RowResult ⟨148, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_148_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 2 4 6)

theorem row_148_211 : RowResult ⟨148, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_148_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_148_212 : RowResult ⟨148, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_148_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 4 5 6)

theorem row_148_213 : RowResult ⟨148, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_148_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_148_214 : RowResult ⟨148, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_148_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 5 6)

theorem row_148_215 : RowResult ⟨148, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_148_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_148_216 : RowResult ⟨148, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_148_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_148_217 : RowResult ⟨148, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_148_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
