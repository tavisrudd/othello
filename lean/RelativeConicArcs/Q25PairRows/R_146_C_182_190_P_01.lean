import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_146_182 : RowResult ⟨146, by decide⟩ ⟨182, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_146_183 : RowResult ⟨146, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_146_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 2 5 7)

theorem row_146_184 : RowResult ⟨146, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_146_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_146_185 : RowResult ⟨146, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_146_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_146_186 : RowResult ⟨146, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_146_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_146_187 : RowResult ⟨146, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_146_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 2 5 6)

theorem row_146_188 : RowResult ⟨146, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_146_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_146_189 : RowResult ⟨146, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_146_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_146_190 : RowResult ⟨146, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_146_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
