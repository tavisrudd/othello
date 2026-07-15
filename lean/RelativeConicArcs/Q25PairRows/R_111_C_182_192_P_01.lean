import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_111_182 : RowResult ⟨111, by decide⟩ ⟨182, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_111_183 : RowResult ⟨111, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_111_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_111_184 : RowResult ⟨111, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_111_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 5 7)

theorem row_111_185 : RowResult ⟨111, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_111_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_111_186 : RowResult ⟨111, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_111_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 1 4 6)

theorem row_111_187 : RowResult ⟨111, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_111_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_111_188 : RowResult ⟨111, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_111_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_111_189 : RowResult ⟨111, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_111_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_111_190 : RowResult ⟨111, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_111_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 2 4 6)

theorem row_111_191 : RowResult ⟨111, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_111_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 1 4 7)

theorem row_111_192 : RowResult ⟨111, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_111_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
