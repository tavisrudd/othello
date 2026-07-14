import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_194_231 : RowResult ⟨194, by decide⟩ ⟨231, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩, by decide⟩

theorem row_194_232 : RowResult ⟨194, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_194_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_194_233 : RowResult ⟨194, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_194_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_194_234 : RowResult ⟨194, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_194_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_194_235 : RowResult ⟨194, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_194_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 4 7)

theorem row_194_236 : RowResult ⟨194, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_194_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_194_237 : RowResult ⟨194, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_194_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
