import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_42_182 : RowResult ⟨42, by decide⟩ ⟨182, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_183 : RowResult ⟨42, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_42_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 2 4 6)

theorem row_42_184 : RowResult ⟨42, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_42_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_42_185 : RowResult ⟨42, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_42_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 2 4 7)

theorem row_42_186 : RowResult ⟨42, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_42_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_187 : RowResult ⟨42, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_42_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 1 4 7)

theorem row_42_188 : RowResult ⟨42, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_42_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_42_189 : RowResult ⟨42, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_42_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_42_190 : RowResult ⟨42, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_42_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 2 5 6)

theorem row_42_191 : RowResult ⟨42, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_42_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_42_192 : RowResult ⟨42, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_42_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 1 4 6)

theorem row_42_193 : RowResult ⟨42, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_42_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_42_194 : RowResult ⟨42, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_42_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 4 5 6)

theorem row_42_195 : RowResult ⟨42, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_42_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_42_196 : RowResult ⟨42, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_42_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
