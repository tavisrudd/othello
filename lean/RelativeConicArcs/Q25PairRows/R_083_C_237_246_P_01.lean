import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_83_237 : RowResult ⟨83, by decide⟩ ⟨237, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_83_238 : RowResult ⟨83, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_83_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_83_239 : RowResult ⟨83, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_83_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_83_240 : RowResult ⟨83, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_83_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 2 4 7)

theorem row_83_241 : RowResult ⟨83, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_83_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_83_242 : RowResult ⟨83, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_83_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_83_243 : RowResult ⟨83, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_83_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_83_244 : RowResult ⟨83, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_83_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_83_245 : RowResult ⟨83, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_83_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_83_246 : RowResult ⟨83, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_83_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
