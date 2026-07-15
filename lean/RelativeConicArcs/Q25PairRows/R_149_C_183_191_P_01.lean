import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_149_183 : RowResult ⟨149, by decide⟩ ⟨183, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_149_184 : RowResult ⟨149, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_149_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 1 4 7)

theorem row_149_185 : RowResult ⟨149, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_149_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_149_186 : RowResult ⟨149, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_149_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_149_187 : RowResult ⟨149, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_149_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 2 5 7)

theorem row_149_188 : RowResult ⟨149, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_149_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_149_189 : RowResult ⟨149, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_149_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_149_190 : RowResult ⟨149, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_149_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_149_191 : RowResult ⟨149, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_149_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
