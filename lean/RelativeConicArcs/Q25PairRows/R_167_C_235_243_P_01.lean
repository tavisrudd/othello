import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_167_235 : RowResult ⟨167, by decide⟩ ⟨235, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_167_236 : RowResult ⟨167, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_167_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_167_237 : RowResult ⟨167, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_167_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 4 7)

theorem row_167_238 : RowResult ⟨167, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_167_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_167_239 : RowResult ⟨167, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_167_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_167_240 : RowResult ⟨167, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_167_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_167_241 : RowResult ⟨167, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_167_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_167_242 : RowResult ⟨167, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_167_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 4 6)

theorem row_167_243 : RowResult ⟨167, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_167_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
