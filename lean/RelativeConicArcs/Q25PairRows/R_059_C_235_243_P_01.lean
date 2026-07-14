import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_59_235 : RowResult ⟨59, by decide⟩ ⟨235, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_59_236 : RowResult ⟨59, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_59_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 5 7)

theorem row_59_237 : RowResult ⟨59, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_59_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 4 5 6)

theorem row_59_238 : RowResult ⟨59, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_59_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_59_239 : RowResult ⟨59, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_59_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_59_240 : RowResult ⟨59, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_59_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_59_241 : RowResult ⟨59, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_59_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_59_242 : RowResult ⟨59, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_59_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_59_243 : RowResult ⟨59, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_59_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
