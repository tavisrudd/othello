import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_59_217 : RowResult ⟨59, by decide⟩ ⟨217, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_59_218 : RowResult ⟨59, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_59_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_59_219 : RowResult ⟨59, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_59_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_59_220 : RowResult ⟨59, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_59_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_59_221 : RowResult ⟨59, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_59_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_59_222 : RowResult ⟨59, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_59_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_59_223 : RowResult ⟨59, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_59_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 2 5 6)

theorem row_59_224 : RowResult ⟨59, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_59_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 1 4 7)

theorem row_59_225 : RowResult ⟨59, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_59_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_59_226 : RowResult ⟨59, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_59_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_59_227 : RowResult ⟨59, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_59_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_59_228 : RowResult ⟨59, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_59_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_59_229 : RowResult ⟨59, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_59_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_59_230 : RowResult ⟨59, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_59_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_59_231 : RowResult ⟨59, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_59_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 2 4 7)

theorem row_59_232 : RowResult ⟨59, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_59_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 5 6)

theorem row_59_233 : RowResult ⟨59, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_59_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_59_234 : RowResult ⟨59, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_59_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
