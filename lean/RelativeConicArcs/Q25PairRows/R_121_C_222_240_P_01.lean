import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_121_222 : RowResult ⟨121, by decide⟩ ⟨222, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_121_223 : RowResult ⟨121, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_121_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 2 5 6)

theorem row_121_224 : RowResult ⟨121, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_121_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 4 5 6)

theorem row_121_225 : RowResult ⟨121, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_121_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_121_226 : RowResult ⟨121, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_121_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_121_227 : RowResult ⟨121, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_121_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_121_228 : RowResult ⟨121, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_121_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_121_229 : RowResult ⟨121, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_121_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_121_230 : RowResult ⟨121, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_121_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_121_231 : RowResult ⟨121, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_121_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 1 4 7)

theorem row_121_232 : RowResult ⟨121, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_121_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 5 6)

theorem row_121_233 : RowResult ⟨121, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_121_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_121_234 : RowResult ⟨121, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_121_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_121_235 : RowResult ⟨121, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_121_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_121_236 : RowResult ⟨121, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_121_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 5 7)

theorem row_121_237 : RowResult ⟨121, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_121_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_121_238 : RowResult ⟨121, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_121_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 4 7)

theorem row_121_239 : RowResult ⟨121, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_121_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_121_240 : RowResult ⟨121, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_121_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
