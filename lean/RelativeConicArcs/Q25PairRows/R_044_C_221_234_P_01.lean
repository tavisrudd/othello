import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_44_221 : RowResult ⟨44, by decide⟩ ⟨221, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_222 : RowResult ⟨44, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_44_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_223 : RowResult ⟨44, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_44_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 2 4 6)

theorem row_44_224 : RowResult ⟨44, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_44_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_44_225 : RowResult ⟨44, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_44_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_44_226 : RowResult ⟨44, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_44_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_44_227 : RowResult ⟨44, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_44_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_44_228 : RowResult ⟨44, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_44_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_44_229 : RowResult ⟨44, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_44_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_44_230 : RowResult ⟨44, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_44_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_44_231 : RowResult ⟨44, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_44_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_232 : RowResult ⟨44, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_44_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 4 6)

theorem row_44_233 : RowResult ⟨44, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_44_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_234 : RowResult ⟨44, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_44_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
