import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_92_207 : RowResult ⟨92, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_92_208 : RowResult ⟨92, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_92_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 2 4 6)

theorem row_92_209 : RowResult ⟨92, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_92_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_92_210 : RowResult ⟨92, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_92_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_92_211 : RowResult ⟨92, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_92_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_92_212 : RowResult ⟨92, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_92_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 1 4 7)

theorem row_92_213 : RowResult ⟨92, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_92_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_92_214 : RowResult ⟨92, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_92_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 5 6)

theorem row_92_215 : RowResult ⟨92, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_92_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_92_216 : RowResult ⟨92, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_92_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_92_217 : RowResult ⟨92, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_92_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 1 4 6)

theorem row_92_218 : RowResult ⟨92, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_92_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
