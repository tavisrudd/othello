import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_143_215 : RowResult ⟨143, by decide⟩ ⟨215, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_216 : RowResult ⟨143, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_143_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_143_217 : RowResult ⟨143, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_143_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_218 : RowResult ⟨143, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_143_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 1 4 6)

theorem row_143_219 : RowResult ⟨143, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_143_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 2 4 6)

theorem row_143_220 : RowResult ⟨143, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_143_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_143_221 : RowResult ⟨143, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_143_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 4 5 6)

theorem row_143_222 : RowResult ⟨143, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_143_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 2 4 7)

theorem row_143_223 : RowResult ⟨143, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_143_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_143_224 : RowResult ⟨143, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_143_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 2 5 7)

theorem row_143_225 : RowResult ⟨143, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_143_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_143_226 : RowResult ⟨143, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_143_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_143_227 : RowResult ⟨143, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_143_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_143_228 : RowResult ⟨143, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_143_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_143_229 : RowResult ⟨143, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_143_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_143_230 : RowResult ⟨143, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_143_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_143_231 : RowResult ⟨143, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_143_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨167, by decide⟩, by decide⟩

theorem row_143_232 : RowResult ⟨143, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_143_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 5 7)

theorem row_143_233 : RowResult ⟨143, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_143_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
