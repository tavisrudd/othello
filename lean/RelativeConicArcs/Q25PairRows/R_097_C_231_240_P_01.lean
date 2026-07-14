import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_97_231 : RowResult ⟨97, by decide⟩ ⟨231, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_97_232 : RowResult ⟨97, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_97_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 4 7)

theorem row_97_233 : RowResult ⟨97, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_97_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_97_234 : RowResult ⟨97, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_97_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 4 6)

theorem row_97_235 : RowResult ⟨97, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_97_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_97_236 : RowResult ⟨97, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_97_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_97_237 : RowResult ⟨97, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_97_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_97_238 : RowResult ⟨97, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_97_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_97_239 : RowResult ⟨97, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_97_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_97_240 : RowResult ⟨97, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_97_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
