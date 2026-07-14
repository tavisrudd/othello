import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_192_232 : RowResult ⟨192, by decide⟩ ⟨232, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_192_233 : RowResult ⟨192, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_192_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_192_234 : RowResult ⟨192, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_192_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_192_235 : RowResult ⟨192, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_192_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_192_236 : RowResult ⟨192, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_192_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_192_237 : RowResult ⟨192, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_192_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 4 7)

theorem row_192_238 : RowResult ⟨192, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_192_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_192_239 : RowResult ⟨192, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_192_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
