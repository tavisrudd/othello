import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_46_218 : RowResult ⟨46, by decide⟩ ⟨218, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_46_219 : RowResult ⟨46, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_46_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 2 5 7)

theorem row_46_220 : RowResult ⟨46, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_46_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_46_221 : RowResult ⟨46, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_46_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 1 4 6)

theorem row_46_222 : RowResult ⟨46, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_46_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_46_223 : RowResult ⟨46, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_46_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_46_224 : RowResult ⟨46, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_46_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_46_225 : RowResult ⟨46, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_46_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_46_226 : RowResult ⟨46, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_46_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_46_227 : RowResult ⟨46, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_46_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_46_228 : RowResult ⟨46, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_46_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_46_229 : RowResult ⟨46, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_46_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_46_230 : RowResult ⟨46, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_46_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_46_231 : RowResult ⟨46, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_46_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 1 4 7)

theorem row_46_232 : RowResult ⟨46, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_46_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_46_233 : RowResult ⟨46, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_46_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 4 6)

theorem row_46_234 : RowResult ⟨46, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_46_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 4 7)

theorem row_46_235 : RowResult ⟨46, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_46_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
