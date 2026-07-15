import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_133_234 : RowResult ⟨133, by decide⟩ ⟨234, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 4 5 6)

theorem row_133_235 : RowResult ⟨133, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_133_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_133_236 : RowResult ⟨133, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_133_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_133_237 : RowResult ⟨133, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_133_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_133_238 : RowResult ⟨133, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_133_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_133_239 : RowResult ⟨133, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_133_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_133_240 : RowResult ⟨133, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_133_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_133_241 : RowResult ⟨133, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_133_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
