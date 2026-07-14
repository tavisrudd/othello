import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_214_215 : RowResult ⟨214, by decide⟩ ⟨215, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 0 4 6)

theorem row_214_216 : RowResult ⟨214, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_214_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 0 4 6)

theorem row_214_217 : RowResult ⟨214, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_214_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 0 4 6)

theorem row_214_218 : RowResult ⟨214, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_214_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 0 4 6)

theorem row_214_219 : RowResult ⟨214, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_214_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 0 4 6)

theorem row_214_220 : RowResult ⟨214, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_214_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 0 4 6)

theorem row_214_221 : RowResult ⟨214, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_214_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 0 4 6)

theorem row_214_222 : RowResult ⟨214, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_214_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 0 4 6)

theorem row_214_223 : RowResult ⟨214, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_214_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 0 4 6)

theorem row_214_224 : RowResult ⟨214, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_214_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 0 4 6)

theorem row_214_225 : RowResult ⟨214, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_214_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_214_226 : RowResult ⟨214, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_214_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_214_227 : RowResult ⟨214, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_214_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_214_228 : RowResult ⟨214, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_214_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_214_229 : RowResult ⟨214, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_214_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_214_230 : RowResult ⟨214, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_214_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_214_231 : RowResult ⟨214, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_214_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_214_232 : RowResult ⟨214, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_214_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨167, by decide⟩, by decide⟩

theorem row_214_233 : RowResult ⟨214, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_214_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_214_234 : RowResult ⟨214, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_214_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_214_235 : RowResult ⟨214, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_214_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨167, by decide⟩, by decide⟩

theorem row_214_236 : RowResult ⟨214, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_214_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 5 6)

theorem row_214_237 : RowResult ⟨214, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_214_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
