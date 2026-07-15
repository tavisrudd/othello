import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_112_213 : RowResult ⟨112, by decide⟩ ⟨213, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_112_214 : RowResult ⟨112, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_112_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_112_215 : RowResult ⟨112, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_112_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_112_216 : RowResult ⟨112, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_112_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_112_217 : RowResult ⟨112, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_112_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 1 4 7)

theorem row_112_218 : RowResult ⟨112, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_112_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 2 5 6)

theorem row_112_219 : RowResult ⟨112, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_112_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 2 4 6)

theorem row_112_220 : RowResult ⟨112, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_112_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_112_221 : RowResult ⟨112, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_112_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_112_222 : RowResult ⟨112, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_112_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 2 4 7)

theorem row_112_223 : RowResult ⟨112, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_112_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
