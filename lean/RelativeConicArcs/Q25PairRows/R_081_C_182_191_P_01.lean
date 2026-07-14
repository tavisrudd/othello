import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_81_182 : RowResult ⟨81, by decide⟩ ⟨182, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 4 5 6)

theorem row_81_183 : RowResult ⟨81, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_81_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_81_184 : RowResult ⟨81, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_81_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_81_185 : RowResult ⟨81, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_81_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_81_186 : RowResult ⟨81, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_81_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_81_187 : RowResult ⟨81, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_81_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 2 5 7)

theorem row_81_188 : RowResult ⟨81, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_81_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_81_189 : RowResult ⟨81, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_81_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_81_190 : RowResult ⟨81, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_81_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_81_191 : RowResult ⟨81, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_81_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
