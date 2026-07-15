import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_34_235 : RowResult ⟨34, by decide⟩ ⟨235, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 5 7)

theorem row_34_236 : RowResult ⟨34, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_34_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_34_237 : RowResult ⟨34, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_34_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_34_238 : RowResult ⟨34, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_34_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_34_239 : RowResult ⟨34, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_34_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_34_240 : RowResult ⟨34, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_34_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_34_241 : RowResult ⟨34, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_34_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_34_242 : RowResult ⟨34, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_34_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
