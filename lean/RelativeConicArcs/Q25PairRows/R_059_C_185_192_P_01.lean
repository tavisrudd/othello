import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_59_185 : RowResult ⟨59, by decide⟩ ⟨185, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_59_186 : RowResult ⟨59, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_59_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 4 5 6)

theorem row_59_187 : RowResult ⟨59, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_59_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_59_188 : RowResult ⟨59, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_59_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_59_189 : RowResult ⟨59, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_59_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_59_190 : RowResult ⟨59, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_59_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_59_191 : RowResult ⟨59, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_59_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_59_192 : RowResult ⟨59, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_59_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
