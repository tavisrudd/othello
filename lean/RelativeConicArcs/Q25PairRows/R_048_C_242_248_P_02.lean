import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_48_242 : RowResult ⟨48, by decide⟩ ⟨242, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_48_243 : RowResult ⟨48, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_48_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_48_244 : RowResult ⟨48, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_48_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨217, by decide⟩, by decide⟩

theorem row_48_245 : RowResult ⟨48, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_48_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_48_246 : RowResult ⟨48, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_48_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 4 5 6)

theorem row_48_247 : RowResult ⟨48, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_48_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_48_248 : RowResult ⟨48, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_48_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
