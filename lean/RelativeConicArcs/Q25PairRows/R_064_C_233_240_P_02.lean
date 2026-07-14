import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_64_233 : RowResult ⟨64, by decide⟩ ⟨233, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_64_234 : RowResult ⟨64, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_64_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_64_235 : RowResult ⟨64, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_64_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 4 7)

theorem row_64_236 : RowResult ⟨64, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_64_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_64_237 : RowResult ⟨64, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_64_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_64_238 : RowResult ⟨64, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_64_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_64_239 : RowResult ⟨64, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_64_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 6)

theorem row_64_240 : RowResult ⟨64, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_64_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
