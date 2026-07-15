import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_116_183 : RowResult ⟨116, by decide⟩ ⟨183, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_116_184 : RowResult ⟨116, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_116_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 4 5 6)

theorem row_116_185 : RowResult ⟨116, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_116_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_116_186 : RowResult ⟨116, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_116_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 1 4 7)

theorem row_116_187 : RowResult ⟨116, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_116_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_116_188 : RowResult ⟨116, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_116_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_116_189 : RowResult ⟨116, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_116_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_116_190 : RowResult ⟨116, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_116_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_116_191 : RowResult ⟨116, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_116_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 1 4 6)

theorem row_116_192 : RowResult ⟨116, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_116_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
