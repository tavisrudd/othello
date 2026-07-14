import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_31_183 : RowResult ⟨31, by decide⟩ ⟨183, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_31_184 : RowResult ⟨31, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_31_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_31_185 : RowResult ⟨31, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_31_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 2 5 6)

theorem row_31_186 : RowResult ⟨31, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_31_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_31_187 : RowResult ⟨31, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_31_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_31_188 : RowResult ⟨31, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_31_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_31_189 : RowResult ⟨31, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_31_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_31_190 : RowResult ⟨31, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_31_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
