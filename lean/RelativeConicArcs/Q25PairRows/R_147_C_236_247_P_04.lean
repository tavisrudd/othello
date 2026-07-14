import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_147_236 : RowResult ⟨147, by decide⟩ ⟨236, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_147_237 : RowResult ⟨147, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_147_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_147_238 : RowResult ⟨147, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_147_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_147_239 : RowResult ⟨147, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_147_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_147_240 : RowResult ⟨147, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_147_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 2 4 6)

theorem row_147_241 : RowResult ⟨147, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_147_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_147_242 : RowResult ⟨147, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_147_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_147_243 : RowResult ⟨147, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_147_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_147_244 : RowResult ⟨147, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_147_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 2 4 7)

theorem row_147_245 : RowResult ⟨147, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_147_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_147_246 : RowResult ⟨147, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_147_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 4 5 6)

theorem row_147_247 : RowResult ⟨147, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_147_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
