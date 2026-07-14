import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_41_185 : RowResult ⟨41, by decide⟩ ⟨185, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_41_186 : RowResult ⟨41, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_41_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 1 4 7)

theorem row_41_187 : RowResult ⟨41, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_41_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 2 4 6)

theorem row_41_188 : RowResult ⟨41, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_41_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_41_189 : RowResult ⟨41, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_41_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_41_190 : RowResult ⟨41, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_41_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_41_191 : RowResult ⟨41, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_41_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 1 4 6)

theorem row_41_192 : RowResult ⟨41, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_41_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_41_193 : RowResult ⟨41, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_41_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 4 5 6)

theorem row_41_194 : RowResult ⟨41, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_41_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_41_195 : RowResult ⟨41, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_41_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_41_196 : RowResult ⟨41, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_41_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
