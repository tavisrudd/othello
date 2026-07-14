import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_141_231 : RowResult ⟨141, by decide⟩ ⟨231, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_141_232 : RowResult ⟨141, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_141_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_141_233 : RowResult ⟨141, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_141_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_141_234 : RowResult ⟨141, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_141_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 4 6)

theorem row_141_235 : RowResult ⟨141, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_141_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_141_236 : RowResult ⟨141, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_141_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 4 7)

theorem row_141_237 : RowResult ⟨141, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_141_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_141_238 : RowResult ⟨141, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_141_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_141_239 : RowResult ⟨141, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_141_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
