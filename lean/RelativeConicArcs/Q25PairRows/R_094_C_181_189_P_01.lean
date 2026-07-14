import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_94_181 : RowResult ⟨94, by decide⟩ ⟨181, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_94_182 : RowResult ⟨94, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_94_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_94_183 : RowResult ⟨94, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_94_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_94_184 : RowResult ⟨94, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_94_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 5 7)

theorem row_94_185 : RowResult ⟨94, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_94_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_94_186 : RowResult ⟨94, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_94_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_94_187 : RowResult ⟨94, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_94_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_94_188 : RowResult ⟨94, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_94_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_94_189 : RowResult ⟨94, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_94_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
