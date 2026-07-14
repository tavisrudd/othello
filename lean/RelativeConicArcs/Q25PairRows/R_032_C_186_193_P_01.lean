import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_32_186 : RowResult ⟨32, by decide⟩ ⟨186, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_32_187 : RowResult ⟨32, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_32_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_32_188 : RowResult ⟨32, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_32_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_32_189 : RowResult ⟨32, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_32_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 2 5 7)

theorem row_32_190 : RowResult ⟨32, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_32_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_191 : RowResult ⟨32, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_32_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_192 : RowResult ⟨32, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_32_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_193 : RowResult ⟨32, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_32_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
