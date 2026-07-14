import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_98_232 : RowResult ⟨98, by decide⟩ ⟨232, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_98_233 : RowResult ⟨98, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_98_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 1 4 7)

theorem row_98_234 : RowResult ⟨98, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_98_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_98_235 : RowResult ⟨98, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_98_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_98_236 : RowResult ⟨98, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_98_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_98_237 : RowResult ⟨98, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_98_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_98_238 : RowResult ⟨98, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_98_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_98_239 : RowResult ⟨98, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_98_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
