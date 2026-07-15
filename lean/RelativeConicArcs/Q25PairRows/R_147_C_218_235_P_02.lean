import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_147_218 : RowResult ⟨147, by decide⟩ ⟨218, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_147_219 : RowResult ⟨147, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_147_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_147_220 : RowResult ⟨147, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_147_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_147_221 : RowResult ⟨147, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_147_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 2 4 6)

theorem row_147_222 : RowResult ⟨147, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_147_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 1 4 6)

theorem row_147_223 : RowResult ⟨147, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_147_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 2 4 7)

theorem row_147_224 : RowResult ⟨147, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_147_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_147_225 : RowResult ⟨147, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_147_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_147_226 : RowResult ⟨147, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_147_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_147_227 : RowResult ⟨147, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_147_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_147_228 : RowResult ⟨147, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_147_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_147_229 : RowResult ⟨147, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_147_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_147_230 : RowResult ⟨147, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_147_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_147_231 : RowResult ⟨147, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_147_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_147_232 : RowResult ⟨147, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_147_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 4 7)

theorem row_147_233 : RowResult ⟨147, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_147_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_147_234 : RowResult ⟨147, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_147_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨218, by decide⟩, by decide⟩

theorem row_147_235 : RowResult ⟨147, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_147_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
