import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_222_240 : RowResult ⟨222, by decide⟩ ⟨240, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_222_241 : RowResult ⟨222, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_222_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_222_242 : RowResult ⟨222, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_222_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 4 5 6)

theorem row_222_243 : RowResult ⟨222, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_222_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_222_244 : RowResult ⟨222, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_222_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_222_245 : RowResult ⟨222, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_222_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_222_246 : RowResult ⟨222, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_222_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨194, by decide⟩, by decide⟩

theorem row_222_247 : RowResult ⟨222, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_222_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 1 4 6)

theorem row_222_248 : RowResult ⟨222, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_222_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨186, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
