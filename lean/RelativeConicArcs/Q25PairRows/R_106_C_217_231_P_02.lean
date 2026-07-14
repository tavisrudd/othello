import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_106_217 : RowResult ⟨106, by decide⟩ ⟨217, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_106_218 : RowResult ⟨106, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_106_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_106_219 : RowResult ⟨106, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_106_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_106_220 : RowResult ⟨106, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_106_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_106_221 : RowResult ⟨106, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_106_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 1 4 7)

theorem row_106_222 : RowResult ⟨106, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_106_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_106_223 : RowResult ⟨106, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_106_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_106_224 : RowResult ⟨106, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_106_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_106_225 : RowResult ⟨106, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_106_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_106_226 : RowResult ⟨106, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_106_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_106_227 : RowResult ⟨106, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_106_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_106_228 : RowResult ⟨106, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_106_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_106_229 : RowResult ⟨106, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_106_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_106_230 : RowResult ⟨106, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_106_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_106_231 : RowResult ⟨106, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_106_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
