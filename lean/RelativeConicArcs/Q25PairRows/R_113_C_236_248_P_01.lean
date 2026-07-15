import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_113_236 : RowResult ⟨113, by decide⟩ ⟨236, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_113_237 : RowResult ⟨113, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_113_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 2 4 6)

theorem row_113_238 : RowResult ⟨113, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_113_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 4 6)

theorem row_113_239 : RowResult ⟨113, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_113_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_113_240 : RowResult ⟨113, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_113_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_113_241 : RowResult ⟨113, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_113_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_113_242 : RowResult ⟨113, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_113_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_113_243 : RowResult ⟨113, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_113_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 4 7)

theorem row_113_244 : RowResult ⟨113, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_113_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_113_245 : RowResult ⟨113, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_113_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_113_246 : RowResult ⟨113, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_113_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_113_247 : RowResult ⟨113, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_113_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 4 5 6)

theorem row_113_248 : RowResult ⟨113, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_113_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
