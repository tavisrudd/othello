import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_66_240 : RowResult ⟨66, by decide⟩ ⟨240, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_66_241 : RowResult ⟨66, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_66_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 4 6)

theorem row_66_242 : RowResult ⟨66, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_66_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_66_243 : RowResult ⟨66, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_66_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_66_244 : RowResult ⟨66, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_66_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_66_245 : RowResult ⟨66, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_66_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_66_246 : RowResult ⟨66, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_66_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_66_247 : RowResult ⟨66, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_66_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 2 4 7)

theorem row_66_248 : RowResult ⟨66, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_66_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨40, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
