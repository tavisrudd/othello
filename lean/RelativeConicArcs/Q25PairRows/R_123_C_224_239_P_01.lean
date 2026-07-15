import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_123_224 : RowResult ⟨123, by decide⟩ ⟨224, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_123_225 : RowResult ⟨123, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_123_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_123_226 : RowResult ⟨123, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_123_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_123_227 : RowResult ⟨123, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_123_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_123_228 : RowResult ⟨123, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_123_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_123_229 : RowResult ⟨123, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_123_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_123_230 : RowResult ⟨123, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_123_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_123_231 : RowResult ⟨123, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_123_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 2 5 6)

theorem row_123_232 : RowResult ⟨123, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_123_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨218, by decide⟩, by decide⟩

theorem row_123_233 : RowResult ⟨123, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_123_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 1 4 7)

theorem row_123_234 : RowResult ⟨123, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_123_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 4 6)

theorem row_123_235 : RowResult ⟨123, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_123_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_123_236 : RowResult ⟨123, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_123_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_123_237 : RowResult ⟨123, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_123_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_123_238 : RowResult ⟨123, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_123_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_123_239 : RowResult ⟨123, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_123_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
