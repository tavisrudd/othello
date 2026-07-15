import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_117_182 : RowResult ⟨117, by decide⟩ ⟨182, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_117_183 : RowResult ⟨117, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_117_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_117_184 : RowResult ⟨117, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_117_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_117_185 : RowResult ⟨117, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_117_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_117_186 : RowResult ⟨117, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_117_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 2 5 6)

theorem row_117_187 : RowResult ⟨117, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_117_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 1 4 7)

theorem row_117_188 : RowResult ⟨117, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_117_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_117_189 : RowResult ⟨117, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_117_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_117_190 : RowResult ⟨117, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_117_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
