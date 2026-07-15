import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_49_223 : RowResult ⟨49, by decide⟩ ⟨223, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_49_224 : RowResult ⟨49, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_49_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 1 4 6)

theorem row_49_225 : RowResult ⟨49, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_49_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_49_226 : RowResult ⟨49, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_49_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_49_227 : RowResult ⟨49, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_49_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_49_228 : RowResult ⟨49, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_49_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_49_229 : RowResult ⟨49, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_49_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_49_230 : RowResult ⟨49, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_49_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_49_231 : RowResult ⟨49, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_49_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_49_232 : RowResult ⟨49, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_49_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_49_233 : RowResult ⟨49, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_49_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨63, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_49_234 : RowResult ⟨49, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_49_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 1 4 7)

theorem row_49_235 : RowResult ⟨49, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_49_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_49_236 : RowResult ⟨49, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_49_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 4 6)

theorem row_49_237 : RowResult ⟨49, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_49_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
