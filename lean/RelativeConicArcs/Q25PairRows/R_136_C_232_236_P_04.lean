import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_136_232 : RowResult ⟨136, by decide⟩ ⟨232, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_136_233 : RowResult ⟨136, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_136_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_136_234 : RowResult ⟨136, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_136_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_136_235 : RowResult ⟨136, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_136_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_136_236 : RowResult ⟨136, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_136_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
