import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_112_224 : RowResult ⟨112, by decide⟩ ⟨224, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨157, by decide⟩, by decide⟩

theorem row_112_225 : RowResult ⟨112, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_112_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_112_226 : RowResult ⟨112, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_112_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_112_227 : RowResult ⟨112, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_112_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_112_228 : RowResult ⟨112, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_112_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_112_229 : RowResult ⟨112, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_112_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_112_230 : RowResult ⟨112, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_112_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_112_231 : RowResult ⟨112, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_112_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_112_232 : RowResult ⟨112, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_112_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_112_233 : RowResult ⟨112, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_112_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_112_234 : RowResult ⟨112, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_112_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_112_235 : RowResult ⟨112, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_112_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
