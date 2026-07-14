import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_113_183 : RowResult ⟨113, by decide⟩ ⟨183, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_113_184 : RowResult ⟨113, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_113_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_113_185 : RowResult ⟨113, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_113_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_113_186 : RowResult ⟨113, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_113_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_113_187 : RowResult ⟨113, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_113_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_113_188 : RowResult ⟨113, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_113_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 1 4 6)

theorem row_113_189 : RowResult ⟨113, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_113_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 2 4 7)

theorem row_113_190 : RowResult ⟨113, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_113_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
