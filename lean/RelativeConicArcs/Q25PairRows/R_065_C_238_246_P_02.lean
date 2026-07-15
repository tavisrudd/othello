import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_65_238 : RowResult ⟨65, by decide⟩ ⟨238, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_65_239 : RowResult ⟨65, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_65_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_65_240 : RowResult ⟨65, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_65_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 4 6)

theorem row_65_241 : RowResult ⟨65, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_65_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_65_242 : RowResult ⟨65, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_65_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_65_243 : RowResult ⟨65, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_65_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_65_244 : RowResult ⟨65, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_65_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨218, by decide⟩, by decide⟩

theorem row_65_245 : RowResult ⟨65, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_65_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_65_246 : RowResult ⟨65, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_65_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
