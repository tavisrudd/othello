import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_49_182 : RowResult ⟨49, by decide⟩ ⟨182, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_183 : RowResult ⟨49, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_49_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_49_184 : RowResult ⟨49, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_49_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 1 4 7)

theorem row_49_185 : RowResult ⟨49, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_49_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_49_186 : RowResult ⟨49, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_49_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_187 : RowResult ⟨49, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_49_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 2 4 7)

theorem row_49_188 : RowResult ⟨49, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_49_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_49_189 : RowResult ⟨49, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_49_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_190 : RowResult ⟨49, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_49_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
