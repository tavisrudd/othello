import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_144_182 : RowResult ⟨144, by decide⟩ ⟨182, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_144_183 : RowResult ⟨144, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_144_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_144_184 : RowResult ⟨144, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_144_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_144_185 : RowResult ⟨144, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_144_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 2 5 6)

theorem row_144_186 : RowResult ⟨144, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_144_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_144_187 : RowResult ⟨144, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_144_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_144_188 : RowResult ⟨144, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_144_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_144_189 : RowResult ⟨144, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_144_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 1 4 7)

theorem row_144_190 : RowResult ⟨144, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_144_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_144_191 : RowResult ⟨144, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_144_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
