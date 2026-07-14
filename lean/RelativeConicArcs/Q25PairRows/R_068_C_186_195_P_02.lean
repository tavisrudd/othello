import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_68_186 : RowResult ⟨68, by decide⟩ ⟨186, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_68_187 : RowResult ⟨68, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_68_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 2 4 7)

theorem row_68_188 : RowResult ⟨68, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_68_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 1 4 7)

theorem row_68_189 : RowResult ⟨68, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_68_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_68_190 : RowResult ⟨68, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_68_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_68_191 : RowResult ⟨68, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_68_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_68_192 : RowResult ⟨68, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_68_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_68_193 : RowResult ⟨68, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_68_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 1 4 6)

theorem row_68_194 : RowResult ⟨68, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_68_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_68_195 : RowResult ⟨68, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_68_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
