import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_181_214 : RowResult ⟨181, by decide⟩ ⟨214, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_181_215 : RowResult ⟨181, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_181_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_181_216 : RowResult ⟨181, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_181_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 2 5 7)

theorem row_181_217 : RowResult ⟨181, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_181_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_181_218 : RowResult ⟨181, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_181_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_181_219 : RowResult ⟨181, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_181_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 4 5 6)

theorem row_181_220 : RowResult ⟨181, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_181_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_181_221 : RowResult ⟨181, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_181_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 1 4 7)

theorem row_181_222 : RowResult ⟨181, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_181_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_181_223 : RowResult ⟨181, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_181_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 2 4 7)

theorem row_181_224 : RowResult ⟨181, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_181_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 2 5 6)

theorem row_181_225 : RowResult ⟨181, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_181_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_181_226 : RowResult ⟨181, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_181_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_181_227 : RowResult ⟨181, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_181_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_181_228 : RowResult ⟨181, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_181_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_181_229 : RowResult ⟨181, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_181_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_181_230 : RowResult ⟨181, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_181_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_181_231 : RowResult ⟨181, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_181_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 1 4 6)

theorem row_181_232 : RowResult ⟨181, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_181_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
