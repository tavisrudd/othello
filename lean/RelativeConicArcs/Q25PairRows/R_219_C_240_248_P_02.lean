import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_219_240 : RowResult ⟨219, by decide⟩ ⟨240, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_219_241 : RowResult ⟨219, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_219_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 5 7)

theorem row_219_242 : RowResult ⟨219, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_219_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

theorem row_219_243 : RowResult ⟨219, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_219_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

theorem row_219_244 : RowResult ⟨219, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_219_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 4 6)

theorem row_219_245 : RowResult ⟨219, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_219_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_219_246 : RowResult ⟨219, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_219_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

theorem row_219_247 : RowResult ⟨219, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_219_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

theorem row_219_248 : RowResult ⟨219, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_219_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
