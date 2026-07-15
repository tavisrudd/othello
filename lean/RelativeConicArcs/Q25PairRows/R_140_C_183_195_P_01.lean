import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_140_183 : RowResult ⟨140, by decide⟩ ⟨183, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_140_184 : RowResult ⟨140, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_140_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_140_185 : RowResult ⟨140, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_140_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 1 4 7)

theorem row_140_186 : RowResult ⟨140, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_140_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_140_187 : RowResult ⟨140, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_140_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 2 4 7)

theorem row_140_188 : RowResult ⟨140, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_140_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_140_189 : RowResult ⟨140, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_140_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_140_190 : RowResult ⟨140, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_140_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 1 4 6)

theorem row_140_191 : RowResult ⟨140, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_140_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_140_192 : RowResult ⟨140, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_140_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 2 5 6)

theorem row_140_193 : RowResult ⟨140, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_140_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_140_194 : RowResult ⟨140, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_140_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 4 5 6)

theorem row_140_195 : RowResult ⟨140, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_140_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
