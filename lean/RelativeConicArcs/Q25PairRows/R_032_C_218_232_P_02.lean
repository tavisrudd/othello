import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_32_218 : RowResult ⟨32, by decide⟩ ⟨218, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_219 : RowResult ⟨32, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_32_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 4 5 6)

theorem row_32_220 : RowResult ⟨32, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_32_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_32_221 : RowResult ⟨32, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_32_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_222 : RowResult ⟨32, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_32_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 1 4 7)

theorem row_32_223 : RowResult ⟨32, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_32_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_32_224 : RowResult ⟨32, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_32_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_32_225 : RowResult ⟨32, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_32_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_32_226 : RowResult ⟨32, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_32_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_32_227 : RowResult ⟨32, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_32_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_32_228 : RowResult ⟨32, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_32_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_32_229 : RowResult ⟨32, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_32_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_32_230 : RowResult ⟨32, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_32_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_32_231 : RowResult ⟨32, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_32_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_32_232 : RowResult ⟨32, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_32_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
