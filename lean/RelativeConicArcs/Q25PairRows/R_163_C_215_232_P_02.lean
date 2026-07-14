import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_163_215 : RowResult ⟨163, by decide⟩ ⟨215, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_163_216 : RowResult ⟨163, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_163_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 2 4 7)

theorem row_163_217 : RowResult ⟨163, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_163_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_163_218 : RowResult ⟨163, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_163_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 1 4 7)

theorem row_163_219 : RowResult ⟨163, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_163_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_163_220 : RowResult ⟨163, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_163_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_163_221 : RowResult ⟨163, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_163_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_163_222 : RowResult ⟨163, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_163_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_163_223 : RowResult ⟨163, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_163_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 2 5 6)

theorem row_163_224 : RowResult ⟨163, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_163_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 2 4 6)

theorem row_163_225 : RowResult ⟨163, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_163_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_163_226 : RowResult ⟨163, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_163_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_163_227 : RowResult ⟨163, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_163_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_163_228 : RowResult ⟨163, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_163_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_163_229 : RowResult ⟨163, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_163_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_163_230 : RowResult ⟨163, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_163_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_163_231 : RowResult ⟨163, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_163_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_163_232 : RowResult ⟨163, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_163_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
