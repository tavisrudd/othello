import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_162_234 : RowResult ⟨162, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_162_235 : RowResult ⟨162, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_162_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_162_236 : RowResult ⟨162, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_162_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_162_237 : RowResult ⟨162, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_162_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 4 6)

theorem row_162_238 : RowResult ⟨162, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_162_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_162_239 : RowResult ⟨162, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_162_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_162_240 : RowResult ⟨162, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_162_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 2 4 6)

theorem row_162_241 : RowResult ⟨162, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_162_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_162_242 : RowResult ⟨162, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_162_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 4 7)

theorem row_162_243 : RowResult ⟨162, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_162_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_162_244 : RowResult ⟨162, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_162_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 2 4 7)

theorem row_162_245 : RowResult ⟨162, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_162_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
