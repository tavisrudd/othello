import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_61_184 : RowResult ⟨61, by decide⟩ ⟨184, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_61_185 : RowResult ⟨61, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_61_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_61_186 : RowResult ⟨61, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_61_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 1 4 6)

theorem row_61_187 : RowResult ⟨61, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_61_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_61_188 : RowResult ⟨61, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_61_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_61_189 : RowResult ⟨61, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_61_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_61_190 : RowResult ⟨61, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_61_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 2 5 6)

theorem row_61_191 : RowResult ⟨61, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_61_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 1 4 7)

theorem row_61_192 : RowResult ⟨61, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_61_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_61_193 : RowResult ⟨61, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_61_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
