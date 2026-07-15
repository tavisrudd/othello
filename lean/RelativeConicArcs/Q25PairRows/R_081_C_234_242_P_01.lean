import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_81_234 : RowResult ⟨81, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_81_235 : RowResult ⟨81, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_81_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 4 7)

theorem row_81_236 : RowResult ⟨81, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_81_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 5 6)

theorem row_81_237 : RowResult ⟨81, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_81_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_81_238 : RowResult ⟨81, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_81_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_81_239 : RowResult ⟨81, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_81_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_81_240 : RowResult ⟨81, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_81_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_81_241 : RowResult ⟨81, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_81_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_81_242 : RowResult ⟨81, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_81_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨44, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
