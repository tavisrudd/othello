import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_161_217 : RowResult ⟨161, by decide⟩ ⟨217, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_161_218 : RowResult ⟨161, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_161_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_161_219 : RowResult ⟨161, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_161_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 2 5 6)

theorem row_161_220 : RowResult ⟨161, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_161_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_161_221 : RowResult ⟨161, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_161_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_161_222 : RowResult ⟨161, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_161_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 2 5 7)

theorem row_161_223 : RowResult ⟨161, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_161_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 2 4 6)

theorem row_161_224 : RowResult ⟨161, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_161_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_161_225 : RowResult ⟨161, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_161_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_161_226 : RowResult ⟨161, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_161_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_161_227 : RowResult ⟨161, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_161_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_161_228 : RowResult ⟨161, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_161_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_161_229 : RowResult ⟨161, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_161_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_161_230 : RowResult ⟨161, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_161_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_161_231 : RowResult ⟨161, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_161_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_161_232 : RowResult ⟨161, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_161_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 4 6)

theorem row_161_233 : RowResult ⟨161, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_161_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
