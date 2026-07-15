import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_72_234 : RowResult ⟨72, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_72_235 : RowResult ⟨72, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_72_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_72_236 : RowResult ⟨72, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_72_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_72_237 : RowResult ⟨72, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_72_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 2 5 6)

theorem row_72_238 : RowResult ⟨72, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_72_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨217, by decide⟩, by decide⟩

theorem row_72_239 : RowResult ⟨72, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_72_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_72_240 : RowResult ⟨72, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_72_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 2 4 7)

theorem row_72_241 : RowResult ⟨72, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_72_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_72_242 : RowResult ⟨72, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_72_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
