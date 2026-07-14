import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_32_233 : RowResult ⟨32, by decide⟩ ⟨233, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_234 : RowResult ⟨32, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_32_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 4 5 6)

theorem row_32_235 : RowResult ⟨32, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_32_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_236 : RowResult ⟨32, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_32_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_32_237 : RowResult ⟨32, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_32_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 2 5 6)

theorem row_32_238 : RowResult ⟨32, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_32_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_32_239 : RowResult ⟨32, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_32_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_32_240 : RowResult ⟨32, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_32_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_241 : RowResult ⟨32, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_32_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
