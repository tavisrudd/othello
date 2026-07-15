import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_197_224 : RowResult ⟨197, by decide⟩ ⟨224, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_197_225 : RowResult ⟨197, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_197_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_197_226 : RowResult ⟨197, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_197_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_197_227 : RowResult ⟨197, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_197_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_197_228 : RowResult ⟨197, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_197_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_197_229 : RowResult ⟨197, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_197_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_197_230 : RowResult ⟨197, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_197_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_197_231 : RowResult ⟨197, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_197_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 2 5 6)

theorem row_197_232 : RowResult ⟨197, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_197_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 4 7)

theorem row_197_233 : RowResult ⟨197, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_197_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_197_234 : RowResult ⟨197, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_197_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_197_235 : RowResult ⟨197, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_197_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_197_236 : RowResult ⟨197, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_197_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_197_237 : RowResult ⟨197, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_197_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
