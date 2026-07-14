import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_112_236 : RowResult ⟨112, by decide⟩ ⟨236, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_112_237 : RowResult ⟨112, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_112_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 4 6)

theorem row_112_238 : RowResult ⟨112, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_112_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_112_239 : RowResult ⟨112, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_112_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_112_240 : RowResult ⟨112, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_112_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 2 5 7)

theorem row_112_241 : RowResult ⟨112, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_112_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_112_242 : RowResult ⟨112, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_112_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 4 7)

theorem row_112_243 : RowResult ⟨112, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_112_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_112_244 : RowResult ⟨112, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_112_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_112_245 : RowResult ⟨112, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_112_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_112_246 : RowResult ⟨112, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_112_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 4 5 6)

theorem row_112_247 : RowResult ⟨112, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_112_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
