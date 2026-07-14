import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_181_233 : RowResult ⟨181, by decide⟩ ⟨233, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_181_234 : RowResult ⟨181, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_181_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 4 5 6)

theorem row_181_235 : RowResult ⟨181, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_181_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_181_236 : RowResult ⟨181, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_181_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_181_237 : RowResult ⟨181, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_181_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_181_238 : RowResult ⟨181, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_181_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_181_239 : RowResult ⟨181, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_181_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_181_240 : RowResult ⟨181, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_181_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 2 4 6)

theorem row_181_241 : RowResult ⟨181, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_181_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
