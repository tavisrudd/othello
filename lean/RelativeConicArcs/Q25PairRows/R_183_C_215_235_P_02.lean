import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_183_215 : RowResult ⟨183, by decide⟩ ⟨215, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_183_216 : RowResult ⟨183, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_183_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 4 5 6)

theorem row_183_217 : RowResult ⟨183, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_183_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_183_218 : RowResult ⟨183, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_183_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 2 5 6)

theorem row_183_219 : RowResult ⟨183, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_183_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_183_220 : RowResult ⟨183, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_183_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_183_221 : RowResult ⟨183, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_183_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_183_222 : RowResult ⟨183, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_183_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_183_223 : RowResult ⟨183, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_183_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 1 4 7)

theorem row_183_224 : RowResult ⟨183, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_183_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 2 4 7)

theorem row_183_225 : RowResult ⟨183, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_183_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_183_226 : RowResult ⟨183, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_183_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_183_227 : RowResult ⟨183, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_183_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_183_228 : RowResult ⟨183, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_183_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_183_229 : RowResult ⟨183, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_183_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_183_230 : RowResult ⟨183, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_183_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_183_231 : RowResult ⟨183, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_183_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 4 5 6)

theorem row_183_232 : RowResult ⟨183, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_183_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 4 7)

theorem row_183_233 : RowResult ⟨183, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_183_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 1 4 6)

theorem row_183_234 : RowResult ⟨183, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_183_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_183_235 : RowResult ⟨183, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_183_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
