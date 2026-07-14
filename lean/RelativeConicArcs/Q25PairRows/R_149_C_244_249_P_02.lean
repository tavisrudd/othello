import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_149_244 : RowResult ⟨149, by decide⟩ ⟨244, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_149_245 : RowResult ⟨149, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_149_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_149_246 : RowResult ⟨149, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_149_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_149_247 : RowResult ⟨149, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_149_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_149_248 : RowResult ⟨149, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_149_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 4 5 6)

theorem row_149_249 : RowResult ⟨149, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_149_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
