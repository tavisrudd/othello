import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_36_231 : RowResult ⟨36, by decide⟩ ⟨231, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_36_232 : RowResult ⟨36, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_36_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_36_233 : RowResult ⟨36, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_36_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_36_234 : RowResult ⟨36, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_36_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_36_235 : RowResult ⟨36, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_36_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 4 5 6)

theorem row_36_236 : RowResult ⟨36, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_36_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
