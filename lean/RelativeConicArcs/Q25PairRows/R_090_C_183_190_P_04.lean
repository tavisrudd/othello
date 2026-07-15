import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_90_183 : RowResult ⟨90, by decide⟩ ⟨183, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_90_184 : RowResult ⟨90, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_90_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_90_185 : RowResult ⟨90, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_90_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 1 4 7)

theorem row_90_186 : RowResult ⟨90, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_90_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_90_187 : RowResult ⟨90, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_90_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_90_188 : RowResult ⟨90, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_90_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_90_189 : RowResult ⟨90, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_90_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 2 4 7)

theorem row_90_190 : RowResult ⟨90, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_90_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
