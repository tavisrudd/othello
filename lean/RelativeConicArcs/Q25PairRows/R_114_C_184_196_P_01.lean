import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_114_184 : RowResult ⟨114, by decide⟩ ⟨184, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_114_185 : RowResult ⟨114, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_114_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_114_186 : RowResult ⟨114, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_114_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨235, by decide⟩, by decide⟩

theorem row_114_187 : RowResult ⟨114, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_114_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 2 4 6)

theorem row_114_188 : RowResult ⟨114, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_114_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_114_189 : RowResult ⟨114, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_114_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 1 4 6)

theorem row_114_190 : RowResult ⟨114, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_114_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_114_191 : RowResult ⟨114, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_114_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_114_192 : RowResult ⟨114, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_114_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 2 5 6)

theorem row_114_193 : RowResult ⟨114, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_114_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_114_194 : RowResult ⟨114, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_114_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 1 4 7)

theorem row_114_195 : RowResult ⟨114, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_114_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_114_196 : RowResult ⟨114, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_114_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
