import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_109_183 : RowResult ⟨109, by decide⟩ ⟨183, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_109_184 : RowResult ⟨109, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_109_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 1 4 6)

theorem row_109_185 : RowResult ⟨109, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_109_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 4 5 6)

theorem row_109_186 : RowResult ⟨109, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_109_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 2 5 7)

theorem row_109_187 : RowResult ⟨109, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_109_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_109_188 : RowResult ⟨109, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_109_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_109_189 : RowResult ⟨109, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_109_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_109_190 : RowResult ⟨109, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_109_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_109_191 : RowResult ⟨109, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_109_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 2 4 6)

theorem row_109_192 : RowResult ⟨109, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_109_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_109_193 : RowResult ⟨109, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_109_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 2 5 6)

theorem row_109_194 : RowResult ⟨109, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_109_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_109_195 : RowResult ⟨109, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_109_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
