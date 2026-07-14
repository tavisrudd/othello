import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_123_181 : RowResult ⟨123, by decide⟩ ⟨181, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_123_182 : RowResult ⟨123, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_123_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_123_183 : RowResult ⟨123, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_123_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 1 4 7)

theorem row_123_184 : RowResult ⟨123, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_123_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_123_185 : RowResult ⟨123, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_123_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 2 4 6)

theorem row_123_186 : RowResult ⟨123, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_123_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_123_187 : RowResult ⟨123, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_123_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_123_188 : RowResult ⟨123, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_123_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_123_189 : RowResult ⟨123, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_123_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
