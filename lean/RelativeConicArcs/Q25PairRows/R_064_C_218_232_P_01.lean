import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_64_218 : RowResult ⟨64, by decide⟩ ⟨218, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_64_219 : RowResult ⟨64, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_64_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 1 4 7)

theorem row_64_220 : RowResult ⟨64, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_64_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_64_221 : RowResult ⟨64, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_64_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_64_222 : RowResult ⟨64, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_64_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_64_223 : RowResult ⟨64, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_64_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_64_224 : RowResult ⟨64, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_64_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_64_225 : RowResult ⟨64, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_64_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_64_226 : RowResult ⟨64, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_64_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_64_227 : RowResult ⟨64, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_64_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_64_228 : RowResult ⟨64, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_64_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_64_229 : RowResult ⟨64, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_64_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_64_230 : RowResult ⟨64, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_64_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_64_231 : RowResult ⟨64, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_64_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 2 5 7)

theorem row_64_232 : RowResult ⟨64, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_64_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
