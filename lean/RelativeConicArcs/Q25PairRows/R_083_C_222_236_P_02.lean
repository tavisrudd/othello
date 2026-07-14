import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_83_222 : RowResult ⟨83, by decide⟩ ⟨222, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_83_223 : RowResult ⟨83, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_83_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 1 4 7)

theorem row_83_224 : RowResult ⟨83, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_83_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_83_225 : RowResult ⟨83, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_83_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_83_226 : RowResult ⟨83, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_83_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_83_227 : RowResult ⟨83, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_83_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_83_228 : RowResult ⟨83, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_83_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_83_229 : RowResult ⟨83, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_83_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_83_230 : RowResult ⟨83, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_83_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_83_231 : RowResult ⟨83, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_83_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_83_232 : RowResult ⟨83, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_83_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 4 5 6)

theorem row_83_233 : RowResult ⟨83, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_83_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 1 4 6)

theorem row_83_234 : RowResult ⟨83, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_83_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_83_235 : RowResult ⟨83, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_83_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_83_236 : RowResult ⟨83, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_83_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
