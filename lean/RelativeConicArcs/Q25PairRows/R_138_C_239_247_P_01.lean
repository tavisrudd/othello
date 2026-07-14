import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_138_239 : RowResult ⟨138, by decide⟩ ⟨239, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_138_240 : RowResult ⟨138, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_138_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_138_241 : RowResult ⟨138, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_138_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨167, by decide⟩, by decide⟩

theorem row_138_242 : RowResult ⟨138, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_138_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_138_243 : RowResult ⟨138, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_138_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 4 7)

theorem row_138_244 : RowResult ⟨138, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_138_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_138_245 : RowResult ⟨138, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_138_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_138_246 : RowResult ⟨138, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_138_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_138_247 : RowResult ⟨138, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_138_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
