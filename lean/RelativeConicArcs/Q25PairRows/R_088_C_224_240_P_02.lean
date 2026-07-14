import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_88_224 : RowResult ⟨88, by decide⟩ ⟨224, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_88_225 : RowResult ⟨88, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_88_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_88_226 : RowResult ⟨88, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_88_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_88_227 : RowResult ⟨88, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_88_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_88_228 : RowResult ⟨88, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_88_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_88_229 : RowResult ⟨88, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_88_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_88_230 : RowResult ⟨88, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_88_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_88_231 : RowResult ⟨88, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_88_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_88_232 : RowResult ⟨88, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_88_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_88_233 : RowResult ⟨88, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_88_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 5 7)

theorem row_88_234 : RowResult ⟨88, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_88_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_88_235 : RowResult ⟨88, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_88_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_236 : RowResult ⟨88, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_88_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 4 5 6)

theorem row_88_237 : RowResult ⟨88, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_88_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_88_238 : RowResult ⟨88, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_88_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 4 6)

theorem row_88_239 : RowResult ⟨88, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_88_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_88_240 : RowResult ⟨88, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_88_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
