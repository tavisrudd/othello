import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_65_183 : RowResult ⟨65, by decide⟩ ⟨183, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_65_184 : RowResult ⟨65, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_65_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_65_185 : RowResult ⟨65, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_65_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 1 4 7)

theorem row_65_186 : RowResult ⟨65, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_65_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_65_187 : RowResult ⟨65, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_65_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 2 5 7)

theorem row_65_188 : RowResult ⟨65, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_65_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_65_189 : RowResult ⟨65, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_65_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 2 4 6)

theorem row_65_190 : RowResult ⟨65, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_65_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 1 4 6)

theorem row_65_191 : RowResult ⟨65, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_65_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_65_192 : RowResult ⟨65, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_65_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_65_193 : RowResult ⟨65, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_65_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 2 4 7)

theorem row_65_194 : RowResult ⟨65, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_65_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_65_195 : RowResult ⟨65, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_65_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
