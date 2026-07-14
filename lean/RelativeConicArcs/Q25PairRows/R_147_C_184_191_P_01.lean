import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_147_184 : RowResult ⟨147, by decide⟩ ⟨184, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_147_185 : RowResult ⟨147, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_147_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_147_186 : RowResult ⟨147, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_147_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_147_187 : RowResult ⟨147, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_147_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_147_188 : RowResult ⟨147, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_147_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_147_189 : RowResult ⟨147, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_147_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_147_190 : RowResult ⟨147, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_147_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_147_191 : RowResult ⟨147, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_147_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
