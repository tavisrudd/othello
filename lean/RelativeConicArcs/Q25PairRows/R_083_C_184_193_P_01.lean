import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_83_184 : RowResult ⟨83, by decide⟩ ⟨184, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 4 5 6)

theorem row_83_185 : RowResult ⟨83, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_83_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_83_186 : RowResult ⟨83, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_83_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_83_187 : RowResult ⟨83, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_83_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 2 4 6)

theorem row_83_188 : RowResult ⟨83, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_83_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_83_189 : RowResult ⟨83, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_83_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_83_190 : RowResult ⟨83, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_83_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_83_191 : RowResult ⟨83, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_83_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_83_192 : RowResult ⟨83, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_83_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 2 5 7)

theorem row_83_193 : RowResult ⟨83, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_83_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
