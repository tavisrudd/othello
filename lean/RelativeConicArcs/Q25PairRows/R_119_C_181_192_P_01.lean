import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_119_181 : RowResult ⟨119, by decide⟩ ⟨181, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_119_182 : RowResult ⟨119, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_119_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 4 5 6)

theorem row_119_183 : RowResult ⟨119, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_119_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 2 4 6)

theorem row_119_184 : RowResult ⟨119, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_119_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_119_185 : RowResult ⟨119, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_119_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 2 4 7)

theorem row_119_186 : RowResult ⟨119, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_119_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_119_187 : RowResult ⟨119, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_119_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_119_188 : RowResult ⟨119, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_119_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_119_189 : RowResult ⟨119, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_119_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 1 4 7)

theorem row_119_190 : RowResult ⟨119, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_119_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_119_191 : RowResult ⟨119, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_119_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 2 5 6)

theorem row_119_192 : RowResult ⟨119, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_119_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
