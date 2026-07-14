import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_197_238 : RowResult ⟨197, by decide⟩ ⟨238, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_197_239 : RowResult ⟨197, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_197_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_197_240 : RowResult ⟨197, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_197_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_197_241 : RowResult ⟨197, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_197_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_197_242 : RowResult ⟨197, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_197_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_197_243 : RowResult ⟨197, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_197_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 2 5 7)

theorem row_197_244 : RowResult ⟨197, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_197_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_197_245 : RowResult ⟨197, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_197_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_197_246 : RowResult ⟨197, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_197_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_197_247 : RowResult ⟨197, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_197_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
