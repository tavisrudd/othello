import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_156_233 : RowResult ⟨156, by decide⟩ ⟨233, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_156_234 : RowResult ⟨156, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_156_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_156_235 : RowResult ⟨156, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_156_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_156_236 : RowResult ⟨156, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_156_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_156_237 : RowResult ⟨156, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_156_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 4 5 6)

theorem row_156_238 : RowResult ⟨156, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_156_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_156_239 : RowResult ⟨156, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_156_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_156_240 : RowResult ⟨156, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_156_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
