import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_131_183 : RowResult ⟨131, by decide⟩ ⟨183, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_131_184 : RowResult ⟨131, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_131_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 4 5 6)

theorem row_131_185 : RowResult ⟨131, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_131_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_131_186 : RowResult ⟨131, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_131_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 2 5 7)

theorem row_131_187 : RowResult ⟨131, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_131_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_131_188 : RowResult ⟨131, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_131_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_131_189 : RowResult ⟨131, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_131_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_131_190 : RowResult ⟨131, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_131_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_131_191 : RowResult ⟨131, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_131_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_131_192 : RowResult ⟨131, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_131_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 2 4 6)

theorem row_131_193 : RowResult ⟨131, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_131_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
