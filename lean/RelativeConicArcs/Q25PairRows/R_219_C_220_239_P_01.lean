import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_219_220 : RowResult ⟨219, by decide⟩ ⟨220, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 0 4 6)

theorem row_219_221 : RowResult ⟨219, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_219_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 0 4 6)

theorem row_219_222 : RowResult ⟨219, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_219_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 0 4 6)

theorem row_219_223 : RowResult ⟨219, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_219_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 0 4 6)

theorem row_219_224 : RowResult ⟨219, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_219_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 0 4 6)

theorem row_219_225 : RowResult ⟨219, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_219_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_219_226 : RowResult ⟨219, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_219_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_219_227 : RowResult ⟨219, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_219_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_219_228 : RowResult ⟨219, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_219_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_219_229 : RowResult ⟨219, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_219_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_219_230 : RowResult ⟨219, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_219_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_219_231 : RowResult ⟨219, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_219_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_219_232 : RowResult ⟨219, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_219_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

theorem row_219_233 : RowResult ⟨219, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_219_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_219_234 : RowResult ⟨219, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_219_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 4 5 6)

theorem row_219_235 : RowResult ⟨219, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_219_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_219_236 : RowResult ⟨219, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_219_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

theorem row_219_237 : RowResult ⟨219, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_219_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_219_238 : RowResult ⟨219, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_219_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 5 6)

theorem row_219_239 : RowResult ⟨219, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_219_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
