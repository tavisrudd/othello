import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_143_181 : RowResult ⟨143, by decide⟩ ⟨181, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_182 : RowResult ⟨143, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_143_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_143_183 : RowResult ⟨143, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_143_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 2 5 6)

theorem row_143_184 : RowResult ⟨143, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_143_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 4 6)

theorem row_143_185 : RowResult ⟨143, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_143_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 2 5 7)

theorem row_143_186 : RowResult ⟨143, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_143_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_143_187 : RowResult ⟨143, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_143_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_188 : RowResult ⟨143, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_143_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 1 4 7)

theorem row_143_189 : RowResult ⟨143, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_143_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_190 : RowResult ⟨143, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_143_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 2 4 7)

theorem row_143_191 : RowResult ⟨143, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_143_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_143_192 : RowResult ⟨143, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_143_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 4 5 6)

theorem row_143_193 : RowResult ⟨143, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_143_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
