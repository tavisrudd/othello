import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_60_234 : RowResult ⟨60, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_60_235 : RowResult ⟨60, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_60_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 1 4 6)

theorem row_60_236 : RowResult ⟨60, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_60_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_60_237 : RowResult ⟨60, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_60_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_60_238 : RowResult ⟨60, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_60_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_60_239 : RowResult ⟨60, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_60_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_60_240 : RowResult ⟨60, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_60_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 4 7)

theorem row_60_241 : RowResult ⟨60, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_60_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_60_242 : RowResult ⟨60, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_60_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 2 5 6)

theorem row_60_243 : RowResult ⟨60, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_60_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
