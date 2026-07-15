import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_133_185 : RowResult ⟨133, by decide⟩ ⟨185, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_133_186 : RowResult ⟨133, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_133_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 2 4 6)

theorem row_133_187 : RowResult ⟨133, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_133_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_133_188 : RowResult ⟨133, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_133_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_133_189 : RowResult ⟨133, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_133_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_133_190 : RowResult ⟨133, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_133_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_133_191 : RowResult ⟨133, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_133_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_133_192 : RowResult ⟨133, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_133_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
