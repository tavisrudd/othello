import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_47_187 : RowResult ⟨47, by decide⟩ ⟨187, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_188 : RowResult ⟨47, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_47_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_47_189 : RowResult ⟨47, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_47_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_47_190 : RowResult ⟨47, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_47_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_191 : RowResult ⟨47, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_47_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_47_192 : RowResult ⟨47, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_47_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_47_193 : RowResult ⟨47, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_47_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
