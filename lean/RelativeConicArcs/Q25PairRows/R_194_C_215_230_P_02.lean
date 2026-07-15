import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_194_215 : RowResult ⟨194, by decide⟩ ⟨215, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_194_216 : RowResult ⟨194, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_194_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_194_217 : RowResult ⟨194, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_194_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 2 4 7)

theorem row_194_218 : RowResult ⟨194, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_194_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_194_219 : RowResult ⟨194, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_194_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 1 4 6)

theorem row_194_220 : RowResult ⟨194, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_194_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_194_221 : RowResult ⟨194, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_194_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_194_222 : RowResult ⟨194, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_194_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_194_223 : RowResult ⟨194, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_194_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 4 5 6)

theorem row_194_224 : RowResult ⟨194, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_194_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_194_225 : RowResult ⟨194, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_194_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_194_226 : RowResult ⟨194, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_194_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_194_227 : RowResult ⟨194, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_194_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_194_228 : RowResult ⟨194, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_194_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_194_229 : RowResult ⟨194, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_194_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_194_230 : RowResult ⟨194, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_194_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
