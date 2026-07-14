import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_110_181 : RowResult ⟨110, by decide⟩ ⟨181, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_110_182 : RowResult ⟨110, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_110_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 2 5 6)

theorem row_110_183 : RowResult ⟨110, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_110_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_110_184 : RowResult ⟨110, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_110_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_110_185 : RowResult ⟨110, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_110_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 1 4 6)

theorem row_110_186 : RowResult ⟨110, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_110_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_110_187 : RowResult ⟨110, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_110_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_110_188 : RowResult ⟨110, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_110_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_110_189 : RowResult ⟨110, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_110_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_110_190 : RowResult ⟨110, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_110_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
