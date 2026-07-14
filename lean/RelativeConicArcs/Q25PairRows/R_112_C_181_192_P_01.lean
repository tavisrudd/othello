import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_112_181 : RowResult ⟨112, by decide⟩ ⟨181, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_112_182 : RowResult ⟨112, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_112_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_112_183 : RowResult ⟨112, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_112_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 2 5 7)

theorem row_112_184 : RowResult ⟨112, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_112_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 4 6)

theorem row_112_185 : RowResult ⟨112, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_112_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_112_186 : RowResult ⟨112, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_112_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_112_187 : RowResult ⟨112, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_112_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 1 4 6)

theorem row_112_188 : RowResult ⟨112, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_112_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_112_189 : RowResult ⟨112, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_112_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_112_190 : RowResult ⟨112, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_112_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 2 4 7)

theorem row_112_191 : RowResult ⟨112, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_112_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_112_192 : RowResult ⟨112, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_112_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
