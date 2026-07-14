import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_118_184 : RowResult ⟨118, by decide⟩ ⟨184, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_118_185 : RowResult ⟨118, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_118_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_118_186 : RowResult ⟨118, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_118_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_118_187 : RowResult ⟨118, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_118_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_118_188 : RowResult ⟨118, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_118_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 1 4 7)

theorem row_118_189 : RowResult ⟨118, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_118_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_118_190 : RowResult ⟨118, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_118_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_118_191 : RowResult ⟨118, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_118_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
