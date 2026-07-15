import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_119_236 : RowResult ⟨119, by decide⟩ ⟨236, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_119_237 : RowResult ⟨119, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_119_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_119_238 : RowResult ⟨119, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_119_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_119_239 : RowResult ⟨119, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_119_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 7)

theorem row_119_240 : RowResult ⟨119, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_119_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_119_241 : RowResult ⟨119, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_119_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_119_242 : RowResult ⟨119, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_119_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_119_243 : RowResult ⟨119, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_119_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 2 5 6)

theorem row_119_244 : RowResult ⟨119, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_119_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 4 6)

theorem row_119_245 : RowResult ⟨119, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_119_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
