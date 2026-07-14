import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_224_225 : RowResult ⟨224, by decide⟩ ⟨225, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_224_226 : RowResult ⟨224, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_224_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_224_227 : RowResult ⟨224, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_224_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_224_228 : RowResult ⟨224, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_224_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_224_229 : RowResult ⟨224, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_224_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_224_230 : RowResult ⟨224, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_224_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_224_231 : RowResult ⟨224, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_224_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_224_232 : RowResult ⟨224, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_224_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 5 7)

theorem row_224_233 : RowResult ⟨224, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_224_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_224_234 : RowResult ⟨224, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_224_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 1 4 7)

theorem row_224_235 : RowResult ⟨224, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_224_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 5 6)

theorem row_224_236 : RowResult ⟨224, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_224_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_224_237 : RowResult ⟨224, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_224_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_224_238 : RowResult ⟨224, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_224_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_224_239 : RowResult ⟨224, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_224_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_224_240 : RowResult ⟨224, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_224_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
