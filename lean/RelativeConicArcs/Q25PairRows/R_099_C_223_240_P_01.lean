import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_99_223 : RowResult ⟨99, by decide⟩ ⟨223, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_99_224 : RowResult ⟨99, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_99_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 1 4 6)

theorem row_99_225 : RowResult ⟨99, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_99_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_99_226 : RowResult ⟨99, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_99_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_99_227 : RowResult ⟨99, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_99_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_99_228 : RowResult ⟨99, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_99_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_99_229 : RowResult ⟨99, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_99_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_99_230 : RowResult ⟨99, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_99_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_99_231 : RowResult ⟨99, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_99_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_99_232 : RowResult ⟨99, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_99_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 4 7)

theorem row_99_233 : RowResult ⟨99, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_99_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_99_234 : RowResult ⟨99, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_99_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 1 4 7)

theorem row_99_235 : RowResult ⟨99, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_99_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 4 6)

theorem row_99_236 : RowResult ⟨99, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_99_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨218, by decide⟩, by decide⟩

theorem row_99_237 : RowResult ⟨99, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_99_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_99_238 : RowResult ⟨99, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_99_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 5 7)

theorem row_99_239 : RowResult ⟨99, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_99_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_99_240 : RowResult ⟨99, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_99_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
