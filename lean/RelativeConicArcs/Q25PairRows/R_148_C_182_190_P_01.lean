import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_148_182 : RowResult ⟨148, by decide⟩ ⟨182, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_148_183 : RowResult ⟨148, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_148_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 1 4 7)

theorem row_148_184 : RowResult ⟨148, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_148_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_148_185 : RowResult ⟨148, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_148_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_148_186 : RowResult ⟨148, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_148_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 2 4 7)

theorem row_148_187 : RowResult ⟨148, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_148_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_148_188 : RowResult ⟨148, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_148_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_148_189 : RowResult ⟨148, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_148_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_148_190 : RowResult ⟨148, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_148_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
