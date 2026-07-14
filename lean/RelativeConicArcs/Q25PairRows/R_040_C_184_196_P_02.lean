import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_40_184 : RowResult ⟨40, by decide⟩ ⟨184, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_40_185 : RowResult ⟨40, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_40_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 1 4 7)

theorem row_40_186 : RowResult ⟨40, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_40_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_40_187 : RowResult ⟨40, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_40_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_40_188 : RowResult ⟨40, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_40_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_40_189 : RowResult ⟨40, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_40_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_40_190 : RowResult ⟨40, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_40_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 1 4 6)

theorem row_40_191 : RowResult ⟨40, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_40_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 2 4 6)

theorem row_40_192 : RowResult ⟨40, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_40_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 4 5 6)

theorem row_40_193 : RowResult ⟨40, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_40_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_40_194 : RowResult ⟨40, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_40_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 2 5 7)

theorem row_40_195 : RowResult ⟨40, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_40_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_40_196 : RowResult ⟨40, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_40_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
