import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_182_235 : RowResult ⟨182, by decide⟩ ⟨235, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_182_236 : RowResult ⟨182, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_182_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_182_237 : RowResult ⟨182, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_182_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_182_238 : RowResult ⟨182, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_182_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 4 7)

theorem row_182_239 : RowResult ⟨182, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_182_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_182_240 : RowResult ⟨182, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_182_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_182_241 : RowResult ⟨182, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_182_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_182_242 : RowResult ⟨182, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_182_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
