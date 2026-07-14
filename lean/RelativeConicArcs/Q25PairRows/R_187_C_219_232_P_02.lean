import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_187_219 : RowResult ⟨187, by decide⟩ ⟨219, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_187_220 : RowResult ⟨187, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_187_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_187_221 : RowResult ⟨187, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_187_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_187_222 : RowResult ⟨187, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_187_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 2 5 6)

theorem row_187_223 : RowResult ⟨187, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_187_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_187_224 : RowResult ⟨187, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_187_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_187_225 : RowResult ⟨187, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_187_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_187_226 : RowResult ⟨187, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_187_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_187_227 : RowResult ⟨187, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_187_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_187_228 : RowResult ⟨187, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_187_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_187_229 : RowResult ⟨187, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_187_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_187_230 : RowResult ⟨187, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_187_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_187_231 : RowResult ⟨187, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_187_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_187_232 : RowResult ⟨187, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_187_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
