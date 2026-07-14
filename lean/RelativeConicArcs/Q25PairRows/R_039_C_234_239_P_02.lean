import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_39_234 : RowResult ⟨39, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_39_235 : RowResult ⟨39, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_39_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_39_236 : RowResult ⟨39, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_39_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_39_237 : RowResult ⟨39, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_39_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_39_238 : RowResult ⟨39, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_39_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 4 5 6)

theorem row_39_239 : RowResult ⟨39, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_39_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
